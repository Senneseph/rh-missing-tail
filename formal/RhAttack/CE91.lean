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
import RhAttack.CE86
import RhAttack.CE87
import RhAttack.CE88
import RhAttack.CE89
import RhAttack.CE90

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82 CE83 CE84 CE85 CE86 CE87 CE88 CE89 CE90
open scoped Topology

/-!
**CE91 - the terminal face re-anchored at the NINETY-FIRST certified
window (0402, option B, unit 116 - lane M5).

MILESTONE STATE: tCE91 - tPT2 = 429 904 - the 425 000 UNIT MILESTONE
(crossed W90 [0401], margin 231 - the FOURTH PREDICTION of the series)
CARRIES margin 4 904; the 430 000 round mark is 96 ahead (the next
UNIT MILESTONE - compute at that window, do not pre-announce). The
400 000 mark (crossed W85 [0396], third prediction) carries 29 904;
the 375 000 mark (crossed W80 [0389], second prediction) carries
54 904; the 350 000 mark (crossed W74 [0380], first prediction)
carries 79 904; the 325 000 and 300 000 marks carry 104 904 and
129 904. Next round mark 450 000: 20 096 ahead (about five full
4 673 steps - compute from the decoded endpoint, do not pre-announce).
CERTIFIED-ZERO CENSUS: cumulative total 1 839 983 over (g_a1, g_b91]
- the 1 840 000 CERTIFIED-ZERO MARK is 17 ahead (compute at that
window, do not pre-announce); the 1 800 000 mark (crossed W90
[0401]) carries 39 983; the 1 700 000 mark carries 139 983; the
1 600 000 mark carries 239 983; 2 000 000 is 160 017 ahead (about
eight full windows; compute at that window, do not pre-announce).

WINDOW 91: NON-SNAPPED (b = a + 20 000 = 12 363 155 277 113; certified
width 20 000). CLEAN WINDOW: ZERO recorded interior Rosser failure
blocks, no rescue - the FOURTH clean record in this stretch, after
W80, W87 and W89 [0399]. End Rosser runs: 43 left of g_a91, 46 right
of g_b91 (both >= K = 12); 0 cross-check failures; 0 undetermined
Gram signs; max phase contribution 4.08e-21 (radius 1.67e-24).
INCREMENT: 4 673 (the usual step; the five recorded 4 672 occurrences
remain the five recorded - w45 -> w46, w53 -> w54, w65 -> w66,
w77 -> w78 [SNAP], w86 -> w87 [SNAP] - no pattern claimed). Census:
the full width adds 20 000 certified zeros (1 819 983 + 20 000 =
1 839 983).

INDEPENDENT AUDIT (performed BEFORE this module was written): a
separate raw-record recompute (a different code path from both the
pipeline and its verifier, exact-dyadic Fraction arithmetic)
reproduced from the recorded data EXACTLY 15 860 blocks inside,
sign changes inside = 20 000 = b - a, zero recorded interior Rosser
failures, and the end Rosser runs 43 / 46, with every recorded point
in strictly increasing t-order. On top of that, 425 sampled Gram
points (every 50th Gram point of [a - 60, b + 60] plus or minus 5 around
both ends) had their signs cross-checked against DIRECT dps-60
Riemann-Siegel evaluations from a different engine (mpmath, theta as
the classical series 0.5 t log(t/(2 pi)) - 0.5 t - pi/8 + 1/(48 t)
- 1/(5760 t^3)): matching signs at every sampled point (0
mismatches). This is a FOURTH verification layer on W91, beyond the
three standard layers below.

PIPELINE RUN (twenty-sixth in the overlap pipeline): seed cache
(window 90's cache copied in before launch - resumed_from_cache =
838 941, logged for provenance) + 32 workers: 33 412 evaluations in
2 559.4 s (same M = 60, C_R = 1, N_range = [691 008, 691 008], same
pipeline, same verifier, same seam discipline). Window 91 RAN WHILE
the formal unit D1G (the D1E named infinite-lifting gap IS
constructively satisfiable: the vanishing weight 2 to the minus n,
along an injective enumeration, has a summable norm sequence and
satisfies the gap for on-line zero sets, while the quantitative pole
obstruction persists at every nonzero-weight zero - the escape hatch
D1F left open, now machine-checked) reached GREEN; the per-unit
critical path is max(run, formalization); window 92 will be launched
from the audited W91 seam.

