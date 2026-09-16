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

STATUS (2026-09-15, Lean 4.33.1): atoms L1, L2, L3, L4, L5.a-e GREEN.  L4 is the missing-tail law (IBP route: `p4_op2c_bound` + `p4_f2_tail_bound`); L5 is the composition root: `p4_Tn_Tendsto` (L5.a, the M-to-infinity limit of the tail partial sums), `p4_zeta_split` (L5.b), `p4_Tn_eq` (L5.c, the tsum passage to `p4_Tn_lim`), `p4_identity` (L5.d, the P4 line-statement for Re s > 1) and `p4_T4_bound` (L5.e, the bound on `p4_em_expr` at Re s = 1/2; the W_n-equality at Re s = 1/2 is cited, DLMF 25.2.8 / Apostol 12.21 - see section doc) and L5.f (`p4_one_minus_s_conj`, `p4_T4_ratio`) the T4 ratio corollary - the correction scale |1-s| = |s| on the critical line and the three-term ratio bound, pure division algebra from L5.e.  No sorry.
STATUS (2026-09-16, Lean 4.33.1): 25ae Stage 3A GREEN - periodic `B8` (def + measurability + `B8_of_Icc_int` + `abs_B8_le` via the pure-algebra `B8poly_bound_Icc`), the finite telescoping lemma `p4_25ae_telescope_pow` (own induction; no Ico-telescope in mathlib 4.33.1), and `p4_25ae_J_finite` (the finite-M identity for the EM tail integral: the 7-level per-period IBP ladder over period sums S3-S8, endpoint differences at n and M with the verbatim Stage-2 coefficient atoms, and the B8 period-sum residue S8).  Full package build: 17434 jobs, 0 errors, 0 sorry.
STATUS (2026-09-16, Lean 4.33.1): 25ae Stage 3B atoms 3B.1-3B.10 GREEN - `p4_25ae_J_iota` (M -> oo passage), `p4_25ae_int_Icc_rpow172`/`_Ioi_rpow172` (FTC-2), `p4_25ae_I8_bound` (|I8| <= n^(-15/2)/225), `p4_25ae_t3kernel_integrableOn_Ioi`, `p4_25ae_J_eq` (the EM tail equals the exact 4-term expression), and `p4_25ae_T3_bound` (the sharpened 4-term triangle bound with the CORRECTED exponents: n^(-7/2), n^(-11/2), n^(-15/2), n^(-15/2) - the anchor F1 script's n^(-9/2) second-term exponent was WRONG: on the critical line Re(-s-5) = -11/2).  The 25ae wall re-anchors to t ~= 1.217e8 at list scale; see DISCOVERY_LOG 25ae Stage 3B.
STATUS (2026-09-16, Lean 4.33.1): 25ae Stage 3B.11 Part A GREEN - the list-scale wall for 1 <= t <= 13 (four bands `t3w_wall_A1`-`A4`: T3UB < 35/78, 35/234, 35/312, 35/390 via endpoint sqrt-constants `t3w_qB_r` (strict isqrt rational upper bounds of `sqrt(t3w_prod t* r)`) and `n^{-p}`-constants `t3w_rB_r`; term indices {2,4,6,7} match the four `p4_25ae_T3_bound` terms; all comparisons close by norm_num; constants: scripts/rh/day026_25ae_t3wall.py).  Part B (13 <= t <= 1e8, log-derivative method) is the next batch.
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


/-! P4Limit · L5 — the composition root (P4 statement + T4 corollary).

STATUS: L5.a-L5.e GREEN (`p4_Tn_Tendsto`, `p4_zeta_split`, `p4_Tn_eq`, `p4_identity`, `p4_T4_bound`, `p4_one_minus_s_conj`, `p4_T4_ratio`) - ALL GREEN.  The W_n-equality at Re s = 1/2 remains CITED (DLMF 25.2.8 / Apostol 12.21); the bound `p4_T4_bound` on the EM expression itself is machine-proven.

The P4 statement, composed from the GREEN atoms L1–L4 + the pinned mathlib
tsum layer (all names `#print`-verified 2026-09-13; module sketch §7):

  P4-id (Re s > 1, machine-lean):
    riemannZeta s − P_n s + I(n,s)
        = −½·(n:ℂ)^{−s} + (s/12)·(n:ℂ)^{−s−1}
          − ½·s·(s+1)·∫_n^∞ B̂₂({x})·(x:ℂ)^{−s−2} dx
    where P_n s := ∑_{k < n} 1/((k+1):ℂ)^s, I(n,s) := (n:ℂ)^{1−s}/(1−s).
  P4-bnd (Re s = ½, machine-lean, for the EM expression; the W_n-equality
    at Re s = ½ is [CITED: DLMF 25.2.8 / Apostol Thm 12.21 — analytic
    continuation of the EM tail identity; numerically verified day-017] = T4.
-/

variable {α : Type*}

-- The P4 tail objects (stated for ALL s — the identity holds Re s > 1, the
-- bound holds Re s = ½; see atom docstrings).
def p4_P (n : ℕ) (s : ℂ) : ℂ := ∑ k ∈ Finset.range n, (1 : ℂ) / ((k + 1) : ℂ) ^ s

/-- First-order tail constant `I(n,s) := n^{1−s}/(1−s)` (the P4 anchor;
    the sign correction of spec p4-tail-law §0.5: W_n := ζ − P_n + I). -/
def p4_I (n : ℕ) (s : ℂ) : ℂ := (n : ℂ) ^ (-s + 1) / (1 - s)

/-- Atom L5.0 — `p4_f1` is continuous off 0 (the missing half of the L1
    smoothness pair; L3 already has this for `p4_f2`). -/
theorem p4_f1_continuousOn_Ioi {s : ℂ} : ContinuousOn (p4_f1 s) (Set.Ioi (0 : ℝ)) := by
  have hbase : ContinuousOn (fun (x : ℝ) => (x : ℂ) ^ (-s - 1)) (Set.Ioi (0 : ℝ)) := by
    intro x hx
    exact (Complex.continuousAt_ofReal_cpow_const x (-s - 1)
      (Or.inr (ne_of_gt hx))).continuousWithinAt
  have hConst : ContinuousOn (fun _ => (-s : ℂ)) (Set.Ioi (0 : ℝ)) := continuousOn_const
  have hprod : ContinuousOn (fun (x : ℝ) => -s * (x : ℂ) ^ (-s - 1)) (Set.Ioi (0 : ℝ)) :=
    hConst.mul hbase
  exact hprod.congr (fun x _ => by dsimp only [p4_f1])

/-- Atom L5.0b — pointwise neighborhood transfer (L1.c idiom):
    `deriv (deriv (p4_f s))` is continuous within `Ioi 0` (it equals `p4_f2 s`,
    which is differentiable (hence continuous) at every 0 < x, on a
    neighborhood of `x`). -/
theorem p4_f2_deriv_continuousWithinAt_Ioi {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1)
    (hs3 : s ≠ -2) {x : ℝ} (hxpos : 0 < x) :
    ContinuousWithinAt (deriv (deriv (p4_f s))) (Set.Ioi (0 : ℝ)) x := by
  have hL : deriv (deriv (p4_f s)) =ᶠ[𝓝 x] (p4_f2 s) := by
    filter_upwards [isOpen_Ioi.mem_nhds hxpos] with u hu
    exact p4_f2_at hs1 hs2 (by simpa using hu)
  have hCA : ContinuousAt (p4_f2 s) x :=
    (p4_f2_hasDerivAt hs1 hs2 hs3 x (ne_of_gt hxpos)).continuousAt
  exact (continuousAt_congr hL).mpr hCA |>.continuousWithinAt

/-- `p4_Tn_lim s n` — closed form of the tail partial-sum limit (Re s > 1):
    −n^{1−s}/(1−s) − ½ n^{−s} + (s/12) n^{−s−1} − ½ s(s+1) ∫_n^∞ B̂₂ x^{−s−2}. -/
noncomputable def p4_Tn_lim (s : ℂ) (n : ℕ) : ℂ :=
    -(((n : ℝ) : ℂ) ^ (-s + 1) / (1 - s)) -
      ((1 / 2) : ℂ) * ((n : ℝ) : ℂ) ^ (-s) +
      ((1 / 12) : ℂ) * (s * ((n : ℝ) : ℂ) ^ (-s - 1)) -
      ((1 / 2) : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)

/-- The EM tail expression (DLMF 25.2.8 form, kernel = f″ with
    f = p4_f = (·:ℝ:ℂ)^{-s}: f″ = p4_f2 = s(s+1)·(·)^{-s-2};
    all terms defined for every s ≠ 1 by the underlying objects; used at
    Re s = ½ for the P4 bound, where its equality with
    `riemannZeta s − p4_P n s + p4_I n s` is CITED — DLMF 25.2.8 /
    Apostol Thm 12.21; at Re s > 1 this equality is `p4_identity` (LEAN);
    the factored form s(s+1)·∫ B̂₂·x^{-s-2} is machine-equal via
    integral_const_mul — the kernel form is used so the L5.d assembly is
    a ring-level cancellation). -/
noncomputable def p4_em_expr (s : ℂ) (n : ℕ) : ℂ :=
    -((1 / 2) : ℂ) * (n : ℂ) ^ (-s) +
      ((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1)) -
      ((1 / 2) : ℂ) *
        (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)

/-- Atom L5.a — the tail partial sums (Re s > 1) converge to `p4_Tn_lim`. -/
theorem p4_Tn_Tendsto {s : ℂ} (hsσ : 1 < s.re) (n : ℕ) (hn : 0 < n) :
    Tendsto (fun m : ℕ => ∑ k ∈ Finset.Ioc n m, (k : ℂ) ^ (-s))
        atTop (nhds (p4_Tn_lim s n)) := by
  set f := p4_f s with hf
  set f2 := p4_f2 s with hf2
  have hs0 : s ≠ 0 := by
    intro h0
    have hre : (s : ℂ).re = 0 := by simpa [h0]
    linarith [hsσ]
  have hs1 : s ≠ 1 := by
    intro h1
    have hre : (s : ℂ).re = 1 := by simpa [h1]
    linarith [hsσ]
  have hs1n : s ≠ -1 := by
    intro h1
    have hre : (s : ℂ).re = -1 := by simpa [h1]
    linarith [hsσ]
  have hs2 : s ≠ -2 := by
    intro h2
    have hre : (s : ℂ).re = -2 := by simpa [h2]
    linarith [hsσ]
  have hsre2 : s.re > -1 := by
    linarith [hsσ]
  have hnpos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  -- Smoothness of f on every Icc n m (m ≥ n ≥ 1 > 0).
  have hdiff (m : ℕ) (hnm : n ≤ m) (t : ℝ) (ht : t ∈ Set.Icc (n : ℝ) (m : ℝ)) :
      DifferentiableAt ℝ f t := by
    have hpos : 0 < t := lt_of_lt_of_le hnpos ht.1
    exact (p4_f_hasDerivAt hs0 t (ne_of_gt hpos)).differentiableAt
  have hfdiff (m : ℕ) (hnm : n ≤ m) (t : ℝ) (ht : t ∈ Set.uIcc (n : ℝ) (m : ℝ)) :
      DifferentiableAt ℝ (deriv f) t := by
    have hmacR : min (n : ℝ) (m : ℝ) = n := min_eq_left (Nat.cast_le.mpr hnm)
    have hpos : 0 < t := lt_of_lt_of_le hnpos (hmacR ▸ ht.1)
    dsimp only [f]
    exact (p4_f1_deriv_hasDerivAt hs0 hs1n hpos).differentiableAt
  have hcont' (m : ℕ) (hnm : n ≤ m) : ContinuousOn (deriv f) (Set.Icc (n : ℝ) (m : ℝ)) := by
    dsimp only [f]
    intro x hx
    have hpos : 0 < x := lt_of_lt_of_le hnpos hx.1
    exact (p4_f1_deriv_hasDerivAt hs0 hs1n hpos).continuousAt.continuousWithinAt
  have hcont'' (m : ℕ) (hnm : n ≤ m) :
      ContinuousOn (deriv (deriv f)) (Set.Icc (n : ℝ) (m : ℝ)) := by
    dsimp only [f]
    intro x hx
    have hpos : 0 < x := lt_of_lt_of_le hnpos hx.1
    have hsub : Set.Icc (n : ℝ) (m : ℝ) ⊆ Set.Ioi (0 : ℝ) := by
      intro u hu
      exact Set.mem_Ioi.mpr (lt_of_lt_of_le hnpos hu.1)
    exact ContinuousWithinAt.mono (p4_f2_deriv_continuousWithinAt_Ioi hs0 hs1n hs2 hpos) hsub
  -- Pointwise: m ≥ n → ∑_{Ioc n m} (k:ℂ)^{−s} = the closed EM expression.
  have hFin (m : ℕ) (hnm : n ≤ m) :
      (∑ k ∈ Finset.Ioc n m, (k : ℂ) ^ (-s)) =
        (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) +
        ((1 / 2) : ℂ) * (f (m : ℝ) - f (n : ℝ)) +
        ((1 / 12) : ℂ) * (p4_f1 s (m : ℝ) - p4_f1 s (n : ℝ)) -
        ((1 / 2) : ℂ) * (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x) := by
    have hnmR : (n : ℝ) ≤ (m : ℝ) := Nat.cast_le.mpr hnm
    have hEm := em2_finite f n m hnm (hdiff m hnm) (hcont' m hnm) (hfdiff m hnm) (hcont'' m hnm)
    -- (1) the LHS sum: f (k:ℝ) = (k:ℂ)^{−s} up to natCast.
    have hSum : (∑ k ∈ Finset.Ioc n m, f ↑k) = (∑ k ∈ Finset.Ioc n m, (k : ℂ) ^ (-s)) := by
      apply Finset.sum_congr rfl (fun k _ => by
        dsimp only [f]
        norm_cast)
    -- (2) first integral → antiderivative (L2 atom).
    have hInt1 : (∫ x : ℝ in (n : ℝ)..(m : ℝ), f x) = (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) := by
      dsimp only [f]
      exact p4_integral_closed s hs1 hn hnm
    -- (3) endpoint derivatives → p4_f1 (L1 atom).
    have hDerM : deriv f (m : ℝ) = p4_f1 s (m : ℝ) := by
      dsimp only [f]
      exact p4_f1_on_Icc hs0 n m hn hnm (m : ℝ) ⟨hnmR, le_rfl⟩
    have hDerN : deriv f (n : ℝ) = p4_f1 s (n : ℝ) := by
      dsimp only [f]
      exact p4_f1_on_Icc hs0 n m hn hnm (n : ℝ) ⟨le_rfl, hnmR⟩
    -- (4) kernel integrand: deriv (deriv f) = p4_f2 on uIcc (L1.e2, L4 bridge).
    have hKer : (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * deriv (deriv f) x) =
        (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x) := by
      dsimp only [f]
      have hEqU : EqOn (fun x : ℝ => (B2 x : ℂ) * deriv (deriv (p4_f s)) x)
          (fun x : ℝ => (B2 x : ℂ) * f2 x) (Set.uIcc (n : ℝ) (m : ℝ)) := by
        intro x hx
        have hmin : min (n : ℝ) (m : ℝ) = n := min_eq_left hnmR
        have hpos : 0 < x := lt_of_lt_of_le hnpos (hmin ▸ hx.1)
        dsimp only
        rw [p4_f2_at hs0 hs1n hpos, hf2]
      exact intervalIntegral.integral_congr (μ := MeasureTheory.volume) hEqU
    calc (∑ k ∈ Finset.Ioc n m, (k : ℂ) ^ (-s))
        _ = (∑ k ∈ Finset.Ioc n m, f ↑k) := hSum.symm
        _ = (∫ x : ℝ in (n : ℝ)..(m : ℝ), f x) +
            ((1 / 2) : ℂ) * (f (m : ℝ) - f (n : ℝ)) +
            ((1 / 12) : ℂ) * (deriv f (m : ℝ) - deriv f (n : ℝ)) -
            ((1 / 2) : ℂ) * (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * deriv (deriv f) x) := hEm
        _ = _ := by
          rw [hInt1, hDerM, hDerN, hKer]
  -- Decay of the three endpoint powers (Re < 0).
  -- === decay + assembly (L5.a completion) ===
  -- Decay primitive (Re r < 0): the real-base power (x:ℂ)^r tends to 0
  -- at +∞ along ℕ.  Chain: norm (Complex.norm_cpow_eq_rpow_re_of_pos)
  -- + tendsto_rpow_neg_atTop (Analysis/SpecialFunctions/Pow/Asymptotics.lean:48,
  --   fetched/read online 2026-09-13) + natCast cofinality (hK precedent) +
  --   tendsto_zero_iff_norm_tendsto_zero.
  have hre1 : (-s + 1 : ℂ).re < 0 := by
    have hre : (-s + 1 : ℂ).re = -s.re + 1 := by
      rw [Complex.add_re, Complex.neg_re, Complex.one_re]
    linarith [hsσ]
  have hre2 : (-s : ℂ).re < 0 := by
    rw [show (-s : ℂ).re = -s.re from by rw [Complex.neg_re]]
    linarith [hsσ]
  have hre3 : (-s - 1 : ℂ).re < 0 := by
    have hEq : (-s - 1 : ℂ) = -((s : ℂ) + 1) := by ring
    rw [hEq, Complex.neg_re, Complex.add_re, Complex.one_re]
    linarith [hsσ]
  have hDecay2 (r : ℂ) (hrre : r.re < 0) :
      Tendsto (fun m : ℕ => ((m : ℝ) : ℂ) ^ r) atTop (nhds 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    apply Tendsto.congr'
    · exact mem_atTop_sets.2 ⟨1, fun m hm => by
        have hm0 : 0 < m := lt_of_lt_of_le (zero_lt_one : (0 : ℕ) < 1) hm
        exact (Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hm0) r).symm
      ⟩
    · convert (tendsto_rpow_neg_atTop (neg_pos.mpr hrre)).comp (tendsto_natCast_atTop_atTop (R := ℝ))
      rw [Function.comp_apply, neg_neg]
  -- the three endpoint decays, in the exact shapes of the hFin-RHS:
  have hM1 : Tendsto (fun m : ℕ => p4_A s (m : ℝ)) atTop (nhds 0) := by
    dsimp only [p4_A]
    exact hDecay2 (-s + 1) hre1
  have hM2 : Tendsto (fun m : ℕ => f (m : ℝ)) atTop (nhds 0) := by
    dsimp only [f]
    exact hDecay2 (-s) hre2
  have hM3 : Tendsto (fun m : ℕ => p4_f1 s (m : ℝ)) atTop (nhds 0) := by
    dsimp only [p4_f1]
    convert (hDecay2 (-s - 1) hre3).const_mul (-s) using 1
    · simp
  -- (1) (p4_A m − p4_A n)/(1−s) → −p4_A n/(1−s)
  have hTA : Tendsto (fun m : ℕ => p4_A s (m : ℝ) / (1 - s)) atTop (nhds 0) := by
    convert hM1.div_const (1 - s)
    simp only [zero_div]
  have hT1 : Tendsto (fun m : ℕ => (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s))
      atTop (nhds (0 - p4_A s (n : ℝ) / (1 - s))) := by
    have hD : ∀ (m : ℕ), (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) =
        p4_A s (m : ℝ) / (1 - s) - p4_A s (n : ℝ) / (1 - s) :=
      fun m => by ring
    have hSub : Tendsto (fun m : ℕ => p4_A s (m : ℝ) / (1 - s) - p4_A s (n : ℝ) / (1 - s))
        atTop (nhds (0 - p4_A s (n : ℝ) / (1 - s))) :=
      hTA.sub (tendsto_const_nhds :
        Tendsto (fun _ : ℕ => p4_A s (n : ℝ) / (1 - s)) atTop (nhds (p4_A s (n : ℝ) / (1 - s))))
    exact hSub.congr' (Eventually.of_forall (fun m => (hD m).symm))
  -- (2) ½(f m − f n) → −½ f n
  have hT2 : Tendsto (fun m : ℕ => ((1 / 2) : ℂ) * (f (m : ℝ) - f (n : ℝ)))
      atTop (nhds (((1 / 2) : ℂ) * (0 - f (n : ℝ)))) :=
    (hM2.sub (tendsto_const_nhds : Tendsto (fun _ : ℕ => f (n : ℝ)) atTop (nhds (f (n : ℝ))))).const_mul (1 / 2 : ℂ)
  -- (3) (1/12)(f' m − f' n) → −(1/12) f' n
  have hT3 : Tendsto (fun m : ℕ => ((1 / 12) : ℂ) * (p4_f1 s (m : ℝ) - p4_f1 s (n : ℝ)))
      atTop (nhds (((1 / 12) : ℂ) * (0 - p4_f1 s (n : ℝ)))) :=
    (hM3.sub (tendsto_const_nhds : Tendsto (fun _ : ℕ => p4_f1 s (n : ℝ)) atTop (nhds (p4_f1 s (n : ℝ))))).const_mul (1 / 12 : ℂ)
  -- kernel: ∫_n^m B• f'' → ∫_{Ioi n} B• f'' (L3 atom, composed with natCast)
  have hK : Tendsto (fun m : ℕ => ∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x)
      atTop (nhds (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * f2 x)) :=
    (p4_kernel_tendsto hsre2 n hn).comp (tendsto_natCast_atTop_atTop (R := ℝ))
  -- (4) ½ ∫_n^m B• f'' → ½ ∫_{Ioi n} B• f'' (L3 kernel, positive form for sub)
  have hT4p : Tendsto (fun m : ℕ => ((1 / 2) : ℂ) * (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x))
      atTop (nhds (((1 / 2) : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * f2 x))) :=
    hK.const_mul ((1 / 2) : ℂ)
  -- assemble: the closed form tends to the four-limit sum, which unfolds to p4_Tn_lim
  have hLim : Tendsto (fun m : ℕ =>
      (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) +
      ((1 / 2) : ℂ) * (f (m : ℝ) - f (n : ℝ)) +
      ((1 / 12) : ℂ) * (p4_f1 s (m : ℝ) - p4_f1 s (n : ℝ)) -
      ((1 / 2) : ℂ) * (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x))
      atTop (nhds (p4_Tn_lim s n)) := by
    convert (hT1.add hT2).add hT3 |>.sub hT4p
    · rw [hf, hf2]
      dsimp [p4_Tn_lim, p4_f1, p4_A, p4_f, p4_f2]
      ring_nf
  -- final: congr' with hFin (eventual pointwise equality, m ≥ n)
  have hEven : {m : ℕ |
      (p4_A s (m : ℝ) - p4_A s (n : ℝ)) / (1 - s) +
      ((1 / 2) : ℂ) * (f (m : ℝ) - f (n : ℝ)) +
      ((1 / 12) : ℂ) * (p4_f1 s (m : ℝ) - p4_f1 s (n : ℝ)) -
      ((1 / 2) : ℂ) * (∫ x : ℝ in (n : ℝ)..(m : ℝ), (B2 x : ℂ) * f2 x)
      = (∑ k ∈ Finset.Ioc n m, (k : ℂ) ^ (-s))} ∈ atTop := by
    apply mem_of_superset (mem_atTop_sets.2 ⟨n, fun m hm => hm⟩)
    intro m hm
    exact (hFin m hm).symm
  exact hLim.congr' hEven

  --/ ===== 25ae — the sharpened T3 (exact EM expansion + 4-term bound) =====
  --| Anchors: scripts/rh/day026_25ae_t3_sharpen.py, day026_25ae_final.py,
  --| out_day026_25ae_final.txt (F1-F4), DISCOVERY_LOG section 25ae.

  --/ Atom 25ae.0 — the B4..B8 periodic Bernoulli polynomials (the P4 no-zeta
  --|  convention; B_{k}' = k · B_{k-1}; cross-checked against mathlib's
  --|  `bernoulliFun 4..8` to 6.4e-17 at 256 points, day-026; B7 corrected
  --|  from the draft: the u-coefficient is 1/6, not 7/30 — the
  --|  B8' = 8·B7 consistency check is the detector). -/
  def B4poly (u : ℝ) : ℝ := u ^ 4 - 2 * u ^ 3 + u ^ 2 - 1 / 30

  def B5poly (u : ℝ) : ℝ := u ^ 5 - (5 / 2) * u ^ 4 + (5 / 3) * u ^ 3 - (1 / 6) * u

  def B6poly (u : ℝ) : ℝ := u ^ 6 - 3 * u ^ 5 + (5 / 2) * u ^ 4 - (1 / 2) * u ^ 2 + 1 / 42

  def B7poly (u : ℝ) : ℝ := u ^ 7 - (7 / 2) * u ^ 6 + (7 / 2) * u ^ 5 - (7 / 6) * u ^ 3 + (1 / 6) * u

  def B8poly (u : ℝ) : ℝ :=
      u ^ 8 - 4 * u ^ 7 + (14 / 3) * u ^ 6 - (7 / 3) * u ^ 4 + (2 / 3) * u ^ 2 - 1 / 30

  --/ Atom 25ae.0a — endpoints (vanishing + constant values used by the
  --|  per-period IBP boundary bookkeeping):
  --|  B4(0) = B4(1) = -1/30, B5(0) = B5(1) = 0, B6(0) = B6(1) = 1/42,
  --|  B7(0) = B7(1) = 0, B8(0) = B8(1) = -1/30. -/
  @[simp] lemma B4poly_at_0 : B4poly 0 = -1 / 30 := by dsimp only [B4poly]; norm_num
  @[simp] lemma B4poly_at_1 : B4poly 1 = -1 / 30 := by dsimp only [B4poly]; norm_num
  @[simp] lemma B5poly_at_0 : B5poly 0 = 0 := by dsimp only [B5poly]; norm_num
  @[simp] lemma B5poly_at_1 : B5poly 1 = 0 := by dsimp only [B5poly]; norm_num
  @[simp] lemma B6poly_at_0 : B6poly 0 = 1 / 42 := by dsimp only [B6poly]; norm_num
  @[simp] lemma B6poly_at_1 : B6poly 1 = 1 / 42 := by dsimp only [B6poly]; norm_num
  @[simp] lemma B7poly_at_0 : B7poly 0 = 0 := by dsimp only [B7poly]; norm_num
  @[simp] lemma B7poly_at_1 : B7poly 1 = 0 := by dsimp only [B7poly]; norm_num
  @[simp] lemma B8poly_at_0 : B8poly 0 = -1 / 30 := by dsimp only [B8poly]; norm_num
  @[simp] lemma B8poly_at_1 : B8poly 1 = -1 / 30 := by dsimp only [B8poly]; norm_num

  --/ Atom 25ae.0b — the derivative chain B_kpoly' = k · B_{k-1}poly (k =
  --|  4..8), the IBP antiderivative facts (primitives B_{k}/k of B_{k-1}). -/
  theorem B4poly_hasDerivAt (u : ℝ) : HasDerivAt B4poly (4 * u ^ 3 - 2 * (3 * u ^ 2) + 2 * u - 0) u := by
    have h1 : HasDerivAt (fun t : ℝ => t ^ 4) (4 * u ^ 3) u := hasDerivAt_pow 4 u
    have h2 : HasDerivAt (fun t : ℝ => 2 * t ^ 3) (2 * (3 * u ^ 2)) u := (hasDerivAt_pow 3 u).const_mul 2
    have h3 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
      simpa using hasDerivAt_pow 2 u
    have h4 : HasDerivAt (fun _ : ℝ => (1 / 30 : ℝ)) 0 u := hasDerivAt_const (x := u) (c := (1 / 30 : ℝ))
    refine ((h1.sub h2).add h3).sub h4

  @[simp] lemma B4poly_deriv_val (u : ℝ) :
      4 * u ^ 3 - 2 * (3 * u ^ 2) + 2 * u - 0 = 4 * B3poly u := by
    dsimp only [B3poly]
    ring

  theorem B5poly_hasDerivAt (u : ℝ) : HasDerivAt B5poly (5 * B4poly u) u := by
    have hT : 5 * B4poly u = 5 * u ^ 4 - (5 / 2 : ℝ) * (4 * u ^ 3) + (5 / 3 : ℝ) * (3 * u ^ 2) - 1 / 6 := by
      dsimp only [B4poly]
      ring
    rw [hT]
    have h1 : HasDerivAt (fun t : ℝ => t ^ 5) (5 * u ^ 4) u := hasDerivAt_pow 5 u
    have h2 : HasDerivAt (fun t : ℝ => (5 / 2 : ℝ) * t ^ 4) ((5 / 2 : ℝ) * (4 * u ^ 3)) u :=
      (hasDerivAt_pow 4 u).const_mul (5 / 2)
    have h3 : HasDerivAt (fun t : ℝ => (5 / 3 : ℝ) * t ^ 3) ((5 / 3 : ℝ) * (3 * u ^ 2)) u :=
      (hasDerivAt_pow 3 u).const_mul (5 / 3)
    have h4 : HasDerivAt (fun t : ℝ => (1 / 6 : ℝ) * t) (1 / 6 : ℝ) u :=
      hasDerivAt_const_mul ((1 / 6 : ℝ)) (x := u)
    refine ((h1.sub h2).add h3).sub h4

  @[simp] lemma B5poly_deriv_val (u : ℝ) :
      5 * u ^ 4 - (5 / 2 : ℝ) * (4 * u ^ 3) + (5 / 3 : ℝ) * (3 * u ^ 2) - 1 / 6 = 5 * B4poly u := by
    dsimp only [B4poly]
    ring

  theorem B6poly_hasDerivAt (u : ℝ) : HasDerivAt B6poly (6 * B5poly u) u := by
    have hT : 6 * B5poly u =
        6 * u ^ 5 - 3 * (5 * u ^ 4) + (5 / 2 : ℝ) * (4 * u ^ 3) - (1 / 2 : ℝ) * (2 * u) + 0 := by
      dsimp only [B5poly]
      ring
    rw [hT]
    have h1 : HasDerivAt (fun t : ℝ => t ^ 6) (6 * u ^ 5) u := hasDerivAt_pow 6 u
    have h2 : HasDerivAt (fun t : ℝ => 3 * t ^ 5) (3 * (5 * u ^ 4)) u := (hasDerivAt_pow 5 u).const_mul 3
    have h3 : HasDerivAt (fun t : ℝ => (5 / 2 : ℝ) * t ^ 4) ((5 / 2 : ℝ) * (4 * u ^ 3)) u :=
      (hasDerivAt_pow 4 u).const_mul (5 / 2)
    have hp2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
      simpa using hasDerivAt_pow 2 u
    have h4 : HasDerivAt (fun t : ℝ => (1 / 2 : ℝ) * t ^ 2) ((1 / 2 : ℝ) * (2 * u)) u :=
      hp2.const_mul (1 / 2)
    have h5 : HasDerivAt (fun _ : ℝ => (1 / 42 : ℝ)) 0 u := hasDerivAt_const (x := u) (c := (1 / 42 : ℝ))
    refine (((h1.sub h2).add h3).sub h4).add h5

  @[simp] lemma B6poly_deriv_val (u : ℝ) :
      6 * u ^ 5 - 3 * (5 * u ^ 4) + (5 / 2 : ℝ) * (4 * u ^ 3) - (1 / 2 : ℝ) * (2 * u) + 0 =
          6 * B5poly u := by
    dsimp only [B5poly]
    ring

  theorem B7poly_hasDerivAt (u : ℝ) : HasDerivAt B7poly (7 * B6poly u) u := by
    have hT : 7 * B6poly u =
        7 * u ^ 6 - (7 / 2 : ℝ) * (6 * u ^ 5) + (7 / 2 : ℝ) * (5 * u ^ 4) - (7 / 6 : ℝ) * (3 * u ^ 2)
            + (1 / 6 : ℝ) := by
      dsimp only [B6poly]
      ring
    rw [hT]
    have h1 : HasDerivAt (fun t : ℝ => t ^ 7) (7 * u ^ 6) u := hasDerivAt_pow 7 u
    have h2 : HasDerivAt (fun t : ℝ => (7 / 2 : ℝ) * t ^ 6) ((7 / 2 : ℝ) * (6 * u ^ 5)) u :=
      (hasDerivAt_pow 6 u).const_mul (7 / 2)
    have h3 : HasDerivAt (fun t : ℝ => (7 / 2 : ℝ) * t ^ 5) ((7 / 2 : ℝ) * (5 * u ^ 4)) u :=
      (hasDerivAt_pow 5 u).const_mul (7 / 2)
    have h4 : HasDerivAt (fun t : ℝ => (7 / 6 : ℝ) * t ^ 3) ((7 / 6 : ℝ) * (3 * u ^ 2)) u :=
      (hasDerivAt_pow 3 u).const_mul (7 / 6)
    have h5 : HasDerivAt (fun t : ℝ => (1 / 6 : ℝ) * t) (1 / 6 : ℝ) u :=
      hasDerivAt_const_mul ((1 / 6 : ℝ)) (x := u)
    refine ((((h1.sub h2).add h3).sub h4).add h5)

  @[simp] lemma B7poly_deriv_val (u : ℝ) :
      7 * u ^ 6 - (7 / 2 : ℝ) * (6 * u ^ 5) + (7 / 2 : ℝ) * (5 * u ^ 4) - (7 / 6 : ℝ) * (3 * u ^ 2)
          + (1 / 6 : ℝ) = 7 * B6poly u := by
    dsimp only [B6poly]
    ring

  theorem B8poly_hasDerivAt (u : ℝ) : HasDerivAt B8poly (8 * B7poly u) u := by
    have hT : 8 * B7poly u =
        8 * u ^ 7 - 4 * (7 * u ^ 6) + (14 / 3 : ℝ) * (6 * u ^ 5) - (7 / 3 : ℝ) * (4 * u ^ 3)
            + (2 / 3 : ℝ) * (2 * u) - 0 := by
      dsimp only [B7poly]
      ring
    rw [hT]
    have h1 : HasDerivAt (fun t : ℝ => t ^ 8) (8 * u ^ 7) u := hasDerivAt_pow 8 u
    have h2 : HasDerivAt (fun t : ℝ => 4 * t ^ 7) (4 * (7 * u ^ 6)) u := (hasDerivAt_pow 7 u).const_mul 4
    have h3 : HasDerivAt (fun t : ℝ => (14 / 3 : ℝ) * t ^ 6) ((14 / 3 : ℝ) * (6 * u ^ 5)) u :=
      (hasDerivAt_pow 6 u).const_mul (14 / 3)
    have h4 : HasDerivAt (fun t : ℝ => (7 / 3 : ℝ) * t ^ 4) ((7 / 3 : ℝ) * (4 * u ^ 3)) u :=
      (hasDerivAt_pow 4 u).const_mul (7 / 3)
    have hp2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
      simpa using hasDerivAt_pow 2 u
    have h5 : HasDerivAt (fun t : ℝ => (2 / 3 : ℝ) * t ^ 2) ((2 / 3 : ℝ) * (2 * u)) u :=
      hp2.const_mul (2 / 3)
    have h6 : HasDerivAt (fun _ : ℝ => (1 / 30 : ℝ)) 0 u := hasDerivAt_const (x := u) (c := (1 / 30 : ℝ))
    refine (((((h1.sub h2).add h3).sub h4).add h5).sub h6)

  @[simp] lemma B8poly_deriv_val (u : ℝ) :
      8 * u ^ 7 - 4 * (7 * u ^ 6) + (14 / 3 : ℝ) * (6 * u ^ 5) - (7 / 3 : ℝ) * (4 * u ^ 3)
          + (2 / 3 : ℝ) * (2 * u) - 0 = 8 * B7poly u := by
    dsimp only [B7poly]
    ring

  --/ Atom 25ae.0c — **|B8poly| <= 1/30 on [0,1]** (the 4-term-bound kernel
  --|  constant).  (The first draft used a Bernstein convex-hull argument;
  --|  it was REFUTED by exact-arithmetic cross-check before the Lean port:
  --|  the on-curve values B8(j/8) are NOT the Bernstein control points
  --|  (that identity is simply false — `ring` rejected it correctly), and
  --|  the true control points include b_4 = 8/105 > 1/30.  The factorization
  --|  route below is what works; every identity was cross-checked in exact
  --|  rational arithmetic before formalization.  Second draft tried a
  --|  second-derivative sign analysis; it was replaced by pure-algebraic
  --|  decompositions (this draft) which need no calculus at all.)
  --|  30·B8poly(u) + 1 = u²(1−u)²·T(u),  T(u) = 30u⁴−60u³−10u²+40u+20, and
  --|    T(u) − 20 = 10u(1−u)(4 − 3u + 3u²·(−1)·(−1))  i.e.  10u(u−1)(3u²−3u−4)
  --|      ≥ 0 on [0,1]  (u ≥ 0, u−1 ≤ 0, 3u²−3u−4 ≤ −4 ≤ 0),
  --|    255 − 8·T(u) = (2u−1)²(−60u²+60u+95) ≥ 0 on [0,1]
  --|      (−60u²+60u+95 = 60u(1−u)+95 ≥ 95 > 0).
  --|  Hence 20 ≤ T(u) ≤ 255/8, and with u²(1−u)² ≤ 1/16 ((2u−1)² ≥ 0):
  --|    B8poly(u) = (u²(1−u)²T(u) − 1)/30 ∈ [−1/30, (255/128−1)/30]
  --|    and (255/128−1)/30 = 127/3840 ≤ 1/30. -/
  theorem B8poly_bound_Icc (u : ℝ) (hu : u ∈ Set.Icc 0 1) : |B8poly u| ≤ 1 / 30 := by
    set Tfun := fun (x : ℝ) => 30 * x ^ 4 - 60 * x ^ 3 - 10 * x ^ 2 + 40 * x + 20 with hTfun_def
    have hu0 : 0 ≤ u := hu.1
    have hu1 : u ≤ 1 := hu.2
    have h1mu : 0 ≤ 1 - u := by linarith
    -- (1) the exact factorization (cross-checked in exact arithmetic)
    have hId : (30 : ℝ) * B8poly u + 1 = u ^ 2 * (1 - u) ^ 2 * Tfun u := by
      dsimp only [B8poly, Tfun]
      ring
    have hB8 : B8poly u = (u ^ 2 * (1 - u) ^ 2 * Tfun u - 1) / 30 := by
      linarith [hId]
    -- (2) 20 ≤ Tfun(u):  Tfun(u) − 20 = 10u(u−1)(3u²−3u−4) = 10u(1−u)(−3u²+3u+4)
    have hTminus : Tfun u - 20 = 10 * u * (u - 1) * (3 * u ^ 2 - 3 * u - 4) := by
      dsimp only [Tfun]
      ring
    have h3u : 3 * u ^ 2 - 3 * u - 4 ≤ 0 := by
      have hxs : u ^ 2 ≤ u := by nlinarith [hu0, hu1]
      nlinarith [hxs]
    have h10u : 0 ≤ 10 * u := by linarith [hu0]
    have hP : 0 ≤ 10 * u * (1 - u) * (-(3 * u ^ 2 - 3 * u - 4)) :=
      mul_nonneg (mul_nonneg h10u h1mu) (by linarith [h3u])
    have hTminus' : Tfun u - 20 = 10 * u * (1 - u) * (-(3 * u ^ 2 - 3 * u - 4)) := by
      dsimp only [Tfun]
      ring
    have hTlb : 20 ≤ Tfun u := by linarith [hTminus', hP]
    -- (3) Tfun(u) ≤ 255/8:  255 − 8Tfun(u) = (2u−1)²(−60u²+60u+95)
    have h8T : (2 * u - 1) ^ 2 * (-60 * u ^ 2 + 60 * u + 95) = 255 - 8 * Tfun u := by
      dsimp only [Tfun]
      ring
    have hInner : 0 ≤ -60 * u ^ 2 + 60 * u + 95 := by
      have h60u : 0 ≤ 60 * u * (1 - u) := mul_nonneg (by positivity) h1mu
      have h60u2 : 60 * u * (1 - u) = 60 * u - 60 * u ^ 2 := by ring
      rw [h60u2] at h60u
      linarith [h60u]
    have hSq : 0 ≤ (2 * u - 1) ^ 2 := by positivity
    have h8Tnn : 0 ≤ (2 * u - 1) ^ 2 * (-60 * u ^ 2 + 60 * u + 95) :=
      mul_nonneg hSq hInner
    have hTub : Tfun u ≤ 255 / 8 := by linarith [h8T, h8Tnn]
    -- (4) u²(1−u)² ≤ 1/16
    have hw : u ^ 2 * (1 - u) ^ 2 ≤ 1 / 16 := by
      have hs : 0 ≤ (2 * u - 1) ^ 2 := by positivity
      have h4w : 4 * (u * (1 - u)) ≤ 1 := by nlinarith [hs]
      have h04w : 0 ≤ 4 * (u * (1 - u)) :=
        mul_nonneg (by norm_num) (mul_nonneg hu0 h1mu)
      have h16 : 16 * (u ^ 2 * (1 - u) ^ 2) ≤ 1 := by
        calc 16 * (u ^ 2 * (1 - u) ^ 2)
            _ = (4 * (u * (1 - u))) ^ 2 := by ring
            _ ≤ 1 := by nlinarith [h04w, h4w]
      nlinarith [h16]
    -- (5) assemble
    rw [hB8, abs_le]
    constructor
    · have hTn : 0 ≤ Tfun u := by linarith [hTlb]
      have hpos : 0 ≤ u ^ 2 * (1 - u) ^ 2 * Tfun u :=
        mul_nonneg (mul_nonneg (pow_nonneg hu0 2) (pow_nonneg h1mu 2)) hTn
      linarith [hpos]
    · have hPosW : 0 ≤ u ^ 2 * (1 - u) ^ 2 :=
        mul_nonneg (pow_nonneg hu0 2) (pow_nonneg h1mu 2)
      have hTn : 0 ≤ Tfun u := by linarith [hTlb]
      have hTop : u ^ 2 * (1 - u) ^ 2 * Tfun u ≤ (1 / 16 : ℝ) * (255 / 8 : ℝ) :=
        mul_le_mul hw hTub hTn (by norm_num : 0 ≤ (1 : ℝ) / 16)
      have hC : (1 / 16 : ℝ) * (255 / 8 : ℝ) ≤ 2 := by norm_num
      calc (u ^ 2 * (1 - u) ^ 2 * Tfun u - 1) / 30
          _ ≤ (2 - 1) / 30 := by
              apply div_le_div_of_nonneg_right
              · linarith [hTop, hC]
              · norm_num
          _ = 1 / 30 := by norm_num

  --/ ===== 25ae Stage 2 — the per-period IBP ladder B2 -> B3 -> ... -> B8 =====
  --|  Per-period atoms (j an integer period, j >= 1), mirroring the L4
  --|  `p4_op2c_bound` pattern (`intervalIntegral.integral_mul_deriv_eq_deriv_mul`
  --|  + `hasDerivAt_ofReal_cpow_const`).  Denominators are the SINGLE next
  --|  index (k+1), NOT cumulative products — the cumulative variant was
  --|  refuted numerically before port (day-026: per-step mpmath check to
  --|  1e-43).  With I_k := ∫ B_k({x}) x^{-s-k}:
  --|    I_k = (B_{k+1}(0)/(k+1))·((j+1)^{-s-k} - j^{-s-k})
  --|          + (s+k)/(k+1) · ∫ B_{k+1}({x}) x^{-s-(k+1)}   (per period),
  --|  with B3(0)=B5(0)=B7(0)=0 and B4(1)=B4(0), B6(1)=B6(0), B8(1)=B8(0). -/

  -- (i) step 1: B2 -> B3 (vanishing boundary)
  theorem p4_25ae_ibp_b2to3 {s : ℂ} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ) * (x : ℂ) ^ (-s - 2))
          = (s + 2 : ℂ) / 3 *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 2) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B3poly (x - (j : ℝ))) / 3 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 2) * (x : ℂ) ^ (-s - 3)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 2 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 2).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
          Complex.neg_re, Complex.add_re,
          show (2 : ℂ).re = 2 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 2 : ℂ) - 1 = -s - 3 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ)) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B3poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B3poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B3poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : 3 * ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6) * 1 =
          3 * ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6) := by ring
      have hW : HasDerivAt (fun t : ℝ => B3poly (t - (j : ℝ)))
          (3 * ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6)) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B3poly (t - (j : ℝ))) / 3)
          ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6) x := by
        simpa using hW.div_const 3
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 3))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 3)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 2) * (x : ℂ) ^ (-s - 3))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 2 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable
        (fun x : ℝ => ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn
          (fun x : ℝ => ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ))) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ) * (x : ℂ) ^ (-s - 2))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ))) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ)))
                (fun x : ℝ =>
                  (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ) * (x : ℂ) ^ (-s - 2)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ), ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) := H
        _ = - (∫ x in (j : ℝ)..(j + 1 : ℝ), ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring, B3poly_at_1]
              norm_num
            have hvb0 : v (j : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring, B3poly_at_0]
              norm_num
            rw [hvb1, hvb0]
            ring
        _ = ((s + 2 : ℂ) / 3) *
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x) =
                ((-(s + 2 : ℂ)) / 3) *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 2) * (x : ℂ) ^ (-s - 3)) * v x)
                  (fun x : ℝ => (-(s + 2 : ℂ)) / 3 *
                    ((B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul ((-(s + 2 : ℂ)) / 3)])
            rw [hX]
            ring


  -- (ii) step 3: B3 -> B4 (boundary from B4(0) = B4(1))
  theorem p4_25ae_ibp_b3to4 {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))
          = (((B4poly 0) / 4) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 3) - ((j : ℝ) : ℂ) ^ (-s - 3))
              + (s + 3 : ℂ) / 4 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 3) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B4poly (x - (j : ℝ))) / 4 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 3) * (x : ℂ) ^ (-s - 4)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 3 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 3).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 3 : ℂ) = -((s : ℂ) + 3) from by ring,
          Complex.neg_re, Complex.add_re,
          show (3 : ℂ).re = 3 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 3 : ℂ) - 1 = -s - 4 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B3poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B4poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B4poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B4poly (t - (j : ℝ))) := by funext t; dsimp
      have hval : (4 * (x - (j : ℝ)) ^ 3 - 2 * (3 * (x - (j : ℝ)) ^ 2) + 2 * (x - (j : ℝ)) - 0)
          = 4 * B3poly (x - (j : ℝ)) := by
        dsimp only [B3poly]
        ring
      have hW : HasDerivAt (fun t : ℝ => B4poly (t - (j : ℝ))) (4 * B3poly (x - (j : ℝ))) x := by
        simpa [hfun, hval] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B4poly (t - (j : ℝ))) / 4)
          (B3poly (x - (j : ℝ))) x := by
        simpa [show (4 * B3poly (x - (j : ℝ)) / 4) = B3poly (x - (j : ℝ)) from by ring]
          using (hW.div_const 4)
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 4))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 4)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 3) * (x : ℂ) ^ (-s - 4))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 3 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B3poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B3poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        dsimp only [B3poly]
        fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B3poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 3) * (x : ℂ) ^ (-s - 4)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B3poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B3poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - 3) * (x : ℂ) ^ (-s - 4)) * v x) := H
        _ = ((B4poly 0 / 4 : ℝ) : ℂ) *
                (u (j + 1 : ℝ) - u (j : ℝ)) -
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  ((-s - 3 : ℂ) * (x : ℂ) ^ (-s - 4)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = (((B4poly 1) / 4) : ℂ) := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring]
            have hvb0 : v (j : ℝ) = (((B4poly 0) / 4) : ℂ) := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring]
            rw [hvb1, hvb0]
            have hB4 : B4poly 1 = B4poly 0 := by
              rw [B4poly_at_1, B4poly_at_0]
            simp [hB4]
            ring
        _ = (((B4poly 0) / 4) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 3) - ((j : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 3 : ℂ) / 4) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)) := by
            have hu1 : u (j + 1 : ℝ) = (((j + 1 : ℝ) : ℂ) ^ (-s - 3)) := by
              dsimp only [u]
            have hu0 : u (j : ℝ) = (((j : ℝ) : ℂ) ^ (-s - 3)) := by
              dsimp only [u]
            rw [hu1, hu0]
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 3) * (x : ℂ) ^ (-s - 4)) * v x) =
                (-(s + 3 : ℂ)) / 4 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 3) * (x : ℂ) ^ (-s - 4)) * v x)
                  (fun x : ℝ => (-(s + 3 : ℂ)) / 4 *
                    ((B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + 3 : ℂ) / 4)])
            rw [hX]
            have hC : (-(s + 3 : ℂ)) / 4 = -((s + 3 : ℂ) / 4) := by
              ring
            rw [hC]
            simp

  -- (iii) step 4: B4 -> B5 (vanishing boundary)
  theorem p4_25ae_ibp_b4to5 {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4))
          = 0
              + (s + 4 : ℂ) / 5 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 4) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B5poly (x - (j : ℝ))) / 5 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 4) * (x : ℂ) ^ (-s - 5)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 4 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 4).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 4 : ℂ) = -((s : ℂ) + 4) from by ring,
          Complex.neg_re, Complex.add_re,
          show (4 : ℂ).re = 4 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 4 : ℂ) - 1 = -s - 5 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B4poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B5poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B5poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B5poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : 5 * B4poly (x - (j : ℝ)) * 1 = 5 * B4poly (x - (j : ℝ)) := by ring
      have hW : HasDerivAt (fun t : ℝ => B5poly (t - (j : ℝ)))
          (5 * B4poly (x - (j : ℝ))) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B5poly (t - (j : ℝ))) / 5)
          (B4poly (x - (j : ℝ))) x := by
        simpa using hW.div_const 5
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 5))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 5)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 4) * (x : ℂ) ^ (-s - 5))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 4 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B4poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B4poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        dsimp only [B4poly]
        fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B4poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 4) * (x : ℂ) ^ (-s - 5)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B4poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B4poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - 4) * (x : ℂ) ^ (-s - 5)) * v x) := H
        _ = - (∫ x in (j : ℝ)..(j + 1 : ℝ),
                ((-s - 4 : ℂ) * (x : ℂ) ^ (-s - 5)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring, B5poly_at_1]
              norm_num
            have hvb0 : v (j : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring, B5poly_at_0]
              norm_num
            rw [hvb1, hvb0]
            ring
        _ = 0
            + ((s + 4 : ℂ) / 5) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)) := by
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 4) * (x : ℂ) ^ (-s - 5)) * v x) =
                (-(s + 4 : ℂ)) / 5 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 4) * (x : ℂ) ^ (-s - 5)) * v x)
                  (fun x : ℝ => (-(s + 4 : ℂ)) / 5 *
                    ((B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + 4 : ℂ) / 5)])
            rw [hX]
            ring

  -- (iv) step 5: B5 -> B6 (boundary from B6(0) = B6(1))
  theorem p4_25ae_ibp_b5to6 {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))
          = (((B6poly 0) / 6) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 5) - ((j : ℝ) : ℂ) ^ (-s - 5))
              + (s + 5 : ℂ) / 6 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 5) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B6poly (x - (j : ℝ))) / 6 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 5) * (x : ℂ) ^ (-s - 6)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 5 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 5).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 5 : ℂ) = -((s : ℂ) + 5) from by ring,
          Complex.neg_re, Complex.add_re,
          show (5 : ℂ).re = 5 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 5 : ℂ) - 1 = -s - 6 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B5poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B6poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B6poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B6poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : 6 * B5poly (x - (j : ℝ)) * 1 = 6 * B5poly (x - (j : ℝ)) := by ring
      have hW : HasDerivAt (fun t : ℝ => B6poly (t - (j : ℝ)))
          (6 * B5poly (x - (j : ℝ))) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B6poly (t - (j : ℝ))) / 6)
          (B5poly (x - (j : ℝ))) x := by
        simpa using hW.div_const 6
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 6))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 6)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 5) * (x : ℂ) ^ (-s - 6))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 5 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B5poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B5poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        dsimp only [B5poly]
        fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B5poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 5) * (x : ℂ) ^ (-s - 6)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B5poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B5poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - 5) * (x : ℂ) ^ (-s - 6)) * v x) := H
        _ = ((B6poly 0 / 6 : ℝ) : ℂ) *
                (u (j + 1 : ℝ) - u (j : ℝ)) -
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  ((-s - 5 : ℂ) * (x : ℂ) ^ (-s - 6)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = (((B6poly 1) / 6) : ℂ) := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring]
            have hvb0 : v (j : ℝ) = (((B6poly 0) / 6) : ℂ) := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring]
            rw [hvb1, hvb0]
            have hB6 : B6poly 1 = B6poly 0 := by
              rw [B6poly_at_1, B6poly_at_0]
            simp [hB6]
            ring
        _ = (((B6poly 0) / 6) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 5) - ((j : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 5 : ℂ) / 6) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)) := by
            have hu1 : u (j + 1 : ℝ) = (((j + 1 : ℝ) : ℂ) ^ (-s - 5)) := by
              dsimp only [u]
            have hu0 : u (j : ℝ) = (((j : ℝ) : ℂ) ^ (-s - 5)) := by
              dsimp only [u]
            rw [hu1, hu0]
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 5) * (x : ℂ) ^ (-s - 6)) * v x) =
                (-(s + 5 : ℂ)) / 6 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 5) * (x : ℂ) ^ (-s - 6)) * v x)
                  (fun x : ℝ => (-(s + 5 : ℂ)) / 6 *
                    ((B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + 5 : ℂ) / 6)])
            rw [hX]
            have hC : (-(s + 5 : ℂ)) / 6 = -((s + 5 : ℂ) / 6) := by
              ring
            rw [hC]
            simp

  -- (v) step 6: B6 -> B7 (vanishing boundary)
  theorem p4_25ae_ibp_b6to7 {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6))
          = 0
              + (s + 6 : ℂ) / 7 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 6) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B7poly (x - (j : ℝ))) / 7 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 6) * (x : ℂ) ^ (-s - 7)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 6 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 6).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 6 : ℂ) = -((s : ℂ) + 6) from by ring,
          Complex.neg_re, Complex.add_re,
          show (6 : ℂ).re = 6 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 6 : ℂ) - 1 = -s - 7 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B6poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B7poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B7poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B7poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : 7 * B6poly (x - (j : ℝ)) * 1 = 7 * B6poly (x - (j : ℝ)) := by ring
      have hW : HasDerivAt (fun t : ℝ => B7poly (t - (j : ℝ)))
          (7 * B6poly (x - (j : ℝ))) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B7poly (t - (j : ℝ))) / 7)
          (B6poly (x - (j : ℝ))) x := by
        simpa using hW.div_const 7
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 7))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 7)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 6) * (x : ℂ) ^ (-s - 7))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 6 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B6poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B6poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        dsimp only [B6poly]
        fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B6poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 6) * (x : ℂ) ^ (-s - 7)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B6poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B6poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - 6) * (x : ℂ) ^ (-s - 7)) * v x) := H
        _ = - (∫ x in (j : ℝ)..(j + 1 : ℝ),
                ((-s - 6 : ℂ) * (x : ℂ) ^ (-s - 7)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring, B7poly_at_1]
              norm_num
            have hvb0 : v (j : ℝ) = 0 := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring, B7poly_at_0]
              norm_num
            rw [hvb1, hvb0]
            ring
        _ = 0
            + ((s + 6 : ℂ) / 7) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)) := by
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 6) * (x : ℂ) ^ (-s - 7)) * v x) =
                (-(s + 6 : ℂ)) / 7 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 6) * (x : ℂ) ^ (-s - 7)) * v x)
                  (fun x : ℝ => (-(s + 6 : ℂ)) / 7 *
                    ((B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + 6 : ℂ) / 7)])
            rw [hX]
            ring

  -- (vi) step 7: B7 -> B8 (boundary from B8(0) = B8(1))
  theorem p4_25ae_ibp_b7to8 {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))
          = (((B8poly 0) / 8) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 7) - ((j : ℝ) : ℂ) ^ (-s - 7))
              + (s + 7 : ℂ) / 8 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - 7) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B8poly (x - (j : ℝ))) / 8 : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - 7) * (x : ℂ) ^ (-s - 8)) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - 7 ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - 7).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - 7 : ℂ) = -((s : ℂ) + 7) from by ring,
          Complex.neg_re, Complex.add_re,
          show (7 : ℂ).re = 7 from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - 7 : ℂ) - 1 = -s - 8 := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B7poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B8poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B8poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B8poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : 8 * B7poly (x - (j : ℝ)) * 1 = 8 * B7poly (x - (j : ℝ)) := by ring
      have hW : HasDerivAt (fun t : ℝ => B8poly (t - (j : ℝ)))
          (8 * B7poly (x - (j : ℝ))) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B8poly (t - (j : ℝ))) / 8)
          (B7poly (x - (j : ℝ))) x := by
        simpa using hW.div_const 8
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 8))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 8)
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - 7) * (x : ℂ) ^ (-s - 8))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - 7 : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B7poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B7poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        dsimp only [B7poly]
        fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B7poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - 7) * (x : ℂ) ^ (-s - 8)) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B7poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B7poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - 7) * (x : ℂ) ^ (-s - 8)) * v x) := H
        _ = ((B8poly 0 / 8 : ℝ) : ℂ) *
                (u (j + 1 : ℝ) - u (j : ℝ)) -
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  ((-s - 7 : ℂ) * (x : ℂ) ^ (-s - 8)) * v x) := by
            have hvb1 : v (j + 1 : ℝ) = (((B8poly 1) / 8) : ℂ) := by
              dsimp only [v]
              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring]
            have hvb0 : v (j : ℝ) = (((B8poly 0) / 8) : ℂ) := by
              dsimp only [v]
              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring]
            rw [hvb1, hvb0]
            have hB8 : B8poly 1 = B8poly 0 := by
              rw [B8poly_at_1, B8poly_at_0]
            simp [hB8]
            ring
        _ = (((B8poly 0) / 8) : ℂ) * (((j + 1 : ℝ) : ℂ) ^ (-s - 7) - ((j : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 7 : ℂ) / 8) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)) := by
            have hu1 : u (j + 1 : ℝ) = (((j + 1 : ℝ) : ℂ) ^ (-s - 7)) := by
              dsimp only [u]
            have hu0 : u (j : ℝ) = (((j : ℝ) : ℂ) ^ (-s - 7)) := by
              dsimp only [u]
            rw [hu1, hu0]
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - 7) * (x : ℂ) ^ (-s - 8)) * v x) =
                (-(s + 7 : ℂ)) / 8 *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - 7) * (x : ℂ) ^ (-s - 8)) * v x)
                  (fun x : ℝ => (-(s + 7 : ℂ)) / 8 *
                    ((B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + 7 : ℂ) / 8)])
            rw [hX]
            have hC : (-(s + 7 : ℂ)) / 8 = -((s + 7 : ℂ) / 8) := by
              ring
            rw [hC]
            simp

  --/ ===== 25ae Stage 3A — periodic B8, telescope, finite-M identity (J) =====

  -- The periodic 8th Bernoulli function (kernel = B8poly on each [j, j+1]).
  noncomputable def B8 (x : ℝ) : ℝ := B8poly (x - ⌊x⌋₊)

  @[fun_prop]
  lemma aestronglyMeasurable_B8 : AEStronglyMeasurable B8 := by
    unfold B8 B8poly
    fun_prop

  -- On [n, n+1]: B8 = B8poly(·−n).  (Same shape as P4Tail.B2_of_Icc_int.)
  lemma B8_of_Icc_int (n : ℕ) {x : ℝ} (hx : x ∈ Set.Icc (n : ℝ) (n + 1 : ℝ)) :
      B8 x = B8poly (x - n) := by
    unfold B8
    by_cases htop : x = (n + 1 : ℝ)
    · rw [htop]
      have hfl : (⌊(n + 1 : ℝ)⌋₊ : ℕ) = n + 1 :=
        (Nat.floor_eq_iff (ha := by positivity)).mpr
          ⟨by norm_cast, by
            norm_cast
            linarith⟩
      rw [hfl]
      norm_num [B8poly_at_0, B8poly_at_1]
    · have hn : (⌊x⌋₊ : ℝ) = (n : ℝ) := by
        norm_cast
        rw [Nat.floor_eq_iff (by linarith [show (0 : ℝ) ≤ x from le_trans (Nat.cast_nonneg n) hx.1])]
        constructor
        · linarith [hx.1]
        · exact lt_of_le_of_ne hx.2 htop
      rw [hn]

  -- |B8 x| <= 1/30 for x >= 0 (kernel in [0,1]; B8poly_bound_Icc on [0,1]).
  lemma abs_B8_le {x : ℝ} (hx : 0 ≤ x) : |B8 x| ≤ 1 / 30 := by
    unfold B8
    set v := (x - ⌊x⌋₊ : ℝ) with hv
    have hv0 : 0 ≤ v := by grind [Nat.floor_le hx]
    have hv1 : v ≤ 1 := by grind [Nat.lt_succ_floor x]
    simpa [v] using B8poly_bound_Icc v ⟨hv0, hv1⟩

  -- Aux telescope with the endpoint written as n + k (avoids ℕ-cast traps).
  lemma p4_25ae_telescope_pow_aux {p : ℂ} (n k : ℕ) :
      (∑ j ∈ Finset.Ico n (n + k), (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
          = (((n + k : ℕ) : ℝ) : ℂ) ^ p - ((n : ℝ) : ℂ) ^ p := by
    set f : ℕ → ℂ :=
      fun (x : ℕ) => (((x + 1 : ℕ) : ℝ) : ℂ) ^ p - (((x : ℕ) : ℝ) : ℂ) ^ p with hf
    have hsumf : (∑ j ∈ Finset.Ico n (n + k), (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
        = (∑ j ∈ Finset.Ico n (n + k), f j) := by
      apply Finset.sum_congr rfl
      intro j _
      dsimp only [f]
      simp only [Nat.cast_add, Nat.cast_one]
    rw [hsumf]
    induction' k with k IH
    · simp [Finset.Ico_self]
    · rw [show n + (k + 1) = (n + k) + 1 from by ring]
      have IHraw : (∑ j ∈ Finset.Ico n (n + k),
                  (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
          = (∑ j ∈ Finset.Ico n (n + k), f j) := by
        apply Finset.sum_congr rfl
        intro j _
        dsimp only [f]
        simp only [Nat.cast_add, Nat.cast_one]
      have IHg : (∑ j ∈ Finset.Ico n (n + k), f j) =
          (((n + k : ℕ) : ℝ) : ℂ) ^ p - ((n : ℝ) : ℂ) ^ p := IH IHraw
      rw [Finset.sum_Ico_succ_top (Nat.le_add_right n k) f]
      rw [IHg]
      dsimp only [f]
      ring

  -- Finite telescope over Ico (no ℕ-indexed Ico telescope in mathlib 4.33.1).
  lemma p4_25ae_telescope_pow {p : ℂ} (n M : ℕ) (hnm : n ≤ M) :
      (∑ j ∈ Finset.Ico n M, (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
          = ((M : ℝ) : ℂ) ^ p - ((n : ℝ) : ℂ) ^ p := by
    have hM : M = n + (M - n) := by omega
    rw [hM]
    exact p4_25ae_telescope_pow_aux n (M - n)

  -- The finite-M identity.  J(M) := ∫_n^M B̂₂ x^{-s-2} dx, expressed via the
  -- endpoint differences (B4/B6/B8 boundary values) and the B8 period-sum
  -- tail.  Coefficient atoms are verbatim those of the Stage-2 atoms
  -- (so all ring atoms between the assembled term and the target match).
  theorem p4_25ae_J_finite {s : ℂ} (hsre : s.re = 1 / 2) (n M : ℕ) (hn : 0 < n)
      (hnm : n ≤ M) :
      (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
          = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
              (((B8poly 0) / 8) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
              (∑ j ∈ Finset.Ico n M,
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) := by
    -- period sums at each ladder level
    set S3 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))) with hS3
    set S4 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4))) with hS4
    set S5 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))) with hS5
    set S6 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6))) with hS6
    set S7 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))) with hS7
    set S8 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) with hS8
    -- (1) ∫_n^M with the B2 kernel = the period sum (kernel = B2poly per period)
    have h1 : (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        = (∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))) := by
      rw [← sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ)) hnm
        (fun (j : ℕ) hjk => by
          have hco2 : ContinuousOn (fun x : ℝ => (B2 x : ℂ)) (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by
            have hpoly : ContinuousOn
                (fun x : ℝ => (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℝ) : ℂ))
                (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by fun_prop
            exact ContinuousOn.congr hpoly (by
              intro x hx
              dsimp only
              rw [B2_of_Icc_int (n := (j : ℕ)) hx])
          have hcohpoly : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 2))
              (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by
            intro x hx
            have hpos : 0 < x := by
              calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
                _ ≤ (j : ℝ) := Nat.cast_le (α := ℝ) |>.mpr (Set.mem_Ico.mp hjk |>.1)
                _ ≤ x := by
                  simpa [show min (j : ℝ) (j + 1) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1
            exact (Complex.continuousAt_ofReal_cpow_const x (-s - 2)
                (Or.inr (ne_of_gt hpos))).continuousWithinAt
          have hco : ContinuousOn (fun x : ℝ => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
              (Set.Icc (j : ℝ) ((j + 1 : ℕ) : ℝ)) :=
            (hco2.mul hcohpoly).mono (by
              intro x hx
              rw [show (j : ℝ) + 1 = ((j + 1 : ℕ) : ℝ) from (Nat.cast_succ j).symm]
              exact hx)
          exact hco.intervalIntegrable_of_Icc (by norm_num))]
      rw [Finset.sum_congr rfl (fun j _ => by
        rw [show ((j + 1 : ℕ) : ℝ) = (j : ℝ) + 1 from Nat.cast_succ j])]
      apply Finset.sum_congr rfl
      intro j hj
      have hIC : Set.EqOn (fun x : ℝ => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
          (fun x : ℝ => (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
        intro x hx
        have hxIcc : x ∈ Set.Icc (j : ℝ) (j + 1 : ℝ) :=
          ⟨by simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1,
            by simpa using hx.2⟩
        dsimp only [B2poly]
        rw [B2_of_Icc_int j hxIcc]
      exact (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hIC)
    -- (2) B2 -> B3 (vanishing B3 boundary): period sum = (s+2)/3 · S3
    have h2 : (∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2)))
        = S3 * ((s + 2 : ℂ) / 3) := by
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 2 : ℂ) / 3 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        have hraw : (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))
            = (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ) * (x : ℂ) ^ (-s - 2))) := by
          have hIC : EqOn (fun x : ℝ => (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))
              (fun x : ℝ => (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℂ) * (x : ℂ) ^ (-s - 2)))
              (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
            intro x _
            dsimp only [B2poly]
            simp [Complex.ofReal_div]
          exact (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hIC)
        rw [hraw]
        exact (p4_25ae_ibp_b2to3 (s := s) hsre j hjpos)
      rw [hper, ← Finset.mul_sum]
      dsimp only [S3]
      ring
    -- (3) B3 -> B4: S3 = B4-boundary·Δu3 + (s+3)/4 · S4
    have h3 : S3 = (((B4poly 0) / 4) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
          + S4 * ((s + 3 : ℂ) / 4) := by
      dsimp only [S3, S4]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B4poly 0) / 4) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 3) - ((j : ℝ) : ℂ) ^ (-s - 3))
                + (s + 3 : ℂ) / 4 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        exact (p4_25ae_ibp_b3to4 (s := s) hsre j hjpos)
      rw [hper, Finset.sum_add_distrib,
        ← Finset.mul_sum,
        p4_25ae_telescope_pow (p := (-s - 3 : ℂ)) n M hnm,
        ← Finset.mul_sum]
      ring
    -- (4) B4 -> B5 (vanishing B5 boundary): S4 = (s+4)/5 · S5
    have h4 : S4 = S5 * ((s + 4 : ℂ) / 5) := by
      dsimp only [S4, S5]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 4 : ℂ) / 5 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        simpa using (p4_25ae_ibp_b4to5 (s := s) hsre j hjpos)
      rw [hper, ← Finset.mul_sum]
      ring
    -- (5) B5 -> B6: S5 = B6-boundary·Δu5 + (s+5)/6 · S6
    have h5 : S5 = (((B6poly 0) / 6) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
          + S6 * ((s + 5 : ℂ) / 6) := by
      dsimp only [S5, S6]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B6poly 0) / 6) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 5) - ((j : ℝ) : ℂ) ^ (-s - 5))
                + (s + 5 : ℂ) / 6 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        exact (p4_25ae_ibp_b5to6 (s := s) hsre j hjpos)
      rw [hper, Finset.sum_add_distrib,
        ← Finset.mul_sum,
        p4_25ae_telescope_pow (p := (-s - 5 : ℂ)) n M hnm,
        ← Finset.mul_sum]
      ring
    -- (6) B6 -> B7 (vanishing B7 boundary): S6 = (s+6)/7 · S7
    have h6 : S6 = S7 * ((s + 6 : ℂ) / 7) := by
      dsimp only [S6, S7]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 6 : ℂ) / 7 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        simpa using (p4_25ae_ibp_b6to7 (s := s) hsre j hjpos)
      rw [hper, ← Finset.mul_sum]
      ring
    -- (7) B7 -> B8: S7 = B8-boundary·Δu7 + (s+7)/8 · S8
    have h7 : S7 = (((B8poly 0) / 8) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
          + S8 * ((s + 7 : ℂ) / 8) := by
      dsimp only [S7, S8]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B8poly 0) / 8) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 7) - ((j : ℝ) : ℂ) ^ (-s - 7))
                + (s + 7 : ℂ) / 8 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by
          rw [Finset.mem_Ico] at hj
          omega
        exact (p4_25ae_ibp_b7to8 (s := s) hsre j hjpos)
      rw [hper, Finset.sum_add_distrib,
        ← Finset.mul_sum,
        p4_25ae_telescope_pow (p := (-s - 7 : ℂ)) n M hnm,
        ← Finset.mul_sum]
      ring
    -- (8) assemble the ladder
    calc (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        _ = (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))) := h1
        _ = S3 * ((s + 2 : ℂ) / 3) := h2
        _ = ((s + 2 : ℂ) / 3) * S3 := by ring
        _ = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
                (((B8poly 0) / 8) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
                S8 := by
          rw [mul_comm, h3, h4, h5, h6, h7]
          ring
        _ = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
                (((B8poly 0) / 8) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
                (∑ j ∈ Finset.Ico n M,
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) := by
            dsimp only [S8]
  --/ ===== 25ae Stage 3B - the M -> oo passage =====

  --/ (3B.1) B8 x^{-s-8} is absolutely integrable on (c, oo), c > 0, Re s > -7:
  --|  |kernel| <= (1/30) x^{-(Re s+8)} (abs_B8_le +
  --|  Complex.norm_cpow_eq_rpow_re_of_pos), dominated by
  --|  (1/30) x^{-(Re s+8)} via integrableOn_Ioi_rpow_of_lt;
  --|  aes = aes(B8-ofReal) .mul aes(cpow continuous on Ioi c). -/
  theorem p4_B8cpw8_integrableOn_Ioi {s : ℂ} (hsre : s.re > -7) {c : ℝ} (hc : 0 < c) :
      IntegrableOn (fun x : ℝ => (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) (Set.Ioi c) := by
    have hB8aes : AEStronglyMeasurable (fun x : ℝ => (B8 x : ℂ)) (volume.restrict (Set.Ioi c)) := by
      exact (AEStronglyMeasurable.mono_measure
        (Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)
          (aestronglyMeasurable_B8 : AEStronglyMeasurable B8))
        ((Measure.restrict_mono (Set.Ioi c).subset_univ le_rfl).trans (le_of_eq Measure.restrict_univ)))
    have hcpwcont : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 8)) (Set.Ioi c) := by
      intro x hx
      have hcxt : c < x := Set.mem_Ioi.mp hx
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 8)
          (Or.inr (ne_of_gt (hc.trans hcxt)))).continuousWithinAt
    have hcpwae : AEStronglyMeasurable (fun x : ℝ => (x : ℂ) ^ (-s - 8))
        (volume.restrict (Set.Ioi c)) :=
      ContinuousOn.aestronglyMeasurable hcpwcont measurableSet_Ioi
    have hRpow : Integrable (fun x : ℝ => x ^ (-(s.re + 8))) (volume.restrict (Set.Ioi c)) :=
      (integrableOn_Ioi_rpow_of_lt (by linarith [hsre]) hc).integrable
    have hMajor : HasFiniteIntegral
        (fun x : ℝ => (1 / 30 : ℝ) * x ^ (-(s.re + 8))) (volume.restrict (Set.Ioi c)) :=
      Integrable.hasFiniteIntegral (hRpow.const_mul (1 / 30 : ℝ))
    constructor
    · exact hB8aes.mul hcpwae
    · rw [← hasFiniteIntegral_norm_iff]
      exact HasFiniteIntegral.mono' hMajor (by
        rw [ae_restrict_iff' measurableSet_Ioi]
        exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx => by
          have hxpos : 0 < x := hc.trans hx
          have h1 : ‖(‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖ : ℝ)‖ =
              ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖ := by simp
          rw [h1]
          calc ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖
              _ = ‖(B8 x : ℂ)‖ * ‖(x : ℂ) ^ (-s - 8)‖ := by rw [norm_mul]
              _ ≤ (1 / 30) * x ^ (-(s.re + 8)) := by
                rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos (-s - 8),
                  show (-s - 8 : ℂ).re = -(s.re + 8) from by
                    rw [show (-(s : ℂ) - 8 : ℂ) = -((s : ℂ) + 8) from by ring,
                      Complex.neg_re, Complex.add_re,
                      show (8 : ℂ).re = 8 from by norm_num]]
                gcongr
                calc ‖(B8 x : ℂ)‖
                    _ = Real.sqrt (B8 x ^ 2) := by
                      rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
                    _ = |B8 x| := by rw [Real.sqrt_sq_eq_abs]
                    _ ≤ 1 / 30 := abs_B8_le hxpos.le
        ))

  --/ (3B.2) the M -> oo passage for the B8 tail kernel (verbatim L3.f idiom):
  --|  ∫_n^M B8 x^{-s-8} -> the improper integral, M -> oo (n >= 1). -/
  theorem p4_B8cpw8_tendsto {s : ℂ} (hsre : s.re > -7) (n : ℕ) (hn : 0 < n) :
      Tendsto (fun M : ℝ => ∫ x in (n : ℝ)..M, (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))
          atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))) :=
    intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ))
      (p4_B8cpw8_integrableOn_Ioi hsre (Nat.cast_pos.mpr hn)) tendsto_id

  --/ (3B.3) the M-endpoint powers vanish on the critical line (k >= 3):
  --|  M^{-s-k} -> 0 as M -> oo.  Norm bridge via
  --|  Complex.norm_cpow_eq_rpow_re_of_pos + Real.tendsto_rpow_neg_atTop +
  --|  NormedAddGroup.tendsto_nhds_zero (the @[to_additive] of
  --|  NormedGroup.tendsto_nhds_one, Analysis/Normed/Group/Basic.lean:331). -/
  theorem p4_25ae_cpwtendsto0 {s : ℂ} (hsre : s.re = 1 / 2) (k : ℕ) (hk : 3 ≤ k) :
      Tendsto (fun M : ℝ => ((M : ℝ) : ℂ) ^ (-s - k)) atTop (𝓝 0) := by
    have hexp : (-s - k : ℂ).re = -(s.re + (k : ℝ)) := by
      rw [show (-(s : ℂ) - (k : ℂ) : ℂ) = -((s : ℂ) + (k : ℂ)) from by ring,
        Complex.neg_re, Complex.add_re]
      simpa using (show (((k : ℕ) : ℂ)).re = (k : ℝ) from by norm_cast)
    have hposy : 0 < s.re + (k : ℝ) := by
      have hsk : 3 ≤ (k : ℝ) := Nat.cast_le.mpr hk
      linarith [hsre, hsk]
    have hae : ∀ᶠ (M : ℝ) in atTop,
        ‖((M : ℝ) : ℂ) ^ (-s - k)‖ = M ^ (-(s.re + (k : ℝ))) := by
      filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with M hM
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hM (-s - k), hexp]
    have hae2 : (fun x : ℝ => x ^ (-(s.re + (k : ℝ)))) =ᶠ[atTop]
        (fun M : ℝ => ‖((M : ℝ) : ℂ) ^ (-s - k)‖) := by
      filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with M hM
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hM (-s - k), hexp]
    have hnorm : Tendsto (fun M : ℝ => ‖((M : ℝ) : ℂ) ^ (-s - k)‖) atTop (𝓝 (0 : ℝ)) :=
      Tendsto.congr' hae2 (tendsto_rpow_neg_atTop hposy)
    exact (NormedAddGroup.tendsto_nhds_zero (α := ℝ) (E := ℂ)).mpr fun ε hε => by
      have hball : ((fun M : ℝ => ‖((M : ℝ) : ℂ) ^ (-s - k)‖)) ⁻¹'
          Metric.ball (0 : ℝ) ε ∈ atTop := by
        exact ((tendsto_def.mp hnorm) (Metric.ball (0 : ℝ) ε) (Metric.ball_mem_nhds (0 : ℝ) hε))
      change {M : ℝ | ‖((M : ℝ) : ℂ) ^ (-s - k)‖ < ε} ∈ atTop
      exact mem_of_superset hball (by
        intro M hM
        simpa using hM)

  --/ (3B.4) the S8 period sum equals the B8 interval integral (the h1
  --|  architecture of J_finite, B8/B8poly at exponent -8):
  --|  sum over periods j in [n, M) of ∫_j^{j+1} B8poly(x-j) x^{-s-8}
  --|  = ∫_n^M B8(x) x^{-s-8}. -/
  theorem p4_25ae_S8_eq_interval {s : ℂ} (hsre : s.re = 1 / 2) (n M : ℕ) (hn : 0 < n)
      (hnm : n ≤ M) :
      (∑ j ∈ Finset.Ico n M,
          (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))
          = ∫ x in (n : ℝ)..(M : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8) := by
    rw [← sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ)) hnm
      (fun (j : ℕ) hjk => by
        have hco8 : ContinuousOn (fun x : ℝ => (B8 x : ℂ)) (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by
          have hpoly : ContinuousOn
              (fun x : ℝ => (B8poly (x - (j : ℝ)) : ℂ)) (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by
            dsimp only [B8poly]
            fun_prop
          exact ContinuousOn.congr hpoly (by
            intro x hx
            have hxIcc : x ∈ Set.Icc (j : ℝ) (j + 1 : ℝ) :=
              ⟨by simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1,
                by simpa using hx.2⟩
            dsimp only
            rw [B8_of_Icc_int (n := (j : ℕ)) hxIcc])
        have hcohp8 : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 8))
            (Set.Icc (j : ℝ) (j + 1 : ℝ)) := by
          intro x hx
          have hpos : 0 < x := by
            calc 0 < (n : ℝ) := Nat.cast_pos.mpr hn
              _ ≤ (j : ℝ) := Nat.cast_le (α := ℝ) |>.mpr (Set.mem_Ico.mp hjk |>.1)
              _ ≤ x := by
                simpa [show min (j : ℝ) (j + 1) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1
          exact (Complex.continuousAt_ofReal_cpow_const x (-s - 8)
              (Or.inr (ne_of_gt hpos))).continuousWithinAt
        have hco : ContinuousOn (fun x : ℝ => (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))
            (Set.Icc (j : ℝ) ((j + 1 : ℕ) : ℝ)) :=
          (hco8.mul hcohp8).mono (by
            intro x hx
            rw [show (j : ℝ) + 1 = ((j + 1 : ℕ) : ℝ) from (Nat.cast_succ j).symm]
            exact hx)
        exact hco.intervalIntegrable_of_Icc (by norm_num))]
    rw [Finset.sum_congr rfl (fun j _ => by
      rw [(Nat.cast_succ j).symm])]
    apply Finset.sum_congr rfl
    intro j hj
    have hIC : Set.EqOn (fun x : ℝ => (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))
        (fun x : ℝ => (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))
        (Set.uIcc (j : ℝ) ((j + 1 : ℕ) : ℝ)) := by
      intro x hx
      have hxIcc : x ∈ Set.Icc (j : ℝ) (j + 1 : ℝ) :=
        ⟨by simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1,
          by simpa using hx.2⟩
      dsimp only
      rw [B8_of_Icc_int (n := (j : ℕ)) hxIcc]
    exact (intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) hIC)

  --/ (3B.5) the S8 period sum converges to the improper B8 tail integral:
  --|  sum_{j in Ico n M) integral_j^{j+1} B8poly(x-j) x^{-s-8}
  --|  -> integral_{Ioi n} B8 x x^{-s-8} as M -> oo.
  --|  = 3B.4 pointwise (for M >= n) + 3B.2 (real-M passage) + natCast. -/
  theorem p4_25ae_S8_tendsto {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      Tendsto (fun M : ℕ => ∑ j ∈ Finset.Ico n M,
          (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))
          atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))) := by
    have hsre' : s.re > -7 := by
      rw [hsre]
      norm_num
    have hfin := Tendsto.comp
      (p4_B8cpw8_tendsto (s := s) hsre' n hn) (tendsto_natCast_atTop_atTop (R := ℝ))
    have hpoint : (fun M : ℕ => (fun b : ℝ => ∫ x in (n : ℝ)..b,
        (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) (M : ℝ)) =ᶠ[atTop]
        (fun M : ℕ => ∑ j ∈ Finset.Ico n M,
          (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) := by
      filter_upwards [Ici_mem_atTop (n : ℕ)] with M hM
      change ∫ x in (n : ℝ)..(M : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8) =
          ∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))
      rw [p4_25ae_S8_eq_interval (s := s) hsre n M hn hM]
    exact Tendsto.congr' hpoint hfin

  --/ (3B.6) the 25ae T3 limit law (the heart of the Stage-3B M -> oo passage):
  --|  as M -> oo on the critical line, the EM tail integral
  --|  integral_n^M B2 x x^{-s-2} converges to the four-term expression with the
  --|  three n-endpoint boundary terms (sign-flipped) plus the improper B8 tail
  --|  (J_finite pointwise + 3B.3 endpoint vanish + 3B.5 S8 passage +
  --|  Tendsto.add/const_mul/sub). -/
  theorem p4_25ae_J_iota {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      Tendsto (fun M : ℕ => ∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
          atTop (𝓝 (
              ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
                (0 - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
                (0 - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
                (((B8poly 0) / 8) : ℂ) * (0 - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160)
                * (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)))) := by
    set A := ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) with hA
    set B := ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) with hB
    set C := ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
        (((B8poly 0) / 8) : ℂ) with hC
    set D := ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160)
        with hD
    -- the M-endpoint powers vanish (3B.3 + natCast)
    have hv (k : ℕ) (hk : 3 ≤ k) :
        Tendsto (fun M : ℕ => ((M : ℝ) : ℂ) ^ (-s - k)) atTop (𝓝 0) := by
      convert Tendsto.comp (p4_25ae_cpwtendsto0 (s := s) hsre (k := k) hk)
          (tendsto_natCast_atTop_atTop (R := ℝ)) using 1
      funext M
      norm_num [show ↑((k : ℕ) : ℂ) = (k : ℂ) from by norm_cast]
    -- the four summands of the J_finite RHS with their M -> oo limits
    have h3 : Tendsto
        (fun M : ℕ => A * (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3)))
        atTop (𝓝 (A * (0 - ((n : ℝ) : ℂ) ^ (-s - 3)))) :=
      Tendsto.const_mul (A : ℂ) (Tendsto.sub (hv 3 (by norm_num)) (tendsto_const_nhds))
    have h5 : Tendsto
        (fun M : ℕ => B * (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5)))
        atTop (𝓝 (B * (0 - ((n : ℝ) : ℂ) ^ (-s - 5)))) :=
      Tendsto.const_mul (B : ℂ) (Tendsto.sub (hv 5 (by norm_num)) (tendsto_const_nhds))
    have h7 : Tendsto
        (fun M : ℕ => C * (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7)))
        atTop (𝓝 (C * (0 - ((n : ℝ) : ℂ) ^ (-s - 7)))) :=
      Tendsto.const_mul (C : ℂ) (Tendsto.sub (hv 7 (by norm_num)) (tendsto_const_nhds))
    have h8 : Tendsto
        (fun M : ℕ => D * (∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))))
        atTop (𝓝 (D * (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)))) :=
      Tendsto.const_mul (D : ℂ) (p4_25ae_S8_tendsto (s := s) hsre n hn)
    -- the full J_finite-RHS sum with the combined limit
    have hsum := Tendsto.add (Tendsto.add (Tendsto.add h3 h5) h7) h8
    -- pointwise (for M >= n) the LHS equals that sum (J_finite)
    have hpoint : (fun M : ℕ =>
        A * (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
      + B * (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
      + C * (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
      + D * (∑ j ∈ Finset.Ico n M,
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))) =ᶠ[atTop]
        (fun M : ℕ => ∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2)) := by
      filter_upwards [Ici_mem_atTop (n : ℕ)] with M hM
      exact (p4_25ae_J_finite (s := s) hsre n M hn hM).symm
    exact Tendsto.congr' hpoint hsum

  --/ ===== 25ae Stage 3B (cont.) - the I8 bound (comparison against x^{-(17/2)}) =====

  --/ (3B.7a) closed form for the rpow interval integral (FTC-2 via
  --|  integral_eq_of_hasDerivAt_off_countable; no rpow-integral closed form
  --|  exists in mathlib 4.33.1):
  --|  integral_n^M x^{-(17/2)} = (2/15)(n^{-(15/2)} - M^{-(15/2)}), 0 < n <= M.
  --|  Antiderivative: (-2/15) x^{-(15/2)} (hasDerivAt_rpow_const,
  --|  Analysis/SpecialFunctions/Pow/Deriv.lean, locally confirmed 4.33.1). -/
  theorem p4_25ae_int_Icc_rpow172 {n M : ℝ} (hn : 0 < n) (hnm : n ≤ M) :
      (∫ x in n..M, x ^ (-(17 / 2 : ℝ))) =
          (2 / 15 : ℝ) * (n ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ))) := by
    set F := fun x : ℝ => (-2 / 15 : ℝ) * x ^ (-(15 / 2 : ℝ)) with hF
    have hder : ∀ x ∈ Ioo n M, HasDerivAt F ((x : ℝ) ^ (-(17 / 2 : ℝ))) x := by
      intro x hx
      have hxpos : 0 < x := by linarith [hx.1]
      have hrpow := hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos))
          (p := (-(15 / 2 : ℝ)))
      have hc : (-2 / 15 : ℝ) * ((-(15 / 2 : ℝ)) * x ^ (-(15 / 2 : ℝ) - 1)) =
          (x : ℝ) ^ (-(17 / 2 : ℝ)) := by
        rw [show (-(15 / 2 : ℝ)) - 1 = (-(17 / 2 : ℝ)) from by ring]
        ring
      exact (HasDerivAt.const_mul ((-2 / 15 : ℝ)) hrpow).congr_deriv hc
    have hFcont : ContinuousOn F (Set.Icc n M) := by
      intro x hx
      have hxpos : 0 < x := by linarith [hx.1]
      dsimp only [F]
      exact (HasDerivAt.const_mul ((-2 / 15 : ℝ))
          (hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos)) (p := (-(15 / 2 : ℝ))))).continuousAt.continuousWithinAt
    have hfcont : ContinuousOn (fun x : ℝ => x ^ (-(17 / 2 : ℝ))) (Set.Icc n M) := by
      intro x hx
      have hxpos : 0 < x := by linarith [hx.1]
      exact (hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos))
          (p := (-(17 / 2 : ℝ)))).continuousAt.continuousWithinAt
    have hFTC : (∫ x in n..M, (fun x : ℝ => x ^ (-(17 / 2 : ℝ))) x) = F M - F n :=
      integral_eq_of_hasDerivAt_off_countable (f := F)
        (f' := fun x : ℝ => x ^ (-(17 / 2 : ℝ))) (a := n) (b := M) (s := (∅ : Set ℝ))
        Set.countable_empty (hFcont.mono ((Set.uIcc_of_le hnm).le))
        (by
          intro x hx
          have hx' : x ∈ Ioo n M := by
            simpa [min_eq_left hnm, max_eq_right hnm, Set.diff_empty] using hx
          exact hder x hx')
        (hfcont.intervalIntegrable_of_Icc (by linarith))
    change (∫ x in n..M, (fun x : ℝ => x ^ (-(17 / 2 : ℝ))) x) =
        (2 / 15 : ℝ) * (n ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ)))
    rw [hFTC]
    dsimp only [F]
    ring

  --/ (3B.7b) the improper value (intervalIntegral_tendsto_integral_Ioi +
  --|  limit-uniqueness, tendsto_nhds_unique; Reals are T2, atTop is NeBot):
  --|  integral_{Ioi n} x^{-(17/2)} = (2/15) n^{-(15/2)} (n >= 1).
  --|  integrableOn_Ioi_rpow_of_lt (a < -1, confirmed online mathlib4 + local 4.33.1)
  --|  + Real.tendsto_rpow_neg_atTop (15/2 > 0). -/
  theorem p4_25ae_int_Ioi_rpow172 (n : ℕ) (hn : 0 < n) :
      (∫ x : ℝ in Set.Ioi (n : ℝ), x ^ (-(17 / 2 : ℝ))) =
          (2 / 15 : ℝ) * (n : ℝ) ^ (-(15 / 2 : ℝ)) := by
    have hInt : IntegrableOn (fun x : ℝ => x ^ (-(17 / 2 : ℝ))) (Set.Ioi (n : ℝ)) :=
      integrableOn_Ioi_rpow_of_lt (by norm_num) (Nat.cast_pos.mpr hn)
    have hIoi : Tendsto (fun M : ℝ => ∫ x in (n : ℝ)..M, x ^ (-(17 / 2 : ℝ)))
        atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), x ^ (-(17 / 2 : ℝ)))) :=
      intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ)) hInt tendsto_id
    have hM : Tendsto (fun M : ℝ => M ^ (-(15 / 2 : ℝ))) atTop (𝓝 0) :=
      tendsto_rpow_neg_atTop (by norm_num)
    have hconst : Tendsto (fun _ : ℝ => (n : ℝ) ^ (-(15 / 2 : ℝ))) atTop
        (𝓝 ((n : ℝ) ^ (-(15 / 2 : ℝ)))) := tendsto_const_nhds
    have hsub0 : Tendsto
        (fun M : ℝ => (n : ℝ) ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ)))
        atTop (𝓝 ((n : ℝ) ^ (-(15 / 2 : ℝ)) - 0)) := Tendsto.sub hconst hM
    have hsub : Tendsto
        (fun M : ℝ => (n : ℝ) ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ)))
        atTop (𝓝 ((n : ℝ) ^ (-(15 / 2 : ℝ)))) :=
      Tendsto.mono_right hsub0 (by
        apply le_of_eq
        exact congrArg (𝓝) (sub_zero _))
    have hformula : Tendsto
        (fun M : ℝ => (2 / 15 : ℝ) * ((n : ℝ) ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ))))
        atTop (𝓝 ((2 / 15 : ℝ) * (n : ℝ) ^ (-(15 / 2 : ℝ)))) :=
      Tendsto.const_mul ((2 / 15 : ℝ)) hsub
    have hae : (fun M : ℝ => (2 / 15 : ℝ) * ((n : ℝ) ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ))))
        =ᶠ[atTop] (fun M : ℝ => ∫ x in (n : ℝ)..M, x ^ (-(17 / 2 : ℝ))) := by
      filter_upwards [Filter.eventually_gt_atTop (n : ℝ)] with M hMn
      exact (p4_25ae_int_Icc_rpow172 (n := (n : ℝ)) (M := M) (Nat.cast_pos.mpr hn)
          (le_of_lt hMn)).symm
    exact tendsto_nhds_unique hIoi (Tendsto.congr' hae hformula)

  --/ (3B.7c) the I8 bound: on the critical line,
  --|  |integral_{Ioi n} B8 x x^{-s-8}| <= n^{-15/2} / 225 (n >= 1).
  --|  Route: |int| <= int|.| (norm_integral_le_integral_norm, verified by
  --|  probe), the norm is integrable on Ioi n by the (1/30) x^{-17/2}
  --|  majorant, every partial integral is <= (1/30)(2/15) n^{-15/2}
  --|  (interval integral_mono_on_of_le_Ioo + 3B.7a + M^{-15/2} >= 0), and
  --|  the order limit follows by an eps-contradiction. -/
  theorem p4_25ae_I8_bound {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      ‖(∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))‖
          ≤ (n : ℝ) ^ (-(15 / 2 : ℝ)) / 225 := by
    set kern := fun x : ℝ => (B8 x : ℂ) * (x : ℂ) ^ (-s - 8) with hkern
    have hre8 : s.re + 8 = (17 / 2 : ℝ) := by
      rw [hsre]
      norm_num
    have hpw : (-s - 8 : ℂ).re = -(s.re + 8) := by
      rw [show (-(s : ℂ) - 8 : ℂ) = -((s : ℂ) + 8) from by ring,
        Complex.neg_re, Complex.add_re,
        show (8 : ℂ).re = 8 from by norm_num]
    -- pointwise majorant for x > 0
    have hest (x : ℝ) (hx : 0 < x) :
        ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖ ≤ (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ)) := by
      calc ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖
          _ = ‖(B8 x : ℂ)‖ * ‖(x : ℂ) ^ (-s - 8)‖ := by rw [norm_mul]
          _ ≤ (1 / 30) * x ^ (-(s.re + 8)) := by
            rw [Complex.norm_cpow_eq_rpow_re_of_pos hx (-s - 8), hpw]
            gcongr
            calc ‖(B8 x : ℂ)‖
                _ = Real.sqrt (B8 x ^ 2) := by
                  rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
                _ = |B8 x| := by rw [Real.sqrt_sq_eq_abs]
                _ ≤ 1 / 30 := abs_B8_le hx.le
          _ = (1 / 30) * x ^ (-(17 / 2 : ℝ)) := by rw [hre8]
    -- (1) |integral| <= the integral of the norm (restricted-measure form;
    --     verified by probe: simpa closes the indicator/variation bridge)
    have h1 : ‖(∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))‖
        ≤ (∫ x : ℝ in Set.Ioi (n : ℝ), ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) := by
      simpa using MeasureTheory.norm_integral_le_integral_norm
          (f := fun x : ℝ => (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))
          (μ := MeasureTheory.volume.restrict (Set.Ioi (n : ℝ)))
    -- (2) the norm is integrable on Ioi n: aes + (1/30) x^{-17/2} majorant
    have h2 : IntegrableOn (fun x : ℝ => ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)
        (Set.Ioi (n : ℝ)) := by
      constructor
      · have hB8aes : AEStronglyMeasurable (fun x : ℝ => (B8 x : ℂ))
            (volume.restrict (Set.Ioi (n : ℝ))) := by
          exact (AEStronglyMeasurable.mono_measure
            (Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)
              (aestronglyMeasurable_B8 : AEStronglyMeasurable B8))
            ((Measure.restrict_mono (Set.Ioi (n : ℝ)).subset_univ le_rfl).trans
              (le_of_eq Measure.restrict_univ)))
        have hcpwcont : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 8))
            (Set.Ioi (n : ℝ)) := by
          intro x hx
          have hcxt : (n : ℝ) < x := Set.mem_Ioi.mp hx
          have h0x : 0 < x := (Nat.cast_pos (α := ℝ).mpr hn).trans hcxt
          exact (Complex.continuousAt_ofReal_cpow_const x (-s - 8)
              (Or.inr (ne_of_gt h0x))).continuousWithinAt
        have hcpwae : AEStronglyMeasurable (fun x : ℝ => (x : ℂ) ^ (-s - 8))
            (volume.restrict (Set.Ioi (n : ℝ))) :=
          ContinuousOn.aestronglyMeasurable hcpwcont measurableSet_Ioi
        exact
          (Continuous.comp_aestronglyMeasurable (by continuity) (hB8aes.mul hcpwae))
      · have hMajor : HasFiniteIntegral
            (fun x : ℝ => (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ)))
            (volume.restrict (Set.Ioi (n : ℝ))) :=
          Integrable.hasFiniteIntegral
            (integrableOn_Ioi_rpow_of_lt (by norm_num) (Nat.cast_pos (α := ℝ).mpr hn)
              |>.integrable.const_mul (1 / 30 : ℝ))
        exact HasFiniteIntegral.mono' hMajor (by
          rw [ae_restrict_iff' measurableSet_Ioi]
          exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ))
            (fun x hx => by
              have hxpos : 0 < x := (Nat.cast_pos (α := ℝ).mpr hn).trans (Set.mem_Ioi.mp hx)
              have hestx := hest x hxpos
              have hnon : 0 ≤ ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖ := norm_nonneg _
              rw [show ‖(‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)‖ =
                      |(‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)| from by rfl,
                abs_of_nonneg hnon]
              exact hestx))
    -- (3) the partial integrals of the norm converge to the Ioi integral
    have h3 : Tendsto
        (fun M : ℝ => ∫ x in (n : ℝ)..M, ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)
        atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)) :=
      intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ)) h2 tendsto_id
    -- (4) every partial integral is <= (1/30)(2/15) n^{-15/2}
    have hwall (M : ℝ) (hMn : (n : ℝ) < M) :
        (∫ x in (n : ℝ)..M, ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) ≤
            (1 / 30 : ℝ) * (2 / 15 : ℝ) * (n : ℝ) ^ (-(15 / 2 : ℝ)) := by
      have hf : IntervalIntegrable
          (fun x : ℝ => ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) volume (n : ℝ) M := by
        rw [intervalIntegrable_iff]
        refine IntegrableOn.mono_set_ae h2 ?_
        show Set.uIoc (n : ℝ) M ≤ᵐ[volume] Set.Ioi (n : ℝ)
        -- Ioc here is open-closed ({n < x <= M}), contained in Ioi n
        rw [Set.uIoc_of_le (le_of_lt hMn)]
        exact (MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx => by
          have hx1 : (n : ℝ) < x ∧ x ≤ M := by
            dsimp only [Set.Ioc] at hx
            exact hx
          dsimp only [Set.Ioi]
          exact hx1.1))
      have hg : IntervalIntegrable
          (fun x : ℝ => (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ))) volume (n : ℝ) M := by
        have hgc : ContinuousOn (fun x : ℝ => (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ)))
            (Set.Icc (n : ℝ) M) := by
          have hrpow : ContinuousOn (fun x : ℝ => x ^ (-(17 / 2 : ℝ)))
              (Set.Icc (n : ℝ) M) := by
            intro x hx
            have hxpos : 0 < x := by
              linarith [hx.1, Nat.cast_pos (α := ℝ).mpr hn]
            have hder := (hasDerivAt_rpow_const (Or.inl (ne_of_gt hxpos))
              (p := (-(17 / 2 : ℝ))) :
                HasDerivAt (fun x : ℝ => x ^ (-(17 / 2 : ℝ))) _ x)
            exact hder.continuousAt.continuousWithinAt
          exact continuousOn_const.mul hrpow
        have hIcc : IntervalIntegrable
            (fun x : ℝ => (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ))) volume (n : ℝ) M :=
          hgc.intervalIntegrable_of_Icc (by linarith)
        rw [intervalIntegrable_iff] at hIcc ⊢
        exact hIcc
      calc (∫ x in (n : ℝ)..M, ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖)
          _ ≤ (∫ x in (n : ℝ)..M, (1 / 30 : ℝ) * x ^ (-(17 / 2 : ℝ))) := by
            apply integral_mono_on_of_le_Ioo
            · exact by linarith [hMn]
            · exact hf
            · exact hg
            · intro x hx
              have hxpos : 0 < x := by
                rw [Set.mem_Ioo] at hx
                linarith [hx.1, Nat.cast_pos (α := ℝ).mpr hn]
              exact hest x hxpos
          _ = (1 / 30 : ℝ) * (2 / 15 : ℝ) *
                ((n : ℝ) ^ (-(15 / 2 : ℝ)) - M ^ (-(15 / 2 : ℝ))) := by
            rw [intervalIntegral.integral_const_mul,
              p4_25ae_int_Icc_rpow172 (n := (n : ℝ)) (M := M)
                (Nat.cast_pos (α := ℝ).mpr hn) (le_of_lt hMn)]
            ring
          _ ≤ (1 / 30 : ℝ) * (2 / 15 : ℝ) * (n : ℝ) ^ (-(15 / 2 : ℝ)) := by
            have h0M : 0 < M := lt_trans (Nat.cast_pos (α := ℝ).mpr hn) hMn
            have hMpow : 0 ≤ M ^ (-(15 / 2 : ℝ)) :=
              rpow_nonneg h0M.le (-(15 / 2 : ℝ))
            ring_nf
            have hCMpow : 0 ≤ (1 / 30 : ℝ) * (2 / 15 : ℝ) * M ^ (-(15 / 2 : ℝ)) :=
              mul_nonneg (by norm_num) hMpow
            nlinarith [hCMpow]
    -- (5) order limit: the Ioi integral is <= the constant (eps-contradiction)
    set C := (1 / 30 : ℝ) * (2 / 15 : ℝ) * (n : ℝ) ^ (-(15 / 2 : ℝ)) with hC
    set L := (∫ x : ℝ in Set.Ioi (n : ℝ), ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) with hL
    have hLraw : L = (∫ x : ℝ in Set.Ioi (n : ℝ),
        ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) := by rfl
    set gpart := fun (M : ℝ) => (∫ x in (n : ℝ)..M, ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) with hgpart
    have hlim : L ≤ C := by
      by_contra hgt
      have hI : C < L := by linarith
      set hε := (L - C) / 2 with hhε
      have hεpos : 0 < hε := by linarith
      have hball : ∀ᶠ (M : ℝ) in atTop, dist (gpart M) L < hε := by
        simpa [gpart, ← hLraw] using
          (tendsto_def.mp h3 (Metric.ball L hε) (by
            rw [hLraw]
            exact Metric.ball_mem_nhds L hεpos))
      have hpt : ∀ᶠ (M : ℝ) in atTop, gpart M ≤ C := by
        filter_upwards [Filter.eventually_gt_atTop (n : ℝ)] with M hMn
        simpa [gpart] using hwall M hMn
      set PQ := fun (M : ℝ) => (dist (gpart M) L < hε) ∧ (gpart M ≤ C) with hPQ
      have hboth : ∀ᶠ (M : ℝ) in atTop, PQ M := hball.and hpt
      obtain ⟨a0, ha0⟩ := (eventually_atTop (p := PQ)).mp hboth
      have hmax0 : (n : ℝ) < max a0 ((n : ℝ) + 1) := by
        linarith [le_max_right a0 ((n : ℝ) + 1), show (0 : ℝ) < 1 by norm_num]
      have hle0 : a0 ≤ max a0 ((n : ℝ) + 1) := le_max_left a0 ((n : ℝ) + 1)
      have hM0P : dist (gpart (max a0 ((n : ℝ) + 1))) L < hε :=
        (ha0 (max a0 ((n : ℝ) + 1)) hle0).1
      have hM0Q : gpart (max a0 ((n : ℝ) + 1)) ≤ C :=
        (ha0 (max a0 ((n : ℝ) + 1)) hle0).2
      have hdle : dist (gpart (max a0 ((n : ℝ) + 1))) L ≤ hε := le_of_lt hM0P
      rw [dist_eq_norm] at hdle
      have hl : -(hε) ≤ gpart (max a0 ((n : ℝ) + 1)) - L := (abs_le.mp hdle).1
      have hlow : L - hε ≤ gpart (max a0 ((n : ℝ) + 1)) := by linarith [hl]
      nlinarith [hlow, hM0Q, hI, hhε]
    calc ‖(∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8))‖
        _ ≤ (∫ x : ℝ in Set.Ioi (n : ℝ),
            ‖(B8 x : ℂ) * (x : ℂ) ^ (-s - 8)‖) := h1
        _ ≤ C := by simpa [hLraw] using hlim
        _ = (n : ℝ) ^ (-(15 / 2 : ℝ)) / 225 := by
          rw [hC]
          ring

  --/ (3B.9a) the bare T3 kernel is integrable on Ioi c for s.re > -1
  --|  (L3.e pattern, without the s(s+1) factor of p4_f2). -/
  theorem p4_25ae_t3kernel_integrableOn_Ioi {s : ℂ} (hsre : s.re > -1) {c : ℝ}
      (hc : 0 < c) :
      IntegrableOn (fun x : ℝ => (B2 x : ℂ) * (x : ℂ) ^ (-s - 2)) (Set.Ioi c) := by
    have hB2aes : AEStronglyMeasurable (fun x : ℝ => (B2 x : ℂ))
        (volume.restrict (Set.Ioi c)) := by
      exact (AEStronglyMeasurable.mono_measure
        (Continuous.comp_aestronglyMeasurable (hg := Complex.continuous_ofReal)
          (aestronglyMeasurable_B2 : AEStronglyMeasurable B2))
        ((Measure.restrict_mono (Set.Ioi c).subset_univ le_rfl).trans
          (le_of_eq Measure.restrict_univ)))
    have hcpwcont : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - 2)) (Set.Ioi c) := by
      intro x hx
      have hcx : c < x := Set.mem_Ioi.mp hx
      have h0x : 0 < x := hc.trans hcx
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - 2)
          (Or.inr (ne_of_gt h0x))).continuousWithinAt
    have hcpwae : AEStronglyMeasurable (fun x : ℝ => (x : ℂ) ^ (-s - 2))
        (volume.restrict (Set.Ioi c)) :=
      ContinuousOn.aestronglyMeasurable hcpwcont measurableSet_Ioi
    have hRpow : Integrable (fun x : ℝ => x ^ (-(s.re + 2)))
        (volume.restrict (Set.Ioi c)) :=
      (integrableOn_Ioi_rpow_of_lt (by linarith) hc).integrable
    have hMajor : HasFiniteIntegral (fun x : ℝ => (1 / 6 : ℝ) * x ^ (-(s.re + 2)))
        (volume.restrict (Set.Ioi c)) :=
      Integrable.hasFiniteIntegral ((hRpow).const_mul ((1 / 6 : ℝ)))
    constructor
    · exact hB2aes.mul hcpwae
    · rw [← hasFiniteIntegral_norm_iff]
      exact HasFiniteIntegral.mono' hMajor (by
        rw [ae_restrict_iff' measurableSet_Ioi]
        exact MeasureTheory.ae_of_all (μ := (volume : Measure ℝ)) (fun x hx => by
          have hxpos : 0 < x := hc.trans (Set.mem_Ioi.mp hx)
          have hpw2 : (-s - 2 : ℂ).re = -(s.re + 2) := by
            rw [show (-(s : ℂ) - 2 : ℂ) = -((s : ℂ) + 2) from by ring,
              Complex.neg_re, Complex.add_re,
              show (2 : ℂ).re = 2 from by norm_num]
          have h1 : ‖(‖(B2 x : ℂ) * (x : ℂ) ^ (-s - 2)‖ : ℝ)‖ =
              ‖(B2 x : ℂ) * (x : ℂ) ^ (-s - 2)‖ := by simp
          rw [h1]
          calc ‖(B2 x : ℂ) * (x : ℂ) ^ (-s - 2)‖
              _ = ‖(B2 x : ℂ)‖ * ‖(x : ℂ) ^ (-s - 2)‖ := by rw [norm_mul]
              _ ≤ (1 / 6) * x ^ (-(s.re + 2)) := by
                rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos (-s - 2), hpw2]
                gcongr
                calc ‖(B2 x : ℂ)‖
                    _ = Real.sqrt (B2 x ^ 2) := by
                      rw [Complex.norm_def, Complex.normSq_ofReal, ← pow_two]
                    _ = |B2 x| := by rw [Real.sqrt_sq_eq_abs]
                    _ ≤ 1 / 6 := abs_B2_le hxpos.le))

  --/ (3B.9b) the improper T3 integral: the finite integrals converge to it,
  --|  so by limit uniqueness the Ioi integral equals the 4-term J_iota
  --|  expression. -/
  theorem p4_25ae_J_eq {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2)) =
          ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
              (0 - ((n : ℝ) : ℂ) ^ (-s - 3))
        + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
              (0 - ((n : ℝ) : ℂ) ^ (-s - 5))
        + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
              (((B8poly 0) / 8) : ℂ) * (0 - ((n : ℝ) : ℂ) ^ (-s - 7))
        + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160)
              * (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) := by
    set T :=
        ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
            (0 - ((n : ℝ) : ℂ) ^ (-s - 3))
      + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
            (0 - ((n : ℝ) : ℂ) ^ (-s - 5))
      + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
            (((B8poly 0) / 8) : ℂ) * (0 - ((n : ℝ) : ℂ) ^ (-s - 7))
      + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160)
            * (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) with hT
    have hj := p4_25ae_J_iota hsre n hn
    -- the finite T3 integrals also tend to the improper integral (L3.f route)
    have hsre1 : s.re > -1 := by
      rw [hsre]
      norm_num
    have hInt := p4_25ae_t3kernel_integrableOn_Ioi hsre1 (Nat.cast_pos.mpr hn)
    have hlt : Tendsto
        (fun M : ℝ => ∫ x in (n : ℝ)..M, (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))) :=
      intervalIntegral_tendsto_integral_Ioi (a := (n : ℝ)) hInt tendsto_id
    have hlnat : Tendsto
        (fun M : ℕ => ∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        atTop (𝓝 (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))) :=
      Tendsto.comp hlt (tendsto_natCast_atTop_atTop (R := ℝ))
    -- same finite function, two limits (T and the Ioi integral)
    have hcong : Tendsto
        (fun M : ℕ => ∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        atTop (𝓝 T) :=
      Tendsto.congr' (by
        filter_upwards [Ici_mem_atTop (n : ℕ)] with M hM
        simp only [hT]) hj
    exact (tendsto_nhds_unique hcong hlnat).symm

  --/ (3B.10) the sharpened T3 bound on the critical line (25ae F1): with
  --|  T3(s, n) := -(1/2)·s(s+1)·∫_n^∞ B2(x)·x^{-s-2} dx,
  --|  |T3| <= |s(s+1)(s+2)| n^{-7/2}/720
  --|        + |s(s+1)(s+2)(s+3)(s+4)| n^{-11/2}/30240
  --|        + |s(s+1)(s+2)..(s+6)| n^{-15/2}/1209600
  --|        + |s(s+1)(s+2)..(s+6)(s+7)| n^{-15/2}/9072000.
  --|  Uses J_eq (4-term decomposition), I8_bound for the residual integral,
  --|  and the endpoint values B4(0)=-1/30, B6(0)=1/42, B8(0)=-1/30. -/
  theorem p4_25ae_T3_bound {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      ‖(-(1 / 2 : ℂ) * s * (s + 1)) *
        (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))‖ ≤
          ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
            (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
            (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
            (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
    set F8 := (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) with hF8
    set A' := ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) with hA
    set B' := ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) with hB
    set C' := ((s + 2 : ℂ) * (((s + 3) * (((s + 4) * (((s + 5) * ((s + 6)))))))) / 2520) *
        (((B8poly 0) / 8) : ℂ) with hC
    set D' := (s + 2 : ℂ) * (((s + 3) * (((s + 4) * (((s + 5) * (((s + 6) * ((s + 7)))))))))) / 20160
        with hD
    set U3 := A' * (0 - ((n : ℝ) : ℂ) ^ (-s - 3)) with hU3
    set U5 := B' * (0 - ((n : ℝ) : ℂ) ^ (-s - 5)) with hU5
    set U7 := C' * (0 - ((n : ℝ) : ℂ) ^ (-s - 7)) with hU7
    set U8 := D' * F8 with hU8
    set K4 := U3 + (U5 + (U7 + U8)) with hK4
    rw [p4_25ae_J_eq hsre n hn]
    -- bridge the J_eq RHS (left-associated U3+U5+U7+U8) to K4
    rw [show ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
            (0 - ((n : ℝ) : ℂ) ^ (-s - 3)) +
          ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
            (0 - ((n : ℝ) : ℂ) ^ (-s - 5)) +
          ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
            (((B8poly 0) / 8) : ℂ) * (0 - ((n : ℝ) : ℂ) ^ (-s - 7)) +
          ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
            (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) = K4 from by
      dsimp only [K4, U3, U5, U7, U8, A', B', C', D', F8]
      ring]
    have hneg : ‖-((1 / 2 : ℂ) * s * (s + 1) * K4)‖ = ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖ :=
      norm_neg _
    rw [show -(1 / 2 : ℂ) * s * (s + 1) * K4 =
        -((1 / 2 : ℂ) * s * (s + 1) * K4) from by ring, hneg]
    -- (a) norm of the endpoint powers
    have hN3 : ‖((n : ℝ) : ℂ) ^ (-s - 3)‖ = (n : ℝ) ^ (-(7 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 3),
        show (-s - 3 : ℂ).re = -(7 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 3 : ℂ) = -((s : ℂ) + 3) from by ring,
            Complex.neg_re, Complex.add_re,
            show (3 : ℂ).re = 3 from by norm_num]
          rw [hsre]
          norm_num]
    have hN5 : ‖((n : ℝ) : ℂ) ^ (-s - 5)‖ = (n : ℝ) ^ (-(11 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 5),
        show (-s - 5 : ℂ).re = -(11 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 5 : ℂ) = -((s : ℂ) + 5) from by ring,
            Complex.neg_re, Complex.add_re,
            show (5 : ℂ).re = 5 from by norm_num]
          rw [hsre]
          norm_num]
    have hN7 : ‖((n : ℝ) : ℂ) ^ (-s - 7)‖ = (n : ℝ) ^ (-(15 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 7),
        show (-s - 7 : ℂ).re = -(15 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 7 : ℂ) = -((s : ℂ) + 7) from by ring,
            Complex.neg_re, Complex.add_re,
            show (7 : ℂ).re = 7 from by norm_num]
          rw [hsre]
          norm_num]
    -- (b) coefficient-norm computations
    have hca : ‖(((B4poly 0) / 4) : ℂ)‖ = (1 : ℝ) / 120 := by
      rw [show (((B4poly 0) / 4) : ℂ) = (-(1 / 120 : ℝ) : ℂ) from by
        rw [B4poly_at_0]
        norm_num]
      norm_num
    have hA1 : ‖A'‖ = ‖s + 2‖ / 360 := by
      rw [hA, norm_mul, hca, norm_div]
      norm_num
      ring
    have hcb : ‖(((B6poly 0) / 6) : ℂ)‖ = (1 : ℝ) / 252 := by
      rw [show (((B6poly 0) / 6) : ℂ) = ((1 / 252 : ℝ) : ℂ) from by
        rw [B6poly_at_0]
        norm_num]
      norm_num
    have hB1 : ‖B'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ / 15120 := by
      rw [hB, norm_mul, hcb, norm_div]
      norm_num
      rw [← norm_mul, ← norm_mul]
      ring
    have hcc : ‖(((B8poly 0) / 8) : ℂ)‖ = (1 : ℝ) / 240 := by
      rw [show (((B8poly 0) / 8) : ℂ) = (-(1 / 240 : ℝ) : ℂ) from by
        rw [B8poly_at_0]
        norm_num]
      norm_num
    have hC1 : ‖C'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ / 604800 := by
      rw [hC, norm_mul, hcc, norm_div]
      norm_num
      repeat' rw [norm_mul]
      ring
    have hD1 : ‖D'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖ / 20160 := by
      rw [hD, norm_div]
      norm_num
      repeat' rw [norm_mul]
      ring
    -- (c) product-norm forms of the target coefficients
    have hprod3 : ‖s * (s + 1) * (s + 2)‖ = ‖s‖ * ‖s + 1‖ * ‖s + 2‖ := by
      rw [norm_mul, norm_mul]
    have hprod5 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) =
          s * (((s + 1) * (((s + 2) * (((s + 3) * ((s + 4)))))))) from by ring]
      repeat' rw [norm_mul]
      ring
    have hprod7 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) =
          s * (((s + 1) * (((s + 2) * (((s + 3) * (((s + 4) * (((s + 5) * ((s + 6)))))))))))) from by ring]
      repeat' rw [norm_mul]
      ring
    have hprod8 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) =
          s * (((s + 1) * (((s + 2) * (((s + 3) * (((s + 4) * (((s + 5) * (((s + 6) * ((s + 7)))))))))))))) from by ring]
      repeat' rw [norm_mul]
      ring
    -- (d) the four termwise bounds
    have hT1 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ ≤
        ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 := by
      have hcalc : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ =
          ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 := by
        calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖A'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 3)‖) := by
            rw [hU3, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 3)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 3)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ / 360) * (n : ℝ) ^ (-(7 : ℝ) / 2)) := by
            rw [hA1, hN3]
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖) / 720 * (n : ℝ) ^ (-(7 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 := by
            rw [← hprod3]
            ring
      exact le_of_eq hcalc
    have hT2 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ * (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 := by
      have hcalc : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ =
          ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ * (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 := by
        calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖B'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 5)‖) := by
            rw [hU5, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 5)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 5)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ / 15120) *
                (n : ℝ) ^ (-(11 : ℝ) / 2)) := by
            rw [hB1, hN5]
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖) / 30240 *
              (n : ℝ) ^ (-(11 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 := by
            rw [← hprod5]
            ring
      exact le_of_eq hcalc
    have hT3 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 := by
      have hcalc : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖ =
          ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 := by
        calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖C'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 7)‖) := by
            rw [hU7, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 7)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 7)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ / 604800) *
                (n : ℝ) ^ (-(15 : ℝ) / 2)) := by
            rw [hC1, hN7]
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ *
              ‖s + 6‖) / 1209600 * (n : ℝ) ^ (-(15 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 := by
            rw [← hprod7]
            ring
      exact le_of_eq hcalc
    have hI8 := p4_25ae_I8_bound hsre n hn
    have hT4a : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ‖F8‖ ≤
        (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := by
      have heq : -(15 / 2 : ℝ) = (-(15 : ℝ) / 2) := by norm_num
      have hI8b : ‖F8‖ ≤ (n : ℝ) ^ (-(15 : ℝ) / 2) / 225 := by
        dsimp only [F8]
        simpa [heq] using hI8
      apply mul_le_mul_of_nonneg_left hI8b
      positivity
    have hT4b : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
        ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
      calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
          ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225)
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖) / 20160) *
              ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := by
            rw [hD1]
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ *
      ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖) / 9072000 *
              (n : ℝ) ^ (-(15 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) *
                (s + 6) * (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
            rw [← hprod8]
            ring
          _ ≤ ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) *
                (s + 6) * (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := le_rfl
    have hT4 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
      rw [show (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ =
          (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ‖F8‖ from by
            rw [hU8, norm_mul]
            ring]
      calc _
          _ ≤ (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
              ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := hT4a
          _ ≤ ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) *
                (s + 6) * (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := hT4b
    -- (e) the triangle decomposition of K4
    have htri : ‖K4‖ ≤ ‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖) := by
      calc ‖K4‖
          _ = ‖U3 + (U5 + (U7 + U8))‖ := by rw [hK4]
          _ ≤ ‖U3‖ + ‖U5 + (U7 + U8)‖ := norm_add_le U3 (U5 + (U7 + U8))
          _ ≤ ‖U3‖ + (‖U5‖ + ‖U7 + U8‖) := by
            apply add_le_add (le_rfl : _ ≤ _)
            exact (norm_add_le U5 (U7 + U8))
          _ ≤ ‖U3‖ + (‖U5‖ + (‖U7‖ + ‖U8‖)) := by
            apply add_le_add (le_rfl : _ ≤ _)
            apply add_le_add (le_rfl : _ ≤ _)
            exact (norm_add_le U7 U8)
          _ = ‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖) := by ring
          _ ≤ ‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖) := le_rfl
    -- (f) the prefactor norm
    have hpref : ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖ =
        (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := by
      calc ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖
          _ = ‖(1 / 2 : ℂ) * s * (s + 1)‖ * ‖K4‖ := by rw [norm_mul]
          _ = (‖(1 / 2 : ℂ) * s‖ * ‖s + 1‖) * ‖K4‖ := by rw [norm_mul]
          _ = ((‖(1 / 2 : ℂ)‖ * ‖s‖) * ‖s + 1‖) * ‖K4‖ := by rw [norm_mul]
          _ = ((1 / 2 : ℝ) * ‖s‖) * ‖s + 1‖ * ‖K4‖ := by
            rw [show ‖(1 / 2 : ℂ)‖ = (1 / 2 : ℝ) from by norm_num]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := by ring
    calc ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖
        _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := hpref
        _ ≤ (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
            (‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖)) := by
          apply mul_le_mul_of_nonneg_left htri
          positivity
        _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
            ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ +
              (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖) +
            (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ := by ring
        _ ≤ ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
            (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 +
              (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
                  (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000)) := by
          calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
                  ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖) +
                  (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖
              _ = ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖) +
                  ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖) := by ring
              _ ≤ (‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
                    ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
                      (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240) +
                  (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                      (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                      ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) *
                        (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000) := by
                apply add_le_add
                · exact add_le_add hT1 hT2
                · exact add_le_add hT3 hT4
              _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
                  (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
                    (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 +
                    (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                      (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                      ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) *
                        (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000)) := by ring
        _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(11 : ℝ) / 2) / 30240 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by ring

/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t <= 13), four bands.  Endpoint constants (records in
   scripts/rh/day026_25ae_t3wall.py, exact Fraction + isqrt):
   t3w_qB_r = strict rational upper bound of sqrt(t3w_prod t* r) at the band
   endpoint t*; t3w_rB_r = strict rational upper bound of (n_min)^(-p_r).
   The product indices i in {2,4,6,7} match the four terms of
   p4_25ae_T3_bound (3, 5, 7, 8 factors; i = 7 is the |S6|*|s+7| product).
   Every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2). -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 7 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 7 then 9072000 else 1

/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The sharpened 4-term bound. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7

/-- t3w_prod is increasing for 0 <= t <= t′. -/
theorem t3w_prod_mono {t t' : ℝ} (h0 : 0 <= t) (h : t <= t') (i : ℕ) :
    t3w_prod t i <= t3w_prod t' i := by
  dsimp only [t3w_prod]
  gcongr
  all_goals nlinarith [sq_le_sq (by linarith [h0]) (by linarith [h0, h])]

/-- n^{-p} <= 1 for n >= 1 and p > 0. -/
theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :
    (n : ℝ) ^ (-p) <= 1 := by
  have h1p : (1 : ℝ) <= (n : ℝ) ^ p := Real.one_le_rpow (by exact_mod_cast hn) hp.le
  calc
    (n : ℝ) ^ (-p) = ((n : ℝ) ^ p)⁻¹ := by rw [rpow_neg (Nat.cast_nonneg n)]
    _ = 1 / (n : ℝ) ^ p := by rw [inv_eq_one_div]
    _ <= 1 / 1 := (one_div_le_one_div (by positivity) (by norm_num : 0 < (1 : ℝ))).mpr h1p
    _ = 1 := by norm_num

def t3w_qA1_2 : ℝ := (2218821909 : ℝ) / 308915776
def t3w_rA1_2 : ℝ := (1 : ℝ) / 1
def t3w_qA1_4 : ℝ := (17550033412413605 : ℝ) / 141167095653376
def t3w_rA1_4 : ℝ := (1 : ℝ) / 1
def t3w_qA1_6 : ℝ := (149512256733405629341179 : ℝ) / 32254987351648575488
def t3w_rA1_6 : ℝ := (1 : ℝ) / 1
def t3w_qA1_7 : ℝ := (1536332078500642084460770895 : ℝ) / 43608742899428874059776
def t3w_rA1_7 : ℝ := (1 : ℝ) / 1

theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < t3w_qA1_2 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) < t3w_qA1_4 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) < t3w_qA1_6 ∧
    Real.sqrt (t3w_prod (16 / 13) 7) < t3w_qA1_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7])).mpr (by norm_num [t3w_prod, t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7])

