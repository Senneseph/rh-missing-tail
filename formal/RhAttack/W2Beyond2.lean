/-
# (W2Beyond2)  The R2/R3 kernel half:  the tail of the Efull log kernel.

The exact Efull kernel of the W2 defect (docs/W2-LEAN-PLAN.md,
day023/day029 verbatim):

    p(g;t) = log|g^2 - t^2| - log(g^2 + 1/4) + 1/2/(g^2 + 1/4)

with principal value at g = t,  which the straddle grid avoids
(|gamma - t| >= 1/2 on the quantized straddle grid).

What this module proves (the kernel-half check for the universal
[S1],  docs/S1-A1-EXPLORATION.md E4):  on the far side of the
straddle (g >= 2t,  with t >= 1),

  eullK_far_rewrite      the closed far-side form
                         log(1 - (t^2+1/4)/(g^2+1/4)) + 1/2/(g^2+1/4)
  eullK_tail_bound       |p(g;t)|  <=  3 t^2 / g^2
                         (in particular  p(g;t) -> 0 as g -> oo)
  eullK_far_deriv        p'(g) = 2g/(g^2-t^2) - 2g/(g^2+1/4)
                                      - g/(g^2+1/4)^2     (g > t)
  eullK_tail_deriv_bound |p'(g)|  <=  5 t^2 / g^3     (g >= 2t)

Consequence (the architecture,  E4):  in the W2 bound
|W| <= K.(|p(G1)| + |p(G2)| + TV(p; (G1, G2])),  as the data
frontier G2 -> oo,  |p(G2)| -> 0  and the far-side total variation
over [g1, oo) is at most (5/2) t^2/g1^2  —  the kernel contributes
a CONSTANT cost to any frontier,  and the universal [S1] target
reduces,  on the walk side,  to the pointwise |DN| <= K  (the E1
restatement:  S bounded at the zeros).

One atom still queued in this module (next build):  the
finite-interval variation statement
|p(g2) - p(g1)| <= (5/2) t^2/g1^2  (g1 >= 2t)  via FTC.

No data,  no sorry:  pure real analysis on the pinned mathlib
(v4.33.1).  Every lemma name verified against the pinned tree and
against this repo's already-built W2 modules (e.g.  the Unbundled
order lemmas such as  div_le_div_iff_0).
-/
import Mathlib

/- The kernel,  and its far-side companions. -/

/-- The exact Efull log kernel (day023/day029 verbatim),  defined
off the diagonal g^2 = t^2.  (The straddle grid has |g - t| >= 1/2.) -/
noncomputable def EfullKernel (t g : ℝ) : ℝ :=
  Real.log |g^2 - t^2| - Real.log (g^2 + 1/4) + 1/2 / (g^2 + 1/4)

/-- The kernel rewritten on the far side of the straddle
(g > t):  the log of a positive number,  no absolute value. -/
noncomputable def FarKernel (t x : ℝ) : ℝ :=
  Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4)) + 1/2 / (x^2 + 1/4)

/-- The far-side derivative,  as a closed expression. -/
noncomputable def FarDeriv (t x : ℝ) : ℝ :=
  2*x/(x^2 - t^2) - 2*x/(x^2 + 1/4) - x/(x^2 + 1/4)^2

/-- x >= 2t  =>  x^2 >= 4 t^2.  (Explicit in t and its lower bound,
so the callers read `h4 t h1 x hx`.) -/
private lemma h4 (t : ℝ) (h1 : 1 ≤ t) (x : ℝ) (hx : x ≥ 2 * t) : 4 * t^2 ≤ x^2 := by
  have hp : 0 ≤ x - 2*t := by linarith
  have hp2 : 0 ≤ x + 2*t := by linarith
  have hfac : x^2 - 4*t^2 = (x - 2*t) * (x + 2*t) := by ring
  rw [← sub_nonneg, hfac]
  exact mul_nonneg hp hp2

/-- x >= 2t  =>  x^2 - t^2 > 0. -/
private lemma hfar (t : ℝ) (h1 : 1 ≤ t) (x : ℝ) (hx : x ≥ 2 * t) : 0 < x^2 - t^2 := by
  have hxpos : x > t := by linarith
  have hfac : x^2 - t^2 = (x - t) * (x + t) := by ring
  rw [hfac]
  exact mul_pos (sub_pos.mpr hxpos) (by linarith : 0 < x + t)

