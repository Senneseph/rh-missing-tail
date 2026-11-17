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
        unit="NINETY-SEVENTH", family="-86"),
}


def rep(s, old, new, n=1, label=""):
    c = s.count(old)
    assert c == n, f"[{label}] count {c} != {n}: {old[:90]!r}"
    return s.replace(old, new)


def gen_ce(N):
    F = FACTS[N]
    P = N - 1
    gap = F["gap"]
    src = open(f"{ROOT}/CE{P}.lean").read()

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
(0418, option B - lane M5).

MILESTONE STATE: tCE{N} - tPT2 = {gap:,} - {F['mile']}.
CERTIFIED-ZERO CENSUS: cumulative total {F['census']} over (g_a1, g_b{N}] -
{F['censmarks']}.

WINDOW {N}: {F['width']} (a = {F['a']} = b{P} (the bit-identical seam), b = {F['b']}; certified width
{F['widthnum']:,}). {F['faildesc']}. Census: the window adds {F['widthnum']:,} certified zeros
({F['censusprev']} + {F['widthnum']:,} = {F['census']}). Cumulative tally through window {N}: {N}
windows - {F['win_n_clean']} clean, {F['win_n_rescue']} rescue; {F['total_fail']} total internal Rosser
failures, ALL RECORDED. End Rosser runs: {F['runs']} left of g_a{N} / right of g_b{N} (both >= K = 12); 0
cross-check failures; 0 undetermined Gram signs; max phase contribution {F['phase']}.

PIPELINE RUN (thirty-second in the overlap pipeline): a fresh run with resumed_from_cache = {F['cache']}
(NOT seeded - the first unseeded overlap run of the current stretch; logged for provenance) after the
2026-11-16 host reboot, 6 workers: {F['evals']} evaluations in {F['seconds']} s (same M = 60, C_R = 1,
N_range = [691 008, 691 008], same pipeline, same verifier, same seam discipline). Window {N} RAN WHILE
the formal units 0414-0417 (SIs / SIsA1 / TerminalFaceCE96 / Face38PosReserve) reached GREEN; the
per-unit critical path is max(run, formalization).

