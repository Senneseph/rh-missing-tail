/- P4Limit — P4 atoms L1..L5: the M→∞ passage of the second-order EM law,
   the remainder bounds (OP1/OP2), and the stated zero-free bound B_n(t)
   for the missing tail W_n(t).

OUTLINE piece: P4 (the rigorous missing-tail law, outline §9 row P4), the
M→∞ passage (spec: kainos plan/40-prize-islands/rh-attack/spec/
p4-tail-law-abstract.md §T2–T4; operational decomposition:
plan/.../spec/p4limit-module-sketch.md, atoms L1–L5).

ROLE: turns the green finite law (RhAttack.P4Em2.em2_finite) into the
line-statement: for s = ½ + it, n ≥ 1, with
  W_n(s) := riemannZeta s - P_n s + I(n,s),  I(n,s) := n^{1-s}/(1-s),
the identity (Riemann 1859, cited under the B-3 no-ζ-identity convention;
published form: DLMF 25.2.8 (ℜs > 0) / 25.2.9 n = 1 (ℜs > -2),
cross-checked against the DLMF form to 3.5e-18, day-019):

  W_n(s) = -½·n^{-s} + (s/12)·n^{-s-1} - ½·∫_n^∞ B̂₂({x})·f″(x) dx

and therefore the stated output — a zero-free, explicit, computable
upper bound feeding the floor (P8):

  |W_n(t)| ≤ B_n(t) := ½·n^{-1/2} + (|s|/12)·n^{-3/2}
                   + (√3/216)·|s|·(|s|+1)·n^{-5/2}.

Built from:
  (1) RhAttack.P4Em2.em2_finite (global finite 2nd-order EM, green),
  (2) RhAttack.P4Tail.B2 (periodic B̂₂, green) and the pinned mathlib
      machinery of the research log (IntegrationByParts.lean,
      IntervalIntegral/Periodic.lean, bernoulli polynomials,
      zeta_eq_tsum_one_div_nat_cpow),
  (3) atoms L1–L5 of this file (draft in progress).

APPROACH / pinned APIs (Lean 4.33.1, mathlib f001ca3a4; see the P4Em2
header for the uIcc/Nat.cast_add/ContinuousOn.mono conventions):
  * `hasDerivAt_ofReal_cpow_const {x : ℝ} (hx : x ≠ 0) {r : ℂ}
    (hr : r ≠ 0) : HasDerivAt (fun y => (y : ℂ) ^ r) (r * x ^ (r - 1)) x`
    (Analysis/SpecialFunctions/Pow/Deriv.lean:288) — all cpow derivative
    facts (L1).
  * `hasDerivAt_ofReal_cpow_const' {x} (hx : x ≠ 0) {r : ℂ}
    (hr : r ≠ -1) : HasDerivAt (fun y => (y : ℂ) ^ (r + 1) / (r + 1))
    (x ^ r) x` (:248) — the antiderivative fact (L2) at r := -s, i.e.
    the s ≠ 1 hypothesis.
  * `HasDerivAt.const_mul (c : ℂ) (hd : HasDerivAt d d' x) :
    HasDerivAt (fun y => c * d y) (c * d') x` (Calculus/Deriv/Mul.lean:355).
  * `intervalIntegral.integral_eq_sub_of_hasDerivAt (hderiv :
    ∀ x ∈ uIcc a b, HasDerivAt f (f' x) x) (hint : IntervalIntegrable f'
    volume a b) : ∫ y in a..b, f' y = f b - f a`
    (IntervalIntegral/FundThmCalculus.lean:1148) — antiderivative
    evaluation (L2).
  * `DifferentiableOn.continuousOn` (Calculus/FDeriv/Basic.lean:664).

STATUS (2026-09-13, Lean 4.33.1): atoms L1, L2, L3, L4 GREEN.  L4 is the
missing-tail law (IBP route: `p4_op2c_bound` + `p4_f2_tail_bound`); L5
(the `f1 ⊣ f2` closure) is assembled downstream.  No sorry.
THEOREMS (L1): p4_f_hasDerivAt, p4_f1_hasDerivAt, p4_f2_hasDerivAt,
 p4_f1_at, p4_f2_at, p4_f1_on_Icc, p4_f2_on_Icc.
THEOREMS (L2): p4_integral_closed, p4_finite_em2.
THEOREMS (L3): p4_f2_abs_eq, p4_f2_continuousOn_Ioi, p4_f2_integrableOn_Ioi,
 p4_f2_integral_Ioi_eq, p4_kernel_integrableOn_Ioi, p4_kernel_tendsto,
 p4_f2_tendsto.
THEOREMS (L4): B3poly, B3poly_at_0, B3poly_at_1, B3poly_max_val,
 B3poly_min_val, abs_B3poly_le, p4_op2c_bound, p4_f2_tail_bound.

L4 TRANSFERABLE NOTES (the IBP/missing-tail route):
  * The missing-tail constant is NOT `sqrt(3)/108`.  Integrating by parts
    twice with the periodic `B3poly` gives
    `INT B2 x * x^(-s-2) = B3poly(x)*x^(-s-2)| + INT B3poly *
    ((s+1)(s+2) * x^(-s-3))` and `|B3poly| <= sqrt(3)/36` at
    `u=(3±sqrt 3)/6` (computed, never recalled).  The numeric refutation of
    `sqrt(3)/108` happened on day-019; the `sqrt(3)/270 * ||s+2||` form is
    what holds on a 15-point grid before formalization (P4 numeric rule).
  * `HasDerivAt.comp` in 4.33.1 takes the point `x` as an explicit first
    argument: `HasDerivAt.comp x (h2 : HasDerivAt h2 h2' (h x))
    (h : HasDerivAt h h' x) : HasDerivAt (h2 ∘ h) (h2' * h') x`.
  * `intervalIntegral.intervalIntegrable` (ContinuousOn form) takes NO
    explicit endpoint arguments in 4.33.1; the pointwise
    `continuousAt_rpow_const ... |>.continuousWithinAt` is the
    one-sided-continuity idiom, and `uIcc`'s lower bound is a `min`
    (bridge with `min_eq_left` before feeding it to `nlinarith`).
  * `tendsto_order : Tendsto f l (𝓝 a) ↔
    (∀ a' < a, ∀ᶠ b, a' < f b) ∧ (∀ a' > a, ∀ᶠ b, f b < a')` — the
    one-sided eventual-inequality idiom.  AND: the eventual upper bound
    passes to the limit directly via `le_of_tendsto (lim : Tendsto f x
    (𝓝 a)) (h : ∀ᶠ c, f c ≤ b) : a ≤ b` (ClosedIicTopology + x.NeBot
    instance) — this REPLACES the by_contra + `filter_upwards`-on-`False`
    dance (`filter_upwards` needs a pi-goal, not `False`).
  * `Filter.Eventually` is a Prop (`l.Eventually p = {x | p x} ∈ l`), so
    there is NO `.imp` dot-notation on a `∀ᶠ`; to compose eventuals,
    `filter_upwards [h1, h2] with x h1 h2` and feed separate names.
  * For a real-constant times an interval integral, pull the constant out
    with `intervalIntegral.integral_const_mul`, not `integral_smul` (which
    is the `•` form — for ℂ-smul over ℂ, `c • z = c * z` is definitional).
  * `Complex.norm_cpow_eq_rpow_re_of_pos` needs STRICT `0 < x`, and must be
    applied BEFORE rewriting the exponent's real part; the endpoint forms
    `((k+1 : ℕ) : ℝ)` vs `(k : ℝ) + 1` are not definitionally equal —
    bridge with `Nat.cast_succ`.

