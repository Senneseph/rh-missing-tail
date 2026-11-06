import Mathlib

set_option linter.style.whitespace false

namespace ProbeRW4
open Set

example : Continuous (fun t : ℝ => (t : ℂ)) := by
  dsimp [Continuous]
  exact continuous_ofReal

example : Continuous (fun t : ℝ => (t : ℂ) * (↑t : ℂ)) := by
  dsimp [Continuous]
  exact (Continuous.mul continuous_id continuous_id)

example (f : ℝ → ℂ) (hf : ∀ x, ContinuousAt f x) : Continuous f := by
  dsimp [Continuous]
  exact hf
end ProbeRW4
