/-
T4Off — the OFF-LINE LIFT of the T4 tail wall (the G-hs3 attack,
discovery 0116).

The T4 tail wall (P4Limit `p4_T4_bound`) bounds the EM expression
`p4_em_expr s n = −½ n^{−s} + (s/12) n^{−s−1} − ½ ∫_n^∞ B̂₂·s(s+1)·x^{−s−2}`
at the critical line s = ½ + it by three machine-proven terms — the
source of the B-wire `P8Floor.p8_B`.  The G-hs3 gap (RHEnd part  B5
docstring) is the OFF-LINE lift of that wire: at a hypothetical
off-pair zero  ρ  (|ρ.re − ½|  =  d0,  ¼/₂₀₀  ≤  d0  ≤  ½)  the  S3
scale must be bounded AWAY from the line.

This module proves the lift is not an analytic barrier: the proof
structure of the wall (per-period IBP with the B₃ primitive, boundary
cancellation, the |B₃poly| ≤ √3/36 pin, the FTC reassembly, the M→∞
passage) uses the critical-line hypothesis in exactly THREE places —
the two endpoint power norms and the tail-exponent step — and all
three lift to a UNIFORM statement valid on BOTH sides of the line:

  `p4_op2c_bound_gen`    (the lifted atom:  -1 < s.re,  exact
                          tail constant  (√3/108)·‖s+2‖·n^{−(s.re+2)}/(s.re+2))
  `p4_f2_tail_bound_gen` (the f″ bridge,  scalar  s(s+1)  factored)
  `p4_T4_bound_gen`      (the lifted wall:  the three-term EM bound
                          with  EXACT  off-line  powers  n^{−s.re},
                          n^{−s.re−1},  n^{−(s.re+2)}/(s.re+2))

At  s.re  =  1/2  each  gen  theorem  specializes  EXACTLY  to  the
on-line T4 statement (the  constant  (√3/108)/(5/2)  =  √3/270  on
the  atom,  √3/540  on  the  wall  -  checked  by  t4genTerm3_at_line
and  t4genTerm12_at_line).  The  endpoint  strip  band  has
s.re  =  ½  ±  d0  with  d0  ≤  ½,  i.e.  s.re  ∈  [0, 1]  ⊂  (−1,
∞)  -  BOTH  sides  of  the  line  are  covered:  the  right  side
(s.re  >  ½)  GAINS  the  n^{−d0}  damping,  the  left  side  loses
a  factor  n^{+d0}  relative  to  the  line  (the  price  of  being
off  the  line,  made  explicit).

WHAT  THIS  DOES  TO  G-hs3:  the  EM  scale  at  an  off-pair  zero
ρ  (where  zeta  ρ  =  0  makes  the  EM  expression  equal  to
−(P_n  −  I_n)  -  the  cited  DLMF 25.2.8  identity  extended  to
Re  s  >  ½  by  the  same  analytic-continuation  bridge  the  tree
already  cites  on  the  line)  is  NOW  MACHINE-BOUNDED  off  the
line.  The  remaining  G-hs3  content  is  decomposed  (docstring
below):  (ii)  the  off-line  P6  finite-kernel  gap  (the  Mr  wire
lifted  off  the  line)  and  (iii)  the  margin  composition
(off-line  scale  +  gap  below  floStripMin  on  the  strip  band).
No  RH  claim:  this  is  a  bound  theorem  about  a  concrete
kernel  expression,  exactly  the  status  of  the  on-line  T4
wall.  Lean  4.33.1  +  mathlib  v4.33.1;  DOC-FIRST:  every  lemma
name  was  taken  from  its  usage  in  P4Limit  (the  same  file
structure  the  on-line  atom  was  built  from).
-/
import Mathlib
import RhAttack.P4Tail
import RhAttack.P4Limit

open Real Set Filter MeasureTheory intervalIntegral Finset

open scoped Topology

/-  ##  Section  A  -  the  lifted  atoms  (the  T4  wall  off  the
    line,  -1  <  s.re,  both  sides)  -/

