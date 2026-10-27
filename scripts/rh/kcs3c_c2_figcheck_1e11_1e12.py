#!/usr/bin/env python3
"""kcs3c_c2: U3c (c) Step 2/3 - the LOS paper's r = 2, q = 4 rows at
1e11 and 1e12 (the paper's two highest published data rows) via the
margin-verified INTERVAL sieve (the 0187 machinery), plus the new
1e12 point on the U3c residual ladder (the out-of-sample
discriminator named in 0187/0190).

Method (identical clearing set to the global sieve restricted to the
interval - 0187 identity-gated):
  - window W = 5e10, margin M = 2000 (>> the maximal prime gap below
    1e12, which is a few hundred; the boundary gap is VERIFIED at
    runtime and the run aborts if it exceeds the margin),
  - per window [A, B) (B = next boundary or x; the sieve extends to
    B + M to see every successor of a prime <= B),
  - paper-convention pair census: for each odd prime p <= B in the
    window, count (p mod 4, p_{next} mod 4); each pair has a unique
    owning window (the one containing its first member) - exact, no
    merge needed for the paper rows,
  - 'meas' convention (the record's gap-class census, incl. the (2,3)
    gap): internal gap parities per window + the boundary gap parity
    between consecutive windows,
  - checkpoint after each window (tmp/u3c_c_fig/ckpt_{x}.json) -
    resumable; progress + RSS to stdout (long compute: 1 core,
    ~40 GB peak per window, leaves 4 cores + ample RAM free).

The 1e12 output includes:
  - pi = 37607912018 (tabulated) identity check,
  - paper-row agreement at 8.654e9 / 1.015e10,
  - meas, u3 = (1+delta)/2 (LOS q=4, delta = log(pi*log(x)/2)/(2
    log x) as in kcs3c_e), R = meas - u3, se,
  - the TWO live predictions at 1e12 (both derived IN-sample earlier,
    now out-of-sample):
      (i)  the 0186 4-point mixed form  a = -0.123764, b = +0.715792
           (R = a*delta + b*(loglog/log)^2): the 0187 under-predictor,
      (ii) the 0190 DERIVED 2-term form  a = -1.88114 (f2), b =
           +3.69471 (f8 = delta*loglog/log): the 0188 named candidate,
    with z-scores against se.

No RH claim: exact integer sieve; the paper rows are published DATA;
the predictions are in-sample fits tested out-of-sample. Flank work.
"""
import gc
import json
import math
import os
import resource
import sys
import time

import numpy as np

# the VERBATIM u3 (two-together) machinery from kcs3b_gap_class_u3b.py -
# the SAME baseline the R ladder (0186/0187) uses: u3 = S2/(S2+S0).
# (0192 correction: the first 1e12 attempt used (1+delta)/2, the wrong
# baseline - the R ladder's u3 is the two-together pair model.)
import re as _re
_SRC = open(
    "/home/jsmille/Projects/rh-missing-tail/scripts/rh/kcs3b_gap_class_u3b.py"
).read()
_NS = {"np": np, "math": math}
for _name in ["twin_constant", "w_array", "class_sums", "los_delta"]:
    _m = _re.search(r"\ndef %s\(.*?(?=\ndef |\nOUT |\nif __name__)" % _name,
                    _SRC, _re.S)
    assert _m, _name
    exec(_m.group(0), _NS)
for _name in ["twin_constant", "w_array", "class_sums", "los_delta"]:
    globals()[_name] = _NS[_name]

W = 5 * 10 ** 10
MARGIN = 2000
DIR = "/home/jsmille/Projects/rh-missing-tail/tmp/u3c_c_fig"

# the 0190/(0186) in-sample coefficients (for the 1e12 predictions)
MIX4 = (-0.123764, 0.715792)      # R = a*delta + b*(ll/l)^2
DERIV2 = (-1.88114, 3.69471)      # R = a*f2 + b*delta*(ll/l)


