#!/usr/bin/env python3
"""FrontierCE{N}.lean generator (durable, parametric): rebuilds the endpoint-wiring module
from FrontierCE{N-1}.lean + gen_cen.FACTS[N] + the per-window FRONTR narrative record.

All transformations are anchored/asserted; the invariant middle proof is copied verbatim
except for the mechanical CE{P} -> CE{N} re-anchoring and the two-slice append
(signature tail + census call tail). NO RH CLAIM.

Usage: python3 gen_frontier_cen.py 98
"""
import re
import sys
import gen_cen

ROOT = gen_cen.ROOT
UNITW = {97: "NINETY-SEVENTH", 98: "NINETY-EIGHTH", 99: "NINETY-NINTH", 100: "ONE-HUNDREDTH"}

FRONTR = {
    98: dict(
        entry="0419",
        hdr_summary=("the 460 000 UNIT ROUND MARK was crossed at CE98 [0419], margin 2 614 - a "
                     "regular round crossing; the 1 960 000 CERTIFIED-ZERO mark (crossed at CE98 "
                     "[0419], margin 19 979); 2 000 000 is 20 021 ahead"),
        abovept2=("This is the 460 000-unit round-mark crossing (margin 2 614 - a regular round "
                  "crossing, not one of the series' PREDICTED milestones) recorded at CE98 (0419): "
                  "the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... 450 000 @ "
                  "CE96, 455 000 @ CE97, 460 000 @ CE98) was tCE - tPT2 in units."),
        slidetail=("W97 SNAPPED 19 997, THREE recorded interior Rosser\n"
                   "failures - all determined, adjudication-confirmed (fresh 6/5/5); W98 "
                   "NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined\n"
                   "via the coarse rescue probe; independent adjudication: over-predictions -\n"
                   "zero fresh zeros in the flagged unions; certificate by sign-change total)"),
    ),
    99: dict(
        entry="0420",
        hdr_summary=("the 465 000 UNIT ROUND MARK was crossed at CE99 [0420], margin 2 287 - a "
                     "regular round crossing; the 1 980 000 CERTIFIED-ZERO mark (crossed at CE99 "
                     "[0420], margin 19 979); 2 000 000 is 21 ahead"),
        abovept2=("This is the 465 000-unit round-mark crossing (margin 2 287 - a regular round "
                  "crossing, not one of the series' PREDICTED milestones) recorded at CE99 "
                  "(0420): the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... "
                  "455 000 @ CE97, 460 000 @ CE98, 465 000 @ CE99) was tCE - tPT2 in units."),
        slidetail=("W98 NON-SNAPPED 20 000, THREE recorded interior Rosser\n"
                   "failures (determined via the coarse rescue probe; independent adjudication: "
                   "over-\npredictions - zero fresh zeros in the flagged unions; certificate by "
                   "sign-change total);\nW99 NON-SNAPPED 20 000 CLEAN"),
    ),
    100: dict(
        entry="0421",
        hdr_summary=("the 2 000 000 CERTIFIED-ZERO TARGET LANDED AT CE100 (1 999 979 + 21 = "
                     "2 000 000, margin 0 - the census program is complete); the 465 000 UNIT "
                     "ROUND MARK (crossed at CE99 [0420]) carries 2 292; the 1 980 000 "
                     "CERTIFIED-ZERO mark (crossed at CE99 [0420]) carries 19 979"),
        abovept2=("The frontier carries the 465 000-unit round-mark crossing (recorded at CE99 "
                  "[0420]; margin at CE100: 2 292): the unit-milestone series (175 000 @ CE38, "
                  "200 000 @ CE42B, ... 460 000 @ CE98, 465 000 @ CE99) was tCE - tPT2 in units."),
        slidetail=("W99 NON-SNAPPED 20 000 CLEAN; W100 TAIL 21 (b - a = 21), CLEAN - the final "
                   "short window of the 2 000 000 census program"),
    ),
}