PROVENANCE (our run, 2026-11-16; pipeline = Murphy's Apache-2.0 deposit, same as CE1-CE{P}): RUN
PARAMETERS: a = {F['a']} (= b{P}), b = {F['b']} ({F['width']}), M = 60, C_R = 1, 6 workers, {F['evals']}
evaluations, {F['seconds']} s, resumed_from_cache = {F['cache']}. CERTIFICATE (window{N}_b{N}.json): the
{F['widthnum']:,} (= b - a) zeros of zeta with g_a{N} < Im s <= g_b{N} are ALL SIMPLE and on the line,
where g_a{N} (recorded exact dyadic ball) is {F['ga_b']} (the W{P} endpoint g_b{P}, the W{N} seam g_a{N}
BIT-IDENTICAL - exact dyadic tuple comparison, audited BEFORE this module was written, per the 0348
process rule), and g_b{N} has exact dyadic tuple {F['gb_b']} (the {F['family']} dyadic family). The floor
tCE{N} = {F['tCE']:,} sits {F['fracmargin']} below the certified lower bound (EXACT dyadic arithmetic,
center-minus-radius reading; robust to the certified radius ~4.7e-14 by many orders of magnitude); the
standard two-decimal lower bound gB{N}Lo ({F['galstr']} = {F['gal']/F['gden']:.2f}) has the exact margin
{F['fracmargin']}; the two-decimal round-down (0.31) is strictly below the exact fractional part
({F['frac']}), so no CASING is needed - window 38 / CE38 remains the only CASING case so far. (The
gB{N}Lo margin 2.99e-4 is the EIGHTEENTH sub-cent case in the current run: W79 (1.76e-4), W81 (4.03e-4),
W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3),
W89 (4.0e-3), W90 (9.1e-3), W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96
(6.1e-3), W97 (2.99e-4); not a precision danger - the certified radius is ~4.7e-14, four orders of
magnitude smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE{P}): (1) ENVIRONMENT REPEAT (Murphy's window-1 certificate
re-verified - see CE2 header); (2) PIPELINE VERIFIER on window{N}_b{N}.json: "CERTIFIED: true",
points_checked = {F['evals']}, sign_changes_inside = {F['widthnum']:,} (= b - a),
rosser_failures_inside = {F['failures_n']} (ALL DETERMINED and rescued - see the W{N} record above),
turing_ok = true, K_conservative = 12, end Rosser runs {F['runs']}; (3) SEAM AUDIT (this run): the
recorded g_a{N} ball is bit-identical to CE{P}'s recorded g_b{P} ball (exact dyadic decode,
2026-11-16). In addition, the independent fresh-mpmath union-span adjudication of the {F['failures_n']}
rescued spans (0418 audit record: separate engine, corrected phase convention, dense scan with refined
crossing checks, plus unflagged control spans) re-confirms each rescue count from outside the pipeline.
FRONTIER ARITHMETIC (machine, below): tCE{N} = {F['tCE']:,}, tCE{N} - tCE{P} = {F['incr']},
tCE{N} - tPT2 = {gap:,}.
HONESTY (trust base): as CE2-CE{P} - the pipeline's own controls, its kernel-checked Lean remainder
theorem, and our verification layers; a RE-RUN of a third-party pipeline, not a from-scratch independent
certification. Cumulative certified count = {F['census']} over (g_a1, g_b{N}] (pipeline data, not
in-tree arithmetic). NO RH CLAIM.
-/
"""

    # ---------- segment A: constants .. gB ordering
    mile = []
    for M in [175000, 200000, 225000, 250000, 275000, 300000, 325000, 375000, 400000, 425000,
              430000, 435000, 440000, 445000, 450000]:
        if M > gap:
            continue
        K = F["milecross"][M]
        label = "MILESTONE CARRIED (machine, PROVEN - norm_num + linarith)"
        mile.append(f"/-- {label}: the {M // 1000} 000-unit mark (CROSSED in WINDOW {K} - see the CE{K} module for the crossing record and margin) is carried at WINDOW-{N}: (tCE{N} : R) - WinC.tPT2 = {gap:,} > {M:,}, margin {gap - M:,}. -/\n"
                    f"theorem frontierPast{M // 1000}k : (tCE{N} : ℝ) - WinC.tPT2 > {M} := by\n"
                    f"  have h : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := frontierGapAboveH0\n"
                    f"  linarith [h]\n\n")
    mile.append(f"/-- MILESTONE CROSSED IN THIS WINDOW (machine, PROVEN - norm_num + linarith): {F['mile']}. -/\n"
                f"theorem frontierPast455k : (tCE{N} : ℝ) - WinC.tPT2 > 455000 := by\n"
                f"  have h : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := frontierGapAboveH0\n"
                f"  linarith [h]\n\n")
    chain = []
    for k in range(N, 74, -1):
        ref = f"faceShrinkCE{N}" if k == N else f"CE{k}.faceShrinkCE{k}"
        chain.append(f"  have hshrink{len(chain)+1} : (tCE{k} : ℝ) - (tCE{k-1} : ℝ) = {shrink(k)} := {ref}")
    nsh = len(chain)
    sumsh = sum(shrink(k) for k in range(75, N + 1))
    n4673 = sum(1 for k in range(75, N + 1) if shrink(k) == 4673)
    snaps_in = [k for k in range(75, N + 1) if shrink(k) == 4672]
    snaplist = ", ".join(f"w{k-1} -> w{k}" for k in snaps_in)
    cons = f"""/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b{N} (machine): gB{N}Lo = {F['galstr']} = {F['gal']/F['gden']:.2f} - the two-decimal round-down of the certified lower bound (the endpoint g_b{N} minus the certified radius ~4.7e-14). The margin is the exact {F['fracmargin']}; the two-decimal round-down (0.31) is strictly below the exact fractional part ({F['frac']}), so no CASING is needed (window 38 / CE38 remains the only CASING case). The 2.99e-4 margin is the EIGHTEENTH sub-cent case in the current run - not a precision danger (certified radius ~4.7e-14). -/