PROVENANCE (our run, 2026-11-14; pipeline = Murphy's Apache-2.0
deposit, same as CE1-CE90): RUN PARAMETERS: a = 12 363 155 257 113
(= b90), b = a + 20 000 = 12 363 155 277 113 (NON-SNAPPED), M = 60,
C_R = 1, 32 workers, 33 412 evaluations, 2 559.4 s,
resumed_from_cache = 838 941 (seeded from window90_b90.json.cache.jsonl).
CERTIFICATE (window91_b91.json): the 20 000 (= b - a) zeros of zeta
with g_a91 < Im s <= g_b91 are ALL SIMPLE and on the line, where
g_a91 (recorded exact dyadic ball) is
232127355985050446970376796310666280219 times 2 to the minus 86 with
radius 16777217 times 2 to the minus 110 (i.e. 3 000 175 758 031.69911766078199025211837702532685051298441923628663978188569610243397432769452137790722190402448177337646484375, the W90
endpoint, plus or minus 1.29e-26), and this ball is BIT-IDENTICAL to
CE90's recorded g_b90 (exact dyadic tuple comparison, 2026-11-14 -
audit performed BEFORE this module was written, per the 0348 process
rule); g_b91 = 3 000 175 762 704.63422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375 (the EXACT conservative center-minus-radius
reading: lo is dyadic with denominator 2 to the 110, so its base-10
expansion terminates exactly; the recorded endpoint ball's radius is
1.29e-26) with exact dyadic tuple [232127356346601289122690987861204409407,
-86, 16777217, -110] - normalizes to exponent -86, matching g_b86,
g_b87, g_b89 and g_b90; the exact dyadic tuple is authoritative over
the exponent representation. The floor tCE91 sits
0.63422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375 below the endpoint (EXACT) - robust to the 1.29e-26 radius by
many orders of magnitude; the standard two-decimal lower bound gB91Lo
(3 000 175 762 704.63) has the exact margin 0.00422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375 (EXACT, 110-digit
terminator - integer-tuple arithmetic, conservative center-minus-
radius reading); the two-decimal round-down (0.63) does not equal the
floor, so no CASING is needed - window 38 / CE38 remains the only
CASING case so far. (The gB91Lo margin is 4.2e-3 - the TWELFTH
sub-cent case in the current run: W79 (1.76e-4), W81 (4.03e-4), W82
(1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3),
W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), W91
(4.2e-3); cent-granularity luck of the endpoint; not by any precision
danger: the certified radius is 1.29e-26, eight orders of magnitude
smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE90): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window91_b91.json: "CERTIFIED: true",
points_checked = 33 412, sign_changes_inside = 20 000 (= b - a),
rosser_failures_inside = 0 (CLEAN WINDOW - zero failures, no
rescue), turing_ok = true, K_conservative = 12, end Rosser runs
43 / 46, endpoints recomputed and matched; (3) SEAM AUDIT (this
run): the recorded g_a91 ball is bit-identical to CE90's recorded
g_b90 ball (exact dyadic decode, 2026-11-14).
FRONTIER ARITHMETIC (machine, below): tCE91 = 3 000 175 762 704,
tCE91 - tCE90 = 4 673, tCE91 - tPT2 = 429 904 (the 430 000 UNIT
MILESTONE is 96 ahead; census 1 839 983 - the 1 840 000 CENSUS MARK
is 17 ahead). HONESTY (trust base): as CE2-CE90 - the pipeline's own
controls, its kernel-checked Lean remainder theorem, and our
verification layers (three standard, here four for W91); a RE-RUN of
a third-party pipeline, not a from-scratch independent certification.
Cumulative certified count = 1 839 983 over (g_a1, g_b91] (pipeline
data, not in-tree arithmetic). NO RH CLAIM.
-/
namespace CE91


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b91 (machine): gB91Lo = 3 000 175 762 704.63 = 300017576270463/100 - the two-decimal round-down of the certified lower bound (the endpoint g_b91 '3 000 175 762 704.63422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375' minus the certified radius 1.29e-26). The margin is the exact 0.00422829... (110-digit terminator) - THIN by cent-granularity luck of the endpoint (TWELFTH sub-cent case in the current run: W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), W91 (4.2e-3); not a precision danger - the certified radius is 1.29e-26, eight orders of magnitude smaller); no CASING is needed (the two-decimal round-down 0.63 does not equal the floor - window 38 / CE38 remains the only CASING case; no pattern claimed on thin margins). -/
def gB91Lo : ℚ := 300017576270463 / 100

