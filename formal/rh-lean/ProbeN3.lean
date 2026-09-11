/- ProbeN3 — day-016: rayEndFormEq branch¬g<b — does the g=b closer close under the
   split_ifs context {a<b, g≤b, ¬g≤a, a<g∧g≤b, ¬g<b}? -/
import Mathlib

noncomputable section

open Real Set

example (a b g : ℝ) (f : ℝ → ℝ) (h'ab : a < b) (h3 : g ≤ b) (h2 : ¬g ≤ a)
    (h1 : a < g ∧ g ≤ b) (h0 : ¬g < b) : f b - f g = 0 := by
  have hg0 : g = b := le_antisymm (by linarith) (by intro hlt; linarith)
  rw [hg0]
  ring
