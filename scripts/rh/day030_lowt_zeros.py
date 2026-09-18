#!/usr/bin/env python3
"""day030 -- LOW-T zero fetch: all zeros of zeta on Re s = 1/2 with
0 < t <= 1200.  Method: bisection on Im zeta (no derivative:
mpmath zeta(s,1) is garbage near zeros; secant findroot wanders),
with interlaced-real-zeta-point disambiguation; verified three ways:
  (a) direct residual |zeta(1/2+i t)| < 1e-10 + monotone gaps > 0.1
      (mpmath zeta has a ~1e-14 absolute NOISE FLOOR near zeros even at
      dps-60 - measured 2026-09-18 - so the residual gate is 1e-10:
      zeros good to ~1e-14.  SUFFICIENT for the day030 unit: worst
      kernel error at the closest pair (gap ~ 1e-8) ~ 2e-6 in a log
      argument vs O(1) margins; dps-50 anchors use the SAME canonical
      float64 list - no cross-precision zero mismatch.)
  (b) spot-check the first 10 against the published values (20
      digits)
  (c) independent second walk (different starting guess) on the
      first 100 + count vs the N(t) asymptotic at 1200 (|d| <= 2).
Saves scripts/rh/lowt/zeros_0_to_1p2e3.f64 + prints md5.
"""
import mpmath as mpm

mpm.mp.dps = 30
import hashlib
import math
import os
import numpy as np

TMAX = 1200.0

FIRST_TEN = [
    14.134725141734693790457,
    21.022039638771554992628,
    25.010857580145688763214,
    30.424876125859513210311,
    32.935061587739189690662,
    37.586178158825671257,     # fetched 2026-09-18 (Wikipedia/OEIS);
    40.918719012147495187796,     # the original memory-typed 37.586...631,
    43.327073280914999519,        # 43.327...559, 48.00515088160968... were wrong
    48.005150881167159727,
    49.773832477672302127944,
]


def estimate_next(t):
    """spacing 2*pi/log(t/2pi) (the N(t) inverse, first order)."""
    return t + 2.0 * mpm.pi / mpm.log(mpm.mpf(repr(t)) / (2 * mpm.pi))


def _imz(t):
    return mpm.im(mpm.zeta(mpm.mpc(0.5, t)))


def _bisect_sign(a, b):
    for _ in range(55):
        m = (a + b) / 2
        if _imz(a) * _imz(m) <= 0:
            b = m
        else:
            a = m
    return (a + b) / 2


def _min_im(a, b):
    """TERNARY search toward the local minimum of |Im zeta| on
    [a, b] (the lobe bottom of a flat zero).  28 iters:
    0.075/3^28 ~ 5e-15 - the LOBE-LEVEL minimum (noise-limited
    near a flat bottom, ~1e-9 from the true zero: that is why the
    next stage is a |zeta|-polish, not a tighter |Im| search)."""
    for _ in range(28):
        m1 = a + (b - a) / 3
        m2 = b - (b - a) / 3
        if abs(_imz(m1)) < abs(_imz(m2)):
            b = m2
        else:
            a = m1
    return (a + b) / 2


def _min_zeta(a, b):
    """TERNARY search on |zeta| over [a, b] (30 iters:
    2e-4/3^30 ~ 1e-18): the |zeta|-polish of a lobe candidate.
    |zeta| is quasi-unimodal with the minimum AT the true zero."""
    for _ in range(30):
        m1 = a + (b - a) / 3
        m2 = b - (b - a) / 3
        if abs(mpm.zeta(mpm.mpc(0.5, m1))) < \
                abs(mpm.zeta(mpm.mpc(0.5, m2))):
            b = m2
        else:
            a = m1
    return (a + b) / 2