/-- THE NEW LOWER BOUND (machine): 3 000 175 762 704 = floor(g_b91) = int(3 000 175 762 704.63422829...). The endpoint sits 0.63422829... above the integer boundary (exact, 110-digit terminator) and the certified radius is 1.29e-26, so the floor is robust by many orders of magnitude. tCE91 - tCE90 = 4 673 (the USUAL step - W91 ran NON-SNAPPED at full width 20 000 as a CLEAN WINDOW: zero recorded interior Rosser failure blocks, no rescue; the five recorded 4 672 INCREMENT occurrences remain the five recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP]) - no pattern claim beyond the recorded data). -/
def tCE91 : ℕ := 3000175762704

theorem tCE91_lt_gB91Lo : (tCE91 : ℝ) < (gB91Lo : ℝ) := by
  norm_num [gB91Lo, tCE91]

theorem tCE90_lt_tCE91 : (tCE90 : ℝ) < (tCE91 : ℝ) := by
  norm_num [CE90.tCE90, tCE91]

/-- ORDERING (machine, norm_num): (gB90Lo : R) < (tCE91 : R), with gB90Lo = 300017575803169/100 (the STANDARD lower bound introduced at CE90) and tCE91 = 3000175762704. So the window-91 terminal slice starts strictly below the new floor. -/
theorem gB90Lo_lt_tCE91 : (gB90Lo : ℝ) < (tCE91 : ℝ) := by
  norm_num [CE90.gB90Lo, tCE91]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE91 - tCE90 = 4 673. THE USUAL STEP: W91 ran NON-SNAPPED (b = a + 20 000 = 12 363 155 277 113, certified width 20 000) as a CLEAN WINDOW - ZERO recorded interior Rosser failure blocks, no rescue [the FOURTH clean record in this stretch, after W80, W87 and W89]. The increment is the full 4 673; the series w79 -> w91 now reads 4 673 eleven times and 4 672 once (w86 -> w87 SNAP); no pattern claim beyond the recorded data points. -/
