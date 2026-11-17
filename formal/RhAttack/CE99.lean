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
import RhAttack.CE91
import RhAttack.CE92
import RhAttack.CE93
import RhAttack.CE94
import RhAttack.CE95
import RhAttack.CE96
import RhAttack.CE97
import RhAttack.CE98

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82 CE83 CE84 CE85 CE86 CE87 CE88 CE89 CE90 CE91 CE92 CE93 CE94 CE95 CE96 CE97 CE98
open scoped Topology

/-!
**CE99 - the terminal face re-anchored at the NINETY-NINTH certified window
(0420, option B - lane M5).

MILESTONE STATE: tCE99 - tPT2 = 467,287 - the 460 000 UNIT ROUND MARK (crossed at W98 [0419]) carries 7 287; the 465 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 99 (margin 2 287 - a regular round crossing, not a predicted milestone); the next round mark 470 000 is 2 713 ahead (less than one full step - compute at that window, do not pre-announce).
CERTIFIED-ZERO CENSUS: cumulative total 1 999 979 over (g_a1, g_b99] -
the 1 980 000 CERTIFIED-ZERO MARK was CROSSED in THIS WINDOW, WINDOW 99 (margin 19 979 - first crossing of that mark); the 1 960 000 mark (crossed W98 [0419]) carries 39 979; the 1 940 000 mark (crossed W97 [0418]) carries 59 979; 2 000 000 is 21 ahead (less than one zero-span - the tail window W100 will land it, do not pre-announce)

WINDOW 99: NON-SNAPPED 20 000, CLEAN (a = 12 363 155 417 109 = b98 (the bit-identical seam), b = 12 363 155 437 109; certified width
20,000). ZERO recorded interior Rosser failure blocks - a CLEAN window.. Census: the window adds 20,000 certified zeros
(1 979 979 + 20,000 = 1 999 979). Cumulative tally through window 99: 99
windows - 43 clean, 56 rescue; 86 total internal Rosser
failures, ALL RECORDED. End Rosser runs: 49 / 46 left of g_a99 / right of g_b99 (both >= K = 12); 0
cross-check failures; 0 undetermined Gram signs; max phase contribution 4.10e-21 (radius 2.61e-24).

PIPELINE RUN (thirty-fourth in the overlap pipeline): the post-2026-11-16-reboot run seeded from the W98 cache tail (resumed_from_cache = 32 737; 33 387 fresh evaluations in 146.1 s, logged for provenance) 6 workers: 33 387
evaluations in 146.1 s (same M = 60, C_R = 1, N_range = [691 008, 691 008], same pipeline, same
verifier, same seam discipline).

PROVENANCE (our run, 2026-11-16; pipeline = Murphy's Apache-2.0 deposit, same as CE1-CE98): RUN
PARAMETERS: a = 12 363 155 417 109 (= b98), b = 12 363 155 437 109 (NON-SNAPPED 20 000, CLEAN), M = 60, C_R = 1, 6 workers, 33 387
evaluations, 146.1 s, resumed_from_cache = 32 737. CERTIFICATE (window99_b99.json): the
20,000 (= b - a) zeros of zeta with g_a99 < Im s <= g_b99 are ALL SIMPLE and on the line,
where g_a99 (recorded exact dyadic ball) is [232127358877384873434150165386313952977, -86, 16777217, -110] (the W98 endpoint g_b98, the W99 seam g_a99
BIT-IDENTICAL - exact dyadic tuple comparison, audited BEFORE this module was written, per the 0348
process rule), and g_b99 has exact dyadic tuple [232127359238935715418942513750545622351, -86, 16777217, -110] (the -86 dyadic family). The floor
tCE99 = 3,000,175,800,087 sits 0.0005166069926931049037 (exact, exponent -86 dyadic arithmetic, center-minus-radius) below the certified lower bound (EXACT dyadic arithmetic,
center-minus-radius reading; robust to the certified radius ~4.7e-14 by many orders of magnitude); the
standard two-decimal lower bound gB99Lo (300017580008718 / 100 = 3000175800087.18) has the exact margin
0.0005166069926931049037 (exact, exponent -86 dyadic arithmetic, center-minus-radius); the two-decimal round-down (0.18) is strictly below the exact fractional part
(0.180516606992693104903701... (exact, exponent -86 dyadic terminator)), so no CASING is needed - window 38 / CE38 remains the only CASING case so far. (The
gB99Lo margin 5.17e-4 is the TWENTIETH sub-cent case in the current run:
W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4); not a precision danger - the certified radius is ~4.7e-14, four orders of
magnitude smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE98): (1) ENVIRONMENT REPEAT (Murphy's window-1 certificate
re-verified - see CE2 header); (2) PIPELINE VERIFIER on window99_b99.json: "CERTIFIED: true",
points_checked = 33 387, sign_changes_inside = 20,000 (= b - a),
rosser_failures_inside = 0 (ALL DETERMINED and rescued - see the W99 record above),
turing_ok = true, K_conservative = 12, end Rosser runs 49 / 46; (3) SEAM AUDIT (this run): the
recorded g_a99 ball is bit-identical to CE98's recorded g_b98 ball (exact dyadic decode,
2026-11-16). The window is CLEAN (zero interior Rosser failure blocks) - nothing to adjudicate.
FRONTIER ARITHMETIC (machine, below): tCE99 = 3,000,175,800,087, tCE99 - tCE98 = 4673,
tCE99 - tPT2 = 467,287.
HONESTY (trust base): as CE2-CE98 - the pipeline's own controls, its kernel-checked Lean remainder
theorem, and our verification layers; a RE-RUN of a third-party pipeline, not a from-scratch independent
certification. Cumulative certified count = 1 999 979 over (g_a1, g_b99] (pipeline data, not
in-tree arithmetic). NO RH CLAIM.
-/
namespace CE99


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b99 (machine): gB99Lo = 300017580008718 / 100 = 3000175800087.18 - the two-decimal round-down of the certified lower bound (the endpoint g_b99 minus the certified radius ~4.7e-14). The margin is the exact 0.0005166069926931049037 (exact, exponent -86 dyadic arithmetic, center-minus-radius); the two-decimal round-down (0.18) is strictly below the exact fractional part (0.180516606992693104903701... (exact, exponent -86 dyadic terminator)), so no CASING is needed (window 38 / CE38 remains the only CASING case). The 5.17e-4 margin is the TWENTIETH sub-cent case in the current run - not a precision danger (certified radius ~4.7e-14). -/
def gB99Lo : ℚ := 300017580008718 / 100

/-- THE NEW LOWER BOUND (machine): 3,000,175,800,087 = floor(g_b99). The endpoint sits 0.180516606992693104903701... (exact, exponent -86 dyadic terminator) above the integer boundary (exact, exponent -86 dyadic terminator) and the certified radius is ~4.7e-14, so the floor is robust by many orders of magnitude. tCE99 - tCE98 = 4673 (the usual increment - W99 ran NON-SNAPPED 20 000 CLEAN, certified b = 12 363 155 437 109 - no pattern claim beyond the recorded data). -/
def tCE99 : ℕ := 3000175800087

theorem tCE99_lt_gB99Lo : (tCE99 : ℝ) < (gB99Lo : ℝ) := by
  norm_num [gB99Lo, tCE99]

theorem tCE98_lt_tCE99 : (tCE98 : ℝ) < (tCE99 : ℝ) := by
  norm_num [CE98.tCE98, tCE99]

/-- ORDERING (machine, norm_num): (gB98Lo : R) < (tCE99 : R), with gB98Lo the STANDARD lower bound introduced at CE98 and tCE99 = 3,000,175,800,087. So the window-99 terminal slice starts strictly below the new floor. -/
theorem gB98Lo_lt_tCE99 : (gB98Lo : ℝ) < (tCE99 : ℝ) := by
  norm_num [CE98.gB98Lo, tCE99]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE99 - tCE98 = 4673. THE USUAL INCREMENT: W99 ran NON-SNAPPED 20 000, CLEAN (certified b = 12 363 155 437 109); the floor advances by 4673. The six recorded 4 672 INCREMENT occurrences remain w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP], w86 -> w87 [SNAP], w97 -> w98 [SNAP]; no pattern claim beyond the recorded data points. -/
theorem faceShrinkCE99 : (tCE99 : ℝ) - (tCE98 : ℝ) = 4673 := by
  norm_num [tCE99, CE98.tCE98]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE99 : R) - WinC.tPT2 = 3,000,175,800,087 - 3 000 175 332 800 = 467,287 above the H0 frontier WinC.tPT2. The 460 000 unit round mark (crossed at w98 [0419]) carries 7 287; the 465 000 unit round mark was crossed in this window, window 99 (margin 2 287 - a regular round crossing, not a predicted milestone); the next round mark 470 000 is 2 713 ahead (less than one full step - compute at that window, do not pre-announce). CERTIFIED-ZERO CENSUS: cumulative total 1 999 979 over (g_a1, g_b99] - the 1 980 000 CERTIFIED-ZERO MARK was CROSSED in THIS WINDOW, WINDOW 99 (margin 19 979 - first crossing of that mark); the 1 960 000 mark (crossed W98 [0419]) carries 39 979; the 1 940 000 mark (crossed W97 [0418]) carries 59 979; 2 000 000 is 21 ahead (less than one zero-span - the tail window W100 will land it, do not pre-announce) -/
theorem frontierGapAboveH0 : (tCE99 : ℝ) - WinC.tPT2 = 467287 := by
  norm_num [tCE99, WinC.tPT2]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 175 000-unit mark (CROSSED in WINDOW 38 - see the CE38 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 175,000, margin 292,287. -/
theorem frontierPast175k : (tCE99 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 200 000-unit mark (CROSSED in WINDOW 42B - see the CE42B module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 200,000, margin 267,287. -/
theorem frontierPast200k : (tCE99 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 225 000-unit mark (CROSSED in WINDOW 48 - see the CE48 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 225,000, margin 242,287. -/
theorem frontierPast225k : (tCE99 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 250 000-unit mark (CROSSED in WINDOW 53 - see the CE53 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 250,000, margin 217,287. -/
theorem frontierPast250k : (tCE99 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 275 000-unit mark (CROSSED in WINDOW 58 - see the CE58 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 275,000, margin 192,287. -/
theorem frontierPast275k : (tCE99 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 300 000-unit mark (CROSSED in WINDOW 64 - see the CE64 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 300,000, margin 167,287. -/
theorem frontierPast300k : (tCE99 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 325 000-unit mark (CROSSED in WINDOW 69 - see the CE69 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 325,000, margin 142,287. -/
theorem frontierPast325k : (tCE99 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 375 000-unit mark (CROSSED in WINDOW 80 - see the CE80 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 375,000, margin 92,287. -/
theorem frontierPast375k : (tCE99 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 400 000-unit mark (CROSSED in WINDOW 85 - see the CE85 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 400,000, margin 67,287. -/
theorem frontierPast400k : (tCE99 : ℝ) - WinC.tPT2 > 400000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 425 000-unit mark (CROSSED in WINDOW 90 - see the CE90 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 425,000, margin 42,287. -/
theorem frontierPast425k : (tCE99 : ℝ) - WinC.tPT2 > 425000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 430 000-unit mark (CROSSED in WINDOW 92 - see the CE92 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 430,000, margin 37,287. -/
theorem frontierPast430k : (tCE99 : ℝ) - WinC.tPT2 > 430000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 435 000-unit mark (CROSSED in WINDOW 93 - see the CE93 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 435,000, margin 32,287. -/
theorem frontierPast435k : (tCE99 : ℝ) - WinC.tPT2 > 435000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 440 000-unit mark (CROSSED in WINDOW 94 - see the CE94 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 440,000, margin 27,287. -/
theorem frontierPast440k : (tCE99 : ℝ) - WinC.tPT2 > 440000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 445 000-unit mark (CROSSED in WINDOW 95 - see the CE95 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 445,000, margin 22,287. -/
theorem frontierPast445k : (tCE99 : ℝ) - WinC.tPT2 > 445000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 450 000-unit mark (CROSSED in WINDOW 96 - see the CE96 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 450,000, margin 17,287. -/
theorem frontierPast450k : (tCE99 : ℝ) - WinC.tPT2 > 450000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 455 000-unit mark (CROSSED in WINDOW 97 - see the CE97 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 455,000, margin 12,287. -/
theorem frontierPast455k : (tCE99 : ℝ) - WinC.tPT2 > 455000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 460 000-unit mark (CROSSED in WINDOW 98 - see the CE98 module for the crossing record and margin) is carried at WINDOW-99: (tCE99 : R) - WinC.tPT2 = 467,287 > 460,000, margin 7,287. -/
theorem frontierPast460k : (tCE99 : ℝ) - WinC.tPT2 > 460000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CROSSED IN THIS WINDOW (machine, PROVEN - norm_num + linarith): the 460 000 UNIT ROUND MARK (crossed at W98 [0419]) carries 7 287; the 465 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 99 (margin 2 287 - a regular round crossing, not a predicted milestone); the next round mark 470 000 is 2 713 ahead (less than one full step - compute at that window, do not pre-announce). -/
theorem frontierPast465k : (tCE99 : ℝ) - WinC.tPT2 > 465000 := by
  have h : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379]); CARRIED into WINDOW-99 - tCE99 - tPT2 = 467,287 exceeds 350 000 with margin 117,287. Proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, through 25 face increments (CE75-CE99: 22 times 4 673 + 3 times 4 672 SNAP [w77 -> w78, w86 -> w87, w96 -> w97]; total 116,822: 350 465 + 116,822 = 467,287). -/
theorem frontierPast350k : (tCE99 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE99 : ℝ) - WinC.tPT2 = 467287 := frontierGapAboveH0
  have hshrink1 : (tCE99 : ℝ) - (tCE98 : ℝ) = 4673 := faceShrinkCE99
  have hshrink2 : (tCE98 : ℝ) - (tCE97 : ℝ) = 4673 := CE98.faceShrinkCE98
  have hshrink3 : (tCE97 : ℝ) - (tCE96 : ℝ) = 4672 := CE97.faceShrinkCE97
  have hshrink4 : (tCE96 : ℝ) - (tCE95 : ℝ) = 4673 := CE96.faceShrinkCE96
  have hshrink5 : (tCE95 : ℝ) - (tCE94 : ℝ) = 4673 := CE95.faceShrinkCE95
  have hshrink6 : (tCE94 : ℝ) - (tCE93 : ℝ) = 4673 := CE94.faceShrinkCE94
  have hshrink7 : (tCE93 : ℝ) - (tCE92 : ℝ) = 4673 := CE93.faceShrinkCE93
  have hshrink8 : (tCE92 : ℝ) - (tCE91 : ℝ) = 4673 := CE92.faceShrinkCE92
  have hshrink9 : (tCE91 : ℝ) - (tCE90 : ℝ) = 4673 := CE91.faceShrinkCE91
  have hshrink10 : (tCE90 : ℝ) - (tCE89 : ℝ) = 4673 := CE90.faceShrinkCE90
  have hshrink11 : (tCE89 : ℝ) - (tCE88 : ℝ) = 4673 := CE89.faceShrinkCE89
  have hshrink12 : (tCE88 : ℝ) - (tCE87 : ℝ) = 4673 := CE88.faceShrinkCE88
  have hshrink13 : (tCE87 : ℝ) - (tCE86 : ℝ) = 4672 := CE87.faceShrinkCE87
  have hshrink14 : (tCE86 : ℝ) - (tCE85 : ℝ) = 4673 := CE86.faceShrinkCE86
  have hshrink15 : (tCE85 : ℝ) - (tCE84 : ℝ) = 4673 := CE85.faceShrinkCE85
  have hshrink16 : (tCE84 : ℝ) - (tCE83 : ℝ) = 4673 := CE84.faceShrinkCE84
  have hshrink17 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := CE83.faceShrinkCE83
  have hshrink18 : (tCE82 : ℝ) - (tCE81 : ℝ) = 4673 := CE82.faceShrinkCE82
  have hshrink19 : (tCE81 : ℝ) - (tCE80 : ℝ) = 4673 := CE81.faceShrinkCE81
  have hshrink20 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := CE80.faceShrinkCE80
  have hshrink21 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink22 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink23 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink24 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink25 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6, hshrink7, hshrink8, hshrink9, hshrink10, hshrink11, hshrink12, hshrink13, hshrink14, hshrink15, hshrink16, hshrink17, hshrink18, hshrink19, hshrink20, hshrink21, hshrink22, hshrink23, hshrink24, hshrink25]
  linarith [h]

/-- ORDERING (machine, norm_num): (gB98Lo : R) < (gB99Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB98Lo the STANDARD lower bound on the window-98 endpoint g_b98 and gB99Lo = 300017580008718 / 100 the STANDARD lower bound on the window-99 endpoint g_b99 (the -86 dyadic family; the exact dyadic tuple is authoritative over the exponent representation). -/
theorem gB98Lo_lt_gB99Lo : (gB98Lo : ℝ) < (gB99Lo : ℝ) := by
  norm_num [CE98.gB98Lo, gB99Lo]




/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 95 FULL slice (re-cited in the W97 band - window 95 of 97, the full recorded window (gB94, g_b95], NON-SNAPPED 20 000 (b = a + 20 000 = 12 363 155 357 112), NOT CLEAN: TWO recorded interior Rosser failure blocks, BOTH DETERMINED TRUE and rescued - block [12 363 155 349 037, 12 363 155 349 039] (need 2 / changes 0 at 129 points, m = 64; rescue union [12 363 155 349 035, 12 363 155 349 040] at m = 8 found all 5 required sign changes) and block [12 363 155 351 222, 12 363 155 351 224] (need 2 / changes 0 at 129 points, m = 64; rescue union [12 363 155 351 221, 12 363 155 351 225] at m = 4 found all 4 required sign changes) - no clean record this window; the clean stretch remains W80, W87, W89, W91, W92, W94): the zeros of zeta with gB94 ('3 000 175 776 723.20591181977219678146667781197600970604257609997374238201018608411508280242596669040722190402448177337646484375', = window 94's endpoint g_b94, the W95 seam g_a95 bit-identical, + or - 1.29e-26) < Im s <= gB95 ('3 000 175 781 396.14102137177211874610539741272063543570118673310916061506304624377484101260815663181347190402448177337646484375', the W95 endpoint, the W96 seam g_a96 bit-identical, + or - 1.29e-26) are all simple and on the line. Provenance: window95_b95.json (Murphy pipeline; NON-SNAPPED 20 000; M = 60, C_R = 1, 32 workers, 34 087 evals in 2 613.8 s, thirtieth overlap run, resumed_from_cache = 972 338); verifier CERTIFIED (points 34 087, sign_changes_inside = 20 000, roser_failures_inside = 2, turing_ok, K_conservative = 12, end runs 44/43, 0 cross-check failures, 0 undetermined Gram signs, max phase 4.10e-21 radius 2.61e-24) + an independent raw-record recompute (separate code path, exact dyadic arithmetic: reproduced 15 867 blocks inside, changes = 20 000 = b - a, the two recorded interior failures, runs 44/43, all points strictly increasing) + a sampled cross-check of 414 Gram-point signs against direct dps-60 Riemann-Siegel evaluations from a different engine (0 mismatches). SEAM: its g_a ball is the CE94 g_b ball EXACTLY (bit-identical tuple). Window-95 data per 0410 (unit 124); the W96 band re-cites it in full so that the W96 terminal slice starts at gB95; no RH CLAIM about window 95. -/
def ce95WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB94Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB95Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 96 FULL slice (re-cited in the W98 band - window 96 of 98, the full recorded window (gB95Lo, gB96Lo]; W96 record: NON-SNAPPED 20 000, CLEAN - zero recorded interior Rosser failure blocks): the zeros of zeta with
(gB95Lo : R) < Im s <= (gB96Lo : R) are all simple and on the line. Provenance: window96_b96.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE96 module (seam/audit record,
carried). Slice restriction (gB95Lo, gB96Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 96. -/
def ce96WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB95Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB96Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 97 FULL slice (re-cited in the W99 band - window 97 of 99, the full recorded window (gB96Lo, gB97Lo]; W97 record: SNAPPED 19 997, THREE recorded interior Rosser failure blocks (all determined and rescued)): the zeros of zeta with
(gB96Lo : R) < Im s <= (gB97Lo : R) are all simple and on the line. Provenance: window97_b97.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE97 module (seam/audit record,
carried). Slice restriction (gB96Lo, gB97Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 97. -/
def ce97WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB96Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB97Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 98 FULL slice (re-cited in the W99 band - window 98 of 99, the full recorded window (gB97Lo, gB98Lo]; W98 record: NON-SNAPPED 20 000, THREE recorded interior Rosser failure blocks (determined via the coarse rescue probe; independently adjudicated over-predictions - zero fresh zeros in the flagged unions)): the zeros of zeta with
(gB97Lo : R) < Im s <= (gB98Lo : R) are all simple and on the line. Provenance: window98_b98.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE98 module (seam/audit record,
carried). Slice restriction (gB97Lo, gB98Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 98. -/
def ce98WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB97Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB98Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 99 TERMINAL slice (window 99 of 99, the (gB98Lo, g_b99] portion of the recorded window,
up to floor(gB99) - NON-SNAPPED 20 000, CLEAN (b = 12 363 155 437 109; zero recorded interior Rosser failure blocks (CLEAN) - see the module header):
the zeros of zeta with
(gB98Lo : R) < Im s <= int(gB99) = 3,000,175,800,087 (the FLOOR - the endpoint g_b99 sits
0.180516606992693104903701... (exact, exponent -86 dyadic terminator) above it, exact, robust to the certified radius ~4.7e-14) are all simple and on the
line. Certificates: window99_b99.json (window 99; certified 2026-11-16) + the pipeline verifier
(CERTIFIED, turing_ok, points 33 387, sign_changes_inside = 20,000 = b - a,
rosser_failures_inside = 0end Rosser runs 49 / 46,
K_conservative = 12) + the module header (M = 60, C_R = 1, the bit-identical g_a99 == g_b98
SEAM AUDIT). Slice restriction (gB98Lo, int(gB99)] is a SUBSET of the certified window, so
its zeros inherit on-linedness; no RH CLAIM about the face above g_b99. -/
def ce99WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB98Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE99 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h100
(window 99 contributes ONE clause for its (gB98Lo, tCE99] slice - h100; W99 NON-SNAPPED 20 000, CLEAN
certified b = 12 363 155 437 109, zero recorded interior Rosser failure blocks (CLEAN); window 98 re-cited in full at gB97 - h99), ALL zeros of zeta with Im s >
WinC.tPT2 and Im s <= (tCE99 : R) lie on the line: h1-h2 cover window 1 (CE2, the
Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the
W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..99 enter as their certified (gB-prev,
gB] slices (bit-identical at every seam; the re-cited full-slice clause carries the full
recorded window). CUMULATIVE tally through window 99: 99 windows - 43 clean,
56 rescue; 86 total internal Rosser failures, ALL RECORDED. NO RH CLAIM
about Im s > tCE99. -/
theorem bandOfWindows99 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : CE80.ce79WinClauseFull) (h81 : CE81.ce80WinClauseFull) (h82 : CE82.ce81WinClauseFull) (h83 : CE83.ce82WinClauseFull) (h84 : CE84.ce83WinClauseFull) (h85 : CE85.ce84WinClauseFull) (h86 : CE86.ce85WinClauseFull) (h87 : CE87.ce86WinClauseFull) (h88 : CE88.ce87WinClauseFull) (h89 : CE89.ce88WinClauseFull) (h90 : CE90.ce89WinClauseFull) (h91 : CE91.ce90WinClauseFull) (h92 : CE92.ce91WinClauseFull) (h93 : CE93.ce92WinClauseFull) (h94 : CE94.ce93WinClauseFull) (h95 : CE95.ce94WinClauseFull) (h96 : ce95WinClauseFull) (h97 : ce96WinClauseFull) (h98 : ce97WinClauseFull) (h99 : ce98WinClauseFull) (h100 : ce99WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE99 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                                                      · by_cases hseam92 : ρ.im ≤ (gB91Lo : ℝ)
                                                                                                                                                                                        · exact h92 ρ hz (not_le.mp hseam91) hseam92
                                                                                                                                                                                        · by_cases hseam93 : ρ.im ≤ (gB92Lo : ℝ)
                                                                                                                                                                                          · exact h93 ρ hz (not_le.mp hseam92) hseam93
                                                                                                                                                                                          · by_cases hseam94 : ρ.im ≤ (gB93Lo : ℝ)
                                                                                                                                                                                            · exact h94 ρ hz (not_le.mp hseam93) hseam94
                                                                                                                                                                                            · by_cases hseam95 : ρ.im ≤ (gB94Lo : ℝ)
                                                                                                                                                                                              · exact h95 ρ hz (not_le.mp hseam94) hseam95
                                                                                                                                                                                              · by_cases hseam96 : ρ.im ≤ (gB95Lo : ℝ)
                                                                                                                                                                                                · exact h96 ρ hz (not_le.mp hseam95) hseam96
                                                                                                                                                                                                · by_cases hseam97 : ρ.im ≤ (gB96Lo : ℝ)
                                                                                                                                                                                                  · exact h97 ρ hz (not_le.mp hseam96) hseam97
                                                                                                                                                                                                  · by_cases hseam98 : ρ.im ≤ (gB97Lo : ℝ)
                                                                                                                                                                                                    · exact h98 ρ hz (not_le.mp hseam97) hseam98
                                                                                                                                                                                                    · by_cases hseam99 : ρ.im ≤ (gB98Lo : ℝ)
                                                                                                                                                                                                      · exact h99 ρ hz (not_le.mp hseam98) hseam99
                                                                                                                                                                                                      · exact h100 ρ hz (not_le.mp hseam99) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 99-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE99 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..h100 : the 100 verified window-slice clauses - the cited slices + the RE-CITED full slices for the re-anchored windows 43..98 (bit-identical seams, recorded data, incl. the recorded Rosser failure blocks of the re-anchored windows - all determined and rescued) + h100 : the window-99 terminal slice (NON-SNAPPED 20 000, CLEAN - zero failures)). This is the finite-height closure through the corrected w1-w99 band (W42b fill) re-anchored to all of the certified NINETY-NINTH window (NON-SNAPPED 20 000, CLEAN); census 1 999 979 over (g_a1, g_b99] - the 1 980 000 CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW (margin 19 979); the 1 960 000 CERTIFIED-ZERO MARK (CROSSED in W98 [0419]) carries margin 39 979; the 1 940 000 CERTIFIED-ZERO MARK (CROSSED in W97 [0418]) carries margin 59 979; the 1 920 000 CERTIFIED-ZERO MARK (CROSSED in W96) carries margin 79 979; the 1 900 000 CERTIFIED-ZERO MARK (CROSSED in W95 [0410]) carries margin 99 979; the 1 880 000 CERTIFIED-ZERO MARK (CROSSED in W93) carries margin 119 979; the 1 860 000 CERTIFIED-ZERO MARK (CROSSED in W92 [0403]) carries margin 139 979; the 1 840 000 CERTIFIED-ZERO MARK (CROSSED in W91 [0402]) carries margin 159 979; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 199 979; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 299 979; the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 399 979; 2 000 000 is 21 ahead (less than one zero-span - the tail window W100 will land it, do not pre-announce). NO RH CLAIM about the face above tCE99. -/
theorem allOnLineUpToCE99 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE99 : ℝ) := by
  have hband := bandOfWindows99 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE NINETY-NINTH RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the NINETY-NINTH certified window (NON-SNAPPED 20 000, CLEAN, b = 12 363 155 437 109, zero recorded interior Rosser failure blocks (CLEAN); census 1 999 979 over (g_a1, g_b99]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE99 : R) = 3,000,175,800,087 lies on the line - i.e. the absolute clause [S1] and A1 (no data-dependent bound on the S-at-zeros and DN walk) above the new lower bound. Frontier 467,287 above H0: the 465 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW, WINDOW 99 (margin 2 287 - a regular round crossing, not a predicted milestone); the 460 000 mark (crossed W98 [0419]) carries 7 287; the 455 000 mark (crossed W97 [0418]) carries 12 287; the 450 000 mark (crossed W96) carries 17 287; the 445 000 mark (crossed W95 [0410]) carries 22 287; the 440 000 mark (crossed W94 [0406]) carries 27 287; the 435 000 mark (crossed W93 [0405]) carries 32 287; the 430 000 mark (crossed W92 [0403]) carries 37 287; the 425 000 mark (crossed W90 [0401], the FOURTH PREDICTION of the series) carries 42 287; the 400 000 mark (crossed W85 [0396], third prediction) carries 67 287; the 375 000 mark (crossed W80, second prediction) carries 92 287; the 350 000 mark (crossed W74, first prediction) carries 117 287; the 325 000 mark (crossed W69) carries 142 287; the 300 000 mark (crossed W64) carries 167 287; the next round mark 470 000 is 2 713 ahead (less than one full 4 673 step); the 1 980 000 CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW (margin 19 979); the 1 960 000 CERTIFIED-ZERO MARK (CROSSED in W98 [0419]) carries margin 39 979; the 1 940 000 CERTIFIED-ZERO MARK (CROSSED in W97 [0418]) carries margin 59 979; the 1 920 000 CERTIFIED-ZERO MARK (CROSSED in W96) carries margin 79 979; the 1 900 000 CERTIFIED-ZERO MARK (CROSSED in W95 [0410]) carries margin 99 979; the 1 880 000 CERTIFIED-ZERO MARK (CROSSED in W93) carries margin 119 979; the 1 860 000 CERTIFIED-ZERO MARK (CROSSED in W92 [0403]) carries margin 139 979; the 1 840 000 CERTIFIED-ZERO MARK (CROSSED in W91 [0402]) carries margin 159 979; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 199 979; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 299 979; the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 399 979; 2 000 000 is 21 ahead (less than one zero-span - the tail window W100 will land it, do not pre-announce). The increment tCE99 - tCE98 = 4673 (the usual increment - W99 ran NON-SNAPPED 20 000 CLEAN, certified b = 12 363 155 437 109 - no pattern claim beyond the recorded data). The face is RE-ANCHORED (the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE99 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE99 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE89 -> ... -> tCE98 -> tCE99) leaves the face IMPLICATOR - anything true above tCE98 is true above tCE99. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE98_implies_faceCE99 (q : ZeroSet)
    (hface : CE98.terminalFaceCE98 q) :
    terminalFaceCE99 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE98_lt_tCE99, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW99, hW100): terminalFaceCE99 q <-> terminalFaceCE98 q. The re-anchor adds no strength and loses none - what was open at tCE98 is (exactly) what is open at tCE99, and the slice family (gB98Lo, tCE99] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE98 pattern). The forward direction splits on 'Im s <= tCE96': the band slice (gB98Lo, tCE99] is handled by the verified window slices hW99, hW100 (the W98 slice is NON-SNAPPED 20 000 with three recorded interior Rosser failures (determined in the pipeline record; the independent union-span adjudication reads the flagged unions as over-predictions - zero fresh zeros; the certificate rests on the sign-change total), re-cited in full at gB98; the W99 slice is NON-SNAPPED 20 000, CLEAN - zero failures), the part above tCE98 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE99_iff_faceCE98 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW99 : ce98WinClauseFull) (hW100 : ce99WinClause) :
    terminalFaceCE99 q ↔ CE98.terminalFaceCE98 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE99 : ℝ)
    · by_cases hseam99 : ρ.im ≤ (gB98Lo : ℝ)
      · exact hW99 ρ (hqz ρ hρ) (by linarith [ht, CE98.gB97Lo_lt_tCE98, tCE98_lt_tCE99]) hseam99
      · exact hW100 ρ (hqz ρ hρ) (not_le.mp hseam99) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE98_implies_faceCE99 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE99) x (terminalFaceCE99 q) - finite-height closure (now through the corrected w1-w96 band with the W42b fill, re-anchored windows 43..99 all bit-identical at their seams; window 99 certified NON-SNAPPED at 20 000, CLEAN - zero recorded interior failures) AND the absolute clause above tCE99. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE99 - tPT2 = 467 287 - the 465 000 UNIT ROUND MARK was CROSSED IN THIS WINDOW [margin 2 287]; census 1 999 979 - the 1 980 000 CERTIFIED-ZERO MARK CROSSED IN THIS WINDOW (margin 19 979); 2 000 000 is 21 ahead (less than one zero-span - the tail window W100 will land it, do not pre-announce)). -/
theorem rh_split_at_CE99 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE99 : ℝ) ∧ terminalFaceCE99 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE99 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE99 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE96): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW97 : the 100 verified window-slice clauses - windows 1..99, incl. the re-anchored 43..99 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each - all ultimately determined; W78: SNAPPED 19 999, one recorded failure; W82: SNAPPED 19 999, two recorded failures - both determined; W83: NON-SNAPPED 20 000, three recorded blocks - all determined; W84: NON-SNAPPED 20 000, one recorded block - determined; W85: NON-SNAPPED 20 000, one recorded block - determined; W86: NON-SNAPPED 20 000, two recorded blocks - both determined; W87: SNAPPED 19 999, CLEAN - zero failures; W88: NON-SNAPPED 20 000, one recorded interior block - determined; W89: NON-SNAPPED 20 000, CLEAN - zero failures; W90: NON-SNAPPED 20 000, two recorded interior blocks - both determined; W91: NON-SNAPPED 20 000, CLEAN - zero failures; W92: NON-SNAPPED 20 000, CLEAN - zero failures; W93: SNAPPED 19 999, one recorded interior block - determined and rescued; W94: NON-SNAPPED 20 000, CLEAN - zero failures; W95: NON-SNAPPED 20 000, two recorded interior blocks - both determined and rescued; W96: NON-SNAPPED 20 000, CLEAN - zero failures; W97: SNAPPED 19 997, THREE recorded interior failures - all determined and rescued; W98: NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined via the coarse rescue probe; independent adjudication: over-predictions - zero fresh zeros in the flagged unions); W99: NON-SNAPPED 20 000, CLEAN - zero failures)), RH is equivalent to the NAMED terminal face above tCE99 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w99 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..99, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE99 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE99 q := by
  have hcensus := allOnLineUpToCE99 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hqz
  have hsplit := rh_split_at_CE99 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE99 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE99 q) :
    RH q :=
  (rh_reanchored_CE99 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE99_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE99 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE99