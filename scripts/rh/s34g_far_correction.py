"""s34g: re-lock the three extreme far rows with the CORRECTED
zeta channel (C/quad, s34).

The mpmath dps-20/30/40 anchors of the 1e8G / 3e8G / 5e8G rows
were produced by a corrupted ADR rssum correction (the 5e8G
decomposition: S1 exact at both precisions; rssumS3 = 13.86
magnitude at dps-40 vs 1.18e-5 true; mpmath dps-15 agrees with
the C channel to ~1e-12 in S1, rssumS3, and |zeta|).  The
corrected logzeta values (C/quad zetac, bare-cosine cross-checked
at each height):

    1e8G   r=1e8:   logzeta = 1.455437142349
    3e8G   r=3e8:   logzeta = 3.284789950625
    5e8G   r=5e8:   logzeta = 2.9370199551   (C + mpmath dps-15)

This script recomputes the canonical f64 identity
    M = eps + lz - lm - la - re - I_far
left-to-right in float64 (the census association of record),
re-checks the integer quantization, emits the corrected rows,
and recomputes the far-drift shape (the s32c arithmetic) on the
corrected M values.  Pure f64 arithmetic - no heavy compute, no
zeta call.  No RH claim: this is a data re-anchoring.
"""
import json

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
OUT = BASE + "/tmp/s34g_far_corrected.jsonl"

# corrected logzeta (provenance: C/quad zetac s34)
C_LZ = {
 "r=1e+08G": (1.455437142349,
              "C/quad zetac s34 chain 0 (bare-cos |Z| 4.2863862899 "
              "vs full 4.2863568042, d = 2.9e-5)"),
 "r=3e+08G": (3.284789950625,
              "C/quad zetac s34 chain 1 (bare-cos |Z| 26.7033614441 "
              "vs full 26.7033746986, d = 1.3e-5)"),
 "r=5e+08G": (2.9370199551,
              "C/quad zetac s34 chain 2 (bare-cos |Z| 18.8595810231 "
              "vs full 18.8595601495, d = 2.1e-5); mpmath dps-15 "
              "instrumented run agrees to 1e-12 (|z| 18.859560149492"
              "072, S1 to 2e-14, rssumS3 1.18e-5)"),
}


def f64_M(eps, lz, lm, la, re, I_far):
    """the canonical census association, float64, left to right."""
    return eps + lz - lm - la - re - I_far


def ulp(x):
    ax = abs(x)
    if ax == 0:
        return 1.0
    b = np.float64(ax)
    return float(np.spacing(b))


def main():
    rows = []
    for line in open(BASE + "/tmp/s30_far_extreme.jsonl"):
        rows.append(json.loads(line))
    out = []
    for r in rows:
        lab = r["lab"]
        lz_new, prov = C_LZ[lab]
        M_new = f64_M(r["eps"], lz_new, r["lm"], r["la"], r["re"],
                      r["I_far"])
        mr = round(M_new)
        resid = M_new - mr
        rec = dict(t=r["t"], lab=lab,
                   stage="corrected",
                   eps=r["eps"],
                   logzeta=lz_new,
                   logzeta_src=prov,
                   logzeta_old_corrupt=r["logzeta"],
                   d_logzeta=lz_new - r["logzeta"],
                   lm=r["lm"], la=r["la"], re=r["re"], I_far=r["I_far"],
                   M=M_new, M_old=r["M"],
                   M_round=mr,
                   integer_quantized=abs(resid) < 0.5 * ulp(M_new),
                   quant_resid=resid,
                   quant_resid_ulps=resid / ulp(M_new),
                   M_shift=M_new - r["M"])
        out.append(rec)
    with open(OUT, "a") as fh:
        for rec in out:
            fh.write(json.dumps(rec) + "\n")

    # --- the far-drift shape on the corrected M (s32c arithmetic) ---
    G = 30001045999.981975555  # G_LAST (s9 engine constant)
    xs, Ms, Ifs = [], [], []
    for rec in out:
        xs.append(rec["t"] / G)
        Ms.append(abs(rec["M"]))
        Ifs.append(abs(rec["I_far"]) / rec["t"])
    X = np.array(xs)
    Mv = np.array(Ms)
    A = np.vstack([X ** 2, X, np.ones_like(X)]).T
    coef, *_ = np.linalg.lstsq(A, Mv, rcond=None)
    fit = A @ coef
    print("=== corrected far rows ===")
    for rec in out:
        print("  %-10s  M_old = %.1f   M_new = %.8f   (round %.1f,"
              " resid %.3e = %.3e ulps)  d_lz = %+.6f"
              % (rec["lab"], rec["M_old"], rec["M"], rec["M_round"],
                 rec["quant_resid"], rec["quant_resid_ulps"],
                 rec["d_logzeta"]))
    print("=== |M|(x) quadratic on corrected M  (x = t/G) ===")
    print("  a2 = %+.6e   a1 = %+.6e   a0 = %+.6e"
          % (coef[0], coef[1], coef[2]))
    for x, m, f in zip(X, Mv, fit):
        print("  x = %.1e  |M| = %.6f  fit-resid = %.3e" % (x, m, m - f))
    print("=== |I_far|/t (t-linearity, corrected rows) ===")
    for x, i in zip(X, Ifs):
        print("  x = %.1e  |I_far|/t = %.9e" % (x, i))
    # local exponents
    (x1, m1), (x2, m2), (x3, m3) = zip(xs, Ms)
    e12 = np.log(m2 / m1) / np.log(x2 / x1)
    e23 = np.log(m3 / m2) / np.log(x3 / x2)
    print("  local exponents: %s->%s: %.3f   %s->%s: %.3f"
          % (x1, x2, e12, x2, x3, e23))
    print("OUT = %s" % OUT)


if __name__ == "__main__":
    main()