L3 TRANSFERABLE NOTES (keep — drafted from the published Gamma example,
Mathlib/Analysis/SpecialFunctions/Gamma/Basic.lean, `Complex.
GammaIntegral_convergent` / `tendsto_partialGamma`):
  * `IntegrableOn f s` = `Integrable f (volume.restrict s)` = the pair
    `⟨AEStronglyMeasurable, HasFiniteIntegral⟩` on that restricted measure;
    `constructor` splits it.  Set integrals `∫ x in s, f x` are
    definitionally `∫ x, f x ∂ (volume.restrict s)`, so univariate
    lemmas (`MeasureTheory.integral_smul`, `integral_Ioi_cpow_of_lt`)
    match set integrals directly.
  * `MeasureTheory.ae_of_all {p} (μ : F) (hp : ∀ a, p a) : ∀ᵐ a ∂μ, p a`
    — the MEASURE (outer measure) is the FIRST explicit argument; passing
    the `by`-block first sends it into the `μ : F` slot (goal becomes a
    bare meta, `introN` fails on `?m` — the symptom).
  * After `← hasFiniteIntegral_norm_iff`, mono' sees the NORM of the norm:
    `‖(‖f x‖ : ℝ)‖` — strip it with a one-line `have h1 := by simp`
    (verified by probe: `‖(‖z‖ : ℝ)‖ = ‖z‖` is a simp fact).
  * `ContinuousOn.aestronglyMeasurable (hf : ContinuousOn f s)
    (hs : MeasurableSet s) : AEStronglyMeasurable f (μ.restrict s)`;
    narrowing the set: `ContinuousOn.mono (hf : ContinuousOn f s0)
    (h : t ⊆ s0)`; `Ioi c ⊆ Ioi 0` via `Ioi_subset_Ioi_iff.mpr` (there is
    NO `Ioi_subset_Ioi_left` in 4.33.1).
  * `continuousOn_const` is argument-free in 4.33.1 (`fun_prop` lemma,
    both s and c implicit) — spell the type in a `have`.
  * For ℂ-smul over ℂ, `c • z = c * z` is DEFINITIONAL (`rfl` closes it;
    verified by probe) — no `smul_def` needed; bare `smul_def` is a trap
    here: `open Finset` makes it resolve to `Finset.smul_def`.
  * Kernel B2-side aes: P4Tail's `fun_prop` aes +
    `Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)`
    + `AEStronglyMeasurable.mono_measure` (aes descends to smaller
    measures; `Measure.restrict_mono (Ioi c).subset_univ le_rfl` trans
    `le_of_eq Measure.restrict_univ`).
  * The `0` in `Set.Ioi 0` and lambda binders `fun (x : ℝ) => ...` must be
    explicitly typed — underdetermined `0`/`x` default to ℂ here.
  * `Complex.add_re` (NOT `re_add`), `Complex.neg_re`, `Complex.norm_def`,
    `Complex.normSq_ofReal`, `Real.sqrt_sq_eq_abs` — the |B2| bridge chain.

L2 REMAINDER-TERM MATCHING (transferable technique, keep for L3–L5):
`em2_finite` lives in a `[RCLike 𝕜]` context, where its tail integrand
`B2 x * deriv (deriv f) x` elaborates the ℝ→𝕜 scalar through the
RCLike coercion `ofReal := Algebra.cast` (= `algebraMap ℝ 𝕜`). In a
concrete `ℂ` file the same printed term `B2 x * d` — or even the
explicit cast `(B2 x : ℂ) * d` — elaborates through the higher-priority
`Coe ℝ ℂ` (Data/Complex, `Complex.ofReal`). The two kernel terms print
identically (`↑(B2 x) * d`) but are NOT unification-equal, so
`rw [hRem]` silently fails with "did not find an occurrence". Fix:
spell the scalar explicitly as `algebraMap (R := ℝ) (A := ℂ) (B2 x)`
in both the congruence hypothesis (hIC) and the remainder equality
(hRem) — verified by a four-form probe (bare / Coe / Algebra.cast /
algebraMap): only the last two rewrite-match. `algebraMap x = (x : ℂ)`
itself closes by `rfl`, so this costs nothing mathematically. -/
import Mathlib
import RhAttack.P4Em2
import RhAttack.P4Tail

open Real Set Filter MeasureTheory intervalIntegral Finset

open scoped Topology

noncomputable section

/-! The P4 family, at a complex exponent `s` (the line case is
`s = 1/2 + t·i`, Re s = ½): `f(x) = x^{-s}` on x > 0, with the explicit
first/second derivatives. -/

/-- `f(x) = (x : ℂ)^{-s}` (real variable, complex value). -/
def p4_f (s : ℂ) (x : ℝ) : ℂ := (x : ℂ) ^ (-s)

/-- The explicit first derivative `f'(x) = -s·(x : ℂ)^{-s-1}`. -/
def p4_f1 (s : ℂ) (x : ℝ) : ℂ := -s * (x : ℂ) ^ (-s - 1)

/-- The explicit second derivative `f''(x) = s(s+1)·(x : ℂ)^{-s-2}`. -/
def p4_f2 (s : ℂ) (x : ℝ) : ℂ := s * (s + 1) * (x : ℂ) ^ (-s - 2)

/-- Atom L1.a — `f` has the formal cpow derivative at every x ≠ 0 (s ≠ 0). -/
theorem p4_f_hasDerivAt {s : ℂ} (hs : s ≠ 0) (x : ℝ) (hx : x ≠ 0) :
    HasDerivAt (p4_f s) (-s * (x : ℂ) ^ (-s - 1)) x := by
  apply hasDerivAt_ofReal_cpow_const (r := -s) hx
  exact neg_ne_zero.mpr hs

/-- Atom L1.b — `f'` differentiates again at every x ≠ 0 (s ≠ 0, s ≠ -1),
    giving `f''(x) = s(s+1)·x^{-s-2}`. -/
theorem p4_f1_hasDerivAt {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) (x : ℝ) (hx : x ≠ 0) :
    HasDerivAt (p4_f1 s) (s * (s + 1) * (x : ℂ) ^ (-s - 2)) x := by
  have hex : (-s - 1 - 1 : ℂ) = -s - 2 := by ring
  have hbase : HasDerivAt (fun y : ℝ => (y : ℂ) ^ (-s - 1))
      ((-s - 1) * (x : ℂ) ^ (-s - 2)) x := by
    simpa [hex] using hasDerivAt_ofReal_cpow_const (x := x) (r := -s - 1) hx (by
      intro h
      have h1 : -s = 1 := sub_eq_zero.mp h
      apply hs2
      rw [← neg_inj, neg_neg]
      exact h1)
  convert! hbase.const_mul (-s) using 1
  ring

/-- Atom L1.c — `f''` differentiates again at every x ≠ 0
    (s ∉ {0, -1, -2}); only needed for completeness of the family
    (the shipped statements use f'' as the terminal derivative). -/
theorem p4_f2_hasDerivAt {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) (hs3 : s ≠ -2)
    (x : ℝ) (hx : x ≠ 0) :
    HasDerivAt (p4_f2 s) (-(s * (s + 1) * (s + 2)) * (x : ℂ) ^ (-s - 3)) x := by
  have hex : (-s - 2 - 1 : ℂ) = -s - 3 := by ring
  have hbase : HasDerivAt (fun y : ℝ => (y : ℂ) ^ (-s - 2))
      ((-s - 2) * (x : ℂ) ^ (-s - 3)) x := by
    simpa [hex] using hasDerivAt_ofReal_cpow_const (x := x) (r := -s - 2) hx (by
      intro h
      have h1 : -s = 2 := sub_eq_zero.mp h
      apply hs3
      rw [← neg_inj, neg_neg]
      exact h1)
  convert! hbase.const_mul (s * (s + 1)) using 1
  ring

/-- Atom L1.d — pointwise: `deriv f = p4_f1` at every x ≠ 0. -/
theorem p4_f1_at {s : ℂ} (hs : s ≠ 0) (x : ℝ) (hx : x ≠ 0) :
    deriv (p4_f s) x = p4_f1 s x := by
  dsimp only [p4_f1]
  exact (p4_f_hasDerivAt hs x hx).deriv

/-- Atom L1.e — `deriv (p4_f s)` has the explicit second derivative at every 0 < x
    (locality of differentiability: on Ioi 0, `deriv (p4_f s) = p4_f1 s`). -/
theorem p4_f1_deriv_hasDerivAt {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) {x : ℝ} (hxpos : 0 < x) :
    HasDerivAt (deriv (p4_f s)) (p4_f2 s x) x := by
  -- On a neighborhood of x (the open set Ioi 0), `deriv (p4_f s)` equals
  -- the named function `p4_f1 s`; differentiability (and the derivative
  -- value) are local, so the statement transfers.
  have hL : deriv (p4_f s) =ᶠ[𝓝 x] (p4_f1 s) := by
    filter_upwards [isOpen_Ioi.mem_nhds hxpos] with u hu
    exact p4_f1_at hs1 u hu.ne'
  have hLw : deriv (p4_f s) =ᶠ[𝓝[Set.univ] x] (p4_f1 s) := by
    simpa [nhdsWithin_univ] using hL
  have hpt : deriv (p4_f s) x = p4_f1 s x := p4_f1_at hs1 x hxpos.ne'
  have hd1 : HasDerivAt (p4_f1 s) (p4_f2 s x) x := p4_f1_hasDerivAt hs1 hs2 x hxpos.ne'
  simpa using (Filter.EventuallyEq.hasDerivWithinAt_iff hLw hpt).mpr hd1.hasDerivWithinAt

