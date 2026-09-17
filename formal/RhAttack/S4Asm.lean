import Mathlib
import RhAttack.S4Window
import RhAttack.S4Own
import RhAttack.S4Gap
import RhAttack.P12Uniform
import RhAttack.S4Growth
import RhAttack.S4Strip

/- 25q — S4 ASSEMBLY (the residue statement, one import).

   After the green atoms 25m (S4a window), 25n/25o (S4b own-strip
   identity + scale), 25p (S4c gap certificate), the ENTIRE open
   content of the S4 squeeze — and hence of P1.2's S4 hypothesis and
   the bound-level RH residue — reduces to exactly TWO named gaps:

   GAP-W (window regime): for t > T0 = 1.1e5,
       p8_B(t, floor(13t/8)) + M e^{Xwire t} Xwire t < 0.9975
       for 0 <= M <= Zbound t.
     GREEN on [1000, T0] (S4a, s4a_is_gapw_low_window);
     numerically GREEN to t* = 690349.0568 (PINNED, 25l[3]);
     fails at the bound level beyond t* (Bwire ~ sqrt(t),
     measured deficit O(1) — 25l[3]/25f[4]).
     25aa/25ab: the bound-level gap is CLOSED by the growing-wire
     family (n = floor(t^2), G = t^2, B = 2 t^2; the list-scale
     family is excluded by S4Sharp) and is now a LEAN theorem:
     S4G.s4g_growth_squeeze (t >= T0, 0 <= M <= Zbound t) +
     S4G.s4g_admissible (RVM lower bound, Backlund — CITED source;
     N_rvm_low(x) >= x for x >= T0^2).  The window regime is closed
     on [1000, inf) at the bound level; the remaining S4 residue is
     the own-regime wire (below) + the S1 height wire (25x).

   GAP-O (own regime, the strip 0 < d <= 1/2, t >= 1000):
       BwireO(t) + Mr(t) + Mf(t) < mown(t, d)
       with BwireO = p8_B(t, floor(13t/8)).
     PROVEN IMPOSSIBLE at the current wires: S4c
     (s4c_own_strip_gap: mown < BwireO; hence
     gapO_current_wires_impossible).  Closing GAP-O REQUIRES a
     strictly sharper P4-floor wire than p8_B at list scale —
     the gap is structural (mown = O(t^{-2}) vs
     Bwire >= (1/2)(13t/8)^{-1/2} = O(t^{-1/2})).

   So: RH (via P1.2, P12Uniform.p1_2) under S1+S2+S3
   (pointwise green, documented in P12Uniform) + GAP-W + a
   SHARPER OWN-REGIME WIRE (any wire W with W <= mown - Mr - Mf
   on the strip replaces BwireO in gapO).

   25v QUANTIFIED that requirement (RhAttack.S4Sharp, namespace S4S):
   any such wire W (with its own P4-floor residuals) must sit below
   the demand envelope Eenv(t) = (1/10^4)(16001/15984)·t^{-2} at the
   closure d-edge d = 1/200 (s4d_wire_demand); the current wire's
   first term (1/2)(13t/8)^{-1/2} exceeds that demand by
   Kgap·t^{3/2} with Kgap = (1/2)(8/13)^{1/2}·10^4·16001/15984,
   3926.494 to 7 digits (s4d_wire_deficit); and no p8_B-family scale
   n <= list scale 13t/8 sits below the demand for any t >= 1000
   (s4d_list_scale_impossible). The deficit is a POWER of t: the
   replacement wire must be of genuinely O(t^{-2}) shape, not a
   constant-factor sharpening of the O(t^{-1/2}) wire family.
   25ad (day026_ownwire_survey) SETTLED the EM family at the quantity
   level: |p4_em_expr(1/2+it, n)| is T1-dominant with T1 = -2^-1 n^-s
   irreducible (|EM|/Eenv = 3918.7 t^{3/2} (1.005), exponent 1.5002 at
   certified zero heights — no hidden t^{-2} decay) — BUT the quantity
   crosses Eenv exactly at the 25v scale boundary (|EM|/Eenv = 0.99994,
   constant in t, at n = 2.495e7 t^4): the replacement wire
   W(t) = p8_B(t, ceiling(3.1e7 t^4)) exists at the demand shape
   (term1 = 8.98e-5 t^{-2} = 90% of the true floor mown/Eenv = 0.99894).
   The open content is (a) the scale of the strip pairs' own-composition
   residuals (the action-composition item — the window residual
   CG3 = 4.1e-3 does not scale with mown ~ 1e-4 t^{-2}, so the t^4 EM
   wire alone does not close the strip), and (b) the 25ae sharpened T3
   bound (extending the PROVABLE quantity wall from t <= ~3.7e5 to all
   t >= 1000; the L4 IBP constant is loose by ~t, measured T3/T1 ~ 1e-3).

   Honest split: LEAN-PROVEN — the gap definitions, the
   impossibility (S4c), the low-window green (S4a), and the
   P1.2 composition (P12).  PINNED — tStar (25l[3] bisection,
   day023_s4_sweep.py; a measurement, not a proof).  Lean
   4.33.1 + Mathlib (pinned).