def gB{N}Lo : ℚ := {F['gal']} / {F['gden']}

/-- THE NEW LOWER BOUND (machine): {F['tCE']:,} = floor(g_b{N}). The endpoint sits {F['frac']} above the integer boundary (exact, exponent -86 dyadic terminator) and the certified radius is ~4.7e-14, so the floor is robust by many orders of magnitude. tCE{N} - tCE{P} = {F['incr']} (the SNAP increment - W{N} ran {F['width']}, certified b = {F['b']}; the six recorded 4 672 INCREMENT occurrences are w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> this step [SNAP] - no pattern claim beyond the recorded data). -/
def tCE{N} : ℕ := {F['tCE']}

theorem tCE{N}_lt_gB{N}Lo : (tCE{N} : ℝ) < (gB{N}Lo : ℝ) := by
  norm_num [gB{N}Lo, tCE{N}]

theorem tCE{P}_lt_tCE{N} : (tCE{P} : ℝ) < (tCE{N} : ℝ) := by
  norm_num [CE{P}.tCE{P}, tCE{N}]

/-- ORDERING (machine, norm_num): (gB{P}Lo : R) < (tCE{N} : R), with gB{P}Lo the STANDARD lower bound introduced at CE{P} and tCE{N} = {F['tCE']:,}. So the window-{N} terminal slice starts strictly below the new floor. -/
theorem gB{P}Lo_lt_tCE{N} : (gB{P}Lo : ℝ) < (tCE{N} : ℝ) := by
  norm_num [CE{P}.gB{P}Lo, tCE{N}]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE{N} - tCE{P} = {F['incr']}. THE SNAP INCREMENT: W{N} ran {F['width']} (certified b = {F['b']}, {F['widthnum']:,} zeros) with {F['failures_n']} recorded interior Rosser failure blocks (all determined and rescued); the floor advances by {F['incr']}. The six recorded 4 672 INCREMENT occurrences are w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> this step [SNAP] - no pattern claim beyond the recorded data points. -/
theorem faceShrinkCE{N} : (tCE{N} : ℝ) - (tCE{P} : ℝ) = {F['incr']} := by
  norm_num [tCE{N}, CE{P}.tCE{P}]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE{N} : R) - WinC.tPT2 = {F['tCE']:,} - 3 000 175 332 800 = {gap:,} above the H0 frontier WinC.tPT2. {F['mile'].capitalize()}. CERTIFIED-ZERO CENSUS: cumulative total {F['census']} over (g_a1, g_b{N}] - {F['censmarks']}. -/
theorem frontierGapAboveH0 : (tCE{N} : ℝ) - WinC.tPT2 = {gap} := by
  norm_num [tCE{N}, WinC.tPT2]

