#!/usr/bin/env python3
"""
s3_interpret.py

Interpret the s3 single-zero margin sweep
(tmp/s3_ledger_recon_margin_sweep.jsonl):

  per 0.025 step, per anchor:
    |dmnew| : margin movement (the door statistic)
    |dS|    : true S increment,  recovered exactly from the
              recorded  im ( = smooth + pi*N(t,tail) )  and
              the principal-arg S  field:
                 dS_step = (arg_p(b)-arg_p(a))/pi + k
                 k = round((im_b - im_a)/pi)     (exact:
                 the smooth-im part per 0.025 step is ~0.004)
  alignment : big |dm| steps vs S-crossing steps
              (|dS| > 0.5)
  contrast  : |dm| vs |dS|  (the 4-5 order gap at 0.5 scale,
              now at TRUE 0.025 scale)

Door rules (docs/SOLUTION-SHAPE.md):
  |dm| median/p99 <= ~1e-4 while |dS| ~ 0.25/step
      -> structural flatness:  the margin's flatness is a
         consequence of the identity Kfull = -c(x) zeta.
  |dm| rough (>= ~1e-2) and/or aligned with S crossings
      -> the margin carries zero-scale structure.

output:  tmp/s3_interpret.md
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
J = os.path.join(ROOT, "tmp", "s3_ledger_recon_margin_sweep.jsonl")
OUT = os.path.join(ROOT, "tmp", "s3_interpret.md")


def stats(ad):
    if not ad:
        return None
    ad = sorted(ad)
    n = len(ad)
    return dict(n=n, median=ad[n // 2], mean=sum(ad) / n,
                p99=ad[min(n - 1, int(0.99 * (n - 1)))], max=ad[-1])


def main():
    anchors = {}
    for line in open(J):
        r = json.loads(line)
        if r.get("role") != "grid":
            continue
        a = r["x"]
        anchors.setdefault(a, []).append(r)
    for a in anchors:
        anchors[a].sort(key=lambda r: r["t"])

    lines = ["# s3 single-zero sweep interpretation", ""]
    alldm = []
    allds = []
    for a in sorted(anchors):
        rows = anchors[a]
        ms = [r["mnew"] for r in rows]
        ims = [float(r["im"]) for r in rows]
        Sp = [r["S"] for r in rows]          # principal arg / pi
        dm = [abs(b - a2) for a2, b in zip(ms, ms[1:])]
        dS = []
        for i in range(len(rows) - 1):
            k = round((ims[i + 1] - ims[i]) / math.pi)
            dS.append((Sp[i + 1] - Sp[i]) + k)
        alldm += dm
        allds += [abs(v) for v in dS]
        sdm = stats(dm)
        sds = stats([abs(v) for v in dS])
        lines.append("## x = %.6e   (%d grid pts, %d steps)" %
                     (a, len(rows), len(dm)))
        lines.append("- margin  |dm| per 0.025 step:  median %s,  mean %s,  p99 %s,  max %s"
                     % ("%.2e" % sdm["median"], "%.2e" % sdm["mean"],
                        "%.2e" % sdm["p99"], "%.2e" % sdm["max"]))
        lines.append("- S-side  |dS| per 0.025 step:  median %s,  mean %s,  p99 %s,  max %s"
                     % ("%.3f" % sds["median"], "%.3f" % sds["mean"],
                        "%.3f" % sds["p99"], "%.3f" % sds["max"]))
        lines.append("- net S change over the %.2f-unit grid: %+.3f"
                     % (rows[-1]["t"] - rows[0]["t"], sum(dS)))
        #  alignment
        order = sorted(range(len(dm)), key=lambda j: -dm[j])
        big_dm = set(order[:5])           # top-5 margin steps
        cross = set(j for j, v in enumerate(dS) if abs(v) > 0.5)
        ov = big_dm & cross | {j for j in big_dm
                               if min((abs(j - c) for c in cross),
                                      default=99) <= 1}
        lines.append("- top-5 |dm| steps within 1 of an S-crossing step: %d/5"
                     % len(ov))
        ratio = (sdm["max"] / sds["median"]) if sds else 0
        lines.append("- contrast max|dm| / median|dS|:  %.1e" % ratio)
        lines.append("")

    adm = stats(alldm)
    ads = stats(allds)
    lines.append("## band-wide (all three sweeps)")
    lines.append("|dm|:  median %.2e, p99 %.2e, max %.2e  (n=%d)"
                 % (adm["median"], adm["p99"], adm["max"], adm["n"]))
    lines.append("|dS|:  median %.3f, p99 %.3f, max %.3f  (n=%d)"
                 % (ads["median"], ads["p99"], ads["max"], ads["n"]))
    lines.append("")
    lines.append("DOOR VERDICT:")
    med = adm["median"]
    rough = adm["max"] >= 1e-2
    flat = adm["p99"] <= 1e-4
    lines.append("- |dm| p99 <= 1e-4: %s ;  |dm| max >= 1e-2: %s"
                 % (flat, rough))
    if flat and not rough:
        lines.append("- -> STRUCTURAL FLATNESS CONFIRMED at the true single-zero")
        lines.append("  resolution: the margin is flat to its noise floor while S")
        lines.append("  moves ~%.2f per zero-spacing. The 505-point flatness was" % ads["median"])
        lines.append("  never in tension with S roughness -- the margin does not")
        lines.append("  track S (Kfull = -c(x) zeta;  see docs/SOLUTION-SHAPE.md 1b).")
    elif rough:
        lines.append("- -> MARGIN CARRIES ZERO-SCALE STRUCTURE (Door B): re-scope.")
    else:
        lines.append("- -> INTERMEDIATE: inspect the jsonl rows before deciding.")
    with open(OUT, "w") as fo:
        fo.write("\n".join(lines) + "\n")
    print("\n".join(lines))
    print("->", OUT)


if __name__ == "__main__":
    main()
