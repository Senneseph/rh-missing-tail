/-
  day-013: B3 §4.2 ray value — the three-case evaluation of (c ≤ x) ⟼ deriv f x, cases p1 (c ≤ a) and p2 (a < c < b). Ported: rayInt_eval in B3.lean.
-/ 
import Mathlib
open Set
open intervalIntegral

variable {f : ℝ → ℝ} {a b c : ℝ}
def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

-- P1: the case1 congr lambda from rayInt_eval
theorem p1 (h'ab : a < b) (hc' : c ≤ a) :
    ∀ x ∈ uIoo a b, rayIntegrand f c x = deriv f x := by
  intro x hx
  rw [uIoo_of_lt h'ab] at hx
  have hcxe : c ≤ x := le_trans hc' (le_of_lt hx.1)
  dsimp only [rayIntegrand]
  simp [hcxe]

-- P2: the hset identity uIoc a b = uIoc a c ∪ uIoc c b for a < c < b
theorem p2 (h'ab : a < b) (hc'b : c < b) (hac : a < c) :
    uIoc a b = uIoc a c ∪ uIoc c b := by
  ext x
  rw [uIoc_of_le (le_of_lt h'ab), uIoc_of_le (le_of_lt hac), uIoc_of_le (le_of_lt hc'b)]
  simp only [Set.mem_Ioc, Set.mem_union]
  constructor
  · rintro ⟨ha, hxb⟩
    by_cases hc : c ≤ x
    · exact Or.inr ⟨hc, hxb⟩
    · exact Or.inl ⟨ha, by linarith [hc]⟩
  · rintro (⟨ha, hxc⟩ | ⟨hc, hxb⟩)
    · exact ⟨ha, by linarith [hxc, hc'b]⟩
    · exact ⟨by linarith [hac], hxb⟩

-- P3: rayIntegrable-style with explicit c pinning (named arg)
section
variable (hf'cont : ContinuousOn (deriv f) (Icc a b)) (h'ab : a < b)
theorem p3test (hac : a < c)
    (hfda' : ContinuousOn (deriv f) (Icc a c)) (hcb : c < b)
    (hfdc' : ContinuousOn (deriv f) (Icc c b)) :
    IntervalIntegrable (fun x => rayIntegrand f c x) volume a c :=
  by
  have hf'cA := hf'cont.mono (Icc_subset_Icc le_rfl (le_of_lt hcb))
  -- placeholder: use rayIntegrable if it exists in this scope; otherwise skip
  exact (by
    have h := derivIntegrableCont' hac hfda'
    exact h)
def derivIntegrableCont' (h'ac : a < c) (hf'cont2 : ContinuousOn (deriv f) (Icc a c)) :
    IntervalIntegrable (deriv f) volume a c :=
  hf'cont2.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ac)
end

-- P4: triangle abs_sub & abs_add'
example (A B : ℝ) : |A - B| ≤ |A| + |B| := abs_sub A B
example (A B : ℝ) : |A + B| ≤ |A| + |B| := by
  simpa [abs_neg, show A + B = (-B) + (A + B) by ring] using abs_add' (A + B) (-B)

-- P5: not_lt / sub_ne_zero / ne_of_gt
example (u v : ℝ) (h : ¬u < v) : v ≤ u := by simpa using not_lt h
example (d : ℝ) (hd : 0 < 1 - d) : 1 - d ≠ 0 := ne_of_gt hd
example (t G x : ℝ) (hGt : t < G) (hx : G ≤ x) : 0 < G := by linarith [hGt, show 0 < t from by linarith]

-- P6: log_le_log arg order
example (G x : ℝ) (hG : Real.exp 1 ≤ G) (hx : 0 < t1) (t1 : ℝ) (hGt : t1 < G) (hGx : G ≤ x) :
    Real.log G ≤ Real.log x := Real.log_le_log (by linarith [hGt, hx]) hGx

-- P7: ContinuousAt -> ContinuousWithinAt (s implicit)
example (g : ℝ → ℝ) (x : ℝ) (h : ContinuousAt g x) (s : Set ℝ) : ContinuousWithin g s x :=
  h.continuousWithinAt
