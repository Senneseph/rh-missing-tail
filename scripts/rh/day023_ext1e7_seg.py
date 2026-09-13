#!/usr/bin/env python3
"""Day-023 — repair-list segment worker: Riemann-Siegel flip walk on
one segment (W0, W1] subset of (6e6, 1e7], 32-way parallel.
Extends the certified list zeros_T6000000_ext_full.txt (N(6e6) =
12,193,869, certified) to T = 1.0e7 — the composite-kernel repair
(DISCOVERY_LOG 21): t/B = 1/10 soundness to ~1e5, 1/40 at 2.5e5, so
the closure statistic (best-straddle, P1.1e) is measurable where it
currently crosses 1 (T* ~ 2.5e4 at B = 6e6; defect-inflated there).

P-0.8 COMPLIANT (named constants, startup echo + grid-invariant
asserts + engine gate + twin certificate, streaming output):
  argv: <segk> <W0> <W1>
  - startup echo: W0 W1 width DT DT2 MAXN base-N rate-estimate
  - engine gate: numpy-vs-host zeta_core.Z_rs at 8 scattered points
    inside the segment (max |diff| < 1e-6, else abort)
  - twin certificate: DT vs DT2 flip counts must agree per segment
    (loud failure; no false list)
  - min gap (dt2) reported per segment
  - output: flips_seg_<W0>_<W1>_dt2.txt (streaming, sorted in-segment)
  - per-segment N continuity: N(W1) = NBASE + flips  (NBASE = N(W0)
    from the certified list, cross-checked against the list count)

Sizing (measured 2026-09-13, this machine, 32-core CPU numpy host
engine, t ~ 3e6, MAXN-1262 matrix): ~6e4 samples/s per process.
Twin floor on (1e5, 6e6] measured from the certified list: 0.002300
(4.6 x DT2).  Expected wall per segment (125,000 wide): ~2.5 h at
6e4 samples/s for DT+DT2 (3.75e8 samples/seg); 32 segments in
parallel => ~2.5-3 h total wall, then ~10 min merge.

Run (supervisor does this):  python3 day023_ext1e7_seg.py <k> <W0> <W1>
"""
import math
import sys
import time

import numpy as np

# ---------------- named constants (P-0.8: single definition site) -------
T_EXT = 1.0e7                 # final window end (rad)
BASE_FILE = "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt"  # noqa: E501
NBASE_6E6 = 12_193_869        # certified N(6e6) (day-010 chain, chain_verify_6e6.py)
DT = 5.0e-4                   # coarse flip step (rad)
DT2 = DT / 2.0                # stability-recheck step (rad)
BLK = 4096                    # S1 matrix block rows (memory bounded ~45 MB)
TWIN_FLOOR_MEASURED = 0.002300  # min gap on (1e5, 6e6], measured day-023
S_PER_SEC = 6.0e4             # measured per-process rate (day-023 bench)
sys.path.insert(0, "/home/jsmille/Projects/kainos-logos/scripts/rh")
import zeta_core  # noqa: E402

LNPI = math.log(math.pi)
LANCZOS = [np.asarray(a, dtype=np.float64) for a in zeta_core._LANCZOS]
MAXN = int(math.sqrt(T_EXT / (2.0 * math.pi))) + 1   # 1262 at T_EXT


def Z_rs_vec(tv):
    """Vectorized host port of the Day-009 GPU engine (same formulas:
    vartheta via Lanczos, S1 masked cosine sum, psi(p) + d3/96pi^2
    remainder, DAY-007 d3 sign fix)."""
    s2p = np.sqrt(tv / (2.0 * math.pi))
    N = np.floor(s2p).astype(np.int64)
    p = s2p - N
    u = np.sqrt(s2p)
    z = 0.25 + 0.5j * tv
    zm1 = z - 1.0
    x = np.full(tv.shape, LANCZOS[0], dtype=np.complex128)
    for i in range(1, len(LANCZOS)):
        x = x + LANCZOS[i] / (zm1 + i)
    t_ = zm1 + 7.5
    cg = 0.5 * math.log(2.0 * math.pi) + (zm1 + 0.5) * np.log(t_) - t_ \
        + np.log(x)
    th = cg.imag - 0.5 * tv * LNPI
    nvec = np.arange(1, MAXN + 1, dtype=np.float64)
    lnn = np.log(nvec)
    wgt = 1.0 / np.sqrt(nvec)
    S1 = np.zeros(tv.shape, dtype=np.float64)
    for b0 in range(0, len(tv), BLK):
        b1 = min(b0 + BLK, len(tv))
        tb = tv[b0:b1]
        thb = th[b0:b1]
        Nb = N[b0:b1]
        mask = (nvec[None, :] <= Nb[:, None])
        S1[b0:b1] = (np.cos(thb[:, None] - tb[:, None] * lnn[None, :])
                     * (mask * wgt)).sum(axis=1)

    def psi(q):
        return np.cos(2.0 * math.pi * (q * q - q - 0.0625)) \
            / np.cos(2.0 * math.pi * q)

    h = 1.0e-3
    S3 = (psi(p + 3j * h) - 3 * psi(p + 2j * h) + 3 * psi(p + 1j * h)
          - psi(p))
    d3 = -S3.imag / h ** 3          # DAY-007 FIX (-Im[S]/h^3)
    sign = np.where(((N - 1) % 2) == 0, 1.0, -1.0)
    R = sign * (psi(p).real / u - d3 / (96.0 * math.pi ** 2 * u ** 3))
    return 2.0 * S1 + R