def t3w_qA2_2 : ℝ := (5199 : ℝ) / 64
def t3w_rA2_2 : ℝ := (1 : ℝ) / 8
def t3w_qA2_4 : ℝ := (2661867 : ℝ) / 1024
def t3w_rA2_4 : ℝ := (1 : ℝ) / 32
def t3w_qA2_6 : ℝ := (2210599813 : ℝ) / 16384
def t3w_rA2_6 : ℝ := (1 : ℝ) / 128
def t3w_qA2_7 : ℝ := (75160393639 : ℝ) / 65536
def t3w_rA2_7 : ℝ := (1 : ℝ) / 128

theorem t3w_qA2 :
    Real.sqrt (t3w_prod (4) 2) < t3w_qA2_2 ∧
    Real.sqrt (t3w_prod (4) 4) < t3w_qA2_4 ∧
    Real.sqrt (t3w_prod (4) 6) < t3w_qA2_6 ∧
    Real.sqrt (t3w_prod (4) 7) < t3w_qA2_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7])).mpr (by norm_num [t3w_prod, t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7])

def t3w_qA3_2 : ℝ := (17499 : ℝ) / 32
def t3w_rA3_2 : ℝ := (1 : ℝ) / 432
def t3w_qA3_4 : ℝ := (22440241 : ℝ) / 512
def t3w_rA3_4 : ℝ := (1 : ℝ) / 15552
def t3w_qA3_6 : ℝ := (17964810777 : ℝ) / 4096
def t3w_rA3_6 : ℝ := (1 : ℝ) / 559872
def t3w_qA3_7 : ℝ := (3151992477389 : ℝ) / 65536
def t3w_rA3_7 : ℝ := (1 : ℝ) / 559872

