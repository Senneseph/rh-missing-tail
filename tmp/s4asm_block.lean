
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
  · exact S4G.s4g_growth_squeeze t (le_of_not_le hw) M hM hMz

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
    apply mul_nonneg
    · norm_num
    · exact mul_nonneg (Real.rpow_nonneg (by linarith : (0 : ℝ) ≤ t0)
          (1 / 4 : ℝ))
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
    apply mul_nonneg
    · norm_num
    · exact mul_nonneg (Real.rpow_nonneg (by linarith : (0 : ℝ) ≤ t0)
          (1 / 4 : ℝ))
        (Real.log_nonneg (by linarith : (1 : ℝ) ≤ t0)))
    le_rfl
