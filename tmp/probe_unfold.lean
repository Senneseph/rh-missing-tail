import Mathlib

noncomputable def SsumUB (t : ℝ) : ℝ := 20 + 4 * Real.log t
noncomputable def Bf4UB (t : ℝ) : ℝ :=
    (2 + 1 / t + 1 / (t * t)) * (1 / (t ^ 6)) / (62000000 * 62000000)

example (t : ℝ) : Bf4UB t * SsumUB t = Bf4UB t * SsumUB t := by
  unfold Bf4UB, SsumUB
  trivial

example (t : ℝ) : SsumUB t = 20 + 4 * Real.log t := by
  unfold SsumUB
  trivial