/-- Atom L1.e2 — pointwise: `deriv (deriv f) = p4_f2` at every 0 < x. -/
theorem p4_f2_at {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) {x : ℝ} (hxpos : 0 < x) :
    deriv (deriv (p4_f s)) x = p4_f2 s x :=
  (p4_f1_deriv_hasDerivAt hs1 hs2 hxpos).deriv

/-- Atom L1.f — on a positive integral interval, the derivative function
    equals `p4_f1` (function equality on `Icc`, for `em2_finite`-style
    hypothesis bridging). -/
theorem p4_f1_on_Icc {s : ℂ} (hs : s ≠ 0) (n m : ℕ) (hn : 0 < n) (hnm : n ≤ m) :
    ∀ t ∈ Set.Icc (n : ℝ) (m : ℝ), deriv (p4_f s) t = p4_f1 s t := by
  intro t ht
  have hpos : 0 < t := by
    have hlo : (n : ℝ) ≤ t := ht.1
    exact lt_of_lt_of_le (Nat.cast_pos.mpr hn) hlo
  exact p4_f1_at hs t hpos.ne'

/-- Atom L1.g — same for the second derivative. -/
theorem p4_f2_on_Icc {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) (n m : ℕ) (hn : 0 < n)
    (hnm : n ≤ m) :
    ∀ t ∈ Set.Icc (n : ℝ) (m : ℝ), deriv (deriv (p4_f s)) t = p4_f2 s t := by
  intro t ht
  have hpos : 0 < t := by
    have hlo : (n : ℝ) ≤ t := ht.1
    exact lt_of_lt_of_le (Nat.cast_pos.mpr hn) hlo
  exact p4_f2_at hs1 hs2 hpos

/-! ### L2 — the exact finite second-order EM identity (no limits, no ζ) -/

