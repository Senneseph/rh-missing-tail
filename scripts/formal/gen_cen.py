#!/usr/bin/env python3
"""CE-series formalizer generator (durable; replaces the per-unit /tmp scripts lost in the 2026-11-16 reboot).

CE{N}.lean is rebuilt from CE{N-1}.lean by segment surgery: invariant middle material (the h1..hN-2
signature prefixes, the nested by_cases band proof up to its last seam level, the terminal-face section
core) is COPIED from the source; dynamic sections are regenerated from per-window FACTS. Every splice
and docstring-refresh is anchored/asserted against the source file at run time. Facts are
run/verifier/dyadic records; nothing analytic. NO RH CLAIM.

Usage: python3 gen_cen.py 97     (CE module only; FrontierCE97 is generated separately)
"""
import re
import sys

ROOT = "/home/jsmille/Projects/rh-missing-tail/formal/RhAttack"
SNAPS = [46, 54, 66, 78, 87, 97]   # target window k: tCE{k} - tCE{k-1} = 4672 (window k ran SNAPPED)


def shrink(k):
    # tCE{k} - tCE{k-1}: 4672 on the recorded SNAP windows, the TAIL increment (5) at W100,
    # the usual 4673 otherwise. FACTS overrides where present (authoritative per window).
    if k in FACTS:
        return FACTS[k]["incr"]
    return 4672 if k in SNAPS else 4673


