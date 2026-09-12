/- ProbeN6 — day-016: multi-tactic calc-step justification in 4.33.1.
   PINS (all green now; failures recorded per probe standard):
   (1) bare `:= by` + NEXT-LINE tactic sequence (one or many) LEAKS the
       tactics into calc-continuation parse mode:
       "unexpected token '<;>'; expected ':='" / "Unknown identifier
       `field_simp`" / calc LHS shows the leaked term. The justification
       of a calc step must be SAME-LINE (single tactic) or a `by { ... }`
       block.
   (2) `:= by <TERM>` (a bare proof term, not a tactic) = "unknown tactic".
   (3) a calc `:= by field_simp [...]` closes the step ALONE (auto-close);
       a trailing `ring_nf`/`field_simp`/`ring` dance = "No goals to be
       solved".
   (4) `0 ≤ 2*x^3` from `0 < x`: nlinarith [hx0] CANNOT see x^3;
       `positivity` does. (This is what the original B3Sbar hremle step
       needed.) -/
import Mathlib

noncomputable section

open Real Set

example (x : ℝ) (hposG : 0 < x) (hlx : 1 ≤ log x) (hinv : 1 / log x ≤ 1) :
    0.290 / (2 * x^3 * log x) ≤ 0.290 / (2 * x^3) := by
  have hx0 : 0 < x := hposG
  have hlnz : log x ≠ 0 := by linarith [hlx]
  calc 0.290 / (2 * x^3 * log x) = (0.290 / (2 * x^3)) * (1 / log x) := by field_simp [hx0.ne', hlnz]
  _ ≤ (0.290 / (2 * x^3)) * 1 := by {
    apply mul_le_mul_of_nonneg_left hinv
    apply div_nonneg
    · norm_num
    · positivity
  }
  _ = 0.290 / (2 * x^3) := by ring
