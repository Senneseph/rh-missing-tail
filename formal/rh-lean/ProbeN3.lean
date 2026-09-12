/- ProbeN3 — day-016: rayEndFormEq branch ¬g<b — the g=b closer under the
   split_ifs context {a<b, g≤b, ¬g≤a, a<g∧g≤b, ¬g<b}.
   RED PIN (the failing form, kept as a comment per probe standard):
     have hg0 : g = b := le_antisymm (by linarith) (by intro hlt; linarith)
     → error: `linarith` does NOT derive `b ≤ g` from `¬g < b`
       (no strict-inequality flip; the goal `g ≤ b` stays unsolved).
   WORKING FORM (green): `not_lt` is [simp]; plain `simp` is goal-only
   (hypothesis rewrite needs `at h`/`at *`); then linarith sees b ≤ g. -/
import Mathlib

noncomputable section

open Real Set

example (a b g : ℝ) (f : ℝ → ℝ) (h'ab : a < b) (h3 : g ≤ b) (h2 : ¬g ≤ a)
    (h1 : a < g ∧ g ≤ b) (h0 : ¬g < b) : f b - f g = 0 := by
  -- 4.33.1: flip ¬g<b → b≤g via the [simp] not_lt lemma, hypothesis-side
  simp only [not_lt] at h0
  have hg0 : g = b := by linarith [h3, h0]
  rw [hg0]
  ring