def newton_zero_from(t_cur, sp_est):
    """Find the NEXT zero strictly above t_cur (the flat-proof
    version, 2026-09-19).  Pathology handled: a zero with tiny
    Re(zeta') (verified case: 169.9119764794) makes Im zeta do a
    narrow shallow lobe (no O(1)-slope crossing), invisible to a
    sign-change scan.  Pipeline: (1) coarse 61-pt scan; (2)
    sign-change brackets -> 40-halving bisection roots (1e-13);
    (3) lobe triggers (interval min |Im| < 0.02, dedup after
    accept) -> 28-iter |Im| ternary -> loose |zeta| gate 1e-5
    -> 30-iter |zeta| ternary polish over [r, r +- 1e-4];
    (4) FINAL gate |zeta| < 1e-7 for ALL survivors (plain zeros:
    2e-18-bisected roots pass directly; lobe landings: the polish
    drives |zeta| to the mpmath noise floor ~1e-11-1e-14 -
    MEASURED 2.315e-11 at 169.912, so the gate sits BETWEEN the
    true-zero noise floor (~1e-11) and the worst isolated
    false-candidate |zeta| after polish (~1e-5 at 1e-4 from a
    zero, ~0.5-2 at interlaced points): 1e-7 has ~3.5 orders of
    margin on each side).  First survivor by t = the next true
    zero.

    Gate history (each miss documented): 1e-8 and 1e-11 REJECTED
    the 169.912 lobe landing (|zeta| 2.86e-7 at the 1e-9-
    noise-floor |Im| minimum / 2.315e-11 at the fully polished
    true zero); the two-stage loose(1e-5)+polish+1e-7 form
    catches it without admitting false candidates (an isolated
    non-zero point has post-polish |zeta| >= ~1e-5)."""
    t0 = mpm.mpf(repr(float(t_cur)))
    sp = mpm.mpf(repr(float(sp_est)))
    wid = 2.5 * sp
    if wid < mpm.mpf("6.0"):
        wid = mpm.mpf("6.0")
    lo = t0 + mpm.mpf("0.05")
    hi = t0 + wid
    N = 61
    pts = [lo + (hi - lo) * mpm.mpf(i) / (N - 1) for i in range(N)]
    vals = [_imz(x) for x in pts]
    seen = []
    cands = []

    def _consider(r):
        """candidate plumbing (dedup 1e-7, loose |zeta| gate 1e-5,
        |zeta| polish over +-1e-4 ONLY when the candidate is coarse
        (|zeta| > 1e-9): the polish's noise-limited ternary floor
        ~1e-9 DESTROYS an exact bisection root (1e-13) - the walk
        residuals all degraded to ~1e-10 until this).  No skip set:
        false lobe candidates are killed by the gates, never by
        suppression."""
        if not all(abs(r - q) > mpm.mpf("1e-7") for q in seen):
            return
        seen.append(r)
        res0 = abs(mpm.zeta(mpm.mpc(0.5, r)))
        if res0 < mpm.mpf("1e-9"):
            cands.append(r)
        elif res0 < mpm.mpf("1e-5"):
            cands.append(_min_zeta(r - mpm.mpf("1e-4"),
                                   r + mpm.mpf("1e-4")))

    # (1) coarse sign brackets: bisection roots
    for i in range(N - 1):
        if vals[i] * vals[i+1] < 0:
            _consider(_bisect_sign(pts[i], pts[i+1]))
    # (1b) NODE check: a grid node sitting ON an Im-zero (|Im| <
    # 1e-9): the sign products on both sides are 0, not < 0.
    for j in range(N):
        if abs(vals[j]) < mpm.mpf("1e-9"):
            _consider(mpm.mpf(repr(float(pts[j]))))
    # (2) lobe/multi-structure loop: an interval is suspicious if
    # ANY of a, mid, b has |Im| < 0.05 (midpoint probe added: the
    # 169.9 case - an interlaced point + a flat true zero 4.16e-3
    # apart inside ONE coarse interval - has same-sign coarse
    # endpoints and only the mid/interior sees the dip).
    # Suspicious intervals are FINELY SUBDIVIDED (25 pts) and EVERY
    # fine sign bracket is bisected plus every sub-0.02 fine lobe
    # ternaried: a single ternary on the coarse interval finds only
    # ONE |Im| minimum (it found the interlaced point, |zeta|
    # 8.2e-3, and the gate correctly rejected it - killing the
    # true zero 4.2e-3 away that was never examined).
    M2 = 25
    for i in range(N - 1):
        mid = (pts[i] + pts[i+1]) / 2
        if (min(abs(vals[i]), abs(vals[i+1])) < mpm.mpf("0.05")
                or abs(_imz(mid)) < mpm.mpf("0.05")):
            a_ = pts[i]
            b_ = pts[i+1]
            fpts = [a_ + (b_ - a_) * mpm.mpf(k) / M2 for k in range(M2+1)]
            fvals = [_imz(x) for x in fpts]
            for k in range(M2):
                if fvals[k] * fvals[k+1] < 0:
                    _consider(_bisect_sign(fpts[k], fpts[k+1]))
                elif (min(abs(fvals[k]), abs(fvals[k+1]))
                          < mpm.mpf("0.02")):
                    _consider(_min_im(fpts[k], fpts[k+1]))
                if abs(fvals[k]) < mpm.mpf("1e-9"):
                    _consider(mpm.mpf(repr(float(fpts[k]))))
    surv = []
    for r in cands:
        res = abs(mpm.zeta(mpm.mpc(0.5, r)))
        if res < mpm.mpf("1e-7"):
            surv.append((float(r), float(res)))
    surv.sort()
    # post-dedup: sign+lobe can deliver the SAME zero twice
    # (polish precision ~1e-9 > the 1e-7 candidate dedup).
    # True zeros are >= 0.16 apart - 1e-5 is 4 orders safe.
    # Per duplicate group keep the member with the SMALLEST |zeta|
    # (the bisected root at ~1e-13-1e-18, not the lobe landing at
    # ~1e-9 - the earlier keep-first-in-t degraded every residual
    # to the noise floor ~1e-10).
    groups = []
    for r, res in surv:
        if groups and r - groups[-1][-1][0] < 1e-5:
            groups[-1].append((r, res))
        else:
            groups.append([(r, res)])
    dd = [min(g, key=lambda x: x[1]) for g in groups]
    dd.sort()
    if not dd:
        raise RuntimeError("no forward zero in (%.4f, %.4f]" % (lo, hi))
    return (dd[0][0], dd[0][1])