/-- The far-side rewrite:  x >= 2*t  =>
    EfullKernel = FarKernel  (no absolute value on the far side). -/
theorem eullK_far_rewrite (t : ℝ) (h1 : 1 ≤ t) (x : ℝ) (hx : x ≥ 2 * t) :
    EfullKernel t x = FarKernel t x := by
  have hf : 0 < x^2 - t^2 := hfar t h1 x hx
  simp only [EfullKernel, FarKernel]
  have hlog : Real.log (x^2 - t^2) - Real.log (x^2 + 1/4) =
      Real.log ((x^2 - t^2) / (x^2 + 1/4)) := by
    rw [← Real.log_div (ne_of_gt hf) (by positivity : (x^2 + 1/4) ≠ 0)]
  have hX : (x^2 - t^2) / (x^2 + 1/4) = 1 - (t^2 + 1/4) / (x^2 + 1/4) := by
    field_simp
    ring
  rw [abs_of_pos hf, hlog, hX]

/-- x in (0, 1/2]  =>  |log (1 - x)| <= 2 x.
    (log(1-x) < 0;  and the lower bound log(1-x) >= -x/(1-x)
    follows from  log y >= 1 - 1/y,  i.e.  log_le_sub_one_of_pos
    applied at y = 1/(1-x),  plus  1/(1-x) - 1 = x/(1-x) <= 2x.) -/
private lemma logOneSubAbsBound (x : ℝ) (hx0 : 0 < x) (hxh : x ≤ 1 / 2) :
    |Real.log (1 - x)| ≤ 2 * x := by
  have h1x : 0 < 1 - x := by linarith
  have hloglt : Real.log (1 - x) < 0 := by
    rw [← Real.log_one]
    exact Real.log_lt_log h1x (by linarith : 1 - x < 1)
  have hinv : Real.log (1 - x) = -Real.log (1 - x)⁻¹ := by
    rw [Real.log_inv, neg_neg]
  have hle : Real.log (1 - x)⁻¹ ≤ (1 - x)⁻¹ - 1 :=
    Real.log_le_sub_one_of_pos (by positivity : 0 < (1 - x)⁻¹)
  have hall : (1 - x)⁻¹ - 1 = x / (1 - x) := by
    field_simp
    ring
  have hmid : Real.log (1 - x)⁻¹ ≤ x / (1 - x) := by
    calc Real.log (1 - x)⁻¹ ≤ (1 - x)⁻¹ - 1 := hle
       _ = x / (1 - x) := hall
  have hlo : -x / (1 - x) ≤ Real.log (1 - x) := by
    have hflip : -(x / (1 - x)) ≤ -Real.log (1 - x)⁻¹ := neg_le_neg_iff.mpr hmid
    rw [hinv, neg_div]
    exact hflip
  have hin : x / (1 - x) ≤ 2 * x := by
    rw [show 2 * x = (2 * x) / 1 from by rw [div_one],
      div_le_div_iff₀ (by positivity : 0 < 1 - x) (by norm_num : (0 : ℝ) < 1)]
    nlinarith [hx0, hxh]
  rw [abs_of_neg hloglt]
  linarith [hlo, hin]

/-- TAIL BOUND:  t >= 1,  x >= 2t  =>  |EfullKernel t x| <= 3 t^2/x^2
    (hence  EfullKernel t x -> 0 as x -> oo). -/
