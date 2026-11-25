import Mathlib
import RhAttack.OnlineZetaEta
import RhAttack.OnlineZetaEta2

open Set Complex Real
open Real
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



/-
## 2.2b: local uniform convergence on the strip

The eta partial sums converge UNIFORMLY on the open ball of radius
`Re s₀ / 2` about any `s₀` with `0 < Re s₀` (the ball stays in
`0 < Re s`), from `OnlineZetaEta2.etaTailBound`:

    ‖P_M(s) − P_K(s)‖ ≤ (2 + ‖s‖/Re s) · (min M K)^{−Re s}
                      < B · (N₀ : ℝ)^{−r}  <  ε

with `r = Re s₀ / 2`, `‖s‖ < ‖s₀‖ + r = C`, `Re s > r`,
`B = 2 + C/r`, and `N₀ > (B/ε)^{1/r} + 1` (so `B · N₀^{-r} < ε`).
This is the local-uniform-convergence witness for the Weierstrass route
to differentiability/analyticity of `etaStrip` (Phase 2.2b.2).
-/

/-- For `s ∈ Metric.ball s₀ (Re s₀ / 2)` with `0 < Re s₀`, we have
`s.re > Re s₀ / 2` (the ball stays in `0 < Re s`). -/
theorem ballReStrict (s₀ s : ℂ) (hs₀ : 0 < s₀.re) (hs : s ∈ Metric.ball s₀ (s₀.re / 2)) :
    s.re > s₀.re / 2 := by
  have h1 : (s - s₀).re ≥ -‖s - s₀‖ := by
    have ha : |(s - s₀).re| ≤ ‖s - s₀‖ := abs_re_le_norm (s - s₀)
    have h : -(s - s₀).re ≤ |(s - s₀).re| := by
      by_cases hpos : 0 ≤ (s - s₀).re
      · rw [abs_of_nonneg hpos]
        linarith
      · rw [abs_of_neg (lt_of_not_ge hpos)]
    linarith
  have h2 : s.re ≥ s₀.re - ‖s - s₀‖ := by
    have hre : s.re = (s - s₀).re + s₀.re := by
      rw [sub_re]
      ring
    rw [hre]
    linarith
  have h3 : ‖s - s₀‖ < s₀.re / 2 := by
    simpa [dist_eq_norm s s₀] using Metric.mem_ball.mp hs
  linarith

/-- For `s ∈ Metric.ball s₀ (Re s₀ / 2)` with `0 < Re s₀`, we have `0 < s.re`. -/
theorem ballRePos (s₀ s : ℂ) (hs₀ : 0 < s₀.re) (hs : s ∈ Metric.ball s₀ (s₀.re / 2)) :
    0 < s.re :=
  lt_trans (half_pos hs₀) (ballReStrict s₀ s hs₀ hs)

