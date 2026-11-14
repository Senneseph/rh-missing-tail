import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3
import RhAttack.CE4
import RhAttack.CE5
import RhAttack.CE6
import RhAttack.CE7
import RhAttack.CE8
import RhAttack.CE9
import RhAttack.CE10
import RhAttack.CE11
import RhAttack.CE12
import RhAttack.CE13
import RhAttack.CE14
import RhAttack.CE15
import RhAttack.CE16
import RhAttack.CE17
import RhAttack.CE18
import RhAttack.CE19
import RhAttack.CE20
import RhAttack.CE21
import RhAttack.CE22
import RhAttack.CE23
import RhAttack.CE24
import RhAttack.CE25
import RhAttack.CE26
import RhAttack.CE27
import RhAttack.CE28
import RhAttack.CE29
import RhAttack.CE30
import RhAttack.CE31
import RhAttack.CE32
import RhAttack.CE33
import RhAttack.CE34
import RhAttack.CE35
import RhAttack.CE36
import RhAttack.CE37
import RhAttack.CE38
import RhAttack.CE39
import RhAttack.CE40
import RhAttack.CE41
import RhAttack.CE42
import RhAttack.CE42B
import RhAttack.CE43
import RhAttack.CE44
import RhAttack.CE45
import RhAttack.CE46
import RhAttack.CE47
import RhAttack.CE48
import RhAttack.CE49
import RhAttack.CE50
import RhAttack.CE51
import RhAttack.CE52
import RhAttack.CE53
import RhAttack.CE54
import RhAttack.CE55
import RhAttack.CE56
import RhAttack.CE57
import RhAttack.CE58
import RhAttack.CE59
import RhAttack.CE60
import RhAttack.CE61
import RhAttack.CE62
import RhAttack.CE63
import RhAttack.CE64
import RhAttack.CE65
import RhAttack.CE66
import RhAttack.CE67
import RhAttack.CE68
import RhAttack.CE69
import RhAttack.CE70
import RhAttack.CE71
import RhAttack.CE72
import RhAttack.CE73
import RhAttack.CE74
import RhAttack.CE75
import RhAttack.CE76
import RhAttack.CE77
import RhAttack.CE78
import RhAttack.CE79
import RhAttack.CE80
import RhAttack.CE81
import RhAttack.CE82
import RhAttack.CE83
import RhAttack.CE84
import RhAttack.CE85

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82 CE83 CE84 CE85
open scoped Topology

/-!
**CE86 — the terminal face re-anchored at the EIGHTY-SIXTH certified window
(0397, option B, unit 111 - lane M5).

MILESTONE STATE: tCE86 - tPT2 = 406 540 - the 400 000 UNIT MILESTONE
(CROSSED in WINDOW 85 at 401 867, margin 1 867 - the THIRD PREDICTION
of the series, ACHIEVED at its predicted frontier exactly) CARRIES
with margin 6 540. The 375 000 mark (crossed W80 [0389], second
prediction) carries 31 540; the 350 000 mark (crossed W74 [0380],
first prediction) carries 56 540; the 325 000 and 300 000 marks carry
81 540 and 106 540. Next round mark 425 000: 18 460 ahead (~4 windows
at the ~4 673 pace). CERTIFIED-ZERO CENSUS: cumulative total 1 739
984 over (g_a1, g_b86] - the 1 700 000 CERTIFIED-ZERO MARK (CROSSED
in WINDOW 85, margin 19 984 - the second census prediction, landed
EXACTLY) CARRIES margin 39 984; the 1 600 000 mark carries 139 984;
the 1 500 000 mark carries 239 984; the 1 800 000 mark is 60 016
ahead (~6.5 windows). No new milestone crossing this window: W87
prediction absent snaps - 425 000 lands around window 88 (425 000 -
406 540 = 18 460 ~ 4 windows), the 1 800 000 census mark around
window 89 (60 016 ~ 6.5 windows); compute from the decoded endpoint,
do not pre-announce.

WINDOW 86: NON-SNAPPED (b requested = b actual = 12 363 155 177 114;
certified width 20 000). RESCUE WINDOW - TWO recorded Rosser failure
blocks (both INTERIOR), both ultimately DETERMINED (rescue
quota-met on each union, determined in the certificate - RECORDED,
not suppressed):
  block 1 naive [12 363 155 163 323, 12 363 155 163 325] (need = 2,
    changes = 0, points = 129, m = 64), union [12 363 155 163 321,
    12 363 155 163 326] (need = 5, found = 5, m = 8);
  block 2 naive [12 363 155 166 705, 12 363 155 166 707] (need = 2,
    changes = 0, points = 129, m = 64), union [12 363 155 166 704,
    12 363 155 166 709] (need = 5, found = 5, m = 2).
rosser_failures_inside = 2 (two failures in ONE window - the most for
any single window in the current run; W83 had three recorded blocks:
two interior + one past b). End Rosser runs: 45 left of g_a86, 48
right of g_b86 (both >= K = 12); 0 cross-check failures (all 34 351
records); 0 undetermined Gram signs. INCREMENT: 4 673 (the usual
step, non-snapped; the increment series w79 -> w86 now reads 4 673
eight times straight; no pattern claim). Census: the full non-snapped
width adds 20 000 zeros (1 719 984 + 20 000 = 1 739 984).