-/

namespace S4A
open Real B0

/-- GAP-W: the window-regime squeeze BEYOND the green window
    T0 = 1.1e5.  (On [1000, T0] it is GREEN — S4a.) -/
def gapW : Prop :=
    ∀ (t : ℝ), S4W.T0 < t → ∀ (M : ℝ), 0 ≤ M → M ≤ S4W.Zbound t →
      p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
          S4W.Xwire t < p8_f_near_pin

/-- S4a IS gapW on the green window [1000, T0]. -/
theorem s4a_is_gapw_low_window (t : ℝ) (ht : 1000 ≤ t) (htu : t ≤ S4W.T0)
    (hX : S4W.Xwire S4W.T0 ≤ S4W.RX) (M : ℝ) (hM : 0 ≤ M)
    (hMz : M ≤ S4W.Zbound t) :
    p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
        S4W.Xwire t < p8_f_near_pin :=
  S4W.s4a_window_squeeze t ht htu hX M hM hMz

/-- GAP-O: the own-regime squeeze on the strip at the CURRENT
    wires: definition side = BwireO = p8_B(t, floor(13t/8))
    plus nonnegative residual Mr and tail Mf; floor = mown(t,d)
    (exact own-height detector mass, S4b). -/
def gapO (Mr Mf : ℝ → ℝ) : Prop :=
    ∀ (t d : ℝ), 1000 ≤ t → 0 < d → d ≤ 1 / 2 →
      S4G.BwireO t + Mr t + Mf t < S4O.mown t d

/-- S4c, in gap-form: GAP-O is IMPOSSIBLE at the current wires —
    for any nonnegative Mr, Mf the strip squeeze fails somewhere
    (in fact at EVERY strip pair with t >= 1000). -/
theorem gapO_current_wires_impossible (Mr Mf : ℝ → ℝ)
    (hMr : ∀ t, 0 ≤ Mr t) (hMf : ∀ t, 0 ≤ Mf t) :
    ¬gapO Mr Mf := by
  intro hg
  have h := hg (1000 : ℝ) (1 / 2) (by norm_num) (by norm_num) (by norm_num)
  exact S4G.s4c_squeeze_impossible (1000 : ℝ) (1 / 2)
    (by norm_num) (by norm_num) (by norm_num) (Mr 1000) (Mf 1000)
    (hMr 1000) (hMf 1000) h

/-- PINNED (25l[3], day023_s4_sweep.py — bisection on the
    closed-form wires; a MEASUREMENT, not a proof): the
    window-regime squeeze holds numerically up to
    t* = 690349.0568 and fails beyond it (deficit 0.54 @ 1e6,
    +4.35 @ 3.15e7, Bwire-dominated). -/
def tStar : ℝ := 690349.0568

/-- THE RESIDUE COMPOSITION: S1 + S2 + S3 + S4 (the four
    structural hypotheses of P1.2) imply RH — restated here so
    the S4Asm module is self-contained: with S4 = (gapW ∧ gapO)
    instantiated at the current wires, RH follows; gapO is
    impossible there (S4c), so the bound-level residue is exactly
    gapW plus a sharper own-regime wire. -/
theorem rh_from_structural_hypotheses
    (q : ZeroSet) (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) >= flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  P12.p1_2 q Mf devOf Bwire Mr flo hs1 hs2 hs3 hs4


/- — 25z reclassification → 25ab/25ae/25af — the window + strip ASSEMBLY
    (the bound-level closure of the closure-relevant regimes, one import). — -/

/-- (25m-low + 25ab-high) THE WINDOW-REGIME CLOSURE AT THE BOUND LEVEL ON
    [1000, ∞): the window WIRE FAMILY — the list-scale wire n = ⌊13t/8⌋ on
    [1000, T0] (S4a; carries the PINNED wire pin hX : Xwire(T0) ≤ RX) and the
    growing wire n = ⌊t²⌋ on [T0, ∞) (25ab, unconditional) — satisfies, for
    every M in the RVM envelope 0 ≤ M ≤ Zbound(t):

        BwireW(t) + M·e^{XW(t)}·XW(t) < 0.9975 = p8_f_near_pin. -/
theorem s4asm_window_closure (hX : S4W.Xwire S4W.T0 ≤ S4W.RX) (t : ℝ)
    (ht : 1000 ≤ t) (M : ℝ) (hM : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    (if t ≤ S4W.T0 then
        p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
            S4W.Xwire t
     else
        p8_B t (S4G.nGrow t) + M * Real.exp (S4G.Xgrow t) * S4G.Xgrow t) <
        p8_f_near_pin := by
  split_ifs with hw
  · exact S4W.s4a_window_squeeze t ht hw hX M hM hMz
  · exact S4G.s4g_growth_squeeze t (not_le.mp hw).le M hM hMz

/-- (25z/25ab/25af) THE BOUND-LEVEL RESIDUE STATEMENT ON THE
    CLOSURE-RELEVANT REGIMES:
    (window) on [1000, ∞) — the window wire family < 0.9975 (the low
      window [1000, T0] carries the pinned Xwire pin hX; the high window is
      unconditional, 25ab);
    (strip)  on 1/200 ≤ d ≤ 1/2, t ≥ 1000 (25af) — the t⁴ wire
      n4 = ⌈3.1e7·t⁴⌉: p8_B(t, n4) + M·e^{X4}·X4 < mown(t, d) for all
      M in the RVM envelope.
    The d < 1/200 substrip and the t < 1000 band do NOT enter: the floor
    mown(t, d) falls below the t⁻² wire scale as d → 0 (measured squeeze
    edge d* = 0.004738 < 1/200 — 25af[7], PINNED) — and t < 1000 is
    data-verified territory, not bound-level. The off-pair coverage of the
    two regions ((i-b) proper) is the named next item. -/
theorem s4asm_residue (hX : S4W.Xwire S4W.T0 ≤ S4W.RX) :
    (∀ (t M : ℝ), 1000 ≤ t → 0 ≤ M → M ≤ S4W.Zbound t →
        (if t ≤ S4W.T0 then
            p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
                S4W.Xwire t
         else
            p8_B t (S4G.nGrow t) + M * Real.exp (S4G.Xgrow t) * S4G.Xgrow t) <
            p8_f_near_pin) ∧
    (∀ (t d M : ℝ), 1000 ≤ t → (1 / 200 : ℝ) ≤ d → d ≤ 1 / 2 → 0 ≤ M →
        M ≤ S4W.Zbound t →
        p8_B t (S4Strip.n4 t) + M * Real.exp (S4Strip.X4fun t) *
            S4Strip.X4fun t < S4O.mown t d) := by
  constructor
  · intro t M ht hM hMz
    exact s4asm_window_closure hX t ht M hM hMz
  · intro t d M ht hdlo hd hM hMz
    have hd0 : 0 < d := by linarith
    exact S4Strip.s4_strip_close t d M ht hd0 hdlo hd hM hMz

/-- (25af, in P1.2's exact S4 shape) the STRIP-REGION squeeze at worst
    case M = Zbound(t0): for 1000 ≤ t0, 1/200 ≤ d0 ≤ 1/2,

        Bwire + Mr + Mf  <  flo
    with Bwire := p8_B(t0, n4 t0), Mr + Mf := Zbound(t0)·e^{X4}·X4,
    flo := mown(t0, d0) — the detector mass of the pair's own height. -/
theorem s4asm_strip_region_S4 (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2) :
    p8_B t0 (S4Strip.n4 t0) + S4W.Zbound t0 * Real.exp (S4Strip.X4fun t0) *
        S4Strip.X4fun t0 < S4O.mown t0 d0 := by
  have hd0 : 0 < d0 := by linarith
  have hM0 : 0 ≤ S4W.Zbound t0 := by
    dsimp only [S4W.Zbound]
    exact mul_nonneg
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 1.6)
        (Real.rpow_nonneg (by linarith : (0 : ℝ) ≤ t0) (1 / 4 : ℝ)))
      (Real.log_nonneg (by linarith : (1 : ℝ) ≤ t0))
  exact S4Strip.s4_strip_close t0 d0 (S4W.Zbound t0) ht0 hd0 hdlo hd hM0 le_rfl