theorem t3w_qA3 :
    Real.sqrt (t3w_prod (8) 2) < t3w_qA3_2 ∧
    Real.sqrt (t3w_prod (8) 4) < t3w_qA3_4 ∧
    Real.sqrt (t3w_prod (8) 6) < t3w_qA3_6 ∧
    Real.sqrt (t3w_prod (8) 7) < t3w_qA3_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7])).mpr (by norm_num [t3w_prod, t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7])

def t3w_qA4_2 : ℝ := (144241 : ℝ) / 64
def t3w_rA4_2 : ℝ := (1 : ℝ) / 6591
def t3w_qA4_4 : ℝ := (213715271 : ℝ) / 512
def t3w_rA4_4 : ℝ := (1 : ℝ) / 1113879
def t3w_qA4_6 : ℝ := (701541006115 : ℝ) / 8192
def t3w_rA4_6 : ℝ := (1 : ℝ) / 188245551
def t3w_qA4_7 : ℝ := (42115838574947 : ℝ) / 32768
def t3w_rA4_7 : ℝ := (1 : ℝ) / 188245551

theorem t3w_qA4 :
    Real.sqrt (t3w_prod (13) 2) < t3w_qA4_2 ∧
    Real.sqrt (t3w_prod (13) 4) < t3w_qA4_4 ∧
    Real.sqrt (t3w_prod (13) 6) < t3w_qA4_6 ∧
    Real.sqrt (t3w_prod (13) 7) < t3w_qA4_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7])).mpr (by norm_num [t3w_prod, t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7])

