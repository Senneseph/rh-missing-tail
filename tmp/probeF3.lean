import Mathlib

noncomputable section

theorem test_hsplit (n : ℕ) :
    (fun x : Real => (∏ k ∈ Finset.range ((n + 1) + 1), (x ^ 2 + (k + 1/2 : Real) ^ 2))) =
      (fun x : Real => (∏ k ∈ Finset.range (n + 1), (x ^ 2 + (k + 1/2 : Real) ^ 2)) *
        (x ^ 2 + ((n + 1 : Real) + 1/2) ^ 2)) := by
  funext x
  rw [Finset.prod_range_succ]
  norm_num