def small_primes(limit):
    s = np.ones(limit // 2 + 1, bool)
    s[0] = False
    r = int(math.isqrt(limit)) // 2 + 1
    for i in range(1, r):
        p = 2 * i + 1
        if s[i]:
            s[(p * p) // 2::p] = False
    out = np.nonzero(s)[0]
    return 2 * out + 1


def interval_sieve(lo, hi):
    """Odd prime values (int64) in [lo, hi], the SAME clearing set as
    the global sieve restricted to the interval."""
    lo = int(lo)
    hi = int(hi)
    lo2 = lo if lo % 2 == 1 else lo + 1
    if lo2 > hi:
        return np.zeros(0, dtype=np.int64)
    m = (hi - lo2) // 2 + 1
    s = np.ones(m, bool)
    if lo2 == 1:
        s[0] = False
    sp = small_primes(math.isqrt(hi))
    for p in sp:
        start = p * p
        if start < lo2:
            start = p * ((lo2 + p - 1) // p)
            if start % 2 == 0:
                start += p
        if start > hi:
            continue
        s[(start - lo2) // 2::p] = False
    idx = np.nonzero(s)[0]
    if len(idx) == 0:
        return np.zeros(0, dtype=np.int64)
    idx = idx.astype(np.int64)
    idx *= 2
    idx += lo2
    return idx


def window_tally(i, x):
    """One window [A, B) of the run for target x (sieve to B + M).
    Returns a record: n (primes <= B, incl. 2 for window 0), the 4
    paper-convention pair counts (odd first members <= B), the
    internal gap statistics for the meas convention, and the
    first/last prime <= B."""
    t0 = time.time()
    A = i * W
    B = min((i + 1) * W, x)
    odds = interval_sieve(A, B + MARGIN)
    rec = {"i": i, "A": A, "B": B}
    # paper convention: odd primes with first member <= B; the successor
    # of odds[mB-1] is odds[mB] (the first margin prime) - visible by
    # construction.  Memory: hold at most odds (int64) + two mod-4 byte
    # arrays.  Gap parity for consecutive ODD primes: k = gap//2 is odd
    # iff the endpoints differ mod 4 - no diff array needed.
    mB = int(np.searchsorted(odds, B, side="right"))
    if mB > 0:
        A4 = (odds[:mB] % 4).astype(np.uint8)
        B4 = (odds[1:mB + 1] % 4).astype(np.uint8)
        cnt = {"p11": int(np.count_nonzero((A4 == 1) & (B4 == 1))),
               "p13": int(np.count_nonzero((A4 == 1) & (B4 == 3))),
               "p31": int(np.count_nonzero((A4 == 3) & (B4 == 1))),
               "p33": int(np.count_nonzero((A4 == 3) & (B4 == 3)))}
        # internal odd-prime gaps (both endpoints <= B)
        gn = mB - 1
        g_odd = int(np.count_nonzero(A4 != B4))
        first_p, last_p = int(odds[0]), int(odds[mB - 1])
    else:
        cnt = {"p11": 0, "p13": 0, "p31": 0, "p33": 0}
        gn, g_odd = 0, 0
        first_p, last_p = None, None
    del odds
    gc.collect()
    # window 0 includes prime 2: one extra chain gap, 2 -> first odd
    # (gap 1, k = 0, the record's 'even' bucket - incl. in denominator)
    n2 = 1 if i == 0 else 0
    rec.update(cnt)
    rec["n"] = mB + n2
    rec["gn"] = gn + n2
    rec["godd"] = g_odd + (1 if (i == 0 and mB > 0 and
                                 (first_p - 2) // 2 % 2 == 1) else 0)
    rec["first"] = 2 if (i == 0 and mB == 0) else (
        first_p if mB > 0 else None)
    rec["last"] = last_p
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024.0
    rec["dt"] = time.time() - t0
    rec["rss_mb"] = rss
    return rec


def main():
    targets = [int(t) for t in sys.argv[1:]] or [10 ** 11]
    out = []
    Wt = out.append
    Wt("=" * 74)
    Wt("U3c (c) Step 2/3: the paper's highest q=4 rows (1e11/1e12) + the")
    Wt("new 1e12 residual-ladder point (margin-verified interval sieve;")
    Wt("resumable; 1 core; ~40 GB/window)")
    Wt("=" * 74)
    for x in targets:
        ckpt = os.path.join(DIR, "ckpt_%d.json" % x)
        done = []
        if os.path.exists(ckpt):
            try:
                done = json.load(open(ckpt))
            except Exception:
                done = []
        nwin = (x + W - 1) // W
        Wt("")
        Wt("x = %d   (%d windows of 5e10, margin %d)" % (x, nwin, MARGIN))
        recs = list(done)
        for i in range(nwin):
            if i < len(recs):
                continue
            rec = window_tally(i, x)
            recs.append(rec)
            json.dump(recs, open(ckpt, "w"))
            Wt("  window %2d: n = %13d   %6.1f s   peak %.1f MB"
               % (i, rec["n"], rec["dt"], rec["rss_mb"]))
        # boundary-gap verification
        maxgap = 0
        for j in range(len(recs) - 1):
            gap = recs[j + 1]["first"] - recs[j]["last"]
            maxgap = max(maxgap, gap)
            assert gap > 0, "window prime ordering broken"
            assert gap <= MARGIN, ("boundary gap %d exceeds margin %d"
                                   % (gap, MARGIN))
        # totals
        p11 = sum(r["p11"] for r in recs)
        p13 = sum(r["p13"] for r in recs)
        p31 = sum(r["p31"] for r in recs)
        p33 = sum(r["p33"] for r in recs)
        pi = sum(r["n"] for r in recs)
        gn = sum(r["gn"] for r in recs) + (len(recs) - 1)
        # boundary gaps: one per adjacent pair; parity = the meas
        # convention's k % 2 with k = (p_next - p_prev)//2
        bcrossodd = 0
        for j in range(len(recs) - 1):
            gp = (recs[j + 1]["first"] - recs[j]["last"]) // 2
            bcrossodd += int(gp % 2 == 1)
        odd_k = sum(r["godd"] for r in recs) + bcrossodd
        assert gn == pi - 1, (gn, pi)
        frac_off = (p13 + p31) / pi            # paper convention
        meas = odd_k / gn                      # record convention
        se = math.sqrt(meas * (1 - meas) / gn)
        Wt("")
        Wt("pi(x) = %d" % pi)
        Wt("  pi(x;4,(1,1)) = %15d" % p11)
        Wt("  pi(x;4,(1,3)) = %15d" % p13)
        Wt("  pi(x;4,(3,1)) = %15d   (paper C1.5 exactness: diff = %d)"
           % (p31, p13 - p31))
        Wt("  pi(x;4,(3,3)) = %15d" % p33)
        Wt("  off-diagonal frac (paper conv) = %.6f" % frac_off)
        Wt("  'meas' (record conv) = %.6f   se = %.3e" % (meas, se))
        Wt("  max boundary gap = %d (<= margin %d)  [VERIFIED]"
           % (maxgap, MARGIN))
        paper_rows = {10 ** 11: (9.412e8, 1.118e9),
                      10 ** 12: (8.654e9, 1.015e10)}
        tabpi = {10 ** 11: 4118054813, 10 ** 12: 37607912018}
        if x in tabpi:
            Wt("  pi(x) vs tabulated %d: %s"
               % (tabpi[x], "IDENTITY" if pi == tabpi[x] else "MISMATCH"))
        if x in paper_rows:
            (v11, v13) = paper_rows[x]
            for lbl, val, ours in [("(1,1)", v11, p11), ("(1,3)", v13, p13)]:
                tol = 0.5 * 10 ** (len(str(int(round(val)))) - 4)
                Wt("  paper row %s = %9.3e   ours = %d   |diff| = %.2e   "
                   "(tol %.0e)   %s"
                   % (lbl, val, ours, abs(ours - val), tol,
                      "AGREE" if abs(ours - val) <= tol else "MISMATCH"))
        meas_rec = {10 ** 11: 0.542888}
        if x in meas_rec:
            Wt("  record meas(%d) = %.6f   ours = %.6f   diff = %+.2e"
               % (x, meas_rec[x], meas, meas - meas_rec[x]))
        if x >= 10 ** 12:
            L = math.log(x)
            delta = los_delta(L)
            _C2 = twin_constant()
            _w = w_array(2000, _C2)
            _S2, _S0 = class_sums(L, _w, 2000)
            u3 = _S2 / (_S2 + _S0)   # the R-ladder baseline (u3-only)
            R = meas - u3
            ll = math.log(L) / L
            (a4, b4) = MIX4
            r4 = a4 * delta + b4 * ll * ll
            (a2, b2) = DERIV2
            r2 = a2 * ll * ll + b2 * delta * ll
            Wt("")
            Wt("  === the NEW %d ladder point (out-of-sample) ===" % x)
            Wt("  delta = %.6f   u3 = S2/(S2+S0) (the ladder baseline)"
               " = %.6f" % (delta, u3))
            Wt("  R = meas - u3 = %+.6f   se = %.3e   z(vs u3) = %+.1f"
               % (R, se, R / se))
            Wt("  prediction (i)  0186 4-pt mixed form:  %+.6f   "
               "diff = %+.6f   z = %+.1f"
               % (r4, R - r4, (R - r4) / se))
            Wt("  prediction (ii) 0190 derived 2-term:     %+.6f   "
               "diff = %+.6f   z = %+.1f"
               % (r2, R - r2, (R - r2) / se))
            Wt("  (the two predictions differ by %+.6f = %.0f se - this"
               % (r2 - r4, (r2 - r4) / se))
            Wt("   point tests the 0190 derived form's out-of-sample")
            Wt("   behavior; the 3e12 point is its SECOND such test)")
        Wt("  No RH claim: exact integer sieve; flank work.")
    text = "\n".join(out)
    os.makedirs(DIR, exist_ok=True)
    with open(os.path.join(DIR, "kcs3c_c2_out.txt"), "w") as f:
        f.write(text + "\n")
    print(text)
    print("done")


if __name__ == "__main__":
    main()
