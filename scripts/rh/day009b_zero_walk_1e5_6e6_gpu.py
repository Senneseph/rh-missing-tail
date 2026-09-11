#!/usr/bin/env python3
"""Day-009: GPU flip walk 1e5 -> 6e6 (P-0.8 COMPLIANT: named constants,
startup echo + grid-invariant asserts, streaming segment outputs).

Purpose: extend the certified zero list (flip positions, float64,
~dt/2 precision in gamma — sufficient for the 25.2.12 product at
t <= 2e5: phase error ~ T_MAX * (DT_FINE/2) / GAMMA_MIN^2).

Sizing (measured, from the 2026-09-09 aborted probe, same engine):
SAMPLES_PER_SEC_MEASURED ~ 1.4e6 at MAXN = 978, CHUNK = 32768
(iGPU, CuPy, ROCm 7.14). Expected wall: total samples / that rate.

Twin-floor (P-0 item 2): smallest measured gap on (1e5, 1e6] =
0.002954 (19 twins, day-4 census); DT = 5e-4 is <= 17% of that floor;
the DT/2 pass is the stability certificate (flip counts must agree).

Outputs (streaming, one file per segment per pass — usable as soon as
written):  flips_seg_<W0>_<W1>_dt.txt / _dt2.txt + per-segment
certification lines in the log. Final: merged extension file.

Run: ~/venvs/cupy/bin/cupy_py day009b_zero_walk_1e5_6e6_gpu.py
"""
import math
import sys
import time

import numpy as np
import cupy as cp
sys.path.insert(0, ".")
import zeta_core  # noqa: E402

# ---------------- named constants (P-0.8: single definition site) -------
W1 = float(sys.argv[1]) if len(sys.argv) > 1 else 6_000_000.0  # window end (rad); argv override for partial runs (echoed below, P-0.8)
W0 = float(sys.argv[2]) if len(sys.argv) > 2 else 100_000.0    # window start (rad); RESUME override (echoed below)
ANCHOR_FILE = (sys.argv[3] if len(sys.argv) > 3 else
               ("zeros_T100000.txt" if W0 == 100_000.0
                else "zeros_T%d_ext_full.txt" % int(W0)))
SEG = 200_000.0           # segment width (rad) — streaming granularity
DT = 5.0e-4               # coarse flip step (rad)
DT2 = DT / 2.0            # stability-recheck step (rad)
CHUNK = 32_768            # GPU samples per kernel launch
MAXN = int(math.sqrt(W1 / (2.0 * math.pi))) + 1  # 978 at W1
LNPI = math.log(math.pi)                       # computed, not recalled
N_SAMPLES_DT = int(round((W1 - W0) / DT))      # 1.18e10
N_SAMPLES_DT2 = int(round((W1 - W0) / DT2))    # 2.36e10
S_PER_SEC = 1.4e6         # measured throughput (see header)
TWIN_FLOOR_MEASURED = 0.002954   # min gap on (1e5, 1e6], day-4 census
NANCHOR = 138_065        # certified N(1e5) (day-3 census)

# ---------------- P-0.8 startup echo + invariant asserts ---------------
def echo_and_assert():
    w = W1 - W0
    assert abs(DT * N_SAMPLES_DT - w) < DT / 2, "grid: dt*n != W1-W0"
    assert abs(DT2 * N_SAMPLES_DT2 - w) < DT2 / 2, "grid: dt2*n != W1-W0"
    assert DT < TWIN_FLOOR_MEASURED / 5, "dt not safely below twin floor"
    assert NANCHOR == int(np.searchsorted(np.loadtxt(
        "zeros_T100000.txt"), W0)), "N(1e5) anchor != certified value"
    est_h = (N_SAMPLES_DT + N_SAMPLES_DT2) / S_PER_SEC / 3600.0
    print("P-0.8 ECHO: W0=%.1f W1=%.1f width=%.1f  ANCHOR=%s" % (W0, W1, w, ANCHOR_FILE))
    n_anchor = int(np.searchsorted(np.loadtxt(ANCHOR_FILE), W0))
    print("  resume anchor: N(W0)=%d from %s" % (n_anchor, ANCHOR_FILE))
    if W0 == 100_000.0:
        assert n_anchor == NANCHOR, "N(1e5) anchor != certified 138065"
    print("  DT=%.1e (n=%d)  DT2=%.1e (n=%d)  CHUNK=%d  MAXN=%d"
          % (DT, N_SAMPLES_DT, DT2, N_SAMPLES_DT2, CHUNK, MAXN))
    print("  t_end check: W0+DT*n = %.6f  (must equal W1=%.1f)"
          % (W0 + DT * N_SAMPLES_DT, W1))
    print("  twin floor %.6f (dt/floor = %.3f)  anchor N(W0)=%d"
          % (TWIN_FLOOR_MEASURED, DT / TWIN_FLOOR_MEASURED, NANCHOR))
    print("  expected wall ~ %.1f h at %.2e samples/s (measured)"
          % (est_h, S_PER_SEC))

