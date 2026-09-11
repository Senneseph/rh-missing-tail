/- Bt6 — atomic probes for the B3.lean §4.4/§5 continuity rewrite:
   (1) ContinuousAt chains through lambda goals (no `continuity`/aesop),
   (2) the =ᶠ[𝓝 x] bridge via (heq : f = g) |>.eventuallyEq,
   (3) BigOperators ∑/∏ over List with a function,
   (4) NList (map then .sum) simp behavior. -/
import Mathlib
open Real Set BigOperators

noncomputable section

def u (x : ℝ) : ℝ := x * x + 1 / 4
def w (t : ℝ) : ℝ := t * t + 1 / 4

/-- fTp t x = -x/(u x)² + 2·w t·x/(u x·(x²−t²)) (the goal form in B3 §6). -/
def fTpGoal (t x : ℝ) : ℝ :=
  -x / (u x) ^ 2 + 2 * (w t) * x / (u x * (x * x - t * t))

theorem fTpCont (t x : ℝ) (hx0 : 0 < x) (hx3 : 0 < x * x - t * t) :
    ContinuousAt (fun z : ℝ => fTpGoal t z) x := by
  have hId : ContinuousAt (fun z : ℝ => z) x := continuousAt_id' (x : ℝ)
  -- u(z) = z² + 1/4
  have hC1 : ContinuousAt (fun _ : ℝ => (1 / 4 : ℝ)) x := continuousAt_const
  have hu : ContinuousAt (fun z : ℝ => z * z + 1 / 4) x :=
    hId.mul hId |>.add hC1
  have huFe : (fun z : ℝ => z * z + 1 / 4) = (fun z : ℝ => u z) := by
    ext z
    dsimp only [u]
  have huU : ContinuousAt (fun z : ℝ => u z) x := hu.congr huFe.eventuallyEq
  have hu2 : ContinuousAt (fun z : ℝ => (u z) ^ 2) x :=
    huU.mul huU |>.congr ((by ext z; ring : (fun z : ℝ => u z * u z) = (fun z : ℝ => (u z) ^ 2))).eventuallyEq
  have hux : 0 < u x := by dsimp only [u]; nlinarith [hx0]
  have hinvu : ContinuousAt (fun z : ℝ => ((u z) ^ 2)⁻¹) x := by
    apply ContinuousAt.comp'
    · exact continuousAt_inv₀ (ne_of_gt (pow_pos hux 2))
    · exact hu2
  have hz1 : ContinuousAt (fun z : ℝ => -z) x :=
    hId.neg
  have hterm1 : ContinuousAt (fun z : ℝ => -z / (u z) ^ 2) x :=
    hz1.div hu2 (ne_of_gt (pow_pos hux 2))
  -- x² − t²
  have hCt : ContinuousAt (fun _ : ℝ => (t * t : ℝ)) x := continuousAt_const
  have hxx : ContinuousAt (fun z : ℝ => z * z - t * t) x :=
    hId.mul hId |>.sub hCt
  have hd : ContinuousAt (fun z : ℝ => u z * (z * z - t * t)) x := huU.mul hxx
  have hC2w : ContinuousAt (fun _ : ℝ => (2 * (w t) : ℝ)) x := continuousAt_const
  have hnum : ContinuousAt (fun z : ℝ => 2 * (w t) * z) x :=
    hC2w.mul hId
  have hhd : 0 < u x * (x * x - t * t) := by nlinarith [hux, hx3]
  have hterm2 : ContinuousAt (fun z : ℝ => (2 * (w t) * z) / (u z * (z * z - t * t))) x :=
    hnum.div hd hhd.ne'
  have hsum : ContinuousAt (fun z : ℝ => -z / (u z) ^ 2 +
      (2 * (w t) * z) / (u z * (z * z - t * t))) x := hterm1.add hterm2
  have hFe : (fun z : ℝ => -z / (u z) ^ 2 +
      (2 * (w t) * z) / (u z * (z * z - t * t))) =
      (fun z : ℝ => fTpGoal t z) := rfl
  exact hsum.congr hFe.eventuallyEq

/-- Q029′ form: 0.290·log(log z)/z³ − 0.290/(2·z³·log z), continuous at x > e. -/
def q029Goal (x : ℝ) : ℝ :=
  0.290 * log (log x) / x ^ 3 - 0.290 / (2 * x ^ 3 * log x)

theorem q029Cont (x : ℝ) (hlx : 1 ≤ log x) (hx0 : 0 < x) :
    ContinuousAt (fun z : ℝ => q029Goal z) x := by
  have hId := continuousAt_id' (x : ℝ)
  have hlx0 : 0 < log x := by linarith [hlx]
  have hlog : ContinuousAt log x := continuousAt_log (ne_of_gt hx0)
  have hloglog : ContinuousAt (fun z : ℝ => log (log z)) x :=
    continuousAt_log (ne_of_gt hlx0) |>.comp hlog
  have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
  have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
  have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
  have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
  have hC1 : ContinuousAt (fun _ : ℝ => (0.290 : ℝ)) x := continuousAt_const
  have hC2 : ContinuousAt (fun _ : ℝ => (2 : ℝ)) x := continuousAt_const
  have hA : ContinuousAt (fun z : ℝ => 0.290 * log (log z)) x :=
    hC1.mul hloglog
  have htermA : ContinuousAt (fun z : ℝ => (0.290 * log (log z)) / z ^ 3) x :=
    hA.div hz3p (ne_of_gt (pow_pos hx0 3))
  have htwo : ContinuousAt (fun z : ℝ => 2 * z ^ 3 * log z) x := by
    have h23 : ContinuousAt (fun z : ℝ => 2 * z ^ 3) x :=
      hC2.mul hz3p
    exact h23.mul hlog
  have hB : ContinuousAt (fun z : ℝ => 0.290 / (2 * z ^ 3 * log z)) x :=
    hC1.div htwo (by
      apply mul_ne_zero
      · apply mul_ne_zero
        · norm_num
        · exact ne_of_gt (pow_pos hx0 3)
      · exact ne_of_gt hlx0)
  have hsum : ContinuousAt (fun z : ℝ => (0.290 * log (log z)) / z ^ 3 -
      0.290 / (2 * z ^ 3 * log z)) x := htermA.sub hB
  have hFe : (fun z : ℝ => (0.290 * log (log z)) / z ^ 3 -
      0.290 / (2 * z ^ 3 * log z)) = (fun z : ℝ => q029Goal z) := by
    ext z
    dsimp only [q029Goal]
  exact hsum.congr hFe.eventuallyEq

/- Q3: BigOperators over List with a function. -/
#check ∑ g ∈ (Finset.univ : Finset (Fin 3)), (↑g : ℝ)

/- Q4: NList (map-sum) simp. -/
def NList (L : List ℝ) (x : ℝ) : ℝ :=
  (L.map (fun (g : ℝ) => if g ≤ x then (1 : ℝ) else 0)).sum
example (x : ℝ) : NList [] x = 0 := by
  dsimp only [NList]
  simp
example (x g : ℝ) (tail : List ℝ) : NList (g :: tail) x =
    (if g ≤ x then (1 : ℝ) else 0) + NList tail x := by
  dsimp only [NList]
  simp

end
