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

STATUS (2026-09-12, Lean 4.33.1): atom L1 GREEN (drafted day-019 goal
turn); L2–L5 pending per the sketch. No sorry.
THEOREMS (L1): p4_f_hasDerivAt, p4_f1_hasDerivAt, p4_f2_hasDerivAt,
 p4_f1_at, p4_f2_at, p4_f1_on_Icc, p4_f2_on_Icc -/
import Mathlib
import RhAttack.P4Em2

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

/-- Atom L1.e — pointwise: `deriv (deriv f) = p4_f2` at every 0 < x. -/
theorem p4_f2_at {s : ℂ} (hs1 : s ≠ 0) (hs2 : s ≠ -1) {x : ℝ} (hxpos : 0 < x) :
    deriv (deriv (p4_f s)) x = p4_f2 s x := by
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
  have hd2 : HasDerivAt (deriv (p4_f s)) (p4_f2 s x) x := by
    simpa using (Filter.EventuallyEq.hasDerivWithinAt_iff hLw hpt).mpr hd1.hasDerivWithinAt
  exact hd2.deriv

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

end
