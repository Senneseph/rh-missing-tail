#!/usr/bin/env python3
"""
s2_closedform_dev_sweep.py

Full-throttle door test -- closed-form half of the single-zero
margin question.

The W2-identity residual dev(g, t) = min_d |R_closed(g,t,d) - 1|
is ELEMENTARY CLOSED FORM (day023 R_closed, d-band DG = 0.005..0.5
step 0.001): no zeros, no tail stream, no quadrature.  This script
sweeps dev (and zabs = |zeta|, the structural product zabs*dev) at
the single-zero t-step 0.025 around three ledger anchors -- the
same grid the engine-side day056 sweep runs -- and answers:

  * is the CLOSED-FORM residual flat or rough at zero resolution?
  * cross-check against the certified ledger (dev and mnew via the
    ledger's own residf/pb) at 6 rows per anchor, gate 1e-9.

Interpretation (docs/SOLUTION-SHAPE.md door question):
  - dev flat at 0.025 (<= ~1e-4) while S moves ~0.25/step:
    the wire combination is structurally (algebraically) flat at
    the zeros -> Door A alive, and the flatness is a theorem
    target about an explicit elementary function (Lean-able).
  - dev rough at S-scale at 0.025: the 505-level flatness was at
    the ratio level (zabs*dev/(pb+residf)) or at the 0.5-step
    level only; the margin inherits the S roughness -> Door B
    (re-scope to the sub-RH theorem).

Read-only.  No engine import;  R_closed / p8_B / n4 copied
verbatim from the engine modules.
"""
import json
import math
import os
import time

import mpmath as mp

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
LEDGER = os.path.join(HERE, "out_day052c_696", "points.jsonl")
OUT = os.path.join(ROOT, "tmp", "s2_closedform_dev_sweep.jsonl")
SUMMARY = os.path.join(ROOT, "tmp", "s2_closedform_dev_sweep_summary.md")

STEP = 0.025
N_J = 60
DPS_DEV = 30
DPS_ZETA = 30

# ---------------- verbatim engine pieces ----------------

def R_closed(g, t, d):
    g = mp.mpf(g); t = mp.mpf(t); d = mp.mpf(d)
    s = mp.mpc(0.5, t)
    w = ((1 + 2*d)/((0.5 + d)**2 + g**2)
         + (1 - 2*d)/((0.5 - d)**2 + g**2) - 1/(0.25 + g**2))
    num = (0.25 + g**2)*((g - t)**2 + d**2)*((g + t)**2 + d**2)
    den = (g**2 - t**2)*((0.5 + d)**2 + g**2)*((0.5 - d)**2 + g**2)
    return num/den * mp.e**(s * w)


def p8_B(t, n):
    s = math.hypot(0.5, t)
    a = complex(0.5, t)
    t3 = abs(a * (a + 1) * (a + 2))
    return (0.5 * n**-0.5
            + (s / 12.0) * n**-1.5
            + (math.sqrt(3) / 540.0) * t3 * n**-2.5)


def n4(t):
    # day037 n4 (the tail-start index);  copied verbatim.
    import math as _m
    return int(_m.floor(t * (0.25) + 0.5)) + 2


DG = [mp.mpf(k) / 1000 for k in range(5, 501)]


# ---------------- sweep ----------------

def dev_at(g, tf):
    """min_d |R_closed(g, tf, d) - 1| at DPS_DEV."""
    mp.dps = DPS_DEV
    g_mp = mp.mpf(repr(g))
    t_mp = mp.mpf(repr(tf))
    best = None
    for d in DG:
        v = abs(R_closed(g_mp, t_mp, d) - 1)
        if best is None or v < best:
            best = v
    return float(best)


def zeta_line(tf):
    """(|zeta|, arg/pi) at 1/2 + it, DPS_ZETA."""
    mp.dps = DPS_ZETA
    z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(tf))))
    return float(abs(z)), float(mp.arg(z)) / math.pi


def unwrap_steps(Svals):
    d = 0.0
    out = [None]
    for a, b in zip(Svals, Svals[1:]):
        dd = b - a
        dd = (dd + math.pi) % (2 * math.pi) - math.pi
        d += dd
        out.append(dd)
    return out


def load_ledger():
    xs = {}
    with open(LEDGER) as fo:
        for line in fo:
            r = json.loads(line)
            xs.setdefault(r["x"], []).append(r)
    return xs


