import Mathlib
import RhAttack.B5

open Real
open Complex

def wFloorC (t d : ℝ) : ℝ :=
    (1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2) + (1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)

example (t d : ℝ) :
    ‖poff t d t‖ =
      d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) /
        (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
  dsimp only [poff, rhoPP, rhoPM, rhoNP, rhoNM, sLine, halfR]
  have h2inv : (2 : ℝ)⁻¹ = 1 / 2 := by norm_num
  rw [h2inv]
  change ‖fac (((1 / 2 : ℝ) + d) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
           fac (((1 / 2 : ℝ) + d) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
           fac (((1 / 2 : ℝ) - d) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
           fac (((1 / 2 : ℝ) - d) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
      d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) /
        (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2))
