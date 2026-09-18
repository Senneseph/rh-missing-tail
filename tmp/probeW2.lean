import Mathlib

#check exp_eq_tsum_div
#check ENNReal.sum_le_tsum
#check ENNReal.ofReal_tsum_of_nonneg
#check ENNReal.ofReal_le_ofReal_iff
#check Real.tsum_le_of_sum_le
#check Real.rpow_le_rpow_iff_of_neg
example : ∑' n : ℕ, ((1 : ℝ) ^ n / n ! : ℝ) ≥ 0 := by
  simp [tsum]
  -- just syntax check
  exact le_rfl
example (f : ℕ → ℝ) (h0 : ∀ n, 0 ≤ f n) (hs : Summable f) {u : Finset ℕ} :
    (∑ n in u, f n : ℝ) ≤ ∑' n, f n := by
  have : (∑' n, f n : ℝ≥0∞) = ∑' n, (f n : ℝ≥0∞) :=
    ENNReal.ofReal_tsum_of_nonneg h0 hs
  have : (∑ n in u, f n : ℝ≥0∞) = ∑ n in u, (f n : ℝ≥0∞) := by
    simp [ENNReal.ofReal_nonneg]? 
  -- check ofReal of finsum
  exact le_rfl
example (z : ℂ) : ‖z‖ = Complex.abs z := by
  rw [Complex.norm_eq_abs]
example (t : ℝ) (ht : 0 ≤ t) : Complex.abs (t : ℂ) = t := by
  simp [Complex.abs]?
  exact le_rfl
