#!/usr/bin/env python3
"""
s3_ledger_recon_margin_sweep.py

FULL-THROTTLE DOOR TEST -- engine-free single-zero margin
reconstruction, anchored on the certified ledger itself.

WHY THIS EXISTS
  The closed-form half of the W2 defect (dev = min_d |R_closed-1|)
  is structurally trivial at straddle points:  R_closed ~ O(1/g)
  ~ 3e-10 (the straddle window is empty of zeros by
  construction),  so dev ~ 1 exactly (Bdev ~ 5e-32 in the
  ledger).  The entire t-dependence of the margin
      mnew = |z(1/2+it)| * dev / (pb + residf)
  therefore lives in  zabs = |zeta|  and
      residf = |zeta - Kfull|,
  the residual of the exact identity
      zeta = exp(logmain + la + i ar + re_tail + i im_tail) *
             exp(Qrem + Qext)
  (functional-equation main term x zero products x quadrature
  tail;  day037 protocol).

  The engine re-streams the 1e11-zero tail per point (minutes
  each).  This script reconstructs Kfull at any grid t from the
  LEDGER'S OWN recorded parts  (re, im, la, ar per row)  plus
  three cheap exact corrections,  with NO engine and NO tail
  stream:
    re(t)  = re(t_s) + sum_{|g-t|<1} [k_g(t) - k_g(t_s)]
             (near-zero log-kernel window;  far drift < 1e-8)
    im(t)  = im(t_s) + pi * (nlt(t) - nlt(t_s)) + sum (t-t_s)/(g^2+1/4)
             (exact sawtooth + exact smooth-im window;  far
              drift < 2e-7)
    la/ar  BIT-EXACT re-evaluation of the engine's own
             _prod_budget_day034 (M.GN,  1e7 zeros,  f64)
             (no interpolation)
  plus  lm (closed form),  Qrem/Qext (closed-form 120-node
  quadrature,  per point,  dps-30),  zeta (mpmath dps-30).

GATES (before any grid row is trusted)
  At the ledger rows inside the three anchor windows:
    |mnew_recon(t_s) - mnew_ledger(t_s)|  <  1e-5
  (recon at t_s uses the row's own recorded parts exactly;
   1e-5 = 10x the 7.6e-6 f64 ulp of the stored im ~ 3.3e10)

OUTPUT
  tmp/s3_ledger_recon_margin_sweep.jsonl  (per grid point)
  tmp/s3_ledger_recon_margin_sweep_summary.md

Door rules (docs/SOLUTION-SHAPE.md):
  margin flat at 0.025 (|dm| <= ~1e-4) while S moves ~0.25/step
    -> Door A:  structural flatness,  theorem target.
  margin rough at zero scale (|dm| ~ 0.1+,  peaks aligned with
    S crossings)  -> Door B:  re-scope to the sub-RH theorem.
"""
import json
import math
import os
import time

import numpy as np
from mpmath import mp

import day023_p11c_1e7 as M

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
LEDGER = os.path.join(HERE, "out_day052c_696", "points.jsonl")
D_FILE = os.path.join(HERE, "hi3e10", "zeros_2999e6_to_30000e6.f64")
OUT = os.path.join(ROOT, "tmp", "s3_ledger_recon_margin_sweep.jsonl")
SUMMARY = os.path.join(ROOT, "tmp",
                       "s3_ledger_recon_margin_sweep_summary.md")

STEP = 0.025
N_J = 60
REMHI = "1e18"
REMHI2 = "1e30"
G_LAST = None  # filled from the D file (last zero)
NLT_GUARD = 1.0e-1

# ================= engine-verbatim pieces =================

def logmain25212(s):
    return (s * mp.log(2 * mp.pi) - (1 + mp.euler / 2) * s - mp.log(2)
            - mp.log(s - 1) - mp.loggamma(s / 2 + 1))


def _kint(smp):
    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp / r1) + mp.log(1 - smp / r2)
             + smp / r1 + smp / r2)
        return p * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))
    return f


def quad_section(f, lo, hi, npts, dps):
    mp.dps = dps
    l = mp.mpf(lo)
    h = mp.mpf(hi)
    pts = [l * (h / l) ** (mp.mpf(j) / mp.mpf(npts))
           for j in range(npts + 1)]
    return mp.quad(f, pts)