/-- The key uniformity computation, isolated: for the constants of
`etaPartialSumsUniformCauchyOn` on `Metric.ball s₀ (Re s₀ / 2)`,
`B · (N₀ : ℝ)^{-r} < ε` whenever `N₀ > (B/ε)^{1/r} + 1` with
`B, r, ε > 0`. -/
private theorem n0Bound (B r ε : ℝ) (hB : 0 < B) (hr : 0 < r) (hε : 0 < ε) (N₀ : ℕ)
    (hN₀ : (B / ε) ^ (1 / r) + 1 < (N₀ : ℝ)) : B * (N₀ : ℝ) ^ (-r) < ε := by
  have hBdiv : 0 < B / ε := div_pos hB hε
  have h2 : (N₀ : ℝ) ^ r > B / ε := by
    have hx : 0 ≤ (B / ε) ^ (1 / r) + 1 := by
      linarith [rpow_pos_of_pos hBdiv (1 / r)]
    calc (N₀ : ℝ) ^ r > ((B / ε) ^ (1 / r) + 1) ^ r :=
        rpow_lt_rpow hx hN₀ hr
      _ > ((B / ε) ^ (1 / r)) ^ r := by
        have hsmo := strictMonoOn_rpow_Ici_of_exponent_pos hr
        have hx' : 0 ≤ (B / ε) ^ (1 / r) := le_of_lt (rpow_pos_of_pos hBdiv (1 / r))
        have hy : 0 ≤ (B / ε) ^ (1 / r) + 1 := by linarith
        exact hsmo hx' hy (lt_add_one ((B / ε : ℝ) ^ (1 / r)))
      _ = B / ε := by
        rw [← rpow_mul (le_of_lt hBdiv) (1 / r) r,
            show (1 / r : ℝ) * r = 1 from by field_simp [hr.ne'],
            rpow_one]
  have h3 : 0 < (N₀ : ℝ) := by
    linarith [rpow_pos_of_pos hBdiv (1 / r)]
  have h4 : (N₀ : ℝ) ^ (-r) < ε / B := by
    have hN₀nn : 0 ≤ (N₀ : ℝ) := by linarith
    have hinv : ((N₀ : ℝ) ^ r)⁻¹ < (B / ε)⁻¹ :=
      (inv_lt_inv₀ (by linarith) (by linarith)).mpr h2
    calc (N₀ : ℝ) ^ (-r) = ((N₀ : ℝ) ^ r)⁻¹ := by rw [rpow_neg hN₀nn r]
      _ < (B / ε)⁻¹ := hinv
      _ = ε / B := by field_simp [hB.ne', hε.ne']
  calc B * (N₀ : ℝ) ^ (-r) < B * (ε / B) := by gcongr
    _ = ε := by field_simp [hB.ne']


/-- Uniform Cauchy estimate: the eta partial sums are uniformly Cauchy on
`Metric.ball s₀ (Re s₀ / 2)` for `0 < Re s₀`. -/
theorem etaPartialSumsUniformCauchyOn (s₀ : ℂ) (hs₀ : 0 < s₀.re) :
    UniformCauchySeqOn (fun N s => OnlineZetaEta2.etaPartial s N) atTop
      (Metric.ball s₀ (s₀.re / 2)) := by
  set r := s₀.re / 2 with hr
  have hrpos : 0 < r := by rw [hr]; exact half_pos hs₀
  set C := ‖s₀‖ + r with hC
  set B := 2 + C / r with hB
  have hCpos : 0 < C := by
    rw [hC]
    linarith [norm_nonneg s₀, hrpos]
  have hBpos : 0 < B := by
    rw [hB]
    positivity
  rw [Metric.uniformCauchySeqOn_iff]
  intro ε hε
  have hBdiv : 0 < B / ε := div_pos hBpos hε
  obtain ⟨N₀, hN₀⟩ := exists_nat_gt ((B / ε : ℝ) ^ (1 / r) + 1)
  have hN₀r : (B / ε) ^ (1 / r) + 1 < (N₀ : ℝ) := hN₀
  have hN₀1n : 1 < N₀ := by
    have h1 : (1 : ℝ) < (B / ε : ℝ) ^ (1 / r) + 1 := by
      linarith [rpow_pos_of_pos hBdiv (1 / r)]
    have h2 : (Nat.cast (1 : ℕ) : ℝ) < (N₀ : ℝ) := by
      norm_num1
      linarith [rpow_pos_of_pos hBdiv (1 / r), hN₀r]
    exact Nat.cast_lt.mp h2
  have hN₀1 : 1 < (N₀ : ℝ) := by
    norm_cast at hN₀1n ⊢
  have hN₀pos : 0 < (N₀ : ℝ) := by linarith [hN₀1]
  use N₀
  intro M hM K hK s hs
  -- uniform bound B · N₀^{-r} < ε
  have hfinal : B * (N₀ : ℝ) ^ (-r) < ε :=
    n0Bound B r ε hBpos hrpos hε N₀ hN₀r
  -- facts about s in the ball: 0 < s.re, ‖s‖ < C, and s.re > r
  have hre : r < s.re := by
    rw [hr]
    exact ballReStrict s₀ s hs₀ hs
  have htri : ‖s‖ ≤ ‖s - s₀‖ + ‖s₀‖ := by
    have heq : s = (s - s₀) + s₀ := by ring
    calc ‖s‖ = ‖(s - s₀) + s₀‖ := congr_arg (fun x : ℂ => ‖x‖) heq
      _ ≤ ‖s - s₀‖ + ‖s₀‖ := Complex.norm_add_le' (s - s₀) s₀
  have hnorm : ‖s‖ < C := by
    rw [hC]
    calc ‖s‖ ≤ ‖s - s₀‖ + ‖s₀‖ := htri
      _ < s₀.re / 2 + ‖s₀‖ := by
        have hball : ‖s - s₀‖ < s₀.re / 2 := by
          simpa [dist_eq_norm s s₀] using Metric.mem_ball.mp hs
        exact add_lt_add_left hball (‖s₀‖ : ℝ)
      _ = ‖s₀‖ + s₀.re / 2 := by ring
      _ = ‖s₀‖ + r := by rw [hr]
  have hcoef : (2 + ‖s‖ / s.re : ℝ) < B := by
    rw [hB]
    have h1 : ‖s‖ / s.re < C / r := by
      have hpos1 : 0 < s.re := ballRePos s₀ s hs₀ hs
      have hpos2 : 0 < r := hrpos
      calc ‖s‖ / s.re < C / s.re := by gcongr
        _ < C / r := by gcongr
    nlinarith
  -- the tail decay: (min M K : ℝ)^{-s.re} < (N₀ : ℝ)^{-r}
  by_cases hMK : M ≥ K
  · -- N' := K
    have hKcast : (N₀ : ℝ) ≤ (K : ℝ) := Nat.cast_le.mpr hK
    have hK₁ : 1 < (K : ℝ) := by linarith [hN₀1, hKcast]
    have hKpos : 0 < (K : ℝ) := by linarith [hK₁]
    have hexp : -s.re < -r := by linarith [hre]
    have hanti := Real.antitoneOn_rpow_Ioi_of_exponent_nonpos (r := -r) (by linarith [show r = s₀.re / 2 from rfl, hs₀] : -r ≤ 0)
    have hdecay : (K : ℝ) ^ (-s.re) < (N₀ : ℝ) ^ (-r) := by
      calc (K : ℝ) ^ (-s.re) < (K : ℝ) ^ (-r) := rpow_lt_rpow_of_exponent_lt hK₁ hexp
        _ ≤ (N₀ : ℝ) ^ (-r) :=
            hanti (by simpa using hN₀pos) (by simpa using hKpos) hKcast
    have hsre : 0 < s.re := ballRePos s₀ s hs₀ hs
    have hbound : ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s K‖ ≤
        (2 + ‖s‖ / s.re) * (K : ℝ) ^ (-s.re) :=
      OnlineZetaEta2.etaTailBound s hsre M K (by omega) hMK
    calc dist (OnlineZetaEta2.etaPartial s M) (OnlineZetaEta2.etaPartial s K) =
            ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s K‖ :=
          dist_eq_norm _ _
      _ ≤ (2 + ‖s‖ / s.re) * (K : ℝ) ^ (-s.re) := hbound
      _ < B * (N₀ : ℝ) ^ (-r) := by gcongr
      _ < ε := hfinal
  · -- M < K: symmetric
    have hMcast : (N₀ : ℝ) ≤ (M : ℝ) := Nat.cast_le.mpr hM
    have hM₁ : 1 < (M : ℝ) := by linarith [hN₀1, hMcast]
    have hMpos : 0 < (M : ℝ) := by linarith [hM₁]
    have hexp : -s.re < -r := by linarith [hre]
    have hanti := Real.antitoneOn_rpow_Ioi_of_exponent_nonpos (r := -r) (by linarith [show r = s₀.re / 2 from rfl, hs₀] : -r ≤ 0)
    have hdecay : (M : ℝ) ^ (-s.re) < (N₀ : ℝ) ^ (-r) := by
      calc (M : ℝ) ^ (-s.re) < (M : ℝ) ^ (-r) := rpow_lt_rpow_of_exponent_lt hM₁ hexp
        _ ≤ (N₀ : ℝ) ^ (-r) :=
            hanti (by simpa using hN₀pos) (by simpa using hMpos) hMcast
    have hsre : 0 < s.re := ballRePos s₀ s hs₀ hs
    have hbound : ‖OnlineZetaEta2.etaPartial s K - OnlineZetaEta2.etaPartial s M‖ ≤
        (2 + ‖s‖ / s.re) * (M : ℝ) ^ (-s.re) :=
      OnlineZetaEta2.etaTailBound s hsre K M (by omega) (by omega)
    calc dist (OnlineZetaEta2.etaPartial s M) (OnlineZetaEta2.etaPartial s K) =
            ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s K‖ :=
          dist_eq_norm _ _
      _ = ‖-(OnlineZetaEta2.etaPartial s K - OnlineZetaEta2.etaPartial s M)‖ := by ring_nf
      _ = ‖OnlineZetaEta2.etaPartial s K - OnlineZetaEta2.etaPartial s M‖ := by rw [norm_neg]
      _ ≤ (2 + ‖s‖ / s.re) * (M : ℝ) ^ (-s.re) := hbound
      _ < B * (N₀ : ℝ) ^ (-r) := by gcongr
      _ < ε := hfinal

/-- Local uniform convergence: on the ball of radius `Re s₀ / 2` about `s₀`
(`0 < Re s₀`), the eta partial sums converge uniformly to `etaStrip`. -/
theorem etaPartialSumsUniformOn (s₀ : ℂ) (hs₀ : 0 < s₀.re) :
    TendstoUniformlyOn (fun N s => OnlineZetaEta2.etaPartial s N) etaStrip atTop
      (Metric.ball s₀ (s₀.re / 2)) :=
  UniformCauchySeqOn.tendstoUniformlyOn_of_tendsto
    (etaPartialSumsUniformCauchyOn s₀ hs₀)
  fun s hs => etaStripTendsto s (ballRePos s₀ s hs₀ hs)

end OnlineZetaEta3