PIPELINE RUN (twenty-first in the overlap pipeline): seed cache
(window 85's cache copied in before launch - resumed_from_cache =
671 399, logged for provenance) + 32 workers: 34 351 evaluations in
2 646.3 s (series so far: ... / 2 571.1 / 2 407.7 / 2 460.2 /
2 646.3 - the count moved, the certification content did not: same
M = 60, C_R = 1, N_range = [691 008, 691 008], same pipeline, same
verifier, same seam discipline). Window 86 RAN WHILE the CE85 re-
anchor unit (this series) reached machine-checked GREEN; the
per-unit critical path is max(run, formalization); window 87 will be
launched with the W86 seam already audited.

PROVENANCE (our run, 2026-11-13; pipeline = Murphy's Apache-2.0
deposit, same as CE1-CE85): RUN PARAMETERS: a = 12 363 155 157 114
(= b85), b requested = b actual = a + 20 000 = 12 363 155 177 114,
M = 60, C_R = 1, 32 workers, 34 351 evaluations, 2 646.3 s,
resumed_from_cache = 671 399 (seeded from
window85_b85.json.cache.jsonl). CERTIFICATE (window86_b86.json): the
20 000 (= b - a) zeros of zeta with g_a86 < Im s <= g_b86 are ALL
SIMPLE and on the line, where g_a86 (recorded exact dyadic ball) =
232127354177314313436807901019472712541 x 2^-86 with radius 16777217
x 2^-110 (i.e. 3 000 175 734 667.25720718360461431097149680518969603882323557767182435366294095761808234656964344821972190402448177337646484375, the W85 endpoint, + or - 1.29e-26) and this ball is
BIT-IDENTICAL to CE85's recorded g_b85 (exact dyadic tuple
comparison, 2026-11-13 - audit PERFORMED BEFORE this module was
written, per the 0348 process rule); g_b86 = 3 000 175 739 340.19231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375 (the EXACT
conservative center-minus-radius reading - lo is a dyadic with
denominator 2^110, so its base-10 expansion terminates exactly) + or - 1.29e-26 (endpoint ball, exact
dyadic tuple
[232127354538865155693824816296248215211, -86, 16777217, -110] - the
endpoint ball NORMALIZES back to exponent -86, now the THIRD
consecutive -86 (g_b84, g_b85, g_b86); the exact dyadic tuple is
authoritative over the exponent representation). The floor tCE86 sits
0.19231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375 below the endpoint (EXACT) - robust to the 1.29e-26 radius
by many orders of magnitude; the standard two-decimal lower bound
gB86Lo (3 000 175 739 340.19) has the exact margin 0.00231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375 (EXACT,
110-digit terminator - integer-tuple arithmetic, conservative center-minus-radius reading);
the two-decimal round-down (0.19) does not equal the floor, so no
CASING is needed - window 38 / CE38 remains the only CASING case so
far. (The gB86Lo margin is thin - 2.3e-3 - the seventh sub-cent case
in the current run: W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83
(6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3); cent-granularity
luck of the endpoint; not by any precision danger: the certified
radius is 1.29e-26, eight orders of magnitude smaller; no pattern
claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE85): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window86_b86.json: "CERTIFIED: true",
points_checked = 34 351, sign_changes_inside = 20 000 (= b - a, the
full width), roser_failures_inside = 2 (RESCUE - the two interior
blocks above, both ultimately determined, quota-met on their unions;
RECORDED, not suppressed), turing_ok = true, K_conservative = 12,
end Rosser runs 45 / 48, endpoints recomputed and matched; (3) SEAM
AUDIT (this run): the recorded g_a86 ball is bit-identical to CE85's
recorded g_b85 ball (exact dyadic decode, 2026-11-13). FRONTIER
ARITHMETIC (machine, below): tCE86 = 3 000 175 739 340, tCE86 -
tCE85 = 4 673, tCE86 - tPT2 = 406 540 (the 400 000 UNIT MILESTONE
CARRIES margin 6 540; census 1 739 984 - the 1 700 000 CENSUS MARK
CARRIES margin 39 984). HONESTY (trust base): as CE2-CE85 - the
pipeline's own controls, its kernel-checked Lean remainder theorem,
and our three verification layers; a RE-RUN of a third-party
pipeline, not a from-scratch independent certification; the Rosser
exceptions are RECORDED, not suppressed (two blocks occurred in this
window, both ultimately determined - recorded above and in the
certificate). Cumulative certified count = 1 739 984 over (g_a1,
g_b86] (pipeline data, not in-tree arithmetic). NO RH CLAIM.
-/
namespace CE86


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b86 (machine): gB86Lo = 3 000 175 739 340.19 = 300017573934019/100 - the two-decimal round-down of the certified lower bound (the endpoint g_b86 '3 000 175 739 340.19231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375' minus the certified radius 1.29e-26). The margin is the exact 0.002319171453... (110-digit terminator) - THIN by cent-granularity luck of the endpoint (seventh sub-cent case in the current run: W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3); not a precision danger - the certified radius is 1.29e-26, eight orders of magnitude smaller); no CASING is needed (the two-decimal round-down 0.19 does not equal the floor - window 38 / CE38 remains the only CASING case; no pattern claimed on thin margins). -/
def gB86Lo : ℚ := 300017573934019 / 100

/-- THE NEW LOWER BOUND (machine): 3 000 175 739 340 = floor(g_b86) = int(3 000 175 739 340.19231917...). The endpoint sits 0.19231917... above the integer boundary (exact, 110-digit terminator) and the certified radius is 1.29e-26, so the floor is robust by many orders of magnitude. tCE86 - tCE85 = 4 673 (the usual step; W86 NON-SNAPPED - the increment series w79 -> w86 now reads 4 673 eight times straight; the four 4 672 INCREMENT occurrences in the whole series remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]) - no pattern claim). -/
def tCE86 : ℕ := 3000175739340

