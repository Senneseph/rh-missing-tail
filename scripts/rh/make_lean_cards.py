#!/usr/bin/env python
"""Generate formal/cards/*.md -- one concise card per .lean file.

Card = 5 lines max:  title (file, line count, status),  WHAT,
HOW,  USES,  optional GOTCHA.  72 chars max.  The whole set is
written to be read in ONE session (fresh-memory bootstrap after
compaction);  see  cards/README.md  for  the  protocol.
"""
import os
import textwrap

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                    "..", ".."))
OUT = os.path.join(ROOT, "formal", "cards")
SRC = os.path.join(ROOT, "formal", "RhAttack")
WIDTH = 72

# module: (what, how, uses, gotcha-or-None)
C = {
"A1Growth": (
 "A1 wire at the provable growth form (E19): the far-side S1 wire.",
 "a1_growth_wire_log: |DN j| <= CS log x_j + 1/x_j on the grid => "
 "far contribution <= (CS log x_M + 1)(17/2)(t^2/g1^2); pins are "
 "lean-proven arithmetic.",
 "terminal: the S1 zero-side wire; the E1 clause consumes this "
 "form.",
 None),
"Ap1ArgumentPrinciple": (
 "D4 ap1: the argument principle, ported.",
 "residueTheorem_finset, finite_zeros_rectangle, rectangleIntegral; "
 "counts zeros in a rectangle by the log-derivative integral.",
 "used by: Ap2CountByIntegral, Ap3MainTerm.",
 "ported from anthropics/formal-math (Apache-2.0); names stable."),
"Ap1Rectangle": (
 "D4 ap1: contour rectangle integrals (ported).",
 "43 theorems: RectangleBorder, Square, symmetry re/symm atoms for "
 "the rectangle contour.",
 "used by: Ap1Residue.",
 "ported; keep atoms exact (symm_re-style definitions are load-"),
"Ap1Residue": (
 "D4 ap1: rectangle residue computations (ported).",
 "56 theorems: HIntegral/VIntegral_symm, "
 "verticalIntegral_split_three, DiffVertRect_eq_UpperLowerUs.",
 "used by: Ap1ArgumentPrinciple, Ap3ZetaBounds.",
 None),
"Ap1Tactic": (
 "D4 ap1: tactic helpers (ported).",
 "pf_smul_c / c_smul_pf / smul_pf, elabAdditiveCombination: "
 "additive-combination elaboration for pf-smul rewrites.",
 "used by: Ap1Residue.",
 None),
"Ap2CountByIntegral": (
 "D4 ap2: counting zeros by integral (ported).",
 "completedRiemannZeta_eq_GammaR_mul etc.; count = integral of the "
 "completed log-derivative over the window.",
 "used by: Ap3Fold, Ap3NcountWindow, Ap3RvMDefs.",
 None),
"Ap2Counting": (
 "D4 ap2: window finiteness / finset counting (ported).",
 "window_finite, window_subset_carrier, ncard_le_finset_mult, "
 "finset_mult_mono.",
 "used by: Ap2Statement.",
 None),
"Ap2Defs": (
 "D4 ap2: the window definition layer (ported).",
 "70 defs (paperFT, l, ell1, Hfun...): window/weight vocabulary "
 "for the RvM count.",
 "used by: Ap2Counting, Ap2Statement.",
 None),
"Ap2Reflect": (
 "D4 ap2: conjugation / reflection (ported).",
 "riemannZeta_conj, analyticOrderAt_conj, ..._zeta_one_sub.",
 "used by: Ap2CountByIntegral.",
 None),
"Ap2Seam": (
 "D4 ap2: analyticity seam (ported).",
 "ZetaSeam: analyticOnNhd of C\\{1}, is_connected_compl_one, "
 "orderAt zeta ne top at 1.",
 "used by: Ap2CountByIntegral.",
 None),
"Ap2Statement": (
 "D4 ap2: the zero-count statement layer (ported).",
 "IsNontrivialZero, zeroMult, zerosIn, Ncount (19 theorems).",
 "used by: Ap2CountByIntegral, Ap2Seam, Ap2Reflect, Ap3Backlund, "
 "Ap3XiLogDeriv.",
 None),
"Ap3Backlund": (
 "D4 ap3: Backlund horizontal O(log T) bound (ported).",
 "hasDerivAt/continuous zeta_horizontal (19 theorems) => the "
 "horizontal O(log T) counting bound.",
 "used by: Ap3MainTerm, S1Point.",
 None),
"Ap3BacklundDefs": (
 "D4 ap3: real-zero-set defs (ported).",
 "reZeroSet, mem_reZeroSet.",
 "used by: Ap3Backlund.",
 None),
"Ap3Fold": (
 "D4 ap3: the Gamma/zeta product fold (ported).",
 "12 theorems: cpow_ofReal_conj, GammaR_conj, deriv/logDeriv "
 "GammaR_conj.",
 "used by: Ap3MainTerm, S1Point.",
 None),
"Ap3Growth": (
 "D4 ap3: growth wiring (ported).",
 "growth facts for the Backlund chain inputs.",
 "used by: Ap3Backlund.",
 None),
"Ap3GammaComplete": (
 "D4 ap3: assembled Gamma machinery (ported).",
 "gammaFacts, gammaFacts_of_stirling: the final gamma facts "
 "package.",
 "used by: S1Point.",
 None),
"Ap3GammaIntMu": (
 "D4 ap3: integral-mu gamma step (ported).",
 "the int-mu component of the gamma chain.",
 "used by: Ap3GammaComplete.",
 None),
"Ap3GammaMu": (
 "D4 ap3: mu-term gamma step (ported).",
 "the mu component of the gamma chain.",
 "used by: Ap3GammaComplete, Ap3GammaIntMu, Ap3GammaStirlingVert.",
 None),
"Ap3GammaSeries": (
 "D4 ap3: gamma series expansion (ported).",
 "series-expansion lemmas feeding Stirling.",
 "used by: Ap3GammaStirling.",
 None),
"Ap3GammaSide": (
 "D4 ap3: gamma side estimates (ported).",
 "the side bounds of the gamma chain.",
 "used by: Ap3MainTerm, S1Point.",
 None),
"Ap3GammaStirling": (
 "D4 ap3: Stirling for Gamma (ported).",
 "Stirling bounds feeding the mu step.",
 "used by: Ap3GammaMu.",
 None),
"Ap3GammaStirlingVert": (
 "D4 ap3: Stirling vertical part (ported).",
 "vertical-direction Stirling estimates.",
 "used by: Ap3GammaComplete.",
 None),
"Ap3Halving": (
 "Ap3 helper: window halving / reflection.",
 "reflect_injective/mem_window, N_le_two_mul_half.",
 "orphan helper of the Ap3 chain (not imported elsewhere).",
 None),
"Ap3Hypotheses": (
 "Ap3: shared hypotheses / atoms.",
 "the named hypotheses the whole Ap3 chain instantiates.",
 "used by: Ap3MainTerm, Ap3RvMDefs, Ap3RvMStatement, "
 "Ap3GammaComplete/Series/Side, S1Point.",
 None),
"Ap3LocalCount": (
 "Ap3: local count facts (good heights).",
 "local zero-count bounds on the window.",
 "used by: Ap3Backlund, Ap3MainTerm, Ap3RvMStatement.",
 None),
"Ap3MainTerm": (
 "Ap3: the main-term identity (ported).",
 "log zeta = main term + controlled remainder; the Ap3 "
 "centerpiece consumed by RvM and S1Point.",
 "used by: Ap3RvMStatement, S1Point.",
 None),
"Ap3NcountWindow": (
 "Ap3: Ncount at the window (ported).",
 "window Ncount facts from Ap2CountByIntegral.",
 "used by: Ap3MainTerm.",
 None),
"Ap3Prelude": (
 "Ap3: prelude for the strong-PNT prefix.",
 "shared atoms for Ap3StrongPNTPrefix.",
 "used by: Ap3StrongPNTPrefix.",
 None),
"Ap3ReZeroCount": (
 "Ap3: real-zero count (ported).",
 "counts real zeros for the Backlund chain.",
 "used by: Ap3Backlund.",
 None),
"Ap3RvMDefs": (
 "Ap3: RvM defs (ported).",
 "the RvM window/weight definitions (ap2-style) for Ap3.",
 "used by: Ap3Fold, Ap3GammaSide, Ap3MainTerm, Ap3NcountWindow.",
 None),
"Ap3RvMStatement": (
 "Ap3: the RvM window identity statement (ported).",
 "19 theorems: the RvM count identity at good heights.  This is "
 "the ap2/ap3 house-proven count identity feeding S1Point.",
 "terminal: the statement itself (consumed by S1Point's proof).",
 None),
"Ap3StrongPNTPrefix": (
 "Ap3: strong-PNT prefix (borelCaratheodory, cauchy).",
 "analytic machinery toward the PNT; the PNT itself is CITED "
 "beyond this prefix.",
 "terminal: cited-fact boundary layer.",
 "do not expect a proof of PNT past this prefix -- it is cited."),
"Ap3XiLogDeriv": (
 "Ap3: xi log-derivative (ported).",
 "log-derivative facts for xi feeding the main term.",
 "used by: Ap3Fold, Ap3MainTerm.",
 None),
"Ap3ZetaBounds": (
 "Ap3: zeta strip bounds (ported).",
 "bounds on zeta in the strip for the growth chain.",
 "used by: Ap3Growth.",
 None),
"Ap3ZetaConj": (
 "Ap3: zeta conjugation facts (ported).",
 "conjugation lemmas for the fold.",
 "used by: Ap3Fold.",
 None),
"B0": (
 "The composition root vocabulary.",
 "zero-set / strip / off-pair / margin primitives every "
 "composition module names things in.",
 "used by: Closure, E1Clause, P12Uniform, S1LowT, S4Growth, "
 "S4Window, SliverEdge, Z78P12, Z78Strip, ZetaZeroSet.",
 "the atom layer: keep definitionally stable (ring/atom "
 "mismatches are silent failure sources)."),
"B3": (
 "The B-3 bridge: residual split (zeta-free core).",
 "residual split of the bridge (see B3Core for primitives).",
 "used by: P8Floor.",
 "names stable across the day-016 move; see B3Core/B3Abel/B3Sbar."),
"B3Abel": (
 "B3: Abel-summation step.",
 "Abel steps for the S-bar primitives.",
 "used by: B3, B3Sbar.",
 None),
"B3Core": (
 "B3 primitives: the RVM flat density layer.",
 "twoPiInv, nHat (ln(x/2pi)/2pi), NHat (x/2pi(ln(x/2pi)-1)+7/8); "
 "fT model functions; regime e <= G <= B, 0 < t < G.",
 "used by: B3, B3Abel, B3Sbar, S4Growth, S4Strip, S4Window.",
 "twoPiInv is a canonical atom: log-arguments must keep using it."),
"B3Sbar": (
 "B3: S-bar primitives.",
 "P011/Q029/R229 atoms, Kbar_le, b3BoundExplicit.",
 "used by: B3.",
 None),
"B4": (
 "B4 core: the detector-line notation.",
 "halfR, sLine, fac, the rho*/sLine factor vocabulary (with "
 "Float gates).",
 "used by: B5, C1b, FloorUnif, SliverEdge.",
 "halfR = 1/2 is the bridge atom between B5 and S4O notations."),
"B5": (
 "B5: the concrete 4-factor own-detector.",
 "rhoPP/PM/NP/NM + sLine; poff (the four-factor product) -- the "
 "S2 own-detector quantity.",
 "used by: C1b, Closure, FloorUnif, P8Floor, S1LowT, SliverEdge, "
 "ZetaZeroSet.",
 "real-cast association differs from S4O: bridge via hhalf + "
 "Complex.ext (FloorUnif.poffIsOwnKerC)."),
"C1b": (
 "C1b: the branch locus IS the pole (window floors).",
 "c1b_den_group, c1b_R1_le_one, c1b_omega_pos; the t != g window "
 "floor and the discrete straddle floor (c1b_disc_floor); sliver "
 "record inputs.",
 "used by: S1LowT.",
 None),
"Closure": (
 "The 8-closure: margin -> RH.",
 "p9_closure_rh_of_margin: the 1987/1995 argument-reduction "
 "theorem; consumes whatever the record says at each point.",
 "used by: C1b, P12Uniform, S1LowT.",
 None),
 "E1Clause": (
 "E1 clause: the above-G data clauses (two-term V3, three-term "
 "V3C of 0154).",
 "V3: M_defect = -25256007 ln t + 523513775 (B = 7000, 21-row "
 "pin) on (G, 1000 G]. V3C (0154, window extended to "
 "9e20 by 0165 9e21 by 0168, 9e23 by 0176): M_defect3 = A3 ln t + B3 "
 "+ C3 t^2 on (G, 9e23]: A3 = -25254354, B3 = 523472285, C3 "
 "= "
 "-(ln(U/(2 pi)) + 1)/(2 pi U) in CLOSED FORM at the in-tree "
 "truncation U = U_TOP = 1e30 (defect_C3absT3: |C3| T3 <= "
 "2439/10^7); mdefect3_bounded: |M_defect3 t| <= 2.3e31; "
 "e1V3C_implies_abs + if_E1V3C_and_walk (same Qside contract).",
 "terminal (data clauses): two coexisting named holes above G - "
 "E1ClauseV3 q 7000 on (G, 1000 G], E1ClauseV3C q 100000000 on "
 "(G, 9e23] (40-row face: the 33 s9+s16+s17 rows through 9e18 "
 "+ the 7 s34 far rows at 3e19/3e20/9e20/3e21/9e21/3e23/9e23 "
 "same-N bare-zeta crosses (d: 3.28e-6 .. 1.25e-6), max residual 6.333622e7 at 9e23 "
 "-> 37% margin; 0164/0165/0167/0168/0174/0176); compose with the walk "
 "into RH.",
 "constants are DATA-SUPPORTED, not proven; C3's closed form is a "
 "model-level identity (I_far truncated at U_TOP), not a zeta "
 "theorem; re-gate only on new data."
 ),
"E2Barrier": (
 "E2 barrier (historical).",
 "envelope_dominates_total_variation, no_constant_closer; 3e10 "
 "band barrier check.",
 "orphan: terminal of that branch; superseded by the P12 "
 "decomposition.",
 None),
"E7a": (
 "E7a: the onset action (chi-5 oracle).",
 "chi5 character mod 5 + the onset core with #eval cross-checks.",
 "used by: B4.",
 None),
"EulerAction": (
 "The Euler action identity.",
 "APart, eulerActionLen, eulerAction: the action identity at the "
 "onset.",
 "used by: E7a.",
 None),
"FloorUnif": (
 "Floor unification: S2 floor == S4 own-mass.",
 "ownKerC/ownKerIsNorm; poffIsOwnKerC (B5 product = S4 kernel "
 "body); poffOwnMass (|poff| = mown); floWinCap (cap 23/1000); "
 "mownBelowFloWinCap (<= 6/t^2 <= 6e-4 on 1000 <= t); "
 "floStripMin_eq_mownOnBand; s4StripUnifiedFloor; s2ActualFullBand.",
 "terminal: the unified floor face; consumes Z78P12, S4Asm.",
 "exp(1/t^2) bounded by 3 via Real.exp_one_lt_three (norm_num "
 "cannot eval Real.exp in the pinned toolchain)."),
"M6": (
 "M6: the S3-side feed assembly.",
 "m6_feed, m6_feed_pos, m6_feed_dom: assembles S3a + W2M5 into "
 "the S3 definition-side feed.",
 "terminal: S3-side output of the composition.",
 None),
"MainBridge": (
 "The main-term bridge (Lean-certifiable).",
 "Ex_total, mainFac_reduced, zeta_eq_main_xi: zeta = main * xi "
 "with the exact main-term reduction.",
 "used by: E1Clause.",
 None),
"ProbeMargin6": (
 "Probe: the squeeze-wire core, standalone.",
 "margin6_unsat: NOT (Q >= dev - Mf AND dev >= flo AND Q <= Bf + Mr AND Bf + Mr + Mf < flo) for all real values - the p9_point_contradiction arithmetic re-proved with Mathlib ONLY (no RhAttack imports), confirming the squeeze core rests on no project definition.",
 "used by: (none - standalone cross-check).",
 "liveness audit of discovery 0089: the joint unsatisfiability is the LIVE engine (the contradiction is joint across four checkable legs, at an existing off-pair) - distinct from the 0088 dead form where it sat inside one leg."),
"S1Face": (
 "THE HS1 FACE: the walk's zero-side leg at an ACTUAL zero, and its named form at the audited band.",
 "hs1AtZero: with zeta(s) = 0 the A0 fill |zeta - K| collapses to |K|, so the S1Ge pointwise atom (0093) reads EXACTLY the walk's hs1 leg (Qside >= devOf - Mf) with the zero-side scale Q := |K| (the kernel magnitude at the zero), devW the deviation face, Mval the A4.3-wired mass bound - the hs1 leg is not a bare premise, it is the theorem with its data pins (devW, Mval) as the only input.  hs1FaceAtAudit: the named face of hs1 at the day-020 band in the spine's lettering - the zero-side claim X >= devWorst * (1 - mPin) and the data pin X <= devWorst / marginWorst are jointly incompatible (alias of QSide.section8_close_at_audit, exact-rational, 0091).  NO RH claim: the data pins (uniform in the height) are the checkable content the data program supplies; uniformity is the open measured track (25x), not claimed.",
 "used by: (the endpoint restatement pending - RHEnd's hs1 residual becomes 'S1Ge + pins' rather than a bare leg).",
 "the residual hs1 of RHEnd.rh_program78 is now EXPLICIT: S1Ge theorem + the dev/Mval pins (data) - the squeeze consumes the face's joint incompatibility with the resid pin."),
"S1Marg": (
 "THE HS1 UNIFORMITY TRACK:  the P1.1e best-straddle margin regime, pinned - where the day-020 audited band (S1Face) closes, the uniform-in-height measured track is pinned at its frontier.",
 "Pin pattern (MFa/B7F):  the 25 certified candidate heights of the P1.1e BEST-STRADDLE CLOSURE STATISTIC (the margin |zeta| * min_d |R-1| / (B + |zeta - K|) of the hs1 composite squeeze at the best straddle point of the window) are pinned from three certified runs:  the 1e7 run (14 candidates [999.7916, 249999.7765], per-t quadrature to 1e18), the 1e6 extension (4 candidates to [999999.7934]), the (1e7, 1e9] band scan (7 REAL-zero candidates [10000000.24, 28000000.1729], dps-30 per-t quadrature, tail = exact discrete sum over 47,517,736 LMFDB zeros (1e7, 3e7] + density quad (3e7, 1e18] + analytic remainder).  Lean pins the regime-deciding anchors (g125/m125 = 28.918 @ 125000.3524; g150/m150 = 38.053 @ 150000.2616, LAST certified >= 25; g200/m200 = 21.665 @ 199999.7053, FIRST certified < 25; g250/m250 = 15.504; g1e6/m1e6 = 13.068 @ 999999.7934; g1e7/m1e7 = 5.2362; g2e7/m2e7 = 1.4138, certified MINIMUM; g28e7/m28e7 = 1.7120 @ 28000000.1729, LAST certified) all as exact rationals from the printed 6-significant-figure record values.  THE GATES (margGates, one norm_num on the pins, exact rationals):  the 25x window (>= 25 at 125k/150k candidates, < 25 at 199999.7053 - closes between 1.5e5 and 2e5); the >= 15 class to 2.5e5; the >= 13 class to 1e6; the >= 1 class to 2.8e7 (min 1.4138 vs threshold 1 - 41% slack); the height order of the anchors; the DECAY order m125 > m250 > m1e6 > m1e7 > m2e7 - the regime degrades monotonically with height.  NAMED FACE (hs1MargFace, declared, b7OpenFace pattern):  for ANY zero set q and ANY margin statistic marg, every height carrying an off-pair zero has marg >= 1 - the open UNIFORM measured track of the hs1 leg (S1Face docstring: 'uniformity in the height is the open measured track'); the pinned gates are its measured shadow at the 25 certified candidates.  The 9 higher band-scan rows (3.1e7-1e9, margins < 1) are EXPLORATORY (nominal decade points, density-only tails, NOT real zeros) - recorded as the signal that the composite is the limiting object above the certified regime, never cited as measurements.",
 "used by: (none yet) - the measured constraint the hs1 uniformity track must reproduce (PATHWAY section 3); consumer candidate: a future endpoint restatement with hs1 uniform below the certified band.",
 "pins are the PRINTED 6-significant-figure values - every gate is slack against the last printed digit (min gap 1.4138 vs 1); the 'exp' rows must never be cited as measurements at real zeros; the statistic is the BEST-STRADDLE margin (the composite squeezes at the best straddle point of the window), not the worst-over-window margin (a P1.1c-class statistic)."),
"S1Ge": (
 "THE S1 >= SIDE ATOM: the walk's zero-side leg at its pointwise core.",
 "s1_ge_side: with the finite-kernel gap |K - (P_n - I)| <= Mval (the A4.3-wired mass, P8Floor p8_residual_wired under |x| <= Xval) and the deviation face devW <= |W_n| (the measured kernel change at the pair's own height via the A2c cited bridge), the zero-side fill |zeta(s) - K| (the A0 same object |def - zero|, P8Floor p8_same_object) dominates devW - Mval - the hs1 leg (Qside >= devOf - Mf) at its pointwise core.  Proof: reverse triangle (Wn = (zeta - K) + r, norm_add_le) + linarith over the four linear facts; the A2c bridge |W_n| = |em_expr| is CITED (DLMF 25.2.8 / Apostol 12.21) - the dev face reads |W_n| through it.  Per the P1.2 spec S1 row: LEAN-PROVEN POINTWISE under the mass premise - the OPEN part the spec names (uniformity of the premise in the height) is the measured track (P1.1e margin regime), NOT claimed.  No RH claim.",
 "used by: (face modules pending - the low-band/audit-band hs1 data faces instantiate the atom upstream).",
 "the hs1 leg of the endpoint remains a NAMED residual supported face-by-face by the data program - this module is the pointwise atom only."),
"LowExcl": (
 "THE LOW-BAND OFF-PAIR EXCLUSION: the squeeze, stated as an impossibility about the zero set at the endpoint.",
 "endpointWireLow / endpointWireLowFull: the endpoint's Z78P12 wire aliases (BwireP + MrP, + MfP) are 0 below the program strip (LowWires' definitional-zero shape pulled through the aliases; MfP = 0).  lowBandLegsFalse: at a low-band point (0 < t0 < 1000, 0 < d0 <= 1/2) the endpoint's three low-band legs in the EXACT endpoint leg form - hs1 (Qside >= RHEnd.devProg), hS2low (devProg >= p8_f_near_pin), hs3 (Qside <= BwireP + MrP) - are jointly contradictory (0.9975 <= devProg <= Qside <= 0), engine LowWires.lowBandSqueezeShape.  offPairExcludedLowBand: the corollary - no zero set carries an off-pair at any low-band height while the three legs hold there; the d0 > 1/2 half of the low band is vacuous from [Z78] alone (Z78P12.offPairFarEmpty, carried in the RHEnd body, not here).  NO RH claim: the module proves what the endpoint's named legs imply in the low band.",
 "used by: (none yet - the exclusion corollary the endpoint's low-band residual legs instantiate; LowWires supplies the wire shape, QSide the data-face vocabulary).",
 "the three low-band legs (hs1 / hS2low / hs3) remain NAMED residual faces of RHEnd.rh_program78 - but their JOINT obligation at every off-pair SELF-EXCLUDES low-band off-pairs by pure logic (no datum needed: the contradiction fires for ANY Qside, ANY devProg); the data program only feeds the legs for off-pairs at 1000 and above (audited band / window pin / [Z78]-vacuous far region apart from the named blind spot)."),
"LowWires": (
 "The LOW-BAND wire shape of the endpoint, machine-proven.",
 "Below the program strip (t0 < 1000) the R-wires are DEFINITIONALLY zero (bwireR_low_zero, mrr_low_zero, mfr_zero, wireSumLow) and the endpoint floor is the near pin (floProg_low_pin : floProg = 0.9975; devProg_low : devProg = devStripMin); s4low_trivial (the S4 low leg: 0 < 0.9975, standalone form of RHEnd's in-body hs4low_pin); lowBandSqueezeShape: the three nontrivial low-band legs are JOINTLY contradictory at any low-band off-pair (0.9975 <= devStripMin <= Qside <= 0 -> False) - the live squeeze engine at the low-band wire configuration, sibling of QSide.section8_close_at_audit.",
 "used by: LowExcl (endpointWireLow / endpointWireLowFull via bwireR_low_zero / mrr_low_zero; lowBandLegsFalse via lowBandSqueezeShape) - the shape module the low-band exclusion runs on.",
 "the legs stay the NAMED residual of the endpoint (hs1 = C2 >= side face, hS2low = the day-030 floor pin, hs3 = the zero-wire shape); this module pins only the wire SHAPE they run on - no RH claim."),
"QSide": (
 "The zero-side scale Qside, NAMED DATA FACE (day-020 audit band).",
 "Qside (the walk-spine Q of discovery 0088) IS the measured |zeta| fill resid(t) = |zeta(1/2 + it) - K_on(t)| (the s10 LHS, A0 same-object), day-020 record: 4 candidate pairs, straddle window 12, overall worst t = 1006.7916 with resid = 0.08168, dev = 9.198, margin 112.6; Xval pin |x| = 0.019253844165493 <= xvalPin = 3.9665418656908, headroom 206x.  Gates (LEAN-PROVEN, exact-rational norm_num + Float #eval): gate_worst_margin (112.6x squeeze gap), gate_xval_headroom, gate_resid_below_dev (route-A), gate_def_dominates_fill (48x), bundled in qsideFaceGated; Part E: mPin = 1/112.6 (the C4 margin pin) + mPin_lt_half + section8_close_at_audit (LEAN-PROVEN: the section-8 closure arithmetically closes at the day-020 pins - no real X with the C2 lower bound dev*(1 - mPin) AND the C3 margin bound dev/marginWorst; the engine's contradiction instantiated at the data face).",
 "used by: (none yet - the face module; the C6 audit-point package of Closure.lean consumes this data).",
 "MEASURED/PINNED labels per the honesty convention: resid/dev/|x| are day-020 measurements carried as named data; per-pair rounded values deliberately NOT re-gated (the C7 4-sig-fig print-precision note); the band-level uniform extension is the named open item, not a claim here."),
"P12Uniform": (
 "P1.2: the closure decomposition (the Qside contract).",
 "closure = S1 zero side + S2 detector floor + S3 definition side "
 "+ S4 squeeze; Qside (R x R -> R) is THE concrete zero-side "
 "scale (the measured |zeta| fill under A4.3): S1 = Qside >= "
 "devOf - Mf, S3 = Qside <= Bwire + Mr - ONE scale in both "
 "legs; squeeze_gives_margin + p1_2 (offPair vocabulary, "
 "pointwise atoms, covered-region composition).",
 "used by: E1Clause, S1LowT, S4Asm, Z78P12, Z78Strip, "
 "ZetaZeroSet.",
 "2026-10-16 re-typing: the old exists-Q (S1) / for-all-Q "
 "(S3) form decoupled the legs and made S3 unsatisfiable for "
 "ANY finite wire (a dead form) - the whole walk spine was "
 "retyped; discovery 0088."),
"P4Em": (
 "P4: E_m measure/integral atoms.",
 "aestronglyMeasurable_B1, abs_B1_le_half, "
 "integral_deriv_mul_add_const.",
 "used by: P4Em2, P4Tail.",
 None),
"P4Em2": (
 "P4: the em2 telescope.",
 "ico_sum_telescope, em2_finite.",
 "used by: P4Limit.",
 None),
"P4Limit": (
 "P4: the limit machinery (the big one).",
 "p4_f/p4_f1/...: the missing-tail law limit structure (6957 "
 "lines).",
 "used by: P8Floor.",
 None),
"T4Off": (
 "THE OFF-LINE LIFT OF THE T4 TAIL WALL (the G-hs3 attack, discovery 0116).",
 "p4_op2c_bound_gen / p4_f2_tail_bound_gen / p4_T4_bound_gen:  the T4 wall of P4Limit (the B-wire source, on the critical line) LIFTED OFF THE LINE - every statement holds for -1 < s.re (BOTH sides of the line) with exact off-line powers n^{-(s.re)}, n^{-(s.re+1)}, n^{-(s.re+2)}/(s.re+2).  The wall's proof structure (per-period IBP with the B3 primitive, |B3poly| <= sqrt(3)/36, the FTC reassembly, the M->inf bounded-limit passage) uses the critical-line hypothesis in exactly three places (the two endpoint power norms, the tail exponent step) and all three lift uniformly.  Sharpness at the line: t4genTerm12_at_line / t4genTerm3_at_line show the gen theorems specialize EXACTLY to the on-line T4 statement (sqrt(3)/540 constant recovered).  THE REMAINING G-hs3 CONTENT (named in the file docstring):  G-hs3-i (the EM scale at an off-pair zero via the lifted wall) - CLOSED HERE;  G-hs3-ii (the P6 finite-kernel gap / Mr wire LIFTED OFF THE LINE - the g-product terms carry g^{-sigma} factors the on-line wire never evaluates) - OPEN;  G-hs3-iii (the margin composition: off-line scale + gap < floStripMin on the strip band above the frontier) - OPEN (needs ii first).",
 "used by: (the endpoint's hs3 leg - with G-hs3-ii + G-hs3-iii closed, hs3 holds in BODY at every off-pair above the frontier and drops out of the endpoint premises; RHEnd stripfront variants are the consumer shape).",
 "No RH claim:  bound theorems about a concrete kernel expression, exactly the status of the on-line T4 wall.  Lean 4.33.1 + mathlib v4.33.1, DOC-FIRST (every lemma name taken from its usage in P4Limit)."),
"T4OffD": (
 "THE STRIP-BAND DOMINATION of the lifted T4 wall (G-hs3-i, endpoint form, discovery 0117).",
 "t4wall_offline_le_bwires:  for  every  1000  <=  t0  and  1/200  <=  d0  <=  1/2,  the  off-line  lifted  T4  wall  (T4Off.p4_T4_bound_gen  applied  at  the  canonical  strip  point  (1/2 + d0) + it0  with  the  t^4  n-schedule  S4Strip.n4)  is  TERMWISE  below  the  on-line  B-wire  P8Floor.p8_B  t0  (S4Strip.n4  t0):  term  1  by  the  extra  damping  n^(-d0);  term  2  by  the  norm  ratio  (<=  6/5,  from  the  1/200  strip  width  against  the  t^4  growth)  against  n^(-d0)  (>=  6/5  at  the  band  edge,  via  the  200th-root  wall  n  >=  (6/5)^200);  term  3  by  the  per-factor  translation  ratio  (<=  2001/2000  each,  product  (2001/2000)^3)  against  the  wall  constant  540  vs  216  plus  the  (5/2+d0)  denominator,  with  the  damping  constant  c^3*n^-d0  <=  (2/5)*(5/2+d0)  (since  n^-d0  <=  1  and  (2001/2000)^3  <  1.0016  <=  (2/5)*2.505).  Helpers:  t4o_sOff/t4o_sOn  (canonical  points),  termwise  lemmas  t4o_T1/t4o_T2/t4o_T3,  the  core  hPdiv  division  step.  CONSEQUENCE:  G-hs3-i  is  closed  at  the  endpoint  level  (the  hs3  side  of  the  endpoint  premise  is  dominated  by  the  strip  B-wire  term  everywhere  on  the  band),  on  top  of  the  component  closure  of  discovery  0116.  G-hs3-ii  (P6  finite-kernel  gap  /  Mr  wire  off  the  line)  and  G-hs3-iii  (margin  composition  below  floStripMin)  remain  open.  GOTCHA:  calc  relation  lines  must  share  ONE  indent  (a  dedent  silently  ENDS  the  calc  and  the  next  '_  <='  line  parses  as  a  command);  'simpa  only'  is  required  under  'simpa  ...  using'  where  terms  carry  divisions  (default  simp  re-normalizes  '/'  to  '*^-1'  and  breaks  unification);  kernel  timeouts  on  the  triple-product  norms  need  'set_option  maxHeartbeats'.",
 "used by: (the  endpoint  hs3  leg  -  composing  with  the  G-hs3-ii  Mr  wire  lift  and  the  S1LowT  floor  (G-hs3-iii)  makes  hs3  body-provable  above  the  frontier  and  drops  it  from  the  RHEnd  stripfront  premises).",
 "No  RH  claim:  a  termwise  domination  between  two  explicit  wire  expressions  on  a  concrete  band.  Lean  4.33.1  +  mathlib  v4.33.1,  DOC-FIRST."),
"T4OffL": (
 "THE G-hs3-LEFT FLANK BARRIERS (discovery 0121, GATED) + THE S3 LEFT WALL AT THE SQUARE-ROOT SCHEDULE (discovery 0125, GATED): the n^4 machine wire CANNOT close the S3 face at sigma < 1/2 on its own schedule (formal negative results, correcting the 0119/0120 all-flanks wording; 0116-0120 cover sigma >= 1/2 only, at t4o_sOff) - but the S3 LEFT LEG IS BODY-DISCHARGEABLE at the per-point square-root schedule n >= (n4 t)^{1/(2 sigma)} (t4l_wall_tuned), composed into the endpoint face (t4l_face_left_body / t4l_face_left_band).",
 "t4l_sOffL (left canonical point re = 1/2 - d0); t4l_expU (exp u <= 1/(1-u) for 0 <= u < 1, PURE log route: log_le_sub_one_of_pos + le_log_iff_exp_le - no numeric exp); floor pins t4l_floorPinEdge (floStripMin t (1/200) <= (1/9999) t^{-2}) / t4l_floorPinHalf (<= 2 t^{-2}); t4l_n4upper ((n4 t : R) <= 2*3.1e7 t^4 via Nat.ceil_lt_add_one: ceil_+(x) < x+1 <= 2x); t4l_term1lb ((1/2)(n4 t)^{-99/200} >= (1/15750) t^{-99/50}; constant via sqrt(62000000) < 7875, exact pin); BARRIERS: t4l_barrier_edge (t >= 10^10 -> first T4 term AT THE n4 SCHEDULE > floor at the band edge; crossing threshold t > (15750/9999)^50 ~= 7.33e9; frontier margin ~13%) and t4l_barrier_sigma0 (1/2 > floor at EVERY schedule n > 0, d0 = 1/2), plus t4l_squeezeImpos_edge/sigma0 (the squeeze cycle's S3 side cannot hold) and t4l_barrier_edge_PT2 (the barrier at the CITED Platt-Trudgian frontier 3,000,175,332,800). S7 LEFT-TUNED SCHEDULE FAMILY (discovery 0123, GATED) - the POSITIVE DUAL of the barriers: t4l_schedA (sigma) = (9999/2)^{1/sigma} (the critical scale constant: (1/2)*A(sigma)^{-sigma} = 1/9999 exactly), t4l_schedA_pos (positive for every sigma > 0), t4l_schedTerm1 (t >= 1000, sigma > 0: EVERY schedule n >= A(sigma)*t^{2/sigma} puts the first T4 term (1/2)n^{-sigma} <= (1/9999)t^{-2} - the edge-floor scale target, at or below), t4l_schedBeat4pin + t4l_schedBeat4 (at t = 10^10 and the band edge sigma = 99/200 the critical scale (9999/2)^{200/99}*t^{400/99} STRICTLY EXCEEDS the uniform machine schedule n4 <= 2*3.1e7*t^4 - pinned to the 99th power: (9999/2)^200*10^40 > 62000000^99), t4l_schedDiverge (for EVERY A > 0 there is a d0 in [1/200, 1/2) with A(1/2-d0) > A - the tuned constant is UNBOUNDED as d0 -> 1/2; NO d0-uniform schedule exists). CONSEQUENCE: satisfaction of the machined hs3 face at a LEFT-flank witness (re = 1/2 - d0) is the remaining face G-hs3-left - analytic content: per-point closure needs a left-tuned schedule (decay n^{-sigma} beating t^{-2}); S7 gives that per-point schedule EXACTLY and proves no uniform one covers the band; d0 = 1/2 unreachable at every schedule. S8 SQUARE-ROOT SCHEDULE AND S3 LEFT WALL (discovery 0125, GATED; file 1738 lines, 0 sorry) - the positive twin of S7 for the FULL S3 squeeze: t4l_schedB (t sigma) = (n4 t)^{1/(2 sigma)} (the square-root schedule: at n = schedB the first T4 term computes (1/2) n^{-sigma} = (1/2) (n4 t)^{-1/2} - exactly the on-line T1 scale), t4l_schedB_pos / t4l_schedB_ge_n4 / t4l_sched_pow (the single schedule fact: n >= schedB and a > 0 imply n^a >= (n4 t)^{a/(2 sigma)}), left-norm helpers t4l_normsq_L / t4l_wall_norm1 (||sL|| <= ||sOn|| on the band) / t4l_shift_normsq / t4l_shift_norm / t4l_wall_norm_prod (the triple product sL(sL+1)(sL+2) is termwise norm-smaller than the on-line product), the T3 coefficient pins t4l_T3pin (31000000^{2/99} >= 500/499) / t4l_T3pin2 (>= 10/9) (exact 99th-power norm_num) and t4l_T3margin ((n4 t)^{(1-2sigma)/sigma} >= 5/(2(sigma+2)) for sigma <= 99/200; split at sigma = 1/4: pin2 route vs the n4-square route), the termwise walls t4l_wall_T1 / t4l_wall_T2 / t4l_wall_T3 against p8_B t (n4 t), THE MAIN LEFT WALL t4l_wall_tuned (t >= 1000, 1/200 <= d0 < 1/2, every n >= t4l_schedB t (1/2 - d0): ||p4_em_expr (t4l_sOffL t d0) n|| <= p8_B t (n4 t)) - the mirror of t4wall_offline_le_bwires (T4OffD) on the left flank - and the endpoint-face composition t4l_face_left_body (the same witness satisfies ||p4_em_expr (sL) n|| <= S4A.BwireR t d0 + t4m_MwireOff t d0, via BwireR = p8_B t (n4 t) on the band) and t4l_face_left_band (for EVERY band off-pair at t0 >= 10^10, n = ceil(schedB) witnesses the wall). Pre-checked in tmp/s35b_leftflank_precheck.py (dps50 mpmath port): max termwise ratio at the schedule 1.0000 on the survey grid, T3 pin worst log10 margin 0.3929 (~2.47x), right-wall port gate clean (max 0.7990). The d0 = 1/2 slice (sigma = 0) stays the 0121 barrier (the schedule diverges there; excluded by d0 < 1/2). The S1 leg is NOT closed by S8: the pre-check measured devProg / (p8_B + MrLift) >= 1.11 at the band edge d0 = 1/200, growing to ~1.1e4 by d0 = 1/2 - numerically, no tuned-tail Qside fits the band squeeze window (the emptiness question is the next unit, S9, pending the B6 cross-check).",
 "used by: the endpoint face list (RHEnd stripfront residual is four faces: P1-P4 pins, window exclusion, machined hs3 at the RIGHT-flank witness, G-hs3-left); docs/KNOWN_LIMITATIONS.md 0121 correction section; the S7 family is the constructive companion feeding the G-hs3-left squeeze candidate (per left-flank witness: run a schedule at or above A(sigma)*t^{2/sigma}); S8 (0125) is the machine discharge of the S3 LEFT LEG at the square-root schedule, feeding the S9 residual analysis (the S1-leg / band-emptiness question).",
 "No RH claim: the S6 barriers are FORMAL NEGATIVE RESULTS about the machine wire, S7 their positive dual (the explicit per-point constructive schedule), and S8 an EXPLICIT wire estimate between named functions on a concrete band - none touches zeta zeros. Pinned-mathlib gotchas (S8 repair log): linarith/nlinarith FAIL on a Nat.cast numeral times a variable (2 : Nat) * x until norm_num normalizes the cast; norm_num CANNOT prove 0 <= sqrt(3)/540 (no sqrt eval) - use positivity; positivity CANNOT prove 0 <= x^8 from 1000 <= x without an explicit 0 < t in context; mul_le_mul_of_nonneg_left gives c*a <= c*b (factor on the LEFT) and _right gives a*c <= b*c - the factor position must match the goal term exactly; div_le_div_iff0 .mpr yields a*d <= c*b - close with mul_le_mul_of_nonneg_right (factor on the right); no pow_le_pow_right / pow_le_pow (use pow_le_pow_left0 or gcongr/nlinarith); no MulLeftStrictMono instance for reals (avoid mul_lt_mul_of_le_of_lt); Real.rpow_nonneg takes the exact exponent TERM - negated-fraction shapes differ as terms; sq_le_sq in this pin is an iff (a^2 <= b^2 <-> |a| <= |b|); p8_B inlines (1/2 + t*I) instead of t4o_sOn - the final definitional step needs dsimp only [p8_B, t4o_sOn]; t4o_normsq-style normsq rewrites need the dsimp of the point def BEFORE the rw. Lean 4.33.1 + mathlib v4.33.1, DOC-FIRST."),
"P4Tail": (
 "P4: the tail-law module.",
 "the tail-law statements feeding the limit chain.",
 "used by: P4Em2, P4Limit.",
 None),
"P8Floor": (
 "P8: the residual-floor line.",
 "p8_same_object, p8_triangle, p8_B_floor; assembles P4Limit + "
 "B3 into the concrete floors the S1/S2 side consumes.",
 "used by: C1b, Closure, S1LowT, S4Growth, S4Strip, S4Window, "
 "SliverEdge.",
 None),
"ProbeM5": (
 "Throwaway probe (M5 era).",
 "probe only; no theorems consumed anywhere.",
 "safe to delete at any time.",
 None),
"S1LowT": (
 "S2 detector floor at low t.",
 "floWin = min(23/1000, 1-25/gamma), floOwn = |poff gamma d "
 "gamma|, floStripMin; s2_strip_min proven for gamma >= 707/50 "
 "(edge d = 1/2 included); strip_squeeze + strip_squeeze_v2 "
 "(the low-t P1.2 forms, Qside contract).",
 "used by: FloorUnif, M6, Z78P12, ZetaZeroSet.",
 None),
"S1Point": (
 "D4 ap5: point-scale RvM (house-proven).",
 "f_pt, C9NoZerosLow (no zero on (0,4]; first zero "
 "14.134725...): |N(T) - f_pt T| <= C log T at good heights; "
 "S1B.rebase_a1g6_dn_form (the A1 wire's C log t + 1/t premise "
 "holds in the classical smooth-count instantiation).",
 "terminal: the D4 apex; S1's pointwise half.",
 None),
"S1Sample": (
 "Sample -> uniform bridge (E1C).",
 "sampleToUniform (pure real); e1V3WholeFromSample / "
 "e1V3FromWhole glue; row faces + L-faces + covers as Float "
 "gates (9/9): L1 = 13.5856 (below G), L2 = 78.9887 (above G), "
 "Dv = 900*G above, 5.809927e9 below.",
 "terminal: the S1 bridge; bridge is vacuous at measured L "
 "(t-metric); cusp robustness operative above G.",
 None),
"SieveAction": (
 "KCS U2 (second orbit): the finite Fourier sieve operator "
 "package - the formal twin of discovery 0172.",
 "rou (primitive N-th root) + char_pow + dft + mark_notdiv + "
 "raman; mark_notdiv_idempotent (M^a = M^b pointwise), "
 "mark_notdiv_commute (M_p M_q = M_q M_p pointwise), chime_comb "
 "(F[1_{p|m}] = N*1_{a=0} - (N/p)*1_{(N/p)|a}, the 3-case comb "
 "formula - the 24-error wall), raman_prime_closed (p-1 / -1); "
 "WAVE-2 A (0177): rou_sum_orthogonality, mobius_sum_nat, "
 "mobius_unit_indicator, raman_inclusion_exclusion (the "
 "full-sieve symbol = the Ramanujan mu-sum); WAVE-2 B (0178): "
 "raman_multiplicativity (c_{mn}(K) = c_m(K)*c_n(K) for (m,n)=1 "
 "- divisor-product bijection Nat.Coprime.mul_injOn_divisors + "
 "mu multiplicativity on coprimes + coprime divisibility "
 "split), raman_full_support (c_N(a) & 0 for squarefree N - "
 "strong induction over the squarefree decomposition M = p*k + "
 "prime closed form (p-1 / -1) + B1 + nonzero product). "
 "Squarefree full support = the U2 measurement in theorem form; "
 "WAVE-2 C (0179): level_census (the k-level divisor census) and "
 "parseval_units - the Parseval identity sum_a |F[f](a)|^2 = "
 "N * sum_m |f(m)|^2 in general form (DFT expansion + conjugate "
 "sum + triple-sum reindexing over product Finsets + the root of "
 "unity kernel collapse (if m = n then N else 0) + normSq bridge). "
 "The kernel lemma rou_sum_orthogonality is the exact engine of "
 "the kcs2 numpy measurement.",
 "N2 + N4 statements of KCS U2 (measurement: "
 "kcs2_fourier_sieve.py at N=210/30030); Wave-2 complete through "
 "C (A 0177, B 0178, C 0179). Next: Wave-3 (sieve-action "
 "composition identities for the orbit program).",
 None),
"SieveOrbit": (
 "KCS U4a + U4b (second orbit): the LEGENDRE EXACT identity (the "
 "machine-checked inclusion-exclusion engine of the sieve action, the "
 "zeta-free face of the orbit program) AND the discrete level-1 exact "
 "sieve band L1 <= Phi <= U2 (the 0181 width number, now proved).",
 "U4a: phi_list (the Legendre recursion def), nodup_prime_split, "
 "phi_list_count, phi_list_mono, prime_dvd_prod_of_prime_list, "
 "legendre_identity ((phi_list x ps : Z) = sum_{d | prod ps} (mu d : "
 "Z) * floor(x / d) - induction on ps via "
 "Nat.Coprime.mul_injOn_divisors + the coprime mu-split), "
 "legendre_count_eq (the sum = count bridge). U4b: "
 "pairset/orderedpairset (the unordered and ordered distinct prime "
 "pairs), mcount (prime-divisibility counting function), L1/U2pair/U2 "
 "(the integer level-1 band endpoints), offdiagset (the n-covering "
 "off-diagonal), slack_t/slack_s (the pointwise lower/upper residuals, "
 "non-negative via slack_t_nonneg / slack_s_nonneg), card_mulps, "
 "mcount_single_sum (the floor sum = the counting sum), "
 "offdiag_pointwise + mcount_offdiag_sum (m*(m-1) = the pairwise off- "
 "diagonal count), ordered_parts (+_disjoint), ordered_eq_two_pair "
 "(the ordered pair sum = 2 x the unordered sum, sum_bij through "
 "Prod.swap), x_ones_sum / mcount_single_sum_Z / mcount_offdiag_sum_Z "
 "(the integer bridges), phi_indicator (Phi = the 0/1 survivor sum), "
 "level1_lower + level1_upper, and level1_sandwich (THE band: L1 x ps "
 "<= (phi_list x ps : Z) <= U2 x ps).",
 "U4a + U4b of KCS U4 in theorem form; measured counterparts: "
 "tmp/kcs1_out.txt (U1a exact identity + U1b residual/worst case) and "
 "tmp/kcs4b_out.txt (0181 width/position: W/xV 2.10->10.12, rho "
 "0.84->0.67 x-stable). Next: U4(c) structural parity/anchor statement "
 "(structural, not a barrier theorem) + the U1c two-process zeta/sieve "
 "residual harness (also O1 of the orbital side-quest).",
 "No RH claim: pure finite combinatorics over Nat/Int (no analysis, no "
 "axioms, no external provenance). Pinned-mathlib gotchas (0180): an "
 "ascribed division (x / d : Z) elaborates to Int.ediv (the ascription "
 "drives the instance) - write cast-of-natdiv explicitly. U4b "
 "additions (0183): a sum body does NOT extend past an infix - or + "
 "(in the sum-over-n of 'f n - g n' the '- g n' is OUTSIDE the sum "
 "with n free - parenthesize the whole summand); an ascribed summand "
 "(t : Z) lifts the operands, so (a / b : Z) is Int.ediv of lifts, NOT "
 "the cast of the Nat quotient - bridge such sums pointwise with "
 "norm_cast to Nat.cast (t) form before cast_sum rewrites (Int.ofNat "
 "terms do not match the Nat.cast_sum rw pattern); hite : ite = 0 "
 "proves by rw [if_neg (Nat.succ_ne_zero k)] alone (rw auto-closes the "
 "0 = 0, so no trailing norm_num); the disjointness application shape "
 "after rw [Finset.disjoint_left] at hdisj is 'hdisj ho hd' "
 "(membership proofs only, first-set side first); do not pre-rewrite "
 "hL where a calc's final target still contains hL.LHS (it breaks the "
 "calc's defeq target).",
),

"ProbeS1U": (
 "Gate probe for S1Uniform Part D: the unified vacuity ledger.",
 "one-command #eval of BdeadData (85772092.455109, the s10 "
 "dead-zone max |M_wp|), belowGUniformVacuous (7.8931e10), "
 "bridgeAddData (6.5570002736e15), s8_Bcand (2), v3_Bcand (7000) "
 "+ both bridge ratios (9.367e11 above, 3.947e7 below).",
 "re-gate the S1 unified ledger from one command; the #eval "
 "lives in S1Uniform itself too.",
 None),
"RHEnd": (
 "THE ENDPOINT of the program on the ACTUAL zeta zero set "
 "under the named external input [Z78] (Re s > 7/8 zero-free), "
 "at the CONCRETE wire. RESIDUAL LEDGER after Part B12 "
 "(discovery 0129, the terminal form of the 0110-0129 chain): "
 "the above-frontier residue is ONE zero-exclusion face hOff38 "
 "(no off-pair on [H, inf) x (0, 3/8]) - the [Z78]-SHARP strip "
 "interior: offPairD0le bounds every actual-set off-pair to "
 "d0 <= 3/8 (zero-free at Re > 7/8 + functional equation put "
 "zeros in [1/8, 7/8], the bound is sharp), so the slice "
 "(3/8, 1/2] of the B11 face is closed IN BODY FROM [Z78] "
 "(rhend_slice38Excl) with no face at all - plus the below-"
 "frontier record [Z-PT2] plus [Z78] (which closes ALL of "
 "d0 > 3/8 in body). The 0126 squeeze certificate (wire + mass "
 "< devProg; no Qside satisfies both squeeze legs at a band "
 "off-pair; the three strip faces jointly contradictory) "
 "covers the WHOLE residual with measured margin >= 1.1136. "
 "The intermediate endpoint forms are all EQUIVALENT in body "
 "and kept: vacant (0126, two exclusion faces), unified (0127, "
 "one 1/2-face), unified38 (0129, the 3/8-face).",
 "wire: Mf = Z78P12.MfP (0 tail), devOf = devProg (the concrete "
 "strip detector), Bwire/Mr = Z78P12.BwireP/MrP (the residue "
 "wires), flo = floProg (the unified S2 floor on the covered "
 "region 1000 <= t0, d0 <= 1/2; the near pin 0.9975 elsewhere). "
 "PROVEN IN BODY: S2 covered (FUnif.s2ActualFullBand, the "
 "unified actual-set floor); S4 strip band (FUnif.s4StripUnifiedFloor, "
 "squeeze and S2 floor are ONE object on 1/200 <= d0 <= 1/2); "
 "S4 low band (TRIVIAL - the residue wires are 0 below 1000, "
 "floor = the pin, 0 < 0.9975); the far region (VACUOUS from "
 "[Z78] alone - Z78P12.offPairFarEmpty). NAMED RESIDUAL: hs1 the "
 "S1 witness: Qside >= devProg - the E1 content, uniform face "
 "via S1Uniform; hs3 the S3 wire: THE SAME Qside <= BwireP + "
 "MrP (Qside contract); hWin the S4 "
 "window-pin shape (25m/25ab closure pinned at 0.9975 vs the "
 "unified floor <= own mass <= 6e-4 there - Part C gate: ratio "
 "1662.5), hS2low the S2 low-band pin (H6 regime; sliver part "
 "vacuous under the named on-line record).",
 "terminal: the one-clause endpoint; composes "
 "S4A.rh_from_regime_closures + Z78/Z78P12 + FloorUnif + S1LowT + "
 "P8Floor (p8_f_near_pin) + S1Face/P4Limit (Part B2).",
 "No RH claim: hs1/hs3/hWin/hS2low are OPEN (data and "
 "bound-level, as the chart carries); this module only NAMES the "
 "residual once, at the concrete wire. Part C #evals: 0.9975, "
 "0.0006, 1662.500000. PART B2 (discovery 0095): "
 "rh_program78_s1pins RESTATES the endpoint with the bare hs1 "
 "scale inequality REPLACED by the PIN FAMILY over the witness "
 "zero (P1 fill = the A0 fill; P2 the kernel-magnitude pin "
 "devFacePt <= |W_n|; P3 the A4.3 mass pin; P4 the absorption pin "
 "devProg + mval <= devFacePt) - the hs1 leg is DERIVED IN BODY "
 "via S1Face.hs1AtZero; the residual narrows from the bare "
 "inequality to the PIN family (same content, checkable "
 "shape). PART B3 (discovery 0107): rh_program78_winpt RESTATES "
 "the endpoint with hWin DERIVED IN BODY from the CITED classical "
 "frontier [Z-PT] (all non-trivial zeros up to tPT = 30,610,046,000 "
 "on the line - the rigorous interval-verified zero-isolation "
 "record, cited like [Z78]) plus the residual face WinC.hWinFaceResidual "
 "(zero-exclusion of off-line zeros on (tPT, inf) x (0, 1/200)): "
 "S4WC's face identity makes the hWin premise exactly zero-"
 "exclusion on [1000, inf) x (0, 1/200), and WinC.faceSplit splits "
 "it at the frontier (no off-pairs on [1000, tPT] from [Z-PT] "
 "alone) - the endpoint's hWin premise narrows to zero-exclusion "
 "above the frontier, the open height interval of the residual "
 "shrinking by a factor of ~3e7; the 3e9 record shadow "
 "(WinC.offExcessBound: off-line excess below 3e9 is 0 or 2 under "
 "the record's +-3 gate) is an independent record-derived "
 "constraint on the same open region, kept out of the endpoint "
 "premises; no RH claim. PART B4 (discovery 0110): rh_program78_frontier - "
 "the endpoint COLLAPSED TO THE CITED FRONTIER: every named residual is "
 "quantified over off-pairs, and [Z-PT] excludes ALL off-line zeros below "
 "tPT at ANY offset (WinC.noOffLineBelowPT: t0 = 0 by non-realness, 0 < t0 "
 "by the sign argument with the conjugate twin) - so below the frontier "
 "all four residuals are VACUOUS and above it only bound-level content "
 "remains: the theorem takes [Z-PT] + hs1/hS3 restricted to t0 >= tPT + "
 "the hWin residual face (zero-exclusion on (tPT, inf) x (0, 1/200)); "
 "hS2low DISAPPEARS ENTIRELY (its domain (0, 1000) sits below the "
 "frontier). The entire residue of the endpoint (four named residuals on "
 "(0, inf) x (0, 1/2)) reduces to content STRICTLY ABOVE tPT = 3.06e10; "
 "no RH claim - the open content is the above-frontier bound-level faces, "
 "where no instrument in the tree reaches. PART B5 (discovery 0111): "
 "rh_program78_stripfront - the endpoint OVER THE STRIP FRONTIER: in the "
 "strip band (t0 >= 1000,  1/200 <= d0 <= 1/2) the four closure legs form "
 "a contradiction at any off-pair (S1:  scale >= devProg;  S2:  "
 "devProg >= floStripMin IN BODY no cap;  S3:  scale <= Bwire + Mr;  S4: "
 "Bwire + Mr < floStripMin IN BODY no cap),  and in the window band above "
 "tPT the hWin zero-exclusion kills every off-pair -  so the hs1/hs3 "
 "premises shrink from all d0 in (0,  1/2] to the STRIP BAND above tPT. "
 "The named gaps behind the two strip faces (docstring):  G-hs3 = the "
 "off-line LIFT of the critical-line T4 wire  (p8_B_floor needs  Re  s  = "
 "1/2;  an off-pair zero is off the line by definition;  no kernel upper "
 "bound at off-line points in the tree;  the P3 mass pin is a premise by "
 "design)  and  G-hs1  =  the  scale  anti-degeneracy  lower  bound  (body "
 "has kernel UPPER bounds and detector LOWER bounds only;  measured "
 "shadow  =  the  S1Marg  margin  track).  G-hs1  +  G-hs3  on  (tPT,  "
 "inf) x [1/200,  1/2] ARE the strip-band zero-exclusion;  the entire "
 "above-frontier residue of the endpoint is named:  two analytic gap "
 "statements plus the window face.  No RH claim. PART B6/B7 "
 "(discoveries 0117-0119): the machined stripfront endpoint "
 "rh_program78_stripfront_mach (+_PT2) - the G-hs3 face MACHINED "
 "at the lifted wires: the S3 face carries the OFF-LINE EM wall "
 "(T4OffD: wall <= strip B-wire, termwise) + the OFF-LINE lifted "
 "M-wire (T4OffM, the CITED 1.6 convexity mass); the S3 leg "
 "closes IN BODY via t4wall_offline_le_bwires and the S4 strip "
 "leg is t4m_margin (lifted wire < floStripMin, ~16 orders); "
 "MrLift = the off-line M-wire in the strip band, S4A.MrR "
 "elsewhere. PART B8 (discovery 0120): "
 "rh_program78_stripfront_mach_s1pins (+_PT2) - G-hs1 entered as "
 "the P1-P4 PIN FAMILY at the strip-band witness zero, the S1 "
 "leg derived in body via S1Face.hs1AtZero. PART B9 (discovery "
 "0122): the hs3 face SPLIT BY FLANK - t4l_flankSplit (an "
 "off-pair with d0 != 0 is a right-flank or left-flank off-pair; "
 "the |.|-shape pins re = 1/2 +- d0), t4l_rightFaceOfSingle "
 "(the B7 single-face premise restricts to the right-flank face), "
 "and rh_program78_stripfront_mach_left (+_PT2): right-flank "
 "face = the machine-closable B7 shape (T4OffD in body), "
 "left-flank face hs3LeftH = the pair-level S3 squeeze "
 "(Qside <= Bwire + Mr) = the NAMED ANALYTIC FACE G-hs3-left "
 "(T4OffL, discovery 0121: the n4 wire cannot produce it - band "
 "edge t >= 10^10, sigma = 0 unreachable, no uniform schedule). "
 "The S4 (floor) side is FLANK-INDEPENDENT (t4m_margin) - only "
 "the S3 (wire) side carries the flank. The endpoint residual "
 "in the machine is now exactly the four-face ledger: G-hs1 "
 "(data), window zero-exclusion (record), machined hs3 at the "
 "right witness (cited 1.6 mass), G-hs3-left (analytic); file "
 "1505 lines. PART B10 (discovery 0126, after T4OffL S7/S8 + the "
 "S35B pre-check): the band squeeze window is EMPTY IN BODY, "
 "flank-independent - t4l_bandWireBelow (on the strip band at any "
 "off-pair: BwireP + MrLift < devProg - t4m_margin (S4 in body, "
 "0118) composed with S2 in body (FUnif.s2ActualFullBand); the "
 "S35B pre-check measured the actual margin: devProg / (p8_B + "
 "MrLift) >= 1.1136 at the band edge d0 = 1/200, ~1.1e4 by "
 "d0 = 1/2), t4l_bandEmpty (no scale Qside satisfies BOTH "
 "squeeze legs at a band off-pair), t4l_stripFacesEmpty (the B9 "
 "three-face bundle G-hs1 + hs3-right + G-hs3-left is jointly "
 "CONTRADICTORY at every band off-pair: right branch via the "
 "T4OffD wall in body, left branch direct) - G-hs3-left (and its "
 "right-flank twin) DISSOLVE AS INDEPENDENT FACES: they are "
 "components of the strip-band zero-exclusion face. "
 "rh_program78_stripfront_mach_vacant (+_PT2): the endpoint with "
 "the bundle replaced by ONE band-zero-exclusion face hNoStrip "
 "(the S4 strip case no longer needs t4m_margin); "
 "rh_program78_stripfront_mach_vacant_ofB9 (+_PT2): the B9 "
 "endpoint implies the vacant endpoint in body - for the "
 "endpoint the three-face bundle is EQUIVALENT to the single "
 "zero-exclusion face. The endpoint residual in the unverified "
 "region is now exactly two zero-exclusion faces (band, window) "
 "+ [Z78] + the below-frontier record; the S1 pin family (B8) is "
 "the DATA SIDE of the squeeze, and the squeeze certificate "
 "certifies the band exclusion in body when the pins hold. "
 "PART B11 (discovery 0127): the above-frontier residual "
 "UNIFIED TO ONE FACE - the band face (hNoStrip, 1/200 <= d0) "
 "and the window face (hWinH, d0 < 1/200) have the identical "
 "form (zero-exclusion above the frontier; the 1/200 boundary "
 "is a proof artifact of the squeeze cycle, not a face "
 "boundary) and the far region d0 > 1/2 is closed in body from "
 "[Z78] - so the endpoint's above-frontier residue is the "
 "SINGLE face hOff (no off-pair on [H, inf) x (0, 1/2]): "
 "rh_program78_stripfront_mach_unified (+_PT2 at the Platt-"
 "Trudgian frontier) states the endpoint with that one face "
 "plus the record below the frontier plus [Z78]; "
 "rh_program78_stripfront_mach_unified_ofB10 (+_PT2_ofB10) "
 "proves the B10 endpoint (two-face form) implies the unified "
 "endpoint in body - the unification loses nothing. File "
 "2043 lines, 0 sorry, full tree green. The above-frontier "
 "ledger is now exactly: ONE record-footing zero-exclusion "
 "face + [Z78] + the below-frontier record. No RH claim: "
 "everything in B10/B11 is either body composition of the "
 "0118 S4 wire margin with the S2 floor closure, or a zero-"
 "exclusion face on record footing with the [Z-PT2] record. "
 "PART B12 (discovery 0129): the face shrinks to the [Z78]- "
 "SHARP strip interior - Z78.offPairD0le (zero-free at Re > 7/8 "
 "+ functional equation: zeros lie in the strip [1/8, 7/8]) "
 "bounds EVERY off-pair of an actual-set zero set to d0 <= 3/8 "
 "(sharp), so the slice (3/8, 1/2] of the B11 face - including "
 "the d0 = 1/2 edge - is closed IN BODY FROM [Z78] with no face "
 "(rhend_slice38Excl). rh_program78_stripfront_mach_unified38 "
 "(+_PT2 at the Platt-Trudgian frontier): the endpoint with the "
 "single open face hOff38 (forall (t0 d0), H <= t0 -> 0 < d0 "
 "-> d0 <= 3/8 -> not offPair q t0 d0) - in the S1/S3 legs and "
 "the S4-covered leg, above H, the proof reads `have h38 : d0 "
 "<= 3/8 := Z78.offPairD0le q hz78 hqz t0 d0 ht0 hd0 hp; "
 "hOff38 kills` - the B11 d0 <= 1/2 splits vanish from those "
 "legs entirely (they remain only in the S2 leg, where they are "
 "structural to hs2_covered's domain). EQUIVALENCE OF THE "
 "FORMS in body: unified38_ofB11 (the 1/2-face restricts to "
 "the 3/8-face; no [Z78] needed) and unified_ofB12 "
 "(+_PT2_ofB12: the 3/8-face + [Z78] close the (3/8, 1/2] "
 "slice via offPairD0le, recovering the 1/2-face) - the 3/8-"
 "form is the NATURAL statement: its face is exactly the region "
 "the external inputs cannot already close. File 2240 lines, 0 "
 "sorry, full tree green. The face-shrinking chain (0110/0108 "
 "record shrink -> 0122 flank split -> 0126 band-empty -> 0127 "
 "unification -> 0129 3/8-shrink) is AT ITS TERMINUS: the "
 "residual face is [Z78]-sharp. PART B13 (discovery 0131): a "
 "NEW external input moves the face boundary - [Z78L], Liu's "
 "improved zero-free half-plane (arXiv 2610.12234; human Lean "
 "formalization, recorded strict replay PASS, 312 declarations, "
 "axioms exactly propext/Classical.choice/Quot.sound; see "
 "Z78Liu.lean header) STRICTLY STRENGTHENS [Z78] (the "
 "certified boundary liuBUpper = 874957019420098947/10^18 is "
 "< 7/8; B_inf = 0.874957019420098946... = (18*xi+7)/(18*xi+9) "
 "with xi the isolated root of 1188x^3-2160x^2+171x+190 in "
 "(0.38858, 0.38859)). offPairD0leLiu bounds EVERY actual-set "
 "off-pair to d0 <= liuD0max = liuBUpper - 1/2 = "
 "374957019420098947/10^18 < 3/8 (sharp at both new strip "
 "edges [1 - liuBUpper, liuBUpper]). "
 "rh_program78_stripfront_mach_unifiedLiu (+_PT2): the endpoint "
 "under [Z78L] with the single open face hOffL (no off-pair on "
 "[H, inf) x (0, liuD0max]) - identical proof shape to B12 "
 "(offPairD0leLiu bounds d0 before the face in the S1/S3/"
 "S4-covered legs; the S2/S4-far legs use the [Z78] DERIVED "
 "from [Z78L] via extLiu_implies_ext78). The slice "
 "(liuD0max, 3/8] of the 0129 face is closed IN BODY FROM "
 "[Z78L] (rhend_sliceLiuExcl) and the 0129 terminal statement "
 "is a THEOREM of the 0131 one (unified38_ofLiu (+_PT2): face "
 "by restriction or slice exclusion). File 2425 lines, 0 "
 "sorry, full tree green. UPDATED TERMINAL LEDGER: [Z-PT2] "
 "record below the frontier + ONE open face hOffL (the "
 "[Z78L]-sharp strip interior, record footing) + [Z78L] "
 "(closes ALL of d0 > liuD0max in body; [Z78] remains a "
 "corollary input). RECON NOTE from the 0131 search: a Zenodo "
 "record initially matched as a certified zero-free region at "
 "Re s >= 0.6 (which would have shrunk the face to ~1/10 by "
 "the functional equation) but is REPLACED by a "
 "restricted-access work and no longer publicly verifiable - "
 "NOT adopted. No RH claim: the face is a zero-exclusion "
 "statement in the unverified region, on record footing with "
 "the [Z-PT2] record; the further-reduction routes stand "
 "(external record above tPT2 = route C; a VERIFIED "
 "zero-free input covering more strip interior - [Z78L] is "
 "the first instance). "
 "PART B14 (discovery 0133): the tracker frontier "
 "(QuasiRiemannTracker record two-level-affine-20261019, PR #67, "
 "ArviFoxy, MERGED 2026-10-20, framework-verified, new-bound; the "
 "all-Dirichlet zero-free half-plane at the exact rational "
 "174963413/200000000 = 0.874817065; protected pipeline: "
 "comparator + Lean/NanoDa/con-ron in the pinned sandbox; see the "
 "Z78Track.lean header) STRICTLY STRENGTHENS [Z78L] (qxUpper < "
 "liuBUpper, norm_num) -> the whole chain. offPairD0leTrack bounds "
 "EVERY actual-set off-pair to d0 <= qxD0max = qxUpper - 1/2 = "
 "74963413/200000000 = 0.374817065 < liuD0max (SHARP). "
 "rh_program78_stripfront_mach_unifiedTrack (+_PT2): the endpoint "
 "under [Z78T] with the single open face hOffT (no off-pair on "
 "[H, inf) x (0, qxD0max]) - identical proof shape to B13; the "
 "slice (qxD0max, liuD0max] of the B13 face is closed IN BODY "
 "(rhend_sliceTrackExcl) and the 0131 terminal statement is a "
 "THEOREM of the 0133 one (unifiedLiu_ofTrack (+_PT2)). Step size "
 "1.39954e-4 (3.3x the 0131 step; cumulative from 3/8: "
 "1.82935e-4). File 2629 lines, 0 sorry, full tree green. "
 "UPDATED TERMINAL LEDGER: [Z-PT2] record below the frontier + ONE "
 "open face hOffT (the [Z78T]-sharp strip interior, record "
 "footing) + [Z78T] (closes ALL of d0 > qxD0max in body; [Z78L] "
 "and [Z78] remain corollary inputs). SNAPSHOT caveat: the board "
 "moves daily - supersession by a newer snapshot is the designed "
 "exit, executed by the same unit (B6 packet section 8). No RH "
 "claim. "
 "PART B15 (discovery 0142): the tracker board moved one day after "
 "the 0141 ceiling analysis of the cycle63 family - [Z78G] "
 "(QuasiRiemannTracker record gao-five-step-affine-20261020, PR #68, "
 "Zhongpai Gao, MERGED 2026-10-21, framework-verified; the five-stage "
 "affine all-Dirichlet zero-free half-plane at the exact rational "
 "8748087/10^7 = 0.8748087; a direct DESCENDANT of [Z78T] - builds on "
 "two-level-affine-20261019; independent second-party replay PASS: "
 "4669/4669 modules from source, kernel statement match at the exact "
 "rational, axiom cone exactly the standard three, 0 sorry; see the "
 "Z78Gao.lean header) STRICTLY STRENGTHENS [Z78T] (gaoUpper < qxUpper, "
 "norm_num) -> the whole chain. offPairD0leGao bounds "
 "EVERY actual-set off-pair to d0 <= gaoD0max = gaoUpper - 1/2 = "
 "3748087/10^7 = 0.3748087 < qxD0max (SHARP). "
 "rh_program78_stripfront_mach_unifiedGao (+_PT2): the endpoint under "
 "[Z78G] with the single open face hOffG (no off-pair on [H, inf) x "
 "(0, gaoD0max]) - identical proof shape to B14; the slice (gaoD0max, "
 "qxD0max] of the B14 face is closed IN BODY (rhend_sliceGaoExcl) and "
 "the 0133 terminal statement is a THEOREM of the 0142 one "
 "(unifiedTrack_ofGao (+_PT2)). Step size 8.365e-6 (about one-fifteenth "
 "of the 0133 step - decaying returns as the ladders deepen). File 2839 "
 "lines, 0 sorry, full tree green. UPDATED TERMINAL LEDGER: [Z-PT2] "
 "record below the frontier + ONE open face hOffG (the [Z78G]-sharp "
 "strip interior, record footing) + [Z78G] (closes ALL of d0 > gaoD0max "
 "in body; [Z78T], [Z78L] and [Z78] remain corollary inputs, each a "
 "named theorem of the 0142 endpoint). SNAPSHOT caveat: the board is "
 "live again - the watcher anchor is 8748087/10^7 and a successor "
 "supersedes by the same unit (the protocol has now run three times "
 "end-to-end). No RH claim."),
"S1Uniform": (
 "The S1 UNIFORM statement + walk composition (v3): the formal "
 "artifact closing P12.S1's 'uniform height = open' side and "
 "composing the whole chain into RH.",
 "(A) e1BelowGWholeFromSample: below G the M_wp face is finite "
 "C^1 (it sums FAR zeros only) -> the two-sided sample->uniform "
 "bridge (S1Sample.sampleToUniform) on the (G0, GH] face domain, "
 "M_wp itself, NO defect subtraction; (B) s1UniformFace (shape) "
 "+ s1UniformStatement (proven): the full program-domain face on "
 "(G0, T_MEAS] = two-sided below G + two-sided dead zone "
 "(GH, G_LAST] (the s10 measured plunge, max 85772092.455109) + "
 "ONE-SIDED upper (the E1 threat direction) above G (the face -> "
 "-oo at super-G zeros), proven by Part A + the hDead datum + "
 "S1Cusp.e1CuspWholeFromRows; (C) s1UniformAndWalk: the S1 "
 "uniform premises (which carry the uniform statement - certified "
 "as hunif in the proof body) + the named data clause "
 "E1ClauseV3 q 7000 + Qside + the four walk legs hs1-hs4 (the "
 "Qside contract) on P12.offPair -> RH q, pure composition "
 "through E1C.if_E1V3_and_walk.",
 "terminal: the S1 formal artifact (uniform statement + walk); "
 "composes with the E1 v3 data clause and the P12 legs.",
 "Both bridge bounds are FORMAL BUT VACUOUS at measured "
 "constants: 9.367e11 x 7000 above (bridgeAddData), 3.947e7 x 2 "
 "below (belowGUniformVacuous) - the operative between-row "
 "control is the cusp face robustness + the P12 squeeze leg; "
 "E1ClauseV3 q 7000 stays the named data hole."),
"S1Cusp": (
 "Cusp-aware between-row bridge ABOVE G (E1 threat direction); "
 "sibling to S1Sample's t-Lipschitz bridge, which is out of "
 "scope above G (zero cusps of log|zeta| break the hLip premise).",
 "cuspPlunge (positive log cusp dominates a locally bounded-ABOVE "
 "smooth part; premise is BddAbove - a below-bound does NOT "
 "control the face from above); vFlankLeft/Right (strict "
 "down/up flanks from secant Lipschitz only, no derivative); "
 "cuspUpperBridge: row |f u| <= B, |t-u| <= Dv, row eps from "
 "every cusp, 0 <= c j <= C => f t <= B + L|t-u| + C n "
 "log(1 + Dv/eps) - uniform in the plunge (the face truly -> "
 "-oo at the cusps); e1CuspWholeFromRows glues onto E1C.Mres on "
 "(G_LAST, T_MEAS].",
 "terminal (for now): the formal S1 above-G between-row control; "
 "P12 squeeze remains the operative DATA between-row control.",
 "Gates are the VACUITY record at measured constants: bridgeAdd "
 "= 6.5570002736e15 = 9.367e11 x B(7000); rowCuspAmp 4.343 < "
 "B. Flat explicit params (no section/variable - they silently "
 "drop in this toolchain); pinned APIs: abs_add_le (triangle), "
 "abs_add' (anti-triangle form |x| <= |y| + |x+y|), "
 "Real.log_inv, mul_lt_mul_of_pos_left (a*b < a*c order), "
 "sum_const needs Fintype-pinned sorts, <- sum_sub_distrib."),
"S3a": (
 "S3: algebraic core on the quantized straddle.",
 "Ralg: ring-certified polynomial identities (file heartbeat "
 "raised to 400000 for that).",
 "used by: M6.",
 None),
"S4Asm": (
 "S4 assembly: the squeeze composition.",
 "gapW / gapO; s4asm_strip_region_S4 (the PROVEN t^4 covered "
 "squeeze on 1000 <= t, 1/200 <= d <= 1/2); "
 "s4asm_residue_S4_covered (the bound-level residue: the named "
 "open S4 gap); rh_from_structural_hypotheses + "
 "rh_from_regime_closures (P1.2 with S4 by regime closures, "
 "Qside contract).",
 "used by: FloorUnif, Z78P12, RHEnd.",
 "the residue is NAMED, not sorry: it is the bound-level open "
 "gap of S4."),
"S4Blind": (
 "THE S4 BLIND-SPOT FACE: the remaining open mathematics, named (127 lines).",
 "blindSpot (t d): the own-regime strip (1000 <= t, 0 < d <= 1/2) at the pole-mass-invisible scale 2 d/t^2 < 6.5e-5 (25a instrument scale, I(1e7) = +1.29e-6; the 25n pin-invisibility 4kd/t^2 <~ floor is header-recorded).  squeezeImpossibleOnBlind: the S4 squeeze BwireO + Mr + Mf < mown is PROVEN impossible at any blind-spot pair for nonnegative Mr, Mf (S4G.s4c_squeeze_impossible on the strip) - the own-floor FORM of the blind-spot face is machine-closed-off.  Pins (MEASURED, 25-series, arithmetic-gated by pinGates): tstarHold = 690349.0568 (the window-regime squeeze-hold boundary, 25l), deltaWin1e3 = -0.953692 / deltaWin1e7 = +5374.37, closeWitnessT = 5004.7343 with margin 143.341847457 (25c, dps-30), bsyI1e7 = 1.29e-6.  s4OpenFace (declared, NOT proven): S4 at the blind-spot pairs in any wiring flo >= mown - the named residual content.  No RH claim.",
 "used by: (face module - names the open face; S4Gap supplies the impossibility engine, P12Uniform the hs4 vocabulary).",
 "the blind-spot residual of S4 is the REMAINING OPEN MATHEMATICS of the prize: measured at the instrument boundaries (the pins), own-floor form closed off in Lean, wiring content open - exactly the P12 header statement, now a named object."),
"B7Far": (
 "THE B7 FAR-SIDE FACE: the census-drift mechanism, named.",
 "Consumes the MFa pins; adds the near-log PART nl = M - D pinned from the s33b record by exact arithmetic on the pins (nl9 = -609469941, nl10 = -667658569.9, nl30 = -695421601.6; 50-dp cross-check A ln t + B within 1.1/0.05/0.51 units = f64 pipeline noise).  Five GATED (norm_num) gates: decompositionGates (nl = M - D exact on the pins), shareWindows (the near-log share |nl|/|M| in [5%,7%] / [0.06%,0.07%] / [0.007%,0.008%] at the three far pins - measured 5.87% / 0.0683% / 0.0079%), shareDecay (share shrinks >=10x per decade and >=5x per 3x step), notLineInLnT (the second M drop ratio drop30/drop10 in [7,9], measured 8.0804, vs the ln-t line 0.477121 and the t*ln-t family 2.2875 - the far M channel is NOT a continuation of the near log law), t2stepConsistency (the drop ratio sits within 1e-3 absolute of the PURE t^2 step ratio (t30^2-t10^2)/(t10^2-t9^2) = 8.0808081 at the exact pinned heights, measured gap 4.57e-4, while every competing family is >=0.79 away: the residual shape is the t^2 / kernel -t^2/g^2 family, identified not asserted).  b7OpenFace (the S4Blind s4OpenFace pattern): the open MECHANISM as a Prop declaration - for any mechanism map gen, there exists a positive far-side count excess E, supported on the measured s29 g-window [2e8, 1e11] (g = t/G), whose GENERATED drift hits the three pinned D values; measured at the pins, not proven.  No RH claim: the endpoint far region is vacuous in the body from [Z78]; this face is a measured constraint any RH proof must reproduce.",
 "used by: B7Far section D (discovery 0112) - the WALK CONSUMER: the "
 "card's 'walk (B1)' candidate in the current module layout (the W2T.DN "
 "tail walk with the W2Beyond drift step law): b7WalkFace = the "
 "b7OpenFace pattern restricted to gen = the W2 tail-walk drift operator "
 "over three consecutive steps (N0 = 0, Nas(0) = 0), PROVEN by "
 "construction (b7WalkHitAny / b7WalkFaceTrue) - for ANY three reals a, b, "
 "c there is a count grid whose walk drift hits them at steps 1, 2, 3 "
 "(grid: i - value_i at i in {1,2,3}, 0 elsewhere) - the WALK OPERATOR "
 "HAS EMPTY STRUCTURAL CONSTRAINT on a drift triple, so the walk is NOT "
 "excluded as the B7 mechanism and the open link of the walk candidate "
 "is exactly the E -> grid INPUT map (the excess driving the count-grid "
 "increments), which is not in the tree. SECTION E (discovery 0113) "
 "wires the SECOND consumer candidate - the old 'law-territory (B5)' - "
 "which in the current module layout is the P4 TAIL-LAW family (P4Limit, "
 "the EM-tail T3 wall): the T3 tail bound (t3w_T3UB, the certified tail "
 "size at height t, cutoff n = floor(13t/8)) closes on the WHOLE wall "
 "range 1 <= t <= 1e8 (p4_25ae_wall_list_scale) - that is the wall the "
 "B7 record calls 'past-the-wall'. The law-territory candidate is "
 "STRUCTURALLY EXCLUDED (b7LawExcluded) on two exact grounds: POSITION - "
 "the B7 support window [2e8, 1e11] and the three pinned far heights sit "
 "beyond the wall range (b7WindowBeyondLawWall / b7PinsBeyondLawWall, "
 "norm_num), where the law makes no statement; MAGNITUDE - on the whole "
 "wall range the certified tail content is < 1/2 (lawTailBelowHalf: "
 "n = 0 branch (0:R)^(-1/2) <= 1, n >= 1 branch n^(-1/2) <= 1 and "
 "35/39 < 1) while every pinned drift is > 1/2 (b7DriftAboveHalf, "
 "smallest |D9| = 9774967307, growing |D9| < |D10| < |D30|) - about 14 "
 "orders of magnitude apart. The two consumers bracket the mechanism "
 "space: the WALK candidate SURVIVES (realizable), the LAW-TERRITORY "
 "candidate is EXCLUDED, and the remaining B7 mechanism content is the "
 "unnamed channel of the excess input E past the wall.",
 "nl is pinned as M - D (exact on the record), NOT recomputed as An * log t + Bn in Lean: the Real log never enters a gate; the ln predictions (0.477121, 2.2875) are documented 50-dp facts on the pinned heights, not Lean computations."),

"S4WinCap": (
 "THE hWin WINDOW FLOOR CAP + FACE IDENTITY: the window face is zero-exclusion, named and certified.",
 "Three new formal facts (namespace S4WC; no RH claim). (1) poffOwnMown: at the pair's OWN HEIGHT the B5 off-line factor product has mass exactly S4O.mown (B5's four canonical factors at (t,d,t) are exactly the 8-factor S4Own kernel; S4O.hMownProd is the 25n closed-form bridge; the B5/S4O zero identification rhoPP=z1 etc. with halfR = (2:R)^-1 = 1/2 is a lemma chain closed by dsimp + Complex.ext + simp/ring). (2) floorBelowWire: on the WHOLE window band 1000 <= t, 0 < d < 1/200, the unified S2 floor floStripMin t d is STRICTLY BELOW the window S4 wire's first tail term (hence below the wire total): floStripMin <= |poff| = mown < 31/(10^5 t^2) [mownWindowScale: each own-kernel factor pinned separately - 4d^2 < 1/10000 from d < 1/200, 1+1/(16t^2) <= 16000001/16000000, exp(1/t^2) <= 1/(1-1/t^2) <= 1000000/999999 via log x <= x-1], then 31/(10^5 t^2) < (1/2)^2/sqrt(13t/8) for t <= T0=110000 [nearTailBelowScale: squaring chain 12493t/8 < 12493t^4/8 < 2e9 t^4 <= 2.5e9 t^4 = 50000^2 t^4, all explicit mul_le/mul_lt in the exact left/right form of the goal] and < 1/(2t) for t > T0 [farTailBelowScale: 62t < 100000 t^2 by div_lt_div_iff0 cross-multiplication]; the tail term is the leading term of p8_B at the wire index (floor(13t/8) near, floor(t^2) far, via S4W.hpow1 and floor_le). (3) The FACE IDENTITY: def hWinFace (restates the hWin hypothesis of RHEnd.rh_program78 verbatim with the Z78P12 wire aliases) is EQUIVALENT to zero-exclusion of off-line zeros on [1000, inf) x (0, 1/200): hwinFaceImpliesZeroExclusion (a face-holding zero set has no off-pairs in the band: wire+Mr+Mf < floor and floor < wire, Mr >= 0 [hMrgen, branch on t <= T0 with S4W.hXwire_pos / hXgrowPos], Mf = 0, contradiction by lt_irrefl) and zeroExclusionImpliesFace (vacuous direction). hXgrowPos: S4G.Xgrow t > 0 for t > T0 (every factor positive; Sbar > 0 by the S4W.hLn27 ln-pin with 27 <= t^2). MEASURED BACKSTOP (survey s35a, tmp/s35a_hwin_far_survey.py, log tmp/s35a_hwin_survey.log, reproduces the Lean pins before results): margin floStripMin - (Bwire+Mr) < 0 at every surveyed point on t in [1e3..3e10] x d in (1e-9, 1/200), floor = 4d^2/t^2 to rel 2e-13, Xwire(T0) = 1.827275e-3 <= RX, 25m total at T0 = 0.936536 < 0.9975. THE FACE ITSELF IS OPEN: it asserts zero-exclusion on a band no instrument in the tree reaches (classical zero-free regions give Re >= 1 - c/ln t, nowhere near 1/2 - 1/200). The endpoint and its four named residuals are untouched; hWin is now CHARACTERIZED.",
 "used by: (none yet) - it characterizes the hWin face of RHEnd.rh_program78; the next consumer is the endpoint restatement or a future zero-free-region import that would discharge the face.",
 "explicit-algebra discipline: every mul_*_of_* call matches the goal's LITERAL parse (left/right factor position), every div comparison is cross-multiplied via the 0-suffixed iff's, no Real log enters the pins; the T0 = 110000 bridges are rfl on the def, not norm_num; the 16000001/16000000 literal is elaborated identically at every use (a literal-type mismatch broke the first attempt)."),

"WinCount": (
 "THE hWin SHINK: the face is zero-exclusion above 3.06e10 plus the 3e9 record shadow - pinned and certified.",
 "Two independent shrinks of the hWin face's OPEN content (namespace WinC; no RH claim; endpoint untouched). (A) THE CLASSICAL FRONTIER SHRNK: tPT := 30610046000 (30,610,046,000) pins the rigorous zero-isolation record (Platt, 'Isolating some non-trivial zeros of Zeta': interval-arithmetic isolation of every non-trivial zero with 0 < Im <= tPT to +- 2^-102, an independent verification of the line to that height; the public LMFDB zero stream ends at exactly this height - the record's own frontier). allOnLineUpTo q tPT is [Z-PT], the CITED classical input stated over the ABSTRACT ZeroSet (the Z78-strip pattern); the higher literature frontier (RH up to 3 x 10^12, Platt-Trudgian arXiv:2004.09765) is named as an optional add-on. Consequences LEAN-PROVEN (cite nothing beyond [Z-PT]): noOffPairBelowPT (no off-pairs in [1000, tPT] x (0, 1/200); a negative-height off-line zero is sent to its positive twin by HFE after HCJ) and faceSplit (S4WC.hWinFace q <-> hWinFaceResidual q): under [Z-PT] the face is EXACTLY zero-exclusion on (tPT, inf) x (0, 1/200) - the open face of the endpoint's hWin residual shrinks by a height factor of about 3e7 (from 1000 to 3.06e10). hWinFaceResidual is the named residual; it is OPEN: the classical zero-free regions stop at Re > 1 - c/ln t (nowhere near Re = 1/2 +- 1/200) and the measured zero walk ends at the frontier. (B) THE 3e9 RECORD SHADOW (MFar/B7Far pattern): the H1 3e9 stream record (day035 ceiling report + the day035_3e9_stream.sh finish gate) is pinned and re-gated: Nline := 9064192826 (exact on-line count at 3e9), rvm3e9 := 9064192825.58 (recorded RVM value; RVM counts the STRIP zeros), pinGates (norm_num: Nline - rvm3e9 = 21/50 exactly and |Nline - rvm3e9| = 0.42 <= 3, the fleet's own +-3 finish gate). Structural: D_even (Even (B0.D q t) for ANY ZeroSet - the whole-slice twin of B0.offSliceEven; the fixed-point-free involution 1 - rho-bar preserves the height EXACTLY and tiles the off-line slice in 2-cycles). Constraint: offExcessBound (for any q whose on-line count at 3e9 matches the pinned Nline and whose strip count passes the record's +-3 gate |Ntot - rvm3e9| <= n for n >= 1: B0.D q (3e9) <= n - 1; with the record's tolerance n = 3: at most TWO off-line zeros = at most ONE off-line orbit below 3e9; with D_even the excess is 0 or 2). Record-derived: spends only B0's structural axioms + the two record pins + the gate. (C) THE ROUTE MERGE (discovery 0108): the two shrink routes subsume each other below the frontier - dZeroBelowRecord (for ANY zero set consistent with [Z-PT]: D q (3e9) = 0 EXACTLY; the B0.zeroD_of_RH pattern with RH replaced by the frontier on (0, tPT]; strictly sharper than the shadow's D <= 2, and 0 is the even case of D_even) and rvmGateDischarged (for a zero set whose exact count at 3e9 matches the pinned Nline - the ACTUAL set's recorded data - the fleet's recorded +-3 gate |Ntot - rvm3e9| <= 3 HOLDS as a theorem: pure record arithmetic via pinGates, no frontier use): [Z-PT] gives D = 0 and the pinned count re-derives the +-3 gate offExcessBound consumed as a hypothesis; below tPT the routes carry each other's load. (D) THE GENERAL-OFFSET LEMMA + THE ENDPOINT-COLLAPSE ENGINE (discovery 0110): noOffLineBelowPT (for ANY zero set consistent with [Z-PT]: NO off-pair at ANY offset d0 for any 0 <= t0 <= tPT - the t0 = 0 case by non-realness, the 0 < t0 case by the sign argument with the conjugate twin; generalizes noOffPairBelowPT, whose 1000 <= t0 and d0 < 1/200 restrictions were the window context) - the engine behind RHEnd Part B4 (rh_program78_frontier): every named residual is quantified over off-pairs, so below the frontier ALL FOUR are vacuous and hS2low drops out entirely (domain (0, 1000) <= tPT). CARDS/MAP updated after this entry; 100 cards.",
 "used by: the endpoint (RHEnd Part B3, rh_program78_winpt - the hWin premise is derived from [Z-PT] + hWinFaceResidual in the body; PART B3 wired the route-A shrink at the endpoint in discovery 0107).",
 "the counts B0.Ntot/Non/D carry the height proof ht as an explicit argument - a theorem's hypotheses must use ONE named ht0 (two (by norm_num) terms are not definitionally equal); the record pins are norm_num GATES, not re-derivations; [Z-PT] is a CITED fact about the actual set carried as a named hypothesis, like [Z78] and [Z-EDGE]."),

"MFar": (
 "THE FAR-M LAW PINS: the past-the-wall M channel, the quadratic identified.",
 "Pinned (s33b record, s34o re-issue): the six far-row M values (5e8G -3035441152, 1e9G -10384437248, 1e10G -978196824064, 3e10G -8798461100032; heights the exact f64 row integers) and the far DRIFT D = M - (A ln t + B) with A = -25271000, B = +523877900 (the near-face fit): D9 = -9774967307, D10 = -977529165494.1, D30 = -8797765678430.4.  pinGates (norm_num, arithmetic only): the 10x/3x height steps within 1e-4 (the f64 grid rounding is inside the windows), the adjacent |D| ratios in [100.00, 100.01] (measured 100.00332) and [9.00, 9.01] (measured 9.0000033), the coefficient c = |D|/t^2 stable within 0.1% across the three decades (1.0860317e-29, 1.0860678e-29, 1.0860682e-29), and |M30| <= 1.01 c t30^2 (the near-log law < 1%).  THE FAR M LAW IS -9.776e-9 (t/G)^2 DOMINANT - the B7 position-amplitude degeneracy is broken on the measured domain; the far law is NOT the near log law.  No RH claim.",
 "used by: B7Far (the B7 face wiring consumes the pins); feeds B1 the walk and B5 law territory.",
 None),
"S4Gap": (
 "S4: the gapW machinery.",
 "hBwireTerm1, hInvHalf, hNscale; the gap-region bound-level "
 "wires.",
 "used by: S4Asm, S4Sharp, S4Strip.",
 None),
"S4Growth": (
 "S4: the growth region.",
 "Ggrow/Bgrow/T0 + growth wires for the squeeze regions.",
 "used by: S4Asm, S4Strip.",
 None),
"S4Own": (
 "S4: the closed-form own-mass kernel.",
 "mown / ownKer (the four-factor product norm); hMownProd "
 "(product identity), hMownScale (the scale window).",
 "used by: FloorUnif, S4Asm, S4Gap, S4Sharp, S4Strip.",
 None),
"S4Sharp": (
 "S4: the sharpening pass (S4S).",
 "hMown_ds, s4d_mown_dmin, s4d_wire_demand: the demand-sides for "
 "sharpening the S4 wires.",
 "terminal: sharpening output.",
 None),
"S4Strip": (
 "S4: the strip region.",
 "the strip-region squeeze wires (2118 lines).",
 "used by: S1LowT, S4Asm.",
 None),
"S4Window": (
 "S4: the window region.",
 "Gc/Bc/T0; the low-window bound-level squeeze material.",
 "used by: S4Asm, S4Gap, S4Growth, S4Strip.",
 None),
"SliverEdge": (
 "The low-sliver edge record.",
 "firstZeroPin (14.134725...), sliverOnCount (the day030 813-"
 "zero slice: (0,1200] all on line, max |zeta| 1.96e-12), "
 "EdgeZeroFree.",
 "used by: Z78P12, ZetaZeroSet.",
 "the sliver key is |rho.im| (conjugate pairs incl.), d0 > 0 + "
 "re != 1/2 exclude the on-line zero."),
"W2Bound": (
 "W2: the far-side bound machinery.",
 "e1_bound, e2_bound, midExtAtPole (1419 lines): the bound-level "
 "far-side estimates.",
 "used by: W2Beyond3, W2M5, W2M6.",
 None),
"W2Integral": (
 "W2: the integral identities.",
 "the W2 integral equalities over the kernel.",
 "used by: W2Beyond0, W2Beyond1, W2Bound.",
 None),
"W2Kernel": (
 "W2: the exact kernel vocabulary.",
 "the Kabs product kernel (as in the day023/day029 verbatim "
 "form) in Lean atoms.",
 "used by: E1Clause, W2Beyond0, W2Beyond1, W2Bound, W2Integral.",
 None),
"W2M5": (
 "W2: the M5 pins.",
 "G1_pin (1e7), G2_pin (3e10), K_pin: the band pins of the M5 "
 "machinery.",
 "used by: M6.",
 None),
"W2M6": (
 "W2: the M6 band (Trudgian uniform S-bound).",
 "band [1e7, 3e10]; Milino-form uniform S-bound (the theorem is "
 "Trudgian's; attribution note in-file) + the project's +1/8 "
 "exact-grid offset (E16: DN - S = 1/8 to < 2e-5).",
 "terminal: the band statement.",
 None),
"W2Telescope": (
 "W2: the count telescope.",
 "DP / DN / S1Sum: the far-side tail of W2 is a statement about "
 "COUNTS, packaged as DN = (N0 + j) - Nas(j) (the smoothed-count "
 "deficit).",
 "used by: M6, W2Beyond0/1/3, W2Bound.",
 None),
"W2Beyond0": (
 "W2-beyond: far-side rewrite, step 1.",
 "the first far-side rewrites of the kernel.",
 "used by: W2Beyond1.",
 None),
"W2Beyond1": (
 "W2-beyond: far-side rewrite, step 2.",
 "the second far-side rewrites.",
 "terminal (used by none: step 3 goes through W2Beyond2/3).",
 None),
"W2Beyond2": (
 "W2-beyond: the far-side kernel bounds.",
 "|p(g;t)| <= 3 t^2/g^2, |p'| <= 5 t^2/g^3 (g >= 2t); far-side "
 "total variation over [g1, oo) <= (5/2) t^2/g1^2.  The E4 "
 "reduction's engine.",
 "used by: W2Beyond3.",
 None),
"W2Beyond3": (
 "W2-beyond: far side -> the count statement.",
 "the final far-side reductions feeding the A1 wire.",
 "used by: A1Growth.",
 None),
"Z78P12": (
 "Z78 woven into P1.2 for actual sets.",
 "offPairFarEmpty (no d0 > 1/2 off-pair: strip 1/8..7/8 -> "
 "d0 <= 3/8 < 1/2, vacuity margin 1/8); rh_actual78 (RH_actual "
 "<= S1 + S2 + S3 + S4 low band t0 < 1000, far VACUOUS; Qside "
 "contract); edgeZeroFree78 (Re = 0/1 excluded from [Z78] "
 "alone); sliverOffPairsEmpty; s2ActualLowBandComplete (S2 on "
 "0 < t0 < 1000, 0 < d0 <= 1/2).",
 "used by: FloorUnif.",
 "the far region is VACUOUS under the named external input, not "
 "a hypothesis."),
"Z78Strip": (
 "The named external quasi-RH input.",
 "externalZeroFree78 / externalZeroFreeDirichlet78 / "
 "externalSiegelGap (named props WITH provenance: openai/math "
 "family 003, kernel-verified 2 kernels, human review in "
 "progress); zetaZeroStrip (1/8 <= Re <= 7/8); offPairD0le "
 "(d0 <= 3/8, SHARP -- the strip distance is 3/8, not 1/8).",
 "used by: Z78P12.",
 "the input class = independently kernel-verified external "
 "theorems as named props; NOT a compiled dependency."),
"Z78Liu": (
 "The [Z78L] named external input: the Liu successor of the "
 "7/8 quasi-RH (arXiv 2610.12234).",
 "externalZeroFree78Liu (named prop WITH provenance: Liu, "
 "'Slightly improved zero-free half-planes for the quasi-"
 "Riemann hypothesis', human Lean formalization with recorded "
 "strict replay PASS - 312 declarations, axioms exactly "
 "propext/Classical.choice/Quot.sound; the certified rational "
 "upper boundary liuBUpper = 874957019420098947/10^18 < 7/8 "
 "in place of the algebraic B_inf = 0.874957019420098946..., "
 "pole guard carried from her statement, inert on the pinned "
 "Mathlib via riemannZeta_one_ne_zero); extLiu_implies_ext78 "
 "([Z78L] STRICTLY STRENGTHENS [Z78], norm_num certified); "
 "zetaZeroStripLiu (1 - liuBUpper <= Re <= liuBUpper); "
 "offPairD0leLiu (d0 <= liuD0max = liuBUpper - 1/2 = "
 "374957019420098947/10^18 < 3/8, SHARP).",
 "used by: RHEnd (part B13).",
 "same input class as Z78Strip - a kernel-verified external "
 "theorem as a named prop, NOT a compiled dependency; its "
 "foundation inherits the B6 OAI 003 input class, its "
 "parameter-improvement delta is human-written Lean. "
 "VERIFICATION STANDING (discovery 0132): the queued "
 "independent replay is DONE and PASS - a clean-network, "
 "from-source run (all dependencies pinned + rebuilt, 8,951 "
 "jobs; strict trust=0 replay of all ten proof files; the "
 "axiom audit reproduces the exact 312-declaration surface "
 "with zero deviations from the standard three axioms; "
 "byte-identical to the public repository) - so [Z78L] now "
 "has two-party Lean-kernel strict replay (producer + "
 "independent); B6 item 5 (the 199-page paper) is the solely "
 "open B6 item and underwrites the foundation of BOTH [Z78] "
 "and [Z78L]. A NO-GO on [Z78L] reverts the program to the "
 "0129 terminal form (nothing else depends on it)."),
"Z78Track": (
 "The [Z78T] named external input: the QuasiRiemannTracker "
 "frontier (record two-level-affine-20261019, PR #67, ArviFoxy, "
 "merged 2026-10-20) - the all-Dirichlet zero-free half-plane at "
 "the certified rational boundary 0.874817065.",
 "externalZeroFree78Track (named prop WITH provenance: tracker "
 "record two-level-affine-20261019 at the exact rational "
 "qxUpper = 174963413/200000000; the zeta form is the chi = 1 "
 "specialization of the verified all-Dirichlet statement, pole "
 "guard inert on the pinned Mathlib via riemannZeta_one_ne_zero); "
 "qxUpper_lt_liuB (norm_num: 174963413*10^18 < "
 "874957019420098947*200000000); extTrack_implies_extLiu / ext78 "
 "([Z78T] STRICTLY STRENGTHENS the whole chain); "
 "zetaZeroStripTrack (1 - qxUpper <= Re <= qxUpper); "
 "offPairD0leTrack (d0 <= qxD0max = qxUpper - 1/2 = "
 "74963413/200000000 = 0.374817065 < liuD0max < 3/8, SHARP). "
 "Float data gates: 0.874817065 / 0.125182935 / 0.374817065.",
 "used by: RHEnd (part B14).",
 "same input class as Z78Liu/Z78Strip - a kernel-verified "
 "external theorem as a named prop, NOT a compiled dependency. "
 "VERIFICATION STANDING (discovery 0133, replayed 0134): the "
 "tracker's protected admission pipeline - Comparator checked the canonical "
 "all-Dirichlet statement at the exact rational for the submitted "
 "commit; Lean, NanoDa and con-ron accepted the proof in the "
 "pinned sandbox (tool-pins sha256-locks every kernel binary); "
 "merged + published as a new board bound - plus the PR's own "
 "block (922-module clean build, pinned Lean 4.34.1; axioms "
 "exactly the standard three; 923-file byte identity). An "
 "INDEPENDENT second-party replay COMPLETED (discovery 0134, "
 "same day): all 4077 modules (922 candidate + 2927 openai-" +
 "baseline + 228 akashlevy) compiled from source through the " +
 "Lean 4.34.1 kernel (0 failures, 2536 s), pin-exact external " +
 "footprint from source at identical pins with byte-identical " +
 "patches, kernel-level statement match at the exact rational, " +
 "axiom cone of the canonical statement exactly {propext, " +
 "Classical.choice, Quot.sound} - [Z78T] is now independently " +
 "second-party verified on the same footing as [Z78L] post-0132; " +
 "the 923-file sha256 snapshot and replay workspace are " +
 "archived under tmp/b6audit/tracker/. FOUNDATION: builds on " +
 "the tracker's openai-baseline (the B6-audited OAI 003 source) " +
 "plus tracker records - B6 item 5 underwrites " +
 "[Z78]/[Z78L]/[Z78T] foundations together. "
 "SNAPSHOT CAVEAT: the board moves daily; [Z78T] is the verified "
 "state of 2026-10-20 and a successor supersedes it by the same "
 "unit. A NO-GO on [Z78T] reverts the program to the 0131 "
 "terminal form (B13 preserved in tree)."),
"Z78Gao": (
 "The [Z78G] named external input: the QuasiRiemannTracker "
 "five-step-affine frontier (record gao-five-step-affine-20261020, "
 "PR #68, Zhongpai Gao, merged 2026-10-21) - the all-Dirichlet "
 "zero-free half-plane at the certified rational boundary "
 "8748087/10^7 = 0.8748087; a direct descendant of [Z78T].",
 "externalZeroFree78Gao (named prop WITH provenance: tracker "
 "record gao-five-step-affine-20261020 at source commit f07bb241" +
 "... at the exact rational gaoUpper = 8748087/10^7; the zeta "
 "form is the chi = 1 specialization of the verified all-Dirichlet "
 "statement, pole guard inert on the pinned Mathlib via "
 "riemannZeta_one_ne_zero); gaoUpper_lt_qx (norm_num cross-" +
 "multiplication: 8748087*200000000 < 174963413*10^7); "
 "extGao_implies_extTrack / _extLiu / _ext78 ([Z78G] STRICTLY "
 "STRENGTHENS the whole chain [Z78G] -> [Z78T] -> [Z78L] -> [Z78]); "
 "zetaZeroStripGao (1 - gaoUpper <= Re <= gaoUpper); offPairD0leGao "
 "(d0 <= gaoD0max = gaoUpper - 1/2 = 3748087/10^7 = 0.3748087 < "
 "qxD0max < 3/8, SHARP). Float data gates: 0.8748087 / 0.1251913 "
 "/ 0.3748087.",
 "used by: RHEnd (part B15).",
 "same input class as Z78Track/Z78Liu/Z78Strip - a kernel-" +
 "verified external theorem as a named prop, NOT a compiled "
 "dependency. VERIFICATION STANDING (discovery 0142, all same day): "
 "the tracker's protected admission (certificate theta_exact "
 "8748087/10000000; Lean default + nanoda + con-ron; run "
 "39514163334) plus an INDEPENDENT second-party replay in this "
 "program's standard environment (tmp/b6audit/tracker/gao5_replay/): "
 "both Submissions dependency subtrees byte-identical to the 0134 "
 "replay tree at the source commit (gate 3 in its cleanest form - no "
 "OAI delta); snapshot guard 1514/1514; 4669/4669 modules (1514 "
 "candidate + 2927 openai-baseline + 228 akashlevy) compiled from "
 "source through the Lean 4.34.1 kernel (0 failures, 3088.7 s); "
 "kernel-level statement match at the exact rational (one-line "
 "bridge to Candidate.bound type-checks); axiom cone of the "
 "canonical statement exactly {propext, Classical.choice, "
 "Quot.sound}; 0 sorry in the 1514-file cone. The four-page paper "
 "(parameters and source-bindings hash-pinned) was read in full per "
 "the B6 item-5 protocol: the moment is BUILT by backward "
 "induction from actual finite native sources (per the bindings "
 "file itself), the endpoint argument (Bernstein certificates at "
 "theta - 1e-7, kappa-feedback, Levy + Collet, inherited Hecke-to-" +
 "Dirichlet transfer) internally consistent, no load-bearing flaws "
 "found at the audit level (tmp/b6audit/tracker/gao5/PAPER-AUDIT.md). "
 "SNAPSHOT CAVEAT: the board is a live frontier - this record is "
 "the verified state of 2026-10-21; a successor supersedes by the "
 "same unit (the B6 section-8 conveyor, now demonstrated three "
 "times). A NO-GO on [Z78G] reverts the program to the 0133 "
 "terminal form (B14 preserved in tree)."),
"Z78Collet": (
 "The [Z78C] named external input: the QuasiRiemannTracker "
 "finite-ordinary-source-moments frontier (record "
 "hailey-collet-1252270103, PR #69, Hailey Collet / HaileyStorm, "
 "MERGED 2026-10-23, merge commit 2cbdbe7c...) - the all-Dirichlet "
 "zero-free half-plane at the certified rational boundary "
 "8747729897/10^10 = 0.8747729897; a DIRECT descendant of [Z78G] "
 "(the record consumes PR67 = [Z78T] as input, adds 64 seed source "
 "faces, 221 derived source faces, a 301-node finite source DAG "
 "induction: a NEW structural cycle, not tuning).",
 "externalZeroFree78Collet (named prop; the zeta form is the "
 "chi = 1 specialization, pole guard inert on the pinned Mathlib); "
 "colletUpper_lt_gao (norm_num cross-multiplication: "
 "8747729897*10^3 < 8748087*10^6); extColet_implies_extGao/_extTrack/"
 "_extLiu/_ext78 (STRICTLY STRENGTHENS the whole chain); "
 "zetaZeroStripCollet (1 - colletUpper <= Re <= colletUpper); "
 "offPairD0leCollet (d0 <= colletD0max = colletUpper - 1/2 = "
 "3747729897/10^10 = 0.3747729897 < gaoD0max < 3/8, SHARP). Float "
 "data gates: 0.8747729897 / 0.1252270103 / 0.3747729897.",
 "used by: RHEnd (part B16 - the CURRENT terminal endpoint "
 "rh_program78_stripfront_mach_unifiedCollet/_PT2; the 0142 Gao "
 "endpoint is a theorem of it via B16.4; face shrink "
 "gaoD0max - colletD0max = 3.57103e-5).",
 "same input class - a kernel-verified external theorem as a named "
 "prop, NOT a compiled dependency. VERIFICATION STANDING (discovery "
 "0162): INDEPENDENT second-party replay at the FROZEN head "
 "ac76d5ef (tmp/b6audit/collet69/replay/): 6474/6474 modules "
 "(3547 record + 2927 vendored OAI baseline) compiled from source "
 "against the tracker-pinned environment (Lean 4.34.1 pinned "
 "binary; mathlib d13f23b7...), 0 failures, 3472s; canonical "
 "statements at the exact rational kernel-accepted in both claimed "
 "scopes; axiom cone exactly [propext, Classical.choice, "
 "Quot.sound]; 0 sorry in the 3547-file cone; snapshot guard sha256 "
 "8607635a... MERGE IDENTITY (2026-10-23): the merged head IS the "
 "frozen head (GitHub API: PR #69 head.sha = ac76d5ef...), and the "
 "FULL merged submission tree is blob-SHA-identical to the replayed "
 "frozen copy (3549/3549 files at the merge commit; spot hash "
 "ReturnConstants.lean md5 b82c1770...) - the frozen-head replay is "
 "exactly the merged-head verification. PENDING NAMING: the "
 "standalone paper (haileystorm.github.io) was 404 at audit time "
 "- provenance TODO, does not block adoption (the B6 section-8 "
 "gate is the kernel replay). SNAPSHOT CAVEAT: the board moved "
 "again by the same mechanism (0133 [Z78]->[Z78T]; 0142 [Z78T]->"
 "[Z78G]; 0162 [Z78G]->[Z78C]). CEILING NOTE (0147): the record "
 "sits 2.116e-4 above its family's named-margin corner "
 "(0.8745613585650727). NO RH CLAIM: a zero-free half-plane, still "
 "0.3747729897 from the critical line in off-line distance."),
"ZetaZeroSet": (
 "The zero-set abstraction + actual-set instantiation.",
 "edgeVacuous, s2legStrip, rhIfMarginZeta (the closure "
 "composition from S1..S4 + margin to RH; Qside contract).",
 "used by: E1Clause.",
 None),
}

def wcount(name):
    with open(os.path.join(SRC, name + ".lean"), encoding="utf-8",
              errors="replace") as fh:
        return sum(1 for _ in fh)

os.makedirs(OUT, exist_ok=True)
total = 0

def card_line(tag, text):
    out = textwrap.fill(tag + text, width=WIDTH,
                        subsequent_indent=" " * (len(tag) + 2))
    return out.split("\n")

for name in sorted(C):
    what, how, uses, got = C[name]
    lines = ["# %s.lean  (%d lines)" % (name, wcount(name))]
    lines += card_line("WHAT:  ", what)
    lines += card_line("HOW:   ", how)
    lines += card_line("USES:  ", uses)
    if got:
        lines += card_line("GOTCHA: ", got)
    body = "\n".join(lines) + "\n"
    for ln in body.split("\n"):
        assert len(ln) <= WIDTH, (name, ln, len(ln))
    open(os.path.join(OUT, name + ".md"), "w").write(body)
    total += len(lines)
print("cards written:", len(C), "| body lines:", total)