/-- (25ab, in P1.2's exact S4 shape) the WINDOW-REGION squeeze at worst
    case M = Zbound(t0): for t0 ≥ 1000,

        Bwire + Mr + Mf  <  flo
    with Bwire + Mr + Mf := the window wire family of
    s4asm_window_closure at M = Zbound(t0), flo := p8_f_near_pin = 0.9975
    (the near-regime detector pin). -/
theorem s4asm_window_region_S4 (hX : S4W.Xwire S4W.T0 ≤ S4W.RX)
    (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    (if t0 ≤ S4W.T0 then
        p8_B t0 (Nat.floor (13 * t0 / 8)) + S4W.Zbound t0 *
            Real.exp (S4W.Xwire t0) * S4W.Xwire t0
     else
        p8_B t0 (S4G.nGrow t0) + S4W.Zbound t0 *
            Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0) < p8_f_near_pin :=
  s4asm_window_closure hX t0 ht0 (S4W.Zbound t0) (by
    dsimp only [S4W.Zbound]
    exact mul_nonneg
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 1.6)
        (Real.rpow_nonneg (by linarith : (0 : ℝ) ≤ t0) (1 / 4 : ℝ)))
      (Real.log_nonneg (by linarith : (1 : ℝ) ≤ t0)))
    le_rfl


/- — (i-b) PROPER: the off-pair COVERAGE — window ∪ strip = the S4
    squeeze on the covered territory, plus the named residual
    territories (d0 > 1/2; the t0 < 1000 band). — -/

/-- (25z/25ab/25af) COVERAGE: every off-pair (t0, d0) with 1000 ≤ t0,
    0 < d0 ≤ 1/2 is squeezed, at worst-case M = Zbound(t0) in the RVM
    envelope, against its own-height detector floor:
      d0 ≥ 1/200 (strip, 25af):   p8_B(t0, n4 t0) + Zbound·e^{X4}·X4 < mown(t0, d0);
      d0 <  1/200 (window, 25m/ab): window wire family < 0.9975 (the near pin).
    Pairs with d0 > 1/2 (Re ρ outside (0, 1)) are empty for the ACTUAL
    zero set by the classical zero-free regions (Re s ≥ 1 and, via the
    functional equation, Re s ≤ 0 — CITED standard facts); the abstract
    ZeroSet does not encode them, so the composition below keeps that
    territory as an explicit hypothesis. -/
theorem s4asm_S4_on_pairs (hX : S4W.Xwire S4W.T0 ≤ S4W.RX)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd0 : 0 < d0) (hdmax : d0 ≤ 1 / 2) :
    (if (1 / 200 : ℝ) ≤ d0 then
        p8_B t0 (S4Strip.n4 t0) + S4W.Zbound t0 *
            Real.exp (S4Strip.X4fun t0) * S4Strip.X4fun t0
     else
        (if t0 ≤ S4W.T0 then
            p8_B t0 (Nat.floor (13 * t0 / 8)) + S4W.Zbound t0 *
                Real.exp (S4W.Xwire t0) * S4W.Xwire t0
         else
            p8_B t0 (S4G.nGrow t0) + S4W.Zbound t0 *
                Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0)) <
    (if (1 / 200 : ℝ) ≤ d0 then S4O.mown t0 d0 else p8_f_near_pin) := by
  by_cases hdge : (1 / 200 : ℝ) ≤ d0
  · rw [if_pos hdge, if_pos hdge]
    exact s4asm_strip_region_S4 t0 d0 ht0 hdge hdmax
  · rw [if_neg hdge, if_neg hdge]
    exact s4asm_window_region_S4 hX t0 ht0

/-- The residue DEFINITION side in P1.2's S4 shape, worst case
    M := Zbound(t0): the wire family of the applicable regime.
    (Values outside the covered territory 1000 ≤ t0, d0 ≤ 1/2 are
    arbitrary — that territory is carried by the residual hypotheses
    of rh_from_regime_closures.) -/
noncomputable def BwireR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then p8_B t0 (S4Strip.n4 t0)
      else if t0 ≤ S4W.T0 then p8_B t0 (Nat.floor (13 * t0 / 8))
      else p8_B t0 (S4G.nGrow t0)
    else 0