theorem tCE86_lt_gB86Lo : (tCE86 : ℝ) < (gB86Lo : ℝ) := by
  norm_num [gB86Lo, tCE86]

theorem tCE85_lt_tCE86 : (tCE85 : ℝ) < (tCE86 : ℝ) := by
  norm_num [CE85.tCE85, tCE86]

/-- ORDERING (machine, norm_num): (gB85Lo : R) < (tCE86 : R), with gB85Lo = 300017573466725/100 (the STANDARD lower bound introduced at CE85) and tCE86 = 3000175739340. So the window-86 terminal slice starts strictly below the new floor. -/
theorem gB85Lo_lt_tCE86 : (gB85Lo : ℝ) < (tCE86 : ℝ) := by
  norm_num [CE85.gB85Lo, tCE86]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE86 - tCE85 = 4 673. THE USUAL STEP, NON-SNAPPED: W86 ran at full width (b requested = b actual = 12 363 155 177 114, certified width 20 000) and the RESCUE status (two recorded Rosser failure blocks - both interior - both ultimately determined) does not change the endpoint. The increment series w79 -> w86 now reads 4 673 eight times straight; the four 4 672 INCREMENT occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]); no pattern claimed (floor/snap artifact data points). -/
theorem faceShrinkCE86 : (tCE86 : ℝ) - (tCE85 : ℝ) = 4673 := by
  norm_num [tCE86, CE85.tCE85]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE86 : R) - WinC.tPT2 = 3 000 175 739 340 - 3 000 175 332 800 = 406 540 above the H0 frontier WinC.tPT2 - the 400 000 UNIT MILESTONE (CROSSED in WINDOW 85 [0396], margin 1 867 - the THIRD PREDICTION of the series, ACHIEVED) CARRIES with margin 6 540. The 375 000 mark (crossed WINDOW 80 [0389], second prediction) carries 31 540; the 350 000 mark (crossed WINDOW 74 [0380], first prediction) carries 56 540; the 325 000 and 300 000 marks carry 81 540 and 106 540. Next round mark 425 000: 18 460 ahead (~4 windows at the ~4 673 pace - lands around window 88 absent snaps; compute from the decoded endpoint, do not pre-announce). CERTIFIED-ZERO CENSUS: cumulative total 1 739 984 over (g_a1, g_b86] - the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 85 [0396], margin 19 984 - the second census prediction, landed EXACTLY) CARRIES margin 39 984; the 1 600 000 mark carries 139 984; the 1 500 000 mark carries 239 984; the 1 800 000 mark is 60 016 ahead (~6.5 windows - around window 89 absent snaps; compute, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE86 : ℝ) - WinC.tPT2 = 406540 := by
  norm_num [tCE86, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 200 000-unit milestone (CROSSED in WINDOW 42B at 200 823, margin 823) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 200 000, margin 206 540. CARRIED INTO WINDOW-86: the face has since crossed 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast200k : (tCE86 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 175 000-unit milestone (CROSSED in WINDOW 38 at 175 404, margin 404) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 175 000, margin 231 540. CARRIED INTO WINDOW-86: the face has since crossed every round mark up to 400 000 @ CE85 (margin 1 867 - the third prediction, ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast175k : (tCE86 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 225 000-unit milestone (CROSSED in WINDOW 48 at 225 364, margin 364) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 225 000, margin 181 540. CARRIED INTO WINDOW-86: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast225k : (tCE86 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 250 000-unit milestone (CROSSED in WINDOW 53 at 250 944, margin 944) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 250 000, margin 156 540. CARRIED INTO WINDOW-86: the face has since crossed 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast250k : (tCE86 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 275 000-unit milestone (CROSSED in WINDOW 58 at 275 088, margin 88) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 275 000, margin 131 540. CARRIED INTO WINDOW-86: the face has since crossed 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast275k : (tCE86 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 300 000-unit round mark (CROSSED in WINDOW 64 at 300 972, margin 972) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 300 000, margin 106 540. CARRIED INTO WINDOW-86: the face has since crossed 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast300k : (tCE86 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 325 000-unit milestone (CROSSED in WINDOW 69 at 327 100, margin 2100 - predicted one window ahead and delivered exactly [0375]) is STILL strictly exceeded at the WINDOW-86 lower bound - (tCE86 : R) - WinC.tPT2 = 406 540 > 325 000, margin 81 540. CARRIED INTO WINDOW-86: the face has since crossed 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED); the 425 000 round mark is 18 460 ahead. -/
theorem frontierPast325k : (tCE86 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [0379]); CARRIED into WINDOW-86 - tCE86 - tPT2 = 406 540 exceeds 350 000 with margin 56 540. Proven at the WINDOW-74 frontier (tCE74 gap 350 465) through TWELVE face shrinks (CE76-CE86: eleven 4 673 + one 4 672 SNAP = 56 075). -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  have hshrink1 : (tCE86 : ℝ) - (tCE85 : ℝ) = 4673 := faceShrinkCE86
  have hshrink2 : (tCE85 : ℝ) - (tCE84 : ℝ) = 4673 := CE85.faceShrinkCE85
  have hshrink3 : (tCE84 : ℝ) - (tCE83 : ℝ) = 4673 := CE84.faceShrinkCE84
  have hshrink4 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := CE83.faceShrinkCE83
  have hshrink5 : (tCE82 : ℝ) - (tCE81 : ℝ) = 4673 := CE82.faceShrinkCE82
  have hshrink6 : (tCE81 : ℝ) - (tCE80 : ℝ) = 4673 := CE81.faceShrinkCE81
  have hshrink7 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := CE80.faceShrinkCE80
  have hshrink8 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink9 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink10 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink11 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink12 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6, hshrink7, hshrink8, hshrink9, hshrink10, hshrink11, hshrink12]
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 375 000 UNIT MILESTONE was CROSSED in WINDOW 80 (at 378 502, margin 3 502 - the SECOND PREDICTION of the series ACHIEVED [0389], with the 1 600 000 CENSUS MARK in the same window - the DOUBLE CONVERGENCE); CARRIED into WINDOW-86 - tCE86 - tPT2 = 406 540 exceeds 375 000 with margin 31 540. The next round mark 425 000 is 18 460 ahead (~4 windows at the ~4 673 pace). -/
theorem frontierPast375k : (tCE86 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 400 000 UNIT MILESTONE was CROSSED in WINDOW 85 (tCE85 - tPT2 = 401 867, margin 1 867 - the THIRD PREDICTION of the series ACHIEVED, with the 1 700 000 CENSUS MARK in the same window - the PREDICTED DOUBLE CROSSING [0396]); CARRIED into WINDOW-86 - tCE86 - tPT2 = 406 540 exceeds 400 000 with margin 6 540. The census mark 1 800 000 is 60 016 ahead (~6.5 windows absent snaps). -/
theorem frontierPast400k : (tCE86 : ℝ) - WinC.tPT2 > 400000 := by
  have h : (tCE86 : ℝ) - WinC.tPT2 = 406540 := frontierGapAboveH0
  linarith [h]

/-- ORDERING (machine, norm_num): (gB85Lo : R) < (gB86Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB85Lo = 300017573466725/100 (the STANDARD lower bound on the NON-SNAPPED window-85 endpoint g_b85 = 3 000 175 734 667.25720718360461431097149680518969603882323557767182435366294095761808234656964344821972190402448177337646484375 = the W86 seam g_a86) and gB86Lo = 300017573934019/100 (the STANDARD lower bound on the NON-SNAPPED window-86 endpoint g_b86 = 3 000 175 739 340.19231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375). -/
theorem gB85Lo_lt_gB86Lo : (gB85Lo : ℝ) < (gB86Lo : ℝ) := by
  norm_num [CE85.gB85Lo, gB86Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 85 FULL slice (re-cited in the W86 band - window 85 of 86, the full recorded window (gB84, g_b85], NON-SNAPPED 20 000, RESCUE: ONE recorded Rosser failure block - interior - ultimately DETERMINED [RECORDED, not suppressed]: block 1 naive [12 363 155 145 836, 12 363 155 145 838], need = 2, changes = 0, points = 129, m = 64, union [12 363 155 145 835, 12 363 155 145 840], need = 5, found = 5, m = 4): the b - a = 20 000 zeros of zeta with gB84 (the standard lower bound on the W84 endpoint g_b84, re-cited from the CE84 record) < Im s <= gB85 ('3 000 175 734 667.25720718360461431097149680518969603882323557767182435366294095761808234656964344821972190402448177337646484375', the W85 endpoint, + or - 1.29e-26) are all simple and on the line. Provenance: window85_b85.json (Murphy pipeline; M = 60, C_R = 1, 32 workers, 33 185 evals in 2 460.2 s, twentieth overlap run); verifier CERTIFIED (points 33 185, sign_changes_inside = 20 000, roser_failures_inside = 1, turing_ok, K_conservative = 12, end runs 47/48). SEAM: its g_a ball is the CE84 g_b ball EXACTLY (bit-identical tuple). Window-85 data per 0396 (unit 110); no RH CLAIM about window 85 or its rescue record. -/
def ce85WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB84Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB85Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 86 TERMINAL slice (re-cited - window 86 of 86, the (gB85, g_b86] portion of the recorded window, up to floor(gB86) - NON-SNAPPED 20 000, RESCUE: TWO recorded Rosser failure blocks, both INTERIOR, both ultimately DETERMINED [RECORDED, not suppressed] - block 1 naive [12 363 155 163 323, 12 363 155 163 325]: need = 2, changes = 0, points = 129, m = 64, union [12 363 155 163 321, 12 363 155 163 326]: need = 5, found = 5, m = 8; block 2 naive [12 363 155 166 705, 12 363 155 166 707]: need = 2, changes = 0, points = 129, m = 64, union [12 363 155 166 704, 12 363 155 166 709]: need = 5, found = 5, m = 2): the zeros of zeta with gB85 ('3 000 175 734 667.25720718360461431097149680518969603882323557767182435366294095761808234656964344821972190402448177337646484375', = window 85's endpoint g_b85, the W86 seam g_a86 bit-identical, + or - 1.29e-26) < Im s <= int(gB86) = 3 000 175 739 340 (the FLOOR - the endpoint g_b86 = 3 000 175 739 340.19231917145359734523448254470568195139130208959583860387510805627065378631268544040722190402448177337646484375 sits 0.19231917... above it, exact, robust to the 1.29e-26 radius) are all simple and on the line. Certificates: window86_b86.json (NON-SNAPPED 20 000; RESCUE - the two blocks above, quota-met, both determined; certified 2026-11-13) + the pipeline verifier (CERTIFIED, turing_ok, points 34 351, sign_changes_inside = 20 000, roser_failures_inside = 2, end Rosser runs 45 / 48, K_conservative = 12, 0 cross-check failures, 0 undetermined Gram signs) + the CE86 header (M = 60, C_R = 1, N_range = [691 008, 691 008], 32 workers, 34 351 evals in 2 646.3 s, twenty-first overlap run, resumed_from_cache = 671 399, and the bit-identical g_a86 == g_b85 SEAM AUDIT). Slice restriction (gB85, int(gB86)] is a SUBSET of the certified window, so its zeros inherit on-linedness; no RH CLAIM about the face above g_b86. -/
def ce86WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB85Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE86 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h87 (window 86 contributes ONE clause for its (gB85, g_b86] portion - h87; W86 NON-SNAPPED 20 000, RESCUE - two recorded Rosser failure blocks, both ultimately determined), ALL zeros of zeta with Im s > WinC.tPT2 and Im s <= (tCE86 : R) lie on the line: h1-h2 cover window 1 (CE2, the Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..86 enter as their certified (gB-prev, gB] slices (the slices are bit-identical at every seam; the re-cited full-slice clause carries the full recorded window) - windows 53..86 RE-CARRY the recorded Rosser-rescue records (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each, all ultimately determined; W78: SNAPPED 19 999 with one recorded failure; W82: SNAPPED 19 999 with two recorded failures, both determined; W83: NON-SNAPPED 20 000 with three recorded blocks, all determined; W84: NON-SNAPPED 20 000 with one recorded interior failure, determined; W85: NON-SNAPPED 20 000 with one recorded interior failure, determined; W86: NON-SNAPPED 20 000 with two recorded interior failures, both determined) and windows 79..80 carry the W80 CLEAN record (zero failures, first since W74) - and h87 carries the window-86 (gB85, g_b86] slice. CUMULATIVE tally through window 86: 86 windows - 36 clean, 50 rescue; 74 total internal Rosser failures, ALL RECORDED. NO RH CLAIM about Im s > tCE86. -/
theorem bandOfWindows86 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : CE22.ce21WinClauseFull)
    (h22 : CE23.ce22WinClauseFull) (h23 : CE24.ce23WinClauseFull)
    (h24 : CE25.ce24WinClauseFull) (h25 : CE26.ce25WinClauseFull)
    (h26 : CE27.ce26WinClauseFull) (h27 : CE28.ce27WinClauseFull)
    (h28 : CE29.ce28WinClauseFull) (h29 : CE30.ce29WinClauseFull)
    (h30 : CE31.ce30WinClauseFull)
    (h31 : CE32.ce31WinClauseFull)
    (h32 : CE33.ce32WinClauseFull)
    (h33 : CE34.ce33WinClauseFull)
    (h34 : CE35.ce34WinClauseFull)
    (h35 : CE36.ce35WinClauseFull)
    (h36 : CE37.ce36WinClauseFull)
    (h37 : CE38.ce37WinClauseFull)
    (h38 : CE39.ce38WinClauseFull)
    (h39 : CE40.ce39WinClauseFull)
    (h40 : CE41.ce40WinClauseFull)
    (h41 : ce41WinClauseFull)
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : CE80.ce79WinClauseFull) (h81 : CE81.ce80WinClauseFull) (h82 : CE82.ce81WinClauseFull) (h83 : CE83.ce82WinClauseFull) (h84 : CE84.ce83WinClauseFull) (h85 : CE85.ce84WinClauseFull) (h86 : ce85WinClauseFull) (h87 : ce86WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE86 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
          · exact h5 ρ hz (not_le.mp hseam4) hseam5
          · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
            · exact h6 ρ hz (not_le.mp hseam5) hseam6
            · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
              · exact h7 ρ hz (not_le.mp hseam6) hseam7
              · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
                · exact h8 ρ hz (not_le.mp hseam7) hseam8
                · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
                  · exact h9 ρ hz (not_le.mp hseam8) hseam9
                  · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
                    · exact h10 ρ hz (not_le.mp hseam9) hseam10
                    · by_cases hseam11 : ρ.im ≤ (gB11Lo : ℝ)
                      · exact h11 ρ hz (not_le.mp hseam10) hseam11
                      · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
                        · exact h12 ρ hz (not_le.mp hseam11) hseam12
                        · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
                          · exact h13 ρ hz (not_le.mp hseam12) hseam13
                          · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
                            · exact h14 ρ hz (not_le.mp hseam13) hseam14
                            · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
                              · exact h15 ρ hz (not_le.mp hseam14) hseam15
                              · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
                                · exact h16 ρ hz (not_le.mp hseam15) hseam16
                                · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
                                  · exact h17 ρ hz (not_le.mp hseam16) hseam17
                                  · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
                                    · exact h18 ρ hz (not_le.mp hseam17) hseam18
                                    · by_cases hseam19 : ρ.im ≤ (gB19Lo : ℝ)
                                      · exact h19 ρ hz (not_le.mp hseam18) hseam19
                                      · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
                                        · exact h20 ρ hz (not_le.mp hseam19) hseam20
                                        · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
                                          · exact h21 ρ hz (not_le.mp hseam20) hseam21
                                          · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
                                            · exact h22 ρ hz (not_le.mp hseam21) hseam22
                                            · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
                                              · exact h23 ρ hz (not_le.mp hseam22) hseam23
                                              · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
                                                · exact h24 ρ hz (not_le.mp hseam23) hseam24
                                                · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
                                                  · exact h25 ρ hz (not_le.mp hseam24) hseam25
                                                  · by_cases hseam26 : ρ.im ≤ (gB26Lo : ℝ)
                                                    · exact h26 ρ hz (not_le.mp hseam25) hseam26
                                                    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
                                                      · exact h27 ρ hz (not_le.mp hseam26) hseam27
                                                      · by_cases hseam28 : ρ.im ≤ (gB28Lo : ℝ)
                                                        · exact h28 ρ hz (not_le.mp hseam27) hseam28
                                                        · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
                                                          · exact h29 ρ hz (not_le.mp hseam28) hseam29
                                                          · by_cases hseam30 : ρ.im ≤ (gB30Lo : ℝ)
                                                            · exact h30 ρ hz (not_le.mp hseam29) hseam30
                                                            · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
                                                              · exact h31 ρ hz (not_le.mp hseam30) hseam31
                                                              · by_cases hseam32 : ρ.im ≤ (gB32Lo : ℝ)
                                                                · exact h32 ρ hz (not_le.mp hseam31) hseam32
                                                                · by_cases hseam33 : ρ.im ≤ (gB33Lo : ℝ)
                                                                  · exact h33 ρ hz (not_le.mp hseam32) hseam33
                                                                  · by_cases hseam34 : ρ.im ≤ (gB34Lo : ℝ)
                                                                    · exact h34 ρ hz (not_le.mp hseam33) hseam34
                                                                    · by_cases hseam35 : ρ.im ≤ (gB35Lo : ℝ)
                                                                      · exact h35 ρ hz (not_le.mp hseam34) hseam35
                                                                      · by_cases hseam36 : ρ.im ≤ (gB36Lo : ℝ)
                                                                        · exact h36 ρ hz (not_le.mp hseam35) hseam36
                                                                        · by_cases hseam37 : ρ.im ≤ (gB37Lo : ℝ)
                                                                          · exact h37 ρ hz (not_le.mp hseam36) hseam37
                                                                          · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
                                                                            · exact h38 ρ hz (not_le.mp hseam37) hseam38
                                                                            · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
                                                                              · exact h39 ρ hz (not_le.mp hseam38) hseam39
                                                                              · by_cases hseam40 : ρ.im ≤ (gB40Lo : ℝ)
                                                                                · exact h40 ρ hz (not_le.mp hseam39) hseam40
                                                                                · by_cases hseam41 : ρ.im ≤ (gB41Lo : ℝ)
                                                                                  · exact h41 ρ hz (not_le.mp hseam40) hseam41
                                                                                  · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
                                                                                    · exact h42 ρ hz (not_le.mp hseam41) hseam42
                                                                                    · by_cases hseam43 : ρ.im ≤ (gB42BLo : ℝ)
                                                                                      · exact h43 ρ hz (not_le.mp hseam42) hseam43
                                                                                      · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
                                                                                        · exact h44 ρ hz (not_le.mp hseam43) hseam44
                                                                                        · by_cases hseam45 : ρ.im ≤ (gB44Lo : ℝ)
                                                                                          · exact h45 ρ hz (not_le.mp hseam44) hseam45
                                                                                          · by_cases hseam46 : ρ.im ≤ (gB45Lo : ℝ)
                                                                                            · exact h46 ρ hz (not_le.mp hseam45) hseam46
                                                                                            · by_cases hseam47 : ρ.im ≤ (gB46Lo : ℝ)
                                                                                              · exact h47 ρ hz (not_le.mp hseam46) hseam47
                                                                                              · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
                                                                                                · exact h48 ρ hz (not_le.mp hseam47) hseam48
                                                                                                · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
                                                                                                  · exact h49 ρ hz (not_le.mp hseam48) hseam49
                                                                                                  · by_cases hseam50 : ρ.im ≤ (gB49Lo : ℝ)
                                                                                                    · exact h50 ρ hz (not_le.mp hseam49) hseam50
                                                                                                    · by_cases hseam51 : ρ.im ≤ (gB50Lo : ℝ)
                                                                                                      · exact h51 ρ hz (not_le.mp hseam50) hseam51
                                                                                                      · by_cases hseam52 : ρ.im ≤ (gB51Lo : ℝ)
                                                                                                        · exact h52 ρ hz (not_le.mp hseam51) hseam52
                                                                                                        · by_cases hseam53 : ρ.im ≤ (gB52Lo : ℝ)
                                                                                                          · exact h53 ρ hz (not_le.mp hseam52) hseam53
                                                                                                          · by_cases hseam54 : ρ.im ≤ (gB53Lo : ℝ)
                                                                                                            · exact h54 ρ hz (not_le.mp hseam53) hseam54
                                                                                                            · by_cases hseam55 : ρ.im ≤ (gB54Lo : ℝ)
                                                                                                              · exact h55 ρ hz (not_le.mp hseam54) hseam55
                                                                                                              · by_cases hseam56 : ρ.im ≤ (gB55Lo : ℝ)
                                                                                                                · exact h56 ρ hz (not_le.mp hseam55) hseam56
                                                                                                                · by_cases hseam57 : ρ.im ≤ (gB56Lo : ℝ)
                                                                                                                  · exact h57 ρ hz (not_le.mp hseam56) hseam57
                                                                                                                  · by_cases hseam58 : ρ.im ≤ (gB57Lo : ℝ)
                                                                                                                    · exact h58 ρ hz (not_le.mp hseam57) hseam58
                                                                                                                    · by_cases hseam59 : ρ.im ≤ (gB58Lo : ℝ)
                                                                                                                      · exact h59 ρ hz (not_le.mp hseam58) hseam59
                                                                                                                      · by_cases hseam60 : ρ.im ≤ (gB59Lo : ℝ)
                                                                                                                        · exact h60 ρ hz (not_le.mp hseam59) hseam60
                                                                                                                        · by_cases hseam61 : ρ.im ≤ (gB60Lo : ℝ)
                                                                                                                          · exact h61 ρ hz (not_le.mp hseam60) hseam61
                                                                                                                          · by_cases hseam62 : ρ.im ≤ (gB61Lo : ℝ)
                                                                                                                            · exact h62 ρ hz (not_le.mp hseam61) hseam62
                                                                                                                            · by_cases hseam63 : ρ.im ≤ (gB62Lo : ℝ)
                                                                                                                              · exact h63 ρ hz (not_le.mp hseam62) hseam63
                                                                                                                              · by_cases hseam64 : ρ.im ≤ (gB63Lo : ℝ)
                                                                                                                                · exact h64 ρ hz (not_le.mp hseam63) hseam64
                                                                                                                                · by_cases hseam65 : ρ.im ≤ (gB64Lo : ℝ)
                                                                                                                                  · exact h65 ρ hz (not_le.mp hseam64) hseam65
                                                                                                                                  · by_cases hseam66 : ρ.im ≤ (gB65Lo : ℝ)
                                                                                                                                    · exact h66 ρ hz (not_le.mp hseam65) hseam66
                                                                                                                                    · by_cases hseam67 : ρ.im ≤ (gB66Lo : ℝ)
                                                                                                                                      · exact h67 ρ hz (not_le.mp hseam66) hseam67
                                                                                                                                      · by_cases hseam68 : ρ.im ≤ (gB67Lo : ℝ)
                                                                                                                                        · exact h68 ρ hz (not_le.mp hseam67) hseam68
                                                                                                                                        · by_cases hseam69 : ρ.im ≤ (gB68Lo : ℝ)
                                                                                                                                          · exact h69 ρ hz (not_le.mp hseam68) hseam69
                                                                                                                                          · by_cases hseam70 : ρ.im ≤ (gB69Lo : ℝ)
                                                                                                                                            · exact h70 ρ hz (not_le.mp hseam69) hseam70
                                                                                                                                            · by_cases hseam71 : ρ.im ≤ (gB70Lo : ℝ)
                                                                                                                                              · exact h71 ρ hz (not_le.mp hseam70) hseam71
                                                                                                                                              · by_cases hseam72 : ρ.im ≤ (gB71Lo : ℝ)
                                                                                                                                                · exact h72 ρ hz (not_le.mp hseam71) hseam72
                                                                                                                                                · by_cases hseam73 : ρ.im ≤ (gB72Lo : ℝ)
                                                                                                                                                  · exact h73 ρ hz (not_le.mp hseam72) hseam73
                                                                                                                                                  · by_cases hseam74 : ρ.im ≤ (gB73Lo : ℝ)
                                                                                                                                                    · exact h74 ρ hz (not_le.mp hseam73) hseam74
                                                                                                                                                    · by_cases hseam75 : ρ.im ≤ (gB74Lo : ℝ)
                                                                                                                                                      · exact h75 ρ hz (not_le.mp hseam74) hseam75
                                                                                                                                                      · by_cases hseam76 : ρ.im ≤ (gB75Lo : ℝ)
                                                                                                                                                        · exact h76 ρ hz (not_le.mp hseam75) hseam76
                                                                                                                                                        · by_cases hseam77 : ρ.im ≤ (gB76Lo : ℝ)
                                                                                                                                                          · exact h77 ρ hz (not_le.mp hseam76) hseam77
                                                                                                                                                          · by_cases hseam78 : ρ.im ≤ (gB77Lo : ℝ)
                                                                                                                                                            · exact h78 ρ hz (not_le.mp hseam77) hseam78
                                                                                                                                                            · by_cases hseam79 : ρ.im ≤ (gB78Lo : ℝ)
                                                                                                                                                              · exact h79 ρ hz (not_le.mp hseam78) hseam79
                                                                                                                                                              · by_cases hseam80 : ρ.im ≤ (gB79Lo : ℝ)
                                                                                                                                                                · exact h80 ρ hz (not_le.mp hseam79) hseam80
                                                                                                                                                                · by_cases hseam81 : ρ.im ≤ (gB80Lo : ℝ)
                                                                                                                                                                  · exact h81 ρ hz (not_le.mp hseam80) hseam81
                                                                                                                                                                  · by_cases hseam82 : ρ.im ≤ (gB81Lo : ℝ)
                                                                                                                                                                    · exact h82 ρ hz (not_le.mp hseam81) hseam82
                                                                                                                                                                    · by_cases hseam83 : ρ.im ≤ (gB82Lo : ℝ)
                                                                                                                                                                      · exact h83 ρ hz (not_le.mp hseam82) hseam83
                                                                                                                                                                      · by_cases hseam84 : ρ.im ≤ (gB83Lo : ℝ)
                                                                                                                                                                        · exact h84 ρ hz (not_le.mp hseam83) hseam84
                                                                                                                                                                        · by_cases hseam85 : ρ.im ≤ (gB84Lo : ℝ)
                                                                                                                                                                          · exact h85 ρ hz (not_le.mp hseam84) hseam85
                                                                                                                                                                          · by_cases hseam86 : ρ.im ≤ (gB85Lo : ℝ)
                                                                                                                                                                            · exact h86 ρ hz (not_le.mp hseam85) hseam86
                                                                                                                                                                            · exact h87 ρ hz (not_le.mp hseam86) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 86-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE86 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..hW87 : the 87 verified window-slice clauses - the cited slices + the RE-CITED full slices for the re-anchored windows 43..86 (bit-identical seams, recorded data) incl. the W53..W86 Rosser records + hW87 : the window-86 terminal slice (NON-SNAPPED 20 000, RESCUE, two recorded blocks, both determined)). This is the finite-height closure through the corrected w1-w86 band (W42b fill) re-anchored to all of the certified EIGHTY-SIXTH window (NON-SNAPPED 20 000, RESCUE); census 1 739 984 over (g_a1, g_b86] - the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 139 984; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 39 984; the 1 800 000 mark is 60 016 ahead. NO RH CLAIM about the face above tCE86. -/
theorem allOnLineUpToCE86 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : ce85WinClauseFull) (hW87 : ce86WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE86 : ℝ) := by
  have hband := bandOfWindows86 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE EIGHTY-SIXTH RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the EIGHTY-SIXTH certified window (NON-SNAPPED 20 000, RESCUE - two recorded Rosser failure blocks, both determined; census 1 739 984 over (g_a1, g_b86]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE86 : R) = 3 000 175 739 340 lies on the line - i.e. the absolute clause [S1] and A1 (no data-dependent bound on the S-at-zeros and DN walk) above the new lower bound. Frontier 406 540 above H0: the 400 000 UNIT MILESTONE (CROSSED in W85 [0396], margin 1 867 - the third prediction, ACHIEVED) CARRIES with margin 6 540; the 375 000 mark (crossed W80, second prediction) carries 31 540; the 350 000 mark (crossed W74, first prediction) carries 56 540; the next round mark 425 000 is 18 460 ahead (~4 windows); the 1 600 000 CERTIFIED-ZERO MARK (crossed W80) carries margin 139 984; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 39 984; the 1 800 000 mark is 60 016 ahead. The increment series w79 -> w86 reads 4 673 eight times straight; the four 4 672 INCREMENT occurrences remain the four recorded; no pattern claim (floor/snap artifact data points). The face is RE-ANCHORED (the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE86 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE86 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE79 -> tCE80 -> ... -> tCE85 -> tCE86) leaves the face IMPLICATOR - anything true above tCE85 is true above tCE86. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE85_implies_faceCE86 (q : ZeroSet)
    (hface : CE85.terminalFaceCE85 q) :
    terminalFaceCE86 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE85_lt_tCE86, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW86, hW87): terminalFaceCE86 q <-> terminalFaceCE85 q. The re-anchor adds no strength and loses none - what was open at tCE85 is (exactly) what is open at tCE86, and the slice family (gB85Lo, tCE86] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE85 pattern). The forward direction splits on 'Im s <= tCE86': the band slice (gB85Lo, tCE86] is handled by the verified window slices hW86, hW87 (the W86 slice is NON-SNAPPED 20 000, RESCUE - two recorded blocks, both determined), the part above tCE86 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE86_iff_faceCE85 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW86 : ce85WinClauseFull) (hW87 : ce86WinClause) :
    terminalFaceCE86 q ↔ CE85.terminalFaceCE85 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE86 : ℝ)
    · by_cases hseam86 : ρ.im ≤ (gB85Lo : ℝ)
      · exact hW86 ρ (hqz ρ hρ) (by linarith [ht, CE85.gB84Lo_lt_tCE85, tCE85_lt_tCE86]) hseam86
      · exact hW87 ρ (hqz ρ hρ) (not_le.mp hseam86) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE85_implies_faceCE86 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE86) x (terminalFaceCE86 q) - finite-height closure (now through the corrected w1-w86 band with the W42b fill, re-anchored windows 53..86 all bit-identical at their seams; window 86 certified NON-SNAPPED at 20 000, RESCUE - two recorded Rosser failure blocks, both ultimately determined) AND the absolute clause above tCE86. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE86 - tPT2 = 406 540 - the 400 000 UNIT MILESTONE carries margin 6 540 [crossed W85]; census 1 739 984 - the 1 700 000 CERTIFIED-ZERO MARK carries margin 39 984 [crossed W85]). -/
theorem rh_split_at_CE86 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE86 : ℝ) ∧ terminalFaceCE86 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE86 : ℝ)
      · exact hCensus ρ hρ hpos hle
      · exact hFace ρ hρ (not_le.mp hle)
    · have hneg : ρ.im < 0 := by
        have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne hle0 hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstpos : 0 < (star ρ).im := by
        have h : (star ρ).im = -ρ.im := by rfl
        rw [h]
        exact neg_pos.mpr hneg
      have hstRe : (star ρ).re = 1 / 2 := by
        by_cases hle : (star ρ).im ≤ (tCE86 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE86): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW87 : the 87 verified window-slice clauses - windows 1..86, incl. the re-anchored 53..86 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each - all ultimately determined; W78: SNAPPED 19 999, one recorded failure; W82: SNAPPED 19 999, two recorded failures - both determined; W83: NON-SNAPPED 20 000, three recorded blocks - all determined; W84: NON-SNAPPED 20 000, one recorded block - determined; W85: NON-SNAPPED 20 000, one recorded block - determined; W86: NON-SNAPPED 20 000, two recorded blocks - both determined) and the W86 terminal slice (NON-SNAPPED, two recorded blocks, both determined)), RH is equivalent to the NAMED terminal face above tCE86 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w86 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..86, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE86 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : ce85WinClauseFull) (hW87 : ce86WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE86 q := by
  have hcensus := allOnLineUpToCE86 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hqz
  have hsplit := rh_split_at_CE86 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE86 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : ce85WinClauseFull) (hW87 : ce86WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE86 q) :
    RH q :=
  (rh_reanchored_CE86 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE86_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE86 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE86