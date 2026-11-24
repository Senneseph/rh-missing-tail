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
import RhAttack.CE99
import RhAttack.CE100
import RhAttack.CE101
import RhAttack.CE102
import RhAttack.CE103
import RhAttack.CE104
import RhAttack.CE105
import RhAttack.CE106
import RhAttack.CE107
import RhAttack.CE108
import RhAttack.CE109
import RhAttack.CE110
import RhAttack.CE111
import RhAttack.CE112
import RhAttack.CE113
import RhAttack.CE114
import RhAttack.CE115
import RhAttack.CE116
import RhAttack.CE117
import RhAttack.CE118
import RhAttack.CE119
import RhAttack.CE120
import RhAttack.CE121
import RhAttack.CE122
import RhAttack.CE123
import RhAttack.CE124
import RhAttack.CE125
import RhAttack.CE126
import RhAttack.CE127
import RhAttack.CE128
import RhAttack.CE129
import RhAttack.CE130
import RhAttack.CE131
import RhAttack.CE132
import RhAttack.CE133
import RhAttack.CE134
import RhAttack.CE135
import RhAttack.CE136
import RhAttack.CE137
import RhAttack.CE138
import RhAttack.CE139
import RhAttack.CE140
import RhAttack.CE141
import RhAttack.CE142

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82 CE83 CE84 CE85 CE86 CE87 CE88 CE89 CE90 CE91 CE92 CE93 CE94 CE95 CE96 CE97 CE98 CE99 CE100 CE101 CE102 CE103 CE104 CE105 CE106 CE107 CE108 CE109 CE110 CE111 CE112 CE113 CE114 CE115 CE116 CE117 CE118 CE119 CE120 CE121 CE122 CE123 CE124 CE125 CE126 CE127 CE128 CE129 CE130 CE131 CE132 CE133 CE134 CE135 CE136 CE137 CE138 CE139 CE140 CE141 CE142
open scoped Topology

/-!
**CE143 - the terminal face re-anchored at the ONE-HUNDRED-FORTY-THIRD certified window
(0464, option B - lane M5).

MILESTONE STATE: tCE143 - tPT2 = 668,226 - no unit round mark crossed in this window; the 660 000 mark (W142 [0477]) carries 8 226; the 655 000 mark (W141 [0475]) carries 13 226; the 650 000 mark (W140 [0474]) carries 18 226; the 500 000 milestone (W107 [0440]) carries 168 226; the next round mark 665 000 is 3 226 ahead (expected at W144, entry 0479).
CERTIFIED-ZERO CENSUS: cumulative total 2 859 992 over (g_a1, g_b143] -
the 2 840 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 143 (margin 19 992 - exactly the expected window of the 0477 schedule, hit); the 2 820 000 mark (W142 [0477]) carries 39 992; the 2 800 000 mark (W141 [0475]) carries 59 992; the 2 860 000 mark is 8 zeros ahead (expected at W144, entry 0479) - recorded data, no pattern claim

WINDOW 143: FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total) (a = 12 363 156 277 122 = b142 (the bit-identical seam), b = 12 363 156 297 122; certified width
20,000). zero recorded interior Rosser failure blocks (machine-derived per-window counts W101-W143: 1,0,0,1,1,1,1,3,1,0,0,3,1,1,0,2,1,0,0,2,2,2,1,2,1,1,2,1,1,2,1,0,1,0,2,0,2,1,2,1,3,1,0 - canonical per 0471) - the NINTH CLEAN WINDOW of the post-target series. Census: the window adds 20,000 certified zeros
(2 839 992 + 20,000 = 2 859 992). Cumulative tally through window 143: 143
windows - 56 clean, 97 rescue; 133 total internal Rosser
failures, ALL RECORDED. End Rosser runs: 49 / 47 left of g_a143 / right of g_b143 (both >= K = 12); 0
cross-check failures; 0 undetermined Gram signs; max phase contribution 4.04e-21 (radius 2.10e-25).

PIPELINE RUN (one hundred forty-third in the overlap pipeline): an autonomous-lane window (launched by the lane supervisor; fresh run, no cache) 8 workers: 33 066
evaluations in 3249.7 s (same M = 60, C_R = 1, N_range = [691 008, 691 008], same pipeline, same
verifier, same seam discipline).

PROVENANCE (our run, 2026-11-16; pipeline = Murphy's Apache-2.0 deposit, same as CE1-CE142): RUN
PARAMETERS: a = 12 363 156 277 122 (= b142), b = 12 363 156 297 122 (FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total)), M = 60, C_R = 1, 8 workers, 33 066
evaluations, 3249.7 s, resumed_from_cache = 0. CERTIFICATE (window143_b143.json): the
20,000 (= b - a) zeros of zeta with g_a143 < Im s <= g_b143 are ALL SIMPLE and on the line,
where g_a143 (recorded exact dyadic ball) is [116063687212153033958716287458310299299, -85, 16777217, -110] (the W142 endpoint g_b142, the W143 seam g_a143
BIT-IDENTICAL - exact dyadic tuple comparison, audited BEFORE this module was written, per the 0348
process rule), and g_b143 has exact dyadic tuple [232127374785856909001758933108470717935, -86, 16777217, -110] (the -86 dyadic family). The floor
tCE143 = 3,000,176,001,026 sits 0.0073325676526547340924 (exact, exponent -86 dyadic arithmetic, center-minus-radius) below the certified lower bound (EXACT dyadic arithmetic,
center-minus-radius reading; robust to the certified radius ~4.7e-14 by many orders of magnitude); the
standard two-decimal lower bound gB143Lo (300017600102642 / 100 = 3000176001026.42) has the exact margin
0.0073325676526547340924 (exact, exponent -86 dyadic arithmetic, center-minus-radius); the two-decimal round-down (0.42) is strictly below the exact fractional part
(0.4273325676526547340924724 (exact, exponent -86 dyadic terminator)), so no CASING is needed - window 38 / CE38 remains the only CASING case so far. (The
gB143Lo margin 7.33e-3 is the SIXTY-FOURTH sub-cent case in the current run:
W79 (1.76e-4), W81 (4.03e-4), W82 (1.87e-3), W83 (6.98e-3), W84 (2.09e-3), W85 (7.2e-3), W86 (2.3e-3), W87 (3.8e-3), W88 (8.9e-3), W89 (4.0e-3), W90 (9.1e-3), W91 (4.2e-3), W92 (9.3e-3), W93 (8.0e-4), W94 (5.9e-3), W95 (1.0e-3), W96 (6.1e-3), W97 (2.99e-4), W98 (5.41e-3), W99 (5.17e-4), W100 (7.10e-3), W101 (2.21e-3), W102 (3.67e-3), W103 (7.84e-3), W104 (2.94e-3), W105 (8.05e-3), W106 (3.16e-3), W107 (4.62e-3), W108 (9.72e-3), W109 (4.83e-3), W110 (6.29e-3), W111 (1.39e-3), W112 (6.50e-3), W113 (7.96e-3), W114 (3.06e-3), W115 (8.17e-3), W116 (3.27e-3), W117 (8.37e-3), W118 (3.48e-3), W119 (8.58e-3), W120 (3.68e-3), W121 (8.79e-3), W122 (3.89e-3), W123 (9.0e-3), W124 (4.09e-3), W125 (9.19e-3), W126 (6.50e-4), W127 (5.75e-3), W128 (8.52e-4), W129 (5.95e-3), W130 (1.05e-3), W131 (6.15e-3), W132 (1.25e-3), W133 (6.35e-3), W134 (1.45e-3), W135 (6.55e-3), W136 (1.65e-3), W137 (6.75e-3), W138 (1.85e-3), W139 (6.94e-3), W140 (2.04e-3), W141 (7.14e-3), W142 (2.24e-3), W143 (7.33e-3); not a precision danger - the certified radius is ~4.7e-14, four orders of
magnitude smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE142): (1) ENVIRONMENT REPEAT (Murphy's window-1 certificate
re-verified - see CE2 header); (2) PIPELINE VERIFIER on window143_b143.json: "CERTIFIED: true",
points_checked = 33 066, sign_changes_inside = 20,000 (= b - a),
rosser_failures_inside = 0 (ALL DETERMINED and rescued - see the W143 record above),
turing_ok = true, K_conservative = 12, end Rosser runs 49 / 47; (3) SEAM AUDIT (this run): the
recorded g_a143 ball is bit-identical to CE142's recorded g_b142 ball (exact dyadic decode,
2026-11-16). The window is CLEAN - zero recorded interior Rosser failure blocks. Certificate by sign-change total b - a = 20 000 = sign_changes_inside, verified independently (CERTIFIED, turing_ok). PHASE NOTE: the certificate phase reads 4.04e-21 (radius 2.10e-25) - the first deviation from the long-running 4.10e-21 (radius 2.61e-24) plateau; recorded data, no pattern claim.
FRONTIER ARITHMETIC (machine, below): tCE143 = 3,000,176,001,026, tCE143 - tCE142 = 4673,
tCE143 - tPT2 = 668,226.
HONESTY (trust base): as CE2-CE142 - the pipeline's own controls, its kernel-checked Lean remainder
theorem, and our verification layers; a RE-RUN of a third-party pipeline, not a from-scratch independent
certification. Cumulative certified count = 2 859 992 over (g_a1, g_b143] (pipeline data, not
in-tree arithmetic). NO RH CLAIM.
-/
namespace CE143


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b143 (machine): gB143Lo = 300017600102642 / 100 = 3000176001026.42 - the two-decimal round-down of the certified lower bound (the endpoint g_b143 minus the certified radius ~4.7e-14). The margin is the exact 0.0073325676526547340924 (exact, exponent -86 dyadic arithmetic, center-minus-radius); the two-decimal round-down (0.42) is strictly below the exact fractional part (0.4273325676526547340924724 (exact, exponent -86 dyadic terminator)), so no CASING is needed (window 38 / CE38 remains the only CASING case). The 7.33e-3 margin is the SIXTY-FOURTH sub-cent case in the current run - not a precision danger (certified radius ~4.7e-14). -/
def gB143Lo : ℚ := 300017600102642 / 100

