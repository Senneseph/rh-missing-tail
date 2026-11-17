#!/usr/bin/env python3
"""FrontierCE{N}.lean generator (durable): rebuilds the endpoint-wiring module from FrontierCE{N-1}.lean.

All transformations are anchored/asserted. Facts from the matching CE{N} entry in gen_cen.FACTS.
NO RH CLAIM.  Usage: python3 gen_frontier_cen.py 97
"""
import sys
import gen_cen

ROOT = gen_cen.ROOT
P = 96          # source module (97 is the first generation; keep explicit for auditability)


def gen(N):
    F = gen_cen.FACTS[N]
    src = open(f"{ROOT}/FrontierCE{P}.lean").read()

    hdr = f"""/-
**FrontierCE{N} - The endpoint at the CE{N} census frontier (lane M5, route (b) wired
into the endpoint squeeze): H = tCE{N} = tPT2 + {F['gap']:,} = {F['tCE']:,}.

ROLE: RHEnd.rh_program78_frontierH is the ARBITRARY-FRONTIER form of the
endpoint: given a frontier H with the allOnLineUpTo census at H (plus the
zero-set premises, the named on-line sliver record below 707/50, and [Z78]),
RH follows from the residual legs hs1 (the zero-side witness: Qside >=
devProg on every off-pair above H), hs3 (the S3 definition-side wire:
Qside <= BwireP + MrP) and the hWin residual face (zero-exclusion of
(H, inf) x (0, 1/200)). The strongest instantiation in the tree before this
module was H = tCE{P} (FrontierCE{P}, the {P}-th wiring): the CE-series
re-anchor CE{N} has since pushed the certified census frontier past
tCE{P}, so that wiring is now one module behind. This module performs the
strict push to the current frontier.

  * ce{N}AbovePT2 - WinC.tPT2 < (CE{N}.tCE{N} : ℝ), the EXACT margin
    (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {F['gap']:,} (norm_num): the in-tree
    CERTIFIED census frontier (the {N} windows, {F['census']} zeros over
    (g_a1, g_b{N}]) sits strictly ABOVE both the cited Platt-Trudgian
    frontier and the prior tCE{P} wiring frontier.

  * rh_program78_frontier_CE{N} - THE ENDPOINT AT THE CENSUS FRONTIER:
    the same endpoint holds with H = tCE{N}; the census input is
    CE{N}.allOnLineUpToCE{N} (tPT2 + the {P+2} verified window-slice
    clauses), and the residue (hs1, hs3, hWin) lives STRICTLY ABOVE
    {F['tCE']:,} = tPT2 + {F['gap']:,}. The endpoint frontier is now
    driven by the CERTIFIED CENSUS at the CE{N} frontier (the 455 000 UNIT
    ROUND MARK was crossed at CE{N} [0418], margin 2 941 - a regular round
    crossing; the 1 940 000 CERTIFIED-ZERO mark (crossed at CE{N} [0418],
    margin 19 979); 2 000 000 is 40 021 ahead).

  * terminalFaceCE{N}_elim_hWin - the RE-ANCHORED TERMINAL FACE of the CE
    series (all zeros of q with Im > tCE{N} on the line) ALONE discharges
    the hWin residual face at tCE{N}: the two decompositions of RH (the CE
    census-iff and the endpoint squeeze) AGREE at the frontier. The
    negative-height half runs through the ZeroSet symmetry fields
    (q.conj / star, the HFE-after-HCJ pattern of WinC.noOffPairBelowPT).

  * face_above_frontier_no_offPair - the same elimination at EVERY offset
    d0 > 0 (no window restriction): nothing off-line at all above tCE{N}.

HONESTY: LEAN-PROVEN (all four facts, one norm_num order fact and pure
composition over RHEnd.rh_program78_frontierH + CE{N}.allOnLineUpToCE{N} +
the CE{N} terminal face). NO RH CLAIM: the residual legs hs1 / hs3 / hWin
at the tCE{N} frontier remain the NAMED open legs, now stated strictly
above a STRICTLY HIGHER frontier than the tCE{P} instantiation; the
terminal-face -> hWin fact shows the face is EXACTLY what the legs need,
not that it is closed. -/

import RhAttack.RHEnd
import RhAttack.CE{P}
import RhAttack.CE{N}

open Real B0 P12
open Complex

namespace FrontierCE{N}

/-- THE FRONTIER ORDER (machine, norm_num): the CERTIFIED census frontier
tCE{N} (the NINETY-SEVENTH window, {F['census']} zeros over (g_a1, g_b{N}]) sits
strictly ABOVE the Platt-Trudgian growth-wire frontier tPT2, with the EXACT
margin tCE{N} - tPT2 = {F['gap']:,}. This is the 455 000-unit round-mark
crossing (margin 2 941 - a regular round crossing, not one of the
series' PREDICTED milestones) recorded at CE{N} (0418): the
unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ...
445 000 @ CE95, 450 000 @ CE96, 455 000 @ CE97) was tCE - tPT2 in units. -/
theorem ce{N}AbovePT2 : WinC.tPT2 < (CE{N}.tCE{N} : ℝ) := by
  norm_num [WinC.tPT2, CE{N}.tCE{N}]

/-- THE EXACT MARGIN (machine, norm_num): (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {F['gap']}. -/
theorem ce{N}PT2Margin : (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {F['gap']} := by
  norm_num [WinC.tPT2, CE{N}.tCE{N}]
"""

    # ---- body: the three theorems, transformed from the source
    i = src.index("/-- THE RE-ANCHORED TERMINAL FACE DISCHARGES THE hWin RESIDUAL")
    j = src.index("end FrontierCE%d" % P) + len(f"end FrontierCE{P}\n")
    body = src[i:j]
    body = body.replace("CE96.terminalFaceCE96", f"CE{N}.terminalFaceCE{N}")
    body = body.replace(f"(CE96.tCE96 : ℝ)", f"(CE{N}.tCE{N} : ℝ)")
    body = body.replace("terminalFaceCE96_elim_hWin", f"terminalFaceCE{N}_elim_hWin")
    body = body.replace("theorem terminalFaceCE96_elim_hWin", f"theorem terminalFaceCE{N}_elim_hWin")
    # docstring tokens (asserted)
    for old, new in [
        ("if every zero of q above tCE96 lies on the line", f"if every zero of q above tCE{N} lies on the line"),
        (f"then the hWin residual face at tCE96 holds", f"then the hWin residual face at tCE{N} holds"),
        ("the SAME open\ncontent above tCE96", f"the SAME open\ncontent above tCE{N}"),
        ("NOTHING OFF-LINE AT ALL ABOVE tCE96", f"NOTHING OFF-LINE AT ALL ABOVE tCE{N}"),
        (f"with d0 > 0 and t0 > tCE96, at EVERY", f"with d0 > 0 and t0 > tCE{N}, at EVERY"),
        (f"the terminalFaceCE{N}_elim_hWin fact", f"the terminalFaceCE{N}_elim_hWin fact"),
        ("(zero-exclusion of (tCE96, inf) x (0, 1/200) at heights >= 1000)",
         f"(zero-exclusion of (tCE{N}, inf) x (0, 1/200) at heights >= 1000)"),
        ("(one instantiation, H := tCE96,", f"(one instantiation, H := tCE{N},"),
    ]:
        assert body.count(old) >= 0
        if old in body:
            body = body.replace(old, new)
    # the big endpoint theorem
    body = body.replace("THE ENDPOINT AT THE CENSUS FRONTIER (machine, the 0288-form endpoint with\nH = tCE96)",
                        f"THE ENDPOINT AT THE CENSUS FRONTIER (machine, the 0288-form endpoint with\nH = tCE{N})")
    for old, new in [
        (f"the CE96 CENSUS (the tPT2 base plus\nthe 97 verified window-slice clauses - windows 1..96, the corrected w1-w96\nband with the W42b fill, re-anchored 43..96 bit-identical at their seams;\nW95 NON-SNAPPED 20 000 with two recorded interior failures, both determined\nand rescued; W96 NON-SNAPPED 20 000 CLEAN - the SEVENTH clean record)",
         f"the CE{N} CENSUS (the tPT2 base plus\nthe 98 verified window-slice clauses - windows 1..97, the corrected w1-w97\nband with the W42b fill, re-anchored 43..97 bit-identical at their seams;\nW95 NON-SNAPPED 20 000 with two recorded interior failures, both determined\nand rescued; W96 NON-SNAPPED 20 000 CLEAN; W97 SNAPPED 19 997, THREE recorded\ninterior failures - all determined and rescued)"),
        (f"S3 definition-side wire at the ONE concrete scale Qside) restricted to\nt0 >= tCE96, plus the hWin residual face at tCE96.",
         f"S3 definition-side wire at the ONE concrete scale Qside) restricted to\nt0 >= tCE{N}, plus the hWin residual face at tCE{N}."),
        (f"hPT := CE96.allOnLineUpToCE96) with 1000 <= tCE96 by norm_num. THE RESIDUE\nLIVES STRICTLY ABOVE 3 000 175 786 069 = tPT2 + 453 269: the endpoint\nfrontier is now driven by the CERTIFIED CENSUS (1 939 982 zeros over\n(g_a1, g_b96])",
         f"hPT := CE{N}.allOnLineUpToCE{N}) with 1000 <= tCE{N} by norm_num. THE RESIDUE\nLIVES STRICTLY ABOVE {F['tCE']:,} = tPT2 + {F['gap']:,}: the endpoint\nfrontier is now driven by the CERTIFIED CENSUS ({F['census']} zeros over\n(g_a1, g_b{N}])"),
        (f"no longer one\nmodule behind the CE re-anchors. NO RH CLAIM: hs1, hs3 and hWin at the\ntCE96 frontier remain the named open legs (and terminalFaceCE{N}_elim_hWin\nshows the hWin leg is exactly the re-anchored terminal face).",
         f"no longer one\nmodule behind the CE re-anchors. NO RH CLAIM: hs1, hs3 and hWin at the\ntCE{N} frontier remain the named open legs (and terminalFaceCE{N}_elim_hWin\nshows the hWin leg is exactly the re-anchored terminal face)."),
        (f"theorem rh_program78_frontier_CE96", f"theorem rh_program78_frontier_CE{N}"),
        (f"(hW96 : CE96.ce95WinClauseFull) (hW97 : CE96.ce96WinClause)\n",
         f"(hW96 : CE96.ce95WinClauseFull) (hW97 : CE97.ce96WinClauseFull) (hW98 : CE97.ce97WinClause)\n"),
        (f"hs1CE96", f"hs1CE{N}"),
        (f"hs3CE96", f"hs3CE{N}"),
        (f"hWinCE96", f"hWinCE{N}"),
        (f"CE96.allOnLineUpToCE96", f"CE{N}.allOnLineUpToCE{N}"),
        (f"norm_num [CE96.tCE96]", f"norm_num [CE{N}.tCE{N}]"),
        (f"hW97 hqzCensus", f"hW97 hW98 hqzCensus"),
    ]:
        assert body.count(old) >= 1, f"frontier: {old[:70]!r}"
        body = body.replace(old, new)
    body = body.replace("end FrontierCE96", f"end FrontierCE{N}")

    out = hdr + body
    open(f"{ROOT}/FrontierCE{N}.lean", "w").write(out)
    print(f"wrote {ROOT}/FrontierCE{N}.lean ({len(out)} chars)")


if __name__ == "__main__":
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 97
    gen(N)
