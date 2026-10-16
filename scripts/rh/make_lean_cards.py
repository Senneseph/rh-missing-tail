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
 "design: norm_num cannot eval Real.exp); if_E1V3_and_walk.",
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
"P12Uniform": (
 "P1.2: the closure decomposition.",
 "closure = S1 zero side + S2 detector floor + S3 definition side "
 "+ S4 squeeze; the offPair vocabulary and the pointwise atoms; "
 "covered-region composition.",
 "used by: E1Clause, S1LowT, S4Asm, Z78P12, Z78Strip, "
 "ZetaZeroSet.",
 None),
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
 "(edge d = 1/2 included).",
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
 "open S4 gap).",
 "used by: FloorUnif, Z78P12.",
 "the residue is NAMED, not sorry: it is the bound-level open "
 "gap of S4."),
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
 "<= S1 + S2 + S3 + S4 low band t0 < 1000, far VACUOUS); "
 "edgeZeroFree78 (Re = 0/1 excluded from [Z78] alone); "
 "sliverOffPairsEmpty; s2ActualLowBandComplete (S2 on 0 < t0 < "
 "1000, 0 < d0 <= 1/2).",
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
 "composition from S1..S4 + margin to RH).",
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
