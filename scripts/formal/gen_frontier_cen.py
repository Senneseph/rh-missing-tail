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
UNITW = {97: "NINETY-SEVENTH", 98: "NINETY-EIGHTH", 99: "NINETY-NINTH", 100: "ONE-HUNDREDTH",
         101: "ONE-HUNDRED-FIRST", 102: "ONE-HUNDRED-SECOND", 103: "ONE-HUNDRED-THIRD",
         104: "ONE-HUNDRED-FOURTH", 105: "ONE-HUNDRED-FIFTH", 106: "ONE-HUNDRED-SIXTH", 107: "ONE-HUNDRED-SEVENTH", 108: "ONE-HUNDRED-EIGHTH"}

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
                   "NON-SNAPPED 20 000, THREE recorded interior Rosser\n"
                   "failures - all determined, adjudication-confirmed (fresh 5/5/5)"),
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
                   "failures - all determined, adjudication-confirmed (fresh 5/5/5); W99 "
                   "NON-SNAPPED 20 000 CLEAN"),
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
    101: dict(
        entry="0431",
        hdr_summary=("the 470 000 UNIT ROUND MARK was crossed at CE101 [0431], margin 1 965 - a "
                     "regular round crossing; the 2 020 000 CERTIFIED-ZERO mark lands exactly at "
                     "CE101 (the first 20 000-mark of the post-target extension); the 2 000 000 "
                     "program target had landed at CE100 [0421] - W101 is the first post-target-"
                     "extension window"),
        abovept2=("This is the 470 000-unit round-mark crossing (margin 1 965 - a regular round "
                  "crossing, not one of the series' PREDICTED milestones) recorded at CE101 (0431): "
                  "the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... 455 000 @ CE97, "
                  "460 000 @ CE98, 465 000 @ CE99, 470 000 @ CE101) was tCE - tPT2 in units. (CE100 "
                  "was the TAIL window that landed the 2 000 000 census program target [0421]; the "
                  "crossing lands in the first post-target full window, CE101.)"),
        slidetail=("W100 TAIL 21 (b - a = 21), CLEAN - the landed 2 000 000 census program target "
                   "[0421]; W101 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - "
                   "determined and rescued, adjudication-confirmed (fresh 4 / 4 - 0431)"),
    ),
    102: dict(
        entry="0434",
        hdr_summary=("the 475 000 UNIT ROUND MARK was crossed at CE102 [0434], margin 1 637 - a "
                     "regular round crossing; the census is 2 039 999 (the 2 040 000 mark is 1 zero "
                     "ahead - do not pre-announce); W102 is the SNAPPED 19 999 CLEAN window (the "
                     "SEVENTH recorded 4 672 increment: w101 -> w102)"),
        abovept2=("This is the 475 000-unit round-mark crossing (margin 1 637 - a regular round "
                  "crossing, not one of the series' PREDICTED milestones) recorded at CE102 (0434): "
                  "the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... 460 000 @ CE98, "
                  "465 000 @ CE99, 470 000 @ CE101, 475 000 @ CE102) was tCE - tPT2 in units. (CE100 "
                  "was the TAIL window that landed the 2 000 000 census program target [0421]; the "
                  "post-target extension continues: CE101 (full 20 000, one rescued failure, "
                  "adjudication-confirmed) and CE102 (SNAPPED 19 999, CLEAN).)"),
        slidetail=("W101 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and "
                   "rescued, adjudication-confirmed (fresh 4 / 4 - 0431); W102 SNAPPED 19 999 (the "
                   "requested 20 000 snapped back one gram at the b-end), CLEAN"),
    ),
    103: dict(
        entry="0436",
        hdr_summary=("the 480 000 UNIT ROUND MARK was crossed at CE103 [0436], margin 1 309 - a regular "
                     "round crossing; the 2 040 000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW "
                     "(margin 19 996); W103 is the SNAPPED 19 997 CLEAN window (the EIGHTH recorded "
                     "4 672 increment and the SECOND CONSECUTIVE: w101 -> w102, w102 -> w103 - both "
                     "SNAP-family)"),
        abovept2=("This is the 480 000-unit round-mark crossing (margin 1 309 - a regular round "
                  "crossing, not one of the series' PREDICTED milestones) recorded at CE103 (0436): "
                  "the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... 470 000 @ CE101, "
                  "475 000 @ CE102, 480 000 @ CE103) was tCE - tPT2 in units. (CE100 was the TAIL "
                  "window that LANDED the 2 000 000 census program target [0421]; the post-target "
                  "extension continues: CE101 (full 20 000, one rescued failure, adjudication-confirmed), "
                  "CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED 19 997, CLEAN, the 2 040 000 census "
                  "mark crossed).)"),
        slidetail=("W102 SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), "
                   "CLEAN; W103 SNAPPED 19 997 (the requested 20 000 snapped back three grams at the "
                   "b-end), CLEAN"),
    ),
    104: dict(
        entry="0437",
        hdr_summary=("the 485 000 UNIT ROUND MARK was crossed at CE104 [0437], margin 982 (a regular "
                     "round crossing - the expected window noted in the 0436 record, hit); the 2 060 "
                     "000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 996); W104 is the "
                     "FULL-width 20 000 window with ONE recorded Rosser failure - determined and "
                     "rescued, adjudication-confirmed (fresh 6 / 6 - 0437); the increment returned to "
                     "the STANDARD 4 673 after the consecutive SNAP pair"),
        abovept2=("This is the 485 000-unit round-mark crossing (margin 982 - a regular round "
                  "crossing, whose expected window W104 was noted in the 0436 record) recorded at "
                  "CE104 (0437): the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... "
                  "470 000 @ CE101, 475 000 @ CE102, 480 000 @ CE103, 485 000 @ CE104) was tCE - "
                  "tPT2 in units. (CE100 was the TAIL window that LANDED the 2 000 000 census program "
                  "target [0421]; the post-target extension continues: CE101 (full 20 000, one "
                  "rescued failure, adjudication-confirmed fresh 4/4), CE102 (SNAPPED 19 999, "
                  "CLEAN), CE103 (SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full "
                  "20 000, one rescued failure, adjudication-confirmed fresh 6/6; 2 060 000 "
                  "crossed).)"),
        slidetail=("W103 SNAPPED 19 997 (the requested 20 000 snapped back three grams at the "
                   "b-end), CLEAN (the 2 040 000 census mark crossed mid-window); W104 NON-SNAPPED "
                   "20 000, ONE recorded interior Rosser failure - determined and rescued, "
                   "adjudication-confirmed (fresh 6 / 6 - 0437)"),
    ),
    105: dict(
        entry="0438",
        hdr_summary=("the 490 000 UNIT ROUND MARK was crossed at CE105 [0438], margin 655 (the "
                     "expected window of the 0437 record, hit); the 2 080 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 996); W105 is the FULL-width 20 000 "
                     "window with ONE recorded Rosser failure - determined and rescued, "
                     "adjudication-confirmed (fresh 4 / 4 - 0438)"),
        abovept2=("This is the 490 000-unit round-mark crossing (margin 655 - a regular round "
                  "crossing, whose expected window W105 was noted in the 0437 record) recorded at "
                  "CE105 (0438): the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... "
                  "480 000 @ CE103, 485 000 @ CE104, 490 000 @ CE105) was tCE - tPT2 in units. "
                  "(CE100 was the TAIL window that LANDED the 2 000 000 census program target "
                  "[0421]; the post-target extension continues: CE101 (full 20 000, "
                  "adjudication-confirmed fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 "
                  "(SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, "
                  "adjudication-confirmed fresh 6/6; 2 060 000 crossed), CE105 (full 20 000, "
                  "adjudication-confirmed fresh 4/4; 2 080 000 crossed).)"),
        slidetail=("W104 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined "
                   "and rescued, adjudication-confirmed (fresh 6 / 6 - 0437); W105 NON-SNAPPED "
                   "20 000, ONE recorded interior Rosser failure - determined and rescued, "
                   "adjudication-confirmed (fresh 4 / 4 - 0438)"),
    ),
    106: dict(
        entry="0439",
        hdr_summary=("the 495 000 UNIT ROUND MARK was crossed at CE106 [0439], margin 328 (the "
                     "expected window of the 0438 record, hit); the 2 100 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 996); W106 is the FULL-width 20 000 "
                     "window with ONE recorded Rosser failure - determined and rescued, "
                     "adjudication-confirmed (fresh 5 / 5 - 0439); the endpoint record moved to the "
                     "exponent -83 dyadic family (first recorded appearance)"),
        abovept2=("This is the 495 000-unit round-mark crossing (margin 328 - a regular round "
                  "crossing, whose expected window W106 was noted in the 0438 record) recorded at "
                  "CE106 (0439): the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... "
                  "485 000 @ CE104, 490 000 @ CE105, 495 000 @ CE106) was tCE - tPT2 in units. "
                  "(CE100 was the TAIL window that LANDED the 2 000 000 census program target "
                  "[0421]; the post-target extension continues: CE101 (full 20 000, "
                  "adjudication-confirmed fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 "
                  "(SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, "
                  "adjudication-confirmed fresh 6/6; 2 060 000 crossed), CE105 (full 20 000, "
                  "adjudication-confirmed fresh 4/4; 2 080 000 crossed), CE106 (full 20 000, "
                  "adjudication-confirmed fresh 5/5; 2 100 000 crossed).)"),
        slidetail=("W105 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined "
                   "and rescued, adjudication-confirmed (fresh 4 / 4 - 0438); W106 NON-SNAPPED "
                   "20 000, ONE recorded interior Rosser failure - determined and rescued, "
                   "adjudication-confirmed (fresh 5 / 5 - 0439)"),
    ),
    107: dict(
        entry="0440",
        hdr_summary=("the 500 000 UNIT ROUND MARK - the LARGEST unit milestone of the program - was "
                     "crossed at CE107 [0440] with margin 1 (the expected window of the 0439 record, "
                     "hit); the 2 120 000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin "
                     "19 995); W107 is the one-gram SNAP window (19 999) with ONE recorded Rosser "
                     "failure - determined and rescued, adjudication-confirmed (fresh 4 / 4 - "
                     "0440); the fourth recorded snap window"),
        abovept2=("This is the 500 000-unit round-mark crossing (margin 1 - the largest unit "
                  "milestone of the program, landed with the smallest unit margin recorded for a "
                  "post-target round mark) recorded at CE107 (0440): the unit-milestone series "
                  "(175 000 @ CE38, 200 000 @ CE42B, ... 490 000 @ CE105, 495 000 @ CE106, 500 000 "
                  "@ CE107) was tCE - tPT2 in units. (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, adjudication-confirmed fresh 4/4), CE102 (SNAPPED 19 999, "
                  "CLEAN), CE103 (SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full "
                  "20 000, adjudication-confirmed fresh 6/6; 2 060 000 crossed), CE105 (full 20 "
                  "000, adjudication-confirmed fresh 4/4; 2 080 000 crossed), CE106 (full 20 000, "
                  "adjudication-confirmed fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, "
                  "adjudication-confirmed fresh 4/4; 2 120 000 crossed).)"),
        slidetail=("W106 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined "
                   "and rescued, adjudication-confirmed (fresh 5 / 5 - 0439); W107 SNAPPED 19 999 "
                   "(one-gram b-end snap), ONE recorded interior Rosser failure - determined and "
                   "rescued, adjudication-confirmed (fresh 4 / 4 - 0440)"),
    ),
    108: dict(
        entry="0441",
        hdr_summary=("the 2 140 000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 995; "
                     "the expected window of the 0440 record, hit); W108 is the FULL-width 20 000 "
                     "window with THREE recorded Rosser failures - ALL determined and rescued, "
                     "adjudication-confirmed (fresh 5 / 5 on each - 0441) - the FIRST MULTI-FAILURE "
                     "window of the program; no unit round mark crossed (505 000 is 326 ahead - the "
                     "smallest next-mark carry recorded, expected at W109)"),
        abovept2=("This is the post-500 000-unit-milestone extension recorded at CE108 (0441): "
                  "the unit frontier stands at 504 674 above tPT2 (the 500 000 milestone crossed "
                  "at CE107 [0440] carries 4 674; the next 505 000 mark is 326 ahead). (CE100 was "
                  "the TAIL window that LANDED the 2 000 000 census program target [0421]; the "
                  "post-target extension continues: CE101 (full 20 000, adjudication-confirmed "
                  "fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED 19 997, CLEAN; 2 040 "
                  "000 crossed mid-window), CE104 (full 20 000, adjudication-confirmed fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, adjudication-confirmed fresh 4/4; 2 080 "
                  "000 crossed), CE106 (full 20 000, adjudication-confirmed fresh 5/5; 2 100 000 "
                  "crossed), CE107 (SNAPPED 19 999, adjudication-confirmed fresh 4/4; 2 120 000 "
                  "crossed; 500 000 unit mark crossed, margin 1), CE108 (full 20 000, THREE "
                  "failures - first multi-failure window - adjudication-confirmed fresh 5/5 on "
                  "each; 2 140 000 crossed).)"),
        slidetail=("W107 SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure "
                   "- determined and rescued, adjudication-confirmed (fresh 4 / 4 - 0440); W108 "
                   "NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all determined "
                   "and rescued, adjudication-confirmed (fresh 5 / 5 on each - 0441) - the first "
                   "multi-failure window of the program"),
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
