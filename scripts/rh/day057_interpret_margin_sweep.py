#!/usr/bin/env python3
"""
day057_interpret_margin_sweep.py

Interpret the day056 single-zero margin sweep
(tmp/day056_margin_sweep.jsonl) and adjudicate the E19
flat-at-zeros clause:

  - roughness statistics of the MARGIN (mnew) at the
    single-zero t-step (0.025), per anchor;
  - compared with (a) the S-side roughness measured by
    s0_singlezero_swalk (median |dS| ~ 0.08-0.25 in S units,
    crossing jumps ~0.92) and (b) the 505-point ledger
    flatness (~3e-4 at 0.5 t-shifts = 20x coarser);
  - verdict: if |dm| stays at the 505-level (~1e-4 or below)
    while S is moving at S-scale, the margin flatness is an
    S-INSENSITIVITY property of the certificate -> the flat
    clause question moves to the main-term (G = C log) side;
    if |dm| shows S-scale roughness (relative deltas of
    order the S deltas), the certificate inherits the S
    roughness and P1/P2 give the in-data refutation of the
    flat clause at leading order.

Read-only.  No engine import.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
SWEEP = os.path.join(ROOT, "tmp", "day056_margin_sweep.jsonl")
S_SIDE = os.path.join(ROOT, "tmp", "s0_singlezero_swalk.json")
OUTMD = os.path.join(HERE, "out_day056_interpret.md")


def stats(deltas):
    if not deltas:
        return None
    ad = sorted(abs(d) for d in deltas)
    n = len(ad)
    med = ad[n // 2]
    mean = sum(ad) / n
    p99 = ad[min(n - 1, int(0.99 * (n - 1)))]
    mx = ad[-1]
    return dict(n=n, median=med, mean=mean, p99=p99, max=mx,
                rel_max=mx)


def main():
    rows = [json.loads(l) for l in open(SWEEP) if l.strip()]
    cc = [r for r in rows if r["role"] == "crosscheck"]
    grid = [r for r in rows if r["role"] == "grid"]

    out = []
    out.append("# day056 single-zero margin sweep -- interpretation\n")
    out.append("## 1. Cross-check (fast dps-30 chain vs certified ledger mnew)\n")
    ok = True
    for r in cc:
        out.append(f"- anchor x={r['anchor']:.6e}  t={r['t']:.6f}  "
                   f"ledger mnew={r['mnew_ledger']:.9f}  "
                   f"fast mnew={r['mnew_fast']:.9f}  "
                   f"|d|={abs(r['mnew_ledger'] - r['mnew_fast']):.3e}")
        if abs(r['mnew_ledger'] - r['mnew_fast']) > 1e-9:
            ok = False
    out.append(f"\nVERDICT cross-check: {'PASS (< 1e-9 at all rows)' if ok else 'FAIL'}\n")
    if not ok:
        out.append("FAST CHAIN MISMATCH -- grid rows are NOT comparable. "
                   "Stop here; audit the fast path first.")
        open(OUTMD, "w").write("\n".join(out))
        print(open(OUTMD).read())
        sys.exit(1)

    out.append("## 2. Margin roughness at the single-zero t-step (0.025)\n")
    # S-side reference
    sref = {}
    if os.path.exists(S_SIDE):
        sj = json.load(open(S_SIDE))
        for key, v in sj.items():
            sref[key] = v

    for x in sorted(set(r["anchor"] for r in grid)):
        pts = sorted([r for r in grid if abs(r["anchor"] - x) < 1e-6], key=lambda r: r["t"])
        ms = [r["mnew_fast"] for r in pts]
        ts = [r["t"] for r in pts]
        dm = [b - a for a, b in zip(ms, ms[1:])]
        s1 = stats(dm)
        rel = [abs(d) / m for d, m in zip(dm, ms[1:])]
        srel = stats(rel)
        out.append(f"### anchor x = {x:.6e}  (n={len(pts)})")
        out.append(f"- mnew range: {min(ms):.6f} .. {max(ms):.6f} "
                   f"(span {max(ms) - min(ms):.3e} over "
                   f"{ts[-1] - ts[0]:.3f} t-units)")
        out.append(f"- |dm| per 0.025-step: median={s1['median']:.3e}  "
                   f"mean={s1['mean']:.3e}  p99={s1['p99']:.3e}  "
                   f"max={s1['max']:.3e}")
        out.append(f"- |dm|/m (relative) per step: median={srel['median']:.3e}  "
                   f"mean={srel['mean']:.3e}  p99={srel['p99']:.3e}  "
                   f"max={srel['max']:.3e}")
        out.append("")

    out.append("## 3. Comparison (the adjudication)\n")
    out.append("S-side single-zero roughness (s0_singlezero_swalk, same 0.025 step):")
    for key, v in sref.items():
        out.append(f"- {key}: median |dS| = {v.get('median|dS|'):.4f}, "
                   f"mean = {v.get('mean|dS|'):.4f}, max = {v.get('max|dS|'):.4f}, "
                   f"p99 = {v.get('p99|dS|'):.4f},  "
                   f"steps > 0.5 = {v.get('steps|dS|>0.5')},  "
                   f"zero-cross steps (> pi/3) = {v.get('steps|dS|>pi/3 (zero-cross)')},  "
                   f"total S change / 5 units = {v.get('total S change over 5 units'):.4f},  "
                   f"P2-scale per-spacing (log read) = {v.get('P2-style per-spacing (log read)'):.4f}")
    out.append("")
    out.append("505-point ledger flatness (0.5 t-shifts = 20x coarser): "
               "adjacent |dm| max ~ 3.19e-4.")
    out.append("")
    out.append("DECISION RULES:")
    out.append("- if grid |dm| median/p99 stays <= ~1e-4 (the 505-level) at the")
    out.append("  0.025 step while S moves ~0.08-0.25 per step: the margin is")
    out.append("  FLAT at true zero resolution -> S-insensitivity property of the")
    out.append("  certificate; the flat-clause question moves to the main-term")
    out.append("  (G = C log) side (see forensics 3.10). P1 Prop 1.5 predicts")
    out.append("  the leading sqrt(loglog) S-fluctuation cannot cancel at leading")
    out.append("  order, so any observed flatness is a secondary-term effect.")
    out.append("- if grid |dm| shows S-scale roughness (relative deltas ~0.1 or")
    out.append("  occasional ~0.9 jumps aligned with S crossings of step j): the")
    out.append("  margin inherits the S roughness at zero resolution; the E19")
    out.append("  flat clause is REFUTED in this data by the in-data deltas, and")
    out.append("  the published theorem backstop is P1 (theorem, RH-conditional")
    out.append("  barrier support) + P2 Thm 1 (zero-scale oscillation, RH,")
    out.append("  effective).")
    out.append("- intermediate: compare the |dm| peak positions against zero")
    out.append("  crossings (from the S walk json if present); alignment =>")
    out.append("  S-driven; no alignment => independent roughness (flag it).")

    open(OUTMD, "w").write("\n".join(out))
    print(open(OUTMD).read())


if __name__ == "__main__":
    main()