/-- A1: 1 <= t < 16 / 13 (n >= 1). -/
theorem t3w_wall_A1 {t : ℝ} (ht : 1 <= t) (htb : t < 16 / 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 78 := by
  have hnmin : 1 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (1 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 16 / 13 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA1_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA1.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA1_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA1.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA1_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA1.2.2.1
  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA1_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA1.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA1_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
      _ <= t3w_rA1_2 := by norm_num [t3w_rA1_2]
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA1_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
      _ <= t3w_rA1_4 := by norm_num [t3w_rA1_4]
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
      _ <= t3w_rA1_6 := by norm_num [t3w_rA1_6]
  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
      _ <= t3w_rA1_7 := by norm_num [t3w_rA1_7]
  have hT2 : t3w_term n t 2 < t3w_qA1_2 * t3w_rA1_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA1_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num [t3w_rA1_2]) <;> (try positivity)
      _ < t3w_qA1_2 * (t3w_rA1_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num [t3w_qA1_2, t3w_rA1_2]) <;> (try positivity)
  have hT4 : t3w_term n t 4 < t3w_qA1_4 * t3w_rA1_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA1_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num [t3w_rA1_4]) <;> (try positivity)
      _ < t3w_qA1_4 * (t3w_rA1_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num [t3w_qA1_4, t3w_rA1_4]) <;> (try positivity)
  have hT6 : t3w_term n t 6 < t3w_qA1_6 * t3w_rA1_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA1_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num [t3w_rA1_6]) <;> (try positivity)
      _ < t3w_qA1_6 * (t3w_rA1_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num [t3w_qA1_6, t3w_rA1_6]) <;> (try positivity)
  have hT7 : t3w_term n t 7 < t3w_qA1_7 * t3w_rA1_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA1_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num [t3w_rA1_7]) <;> (try positivity)
      _ < t3w_qA1_7 * (t3w_rA1_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num [t3w_qA1_7, t3w_rA1_7]) <;> (try positivity)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA1_2 * (t3w_rA1_2 : ℝ) / 720 + t3w_qA1_4 * (t3w_rA1_4 : ℝ) / 30240 +
        t3w_qA1_6 * (t3w_rA1_6 : ℝ) / 1209600 + t3w_qA1_7 * (t3w_rA1_7 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 78 := by norm_num [t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7]

/-- A2: 16 / 13 <= t < 4 (n >= 2). -/
theorem t3w_wall_A2 {t : ℝ} (ht : 16 / 13 <= t) (htb : t < 4) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 234 := by
  have hnmin : 2 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (2 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 4 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA2_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA2.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA2_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA2.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA2_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA2.2.2.1
  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA2_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA2.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA2_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_2 := by
        have hrew : (2 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((7 : ℝ) / 2) = (2 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (2 : ℝ) ^ (7 : ℕ)))
                      (by norm_num [t3w_rA2_2] : 0 < t3w_rA2_2)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA2_2] : 0 ≤ 1 / t3w_rA2_2)).mpr (by norm_num [t3w_rA2_2])
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA2_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_4 := by
        have hrew : (2 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((11 : ℝ) / 2) = (2 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (2 : ℝ) ^ (11 : ℕ)))
                      (by norm_num [t3w_rA2_4] : 0 < t3w_rA2_4)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA2_4] : 0 ≤ 1 / t3w_rA2_4)).mpr (by norm_num [t3w_rA2_4])
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA2_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_6 := by
        have hrew : (2 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((15 : ℝ) / 2) = (2 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (2 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA2_6] : 0 < t3w_rA2_6)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA2_6] : 0 ≤ 1 / t3w_rA2_6)).mpr (by norm_num [t3w_rA2_6])
  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA2_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_7 := by
        have hrew : (2 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((15 : ℝ) / 2) = (2 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (2 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA2_7] : 0 < t3w_rA2_7)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA2_7] : 0 ≤ 1 / t3w_rA2_7)).mpr (by norm_num [t3w_rA2_7])
  have hT2 : t3w_term n t 2 < t3w_qA2_2 * t3w_rA2_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA2_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num [t3w_rA2_2]) <;> (try positivity)
      _ < t3w_qA2_2 * (t3w_rA2_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num [t3w_qA2_2, t3w_rA2_2]) <;> (try positivity)
  have hT4 : t3w_term n t 4 < t3w_qA2_4 * t3w_rA2_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA2_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num [t3w_rA2_4]) <;> (try positivity)
      _ < t3w_qA2_4 * (t3w_rA2_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num [t3w_qA2_4, t3w_rA2_4]) <;> (try positivity)
  have hT6 : t3w_term n t 6 < t3w_qA2_6 * t3w_rA2_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA2_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num [t3w_rA2_6]) <;> (try positivity)
      _ < t3w_qA2_6 * (t3w_rA2_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num [t3w_qA2_6, t3w_rA2_6]) <;> (try positivity)
  have hT7 : t3w_term n t 7 < t3w_qA2_7 * t3w_rA2_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA2_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num [t3w_rA2_7]) <;> (try positivity)
      _ < t3w_qA2_7 * (t3w_rA2_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num [t3w_qA2_7, t3w_rA2_7]) <;> (try positivity)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA2_2 * (t3w_rA2_2 : ℝ) / 720 + t3w_qA2_4 * (t3w_rA2_4 : ℝ) / 30240 +
        t3w_qA2_6 * (t3w_rA2_6 : ℝ) / 1209600 + t3w_qA2_7 * (t3w_rA2_7 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 234 := by norm_num [t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7]

/-- A3: 4 <= t < 8 (n >= 6). -/
theorem t3w_wall_A3 {t : ℝ} (ht : 4 <= t) (htb : t < 8) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 312 := by
  have hnmin : 6 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (6 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 8 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA3_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA3.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA3_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA3.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA3_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA3.2.2.1
  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA3_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA3.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA3_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_2 := by
        have hrew : (6 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((7 : ℝ) / 2) = (6 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (6 : ℝ) ^ (7 : ℕ)))
                      (by norm_num [t3w_rA3_2] : 0 < t3w_rA3_2)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA3_2] : 0 ≤ 1 / t3w_rA3_2)).mpr (by norm_num [t3w_rA3_2])
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA3_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_4 := by
        have hrew : (6 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((11 : ℝ) / 2) = (6 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (6 : ℝ) ^ (11 : ℕ)))
                      (by norm_num [t3w_rA3_4] : 0 < t3w_rA3_4)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA3_4] : 0 ≤ 1 / t3w_rA3_4)).mpr (by norm_num [t3w_rA3_4])
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA3_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_6 := by
        have hrew : (6 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((15 : ℝ) / 2) = (6 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (6 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA3_6] : 0 < t3w_rA3_6)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA3_6] : 0 ≤ 1 / t3w_rA3_6)).mpr (by norm_num [t3w_rA3_6])
  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA3_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_7 := by
        have hrew : (6 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((15 : ℝ) / 2) = (6 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (6 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA3_7] : 0 < t3w_rA3_7)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA3_7] : 0 ≤ 1 / t3w_rA3_7)).mpr (by norm_num [t3w_rA3_7])
  have hT2 : t3w_term n t 2 < t3w_qA3_2 * t3w_rA3_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA3_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num [t3w_rA3_2]) <;> (try positivity)
      _ < t3w_qA3_2 * (t3w_rA3_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num [t3w_qA3_2, t3w_rA3_2]) <;> (try positivity)
  have hT4 : t3w_term n t 4 < t3w_qA3_4 * t3w_rA3_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA3_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num [t3w_rA3_4]) <;> (try positivity)
      _ < t3w_qA3_4 * (t3w_rA3_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num [t3w_qA3_4, t3w_rA3_4]) <;> (try positivity)
  have hT6 : t3w_term n t 6 < t3w_qA3_6 * t3w_rA3_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA3_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num [t3w_rA3_6]) <;> (try positivity)
      _ < t3w_qA3_6 * (t3w_rA3_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num [t3w_qA3_6, t3w_rA3_6]) <;> (try positivity)
  have hT7 : t3w_term n t 7 < t3w_qA3_7 * t3w_rA3_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA3_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num [t3w_rA3_7]) <;> (try positivity)
      _ < t3w_qA3_7 * (t3w_rA3_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num [t3w_qA3_7, t3w_rA3_7]) <;> (try positivity)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA3_2 * (t3w_rA3_2 : ℝ) / 720 + t3w_qA3_4 * (t3w_rA3_4 : ℝ) / 30240 +
        t3w_qA3_6 * (t3w_rA3_6 : ℝ) / 1209600 + t3w_qA3_7 * (t3w_rA3_7 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 312 := by norm_num [t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7]

/-- A4: 8 <= t < 13 (n >= 13). -/
theorem t3w_wall_A4 {t : ℝ} (ht : 8 <= t) (htb : t < 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 390 := by
  have hnmin : 13 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (13 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 13 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA4_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA4.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA4_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA4.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA4_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA4.2.2.1
  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA4_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA4.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA4_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_2 := by
        have hrew : (13 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((7 : ℝ) / 2) = (13 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (13 : ℝ) ^ (7 : ℕ)))
                      (by norm_num [t3w_rA4_2] : 0 < t3w_rA4_2)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA4_2] : 0 ≤ 1 / t3w_rA4_2)).mpr (by norm_num [t3w_rA4_2])
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA4_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_4 := by
        have hrew : (13 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((11 : ℝ) / 2) = (13 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (13 : ℝ) ^ (11 : ℕ)))
                      (by norm_num [t3w_rA4_4] : 0 < t3w_rA4_4)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA4_4] : 0 ≤ 1 / t3w_rA4_4)).mpr (by norm_num [t3w_rA4_4])
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA4_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_6 := by
        have hrew : (13 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((15 : ℝ) / 2) = (13 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (13 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA4_6] : 0 < t3w_rA4_6)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA4_6] : 0 ≤ 1 / t3w_rA4_6)).mpr (by norm_num [t3w_rA4_6])
  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA4_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))
          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_7 := by
        have hrew : (13 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((15 : ℝ) / 2) = (13 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < (13 : ℝ) ^ (15 : ℕ)))
                      (by norm_num [t3w_rA4_7] : 0 < t3w_rA4_7)]
        exact (Real.lt_sqrt (by norm_num [t3w_rA4_7] : 0 ≤ 1 / t3w_rA4_7)).mpr (by norm_num [t3w_rA4_7])
  have hT2 : t3w_term n t 2 < t3w_qA4_2 * t3w_rA4_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA4_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num [t3w_rA4_2]) <;> (try positivity)
      _ < t3w_qA4_2 * (t3w_rA4_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num [t3w_qA4_2, t3w_rA4_2]) <;> (try positivity)
  have hT4 : t3w_term n t 4 < t3w_qA4_4 * t3w_rA4_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA4_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num [t3w_rA4_4]) <;> (try positivity)
      _ < t3w_qA4_4 * (t3w_rA4_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num [t3w_qA4_4, t3w_rA4_4]) <;> (try positivity)
  have hT6 : t3w_term n t 6 < t3w_qA4_6 * t3w_rA4_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA4_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num [t3w_rA4_6]) <;> (try positivity)
      _ < t3w_qA4_6 * (t3w_rA4_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num [t3w_qA4_6, t3w_rA4_6]) <;> (try positivity)
  have hT7 : t3w_term n t 7 < t3w_qA4_7 * t3w_rA4_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA4_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num [t3w_rA4_7]) <;> (try positivity)
      _ < t3w_qA4_7 * (t3w_rA4_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num [t3w_qA4_7, t3w_rA4_7]) <;> (try positivity)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA4_2 * (t3w_rA4_2 : ℝ) / 720 + t3w_qA4_4 * (t3w_rA4_4 : ℝ) / 30240 +
        t3w_qA4_6 * (t3w_rA4_6 : ℝ) / 1209600 + t3w_qA4_7 * (t3w_rA4_7 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 390 := by norm_num [t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7]

/- 25ae Stage 3B.11 -- Part B (13 <= t <= 1e8): the list-scale wall band, log-derivative method.
   Records: scripts/rh/day026_25ae_t3wallB.py (exact sympy/Fraction; out_day026_25ae_t3wallB.txt).

   For term index i in {2,4,6,7} (products with 3,5,7,8 factors; p_i = 7/2,11/2,15/2,15/2;
   d_i = 720,30240,1209600,9072000), term i of the sharpened T3 bound at list scale with
   n = floor(13t/8) satisfies
     t3w_term i n t <= t3wB_R i t * t3wB_target t
   with the continuous (floor-lower-bound) ratio bound
     t3wB_R i t = sqrt(t3w_prod t i) * (13t/8 - 1)^(-p_i) * 2*(13t/8)^(1/2)*(78/70)/d_i
   whose exact-scale target is t3wB_target t = (1/2)*(13t/8)^(-1/2)*(35/39) (so that
   t3wB_R i t * t3wB_target t = sqrt(t3w_prod t i)*(13t/8 - 1)^(-p_i)/d_i exactly,
   t3wB_Rtarget).  h_i = d/dt log R_i is the rational function t3wB_h i = Num_i / Den_i
   with integer Num_i (t3wB_num*, all-negative for i in {2,4,6}; the i=7 numerator has the
   b_0<0, b_1<0, b_k>0 (k>=2) shifted-at-13 structure of the later lemmas).  Consequences:
   R_2,R_4,R_6 strictly decreasing on [13,1e8] (h_i < 0); R_7 strictly decreasing then
   increasing with a unique crossing c in (13,100) (Den_7 > 0), so R_7(t) < t3wB_K7 on
   [13,1e8].  Endpoint constants (strict rational sqrt bounds):
   R_i(t) <= K_i with K_i in t3wB_K2,K4,K6,K7 and K2+K4+K6+K7 < 1 (margin ~0.178).  Hence
   sum_i R_i(t) < 1 and the wall bound t3w_T3UB n t < (1/2)*n^(-1/2)*(35/39) on 13 <= t <= 1e8
   (t3w_wall_B; combined with the Part A bands by p4_25ae_wall_list_scale). -/

/-- Exact-scale wall target at height t: (1/2) * (13t/8)^(-1/2) * (35/39). -/
def t3wB_target (t : ℝ) : ℝ :=
  (1/2 : ℝ) * ((13 * t / 8 : ℝ)) ^ (-(1/2 : ℝ)) * (35/39)

/-- Continuous (floor-lower-bound) ratio bound for term index i. -/
def t3wB_R (i : ℕ) (t : ℝ) : ℝ :=
  Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) *
      (2 * ((13 * t / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))

/-- Log-derivative of t3wB_R i (rational form, no rpow). -/
def t3wB_h (i : ℕ) (t : ℝ) : ℝ :=
  (∑ k ∈ Finset.range (i + 1), (4 : ℝ) * t / (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)) +
      (1/2 : ℝ) / t - (t3w_p i) * (13/8 : ℝ) / (13 * t / 8 - 1)

/-- Structured positive denominator: 16*t*(13t-8)*∏_{k≤i} (4t^2 + (2k+1)^2). -/
def t3wB_den (i : ℕ) (t : ℝ) : ℝ :=
  128 * t * (13 * t / 8 - 1) * ∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)