FACTS = {
    97: dict(
        N=97, tCE=3000175790741, gap=457941, prevgap=453269,
        gal=300017579074131, gden=100, galstr="300017579074131 / 100",
        frac="0.31029939748195319047641737... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.00029939748195319048 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 377 112", b="12 363 155 397 109",
        ga_b="[58031839538584355507012194662551424509, -84, 16777217, -110]",
        gb_b="[232127358515834031428417063231834812061, -86, 16777217, -110]",
        width="SNAPPED 19 997", widthnum=19997, census="1 959 979", censusnum=1959979,
        censusprev="1 939 982", censusprevnum=1939982,
        widthprev_desc="NON-SNAPPED 20 000, CLEAN - zero recorded interior Rosser failure blocks",
        evals="34 749", seconds="2 653.8", cache="0",
        runs="52 / 49", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=3,
        faildesc=("THREE recorded interior Rosser failure blocks, ALL DETERMINED TRUE and rescued: "
                  "block [12 363 155 382 326, 12 363 155 382 330] (need 4 / changes 2 at 257 points, m = 64; "
                  "rescue union [12 363 155 382 325, 12 363 155 382 331] at m = 8 found all 6 required sign "
                  "changes); block [12 363 155 384 232, 12 363 155 384 235] (need 3 / changes 1 at 193 points, "
                  "m = 64; rescue union [12 363 155 384 231, 12 363 155 384 236] at m = 16 found all 5 required "
                  "sign changes); block [12 363 155 384 383, 12 363 155 384 385] (need 2 / changes 0 at 129 "
                  "points, m = 64; rescue union [12 363 155 384 381, 12 363 155 384 386] at m = 4 found all 5 "
                  "required sign changes)"),
        win_n_clean=42, win_n_rescue=55, total_fail=83,
        incr=4672,
        mile=("the 455 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 97 (tCE97 - tPT2 = 457 941, "
              "margin 2 941 - a regular round crossing: not one of the series' PREDICTED milestones [the second "
              "@ W80, third @ W85 and fourth @ W90 were the only predictions claimed, and all landed; the fifth "
              "is not predicted - no pattern claimed]); the next round mark 460 000 is 2 059 ahead (less than "
              "one full step - compute at that window, do not pre-announce)"),
        censmarks=("the 1 940 000 CERTIFIED-ZERO MARK was CROSSED in THIS WINDOW, WINDOW 97 (margin 19 "
                   "979); the next round mark 1 960 000 is 21 ahead (less than one window - compute at that "
                   "window, do not pre-announce); the 1 920 000 mark (crossed W96) carries 39 979; the 1 900 "
                   "000 mark (crossed W95 [0410]) carries 59 979"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97},
        unit="NINETY-SEVENTH", family="-86",
        ord_word="thirty-second", nw=6,
        run_note=("a fresh run with resumed_from_cache = 0 (NOT seeded - the first unseeded overlap run "
                  "of the current stretch; logged for provenance) after the 2026-11-16 host reboot"),
        parallel_note=(" Window 97 RAN WHILE the formal units 0414-0417 (SIs / SIsA1 / TerminalFaceCE96 / "
                       "Face38PosReserve) reached GREEN; the per-unit critical path is max(run, formalization)."),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication of the 3 rescued "
                     "spans (0418 audit record: separate engine, corrected phase convention, dense scan with "
                     "refined crossing checks, plus unflagged control spans) re-confirms each rescue count "
                     "from outside the pipeline."),
        shrink_note=("THE SNAP INCREMENT: W97 ran SNAPPED 19 997 (certified b = 12 363 155 397 109, 19 997 "
                     "zeros) with 3 recorded interior Rosser failure blocks (all determined and rescued); "
                     "the floor advances by 4672. The six recorded 4 672 INCREMENT occurrences are "
                     "w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], "
                     "w97 -> this step [SNAP] - no pattern claim beyond the recorded data."),
        incr_note=("the SNAP increment - W97 ran SNAPPED 19 997, certified b = 12 363 155 397 109; the six "
                   "recorded 4 672 INCREMENT occurrences are w45 -> w46, w53 -> w54, w65 -> w66, "
                   "w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> this step [SNAP] - no pattern claim "
                   "beyond the recorded data"),
        margin_exp="2.99e-4",
        subcent_ordinal="EIGHTEENTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4)"),
        new_milestone=455000,
    ),
    98: dict(
        N=98, tCE=3000175795414, gap=462614, prevgap=457941,
        gal=300017579541424, gden=100, galstr="300017579541424 / 100",
        frac="0.245408137563772737838805... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0054081375637727378388 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 397 109", b="12 363 155 417 109",
        ga_b="[232127358515834031428417063231834812061, -86, 16777217, -110]",
        gb_b="[232127358877384873434150165386313952977, -86, 16777217, -110]",
        width="NON-SNAPPED 20 000", widthnum=20000, census="1 979 979", censusnum=1979979,
        censusprev="1 959 979", censusprevnum=1959979,
        widthprev_desc="SNAPPED 19 997, THREE recorded interior Rosser failure blocks (all determined and rescued)",
        evals="34 938", seconds="11 635.5", cache="0",
        runs="49 / 52", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=3,
        faildesc=("THREE recorded interior Rosser failure blocks, ALL DETERMINED TRUE and "
                  "rescued (each union-span resample found the full quota of 5 sign changes): "
                  "block [12 363 155 398 701, 12 363 155 398 703] (need 2 / changes 0 at 129 "
                  "points, finest m = 64; rescue union [12 363 155 398 700, 12 363 155 398 705] "
                  "FOUND 5 at m = 4); block [12 363 155 408 245, 12 363 155 408 247] (m = 64; "
                  "rescue union [12 363 155 408 243, 12 363 155 408 248] FOUND 5 at m = 2); block "
                  "[12 363 155 408 862, 12 363 155 408 864] (m = 64; rescue union [12 363 155 "
                  "408 860, 12 363 155 408 865] FOUND 5 at m = 4). THE INDEPENDENT ADJUDICATION "
                  "(fresh mpmath, separate engine, corrected phase convention, dense scan with "
                  "refined crossing checks, plus unflagged control spans; "
                  "window98_union_adjudication.json, 2026-11-17) RE-CONFIRMED EACH RESCUE COUNT "
                  "from outside the pipeline (fresh 5/5/5; min |Z| 1.79e-05 / 2.24e-04 / 6.13e-05; no near-zero "
                  "touch; 4 control spans all pass at 2/2, 3/3, 3/3, 2/2). ERRATUM: a stale pre-reboot audit run (as recorded in the "
                  "then-current comparative view and reviewer brief) claimed the three flagged "
                  "unions contained zero zeros (over-prediction); the durable re-adjudication "
                  "supersedes it - the rescues are REAL, exactly as in"
                  " W97"),        win_n_clean=42, win_n_rescue=56, total_fail=86,
        incr=4673,
        mile=("the 455 000 UNIT ROUND MARK (crossed at W97 [0418]) carries 7 614; the 460 000 UNIT ROUND "
              "MARK was CROSSED IN THIS WINDOW, WINDOW 98 (margin 2 614 - a regular round crossing, not a "
              "predicted milestone); the next round mark 465 000 is 2 386 ahead (less than one full step "
              "- compute at that window, do not pre-announce)"),
        censmarks=("the 1 960 000 CERTIFIED-ZERO MARK was CROSSED in THIS WINDOW, WINDOW 98 (margin 19 "
                   "979); the 1 940 000 mark (crossed W97 [0418]) carries 39 979; the 1 920 000 mark "
                   "(crossed W96) carries 59 979; the 1 900 000 mark (crossed W95 [0410]) carries 79 979; "
                   "2 000 000 is 20 021 ahead (about one full window - compute at that window, do not "
                   "pre-announce)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98},
        unit="NINETY-EIGHTH", family="-86",
        ord_word="thirty-third", nw=6,
        run_note="the pre-2026-11-16-reboot run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication of the 3 "
                     "rescued spans (0424 audit record: separate engine, corrected phase "
                     "convention, dense scan with refined crossing checks, plus unflagged control "
                     "spans) RE-CONFIRMS EACH RESCUE COUNT from outside the pipeline (fresh "
                     "5/5/5; min |Z| 1.79e-05 / 2.24e-04 / 6.13e-05; no near-zero touch; 4 control spans all pass at 2/2, 3/3, 3/3, 2/2). ERRATUM: a stale "
                     "pre-reboot audit reading recorded in the committed comparative view (8b81f0c) "
                     "and reviewer brief (813e732) - 'the 3 flagged spans in W98 contain zero "
                     "zeros (over-prediction)' - is SUPERSEDED by this durable re-adjudication of "
                     "2026-11-17 (erratum 0424)."),
        fail_phrase=("three recorded interior Rosser failure blocks, ALL DETERMINED and "
                     "rescued, each rescue count independently re-confirmed by the fresh-mpmath "
                     "union-span adjudication (fresh 5 / 5 / 5)"),
        band_fail=("three recorded interior Rosser failure blocks, all determined and "
                   "rescue-confirmed (the independent fresh-mpmath union-span adjudication "
                   "re-confirms each rescue count: fresh 5 / 5 / 5)"),
        rescued_note=(" all determined and rescued, the rescues independently re-confirmed by "
                      "the fresh-mpmath union-span adjudication (fresh 5 / 5 / 5), "),
        prov_fail=("(ALL DETERMINED TRUE and rescued - the rescues independently re-confirmed by "
                   "the fresh-mpmath union-span adjudication of 2026-11-17 (erratum 0424 "
                   "supersedes a stale pre-reboot 'over-prediction' reading); see the W98 "
                   "record above)"),        shrink_note=("THE USUAL INCREMENT: W98 ran NON-SNAPPED 20 000 (certified b = 12 363 155 417 109) "
                     "with 3 recorded interior Rosser failure blocks (all determined and rescued); the floor "
                     "advances by 4673. The six recorded 4 672 INCREMENT occurrences remain w45 -> w46, "
                     "w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 [SNAP]; no "
                     "pattern claim beyond the recorded data points."),
        incr_note=("the usual increment - W98 ran NON-SNAPPED 20 000, certified b = 12 363 155 417 109; the "
                   "six recorded 4 672 INCREMENT occurrences remain w45 -> w46, w53 -> w54, w65 -> w66, "
                   "w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 [SNAP] - no pattern claim beyond the "
                   "recorded data"),
        margin_exp="5.41e-3",
        subcent_ordinal="NINETEENTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3)"),
        new_milestone=460000,
    ),
    99: dict(
        N=99, tCE=3000175800087, gap=467287, prevgap=462614,
        gal=300017580008718, gden=100, galstr="300017580008718 / 100",
        frac="0.180516606992693104903701... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0005166069926931049037 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 417 109", b="12 363 155 437 109",
        ga_b="[232127358877384873434150165386313952977, -86, 16777217, -110]",
        gb_b="[232127359238935715418942513750545622351, -86, 16777217, -110]",
        width="NON-SNAPPED 20 000, CLEAN", widthnum=20000, census="1 999 979", censusnum=1999979,
        censusprev="1 979 979", censusprevnum=1979979,
        widthprev_desc="NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined at m = 64; the rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 independent fresh-mpmath union-span adjudication - fresh 5 / 5 / 5, no near-zero touch, 4/4 control spans pass)",
        evals="33 387", seconds="146.1", cache="32 737",
        runs="49 / 46", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=0,
        faildesc="ZERO recorded interior Rosser failure blocks - a CLEAN window.",
        win_n_clean=43, win_n_rescue=56, total_fail=86,
        incr=4673,
        mile=("the 460 000 UNIT ROUND MARK (crossed at W98 [0419]) carries 7 287; the 465 000 UNIT ROUND "
              "MARK was CROSSED IN THIS WINDOW, WINDOW 99 (margin 2 287 - a regular round crossing, not a "
              "predicted milestone); the next round mark 470 000 is 2 713 ahead (less than one full step - "
              "compute at that window, do not pre-announce)"),
        censmarks=("the 1 980 000 CERTIFIED-ZERO MARK was CROSSED in THIS WINDOW, WINDOW 99 (margin 19 "
                   "979 - first crossing of that mark); the 1 960 000 mark (crossed W98 [0419]) carries "
                   "39 979; the 1 940 000 mark (crossed W97 [0418]) carries 59 979; 2 000 000 is 21 ahead "
                   "(less than one zero-span - the tail window W100 will land it, do not pre-announce)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99},
        unit="NINETY-NINTH", family="-86",
        ord_word="thirty-fourth", nw=6,
        run_note=("the post-2026-11-16-reboot run seeded from the W98 cache tail (resumed_from_cache = "
                  "32 737; 33 387 fresh evaluations in 146.1 s, logged for provenance)"),
        parallel_note="",
        verif_extra="The window is CLEAN (zero interior Rosser failure blocks) - nothing to adjudicate.",
        shrink_note=("THE USUAL INCREMENT: W99 ran NON-SNAPPED 20 000, CLEAN (certified b = 12 363 155 437 "
                     "109); the floor advances by 4673. The six recorded 4 672 INCREMENT occurrences remain "
                     "w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 "
                     "[SNAP]; no pattern claim beyond the recorded data points."),
        incr_note=("the usual increment - W99 ran NON-SNAPPED 20 000 CLEAN, certified b = 12 363 155 437 "
                   "109 - no pattern claim beyond the recorded data"),
        margin_exp="5.17e-4",
        subcent_ordinal="TWENTIETH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4)"),
        new_milestone=465000,
    ),
    100: dict(
        N=100, tCE=3000175800092, gap=467292, prevgap=467287,
        gal=300017580009208, gden=100, galstr="300017580009208 / 100",
        frac="0.0870984707433515019730524... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0070984707433515019731 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 437 109", b="12 363 155 437 130",
        ga_b="[232127359238935715418942513750545622351, -86, 16777217, -110]",
        gb_b="[232127359239315343803015540277010368039, -86, 16777217, -110]",
        width="TAIL 21 (the final short window of the 2 000 000 census program; b - a = 21)", widthnum=21,
        census="2 000 000", censusnum=2000000, censusprev="1 999 979", censusprevnum=1999979,
        widthprev_desc="NON-SNAPPED 20 000, CLEAN",
        evals="244", seconds="29.7", cache="0",
        runs="48 / 47", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=0,
        faildesc="ZERO recorded interior Rosser failure blocks - a CLEAN tail window.",
        win_n_clean=44, win_n_rescue=56, total_fail=86,
        incr=5,
        mile=("the 465 000 UNIT ROUND MARK (crossed at W99 [0420]) carries 2 292; the 460 000 UNIT ROUND "
              "MARK (crossed at W98 [0419]) carries 7 292; the next round mark 470 000 is 2 708 ahead "
              "(less than one full step - compute at that window, do not pre-announce)"),
        censmarks=("the 2 000 000 CERTIFIED-ZERO MARK LANDS EXACTLY IN THIS WINDOW, WINDOW 100 (the tail "
                   "window: 1 999 979 + 21 = 2 000 000, margin 0) - the census program's target is met "
                   "itself; the 1 980 000 mark (crossed W99 [0420]) carries margin 19 979; the 1 960 000 "
                   "mark (crossed W98 [0419]) carries 39 979; the 1 940 000 mark (crossed W97 [0418]) "
                   "carries 59 979"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99},
        unit="ONE-HUNDREDTH", family="-86",
        ord_word="thirty-fifth", nw=6,
        run_note="the post-2026-11-16-reboot fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        verif_extra="The window is CLEAN (zero interior Rosser failure blocks) - nothing to adjudicate.",
        shrink_note=("THE SHORT-WINDOW INCREMENT: W100 ran the TAIL window (21 gram intervals, certified "
                     "b = 12 363 155 437 130, CLEAN); the floor advances by only 5 (21 grams near this "
                     "height span ~0.49 in t). The six recorded 4 672 INCREMENT occurrences remain "
                     "w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 "
                     "[SNAP]; no pattern claim beyond the recorded data points."),
        incr_note=("the SHORT-WINDOW increment - W100 ran the TAIL (21 gram intervals, ~0.49 in t), "
                   "certified b = 12 363 155 437 130, CLEAN - no pattern claim beyond the recorded data"),
        margin_exp="7.10e-3",
        subcent_ordinal="TWENTY-FIRST",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3)"),
        new_milestone=None,
    ),
    101: dict(
        N=101, tCE=3000175804765, gap=471965, prevgap=467292,
        gal=300017580476502, gden=100, galstr="300017580476502 / 100",
        frac="0.0222066692351876139239025... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0022066692351876139239 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 437 130", b="12 363 155 457 130",
        ga_b="[232127359239315343803015540277010368039, -86, 16777217, -110]",
        gb_b="[232127359600866185766845147095826895749, -86, 16777217, -110]",
        width="NON-SNAPPED 20 000", widthnum=20000,
        census="2 020 000", censusnum=2020000, censusprev="2 000 000", censusprevnum=2000000,
        widthprev_desc=("TAIL 21 (the final short window of the 2 000 000 census program; b - a = 21), "
                        "CLEAN - zero failures - the 2 000 000 program target LANDED at W100 [0421]; "
                        "W101 is the first post-target-extension window"),
        evals="33 752", seconds="4832.1", cache="0",
        runs="47 / 48", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 452 023, 12 363 155 452 025] "
                  "(need 2, changes 0 at 129 sampled points, m = 64, DETERMINED) - RESCUED by the widened "
                  "union span [12 363 155 452 022, 12 363 155 452 026] (need 4, FOUND 4, probe m = 8); the "
                  "0431 independent fresh-mpmath union-span adjudication RE-CONFIRMS the rescue count "
                  "(fresh 4 / 4, no near-zero touch - min |Z| = 5.06e-4; 4/4 control spans pass at "
                  "2 / 2, 2 / 2, 2 / 2, 2 / 2) - verdict: ALL SPANS RESOLVED, CERTIFIED. Window "
                  "sign-change total = b - a = 20 000."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0431 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no "
                     "near-zero touch)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, "
                   "adjudication-confirmed (fresh 4 / 4 - the 0431 independent union-span adjudication; "
                   "certificate by sign-change total)"),
        rescued_note=" (the single block DETERMINED and RESCUED - the 0431 adjudication re-confirms "
                     "fresh 4 / 4), ",
        prov_fail=("(the single recorded block: DETERMINED and RESCUED at union "
                   "[12 363 155 452 022, 12 363 155 452 026], FOUND 4 / need 4, probe m = 8; the 0431 "
                   "independent fresh-mpmath adjudication re-confirms the rescue count fresh 4 / 4, "
                   "no near-zero touch, 4/4 control spans pass - verdict ALL SPANS RESOLVED)"),
        verif_extra=("The window is CERTIFIED (20 000 / 20 000 sign changes, turing_ok). ONE recorded "
                     "interior Rosser failure block, determined and rescued; the 0431 independent "
                     "fresh-mpmath union-span adjudication (corrupted-phase-convention, dense scan, "
                     "refined crossing checks, unflagged control spans) RE-CONFIRMS the rescue: union "
                     "[12 363 155 452 022, 12 363 155 452 026] fresh 4 / 4 (pipeline 4 / 4), "
                     "near-zero touch 0 (min |Z| = 5.06e-4); 4 control spans pass (2/2, 2/2, 2/2, 2/2); "
                     "verdict ALL SPANS RESOLVED - window sign-change total = b - a, CERTIFIED by "
                     "verifier."),
        win_n_clean=44, win_n_rescue=57, total_fail=87,
        incr=4673,
        mile=("the 470 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 101 (margin 1 965 - a "
              "regular round crossing, not a predicted milestone); the 465 000 UNIT ROUND MARK (crossed "
              "at W99 [0420]) carries 6 965; the 460 000 UNIT ROUND MARK (crossed at W98 [0419]) carries "
              "11 965; the next round mark 475 000 is 3 035 ahead (less than one full 4 673 step)"),
        censmarks="",  # auto: census_narr() with the updated CENSUS_MARKS + post-target branch
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101},
        unit="ONE-HUNDRED-FIRST", family="-86",
        ord_word="thirty-sixth", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W101 resumes the full 20 000 width after the TAIL W100 (+21, floor +5 - the "
                     "landed 2 000 000 census program target [0421]): the floor now advances by 4 673 "
                     "(the usual full-window increment) - the first post-target-extension window. The six "
                     "recorded 4 672 INCREMENT occurrences remain w45 -> w46, w53 -> w54, w65 -> w66, "
                     "w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 [SNAP]; no pattern claim beyond the "
                     "recorded data points."),
        incr_note=("the usual full-window increment - W101 ran the full 20 000 gram width, certified "
                   "b = 12 363 155 457 130; no pattern claim beyond the recorded data"),
        margin_exp="2.21e-3",
        subcent_ordinal="TWENTY-SECOND",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3)"),
        new_milestone=470000,
    ),
    102: dict(
        N=102, tCE=3000175809437, gap=476637, prevgap=471965,
        gal=300017580943772, gden=100, galstr="300017580943772 / 100",
        frac="0.7236678416844995204769021... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0036678416844995204769 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 457 130", b="12 363 155 477 129",
        ga_b="[232127359600866185766845147095826895749, -86, 16777217, -110]",
        gb_b="[232127359962398950167637379246955296117, -86, 16777217, -110]",
        width=("SNAPPED 19 999 (the requested 20 000 window was snapped back one gram at the b-end: "
               "b_requested = 12 363 155 477 130, certified b = 12 363 155 477 129, b - a = 19 999)"),
        widthnum=19999,
        census="2 039 999", censusnum=2039999, censusprev="2 020 000", censusprevnum=2020000,
        widthprev_desc=("NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and "
                        "rescued, adjudication-confirmed (fresh 4 / 4 - the 0431 independent union-span "
                        "adjudication)"),
        evals="34 040", seconds="4784.8", cache="0",
        runs="48 / 45", phase="4.08e-21 (radius 1.67e-24)",
        failures_n=0,
        faildesc=("ZERO recorded interior Rosser failure blocks - a CLEAN snap window (the requested "
                  "20 000 was snapped back exactly one gram at the b-end, logged as b_requested in the "
                  "window record; the sign-change total equals b - a = 19 999)."),
        win_n_clean=45, win_n_rescue=57, total_fail=87,
        incr=4672,
        mile=("the 475 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 102 (margin 1 637 - a "
              "regular round crossing, not a predicted milestone); the 470 000 UNIT ROUND MARK (crossed "
              "at W101 [0431]) carries 6 637; the 465 000 UNIT ROUND MARK (crossed at W99 [0420]) carries "
              "11 637; the next round mark 480 000 is 3 363 ahead (less than one full 4 673 step)"),
        censmarks=("the 2 020 000 CERTIFIED-ZERO MARK (crossed at W101 [0431]) carries margin 19 999; "
                   "the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's "
                   "target; carries margin 39 999); the 1 980 000 CERTIFIED-ZERO MARK (crossed at "
                   "W99 [0420]) carries margin 59 999; the 2 040 000 mark is 1 zero ahead (it lands at "
                   "the start of the NEXT window - do not pre-announce)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102},
        unit="ONE-HUNDRED-SECOND", family="-86",
        ord_word="thirty-seventh", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        verif_extra=("The window is CLEAN (zero interior Rosser failure blocks) - nothing to adjudicate. "
                     "The SNAP is a recorded pipeline endpoint adjustment (b_requested = 12 363 155 "
                     "477 130 snapped to b = 12 363 155 477 129, exactly one gram), logged in the "
                     "window record; the certificate rests on the sign-change total b - a = 19 999."),
        shrink_note=("W102: the requested 20 000 window was SNAPPED back one gram at the b-end "
                     "(19 999 certified), CLEAN. The floor advances by 4 672 - the SEVENTH recorded 4 "
                     "672 INCREMENT: w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> "
                     "w87 [SNAP], w97 -> w98 [SNAP], w101 -> w102 [SNAP]; no pattern claim beyond the "
                     "recorded data points."),
        incr_note=("a recorded 4 672 increment (the seventh occurrence; the window was SNAPPED 19 999) - "
                   "certified b = 12 363 155 477 129, CLEAN - no pattern claim beyond the recorded data"),
        margin_exp="3.67e-3",
        subcent_ordinal="TWENTY-THIRD",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3)"),
        new_milestone=475000,
    ),
    103: dict(
        N=103, tCE=3000175814109, gap=481309, prevgap=476637,
        gal=300017581410995, gden=100, galstr="300017581410995 / 100",
        frac="0.9578352327557882471696919... (exact, exponent -85 dyadic terminator)",
        fracmargin="0.0078352327557882471696 (exact, exponent -85 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 477 129", b="12 363 155 497 126",
        ga_b="[232127359962398950167637379246955296117, -86, 16777217, -110]",
        gb_b="[116063680161947779731649901826641618125, -85, 16777217, -110]",
        width=("SNAPPED 19 997 (the requested 20 000 window was snapped back three grams at the b-end: "
               "b_requested = 12 363 155 497 129, certified b = 12 363 155 497 126, b - a = 19 997)"),
        widthnum=19997,
        census="2 059 996", censusnum=2059996, censusprev="2 039 999", censusprevnum=2039999,
        widthprev_desc=("SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), "
                        "CLEAN - zero recorded interior failures"),
        evals="33 186", seconds="4668.6", cache="0",
        runs="47 / 50", phase="4.04e-21 (radius 2.10e-25)",
        failures_n=0,
        faildesc=("ZERO recorded interior Rosser failure blocks - a CLEAN snap window (the requested "
                  "20 000 was snapped back exactly three grams at the b-end, logged as b_requested in "
                  "the window record; the sign-change total equals b - a = 19 997)."),
        win_n_clean=46, win_n_rescue=57, total_fail=87,
        incr=4672,
        mile=("the 480 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 103 (margin 1 309 - a "
              "regular round crossing, not a predicted milestone); the 475 000 UNIT ROUND MARK (crossed "
              "at W102 [0434]) carries 6 309; the 470 000 UNIT ROUND MARK (crossed at W101 [0431]) "
              "carries 11 309; the next round mark 485 000 is 3 691 ahead (less than one full 4 673 "
              "step)"),
        censmarks=("the 2 040 000 CERTIFIED-ZERO MARK was LANDED IN THIS WINDOW, WINDOW 103 (margin "
                   "19 996); the 2 020 000 mark (W101 [0431]) carries 39 996; the 2 000 000 program "
                   "target (W100 [0421]) carries 59 996; the 2 060 000 mark is 4 zeros ahead (it lands "
                   "at the start of the NEXT window - do not pre-announce)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103},
        unit="ONE-HUNDRED-THIRD", family="-85",
        ord_word="thirty-eighth", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        verif_extra=("The window is CLEAN (zero interior Rosser failure blocks) - nothing to adjudicate. "
                     "The SNAP is a recorded pipeline endpoint adjustment (b_requested = 12 363 155 "
                     "497 129 snapped to b = 12 363 155 497 126, exactly three grams), logged in the "
                     "window record; the certificate rests on the sign-change total b - a = 19 997."),
        shrink_note=("W103: the requested 20 000 window was SNAPPED back three grams at the b-end "
                     "(19 997 certified), CLEAN. The floor advances by 4 672 - the EIGHTH recorded 4 "
                     "672 INCREMENT and the SECOND CONSECUTIVE one (w101 -> w102: 19 999 snap, w102 -> "
                     "w103: 19 997 snap): the full series is w45 -> w46, w53 -> w54, w65 -> w66, "
                     "w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 [SNAP], w101 -> w102 [SNAP], "
                     "w102 -> w103 [SNAP]; the increment is a property of the floor landing, while the "
                     "census advances by the window's certified width - recorded separately, no "
                     "pattern claim beyond the recorded data."),
        incr_note=("a recorded 4 672 increment (the eighth occurrence, and the second consecutive; the "
                   "window was SNAPPED 19 997) - certified b = 12 363 155 497 126, CLEAN - no pattern "
                   "claim beyond the recorded data"),
        margin_exp="7.84e-3",
        subcent_ordinal="TWENTY-FOURTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3)"),
        new_milestone=480000,
    ),
    104: dict(
        N=104, tCE=3000175818782, gap=485982, prevgap=481309,
        gal=300017581878289, gden=100, galstr="300017581878289 / 100",
        frac="0.8929426193430616163786617... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0029426193430616163786 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 497 126", b="12 363 155 517 126",
        ga_b="[116063680161947779731649901826641618125, -85, 16777217, -110]",
        gb_b="[232127360685446401364311337578491677853, -86, 16777217, -110]",
        width="NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued",
        widthnum=20000,
        census="2 079 996", censusnum=2079996, censusprev="2 059 996", censusprevnum=2059996,
        widthprev_desc=("SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), "
                        "CLEAN - zero recorded interior failures (the 2 040 000 census mark crossed "
                        "mid-window)"),
        evals="34 069", seconds="4831.0", cache="0",
        runs="53 / 47", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 500 307, 12 363 155 "
                  "500 309] - DETERMINED (129 points, m = 64) and RESCUED on the union span "
                  "[12 363 155 500 304, 12 363 155 500 310] (need 6, found 6); the independent "
                  "fresh-mpmath adjudication (0437) RE-CONFIRMS the rescue count (fresh 6 / 6, no "
                  "near-zero touch, min |Z| 1.01e-4) and all 4 control spans pass (2/2, 2/2, 3/3, "
                  "3/3)."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0437 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 6 / 6, no "
                     "near-zero touch, 4/4 control spans pass)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, the rescue "
                   "union RE-CONFIRMED by the 0437 fresh-mpmath adjudication (fresh 6 / 6, no "
                   "near-zero touch; all four control spans pass)"),
        rescued_note=(" (the single block DETERMINED and RESCUED - the 0437 adjudication re-confirms "
                      "fresh 6 / 6, no near-zero touch; all four control spans pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0437) "
                     "re-counts the rescued union [12 363 155 500 304, 12 363 155 500 310] from a "
                     "fresh evaluation: fresh 6 / 6 (need 6), no near-zero touch (min |Z| "
                     "1.01e-4), and all 4 unflagged control spans pass (2/2, 2/2, 3/3, 3/3) - "
                     "verdict ALL SPANS RESOLVED; the window sign-change total equals b - a = "
                     "20 000."),
        win_n_clean=46, win_n_rescue=58, total_fail=88,
        incr=4673,
        mile=("the 485 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 104 (margin 982 - a "
              "regular round crossing; its expected window W104 was noted in the 0436 record); the "
              "480 000 UNIT ROUND MARK (crossed at W103 [0436]) carries 5 982; the 475 000 UNIT ROUND "
              "MARK (crossed at W102 [0434]) carries 10 982; the next round mark 490 000 is 4 018 "
              "ahead (less than one full 4 673 step)"),
        censmarks=("the 2 060 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 104 (margin "
                   "19 996 - the second post-target 20 000-mark, landing in a FULL-width window after "
                   "the mid-window landing of 2 040 000 at W103); the 2 040 000 mark (W103 [0436]) "
                   "carries 39 996; the 2 000 000 program target (W100 [0421]) carries 79 996; the "
                   "2 080 000 mark is 4 zeros ahead (it lands at the start of the NEXT window - do "
                   "not pre-announce)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104},
        unit="ONE-HUNDRED-FOURTH", family="-86",
        ord_word="thirty-ninth", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W104: a FULL 20 000 window (no snap). The floor advances by the STANDARD 4 673 "
                     "- the return to standard after the consecutive SNAP pair (w101 -> w102: 4 672 "
                     "[SNAP 19 999], w102 -> w103: 4 672 [SNAP 19 997]); the 4 672 series remains "
                     "eight recorded occurrences, no pattern claim beyond the recorded data."),
        incr_note=("the standard 4 673 increment after two consecutive 4 672 SNAP-family increments "
                   "(w101 -> w102, w102 -> w103) - return to standard, no pattern claim"),
        margin_exp="2.94e-3",
        subcent_ordinal="TWENTY-FIFTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3)"),
        new_milestone=485000,
    ),
    105: dict(
        N=105, tCE=3000175823455, gap=490655, prevgap=485982,
        gal=300017582345582, gden=100, galstr="300017582345582 / 100",
        frac="0.8280497352774381486108240... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0080497352774381486108 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 517 126", b="12 363 155 537 126",
        ga_b="[232127360685446401364311337578491677853, -86, 16777217, -110]",
        gb_b="[232127361046997243244382117894758304225, -86, 16777217, -110]",
        width="NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued",
        widthnum=20000,
        census="2 099 996", censusnum=2099996, censusprev="2 079 996", censusprevnum=2079996,
        widthprev_desc=("FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - "
                        "determined, rescued, adjudication-confirmed (fresh 6 / 6 - 0437; the "
                        "2 060 000 census mark crossed in the window)"),
        evals="33 671", seconds="4724.2", cache="0",
        runs="54 / 49", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 517 506, 12 363 155 "
                  "517 508] - DETERMINED (129 points, m = 64) and RESCUED on the union span "
                  "[12 363 155 517 505, 12 363 155 517 509] (need 4, found 4); the independent "
                  "fresh-mpmath adjudication (0438) RE-CONFIRMS the rescue count (fresh 4 / 4, no "
                  "near-zero touch, min |Z| 2.86e-4) and all 4 control spans pass (2/2, 3/3, 2/2, "
                  "2/2)."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0438 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no "
                     "near-zero touch, 4/4 control spans pass)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, the rescue "
                   "union RE-CONFIRMED by the 0438 fresh-mpmath adjudication (fresh 4 / 4, no "
                   "near-zero touch; all four control spans pass)"),
        rescued_note=(" (the single block DETERMINED and RESCUED - the 0438 adjudication re-confirms "
                      "fresh 4 / 4, no near-zero touch; all four control spans pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0438) "
                     "re-counts the rescued union [12 363 155 517 505, 12 363 155 517 509] from a "
                     "fresh evaluation: fresh 4 / 4 (need 4), no near-zero touch (min |Z| 2.86e-4), "
                     "and all 4 unflagged control spans pass (2/2, 3/3, 2/2, 2/2) - verdict ALL "
                     "SPANS RESOLVED; the window sign-change total equals b - a = 20 000."),
        win_n_clean=46, win_n_rescue=59, total_fail=89,
        incr=4673,
        mile=("the 490 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 105 (margin 655 - a "
              "regular round crossing; its expected window W105 was noted in the 0437 record - "
              "hit); the 485 000 UNIT ROUND MARK (crossed at W104 [0437]) carries 5 655; the 480 000 "
              "UNIT ROUND MARK (crossed at W103 [0436]) carries 10 655; the next round mark 495 000 "
              "is 4 345 ahead (less than one full 4 673 step)"),
        censmarks=("the 2 080 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 105 (margin "
                   "19 996 - the third post-target 20 000-mark); the 2 060 000 mark (W104 [0437]) "
                   "carries 39 996; the 2 040 000 mark (W103 [0436]) carries 59 996; the 2 100 000 "
                   "mark is 4 zeros ahead (it lands at the start of the NEXT window - do not pre-"
                   "announce); the census has carried the -4 offset since the W103 three-gram snap "
                   "(recorded data, no pattern claim)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105},
        unit="ONE-HUNDRED-FIFTH", family="-86",
        ord_word="fortieth", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W105: a FULL 20 000 window (no snap). The floor advances by the STANDARD 4 673 "
                     "(second consecutive standard increment after the return at W104); the 4 672 "
                     "series remains eight recorded occurrences, no pattern claim beyond the "
                     "recorded data."),
        incr_note=("the standard 4 673 increment (second consecutive after the SNAP pair; no "
                   "pattern claim beyond the recorded data)"),
        margin_exp="8.05e-3",
        subcent_ordinal="TWENTY-SIXTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3)"),
        new_milestone=490000,
    ),
    106: dict(
        N=106, tCE=3000175828128, gap=495328, prevgap=490655,
        gal=300017582812876, gden=100, galstr="300017582812876 / 100",
        frac="0.7631565805589183124506519... (exact, exponent -83 dyadic terminator)",
        fracmargin="0.0031565805589183124506 (exact, exponent -83 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 537 126", b="12 363 155 557 126",
        ga_b="[232127361046997243244382117894758304225, -86, 16777217, -110]",
        gb_b="[29015920176068510637939018079792260365, -83, 16777217, -110]",
        width="NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued",
        widthnum=20000,
        census="2 119 996", censusnum=2119996, censusprev="2 099 996", censusprevnum=2099996,
        widthprev_desc=("FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - "
                        "determined, rescued, adjudication-confirmed (fresh 4 / 4 - 0438; the "
                        "2 080 000 census mark crossed in the window)"),
        evals="33 743", seconds="4799.4", cache="0",
        runs="55 / 46", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 553 044, 12 363 155 "
                  "553 047] - DETERMINED (193 points, m = 64) and RESCUED on the union span "
                  "[12 363 155 553 043, 12 363 155 553 048] (need 5, found 5); the independent "
                  "fresh-mpmath adjudication (0439) RE-CONFIRMS the rescue count (fresh 5 / 5, no "
                  "near-zero touch, min |Z| 3.48e-4) and all 4 control spans pass (2/2, 3/3, 3/3, "
                  "3/3)."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0439 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no "
                     "near-zero touch, 4/4 control spans pass)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, the rescue "
                   "union RE-CONFIRMED by the 0439 fresh-mpmath adjudication (fresh 5 / 5, no "
                   "near-zero touch; all four control spans pass)"),
        rescued_note=(" (the single block DETERMINED and RESCUED - the 0439 adjudication re-confirms "
                      "fresh 5 / 5, no near-zero touch; all four control spans pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0439) "
                     "re-counts the rescued union [12 363 155 553 043, 12 363 155 553 048] from a "
                     "fresh evaluation: fresh 5 / 5 (need 5), no near-zero touch (min |Z| 3.48e-4), "
                     "and all 4 unflagged control spans pass (2/2, 3/3, 3/3, 3/3) - verdict ALL "
                     "SPANS RESOLVED; the window sign-change total equals b - a = 20 000."),
        win_n_clean=46, win_n_rescue=60, total_fail=90,
        incr=4673,
        mile=("the 495 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 106 (margin 328 - a "
              "regular round crossing; its expected window W106 was noted in the 0438 record - "
              "hit); the 490 000 UNIT ROUND MARK (crossed at W105 [0438]) carries 5 328; the 485 "
              "000 UNIT ROUND MARK (crossed at W104 [0437]) carries 10 328; the next round mark "
              "500 000 is 4 672 ahead (within both recorded increment sizes, 4 672 and 4 673; "
              "expected at W107, entry 0440)"),
        censmarks=("the 2 100 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 106 (margin "
                   "19 996); the 2 080 000 mark (W105 [0438]) carries 39 996; the 2 060 000 mark "
                   "(W104 [0437]) carries 59 996; the 2 120 000 mark is 4 zeros ahead (it lands at "
                   "the start of the NEXT window - do not pre-announce); the census has carried "
                   "the -4 offset since the W103 three-gram snap (recorded data, no pattern claim)"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106},
        unit="ONE-HUNDRED-SIXTH", family="-83",
        ord_word="forty-first", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W106: a FULL 20 000 window (no snap). The floor advances by the STANDARD "
                     "4 673 (third consecutive standard increment); the 4 672 series remains "
                     "eight recorded occurrences, no pattern claim. The endpoint record moves to "
                     "the exponent -83 dyadic family (first recorded appearance in this run; the "
                     "exact dyadic tuple is authoritative over the exponent representation - "
                     "recorded data)."),
        incr_note=("the standard 4 673 increment (third consecutive; no pattern claim beyond the "
                   "recorded data)"),
        margin_exp="3.16e-3",
        subcent_ordinal="TWENTY-SEVENTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3)"),
        new_milestone=495000,
    ),
    107: dict(
        N=107, tCE=3000175832801, gap=500001, prevgap=495328,
        gal=300017583280146, gden=100, galstr="300017583280146 / 100",
        frac="0.4646163998655371313429814... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0046163998655371313429 (exact, exponent -86 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 557 126", b="12 363 155 577 125",
        ga_b="[29015920176068510637939018079792260365, -83, 16777217, -110]",
        gb_b="[232127361770080849399610031874487488647, -86, 16777217, -110]",
        width="SNAPPED 19 999 (the requested 20 000 window snapped back one gram at the b-end), ONE recorded interior Rosser failure - determined and rescued",
        widthnum=19999,
        census="2 139 995", censusnum=2139995, censusprev="2 119 996", censusprevnum=2119996,
        widthprev_desc=("FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - "
                        "determined, rescued, adjudication-confirmed (fresh 5 / 5 - 0439; the "
                        "2 100 000 census mark crossed in the window)"),
        evals="34 167", seconds="4927.5", cache="0",
        runs="48 / 48", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 575 003, 12 363 155 "
                  "575 005] - DETERMINED (129 points, m = 64) and RESCUED on the union span "
                  "[12 363 155 575 002, 12 363 155 575 006] (need 4, found 4); the independent "
                  "fresh-mpmath adjudication (0440) RE-CONFIRMS the rescue count (fresh 4 / 4, no "
                  "near-zero touch, min |Z| 4.54e-4) and all 4 control spans pass (3/3, 2/2, 2/2, "
                  "5/5)."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0440 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no "
                     "near-zero touch, 4/4 control spans pass)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, the rescue "
                   "union RE-CONFIRMED by the 0440 fresh-mpmath adjudication (fresh 4 / 4, no "
                   "near-zero touch; all four control spans pass)"),
        rescued_note=(" (the single block DETERMINED and RESCUED - the 0440 adjudication re-confirms "
                      "fresh 4 / 4, no near-zero touch; all four control spans pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0440) "
                     "re-counts the rescued union [12 363 155 575 002, 12 363 155 575 006] from a "
                     "fresh evaluation: fresh 4 / 4 (need 4), no near-zero touch (min |Z| 4.54e-4), "
                     "and all 4 unflagged control spans pass (3/3, 2/2, 2/2, 5/5) - verdict ALL "
                     "SPANS RESOLVED; the window sign-change total equals b - a = 19 999."),
        win_n_clean=46, win_n_rescue=61, total_fail=91,
        incr=4673,
        mile=("the 500 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 107, with margin 1 - "
              "the LARGEST unit milestone of the program (half a million units above H0), landed "
              "with the smallest unit margin recorded for a post-target round mark; the 495 000 "
              "mark (crossed at W106 [0439]) carries 5 001; the 490 000 mark (crossed at W105 "
              "[0438]) carries 10 001; the next round mark 505 000 is 4 999 ahead (beyond one "
              "standard 4 673 step under either recorded increment family; expected at W109, entry "
              "0442)"),
        censmarks=("the 2 120 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 107 (margin "
                   "19 995); the 2 100 000 mark (W106 [0439]) carries 19 995; the 2 080 000 mark "
                   "(W105 [0438]) carries 39 995; the 2 140 000 mark is 5 zeros ahead (expected at "
                   "W108, entry 0441); the census offset moved from -4 to -5 with this one-gram "
                   "snap (inherited originally from the W103 three-gram snap on top of W102's one-"
                   "gram snap) - recorded data, no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107},
        unit="ONE-HUNDRED-SEVENTH", family="-86",
        ord_word="forty-second", nw=6,
        run_note="the 2026-11-17 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W107: the FOURTH recorded snap window (the snap family so far: W97 19 997, "
                     "W102 19 999, W103 19 997, W107 19 999 - recorded data, no pattern claim). The "
                     "floor advances by the STANDARD 4 673 despite the snapped width (the "
                     "endpoint fraction drops from .763 to .465). The 500 000 UNIT ROUND MARK - "
                     "the largest unit milestone of the program - CROSSED WITH MARGIN 1. The snap "
                     "is a recorded pipeline endpoint adjustment; the certificate rests on the "
                     "sign-change total b - a = 19 999, and the single recorded failure is "
                     "determined and rescued."),
        incr_note=("the standard 4 673 increment (the floor advanced a full step despite the one-"
                   "gram snap width; recorded data, no pattern claim)"),
        margin_exp="4.62e-3",
        subcent_ordinal="TWENTY-EIGHTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3)"),
        new_milestone=500000,
    ),
    108: dict(
        N=108, tCE=3000175837474, gap=504674, prevgap=500001,
        gal=300017583747439, gden=100, galstr="300017583747439 / 100",
        frac="0.3997227038547586089114001... (exact, exponent -85 dyadic terminator)",
        fracmargin="0.0097227038547586089114 (exact, exponent -85 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 577 125", b="12 363 155 597 125",
        ga_b="[232127361770080849399610031874487488647, -86, 16777217, -110]",
        gb_b="[116063681065815845608429799309566288339, -85, 16777217, -110]",
        width="NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all determined and rescued (the first multi-failure window in the program)",
        widthnum=20000,
        census="2 159 995", censusnum=2159995, censusprev="2 139 995", censusprevnum=2139995,
        widthprev_desc=("SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure "
                        "- determined, rescued, adjudication-confirmed (fresh 4 / 4 - 0440; the "
                        "500 000 unit round mark crossed with margin 1)"),
        evals="35 037", seconds="5011.9", cache="0",
        runs="52 / 49", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=3,
        faildesc=("THREE recorded interior Rosser failure blocks - [12 363 155 579 429, 12 363 "
                  "155 579 431], [12 363 155 584 538, 12 363 155 584 540] and [12 363 155 593 013, "
                  "12 363 155 593 015] (all the same shape: need 2, changes 0, 129 points, m = 64) "
                  "- all DETERMINED and all RESCUED on their six-glyph union spans (need 5, found "
                  "5 each); the independent fresh-mpmath adjudication (0441) RE-CONFIRMS ALL THREE "
                  "rescue counts (fresh 5 / 5, 5 / 5 and 5 / 5, no near-zero touch anywhere: min "
                  "|Z| 2.34e-4, 1.29e-3, 1.31e-3) and all 4 control spans pass (3/3, 2/2, 2/2, 4/4). "
                  "This is the FIRST MULTI-FAILURE window of the program, handled by the existing "
                  "protocol without modification."),
        fail_phrase=("three recorded interior Rosser failure blocks - all DETERMINED and RESCUED "
                     "(need 5, found 5 each) - the 0441 fresh-mpmath adjudication RE-CONFIRMS ALL "
                     "THREE rescue counts (fresh 5 / 5, 5 / 5, 5 / 5, no near-zero touch, 4/4 "
                     "control spans pass)"),
        band_fail=("three recorded interior Rosser failure blocks - all determined and rescued, all "
                   "three rescue unions RE-CONFIRMED by the 0441 fresh-mpmath adjudication (fresh "
                   "5 / 5 each, no near-zero touch; all four control spans pass)"),
        rescued_note=(" (all three blocks DETERMINED and RESCUED - the 0441 adjudication re-"
                      "confirms fresh 5 / 5 on each, no near-zero touch; all four control spans "
                      "pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0441) "
                     "re-counts all three rescued unions from fresh evaluations: [12 363 155 579 "
                     "428, 12 363 155 579 433] fresh 5 / 5 (min |Z| 1.29e-3), [12 363 155 584 536, "
                     "12 363 155 584 541] fresh 5 / 5 (1.31e-3), [12 363 155 593 012, 12 363 155 "
                     "593 017] fresh 5 / 5 (2.34e-4) - no near-zero touch anywhere; all 4 unflagged "
                     "control spans pass (3/3, 2/2, 2/2, 4/4); verdict ALL SPANS RESOLVED; the "
                     "window sign-change total equals b - a = 20 000."),
        win_n_clean=46, win_n_rescue=62, total_fail=94,
        incr=4673,
        mile=("the 500 000 UNIT ROUND MARK (crossed at W107 [0440], margin 1) carries 4 674; the "
              "495 000 mark (crossed at W106 [0439]) carries 9 674; the 490 000 mark (crossed at "
              "W105 [0438]) carries 14 674; the next round mark 505 000 is 326 ahead (less than one "
              "standard 4 673 step; the smallest next-mark carry recorded; expected at W109, entry "
              "0442)"),
        censmarks=("the 2 140 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 108 (margin "
                   "19 995 - the expected window of the 0440 record, hit); the 2 120 000 mark (W107 "
                   "[0440]) carries 19 995; the 2 100 000 mark (W106 [0439]) carries 39 995; the "
                   "2 160 000 mark is 5 zeros ahead (expected at W109, entry 0442); the census "
                   "offset held at -5 (inherited from the W103 three-gram snap on top of the W102 "
                   "and W107 one-gram snaps) - recorded data, no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107},
        unit="ONE-HUNDRED-EIGHTH", family="-85",
        ord_word="forty-third", nw=6,
        run_note="the 2026-11-18 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W108: a FULL 20 000 window (no snap) and the FIRST MULTI-FAILURE window of "
                     "the program: THREE recorded interior Rosser failure blocks (all the same "
                     "shape: need 2, changes 0, 129 points, m = 64), all DETERMINED, all RESCUED on "
                     "six-glyph union spans (need 5, found 5 each). The floor advances by the "
                     "STANDARD 4 673; the 4 672 series remains eight recorded occurrences, no "
                     "pattern claim. The endpoint record sits in the exponent -85 dyadic family "
                     "(second recorded appearance, after W103 - recorded data)."),
        incr_note=("the standard 4 673 increment (no pattern claim beyond the recorded data)"),
        margin_exp="9.72e-3",
        subcent_ordinal="TWENTY-NINTH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3), W108 (9.72e-3)"),
        new_milestone=None,
    ),
    109: dict(
        N=109, tCE=3000175842147, gap=509347, prevgap=504674,
        gal=300017584214733, gden=100, galstr="300017584214733 / 100",
        frac="0.3348287371910851238174646... (exact, exponent -84 dyadic terminator)",
        fracmargin="0.0048287371910851238174 (exact, exponent -84 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 597 125", b="12 363 155 617 125",
        ga_b="[116063681065815845608429799309566288339, -85, 16777217, -110]",
        gb_b="[58031840623295633253292102974963476553, -84, 16777217, -110]",
        width="NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued",
        widthnum=20000,
        census="2 179 995", censusnum=2179995, censusprev="2 159 995", censusprevnum=2159995,
        widthprev_desc=("FULL-width 20 000 (no snap), THREE recorded interior Rosser failures - "
                        "all determined, all rescued, all adjudication-confirmed (fresh 5 / 5 on "
                        "each - 0441; the first multi-failure window; the 2 140 000 census mark "
                        "crossed in the window)"),
        evals="33 642", seconds="4775.8", cache="0",
        runs="51 / 43", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=1,
        faildesc=("ONE recorded interior Rosser failure block [12 363 155 611 160, 12 363 155 "
                  "611 162] - DETERMINED (129 points, m = 64) and RESCUED on the union span "
                  "[12 363 155 611 158, 12 363 155 611 163] (need 5, found 5; a six-glyph union, "
                  "the widest rescue span recorded so far); the independent fresh-mpmath "
                  "adjudication (0442) RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero "
                  "touch, min |Z| 1.75e-4) and all 4 control spans pass (2/2, 2/2, 2/2, 2/2)."),
        fail_phrase=("one recorded interior Rosser failure block, DETERMINED and RESCUED - the 0442 "
                     "fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no "
                     "near-zero touch, 4/4 control spans pass)"),
        band_fail=("one recorded interior Rosser failure block - determined and rescued, the rescue "
                   "union RE-CONFIRMED by the 0442 fresh-mpmath adjudication (fresh 5 / 5, no "
                   "near-zero touch; all four control spans pass)"),
        rescued_note=(" (the single block DETERMINED and RESCUED - the 0442 adjudication re-confirms "
                      "fresh 5 / 5, no near-zero touch; all four control spans pass)"),
        verif_extra=("In addition, the independent fresh-mpmath union-span adjudication (0442) "
                     "re-counts the rescued union [12 363 155 611 158, 12 363 155 611 163] from a "
                     "fresh evaluation: fresh 5 / 5 (need 5), no near-zero touch (min |Z| 1.75e-4), "
                     "and all 4 unflagged control spans pass (2/2, 2/2, 2/2, 2/2) - verdict ALL "
                     "SPANS RESOLVED; the window sign-change total equals b - a = 20 000."),
        win_n_clean=46, win_n_rescue=63, total_fail=95,
        incr=4673,
        mile=("the 505 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 109 (margin 4 347 - "
              "the smallest next-mark carry recorded, 326 at the W108 seam, landed exactly as "
              "predicted within this window under either recorded increment family); the 500 000 "
              "milestone (W107 [0440], margin 1) carries 9 347; the 495 000 mark (W106 [0439]) "
              "carries 14 347; the next round mark 510 000 is 653 ahead (less than one standard 4 "
              "673 step; expected at W110, entry 0443)"),
        censmarks=("the 2 160 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 109 (margin "
                   "19 995 - the expected window of the 0441 record, hit); the 2 140 000 mark (W108 "
                   "[0441]) carries 19 995; the 2 120 000 mark (W107 [0440]) carries 39 995; the "
                   "2 180 000 mark is 5 zeros ahead (expected at W110, entry 0443); the census "
                   "offset held at -5 (inherited from the W103 three-gram snap on top of the W102 "
                   "and W107 one-gram snaps) - recorded data, no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107,
                   505000: 109},
        unit="ONE-HUNDRED-NINTH", family="-84",
        ord_word="forty-fourth", nw=6,
        run_note="the 2026-11-18 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W109: a FULL 20 000 window (no snap). The floor advances by the STANDARD 4 "
                     "673; the 4 672 series remains eight recorded occurrences, no pattern claim. "
                     "The endpoint record introduces the exponent -84 dyadic family (first recorded "
                     "appearance in this run - the post-target family record is now -86 (W102, "
                     "W104, W105, W107), -85 (W103, W108), -83 (W106), -84 (W109); recorded data, "
                     "no pattern claim; the exact dyadic tuple is authoritative). The 505 000 round "
                     "mark landed with the smallest carry-on record: 326 at the W108 seam - "
                     "landed as predicted."),
        incr_note=("the standard 4 673 increment (no pattern claim beyond the recorded data)"),
        margin_exp="4.83e-3",
        subcent_ordinal="THIRTIETH",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3), W108 (9.72e-3), W109 (4.83e-3)"),
        new_milestone=505000,
    ),
    110: dict(
        N=110, tCE=3000175846820, gap=514020, prevgap=509347,
        gal=300017584682003, gden=100, galstr="300017584682003 / 100",
        frac="0.0362877445931489570830247... (exact, exponent -84 dyadic terminator)",
        fracmargin="0.0062877445931489570830 (exact, exponent -84 dyadic arithmetic, center-minus-radius)",
        a="12 363 155 617 125", b="12 363 155 637 124",
        ga_b="[58031840623295633253292102974963476553, -84, 16777217, -110]",
        gb_b="[58031840713678824311612056710643234355, -84, 16777217, -110]",
        width="SNAPPED 19 999 (the requested 20 000 window was snapped back one gram at the b-end: b_requested 12 363 155 637 125, certified b 12 363 155 637 124), CLEAN - zero interior Rosser failure blocks",
        widthnum=19999,
        census="2 199 994", censusnum=2199994, censusprev="2 179 995", censusprevnum=2179995,
        widthprev_desc=("FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - "
                        "determined, rescued on a six-glyph union, adjudication-confirmed (fresh "
                        "5 / 5 - 0442; the 505 000 unit mark and the 2 160 000 census mark crossed "
                        "in the window)"),
        evals="32 911", seconds="4614.8", cache="0",
        runs="47 / 53", phase="4.08e-21 (radius 1.67e-24)",
        failures_n=0,
        faildesc=("ZERO recorded interior Rosser failure blocks - a CLEAN snap window (the "
                  "requested 20 000 window snapped back one gram at the b-end, certified 19 999; "
                  "nothing to adjudicate). The first CLEAN window since W103: W104–W109 all "
                  "recorded at least one interior failure. The certificate rests on the sign-"
                  "change total b - a = 19 999 (= sign_changes_inside, CERTIFIED)."),
        verif_extra=("The window is CLEAN (zero interior Rosser failure blocks) - nothing to "
                     "adjudicate. The SNAP is a recorded pipeline endpoint adjustment (b_requested "
                     "12 363 155 637 125, certified b 12 363 155 637 124); the certificate rests "
                     "on the sign-change total b - a = 19 999 = sign_changes_inside, verified "
                     "independently (CERTIFIED, turing_ok)."),
        win_n_clean=47, win_n_rescue=63, total_fail=95,
        incr=4673,
        mile=("the 510 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 110 (margin 4 020 - "
              "the expected window of the 0442 record, hit); the 505 000 mark (crossed at W109 "
              "[0442]) carries 4 020; the 500 000 milestone (crossed at W107 [0440], margin 1) "
              "carries 9 020; the next round mark 515 000 is 980 ahead (less than one standard 4 "
              "673 step; expected at W111, entry 0444)"),
        censmarks=("the 2 180 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 110 (margin "
                   "19 994 - the expected window of the 0442 record, hit); the 2 160 000 mark "
                   "(W109 [0442]) carries 39 994; the 2 140 000 mark (W108 [0441]) carries 59 994; "
                   "the 2 200 000 mark is 6 zeros ahead (the offset moved from -5 to -6 with this "
                   "one-gram snap) - recorded data, no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107,
                   505000: 109, 510000: 110},
        unit="ONE-HUNDRED-TENTH", family="-84",
        ord_word="forty-fifth", nw=6,
        run_note="the 2026-11-18 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W110: the requested 20 000 window was SNAPPED back one gram at the b-end "
                     "(19 999 certified), CLEAN - zero interior Rosser failure blocks, nothing to "
                     "adjudicate (the first clean window since W103; W104–W109 all recorded at "
                     "least one interior failure - recorded data, no pattern claim). The floor "
                     "advances by the STANDARD 4 673 despite the snapped width (the endpoint "
                     "fraction drops from .335 to .036); the 4 672 series remains eight recorded "
                     "occurrences, no pattern claim. The snap family so far: W97 19 997, W102 "
                     "19 999, W103 19 997, W107 19 999, W110 19 999 - recorded data, no pattern "
                     "claim. The endpoint record stays in the exponent -84 dyadic family "
                     "(second consecutive -84 endpoint, after W109)."),
        incr_note=("the standard 4 673 increment for the floor (despite the one-gram snap width; "
                   "recorded data, no pattern claim)"),
        margin_exp="6.29e-3",
        subcent_ordinal="THIRTY-FIRST",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3), W108 (9.72e-3), W109 (4.83e-3), W110 (6.29e-3)"),
        new_milestone=510000,
    ),
    111: dict(
        N=111, tCE=3000175851492, gap=518692, prevgap=514020,
        gal=300017585149297, gden=100, galstr="300017585149297 / 100",
        frac="0.9713932366372195971073397... (exact, exponent -86 dyadic terminator)",
        fracmargin="0.0013932366372195971073 (exact, exponent -86 dyadic arithmetic, center-to-interval-endpoint)",
        a="12 363 155 637 124", b="12 363 155 657 124",
        ga_b="[58031840713678824311612056710643234355, -84, 16777217, -110]",
        gb_b="[232127363216266139000876580341880315403, -86, 16777217, -110]",
        width="FULL 20 000 (no snap), CLEAN - zero interior Rosser failure blocks",
        widthnum=20000,
        census="2 219 994", censusnum=2219994, censusprev="2 199 994", censusprevnum=2199994,
        widthprev_desc=("SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser failure "
                        "blocks (nothing to adjudicate - 0443; the 510 000 unit mark and the 2 180 000 "
                        "census mark crossed in the window)"),
        evals="33 445", seconds="4691.4", cache="0",
        runs="45 / 50", phase="4.08e-21 (radius 1.67e-24)",
        failures_n=0,
        faildesc=("ZERO recorded interior Rosser failure blocks - a CLEAN full-width window "
                  "(nothing to adjudicate). The SECOND CONSECUTIVE clean window (W110, W111): the "
                  "six-failure streak W104–W109 has ended, and the recorded mix continues to be "
                  "variable (recorded data, no pattern claim). The certificate rests on the sign-"
                  "change total b - a = 20 000 (= sign_changes_inside, CERTIFIED)."),
        verif_extra=("The window is CLEAN (zero interior Rosser failure blocks) - nothing to "
                     "adjudicate; no snap in this window (certified width = requested width = 20 "
                     "000). Certificate by sign-change total b - a = 20 000 = sign_changes_inside, "
                     "verified independently (CERTIFIED, turing_ok)."),
        win_n_clean=49, win_n_rescue=63, total_fail=95,
        incr=4672,
        mile=("the 515 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 111 (margin 3 692 - "
              "the expected window of the 0443 record, hit); the 510 000 mark (crossed at W110 "
              "[0443]) carries 3 692; the 505 000 mark (W109 [0442]) carries 8 692; the 500 000 "
              "milestone (W107 [0440]) carries 13 692; the next round mark 520 000 is 1 308 ahead "
              "(less than one standard 4 673 step; expected at W112, entry 0445)"),
        censmarks=("the 2 200 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 111 (margin "
                   "19 994 - the expected window of the 0443 record, hit); the 2 180 000 mark "
                   "(W110 [0443]) carries 39 994; the 2 160 000 mark (W109 [0442]) carries 59 994; "
                   "the 2 220 000 mark is 6 zeros ahead (the offset stays at -6 after the full "
                   "width) - recorded data, no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107,
                   505000: 109, 510000: 110, 515000: 111},
        unit="ONE-HUNDRED-ELVENTH", family="-86",
        ord_word="forty-sixth", nw=6,
        run_note="the 2026-11-18 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W111: FULL-width 20 000, CLEAN - zero interior Rosser failure blocks (the "
                     "second consecutive clean window, after W110's one-gram snap). The floor "
                     "advances by 4 672 - a recorded increment (the NINTH recorded occurrence of "
                     "4 672 overall; the endpoint fraction rose from .036 to .971, so the floor "
                     "advanced one gram less than a full standard step). The increment family so "
                     "far within CE74+: 30 x 4 673 + 6 x 4 672 + 5 (the W100 TAIL) = 168 227 - "
                     "recorded data, no pattern claim. The endpoint record ROTATES to the exponent "
                     "-86 dyadic family (after -84, -84 of W109-W110)."),
        incr_note=("a recorded 4 672 increment (the ninth occurrence of 4 672 in the recorded "
                   "series; the endpoint fraction rose from .036 to .971, so the floor advanced "
                   "one gram less than the standard step - recorded data, no pattern claim)"),
        margin_exp="1.39e-3",
        subcent_ordinal="THIRTY-SECOND",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3), W108 (9.72e-3), W109 (4.83e-3), W110 (6.29e-3), W111 (1.39e-3)"),
        new_milestone=515000,
    ),
    112: dict(
        N=112, tCE=3000175856165, gap=523365, prevgap=518692,
        gal=300017585616590, gden=100, galstr="300017585616590 / 100",
        frac="0.9064984580283966801992665... (exact, exponent -79 dyadic terminator)",
        fracmargin="0.0064984580283966801992 (exact, exponent -79 dyadic arithmetic, center-to-interval-endpoint)",
        a="12 363 155 657 124", b="12 363 155 677 124",
        ga_b="[232127363216266139000876580341880315403, -86, 16777217, -110]",
        gb_b="[1813495027951695161987220160047086117, -79, 16777217, -110]",
        width="FULL 20 000 (no snap), THREE recorded interior Rosser failure blocks - all determined and rescued, adjudication-confirmed",
        widthnum=20000,
        census="2 239 994", censusnum=2239994, censusprev="2 219 994", censusprevnum=2219994,
        widthprev_desc=("FULL 20 000, CLEAN - zero interior Rosser failure blocks (nothing to "
                        "adjudicate - 0444; second consecutive clean window; the 515 000 unit mark "
                        "and the 2 200 000 census mark crossed in the window)"),
        evals="33 881", seconds="4753.6", cache="0",
        runs="43 / 50", phase="4.10e-21 (radius 2.61e-24)",
        failures_n=3,
        faildesc=("THREE recorded interior Rosser failure blocks (the SECOND multi-failure "
                  "window, after W108's three) - all DETERMINED = true (each need 2, changes 0, "
                  "129 points, m = 64). Pipeline rescue on each union span: [12 363 155 663 751, "
                  "12 363 155 663 755] need 4 found 4 (m = 8); [12 363 155 665 657, 12 363 155 "
                  "665 662] need 5 found 5 (m = 4); [12 363 155 673 082, 12 363 155 673 086] "
                  "need 4 found 4 (m = 4). Independent fresh-mpmath adjudication (pinned at "
                  "tmp/ce2/ce1_window_H0_v1/window112_union_adjudication.json): all three unions "
                  "re-counted fresh (4 / 4, 5 / 5, 4 / 4), near_zero_touch = 0 on all (min |Z| "
                  "6.73e-4, 5.88e-4, 5.01e-4), all 4 unflagged control spans pass (2/2, 2/2, 2/2, "
                  "3/3). VERDICT: ALL SPANS RESOLVED - window sign-change total = b - a, CERTIFIED "
                  "by verifier."),
        verif_extra=("The certificate rests on the sign-change total b - a = 20 000. The THREE "
                     "recorded interior Rosser failures are all DETERMINED and were rescued by the "
                     "pipeline on their union spans (4/4, 5/5, 4/4); an independent fresh-mpmath "
                     "re-evaluation (window112_union_adjudication.json) confirms all three rescue "
                     "counts from scratch (4/4, 5/5, 4/4) with no near-zero touches and all four "
                     "control spans passing - the Tenth full cycle of the W97-family "
                     "adjudication protocol."),
        win_n_clean=49, win_n_rescue=66, total_fail=98,
        incr=4673,
        mile=("the 520 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 112 (margin 3 365 - "
              "the expected window of the 0444 record, hit); the 515 000 mark (crossed at W111 "
              "[0444]) carries 3 365; the 510 000 mark (W110 [0443]) carries 8 365; the 500 000 "
              "milestone (W107 [0440]) carries 18 365; the next round mark 525 000 is 1 635 ahead "
              "(expected at W113, entry 0446)"),
        censmarks=("the 2 220 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 112 (margin "
                   "19 994 - the expected window of the 0444 record, hit); the 2 200 000 mark "
                   "(W111 [0444]) carries 39 994; the 2 180 000 mark (W110 [0443]) carries 59 994; "
                   "the 2 240 000 mark is 6 zeros ahead (the offset stays at -6) - recorded data, "
                   "no pattern claim"),
        milecross={175000: 38, 200000: "42B", 225000: 48, 250000: 53, 275000: 58, 300000: 64,
                   325000: 69, 350000: 74, 375000: 80, 400000: 85, 425000: 90, 430000: 92, 435000: 93,
                   440000: 94, 445000: 95, 450000: 96, 455000: 97, 460000: 98, 465000: 99, 470000: 101,
                   475000: 102, 480000: 103, 485000: 104, 490000: 105, 495000: 106, 500000: 107,
                   505000: 109, 510000: 110, 515000: 111, 520000: 112},
        unit="ONE-HUNDRED-TWELFTH", family="-79",
        ord_word="forty-seventh", nw=6,
        run_note="the 2026-11-18 fresh run (resumed_from_cache = 0, logged for provenance)",
        parallel_note="",
        shrink_note=("W112: FULL-width 20 000 with THREE recorded interior Rosser failure blocks - "
                     "the SECOND multi-failure window recorded (after W108's three). All three "
                     "blocks are DETERMINED and were rescued by the pipeline on their union spans "
                     "(4/4, 5/5, 4/4); the independent fresh-mpmath adjudication confirms all three "
                     "rescue counts from scratch with no near-zero touches and all four control "
                     "spans passing (Tenth W97-family protocol cycle). The floor advances by the "
                     "STANDARD 4 673; the endpoint record introduces the exponent -79 dyadic "
                     "family (FIRST recorded appearance - the post-target family record is now "
                     "-86, -85, -84, -83, -79: recorded data, no pattern claim). The two "
                     "consecutive clean windows W110-W111 end with this window (recorded data, no "
                     "trend claim). Recorded increment series CE74 -> CE112 (38 increments): 31 x "
                     "4 673 + 6 x 4 672 + 5 (the W100 TAIL) = 172 900: 350 465 -> 523 365."),
        incr_note="the standard 4 673 floor increment (recorded data, no pattern claim)",
        margin_exp="6.50e-3",
        subcent_ordinal="THIRTY-THIRD",
        subcent_list=("W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 "
                      "(7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), "
                      "W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), "
                      "W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), "
                      "W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), "
                      "W107 (4.62e-3), W108 (9.72e-3), W109 (4.83e-3), W110 (6.29e-3), W111 (1.39e-3), "
                      "W112 (6.50e-3)"),
        new_milestone=520000,
    ),
}