def fmt(x):
    return f"{x:,}".replace(",", " ")


def gen(N):
    F = gen_cen.FACTS[N]
    R = FRONTR[N]
    P = N - 1
    gap = F["gap"]
    src = open(f"{ROOT}/FrontierCE{P}.lean").read()

    hdr = f"""/-
**FrontierCE{N} - The endpoint at the CE{N} census frontier (lane M5, route (b) wired
into the endpoint squeeze): H = tCE{N} = tPT2 + {fmt(gap)} = {fmt(F['tCE'])}.

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
    (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {fmt(gap)} (norm_num): the in-tree
    CERTIFIED census frontier (the {N} windows, {F['census']} zeros over
    (g_a1, g_b{N}]) sits strictly ABOVE both the cited Platt-Trudgian
    frontier and the prior tCE{P} wiring frontier.

  * rh_program78_frontier_CE{N} - THE ENDPOINT AT THE CENSUS FRONTIER:
    the same endpoint holds with H = tCE{N}; the census input is
    CE{N}.allOnLineUpToCE{N} (tPT2 + the {N + 1} verified window-slice
    clauses), and the residue (hs1, hs3, hWin) lives STRICTLY ABOVE
    {fmt(F['tCE'])} = tPT2 + {fmt(gap)}. The endpoint frontier is now
    driven by the CERTIFIED CENSUS at the CE{N} frontier ({R['hdr_summary']}).

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
import RhAttack.CE{P - 1}
import RhAttack.CE{P}
import RhAttack.CE{N}

open Real B0 P12
open Complex

namespace FrontierCE{N}

/-- THE FRONTIER ORDER (machine, norm_num): the CERTIFIED census frontier
tCE{N} (the {UNITW[N]} window, {F['census']} zeros over (g_a1, g_b{N}]) sits
strictly ABOVE the Platt-Trudgian growth-wire frontier tPT2, with the EXACT
margin tCE{N} - tPT2 = {fmt(gap)}. {R['abovept2']} -/
theorem ce{N}AbovePT2 : WinC.tPT2 < (CE{N}.tCE{N} : ℝ) := by
  norm_num [WinC.tPT2, CE{N}.tCE{N}]

/-- THE EXACT MARGIN (machine, norm_num): (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {gap}. -/
theorem ce{N}PT2Margin : (CE{N}.tCE{N} : ℝ) - WinC.tPT2 = {gap} := by
  norm_num [WinC.tPT2, CE{N}.tCE{N}]
"""

    # ---- body: the reanchor/endpoint theorems, transformed from the source
    i = src.index("/-- THE RE-ANCHORED TERMINAL FACE DISCHARGES THE hWin RESIDUAL")
    assert src.rstrip().endswith(f"end FrontierCE{P}")
    body = src[i:].rstrip()
    assert body.endswith(f"end FrontierCE{P}")
    body = body[: -len(f"end FrontierCE{P}")]

    def br(old, new, label, nmin=1):
        nonlocal body
        c = body.count(old)
        assert c >= nmin, f"frontier body: {label}: count {c} < {nmin}: {old[:70]!r}"
        body = body.replace(old, new)

    # mechanical re-anchoring (order matters: qualified first, then bare)
    br(f"CE{P}.tCE{P}", f"CE{N}.tCE{N}", "CE.tCE qualified")
    br(f"CE{P}.terminalFaceCE{P}", f"CE{N}.terminalFaceCE{N}", "CE.terminalFace qualified")
    br(f"terminalFaceCE{P}", f"terminalFaceCE{N}", "terminalFace bare")
    br(f"CE{P}.allOnLineUpToCE{P}", f"CE{N}.allOnLineUpToCE{N}", "CE.allOnLineUpTo qualified")
    # engine theorem name: normalize whatever generation left behind
    # (fresh CE{P} or a stale earlier number) to CE{N}
    _before = body.count("rh_program78_frontier_CE")
    body = re.sub(r"rh_program78_frontier_CE\d+", f"rh_program78_frontier_CE{N}", body)
    assert body.count(f"rh_program78_frontier_CE{N}") >= 1 and _before >= 1, \
        f"frontier body: engine rename: before {_before}"
    if f"allOnLineUpToCE{P}" in body:
        br(f"allOnLineUpToCE{P}", f"allOnLineUpToCE{N}", "allOnLineUpTo bare")
    br(f"hs1CE{P}", f"hs1CE{N}", "hs1")
    br(f"hs3CE{P}", f"hs3CE{N}", "hs3")
    br(f"hWinCE{P}", f"hWinCE{N}", "hWin")
    br(f"tCE{P}", f"tCE{N}", "tCE bare")

    # signature tail: append the two new clauses
    sig_old = (f"(hW{P - 1} : CE{P - 1}.ce{P - 2}WinClauseFull) (hW{P} : CE{P}.ce{P - 1}WinClauseFull) "
               f"(hW{P + 1} : CE{P}.ce{P}WinClause)\n")
    sig_new = (f"(hW{P - 1} : CE{P - 1}.ce{P - 2}WinClauseFull) (hW{P} : CE{P}.ce{P - 1}WinClauseFull) "
               f"(hW{P + 1} : CE{N}.ce{P}WinClauseFull) (hW{P + 2} : CE{N}.ce{N}WinClause)\n")
    br(sig_old, sig_new, "signature tail")

    # census call tail: append hW{P+2}
    br(f"hW{P + 1} hqzCensus", f"hW{P + 1} hW{P + 2} hqzCensus", "call tail")

    # the CENSUS description sentence (from 'and the CE.. CENSUS (the tPT2 base plus' to '),\nRH q follows')
    m = re.search(r"and the CE\d+ CENSUS \(the tPT2 base plus\n.*?\),\nRH q follows", body, re.DOTALL)
    assert m, "endpoint census sentence not found"
    census_new = (
        f"and the CE{N} CENSUS (the tPT2 base plus\n"
        f"the {N + 1} verified window-slice clauses - windows 1..{N}, the corrected w1-w{N}\n"
        f"band with the W42b fill, re-anchored 43..{N} bit-identical at their seams;\n"
        f"W95 NON-SNAPPED 20 000 with two recorded interior failures, both determined\n"
        f"and rescued; W96 NON-SNAPPED 20 000 CLEAN; {R['slidetail']}),\n"
        f"RH q follows"
    )
    body = body[:m.start()] + census_new + body[m.end():]

    # the residue line
    m = re.search(r"THE RESIDUE\nLIVES STRICTLY ABOVE .*?\n\(g_a1, g_b\d+\]\), not by", body, re.DOTALL)
    assert m, "residue line not found"
    residue_new = (f"THE RESIDUE\nLIVES STRICTLY ABOVE {fmt(F['tCE'])} = tPT2 + {fmt(gap)}: the "
                   f"endpoint\nfrontier is now driven by the CERTIFIED CENSUS ({F['census']} zeros "
                   f"over\n(g_a1, g_b{N}]), not by")
    body = body[:m.start()] + residue_new + body[m.end():]

    body += f"end FrontierCE{N}\n"

    # ---- stale-token sweep
    for tok in [f"CE{P}.ce{P}WinClause", f"hs1CE{P}", f"hs3CE{P}", f"hWinCE{P}", f"tCE{P}",
                f"FrontierCE{P}", f"allOnLineUpToCE{P}", f"terminalFaceCE{P}"]:
        assert tok not in body, f"stale token survived: {tok!r}"
    assert f"CE{P}." in body  # the signature intentionally keeps CE{P-1}./CE{P}. refs to earlier modules

    out = hdr + body
    open(f"{ROOT}/FrontierCE{N}.lean", "w").write(out)
    print(f"wrote {ROOT}/FrontierCE{N}.lean ({len(out)} chars)")


if __name__ == "__main__":
    N = int(sys.argv[1])
    gen(N)