/-- Numerator of h_2: all coefficients negative. -/
def t3wB_num2 (t : ℝ) : ℝ :=
  -28672*t^6 - 116480*t^5 - 179200*t^4 - 430976*t^3 - 198912*t^2 - 140400*t - 14400

/-- Numerator of h_4: all coefficients negative. -/
def t3wB_num4 (t : ℝ) : ℝ :=
  -720896*t^10 - 8785920*t^9 - 24330240*t^8 - 233705472*t^7 - 251682816*t^6 -
      1725335040*t^5 - 884787200*t^4 - 3518431488*t^3 - 811945728*t^2 - 928746000*t - 57153600

/-- Numerator of h_6: all coefficients negative. -/
def t3wB_num6 (t : ℝ) : ℝ :=
  -15728640*t^14 - 387645440*t^13 - 1550581760*t^12 - 32833568768*t^11 - 55564500992*t^10 -
      973242716160*t^9 - 898377891840*t^8 - 12282899492864*t^7 - 6613868957696*t^6 -
      63918879315200*t^5 - 19667347481600*t^4 - 109215422679168*t^3 - 16802372719872*t^2 -
      26588697735600*t - 1168733966400

/-- Numerator of h_7: deg 17; b_0<0, b_1<0, b_k>0 (k>=2) after shifting to t = 13 (t3wB_b*). -/
def t3wB_num7 (t : ℝ) : ℝ :=
  13631488*t^17 - 71303168*t^16 - 10695475200*t^14 - 152887361536*t^13 - 611549446144*t^12 -
      9982866882560*t^11 - 16894082416640*t^10 - 255828309614592*t^9 - 236149208875008*t^8 -
      2968192799703040*t^7 - 1598257661378560*t^6 - 14745799254850560*t^5 - 4537169001492480*t^4 -
      24664631352192000*t^3 - 3794558669568000*t^2 - 5982456990510000*t - 262965142440000