""" + "".join(mile) + f"""/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379]); CARRIED into WINDOW-{N} - tCE{N} - tPT2 = {gap:,} exceeds 350 000 with margin {gap - 350000:,}. Proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, through {nsh} face shrinks (CE75-CE{N}: {n4673} times 4 673 + {nsh - n4673} times 4 672 SNAP [{snaplist}] = {sumsh:,}: 350 465 -> {gap:,}). -/
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
             f"up to floor(gB{N}) - {F['width']} (b = {F['b']}; {F['failures_n']} recorded interior Rosser failure\n"
             f"blocks, ALL DETERMINED and rescued - see the module header): the zeros of zeta with\n"
             f"(gB{P}Lo : R) < Im s <= int(gB{N}) = {F['tCE']:,} (the FLOOR - the endpoint g_b{N} sits\n"
             f"{F['frac']} above it, exact, robust to the certified radius ~4.7e-14) are all simple and on the\n"
             f"line. Certificates: window{N}_b{N}.json (window {N}; certified 2026-11-16) + the pipeline verifier\n"
             f"(CERTIFIED, turing_ok, points {F['evals']}, sign_changes_inside = {F['widthnum']:,} = b - a,\n"
             f"rosser_failures_inside = {F['failures_n']} all determined and rescued, end Rosser runs {F['runs']},\n"
             f"K_conservative = 12) + the module header (M = 60, C_R = 1, the bit-identical g_a{N} == g_b{P}\n"
             f"SEAM AUDIT, the 0418 independent fresh-mpmath union-span adjudication of the {F['failures_n']}\n"
             f"rescued spans). Slice restriction (gB{P}Lo, int(gB{N})] is a SUBSET of the certified window, so\n"
             f"its zeros inherit on-linedness; no RH CLAIM about the face above g_b{N}. -/\n"
             f"def ce{N}WinClause : Prop :=\n"
             f"    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB{P}Lo : ℝ) < ρ.im →\n"
             f"      ρ.im ≤ (tCE{N} : ℝ) → ρ.re = 1 / 2\n\n")

    # ---------- segment C: band theorem (doc + proof; signature/goal/tail refreshed)
    band = src[A_band_i:A_band_j]
    docC = (f"/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h{P + 2}\n"
            f"(window {N} contributes ONE clause for its (gB{P}Lo, tCE{N}] slice - h{P + 2}; W{N} {F['width']}\n"
            f"certified b = {F['b']}, {F['failures_n']} recorded interior Rosser failure blocks all determined and\n"
            f"rescued; window {P} re-cited in full at gB{P-1} - h{P + 1}), ALL zeros of zeta with Im s >\n"
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
                f"RE-CITED full slices for the re-anchored windows 43..{P} (bit-identical seams, recorded data) "
                f"incl. the W53..W{P} Rosser records + h{P+2} : the window-{N} terminal slice (SNAPPED 19 997, "
                f"THREE recorded interior failures - all determined and rescued)). This is the finite-height "
                f"closure through the corrected w1-w{N} band (W42b fill) re-anchored to all of the certified "
                f"NINETY-SEVENTH window (SNAPPED 19 997); census 1 959 979 over (g_a1, g_b{N}] - the 1 600 000 "
                f"CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 359 979; the 1 700 000 CERTIFIED-ZERO "
                f"MARK (CROSSED in W85 [0396]) carries margin 259 979; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED "
                f"in W90 [0401]) carries margin 159 979; the 1 840 000 mark (CROSSED in W91 [0402]) carries margin "
                f"119 979; the 1 860 000 mark carries 99 979; the 1 880 000 mark carries 79 979; the 1 900 000 "
                f"CERTIFIED-ZERO MARK (CROSSED in W95 [0410]) carries margin 59 979; the 1 920 000 mark (CROSSED "
                f"in W96) carries margin 39 979; the 1 940 000 CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW W97 "
                f"(margin 19 979); the 1 960 000 mark is 21 ahead (less than one window); 2 000 000 is 40 021 "
                f"ahead (about two full windows; compute at that window, do not pre-announce). NO RH CLAIM about "
                f"the face above tCE{N}. -/\n")

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
    new_tfdoc = (f"/-- THE NINETY-SEVENTH RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the "
                 f"absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains "
                 f"open at the NINETY-SEVENTH certified window (SNAPPED 19 997, b = 12 363 155 397 109, THREE "
                 f"recorded interior Rosser failures - all determined and rescued; census 1 959 979 over "
                 f"(g_a1, g_b{N}]) is the assertion that every zeta zero of the (data-independent) zero set q "
                 f"with Im s > (tCE{N} : R) = {F['tCE']:,} lies on the line - i.e. the absolute clause [S1] "
                 f"and A1 (no data-dependent bound on the S-at-zeros and DN walk) above the new lower bound. "
                 f"Frontier {gap:,} above H0: the 455 000 UNIT ROUND MARK was CROSSED in THIS WINDOW (margin "
                 f"2 941 - a regular round crossing, not a predicted milestone); the 450 000 mark (crossed W96) "
                 f"carries 7 941; the 445 000 mark (crossed W95 [0410]) carries 12 941; the 440 000 mark "
                 f"(crossed W94 [0406]) carries 17 941; the 435 000 mark (crossed W93 [0405]) carries 22 941; "
                 f"the 430 000 mark (crossed W92 [0403]) carries 27 941; the 425 000 mark (crossed W90 [0401], "
                 f"the FOURTH PREDICTION of the series) carries 32 941; the 400 000 mark (crossed W85 [0396], "
                 f"third prediction) carries 57 941; the 375 000 mark (crossed W80, second prediction) carries "
                 f"82 941; the 350 000 mark (crossed W74, first prediction) carries 107 941; the 325 000 and "
                 f"300 000 marks carry 132 941 and 157 941; the next round mark 460 000 is 2 059 ahead (less "
                 f"than one full 4 673 step); the 1 600 000 CERTIFIED-ZERO MARK (crossed W80) carries margin "
                 f"359 979; the 1 700 000 mark (crossed W85) carries 259 979; the 1 800 000 mark (crossed W90) "
                 f"carries 159 979; the 1 840 000 mark (crossed W91) carries 119 979; the 1 860 000 mark "
                 f"(crossed W92) carries 99 979; the 1 880 000 mark carries 79 979; the 1 900 000 "
                 f"CERTIFIED-ZERO MARK (crossed W95 [0410]) carries 59 979; the 1 920 000 mark (crossed W96) "
                 f"carries 39 979; the 1 940 000 CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW W97 (margin 19 979); "
                 f"the 1 960 000 mark is 21 ahead (less than one window); 2 000 000 is 40 021 ahead. "
                 f"The increment tCE{N} - tCE{P} = {F['incr']} (SNAP: W{N} runs SNAPPED 19 997; the six recorded "
                 f"4 672 occurrences remain w45, w53, w65, w77 [SNAP], w86 [SNAP], w97 [SNAP, this step]); no "
                 f"pattern claim beyond the recorded data. The face is RE-ANCHORED (the exact iff below proves "
                 f"no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/\n")
    E = new_tfdoc + E[tfdef_idx:]
    # rh_reanchored docstring: scoped token transforms
    rhre_i = E.index(f"theorem rh_reanchored_CE{N}")
    rr0 = E.rindex("/--", 0, rhre_i)
    sc = E[rr0:rhre_i]
    for old, new in [
        (f"the {P+1} verified window-slice clauses - windows 1..{P}, incl. the re-anchored 43..{P}",
         f"the {P+2} verified window-slice clauses - windows 1..{P+1}, incl. the re-anchored 43..{P+1}"),
        ("W96: NON-SNAPPED 20 000, CLEAN - zero failures))",
         "W96: NON-SNAPPED 20 000, CLEAN - zero failures; W97: SNAPPED 19 997, THREE recorded interior "
         "failures - all determined and rescued))"),
        (f"the NAMED terminal face above tCE{P} - the finite-height part",
         f"the NAMED terminal face above tCE{N} - the finite-height part"),
        ("the corrected w1-w96 band", "the corrected w1-w97 band"),
        ("windows 43..96, all of them bit-identical at their seams",
         "windows 43..97, all of them bit-identical at their seams"),
    ]:
        assert sc.count(old) == 1, f"rhre doc: {old[:70]!r} (count {sc.count(old)})"
        sc = sc.replace(old, new)
    E = E[:rr0] + sc + E[rhre_i:]
    # iff / split / monotonicity docstrings: exact token transforms
    for old, new in [
        ("beyond the cited window-data slices hW95, hW96): terminalFaceCE96 q <-> terminalFaceCE95 q",
         "beyond the cited window-data slices hW97, hW98): terminalFaceCE97 q <-> terminalFaceCE96 q"),
        ("what was open at tCE95 is (exactly) what is open at tCE96, and the slice family (gB95Lo, tCE96] "
         "covers the moved band",
         "what was open at tCE96 is (exactly) what is open at tCE97, and the slice family (gB96Lo, tCE97] "
         "covers the moved band"),
        ("at the new frontier (CE2-CE95 pattern)", "at the new frontier (CE2-CE96 pattern)"),
        ("the band slice (gB95Lo, tCE96] is handled by the verified window slices hW96, hW97 (the W95 slice "
         "is NON-SNAPPED 20 000 with two recorded interior failures, both determined and rescued, re-cited "
         "in full at gB95; the W96 slice is NON-SNAPPED 20 000, CLEAN - zero failures), the part above tCE95 "
         "is exactly the old face",
         "the band slice (gB96Lo, tCE97] is handled by the verified window slices hW97, hW98 (the W96 slice "
         "is NON-SNAPPED 20 000, CLEAN - zero failures, re-cited in full at gB96; the W97 slice is SNAPPED "
         "19 997 with three recorded interior failures - all determined and rescued), the part above tCE96 "
         "is exactly the old face"),
        ("shrinking the lower bound (tCE89 -> ... -> tCE95 -> tCE96) leaves the face IMPLICATOR - anything "
         "true above tCE95 is true above tCE96",
         "shrinking the lower bound (tCE89 -> ... -> tCE96 -> tCE97) leaves the face IMPLICATOR - anything "
         "true above tCE96 is true above tCE97"),
        ("RH q <-> (allOnLineUpTo q tCE96) x (terminalFaceCE96 q)",
         "RH q <-> (allOnLineUpTo q tCE97) x (terminalFaceCE97 q)"),
        ("re-anchored windows 43..96 all bit-identical at their seams; window 96 certified NON-SNAPPED at "
         "20 000, CLEAN - zero recorded interior failures",
         "re-anchored windows 43..97 all bit-identical at their seams; window 97 certified SNAPPED at "
         "19 997 (three recorded interior failures - all determined and rescued)"),
        ("AND the absolute clause above tCE96. Both sides",
         "AND the absolute clause above tCE97. Both sides"),
        ("(tCE96 - tPT2 = 453 269 - the 450 000 UNIT ROUND MARK was CROSSED in THIS WINDOW [margin 3 269]; "
         "census 1 939 982 - the 1 900 000 CERTIFIED-ZERO MARK (crossed W95 [0410]) carries margin 39 982; "
         "2 000 000 is 60 018 ahead)",
         "(tCE97 - tPT2 = 457 941 - the 455 000 UNIT ROUND MARK was CROSSED in THIS WINDOW [margin 2 941]; "
         "census 1 959 979 - the 1 940 000 CERTIFIED-ZERO MARK CROSSED in THIS WINDOW W97 [margin 19 979]; "
         "2 000 000 is 40 021 ahead)"),
    ]:
        assert E.count(old) == 1, f"segE doc: {old[:70]!r} (count {E.count(old)})"
        E = E.replace(old, new)
    for tok in ["NINETY-SIXTH", "tCE96 : R", "tCE96.", "tCE96 - tPT2 = 453", "1 939 982", "60 018"]:
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
                f"terminalFaceCE{P}_of_thetaInf", "NINETY-SIXTH"]:
        assert out.count(bad) == 0, f"stale token {bad!r}"
    open(f"{ROOT}/CE{N}.lean", "w").write(out)
    print(f"wrote {ROOT}/CE{N}.lean ({len(out)} chars)")


if __name__ == "__main__":
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 97
    gen_ce(N)