theorem p4_op2c_bound_gen {s : ℂ} (hsre : -1 < s.re) (n : ℕ) (hn : 0 < n) :
    ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2)‖
        ≤ Real.sqrt 3 / 108 * ‖s + 2‖ * ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
  have hnpos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  set f : ℝ → ℂ := fun (x : ℝ) => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2) with hf
  -- (0) the tail integrand is integrable on (n, ∞)  [mirror of L3.c]
  have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 2)) (Set.Ioi (n : ℝ)) := by
    intro x hx
    exact (Complex.continuousAt_ofReal_cpow_const x (-s - 2) (Or.inr (ne_of_gt (hnpos.trans hx)))).continuousWithinAt
  have hB2aesIoi : AEStronglyMeasurable (fun x : ℝ => (B2 x : ℂ))
      (volume.restrict (Set.Ioi (n : ℝ))) :=
    AEStronglyMeasurable.mono_measure
      (Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)
        (aestronglyMeasurable_B2 : AEStronglyMeasurable B2))
      ((Measure.restrict_mono (Set.Ioi (n : ℝ)).subset_univ le_rfl).trans
        (le_of_eq Measure.restrict_univ))
  have hCpowaes : AEStronglyMeasurable (fun x : ℝ => (x : ℂ) ^ (-s - 2))
      (volume.restrict (Set.Ioi (n : ℝ))) :=
    ContinuousOn.aestronglyMeasurable hCpowCO measurableSet_Ioi
  have hRe : (-(s.re + 2) : ℝ) < -1 := by nlinarith [hsre]
  have hRpow : Integrable (fun x : ℝ => x ^ (-(s.re + 2)))
      (volume.restrict (Set.Ioi (n : ℝ))) :=
    (integrableOn_Ioi_rpow_of_lt (a := (-(s.re + 2) : ℝ)) hRe hnpos).integrable
  have hMajor : HasFiniteIntegral (fun x : ℝ => (1 / 6 : ℝ) * x ^ (-(s.re + 2)))
      (volume.restrict (Set.Ioi (n : ℝ))) :=
    Integrable.hasFiniteIntegral (hRpow.const_mul (1 / 6 : ℝ))
  have hInt : IntegrableOn f (Set.Ioi (n : ℝ)) := by
    refine ⟨hB2aesIoi.mul hCpowaes, ?_⟩
    rw [← hasFiniteIntegral_norm_iff]
    exact HasFiniteIntegral.mono' hMajor (by
      rw [ae_restrict_iff' measurableSet_Ioi]
      exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx => by
        have hxpos : 0 < x := hnpos.trans hx
        have h1 : ‖(‖f x‖ : ℝ)‖ = ‖f x‖ := by simp
        rw [h1]
        calc ‖f x‖
            _ = ‖(B2 x : ℂ)‖ * ‖(x : ℂ) ^ (-s - 2)‖ := by
              rw [hf, norm_mul]
            _ = |B2 x| * ‖(x : ℂ) ^ (-s - 2)‖ := by
              have hb2 : ‖(B2 x : ℂ)‖ = Real.sqrt ((B2 x : ℝ) ^ 2) := by
                rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
              rw [hb2, Real.sqrt_sq_eq_abs]
            _ ≤ (1 / 6 : ℝ) * ‖(x : ℂ) ^ (-s - 2)‖ := by
              gcongr
              exact abs_B2_le (le_of_lt hxpos)
            _ = (1 / 6 : ℝ) * (x : ℝ) ^ (-(s.re + 2)) := by
              rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
              rw [show (-(s : ℂ) - 2).re = -(s.re + 2) from by
                rw [show (-(s : ℂ) - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
                  Complex.neg_re, Complex.add_re,
                  show (2 : ℂ).re = 2 from by norm_num]]))
  -- (1) continuity of the tail integrand on each unit period [k, k+1]
  have hCpow3CO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 3)) (Set.Ioi (n : ℝ)) := by
    intro x hx
    exact (Complex.continuousAt_ofReal_cpow_const x (-s - 3) (Or.inr (ne_of_gt (hnpos.trans hx)))).continuousWithinAt
  have hPeriodCont (k : ℕ) (hk : n ≤ k) :
      ContinuousOn f (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by
    have hco2 : ContinuousOn (fun x : ℝ => (B2 x : ℂ)) (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by
      have hpoly : ContinuousOn
          (fun x : ℝ => (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℝ) : ℂ))
          (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by fun_prop
      exact ContinuousOn.congr hpoly (by
        intro x hx
        dsimp only
        rw [B2_of_Icc_int (n := (k : ℕ)) hx])
    exact hco2.mul (by
      intro x hx
      have hpos : 0 < x := by
        calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
          _ ≤ (k : ℝ) := (Nat.cast_le (α := ℝ)).mpr hk
          _ ≤ x := hx.1
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 2) (Or.inr (ne_of_gt hpos))).continuousWithinAt)
  -- (2) derivatives for the per-period IBP
  have hGderiv (k : ℕ) (hk : n ≤ k) :
      ∀ x ∈ Set.uIcc (k : ℝ) (k + 1 : ℝ),
        HasDerivAt (fun x : ℝ => (x : ℂ) ^ (-s - 2))
            ((-s - 2) * (x : ℂ) ^ (-s - 3)) x := by
    intro x hx
    have hx0 : x ≠ 0 := by
      intro h
      have hxge : (n : ℝ) ≤ x :=
        (Nat.cast_le.mpr hk).trans (by
          simpa [show min (k : ℝ) (k + 1) = (k : ℝ) from min_eq_left (by nlinarith)]
            using hx.1)
      linarith [hn, hxge, h]
    have hsc : -s - 2 ≠ 0 := by
      intro h
      have hre0 : (-(s : ℂ) - 2).re = 0 := by simpa [h]
      rw [show (-(s : ℂ) - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
        Complex.neg_re, Complex.add_re,
        show (2 : ℂ).re = 2 from by norm_num] at hre0
      linarith [hsre]
    have hexp : (-s - 2 : ℂ) - 1 = -s - 3 := by ring
    simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
  have hVderiv (k : ℕ) :
      ∀ x ∈ Set.uIcc (k : ℝ) (k + 1 : ℝ),
        HasDerivAt (fun x : ℝ => (B3poly (x - (k : ℝ)) / 3 : ℂ))
            (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ)) x := by
    intro x _
    have hU : HasDerivAt (fun t : ℝ => t - (k : ℝ)) 1 x := by
      have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (k : ℝ))) (1 - 0) x := by
        simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (k : ℝ))
      have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (k : ℝ)) = (fun t : ℝ => t - (k : ℝ)) := by
        funext t
        dsimp
      simpa [hfun] using hsub
    have hW : HasDerivAt (fun t : ℝ => B3poly (t - (k : ℝ)))
        (3 * ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6)) x := by
      have hW0 := HasDerivAt.comp x (B3poly_hasDerivAt (x - (k : ℝ))) hU
      have hfun : (B3poly ∘ (fun t : ℝ => t - (k : ℝ))) =
          (fun t : ℝ => B3poly (t - (k : ℝ))) := by
        funext t
        dsimp
      have hder : 3 * ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6) * 1 =
          3 * ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6) := by ring
      simpa [hfun, hder] using hW0
    have hV2 : HasDerivAt (fun t : ℝ => (B3poly (t - (k : ℝ))) / 3)
        ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6) x := by
      simpa using hW.div_const 3
    simpa using HasDerivAt.ofReal_comp hV2
  -- (3) the per-period IBP identity
  have hIBP (k : ℕ) (hk : n ≤ k) :
      (∫ x in (k : ℝ)..(k + 1 : ℝ), f x) =
          (s + 2) / 3 * (∫ x in (k : ℝ)..(k + 1 : ℝ),
            (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
    set u : ℝ → ℂ := (fun (x : ℝ) => (x : ℂ) ^ (-s - 2)) with hu
    set v : ℝ → ℂ := (fun (x : ℝ) => (B3poly (x - (k : ℝ)) / 3 : ℂ)) with hv
    have hU : ∀ x ∈ Set.uIcc (k : ℝ) (k + 1 : ℝ),
        HasDerivAt u ((-s - 2) * (x : ℂ) ^ (-s - 3)) x := hGderiv k hk
    have hV : ∀ x ∈ Set.uIcc (k : ℝ) (k + 1 : ℝ),
        HasDerivAt v (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ)) x :=
      hVderiv k
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 2) * (x : ℂ) ^ (-s - 3))
        volume (k : ℝ) (k + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (-s - 2) * (x : ℂ) ^ (-s - 3))
          (Set.uIcc (k : ℝ) (k + 1 : ℝ)) :=
        continuousOn_const.mul (by
          intro x hx
          have hpos : 0 < x := by
            calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
              _ ≤ (k : ℝ) := (Nat.cast_le (α := ℝ)).mpr hk
              _ ≤ x := by
                simpa [show min (k : ℝ) (k + 1) = (k : ℝ) from min_eq_left (by nlinarith)]
                  using hx.1
          exact (Complex.continuousAt_ofReal_cpow_const x (-s - 3)
              (Or.inr (ne_of_gt hpos))).continuousWithinAt)
      exact hm.intervalIntegrable
    have hVint : IntervalIntegrable
        (fun x : ℝ => ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ))
        volume (k : ℝ) (k + 1 : ℝ) := by
      have hm : ContinuousOn
          (fun x : ℝ => ((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ))
          (Set.uIcc (k : ℝ) (k + 1 : ℝ)) := by fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (k : ℝ)..(k + 1 : ℝ),
              u x * (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ))) =
        u (k + 1 : ℝ) * v (k + 1 : ℝ) - u (k : ℝ) * v (k : ℝ) -
          (∫ x in (k : ℝ)..(k + 1 : ℝ), ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (k : ℝ)..(k + 1 : ℝ), f x)
        _ = (∫ x in (k : ℝ)..(k + 1 : ℝ),
              u x * (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ))) := by
          have hEq : EqOn (fun x : ℝ => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
              (fun x : ℝ => u x * (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ)))
              (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by
            intro x hx
            dsimp only [f, u]
            rw [B2_of_Icc_int (n := (k : ℕ)) hx]
            rw [mul_comm]
            congr 1
            apply Complex.ext
            · simp [Complex.ofReal_re]
            · simp [Complex.ofReal_im]
          have hEqU : EqOn f (fun x : ℝ => u x * (((x - (k : ℝ)) ^ 2 - (x - (k : ℝ)) + 1 / 6 : ℂ)))
              (Set.uIcc (k : ℝ) (k + 1 : ℝ)) :=
            (hf.symm ▸ hEq).mono (by
              intro x hx
              simpa [show min (k : ℝ) (k + 1) = (k : ℝ) from min_eq_left (by nlinarith),
                show max (k : ℝ) (k + 1) = (k + 1 : ℝ) from max_eq_right (by nlinarith)]
                using hx)
          simpa using (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hEqU)
        _ = u (k + 1 : ℝ) * v (k + 1 : ℝ) - u (k : ℝ) * v (k : ℝ) -
            (∫ x in (k : ℝ)..(k + 1 : ℝ), ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) :=
          H
        _ = - (∫ x in (k : ℝ)..(k + 1 : ℝ),
              ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) := by
          have hvk1 : v (k + 1 : ℝ) = 0 := by
            dsimp only [v]
            rw [show ((k + 1 : ℝ) - (k : ℝ) : ℝ) = 1 by ring, B3poly_at_1]
            norm_num
          have hvk0 : v (k : ℝ) = 0 := by
            dsimp only [v]
            rw [show ((k : ℝ) - (k : ℝ) : ℝ) = 0 by ring, B3poly_at_0]
            norm_num
          rw [hvk1, hvk0]
          ring
        _ = ((s + 2) / 3 : ℂ) * (∫ x in (k : ℝ)..(k + 1 : ℝ),
              (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
          have hX : (∫ x in (k : ℝ)..(k + 1 : ℝ),
                    ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) =
              ((-(s + 2 : ℂ)) / 3) *
                (∫ x in (k : ℝ)..(k + 1 : ℝ),
                  (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
            have hEq : EqOn
                (fun x : ℝ => ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x)
                (fun x : ℝ => (-(s + 2 : ℂ)) / 3 *
                  ((B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)))
                (Set.uIcc (k : ℝ) (k + 1 : ℝ)) := by
              intro x _
              dsimp only [v]
              ring
            exact (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans (by
              rw [intervalIntegral.integral_const_mul ((-(s + 2 : ℂ)) / 3)])
          rw [hX]
          ring
  -- (4) the per-period bound after the IBP
  have hper (k : ℕ) (hk : n ≤ k) :
      ‖∫ x in (k : ℝ)..(k + 1 : ℝ), (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)‖
          ≤ (∫ x in (k : ℝ)..(k + 1 : ℝ), Real.sqrt 3 / 36 * (x ^ (-(s.re + 3) : ℝ))) := by
    apply intervalIntegral.norm_integral_le_of_norm_le
      (g := fun x : ℝ => Real.sqrt 3 / 36 * (x ^ (-(s.re + 3) : ℝ)))
    · linarith
    · exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun t htx => by
        have htxpos : 0 < t := by
          calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
            _ ≤ (k : ℝ) := (Nat.cast_le (α := ℝ)).mpr hk
            _ ≤ t := le_of_lt htx.1
        have hB3 : |B3poly (t - (k : ℝ))| ≤ Real.sqrt 3 / 36 :=
          abs_B3poly_le (t - (k : ℝ))
            ⟨by linarith [htx.1], by nlinarith [htx.2]⟩
        calc ‖(B3poly (t - (k : ℝ)) : ℂ) * (t : ℂ) ^ (-s - 3)‖
            _ = ‖(B3poly (t - (k : ℝ)) : ℂ)‖ * ‖(t : ℂ) ^ (-s - 3)‖ := by
              rw [norm_mul]
            _ = |B3poly (t - (k : ℝ))| * ‖(t : ℂ) ^ (-s - 3)‖ := by
              have hb3 : ‖(B3poly (t - (k : ℝ)) : ℂ)‖ =
                  Real.sqrt ((B3poly (t - (k : ℝ)) : ℝ) ^ 2) := by
                rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
              rw [hb3, Real.sqrt_sq_eq_abs]
            _ ≤ Real.sqrt 3 / 36 * ‖(t : ℂ) ^ (-s - 3)‖ := by
              gcongr
            _ = Real.sqrt 3 / 36 * (t : ℝ) ^ (-(s.re + 3)) := by
              rw [Complex.norm_cpow_eq_rpow_re_of_pos htxpos ((-s : ℂ) - 3)]
              rw [show (-(s : ℂ) - 3).re = -(s.re + 3) from by
                rw [show (-(s : ℂ) - 3 : ℂ) = -((s : ℂ) + 3) from by ring,
                  Complex.neg_re, Complex.add_re,
                  show (3 : ℂ).re = 3 from by norm_num]]
              )
    · have hco : ContinuousOn (fun x : ℝ => x ^ (-(s.re + 3) : ℝ))
            (Set.uIcc (k : ℝ) (k + 1 : ℝ)) := by
        intro x hx
        exact (continuousAt_rpow_const x (-(s.re + 3) : ℝ)
            (Or.inl (ne_of_gt (by
              calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
                _ ≤ (k : ℝ) := (Nat.cast_le (α := ℝ)).mpr hk
                _ ≤ x := by
                  simpa [show min (k : ℝ) (k + 1) = (k : ℝ) from min_eq_left (by nlinarith)]
                    using hx.1)))).continuousWithinAt
      have hc : ContinuousOn (fun _ : ℝ => (Real.sqrt 3 / 36 : ℝ) : ℝ → ℝ)
          (Set.uIcc (k : ℝ) (k + 1 : ℝ)) := continuousOn_const
      exact (hc.mul hco).intervalIntegrable
  -- (5) the finite bound over [n, N]  (N ≥ n, natural)
  have hSum (N : ℕ) (hN : n ≤ N) :
      (∫ x in (n : ℝ)..(N : ℝ), f x) =
          ∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..(k + 1 : ℝ), f x := by
    rw [← sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ))
      (by exact hN)
      (fun (k : ℕ) hk => by
        have hco0 := hPeriodCont k (Set.mem_Ico.mp hk |>.1)
        have hco : ContinuousOn f (Set.Icc (k : ℝ) ((k + 1 : ℕ) : ℝ)) :=
          hco0.mono (by
            intro x hx
            rw [show (k : ℝ) + 1 = ((k + 1 : ℕ) : ℝ) from (Nat.cast_succ k).symm]
            exact hx)
        exact hco.intervalIntegrable_of_Icc (by norm_num))
    ]
    rw [Finset.sum_congr rfl (fun k hk => by
      rw [show ((k + 1 : ℕ) : ℝ) = (k : ℝ) + 1 from Nat.cast_succ k])]
  have hBoundN (N : ℕ) (hN : n ≤ N) :
      ‖∫ x in (n : ℝ)..(N : ℝ), f x‖ ≤
          Real.sqrt 3 / 108 * ‖s + 2‖ * ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
    have hper2 (k : ℕ) (hk : n ≤ k) :
        ‖∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ ≤
            Real.sqrt 3 / 108 * ‖s + 2‖ * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ)) := by
      calc ‖∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖
          _ = ‖((s + 2) / 3 : ℂ) * (∫ x in (k : ℝ)..(k + 1 : ℝ),
                (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))‖ := by
            rw [hIBP k hk]
          _ = ‖s + 2‖ / 3 * ‖∫ x in (k : ℝ)..(k + 1 : ℝ),
                (B3poly (x - (k : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)‖ := by
            rw [norm_mul]
            rw [show ‖((s + 2) / 3 : ℂ)‖ = ‖s + 2‖ / 3 from by
              rw [norm_div]
              norm_num]
          _ ≤ ‖s + 2‖ / 3 *
              (Real.sqrt 3 / 36 * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ))) := by
            gcongr
            simpa using hper k hk
          _ = Real.sqrt 3 / 108 * ‖s + 2‖ *
              (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ)) := by
            ring
    calc ‖∫ x in (n : ℝ)..(N : ℝ), f x‖
        _ = ‖∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ := by
          rw [hSum N hN]
        _ ≤ ∑ k ∈ Finset.Ico n N, ‖∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ :=
          norm_sum_le (Finset.Ico n N) (fun k : ℕ => ∫ x in (k : ℝ)..(k + 1 : ℝ), f x)
        _ ≤ ∑ k ∈ Finset.Ico n N,
              (Real.sqrt 3 / 108 * ‖s + 2‖ * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ))) := by
          apply Finset.sum_le_sum
          intro k hk
          simpa using hper2 k (Finset.mem_Ico.mp hk |>.1)
        _ = (Real.sqrt 3 / 108 * ‖s + 2‖) * (∫ x in (n : ℝ)..(N : ℝ), x ^ (-(s.re + 3) : ℝ)) := by
          rw [← Finset.mul_sum (Finset.Ico n N)
            (fun k : ℕ => ∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ))
            (Real.sqrt 3 / 108 * ‖s + 2‖)]
          rw [show ∫ x in (n : ℝ)..(N : ℝ), x ^ (-(s.re + 3) : ℝ) =
                ∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-(s.re + 3) : ℝ) from by
            have hS : (∫ x in (n : ℝ)..(N : ℝ), x ^ (-(s.re + 3) : ℝ)) =
                (∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..((k + 1 : ℕ) : ℝ), x ^ (-(s.re + 3) : ℝ)) :=
              (sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ)) hN
                (fun k hk => by
                  have hco0 : ContinuousOn (fun x : ℝ => x ^ (-(s.re + 3) : ℝ))
                      (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by
                    intro x hx
                    have hxpos : 0 < x := by nlinarith [hx.1,
                    (Nat.cast_le (α := ℝ)).mpr (Set.mem_Ico.mp hk |>.1),
                    (Nat.cast_pos (α := ℝ)).mpr hn]
                    exact (continuousAt_rpow_const x (-(s.re + 3) : ℝ) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
                  have hco : ContinuousOn (fun x : ℝ => x ^ (-(s.re + 3) : ℝ))
                      (Set.Icc (k : ℝ) ((k + 1 : ℕ) : ℝ)) :=
                    hco0.mono (by
                      intro x hx
                      rw [show (k : ℝ) + 1 = ((k + 1 : ℕ) : ℝ) from (Nat.cast_succ k).symm]
                      exact hx)
                  exact hco.intervalIntegrable_of_Icc (μ := (MeasureTheory.volume : Measure ℝ)) (by
                    rw [Nat.cast_succ]
                    nlinarith))).symm
            rw [hS, Finset.sum_congr rfl (fun k hk => by
              rw [show ((k + 1 : ℕ) : ℝ) = (k : ℝ) + 1 from Nat.cast_succ k])
            ]
            ]
        _ ≤ (Real.sqrt 3 / 108 * ‖s + 2‖) * ((1 / (s.re + 2)) * (n : ℝ) ^ (-(s.re + 2))) := by
          gcongr
          -- ∫_n^N x^{−7/2} = (2/5)·(n^{−5/2} − N^{−5/2}) ≤ (2/5)·n^{−5/2}
          have hFTC : (∫ x in (n : ℝ)..(N : ℝ), x ^ (-(s.re + 3) : ℝ)) =
              (1 / (s.re + 2)) * ((n : ℝ) ^ (-(s.re + 2)) - (N : ℝ) ^ (-(s.re + 2))) := by
            have hDeriv : ∀ x ∈ Set.Ioo (n : ℝ) (N : ℝ),
                HasDerivAt (fun x : ℝ => (-(1 / (s.re + 2))) * ((x : ℝ) ^ (-(s.re + 2))))
                    ((x : ℝ) ^ (-(s.re + 3))) x := by
              intro x hx
              have hxpos : 0 < x := by nlinarith [hx.1, (Nat.cast_pos (α := ℝ)).mpr hn]
              have hrp : HasDerivAt (fun x : ℝ => (x : ℝ) ^ (-(s.re + 2)))
                  ((-(s.re + 2)) * ((x : ℝ) ^ ((-(s.re + 2)) - 1))) x :=
                hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos))
              have hm : HasDerivAt (fun x : ℝ => (-(1 / (s.re + 2))) * ((x : ℝ) ^ (-(s.re + 2))))
                  (-(1 / (s.re + 2)) * ((-(s.re + 2)) * ((x : ℝ) ^ ((-(s.re + 2)) - 1)))) x :=
                HasDerivAt.const_mul (c := (-(1 / (s.re + 2)))) hrp
              convert hm
              rw [show (-(s.re + 2)) - 1 = (-(s.re + 3) : ℝ) from by ring]
              field_simp [show (s.re + 2 : ℝ) ≠ 0 from by linarith [hsre]]
            have hCont : ContinuousOn (fun x : ℝ => (-(1 / (s.re + 2))) * ((x : ℝ) ^ (-(s.re + 2))))
                (Set.Icc (n : ℝ) (N : ℝ)) := by
              have hR : ContinuousOn (fun x : ℝ => (x : ℝ) ^ (-(s.re + 2)))
                  (Set.Icc (n : ℝ) (N : ℝ)) := by
                intro x hx
                have hxpos : 0 < x := by nlinarith [hx.1, (Nat.cast_pos (α := ℝ)).mpr hn]
                exact (continuousAt_rpow_const x (-(s.re + 2)) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
              have hc : ContinuousOn (fun _ : ℝ => (-(1 / (s.re + 2))) : ℝ → ℝ)
                  (Set.Icc (n : ℝ) (N : ℝ)) := continuousOn_const
              exact hc.mul hR
            have hIntg : IntervalIntegrable (fun x : ℝ => (x : ℝ) ^ (-(s.re + 3)))
                volume (n : ℝ) (N : ℝ) := by
              have hco : ContinuousOn (fun x : ℝ => (x : ℝ) ^ (-(s.re + 3)))
                  (Set.uIcc (n : ℝ) (N : ℝ)) := by
                intro x hx
                have hxpos : 0 < x := by
                  calc 0 < (n : ℝ) := (Nat.cast_pos (α := ℝ)).mpr hn
                    _ = min (n : ℝ) (N : ℝ) := (min_eq_left ((Nat.cast_le (α := ℝ)).mpr hN)).symm
                    _ ≤ x := hx.1
                exact (continuousAt_rpow_const x (-(s.re + 3) : ℝ) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
              exact hco.intervalIntegrable
            have hH := integral_eq_sub_of_hasDerivAt_of_le ((Nat.cast_le (α := ℝ)).mpr hN) hCont hDeriv hIntg
            rw [hH]
            ring
          rw [hFTC]
          have hb : 0 < s.re + 2 := by linarith [hsre]
          have hN2 : 0 ≤ (N : ℝ) ^ (-(s.re + 2)) := by
            have hNpos : 0 < (N : ℝ) := by nlinarith [hn, (Nat.cast_le (α := ℝ)).mpr hN]
            exact Real.rpow_nonneg (le_of_lt hNpos) (-(s.re + 2))
          have hsub : (n : ℝ) ^ (-(s.re + 2)) - (N : ℝ) ^ (-(s.re + 2)) ≤
              (n : ℝ) ^ (-(s.re + 2)) := by
            linarith [hN2]
          exact mul_le_mul_of_nonneg_left hsub (le_of_lt (one_div_pos.mpr hb))
        _ = Real.sqrt 3 / 108 * ‖s + 2‖ * ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
          ring
  -- (6) the M→∞ passage (L3 pattern) + the bounded-limit argument
  set L := (∫ x, f x ∂ volume.restrict (Set.Ioi (n : ℝ))) with hLdef
  have hSeq : Tendsto (fun N : ℕ => ∫ x in (n : ℝ)..(N : ℝ), f x) atTop (𝓝 L) := by
    have hSeqR : Tendsto (fun M : ℝ => ∫ x in (n : ℝ)..M, f x) atTop (𝓝 L) :=
      intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ)) hInt tendsto_id
    exact hSeqR.comp (tendsto_natCast_atTop_atTop (R := ℝ))
  have hNorm : Tendsto (fun N : ℕ => ‖∫ x in (n : ℝ)..(N : ℝ), f x‖) atTop (𝓝 ‖L‖) := by
    have hcn : Continuous (fun z : ℂ => ‖z‖) := by continuity
    exact (hcn.tendsto L).comp hSeq
  set C := Real.sqrt 3 / 108 * ‖s + 2‖ * ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) with hCdef
  have hBoundSeq : ∀ᶠ (N : ℕ) in atTop, ‖∫ x in (n : ℝ)..(N : ℝ), f x‖ ≤ C := by
    filter_upwards [eventually_ge_atTop n] with N hN
    exact hBoundN N hN
  -- the eventual bound passes to the limit (mathlib `le_of_tendsto`)
  have hLbound : ‖L‖ ≤ C := le_of_tendsto hNorm hBoundSeq
  simpa [f] using hLbound




