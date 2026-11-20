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
         104: "ONE-HUNDRED-FOURTH", 105: "ONE-HUNDRED-FIFTH", 106: "ONE-HUNDRED-SIXTH", 107: "ONE-HUNDRED-SEVENTH", 108: "ONE-HUNDRED-EIGHTH", 109: "ONE-HUNDRED-NINTH", 110: "ONE-HUNDRED-TENTH", 111: "ONE-HUNDRED-ELVENTH", 112: "ONE-HUNDRED-TWELFTH", 113: "ONE-HUNDRED-THIRTEENTH", 114: "ONE-HUNDRED-FOURTEENTH", 115: "ONE-HUNDRED-FIFTEENTH", 116: "ONE-HUNDRED-SIXTEENTH", 117: "ONE-HUNDRED-SEVENTEENTH", 118: "ONE-HUNDRED-EIGHTEENTH", 119: "ONE-HUNDRED-NINETEENTH", 120: "ONE-HUNDRED-TWENTIETH", 121: "ONE-HUNDRED-TWENTY-FIRST", 122: "ONE-HUNDRED-TWENTY-SECOND", 123: "ONE-HUNDRED-TWENTY-THIRD", 124: "ONE-HUNDRED-TWENTY-FOURTH"}

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
    109: dict(
        entry="0442",
        hdr_summary=("the 505 000 UNIT ROUND MARK was crossed at CE109 [0442], margin 4 347 (the "
                     "smallest carry-on record, 326 at the W108 seam, landed exactly as predicted "
                     "within this window under either recorded increment family); the 2 160 000 "
                     "CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 995 - the 0441 "
                     "prediction, hit); W109 is the FULL-width 20 000 window with ONE recorded "
                     "Rosser failure - determined and rescued, adjudication-confirmed (fresh 5 / "
                     "5 - 0442); the endpoint record introduces the exponent -84 dyadic family "
                     "(first recorded appearance)"),
        abovept2=("This is the 505 000-unit round-mark crossing (margin 4 347) recorded at CE109 "
                  "(0442): the unit-margin series now stands at 509 347 above tPT2 (the 500 000 "
                  "milestone [0440] carries 9 347). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, adjudication-confirmed fresh 4/4), CE102 (SNAPPED 19 999, "
                  "CLEAN), CE103 (SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full "
                  "20 000, adjudication-confirmed fresh 6/6; 2 060 000 crossed), CE105 (full 20 "
                  "000, adjudication-confirmed fresh 4/4; 2 080 000 crossed), CE106 (full 20 000, "
                  "adjudication-confirmed fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, "
                  "adjudication-confirmed fresh 4/4; 2 120 000 crossed; 500 000 unit mark crossed, "
                  "margin 1), CE108 (full 20 000, first multi-failure window - three failures, "
                  "adjudication-confirmed fresh 5/5 on each; 2 140 000 crossed), CE109 (full 20 "
                  "000, adjudication-confirmed fresh 5/5; 2 160 000 crossed; 505 000 crossed).)"),
        slidetail=("W108 NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all "
                   "determined and rescued, adjudication-confirmed (fresh 5 / 5 on each - 0441) - "
                   "the first multi-failure window; W109 NON-SNAPPED 20 000, ONE recorded interior "
                   "Rosser failure - determined and rescued, adjudication-confirmed (fresh 5 / 5 "
                   "- 0442)"),
    ),
    110: dict(
        entry="0443",
        hdr_summary=("the 510 000 UNIT ROUND MARK was crossed at CE110 [0443], margin 4 020 (the "
                     "expected window of the 0442 record, hit); the 2 180 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 994 - the 0442 prediction, hit); W110 "
                     "is the one-gram SNAP window (19 999) and CLEAN - zero interior Rosser "
                     "failure blocks, nothing to adjudicate (the first clean window since W103); "
                     "census offset moved from -5 to -6"),
        abovept2=("This is the 510 000-unit round-mark crossing (margin 4 020) recorded at CE110 "
                  "(0443): the unit-margin series now stands at 514 020 above tPT2 (the 500 000 "
                  "milestone [0440] carries 9 020). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed).)"),
        slidetail=("W109 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined "
                   "and rescued, adjudication-confirmed (fresh 5 / 5 - 0442); W110 SNAPPED 19 999 "
                   "(one-gram b-end snap), CLEAN - zero interior Rosser failure blocks (nothing "
                   "to adjudicate; certificate by sign-change total)"),
    ),
    111: dict(
        entry="0444",
        hdr_summary=("the 515 000 UNIT ROUND MARK was crossed at CE111 [0444], margin 3 692 (the "
                     "expected window of the 0443 record, hit); the 2 200 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 994 - the 0443 prediction, hit); W111 "
                     "is the FULL-width window and CLEAN - zero interior Rosser failure blocks, "
                     "nothing to adjudicate (second consecutive clean window after W110); the "
                     "floor increment is a recorded 4 672 (endpoint fraction rose .036 -> .971)"),
        abovept2=("This is the 515 000-unit round-mark crossing (margin 3 692) recorded at CE111 "
                  "(0444): the unit-margin series now stands at 518 692 above tPT2 (the 500 000 "
                  "milestone [0440] carries 13 692). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed).)"),
        slidetail=("W110 SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser "
                   "failure blocks (certificate by sign-change total); W111 FULL 20 000, CLEAN - "
                   "zero interior Rosser failure blocks (second consecutive clean window)"),
    ),
    112: dict(
        entry="0445",
        hdr_summary=("the 520 000 UNIT ROUND MARK was crossed at CE112 [0445], margin 3 365 (the "
                     "expected window of the 0444 record, hit); the 2 220 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 994 - the 0444 prediction, hit); W112 "
                     "is the FULL-width window with THREE recorded interior Rosser failures - all "
                     "determined, rescued, and adjudication-confirmed (fresh 4/4, 5/5, 4/4 - the "
                     "SECOND multi-failure window, after W108; Tenth W97-family protocol cycle); "
                     "the endpoint record introduces the exponent -79 dyadic family (first "
                     "recorded appearance)"),
        abovept2=("This is the 520 000-unit round-mark crossing (margin 3 365) recorded at CE112 "
                  "(0445): the unit-margin series now stands at 523 365 above tPT2 (the 500 000 "
                  "milestone [0440] carries 18 365). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed).)"),
        slidetail=("W111 FULL 20 000, CLEAN - zero interior Rosser failure blocks; W112 FULL 20 "
                   "000, THREE recorded interior Rosser failures - all determined and rescued, "
                   "adjudication-confirmed (fresh 4/4, 5/5, 4/4)"),
    ),
    113: dict(
        entry="0446",
        hdr_summary=("the 525 000 UNIT ROUND MARK was crossed at CE113 [0446], margin 3 038 (the "
                     "expected window of the 0445 record, hit); the 2 240 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0445 prediction, hit); W113 "
                     "is the one-gram SNAP window (19 999) with ONE recorded interior Rosser "
                     "failure - determined, rescued on a five-glyph union, adjudication-confirmed "
                     "(fresh 5/5 - ELEVENTH W97-family protocol cycle); the endpoint record "
                     "rotates to the exponent -85 dyadic family"),
        abovept2=("This is the 525 000-unit round-mark crossing (margin 3 038) recorded at CE113 "
                  "(0446): the unit-margin series now stands at 528 038 above tPT2 (the 500 000 "
                  "milestone [0440] carries 28 038). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed).)"),
        slidetail=("W112 FULL 20 000, THREE recorded interior Rosser failures - all determined "
                   "and rescued, adjudication-confirmed (fresh 4/4, 5/5, 4/4); W113 SNAPPED 19 "
                   "999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined "
                   "and rescued, adjudication-confirmed (fresh 5/5)"),
    ),
    114: dict(
        entry="0447",
        hdr_summary=("the 530 000 UNIT ROUND MARK was crossed at CE114 [0447], margin 2 711 (the "
                     "expected window of the 0446 record, hit); the 2 260 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0446 prediction, hit); W114 "
                     "is the FULL-width window with ONE recorded interior Rosser failure - "
                     "determined, rescued on a five-glyph union, adjudication-confirmed (fresh "
                     "4/4 - TWELFTH W97-family protocol cycle); the endpoint record stays in the "
                     "exponent -85 dyadic family (fourth recorded -85 endpoint)"),
        abovept2=("This is the 530 000-unit round-mark crossing (margin 2 711) recorded at CE114 "
                  "(0447): the unit-margin series now stands at 532 711 above tPT2 (the 500 000 "
                  "milestone [0440] carries 32 711). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed).)"),
        slidetail=("W113 SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser "
                   "failure - determined and rescued, adjudication-confirmed (fresh 5/5); W114 "
                   "FULL 20 000, ONE recorded interior Rosser failure - determined and rescued, "
                   "adjudication-confirmed (fresh 4/4)"),
    ),
    115: dict(
        entry="0448",
        hdr_summary=("the 535 000 UNIT ROUND MARK was crossed at CE115 [0448], margin 2 384 (the "
                     "expected window of the 0447 record, hit); the 2 280 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0447 prediction, hit); W115 "
                     "is the FULL-width window and CLEAN - zero interior Rosser failure blocks, "
                     "nothing to adjudicate (third clean window of the post-target series; the "
                     "phase-contribution radius 2.10e-25 is the smallest recorded in the run); "
                     "the endpoint record rotates to the exponent -86 dyadic family"),
        abovept2=("This is the 535 000-unit round-mark crossing (margin 2 384) recorded at CE115 "
                  "(0448): the unit-margin series now stands at 537 384 above tPT2 (the 500 000 "
                  "milestone [0440] carries 37 384). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed).)"),
        slidetail=("W114 FULL 20 000, ONE recorded interior Rosser failure - determined and "
                   "rescued, adjudication-confirmed (fresh 4/4); W115 FULL 20 000, CLEAN - zero "
                   "interior Rosser failure blocks (certificate by sign-change total)"),
    ),
    116: dict(
        entry="0449",
        hdr_summary=("the 540 000 UNIT ROUND MARK was crossed at CE116 [0449], margin 2 057 (the "
                     "expected window of the 0448 record, hit); the 2 300 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0448 prediction, hit); W116 "
                     "is the FULL-width window with TWO recorded interior Rosser failure blocks - "
                     "both determined, rescued, adjudication-confirmed (fresh 4/4, 4/4 - "
                     "THIRTEENTH W97-family protocol cycle; FIRST two-failure window of the post-"
                     "target series); the verify-radius 5.83e-15 is the tightest recorded in the "
                     "run; the endpoint record stays in the exponent -86 dyadic family"),
        abovept2=("This is the 540 000-unit round-mark crossing (margin 2 057) recorded at CE116 "
                  "(0449): the unit-margin series now stands at 542 057 above tPT2 (the 500 000 "
                  "milestone [0440] carries 42 057). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed).)"),
        slidetail=("W115 FULL 20 000, CLEAN - zero interior Rosser failure blocks; W116 FULL 20 "
                   "000, TWO recorded interior Rosser failure blocks - both determined and "
                   "rescued, adjudication-confirmed (fresh 4/4, 4/4)"),
    ),
    117: dict(
        entry="0450",
        hdr_summary=("the 545 000 UNIT ROUND MARK was crossed at CE117 [0450], margin 1 730 (the "
                     "expected window of the 0449 record, hit); the 2 320 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0449 prediction, hit); W117 "
                     "is the FULL-width window with ONE recorded interior Rosser failure - "
                     "determined, rescued on a WIDE SIX-GLYPH union (5/5 - one gram wider than "
                     "the usual rescue spans), adjudication-confirmed (fresh 5/5 - FOURTEENTH "
                     "W97-family protocol cycle); the endpoint record stays in the exponent -86 "
                     "dyadic family (third consecutive)"),
        abovept2=("This is the 545 000-unit round-mark crossing (margin 1 730) recorded at CE117 "
                  "(0450): the unit-margin series now stands at 546 730 above tPT2 (the 500 000 "
                  "milestone [0440] carries 46 730). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed).)"),
        slidetail=("W116 FULL 20 000, TWO recorded interior Rosser failure blocks - both "
                   "determined and rescued (fresh 4/4, 4/4); W117 FULL 20 000, ONE recorded "
                   "interior Rosser failure - determined, rescued on a wide six-glyph union "
                   "(fresh 5/5)"),
    ),
    118: dict(
        entry="0451",
        hdr_summary=("the 550 000 UNIT ROUND MARK was crossed at CE118 [0451], margin 1 403 (the "
                     "expected window of the 0450 record, hit); the 2 340 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0450 prediction, hit); W118 "
                     "is the FULL-width window and CLEAN - zero interior Rosser failure blocks, "
                     "nothing to adjudicate (FOURTH clean window of the post-target series: W110, "
                     "W111, W115, W118); the endpoint record stays in the exponent -86 dyadic "
                     "family - FOURTH CONSECUTIVE -86 endpoint (W115, W116, W117, W118)"),
        abovept2=("This is the 550 000-unit round-mark crossing (margin 1 403) recorded at CE118 "
                  "(0451): the unit-margin series now stands at 551 403 above tPT2 (the 500 000 "
                  "milestone [0440] carries 51 403). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed).)"),
        slidetail=("W117 FULL 20 000, ONE recorded interior Rosser failure - determined, rescued "
                   "on a wide six-glyph union (fresh 5/5); W118 FULL 20 000, CLEAN - zero "
                   "interior Rosser failure blocks (certificate by sign-change total)"),
    ),
    119: dict(
        entry="0452",
        hdr_summary=("the 555 000 UNIT ROUND MARK was crossed at CE119 [0452], margin 1 076 (the "
                     "expected window of the 0451 record, hit); the 2 360 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0451 prediction, hit); W119 "
                     "is the FULL-width window and CLEAN - zero interior Rosser failure blocks, "
                     "nothing to adjudicate (FIFTH clean window of the post-target series: W110, "
                     "W111, W115, W118, W119); the endpoint record rotates BACK to the exponent "
                     "-85 dyadic family after the four-consecutive -86 run (W115-W118)"),
        abovept2=("This is the 555 000-unit round-mark crossing (margin 1 076) recorded at CE119 "
                  "(0452): the unit-margin series now stands at 556 076 above tPT2 (the 500 000 "
                  "milestone [0440] carries 56 076). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed).)"),
        slidetail=("W118 FULL 20 000, CLEAN - zero interior Rosser failure blocks; W119 FULL 20 "
                   "000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change "
                   "total; second consecutive clean window)"),
    ),
    120: dict(
        entry="0453",
        hdr_summary=("the 560 000 UNIT ROUND MARK was crossed at CE120 [0453], margin 749 (the "
                     "expected window of the 0452 record, hit); the 2 380 000 CERTIFIED-ZERO mark "
                     "was CROSSED IN THIS WINDOW (margin 19 993 - the 0452 prediction, hit); W120 "
                     "is the FULL-width window with TWO recorded interior Rosser failure blocks "
                     "- the FIRST FOUR-GRAM failure block (need 3, changes 1) rescued on an EIGHT-"
                     "GLYPH union (7/7 - the widest span and largest rescue need of the series) "
                     "and a standard three-gram block (4/4), both adjudication-confirmed "
                     "(FIFTEENTH W97-family protocol cycle); the endpoint record rotates to the "
                     "exponent -84 dyadic family - the FIFTH post-target family now attested "
                     "(recorded data, no pattern claim)"),
        abovept2=("This is the 560 000-unit round-mark crossing (margin 749) recorded at CE120 "
                  "(0453): the unit-margin series now stands at 560 749 above tPT2 (the 500 000 "
                  "milestone [0440] carries 60 749). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), "
                  "CE120 (full 20 000, two failures including the first four-gram block - fresh "
                  "7/7 + 4/4; 2 380 000 + 560 000 crossed).)"),
        slidetail=("W119 FULL 20 000, CLEAN - zero interior Rosser failure blocks; W120 FULL 20 "
                   "000, TWO recorded interior Rosser failure blocks - both determined and "
                   "rescued (fresh 7/7 on an eight-glyph union, 4/4)"),
    ),
    121: dict(
        entry="0454",
        hdr_summary=("the 565 000 UNIT ROUND MARK was crossed at CE121 [0454], margin 422 (the "
                     "expected window of the 0453 record, hit - the smallest unit-margin crossing "
                     "since the 1-margin 500 000 milestone at W107); the 2 400 000 CERTIFIED-ZERO "
                     "mark was CROSSED IN THIS WINDOW (margin 19 993 - the 0453 prediction, hit); "
                     "W121 is the FULL-width window with TWO recorded interior Rosser failure "
                     "blocks - both determined, both rescued on WIDE SIX-GLYPH unions (5/5, 5/5), "
                     "both adjudication-confirmed (fresh 5/5, 5/5 - SIXTEENTH W97-family protocol "
                     "cycle; THIRD two-failure window); the endpoint record rotates to the "
                     "exponent -82 dyadic family - the SIXTH recorded post-target family (this "
                     "supersedes the W120-time 'fifth and last' statement; erratum addendum "
                     "recorded in 0453)"),
        abovept2=("This is the 565 000-unit round-mark crossing (margin 422) recorded at CE121 "
                  "(0454): the unit-margin series now stands at 565 422 above tPT2 (the 500 000 "
                  "milestone [0440] carries 65 422). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), "
                  "CE120 (full 20 000, two failures including the first four-gram block - fresh "
                  "7/7 + 4/4; 2 380 000 + 560 000 crossed), CE121 (full 20 000, two failures on "
                  "wide six-glyph unions - fresh 5/5, 5/5; 2 400 000 + 565 000 crossed).)"),
        slidetail=("W120 FULL 20 000, TWO recorded interior Rosser failure blocks - both "
                   "determined and rescued (fresh 7/7 on an eight-glyph union, 4/4); W121 FULL "
                   "20 000, TWO recorded interior Rosser failure blocks - both determined and "
                   "rescued on wide six-glyph unions (fresh 5/5, 5/5)"),
    ),
    122: dict(
        entry="0455",
        hdr_summary=("the 570 000 UNIT ROUND MARK was crossed at CE122 [0455], margin 95 (the "
                     "expected window of the 0454 record, hit - the SMALLEST UNIT-MARGIN "
                     "CROSSING SINCE THE 1-MARGIN 500 000 MILESTONE AT W107); the 2 420 000 "
                     "CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 993 - the 0454 "
                     "prediction, hit); W122 is the FULL-width window with TWO recorded interior "
                     "Rosser failure blocks - both determined, one rescued 4/4, the other on "
                     "the series' FIRST SEVEN-GLYPH UNION (need 6, found 6) - adjudication-"
                     "confirmed (fresh 4/4, 6/6 - SEVENTEENTH W97-family protocol cycle; FOURTH "
                     "two-failure window); the endpoint record rotates BACK to the exponent -86 "
                     "dyadic family"),
        abovept2=("This is the 570 000-unit round-mark crossing (margin 95) recorded at CE122 "
                  "(0455): the unit-margin series now stands at 570 095 above tPT2 (the 500 000 "
                  "milestone [0440] carries 70 095). (CE100 was the TAIL window that LANDED the 2 "
                  "000 000 census program target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), "
                  "CE120 (full 20 000, two failures including the first four-gram block - fresh "
                  "7/7 + 4/4; 2 380 000 + 560 000 crossed), CE121 (full 20 000, two failures on "
                  "wide six-glyph unions - fresh 5/5, 5/5; 2 400 000 + 565 000 crossed), CE122 "
                  "(full 20 000, two failures - fresh 4/4 + 6/6 on the first seven-glyph union; "
                  "2 420 000 + 570 000 crossed).)"),
        slidetail=("W121 FULL 20 000, TWO recorded interior Rosser failure blocks - both "
                   "determined and rescued on wide six-glyph unions (fresh 5/5, 5/5); W122 FULL "
                   "20 000, TWO recorded interior Rosser failure blocks - both determined and "
                   "rescued (fresh 4/4, 6/6 on the first seven-glyph union)"),
    ),
    123: dict(
        entry="0456",
        hdr_summary=("the 2 440 000 CERTIFIED-ZERO mark was crossed at CE123 [0456] (margin "
                     "19 993 - the 0455 prediction, hit), while the 575 000 UNIT ROUND MARK was "
                     "NOT crossed: W123 advanced the floor by the SUB-STANDARD 4 672 increment "
                     "(the SEVENTH 4 672 since CE74), leaving 575 000 still 233 ahead (expected "
                     "at W124, entry 0457) - the W122-staged 575 000@W123 prediction was an "
                     "arithmetic slip (4 905 ahead exceeds one standard 4 673 step), corrected "
                     "transparently here and by erratum addendum on entry 0455; W122 was the "
                     "FULL-width window with TWO recorded interior Rosser failure blocks - both "
                     "determined, rescued 4/4 and 6/6 on the series' first seven-glyph union, "
                     "adjudication-confirmed (fresh 4/4, 6/6 - SEVENTEENTH W97-family protocol "
                     "cycle); W123 carries ONE standard three-gram failure, determined and "
                     "rescued 4/4, adjudication-confirmed (EIGHTEENTH cycle); the endpoint "
                     "record rotates to the exponent -85 dyadic family"),
        abovept2=("This window crosses the 2 440 000 CERTIFIED-ZERO mark (margin 19 993) "
                  "recorded at CE123 (0456): the census now stands at 2 459 993 and the "
                  "unit-margin series at 574 767 above tPT2 (the 500 000 milestone [0440] "
                  "carries 74 767; the 575 000 round mark is 233 ahead - expected at W124 "
                  "[0457]). (CE100 was the TAIL window that LANDED the 2 000 000 census program "
                  "target [0421]; the post-target extension continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), "
                  "CE120 (full 20 000, two failures including the first four-gram block - fresh "
                  "7/7 + 4/4; 2 380 000 + 560 000 crossed), CE121 (full 20 000, two failures on "
                  "wide six-glyph unions - fresh 5/5, 5/5; 2 400 000 + 565 000 crossed), CE122 "
                  "(full 20 000, two failures - fresh 4/4 + 6/6 on the first seven-glyph union; "
                  "2 420 000 + 570 000 crossed), CE123 (full 20 000 with a SUB-STANDARD 4 672 "
                  "increment, one failure fresh 4/4; 2 440 000 crossed; 575 000 NOT crossed - "
                  "233 ahead).)"),
        slidetail=("W122 FULL 20 000, TWO recorded interior Rosser failure blocks - both "
                   "determined and rescued (fresh 4/4, 6/6 on the first seven-glyph union); W123 "
                   "FULL 20 000, ONE recorded interior Rosser failure block - determined and "
                   "rescued (fresh 4/4); SUB-STANDARD 4 672 floor increment"),
    ),
    124: dict(
        entry="0457",
        hdr_summary=("the 575 000 UNIT ROUND MARK was crossed at CE124 [0457], margin 4 440 - "
                     "exactly the expected window of the CORRECTED 0456 table (575000, 124, "
                     "[0457]), which thereby VERIFIES the correction of the W122-staging "
                     "arithmetic slip recorded in the entry-0455 erratum addendum; the 2 460 "
                     "000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 993 - as "
                     "tabled); W124 is the FULL-width window with TWO recorded interior Rosser "
                     "failure blocks - both determined, rescued 4/4 and 7/7 (the second "
                     "eight-glyph union of the series, tied with W120 for the widest span), "
                     "adjudication-confirmed (fresh 4/4, 7/7 - NINETEENTH W97-family protocol "
                     "cycle; FIFTH two-failure window); the endpoint record rotates back to the "
                     "exponent -84 dyadic family"),
        abovept2=("This is the 575 000-unit round-mark crossing (margin 4 440) recorded at "
                  "CE124 (0457): the unit-margin series now stands at 579 440 above tPT2 (the "
                  "500 000 milestone [0440] carries 79 440). (CE100 was the TAIL window that "
                  "LANDED the 2 000 000 census program target [0421]; the post-target extension "
                  "continues: "
                  "CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED "
                  "19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 "
                  "060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 "
                  "(full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; "
                  "2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three "
                  "failures - first multi-failure window - fresh 5/5 on each; 2 140 000 "
                  "crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 "
                  "(SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, "
                  "CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - "
                  "fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, "
                  "fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 "
                  "000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 "
                  "crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 "
                  "000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - "
                  "fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 "
                  "+ 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), "
                  "CE120 (full 20 000, two failures including the first four-gram block - fresh "
                  "7/7 + 4/4; 2 380 000 + 560 000 crossed), CE121 (full 20 000, two failures on "
                  "wide six-glyph unions - fresh 5/5, 5/5; 2 400 000 + 565 000 crossed), CE122 "
                  "(full 20 000, two failures - fresh 4/4 + 6/6 on the first seven-glyph union; "
                  "2 420 000 + 570 000 crossed), CE123 (full 20 000, one failure fresh 4/4, "
                  "SUB-STANDARD 4 672 increment; 2 440 000 crossed; 575 000 NOT crossed - 233 "
                  "ahead), CE124 (full 20 000, two failures - fresh 4/4 + 7/7 on the second "
                  "eight-glyph union; STANDARD 4 673 restored; 2 460 000 + 575 000 crossed).)"),
        slidetail=("W123 FULL 20 000, ONE recorded interior Rosser failure block - determined "
                   "and rescued (fresh 4/4); SUB-STANDARD 4 672 floor increment; W124 FULL 20 "
                   "000, TWO recorded interior Rosser failure blocks - both determined and "
                   "rescued (fresh 4/4, 7/7 on the second eight-glyph union)"),
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