/-- Strict rational upper bound of R_2 at 13. -/
def t3wB_K2 : ℝ := (69379921 : ℝ) / 76684038375
/-- Strict rational upper bound of R_4 at 13. -/
def t3wB_K4 : ℝ := (58741168772 : ℝ) / 5963180876155125
/-- Strict rational upper bound of R_6 at 13. -/
def t3wB_K6 : ℝ := (134976489576526 : ℝ) / 1082001280435718965875
/-- Strict rational upper bound of R_7 at 10^8. -/
def t3wB_K7 : ℝ :=
  (27152220160000230793871360000541788613017600365952532275199977013110761687 : ℝ) /
    33069018044903324635418068668593060916969864823485826249274579824803840000
/-- Strict rational upper bound of R_7 at 13. -/
def t3wB_B7_13 : ℝ := (20257718354549507 : ℝ) / 81150096032678922440625
/-- Strict rational lower bound of R_7 at 10^8. -/
def t3wB_LB7_1e8 : ℝ :=
  (6733653333333390569386666666801028301866666757421583733333327632667137 : ℝ) /
    8202284797567284397844418484928766708131679846895918262781258670080000

/-- sqrt upper bound factors (each strict). -/
def t3wB_S2 : ℝ := (144241 : ℝ) / 64
def t3wB_I2 : ℝ := (4096 : ℝ) / 146064835
def t3wB_T2 : ℝ := (37 : ℝ) / 4
def t3wB_S4 : ℝ := (213715271 : ℝ) / 512
def t3wB_I4 : ℝ := (262144 : ℝ) / 3786146588035
def t3wB_T4 : ℝ := (37 : ℝ) / 4
def t3wB_S6 : ℝ := (701541006115 : ℝ) / 8192
def t3wB_I6 : ℝ := (16777216 : ℝ) / 98140705708455235
def t3wB_T6 : ℝ := (37 : ℝ) / 4
def t3wB_S7_13 : ℝ := (42115838574947 : ℝ) / 32768
def t3wB_I7_13 : ℝ := (16777216 : ℝ) / 98140705708455235
def t3wB_T7_13 : ℝ := (37 : ℝ) / 4
def t3wB_S7_1e8 : ℝ :=
  (655360000000005570560000000013076889600000008832819199999999445176577 : ℝ) / 65536