theorem eullK_tail_bound (t : ℝ) (h1 : 1 ≤ t) (x : ℝ) (hx : x ≥ 2 * t) :
    |EfullKernel t x| ≤ 3 * t^2 / x^2 := by
  have h4t : 4 * t^2 ≤ x^2 := h4 t h1 x hx
  have hxpos : 0 < x := by linarith
  have hx2 : 0 < x^2 := pow_pos hxpos 2
  have hx2ne : x^2 ≠ 0 := ne_of_gt hx2
  have hrew : EfullKernel t x = FarKernel t x := eullK_far_rewrite t h1 x hx
  have hxk12 : (t^2 + 1/4) / (x^2 + 1/4) ≤ 1/2 := by
    rw [div_le_div_iff₀ (by positivity : 0 < x^2 + 1/4) (by norm_num : (0 : ℝ) < 2)]
    ring_nf
    nlinarith [h4t, h1]
  have hlogb : |Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4))| ≤
      2 * ((t^2 + 1/4) / (x^2 + 1/4)) :=
    logOneSubAbsBound ((t^2 + 1/4) / (x^2 + 1/4)) (by positivity) hxk12
  have hden : 1/2 / (x^2 + 1/4) ≤ 1/2 / x^2 := by
    rw [div_le_div_iff₀ (by positivity : 0 < x^2 + 1/4) hx2]
    ring_nf
    nlinarith
  have hxk2 : (t^2 + 1/4) / (x^2 + 1/4) ≤ (t^2 + 1/4) / x^2 := by
    rw [div_le_div_iff₀ (by positivity : 0 < x^2 + 1/4) hx2]
    ring_nf
    nlinarith
  have h2k : 2 * ((t^2 + 1/4) / (x^2 + 1/4)) ≤ 2 * ((t^2 + 1/4) / x^2) :=
    mul_le_mul_of_nonneg_left hxk2 (by norm_num : 0 ≤ (2 : ℝ))
  have hcomb : 2 * ((t^2 + 1/4) / x^2) + 1/2 / x^2 = (2 * t^2 + 1) / x^2 := by
    field_simp [hx2ne, show (x^2 + 1/4) ≠ 0 from by positivity]
    ring
  have hfin : (2 * t^2 + 1) / x^2 ≤ 3 * t^2 / x^2 := by
    have htn : 0 ≤ t := by linarith
    have ht2 : 1 ≤ t^2 := by
      have h0 : t * 1 ≤ t * t := mul_le_mul_of_nonneg_left h1 htn
      rw [mul_one] at h0
      rw [← pow_two] at h0
      exact le_trans h1 h0
    have hfin2 : x^2 ≤ t^2 * x^2 := by
      have h0 : x^2 * 1 ≤ x^2 * t^2 := mul_le_mul_of_nonneg_left ht2 (le_of_lt hx2)
      rw [mul_one] at h0
      rw [mul_comm] at h0
      exact h0
    rw [div_le_div_iff₀ hx2 hx2]
    nlinarith [hfin2]
  calc
    |EfullKernel t x|
        = |FarKernel t x| := by rw [hrew]
    _ = |Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4)) + 1/2 / (x^2 + 1/4)| := by
          dsimp only [FarKernel]
    _ ≤ |Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4))| + 1/2 / (x^2 + 1/4) := by
          have htri : |Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4)) +
              1/2 / (x^2 + 1/4)| ≤
              |Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4))| +
              |1/2 / (x^2 + 1/4)| := by
            simpa [Real.norm_eq_abs] using norm_add_le
              (Real.log (1 - (t^2 + 1/4) / (x^2 + 1/4))) (1/2 / (x^2 + 1/4))
          have habs : |1/2 / (x^2 + 1/4)| = 1/2 / (x^2 + 1/4) :=
            abs_of_nonneg (by positivity : 0 ≤ 1/2 / (x^2 + 1/4))
          rw [habs] at htri
          exact htri
    _ ≤ 2 * ((t^2 + 1/4) / (x^2 + 1/4)) + 1/2 / (x^2 + 1/4) :=
          add_le_add hlogb (le_rfl)
    _ ≤ 2 * ((t^2 + 1/4) / (x^2 + 1/4)) + 1/2 / x^2 :=
          add_le_add (le_rfl) hden
    _ ≤ 2 * ((t^2 + 1/4) / x^2) + 1/2 / x^2 :=
          add_le_add h2k (le_rfl)
    _ = (2 * t^2 + 1) / x^2 := hcomb
    _ ≤ 3 * t^2 / x^2 := hfin

/-- The far-side derivative (x > t):
    the derivative of FarKernel t at x is  FarDeriv t x,  with
    FarDeriv t x = 2x/(x^2-t^2) - 2x/(x^2+1/4) - x/(x^2+1/4)^2. -/