def p8_B(t, n):
    s = math.hypot(0.5, t)
    a = complex(0.5, t)
    t3 = abs(a * (a + 1) * (a + 2))
    return (0.5 * n**-0.5
            + (s / 12.0) * n**-1.5
            + (math.sqrt(3) / 540.0) * t3 * n**-2.5)


def n4(t):
    return int(math.ceil(31000000.0 * t ** 4))


def R_closed(g, t, d):
    g = mp.mpf(g); t = mp.mpf(t); d = mp.mpf(d)
    s = mp.mpc(0.5, t)
    w = ((1 + 2*d)/((0.5 + d)**2 + g**2)
         + (1 - 2*d)/((0.5 - d)**2 + g**2) - 1/(0.25 + g**2))
    num = (0.25 + g**2)*((g - t)**2 + d**2)*((g + t)**2 + d**2)
    den = (g**2 - t**2)*((0.5 + d)**2 + g**2)*((0.5 - d)**2 + g**2)
    return num/den * mp.e**(s * w)


DG = [mp.mpf(k) / 1000 for k in range(5, 501)]

# ================= ledger + D file =================

def load_ledger():
    xs = {}
    for line in open(LEDGER):
        r = json.loads(line)
        xs.setdefault(r["x"], []).append(r)
    for x in xs:
        xs[x].sort(key=lambda r: r["t"])
    return xs


def zero_window(g, half=3.0):
    """the D-file zeros in [g-half, g+half] (memmap, read-only,
    file-local binary search)."""
    mm = np.memmap(D_FILE, dtype=np.float64, mode="r")
    idx = int(np.searchsorted(mm, g, side="left"))
    lo = max(idx - 60, 0)
    hi = idx + 61
    vals = mm[lo:hi].tolist()
    dels = 61 - len(vals)
    return [v for v in vals if g - half <= v <= g + half]

# ================= reconstruction =================

def recon_parts(g, tf, zeros, la_ar_lut):
    """Kfull parts at grid t from the anchor baseline row t_s +
    corrections.  Returns dict of parts (mp types,  dps set by
    caller)."""
    # find the ledger baseline row t_s = nearest ledger t (the
    # caller passes it as the window row for tf)
    # la/ar interpolation from the lut (sorted t -> (la, ar))
    la, ar = la_ar_lut.tf(tf)
    return la, ar


class LaArLUT:
    """Bit-exact copy of day037._prod_budget_day034 (M.GN, f64).
       Returns (la, ar) at any t  --  no interpolation."""

    @staticmethod
    def tf(tf):
        gv = M.GN
        A = tf * tf + 0.25
        Bv = 1.0 / (0.25 + gv * gv)
        inner = 1.0 - A * Bv
        la = float(np.sum(0.5 * Bv + np.log(np.abs(inner))))
        ar = float(tf * float(np.sum(Bv)) - math.pi * float(np.sum(gv < tf)))
        return la, ar


def re_im_at(g, t_s, re_s, im_s, tf, zeros):
    """re(t), im(t) from baseline (t_s, re_s, im_s):
       re:  near-window log-kernel difference (window 1.5
            around t and around t_s;  far drift < 1e-8);
       im:  exact sawtooth  pi * (nlt(t) - nlt(t_s))  plus the
            exact smooth-im window  (t-t_s)/(g^2+1/4);
            the far-window smooth part  (tf-t_s)*sum_far
            < 8e-7  (documented,  negligible)."""
    # near window: zeros within 1.5 of t or t_s
    win = [vv for vv in zeros
           if abs(vv - tf) < 1.5 or abs(vv - t_s) < 1.5]
    d = 0.0
    dim = 0.0
    cnt = 0
    for vv in win:
        u1 = vv * vv - tf * tf
        u0 = vv * vv - t_s * t_s
        if u1 == 0.0:
            log1 = -1e300   # t exactly at a zero:  kernel log -> -inf
        else:
            log1 = math.log(abs(u1) / (vv * vv + 0.25))
        if u0 == 0.0:
            log0 = -1e300
        else:
            log0 = math.log(abs(u0) / (vv * vv + 0.25))
        d += log1 - log0
        if t_s < vv <= tf:
            cnt += 1
        elif tf < vv <= t_s:
            cnt -= 1
        dim += (tf - t_s) / (vv * vv + 0.25)
    return re_s + d, im_s + math.pi * cnt + dim