def t3wB_I7_1e8 : ℝ :=
  (1 : ℝ) / 38140073382553740273378989139471030626096447015170749712487253
def t3wB_T7_1e8 : ℝ := (25496 : ℝ) / 1
def t3wB_SL7_1e8 : ℝ :=
  (2560000000000021760000000000051081600000000034503199999999997832721 : ℝ) / 256
def t3wB_IL7_1e8 : ℝ :=
  (1 : ℝ) / 38143065464877624617952094888991660659094493335639500849987252
def t3wB_TL7_1e8 : ℝ := (25494 : ℝ) / 1

/-- The (78/70)*(35/39)*(1/2)*2 = 1 cancellation: R_i * target = the floor-lower-bound term. -/
theorem t3wB_Rtarget (i : ℕ) {t : ℝ} (ht : 13 ≤ t) :
    t3wB_R i t * t3wB_target t =
        Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) / (t3w_d i) := by
  dsimp only [t3wB_R, t3wB_target]
  set Y := (13 * t / 8 : ℝ) ^ (1/2 : ℝ) with Ydef
  set Z := (13 * t / 8 : ℝ) ^ (-(1/2 : ℝ)) with Zdef
  set M := 2 * Y * (78/70 : ℝ) / (t3w_d i) with Mdef
  set N := (1/2 : ℝ) * Z * (35/39 : ℝ) with Ndef
  have hbase : 0 < (13 * t / 8 : ℝ) := by
    apply div_pos (by nlinarith [ht]) (by norm_num)
  have hpair : Y * Z = 1 := by
    rw [Ydef, Zdef, show (13 * t / 8 : ℝ) ^ (1/2 : ℝ) * (13 * t / 8 : ℝ) ^ (-(1/2 : ℝ)) =
          ((13 * t / 8 : ℝ)) ^ ((1/2 : ℝ) + (-(1/2 : ℝ))) from by rw [← rpow_add hbase],
        show (1/2 : ℝ) + (-(1/2 : ℝ)) = 0 from by norm_num, Real.rpow_zero _]
  have hMN : M * N = Y * Z * ((2 : ℝ) * (1/2) * ((78/70 : ℝ) * (35/39 : ℝ))) / t3w_d i := by
    simp only [Mdef, Ndef, Ydef, Zdef]
    ring
  have hconst : (2 : ℝ) * (1/2) * ((78/70 : ℝ) * (35/39 : ℝ)) = 1 := by norm_num
  have hre : Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) * M * N =
      Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) * (M * N) := by ring
  rw [hre, hMN, hpair, hconst]
  ring

theorem t3wB_den_pos {i : ℕ} {t : ℝ} (ht : 13 ≤ t) : 0 < t3wB_den i t := by
  dsimp only [t3wB_den]
  have h2 : 0 < (128 * t) * (13 * t / 8 - 1) := by
    have ht0 : 0 < t := by linarith [ht]
    have ht8 : 0 < 13 * t / 8 - 1 := by
      nlinarith [show (13 : ℝ) * t ≥ 13 * 13 from by nlinarith [ht]]
    nlinarith [ht0, ht8]
  have hprod : 0 < ∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2) := by
    apply Finset.prod_pos
    intro k hk
    have ht0 : 0 < t := by linarith [ht]
    nlinarith [show (0 : ℝ) < 4 * t ^ 2 from by nlinarith [show (0 : ℝ) < t ^ 2 from by nlinarith [ht0]],
      show (0 : ℝ) ≤ (2 * k + 1 : ℝ)^2 from sq_nonneg _]
  nlinarith [h2, hprod]

/-- h_i = Num_i / Den_i (i = 2). -/
theorem t3wB_h2_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 2 t = t3wB_num2 t / t3wB_den 2 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 2 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ)) with Dfulldef
  have hmult : t3wB_h 2 t * (t3wB_den 2 t) = t3wB_num2 t := by
    calc
      t3wB_h 2 t * (t3wB_den 2 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num2 t := by
        dsimp only [t3wB_num2]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 728 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ)) =
                (((7/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hB, hC]
        ring
  rw [show t3wB_num2 t / (t3wB_den 2 t) = t3wB_h 2 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 4). -/
theorem t3wB_h4_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 4 t = t3wB_num4 t / t3wB_den 4 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 4 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ)) with Dfulldef
  have hmult : t3wB_h 4 t * (t3wB_den 4 t) = t3wB_num4 t := by
    calc
      t3wB_h 4 t * (t3wB_den 4 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num4 t := by
        dsimp only [t3wB_num4]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1144 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ)) =
                (((11/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hB, hC]
        ring
  rw [show t3wB_num4 t / (t3wB_den 4 t) = t3wB_h 4 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 6). -/
theorem t3wB_h6_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 6 t = t3wB_num6 t / t3wB_den 6 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 6 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ)) with Dfulldef
  have hmult : t3wB_h 6 t * (t3wB_den 6 t) = t3wB_num6 t := by
    calc
      t3wB_h 6 t * (t3wB_den 6 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num6 t := by
        dsimp only [t3wB_num6]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hk5 : (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 121 : ℝ) ≠ 0)]
          ring
        have hk6 : (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 169 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ)) =
                (((15/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hk5, hk6, hB, hC]
        ring
  rw [show t3wB_num6 t / (t3wB_den 6 t) = t3wB_h 6 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 7). -/
theorem t3wB_h7_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 7 t = t3wB_num7 t / t3wB_den 7 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 7 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ)) with Dfulldef
  have hmult : t3wB_h 7 t * (t3wB_den 7 t) = t3wB_num7 t := by
    calc
      t3wB_h 7 t * (t3wB_den 7 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 225 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num7 t := by
        dsimp only [t3wB_num7]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hk5 : (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 121 : ℝ) ≠ 0)]
          ring
        have hk6 : (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 169 : ℝ) ≠ 0)]
          ring
        have hk7 : (4 * t / (4 * t ^ 2 + 225 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 225 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have F0 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2313945088) * t ^ 15 + (-1423966208) * t ^ 14 + (152308875264) * t ^ 13 + (-93728538624) * t ^ 12 + (4953356222464) * t ^ 11 + (-3048219213824) * t ^ 10 + (84037764149248) * t ^ 9 + (-51715547168768) * t ^ 8 + (721038758888448) * t ^ 7 + (-443716159315968) * t ^ 6 + (2768900161248000) * t ^ 5 + (-1703938560768000) * t ^ 4 + (3418546851720000) * t ^ 3 + (-2103721139520000) * t ^ 2 := by
          ring
        have F1 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2286682112) * t ^ 15 + (-1407188992) * t ^ 14 + (147742326784) * t ^ 13 + (-90918354944) * t ^ 12 + (4659013206016) * t ^ 11 + (-2867085049856) * t ^ 10 + (74793323491328) * t ^ 9 + (-46026660610048) * t ^ 8 + (573763222070272) * t ^ 7 + (-353085059735552) * t ^ 6 + (1658192601312000) * t ^ 5 + (-1020426216192000) * t ^ 4 + (379838539080000) * t ^ 3 + (-233746793280000) * t ^ 2 := by
          ring
        have F2 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2232156160) * t ^ 15 + (-1373634560) * t ^ 14 + (138936385536) * t ^ 13 + (-85499314176) * t ^ 12 + (4123081031680) * t ^ 11 + (-2537280634880) * t ^ 10 + (59506846756864) * t ^ 9 + (-36619598004224) * t ^ 8 + (370130407695360) * t ^ 7 + (-227772558581760) * t ^ 6 + (635844802874112) * t ^ 5 + (-391289109460992) * t ^ 4 + (136741874068800) * t ^ 3 + (-84148845580800) * t ^ 2 := by
          ring
        have F3 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2150367232) * t ^ 15 + (-1323302912) * t ^ 14 + (126545362944) * t ^ 13 + (-77874069504) * t ^ 12 + (3441252745216) * t ^ 11 + (-2117693997056) * t ^ 10 + (43120757075968) * t ^ 9 + (-26535850508288) * t ^ 8 + (213818925745152) * t ^ 7 + (-131580877381632) * t ^ 6 + (329878010592000) * t ^ 5 + (-203001852672000) * t ^ 4 + (69766262280000) * t ^ 3 + (-42933084480000) * t ^ 2 := by
          ring
        have F4 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2041315328) * t ^ 15 + (-1256194048) * t ^ 14 + (111550726144) * t ^ 13 + (-68646600704) * t ^ 12 + (2732531236864) * t ^ 11 + (-1681557684224) * t ^ 10 + (29942345658368) * t ^ 9 + (-18426058866688) * t ^ 8 + (135715700343808) * t ^ 7 + (-83517354057728) * t ^ 6 + (200916919008000) * t ^ 5 + (-123641180928000) * t ^ 4 + (42204282120000) * t ^ 3 + (-25971865920000) * t ^ 2 := by
          ring
        have F5 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1905000448) * t ^ 15 + (-1172307968) * t ^ 14 + (95261097984) * t ^ 13 + (-58622214144) * t ^ 12 + (2109785227264) * t ^ 11 + (-1298329370624) * t ^ 10 + (21455100080128) * t ^ 9 + (-13203138510848) * t ^ 8 + (93031422501888) * t ^ 7 + (-57250106155008) * t ^ 6 + (134959320288000) * t ^ 5 + (-83051889408000) * t ^ 4 + (28252453320000) * t ^ 3 + (-17386125120000) * t ^ 2 := by
          ring
        have F6 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1741422592) * t ^ 15 + (-1071644672) * t ^ 14 + (79312257024) * t ^ 13 + (-48807542784) * t ^ 12 + (1640490582016) * t ^ 11 + (-1009532665856) * t ^ 10 + (15965376114688) * t ^ 9 + (-9824846839808) * t ^ 8 + (67511059080192) * t ^ 7 + (-41545267126272) * t ^ 6 + (96817604832000) * t ^ 5 + (-59580064512000) * t ^ 4 + (20228087880000) * t ^ 3 + (-12448054080000) * t ^ 2 := by
          ring
        have F7 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1550581760) * t ^ 15 + (-954204160) * t ^ 14 + (65667137536) * t ^ 13 + (-40410546176) * t ^ 12 + (1297656954880) * t ^ 11 + (-798558126080) * t ^ 10 + (12282899492864) * t ^ 9 + (-7558707380224) * t ^ 8 + (51135103452160) * t ^ 7 + (-31467755970560) * t ^ 6 + (72810281786112) * t ^ 5 + (-44806327252992) * t ^ 4 + (15193541563200) * t ^ 3 + (-9349871731200) * t ^ 2 := by
          ring
        have FB : 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (6815744) * t ^ 17 + (-4194304) * t ^ 16 + (1158676480) * t ^ 15 + (-713031680) * t ^ 14 + (76443680768) * t ^ 13 + (-47042265088) * t ^ 12 + (2495716720640) * t ^ 11 + (-1535825674240) * t ^ 10 + (42638051602432) * t ^ 9 + (-26238800986112) * t ^ 8 + (371024099962880) * t ^ 7 + (-228322523054080) * t ^ 6 + (1474579925485056) * t ^ 5 + (-907433800298496) * t ^ 4 + (2055385946016000) * t ^ 3 + (-1264852889856000) * t ^ 2 + (427318356465000) * t ^ 1 + -262965142440000 := by
          ring
        have FC : 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (102236160) * t ^ 17 + (17380147200) * t ^ 15 + (1146655211520) * t ^ 13 + (37435750809600) * t ^ 11 + (639570774036480) * t ^ 9 + (5565361499443200) * t ^ 7 + (22118698882275840) * t ^ 5 + (30830789190240000) * t ^ 3 + (6409775346975000) * t ^ 1 := by
          ring
        have hC : (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ)) =
                (((15/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hk5, hk6, hk7, hB, hC, F0, F1, F2, F3, F4, F5, F6, F7, FB, FC]
        ring
  rw [show t3wB_num7 t / (t3wB_den 7 t) = t3wB_h 7 t from by rw [← hmult]; field_simp [hden]]










/-- t3wB_num2 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num2_neg {t : ℝ} (ht : 0 < t) : t3wB_num2 t < 0 := by
  dsimp only [t3wB_num2]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6]

/-- t3wB_num4 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num4_neg {t : ℝ} (ht : 0 < t) : t3wB_num4 t < 0 := by
  dsimp only [t3wB_num4]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  have h7 : 0 < t^7 := by positivity
  have h8 : 0 < t^8 := by positivity
  have h9 : 0 < t^9 := by positivity
  have h10 : 0 < t^10 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6, h7, h8, h9, h10]

