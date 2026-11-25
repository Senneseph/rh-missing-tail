import Mathlib
import RhAttack.OnlineZetaEta
import RhAttack.OnlineZetaEta2

open Set Complex Real
open BigOperators MeasureTheory Filter Topology

namespace OnlineZetaEta3

/-
honline Phase 2.2a: the eta function on the strip 0 < Re s as the SEQUENTIAL
limit of its partial sums, and its identity with `OnlineZetaEta.etaSeries`
for `Re s > 1` (first step of the identity-theorem extension of
`OnlineZetaEta.etaIdentity` to `0 < Re s`, `s ≠ 1`).

WHY A NEW FUNCTION (and not the `∑'` tsum): the eta series
    etaTerm(s, n) = (-1)^(n-1) / n^s
converges only CONDITIONALLY for `0 < Re s ≤ 1`. Mathlib's `Summable`/`∑'`
is the unconditional (Finset-net) notion; for conditionally convergent
series the Finset net of sums is NOT Cauchy (Riemann's rearrangement
theorem: one can thin the positive terms past any N₀ to make the net
diverge). Concretely, at `s = 1/2` the net `t ↦ ∑ n ∈ t, etaTerm s n`
contains the subsequence of partial sums over the odd indices, which
grows like (1/2)·ln N. So the strip eta function must be defined as the
limit of the ORDINAL-indexed partial sums, which DO converge (Phase 2.1:
`OnlineZetaEta2.etaPartialSumsCauchy`, via `CauchySeq.tendsto_limUnder`).

This module defines, in local lemmas (classical, no external input):

1. `etaStrip (s : ℂ) : ℂ` — the strip eta function:
   `etaStrip s = (fun N ↦ etaPartial s N) →` (sequential limit) for
   `0 < Re s`, and `0` otherwise (the `else` branch is inert; all theorems
   in this program assume `0 < Re s`).
2. `etaStripTendsto` — the partial sums converge to `etaStrip s` for
   `0 < Re s` (Phase 2.1 Cauchy + `CauchySeq.tendsto_limUnder`).
3. `etaStripAgreesEtaSeries` — for `Re s > 1` (absolute convergence),
   the sequential limit coincides with the tsum `OnlineZetaEta.etaSeries`,
   so the Phase 2.0 identity `etaIdentity` applies to `etaStrip` there.
4. `etaStrip_of_nonpos_re` — the inert `else` branch.

NO RH CLAIM. NO NEW AXIOMS. Machine-checked against pinned Mathlib v4.33.1.

ELABORATION NOTE: every theorem takes `s` and its hypotheses as explicit
parameters in its own header (pattern of OnlineZetaEta.lean). Anonymous
binders in displayed types get explicit type ascriptions (`fun (n : ℕ) =>`)
because the generic `HPow` instances for ℂ (pow vs cpow) otherwise infer
the binder type from the base (trap documented in OnlineZetaEta.lean).
-/

/-- The eta function on the strip `0 < Re s`: the sequential limit of the
partial sums `etaPartial s N` (the `else` branch is inert — every theorem
in the honline program assumes `0 < Re s`). For `Re s > 1` this agrees
with the tsum `OnlineZetaEta.etaSeries` (see `etaStripAgreesEtaSeries`). -/
noncomputable def etaStrip (s : ℂ) : ℂ :=
  if 0 < s.re then atTop.limUnder (fun N => OnlineZetaEta2.etaPartial s N) else 0

/-- For `0 < Re s` the eta partial sums converge (to `etaStrip s`). -/
theorem etaStripTendsto (s : ℂ) (hs : 0 < s.re) :
    Tendsto (fun N => OnlineZetaEta2.etaPartial s N) atTop (nhds (etaStrip s)) := by
  dsimp [etaStrip]
  rw [if_pos hs]
  exact (OnlineZetaEta2.etaPartialSumsCauchy s hs).tendsto_limUnder

/-- For `Re s > 1` the sequential limit `etaStrip` coincides with the tsum
`OnlineZetaEta.etaSeries` (absolute convergence), so the Phase 2.0 identity
`OnlineZetaEta.etaIdentity` applies to `etaStrip` on `Re s > 1`. -/
theorem etaStripAgreesEtaSeries (s : ℂ) (hs : 1 < s.re) :
    etaStrip s = OnlineZetaEta.etaSeries s := by
  have h0 : 0 < s.re := lt_trans (show (0 : ℝ) < 1 from by norm_num) hs
  dsimp [etaStrip]
  rw [if_pos h0]
  set f := fun n : ℕ => OnlineZetaEta2.etaTerm s n
  -- Absolute convergence of the eta terms for Re s > 1: |f n| = n^{-Re s}.
  have habs : Summable (fun n : ℕ => (1 : ℂ) / (n : ℂ) ^ s) :=
    (Complex.summable_one_div_nat_cpow (p := s)).mpr hs
  have h1 : Summable (fun (n : ℕ) => (-1 : ℂ) ^ n * (1 / (n : ℂ) ^ s)) :=
    Summable.alternating habs
  -- f n = (-1)^(n-1) / n^s = -((-1)^n / n^s).
  have h2 : f = fun (n : ℕ) => -((-1 : ℂ) ^ n * (1 / (n : ℂ) ^ s)) := by
    funext n
    cases n with
    | zero =>
      dsimp [f, OnlineZetaEta2.etaTerm]
      have hsnz : s ≠ 0 := by
        intro r
        rw [r] at hs
        norm_num at hs
      simp [hsnz]
    | succ m =>
      dsimp [f, OnlineZetaEta2.etaTerm]
      have hpow : (-1 : ℂ) ^ (m + 1) = (-1 : ℂ) ^ m * (-1 : ℂ) := by rw [pow_succ]
      rw [hpow]
      ring
  have hsum : Summable f := Summable.congr (Summable.neg h1) (fun b => (congrFun h2 b).symm)
  obtain ⟨a, ha⟩ := hsum
  -- The range partial sums of a summable ℕ-series converge to the tsum.
  have hR : Tendsto (fun M => ∑ n ∈ Finset.range M, f n) atTop (nhds a) := ha.tendsto_sum_nat
  have hcomp : Tendsto (fun N => N + 1) atTop atTop := by
    change Tendsto Nat.succ atTop atTop
    apply tendsto_atTop_atTop_of_monotone (fun a b hab => Nat.succ_le_succ hab)
    intro b
    exact ⟨b, Nat.le_succ b⟩
  -- etaPartial s N = ∑ n ∈ range (N+1), f n = R (N+1): a convergent subsequence.
  have hP : Tendsto (fun N => ∑ n ∈ Finset.range (N + 1), f n) atTop (nhds a) := hR.comp hcomp
  have heq :
      (fun N : ℕ => OnlineZetaEta2.etaPartial s N) =
      (fun N => ∑ n ∈ Finset.range (N + 1), f n) := by
    funext N
    dsimp [OnlineZetaEta2.etaPartial, f, OnlineZetaEta2.etaTerm]
  have hP' : Tendsto (fun N => OnlineZetaEta2.etaPartial s N) atTop (nhds a) := by
    convert hP
  have hlim : atTop.limUnder (fun N => OnlineZetaEta2.etaPartial s N) = a :=
    Filter.Tendsto.limUnder_eq hP'
  rw [hlim]
  have htsum : a = ∑' n : ℕ, f n := (HasSum.tsum_eq ha).symm
  rw [htsum]
  dsimp [OnlineZetaEta.etaSeries, f, OnlineZetaEta2.etaTerm]

/-- The inert branch: for `Re s ≤ 0`, `etaStrip s = 0`. -/
theorem etaStrip_of_nonpos_re (s : ℂ) (hs : s.re ≤ 0) : etaStrip s = 0 := by
  dsimp [etaStrip]
  rw [if_neg (not_lt_of_ge hs)]

end OnlineZetaEta3