def mnew_at(g, tf, re, im, la, ar, qrem, qext, dps=30):
    mp.dps = dps
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    lm = logmain25212(s)
    z = mp.zeta(s)
    K = mp.e ** (lm + mp.mpf(repr(la)) + 1j * mp.mpf(repr(ar))
                 + mp.mpf(repr(re)) + 1j * mp.mpf(repr(im)))
    K = K * mp.e ** qrem
    K = K * mp.e ** qext
    zabs = float(abs(z))
    residf = float(abs(z - K))
    pb = float(p8_B(tf, n4(tf)))
    # dev (the closed-form defect;  ~1 at straddles)
    g_mp = mp.mpf(repr(g))
    t_mp = mp.mpf(repr(tf))
    best = None
    for dd in DG:
        v = abs(R_closed(g_mp, t_mp, dd) - 1)
        if best is None or v < best:
            best = v
    dev = float(best)
    mnew = zabs * dev / (pb + residf)
    return dict(t=tf, mnew=mnew, zabs=zabs, residf=residf,
                dev=dev, pb=pb, Kabs=float(abs(K)),
                S=float(mp.arg(z)) / math.pi,
                re=f"{re!r}", im=f"{im!r}", la=la, ar=ar,
                qrem=float(mp.re(qrem)), qext=float(mp.re(qext)))


def quad_both(tf, dps):
    mp.dps = dps
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    f = _kint(s)
    lo = repr(G_LAST)
    rem = quad_section(f, lo, REMHI, 120, dps)
    ext = quad_section(f, REMHI, REMHI2, 120, dps)
    return rem, ext