theorem eullK_far_deriv (t : ℝ) (htn : 0 ≤ t) (x : ℝ) (hxt : x > t) :
    HasDerivAt (fun y : ℝ => FarKernel t y) (FarDeriv t x) x := by
  have hf : 0 < x^2 - t^2 := by
    have hfac : x^2 - t^2 = (x - t) * (x + t) := by ring
    rw [hfac]
    exact mul_pos (sub_pos.mpr hxt) (by linarith : 0 < x + t)
  let u := fun y : ℝ => 1 - (t^2 + 1/4) / (y^2 + 1/4)
  let c := t^2 + 1/4
  have hudiff (y : ℝ) : HasDerivAt (fun y : ℝ => y^2 + 1/4) (2*y) y := by
    have hfun : (fun z : ℝ => z^2) + (fun z : ℝ => (1/4 : ℝ)) = fun y : ℝ => y^2 + 1/4 := by
      ext z
      simp
    rw [← hfun]
    simpa using (hasDerivAt_pow 2 y).add (hasDerivAt_const y (1/4 : ℝ))
  have hv (y : ℝ) : HasDerivAt (fun y : ℝ => c / (y^2 + 1/4))
      (-(c * (2*y)) / (y^2 + 1/4)^2) y := by
    have hfun : (fun _ : ℝ => c) / (fun z : ℝ => z^2 + 1/4) = fun y : ℝ => c / (y^2 + 1/4) := by
      ext z
      rfl
    have hg1 : HasDerivAt ((fun _ : ℝ => c) / (fun z : ℝ => z^2 + 1/4))
        ((0 * (y^2 + 1/4) - c * (2*y)) / (y^2 + 1/4)^2) y :=
      (hasDerivAt_const y c).div (hudiff y) (by positivity : (y^2 + 1/4) ≠ 0)
    have hder : (0 * (y^2 + 1/4) - c * (2*y)) / (y^2 + 1/4)^2 =
        (-(c * (2*y))) / (y^2 + 1/4)^2 := by
      field_simp
      ring
    rw [hfun, hder] at hg1
    exact hg1
  have hu (y : ℝ) : HasDerivAt u (c * (2*y) / (y^2 + 1/4)^2) y := by
    have hfun : (fun _ : ℝ => (1 : ℝ)) - (fun z : ℝ => c / (z^2 + 1/4)) = u := by
      ext z
      simp
      ring
    have hg1 : HasDerivAt ((fun _ : ℝ => (1 : ℝ)) - (fun z : ℝ => c / (z^2 + 1/4)))
        (0 - (-(c * (2*y)) / (y^2 + 1/4)^2)) y :=
      (hasDerivAt_const y (1 : ℝ)).sub (hv y)
    have hder : 0 - (-(c * (2*y)) / (y^2 + 1/4)^2) = c * (2*y) / (y^2 + 1/4)^2 := by ring
    rw [hfun, hder] at hg1
    exact hg1
  have hune : u x ≠ 0 := by
    have hux : u x = (x^2 - t^2) / (x^2 + 1/4) := by
      dsimp only [u]
      field_simp
      ring
    rw [hux]
    exact div_ne_zero (ne_of_gt hf) (by positivity)
  have hlog : HasDerivAt (fun y : ℝ => Real.log (u y))
      ((u x)⁻¹ * (c * (2*x) / (x^2 + 1/4)^2)) x :=
    HasDerivAt.comp x (Real.hasDerivAt_log (x := u x) hune) (hu x)
  have hc2 (y : ℝ) : HasDerivAt (fun y : ℝ => 1/2 / (y^2 + 1/4))
      (-(1/2 * (2*y)) / (y^2 + 1/4)^2) y := by
    have hfun : (fun _ : ℝ => (1/2 : ℝ)) / (fun z : ℝ => z^2 + 1/4) =
        fun y : ℝ => 1/2 / (y^2 + 1/4) := by
      ext z
      rfl
    have hg1 : HasDerivAt ((fun _ : ℝ => (1/2 : ℝ)) / (fun z : ℝ => z^2 + 1/4))
        ((0 * (y^2 + 1/4) - (1/2 : ℝ) * (2*y)) / (y^2 + 1/4)^2) y :=
      (hasDerivAt_const y (1/2 : ℝ)).div (hudiff y) (by positivity : (y^2 + 1/4) ≠ 0)
    have hder : (0 * (y^2 + 1/4) - (1/2 : ℝ) * (2*y)) / (y^2 + 1/4)^2 =
        (-(1/2 * (2*y))) / (y^2 + 1/4)^2 := by
      field_simp
      ring
    rw [hfun, hder] at hg1
    exact hg1
  have hsum : HasDerivAt (fun y : ℝ => FarKernel t y)
      ((u x)⁻¹ * (c * (2*x) / (x^2 + 1/4)^2) +
         (-(1/2 * (2*x)) / (x^2 + 1/4)^2)) x := by
    have hfun : (fun z : ℝ => Real.log (u z)) + (fun z : ℝ => 1/2 / (z^2 + 1/4)) =
        fun y : ℝ => FarKernel t y := by
      ext z
      dsimp only [u, FarKernel]
      simp
    have hg1 : HasDerivAt ((fun z : ℝ => Real.log (u z)) +
        (fun z : ℝ => 1/2 / (z^2 + 1/4)))
        ((u x)⁻¹ * (c * (2*x) / (x^2 + 1/4)^2) +
           (-(1/2 * (2*x)) / (x^2 + 1/4)^2)) x :=
      hlog.add (hc2 x)
    rw [hfun] at hg1
    exact hg1
  -- algebraic identity:  the assembled derivative = FarDeriv t x
  have hiden : (u x)⁻¹ * (c * (2*x) / (x^2 + 1/4)^2) +
      (-(1/2 * (2*x)) / (x^2 + 1/4)^2) = FarDeriv t x := by
    have hux : u x = (x^2 - t^2) / (x^2 + 1/4) := by
      dsimp only [u]
      field_simp
      ring
    dsimp only [c]
    rw [hux, FarDeriv]
    field_simp [hf, show (0 : ℝ) < x^2 + 1/4 from by positivity]
    ring
  convert hsum using 1
  exact hiden.symm

