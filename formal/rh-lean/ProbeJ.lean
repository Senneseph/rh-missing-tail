import Mathlib
import Mathlib.Tactic

set_option maxErrors 300

noncomputable section
open Real Set MeasureTheory intervalIntegral

variable {f g : ℝ → ℝ} {a b x : ℝ} (h'ab : a < b)

/-- probe 1: EqOn application with implicit point -/
example (s : Set ℝ) (h : EqOn (fun z => 1 / z) (deriv log) s) (p : ℝ) (hp : p ∈ s) :
    (1 / p) = deriv log p := by
  exact h hp

/-- probe 2: smul target -/
example (y : ℝ) (hy : 0 < y) (hy1 : y < 1) :
    (1 - (1 - y)) • (1 / (1 - y)) = y / (1 - y) := by
  simp [smul_eq_mul]
  ring

/-- probe 3: hP identity via field_simp; ring -/
example (z : ℝ) (hz : 0 < z) (hz1 : z < 1) :
    z / (1 - z) = 1 / (1 - z) - 1 := by
  field_simp
  ring

/-- probe 4: hset for uIoc split -/
example (c : ℝ) (hac : a < c) (hcb : c < b) :
    uIoc a b = uIoc a c ∪ uIoc c b := by
  ext x
  rw [uIoc_of_le (le_of_lt h'ab),
      uIoc_of_le (le_of_lt hac),
      uIoc_of_le (le_of_lt hcb)]
  simp [Set.mem_Ioc, Set.mem_union]

/-- probe 5: foldr NList basics -/
def NList (L : List ℝ) (x : ℝ) : ℝ :=
  L.foldr (fun (g : ℝ) (acc : ℝ) => acc + (if g ≤ x then (1 : ℝ) else 0)) 0

example (x : ℝ) : NList [] x = 0 := by
  dsimp only [NList]
  ring

example (x : ℝ) (T : List ℝ) (w : ℝ) :
    NList (w :: T) x = (if w ≤ x then (1 : ℝ) else 0) + NList T x := by
  dsimp only [NList]
  simp

/-- probe 6: hpt-style with foldr NList -/
example (x : ℝ) (T : List ℝ) (w : ℝ) (d : ℝ) :
    NList (w :: T) x * d = (if w ≤ x then d else 0) + NList T x * d := by
  dsimp only [NList]
  by_cases hgw : w ≤ x
  · simp [hgw]
    ring
  · simp [hgw]
    ring

/-- probe 7: continuousAt_log argument -/
example (z : ℝ) (hz : 0 < z) : ContinuousAt (log : ℝ → ℝ) z :=
  Real.continuousAt_log hz.ne

/-- probe 8: ContinuousAt.comp for log(z*c) -/
example (z c : ℝ) (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => log (w * c)) z := by
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul (continuousAt_const (c : ℝ))
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log (ne_of_gt (mul_pos hz hc))
  exact ContinuousAt.comp h2 h1

/-- probe 9: let-H rw in calc-style goal -/
example (H : ℝ → ℝ) (c1 c2 c3 : ℝ) (h : ∫ x in a..b, deriv H x = c1)
    : ∫ x in a..b, deriv H x - c2 = c1 - c2 := by
  rw [h]

/-- probe 9b: let-H via `set` -/
example : ∫ x in a..b, -2 * x = (-(b * b)) + (a * a) := by
  set HH := fun x : ℝ => x * x with hHH
  have hh : ∫ x in a..b, deriv HH x = HH b - HH a := by
    rw [integral_eq_sub_of_hasDerivAt]
    · intro x hx
      have hd : HasDerivAt HH (2 * x) x := by
        simpa [HH] using ((hasDerivAt_id' (x : ℝ)).const 2 (right := x))
      exact HasDerivAt.deriv hd
    · exact integral_id (hab := le_of_lt h'ab)
  rw [show ∫ x in a..b, -2 * x = ∫ x in a..b, deriv HH x from by
    congr
    intro x
    have hd : HasDerivAt HH (2 * x) x := by
      simpa [HH] using ((hasDerivAt_id' (x : ℝ)).const 2 (right := x))
    simpa [HH] using (HasDerivAt.deriv hd).symm]
  rw [hh]
  ring

/-- probe 10: abs_integral_le_integral_abs with argument -/
example (L : List ℝ) (G B : ℝ) (hGB : G < B)
    (hII : IntervalIntegrable (fun x => (2 * x - 1) * x) volume G B) :
    |∫ x in G..B, (2 * x - 1) * x| ≤ ∫ x in G..B, |(2 * x - 1) * x| := by
  exact intervalIntegral.abs_integral_le_integral_abs (le_of_lt hGB)

/-- probe 11: rw of point equality under bound lambda in ContinuousWithinAt -/
example (F : ℝ → ℝ) (p : ℝ) (hF : p ∈ Icc 0 1)
    (hd : deriv F p = fun y => 2 * y) :
    ContinuousWithinAt (fun y => |deriv F y|) (Icc 0 1) p := by
  dsimp
  have hc1 : ContinuousAt (fun y => deriv F y) p := by
    simpa [deriv] using hd
  exact Continuous.abs hc1 |>.continuousWithinAt (s := Icc 0 1) hF

/-- probe 12: ring after dsimp of let (trivial goal) -/
def Δfun (x : ℝ) : ℝ := (2 * x - 3) * (x + 1)
example : ∀ x, Δfun x = (2 * x - 3) * (x + 1) := by
  intro x
  dsimp only [Δfun]
  ring

/-- probe 13: rayEndFormEq manual proof -/
theorem rayEndFormEq (a b p : ℝ) (f : ℝ → ℝ) (h'ab : a < b) :
    f b * (if p ≤ b then (1 : ℝ) else 0) - f a * (if p ≤ a then (1 : ℝ) else 0)
      - (if a < p ∧ p ≤ b then f p else 0) =
      if p ≤ a then f b - f a else if p < b then f b - f p else 0 := by
  by_cases hgb : p ≤ b
  · by_cases hga : p ≤ a
    · rw [if_pos hgb, if_pos hga]
      have hnot3 : ¬(a < p ∧ p ≤ b) := by
        intro h1
        linarith [h1.1, hga]
      rw [hnot3]
      ring
    · have h3a : a < p := by tauto
      by_cases hglt : p < b
      · rw [if_pos hgb, if_neg hga, if_pos hglt]
        rw [show a < p ∧ p ≤ b from ⟨h3a, by linarith⟩]
        ring
      · rw [if_pos hgb, if_neg hga, if_neg hglt]
        rw [show a < p ∧ p ≤ b from ⟨h3a, hgb⟩]
        have hpb : p = b := le_antisymm hgb (by linarith [hglt])
        rw [hpb]
        ring
  · by_cases hga : p ≤ a
    · exfalso
      linarith [hga, h'ab, by tauto : b < p]
    · have hnot3 : ¬(a < p ∧ p ≤ b) := by
        intro h1
        tauto
      have hnot4 : ¬p < b := by
        intro h1
        tauto
      rw [if_neg hgb, if_neg hga, hnot3, hnot4]
      ring

/-- probe 14: congrArg abs (by ring) -/
example (N H d : ℝ) :
    abs (N * d - H * d) = abs ((N - H) * d) :=
  congrArg abs (by ring)

/-- probe 15: nlinarith abs_add triangle step -/
example (A B C : ℝ) :
    |A| + |B + C| ≤ |A| + |B| + |C| := by
  exact nlinarith [abs_add B C]

end
