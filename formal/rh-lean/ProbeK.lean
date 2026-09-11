import Mathlib
import Mathlib.Tactic

set_option maxErrors 300

noncomputable section
open Real Set MeasureTheory intervalIntegral

variable {f g : ℝ → ℝ} {a b c : ℝ} (h'ab : a < b)

/-- K1: EqOn apply form -/
example (s : Set ℝ) (h : s.EqOn (fun z => 1 / z) (deriv log)) (p : ℝ) (hp : p ∈ s) :
    (1 / p) = deriv log p := by
  exact h hp

/-- K2: integral_const gives smul target -/
example (y : ℝ) (hy : 0 < y) (hy1 : y < 1) :
    ∫ z in (1 - y)..1, (1 / (1 - y)) = y / (1 - y) := by
  rw [intervalIntegral.integral_const]
  simp [smul_eq_mul]
  field_simp [(by linarith : 0 < 1 - y).ne']
  ring

/-- K2b: hP identity field_simp with explicit side condition -/
example (e : ℝ) (he : 1 - e ≠ 0) (hpos : 0 < e) :
    e / (1 - e) = 1 / (1 - e) - 1 := by
  field_simp [he]
  ring

/-- K3: hset with manual by_cases bullets -/
example (c : ℝ) (hac : a < c) (hcb : c < b) :
    uIoc a b = uIoc a c ∪ uIoc c b := by
  ext x
  rw [uIoc_of_le (le_of_lt h'ab),
      uIoc_of_le (le_of_lt hac),
      uIoc_of_le (le_of_lt hcb)]
  simp only [Set.mem_Ioc, Set.mem_union]
  constructor
  · intro h
    by_cases hc : c < x
    · exact Or.inr ⟨hc, h.2⟩
    · exact Or.inl ⟨h.1, not_lt.mp hc⟩
  · intro h
    cases h with
    | inl h => exact ⟨h.1, le_trans h.2 (le_of_lt hcb)⟩
    | inr h => exact ⟨lt_trans hac h.1, h.2⟩

/-- K4a: parse pin — outer (two-integral) reading of `∫ + ∫` -/
def Rfun (x : ℝ) : ℝ := x
example : (∫ x in a..c, Rfun x) + ∫ x in c..b, Rfun x = 0 := by
  change (∫ x in a..c, Rfun x) + (∫ x in c..b, Rfun x) = 0

/-- K4b: parse pin — inner (extended integrand) reading -/
example : (∫ x in a..c, Rfun x) + ∫ x in c..b, Rfun x = 0 := by
  change ∫ x in a..c, Rfun x + ∫ x in c..b, Rfun x = 0

/-- K5: Sbar pointwise split via field_simp -/
def SbarK (x : ℝ) : ℝ := 0.110 * log x + 0.290 * log (log x) + 2.290
example (x : ℝ) (hx0 : 0 < x) (hlx : 0 < log x) :
    SbarK x / x^3 = 0.110 * log x / x^3 + 0.290 * log (log x) / x^3 + 2.290 / x^3 := by
  dsimp only [SbarK]
  field_simp [hx0.ne', hlx.ne']

/-- K6: remainder-term split with hoisted nonzero -/
example (x : ℝ) (hx0 : 0 < x) (hlx : 1 ≤ log x) :
    0.290 / (2 * x^3 * log x) = (0.290 / (2 * x^3)) * (1 / log x) := by
  have hln0 : log x ≠ 0 := by
    intro h1
    linarith [hlx, h1]
  field_simp [hx0.ne', hln0]
  ring

/-- K7: rayEndFormEq by_cases proof -/
def rayIntegrandK (f : ℝ → ℝ) (c x : ℝ) : ℝ := if c ≤ x then deriv f x else 0
example (a b p : ℝ) (f : ℝ → ℝ) (h'ab : a < b) :
    f b * (if p ≤ b then (1 : ℝ) else 0) - f a * (if p ≤ a then (1 : ℝ) else 0)
      - (if a < p ∧ p ≤ b then f p else 0) =
      if p ≤ a then f b - f a else if p < b then f b - f p else 0 := by
  by_cases hgb : p ≤ b
  · by_cases hga : p ≤ a
    · rw [if_pos hgb, if_pos hga]
      have hnot3 : ¬(a < p ∧ p ≤ b) := by
        intro h1
        linarith [h1.1, hga]
      rw [if_neg hnot3]
      ring
    · have h3a : a < p := not_le.mp hga
      by_cases hglt : p < b
      · rw [if_pos hgb, if_neg hga, if_pos hglt]
        rw [if_pos (show a < p ∧ p ≤ b from ⟨h3a, le_of_lt hglt⟩)]
        ring
      · rw [if_pos hgb, if_neg hga, if_neg hglt]
        rw [if_pos (show a < p ∧ p ≤ b from ⟨h3a, hgb⟩)]
        have hbg : p = b := le_antisymm hgb (le_of_not_lt hglt)
        rw [hbg]
        ring
  · by_cases hga : p ≤ a
    · exfalso
      linarith [hga, not_le.mp hgb, h'ab]
    · have hnot3 : ¬(a < p ∧ p ≤ b) := by
        intro h1
        exact hgb h1.2
      have hnot4 : ¬p < b := by
        intro h1
        exact hgb (le_of_lt h1)
      rw [if_neg hgb, if_neg hga, if_neg hnot3, if_neg hnot4]
      ring

/-- K8: triangle step via nlinarith -/
example (A B C : ℝ) :
    |A| + |B + C| ≤ |A| + |B| + |C| := by
  nlinarith [abs_add_le B C]

/-- K8b: exact abs_add_le / abs_sub_le signatures -/
example (B C : ℝ) : |B + C| ≤ |B| + |C| := by
  exact abs_add_le B C

example (A B : ℝ) : |A - B| ≤ |A| + |B| := by
  exact abs_sub_le A B

/-- K9: continuousAt_log with ne_of_gt; comp with declared type -/
example (z c : ℝ) (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => log (w * c)) z := by
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log (ne_of_gt (mul_pos hz hc))
  exact ContinuousAt.comp h2 h1

/-- K10: abs_integral_le_integral_abs with explicit hab -/
example (L : List ℝ) (G B : ℝ) (hGB : G < B)
    (hII : IntervalIntegrable (fun x : ℝ => (2 * x - 1) * x) volume G B)
    (hIIabs : IntervalIntegrable (fun x : ℝ => |(2 * x - 1) * x|) volume G B) :
    |∫ x in G..B, (2 * x - 1) * x| ≤ ∫ x in G..B, |(2 * x - 1) * x| := by
  exact intervalIntegral.abs_integral_le_integral_abs (le_of_lt hGB)

/-- K11: integral_congr_uIoo with (μ := volume) in rw -/
example (H : ℝ → ℝ) (HH : ∀ x ∈ uIoo a b, H x = 2 * x) (hI : IntervalIntegrable H volume a b) :
    (∫ x in a..b, H x) = ∫ x in a..b, (2 * x) := by
  rw [integral_congr_uIoo (μ := volume) HH]

end