/-- TAIL DERIVATIVE BOUND:  t >= 1,  x >= 2t  =>
    |FarDeriv t x| <= 5 t^2/x^3  (hence the far-side total
    variation over [g1, oo) is at most (5/2) t^2/g1^2,
    independent of the upper end). -/
theorem eullK_tail_deriv_bound (t : ℝ) (h1 : 1 ≤ t) (x : ℝ) (hx : x ≥ 2 * t) :
    |FarDeriv t x| ≤ 5 * t^2 / x^3 := by
  have h4t : 4 * t^2 ≤ x^2 := h4 t h1 x hx
  have hf : 0 < x^2 - t^2 := hfar t h1 x hx
  have hxpos : 0 < x := by linarith
  have hx2 : 0 < x^2 := pow_pos hxpos 2
  have hx3 : 0 < x^3 := pow_pos hxpos 3
  have hx3nn : 0 ≤ x^3 := pow_nonneg (le_of_lt hxpos) 3
  let A := 2*x / (x^2 - t^2)
  let B := 2*x / (x^2 + 1/4)
  let C := x / (x^2 + 1/4)^2
  let D := (x^2 - t^2) * (x^2 + 1/4)
  have hdenD : 0 < D := by
    dsimp only [D]
    apply mul_pos hf
    positivity
  have hAB : A ≥ B := by
    dsimp only [A, B]
    rw [ge_iff_le,
      div_le_div_iff₀ (by positivity : 0 < x^2 + 1/4) hf]
    ring_nf
    nlinarith [h1, hxpos]
  have hABex : A - B = 2*x * (t^2 + 1/4) / D := by
    dsimp only [A, B, D]
    field_simp [show (x^2 - t^2) ≠ 0 from ne_of_gt hf,
      show (x^2 + 1/4) ≠ 0 from by positivity]
    ring
  have hD : D ≥ (3/4 : ℝ) * x^4 := by
    dsimp only [D]
    have hg1 : x^2 - t^2 ≥ (3/4 : ℝ) * x^2 := by nlinarith [h4t]
    have h3 : (x^2 - t^2) * x^2 ≥ ((3/4 : ℝ) * x^2) * x^2 :=
      mul_le_mul_of_nonneg_right hg1 (by positivity : 0 ≤ x^2)
    have h4 : (x^2 - t^2) * (1/4 : ℝ) ≥ ((3/4 : ℝ) * x^2) * (1/4 : ℝ) := by
      have h4l := mul_le_mul_of_nonneg_right hg1 (by norm_num : 0 ≤ (4 : ℝ)⁻¹)
      simpa using h4l
    calc
      (x^2 - t^2) * (x^2 + 1/4)
          = (x^2 - t^2) * x^2 + (x^2 - t^2) * (1/4) := by ring
      _ ≥ ((3/4 : ℝ) * x^2) * x^2 + ((3/4 : ℝ) * x^2) * (1/4) :=
          add_le_add h3 (by simpa [mul_assoc, mul_comm, mul_left_comm] using h4)
      _ ≥ (3/4 : ℝ) * x^4 := by
          have hring : ((3/4 : ℝ) * x^2) * x^2 + ((3/4 : ℝ) * x^2) * (1/4) =
              (3/4 : ℝ) * x^4 + (3/16 : ℝ) * x^2 := by ring
          rw [hring]
          nlinarith [show (0 : ℝ) ≤ (3/16) * x^2 from by positivity]
  have hcore : 2*x / D ≤ (8/3 : ℝ) / x^3 := by
    rw [div_le_div_iff₀ hdenD hx3]
    nlinarith [hD]
  have hA1 : A - B ≤ (8/3 : ℝ) * (t^2 + 1/4) / x^3 := by
    have hmul : A - B = (t^2 + 1/4) * (2*x / D) := by
      dsimp only [A, B, D]
      field_simp [hdenD, hf, show (x^2 - t^2) ≠ 0 from ne_of_gt hf,
        show (x^2 + 1/4) ≠ 0 from by positivity, show D ≠ 0 from ne_of_gt hdenD]
      ring
    have hstep : (t^2 + 1/4) * (2*x / D) ≤ (t^2 + 1/4) * ((8/3 : ℝ) / x^3) :=
      mul_le_mul_of_nonneg_left hcore (by positivity : 0 ≤ t^2 + 1/4)
    calc
      A - B = (t^2 + 1/4) * (2*x / D) := hmul
      _ ≤ (t^2 + 1/4) * ((8/3 : ℝ) / x^3) := hstep
      _ = (8/3 : ℝ) * (t^2 + 1/4) / x^3 := by
          field_simp [show x^3 ≠ 0 from ne_of_gt hx3]
  have hC1 : C ≤ 1/x^3 := by
    dsimp only [C]
    rw [div_le_div_iff₀ (by positivity : 0 < (x^2 + 1/4)^2) hx3]
    ring_nf
    nlinarith
  have ht3 : 1/x^3 ≤ t^2/x^3 := by
    have htn0 : 0 ≤ t := by linarith
    have htsq0 : t * 1 ≤ t * t := mul_le_mul_of_nonneg_left h1 htn0
    rw [mul_one] at htsq0
    rw [← pow_two] at htsq0
    have ht2 : 1 ≤ t^2 := le_trans h1 htsq0
    rw [div_le_div_iff₀ hx3 hx3]
    nlinarith [ht2]
  calc
    |FarDeriv t x|
        = |A - B - C| := by
          dsimp only [A, B, C, FarDeriv]
    _ ≤ |A - B| + |C| := abs_sub _ _
    _ = (A - B) + C := by
          rw [abs_of_nonneg (sub_nonneg.mpr hAB),
            abs_of_nonneg (by positivity : 0 ≤ C)]
    _ ≤ (8/3 : ℝ) * (t^2 + 1/4) / x^3 + 1/x^3 := add_le_add hA1 hC1
    _ ≤ (8/3 : ℝ) * (t^2 + 1/4) / x^3 + t^2/x^3 := add_le_add (le_rfl) ht3
    _ ≤ 5 * t^2 / x^3 := by
          rw [show (8/3 : ℝ) * (t^2 + 1/4) / x^3 + t^2/x^3 =
                ((8/3 : ℝ) * (t^2 + 1/4) + t^2) / x^3 from by
            rw [← add_div ((8/3 : ℝ) * (t^2 + 1/4)) (t^2) (x^3)]]
          rw [div_le_div_iff₀ hx3 hx3]
          ring_nf
          have htn0 : 0 ≤ t := by linarith
          have htsq0 : t * 1 ≤ t * t := mul_le_mul_of_nonneg_left h1 htn0
          rw [mul_one] at htsq0
          rw [← pow_two] at htsq0
          have ht2 : 1 ≤ t^2 := le_trans h1 htsq0
          nlinarith [ht2]