/-- THE NEW LOWER BOUND (machine): 3,000,176,001,026 = floor(g_b143). The endpoint sits 0.4273325676526547340924724 (exact, exponent -86 dyadic terminator) above the integer boundary (exact, exponent -86 dyadic terminator) and the certified radius is ~4.7e-14, so the floor is robust by many orders of magnitude. tCE143 - tCE142 = 4673 (the STANDARD 4 673 floor increment (eighth consecutive standard step after W135's sub-standard 4 672; recorded data, no pattern claim)). -/
def tCE143 : ℕ := 3000176001026

theorem tCE143_lt_gB143Lo : (tCE143 : ℝ) < (gB143Lo : ℝ) := by
  norm_num [gB143Lo, tCE143]

theorem tCE142_lt_tCE143 : (tCE142 : ℝ) < (tCE143 : ℝ) := by
  norm_num [CE142.tCE142, tCE143]

/-- ORDERING (machine, norm_num): (gB142Lo : R) < (tCE143 : R), with gB142Lo the STANDARD lower bound introduced at CE142 and tCE143 = 3,000,176,001,026. So the window-143 terminal slice starts strictly below the new floor. -/
theorem gB142Lo_lt_tCE143 : (gB142Lo : ℝ) < (tCE143 : ℝ) := by
  norm_num [CE142.gB142Lo, tCE143]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE143 - tCE142 = 4673. W143: FULL-width 20 000, CLEAN - zero recorded interior failures (certificate by sign-change total). The floor advances by the STANDARD 4 673; the endpoint record REVISITS the -86 dyadic family (the most frequent family of the series; recorded data, no pattern claim). Recorded increment series CE74 -> CE143 (69 increments): 60 x 4 673 + 8 x 4 672 + 5 (the W100 TAIL) = 317 761: 350 465 -> 668 226. -/
theorem faceShrinkCE143 : (tCE143 : ℝ) - (tCE142 : ℝ) = 4673 := by
  norm_num [tCE143, CE142.tCE142]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE143 : R) - WinC.tPT2 = 3,000,176,001,026 - 3 000 175 332 800 = 668,226 above the H0 frontier WinC.tPT2. No unit round mark crossed in this window; the 660 000 mark (w142 [0477]) carries 8 226; the 655 000 mark (w141 [0475]) carries 13 226; the 650 000 mark (w140 [0474]) carries 18 226; the 500 000 milestone (w107 [0440]) carries 168 226; the next round mark 665 000 is 3 226 ahead (expected at w144, entry 0479). CERTIFIED-ZERO CENSUS: cumulative total 2 859 992 over (g_a1, g_b143] - the 2 840 000 CERTIFIED-ZERO MARK was CROSSED IN THIS WINDOW, WINDOW 143 (margin 19 992 - exactly the expected window of the 0477 schedule, hit); the 2 820 000 mark (W142 [0477]) carries 39 992; the 2 800 000 mark (W141 [0475]) carries 59 992; the 2 860 000 mark is 8 zeros ahead (expected at W144, entry 0479) - recorded data, no pattern claim -/
theorem frontierGapAboveH0 : (tCE143 : ℝ) - WinC.tPT2 = 668226 := by
  norm_num [tCE143, WinC.tPT2]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 175 000-unit mark (CROSSED in WINDOW 38 - see the CE38 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 175,000, margin 493,226. -/
theorem frontierPast175k : (tCE143 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 200 000-unit mark (CROSSED in WINDOW 42B - see the CE42B module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 200,000, margin 468,226. -/
theorem frontierPast200k : (tCE143 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 225 000-unit mark (CROSSED in WINDOW 48 - see the CE48 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 225,000, margin 443,226. -/
theorem frontierPast225k : (tCE143 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 250 000-unit mark (CROSSED in WINDOW 53 - see the CE53 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 250,000, margin 418,226. -/
theorem frontierPast250k : (tCE143 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 275 000-unit mark (CROSSED in WINDOW 58 - see the CE58 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 275,000, margin 393,226. -/
theorem frontierPast275k : (tCE143 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 300 000-unit mark (CROSSED in WINDOW 64 - see the CE64 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 300,000, margin 368,226. -/
theorem frontierPast300k : (tCE143 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 325 000-unit mark (CROSSED in WINDOW 69 - see the CE69 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 325,000, margin 343,226. -/
theorem frontierPast325k : (tCE143 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 375 000-unit mark (CROSSED in WINDOW 80 - see the CE80 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 375,000, margin 293,226. -/
theorem frontierPast375k : (tCE143 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 400 000-unit mark (CROSSED in WINDOW 85 - see the CE85 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 400,000, margin 268,226. -/
theorem frontierPast400k : (tCE143 : ℝ) - WinC.tPT2 > 400000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 425 000-unit mark (CROSSED in WINDOW 90 - see the CE90 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 425,000, margin 243,226. -/
theorem frontierPast425k : (tCE143 : ℝ) - WinC.tPT2 > 425000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 430 000-unit mark (CROSSED in WINDOW 92 - see the CE92 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 430,000, margin 238,226. -/
theorem frontierPast430k : (tCE143 : ℝ) - WinC.tPT2 > 430000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 435 000-unit mark (CROSSED in WINDOW 93 - see the CE93 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 435,000, margin 233,226. -/
theorem frontierPast435k : (tCE143 : ℝ) - WinC.tPT2 > 435000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 440 000-unit mark (CROSSED in WINDOW 94 - see the CE94 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 440,000, margin 228,226. -/
theorem frontierPast440k : (tCE143 : ℝ) - WinC.tPT2 > 440000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 445 000-unit mark (CROSSED in WINDOW 95 - see the CE95 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 445,000, margin 223,226. -/
theorem frontierPast445k : (tCE143 : ℝ) - WinC.tPT2 > 445000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 450 000-unit mark (CROSSED in WINDOW 96 - see the CE96 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 450,000, margin 218,226. -/
theorem frontierPast450k : (tCE143 : ℝ) - WinC.tPT2 > 450000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 455 000-unit mark (CROSSED in WINDOW 97 - see the CE97 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 455,000, margin 213,226. -/
theorem frontierPast455k : (tCE143 : ℝ) - WinC.tPT2 > 455000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 460 000-unit mark (CROSSED in WINDOW 98 - see the CE98 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 460,000, margin 208,226. -/
theorem frontierPast460k : (tCE143 : ℝ) - WinC.tPT2 > 460000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 465 000-unit mark (CROSSED in WINDOW 99 - see the CE99 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 465,000, margin 203,226. -/
theorem frontierPast465k : (tCE143 : ℝ) - WinC.tPT2 > 465000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 470 000-unit mark (CROSSED in WINDOW 101 - see the CE101 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 470,000, margin 198,226. -/
theorem frontierPast470k : (tCE143 : ℝ) - WinC.tPT2 > 470000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 475 000-unit mark (CROSSED in WINDOW 102 - see the CE102 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 475,000, margin 193,226. -/
theorem frontierPast475k : (tCE143 : ℝ) - WinC.tPT2 > 475000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 480 000-unit mark (CROSSED in WINDOW 103 - see the CE103 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 480,000, margin 188,226. -/
theorem frontierPast480k : (tCE143 : ℝ) - WinC.tPT2 > 480000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 485 000-unit mark (CROSSED in WINDOW 104 - see the CE104 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 485,000, margin 183,226. -/
theorem frontierPast485k : (tCE143 : ℝ) - WinC.tPT2 > 485000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 490 000-unit mark (CROSSED in WINDOW 105 - see the CE105 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 490,000, margin 178,226. -/
theorem frontierPast490k : (tCE143 : ℝ) - WinC.tPT2 > 490000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 495 000-unit mark (CROSSED in WINDOW 106 - see the CE106 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 495,000, margin 173,226. -/
theorem frontierPast495k : (tCE143 : ℝ) - WinC.tPT2 > 495000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 500 000-unit mark (CROSSED in WINDOW 107 - see the CE107 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 500,000, margin 168,226. -/
theorem frontierPast500k : (tCE143 : ℝ) - WinC.tPT2 > 500000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 505 000-unit mark (CROSSED in WINDOW 109 - see the CE109 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 505,000, margin 163,226. -/
theorem frontierPast505k : (tCE143 : ℝ) - WinC.tPT2 > 505000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 510 000-unit mark (CROSSED in WINDOW 110 - see the CE110 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 510,000, margin 158,226. -/
theorem frontierPast510k : (tCE143 : ℝ) - WinC.tPT2 > 510000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 515 000-unit mark (CROSSED in WINDOW 111 - see the CE111 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 515,000, margin 153,226. -/
theorem frontierPast515k : (tCE143 : ℝ) - WinC.tPT2 > 515000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 520 000-unit mark (CROSSED in WINDOW 112 - see the CE112 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 520,000, margin 148,226. -/
theorem frontierPast520k : (tCE143 : ℝ) - WinC.tPT2 > 520000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 525 000-unit mark (CROSSED in WINDOW 113 - see the CE113 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 525,000, margin 143,226. -/
theorem frontierPast525k : (tCE143 : ℝ) - WinC.tPT2 > 525000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 530 000-unit mark (CROSSED in WINDOW 114 - see the CE114 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 530,000, margin 138,226. -/
theorem frontierPast530k : (tCE143 : ℝ) - WinC.tPT2 > 530000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 535 000-unit mark (CROSSED in WINDOW 115 - see the CE115 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 535,000, margin 133,226. -/
theorem frontierPast535k : (tCE143 : ℝ) - WinC.tPT2 > 535000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 540 000-unit mark (CROSSED in WINDOW 116 - see the CE116 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 540,000, margin 128,226. -/
theorem frontierPast540k : (tCE143 : ℝ) - WinC.tPT2 > 540000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 545 000-unit mark (CROSSED in WINDOW 117 - see the CE117 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 545,000, margin 123,226. -/
theorem frontierPast545k : (tCE143 : ℝ) - WinC.tPT2 > 545000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 550 000-unit mark (CROSSED in WINDOW 118 - see the CE118 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 550,000, margin 118,226. -/
theorem frontierPast550k : (tCE143 : ℝ) - WinC.tPT2 > 550000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 555 000-unit mark (CROSSED in WINDOW 119 - see the CE119 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 555,000, margin 113,226. -/
theorem frontierPast555k : (tCE143 : ℝ) - WinC.tPT2 > 555000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 560 000-unit mark (CROSSED in WINDOW 120 - see the CE120 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 560,000, margin 108,226. -/
theorem frontierPast560k : (tCE143 : ℝ) - WinC.tPT2 > 560000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 565 000-unit mark (CROSSED in WINDOW 121 - see the CE121 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 565,000, margin 103,226. -/
theorem frontierPast565k : (tCE143 : ℝ) - WinC.tPT2 > 565000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 570 000-unit mark (CROSSED in WINDOW 122 - see the CE122 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 570,000, margin 98,226. -/
theorem frontierPast570k : (tCE143 : ℝ) - WinC.tPT2 > 570000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 575 000-unit mark (CROSSED in WINDOW 124 - see the CE124 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 575,000, margin 93,226. -/
theorem frontierPast575k : (tCE143 : ℝ) - WinC.tPT2 > 575000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 580 000-unit mark (CROSSED in WINDOW 125 - see the CE125 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 580,000, margin 88,226. -/
theorem frontierPast580k : (tCE143 : ℝ) - WinC.tPT2 > 580000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 585 000-unit mark (CROSSED in WINDOW 126 - see the CE126 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 585,000, margin 83,226. -/
theorem frontierPast585k : (tCE143 : ℝ) - WinC.tPT2 > 585000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 590 000-unit mark (CROSSED in WINDOW 127 - see the CE127 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 590,000, margin 78,226. -/
theorem frontierPast590k : (tCE143 : ℝ) - WinC.tPT2 > 590000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 595 000-unit mark (CROSSED in WINDOW 128 - see the CE128 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 595,000, margin 73,226. -/
theorem frontierPast595k : (tCE143 : ℝ) - WinC.tPT2 > 595000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 600 000-unit mark (CROSSED in WINDOW 129 - see the CE129 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 600,000, margin 68,226. -/
theorem frontierPast600k : (tCE143 : ℝ) - WinC.tPT2 > 600000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 605 000-unit mark (CROSSED in WINDOW 130 - see the CE130 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 605,000, margin 63,226. -/
theorem frontierPast605k : (tCE143 : ℝ) - WinC.tPT2 > 605000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 610 000-unit mark (CROSSED in WINDOW 131 - see the CE131 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 610,000, margin 58,226. -/
theorem frontierPast610k : (tCE143 : ℝ) - WinC.tPT2 > 610000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 615 000-unit mark (CROSSED in WINDOW 132 - see the CE132 module for the crossing record and margin) is carried at WINDOW-143: (tCE143 : R) - WinC.tPT2 = 668,226 > 615,000, margin 53,226. -/
theorem frontierPast615k : (tCE143 : ℝ) - WinC.tPT2 > 615000 := by
  have h : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379]); CARRIED into WINDOW-143 - tCE143 - tPT2 = 668,226 exceeds 350 000 with margin 318,226. Proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, through 69 face increments (CE75-CE143: 60 times 4 673 + 8 times 4 672 SNAP [w77 -> w78, w86 -> w87, w96 -> w97, w101 -> w102, w102 -> w103, w110 -> w111, w122 -> w123, w134 -> w135]; total 317,761: 350 465 + 317,761 = 668,226). -/
theorem frontierPast350k : (tCE143 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE143 : ℝ) - WinC.tPT2 = 668226 := frontierGapAboveH0
  have hshrink1 : (tCE143 : ℝ) - (tCE142 : ℝ) = 4673 := faceShrinkCE143
  have hshrink2 : (tCE142 : ℝ) - (tCE141 : ℝ) = 4673 := CE142.faceShrinkCE142
  have hshrink3 : (tCE141 : ℝ) - (tCE140 : ℝ) = 4673 := CE141.faceShrinkCE141
  have hshrink4 : (tCE140 : ℝ) - (tCE139 : ℝ) = 4673 := CE140.faceShrinkCE140
  have hshrink5 : (tCE139 : ℝ) - (tCE138 : ℝ) = 4673 := CE139.faceShrinkCE139
  have hshrink6 : (tCE138 : ℝ) - (tCE137 : ℝ) = 4673 := CE138.faceShrinkCE138
  have hshrink7 : (tCE137 : ℝ) - (tCE136 : ℝ) = 4673 := CE137.faceShrinkCE137
  have hshrink8 : (tCE136 : ℝ) - (tCE135 : ℝ) = 4673 := CE136.faceShrinkCE136
  have hshrink9 : (tCE135 : ℝ) - (tCE134 : ℝ) = 4672 := CE135.faceShrinkCE135
  have hshrink10 : (tCE134 : ℝ) - (tCE133 : ℝ) = 4673 := CE134.faceShrinkCE134
  have hshrink11 : (tCE133 : ℝ) - (tCE132 : ℝ) = 4673 := CE133.faceShrinkCE133
  have hshrink12 : (tCE132 : ℝ) - (tCE131 : ℝ) = 4673 := CE132.faceShrinkCE132
  have hshrink13 : (tCE131 : ℝ) - (tCE130 : ℝ) = 4673 := CE131.faceShrinkCE131
  have hshrink14 : (tCE130 : ℝ) - (tCE129 : ℝ) = 4673 := CE130.faceShrinkCE130
  have hshrink15 : (tCE129 : ℝ) - (tCE128 : ℝ) = 4673 := CE129.faceShrinkCE129
  have hshrink16 : (tCE128 : ℝ) - (tCE127 : ℝ) = 4673 := CE128.faceShrinkCE128
  have hshrink17 : (tCE127 : ℝ) - (tCE126 : ℝ) = 4673 := CE127.faceShrinkCE127
  have hshrink18 : (tCE126 : ℝ) - (tCE125 : ℝ) = 4673 := CE126.faceShrinkCE126
  have hshrink19 : (tCE125 : ℝ) - (tCE124 : ℝ) = 4673 := CE125.faceShrinkCE125
  have hshrink20 : (tCE124 : ℝ) - (tCE123 : ℝ) = 4673 := CE124.faceShrinkCE124
  have hshrink21 : (tCE123 : ℝ) - (tCE122 : ℝ) = 4672 := CE123.faceShrinkCE123
  have hshrink22 : (tCE122 : ℝ) - (tCE121 : ℝ) = 4673 := CE122.faceShrinkCE122
  have hshrink23 : (tCE121 : ℝ) - (tCE120 : ℝ) = 4673 := CE121.faceShrinkCE121
  have hshrink24 : (tCE120 : ℝ) - (tCE119 : ℝ) = 4673 := CE120.faceShrinkCE120
  have hshrink25 : (tCE119 : ℝ) - (tCE118 : ℝ) = 4673 := CE119.faceShrinkCE119
  have hshrink26 : (tCE118 : ℝ) - (tCE117 : ℝ) = 4673 := CE118.faceShrinkCE118
  have hshrink27 : (tCE117 : ℝ) - (tCE116 : ℝ) = 4673 := CE117.faceShrinkCE117
  have hshrink28 : (tCE116 : ℝ) - (tCE115 : ℝ) = 4673 := CE116.faceShrinkCE116
  have hshrink29 : (tCE115 : ℝ) - (tCE114 : ℝ) = 4673 := CE115.faceShrinkCE115
  have hshrink30 : (tCE114 : ℝ) - (tCE113 : ℝ) = 4673 := CE114.faceShrinkCE114
  have hshrink31 : (tCE113 : ℝ) - (tCE112 : ℝ) = 4673 := CE113.faceShrinkCE113
  have hshrink32 : (tCE112 : ℝ) - (tCE111 : ℝ) = 4673 := CE112.faceShrinkCE112
  have hshrink33 : (tCE111 : ℝ) - (tCE110 : ℝ) = 4672 := CE111.faceShrinkCE111
  have hshrink34 : (tCE110 : ℝ) - (tCE109 : ℝ) = 4673 := CE110.faceShrinkCE110
  have hshrink35 : (tCE109 : ℝ) - (tCE108 : ℝ) = 4673 := CE109.faceShrinkCE109
  have hshrink36 : (tCE108 : ℝ) - (tCE107 : ℝ) = 4673 := CE108.faceShrinkCE108
  have hshrink37 : (tCE107 : ℝ) - (tCE106 : ℝ) = 4673 := CE107.faceShrinkCE107
  have hshrink38 : (tCE106 : ℝ) - (tCE105 : ℝ) = 4673 := CE106.faceShrinkCE106
  have hshrink39 : (tCE105 : ℝ) - (tCE104 : ℝ) = 4673 := CE105.faceShrinkCE105
  have hshrink40 : (tCE104 : ℝ) - (tCE103 : ℝ) = 4673 := CE104.faceShrinkCE104
  have hshrink41 : (tCE103 : ℝ) - (tCE102 : ℝ) = 4672 := CE103.faceShrinkCE103
  have hshrink42 : (tCE102 : ℝ) - (tCE101 : ℝ) = 4672 := CE102.faceShrinkCE102
  have hshrink43 : (tCE101 : ℝ) - (tCE100 : ℝ) = 4673 := CE101.faceShrinkCE101
  have hshrink44 : (tCE100 : ℝ) - (tCE99 : ℝ) = 5 := CE100.faceShrinkCE100
  have hshrink45 : (tCE99 : ℝ) - (tCE98 : ℝ) = 4673 := CE99.faceShrinkCE99
  have hshrink46 : (tCE98 : ℝ) - (tCE97 : ℝ) = 4673 := CE98.faceShrinkCE98
  have hshrink47 : (tCE97 : ℝ) - (tCE96 : ℝ) = 4672 := CE97.faceShrinkCE97
  have hshrink48 : (tCE96 : ℝ) - (tCE95 : ℝ) = 4673 := CE96.faceShrinkCE96
  have hshrink49 : (tCE95 : ℝ) - (tCE94 : ℝ) = 4673 := CE95.faceShrinkCE95
  have hshrink50 : (tCE94 : ℝ) - (tCE93 : ℝ) = 4673 := CE94.faceShrinkCE94
  have hshrink51 : (tCE93 : ℝ) - (tCE92 : ℝ) = 4673 := CE93.faceShrinkCE93
  have hshrink52 : (tCE92 : ℝ) - (tCE91 : ℝ) = 4673 := CE92.faceShrinkCE92
  have hshrink53 : (tCE91 : ℝ) - (tCE90 : ℝ) = 4673 := CE91.faceShrinkCE91
  have hshrink54 : (tCE90 : ℝ) - (tCE89 : ℝ) = 4673 := CE90.faceShrinkCE90
  have hshrink55 : (tCE89 : ℝ) - (tCE88 : ℝ) = 4673 := CE89.faceShrinkCE89
  have hshrink56 : (tCE88 : ℝ) - (tCE87 : ℝ) = 4673 := CE88.faceShrinkCE88
  have hshrink57 : (tCE87 : ℝ) - (tCE86 : ℝ) = 4672 := CE87.faceShrinkCE87
  have hshrink58 : (tCE86 : ℝ) - (tCE85 : ℝ) = 4673 := CE86.faceShrinkCE86
  have hshrink59 : (tCE85 : ℝ) - (tCE84 : ℝ) = 4673 := CE85.faceShrinkCE85
  have hshrink60 : (tCE84 : ℝ) - (tCE83 : ℝ) = 4673 := CE84.faceShrinkCE84
  have hshrink61 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := CE83.faceShrinkCE83
  have hshrink62 : (tCE82 : ℝ) - (tCE81 : ℝ) = 4673 := CE82.faceShrinkCE82
  have hshrink63 : (tCE81 : ℝ) - (tCE80 : ℝ) = 4673 := CE81.faceShrinkCE81
  have hshrink64 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := CE80.faceShrinkCE80
  have hshrink65 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink66 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink67 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink68 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink69 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6, hshrink7, hshrink8, hshrink9, hshrink10, hshrink11, hshrink12, hshrink13, hshrink14, hshrink15, hshrink16, hshrink17, hshrink18, hshrink19, hshrink20, hshrink21, hshrink22, hshrink23, hshrink24, hshrink25, hshrink26, hshrink27, hshrink28, hshrink29, hshrink30, hshrink31, hshrink32, hshrink33, hshrink34, hshrink35, hshrink36, hshrink37, hshrink38, hshrink39, hshrink40, hshrink41, hshrink42, hshrink43, hshrink44, hshrink45, hshrink46, hshrink47, hshrink48, hshrink49, hshrink50, hshrink51, hshrink52, hshrink53, hshrink54, hshrink55, hshrink56, hshrink57, hshrink58, hshrink59, hshrink60, hshrink61, hshrink62, hshrink63, hshrink64, hshrink65, hshrink66, hshrink67, hshrink68, hshrink69]
  linarith [h]

/-- ORDERING (machine, norm_num): (gB142Lo : R) < (gB143Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB142Lo the STANDARD lower bound on the window-142 endpoint g_b142 and gB143Lo = 300017600102642 / 100 the STANDARD lower bound on the window-143 endpoint g_b143 (the -86 dyadic family; the exact dyadic tuple is authoritative over the exponent representation). -/
theorem gB142Lo_lt_gB143Lo : (gB142Lo : ℝ) < (gB143Lo : ℝ) := by
  norm_num [CE142.gB142Lo, gB143Lo]
















































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

/-- WINDOW 98 FULL slice (re-cited in the W100 band - window 98 of 100, the full recorded window (gB97Lo, gB98Lo]; W98 record: NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined at m = 64; the rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 independent fresh-mpmath union-span adjudication - fresh 5 / 5 / 5, no near-zero touch, 4/4 control spans pass)): the zeros of zeta with
(gB97Lo : R) < Im s <= (gB98Lo : R) are all simple and on the line. Provenance: window98_b98.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE98 module (seam/audit record,
carried). Slice restriction (gB97Lo, gB98Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 98. -/
def ce98WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB97Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB98Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 99 FULL slice (re-cited in the W101 band - window 99 of 101, the full recorded window (gB98Lo, gB99Lo]; W99 record: NON-SNAPPED 20 000, CLEAN): the zeros of zeta with
(gB98Lo : R) < Im s <= (gB99Lo : R) are all simple and on the line. Provenance: window99_b99.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE99 module (seam/audit record,
carried). Slice restriction (gB98Lo, gB99Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 99. -/
def ce99WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB98Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB99Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 100 FULL slice (re-cited in the W102 band - window 100 of 102, the full recorded window (gB99Lo, gB100Lo]; W100 record: TAIL 21 (the final short window of the 2 000 000 census program; b - a = 21), CLEAN - zero failures - the 2 000 000 program target LANDED at W100 [0421]; W101 is the first post-target-extension window): the zeros of zeta with
(gB99Lo : R) < Im s <= (gB100Lo : R) are all simple and on the line. Provenance: window100_b100.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE100 module (seam/audit record,
carried). Slice restriction (gB99Lo, gB100Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 100. -/
def ce100WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB99Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB100Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 101 FULL slice (re-cited in the W103 band - window 101 of 103, the full recorded window (gB100Lo, gB101Lo]; W101 record: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued, adjudication-confirmed (fresh 4 / 4 - the 0431 independent union-span adjudication)): the zeros of zeta with
(gB100Lo : R) < Im s <= (gB101Lo : R) are all simple and on the line. Provenance: window101_b101.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE101 module (seam/audit record,
carried). Slice restriction (gB100Lo, gB101Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 101. -/
def ce101WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB100Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB101Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 102 FULL slice (re-cited in the W104 band - window 102 of 104, the full recorded window (gB101Lo, gB102Lo]; W102 record: SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - zero recorded interior failures): the zeros of zeta with
(gB101Lo : R) < Im s <= (gB102Lo : R) are all simple and on the line. Provenance: window102_b102.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE102 module (seam/audit record,
carried). Slice restriction (gB101Lo, gB102Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 102. -/
def ce102WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB101Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB102Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 103 FULL slice (re-cited in the W105 band - window 103 of 105, the full recorded window (gB102Lo, gB103Lo]; W103 record: SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - zero recorded interior failures (the 2 040 000 census mark crossed mid-window)): the zeros of zeta with
(gB102Lo : R) < Im s <= (gB103Lo : R) are all simple and on the line. Provenance: window103_b103.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE103 module (seam/audit record,
carried). Slice restriction (gB102Lo, gB103Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 103. -/
def ce103WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB102Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB103Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 104 FULL slice (re-cited in the W106 band - window 104 of 106, the full recorded window (gB103Lo, gB104Lo]; W104 record: FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - determined, rescued, adjudication-confirmed (fresh 6 / 6 - 0437; the 2 060 000 census mark crossed in the window)): the zeros of zeta with
(gB103Lo : R) < Im s <= (gB104Lo : R) are all simple and on the line. Provenance: window104_b104.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE104 module (seam/audit record,
carried). Slice restriction (gB103Lo, gB104Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 104. -/
def ce104WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB103Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB104Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 105 FULL slice (re-cited in the W107 band - window 105 of 107, the full recorded window (gB104Lo, gB105Lo]; W105 record: FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - determined, rescued, adjudication-confirmed (fresh 4 / 4 - 0438; the 2 080 000 census mark crossed in the window)): the zeros of zeta with
(gB104Lo : R) < Im s <= (gB105Lo : R) are all simple and on the line. Provenance: window105_b105.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE105 module (seam/audit record,
carried). Slice restriction (gB104Lo, gB105Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 105. -/
def ce105WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB104Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB105Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 106 FULL slice (re-cited in the W108 band - window 106 of 108, the full recorded window (gB105Lo, gB106Lo]; W106 record: FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - determined, rescued, adjudication-confirmed (fresh 5 / 5 - 0439; the 2 100 000 census mark crossed in the window)): the zeros of zeta with
(gB105Lo : R) < Im s <= (gB106Lo : R) are all simple and on the line. Provenance: window106_b106.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE106 module (seam/audit record,
carried). Slice restriction (gB105Lo, gB106Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 106. -/
def ce106WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB105Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB106Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 107 FULL slice (re-cited in the W109 band - window 107 of 109, the full recorded window (gB106Lo, gB107Lo]; W107 record: SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined, rescued, adjudication-confirmed (fresh 4 / 4 - 0440; the 500 000 unit round mark crossed with margin 1)): the zeros of zeta with
(gB106Lo : R) < Im s <= (gB107Lo : R) are all simple and on the line. Provenance: window107_b107.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE107 module (seam/audit record,
carried). Slice restriction (gB106Lo, gB107Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 107. -/
def ce107WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB106Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB107Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 108 FULL slice (re-cited in the W110 band - window 108 of 110, the full recorded window (gB107Lo, gB108Lo]; W108 record: FULL-width 20 000 (no snap), THREE recorded interior Rosser failures - all determined, all rescued, all adjudication-confirmed (fresh 5 / 5 on each - 0441; the first multi-failure window; the 2 140 000 census mark crossed in the window)): the zeros of zeta with
(gB107Lo : R) < Im s <= (gB108Lo : R) are all simple and on the line. Provenance: window108_b108.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE108 module (seam/audit record,
carried). Slice restriction (gB107Lo, gB108Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 108. -/
def ce108WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB107Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB108Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 109 FULL slice (re-cited in the W111 band - window 109 of 111, the full recorded window (gB108Lo, gB109Lo]; W109 record: FULL-width 20 000 (no snap), ONE recorded interior Rosser failure - determined, rescued on a six-glyph union, adjudication-confirmed (fresh 5 / 5 - 0442; the 505 000 unit mark and the 2 160 000 census mark crossed in the window)): the zeros of zeta with
(gB108Lo : R) < Im s <= (gB109Lo : R) are all simple and on the line. Provenance: window109_b109.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE109 module (seam/audit record,
carried). Slice restriction (gB108Lo, gB109Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 109. -/
def ce109WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB108Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB109Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 110 FULL slice (re-cited in the W112 band - window 110 of 112, the full recorded window (gB109Lo, gB110Lo]; W110 record: SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser failure blocks (nothing to adjudicate - 0443; the 510 000 unit mark and the 2 180 000 census mark crossed in the window)): the zeros of zeta with
(gB109Lo : R) < Im s <= (gB110Lo : R) are all simple and on the line. Provenance: window110_b110.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE110 module (seam/audit record,
carried). Slice restriction (gB109Lo, gB110Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 110. -/
def ce110WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB109Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB110Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 111 FULL slice (re-cited in the W113 band - window 111 of 113, the full recorded window (gB110Lo, gB111Lo]; W111 record: FULL 20 000, CLEAN - zero interior Rosser failure blocks (nothing to adjudicate - 0444; second consecutive clean window; the 515 000 unit mark and the 2 200 000 census mark crossed in the window)): the zeros of zeta with
(gB110Lo : R) < Im s <= (gB111Lo : R) are all simple and on the line. Provenance: window111_b111.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE111 module (seam/audit record,
carried). Slice restriction (gB110Lo, gB111Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 111. -/
def ce111WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB110Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB111Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 112 FULL slice (re-cited in the W114 band - window 112 of 114, the full recorded window (gB111Lo, gB112Lo]; W112 record: FULL 20 000, THREE recorded interior Rosser failures - all determined and rescued, adjudication-confirmed (fresh 4/4, 5/5, 4/4 - 0445; second multi-failure window; the 520 000 unit mark and the 2 220 000 census mark crossed in the window)): the zeros of zeta with
(gB111Lo : R) < Im s <= (gB112Lo : R) are all simple and on the line. Provenance: window112_b112.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE112 module (seam/audit record,
carried). Slice restriction (gB111Lo, gB112Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 112. -/
def ce112WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB111Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB112Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 113 FULL slice (re-cited in the W115 band - window 113 of 115, the full recorded window (gB112Lo, gB113Lo]; W113 record: SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined, rescued on a five-glyph union, adjudication-confirmed (fresh 5/5 - 0446; the 525 000 unit mark and the 2 240 000 census mark crossed in the window)): the zeros of zeta with
(gB112Lo : R) < Im s <= (gB113Lo : R) are all simple and on the line. Provenance: window113_b113.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE113 module (seam/audit record,
carried). Slice restriction (gB112Lo, gB113Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 113. -/
def ce113WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB112Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB113Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 114 FULL slice (re-cited in the W116 band - window 114 of 116, the full recorded window (gB113Lo, gB114Lo]; W114 record: FULL 20 000, ONE recorded interior Rosser failure - determined, rescued on a five-glyph union, adjudication-confirmed (fresh 4/4 - 0447; the 530 000 unit mark and the 2 260 000 census mark crossed in the window)): the zeros of zeta with
(gB113Lo : R) < Im s <= (gB114Lo : R) are all simple and on the line. Provenance: window114_b114.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE114 module (seam/audit record,
carried). Slice restriction (gB113Lo, gB114Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 114. -/
def ce114WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB113Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB114Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 115 FULL slice (re-cited in the W117 band - window 115 of 117, the full recorded window (gB114Lo, gB115Lo]; W115 record: FULL 20 000, CLEAN - zero interior Rosser failure blocks (nothing to adjudicate - 0448; third clean window of the post-target series; the 535 000 unit mark and the 2 280 000 census mark crossed in the window)): the zeros of zeta with
(gB114Lo : R) < Im s <= (gB115Lo : R) are all simple and on the line. Provenance: window115_b115.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE115 module (seam/audit record,
carried). Slice restriction (gB114Lo, gB115Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 115. -/
def ce115WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB114Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB115Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 116 FULL slice (re-cited in the W118 band - window 116 of 118, the full recorded window (gB115Lo, gB116Lo]; W116 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued, adjudication-confirmed (fresh 4/4, 4/4 - the first two-failure window of the post-target series - 0449; the 540 000 unit mark and the 2 300 000 census mark crossed in the window)): the zeros of zeta with
(gB115Lo : R) < Im s <= (gB116Lo : R) are all simple and on the line. Provenance: window116_b116.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE116 module (seam/audit record,
carried). Slice restriction (gB115Lo, gB116Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 116. -/
def ce116WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB115Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB116Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 117 FULL slice (re-cited in the W119 band - window 117 of 119, the full recorded window (gB116Lo, gB117Lo]; W117 record: FULL 20 000, ONE recorded interior Rosser failure - determined, rescued on a wide six-glyph union (5/5), adjudication-confirmed (fresh 5/5 - FOURTEENTH W97-family protocol cycle - 0450; the 545 000 unit mark and the 2 320 000 census mark crossed in the window)): the zeros of zeta with
(gB116Lo : R) < Im s <= (gB117Lo : R) are all simple and on the line. Provenance: window117_b117.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE117 module (seam/audit record,
carried). Slice restriction (gB116Lo, gB117Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 117. -/
def ce117WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB116Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB117Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 118 FULL slice (re-cited in the W120 band - window 118 of 120, the full recorded window (gB117Lo, gB118Lo]; W118 record: FULL 20 000, CLEAN - zero interior Rosser failure blocks (nothing to adjudicate - 0451; fourth clean window of the post-target series; the 550 000 unit mark and the 2 340 000 census mark crossed in the window)): the zeros of zeta with
(gB117Lo : R) < Im s <= (gB118Lo : R) are all simple and on the line. Provenance: window118_b118.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE118 module (seam/audit record,
carried). Slice restriction (gB117Lo, gB118Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 118. -/
def ce118WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB117Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB118Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 119 FULL slice (re-cited in the W121 band - window 119 of 121, the full recorded window (gB118Lo, gB119Lo]; W119 record: FULL 20 000, CLEAN - zero interior Rosser failure blocks (nothing to adjudicate - 0452; fifth clean window of the post-target series; the 555 000 unit mark and the 2 360 000 census mark crossed in the window)): the zeros of zeta with
(gB118Lo : R) < Im s <= (gB119Lo : R) are all simple and on the line. Provenance: window119_b119.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE119 module (seam/audit record,
carried). Slice restriction (gB118Lo, gB119Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 119. -/
def ce119WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB118Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB119Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 120 FULL slice (re-cited in the W122 band - window 120 of 122, the full recorded window (gB119Lo, gB120Lo]; W120 record: FULL 20 000, TWO recorded interior Rosser failure blocks - the second two-failure window, including the first four-gram block rescued on an eight-glyph union (fresh 7/7, 4/4 - 0453; the 560 000 unit mark and the 2 380 000 census mark crossed in the window)): the zeros of zeta with
(gB119Lo : R) < Im s <= (gB120Lo : R) are all simple and on the line. Provenance: window120_b120.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE120 module (seam/audit record,
carried). Slice restriction (gB119Lo, gB120Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 120. -/
def ce120WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB119Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB120Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 121 FULL slice (re-cited in the W123 band - window 121 of 123, the full recorded window (gB120Lo, gB121Lo]; W121 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued on wide six-glyph unions (fresh 5/5, 5/5 - the 565 000 unit mark and the 2 400 000 census mark crossed in the window, margin 422 - 0454)): the zeros of zeta with
(gB120Lo : R) < Im s <= (gB121Lo : R) are all simple and on the line. Provenance: window121_b121.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE121 module (seam/audit record,
carried). Slice restriction (gB120Lo, gB121Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 121. -/
def ce121WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB120Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB121Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 122 FULL slice (re-cited in the W124 band - window 122 of 124, the full recorded window (gB121Lo, gB122Lo]; W122 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4, 6/6 on the first seven-glyph union - the 570 000 unit mark crossed in the window, margin 95 - 0455)): the zeros of zeta with
(gB121Lo : R) < Im s <= (gB122Lo : R) are all simple and on the line. Provenance: window122_b122.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE122 module (seam/audit record,
carried). Slice restriction (gB121Lo, gB122Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 122. -/
def ce122WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB121Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB122Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 123 FULL slice (re-cited in the W125 band - window 123 of 125, the full recorded window (gB122Lo, gB123Lo]; W123 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4) with a SUB-STANDARD 4 672 floor increment (the 2 440 000 census mark crossed; the 575 000 unit mark NOT crossed - 0456)): the zeros of zeta with
(gB122Lo : R) < Im s <= (gB123Lo : R) are all simple and on the line. Provenance: window123_b123.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE123 module (seam/audit record,
carried). Slice restriction (gB122Lo, gB123Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 123. -/
def ce123WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB122Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB123Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 124 FULL slice (re-cited in the W126 band - window 124 of 126, the full recorded window (gB123Lo, gB124Lo]; W124 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4, 7/7 on the second eight-glyph union; the 575 000 unit and 2 460 000 census marks crossed exactly as the corrected 0456 schedule predicted - 0457)): the zeros of zeta with
(gB123Lo : R) < Im s <= (gB124Lo : R) are all simple and on the line. Provenance: window124_b124.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE124 module (seam/audit record,
carried). Slice restriction (gB123Lo, gB124Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 124. -/
def ce124WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB123Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB124Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 125 FULL slice (re-cited in the W127 band - window 125 of 127, the full recorded window (gB124Lo, gB125Lo]; W125 record: FULL 20 000, ONE recorded interior Rosser failure block - the second four-gram of the series - determined and rescued (fresh 5/5); the 580 000 unit and 2 480 000 census marks crossed exactly as the 0457 schedule predicted (0458)): the zeros of zeta with
(gB124Lo : R) < Im s <= (gB125Lo : R) are all simple and on the line. Provenance: window125_b125.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE125 module (seam/audit record,
carried). Slice restriction (gB124Lo, gB125Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 125. -/
def ce125WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB124Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB125Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 126 FULL slice (re-cited in the W128 band - window 126 of 128, the full recorded window (gB125Lo, gB126Lo]; W126 record: ONE-GRAM SNAP 19 999, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4); the 585 000 unit and 2 500 000 census marks crossed exactly as the 0458 schedule predicted (0459)): the zeros of zeta with
(gB125Lo : R) < Im s <= (gB126Lo : R) are all simple and on the line. Provenance: window126_b126.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE126 module (seam/audit record,
carried). Slice restriction (gB125Lo, gB126Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 126. -/
def ce126WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB125Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB126Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 127 FULL slice (re-cited in the W129 band - window 127 of 129, the full recorded window (gB126Lo, gB127Lo]; W127 record: FULL 20 000, TWO recorded interior Rosser failure blocks - the seventh two-failure window, including the third four-gram of the series - both determined and rescued (fresh 4/4, 5/5); the 590 000 unit and 2 520 000 census marks crossed exactly as the 0459 schedule predicted (0460)): the zeros of zeta with
(gB126Lo : R) < Im s <= (gB127Lo : R) are all simple and on the line. Provenance: window127_b127.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE127 module (seam/audit record,
carried). Slice restriction (gB126Lo, gB127Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 127. -/
def ce127WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB126Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB127Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 128 FULL slice (re-cited in the W130 band - window 128 of 130, the full recorded window (gB127Lo, gB128Lo]; W128 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5); the 595 000 unit and 2 540 000 census marks crossed exactly as the 0460 schedule predicted (0461)): the zeros of zeta with
(gB127Lo : R) < Im s <= (gB128Lo : R) are all simple and on the line. Provenance: window128_b128.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE128 module (seam/audit record,
carried). Slice restriction (gB127Lo, gB128Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 128. -/
def ce128WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB127Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB128Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 129 FULL slice (re-cited in the W131 band - window 129 of 131, the full recorded window (gB128Lo, gB129Lo]; W129 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4); the 600 000 unit and 2 560 000 census marks crossed exactly as the 0461 schedule predicted (0462)): the zeros of zeta with
(gB128Lo : R) < Im s <= (gB129Lo : R) are all simple and on the line. Provenance: window129_b129.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE129 module (seam/audit record,
carried). Slice restriction (gB128Lo, gB129Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 129. -/
def ce129WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB128Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB129Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 130 FULL slice (re-cited in the W132 band - window 130 of 132, the full recorded window (gB129Lo, gB130Lo]; W130 record: FULL 20 000, TWO recorded interior Rosser failure blocks - the eighth two-failure window, including the fourth four-gram of the series - both determined and rescued (fresh 7/7, 4/4); the 605 000 unit and 2 580 000 census marks crossed exactly as the 0462 schedule predicted (0463)): the zeros of zeta with
(gB129Lo : R) < Im s <= (gB130Lo : R) are all simple and on the line. Provenance: window130_b130.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE130 module (seam/audit record,
carried). Slice restriction (gB129Lo, gB130Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 130. -/
def ce130WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB129Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB130Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 131 FULL slice (re-cited in the W133 band - window 131 of 133, the full recorded window (gB130Lo, gB131Lo]; W131 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 6/6 on a seven-glyph union), adjudication-confirmed (TWENTY-SIXTH W97-family protocol cycle); the 610 000 unit and 2 600 000 census marks crossed exactly as the 0463 schedule predicted (0464)): the zeros of zeta with
(gB130Lo : R) < Im s <= (gB131Lo : R) are all simple and on the line. Provenance: window131_b131.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE131 module (seam/audit record,
carried). Slice restriction (gB130Lo, gB131Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 131. -/
def ce131WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB130Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB131Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 132 FULL slice (re-cited in the W134 band - window 132 of 134, the full recorded window (gB131Lo, gB132Lo]; W132 record: FULL 20 000, CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total; the SIXTH clean window of the post-target series); the 615 000 unit and 2 620 000 census marks crossed exactly as the 0465 schedule predicted (0465)): the zeros of zeta with
(gB131Lo : R) < Im s <= (gB132Lo : R) are all simple and on the line. Provenance: window132_b132.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE132 module (seam/audit record,
carried). Slice restriction (gB131Lo, gB132Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 132. -/
def ce132WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB131Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB132Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 133 FULL slice (re-cited in the W135 band - window 133 of 135, the full recorded window (gB132Lo, gB133Lo]; W133 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5 on a six-glyph union; the FIRST autonomous-lane window); the 620 000 unit and 2 640 000 census marks crossed exactly as the 0466 schedule predicted (0466)): the zeros of zeta with
(gB132Lo : R) < Im s <= (gB133Lo : R) are all simple and on the line. Provenance: window133_b133.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE133 module (seam/audit record,
carried). Slice restriction (gB132Lo, gB133Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 133. -/
def ce133WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB132Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB133Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 134 FULL slice (re-cited in the W136 band - window 134 of 136, the full recorded window (gB133Lo, gB134Lo]; W134 record: FULL 20 000, CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total; the SEVENTH clean window of the post-target series); the 625 000 unit and 2 660 000 census marks crossed exactly as the 0467 schedule predicted (0467)): the zeros of zeta with
(gB133Lo : R) < Im s <= (gB134Lo : R) are all simple and on the line. Provenance: window134_b134.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE134 module (seam/audit record,
carried). Slice restriction (gB133Lo, gB134Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 134. -/
def ce134WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB133Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB134Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 135 FULL slice (re-cited in the W137 band - window 135 of 137, the full recorded window (gB134Lo, gB135Lo]; W135 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 7/7 on an eight-glyph union; the TWENTY-EIGHTH + TWENTY-NINTH W97-family protocol cycles) (0468)): the zeros of zeta with
(gB134Lo : R) < Im s <= (gB135Lo : R) are all simple and on the line. Provenance: window135_b135.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE135 module (seam/audit record,
carried). Slice restriction (gB134Lo, gB135Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 135. -/
def ce135WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB134Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB135Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 136 FULL slice (re-cited in the W138 band - window 136 of 138, the full recorded window (gB135Lo, gB136Lo]; W136 record: FULL 20 000, CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total; the EIGHTH clean window of the post-target series) (0469)): the zeros of zeta with
(gB135Lo : R) < Im s <= (gB136Lo : R) are all simple and on the line. Provenance: window136_b136.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE136 module (seam/audit record,
carried). Slice restriction (gB135Lo, gB136Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 136. -/
def ce136WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB135Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB136Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 137 FULL slice (re-cited in the W139 band - window 137 of 139, the full recorded window (gB136Lo, gB137Lo]; W137 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 4/4 on a five-glyph union; the THIRTIETH + THIRTY-FIRST W97-family protocol cycles) (0471)): the zeros of zeta with
(gB136Lo : R) < Im s <= (gB137Lo : R) are all simple and on the line. Provenance: window137_b137.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE137 module (seam/audit record,
carried). Slice restriction (gB136Lo, gB137Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 137. -/
def ce137WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB136Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB137Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 138 FULL slice (re-cited in the W140 band - window 138 of 140, the full recorded window (gB137Lo, gB138Lo]; W138 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a five-glyph union; the THIRTY-SECOND W97-family protocol cycle) (0472)): the zeros of zeta with
(gB137Lo : R) < Im s <= (gB138Lo : R) are all simple and on the line. Provenance: window138_b138.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE138 module (seam/audit record,
carried). Slice restriction (gB137Lo, gB138Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 138. -/
def ce138WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB137Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB138Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 139 FULL slice (re-cited in the W141 band - window 139 of 141, the full recorded window (gB138Lo, gB139Lo]; W139 record: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 5/5 on a six-glyph union; the THIRTY-THIRD + THIRTY-FOURTH W97-family protocol cycles) (0473)): the zeros of zeta with
(gB138Lo : R) < Im s <= (gB139Lo : R) are all simple and on the line. Provenance: window139_b139.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE139 module (seam/audit record,
carried). Slice restriction (gB138Lo, gB139Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 139. -/
def ce139WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB138Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB139Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 140 FULL slice (re-cited in the W142 band - window 140 of 142, the full recorded window (gB139Lo, gB140Lo]; W140 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 6/6 on a six-glyph union; the THIRTY-FIFTH W97-family protocol cycle) (0474)): the zeros of zeta with
(gB139Lo : R) < Im s <= (gB140Lo : R) are all simple and on the line. Provenance: window140_b140.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE140 module (seam/audit record,
carried). Slice restriction (gB139Lo, gB140Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 140. -/
def ce140WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB139Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB140Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 141 FULL slice (re-cited in the W143 band - window 141 of 143, the full recorded window (gB140Lo, gB141Lo]; W141 record: FULL 20 000, THREE recorded interior Rosser failure blocks - all determined and rescued (fresh 4/4 on each four-glyph union; the THIRTY-SIXTH + THIRTY-SEVENTH + THIRTY-EIGHTH W97-family protocol cycles) (0475)): the zeros of zeta with
(gB140Lo : R) < Im s <= (gB141Lo : R) are all simple and on the line. Provenance: window141_b141.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE141 module (seam/audit record,
carried). Slice restriction (gB140Lo, gB141Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 141. -/
def ce141WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB140Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB141Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 142 FULL slice (re-cited in the W143 band - window 142 of 143, the full recorded window (gB141Lo, gB142Lo]; W142 record: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a four-glyph union; the THIRTY-NINTH W97-family protocol cycle) (0477)): the zeros of zeta with
(gB141Lo : R) < Im s <= (gB142Lo : R) are all simple and on the line. Provenance: window142_b142.json
(Murphy pipeline) + the pipeline verifier (CERTIFIED) + the CE142 module (seam/audit record,
carried). Slice restriction (gB141Lo, gB142Lo] is a SUBSET of the certified window, so its zeros
inherit on-linedness; no RH CLAIM about window 142. -/
def ce142WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB141Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB142Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 143 TERMINAL slice (window 143 of 143, the (gB142Lo, g_b143] portion of the recorded window,
up to floor(gB143) - FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total) (b = 12 363 156 297 122; zero recorded interior Rosser failure blocks (CLEAN) - see the module header):
the zeros of zeta with
(gB142Lo : R) < Im s <= int(gB143) = 3,000,176,001,026 (the FLOOR - the endpoint g_b143 sits
0.4273325676526547340924724 (exact, exponent -86 dyadic terminator) above it, exact, robust to the certified radius ~4.7e-14) are all simple and on the
line. Certificates: window143_b143.json (window 143; certified 2026-11-16) + the pipeline verifier
(CERTIFIED, turing_ok, points 33 066, sign_changes_inside = 20,000 = b - a,
rosser_failures_inside = 0end Rosser runs 49 / 47,
K_conservative = 12) + the module header (M = 60, C_R = 1, the bit-identical g_a143 == g_b142
SEAM AUDIT). Slice restriction (gB142Lo, int(gB143)] is a SUBSET of the certified window, so
its zeros inherit on-linedness; no RH CLAIM about the face above g_b143. -/
def ce143WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB142Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE143 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h144
(window 143 contributes ONE clause for its (gB142Lo, tCE143] slice - h144; W143 FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total)
certified b = 12 363 156 297 122, zero recorded interior Rosser failure blocks (CLEAN); window 142 re-cited in full at gB141 - h143), ALL zeros of zeta with Im s >
WinC.tPT2 and Im s <= (tCE143 : R) lie on the line: h1-h2 cover window 1 (CE2, the
Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the
W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..143 enter as their certified (gB-prev,
gB] slices (bit-identical at every seam; the re-cited full-slice clause carries the full
recorded window). CUMULATIVE tally through window 143: 143 windows - 56 clean,
97 rescue; 133 total internal Rosser failures, ALL RECORDED. NO RH CLAIM
about Im s > tCE143. -/
theorem bandOfWindows143 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : CE80.ce79WinClauseFull) (h81 : CE81.ce80WinClauseFull) (h82 : CE82.ce81WinClauseFull) (h83 : CE83.ce82WinClauseFull) (h84 : CE84.ce83WinClauseFull) (h85 : CE85.ce84WinClauseFull) (h86 : CE86.ce85WinClauseFull) (h87 : CE87.ce86WinClauseFull) (h88 : CE88.ce87WinClauseFull) (h89 : CE89.ce88WinClauseFull) (h90 : CE90.ce89WinClauseFull) (h91 : CE91.ce90WinClauseFull) (h92 : CE92.ce91WinClauseFull) (h93 : CE93.ce92WinClauseFull) (h94 : CE94.ce93WinClauseFull) (h95 : CE95.ce94WinClauseFull) (h96 : ce95WinClauseFull) (h97 : ce96WinClauseFull) (h98 : ce97WinClauseFull) (h99 : ce98WinClauseFull) (h100 : ce99WinClauseFull) (h101 : ce100WinClauseFull) (h102 : ce101WinClauseFull) (h103 : ce102WinClauseFull) (h104 : ce103WinClauseFull) (h105 : ce104WinClauseFull) (h106 : ce105WinClauseFull) (h107 : ce106WinClauseFull) (h108 : ce107WinClauseFull) (h109 : ce108WinClauseFull) (h110 : ce109WinClauseFull) (h111 : ce110WinClauseFull) (h112 : ce111WinClauseFull) (h113 : ce112WinClauseFull) (h114 : ce113WinClauseFull) (h115 : ce114WinClauseFull) (h116 : ce115WinClauseFull) (h117 : ce116WinClauseFull) (h118 : ce117WinClauseFull) (h119 : ce118WinClauseFull) (h120 : ce119WinClauseFull) (h121 : ce120WinClauseFull) (h122 : ce121WinClauseFull) (h123 : ce122WinClauseFull) (h124 : ce123WinClauseFull) (h125 : ce124WinClauseFull) (h126 : ce125WinClauseFull) (h127 : ce126WinClauseFull) (h128 : ce127WinClauseFull) (h129 : ce128WinClauseFull) (h130 : ce129WinClauseFull) (h131 : ce130WinClauseFull) (h132 : ce131WinClauseFull) (h133 : ce132WinClauseFull) (h134 : ce133WinClauseFull) (h135 : ce134WinClauseFull) (h136 : ce135WinClauseFull) (h137 : ce136WinClauseFull) (h138 : ce137WinClauseFull) (h139 : ce138WinClauseFull) (h140 : ce139WinClauseFull) (h141 : ce140WinClauseFull) (h142 : ce141WinClauseFull) (h143 : ce142WinClauseFull) (h144 : ce143WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE143 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                                                                      · by_cases hseam100 : ρ.im ≤ (gB99Lo : ℝ)
                                                                                                                                                                                                        · exact h100 ρ hz (not_le.mp hseam99) hseam100
                                                                                                                                                                                                        · by_cases hseam101 : ρ.im ≤ (gB100Lo : ℝ)
                                                                                                                                                                                                          · exact h101 ρ hz (not_le.mp hseam100) hseam101
                                                                                                                                                                                                          · by_cases hseam102 : ρ.im ≤ (gB101Lo : ℝ)
                                                                                                                                                                                                            · exact h102 ρ hz (not_le.mp hseam101) hseam102
                                                                                                                                                                                                            · by_cases hseam103 : ρ.im ≤ (gB102Lo : ℝ)
                                                                                                                                                                                                              · exact h103 ρ hz (not_le.mp hseam102) hseam103
                                                                                                                                                                                                              · by_cases hseam104 : ρ.im ≤ (gB103Lo : ℝ)
                                                                                                                                                                                                                · exact h104 ρ hz (not_le.mp hseam103) hseam104
                                                                                                                                                                                                                · by_cases hseam105 : ρ.im ≤ (gB104Lo : ℝ)
                                                                                                                                                                                                                  · exact h105 ρ hz (not_le.mp hseam104) hseam105
                                                                                                                                                                                                                  · by_cases hseam106 : ρ.im ≤ (gB105Lo : ℝ)
                                                                                                                                                                                                                    · exact h106 ρ hz (not_le.mp hseam105) hseam106
                                                                                                                                                                                                                    · by_cases hseam107 : ρ.im ≤ (gB106Lo : ℝ)
                                                                                                                                                                                                                      · exact h107 ρ hz (not_le.mp hseam106) hseam107
                                                                                                                                                                                                                      · by_cases hseam108 : ρ.im ≤ (gB107Lo : ℝ)
                                                                                                                                                                                                                        · exact h108 ρ hz (not_le.mp hseam107) hseam108
                                                                                                                                                                                                                        · by_cases hseam109 : ρ.im ≤ (gB108Lo : ℝ)
                                                                                                                                                                                                                          · exact h109 ρ hz (not_le.mp hseam108) hseam109
                                                                                                                                                                                                                          · by_cases hseam110 : ρ.im ≤ (gB109Lo : ℝ)
                                                                                                                                                                                                                            · exact h110 ρ hz (not_le.mp hseam109) hseam110
                                                                                                                                                                                                                            · by_cases hseam111 : ρ.im ≤ (gB110Lo : ℝ)
                                                                                                                                                                                                                              · exact h111 ρ hz (not_le.mp hseam110) hseam111
                                                                                                                                                                                                                              · by_cases hseam112 : ρ.im ≤ (gB111Lo : ℝ)
                                                                                                                                                                                                                                · exact h112 ρ hz (not_le.mp hseam111) hseam112
                                                                                                                                                                                                                                · by_cases hseam113 : ρ.im ≤ (gB112Lo : ℝ)
                                                                                                                                                                                                                                  · exact h113 ρ hz (not_le.mp hseam112) hseam113
                                                                                                                                                                                                                                  · by_cases hseam114 : ρ.im ≤ (gB113Lo : ℝ)
                                                                                                                                                                                                                                    · exact h114 ρ hz (not_le.mp hseam113) hseam114
                                                                                                                                                                                                                                    · by_cases hseam115 : ρ.im ≤ (gB114Lo : ℝ)
                                                                                                                                                                                                                                      · exact h115 ρ hz (not_le.mp hseam114) hseam115
                                                                                                                                                                                                                                      · by_cases hseam116 : ρ.im ≤ (gB115Lo : ℝ)
                                                                                                                                                                                                                                        · exact h116 ρ hz (not_le.mp hseam115) hseam116
                                                                                                                                                                                                                                        · by_cases hseam117 : ρ.im ≤ (gB116Lo : ℝ)
                                                                                                                                                                                                                                          · exact h117 ρ hz (not_le.mp hseam116) hseam117
                                                                                                                                                                                                                                          · by_cases hseam118 : ρ.im ≤ (gB117Lo : ℝ)
                                                                                                                                                                                                                                            · exact h118 ρ hz (not_le.mp hseam117) hseam118
                                                                                                                                                                                                                                            · by_cases hseam119 : ρ.im ≤ (gB118Lo : ℝ)
                                                                                                                                                                                                                                              · exact h119 ρ hz (not_le.mp hseam118) hseam119
                                                                                                                                                                                                                                              · by_cases hseam120 : ρ.im ≤ (gB119Lo : ℝ)
                                                                                                                                                                                                                                                · exact h120 ρ hz (not_le.mp hseam119) hseam120
                                                                                                                                                                                                                                                · by_cases hseam121 : ρ.im ≤ (gB120Lo : ℝ)
                                                                                                                                                                                                                                                  · exact h121 ρ hz (not_le.mp hseam120) hseam121
                                                                                                                                                                                                                                                  · by_cases hseam122 : ρ.im ≤ (gB121Lo : ℝ)
                                                                                                                                                                                                                                                    · exact h122 ρ hz (not_le.mp hseam121) hseam122
                                                                                                                                                                                                                                                    · by_cases hseam123 : ρ.im ≤ (gB122Lo : ℝ)
                                                                                                                                                                                                                                                      · exact h123 ρ hz (not_le.mp hseam122) hseam123
                                                                                                                                                                                                                                                      · by_cases hseam124 : ρ.im ≤ (gB123Lo : ℝ)
                                                                                                                                                                                                                                                        · exact h124 ρ hz (not_le.mp hseam123) hseam124
                                                                                                                                                                                                                                                        · by_cases hseam125 : ρ.im ≤ (gB124Lo : ℝ)
                                                                                                                                                                                                                                                          · exact h125 ρ hz (not_le.mp hseam124) hseam125
                                                                                                                                                                                                                                                          · by_cases hseam126 : ρ.im ≤ (gB125Lo : ℝ)
                                                                                                                                                                                                                                                            · exact h126 ρ hz (not_le.mp hseam125) hseam126
                                                                                                                                                                                                                                                            · by_cases hseam127 : ρ.im ≤ (gB126Lo : ℝ)
                                                                                                                                                                                                                                                              · exact h127 ρ hz (not_le.mp hseam126) hseam127
                                                                                                                                                                                                                                                              · by_cases hseam128 : ρ.im ≤ (gB127Lo : ℝ)
                                                                                                                                                                                                                                                                · exact h128 ρ hz (not_le.mp hseam127) hseam128
                                                                                                                                                                                                                                                                · by_cases hseam129 : ρ.im ≤ (gB128Lo : ℝ)
                                                                                                                                                                                                                                                                  · exact h129 ρ hz (not_le.mp hseam128) hseam129
                                                                                                                                                                                                                                                                  · by_cases hseam130 : ρ.im ≤ (gB129Lo : ℝ)
                                                                                                                                                                                                                                                                    · exact h130 ρ hz (not_le.mp hseam129) hseam130
                                                                                                                                                                                                                                                                    · by_cases hseam131 : ρ.im ≤ (gB130Lo : ℝ)
                                                                                                                                                                                                                                                                      · exact h131 ρ hz (not_le.mp hseam130) hseam131
                                                                                                                                                                                                                                                                      · by_cases hseam132 : ρ.im ≤ (gB131Lo : ℝ)
                                                                                                                                                                                                                                                                        · exact h132 ρ hz (not_le.mp hseam131) hseam132
                                                                                                                                                                                                                                                                        · by_cases hseam133 : ρ.im ≤ (gB132Lo : ℝ)
                                                                                                                                                                                                                                                                          · exact h133 ρ hz (not_le.mp hseam132) hseam133
                                                                                                                                                                                                                                                                          · by_cases hseam134 : ρ.im ≤ (gB133Lo : ℝ)
                                                                                                                                                                                                                                                                            · exact h134 ρ hz (not_le.mp hseam133) hseam134
                                                                                                                                                                                                                                                                            · by_cases hseam135 : ρ.im ≤ (gB134Lo : ℝ)
                                                                                                                                                                                                                                                                              · exact h135 ρ hz (not_le.mp hseam134) hseam135
                                                                                                                                                                                                                                                                              · by_cases hseam136 : ρ.im ≤ (gB135Lo : ℝ)
                                                                                                                                                                                                                                                                                · exact h136 ρ hz (not_le.mp hseam135) hseam136
                                                                                                                                                                                                                                                                                · by_cases hseam137 : ρ.im ≤ (gB136Lo : ℝ)
                                                                                                                                                                                                                                                                                  · exact h137 ρ hz (not_le.mp hseam136) hseam137
                                                                                                                                                                                                                                                                                  · by_cases hseam138 : ρ.im ≤ (gB137Lo : ℝ)
                                                                                                                                                                                                                                                                                    · exact h138 ρ hz (not_le.mp hseam137) hseam138
                                                                                                                                                                                                                                                                                    · by_cases hseam139 : ρ.im ≤ (gB138Lo : ℝ)
                                                                                                                                                                                                                                                                                      · exact h139 ρ hz (not_le.mp hseam138) hseam139
                                                                                                                                                                                                                                                                                      · by_cases hseam140 : ρ.im ≤ (gB139Lo : ℝ)
                                                                                                                                                                                                                                                                                        · exact h140 ρ hz (not_le.mp hseam139) hseam140
                                                                                                                                                                                                                                                                                        · by_cases hseam141 : ρ.im ≤ (gB140Lo : ℝ)
                                                                                                                                                                                                                                                                                          · exact h141 ρ hz (not_le.mp hseam140) hseam141
                                                                                                                                                                                                                                                                                          · by_cases hseam142 : ρ.im ≤ (gB141Lo : ℝ)
                                                                                                                                                                                                                                                                                            · exact h142 ρ hz (not_le.mp hseam141) hseam142
                                                                                                                                                                                                                                                                                            · by_cases hseam143 : ρ.im ≤ (gB142Lo : ℝ)
                                                                                                                                                                                                                                                                                              · exact h143 ρ hz (not_le.mp hseam142) hseam143
                                                                                                                                                                                                                                                                                              · exact h144 ρ hz (not_le.mp hseam143) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 143-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE143 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..h144 : the 144 verified window-slice clauses - the cited slices + the RE-CITED full slices for the re-anchored windows 43..142 (bit-identical seams, recorded data, incl. the recorded Rosser failure blocks of the re-anchored windows - all determined and rescued) + h144 : the window-143 terminal slice (FULL 20 000, CLEAN - zero recorded interior failures)). This is the finite-height closure through the corrected w1-w143 band (W42b fill) re-anchored to all of the certified ONE-HUNDRED-FORTY-THIRD window (FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total)); census 2 859 992 over (g_a1, g_b143] - the 2 620 000 CERTIFIED-ZERO MARK (CROSSED in W132 [0465]) carries margin 239 992; the 2 600 000 CERTIFIED-ZERO MARK (CROSSED in W131 [0464]) carries margin 259 992; the 2 580 000 CERTIFIED-ZERO MARK (CROSSED in W130 [0463]) carries margin 279 992; the 2 560 000 CERTIFIED-ZERO MARK (CROSSED in W129 [0462]) carries margin 299 992; the 2 540 000 CERTIFIED-ZERO MARK (CROSSED in W128 [0461]) carries margin 319 992; the 2 520 000 CERTIFIED-ZERO MARK (CROSSED in W127 [0460]) carries margin 339 992; the 2 500 000 CERTIFIED-ZERO MARK (CROSSED in W126 [0459]) carries margin 359 992; the 2 480 000 CERTIFIED-ZERO MARK (CROSSED in W125 [0458]) carries margin 379 992; the 2 460 000 CERTIFIED-ZERO MARK (CROSSED in W124 [0457]) carries margin 399 992; the 2 440 000 CERTIFIED-ZERO MARK (CROSSED in W123 [0456]) carries margin 419 992; the 2 420 000 CERTIFIED-ZERO MARK (CROSSED in W122 [0455]) carries margin 439 992; the 2 400 000 CERTIFIED-ZERO MARK (CROSSED in W121 [0454]) carries margin 459 992; the 2 380 000 CERTIFIED-ZERO MARK (CROSSED in W120 [0453]) carries margin 479 992; the 2 360 000 CERTIFIED-ZERO MARK (CROSSED in W119 [0452]) carries margin 499 992; the 2 340 000 CERTIFIED-ZERO MARK (CROSSED in W118 [0451]) carries margin 519 992; the 2 320 000 CERTIFIED-ZERO MARK (CROSSED in W117 [0450]) carries margin 539 992; the 2 300 000 CERTIFIED-ZERO MARK (CROSSED in W116 [0449]) carries margin 559 992; the 2 280 000 CERTIFIED-ZERO MARK (CROSSED in W115 [0448]) carries margin 579 992; the 2 260 000 CERTIFIED-ZERO MARK (CROSSED in W114 [0447]) carries margin 599 992; the 2 240 000 CERTIFIED-ZERO MARK (CROSSED in W113 [0446]) carries margin 619 992; the 2 220 000 CERTIFIED-ZERO MARK (CROSSED in W112 [0445]) carries margin 639 992; the 2 200 000 CERTIFIED-ZERO MARK (CROSSED in W111 [0444]) carries margin 659 992; the 2 180 000 CERTIFIED-ZERO MARK (CROSSED in W110 [0443]) carries margin 679 992; the 2 160 000 CERTIFIED-ZERO MARK (CROSSED in W109 [0442]) carries margin 699 992; the 2 140 000 CERTIFIED-ZERO MARK (CROSSED in W108 [0441]) carries margin 719 992; the 2 120 000 CERTIFIED-ZERO MARK (CROSSED in W107 [0440]) carries margin 739 992; the 2 100 000 CERTIFIED-ZERO MARK (CROSSED in W106 [0439]) carries margin 759 992; the 2 080 000 CERTIFIED-ZERO MARK (CROSSED in W105 [0438]) carries margin 779 992; the 2 060 000 CERTIFIED-ZERO MARK (CROSSED in W104 [0437]) carries margin 799 992; the 2 040 000 CERTIFIED-ZERO MARK (CROSSED in W103 [0436]) carries margin 819 992; the 2 020 000 CERTIFIED-ZERO MARK (CROSSED in W101 [0431]) carries margin 839 992; the 1 980 000 CERTIFIED-ZERO MARK (CROSSED in W99 [0420]) carries margin 879 992; the 1 960 000 CERTIFIED-ZERO MARK (CROSSED in W98 [0419]) carries margin 899 992; the 1 940 000 CERTIFIED-ZERO MARK (CROSSED in W97 [0418]) carries margin 919 992; the 1 920 000 CERTIFIED-ZERO MARK (CROSSED in W96) carries margin 939 992; the 1 900 000 CERTIFIED-ZERO MARK (CROSSED in W95 [0410]) carries margin 959 992; the 1 880 000 CERTIFIED-ZERO MARK (CROSSED in W93) carries margin 979 992; the 1 860 000 CERTIFIED-ZERO MARK (CROSSED in W92 [0403]) carries margin 999 992; the 1 840 000 CERTIFIED-ZERO MARK (CROSSED in W91 [0402]) carries margin 1 019 992; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 1 059 992; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 1 159 992; the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 1 259 992; the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's target; margin at WINDOW 143: 859 992) - the frontier extension continues beyond the target (post-target phase, no new program claim); the 2 860 000 CERTIFIED-ZERO mark is 8 zeros ahead (it lands at the start of the NEXT window - do not pre-announce). NO RH CLAIM about the face above tCE143. -/
theorem allOnLineUpToCE143 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClauseFull) (hW101 : ce100WinClauseFull) (hW102 : ce101WinClauseFull) (hW103 : ce102WinClauseFull) (hW104 : ce103WinClauseFull) (hW105 : ce104WinClauseFull) (hW106 : ce105WinClauseFull) (hW107 : ce106WinClauseFull) (hW108 : ce107WinClauseFull) (hW109 : ce108WinClauseFull) (hW110 : ce109WinClauseFull) (hW111 : ce110WinClauseFull) (hW112 : ce111WinClauseFull) (hW113 : ce112WinClauseFull) (hW114 : ce113WinClauseFull) (hW115 : ce114WinClauseFull) (hW116 : ce115WinClauseFull) (hW117 : ce116WinClauseFull) (hW118 : ce117WinClauseFull) (hW119 : ce118WinClauseFull) (hW120 : ce119WinClauseFull) (hW121 : ce120WinClauseFull) (hW122 : ce121WinClauseFull) (hW123 : ce122WinClauseFull) (hW124 : ce123WinClauseFull) (hW125 : ce124WinClauseFull) (hW126 : ce125WinClauseFull) (hW127 : ce126WinClauseFull) (hW128 : ce127WinClauseFull) (hW129 : ce128WinClauseFull) (hW130 : ce129WinClauseFull) (hW131 : ce130WinClauseFull) (hW132 : ce131WinClauseFull) (hW133 : ce132WinClauseFull) (hW134 : ce133WinClauseFull) (hW135 : ce134WinClauseFull) (hW136 : ce135WinClauseFull) (hW137 : ce136WinClauseFull) (hW138 : ce137WinClauseFull) (hW139 : ce138WinClauseFull) (hW140 : ce139WinClauseFull) (hW141 : ce140WinClauseFull) (hW142 : ce141WinClauseFull) (hW143 : ce142WinClauseFull) (hW144 : ce143WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE143 : ℝ) := by
  have hband := bandOfWindows143 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE ONE-HUNDRED-FORTY-THIRD RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the ONE-HUNDRED-FORTY-THIRD certified window (FULL 20 000 (no snap), CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total), b = 12 363 156 297 122, zero recorded interior Rosser failure blocks (CLEAN); census 2 859 992 over (g_a1, g_b143]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE143 : R) = 3,000,176,001,026 lies on the line - i.e. the absolute clause [S1] and A1 (no data-dependent bound on the S-at-zeros and DN walk) above the new lower bound. Frontier 668,226 above H0: the 615 000 mark (crossed W132 [0465]) carries 53 226; the 610 000 mark (crossed W131 [0464]) carries 58 226; the 605 000 mark (crossed W130 [0463]) carries 63 226; the 600 000 mark (crossed W129 [0462]) carries 68 226; the 595 000 mark (crossed W128 [0461]) carries 73 226; the 590 000 mark (crossed W127 [0460]) carries 78 226; the 585 000 mark (crossed W126 [0459]) carries 83 226; the 580 000 mark (crossed W125 [0458]) carries 88 226; the 575 000 mark (crossed W124 [0457]) carries 93 226; the 570 000 mark (crossed W122 [0455]) carries 98 226; the 565 000 mark (crossed W121 [0454]) carries 103 226; the 560 000 mark (crossed W120 [0453]) carries 108 226; the 555 000 mark (crossed W119 [0452]) carries 113 226; the 550 000 mark (crossed W118 [0451]) carries 118 226; the 545 000 mark (crossed W117 [0450]) carries 123 226; the 540 000 mark (crossed W116 [0449]) carries 128 226; the 535 000 mark (crossed W115 [0448]) carries 133 226; the 530 000 mark (crossed W114 [0447]) carries 138 226; the 525 000 mark (crossed W113 [0446]) carries 143 226; the 520 000 mark (crossed W112 [0445]) carries 148 226; the 515 000 mark (crossed W111 [0444]) carries 153 226; the 510 000 mark (crossed W110 [0443]) carries 158 226; the 505 000 mark (crossed W109 [0442]) carries 163 226; the 500 000 mark (crossed W107 [0440]) carries 168 226; the 495 000 mark (crossed W106 [0439]) carries 173 226; the 490 000 mark (crossed W105 [0438]) carries 178 226; the 485 000 mark (crossed W104 [0437]) carries 183 226; the 480 000 mark (crossed W103 [0436]) carries 188 226; the 475 000 mark (crossed W102 [0434]) carries 193 226; the 470 000 mark (crossed W101 [0431]) carries 198 226; the 465 000 mark (crossed W99 [0420]) carries 203 226; the 460 000 mark (crossed W98 [0419]) carries 208 226; the 455 000 mark (crossed W97 [0418]) carries 213 226; the 450 000 mark (crossed W96) carries 218 226; the 445 000 mark (crossed W95 [0410]) carries 223 226; the 440 000 mark (crossed W94 [0406]) carries 228 226; the 435 000 mark (crossed W93 [0405]) carries 233 226; the 430 000 mark (crossed W92 [0403]) carries 238 226; the 425 000 mark (crossed W90 [0401], the FOURTH PREDICTION of the series) carries 243 226; the 400 000 mark (crossed W85 [0396], third prediction) carries 268 226; the 375 000 mark (crossed W80, second prediction) carries 293 226; the 350 000 mark (crossed W74, first prediction) carries 318 226; the 325 000 mark (crossed W69) carries 343 226; the 300 000 mark (crossed W64) carries 368 226; the next round mark 670 000 is 1 774 ahead (less than one half-step); the 2 620 000 CERTIFIED-ZERO MARK (CROSSED in W132 [0465]) carries margin 239 992; the 2 600 000 CERTIFIED-ZERO MARK (CROSSED in W131 [0464]) carries margin 259 992; the 2 580 000 CERTIFIED-ZERO MARK (CROSSED in W130 [0463]) carries margin 279 992; the 2 560 000 CERTIFIED-ZERO MARK (CROSSED in W129 [0462]) carries margin 299 992; the 2 540 000 CERTIFIED-ZERO MARK (CROSSED in W128 [0461]) carries margin 319 992; the 2 520 000 CERTIFIED-ZERO MARK (CROSSED in W127 [0460]) carries margin 339 992; the 2 500 000 CERTIFIED-ZERO MARK (CROSSED in W126 [0459]) carries margin 359 992; the 2 480 000 CERTIFIED-ZERO MARK (CROSSED in W125 [0458]) carries margin 379 992; the 2 460 000 CERTIFIED-ZERO MARK (CROSSED in W124 [0457]) carries margin 399 992; the 2 440 000 CERTIFIED-ZERO MARK (CROSSED in W123 [0456]) carries margin 419 992; the 2 420 000 CERTIFIED-ZERO MARK (CROSSED in W122 [0455]) carries margin 439 992; the 2 400 000 CERTIFIED-ZERO MARK (CROSSED in W121 [0454]) carries margin 459 992; the 2 380 000 CERTIFIED-ZERO MARK (CROSSED in W120 [0453]) carries margin 479 992; the 2 360 000 CERTIFIED-ZERO MARK (CROSSED in W119 [0452]) carries margin 499 992; the 2 340 000 CERTIFIED-ZERO MARK (CROSSED in W118 [0451]) carries margin 519 992; the 2 320 000 CERTIFIED-ZERO MARK (CROSSED in W117 [0450]) carries margin 539 992; the 2 300 000 CERTIFIED-ZERO MARK (CROSSED in W116 [0449]) carries margin 559 992; the 2 280 000 CERTIFIED-ZERO MARK (CROSSED in W115 [0448]) carries margin 579 992; the 2 260 000 CERTIFIED-ZERO MARK (CROSSED in W114 [0447]) carries margin 599 992; the 2 240 000 CERTIFIED-ZERO MARK (CROSSED in W113 [0446]) carries margin 619 992; the 2 220 000 CERTIFIED-ZERO MARK (CROSSED in W112 [0445]) carries margin 639 992; the 2 200 000 CERTIFIED-ZERO MARK (CROSSED in W111 [0444]) carries margin 659 992; the 2 180 000 CERTIFIED-ZERO MARK (CROSSED in W110 [0443]) carries margin 679 992; the 2 160 000 CERTIFIED-ZERO MARK (CROSSED in W109 [0442]) carries margin 699 992; the 2 140 000 CERTIFIED-ZERO MARK (CROSSED in W108 [0441]) carries margin 719 992; the 2 120 000 CERTIFIED-ZERO MARK (CROSSED in W107 [0440]) carries margin 739 992; the 2 100 000 CERTIFIED-ZERO MARK (CROSSED in W106 [0439]) carries margin 759 992; the 2 080 000 CERTIFIED-ZERO MARK (CROSSED in W105 [0438]) carries margin 779 992; the 2 060 000 CERTIFIED-ZERO MARK (CROSSED in W104 [0437]) carries margin 799 992; the 2 040 000 CERTIFIED-ZERO MARK (CROSSED in W103 [0436]) carries margin 819 992; the 2 020 000 CERTIFIED-ZERO MARK (CROSSED in W101 [0431]) carries margin 839 992; the 1 980 000 CERTIFIED-ZERO MARK (CROSSED in W99 [0420]) carries margin 879 992; the 1 960 000 CERTIFIED-ZERO MARK (CROSSED in W98 [0419]) carries margin 899 992; the 1 940 000 CERTIFIED-ZERO MARK (CROSSED in W97 [0418]) carries margin 919 992; the 1 920 000 CERTIFIED-ZERO MARK (CROSSED in W96) carries margin 939 992; the 1 900 000 CERTIFIED-ZERO MARK (CROSSED in W95 [0410]) carries margin 959 992; the 1 880 000 CERTIFIED-ZERO MARK (CROSSED in W93) carries margin 979 992; the 1 860 000 CERTIFIED-ZERO MARK (CROSSED in W92 [0403]) carries margin 999 992; the 1 840 000 CERTIFIED-ZERO MARK (CROSSED in W91 [0402]) carries margin 1 019 992; the 1 800 000 CERTIFIED-ZERO MARK (CROSSED in W90 [0401]) carries margin 1 059 992; the 1 700 000 CERTIFIED-ZERO MARK (CROSSED in W85 [0396]) carries margin 1 159 992; the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 1 259 992; the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's target; margin at WINDOW 143: 859 992) - the frontier extension continues beyond the target (post-target phase, no new program claim); the 2 860 000 CERTIFIED-ZERO mark is 8 zeros ahead (it lands at the start of the NEXT window - do not pre-announce). The increment tCE143 - tCE142 = 4673 (the STANDARD 4 673 floor increment (eighth consecutive standard step after W135's sub-standard 4 672; recorded data, no pattern claim)). The face is RE-ANCHORED (the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE143 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE143 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE89 -> ... -> tCE142 -> tCE143) leaves the face IMPLICATOR - anything true above tCE142 is true above tCE143. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE142_implies_faceCE143 (q : ZeroSet)
    (hface : CE142.terminalFaceCE142 q) :
    terminalFaceCE143 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE142_lt_tCE143, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW143, hW144): terminalFaceCE143 q <-> terminalFaceCE142 q. The re-anchor adds no strength and loses none - what was open at tCE142 is (exactly) what is open at tCE143, and the slice family (gB142Lo, tCE143] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE142 pattern). The forward direction splits on 'Im s <= tCE96': the band slice (gB142Lo, tCE143] is handled by the verified window slices hW143, hW144 (the W142 slice is FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 four-glyph, adjudication-confirmed), re-cited in full at gB142; the W143 slice is FULL 20 000, CLEAN - zero recorded interior failures (certificate by sign-change total)), the part above tCE142 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE143_iff_faceCE142 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW143 : ce142WinClauseFull) (hW144 : ce143WinClause) :
    terminalFaceCE143 q ↔ CE142.terminalFaceCE142 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE143 : ℝ)
    · by_cases hseam143 : ρ.im ≤ (gB142Lo : ℝ)
      · exact hW143 ρ (hqz ρ hρ) (by linarith [ht, CE142.gB141Lo_lt_tCE142, tCE142_lt_tCE143]) hseam143
      · exact hW144 ρ (hqz ρ hρ) (not_le.mp hseam143) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE142_implies_faceCE143 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE143) x (terminalFaceCE143 q) - finite-height closure (now through the corrected w1-w96 band with the W42b fill, re-anchored windows 43..143 all bit-identical at their seams; window 143 certified FULL 20 000, CLEAN - zero recorded interior failures (certificate by sign-change total)) AND the absolute clause above tCE143. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE143 - tPT2 = 668 226 - the 615 000 UNIT ROUND MARK (crossed W132 [0465]) carries 53 226, the next round mark 670 000 is 1 774 ahead (less than one half-step); census 2 859 992 - census extension past the landed target: 2 859 992 certified (2 839 992 + 20,000); the 2 000 000 CERTIFIED-ZERO MARK LANDED at WINDOW 100 [0421] (the census program's target; margin at WINDOW 143: 859 992); the 2 860 000 CERTIFIED-ZERO mark is 8 zeros ahead (it lands at the start of the NEXT window - do not pre-announce)). -/
theorem rh_split_at_CE143 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE143 : ℝ) ∧ terminalFaceCE143 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE143 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE143 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE96): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW97 : the 144 verified window-slice clauses - windows 1..143, incl. the re-anchored 43..143 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each - all ultimately determined; W78: SNAPPED 19 999, one recorded failure; W82: SNAPPED 19 999, two recorded failures - both determined; W83: NON-SNAPPED 20 000, three recorded blocks - all determined; W84: NON-SNAPPED 20 000, one recorded block - determined; W85: NON-SNAPPED 20 000, one recorded block - determined; W86: NON-SNAPPED 20 000, two recorded blocks - both determined; W87: SNAPPED 19 999, CLEAN - zero failures; W88: NON-SNAPPED 20 000, one recorded interior block - determined; W89: NON-SNAPPED 20 000, CLEAN - zero failures; W90: NON-SNAPPED 20 000, two recorded interior blocks - both determined; W91: NON-SNAPPED 20 000, CLEAN - zero failures; W92: NON-SNAPPED 20 000, CLEAN - zero failures; W93: SNAPPED 19 999, one recorded interior block - determined and rescued; W94: NON-SNAPPED 20 000, CLEAN - zero failures; W95: NON-SNAPPED 20 000, two recorded interior blocks - both determined and rescued; W96: NON-SNAPPED 20 000, CLEAN - zero failures; W97: SNAPPED 19 997, THREE recorded interior failures - all determined and rescued; W98: NON-SNAPPED 20 000, THREE recorded interior Rosser failures (determined at m = 64; the rescue probe's FOUND 5 union counts RE-CONFIRMED by the 0424 fresh-mpmath adjudication - fresh 5 / 5 / 5, no near-zero touch); W99: NON-SNAPPED 20 000, CLEAN - zero failures; W100: TAIL 21, CLEAN - zero failures; W101: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the 0431 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero touch); W102: SNAPPED 19 999 (the requested 20 000 snapped back one gram at the b-end), CLEAN - zero recorded interior failures; W103: SNAPPED 19 997 (the requested 20 000 snapped back three grams at the b-end), CLEAN - zero recorded interior failures; W104: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the 0437 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 6 / 6, no near-zero touch, 4/4 control spans pass); W105: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the 0438 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero touch, 4/4 control spans pass); W106: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the 0439 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero touch, 4/4 control spans pass); W107: SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined and rescued; the 0440 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 4 / 4, no near-zero touch, 4/4 control spans pass); W108: NON-SNAPPED 20 000, THREE recorded interior Rosser failures - all determined and rescued; the 0441 fresh-mpmath adjudication RE-CONFIRMS ALL THREE rescue counts (fresh 5 / 5, 5 / 5, 5 / 5, no near-zero touch, 4/4 control spans pass) - the first multi-failure window of the program; W109: NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued; the 0442 fresh-mpmath adjudication RE-CONFIRMS the rescue count (fresh 5 / 5, no near-zero touch, 4/4 control spans pass); W110: SNAPPED 19 999 (one-gram b-end snap), CLEAN - zero interior Rosser failure blocks (nothing to adjudicate; certificate by sign-change total) - the first clean window since W103; W111: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; second consecutive clean window); W112: FULL 20 000, THREE recorded interior Rosser failures - all determined and rescued, adjudication-confirmed (fresh 4/4, 5/5, 4/4; Tenth full W97-family protocol cycle); W113: SNAPPED 19 999 (one-gram b-end snap), ONE recorded interior Rosser failure - determined and rescued, adjudication-confirmed (fresh 5/5; ELEVENTH W97-family protocol cycle); W114: FULL 20 000, ONE recorded interior Rosser failure - determined and rescued, adjudication-confirmed (fresh 4/4; TWELFTH W97-family protocol cycle); W115: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; third clean window of the post-target series); W116: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued, adjudication-confirmed (fresh 4/4, 4/4; THIRTEENTH W97-family protocol cycle; first two-failure window of the post-target series); W117: FULL 20 000, ONE recorded interior Rosser failure - determined, rescued on a wide six-glyph union (5/5), adjudication-confirmed (fresh 5/5; FOURTEENTH W97-family protocol cycle); W118: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; fourth clean window of the post-target series); W119: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; fifth clean window of the post-target series); W120: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (7/7 on an eight-glyph union - the first four-gram block and widest rescue of the series, and 4/4), adjudication-confirmed (FIFTEENTH W97-family protocol cycle); W121: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued on wide six-glyph unions (5/5, 5/5), adjudication-confirmed (fresh 5/5, 5/5; SIXTEENTH W97-family protocol cycle; third two-failure window); W122: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4, 6/6 on the series' first seven-glyph union; SEVENTEENTH W97-family protocol cycle; fourth two-failure window); W123: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4; EIGHTEENTH W97-family protocol cycle); W124: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4, 7/7 on the second eight-glyph union; NINETEENTH W97-family protocol cycle; fifth two-failure window); W125: FULL 20 000, ONE recorded interior Rosser failure block - four-gram (second of the series), determined and rescued (fresh 5/5 on a six-glyph union); TWENTIETH W97-family protocol cycle; W126: ONE-GRAM SNAP 19 999, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a five-glyph union); TWENTY-FIRST W97-family protocol cycle; W127: FULL 20 000, TWO recorded interior Rosser failure blocks - the THIRD four-gram of the series among them - both determined and rescued (fresh 4/4, 5/5); TWENTY-SECOND W97-family protocol cycle; seventh two-failure window; W128: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5 on a six-glyph union); TWENTY-THIRD W97-family protocol cycle; W129: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a five-glyph union); TWENTY-FOURTH W97-family protocol cycle; W130: FULL 20 000, TWO recorded interior Rosser failure blocks (one of them the fourth four-gram of the series) - both determined and rescued (fresh 7/7 on an eight-glyph union, 4/4 on a five-glyph union); TWENTY-FIFTH W97-family protocol cycle; W131: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 6/6 on a seven-glyph union); TWENTY-SIXTH W97-family protocol cycle; W132: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; sixth clean window of the post-target series); W133: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5 on a six-glyph union); TWENTY-SEVENTH W97-family protocol cycle; W134: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; seventh clean window of the post-target series); W135: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 7/7 on an eight-glyph union, the first eight-glyph of the series); TWENTY-EIGHTH + TWENTY-NINTH W97-family protocol cycles; W136: FULL 20 000, CLEAN - zero interior Rosser failure blocks (certificate by sign-change total; eighth clean window of the post-target series); W137: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 4/4 on a five-glyph union); THIRTIETH + THIRTY-FIRST W97-family protocol cycles; W138: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a five-glyph union); THIRTY-SECOND W97-family protocol cycle; W139: FULL 20 000, TWO recorded interior Rosser failure blocks - both determined and rescued (fresh 4/4 on a five-glyph union + fresh 5/5 on a six-glyph union); THIRTY-THIRD + THIRTY-FOURTH W97-family protocol cycles; W140: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 6/6 on a six-glyph union); THIRTY-FIFTH W97-family protocol cycle; W141: FULL 20 000, THREE recorded interior Rosser failure blocks - all determined and rescued (fresh 4/4 on each four-glyph union); THIRTY-SIXTH + THIRTY-SEVENTH + THIRTY-EIGHTH W97-family protocol cycles; W142: FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 4/4 on a four-glyph union); THIRTY-NINTH W97-family protocol cycle; W143: FULL 20 000, CLEAN - zero recorded interior Rosser failure blocks (certificate by sign-change total))), RH is equivalent to the NAMED terminal face above tCE143 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w143 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..143, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE143 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClauseFull) (hW101 : ce100WinClauseFull) (hW102 : ce101WinClauseFull) (hW103 : ce102WinClauseFull) (hW104 : ce103WinClauseFull) (hW105 : ce104WinClauseFull) (hW106 : ce105WinClauseFull) (hW107 : ce106WinClauseFull) (hW108 : ce107WinClauseFull) (hW109 : ce108WinClauseFull) (hW110 : ce109WinClauseFull) (hW111 : ce110WinClauseFull) (hW112 : ce111WinClauseFull) (hW113 : ce112WinClauseFull) (hW114 : ce113WinClauseFull) (hW115 : ce114WinClauseFull) (hW116 : ce115WinClauseFull) (hW117 : ce116WinClauseFull) (hW118 : ce117WinClauseFull) (hW119 : ce118WinClauseFull) (hW120 : ce119WinClauseFull) (hW121 : ce120WinClauseFull) (hW122 : ce121WinClauseFull) (hW123 : ce122WinClauseFull) (hW124 : ce123WinClauseFull) (hW125 : ce124WinClauseFull) (hW126 : ce125WinClauseFull) (hW127 : ce126WinClauseFull) (hW128 : ce127WinClauseFull) (hW129 : ce128WinClauseFull) (hW130 : ce129WinClauseFull) (hW131 : ce130WinClauseFull) (hW132 : ce131WinClauseFull) (hW133 : ce132WinClauseFull) (hW134 : ce133WinClauseFull) (hW135 : ce134WinClauseFull) (hW136 : ce135WinClauseFull) (hW137 : ce136WinClauseFull) (hW138 : ce137WinClauseFull) (hW139 : ce138WinClauseFull) (hW140 : ce139WinClauseFull) (hW141 : ce140WinClauseFull) (hW142 : ce141WinClauseFull) (hW143 : ce142WinClauseFull) (hW144 : ce143WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE143 q := by
  have hcensus := allOnLineUpToCE143 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144 hqz
  have hsplit := rh_split_at_CE143 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE143 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : ce95WinClauseFull) (hW97 : ce96WinClauseFull) (hW98 : ce97WinClauseFull) (hW99 : ce98WinClauseFull) (hW100 : ce99WinClauseFull) (hW101 : ce100WinClauseFull) (hW102 : ce101WinClauseFull) (hW103 : ce102WinClauseFull) (hW104 : ce103WinClauseFull) (hW105 : ce104WinClauseFull) (hW106 : ce105WinClauseFull) (hW107 : ce106WinClauseFull) (hW108 : ce107WinClauseFull) (hW109 : ce108WinClauseFull) (hW110 : ce109WinClauseFull) (hW111 : ce110WinClauseFull) (hW112 : ce111WinClauseFull) (hW113 : ce112WinClauseFull) (hW114 : ce113WinClauseFull) (hW115 : ce114WinClauseFull) (hW116 : ce115WinClauseFull) (hW117 : ce116WinClauseFull) (hW118 : ce117WinClauseFull) (hW119 : ce118WinClauseFull) (hW120 : ce119WinClauseFull) (hW121 : ce120WinClauseFull) (hW122 : ce121WinClauseFull) (hW123 : ce122WinClauseFull) (hW124 : ce123WinClauseFull) (hW125 : ce124WinClauseFull) (hW126 : ce125WinClauseFull) (hW127 : ce126WinClauseFull) (hW128 : ce127WinClauseFull) (hW129 : ce128WinClauseFull) (hW130 : ce129WinClauseFull) (hW131 : ce130WinClauseFull) (hW132 : ce131WinClauseFull) (hW133 : ce132WinClauseFull) (hW134 : ce133WinClauseFull) (hW135 : ce134WinClauseFull) (hW136 : ce135WinClauseFull) (hW137 : ce136WinClauseFull) (hW138 : ce137WinClauseFull) (hW139 : ce138WinClauseFull) (hW140 : ce139WinClauseFull) (hW141 : ce140WinClauseFull) (hW142 : ce141WinClauseFull) (hW143 : ce142WinClauseFull) (hW144 : ce143WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE143 q) :
    RH q :=
  (rh_reanchored_CE143 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE143_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE143 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE143