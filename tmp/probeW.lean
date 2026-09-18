import Mathlib

open Real

example (t : ℝ) (ht : 1000 ≤ t) : (31000000 : ℝ) * t ^ 4 ≤ (⌈(31000000 : ℝ) * t ^ 4⌉₊ : ℝ) := by
  exact le_ceil _

example : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
example : ‖(Complex.I : ℂ)‖ = 1 := by norm_num
example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  have h1 : ‖(t : ℂ)‖ = Complex.abs (t : ℂ) := by simp [Complex.norm_eq_abs]?
  sorry

example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) (hz : z < 0) : a ^ z ≤ b ^ z ↔ b ≤ a := by
  exact rpow_inv_le_iff_of_neg ha hb hz

example (x : ℝ) (hx : 0 < x) (y z : ℝ) : x ^ (y + z) = x ^ y * x ^ z := rpow_add hx y z
example (x : ℝ) (hx : 0 ≤ x) (y : ℝ) : x ^ (-y) = (x ^ y)⁻¹ := rpow_neg hx y
example (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) : (x * y) ^ z = x ^ z * y ^ z := mul_rpow hx hy

#check ENNReal.sum_le_tsum
#check ENNReal.ofReal_tsum_of_nonneg
#check ENNReal.ofReal_le_ofReal_iff
#check Real.tsum_le_of_sum_le
#check norm_expSeries_summable'
example (f : ℕ → ℝ) (h0 : 0 ≤ f) (hu : u ⊆ Finset.univ) : (∑ n in u, (f n : ℝ≥0∞)) = (∑ n in u, f n : ℝ≥0∞) := by
  have := ENNReal.sum_le_tsum fun n : ℕ => (f n : ℝ≥0∞) u
  simp
example : Summable (fun n : ℕ, (1 : ℝ) / n !) := by
  have h : Summable (fun n : ℕ, (n !⁻¹ : ℝ) • (1 : ℝ) ^ n) := by
    simpa using norm_expSeries_summable' (1 : ℝ)
  convert h.of_norm using 1
  funext n
  simp [smul_eq_mul]
  -- (n!⁻¹ : ℝ) • 1^n = n!⁻¹ * 1 = 1/n!
  ring
theorem sum_range_geom_le {r : ℝ} (hr : 0 ≤ r) (hr1 : r < 1) (K : ℕ) :
    ∑ j in Finset.range K, r ^ j ≤ (1 - r)⁻¹ := by
  calc ∑ j in Finset.range K, r ^ j ≤ ∑' j : ℕ, r ^ j := by
    -- ENNReal bridge for finsum ≤ tsum
    have hnn : 0 ≤ ∑ j in Finst.range K, r ^ j := Finst.sum_nonneg fun j _ => pow_nonneg hr j
    sorry
    _ = (1 - r)⁻¹ := by rw [tsum_geometric_of_lt_one hr hr1]