theorem p4_f2_tail_bound_gen {s : ℂ} (hsre : -1 < s.re) (n : ℕ) (hn : 0 < n) :
  ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x‖
      ≤ Real.sqrt 3 / 108 * ‖s * (s + 1)‖ * ‖s + 2‖ *
        ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
  set f : ℝ → ℂ := fun (x : ℝ) => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2) with hf
  dsimp only [p4_f2]
  have hFactor : (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (s * (s + 1) * (x : ℂ) ^ (-s - 2))) =
      (s * (s + 1)) • (∫ x : ℝ in Set.Ioi (n : ℝ), f x) := by
    have hM : Integrable (fun x : ℝ => (B2 x : ℂ) * (s * (s + 1) * (x : ℂ) ^ (-s - 2)))
        (volume.restrict (Set.Ioi (n : ℝ))) :=
      (p4_kernel_integrableOn_Ioi (by nlinarith [hsre]) (Nat.cast_pos.mpr hn)).integrable.congr
      (MeasureTheory.ae_of_all (μ := (volume.restrict (Set.Ioi (n : ℝ))))
        (fun x => by dsimp only [p4_f2]))
    rw [show (∫ x : ℝ in Set.Ioi (n : ℝ),
              (B2 x : ℂ) * (s * (s + 1) * (x : ℂ) ^ (-s - 2))) =
              (∫ x : ℝ in Set.Ioi (n : ℝ), (s * (s + 1)) • f x) from by
      refine (MeasureTheory.integral_congr_ae ?_)
      exact MeasureTheory.ae_of_all (μ := (volume.restrict (Set.Ioi (n : ℝ)))) (fun x => by
        dsimp only [f]
        rw [show (s * (s + 1) : ℂ) • ((B2 x : ℂ) * (x : ℂ) ^ (-s - 2)) =
                 (s * (s + 1)) * ((B2 x : ℂ) * (x : ℂ) ^ (-s - 2)) from rfl]
        ring)]
    rw [MeasureTheory.integral_smul]
  rw [hFactor]
  rw [show ‖(s * (s + 1)) • (∫ x : ℝ in Set.Ioi (n : ℝ), f x)‖ =
        ‖(s * (s + 1)) * (∫ x : ℝ in Set.Ioi (n : ℝ), f x)‖ from rfl]
  rw [norm_mul]
  have hRHS : Real.sqrt 3 / 108 * ‖s * (s + 1)‖ * ‖s + 2‖ *
      ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) =
    ‖s * (s + 1)‖ *
      (Real.sqrt 3 / 108 * ‖s + 2‖ * ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2)) := by
    field_simp
  rw [hRHS]
  apply mul_le_mul_of_nonneg_left
  · simpa [f] using (p4_op2c_bound_gen hsre n hn)
  · exact norm_nonneg (s * (s + 1))