def stats(deltas):
    ad = sorted(abs(d) for d in deltas if d is not None and
                not (isinstance(d, float) and d != d))
    if not ad:
        return None
    n = len(ad)
    return dict(n=n, median=ad[n // 2], mean=sum(ad) / n,
                p99=ad[min(n - 1, int(0.99 * (n - 1)))], max=ad[-1])


def main():
    global G_LAST
    mm = np.memmap(D_FILE, dtype=np.float64, mode="r")
    G_LAST = float(mm[-1])
    del mm
    print("G_LAST = %.6e" % G_LAST, flush=True)

    rows_out = []
    summ = ["# s3 ledger-reconstruction single-zero margin sweep", ""]
    gate_ok = True
    max_cc = 0.0

    xs = load_ledger()
    cand = sorted(xs.keys())
    full = [x for x in cand
            if sum(1 for r in xs[x]
                   if abs(r["t"] - r["g"]) <= 1.5 + 1e-9) >= 6]
    anchors = [full[0], min(full, key=lambda x: abs(x - 1e10)), full[-1]]
    summ.append("anchors (narrow-window >= 6 ledger rows): "
                + ",  ".join("%.4e" % a for a in anchors))
    print(summ[-1], flush=True)

    for x in anchors:
        win_rows = [r for r in xs[x] if abs(r["t"] - r["g"]) <= 1.5 + 1e-9]
        g = win_rows[0]["g"]
        zeros = zero_window(g, half=3.0)
        rowmap = {round(r["t"], 9): r for r in win_rows}

        # -------- GATE: reproduce the ledger rows --------
        t0 = time.time()
        cc = []
        for r in win_rows:
            tfs = float(r["t"])
            re_s = float(r["p"]["re"]); im_s = float(r["p"]["im"])
            la, ar = LaArLUT.tf(tfs)
            qrem, qext = quad_both(tfs, 30)
            m = mnew_at(g, tfs, re_s, im_s, la, ar, qrem, qext, dps=30)
            d = abs(m["mnew"] - float(r["p"]["mnew"]))
            max_cc = max(max_cc, d)
            cc.append((tfs, float(r["p"]["mnew"]), m["mnew"], d))
        ok = all(d < 1e-5 for *_, d in cc)
        gate_ok = gate_ok and ok
        summ.append("anchor x=%.6e: GATE over %d ledger rows: %s "
                    "(max |dmnew| = %.3e, %.1fs)"
                    % (x, len(cc), "PASS" if ok else "FAIL",
                       max_cc, time.time() - t0))
        print(summ[-1], flush=True)
        for (tfs, ml, mr, d) in cc:
            rows_out.append(dict(x=x, g=g, t=tfs, role="gate",
                                 mnew_recon=mr, mnew_ledger=ml,
                                 d=d))
        if not ok:
            summ.append("  GATE FAIL -- grid discarded for this anchor.")
            continue

        # -------- GRID: 0.025 step,  midpoints (never t == g) --------
        grid = [g + STEP * (j + 0.5) for j in range(-N_J, N_J)]
        base = min(win_rows, key=lambda r: abs(r["t"] - g))
        t_s = float(base["t"]); re_s = float(base["p"]["re"])
        im_s = float(base["p"]["im"])
        t0 = time.time()
        ms = []
        for tf in grid:
            re, im = re_im_at(g, t_s, re_s, im_s, tf, zeros)
            la, ar = LaArLUT.tf(tf)
            qrem, qext = quad_both(tf, 30)
            m = mnew_at(g, tf, re, im, la, ar, qrem, qext, dps=30)
            ms.append(m)
        dt = time.time() - t0
        for m in ms:
            m.update(x=x, g=g, role="grid")
            rows_out.append(m)

        mvals = [m["mnew"] for m in ms]
        Svals = [m["S"] for m in ms]
        dvs = [m["dev"] for m in ms]
        rs = [m["residf"] for m in ms]
        zs = [m["zabs"] for m in ms]
        dS = []
        for a, b in zip(Svals, Svals[1:]):
            dd = b - a
            dS.append((dd + math.pi) % (2 * math.pi) - math.pi)
        dm = [b - a for a, b in zip(mvals, mvals[1:])]
        dres = [b - a for a, b in zip(rs, rs[1:])]
        dz = [b - a for a, b in zip(zs, zs[1:])]
        ddv = [b - a for a, b in zip(dvs, dvs[1:])]

        def fmt(s):
            return ("median=%.3e mean=%.3e p99=%.3e max=%.3e"
                    % (s["median"], s["mean"], s["p99"], s["max"])
                    if s else "n/a")
        summ.append("")
        summ.append("## x = %.6e   grid %d pts in %.1f s"
                    % (x, len(grid), dt))
        print("anchor x=%.6e grid done in %.1f s" % (x, dt), flush=True)
        summ.append("- |dmnew| per 0.025 step:  %s" % fmt(stats(dm)))
        summ.append("- |dresidf| per step:       %s" % fmt(stats(dres)))
        summ.append("- |dzabs| per step:         %s" % fmt(stats(dz)))
        summ.append("- |ddev| per step:          %s" % fmt(stats(ddv)))
        summ.append("- |dS| per step (local):    %s" % fmt(stats(dS)))
        cross = [j for j, v in enumerate(dS) if abs(v) > 0.5]
        med = stats(dm)
        big = [j for j, v in enumerate(dm) if abs(v) > 10 * med["median"]]
        ov = [j for j in big if any(abs(j - c) <= 1 for c in cross)]
        summ.append("- S-crossing steps (|dS|>0.5): %d;  big margin steps "
                    "(>10x median): %d;  aligned within 1: %d"
                    % (len(cross), len(big), len(ov)))

    summ.insert(2, "")
    summ.insert(3, "RECONSTRUCTION GATE vs certified ledger:  "
                   + ("PASS (max |dmnew| = %.3e < 1e-5)" % max_cc
                      if gate_ok else "FAIL (max |dmnew| = %.3e)"
                      % max_cc))
    summ.append("")
    summ.append("DECISION RULES (docs/SOLUTION-SHAPE.md):")
    summ.append("- |dmnew| median/p99 <= ~1e-4 at the 0.025 step while |dS| ~ 0.25:  "
                "structural flatness (Door A alive).")
    summ.append("- |dmnew| rough (>= ~1e-2) and/or big steps aligned with S crossings: "
                "margin tracks zero-scale structure (Door B).")

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as fo:
        for r in rows_out:
            fo.write(json.dumps(r) + "\n")
    with open(SUMMARY, "w") as fo:
        fo.write("\n".join(summ) + "\n")
    print("\n".join(summ))
    print("rows:", len(rows_out), "->", OUT)


if __name__ == "__main__":
    main()