def stats(deltas):
    ad = sorted(abs(d) for d in deltas if d is not None)
    if not ad:
        return None
    n = len(ad)
    return dict(n=n, median=ad[n // 2], mean=sum(ad) / n,
                p99=ad[min(n - 1, int(0.99 * (n - 1)))], max=ad[-1])


def main():
    xs = load_ledger()
    # the three day056 anchors:  band head, mid (~1e10), top.
    cand = sorted(xs.keys())
    xs_list = [cand[0], min(cand, key=lambda x: abs(x - 1e10)), cand[-1]]

    out_rows = []
    summary = ["# s2 closed-form dev sweep (0.025 step, one zero per step)", ""]

    cc_ok = True
    for x in xs_list:
        rows = xs[x]
        g = rows[0]["g"]
        grid = [g + STEP * j for j in range(-N_J, N_J + 1)]

        # cross-check rows (6 ledger rows nearest to g)
        cc = sorted(rows, key=lambda r: abs(r["t"] - g))[:6]
        for r in cc:
            tf = float(r["t"])
            dev_cc = dev_at(g, tf)
            zabs_cc, _ = zeta_line(tf)
            p = r["p"]
            pb_cc = float(p8_B(tf, n4(tf)))
            mnew_cc = zabs_cc * dev_cc / (pb_cc + float(p["residf"]))
            ddev = abs(dev_cc - float(p["dev"]))
            dmnew = abs(mnew_cc - float(p["mnew"]))
            ok = (ddev < 1e-9) and (dmnew < 1e-9)
            cc_ok = cc_ok and ok
            summary.append(
                "- CC x=%.6e t=%.6f: dev |d|=%.3e (%s)  "
                "mnew |d|=%.3e (%s)" % (
                    x, tf, ddev, "PASS" if ddev < 1e-9 else "FAIL",
                    dmnew, "PASS" if dmnew < 1e-9 else "FAIL"))
            out_rows.append(dict(x=x, g=g, t=tf, role="xcheck",
                                 dev=dev_cc, zabs=zabs_cc,
                                 dev_ledger=float(p["dev"]),
                                 mnew_ledger=float(p["mnew"]),
                                 mnew_fast=mnew_cc))

        # grid
        t0 = time.time()
        devs, zabses, Svals = [], [], []
        for tf in grid:
            dev = dev_at(g, tf)
            zabs, Sv = zeta_line(tf)
            devs.append(dev); zabses.append(zabs); Svals.append(Sv)
        dS = unwrap_steps(Svals)
        dt = time.time() - t0
        for j, tf in enumerate(grid):
            out_rows.append(dict(x=x, g=g, t=tf, role="grid",
                                 dev=devs[j], zabs=zabses[j],
                                 Sv=Svals[j]))
        ddev = [b - a for a, b in zip(devs, devs[1:])]
        dprod = [b - a for a, b in zip(zabses, zabses[1:])]
        s_dev = stats(ddev)
        s_prod = stats(dprod)
        s_S = stats(dS)
        s_zabs = stats([b - a for a, b in zip(zabses, zabses[1:])])
        summary.append("")
        summary.append("## x = %.6e  (%d points, %.1f s)" % (x, len(grid), dt))
        summary.append("- dev = min_d |R_closed - 1|  (closed form, dps-%d)" % DPS_DEV)
        summary.append("- range: %.6e .. %.6e" % (min(devs), max(devs)))
        summary.append("- |ddev| per 0.025 step: median=%.3e mean=%.3e "
                       "p99=%.3e max=%.3e" % (
                           s_dev["median"], s_dev["mean"],
                           s_dev["p99"], s_dev["max"]))
        summary.append("- |dzabs| per step: median=%.3e mean=%.3e "
                       "p99=%.3e max=%.3e" % (
                           s_zabs["median"], s_zabs["mean"],
                           s_zabs["p99"], s_zabs["max"]))
        summary.append("- |d(zabs*dev)| per step: median=%.3e mean=%.3e "
                       "p99=%.3e max=%.3e" % (
                           s_prod["median"], s_prod["mean"],
                           s_prod["p99"], s_prod["max"]))
        summary.append("- |dS| per step (reference): median=%.3e mean=%.3e "
                       "p99=%.3e max=%.3e" % (
                           s_S["median"], s_S["mean"], s_S["p99"], s_S["max"]))
        # zero-crossing alignment: dev steps vs S-crossing steps
        cross = [j for j, dd in enumerate(dS) if dd is not None and abs(dd) > 0.5]
        big_dev = [j for j, dd in enumerate(ddev) if abs(dd) > 10 * s_dev["median"]]
        overlap = [j for j in big_dev if any(abs(j - cj) <= 1 for cj in cross)]
        summary.append("- S-crossing steps (|dS|>0.5): %d;  big dev steps "
                       "(>10x median): %d;  aligned within 1 step: %d"
                       % (len(cross), len(big_dev), len(overlap)))

    summary.insert(2, "")
    summary.insert(
        3, "CROSS-CHECK vs certified ledger (6 rows/anchor, gate 1e-9): "
           + ("PASS" if cc_ok else "FAIL") + "  -- if FAIL, discard grid.")
    summary.append("")
    summary.append("DECISION RULES (docs/SOLUTION-SHAPE.md):")
    summary.append("- dev median/p99 <= ~1e-4 at the 0.025 step while |dS| ~ 0.25:")
    summary.append("  closed-form residual is structurally flat -> Door A alive;")
    summary.append("  the flatness is an explicit-function theorem target (Lean-able).")
    summary.append("- dev rough (median >= ~1e-2) or big-dev steps aligned with S-")
    summary.append("  crossings: the wire combination inherits S roughness at zero")
    summary.append("  resolution -> Door B (re-scope to the sub-RH theorem).")

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as fo:
        for r in out_rows:
            fo.write(json.dumps(r) + "\n")
    with open(SUMMARY, "w") as fo:
        fo.write("\n".join(summary) + "\n")
    print("\n".join(summary))
    print("\nrows:", len(out_rows), "->", OUT)


if __name__ == "__main__":
    main()
