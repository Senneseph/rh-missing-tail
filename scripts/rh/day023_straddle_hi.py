#!/usr/bin/env python3
"""day023 (1e7, 1e9] band scan — PER-T EXACT TAIL (no frozen-center).

Why per-t: at t >= 1e7 the tail log product pieces (discrete (1e7,3e7],
quad (3e7, REM_HI], main <= 1e7) are individually O(1e7)-scale in re and
wildly t-sensitive (they cancel to log|zeta| + O(1) only in the SUM);
freezing the quad at t = g (the low-band center-tail trick) is invalid
here.  So every t gets its own dps-30 quadrature.

Kernel (day-023 corrected):
  K = e^{logmain25212(s) + logprod_{g<=1e7} pairfactor + tail_discrete(s)}
  tail_discrete = discrete sum over 47,517,736 actual zeros (1e7, 3e7]
    (LMFDB shards, phase branch +i*pi per g < t) + mp.quad density
    (3e7, REM_HI] + analytic bound (REM_HI, inf).
  margin(t) = |zeta| * min_d |R-1| / (B(t) + |zeta - K|)
The POLE COLUMN t = g is excluded (kernel product vanishes there; it is
the own-height detector regime S2b/C1a, not the straddle window).

Candidates: 8 real zeros <= 3.15e7 (shards reach 3.15e7; nominal g above
that are NOT real zeros and the 5e3-gate discards them) + 9 nominal
decade points (exploratory, labeled "exp", tail from density quad only
since the discrete cache stops at 3e7).

Env: TAIL_REM_HI (default 1e18), TAIL_REM_NPTS (default 200),
REISSUE_NPTS (default 400), WORKERS (default 32).
"""
import mpmath as mp
mp.mp.dps = 30
import os
import numpy as np
import concurrent.futures as cf
import day023_taildiscrete as td
import day023_p11c_1e7 as M

LO_T, HI_T = 1.0e7, 3.15e7


def real_zero_at(x):
    gh = td._G_CACHE
    i = int(np.searchsorted(gh, x))
    cands = [float(gh[j]) for j in range(max(0, i-2), min(gh.size, i+3))]
    gz = min(cands, key=lambda v: abs(v-x))
    return gz if abs(gz-x) < 5e3 else None


DG = [mp.mpf(k)/1000 for k in range(5, 501)]


def margin_at(t, g, npts):
    s = mp.mpc(0.5, t)
    gmp = mp.mpf(repr(float(g))); tmm = mp.mpf(repr(float(t)))
    dev = None
    for d in DG:
        v = abs(M.R_closed(gmp, tmm, d) - 1)
        dev = v if dev is None else min(dev, v)
    z = mp.zeta(s)
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    os.environ["TAIL_REM_NPTS"] = str(npts)
    disc, rem, bound = td.tail_discrete(s)
    tail = (mp.mpf(repr(float(disc.real if isinstance(disc, complex) else disc)))
            + 1j*mp.mpf(repr(float(disc.imag if isinstance(disc, complex)
                                  else 0.0))) + rem)
    K = mp.e**(main + mp.mpf(repr(float(la))) + 1j*mp.mpf(repr(float(ar)))
               + tail)
    B = M.B_best(tmm)
    resid = abs(z - K)
    margin = abs(z)*dev/(B + resid)
    E = mp.log(abs(z)) - mp.re(mp.log(K))
    return {"margin": margin, "t": t, "g": g, "zeta": abs(z), "resid": resid,
            "B": B, "dev": dev, "E": E, "bound": bound}


def scan_one(x, label, npts_workers):
    g = real_zero_at(x)
    real = g is not None
    if real is False:
        g = float(x)
    best = None
    for k in range(-12, 13):
        if k == 0:
            continue  # pole column (own-height detector regime, S2b/C1a)
        t = mp.mpf(repr(float(g))) + mp.mpf(k)/2
        r = margin_at(t, float(g), npts_workers)
        if best is None or r["margin"] > best["margin"]:
            best = r
    best = margin_at(best["t"], float(g), int(os.environ.get("REISSUE_NPTS", "400")))
    best["label"] = label + ("" if real else " exp")
    best["is_real"] = real
    return best


def _worker(args):
    x, lab, npts = args
    if td._G_CACHE is None:
        td.build_cache()
    return _scan_locked(x, lab, npts)


# (each worker builds its own cache; the pool is fork-based)
_scan_locked = None


def run():
    work = int(os.environ.get("WORKERS", "32"))
    npts = int(os.environ.get("TAIL_REM_NPTS", "200"))
    td.build_cache()
    cands = [(1.0e7, "1e7"), (1.2e7, "1.2e7"), (1.5e7, "1.5e7"),
             (1.8e7, "1.8e7"), (2.0e7, "2e7"), (2.4e7, "2.4e7"),
             (2.8e7, "2.8e7"), (3.1e7, "3.1e7"), (3.75e7, "3.75e7"),
             (5.0e7, "5e7"), (7.5e7, "7.5e7"), (1.0e8, "1e8"),
             (1.5e8, "1.5e8"), (2.5e8, "2.5e8"), (4.0e8, "4e8"),
             (6.0e8, "6e8"), (1.0e9, "1e9")]
    print("P1.1e band scan (1e7, 1e9]: %d candidates, per-t quad to %s, %d pts, %d workers"
          % (len(cands), os.environ.get("TAIL_REM_HI", "1e18"), npts, work), flush=True)
    with cf.ProcessPoolExecutor(max_workers=work) as ex:
        futs = [ex.submit(scan_one, x, lab, npts) for (x, lab) in cands]
        results = [fu.result() for fu in futs]
    results.sort(key=lambda r: float(r["t"]))
    print("%-10s %10s %9s %9s %9s %9s %9s %9s" %
          ("g", "t_best", "margin", "def_c", "resid", "zeta", "dev", "E"))
    for r in results:
        deff = r["B"] + r["resid"]
        print("%-10.4f %10.4f %9.4f %9.5f %9.5f %9.4f %9.4f %9.6f  %s"
              % (float(r["g"]), float(r["t"]), float(r["margin"]),
                 float(deff), float(r["resid"]), float(r["zeta"]),
                 float(r["dev"]), float(r["E"]), r["label"]))


if __name__ == "__main__":
    run()