echo_and_assert()
assert zeta_core.selftest(verbose=False), "zeta_core selftest failed"
LANCZOS = [cp.asarray(a, dtype=cp.float64) for a in zeta_core._LANCZOS]
N0 = NANCHOR
if W0 != 100_000.0:
    N0 = int(np.searchsorted(np.loadtxt(ANCHOR_FILE), W0))
    print("resuming: base count N0=%d (certified list up to W0)" % N0, flush=True)

def vartheta_gpu(tv):
    z = 0.25 + 0.5j * tv
    zm1 = z - 1.0
    x = cp.full(tv.shape, float(LANCZOS[0]), dtype=cp.complex128)
    for i in range(1, len(LANCZOS)):
        x = x + LANCZOS[i] / (zm1 + i)
    t_ = zm1 + 7.5
    cg = 0.5 * math.log(2.0 * math.pi) + (zm1 + 0.5) * cp.log(t_) \
        - t_ + cp.log(x)
    return cg.imag - 0.5 * tv * LNPI

def Z_rs_gpu(tv):
    s2p = cp.sqrt(tv / (2.0 * math.pi))
    N = cp.floor(s2p).astype(cp.int64)
    p = s2p - N
    u = cp.sqrt(s2p)
    th = vartheta_gpu(tv)
    nvec = cp.arange(1, MAXN + 1, dtype=cp.float64)
    lnn = cp.log(nvec)
    wgt = 1.0 / cp.sqrt(nvec)
    mask = (nvec[None, :] <= N[:, None]).astype(cp.float64)
    S1 = (cp.cos(th[:, None] - tv[:, None] * lnn[None, :])
          * (mask * wgt)).sum(axis=1)

    def psi(q):
        return cp.cos(2.0 * math.pi * (q * q - q - 0.0625)) \
            / cp.cos(2.0 * math.pi * q)

    h = 1.0e-3
    S3 = (psi(p + 3j * h) - 3 * psi(p + 2j * h)
          + 3 * psi(p + 1j * h) - psi(p))
    d3 = -S3.imag / h ** 3          # DAY-007 FIX (-Im[S]/h^3)
    sign = cp.where(((N - 1) % 2) == 0, 1.0, -1.0)
    R = sign * (psi(p).real / u - d3 / (96.0 * math.pi ** 2 * u ** 3))
    return 2.0 * S1 + R

# engine gate: GPU vs host (post-fix) at 12 scattered points
vt = np.linspace(W0 + 113.0, W1 - 113.0, 12)
err = float(np.abs(Z_rs_gpu(cp.asarray(vt, dtype=cp.float64)).get()
                   - np.array([zeta_core.Z_rs(float(x)) for x in vt]))
                   .max())
print("engine gate GPU-vs-host max |diff| = %.3e (tol 1e-6)" % err)
assert err < 1.0e-6, "Z_rs mismatch — abort"

