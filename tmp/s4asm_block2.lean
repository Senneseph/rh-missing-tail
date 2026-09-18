
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
  split_ifs with hdge
  · exact s4asm_strip_region_S4 t0 d0 ht0 hdge hdmax
  · exact s4asm_window_region_S4 hX t0 ht0

/-- The residue DEFINITION side in P1.2's S4 shape, worst case
    M := Zbound(t0): the wire family of the applicable regime.
    (Values outside the covered territory 1000 ≤ t0, d0 ≤ 1/2 are
    arbitrary — that territory is carried by the residual hypotheses
    of rh_from_regime_closures.) -/
def BwireR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then p8_B t0 (S4Strip.n4 t0)
      else if t0 ≤ S4W.T0 then p8_B t0 (Nat.floor (13 * t0 / 8))
      else p8_B t0 (S4G.nGrow t0)
    else 0

/-- The residue M + F side (the RVM-envelope worst-case M term). -/
def MrR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then S4W.Zbound t0 *
          Real.exp (S4Strip.X4fun t0) * S4Strip.X4fun t0
      else if t0 ≤ S4W.T0 then S4W.Zbound t0 *
          Real.exp (S4W.Xwire t0) * S4W.Xwire t0
      else S4W.Zbound t0 * Real.exp (S4G.Xgrow t0) * S4G.Xgrow t0
    else 0

def MfR (_ : ℝ × ℝ) : ℝ := 0

/-- The residue detector floor: the pair's own-height mass on the
    strip, the near regimE pin on the window. -/
def floR (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 then
      if (1 / 200 : ℝ) ≤ d0 then S4O.mown t0 d0 else p8_f_near_pin
    else 1

/-- INSTANTIATION: under the residue wire/floor functions above, the
    covered territory satisfies P1.2's S4 inequality exactly. -/
theorem s4asm_residue_S4_covered (hX : S4W.Xwire S4W.T0 ≤ S4W.RX)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd0 : 0 < d0) (hdmax : d0 ≤ 1 / 2) :
    BwireR (t0, d0) + MrR (t0, d0) + MfR (t0, d0) < floR (t0, d0) := by
  dsimp only [MfR]
  rw [add_zero]
  split_ifs with hov hdge hT
  · exfalso
    apply hov
    exact ⟨ht0, hdmax⟩
  · exact s4asm_strip_region_S4 t0 d0 ht0 hdge hdmax
  · exact s4asm_window_region_S4 hX t0 ht0

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