/-- Antiderivative family `F_s(x) = x^{1-s}` (written `x^{-s+1}` to match the
    real-cpow antiderivative theorem's native form; used with the factor `1/(1-s)` when `s ≠ 1`). -/
def p4_A (s : ℂ) (x : ℝ) : ℂ := (x : ℂ) ^ (-s + 1)

/-- Atom L2.a — the elementary integral in closed form, `[x^{1-s}/(1-s)]_n^m`,
    by the FTC (`integral_eq_sub_of_hasDerivAt`) with the real-cpow
    antiderivative (`hasDerivAt_ofReal_cpow_const'`). -/
theorem p4_integral_closed (s : ℂ) (hs3 : s ≠ 1) {n m : ℕ} (hn : 0 < n) (hnm : n ≤ m) :
    (∫ x in (n : ℝ)..(m : ℝ), p4_f s x) =
      (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) := by
  have hnmR : (n : ℝ) ≤ (m : ℝ) := Nat.cast_le.mpr hnm
  set G := fun x : ℝ => (x : ℂ) ^ (-s + 1) / (-s + 1)
  have hF' : ∀ x ∈ Set.uIcc (n : ℝ) (m : ℝ), HasDerivAt G (p4_f s x) x := by
    intro x ht
    rw [uIcc_of_le hnmR] at ht
    have hxpos : 0 < x := lt_of_lt_of_le (Nat.cast_pos.mpr hn) ht.1
    simpa [p4_f] using
      hasDerivAt_ofReal_cpow_const' (r := -s) hxpos.ne' (by
        intro h
        rw [neg_inj] at h
        exact hs3 h)
  have hC : ContinuousOn (p4_f s) (Set.Icc (n : ℝ) (m : ℝ)) := by
    intro x hx
    exact (Complex.continuousAt_ofReal_cpow_const x (-s)
      (Or.inr (lt_of_lt_of_le (Nat.cast_pos.mpr hn) hx.1).ne')).continuousWithinAt
  have hint : IntervalIntegrable (p4_f s) volume (n : ℝ) (m : ℝ) :=
    hC.intervalIntegrable_of_Icc hnmR
  have hds : (-s + 1 : ℂ) = 1 - s := by ring
  rw [integral_eq_sub_of_hasDerivAt hF' hint]
  simp only [G, p4_A]
  rw [hds]
  ring

/-- Atom L2.b — the exact finite second-order Euler–Maclaurin identity for
    `f(x) = x^{-s}` on `[n, m]`, with every endpoint term and the periodic-`B2`
    remainder made explicit.  Pure rearrangement:
    `em2_finite` (P4Em2) + the L1 derivative family + L2.a.  No limit, no ζ. -/
theorem p4_finite_em2 (s : ℂ) (hs1 : s ≠ 0) (hs2 : s ≠ -1) (hs3 : s ≠ 1)
    {n m : ℕ} (hn : 0 < n) (hnm : n ≤ m) :
  (∑ k ∈ Finset.Ioc n m, p4_f s k) =
    (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) +
    (1 / 2) * (p4_f s (m : ℝ) - p4_f s (n : ℝ)) +
    (1 / 12) * (p4_f1 s (m : ℝ) - p4_f1 s (n : ℝ)) -
    (1 / 2) * (∫ x in (n : ℝ)..(m : ℝ), algebraMap (R := ℝ) (A := ℂ) (B2 x) * p4_f2 s x) := by
  set S := Set.Icc (n : ℝ) (m : ℝ) with hSdef
  have hnmR : (n : ℝ) ≤ (m : ℝ) := Nat.cast_le.mpr hnm
  have hdiff : ∀ t ∈ S, DifferentiableAt ℝ (p4_f s) t := by
    intro t ht
    exact (p4_f_hasDerivAt hs1 t
      (lt_of_lt_of_le (Nat.cast_pos.mpr hn) ht.1).ne').differentiableAt
  have hC1 : ContinuousOn (p4_f1 s) S := by
    intro x hx
    have hpos : x ≠ 0 := (lt_of_lt_of_le (Nat.cast_pos.mpr hn) hx.1).ne'
    have hbase : ContinuousWithinAt (fun y : ℝ => (y : ℂ) ^ (-s - 1)) S x :=
      (Complex.continuousAt_ofReal_cpow_const x (-s - 1) (Or.inr hpos)).continuousWithinAt
    have hfn : p4_f1 s = (fun y : ℝ => (-s : ℂ) * (y : ℂ) ^ (-s - 1)) := by
      funext y
      rfl
    rw [hfn]
    exact hbase.const_smul (-s : ℂ)
  have hC1d : ContinuousOn (deriv (p4_f s)) S :=
    hC1.congr (p4_f1_on_Icc hs1 n m hn hnm)
  have hdiff2 : ∀ t ∈ Set.uIcc (n : ℝ) (m : ℝ), DifferentiableAt ℝ (deriv (p4_f s)) t := by
    intro t ht
    rw [uIcc_of_le hnmR] at ht
    exact (p4_f1_deriv_hasDerivAt hs1 hs2
      (lt_of_lt_of_le (Nat.cast_pos.mpr hn) ht.1)).differentiableAt
  have hC2 : ContinuousOn (p4_f2 s) S := by
    intro x hx
    have hpos : x ≠ 0 := (lt_of_lt_of_le (Nat.cast_pos.mpr hn) hx.1).ne'
    have hbase : ContinuousWithinAt (fun y : ℝ => (y : ℂ) ^ (-s - 2)) S x :=
      (Complex.continuousAt_ofReal_cpow_const x (-s - 2) (Or.inr hpos)).continuousWithinAt
    have hfn : p4_f2 s = (fun y : ℝ => (s * (s + 1) : ℂ) * (y : ℂ) ^ (-s - 2)) := by
      funext y
      rfl
    rw [hfn]
    exact hbase.const_smul (s * (s + 1) : ℂ)
  have hC2d : ContinuousOn (deriv (deriv (p4_f s))) S :=
    hC2.congr (p4_f2_on_Icc hs1 hs2 n m hn hnm)
  -- the finite second-order law itself, then make every term explicit
  have hem := em2_finite (p4_f s) n m hnm hdiff hC1d hdiff2 hC2d
  rw [hem]
  have hmn : (m : ℝ) ≠ 0 :=
    (lt_of_lt_of_le (Nat.cast_pos.mpr hn) (Nat.cast_le.mpr hnm)).ne'
  have hnn : (n : ℝ) ≠ 0 := (Nat.cast_pos.mpr hn).ne'
  have hIC : EqOn (fun x => algebraMap (R := ℝ) (A := ℂ) (B2 x) * deriv (deriv (p4_f s)) x)
      (fun x => algebraMap (R := ℝ) (A := ℂ) (B2 x) * p4_f2 s x) (Set.uIcc (n : ℝ) (m : ℝ)) := by
    intro x hx
    dsimp
    rw [uIcc_of_le hnmR] at hx
    rw [p4_f2_at hs1 hs2 (lt_of_lt_of_le (Nat.cast_pos.mpr hn) hx.1)]
  have hRem : (∫ x in (n : ℝ)..(m : ℝ), algebraMap (R := ℝ) (A := ℂ) (B2 x) * deriv (deriv (p4_f s)) x) =
      (∫ x in (n : ℝ)..(m : ℝ), algebraMap (R := ℝ) (A := ℂ) (B2 x) * p4_f2 s x) := by
    simpa using (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hIC)
  rw [p4_integral_closed s hs3 hn hnm,
    p4_f1_at hs1 (m : ℝ) hmn, p4_f1_at hs1 (n : ℝ) hnn,
    hRem]

  -- ==================================================================
  --  P4 atom L3: absolute convergence of the kernel, the M→∞ passage
  --  (module sketch §1, atom L3)
  --
  --  Goal: the B̂₂·f″ kernel of the finite 2nd-order EM law (L2) is
  --  absolutely integrable on (c, ∞) for c > 0 and ℜs > -1 (line:
  --  ℜs = ½), so the remainder integral of A(M, s) has a limit as
  --  M → ∞ — namely the improper tail integral — by the finite
  --  identity (L2), not by any series argument (the raw series
  --  diverges at σ = ½; spec §T1).
  --
  --  METHOD — borrowed from the PUBLISHED Gamma-function example
  --  (Mathlib/Analysis/SpecialFunctions/Gamma/Basic.lean:
  --  `Complex.GammaIntegral_convergent`, `tendsto_partialGamma` —
  --  same shape: a complex-power kernel on Ioi, integrability by
  --  `constructor` + aes + norm comparison, limit by
  --  `intervalIntegral_tendsto_integral_Ioi a hIntegrableOn tendsto_id`):
  --   * `IntegrableOn f (Ioi c)` unfolds to a pair on
  --     `volume.restrict (Ioi c)`; set integrals `∫ x in s, f x`
  --     are definitionally `∫ x, f x ∂ (volume.restrict s)` (mathlib
  --     docs, set-integral), so univariate lemmas such as
  --     `integral_smul` match set integrals directly.
  --   * kernel aes: `AEStronglyMeasurable.mul` — the B2 side from
  --     P4Tail's `fun_prop` aes + `Continuous.comp_aestronglyMeasurable`
  --     + `mono_measure` (aes descends to smaller measures);
  --     the f″ side from `ContinuousOn.aestronglyMeasurable`.
  --   * kernel finiteness: `HasFiniteIntegral.mono'` domination by
  --     (1/6)·‖s(s+1)‖·x^{−(ℜs+2)} (abs_B2_le + p4_f2_abs_eq), whose
  --     integrability is `integrableOn_Ioi_rpow_of_lt`.
  --   * limit: the verbatim Gamma idiom.
  --  Pinned mathlib 4.33.1 lemmas (checked in this checkout):
  --   * Complex.continuousAt_ofReal_cpow_const (Pow/Continuity.lean:365)
  --   * Complex.norm_cpow_eq_rpow_re_of_pos (Pow/Real.lean:337)
  --   * integrableOn_Ioi_rpow_of_lt (ImproperIntegrals.lean:130)
  --   * integral_Ioi_cpow_of_lt (ImproperIntegrals.lean:245)
  --   * intervalIntegral_tendsto_integral_Ioi (IntegralEqImproper.lean)
  --   * integral_smul (Bochner/Basic.lean:275, unconditional)
  --   * integral_congr_ae (Bochner/Basic.lean:299)
  --   * HasFiniteIntegral.mono' (L1Space/HasFiniteIntegral.lean:130)
  --   * hasFiniteIntegral_norm_iff (L1Space/HasFiniteIntegral.lean:273)
  --   * AEStronglyMeasurable.mul (AEStronglyMeasurable.lean:300),
  --     .mono_measure (:202), Continuous.comp_aestronglyMeasurable (:232),
  --     ContinuousOn.aestronglyMeasurable (IntegrableOn.lean:760)
  --   * ae_restrict_iff' (Measure/Restrict.lean:627),
  --     Filter.ae_of_all (OuterMeasure/AE.lean:94)
  --   * Measure.restrict_mono (Measure/Restrict.lean:87),
  --     Measure.restrict_univ (:245)
  --   * Complex.norm_def (Analysis/Complex/Norm.lean:29),
  --     Complex.normSq_ofReal (Data/Complex/Basic.lean),
  --     Real.sqrt_sq_eq_abs
  --  Kernel convention: the new L3 statements write the B̂₂ scalar in
  --  `Coe` form `(B2 x : ℂ)` (matches the aes machinery directly);
  --  L5 bridges to L2's `algebraMap` form by pointwise `rfl`
  --  (algebraMap ℝ ℂ = Coe ℝ ℂ = ofReal — L2 note above).

  --/ Atom L3.a — pointwise magnitude of the second-derivative kernel:
  --| ‖p4_f2 s x‖ = ‖s·(s+1)‖ · x^{−(ℜs + 2)}  (0 < x).
  --| At the line ℜs = ½ this is |f″(x)| = |s|·|s+1|·x^{−5/2}, a
  --| decreasing p-power (p = ℜs + 2 > 3) — the OP1/OP2 input of L4. -/
  theorem p4_f2_abs_eq {s : ℂ} {x : ℝ} (hx : 0 < x) :
      ‖p4_f2 s x‖ = ‖s * (s + 1)‖ * x ^ (-(s.re + 2)) := by
    dsimp only [p4_f2]
    rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos hx _]
    rw [show (-s - 2 : ℂ).re = -(s.re + 2) from by
      rw [show (-s - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
        Complex.neg_re, Complex.add_re, show (2 : ℂ).re = 2 from by norm_num]]

  --/ Atom L3.b — f″ is continuous on (0, ∞) (no hypothesis on s):
  --| the only possible kink of x ↦ (x : ℂ) ^ c is at 0. -/
  theorem p4_f2_continuousOn_Ioi {s : ℂ} : ContinuousOn (p4_f2 s) (Set.Ioi (0 : ℝ)) := by
    have hbase : ContinuousOn (fun (x : ℝ) => (x : ℂ) ^ (-s - 2)) (Set.Ioi (0 : ℝ)) := by
      intro x hx
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 2)
        (Or.inr (ne_of_gt hx))).continuousWithinAt
    have hConst : ContinuousOn (fun _ => (s * (s + 1) : ℂ)) (Set.Ioi (0 : ℝ)) := continuousOn_const
    have hprod : ContinuousOn (fun (x : ℝ) => (s * (s + 1)) * (x : ℂ) ^ (-s - 2)) (Set.Ioi (0 : ℝ)) :=
      hConst.mul hbase
    exact hprod.congr (fun x _ => by dsimp only [p4_f2])

  --/ Atom L3.c — absolute (Bochner) integrability of f″ on (c, ∞),
  --|  c > 0, under ℜs > -1. Comparison: ‖f″(x)‖ = ‖s(s+1)‖·x^{−(ℜs+2)}
  --|  (L3.a), a p-power with p = ℜs + 2 > 1 — exactly
  --|  `integrableOn_Ioi_rpow_of_lt`.  Gamma-style proof shape:
  --|  `constructor` + aes + `HasFiniteIntegral.mono'` norm domination. -/
  theorem p4_f2_integrableOn_Ioi {s : ℂ} (hsre : s.re > -1) {c : ℝ} (hc : 0 < c) :
      IntegrableOn (p4_f2 s) (Set.Ioi c) := by
    have hRpow : Integrable (fun x : ℝ => x ^ (-(s.re + 2))) (volume.restrict (Set.Ioi c)) :=
      (integrableOn_Ioi_rpow_of_lt (by linarith) hc).integrable
    have hMajor : HasFiniteIntegral (fun x : ℝ => ‖s * (s + 1)‖ * x ^ (-(s.re + 2)))
        (volume.restrict (Set.Ioi c)) :=
      Integrable.hasFiniteIntegral (hRpow.const_mul (‖s * (s + 1)‖ : ℝ))
    constructor
    · refine ContinuousOn.aestronglyMeasurable ?_ measurableSet_Ioi
      exact (p4_f2_continuousOn_Ioi).mono (Ioi_subset_Ioi_iff.mpr hc.le)
    · rw [← hasFiniteIntegral_norm_iff]
      exact HasFiniteIntegral.mono' hMajor (by
        rw [ae_restrict_iff' measurableSet_Ioi]
        exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx =>
          le_of_eq (by
            have h1 : ‖(‖p4_f2 s x‖ : ℝ)‖ = ‖p4_f2 s x‖ := by simp
            rw [h1, p4_f2_abs_eq (hc.trans hx)]))
      )

  --/ Atom L3.d — the closed value of the f″ tail (corollary of the pinned
  --|  `integral_Ioi_cpow_of_lt`; cross-check target of the P4Float gate):
  --|  ∫_{(c,∞)} p4_f2 s = s · c^{−s−1}   (ℜs > -1, c > 0; s+1 ≠ 0 follows). -/
  theorem p4_f2_integral_Ioi_eq {s : ℂ} (hsre : s.re > -1) {c : ℝ} (hc : 0 < c) :
      (∫ x : ℝ in Set.Ioi c, p4_f2 s x) = s * (c : ℂ) ^ (-s - 1) := by
    have hs1 : (s + 1 : ℂ) ≠ 0 := by
      intro h
      have hre : (s + 1 : ℂ).re = 0 := by rw [h]; simp
      rw [Complex.add_re, Complex.one_re] at hre
      linarith [hsre, hre]
    have ha : (-s - 2 : ℂ).re < -1 := by
      rw [show (-s - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
        Complex.neg_re, Complex.add_re, show (2 : ℂ).re = 2 from by norm_num]
      linarith
    have hNeg : -s - 1 ≠ 0 := by
      intro h
      rw [show (-s - 1 : ℂ) = -((s : ℂ) + 1) from by ring, neg_eq_zero] at h
      exact hs1 h
    have hEqForm : (∫ x : ℝ in Set.Ioi c, p4_f2 s x) =
        (∫ x : ℝ in Set.Ioi c, (s * (s + 1)) • (x : ℂ) ^ (-s - 2)) := by
      apply MeasureTheory.integral_congr_ae
      exact MeasureTheory.ae_of_all (μ := (volume.restrict (Set.Ioi c))) (fun x =>
        by
          dsimp only [p4_f2]
          rfl)
    rw [hEqForm]
    have hPull : (∫ x : ℝ in Set.Ioi c, (s * (s + 1)) • (x : ℂ) ^ (-s - 2)) =
        (s * (s + 1)) • (∫ x : ℝ in Set.Ioi c, (x : ℂ) ^ (-s - 2)) := by
      rw [MeasureTheory.integral_smul]
    rw [hPull, integral_Ioi_cpow_of_lt ha hc]
    rw [show (-s - 2 + 1 : ℂ) = -s - 1 from by ring]
    have hSm : (s * (s + 1)) • (-(c : ℂ) ^ (-s - 1) / (-s - 1)) =
        (s * (s + 1)) * (-(c : ℂ) ^ (-s - 1) / (-s - 1)) := rfl
    rw [hSm]
    have hFrac : (-(c : ℂ) ^ (-s - 1)) / (-s - 1) =
        (c : ℂ) ^ (-s - 1) / (s + 1) := by
      rw [show (-s - 1 : ℂ) = -((s : ℂ) + 1) from by ring]
      field_simp [hNeg, hs1]
    rw [hFrac]
    field_simp [hs1]

  --/ Atom L3.e — the star: the B̂₂·f″ kernel is absolutely integrable on
  --|  (c, ∞) (c > 0, ℜs > -1) — the M→∞-passage hypothesis of
  --|  `intervalIntegral_tendsto_integral_Ioi`.  Gamma-style proof shape:
  --|  aes = product of two aes functions (B2 side via P4Tail's `fun_prop`
  --|  aes + continuous ℝ→ℂ embedding + restriction monotonicity; f″ side
  --|  via L3.b); HasFiniteIntegral = `HasFiniteIntegral.mono'` domination
  --|  by (1/6)·‖s(s+1)‖·x^{−(ℜs+2)} (abs_B2_le + L3.a). -/
  theorem p4_kernel_integrableOn_Ioi {s : ℂ} (hsre : s.re > -1) {c : ℝ} (hc : 0 < c) :
      IntegrableOn (fun x => (B2 x : ℂ) * p4_f2 s x) (Set.Ioi c) := by
    have hB2aes : AEStronglyMeasurable (fun x => (B2 x : ℂ)) (volume.restrict (Set.Ioi c)) := by
      exact (AEStronglyMeasurable.mono_measure
        (Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)
          (aestronglyMeasurable_B2 : AEStronglyMeasurable B2))
        ((Measure.restrict_mono (Set.Ioi c).subset_univ le_rfl).trans (le_of_eq Measure.restrict_univ)))
    have hF2aes : AEStronglyMeasurable (p4_f2 s) (volume.restrict (Set.Ioi c)) :=
      ContinuousOn.aestronglyMeasurable
        ((p4_f2_continuousOn_Ioi).mono (Ioi_subset_Ioi_iff.mpr hc.le)) measurableSet_Ioi
    have hRpow : Integrable (fun x : ℝ => x ^ (-(s.re + 2))) (volume.restrict (Set.Ioi c)) :=
      (integrableOn_Ioi_rpow_of_lt (by linarith) hc).integrable
    have hMajor : HasFiniteIntegral
        (fun x : ℝ => (1 / 6) * (‖s * (s + 1)‖ * x ^ (-(s.re + 2))))
        (volume.restrict (Set.Ioi c)) :=
      Integrable.hasFiniteIntegral ((hRpow.const_mul (‖s * (s + 1)‖ : ℝ)).const_mul ((1 / 6) : ℝ))
    constructor
    · exact hB2aes.mul hF2aes
    · rw [← hasFiniteIntegral_norm_iff]
      exact HasFiniteIntegral.mono' hMajor (by
        rw [ae_restrict_iff' measurableSet_Ioi]
        exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx => by
          have hxpos : 0 < x := hc.trans hx
          have h1 : ‖(‖(B2 x : ℂ) * p4_f2 s x‖ : ℝ)‖ = ‖(B2 x : ℂ) * p4_f2 s x‖ := by simp
          rw [h1]
          calc ‖(B2 x : ℂ) * p4_f2 s x‖
              _ = ‖(B2 x : ℂ)‖ * ‖p4_f2 s x‖ := by rw [norm_mul]
              _ ≤ (1 / 6) * ‖p4_f2 s x‖ := by
                gcongr
                calc ‖(B2 x : ℂ)‖
                    _ = Real.sqrt (((B2 x : ℝ) ^ 2)) := by
                      rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
                    _ = |B2 x| := by rw [Real.sqrt_sq_eq_abs]
                    _ ≤ 1 / 6 := abs_B2_le hxpos.le
              _ ≤ (1 / 6) * (‖s * (s + 1)‖ * x ^ (-(s.re + 2))) := by
                gcongr
                exact le_of_eq (p4_f2_abs_eq hxpos)))

  --/ Atom L3.f — the M→∞ passage for the kernel (the verbatim Gamma
  --|  `tendsto_partialGamma` idiom): under L3.e,
  --|  `∫_n^M B̂₂·f″ → ∫_n^∞ B̂₂·f″` as M → ∞ (n ≥ 1). -/
  theorem p4_kernel_tendsto {s : ℂ} (hsre : s.re > -1) (n : ℕ) (hn : 0 < n) :
      Tendsto (fun M : ℝ => ∫ x in (n : ℝ)..M, (B2 x : ℂ) * p4_f2 s x)
          atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)) :=
    intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ))
      (p4_kernel_integrableOn_Ioi hsre (Nat.cast_pos.mpr hn)) tendsto_id

  --/ Atom L3.g — the M→∞ passage for the bare f″ integral, with closed
  --|  value (L3.d): `∫_n^M f″ → s·n^{−s−1}` — the limit of the A(M, s)
  --|  integral term. -/
  theorem p4_f2_tendsto {s : ℂ} (hsre : s.re > -1) (n : ℕ) (hn : 0 < n) :
      Tendsto (fun M : ℝ => ∫ x in (n : ℝ)..M, p4_f2 s x)
          atTop (𝓝 (s * (n : ℂ) ^ (-s - 1))) := by
    have hLim := intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ))
        (p4_f2_integrableOn_Ioi hsre (Nat.cast_pos.mpr hn)) tendsto_id
    rw [p4_f2_integral_Ioi_eq hsre (Nat.cast_pos.mpr hn)] at hLim
    exact hLim


  --/ ===== L4 — the OP family (spec sketch §6, post numeric refutation) =====
  --| L4.0: the B3 kernel + max |B3| = sqrt(3)/36.  L4.3: OP2c (complex
  --|  decaying exponential — the atom P4 uses).  L4.4: application to f''.
  --|  (L4.1 OP1 / L4.2 OP2 — the real valued monotone atoms — are the next
  --|  step; P4's critical path is L4.3/L4.4.)
  --| B3 mirrors the P4Tail.B2 local-kernel convention; mathlib's
  --| `bernoulliFun 3` (NumberTheory/ZetaValues) is the same polynomial —
  --|  cross-check only (P4 no-ζ-core convention).  Constants computed,
  --|  never recalled (/tmp/l4_b3max.py, /tmp/l4_check2.py, /tmp/ibp_check.py). -/

  --/ Atom L4.0a — the 3rd periodic Bernoulli function and its polynomial. -/
  def B3 (x : ℝ) : ℝ := (x - ⌊x⌋₊) ^ 3 - (3 / 2) * (x - ⌊x⌋₊) ^ 2 + (1 / 2) * (x - ⌊x⌋₊)

  def B3poly (u : ℝ) : ℝ := u ^ 3 - (3 / 2) * u ^ 2 + (1 / 2) * u

  --/ Atom L4.0b — endpoints (B₃(0) = B₃(1) = 0): the per-period IBP
  --|  boundary terms below vanish because of these. -/
  @[simp]
  lemma B3poly_at_0 : B3poly 0 = 0 := by dsimp only [B3poly]; norm_num

  @[simp]
  lemma B3poly_at_1 : B3poly 1 = 0 := by dsimp only [B3poly]; norm_num

  --/ Atom L4.0c — derivative: B₃'(u) = 3·(u²−u+1/6) (the B₃/3 primitive
  --|  of B₂; cross-checked against mathlib's `antideriv_bernoulliFun`). -/
  lemma B3poly_hasDerivAt (u : ℝ) :
      HasDerivAt B3poly (3 * (u ^ 2 - u + 1 / 6)) u := by
    -- (a) the polynomial is differentiable at u (explicit-lambda form:
    --     `dsimp` does not delta-unfold a bare def in 4.33.1)
    have hd : DifferentiableAt ℝ (fun u : ℝ => u ^ 3 - (3 / 2) * u ^ 2 + (1 / 2) * u) u := by
      fun_prop
    -- (b) the derivative value, by linearity of deriv
    have hId : DifferentiableAt ℝ (fun u : ℝ => u) u := (hasDerivAt_id' u).differentiableAt
    have h1 : DifferentiableAt ℝ ((fun u : ℝ => u) ^ 3) u := by
      fun_prop
    have h2sq : DifferentiableAt ℝ ((fun u : ℝ => u) ^ 2) u := by
      fun_prop
    have h2 : DifferentiableAt ℝ (fun u : ℝ => (3 / 2) * u ^ 2) u := by
      fun_prop
    have h3 : DifferentiableAt ℝ (fun u : ℝ => (1 / 2) * u) u := by
      fun_prop
    have h12 : DifferentiableAt ℝ (((fun u : ℝ => u) ^ 3) - (fun u : ℝ => (3 / 2) * u ^ 2)) u :=
      DifferentiableAt.sub h1 h2
    have hIdDer : deriv (fun u : ℝ => u) u = 1 := by
      rw [deriv_id'']
    have h2dF : (fun u : ℝ => (3 / 2) * u ^ 2) = (fun y : ℝ => (3 / 2) * (((fun y : ℝ => y) ^ 2) y)) := by
      funext y
      dsimp
    have h3dF : (fun u : ℝ => (1 / 2) * u) = (fun y : ℝ => (1 / 2) * ((fun y : ℝ => y) y)) := by
      funext y
      dsimp
    have h2deriv : deriv (fun u : ℝ => (3 / 2) * u ^ 2) u = (3 / 2) * (2 * u) := by
      rw [h2dF]
      rw [deriv_const_mul ((3 / 2 : ℝ)) h2sq, deriv_pow hId 2, hIdDer]
      ring
    have h3deriv : deriv (fun u : ℝ => (1 / 2) * u) u = 1 / 2 := by
      rw [h3dF]
      rw [deriv_const_mul ((1 / 2 : ℝ)) hId, hIdDer]
      ring
    have hder : deriv ((((fun u : ℝ => u) ^ 3) - (fun u : ℝ => (3 / 2) * u ^ 2)) +
        (fun u : ℝ => (1 / 2) * u)) u =
        3 * (u ^ 2 - u + 1 / 6) := by
      rw [deriv_add h12 h3, deriv_sub h1 h2, deriv_pow hId 3, h2deriv, h3deriv, hIdDer]
      ring
    -- (c) glue: HasDerivAt with the derivative value
    have hFin : HasDerivAt B3poly (deriv B3poly u) u := hd.hasDerivAt
    have hAddL : (fun u : ℝ => u ^ 3 - (3 / 2) * u ^ 2 + (1 / 2) * u) =
        (((fun u : ℝ => u) ^ 3) - (fun u : ℝ => (3 / 2) * u ^ 2)) + (fun u : ℝ => (1 / 2) * u) := by
      funext x
      dsimp
    have hDerivB3 : deriv B3poly u = 3 * (u ^ 2 - u + 1 / 6) := by
      rw [show deriv B3poly u =
               deriv (fun u : ℝ => u ^ 3 - (3 / 2) * u ^ 2 + (1 / 2) * u) u from rfl]
      rw [hAddL]
      exact hder
    rw [← hDerivB3]
    exact hFin

  --/ Atom L4.0d — the two extremal values (symbolic; /tmp/l4_b3max.py at
  --|  50 digits): B₃((3−√3)/6) = +√3/36, B₃((3+√3)/6) = −√3/36. -/
  lemma B3poly_max_val : B3poly ((3 - Real.sqrt 3) / 6) = Real.sqrt 3 / 36 := by
    dsimp only [B3poly]
    have hw : (Real.sqrt 3) ^ 2 = 3 := Real.sq_sqrt (by norm_num)
    have hU2 : ((3 - Real.sqrt 3) / 6) ^ 2 = (2 - Real.sqrt 3) / 6 := by
      field_simp [pow_two]
      nlinarith [hw]
    have hMid : ((3 - Real.sqrt 3) / 6) ^ 2 - (3 / 2) * ((3 - Real.sqrt 3) / 6) + 1 / 2 =
        (1 + Real.sqrt 3) / 12 := by
      rw [hU2]
      field_simp
      nlinarith [hw]
    have hFac : ((3 - Real.sqrt 3) / 6) ^ 3 - (3 / 2) * ((3 - Real.sqrt 3) / 6) ^ 2 +
          (1 / 2) * ((3 - Real.sqrt 3) / 6) =
        ((3 - Real.sqrt 3) / 6) * ((((3 - Real.sqrt 3) / 6) ^ 2 -
          (3 / 2) * ((3 - Real.sqrt 3) / 6) + 1 / 2)) := by
      ring
    rw [hFac, hMid]
    field_simp
    nlinarith [hw]

  lemma B3poly_min_val : B3poly ((3 + Real.sqrt 3) / 6) = -(Real.sqrt 3 / 36) := by
    dsimp only [B3poly]
    have hw : (Real.sqrt 3) ^ 2 = 3 := Real.sq_sqrt (by norm_num)
    have hU2 : ((3 + Real.sqrt 3) / 6) ^ 2 = (2 + Real.sqrt 3) / 6 := by
      field_simp [pow_two]
      nlinarith [hw]
    have hMid : ((3 + Real.sqrt 3) / 6) ^ 2 - (3 / 2) * ((3 + Real.sqrt 3) / 6) + 1 / 2 =
        (1 - Real.sqrt 3) / 12 := by
      rw [hU2]
      field_simp
      nlinarith [hw]
    have hFac : ((3 + Real.sqrt 3) / 6) ^ 3 - (3 / 2) * ((3 + Real.sqrt 3) / 6) ^ 2 +
          (1 / 2) * ((3 + Real.sqrt 3) / 6) =
        ((3 + Real.sqrt 3) / 6) * ((((3 + Real.sqrt 3) / 6) ^ 2 -
          (3 / 2) * ((3 + Real.sqrt 3) / 6) + 1 / 2)) := by
      ring
    rw [hFac, hMid]
    field_simp
    nlinarith [hw]

  --/ Atom L4.0e — **max |B₃| on [0,1] = √3/36** (the OP2c constant).
  --|  Proof: 3u²−3u+1/2 = 3(u−u₁)(u−u₂) with u₁ = (3−√3)/6 < u₂ =
  --|  (3+√3)/6; B₃ rises on [0,u₁], falls on [u₁,u₂], rises on [u₂,1];
  --|  |B₃| on [0,1] is attained at u₁ (max) or u₂ (min). -/
  theorem abs_B3poly_le (u : ℝ) (hu : u ∈ Set.Icc 0 1) :
      |B3poly u| ≤ Real.sqrt 3 / 36 := by
    set w := Real.sqrt 3 with hw_def
    set u1 := (3 - w) / 6 with hu1_def
    set u2 := (3 + w) / 6 with hu2_def
    have hw : w ^ 2 = 3 := Real.sq_sqrt (by norm_num)
    have hwnn : 0 ≤ w := Real.sqrt_nonneg 3
    have h0u1 : 0 < u1 := by nlinarith [hw, hwnn]
    have hu1u2 : u1 < u2 := by nlinarith [hw, hwnn]
    have hu21 : u2 < 1 := by nlinarith [hw, hwnn]
    have h0u2 : 0 < u2 := by nlinarith [hw, hwnn]
    have hFact : ∀ t : ℝ, 3 * t ^ 2 - 3 * t + 1 / 2 = 3 * (t - u1) * (t - u2) := by
      intro t
      have hsum : u1 + u2 = 1 := by nlinarith [hw, hwnn]
      have hprod : u1 * u2 = 1 / 6 := by nlinarith [hw, hwnn]
      have h1 : (t - u1) * (t - u2) = t ^ 2 - (u1 + u2) * t + u1 * u2 := by ring
      calc 3 * t ^ 2 - 3 * t + 1 / 2
          _ = 3 * (t ^ 2 - t + 1 / 6) := by ring
          _ = 3 * (t ^ 2 - (u1 + u2) * t + u1 * u2) := by rw [hsum, hprod]; ring
          _ = 3 * ((t - u1) * (t - u2)) := by rw [← h1]
          _ = 3 * (t - u1) * (t - u2) := by ring
    -- deriv B3poly x = 3x² − 3x + 1/2 (from B3poly_hasDerivAt via HasDerivAt.deriv)
    have hDeriv : ∀ x : ℝ, deriv B3poly x = 3 * x ^ 2 - 3 * x + 1 / 2 := by
      intro x
      rw [HasDerivAt.deriv (B3poly_hasDerivAt x)]
      ring
    have hCont (t : Set ℝ) : ContinuousOn B3poly t := by
      intro x _
      have hc : Continuous fun u : ℝ => u ^ 3 - (3 / 2) * u ^ 2 + (1 / 2) * u := by
        continuity
      exact hc.continuousWithinAt
    have hDiff (t : Set ℝ) : DifferentiableOn ℝ B3poly t :=
      fun x _ => (B3poly_hasDerivAt x).differentiableAt.differentiableWithinAt
    have hMax : B3poly u1 = Real.sqrt 3 / 36 := by simpa [hw_def] using B3poly_max_val
    have hMin : B3poly u2 = -(Real.sqrt 3 / 36) := by simpa [hw_def] using B3poly_min_val
    by_cases hL : u ≤ u1
    · -- u ∈ [0, u1]: B3poly nondecreasing (deriv ≥ 0 on (0, u1))
      have hmono : MonotoneOn B3poly (Set.Icc 0 u1) :=
        monotoneOn_of_deriv_nonneg (convex_Icc (0 : ℝ) u1) (hCont (Set.Icc 0 u1))
          (hDiff (interior (Set.Icc 0 u1))) (fun x hx => by
            have hIo : x ∈ Set.Ioo 0 u1 := by
              simpa [interior_Icc] using hx
            rw [hDeriv x, hFact x]
            nlinarith [h0u1, hIo.1, hIo.2, hu1u2])
      have hA : B3poly 0 ≤ B3poly u :=
        hmono ⟨le_rfl, h0u1.le⟩ ⟨hu.1, hL⟩ hu.1
      have hpos : 0 ≤ B3poly u := by simpa [B3poly_at_0] using hA
      have hB : B3poly u ≤ B3poly u1 :=
        hmono ⟨hu.1, hL⟩ ⟨h0u1.le, le_rfl⟩ hL
      rw [abs_of_nonneg hpos]
      nlinarith [hB, hMax]
    · push_neg at hL
      by_cases hR : u ≥ u2
      · -- u ∈ [u2, 1]: B3poly nondecreasing (deriv ≥ 0 on (u2, 1))
        have hmono : MonotoneOn B3poly (Set.Icc u2 1) :=
          monotoneOn_of_deriv_nonneg (convex_Icc u2 1) (hCont (Set.Icc u2 1))
            (hDiff (interior (Set.Icc u2 1))) (fun x hx => by
              have hIo : x ∈ Set.Ioo u2 1 := by
                simpa [interior_Icc] using hx
              rw [hDeriv x, hFact x]
              nlinarith [h0u1, hIo.1, hIo.2, hu1u2])
        have hA : B3poly u2 ≤ B3poly u :=
          hmono ⟨le_rfl, hu21.le⟩ ⟨hR, hu.2⟩ hR
        have hneg : B3poly u ≤ 0 := by
          have hB : B3poly u ≤ B3poly 1 :=
            hmono ⟨hR, hu.2⟩ ⟨hu21.le, le_rfl⟩ hu.2
          simpa [B3poly_at_1] using hB
        rw [abs_of_nonpos hneg]
        nlinarith [hA, hMin]
      · -- u₁ < u < u₂: B3poly nonincreasing (deriv ≤ 0 on (u1, u2))
        push_neg at hR
        have hanti : AntitoneOn B3poly (Set.Icc u1 u2) :=
          antitoneOn_of_deriv_nonpos (convex_Icc u1 u2) (hCont (Set.Icc u1 u2))
            (hDiff (interior (Set.Icc u1 u2))) (fun x hx => by
              have hIo : x ∈ Set.Ioo u1 u2 := by
                simpa [interior_Icc] using hx
              rw [hDeriv x, hFact x]
              nlinarith [hIo.1, hIo.2])
        have hA : B3poly u2 ≤ B3poly u :=
          hanti ⟨le_of_lt hL, hR.le⟩ ⟨hu1u2.le, le_rfl⟩ hR.le
        have hB : B3poly u ≤ B3poly u1 :=
          hanti ⟨le_rfl, hu1u2.le⟩ ⟨le_of_lt hL, hR.le⟩ (le_of_lt hL)
        rw [abs_le]
        constructor
        · nlinarith [hA, hMin]
        · nlinarith [hB, hMax]

  --/ Atom L4.3 — **OP2c (complex decaying exponential — the atom P4 uses)**:
  --|  for Re s = 1/2, n ≥ 1:
  --|    |∫_n^∞ B̂₂(x)·(x:ℂ)^{−s−2} dx| ≤ (√3/270)·‖s+2‖·n^{−5/2}.
  --|  Proof per the spec: per-period IBP (lemma-u := (x:ℂ)^{−s−2},
  --|  lemma-v := B₃(x−k)/3 with v' = B̂₂ on [k,k+1], u' =
  --|  (−s−2)(x:ℂ)^{−s−3}); boundary terms vanish (B₃(0) = B₃(1) = 0);
  --|  |B₃poly| ≤ √3/36; the per-period x^{-7/2} integrals reassemble into
  --|  ∫_n^N ≤ (2/5)n^{−5/2} (FTC with antiderivative −(2/5)x^{-5/2});
  --|  then the L3 M→∞ passage (L3 pattern) + a bounded-limit argument.
  --|  IBP sign verified numerically (/tmp/ibp_check.py). -/
  theorem p4_op2c_bound {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2)‖
          ≤ Real.sqrt 3 / 270 * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) := by
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
            ≤ (∫ x in (k : ℝ)..(k + 1 : ℝ), Real.sqrt 3 / 36 * (x ^ (-7 / 2 : ℝ))) := by
      apply intervalIntegral.norm_integral_le_of_norm_le
        (g := fun x : ℝ => Real.sqrt 3 / 36 * (x ^ (-7 / 2 : ℝ)))
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
              _ = Real.sqrt 3 / 36 * (t ^ (-7 / 2 : ℝ)) := by
                rw [show (-(s.re + 3) : ℝ) = (-7 / 2 : ℝ) from by
                  rw [hsre]
                  norm_num])
      · have hco : ContinuousOn (fun x : ℝ => x ^ (-7 / 2 : ℝ))
              (Set.uIcc (k : ℝ) (k + 1 : ℝ)) := by
          intro x hx
          exact (continuousAt_rpow_const x (-7 / 2)
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
            Real.sqrt 3 / 270 * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) := by
      have hper2 (k : ℕ) (hk : n ≤ k) :
          ‖∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ ≤
              Real.sqrt 3 / 108 * ‖s + 2‖ * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ)) := by
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
                (Real.sqrt 3 / 36 * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ))) := by
              gcongr
              simpa using hper k hk
            _ = Real.sqrt 3 / 108 * ‖s + 2‖ *
                (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ)) := by
              ring
      calc ‖∫ x in (n : ℝ)..(N : ℝ), f x‖
          _ = ‖∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ := by
            rw [hSum N hN]
          _ ≤ ∑ k ∈ Finset.Ico n N, ‖∫ x in (k : ℝ)..(k + 1 : ℝ), f x‖ :=
            norm_sum_le (Finset.Ico n N) (fun k : ℕ => ∫ x in (k : ℝ)..(k + 1 : ℝ), f x)
          _ ≤ ∑ k ∈ Finset.Ico n N,
                (Real.sqrt 3 / 108 * ‖s + 2‖ * (∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ))) := by
            apply Finset.sum_le_sum
            intro k hk
            simpa using hper2 k (Finset.mem_Ico.mp hk |>.1)
          _ = (Real.sqrt 3 / 108 * ‖s + 2‖) * (∫ x in (n : ℝ)..(N : ℝ), x ^ (-7 / 2 : ℝ)) := by
            rw [← Finset.mul_sum (Finset.Ico n N)
              (fun k : ℕ => ∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ))
              (Real.sqrt 3 / 108 * ‖s + 2‖)]
            rw [show ∫ x in (n : ℝ)..(N : ℝ), x ^ (-7 / 2 : ℝ) =
                  ∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..(k + 1 : ℝ), x ^ (-7 / 2 : ℝ) from by
              have hS : (∫ x in (n : ℝ)..(N : ℝ), x ^ (-7 / 2 : ℝ)) =
                  (∑ k ∈ Finset.Ico n N, ∫ x in (k : ℝ)..((k + 1 : ℕ) : ℝ), x ^ (-7 / 2 : ℝ)) :=
                (sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ)) hN
                  (fun k hk => by
                    have hco0 : ContinuousOn (fun x : ℝ => x ^ (-7 / 2 : ℝ))
                        (Set.Icc (k : ℝ) (k + 1 : ℝ)) := by
                      intro x hx
                      have hxpos : 0 < x := by nlinarith [hx.1,
                      (Nat.cast_le (α := ℝ)).mpr (Set.mem_Ico.mp hk |>.1),
                      (Nat.cast_pos (α := ℝ)).mpr hn]
                      exact (continuousAt_rpow_const x (-7 / 2) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
                    have hco : ContinuousOn (fun x : ℝ => x ^ (-7 / 2 : ℝ))
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
          _ ≤ (Real.sqrt 3 / 108 * ‖s + 2‖) * ((2 / 5) * (n : ℝ) ^ (-5 / 2 : ℝ)) := by
            gcongr
            -- ∫_n^N x^{−7/2} = (2/5)·(n^{−5/2} − N^{−5/2}) ≤ (2/5)·n^{−5/2}
            have hFTC : (∫ x in (n : ℝ)..(N : ℝ), x ^ (-7 / 2 : ℝ)) =
                (-(2 / 5)) * ((N : ℝ) ^ (-5 / 2 : ℝ) - (n : ℝ) ^ (-5 / 2 : ℝ)) := by
              have hDeriv : ∀ x ∈ Set.Ioo (n : ℝ) (N : ℝ),
                  HasDerivAt (fun x : ℝ => (-(2 / 5)) * (x ^ (-5 / 2 : ℝ))) (x ^ (-7 / 2 : ℝ)) x := by
                intro x hx
                have hxpos : 0 < x := by nlinarith [hx.1, (Nat.cast_pos (α := ℝ)).mpr hn]
                have hrp : HasDerivAt (fun x : ℝ => x ^ (-5 / 2 : ℝ))
                    (((-5 / 2) : ℝ) * (x ^ (((-5 / 2) : ℝ) - 1))) x :=
                  hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos))
                have hm : HasDerivAt (fun x : ℝ => (-(2 / 5)) * (x ^ (-5 / 2 : ℝ)))
                    (-(2 / 5) * (((-5 / 2) : ℝ) * (x ^ ((-5 / 2 : ℝ) - 1)))) x :=
                  HasDerivAt.const_mul (c := (-(2 / 5) : ℝ)) hrp
                have hd : (-(2 / 5)) * (((-5 / 2) : ℝ) * (x ^ ((-5 / 2 : ℝ) - 1))) =
                    x ^ (-7 / 2 : ℝ) := by
                  rw [show (((-5 / 2) : ℝ) - 1) = (-7 / 2 : ℝ) from by norm_num]
                  ring
                simpa [hd] using hm
              have hCont : ContinuousOn (fun x : ℝ => (-(2 / 5)) * (x ^ (-5 / 2 : ℝ)))
                  (Set.Icc (n : ℝ) (N : ℝ)) := by
                have hR : ContinuousOn (fun x : ℝ => x ^ (-5 / 2 : ℝ))
                    (Set.Icc (n : ℝ) (N : ℝ)) := by
                  intro x hx
                  have hxpos : 0 < x := by nlinarith [hx.1, (Nat.cast_pos (α := ℝ)).mpr hn]
                  exact (continuousAt_rpow_const x (-5 / 2) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
                have hc : ContinuousOn (fun _ : ℝ => (-(2 / 5) : ℝ) : ℝ → ℝ)
                    (Set.Icc (n : ℝ) (N : ℝ)) := continuousOn_const
                exact hc.mul hR
              have hIntg : IntervalIntegrable (fun x : ℝ => x ^ (-7 / 2 : ℝ))
                  volume (n : ℝ) (N : ℝ) := by
                have hco : ContinuousOn (fun x : ℝ => x ^ (-7 / 2 : ℝ))
                    (Set.uIcc (n : ℝ) (N : ℝ)) := by
                  intro x hx
                  have hxpos : 0 < x := by
                    calc 0 < (n : ℝ) := (Nat.cast_pos (α := ℝ)).mpr hn
                      _ = min (n : ℝ) (N : ℝ) := (min_eq_left ((Nat.cast_le (α := ℝ)).mpr hN)).symm
                      _ ≤ x := hx.1
                  exact (continuousAt_rpow_const x (-7 / 2) (Or.inl (ne_of_gt hxpos))).continuousWithinAt
                exact hco.intervalIntegrable
              have hH := integral_eq_sub_of_hasDerivAt_of_le ((Nat.cast_le (α := ℝ)).mpr hN) hCont hDeriv hIntg
              simpa [show ((-(2 / 5) : ℝ)) * ((N : ℝ) ^ (-5 / 2 : ℝ) - (n : ℝ) ^ (-5 / 2 : ℝ)) =
                  (-(2 / 5) : ℝ) * (N : ℝ) ^ (-5 / 2 : ℝ) + (2 / 5) * (n : ℝ) ^ (-5 / 2 : ℝ) from by ring] using hH
            rw [hFTC]
            nlinarith [show 0 ≤ (N : ℝ) ^ (-5 / 2 : ℝ) from by
              apply Real.rpow_nonneg
              norm_num]
          _ = Real.sqrt 3 / 270 * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) := by
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
    set C := Real.sqrt 3 / 270 * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) with hCdef
    have hBoundSeq : ∀ᶠ (N : ℕ) in atTop, ‖∫ x in (n : ℝ)..(N : ℝ), f x‖ ≤ C := by
      filter_upwards [eventually_ge_atTop n] with N hN
      exact hBoundN N hN
    -- the eventual bound passes to the limit (mathlib `le_of_tendsto`)
    have hLbound : ‖L‖ ≤ C := le_of_tendsto hNorm hBoundSeq
    simpa [f] using hLbound

  --/ Atom L4.4 — application to f'' (the bridge from L5 to L4.3): for
  --|  Re s = 1/2, n ≥ 1,
  --|    ‖∫_n^∞ B̂₂(x)·f″(x) dx‖ ≤ (√3/270)·‖s(s+1)‖·‖s+2‖·n^{−5/2}
  --|  (f″ = s(s+1)·(x:ℂ)^{−s−2}: scalar factor out of the integral,
  --|  then L4.3 + norm_mul).  Note: this checkout's ℂ has no `Abs`
  --|  instance — complex absolute value is the norm ‖·‖. -/
  theorem p4_f2_tail_bound {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x‖
          ≤ Real.sqrt 3 / 270 * ‖s * (s + 1)‖ * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) := by
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
    have hRHS : Real.sqrt 3 / 270 * ‖s * (s + 1)‖ * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ) =
        ‖s * (s + 1)‖ * (Real.sqrt 3 / 270 * ‖s + 2‖ * (n : ℝ) ^ (-5 / 2 : ℝ)) := by ring
    rw [hRHS]
    apply mul_le_mul_of_nonneg_left
    · simpa [f] using (p4_op2c_bound hsre n hn)
    · exact norm_nonneg (s * (s + 1))

end