def rep(s, old, new, n=1, label=""):
    c = s.count(old)
    assert c == n, f"[{label}] count {c} != {n}: {old[:90]!r}"
    return s.replace(old, new)


def gen_ce(N):
    F = FACTS[N]
    P = N - 1
    gap = F["gap"]
    prevgap = F["prevgap"]
    censusnum = F["censusnum"]
    censusprev = F["censusprevnum"]
    entry = "0431" if N == 101 else "0%d" % (418 + N - 97)  # 0423-0430 taken by the L1 lane
    src = open(f"{ROOT}/CE{P}.lean").read()

    # ---- per-window record phrases (docstring narratives)
    WR = {  # short window record (rhre doc style)
        95: "NON-SNAPPED 20 000, TWO recorded interior failures - both determined and rescued",
        96: "NON-SNAPPED 20 000, CLEAN - zero failures",
        97: "SNAPPED 19 997, THREE recorded interior failures - all determined and rescued",
        98: "NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined at m = 64; the "
            "rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 fresh-mpmath adjudication - "
            "fresh 5 / 5 / 5, no near-zero touch)",
        99: "NON-SNAPPED 20 000, CLEAN - zero failures",
        100: "TAIL 21, CLEAN - zero failures",
        101: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0431 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero "
             "touch)",
        102: "SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - zero "
             "recorded interior failures",
        103: "SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - "
             "zero recorded interior failures",
        104: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0437 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 6 / 6, no near-zero "
             "touch, 4/4 control spans pass)",
        105: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0438 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero "
             "touch, 4/4 control spans pass)",
        106: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0439 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero "
             "touch, 4/4 control spans pass)",
        107: "SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined "
             "and rescued; the 0440 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 "
             "/ 4, no near-zero touch, 4/4 control spans pass)",
        108: "NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all determined and "
             "rescued; the 0441 fresh-mpmath adjudication RE-CONFIRMS ALL THREE rescue counts "
             "(fresh 5 / 5, 5 / 5, 5 / 5, no near-zero touch, 4/4 control spans pass) - the first "
             "multi-failure window of the program",
        109: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0442 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero "
             "touch, 4/4 control spans pass)",
        110: "SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser failure blocks "
             "(nothing to adjudicate; certificate by sign-change total) - the first clean window "
             "since W103",
        111: "FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change "
             "total; second consecutive clean window)",
        112: "FULL 20 000, THREE recorded interior Rosser failures - all determined and rescued, "
             "adjudication-confirmed (fresh 4/4, 5/5, 4/4; Tenth full W97-family protocol cycle)",
    }
    IFFREC = {  # iff-doc window-slice records
        95: "NON-SNAPPED 20 000 with two recorded interior failures, both determined and rescued",
        96: "NON-SNAPPED 20 000, CLEAN - zero failures",
        97: "SNAPPED 19 997 with three recorded interior failures - all determined and rescued",
        98: "NON-SNAPPED 20 000 with three recorded interior Rosser failures (determined at m = 64; "
            "the rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 fresh-mpmath "
            "adjudication - fresh 5 / 5 / 5; the stale pre-reboot 'over-prediction' reading is an "
            "audited erratum (0424); the certificate rests on the sign-change total)",
        99: "NON-SNAPPED 20 000, CLEAN - zero failures",
        100: "TAIL 21, CLEAN - zero failures",
        101: "NON-SNAPPED 20 000 with one recorded interior Rosser failure (determined; the rescue "
             "union FOUND 4 RE-CONFIRMED by the 0431 fresh-mpmath adjudication - fresh 4 / 4, no "
             "near-zero touch; the certificate rests on the sign-change total)",
        102: "SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - zero "
             "recorded interior failures",
        103: "SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - "
             "zero recorded interior failures",
        104: "NON-SNAPPED 20 000 with one recorded interior Rosser failure (determined; the rescue "
             "union FOUND 6 RE-CONFIRMED by the 0437 fresh-mpmath adjudication - fresh 6 / 6, no "
             "near-zero touch; the certificate rests on the sign-change total)",
        105: "NON-SNAPPED 20 000 with one recorded interior Rosser failure (determined; the rescue "
             "union FOUND 4 RE-CONFIRMED by the 0438 fresh-mpmath adjudication - fresh 4 / 4, no "
             "near-zero touch; the certificate rests on the sign-change total)",
        106: "NON-SNAPPED 20 000 with one recorded interior Rosser failure (determined; the rescue "
             "union FOUND 5 RE-CONFIRMED by the 0439 fresh-mpmath adjudication - fresh 5 / 5, no "
             "near-zero touch; the certificate rests on the sign-change total)",
        107: "SNAPPED 19 999 (one-gram b-end snap) with one recorded interior Rosser failure "
             "(determined; the rescue union FOUND 4 RE-CONFIRMED by the 0440 fresh-mpmath "
             "adjudication - fresh 4 / 4, no near-zero touch; the certificate rests on the sign-"
             "change total)",
        108: "NON-SNAPPED 20 000 with THREE recorded interior Rosser failures (all determined; the "
             "three rescue unions FOUND 5, 5, 5 RE-CONFIRMED by the 0441 fresh-mpmath adjudication "
             "- fresh 5 / 5 each, no near-zero touch; the certificate rests on the sign-change "
             "total)",
        109: "NON-SNAPPED 20 000 with one recorded interior Rosser failure (determined; the rescue "
             "union FOUND 5 RE-CONFIRMED by the 0442 fresh-mpmath adjudication - fresh 5 / 5, no "
             "near-zero touch; the certificate rests on the sign-change total)",
        110: "SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser failure blocks "
             "(the certificate rests on the sign-change total) - the first clean window since "
             "W103",
        111: "FULL 20 000, CLEAN - zero interior Rosser failure blocks (the certificate rests on the "
             "sign-change total; second consecutive clean window)",
        112: "FULL 20 000, THREE recorded interior Rosser failures - all determined and rescued "
             "(4/4, 5/5, 4/4 on the union spans), adjudication-confirmed (Tenth W97-family "
             "protocol cycle)",
    }
    WINREC2 = {  # split-doc window records
        96: "NON-SNAPPED at 20 000, CLEAN - zero recorded interior failures",
        97: "SNAPPED at 19 997 (three recorded interior failures - all determined and rescued)",
        98: "NON-SNAPPED at 20 000 (three recorded interior failures - determined at m = 64; the "
            "rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 fresh-mpmath adjudication - "
            "fresh 5 / 5 / 5; certificate by sign-change total)",
        99: "NON-SNAPPED at 20 000, CLEAN - zero recorded interior failures",
        100: "at the TAIL 21, CLEAN - zero recorded interior failures",
        101: "NON-SNAPPED at 20 000 (one recorded interior failure - determined and rescued; the 0431 "
             "adjudication re-confirms fresh 4 / 4; certificate by sign-change total)",
        102: "SNAPPED at 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - "
             "zero recorded interior failures",
        103: "SNAPPED at 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - "
             "zero recorded interior failures",
        104: "NON-SNAPPED at 20 000 (one recorded interior failure - determined and rescued; the 0437 "
             "adjudication re-confirms fresh 6 / 6; certificate by sign-change total)",
        105: "NON-SNAPPED at 20 000 (one recorded interior failure - determined and rescued; the 0438 "
             "adjudication re-confirms fresh 4 / 4; certificate by sign-change total)",
        106: "NON-SNAPPED at 20 000 (one recorded interior failure - determined and rescued; the 0439 "
             "adjudication re-confirms fresh 5 / 5; certificate by sign-change total)",
        107: "SNAPPED at 19 999 (one-gram b-end snap; one recorded interior failure - determined and "
             "rescued; the 0440 adjudication re-confirms fresh 4 / 4; certificate by sign-change "
             "total)",
        108: "NON-SNAPPED at 20 000 (three recorded interior failures - all determined and rescued; "
             "the 0441 adjudication re-confirms fresh 5 / 5 on each; certificate by sign-change "
             "total)",
        109: "NON-SNAPPED at 20 000 (one recorded interior failure - determined and rescued; the 0442 "
             "adjudication re-confirms fresh 5 / 5; certificate by sign-change total)",
        110: "SNAPPED at 19 999 (one-gram b-end snap; CLEAN - zero failures; certificate by sign-"
             "change total)",
        111: "FULL 20 000, CLEAN - zero recorded interior failures (certificate by sign-change "
             "total)",
        112: "FULL 20 000, THREE recorded interior Rosser failures - all determined and rescued, "
             "adjudication-confirmed",
    }
    UNITW = {95: "NINETY-FIFTH", 96: "NINETY-SIXTH", 97: "NINETY-SEVENTH",
             98: "NINETY-EIGHTH", 99: "NINETY-NINTH", 100: "ONE-HUNDREDTH", 101: "ONE-HUNDRED-FIRST",
             102: "ONE-HUNDRED-SECOND", 103: "ONE-HUNDRED-THIRD", 104: "ONE-HUNDRED-FOURTH",
             105: "ONE-HUNDRED-FIFTH", 106: "ONE-HUNDRED-SIXTH", 107: "ONE-HUNDRED-SEVENTH", 108: "ONE-HUNDRED-EIGHTH",
             109: "ONE-HUNDRED-NINTH",
             110: "ONE-HUNDRED-TENTH", 111: "ONE-HUNDRED-ELVENTH", 112: "ONE-HUNDRED-TWELFTH"}
    SLICENOTE = {  # aolu-doc terminal-slice notes
        97: "SNAPPED 19 997, THREE recorded interior failures - all determined and rescued",
        98: "NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined at m = 64; the "
            "rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 fresh-mpmath adjudication - "
            "fresh 5 / 5 / 5, no near-zero touch; certificate by sign-change total)",
        99: "NON-SNAPPED 20 000, CLEAN - zero failures",
        100: "TAIL 21, CLEAN - zero failures",
        101: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0431 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero "
             "touch; certificate by sign-change total)",
        102: "SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - zero "
             "recorded interior failures",
        103: "SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - "
             "zero recorded interior failures",
        104: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0437 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 6 / 6, no near-zero "
             "touch; certificate by sign-change total)",
        105: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0438 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero "
             "touch; certificate by sign-change total)",
        106: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0439 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero "
             "touch; certificate by sign-change total)",
        107: "SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined "
             "and rescued; the 0440 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 "
             "/ 4, no near-zero touch; certificate by sign-change total)",
        108: "NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all determined and "
             "rescued; the 0441 fresh-mpmath adjudication RE-CONFIRMS ALL THREE rescue counts "
             "(fresh 5 / 5 each, no near-zero touch; certificate by sign-change total)",
        109: "NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the "
             "0442 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero "
             "touch; certificate by sign-change total)",
        110: "SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - "
             "zero recorded interior failures",
        111: "FULL 20 000, CLEAN - zero recorded interior failures",
        112: "FULL 20 000, THREE recorded interior failures - all determined and rescued, "
             "adjudication-confirmed (fresh 4/4, 5/5, 4/4)",
    }
    SLICENOTE = SLICENOTE[N]

    # ---- mark tables (unit round marks: M, crossed window, entry ref, annotation)
    UNIT_MARKS = [(300000, 64, "", ""), (325000, 69, "", ""), (350000, 74, "", "first prediction"),
                  (375000, 80, "", "second prediction"), (400000, 85, "[0396]", "third prediction"),
                  (425000, 90, "[0401]", "the FOURTH PREDICTION of the series"),
                  (430000, 92, "[0403]", ""), (435000, 93, "[0405]", ""), (440000, 94, "[0406]", ""),
                  (445000, 95, "[0410]", ""), (450000, 96, "", ""), (455000, 97, "[0418]", ""),
                  (460000, 98, "[0419]", ""), (465000, 99, "[0420]", ""),
                  (470000, 101, "[0431]", ""), (475000, 102, "[0434]", ""),
                  (480000, 103, "[0436]", ""), (485000, 104, "[0437]", ""),
                  (490000, 105, "[0438]", ""), (495000, 106, "[0439]", ""), (500000, 107, "[0440]", ""), (505000, 109, "[0442]", ""), (510000, 110, "[0443]", ""), (515000, 111, "[0444]", ""), (520000, 112, "[0445]", ""), (525000, 113, "[0446]", "")]
    CENSUS_MARKS = [(1600000, 80, "[0389]"), (1700000, 85, "[0396]"), (1800000, 90, "[0401]"),
                    (1840000, 91, "[0402]"), (1860000, 92, "[0403]"), (1880000, 93, ""),
                    (1900000, 95, "[0410]"), (1920000, 96, ""), (1940000, 97, "[0418]"),
                    (1960000, 98, "[0419]"), (1980000, 99, "[0420]"), (2000000, 100, "[0421]"),
                    (2020000, 101, "[0431]"), (2040000, 103, "[0436]"), (2060000, 104, "[0437]"),
                    (2080000, 105, "[0438]"), (2100000, 106, "[0439]"), (2120000, 107, "[0440]"), (2140000, 108, "[0441]"), (2160000, 109, "[0442]"), (2180000, 110, "[0443]"), (2200000, 111, "[0444]"), (2220000, 112, "[0445]"), (2240000, 113, "[0446]")]

    def fmt(x):
        return f"{x:,}".replace(",", " ")

    def unit_narrative():
        parts = []
        for (M, K, ref, ann) in reversed(UNIT_MARKS):
            if M > gap:
                continue
            if K == N:
                parts.append(f"the {M // 1000} 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW {N} "
                             f"(margin {fmt(gap - M)} - a regular round crossing, not a predicted milestone)")
            else:
                seg = (f"the {M // 1000} 000 mark (crossed W{K}" + (f" {ref}" if ref else "") +
                       (f", {ann}" if ann else "") + f") carries {fmt(gap - M)}")
                parts.append(seg)
        above = [M for (M, K, r, a) in UNIT_MARKS if M > gap]
        nxt = min(above) if above else (gap // 5000 + 1) * 5000
        d = nxt - gap
        if d < 2336:
            ph = "less than one half-step"
        elif d < 4673:
            ph = "less than one full 4 673 step"
        else:
            ph = f"about {round(d / 4673)} full steps"
        parts.append(f"the next round mark {nxt // 1000} 000 is {fmt(d)} ahead ({ph})")
        return "; ".join(parts)

    def census_narr():
        parts = []
        for (M, K, ref) in reversed(CENSUS_MARKS):
            # post-target: the 2 000 000 mark is stated once, as the LANDED line below
            if censusnum > 2000000 and M == 2000000:
                continue
            if M <= censusprev:
                parts.append(f"the {fmt(M)} CERTIFIED-ZERO MARK (CROSSED in W{K}"
                             + (f" {ref}" if ref else "") + f") carries margin {fmt(censusnum - M)}")
                continue
            if M <= censusnum:
                if K == N:
                    parts.append(f"the {fmt(M)} CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW (margin {fmt(censusnum - M)})")
                else:
                    parts.append(f"the {fmt(M)} CERTIFIED-ZERO MARK (CROSSED in W{K}"
                                 + (f" {ref}" if ref else "") + f") carries margin {fmt(censusnum - M)}")
                continue
        d = 2000000 - censusnum
        if d > 0:
            if d <= 200:
                parts.append(f"2 000 000 is {fmt(d)} ahead (less than one zero-span - the tail window W100 will "
                             f"land it, do not pre-announce)")
            elif d <= 22000:
                parts.append(f"2 000 000 is {fmt(d)} ahead (about one full window - compute at that window, do "
                             f"not pre-announce)")
            else:
                parts.append(f"2 000 000 is {fmt(d)} ahead (about {round(d / 20000)} full windows - do not "
                             f"pre-announce)")
        else:
            parts.append(f"the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's "
                         f"target; margin at WINDOW {N}: {fmt(-d)}) - the frontier extension continues beyond "
                         f"the target (post-target phase, no new program claim)")
            if censusnum % 20000 == 0:
                pos = ("the first 20 000-mark" if censusnum == 2020000 else "another 20 000-mark")
                parts.append(f"the {fmt(censusnum)} CERTIFIED-ZERO MARK LANDS EXACTLY IN THIS WINDOW, WINDOW "
                             f"{N} ({fmt(censusprev)} + {F['widthnum']:,} = {fmt(censusnum)}, margin 0) - "
                             f"{pos} of the post-target extension")
            else:
                nm = (censusnum // 20000 + 1) * 20000
                k = nm - censusnum
                if k <= 2000:
                    parts.append(f"the {fmt(nm)} CERTIFIED-ZERO mark is {fmt(k)} zero"
                                 + ("s" if k != 1 else "") + " ahead (it lands at the start of the NEXT "
                                 "window - do not pre-announce)")
        return "; ".join(parts) + "."

    failphrase = F.get("fail_phrase") or (
        f"{F['failures_n']} recorded interior Rosser failure blocks, ALL DETERMINED and rescued"
        if F["failures_n"] else "zero recorded interior Rosser failure blocks (CLEAN)")
    bandfail = F.get("band_fail") or (
        f"{F['failures_n']} recorded interior Rosser failure blocks all determined and rescued"
        if F["failures_n"] else "zero recorded interior Rosser failure blocks (CLEAN)")
    rescued_note = F.get("rescued_note") or (" all determined and rescued, " if F["failures_n"] else "")
    prov_fail = F.get("prov_fail") or "(ALL DETERMINED and rescued - see the W" + str(N) + " record above)"
    adjud_note = (f", the {entry} independent fresh-mpmath union-span adjudication of the {F['failures_n']} "
                  f"rescued spans" if F["failures_n"] else "")
    frac2 = f"{(F['gal'] % F['gden']) / F['gden']:.2f}"
    cens_used = F["censmarks"] or census_narr()

    # ---------- anchors (verified against the source at run time)
    A_hdr_i = src.index(f"/-!\n**CE{P} -")
    A_hdr_j = src.index(f"namespace CE{P}\n")
    A_cons_i = src.index(f"/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b{P} ")
    A_cons_j = src.index(f"norm_num [CE{P-1}.gB{P-1}Lo, gB{P}Lo]")
    A_cons_j = src.index("\n", A_cons_j) + 1
    A_wdef_i = src.rindex("/--", 0, src.index(f"def ce{P}WinClause : Prop"))
    A_wdef_j = src.index(f"ρ.im ≤ (tCE{P} : ℝ) → ρ.re = 1 / 2\n", src.index(f"def ce{P}WinClause : Prop"))
    A_wdef_j += len(f"ρ.im ≤ (tCE{P} : ℝ) → ρ.re = 1 / 2\n")
    A_band_doc_i = src.rindex("/--", 0, src.index(f"theorem bandOfWindows{P}"))
    A_band_i = src.index(f"theorem bandOfWindows{P}")
    A_band_j = src.index("\n/-! ### 3", A_band_i)
    A_aolu_doc_i = src.rindex("/--", 0, src.index(f"theorem allOnLineUpToCE{P}"))
    A_aolu_i = src.index(f"theorem allOnLineUpToCE{P}")
    A_tf_i = src.rindex("/--", 0, src.index(f"def terminalFaceCE{P} (q : ZeroSet) : Prop :="))

    # ---------- header
    hdr = f"""/-!
**CE{N} - the terminal face re-anchored at the {F['unit']} certified window
({entry}, option B - lane M5).

MILESTONE STATE: tCE{N} - tPT2 = {gap:,} - {F['mile']}.
CERTIFIED-ZERO CENSUS: cumulative total {F['census']} over (g_a1, g_b{N}] -
{cens_used}

WINDOW {N}: {F['width']} (a = {F['a']} = b{P} (the bit-identical seam), b = {F['b']}; certified width
{F['widthnum']:,}). {F['faildesc']}. Census: the window adds {F['widthnum']:,} certified zeros
({F['censusprev']} + {F['widthnum']:,} = {F['census']}). Cumulative tally through window {N}: {N}
windows - {F['win_n_clean']} clean, {F['win_n_rescue']} rescue; {F['total_fail']} total internal Rosser
failures, ALL RECORDED. End Rosser runs: {F['runs']} left of g_a{N} / right of g_b{N} (both >= K = 12); 0
cross-check failures; 0 undetermined Gram signs; max phase contribution {F['phase']}.

PIPELINE RUN ({F['ord_word']} in the overlap pipeline): {F['run_note']} {F['nw']} workers: {F['evals']}
evaluations in {F['seconds']} s (same M = 60, C_R = 1, N_range = [691 008, 691 008], same pipeline, same
verifier, same seam discipline).{F['parallel_note']}

PROVENANCE (our run, 2026-11-16; pipeline = Murphy's Apache-2.0 deposit, same as CE1-CE{P}): RUN
PARAMETERS: a = {F['a']} (= b{P}), b = {F['b']} ({F['width']}), M = 60, C_R = 1, {F['nw']} workers, {F['evals']}
evaluations, {F['seconds']} s, resumed_from_cache = {F['cache']}. CERTIFICATE (window{N}_b{N}.json): the
{F['widthnum']:,} (= b - a) zeros of zeta with g_a{N} < Im s <= g_b{N} are ALL SIMPLE and on the line,
where g_a{N} (recorded exact dyadic ball) is {F['ga_b']} (the W{P} endpoint g_b{P}, the W{N} seam g_a{N}
BIT-IDENTICAL - exact dyadic tuple comparison, audited BEFORE this module was written, per the 0348
process rule), and g_b{N} has exact dyadic tuple {F['gb_b']} (the {F['family']} dyadic family). The floor
tCE{N} = {F['tCE']:,} sits {F['fracmargin']} below the certified lower bound (EXACT dyadic arithmetic,
center-minus-radius reading; robust to the certified radius ~4.7e-14 by many orders of magnitude); the
standard two-decimal lower bound gB{N}Lo ({F['galstr']} = {F['gal']/F['gden']:.2f}) has the exact margin
{F['fracmargin']}; the two-decimal round-down ({frac2}) is strictly below the exact fractional part
({F['frac']}), so no CASING is needed - window 38 / CE38 remains the only CASING case so far. (The
gB{N}Lo margin {F['margin_exp']} is the {F['subcent_ordinal']} sub-cent case in the current run:
{F['subcent_list']}; not a precision danger - the certified radius is ~4.7e-14, four orders of
magnitude smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE{P}): (1) ENVIRONMENT REPEAT (Murphy's window-1 certificate
re-verified - see CE2 header); (2) PIPELINE VERIFIER on window{N}_b{N}.json: "CERTIFIED: true",
points_checked = {F['evals']}, sign_changes_inside = {F['widthnum']:,} (= b - a),
rosser_failures_inside = {F['failures_n']} {prov_fail},
turing_ok = true, K_conservative = 12, end Rosser runs {F['runs']}; (3) SEAM AUDIT (this run): the
recorded g_a{N} ball is bit-identical to CE{P}'s recorded g_b{P} ball (exact dyadic decode,
2026-11-16). {F['verif_extra']}
FRONTIER ARITHMETIC (machine, below): tCE{N} = {F['tCE']:,}, tCE{N} - tCE{P} = {F['incr']},
tCE{N} - tPT2 = {gap:,}.
HONESTY (trust base): as CE2-CE{P} - the pipeline's own controls, its kernel-checked Lean remainder
theorem, and our verification layers; a RE-RUN of a third-party pipeline, not a from-scratch independent
certification. Cumulative certified count = {F['census']} over (g_a1, g_b{N}] (pipeline data, not
in-tree arithmetic). NO RH CLAIM.
-/
"""

    # ---------- segment A: constants .. gB ordering
    CARRY_ALL = [175000, 200000, 225000, 250000, 275000] + [M for (M, K, r, a) in UNIT_MARKS if M != 350000]  # 350 000 has its dedicated chain proof
    carried = [M for M in CARRY_ALL if M <= gap and F["milecross"].get(M) != N]
    crossed_now = [M for M in CARRY_ALL if M <= gap and F["milecross"].get(M) == N]
    mile = []
    for M in carried:
        K = F["milecross"][M]
        label = "MILESTONE CARRIED (machine, PROVEN - norm_num + linarith)"
        mile.append(f"/-- {label}: the {M // 1000} 000-unit mark (CROSSED in WINDOW {K} - see the CE{K} module for the crossing record and margin) is carried at WINDOW-{N}: (tCE{N} : R) - WinC.tPT2 = {gap:,} > {M:,}, margin {gap - M:,}. -/\n"
                    f"theorem frontierPast{M // 1000}k : (tCE{N} : ℝ) - WinC.tPT2 > {M} := by\n"
                    f"  have h : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := frontierGapAboveH0\n"
                    f"  linarith [h]\n\n")
    for M in crossed_now:
        mile.append(f"/-- MILESTONE CROSSED IN THIS WINDOW (machine, PROVEN - norm_num + linarith): {F['mile']}. -/\n"
                    f"theorem frontierPast{M // 1000}k : (tCE{N} : ℝ) - WinC.tPT2 > {M} := by\n"
                    f"  have h : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := frontierGapAboveH0\n"
                    f"  linarith [h]\n\n")
    chain = []
    for k in range(N, 74, -1):
        ref = f"faceShrinkCE{N}" if k == N else f"CE{k}.faceShrinkCE{k}"
        chain.append(f"  have hshrink{len(chain)+1} : (tCE{k} : ℝ) - (tCE{k-1} : ℝ) = {shrink(k)} := {ref}")
    nsh = len(chain)
    sumsh = sum(shrink(k) for k in range(75, N + 1))
    n4673 = sum(1 for k in range(75, N + 1) if shrink(k) == 4673)
    n4672 = sum(1 for k in range(75, N + 1) if shrink(k) == 4672)
    tail100 = 1 if N == 100 else 0
    snaps_in = [k for k in range(75, N + 1) if shrink(k) == 4672]
    snaplist = ", ".join(f"w{k-1} -> w{k}" for k in snaps_in)
    shrink_desc = f"{n4673} times 4 673 + {n4672} times 4 672 SNAP [{snaplist}]"
    if tail100:
        shrink_desc += " + the W100 TAIL increment of 5"
    cons = f"""/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b{N} (machine): gB{N}Lo = {F['galstr']} = {F['gal']/F['gden']:.2f} - the two-decimal round-down of the certified lower bound (the endpoint g_b{N} minus the certified radius ~4.7e-14). The margin is the exact {F['fracmargin']}; the two-decimal round-down ({frac2}) is strictly below the exact fractional part ({F['frac']}), so no CASING is needed (window 38 / CE38 remains the only CASING case). The {F['margin_exp']} margin is the {F['subcent_ordinal']} sub-cent case in the current run - not a precision danger (certified radius ~4.7e-14). -/
def gB{N}Lo : ℚ := {F['gal']} / {F['gden']}

/-- THE NEW LOWER BOUND (machine): {F['tCE']:,} = floor(g_b{N}). The endpoint sits {F['frac']} above the integer boundary (exact, exponent -86 dyadic terminator) and the certified radius is ~4.7e-14, so the floor is robust by many orders of magnitude. tCE{N} - tCE{P} = {F['incr']} ({F['incr_note']}). -/
def tCE{N} : ℕ := {F['tCE']}

theorem tCE{N}_lt_gB{N}Lo : (tCE{N} : ℝ) < (gB{N}Lo : ℝ) := by
  norm_num [gB{N}Lo, tCE{N}]

theorem tCE{P}_lt_tCE{N} : (tCE{P} : ℝ) < (tCE{N} : ℝ) := by
  norm_num [CE{P}.tCE{P}, tCE{N}]

/-- ORDERING (machine, norm_num): (gB{P}Lo : R) < (tCE{N} : R), with gB{P}Lo the STANDARD lower bound introduced at CE{P} and tCE{N} = {F['tCE']:,}. So the window-{N} terminal slice starts strictly below the new floor. -/
theorem gB{P}Lo_lt_tCE{N} : (gB{P}Lo : ℝ) < (tCE{N} : ℝ) := by
  norm_num [CE{P}.gB{P}Lo, tCE{N}]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE{N} - tCE{P} = {F['incr']}. {F['shrink_note']} -/
theorem faceShrinkCE{N} : (tCE{N} : ℝ) - (tCE{P} : ℝ) = {F['incr']} := by
  norm_num [tCE{N}, CE{P}.tCE{P}]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE{N} : R) - WinC.tPT2 = {F['tCE']:,} - 3 000 175 332 800 = {gap:,} above the H0 frontier WinC.tPT2. {F['mile'].capitalize()}. CERTIFIED-ZERO CENSUS: cumulative total {F['census']} over (g_a1, g_b{N}] - {cens_used} -/
theorem frontierGapAboveH0 : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := by
  norm_num [tCE{N}, WinC.tPT2]

""" + "".join(mile) + f"""/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379]); CARRIED into WINDOW-{N} - tCE{N} - tPT2 = {gap:,} exceeds 350 000 with margin {gap - 350000:,}. Proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, through {nsh} face increments (CE75-CE{N}: {shrink_desc}; total {sumsh:,}: 350 465 + {sumsh:,} = {gap:,}). -/
theorem frontierPast350k : (tCE{N} : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := frontierGapAboveH0
""" + "\n".join(chain) + f"""
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [{', '.join('hshrink%d' % (r + 1) for r in range(nsh))}]
  linarith [h]

/-- ORDERING (machine, norm_num): (gB{P}Lo : R) < (gB{N}Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB{P}Lo the STANDARD lower bound on the window-{P} endpoint g_b{P} and gB{N}Lo = {F['galstr']} the STANDARD lower bound on the window-{N} endpoint g_b{N} (the {F['family']} dyadic family; the exact dyadic tuple is authoritative over the exponent representation). -/
theorem gB{P}Lo_lt_gB{N}Lo : (gB{P}Lo : ℝ) < (gB{N}Lo : ℝ) := by
  norm_num [CE{P}.gB{P}Lo, gB{N}Lo]

"""

    # ---------- window slice defs (fresh)
    wdefs = (f"/-- WINDOW {P} FULL slice (re-cited in the W{N} band - window {P} of {N}, the full recorded window "
             f"(gB{P-1}Lo, gB{P}Lo]; W{P} record: {F['widthprev_desc']}): the zeros of zeta with\n"
             f"(gB{P-1}Lo : R) < Im s <= (gB{P}Lo : R) are all simple and on the line. Provenance: window{P}_b{P}.json\n"
             f"(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE{P} module (seam/audit record,\n"
             f"carried). Slice restriction (gB{P-1}Lo, gB{P}Lo] is a SUBSET of the certified window, so its zeros\n"
             f"inherit on-linedness; no RH CLAIM about window {P}. -/\n"
             f"def ce{P}WinClauseFull : Prop :=\n"
             f"    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB{P-1}Lo : ℝ) < ρ.im →\n"
             f"      ρ.im ≤ (gB{P}Lo : ℝ) → ρ.re = 1 / 2\n\n"
             f"/-- WINDOW {N} TERMINAL slice (window {N} of {N}, the (gB{P}Lo, g_b{N}] portion of the recorded window,\n"
             f"up to floor(gB{N}) - {F['width']} (b = {F['b']}; {failphrase} - see the module header):\n"
             f"the zeros of zeta with\n"
             f"(gB{P}Lo : R) < Im s <= int(gB{N}) = {F['tCE']:,} (the FLOOR - the endpoint g_b{N} sits\n"
             f"{F['frac']} above it, exact, robust to the certified radius ~4.7e-14) are all simple and on the\n"
             f"line. Certificates: window{N}_b{N}.json (window {N}; certified 2026-11-16) + the pipeline verifier\n"
             f"(CERTIFIED, turing_ok, points {F['evals']}, sign_changes_inside = {F['widthnum']:,} = b - a,\n"
             f"rosser_failures_inside = {F['failures_n']}{rescued_note}end Rosser runs {F['runs']},\n"
             f"K_conservative = 12) + the module header (M = 60, C_R = 1, the bit-identical g_a{N} == g_b{P}\n"
             f"SEAM AUDIT{adjud_note}). Slice restriction (gB{P}Lo, int(gB{N})] is a SUBSET of the certified window, so\n"
             f"its zeros inherit on-linedness; no RH CLAIM about the face above g_b{N}. -/\n"
             f"def ce{N}WinClause : Prop :=\n"
             f"    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB{P}Lo : ℝ) < ρ.im →\n"
             f"      ρ.im ≤ (tCE{N} : ℝ) → ρ.re = 1 / 2\n\n")

    # ---------- segment C: band theorem (doc + proof; signature/goal/tail refreshed)
    band = src[A_band_i:A_band_j]
    docC = (f"/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h{P + 2}\n"
            f"(window {N} contributes ONE clause for its (gB{P}Lo, tCE{N}] slice - h{P + 2}; W{N} {F['width']}\n"
            f"certified b = {F['b']}, {bandfail}; window {P} re-cited in full at gB{P-1} - h{P + 1}), ALL zeros of zeta with Im s >\n"
            f"WinC.tPT2 and Im s <= (tCE{N} : R) lie on the line: h1-h2 cover window 1 (CE2, the\n"
            f"Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the\n"
            f"W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..{N} enter as their certified (gB-prev,\n"
            f"gB] slices (bit-identical at every seam; the re-cited full-slice clause carries the full\n"
            f"recorded window). CUMULATIVE tally through window {N}: {N} windows - {F['win_n_clean']} clean,\n"
            f"{F['win_n_rescue']} rescue; {F['total_fail']} total internal Rosser failures, ALL RECORDED. NO RH CLAIM\n"
            f"about Im s > tCE{N}. -/\n")
    band = rep(band, f"theorem bandOfWindows{P}", f"theorem bandOfWindows{N}", label="band-name")
    band = rep(band, f"(h{P} : ce{P-1}WinClauseFull) (h{P+1} : ce{P}WinClause) :",
               f"(h{P} : ce{P-1}WinClauseFull) (h{P+1} : ce{P}WinClauseFull) (h{P+2} : ce{N}WinClause) :",
               label="band-sig")
    band = rep(band, f"      ρ.im ≤ (tCE{P} : ℝ) → ρ.re = 1 / 2 := by",
               f"      ρ.im ≤ (tCE{N} : ℝ) → ρ.re = 1 / 2 := by", label="band-goal")
    last_old = f"· exact h{P+1} ρ hz (not_le.mp hseam{P}) htH"
    assert last_old in band, "band last level"
    k = band.rfind(last_old)
    line_start = band.rfind("\n", 0, k) + 1
    ind = band[line_start:k]
    tail = (f"{ind}· by_cases hseam{P+1} : ρ.im ≤ (gB{P}Lo : ℝ)\n"
            f"{ind}  · exact h{P+1} ρ hz (not_le.mp hseam{P}) hseam{P+1}\n"
            f"{ind}  · exact h{P+2} ρ hz (not_le.mp hseam{P+1}) htH")
    band = band[:line_start] + tail + band[k + len(last_old):]

    # ---------- segment D: allOnLineUpTo (doc + theorem incl. body; ends where segE begins)
    aolu = src[A_aolu_i:A_tf_i]
    aolu_doc = src[A_aolu_doc_i:A_aolu_i]
    aolu = rep(aolu, f"theorem allOnLineUpToCE{P}", f"theorem allOnLineUpToCE{N}", label="aolu-name")
    aolu = rep(aolu, f"(hW{P} : ce{P-1}WinClauseFull) (hW{P+1} : ce{P}WinClause)\n",
               f"(hW{P} : ce{P-1}WinClauseFull) (hW{P+1} : ce{P}WinClauseFull) (hW{P+2} : ce{N}WinClause)\n",
               label="aolu-sig")
    aolu = rep(aolu, f"WinC.allOnLineUpTo q (tCE{P} : ℝ) := by", f"WinC.allOnLineUpTo q (tCE{N} : ℝ) := by",
               label="aolu-goal")
    aolu = rep(aolu, f"have hband := bandOfWindows{P} hW1", f"have hband := bandOfWindows{N} hW1", label="aolu-census")
    aolu = rep(aolu, f" hW{P+1}\n", f" hW{P+1} hW{P+2}\n", label="aolu-hW98")
    # allOnLineUpTo docstring: wholesale regenerate (census narrative is per-window)
    aolu_doc = (f"/-- THE {N}-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the "
                f"(data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE{N} : R) lie on the line, "
                f"given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member "
                f"is a zeta zero; hW1..h{P+2} : the {P+2} verified window-slice clauses - the cited slices + the "
                f"RE-CITED full slices for the re-anchored windows 43..{P} (bit-identical seams, recorded data, "
                f"incl. the recorded Rosser failure blocks of the re-anchored windows - all determined and "
                f"rescued) + h{P+2} : the window-{N} terminal slice ({SLICENOTE})). This is the finite-height "
                f"closure through the corrected w1-w{N} band (W42b fill) re-anchored to all of the certified "
                f"{F['unit']} window ({F['width']}); census {F['census']} over (g_a1, g_b{N}] - {census_narr()} "
                f"NO RH CLAIM about the face above tCE{N}. -/\n")

    # ---------- segment E: terminal face .. EOF
    E = src[A_tf_i:]
    def Erep(old, new, n=1, label=""):
        nonlocal E
        E = rep(E, old, new, n=n, label=label)

    Erep(f"def terminalFaceCE{P} (q : ZeroSet) : Prop :=", f"def terminalFaceCE{N} (q : ZeroSet) : Prop :=")
    Erep(f"(tCE{P} : ℝ) < ρ.im → ρ.re = 1 / 2", f"(tCE{N} : ℝ) < ρ.im → ρ.re = 1 / 2")
    Erep(f"theorem faceCE{P-1}_implies_faceCE{P}", f"theorem faceCE{P}_implies_faceCE{N}")
    Erep(f"(hface : CE{P-1}.terminalFaceCE{P-1} q)", f"(hface : CE{P}.terminalFaceCE{P} q)")
    Erep(f"exact hface ρ hρ (by linarith [tCE{P-1}_lt_tCE{P}, ht])",
         f"exact hface ρ hρ (by linarith [tCE{P}_lt_tCE{N}, ht])")
    Erep(f"theorem terminalFaceCE{P}_iff_faceCE{P-1}", f"theorem terminalFaceCE{N}_iff_faceCE{P}")
    Erep(f"(hW{P} : ce{P-1}WinClauseFull) (hW{P+1} : ce{P}WinClause) :",
         f"(hW{P+1} : ce{P}WinClauseFull) (hW{P+2} : ce{N}WinClause) :", label="iff-sig")
    Erep(f"terminalFaceCE{P} q ↔ CE{P-1}.terminalFaceCE{P-1} q",
         f"terminalFaceCE{N} q ↔ CE{P}.terminalFaceCE{P} q")
    Erep(f"by_cases hmid : ρ.im ≤ (tCE{P} : ℝ)", f"by_cases hmid : ρ.im ≤ (tCE{N} : ℝ)")
    ifi = E.index(f"theorem terminalFaceCE{N}_iff_faceCE{P}")
    ifj = E.index("· exact faceCE", ifi)
    ifscope = E[ifi:ifj]
    ifscope = rep(ifscope, f"· by_cases hseam{P} : ρ.im ≤ (gB{P-1}Lo : ℝ)",
                  f"· by_cases hseam{P+1} : ρ.im ≤ (gB{P}Lo : ℝ)", label="iff-hseam")
    ifscope = rep(
        ifscope,
        f"      · exact hW{P} ρ (hqz ρ hρ) (by linarith [ht, CE{P-1}.gB{P-2}Lo_lt_tCE{P-1}, tCE{P-1}_lt_tCE{P}]) hseam{P}\n"
        f"      · exact hW{P+1} ρ (hqz ρ hρ) (not_le.mp hseam{P}) hmid",
        f"      · exact hW{P+1} ρ (hqz ρ hρ) (by linarith [ht, CE{P}.gB{P-1}Lo_lt_tCE{P}, tCE{P}_lt_tCE{N}]) hseam{P+1}\n"
        f"      · exact hW{P+2} ρ (hqz ρ hρ) (not_le.mp hseam{P+1}) hmid", label="iff-2lines")
    E = E[:ifi] + ifscope + E[ifj:]
    Erep(f"· exact faceCE{P-1}_implies_faceCE{P} q", f"· exact faceCE{P}_implies_faceCE{N} q")
    Erep(f"rh_split_at_CE{P}", f"rh_split_at_CE{N}", n=2, label="split-refs")
    Erep(f"RH q ↔ WinC.allOnLineUpTo q (tCE{P} : ℝ) ∧ terminalFaceCE{P} q",
         f"RH q ↔ WinC.allOnLineUpTo q (tCE{N} : ℝ) ∧ terminalFaceCE{N} q")
    Erep(f"by_cases hle : ρ.im ≤ (tCE{P} : ℝ)", f"by_cases hle : ρ.im ≤ (tCE{N} : ℝ)")
    Erep(f"by_cases hle : (star ρ).im ≤ (tCE{P} : ℝ)", f"by_cases hle : (star ρ).im ≤ (tCE{N} : ℝ)", n=1)
    Erep(f"theorem rh_reanchored_CE{P}", f"theorem rh_reanchored_CE{N}")
    Erep(f"(hW{P} : ce{P-1}WinClauseFull) (hW{P+1} : ce{P}WinClause)\n",
         f"(hW{P} : ce{P-1}WinClauseFull) (hW{P+1} : ce{P}WinClauseFull) (hW{P+2} : ce{N}WinClause)\n",
         n=2, label="hW-tails")
    Erep(f"have hcensus := allOnLineUpToCE{P} q hZPT2", f"have hcensus := allOnLineUpToCE{N} q hZPT2")
    k = E.index("have hcensus := allOnLineUpToCE%d q hZPT2" % N)
    k2 = E.index(" hqz", k)
    E = E[:k2] + f" hW{P+2}" + E[k2:]
    Erep(f"rh_reanchored_CE{P} q hZPT2", f"rh_reanchored_CE{N} q hZPT2")
    k = E.index(f"rh_reanchored_CE{N} q hZPT2")
    k2 = E.index(" hqz", k)
    E = E[:k2] + f" hW{P+2}" + E[k2:]
    Erep(f"theorem rh_of_terminalFaceCE{P}", f"theorem rh_of_terminalFaceCE{N}")
    Erep(f"(hFace : terminalFaceCE{P} q) :", f"(hFace : terminalFaceCE{N} q) :")
    Erep(f"theorem terminalFaceCE{P}_of_thetaInf", f"theorem terminalFaceCE{N}_of_thetaInf")
    c = len(re.findall(r"(?<![A-Za-z0-9_.])terminalFaceCE%d q := by" % P, E))
    assert c == 3, f"tf-concl count {c}"
    E = re.sub(r"(?<![A-Za-z0-9_.])terminalFaceCE%d q := by" % P, f"terminalFaceCE{N} q := by", E)
    Erep(f"end CE{P}", f"end CE{N}")
    # ---- docstring layer: exact scoped transforms (each asserted)
    tfdef_idx = E.index(f"def terminalFaceCE{N}")
    new_tfdoc = (f"/-- THE {F['unit']} RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the "
                 f"absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains "
                 f"open at the {F['unit']} certified window ({F['width']}, b = {F['b']}, {failphrase}; census "
                 f"{F['census']} over (g_a1, g_b{N}]) is the assertion that every zeta zero of the "
                 f"(data-independent) zero set q with Im s > (tCE{N} : R) = {F['tCE']:,} lies on the line - i.e. "
                 f"the absolute clause [S1] and A1 (no data-dependent bound on the S-at-zeros and DN walk) above "
                 f"the new lower bound. Frontier {gap:,} above H0: {unit_narrative()}; {census_narr()} The "
                 f"increment tCE{N} - tCE{P} = {F['incr']} ({F['incr_note']}). The face is RE-ANCHORED (the "
                 f"exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated "
                 f"at the new frontier. -/\n")
    E = new_tfdoc + E[tfdef_idx:]
    # rh_reanchored docstring: scoped token transforms (parametric in P)
    rhre_i = E.index(f"theorem rh_reanchored_CE{N}")
    rr0 = E.rindex("/--", 0, rhre_i)
    sc = E[rr0:rhre_i]
    for old, new in [
        (f"the {P+1} verified window-slice clauses - windows 1..{P}, incl. the re-anchored 43..{P}",
         f"the {P+2} verified window-slice clauses - windows 1..{P+1}, incl. the re-anchored 43..{N}"),
        (f"W{P}: {WR[P]})", f"W{P}: {WR[P]}; W{N}: {WR[N]})"),
        (f"the NAMED terminal face above tCE{P} - the finite-height part",
         f"the NAMED terminal face above tCE{N} - the finite-height part"),
        (f"the corrected w1-w{P} band", f"the corrected w1-w{N} band"),
        (f"windows 43..{P}, all of them bit-identical at their seams",
         f"windows 43..{N}, all of them bit-identical at their seams"),
    ]:
        assert sc.count(old) == 1, f"rhre doc: {old[:70]!r} (count {sc.count(old)})"
        sc = sc.replace(old, new)
    E = E[:rr0] + sc + E[rhre_i:]
    # iff / split / monotonicity docstrings: exact token transforms (parametric in P)
    import re as _re
    mif = _re.search(r"beyond the cited window-data slices (hW\d+, hW\d+)\): terminalFaceCE" + str(P) + " q <-> terminalFaceCE" + str(P - 1) + " q", E)
    assert mif, "iff header pattern not found"
    E = E[:mif.start()] + (f"beyond the cited window-data slices hW{P+1}, hW{P+2}): terminalFaceCE{N} q <-> terminalFaceCE{P} q") + E[mif.end():]
    for old, new in [
        (f"what was open at tCE{P-1} is (exactly) what is open at tCE{P}, and the slice family (gB{P-1}Lo, "
         f"tCE{P}] covers the moved band",
         f"what was open at tCE{P} is (exactly) what is open at tCE{N}, and the slice family (gB{P}Lo, "
         f"tCE{N}] covers the moved band"),
        (f"at the new frontier (CE2-CE{P-1} pattern)", f"at the new frontier (CE2-CE{P} pattern)"),
        (f"the band slice (gB{P-1}Lo, tCE{P}] is handled by the verified window slices hW{P}, hW{P+1} "
         f"(the W{P-1} slice is {IFFREC[P-1]}, re-cited in full at gB{P-1}; the W{P} slice is {IFFREC[P]}), "
         f"the part above tCE{P-1} is exactly the old face",
         f"the band slice (gB{P}Lo, tCE{N}] is handled by the verified window slices hW{P+1}, hW{P+2} "
         f"(the W{P} slice is {IFFREC[P]}, re-cited in full at gB{P}; the W{N} slice is {IFFREC[N]}), "
         f"the part above tCE{P} is exactly the old face"),
        (f"shrinking the lower bound (tCE89 -> ... -> tCE{P-1} -> tCE{P}) leaves the face IMPLICATOR - anything "
         f"true above tCE{P-1} is true above tCE{P}",
         f"shrinking the lower bound (tCE89 -> ... -> tCE{P} -> tCE{N}) leaves the face IMPLICATOR - anything "
         f"true above tCE{P} is true above tCE{N}"),
        (f"RH q <-> (allOnLineUpTo q tCE{P}) x (terminalFaceCE{P} q)",
         f"RH q <-> (allOnLineUpTo q tCE{N}) x (terminalFaceCE{N} q)"),
        (f"re-anchored windows 43..{P} all bit-identical at their seams; window {P} certified {WINREC2[P]}",
         f"re-anchored windows 43..{N} all bit-identical at their seams; window {N} certified {WINREC2[N]}"),
        (f"AND the absolute clause above tCE{P}. Both sides",
         f"AND the absolute clause above tCE{N}. Both sides"),
    ]:
        assert E.count(old) == 1, f"segE doc: {old[:70]!r} (count {E.count(old)})"
        E = E.replace(old, new)
    # the inline milestone/census sentence: located by paren-depth scan from the source's own values
    sent_anchor = f"(tCE{P} - tPT2 = {fmt(prevgap)} - "
    sa = E.index(sent_anchor)
    depth, sj = 0, sa
    for jj in range(sa, len(E)):
        ch = E[jj]
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0:
                sj = jj + 1
                break
    assert sj > sa, "sentence end not found"
    crossM = [M for (M, K, r, a) in UNIT_MARKS if M <= gap and K == N]
    if crossM:
        Mx = max(crossM)
        unit_inline = f"the {Mx // 1000} 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW [margin {fmt(gap - Mx)}]"
    else:
        M, K, r, a = max((t for t in UNIT_MARKS if t[0] <= gap))
        above = [t[0] for t in UNIT_MARKS if t[0] > gap]
        nxt = min(above) if above else (gap // 5000 + 1) * 5000
        d = nxt - gap
        ph = ("less than one half-step" if d < 2336 else
              "less than one full 4 673 step" if d < 4673 else f"about {round(d / 4673)} full steps")
        unit_inline = (f"the {M // 1000} 000 UNIT ROUND MARK (crossed W{K}" + (f" {r}" if r else "") +
                       (f", {a}" if a else "") + f") carries {fmt(gap - M)}, the next round mark "
                       f"{nxt // 1000} 000 is {fmt(d)} ahead ({ph})")
    d2 = 2000000 - censusnum
    if d2 > 0:
        if d2 <= 200:
            tail_cens = (f"2 000 000 is {fmt(d2)} ahead (less than one zero-span - the tail window W100 will "
                         f"land it, do not pre-announce)")
        elif d2 <= 22000:
            tail_cens = (f"2 000 000 is {fmt(d2)} ahead (about one full window - compute at that window, do "
                         f"not pre-announce)")
        else:
            tail_cens = (f"2 000 000 is {fmt(d2)} ahead (about {round(d2 / 20000)} full windows - do not "
                         f"pre-announce)")
        crossC = [M for (M, K, r) in CENSUS_MARKS if censusprev < M <= censusnum]
        if crossC:
            Mc = max(crossC)
            cens_inline = (f"the {fmt(Mc)} CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW "
                           f"(margin {fmt(censusnum - Mc)}); {tail_cens}")
        else:
            cens_inline = tail_cens
    else:
        # POST-TARGET phase (the 2 000 000 program target landed at W100 [0421]); the extension continues
        landed = (f"the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's "
                  f"target; margin at WINDOW {N}: {fmt(censusnum - 2000000)})")
        crossC2 = [M for (M, K, r) in CENSUS_MARKS if censusprev < M <= censusnum and M != censusnum]
        crossed = "".join(f"the {fmt(M)} CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW "
                          f"(margin {fmt(censusnum - M)}); " for M in crossC2)
        if censusnum % 20000 == 0:
            pos = ("the first 20 000-mark" if censusnum == 2020000 else "another 20 000-mark")
            cens_inline = (f"{crossed}the {fmt(censusnum)} CERTIFIED-ZERO MARK LANDS EXACTLY IN THIS "
                           f"WINDOW, WINDOW {N} ({fmt(censusprev)} + {F['widthnum']:,} = {fmt(censusnum)}, "
                           f"margin 0) - {pos} of the post-target extension; {landed}; "
                           f"the frontier extension continues beyond the target (post-target phase, no new "
                           f"program claim)")
        else:
            nm = (censusnum // 20000 + 1) * 20000
            k = nm - censusnum
            extra = ""
            if k <= 2000:
                extra = (f"; the {fmt(nm)} CERTIFIED-ZERO mark is {fmt(k)} zero"
                         + ("s" if k != 1 else "") + " ahead (it lands at the start of the NEXT window - "
                         "do not pre-announce)")
            cens_inline = (f"{crossed}census extension past the landed target: {fmt(censusnum)} certified ("
                           f"{fmt(censusprev)} + {F['widthnum']:,}); {landed}{extra}")
    new_sent = f"(tCE{N} - tPT2 = {fmt(gap)} - {unit_inline}; census {F['census']} - {cens_inline})"
    E = E[:sa] + new_sent + E[sj:]
    toks = [UNITW[P], f"tCE{P} : R", f"tCE{P}.", f"tCE{P} - tPT2 = {fmt(prevgap)}",
            F["censusprev"], fmt(2000000 - censusprev)]
    if N == 100:
        # the landing sentence legitimately quotes the previous census and the tail length
        toks = [t for t in toks if t not in (F["censusprev"], fmt(2000000 - censusprev))]
    if censusnum > 2000000:
        # post-target: the landed-target sentence legitimately quotes the previous census (2 000 000)
        toks = [t for t in toks if t not in (F["censusprev"], fmt(2000000 - censusprev))]
    for tok in toks:
        assert E.count(tok) == 0, f"stale segE token {tok!r}"

    # leftovers check: no unqualified tCE96 / CE95.terminalFaceCE95 stale refs in positions we renamed
    assert not E.count(f"theorem terminalFaceCE{P}_") and E.count(f"terminalFaceCE{P}q") == 0, "stale tf names"
    for tok in [f"tCE{P}_lt_tCE{P}", f"CE{P-1}.terminalFaceCE{P-1} q :"]:
        assert E.count(tok) == 0, f"stale token {tok!r}"

    # ---------- assemble
    P1 = src[:A_hdr_i]
    P1 = rep(P1, f"import RhAttack.CE{P-1}\n", f"import RhAttack.CE{P-1}\nimport RhAttack.CE{P}\n", label="imp")
    P1 = rep(P1, f"CE{P-2} CE{P-1}\nopen scoped Topology", f"CE{P-2} CE{P-1} CE{P}\nopen scoped Topology",
             label="open")
    P3 = f"namespace CE{N}\n"
    P4 = src[A_hdr_j + len(f"namespace CE{P}\n"):A_cons_i]
    B1 = src[A_cons_j:A_wdef_i]
    B1 = rep(B1, f"re-cited in the W{P} band - window {P-1} of {P}",
             f"re-cited in the W{N} band - window {P-1} of {N}", label="rc")
    B3 = src[A_wdef_j:A_band_doc_i]
    D1 = src[A_band_j:A_aolu_doc_i]
    out = P1 + hdr + P3 + P4 + cons + B1 + wdefs + docC + band + D1 + aolu_doc + aolu + E
    # final global stale-token sweep on out (code-level; docstrings handled above)
    for bad in [f"bandOfWindows{P} ", f"allOnLineUpToCE{P} ", f"rh_reanchored_CE{P} ",
                f"terminalFaceCE{P}_of_thetaInf", UNITW[P]]:
        assert out.count(bad) == 0, f"stale token {bad!r}"
    open(f"{ROOT}/CE{N}.lean", "w").write(out)
    print(f"wrote {ROOT}/CE{N}.lean ({len(out)} chars)")


if __name__ == "__main__":
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 97
    gen_ce(N)