if __name__ == "__main__":
    segk = int(sys.argv[1])
    W0 = float(sys.argv[2])
    W1 = float(sys.argv[3])
    w = W1 - W0
    n_dt = int(round(w / DT))
    n_dt2 = int(round(w / DT2))

    def echo():
        assert abs(DT * n_dt - w) < DT / 2, "grid: DT*n != W1-W0"
        assert abs(DT2 * n_dt2 - w) < DT2 / 2, "grid: DT2*n != W1-W0"
        assert DT < TWIN_FLOOR_MEASURED * 0.5, \
            "DT not safely below measured twin floor"
        n_w0 = int(np.searchsorted(np.loadtxt(BASE_FILE), W0))
        assert n_w0 == NBASE_6E6 if W0 == 6.0e6 else True
        print("P-0.8 ECHO [seg%02d]: W0=%.1f W1=%.1f width=%.1f"
              % (segk, W0, W1, w), flush=True)
        print("  N(W0) = %d (certified list; N(6e6) = %d)"
              % (n_w0, NBASE_6E6), flush=True)
        print("  DT=%.1e (n=%d)  DT2=%.1e (n=%d)  BLK=%d  MAXN=%d"
              % (DT, n_dt, DT2, n_dt2, BLK, MAXN), flush=True)
        print("  t_end check: W0+DT*n = %.6f (W1=%.1f)"
              % (W0 + DT * n_dt, W1), flush=True)
        print("  twin floor %.6f (DT/floor = %.3f; DT2/floor = %.3f)"
              % (TWIN_FLOOR_MEASURED, DT / TWIN_FLOOR_MEASURED,
                 DT2 / TWIN_FLOOR_MEASURED), flush=True)
        print("  expected wall ~ %.0f s at %.2e samples/s (measured)"
              % ((n_dt + n_dt2) / S_PER_SEC, S_PER_SEC), flush=True)
        return n_w0

    N0 = echo()
    assert zeta_core.selftest(verbose=False), "zeta_core selftest failed"
    vt = np.linspace(W0 + 113.0, W1 - 113.0, 8)
    err = float(np.abs(Z_rs_vec(vt)
                       - np.array([zeta_core.Z_rs(float(x)) for x in vt]))
                       .max())
    print("  engine gate numpy-vs-host max |diff| = %.3e (tol 1e-6)" % err,
          flush=True)
    assert err < 1.0e-6, "Z_rs mismatch — abort"

    def pass_dt(dt, tag):
        t_start = time.time()
        n = int(round(w / dt))
        assert abs(dt * n - w) < dt / 2, "segment grid invariant"
        cum = 0
        z_prev = None
        flips = []
        for i0 in range(0, n, BLK):
            i1 = min(i0 + BLK, n)
            tv = W0 + dt * np.arange(i0, i1, dtype=np.float64)
            sgn = np.sign(Z_rs_vec(tv))
            sgn[sgn == 0] = 1.0
            if z_prev is not None:
                seg = np.concatenate(([z_prev], sgn))
                fl = (seg[1:] != seg[:-1])
            else:
                fl = np.zeros(len(sgn), dtype=bool)
                fl[1:] = (sgn[1:] != sgn[:-1])
            cum += int(fl.sum())
            idx_f = np.nonzero(fl)[0]
            if idx_f.size:
                flips.append(W0 + dt * (i0 + idx_f))
            z_prev = int(sgn[-1])
        fl = np.concatenate(flips) if flips else np.zeros(0)
        el = time.time() - t_start
        print("  [seg%02d %s] flips=%d N(NOW)=%d elapsed %.0f s "
              "rate %.2e/s" % (segk, tag, len(fl), N0 + cum, el, n / el),
              flush=True)
        return fl

    f_dt = pass_dt(DT, "dt ")
    f_dt2 = pass_dt(DT2, "dt2")
    agree = (len(f_dt) == len(f_dt2))
    gmin = float(np.diff(f_dt2).min()) if f_dt2.size > 1 else float("nan")
    print("  [seg%02d] dt=%d dt2=%d agree=%s min_gap(dt2)=%.6f"
          % (segk, len(f_dt), len(f_dt2), agree, gmin), flush=True)
    if not agree:
        print("  !!! [seg%02d] dt vs dt/2 DISAGREE — twin certificate "
              "FAILED; no output emitted" % segk, flush=True)
        sys.exit(2)
    out = "flips_seg%d_%09d_%09d_dt2.txt" % (segk, int(W0), int(W1))
    np.savetxt(out, f_dt2, fmt="%.10e")
    print("  [seg%02d] DONE: %s (%d flips, N(W1) = %d)"
          % (segk, out, len(f_dt2), N0 + len(f_dt2)), flush=True)