/--  THE  LIFTED  T4  WALL  (the  G-hs3  atom):  for  every  s  with
    -1  <  s.re  (BOTH  sides  of  the  critical  line)  and  n  >  0,
    the  EM  expression  is  bounded  by  the  three-term  form  with
    EXACT  off-line  endpoint  powers;  at  s.re  =  1/2  this  IS
    p4_T4_bound  (the  on-line  T4  wall).  -/
theorem p4_T4_bound_gen {s : ℂ} (hsre : -1 < s.re) {n : ℕ} (hn : 0 < n) :
    ‖p4_em_expr s n‖ ≤
        (1 / 2) * (n : ℝ) ^ (-s.re) +
        (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) +
        (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
          ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
  set t1 := -((1 / 2) : ℂ) * (n : ℂ) ^ (-s) with ht1
  set t2 := ((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1)) with ht2
  set tk := ((1 / 2) : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x) with htk
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  have hEm : p4_em_expr s n = t1 + t2 - tk := by
    dsimp only [t1, t2, tk, p4_em_expr]
  rw [hEm]
  have hbase : (n : ℂ) = ((n : ℝ) : ℂ) := by
    norm_cast
  have hnorm1 : ‖(n : ℂ) ^ (-s)‖ = (n : ℝ) ^ (-s.re) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s)]
    simp [Complex.neg_re]
  have hnorm2 : ‖(n : ℂ) ^ (-s - 1)‖ = (n : ℝ) ^ (-s.re - 1) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s - 1),
      show (-(s : ℂ) - 1 : ℂ).re = -s.re - 1 from by
        simp only [Complex.sub_re, Complex.neg_re]
        norm_num]
  have hnorm12 : ‖-((1 / 2) : ℂ)‖ = (1 / 2 : ℝ) := by norm_num
  have hnorm112 : ‖((1 / 12) : ℂ)‖ = (1 / 12 : ℝ) := by norm_num
  -- (1) kernel:  the  lifted  f″  bound  with  the  leading  ½
  have hK : ‖tk‖ ≤ (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
      ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
    dsimp only [tk]
    calc ‖(1 / 2 : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)‖
        = (1 / 2 : ℝ) * ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x‖ := by
          rw [norm_mul]
          norm_num
      _ ≤ (1 / 2) * (Real.sqrt 3 / 108 * ‖s * (s + 1)‖ * ‖s + 2‖ *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2)) :=
          mul_le_mul_of_nonneg_left (p4_f2_tail_bound_gen hsre n hn) (by norm_num)
      _ = (Real.sqrt 3 / 216) * (‖s‖ * ‖s + 1‖ * ‖s + 2‖) *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
          rw [norm_mul]
          ring
      _ = (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
          rw [← norm_mul, ← norm_mul]
  -- (2) first  endpoint  term
  have h1 : ‖t1‖ ≤ (1 / 2) * (n : ℝ) ^ (-s.re) := by
    dsimp only [t1]
    rw [norm_mul, hnorm12]
    apply mul_le_mul_of_nonneg_left _ (by norm_num)
    rw [hnorm1]
  -- (3) second  endpoint  term
  have h2 : ‖t2‖ ≤ (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) := by
    dsimp only [t2]
    calc ‖((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1))‖
        = (1 / 12 : ℝ) * ‖s * (n : ℂ) ^ (-s - 1)‖ := by
          rw [norm_mul, hnorm112]
      _ ≤ (1 / 12 : ℝ) * (‖s‖ * (n : ℝ) ^ (-s.re - 1)) :=
          mul_le_mul_of_nonneg_left (by rw [norm_mul, hnorm2]) (by norm_num)
      _ = (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) := by ring
  -- triangle
  have hTri : ‖t1 + t2 - tk‖ ≤ ‖t1‖ + ‖t2‖ + ‖tk‖ := by
    have hsub := norm_sub_le (t1 + t2) tk
    have hadd := norm_add_le t1 t2
    linarith [hsub, hadd]
  linarith [hTri, h1, h2, hK]

/-  ##  Section  B  -  the  wall  at  the  line  (sharpness)  and
    the  remaining  G-hs3  content  -/

/--  SHARPNESS  (term  1/2  of  the  wall):  at  s.re  =  1/2  the
    lifted  endpoint  powers  ARE  the  on-line  T4  powers  (one
    norm_num  each).  -/
theorem t4genTerm12_at_line {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ)
    (hn : 0 < n) :
    (n : ℝ) ^ (-s.re) = (n : ℝ) ^ (-1 / 2 : ℝ) ∧
    (n : ℝ) ^ (-s.re - 1) = (n : ℝ) ^ (-3 / 2 : ℝ) := by
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  constructor
  · rw [hsre]
    rw [show (-((1 / 2) : ℝ)) = (-1 / 2 : ℝ) from by norm_num]
  · rw [hsre]
    rw [show (-((1 / 2) : ℝ) - 1) = (-3 / 2 : ℝ) from by norm_num]

/--  SHARPNESS  (term  3  of  the  wall):  at  s.re  =  1/2  the
    lifted  tail  term  IS  the  on-line  T4  tail  term  (the
    constant  (√3/216)/(5/2)  =  √3/540).  -/
theorem t4genTerm3_at_line {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ)
    (hn : 0 < n) :
    (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
        ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) =
        (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ *
          (n : ℝ) ^ (-5 / 2 : ℝ) := by
  have hexp : (-(s.re + 2) : ℝ) = (-5 / 2 : ℝ) := by
    rw [hsre]
    norm_num
  rw [hexp, hsre]
  field_simp
  ring

/-  THE  REMAINING  G-hs3  CONTENT  (named  -  what  the  T4  lift
    does  and  does  not  close  for  the  endpoint's  hs3  leg):

  hs3  at  a  hypothetical  off-pair  zero  ρ  (|ρ.re  −  ½|  =
  d0  in  [¼/₂₀₀,  ½],  height  t0  =  |ρ.im|  ≥  tPT)  asks  for
  Qside  ≤  Bwire  +  Mr,  where  Qside  =  ‖K(ρ)‖  is  the  kernel
  scale  at  the  zero  (zeta  ρ  =  0).  Decompose  with  the  EM
  expression  W_n  (ρ)  =  zeta  ρ  −  P_n  ρ  +  I_n  ρ  =
  −(P_n  −  I_n)  ρ  (the  cited  DLMF 25.2.8  IDENTITY  -  the
  analytic-continuation  bridge  the  tree  already  cites  on  the
  line  applies  to  every  s  in  {Re  s  >  ½}\{1},  which
  contains  both  sides  of  the  endpoint  strip  band):

      G-hs3-i   ‖W_n(ρ)‖  =  ‖p4_em_expr  ρ  n‖  ≤  the  LIFTED
                  WALL  (p4_T4_bound_gen,  n  =  the  strip  n-
                  schedule)  -  CLOSED  THIS  ROUND  (machine-
                  proven,  both  sides  of  the  line).
      G-hs3-ii  ‖K(ρ)  −  (P_n  −  I_n)  ρ‖  ≤  M_wire  at  ρ  -
                  the  P6  finite-kernel  gap  (the  b3Bound-
                  Explicit  /  Mr-wire  family)  LIFTED  OFF  THE
                  LINE:  ITS  g-PRODUCT  TERMS  CARRY  g^{−σ}
                  FACTORS  (σ  =  ρ.re  =  ½  ±  d0)  THAT  THE
                  ON-LINE  WIRE  NEVER  EVALUATES.  OPEN.
      G-hs3-iii  the  margin  composition:  (G-hs3-i  +  G-hs3-ii)
                  <  floStripMin  (t0,  d0)  on  the  strip  band
                  above  the  frontier  -  the  pointwise  check
                  that  the  S4-strip  floor  (IN  BODY,
                  s4StripUnifiedFloor)  absorbs  the  off-line
                  scale  PLUS  the  off-line  gap.  OPEN  (needs
                  G-hs3-ii  first;  then  a  constants  check  in
                  the  style  of  the  25ae  wall  program).

  With  G-hs3-ii  +  G-hs3-iii  closed,  hs3  holds  IN  BODY  at
  every  off-pair  above  the  frontier  and  G-hs3  is  discharged
  from  the  endpoint  premises.  No  RH  claim.  -/
