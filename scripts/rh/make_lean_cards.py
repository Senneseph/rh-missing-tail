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
 "E1 clause v3: the above-G data clause.",
 "E1ClauseV3 q B on (G, T_MEAS]: M_defect(t) = -25256007 ln t + "
 "523513775, B = 7000 data-supported; mdefect_bounded (loose by "
 "design: norm_num cannot eval Real.exp); if_E1_and_walk + "
 "if_E1V3_and_walk (Qside contract: hs1 Qside >= devOf - Mf, "
 "hs3 Qside <= Bwire + Mr).",
 "terminal (data clause): composes with the walk into RH.",
 "constants are DATA-SUPPORTED, not proven; re-gate only on new "
 "near-band data."),
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
"ProbeTmp": (
 "Throwaway probe.",
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
 "at the CONCRETE wire, with maximal concretization: the residual "
 "is named exactly once, as the single theorem rh_program78.",
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
 "shape)."),
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
 "used by: (none yet - the endpoint's four named residuals hs1/hs3/hWin/hS2low are untouched; next consumer candidates: the walk (B1) and the law-territory clause (B5)).",
 "nl is pinned as M - D (exact on the record), NOT recomputed as An * log t + Bn in Lean: the Real log never enters a gate; the ln predictions (0.477121, 2.2875) are documented 50-dp facts on the pinned heights, not Lean computations."),

"S4WinCap": (
 "THE hWin WINDOW FLOOR CAP + FACE IDENTITY: the window face is zero-exclusion, named and certified.",
 "Three new formal facts (namespace S4WC; no RH claim). (1) poffOwnMown: at the pair's OWN HEIGHT the B5 off-line factor product has mass exactly S4O.mown (B5's four canonical factors at (t,d,t) are exactly the 8-factor S4Own kernel; S4O.hMownProd is the 25n closed-form bridge; the B5/S4O zero identification rhoPP=z1 etc. with halfR = (2:R)^-1 = 1/2 is a lemma chain closed by dsimp + Complex.ext + simp/ring). (2) floorBelowWire: on the WHOLE window band 1000 <= t, 0 < d < 1/200, the unified S2 floor floStripMin t d is STRICTLY BELOW the window S4 wire's first tail term (hence below the wire total): floStripMin <= |poff| = mown < 31/(10^5 t^2) [mownWindowScale: each own-kernel factor pinned separately - 4d^2 < 1/10000 from d < 1/200, 1+1/(16t^2) <= 16000001/16000000, exp(1/t^2) <= 1/(1-1/t^2) <= 1000000/999999 via log x <= x-1], then 31/(10^5 t^2) < (1/2)^2/sqrt(13t/8) for t <= T0=110000 [nearTailBelowScale: squaring chain 12493t/8 < 12493t^4/8 < 2e9 t^4 <= 2.5e9 t^4 = 50000^2 t^4, all explicit mul_le/mul_lt in the exact left/right form of the goal] and < 1/(2t) for t > T0 [farTailBelowScale: 62t < 100000 t^2 by div_lt_div_iff0 cross-multiplication]; the tail term is the leading term of p8_B at the wire index (floor(13t/8) near, floor(t^2) far, via S4W.hpow1 and floor_le). (3) The FACE IDENTITY: def hWinFace (restates the hWin hypothesis of RHEnd.rh_program78 verbatim with the Z78P12 wire aliases) is EQUIVALENT to zero-exclusion of off-line zeros on [1000, inf) x (0, 1/200): hwinFaceImpliesZeroExclusion (a face-holding zero set has no off-pairs in the band: wire+Mr+Mf < floor and floor < wire, Mr >= 0 [hMrgen, branch on t <= T0 with S4W.hXwire_pos / hXgrowPos], Mf = 0, contradiction by lt_irrefl) and zeroExclusionImpliesFace (vacuous direction). hXgrowPos: S4G.Xgrow t > 0 for t > T0 (every factor positive; Sbar > 0 by the S4W.hLn27 ln-pin with 27 <= t^2). MEASURED BACKSTOP (survey s35a, tmp/s35a_hwin_far_survey.py, log tmp/s35a_hwin_survey.log, reproduces the Lean pins before results): margin floStripMin - (Bwire+Mr) < 0 at every surveyed point on t in [1e3..3e10] x d in (1e-9, 1/200), floor = 4d^2/t^2 to rel 2e-13, Xwire(T0) = 1.827275e-3 <= RX, 25m total at T0 = 0.936536 < 0.9975. THE FACE ITSELF IS OPEN: it asserts zero-exclusion on a band no instrument in the tree reaches (classical zero-free regions give Re >= 1 - c/ln t, nowhere near 1/2 - 1/200). The endpoint and its four named residuals are untouched; hWin is now CHARACTERIZED.",
 "used by: (none yet) - it characterizes the hWin face of RHEnd.rh_program78; the next consumer is the endpoint restatement or a future zero-free-region import that would discharge the face.",
 "explicit-algebra discipline: every mul_*_of_* call matches the goal's LITERAL parse (left/right factor position), every div comparison is cross-multiplied via the 0-suffixed iff's, no Real log enters the pins; the T0 = 110000 bridges are rfl on the def, not norm_num; the 16000001/16000000 literal is elaborated identically at every use (a literal-type mismatch broke the first attempt)."),

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
