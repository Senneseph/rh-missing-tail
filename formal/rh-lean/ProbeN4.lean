/- ProbeN4 — day-016: under ctx {a<b, g≤b, ¬g≤a, a<g∧g≤b, ¬g<b}: which g=b derivation
   works? (1) not_lt.mp  (2) plain linarith on g = b  (3) end-to-end closer. -/
import Mathlib

noncomputable section

open Real Set

example (a b g : ℝ) (h'ab : a < b) (h3 : g ≤ b) (h2 : ¬g ≤ a)
    (h1 : a < g ∧ g ≤ b) (h0 : ¬g < b) : b ≤ g := by
  exact not_lt.mp h0

example (a b g : ℝ) (h'ab : a < b) (h3 : g ≤ b) (h2 : ¬g ≤ a)
    (h1 : a < g ∧ g ≤ b) (h0 : ¬g < b) : g = b := by
  linarith

example (a b g : ℝ) (f : ℝ → ℝ) (h'ab : a < b) (h3 : g ≤ b) (h2 : ¬g ≤ a)
    (h1 : a < g ∧ g ≤ b) (h0 : ¬g < b) : f b - f g = 0 := by
  have hg0 : g = b := by linarith
  rw [hg0]
  ring