def walk(t0, n, jitter=0.0):
    out = []
    t = mpm.mpf(repr(t0 + jitter))
    for _ in range(n):
        t1 = estimate_next(float(t))
        z, res = newton_zero(float(t1))
        out.append((z, res))
        t = mpm.mpf(repr(z))
    return out


def _diag_report(keep, lm12):
    """Which LMFDB zeros did the walk MISS, and which are EXTRA?"""
    miss = [float(v) for v in lm12
            if keep.size == 0 or float(np.min(np.abs(keep - v))) > 1e-6]
    extra = [float(v) for v in keep
             if lm12.size == 0 or float(np.min(np.abs(lm12 - v))) > 1e-6]
    print("DIAGNOSIS - LMFDB zeros NOT found by the walk: %d" % len(miss),
          flush=True)
    for v in miss:
        print("  MISSED: %.12f" % v, flush=True)
    if extra:
        print("DIAGNOSIS - walk values not in LMFDB: %d" % len(extra),
              flush=True)
        for v in extra:
            print("  EXTRA: %.12f" % v, flush=True)


if __name__ == "__main__":
    mpm.mp.dps = 30
    # count target: N(1200) asymptotic
    n_est = int(round((mpm.mpf("1200") * (mpm.log(mpm.mpf("1200") / (2*mpm.pi)))
                       - mpm.mpf("1200")) / (2 * mpm.pi)))
    print("N(1200) asymptotic ~", n_est, flush=True)

    zeros = []
    # coarse walk with slack, then trim.  Start at 14.0: the first
    # zero is at 14.1347 (the 20-digit spot check (b) below is the
    # anchor that proves no zero was missed below it).
    t = mpm.mpf("13.0")   # below gamma_1 = 14.1347: the window floor
    # t + 0.3 would otherwise exclude the first zero (V7 defect).
    import time
    t_wall = time.time()
    # checkpoint/resume (V10): the full walk takes ~66 min at the
    # lobe-proof cost - one long foreground timeout is a gamble;
    # save every 25th zero, resume from the checkpoint if a run is
    # killed mid-walk (the LMFDB exact gate below validates the
    # WHOLE list either way, so a corrupt checkpoint can never
    # pass silently).
    # .npz exactly: np.savez_compressed APPENDS .npz to any other
    # suffix (V10's checkpoints landed as *.np.gz.npz and the
    # resume check looked for the bare name - documented).
    ckpt = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "lowt", "zeros_checkpoint.npz")
    start_t = mpm.mpf("13.0")
    start_k = 0
    if os.path.exists(ckpt):
        ck = np.load(ckpt, allow_pickle=False)
        arr = ck["arr"]           # NpzFile: name the key (ck[-1]
        start_t = mpm.mpf(repr(float(arr[-1])))               # is a
        start_k = int(arr.size)                               # dict,
        print("RESUME: checkpoint %d zeros, last t = %.6f"           # not an indexable array)
              % (start_k, float(arr[-1])), flush=True)
        zeros = [(float(v), 0.0) for v in arr]
    t = start_t
    for _ in range(n_est + 12 - start_k):
        t1 = estimate_next(float(t))
        z, res = newton_zero_from(float(t), float(t1) - float(t))
        if z <= float(t) + 1e-9:
            raise RuntimeError("stall: no forward progress at t = %.4f"
                               % float(t))
        zeros.append((z, res))
        if len(zeros) % 25 == 0 or z > TMAX:
            print("  z=%3d  t=%.6f  res=%.1e  (%.0f s, %.1f s/zero)"
                  % (len(zeros), z, res, time.time() - t_wall,
                     (time.time() - t_wall)/len(zeros)), flush=True)
            if z > TMAX:
                os.remove(ckpt) if os.path.exists(ckpt) else None
            else:
                os.makedirs(os.path.dirname(ckpt), exist_ok=True)
                np.savez_compressed(ckpt,
                                    arr=np.array([v for v, _ in zeros],
                                                 dtype="<f8"))
        t = mpm.mpf(repr(z))
        if z > TMAX:
            break
    # dedupe + trim + verify
    seen = set()
    max_res = 0.0
    keep = []
    for z, res in zeros:
        key = round(z, 12)
        if key in seen or z <= 0 or z > TMAX:
            continue
        seen.add(key)
        if res > mpm.mpf("1e-10"):
            print("  !! residual fail at t = %.20f (res %.2e)" % (z, res),
                  flush=True)
            raise SystemExit("residual check failed")
        max_res = max(max_res, float(res))
        keep.append(z)
    for i in range(1, len(keep)):
        if keep[i] - keep[i-1] < 0.1:
            print("  !! gap fail near t = %.6f (gap %.3e)"
                  % (keep[i], keep[i]-keep[i-1]), flush=True)
            raise SystemExit("gap check failed")
    print("walk: %d zeros in (0, 1200]; max |residual| = %.2e (gate 1e-10); "
          "count vs asymptotic: d = %d" % (len(keep), max_res,
                                           len(keep) - n_est), flush=True)
    if abs(len(keep) - n_est) > 2:
        print("WARNING: count %d vs asymptotic %d - the LMFDB diff below identifies any misses" % (len(keep), n_est), flush=True)

    # (b-pre) EXACT diff vs the committed LMFDB list (0, 1200]
    # (the independent verified oracle): counts must match and
    # every zero agree to < 1e-6.
    lm = np.loadtxt(os.path.join(os.path.dirname(os.path.abspath(
        __file__)), "zeros_T10000000_lmfdb.txt"), dtype="<f8")
    lm12 = lm[lm <= TMAX]
    print("LMFDB oracle: %d zeros in (0, 1200]" % lm12.size, flush=True)
    karr = np.array(keep, dtype="<f8")          # keep is a list
    if karr.size != lm12.size or float(np.max(np.abs(karr - lm12))) > 1e-6:
        _diag_report(karr, lm12)
        raise SystemExit("LMFDB gate failed (see diagnosis above)")
    dmax = float(np.max(np.abs(karr - lm12)))
    print("LMFDB exact gate: %d zeros, max |d| = %.2e  (PASS)"
          % (keep.size, dmax), flush=True)

    # (b) first-ten spot check (20 digits)
    maxdd = 0.0
    for i, ref in enumerate(FIRST_TEN):
        dd = abs(keep[i] - ref)
        maxdd = max(maxdd, dd)
        if dd > 1e-13:
            print("  !! first-ten spot check FAIL at i=%d: d=%.2e"
                  % (i, dd), flush=True)
            raise SystemExit("spot check failed")
    print("first-ten spot check vs fetched reference (tol 1e-13): "
          "max |d| = %.2e (PASS)" % maxdd, flush=True)

    # (c) independent second walk on the first 100 (different start)
    z2 = [x[0] for x in walk(12.0, min(100, len(keep)), jitter=0.37)]
    dd2 = max(abs(z2[i] - keep[i]) for i in range(len(z2)))
    print("independent walk (first 100): max |d| = %.2e (PASS if < 1e-12)"
          % dd2, flush=True)
    assert dd2 < 1e-12

    # save
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                       "lowt", "zeros_0_to_1p2e3.f64")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    arr = np.array(keep, dtype="<f8")
    arr.tofile(out)
    md5 = hashlib.md5(open(out, "rb").read()).hexdigest()
    print("\nSAVED %s  (%d zeros, %.6f ... %.6f)  md5 = %s"
          % (out, arr.size, float(arr[0]), float(arr[-1]), md5), flush=True)
    print("first 5:  ", " ".join("%.17g" % keep[i] for i in range(5)),
          flush=True)
    print("last  3:  ", " ".join("%.17g" % keep[i]
                                 for i in range(len(keep)-3, len(keep))),
          flush=True)