def pass_dt(dt, w0, w1, tag):
    t_start = time.time()
    n = int(round((w1 - w0) / dt))
    assert abs(dt * n - (w1 - w0)) < dt / 2, "segment grid invariant"
    cum = 0
    z_prev = None
    flips = []
    for i0 in range(0, n, CHUNK):
        i1 = min(i0 + CHUNK, n)
        idx = np.arange(i0, i1, dtype=np.float64)
        tv = cp.asarray(w0 + dt * idx)
        Z = Z_rs_gpu(tv).get()
        sgn = np.sign(Z)
        sgn[sgn == 0] = 1.0
        if z_prev is not None:
            seg = np.concatenate(([z_prev], sgn))
            fl = (seg[1:] != seg[:-1])
        else:
            # DAY-009 FIX (cert 2): the first chunk has no cross-chunk
            # precedent — but its INTERNAL sign changes are real; the old
            # version zeroed the whole first chunk, dropping every zero in
            # [w0, w0 + CHUNK*dt) (13 on seg00, incl. gamma_138066 =
            # 100000.743723).
            fl = np.zeros(len(sgn), dtype=bool)
            fl[1:] = (sgn[1:] != sgn[:-1])
        cum += int(fl.sum())
        idx_f = np.nonzero(fl)[0]
        if idx_f.size:
            flips.append(w0 + dt * (i0 + idx_f))
        z_prev = int(sgn[-1])
    fl = np.concatenate(flips) if flips else np.zeros(0)
    el = time.time() - t_start
    rate = n / el if el > 0 else float("nan")
    print("[%s seg (%.0f, %.0f)] flips=%d  N_now=%d  elapsed %.0f s  "
          "rate %.2e/s" % (tag, w0, w1, len(fl), N0 + cum, el, rate),
          flush=True)
    return fl, N0 + cum

# DAY-011 FIX (off-by-one): `np.arange(W0, W1 + SEG/2, SEG)` never includes W1
# when W1 - W0 is not a multiple of SEG — the (5.9e6, 6.0e6] patch segment was
# silently dropped from the 6e6 list (219k zeros missing; chain's own S-line
# flagged it: N - main = -219016.93). arange(W0, W1) + [W1] always covers W1.
seg_boundaries = list(np.arange(W0, W1, SEG)) + [W1]
all_dt2 = []
for k in range(len(seg_boundaries) - 1):
    s0, s1 = seg_boundaries[k], min(seg_boundaries[k + 1], W1)
    tag0 = "seg%02d" % k
    f_dt, N_a = pass_dt(DT, s0, s1, "dt  " + tag0)
    f_dt2, N_b = pass_dt(DT2, s0, s1, "dt2 " + tag0)
    agree = (N_a == N_b)
    gmin = float(np.diff(f_dt2).min()) if f_dt2.size > 1 else float("nan")
    print("  [%s] N(%d) dt=%d dt2=%d agree=%s  min_gap(dt2)=%.6f"
          % (tag0, s1, N_a, N_b, agree, gmin), flush=True)
    np.savetxt("flips_seg_%09d_%09d_dt.txt" % (int(s0), int(s1)), f_dt,
               fmt="%.10e")
    np.savetxt("flips_seg_%09d_%09d_dt2.txt" % (int(s0), int(s1)), f_dt2,
               fmt="%.10e")
    all_dt2.append(f_dt2)
    if not agree:
        print("  !!! [%s] dt vs dt/2 DISAGREE — segment flagged for "
              "inspection (P-0 twin certificate FAILED)" % tag0, flush=True)
        break  # stop: the certificate failed; do not emit a false list

ext = np.concatenate(all_dt2)
gmin_all = float(np.diff(ext).min()) if ext.size > 1 else float("nan")
np.savetxt("zeros_T%d_ext_GT%d_dt2.txt" % (int(W1), int(W0)), ext, fmt="%.10e")
np.savetxt("zeros_T%d_ext_full.txt" % int(W1),
           np.concatenate((np.loadtxt(ANCHOR_FILE), ext)),
           fmt="%.10e")
print("DONE: extension %d zeros on (%d, %d], min gap %.6f; files "
      "zeros_T%d_ext_* written." % (ext.size, int(W0), int(W1), gmin_all, int(W1)),
      flush=True)