/-- t3wB_num6 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num6_neg {t : ℝ} (ht : 0 < t) : t3wB_num6 t < 0 := by
  dsimp only [t3wB_num6]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  have h7 : 0 < t^7 := by positivity
  have h8 : 0 < t^8 := by positivity
  have h9 : 0 < t^9 := by positivity
  have h10 : 0 < t^10 := by positivity
  have h11 : 0 < t^11 := by positivity
  have h12 : 0 < t^12 := by positivity
  have h13 : 0 < t^13 := by positivity
  have h14 : 0 < t^14 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14]

/-- h_i < 0 for all t >= 13, i in {2,4,6} (Num_i < 0, Den_i > 0). -/
theorem t3wB_h_neg_246 {i : ℕ} (hi : i = 2 ∨ i = 4 ∨ i = 6) {t : ℝ} (ht : 13 ≤ t) :
    t3wB_h i t < 0 := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : 0 < t3wB_den i t := t3wB_den_pos ht
  rcases hi with (rfl | hi)
  rw [t3wB_h2_id ht]
  exact div_neg_of_neg_of_pos (t3wB_num2_neg ht0) hden
  · rcases hi with (rfl | hi)
    rw [t3wB_h4_id ht]
    exact div_neg_of_neg_of_pos (t3wB_num4_neg ht0) hden
    · rcases hi with rfl
      rw [t3wB_h6_id ht]
      exact div_neg_of_neg_of_pos (t3wB_num6_neg ht0) hden

end




/-! P4Limit · L5.b — zeta split (Re s > 1).

    ζ(s) = P_n s + ∑' i, 1/((i+n+1):ℂ)^s, separating the first n terms of the
    1-indexed tsum.  Pinned mathlib: `zeta_eq_tsum_one_div_nat_add_one_cpow`
    (NumberTheory/LSeries/RiemannZeta.lean:214 — the 1-indexed tsum, stated
    "to avoid relying on mathlib's conventions for 0 ^ s"),
    `Summable.sum_add_tsum_nat_add'` (Topology/Algebra/InfiniteSum/NatInt.lean,
    `to_additive` of `Multipliable.prod_mul_tprod_nat_mul'`:
    ∑ range k, f + ∑' f (i+k) = ∑' f), `summable_nat_add_iff` (shift-
    invariance of summability, found by #print after greps failed — the generic
    version is not source-greppable), `Complex.summable_one_div_nat_cpow`.
-/

/-/ Atom L5.b — for Re s > 1: ζ(s) = P_n s + ∑' i, 1/((i+n+1):ℂ)^s. -/
theorem p4_zeta_split {s : ℂ} (hs : 1 < s.re) (n : ℕ) :
    riemannZeta s = p4_P n s + ∑' i : ℕ, (1 : ℂ) / (((i + n) + 1) : ℂ) ^ s := by
  set g : ℕ → ℂ := fun i : ℕ => (1 : ℂ) / (((i + 1) : ℕ) : ℂ) ^ s with hg
  have hS0 : Summable (fun i : ℕ => (1 : ℂ) / (i : ℂ) ^ s) := by
    simpa using (Complex.summable_one_div_nat_cpow (p := s)).2 hs
  have hSg : Summable g := by
    simpa [g] using (summable_nat_add_iff (k := 1) (G := ℂ)
        (f := fun i : ℕ => (1 : ℂ) / (i : ℂ) ^ s)).2 hS0
  have hSn : Summable (fun i : ℕ => g (i + n)) := by
    simpa [g] using (summable_nat_add_iff (k := n) (G := ℂ) (f := g)).2 hSg
  rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
  simpa [p4_P, g] using (Summable.sum_add_tsum_nat_add' hSn).symm

/-! P4Limit · L5.c — the tail tsum equals the closed-form limit (Re s > 1).

    ∑' i, 1/((i+n+1):ℂ)^s = p4_Tn_lim s n.  Route: the tail partial sums
    are the L5.a functions at M = n+m; the shifted tsum partial sums reach
    the same Ioc partial sums (Ioc↔range bridge: `Finset.sum_range_add` +
    `Finset.sum_union` over the disjoint split range (n+m+1) = range (n+1) ∪
    Ioc n (n+m), verified standalone); `tendsto_unique` then identifies the
    tsum limit with the L5.a limit.  Pinned: `Summable.tendsto_sum_tsum_nat`,
    `tendsto_add_atTop_nat`, `tendsto_unique`, `Complex.cpow_neg`.
-/

/-/ Atom L5.c — for Re s > 1, n ≥ 1: the shifted tail tsum is exactly the
    closed-form limit p4_Tn_lim s n. -/
theorem p4_Tn_eq {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 0 < n) :
    (∑' i : ℕ, (1 : ℂ) / (((i + n) + 1) : ℂ) ^ s) = p4_Tn_lim s n := by
  set g : ℕ → ℂ := fun i : ℕ => (1 : ℂ) / (((i + 1) : ℕ) : ℂ) ^ s with hg
  have hS0 : Summable (fun i : ℕ => (1 : ℂ) / (i : ℂ) ^ s) := by
    simpa using (Complex.summable_one_div_nat_cpow (p := s)).2 hs
  have hSg : Summable g := by
    simpa [g] using (summable_nat_add_iff (k := 1) (G := ℂ)
        (f := fun i : ℕ => (1 : ℂ) / (i : ℂ) ^ s)).2 hS0
  have hSn : Summable (fun i : ℕ => g (i + n)) := by
    simpa [g] using (summable_nat_add_iff (k := n) (G := ℂ) (f := g)).2 hSg
  -- summand bridge: g (i + n) = ((i + n + 1):ℕ:ℂ)^{-s}
  have hTerm0 (i : ℕ) : g (i + n) = (1 : ℂ) / (((i + n) + 1 : ℕ) : ℂ) ^ s := by
    dsimp only [g]
  have hTerm (i : ℕ) : g (i + n) = (((i + n) + 1 : ℕ) : ℂ) ^ (-s) := by
    rw [hTerm0 i, one_div, ← Complex.cpow_neg]
  -- the tsum partial sums
  have hT : Tendsto (fun m : ℕ => ∑ i ∈ Finset.range m, g (i + n)) atTop
      (nhds (∑' i : ℕ, g (i + n))) :=
    Summable.tendsto_sum_tsum_nat hSn
  have hT2 : Tendsto (fun m : ℕ => ∑ i ∈ Finset.range m, (((i + n) + 1 : ℕ) : ℂ) ^ (-s))
      atTop (nhds (∑' i : ℕ, g (i + n))) := by
    convert hT using 1
    funext m
    exact Finset.sum_congr rfl (fun i _ => (hTerm i).symm)
  -- Ioc↔range bridge (verified standalone in ProbeTmp before splicing)
  have hIoc (m : ℕ) : (∑ i ∈ Finset.range m, (((i + n) + 1 : ℕ) : ℂ) ^ (-s)) =
      (∑ k ∈ Finset.Ioc n (n + m), (k : ℂ) ^ (-s)) := by
    set a := n + 1 with ha
    set t : ℕ → ℂ := fun k : ℕ => (k : ℂ) ^ (-s) with ht
    have hUniv : (Finset.range (n + m + 1) : Finset ℕ) =
        Finset.range a ∪ Finset.Ioc n (n + m) := by
      dsimp only [a]
      ext k
      simp only [Finset.mem_union, Finset.mem_range, Finset.mem_Ioc]
      omega
    have hDisj : Disjoint (Finset.range a) (Finset.Ioc n (n + m)) := by
      dsimp only [a]
      intro x hx1 hx2 k hk
      have hd1 : k < n + 1 := Finset.mem_range.mp (hx1 hk)
      have hd2 : n < k := (Finset.mem_Ioc.mp (hx2 hk)).1
      omega
    have hSplit : (∑ k ∈ Finset.range (a + m), t k) =
        (∑ k ∈ Finset.range a, t k) + (∑ i ∈ Finset.range m, t (a + i)) := by
      simpa using Finset.sum_range_add t a m
    have h1 : (∑ i ∈ Finset.range m, t (a + i)) =
        (∑ k ∈ Finset.range (a + m), t k) - (∑ k ∈ Finset.range a, t k) := by
      rw [hSplit]
      ring
    have hNat : (a + m : ℕ) = n + m + 1 := by
      dsimp only [a]
      ring
    have hNat2 (i : ℕ) : (i + n + 1 : ℕ) = a + i := by
      dsimp only [a]
      ring
    have hHead : (∑ i ∈ Finset.range m, (((i + n) + 1 : ℕ) : ℂ) ^ (-s)) =
        (∑ i ∈ Finset.range m, t (a + i)) :=
      Finset.sum_congr rfl (fun i _h => by
        rw [hNat2 i])
    have h2 : (∑ i ∈ Finset.range m, t (a + i)) =
        (∑ k ∈ Finset.range (n + m + 1), t k) - (∑ k ∈ Finset.range a, t k) := by
      rw [h1]
      rw [hNat]
    have h3 : (∑ i ∈ Finset.range m, t (a + i)) =
        ((Finset.range a ∪ Finset.Ioc n (n + m)).sum t) - (∑ k ∈ Finset.range a, t k) := by
      rw [h2]
      rw [hUniv]
    have h4 : (∑ i ∈ Finset.range m, t (a + i)) =
        ((∑ k ∈ Finset.range a, t k) + (∑ k ∈ Finset.Ioc n (n + m), t k)) -
        (∑ k ∈ Finset.range a, t k) := by
      rw [h3]
      simp only [Finset.sum_union hDisj]
    have h5 : (∑ i ∈ Finset.range m, t (a + i)) = (∑ k ∈ Finset.Ioc n (n + m), t k) := by
      rw [h4]
      abel
    rw [hHead, h5]
  -- the Ioc partial sums reach the tsum limit
  have hT3 : Tendsto (fun m : ℕ => ∑ k ∈ Finset.Ioc n (n + m), (k : ℂ) ^ (-s))
      atTop (nhds (∑' i : ℕ, g (i + n))) := by
    convert hT2 using 1
    funext m
    exact (hIoc m).symm
  -- the Ioc partial sums reach the L5.a limit (L5.a at M = n+m)
  have hShift : Tendsto (fun m : ℕ => n + m) atTop atTop := by
    convert tendsto_add_atTop_nat n using 1
    funext m
    rw [add_comm]
  have hL : Tendsto (fun m : ℕ => ∑ k ∈ Finset.Ioc n (n + m), (k : ℂ) ^ (-s))
      atTop (nhds (p4_Tn_lim s n)) := by
    convert (p4_Tn_Tendsto hs n hn).comp hShift using 1
    funext m
    rfl
  -- one function, two limits, Hausdorff: equal
  simpa [g] using tendsto_nhds_unique hT3 hL

/-! P4Limit · L5.d — the P4 identity at Re s > 1 (Lean-proven).

    W_n(s) := ζ(s) − P_n s + I(n,s) = p4_em_expr s n, for n ≥ 1, Re s > 1.
    Assembly: L5.b (zeta split) cancels the head P_n; L5.c identifies the
    shifted tail tsum with p4_Tn_lim; +I cancels the first-order term
    −p4_Tn_lim's leading −n^{1−s}/(1−s) (the §0.5 sign correction, now
    machine-checked); the kernel s(s+1)·∫ B̂2·x^{−s−2} is pulled together
    into ∫ B̂2·p4_f2 (`integral_const_mul` + `integral_congr`).  The
    extension to Re s = ½ is CITED (DLMF 25.2.8 / Apostol Thm 12.21).
-/

/-/ Atom L5.d — the P4 identity at Re s > 1, n ≥ 1. -/
theorem p4_identity {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 0 < n) :
    riemannZeta s - p4_P n s + p4_I n s = p4_em_expr s n := by
  rw [p4_zeta_split hs n]
  rw [p4_Tn_eq hs hn]
  dsimp only [p4_Tn_lim, p4_I, p4_em_expr]
  norm_cast
  ring


/-! P4Limit · L5.e — the P4 statement: the bound on the EM expression at
    Re s = ½ (fully Lean-proven).

    ‖p4_em_expr s n‖ ≤ B_n(s) := ½·n^(-1/2) + (‖s‖/12)·n^(-3/2)
       + (√3/540)·‖s(s+1)(s+2)‖·n^(-5/2),  for s.re = ½, n ≥ 1.

    The equality `W_n(s) = p4_em_expr s n` (W_n := ζ − P_n + I) at
    Re s = ½ is CITED — [DLMF 25.2.8 / Apostol Thm 12.21: the EM tail
    identity holds by analytic continuation on 0 < Re s ≤ 1/2; the
    two sides agree on Re s > 1 (p4_identity) and both are analytic on
    {Re s > -1}\{-1,-2}]; numerically verified at the 1/sqrt(M) rate
    (day-017, day-019 §10).  The bound on the EM expression itself is
    triangle-inequality + `p4_f2_tail_bound` (L4, sharp constant
    √3/270; the leading ½ turns it into √3/540).
-/

/-/ Atom L5.e — the P4 bound at Re s = ½ (the machine-proven half of the
    T4 law; the W_n-equality at Re s = ½ is cited — see the section doc). -/
theorem p4_T4_bound {s : ℂ} (hsre : s.re = 1 / 2) {n : ℕ} (hn : 0 < n) :
    ‖p4_em_expr s n‖ ≤
        (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) +
        (‖s‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) +
        (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-5 / 2 : ℝ) := by
  set t1 := -((1 / 2) : ℂ) * (n : ℂ) ^ (-s) with ht1
  set t2 := ((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1)) with ht2
  set tk := ((1 / 2) : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x) with htk
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  have hEm : p4_em_expr s n = t1 + t2 - tk := by
    dsimp only [t1, t2, tk, p4_em_expr]
  rw [hEm]
  have hre1 : (-s : ℂ).re = (-1 / 2 : ℝ) := by
    rw [Complex.neg_re, hsre]
    ring
  have hbase : (n : ℂ) = ((n : ℝ) : ℂ) := by
    norm_cast
  have hre2 : (-s - 1 : ℂ).re = (-3 / 2 : ℝ) := by
    rw [Complex.sub_re, Complex.neg_re, hsre, Complex.one_re]
    ring
  have hnorm2 : ‖(n : ℂ) ^ (-s - 1)‖ = (n : ℝ) ^ (-3 / 2 : ℝ) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s - 1), hre2]
  have hnorm1 : ‖(n : ℂ) ^ (-s)‖ = (n : ℝ) ^ (-1 / 2 : ℝ) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s), hre1]
  have hnorm12 : ‖-((1 / 2) : ℂ)‖ = (1 / 2 : ℝ) := by norm_num
  have hnorm112 : ‖((1 / 12) : ℂ)‖ = (1 / 12 : ℝ) := by norm_num
  -- (1) kernel: L4.4 with the leading ½
  have hK : ‖tk‖ ≤ (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ *
      (n : ℝ) ^ (-5 / 2 : ℝ) := by
    dsimp only [tk]
    calc ‖(1 / 2 : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)‖
        = (1 / 2 : ℝ) * ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x‖ := by
          rw [norm_mul]
          norm_num
      _ ≤ (1 / 2) * (Real.sqrt 3 / 270 * ‖s * (s + 1)‖ * ‖s + 2‖ *
            (n : ℝ) ^ (-5 / 2 : ℝ)) :=
          mul_le_mul_of_nonneg_left (p4_f2_tail_bound hsre n hn) (by norm_num)
      _ = (Real.sqrt 3 / 540) * (‖s‖ * ‖s + 1‖ * ‖s + 2‖) *
            (n : ℝ) ^ (-5 / 2 : ℝ) := by
          rw [norm_mul]
          ring
      _ = (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ *
            (n : ℝ) ^ (-5 / 2 : ℝ) := by
          rw [← norm_mul, ← norm_mul]
  -- (2) first endpoint term
  have h1 : ‖t1‖ ≤ (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) := by
    dsimp only [t1]
    rw [norm_mul, hnorm12]
    apply mul_le_mul_of_nonneg_left _ (by norm_num)
    rw [hnorm1]
  -- (3) second endpoint term
  have h2 : ‖t2‖ ≤ (‖s‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) := by
    dsimp only [t2]
    calc ‖((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1))‖
        = (1 / 12 : ℝ) * ‖s * (n : ℂ) ^ (-s - 1)‖ := by
          rw [norm_mul, hnorm112]
      _ ≤ (1 / 12 : ℝ) * (‖s‖ * (n : ℝ) ^ (-3 / 2 : ℝ)) :=
          mul_le_mul_of_nonneg_left (by rw [norm_mul, hnorm2]) (by norm_num)
      _ = (‖s‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) := by ring
  -- triangle
  have hTri : ‖t1 + t2 - tk‖ ≤ ‖t1‖ + ‖t2‖ + ‖tk‖ := by
    have hsub := norm_sub_le (t1 + t2) tk
    have hadd := norm_add_le t1 t2
    linarith [hsub, hadd]
  linarith [hTri, h1, h2, hK]

/-! P4Limit · L5.f — the T4 corollary (the strictified measured law),
    pure division algebra from the P4 statement.

    At Re s = ½ the correction scale is |I(n,s)| = n^{1/2}/|1−s| and
    `p4_one_minus_s_conj` gives |1−s| = |s| (1 − s = conj s on the
    critical line), so the ratio |W_n(s)|/|I(n,s)| is bounded by
    (using p4_identity + p4_T4_bound for W_n at Re s = ½, as cited):

      ‖p4_em_expr s n‖ · |1−s| · n^{−1/2}
          ≤ (‖s‖/2)·n^{−1} + (‖s‖²/12)·n^{−2}
            + (√3/540)·‖s‖·‖s(s+1)(s+2)‖·n^{−3}.

    (The module sketch's draft line in (t²+¼)(|s|+1) form was wrong for
    large t and is replaced by this exact product form, which holds for
    every t ≥ 0.)
-/

/-/ Atom L5.f.1 — on the critical line Re s = ½: 1 − s = conj s, hence
    |1 − s| = |s| (the correction scale simplifies). -/
theorem p4_one_minus_s_conj {s : ℂ} (hsre : s.re = 1 / 2) : (1 : ℂ) - s = star s := by
  apply Complex.ext
  · simp [Complex.conj_re, hsre]
    norm_num
  · simp [Complex.conj_im]

/-/ Atom L5.f.2 — the T4 ratio corollary: the corrected-tail ratio
    |W_n(s)|/|I(n,s)| (W_n at Re s = ½ is the EM expression by the cited
    identity) is bounded by the sharp three-term expression.  Stated as a
    product (no quotients) for ℝ-algebra hygiene. -/
theorem p4_T4_ratio {s : ℂ} (hsre : s.re = 1 / 2) {n : ℕ} (hn : 0 < n) :
    ‖p4_em_expr s n‖ * ‖1 - s‖ * (n : ℝ) ^ (-1 / 2 : ℝ) ≤
        (‖s‖ / 2) * (n : ℝ) ^ (-1 : ℝ) +
        (‖s‖ ^ 2 / 12) * (n : ℝ) ^ (-2 : ℝ) +
        (Real.sqrt 3 / 540) * ‖s‖ * ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-3 : ℝ) := by
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  have hbB : ‖p4_em_expr s n‖ ≤
      (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) +
      (‖s‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) +
      (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-5 / 2 : ℝ) :=
    p4_T4_bound hsre hn
  have hconj : (1 : ℂ) - s = star s := p4_one_minus_s_conj hsre
  have hnorm : ‖(1 : ℂ) - s‖ = ‖s‖ := by
    rw [hconj, norm_star]
  have hrpow1 : (n : ℝ) ^ (-1 / 2 : ℝ) * (n : ℝ) ^ (-1 / 2 : ℝ) =
      (n : ℝ) ^ (-1 : ℝ) := by
    rw [← Real.rpow_add hnR (-1 / 2 : ℝ) (-1 / 2 : ℝ)]
    ring_nf
  have hrpow2 : (n : ℝ) ^ (-1 / 2 : ℝ) * (n : ℝ) ^ (-3 / 2 : ℝ) =
      (n : ℝ) ^ (-2 : ℝ) := by
    rw [← Real.rpow_add hnR (-1 / 2 : ℝ) (-3 / 2 : ℝ)]
    ring_nf
  have hrpow3 : (n : ℝ) ^ (-1 / 2 : ℝ) * (n : ℝ) ^ (-5 / 2 : ℝ) =
      (n : ℝ) ^ (-3 : ℝ) := by
    rw [← Real.rpow_add hnR (-1 / 2 : ℝ) (-5 / 2 : ℝ)]
    ring_nf
  calc ‖p4_em_expr s n‖ * ‖(1 : ℂ) - s‖ * (n : ℝ) ^ (-1 / 2 : ℝ)
      ≤ ((1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) +
          (‖s‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) +
          (Real.sqrt 3 / 540) * ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-5 / 2 : ℝ)) *
          ((‖s‖ * (n : ℝ) ^ (-1 / 2 : ℝ))) := by
        rw [hnorm, mul_assoc]
        exact mul_le_mul_of_nonneg_right hbB (by positivity)
      _ = (‖s‖ / 2) * (n : ℝ) ^ (-1 : ℝ) +
          (‖s‖ ^ 2 / 12) * (n : ℝ) ^ (-2 : ℝ) +
          (Real.sqrt 3 / 540) * ‖s‖ * ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-3 : ℝ) := by
        ring_nf
        have hK : (n : ℝ) ^ (-1 / 2 : ℝ) * ‖s‖ * Real.sqrt 3 *
            ‖s * 2 + s ^ 2 * 3 + s ^ 3‖ * (n : ℝ) ^ (-5 / 2 : ℝ) * (1 / 540) =
            (n : ℝ) ^ (-1 / 2 : ℝ) * (n : ℝ) ^ (-5 / 2 : ℝ) * ‖s‖ * Real.sqrt 3 *
            ‖s * 2 + s ^ 2 * 3 + s ^ 3‖ * (1 / 540) := by ring
        have hT : (n : ℝ) ^ (-1 / 2 : ℝ) * ‖s‖ ^ 2 *
            (n : ℝ) ^ (-3 / 2 : ℝ) * (1 / 12) =
            (n : ℝ) ^ (-1 / 2 : ℝ) * (n : ℝ) ^ (-3 / 2 : ℝ) * ‖s‖ ^ 2 * (1 / 12) := by ring
        have hSq : ((n : ℝ) ^ (-1 / 2 : ℝ)) ^ 2 = (n : ℝ) ^ (-1 : ℝ) := by
          simp only [pow_two]
          rw [hrpow1]
        rw [hK, hrpow3, hT, hrpow2, hSq]
        ring