theorem faceShrinkCE91 : (tCE91 : ℝ) - (tCE90 : ℝ) = 4673 := by
  norm_num [tCE91, CE90.tCE90]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE91 : R) - WinC.tPT2 = 3 000 175 762 704 - 3 000 175 332 800 = 429 904 above the H0 frontier WinC.tPT2 - CARRIED from the 425 000 UNIT MILESTONE (CROSSED in WINDOW 90 [0401], margin 231 - the FOURTH PREDICTION of the series): margin 4 904, and the 430 000 round mark is 96 ahead (the NEXT unit milestone - compute at that window, do not pre-announce). The 400 000 mark (crossed WINDOW 85 [0396], third prediction) carries 29 904; the 375 000 mark (crossed WINDOW 80 [0389], second prediction) carries 54 904; the 350 000 mark (crossed WINDOW 74 [0380], first prediction) carries 79 904; the 325 000 and 300 000 marks carry 104 904 and 129 904. Next round mark 450 000: 20 096 ahead (about five full 4 673 steps - compute from the decoded endpoint, do not pre-announce). CERTIFIED-ZERO CENSUS: cumulative total 1 839 983 over (g_a1, g_b91] - the 1 840 000 CERTIFIED-ZERO MARK is 17 ahead (compute at that window, do not pre-announce); the 1 800 000 mark (crossed W90 [0401]) carries 39 983; the 1 700 000 mark carries 139 983; the 1 600 000 mark carries 239 983; the 2 000 000 mark is 160 017 ahead (about eight full windows; compute at that window, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE91 : ℝ) - WinC.tPT2 = 429904 := by
  norm_num [tCE91, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 200 000-unit milestone (CROSSED in WINDOW 42B at 200 823, margin 823) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 200 000, margin 229 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast200k : (tCE91 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 175 000-unit milestone (CROSSED in WINDOW 38 at 175 404, margin 404) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 175 000, margin 254 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast175k : (tCE91 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 225 000-unit milestone (CROSSED in WINDOW 48 at 225 364, margin 364) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 225 000, margin 204 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast225k : (tCE91 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 250 000-unit milestone (CROSSED in WINDOW 53 at 250 944, margin 944) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 250 000, margin 179 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast250k : (tCE91 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 275 000-unit milestone (CROSSED in WINDOW 58 at 275 088, margin 88) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 275 000, margin 154 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast275k : (tCE91 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 300 000-unit round mark (CROSSED in WINDOW 64 at 300 972, margin 972) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 300 000, margin 129 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast300k : (tCE91 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 325 000-unit milestone (CROSSED in WINDOW 69 at 327 100, margin 2100 - predicted one window ahead and delivered exactly [0375]) is STILL strictly exceeded at the WINDOW-91 lower bound - (tCE91 : R) - WinC.tPT2 = 429 904 > 325 000, margin 104 904. CARRIED INTO WINDOW-91: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED), 400 000 @ CE85 (margin 1 867 - ACHIEVED), 425 000 @ CE90 (margin 231 - ACHIEVED - the FOURTH PREDICTION of the series); the next round mark 450 000 is 20 096 ahead. -/
theorem frontierPast325k : (tCE91 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-91 - tCE91 - tPT2 = 429 904 exceeds 350 000 with margin 79 904. Proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, through SEVENTEEN face shrinks (CE75-CE91: fifteen 4 673 + two 4 672 SNAP [w77 -> w78, w86 -> w87] = 79 439: 350 465 -> 429 904). -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  have hshrink1 : (tCE91 : ℝ) - (tCE90 : ℝ) = 4673 := faceShrinkCE91
  have hshrink2 : (tCE90 : ℝ) - (tCE89 : ℝ) = 4673 := CE90.faceShrinkCE90
  have hshrink3 : (tCE89 : ℝ) - (tCE88 : ℝ) = 4673 := CE89.faceShrinkCE89
  have hshrink4 : (tCE88 : ℝ) - (tCE87 : ℝ) = 4673 := CE88.faceShrinkCE88
  have hshrink5 : (tCE87 : ℝ) - (tCE86 : ℝ) = 4672 := CE87.faceShrinkCE87
  have hshrink6 : (tCE86 : ℝ) - (tCE85 : ℝ) = 4673 := CE86.faceShrinkCE86
  have hshrink7 : (tCE85 : ℝ) - (tCE84 : ℝ) = 4673 := CE85.faceShrinkCE85
  have hshrink8 : (tCE84 : ℝ) - (tCE83 : ℝ) = 4673 := CE84.faceShrinkCE84
  have hshrink9 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := CE83.faceShrinkCE83
  have hshrink10 : (tCE82 : ℝ) - (tCE81 : ℝ) = 4673 := CE82.faceShrinkCE82
  have hshrink11 : (tCE81 : ℝ) - (tCE80 : ℝ) = 4673 := CE81.faceShrinkCE81
  have hshrink12 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := CE80.faceShrinkCE80
  have hshrink13 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink14 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink15 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink16 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink17 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6, hshrink7, hshrink8, hshrink9, hshrink10, hshrink11, hshrink12, hshrink13, hshrink14, hshrink15, hshrink16, hshrink17]
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 375 000 UNIT MILESTONE was CROSSED in WINDOW 80 (at 378 502, margin 3 502 - the SECOND PREDICTION of the series ACHIEVED [0389], with the 1 600 000 CENSUS MARK in the same window - the DOUBLE CONVERGENCE); CARRIED into WINDOW-91 - tCE91 - tPT2 = 429 904 exceeds 375 000 with margin 54 904. The next round mark 450 000 is 20 096 ahead (about five full 4 673 steps; compute, do not pre-announce). -/
theorem frontierPast375k : (tCE91 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 400 000 UNIT MILESTONE was CROSSED in WINDOW 85 (tCE85 - tPT2 = 401 867, margin 1 867 - the THIRD PREDICTION of the series ACHIEVED, with the 1 700 000 CENSUS MARK in the same window - the PREDICTED DOUBLE CROSSING [0396]); CARRIED into WINDOW-91 - tCE91 - tPT2 = 429 904 exceeds 400 000 with margin 29 904. The 425 000 mark (the FOURTH PREDICTION) was CROSSED in WINDOW 90 (margin 231) and CARRIES here with margin 4 904. -/
theorem frontierPast400k : (tCE91 : ℝ) - WinC.tPT2 > 400000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 425 000 UNIT MILESTONE - the FOURTH PREDICTION of the series (predicted at CE89 [0400] as landing in window 90 absent snaps, ACHIEVED: CROSSED in WINDOW 90 at 425 231, margin 231, with the 1 800 000 CERTIFIED-ZERO MARK in the same window - the PREDICTED DOUBLE CROSSING) - is CARRIED into WINDOW-91: (tCE91 : R) - WinC.tPT2 = 429 904 > 425 000, margin 4 904. The 430 000 round mark is 96 ahead (the NEXT unit milestone - compute at that window, do not pre-announce). All four PREDICTED crossings of the series (second @ W80, third @ W85, fourth @ W90) have landed in their predicted windows; the fifth is not predicted (no pattern claimed). -/
theorem frontierPast425k : (tCE91 : ℝ) - WinC.tPT2 > 425000 := by
  have h : (tCE91 : ℝ) - WinC.tPT2 = 429904 := frontierGapAboveH0
  linarith [h]

/-- ORDERING (machine, norm_num): (gB90Lo : R) < (gB91Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB90Lo = 300017575803169/100 (the STANDARD lower bound on the window-90 endpoint g_b90 = 3 000 175 758 031.69911766078199025211837702532685051298441923628663978188569610243397432769452137790722190402448177337646484375 - normalizes to exponent -86, matching g_b86, g_b87 and g_b89) and gB91Lo = 300017576270463/100 (the STANDARD lower bound on the window-91 endpoint g_b91 = 3 000 175 762 704.63422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375 - normalizes to exponent -86 again, matching g_b86, g_b87, g_b89 and g_b90; the exact dyadic tuple is authoritative over the exponent representation). -/
theorem gB90Lo_lt_gB91Lo : (gB90Lo : ℝ) < (gB91Lo : ℝ) := by
  norm_num [CE90.gB90Lo, gB91Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 90 FULL slice (re-cited in the W91 band - window 90 of 91, the full recorded window (gB89, g_b90], NON-SNAPPED 20 000, DOUBLE-RESCUE: two recorded interior Rosser failure blocks, both DETERMINED via the usual rescue expansion [RECORDED, not suppressed]): the zeros of zeta with gB89 (the standard lower bound on the W89 endpoint g_b89 '3 000 175 753 358.76400675553109097396719569317740113303939909056534922097171085657286125625287098728222190402448177337646484375', re-cited from the CE89 record) < Im s <= gB90 ('3 000 175 758 031.69911766078199025211837702532685051298441923628663978188569610243397432769452137790722190402448177337646484375', the W90 endpoint, + or - 1.29e-26) are all simple and on the line. Provenance: window90_b90.json (Murphy pipeline; NON-SNAPPED 20 000; M = 60, C_R = 1, 32 workers, 34 086 evals in 2 490.3 s, twenty-fifth overlap run, resumed_from_cache = 805 050); verifier CERTIFIED (points 34 086, sign_changes_inside = 20 000, roser_failures_inside = 2 (both determined), turing_ok, K_conservative = 12, end runs 43/50, 0 cross-check failures, 0 undetermined Gram signs, max phase 4.10e-21 radius 2.61e-24). SEAM: its g_a ball is the CE89 g_b ball EXACTLY (bit-identical tuple). Window-90 data per 0401 (unit 115); the W91 band also re-cites it in full so that the W91 terminal slice starts at gB90; no RH CLAIM about window 90. -/
def ce90WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB89Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB90Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 91 TERMINAL slice (re-cited - window 91 of 91, the (gB90, g_b91] portion of the recorded window, up to floor(gB91) - NON-SNAPPED 20 000, CLEAN WINDOW: ZERO recorded interior Rosser failure blocks, no rescue - the FOURTH clean record in this stretch, after W80, W87 and W89): the zeros of zeta with gB90 ('3 000 175 758 031.69911766078199025211837702532685051298441923628663978188569610243397432769452137790722190402448177337646484375', = window 90's endpoint g_b90, the W91 seam g_a91 bit-identical, + or - 1.29e-26) < Im s <= int(gB91) = 3 000 175 762 704 (the FLOOR - the endpoint g_b91 = 3 000 175 762 704.63422829537998660138987980956374344019439350656171220957958150425660091842328114353222190402448177337646484375 sits 0.63422829... above it, exact, robust to the 1.29e-26 radius) are all simple and on the line. Certificates: window91_b91.json (NON-SNAPPED 20 000; certified 2026-11-14) + the pipeline verifier (CERTIFIED, turing_ok, points 33 412, sign_changes_inside = 20 000, roser_failures_inside = 0, end Rosser runs 43 / 46, K_conservative = 12, 0 cross-check failures, 0 undetermined Gram signs, max phase 4.08e-21 radius 1.67e-24) + the CE91 header (M = 60, C_R = 1, N_range = [691 008, 691 008], 32 workers, 33 412 evals in 2 559.4 s, twenty-sixth overlap run, resumed_from_cache = 838 941, and the bit-identical g_a91 == g_b90 SEAM AUDIT) + an independent raw-record recompute (separate code path, exact dyadic arithmetic: reproduced 15 860 blocks inside, changes = 20 000 = b - a, zero recorded interior failures, runs 43/46) + a sampled cross-check of 425 Gram-point signs against direct dps-60 Riemann-Siegel evaluations from a different engine (0 mismatches). Slice restriction (gB90, int(gB91)] is a SUBSET of the certified window, so its zeros inherit on-linedness; no RH CLAIM about the face above g_b91. -/
def ce91WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB90Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE91 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h92 (window 91 contributes ONE clause for its (gB90, g_b91] portion - h92; W91 NON-SNAPPED 20 000 - CLEAN WINDOW, zero recorded failures, no rescue), ALL zeros of zeta with Im s > WinC.tPT2 and Im s <= (tCE91 : R) lie on the line: h1-h2 cover window 1 (CE2, the Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..91 enter as their certified (gB-prev, gB] slices (the slices are bit-identical at every seam; the re-cited full-slice clause carries the full recorded window) - windows 53..91 RE-CARRY the recorded Rosser-rescue records (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each, all ultimately determined; W78: SNAPPED 19 999 with one recorded failure; W82: SNAPPED 19 999 with two recorded failures, both determined; W83: NON-SNAPPED 20 000 with three recorded blocks, all determined; W84: NON-SNAPPED 20 000 with one recorded interior failure, determined; W85: NON-SNAPPED 20 000 with one recorded interior failure, determined; W86: NON-SNAPPED 20 000 with two recorded interior failures, both determined; W87: SNAPPED 19 999 CLEAN - zero failures; W88: NON-SNAPPED 20 000 with one recorded interior failure, determined; W89: NON-SNAPPED 20 000 CLEAN - zero failures; W90: NON-SNAPPED 20 000 with two recorded interior failures, both determined; W91: NON-SNAPPED 20 000 CLEAN - zero failures) and windows 80, 87, 89 and 91 carry the CLEAN records (zero failures - W80 first since W74, W87 second, W89 third, W91 fourth) - and h92 carries the window-91 (gB90, g_b91] slice. CUMULATIVE tally through window 91: 91 windows - 39 clean, 52 rescue; 77 total internal Rosser failures, ALL RECORDED. NO RH CLAIM about Im s > tCE91. -/
theorem bandOfWindows91 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : CE80.ce79WinClauseFull) (h81 : CE81.ce80WinClauseFull) (h82 : CE82.ce81WinClauseFull) (h83 : CE83.ce82WinClauseFull) (h84 : CE84.ce83WinClauseFull) (h85 : CE85.ce84WinClauseFull) (h86 : CE86.ce85WinClauseFull) (h87 : CE87.ce86WinClauseFull) (h88 : CE88.ce87WinClauseFull) (h89 : CE89.ce88WinClauseFull) (h90 : CE90.ce89WinClauseFull) (h91 : ce90WinClauseFull) (h92 : ce91WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE91 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                                            · by_cases hseam87 : ρ.im ≤ (gB86Lo : ℝ)
                                                                                                                                                                              · exact h87 ρ hz (not_le.mp hseam86) hseam87
                                                                                                                                                                              · by_cases hseam88 : ρ.im ≤ (gB87Lo : ℝ)
                                                                                                                                                                                · exact h88 ρ hz (not_le.mp hseam87) hseam88
                                                                                                                                                                                · by_cases hseam89 : ρ.im ≤ (gB88Lo : ℝ)
                                                                                                                                                                                  · exact h89 ρ hz (not_le.mp hseam88) hseam89
                                                                                                                                                                                  · by_cases hseam90 : ρ.im ≤ (gB89Lo : ℝ)
                                                                                                                                                                                    · exact h90 ρ hz (not_le.mp hseam89) hseam90
                                                                                                                                                                                    · by_cases hseam91 : ρ.im ≤ (gB90Lo : ℝ)
                                                                                                                                                                                      · exact h91 ρ hz (not_le.mp hseam90) hseam91
                                                                                                                                                                                      · exact h92 ρ hz (not_le.mp hseam91) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 91-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE91 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..hW92 : the 92 verified window-slice clauses - the cited slices + the RE-CITED full slices for the re-anchored windows 43..91 (bit-identical seams, recorded data) incl. the W53..W89 Rosser records + hW92 : the window-91 terminal slice (NON-SNAPPED 20 000, CLEAN - zero failures)). This is the finite-height closure through the corrected w1-w91 band (W42b fill) re-anchored to all of the certified NINETY-FIRST window (NON-SNAPPED 20 000, CLEAN WINDOW); census 1 839 983 over (g_a1, g_b91] - the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 239 983; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 139 983; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 39 983; the 1 840 000 mark is 17 ahead (compute at that window); the 2 000 000 mark is 160 017 ahead. NO RH CLAIM about the face above tCE91. -/
theorem allOnLineUpToCE91 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : ce90WinClauseFull) (hW92 : ce91WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE91 : ℝ) := by
  have hband := bandOfWindows91 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE NINETY-FIRST RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the NINETY-FIRST certified window (NON-SNAPPED 20 000, CLEAN WINDOW - zero recorded interior Rosser failures, no rescue; census 1 839 983 over (g_a1, g_b91]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE91 : R) = 3 000 175 762 704 lies on the line - i.e. the absolute clause [S1] and A1 (no data-dependent bound on the S-at-zeros and DN walk) above the new lower bound. Frontier 429 904 above H0: the 425 000 UNIT MILESTONE (crossed W90 [0401], margin 231 - the FOURTH PREDICTION of the series) CARRIES margin 4 904; the 430 000 round mark is 96 ahead (the NEXT unit milestone - compute at that window, do not pre-announce); the 400 000 mark (crossed W85 [0396], third prediction) carries 29 904; the 375 000 mark (crossed W80, second prediction) carries 54 904; the 350 000 mark (crossed W74, first prediction) carries 79 904; the 325 000 and 300 000 marks carry 104 904 and 129 904; the next round mark 450 000 is 20 096 ahead; the 1 700 000 CERTIFIED-ZERO MARK (crossed W85) carries margin 139 983; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 39 983; the 1 840 000 mark is 17 ahead; the 2 000 000 mark is 160 017 ahead. The increment tCE91 - tCE90 = 4 673 (the usual step; the five recorded 4 672 occurrences remain w45, w53, w65, w77 [SNAP], w86 [SNAP]); no pattern claim beyond the recorded data. The face is RE-ANCHORED (the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE91 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE91 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE89 -> ... -> tCE90 -> tCE91) leaves the face IMPLICATOR - anything true above tCE90 is true above tCE91. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE90_implies_faceCE91 (q : ZeroSet)
    (hface : CE90.terminalFaceCE90 q) :
    terminalFaceCE91 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE90_lt_tCE91, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW91, hW92): terminalFaceCE91 q <-> terminalFaceCE90 q. The re-anchor adds no strength and loses none - what was open at tCE90 is (exactly) what is open at tCE91, and the slice family (gB90Lo, tCE91] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE90 pattern). The forward direction splits on 'Im s <= tCE91': the band slice (gB90Lo, tCE91] is handled by the verified window slices hW91, hW92 (the W90 slice is NON-SNAPPED 20 000, DOUBLE-RESCUE - two determined failures, re-cited in full at gB90; the W91 slice is NON-SNAPPED 20 000, CLEAN - zero failures), the part above tCE91 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE91_iff_faceCE90 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW91 : ce90WinClauseFull) (hW92 : ce91WinClause) :
    terminalFaceCE91 q ↔ CE90.terminalFaceCE90 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE91 : ℝ)
    · by_cases hseam91 : ρ.im ≤ (gB90Lo : ℝ)
      · exact hW91 ρ (hqz ρ hρ) (by linarith [ht, CE90.gB89Lo_lt_tCE90, tCE90_lt_tCE91]) hseam91
      · exact hW92 ρ (hqz ρ hρ) (not_le.mp hseam91) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE90_implies_faceCE91 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE91) x (terminalFaceCE91 q) - finite-height closure (now through the corrected w1-w91 band with the W42b fill, re-anchored windows 53..91 all bit-identical at their seams; window 91 certified NON-SNAPPED at 20 000, CLEAN WINDOW with zero recorded Rosser failures) AND the absolute clause above tCE91. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE91 - tPT2 = 429 904 - the 425 000 UNIT MILESTONE CARRIES margin 4 904 [crossed W90]; census 1 839 983 - the 1 840 000 CERTIFIED-ZERO MARK is 17 ahead). -/
theorem rh_split_at_CE91 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE91 : ℝ) ∧ terminalFaceCE91 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE91 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE91 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE91): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW92 : the 92 verified window-slice clauses - windows 1..91, incl. the re-anchored 53..91 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each - all ultimately determined; W78: SNAPPED 19 999, one recorded failure; W82: SNAPPED 19 999, two recorded failures - both determined; W83: NON-SNAPPED 20 000, three recorded blocks - all determined; W84: NON-SNAPPED 20 000, one recorded block - determined; W85: NON-SNAPPED 20 000, one recorded block - determined; W86: NON-SNAPPED 20 000, two recorded blocks - both determined; W87: SNAPPED 19 999, CLEAN - zero failures; W88: NON-SNAPPED 20 000, one recorded interior block - determined; W89: NON-SNAPPED 20 000, CLEAN - zero failures; W90: NON-SNAPPED 20 000, two recorded interior blocks - both determined; W91: NON-SNAPPED 20 000, CLEAN - zero failures)), RH is equivalent to the NAMED terminal face above tCE91 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w91 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..91, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE91 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : ce90WinClauseFull) (hW92 : ce91WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE91 q := by
  have hcensus := allOnLineUpToCE91 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hqz
  have hsplit := rh_split_at_CE91 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE91 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : ce90WinClauseFull) (hW92 : ce91WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE91 q) :
    RH q :=
  (rh_reanchored_CE91 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE91_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE91 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE91