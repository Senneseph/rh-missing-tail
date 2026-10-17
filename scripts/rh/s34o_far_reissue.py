"""s34o: re-issue the EIGHT far-census rows on the C/quad zeta channel.

Input  : tmp/s25_M_farcensus.jsonl        (5 sub-wall rows, components +
         recorded (corrupted-class) logzeta)
         tmp/s34g_far_corrected.jsonl     (3 extreme rows, components,
         already-C logzeta)
Args   : a JSON file mapping exact-f64-integer-t string -> C logzeta
         (used for the 5 sub-wall rows; the 3 extreme rows take their
         C logzeta from s34g).
Output : tmp/s34o_far_reissued.jsonl + a summary.

M is recomputed with the canonical f64 identity, left to right:
    M = eps + lz - lm - la - re - I_far
(plain float64 arithmetic - the recorded pipeline's exact association).
The test: M_new == M_old (the f64 association absorbs O(1-5) lz shifts
at these scales) and integer quantization residual exactly 0.0.

No RH content.  Pure arithmetical re-issue.
"""
import json
import sys

S25 = "tmp/s25_M_farcensus.jsonl"
S34G = "tmp/s34g_far_corrected.jsonl"


def f64_identity(eps, lz, lm, la, re, Ifar):
    # canonical left-to-right float64 association
    return eps + lz - lm - la - re - Ifar


def main():
    corr_path = sys.argv[1]
    corr = {int(k): float(v) for k, v in json.load(open(corr_path)).items()}

    rows = []
    # sub-wall rows (5)
    for line in open(S25):
        line = line.strip()
        if not line:
            continue
        r = json.loads(line)
        t = r["t"]
        ti = int(t)
        if ti not in corr:
            print("SKIP (no C correction for t = %s)" % t)
            continue
        lz_new = corr[ti]
        eps, lm, la, re, Ifar = r["eps"], r["lm"], r["la"], r["re"], r["I_far"]
        M_new = f64_identity(eps, lz_new, lm, la, re, Ifar)
        M_old = r["M"]
        resid = M_new - round(M_new)
        rows.append(dict(
            t=ti, lab=r.get("lab"), band="sub-wall",
            lz_old=float(r["logzeta"]), lz_new=lz_new,
            d_lz=lz_new - float(r["logzeta"]),
            M_old=float(M_old), M_new=M_new,
            M_shift=M_new - float(M_old),
            integer_quantized=resid == 0.0, quant_resid=resid,
        ))
    # extreme rows (3) - s34g already has C lz; recompute M for the record
    for line in open(S34G):
        line = line.strip()
        if not line:
            continue
        r = json.loads(line)
        t = int(r["t"])
        eps, lm, la, re, Ifar = r["eps"], r["lm"], r["la"], r["re"], r["I_far"]
        M_new = f64_identity(eps, r["logzeta"], lm, la, re, Ifar)
        M_old = r["M_old"]
        resid = M_new - round(M_new)
        rows.append(dict(
            t=t, lab=r.get("lab"), band="extreme",
            lz_old=float(r["logzeta_old_corrupt"]), lz_new=float(r["logzeta"]),
            d_lz=float(r["d_logzeta"]),
            M_old=float(M_old), M_new=M_new,
            M_shift=M_new - float(M_old),
            integer_quantized=resid == 0.0, quant_resid=resid,
        ))

    out = "tmp/s34o_far_reissued.jsonl"
    with open(out, "w") as f:
        for r in rows:
            f.write(json.dumps(r) + "\n")

    print("row          band       lz_old        lz_new        d_lz        "
          "M_old          M_new          M_shift  quant")
    n_shift = 0
    for r in rows:
        if r["M_shift"] != 0.0:
            n_shift += 1
        print("%-11s  %-8s  %12.6f  %12.6f  %10.4f   %12.0f   %12.0f   %8.1f  %s"
              % (r["lab"], r["band"], r["lz_old"], r["lz_new"], r["d_lz"],
                 r["M_old"], r["M_new"], r["M_shift"],
                 "OK" if r["integer_quantized"] else "FAIL"))
    print()
    print("rows: %d   M-shifts: %d   all quantized: %s"
          % (len(rows), n_shift, all(r["integer_quantized"] for r in rows)))
    print("wrote", out)


if __name__ == "__main__":
    main()