/-- The residue M + F side (the RVM-envelope worst-case M term). -/
noncomputable def MrR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then S4W.Zbound t0 *
          Real.exp (S4Strip.X4fun t0) * S4Strip.X4fun t0
      else if t0 ≤ S4W.T0 then S4W.Zbound t0 *
          Real.exp (S4W.Xwire t0) * S4W.Xwire t0
      else S4W.Zbound t0 * Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0
    else 0

def MfR (_ : ℝ × ℝ) : ℝ := 0

/-- The residue detector floor: the pair's own-height mass on the
    strip, the near-regime pin on the window. -/
noncomputable def floR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then S4O.mown t0 d0 else p8_f_near_pin
    else 1

/-- INSTANTIATION: under the residue wire/floor functions above, the
    covered territory satisfies P1.2's S4 inequality exactly. -/
theorem s4asm_residue_S4_covered (hX : S4W.Xwire S4W.T0 ≤ S4W.RX)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd0 : 0 < d0) (hdmax : d0 ≤ 1 / 2) :
    BwireR t0 d0 + MrR t0 d0 + MfR (t0, d0) < floR t0 d0 := by
  dsimp only [MfR]
  rw [add_zero]
  dsimp only [BwireR, MrR, floR]
  have hown : 1000 ≤ t0 ∧ d0 ≤ 1 / 2 := ⟨ht0, hdmax⟩
  rw [if_pos hown, if_pos hown, if_pos hown]
  by_cases hdge : (1 / 200 : ℝ) ≤ d0
  · rw [if_pos hdge, if_pos hdge, if_pos hdge]
    exact s4asm_strip_region_S4 t0 d0 ht0 hdge hdmax
  · rw [if_neg hdge, if_neg hdge, if_neg hdge]
    have hcomb : (if t0 ≤ S4W.T0 then
              p8_B t0 (Nat.floor (13 * t0 / 8))
            else p8_B t0 (S4G.nGrow t0)) +
        (if t0 ≤ S4W.T0 then
            S4W.Zbound t0 * Real.exp (S4W.Xwire t0) * S4W.Xwire t0
          else
            S4W.Zbound t0 * Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0) =
        (if t0 ≤ S4W.T0 then
            p8_B t0 (Nat.floor (13 * t0 / 8)) + S4W.Zbound t0 *
                Real.exp (S4W.Xwire t0) * S4W.Xwire t0
          else
            p8_B t0 (S4G.nGrow t0) + S4W.Zbound t0 *
                Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0) := by
      by_cases hT : t0 ≤ S4W.T0
      · rw [if_pos hT, if_pos hT, if_pos hT]
      · rw [if_neg hT, if_neg hT, if_neg hT]
    rw [hcomb]
    exact s4asm_window_region_S4 hX t0 ht0

/-- (25z/25ab/25ae/25af) THE S4 COMPOSITION: RH from the four P1.2
    hypotheses with S4 SUPPLIED BY THE REGIME CLOSURES — the covered
    territory (t0 ≥ 1000, d0 ≤ 1/2) is the window ∪ strip closure
    (25m/25ab window, 25af strip), and the two residual territories
    are kept EXPLICIT:
      (i)   d0 > 1/2 — Re ρ outside (0, 1): empty for the actual zero
            set (classical zero-free regions, CITED);
      (ii)  the t0 < 1000 band — data-verified territory, not bound-level.
    This is the (i-b) assembly: the bound-level residue of S4 on the
    closure-relevant regimes is exactly window + strip, both closed. -/
theorem rh_from_regime_closures (q : ZeroSet)
    (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
        ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
        devOf (t0, d0) >= flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
        P12.offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))
    (hs4covered : ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 ≤ 1 / 2 →
        P12.offPair q t0 d0 →
        Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0))
    (hs4low : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 1000 → 0 < d0 → d0 ≤ 1 / 2 →
        P12.offPair q t0 d0 →
        Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0))
    (hs4far : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → d0 > 1 / 2 →
        P12.offPair q t0 d0 →
        Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q := by
  refine P12.p1_2 q Mf devOf Bwire Mr flo hs1 hs2 hs3 ?_
  intro t0 d0 ht0 hd0 hpair
  by_cases hdm : d0 ≤ 1 / 2
  · by_cases htl : 1000 ≤ t0
    · exact hs4covered t0 d0 htl hd0 hdm hpair
    · exact hs4low t0 d0 ht0 (by linarith) hd0 hdm hpair
  · exact hs4far t0 d0 ht0 hd0 (not_le.mp hdm) hpair

end S4A
