import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real

/-!
**SWall — the 0350 wall literature audit, formalized (M2 lane, unit 63).**

The audit (docs/discovery/entries/0350.json) settled the terminal face's
analytic closure routes against 2025-grade primary sources. This module
records that settlement in the tree, in the project's standard pattern:

  * the PUBLISHED results are consumed as self-contained named Prop
    hypotheses (Z78 citation pattern) -
    `sUnconditionallyUnbounded` (classical, unconditional; the Selberg 1946
    mean-square derivation is recorded verbatim in the docstring),
    `sUpperRH` (Carneiro-Chandee-Milinovich, Math. Ann. 356 (2013) 939-968,
    Thm 2), `sOmegaRH` (Inoue, arXiv:1904.11051; improves Montgomery,
    matches Bondarenko-Seip);
  * the CONSEQUENCES that are pure logic / pure real analysis are
    LEAN-PROVEN in-tree:
      - every uniform bound on S at all heights is killed by the cited
        unconditional unboundedness (`noUniformAllT_of_citedUnbounded`);
      - every uniform bound on S at all heights is killed by the RH Omega
        (`noUniformAllT_of_RHOmega`);
      - the best published RH upper bound on S (CCM, 13/50 eventual form)
        DIVERGES (`upperRH_bound_diverges`) - no finite ceiling exists on
        the published RH picture;
      - the named at-zeros clause (the E19 gap) would kill the uniform
        AT-ZEROS bound (`atZeroUnbounded_kills_uniformZeros`) - recorded as
        a named Prop, NOT a theorem (no published source supplies it as of
        0350);
  * the VERDICT (header + 0350): Door 1 (the absolute clause G-hs1/A1 in
    S-form: a uniform finite |S(zero)| <= K) is DEAD as a published input
    and remains "under pressure - not refuted" at the zeros (the E19 gap
    stands exactly); Door 2 (the quantitative growth route, the
    {theta | 4/7 < theta} Levinson/PRZZ wall, 0310-0312) is ALIVE and
    PINNED - the only analytic path; Door 3 (the theta = inf lane,
    ThetaInf/0290) is ALIVE and conjectural by nature.

Status labels per project convention: classical inputs CITED (see
formal/RH-LEAN-PROVENANCE.md); the lemmas in Section 2 LEAN-PROVEN.
**NO RH CLAIM** - the terminal face remains an open hypothesis; this
module records which closure routes are dead, not a closure.
-/

namespace SWall

/-! ## 1. Cited published results, self-contained (Z78 pattern)

    S is the standard Riemann S-function: S(t) = (1/pi) . arg zeta(1/2 + it),
    the argument obtained by continuous variation along the line segments
    2 -> 2 + it -> 1/2 + it (at the ordinates of zeros,
    S(t) = (1/2)(S(t-) + S(t+))). The statements below are about an
    arbitrary S : R -> R satisfying the cited property - the published
    fact is what is cited, not the definition.
-/

/-- [CITED, classical, UNCONDITIONAL] S IS UNBOUNDED. Eventual form consumed
    here: for every C there is t >= 3 with |S t| > C.
    Record (0350, verbatim sources): Conrey, "A theory for the zeros of
    Riemann zeta and other L-functions (updated)" (arXiv:1407.4358), Section
    VIII: "It is known that S(y) is unbounded, which implies that the logs in
    (154), which are Arg's, can accumulate. The roughest estimate is the known
    fact that S(y) = O(log y), which actually was not written explicitly in
    Riemann's paper, but only later by von Mangoldt." The standard
    UNCONDITIONAL derivation: the Selberg (1946) mean-square theorem, cited
    verbatim from the same section: "A celebrated theorem of Selberg [Selberg
    1946a] states that S(y) over a large interval 0 < y < T satisfies a normal
    distribution with zero mean and variance S(y)^2-bar = (1/T) integral_0^T
    S(y)^2 dy = (1/(2 pi^2)) log log T + O(sqrt(log log T))" - the divergent
    mean square (log log T -> infinity) forces limsup_{y -> oo} |S(y)| =
    infinity. The eventual form above is a pure corollary (the O-term is
    eventually dominated). Consumed as a hypothesis; not proven in-tree. -/
def sUnconditionallyUnbounded (S : ℝ → ℝ) : Prop :=
    ∀ C, ∃ t, 3 ≤ t ∧ |S t| > C

/-- [CITED, UNDER RH - Carneiro-Chandee-Milinovich (CCM), "Bounding S(t) and
    S_1(t) on the Riemann hypothesis", Mathematische Annalen 356 (2013)
    939-968 (arXiv:1309.1526), Theorem 2, verbatim from ar5iv: "Assume RH.
    For t sufficiently large, |S(t)| <= (1/4) . (log t)/(log log t) +
    O((log t . log log log t)/(log log t)^2)." The paper's introduction:
    "This improves the previous bound of Goldston and Gonek, (1/2 + o(1)) .
    (log t)/(log log t), by a factor of 2." Conrey's book (arXiv:1407.4358,
    Section VIII) corroborates the form (1/4 + o(1)) . log y / log log y. The
    eventual 13/50 = 0.26 > 1/4 form consumed here is a pure corollary (the
    O-term is eventually < (1/50) . log t / log log t; 0.25 + 0.01 = 0.26).
    Consumed as a hypothesis; not proven in-tree. -/
def sUpperRH (S : ℝ → ℝ) : Prop :=
    ∃ T0, T0 ≥ 4 ∧ ∀ t ≥ T0, |S t| ≤ (13 / 50) * (log t / log (log t))

/-- [CITED, UNDER RH - Inoue, "Large oscillations of the argument of the
    Riemann zeta-function" (arXiv:1904.11051), abstract verbatim: "Assuming
    the Riemann hypothesis, we prove that S(t) = Omega_pm((log t .
    log log log t)/(log log t)). This improves the classical Omega-results of
    Montgomery [14, Theorem 2] and matches with the Omega-result obtained by
    Bondarenko and Seip [1, Theorem 2]."]
    Eventual form consumed here, on doubling intervals [A, 2A]: for all large
    A there is t in [A, 2A] with |S t| at half the stated order in A (the
    o(1) of the Omega statement is absorbed into 1/2; the two-sided Omega_pm
    is consumed here in absolute value, which is what the contradiction
    lemmas consume). Consumed as a hypothesis; not proven in-tree. -/
def sOmegaRH (S : ℝ → ℝ) : Prop :=
    ∃ T0, T0 ≥ exp (exp 1) ∧ ∀ A ≥ T0,
      ∃ t, A ≤ t ∧ t ≤ 2 * A ∧
        |S t| ≥ (1 / 2) * ((log A * log (log (log A))) / log (log A))

/-! ### The named at-zeros clause (the E19 gap) and the absolute clause it would kill
-/

/-- NAMED GAP (E19; 0350): S IS UNBOUNDED AT THE ZERO ORDINATES. Read
    `gamma t` as "t is the ordinate of a non-trivial zero of zeta" (t =
    gamma for some zero 1/2 + i gamma, or - gamma, per the project's
    convention). The 0350 audit found NO published theorem establishing
    this (at no order): the general-t Omegas do not transfer to the zero
    ordinates by crude argument (E19), and no at-zeros Omega appeared in the
    2013/2018/2019/2021/2023/2025 sources pulled. If this were ever
    supplied, it would kill `sUniformZerosBound` below (pure logic, in-tree,
    `atZeroUnbounded_kills_uniformZeros`). Named Prop; consumed as a
    hypothesis only if ever supplied. -/
def sUnboundedAtZeros (S : ℝ → ℝ) (gamma : ℝ → Prop) : Prop :=
    ∀ C, ∃ t, 3 ≤ t ∧ gamma t ∧ |S t| > C

/-- THE ABSOLUTE CLAUSE (G-hs1/A1 in S-form): a UNIFORM FINITE bound on S at
    the zero ordinates. Verdict per 0350: NO published theorem supplies it
    (F1, re-confirmed against 2025-grade sources); every published upper
    bound on S DIVERGES (best under RH: `sUpperRH`, an UNBOUNDED function -
    see `upperRH_bound_diverges`); the clause is therefore "under pressure -
    not refuted": neither a live published theorem nor a refutation (the E19
    gap, above). Named Prop. -/
def sUniformZerosBound (S : ℝ → ℝ) (gamma : ℝ → Prop) : Prop :=
    ∃ K, ∀ t, gamma t → |S t| ≤ K

/-! ## 2. LEAN-PROVEN consequences (pure real analysis + pure logic)
-/

/-- (LEAN-PROVEN, real analysis) For every u > 0: log u <= u ^ (2/3).
    The real-analysis workhorse for the log-log divergence below. Proof
    (elementary, no calculus): write v = log u. If 1 <= u, set
    w = (2/3) v (so u ^ (2/3) = exp w and v = (3/2) w); the elementary
    inequality exp w >= (3/2) w for all w >= 0 follows from
    (a) w <= 2: exp w >= 1 + w >= (3/2) w (add_one_le_exp, since
        1 >= w/2);
    (b) w >= 2: exp w = (exp (w/2))^2 >= (1 + w/2)^2 = 1 + w + w^2/4
        = (3/2) w + (1/4)(w - 2)^2 >= (3/2) w.
    If u < 1, log u < 0 <= u ^ (2/3). -/
theorem log_le_u_pow_two_thirds (u : ℝ) (hu : 0 < u) :
    log u ≤ u ^ (2 / 3 : ℝ) := by
  by_cases hu1 : 1 ≤ u
  · set v := log u with hv
    have hvn : 0 ≤ v := log_nonneg hu1
    set w := (2 / 3 : ℝ) * v with hw
    have h1 : v = (3 / 2 : ℝ) * w := by ring
    have h2 : exp w = u ^ (2 / 3 : ℝ) := by
      have hwu : w = log u * (2 / 3 : ℝ) := by
        rw [hw, hv]
        ring
      rw [hwu]
      exact (rpow_def_of_pos hu (2 / 3 : ℝ)).symm
    have h3 : (3 / 2 : ℝ) * w ≤ exp w := by
      by_cases hw2 : 2 ≤ w
      · have := add_one_le_exp (w / 2)
        have h4 : exp w = (exp (w / 2)) ^ 2 := by
          have hw2b : w = w / 2 + w / 2 := by ring
          rw [hw2b, exp_add]
          ring
        calc (3 / 2 : ℝ) * w
            ≤ 1 + w + w ^ 2 / 4 := by nlinarith
          _ = (1 + w / 2) ^ 2 := by ring
          _ ≤ (exp (w / 2)) ^ 2 := by
              gcongr
              nlinarith [this]
          _ = exp w := by rw [h4]
      · have := add_one_le_exp w
        nlinarith [this, hw2]
    nlinarith [h1, h2, h3]
  · have hn : log u < 0 := log_neg hu (by linarith)
    have hpos : 0 < u ^ (2 / 3 : ℝ) := rpow_pos_of_pos hu _
    linarith

/-- (LEAN-PROVEN, real analysis) log t / log (log t) -> infinity, in the
    eventuality form the wall lemmas consume (multiplicative form: for
    M >= 0, log t >= M . log (log t) for all large t, with log (log t) >
    0). Proof: take L = exp (max (exp 2) (M^3 + 1)); for t >= L, log t >=
    max (exp 2) (M^3 + 1), hence log (log t) > 0 and log (log t) <=
    (log t)^(2/3) (the lemma above, u = log t >= exp 2 >= 1), hence
    (log t)^(1/3) . log (log t) <= log t; and log t >= M^3 + 1 gives
    M <= (log t)^(1/3) (M >= 0, cube monotone). These combine to
    M . log (log t) <= (log t)^(1/3) . log (log t) <= log t. -/
theorem logDivLoglog_eventuallyAbove (M : ℝ) (hM : 0 ≤ M) :
    ∃ L, L > 0 ∧ ∀ t ≥ L, 0 < log (log t) ∧ M * log (log t) ≤ log t := by
  set M' := max M 0 with hMp
  set L := exp (max (exp 2) (M' ^ 3 + 1)) with hL
  use L
  refine' ⟨exp_pos _, fun t ht => ?_⟩
  have hLp : 0 < L := exp_pos _
  have ht0 : 0 < t := by linarith [hLp, ht]
  have hll : log L = max (exp 2) (M' ^ 3 + 1) := by rw [hL, log_exp]
  have hlogle : log L ≤ log t := (log_le_log_iff hLp ht0).2 ht
  have hmax : max (exp 2) (M' ^ 3 + 1) ≤ log t := by simpa [hll] using hlogle
  have h1 : log t ≥ exp 2 := le_trans (le_max_left _ _) hmax
  have h2 : log t ≥ M' ^ 3 + 1 := le_trans (le_max_right _ _) hmax
  have h1p : 0 < log t := by linarith [h1, exp_pos 2]
  have hloglogpos : 0 < log (log t) := log_pos (show 1 < log t from by
    have : 1 < exp 2 := by
      have := add_one_le_exp 2
      linarith
    linarith [h1])
  have hub : log (log t) ≤ (log t) ^ (2 / 3 : ℝ) :=
    log_le_u_pow_two_thirds _ h1p
  have hM3 : M' ^ 3 ≤ log t := by linarith [h2]
  have hY3 : ((log t) ^ (1 / 3 : ℝ)) ^ 3 = log t := by
    have hY3b : ((log t) ^ ((3 : ℕ)⁻¹ : ℝ)) ^ 3 = log t := by
      rw [rpow_inv_natCast_pow (le_of_lt h1p) (by decide)]
    have heq : (log t) ^ (1 / 3 : ℝ) = (log t) ^ ((3 : ℕ)⁻¹ : ℝ) := by
      congr
      norm_num
    rw [heq]
    exact hY3b
  have hMcube : M' ≤ (log t) ^ (1 / 3 : ℝ) := by
    apply le_of_not_gt
    intro hgt
    set Y := (log t) ^ (1 / 3 : ℝ) with hYd
    have hcube : M' ^ 3 - Y ^ 3 = (M' - Y) * (M' ^ 2 + M' * Y + Y ^ 2) := by ring
    have hsub : M' ^ 3 - log t = (M' - Y) * (M' ^ 2 + M' * Y + Y ^ 2) := by
      rw [← hY3]
      exact hcube
    have hlt1 : 0 < M' - Y := by linarith [hgt]
    have hb : 0 < M' ^ 2 + M' * Y + Y ^ 2 := by
      nlinarith [hlt1, sq_nonneg M', sq_nonneg Y]
    have hpos : 0 < M' ^ 3 - log t := by
      rw [hsub]
      exact mul_pos hlt1 hb
    linarith [hpos, hM3]
  have hmid : (log t) ^ (1 / 3 : ℝ) * log (log t) ≤ log t := by
    calc (log t) ^ (1 / 3 : ℝ) * log (log t)
        ≤ (log t) ^ (1 / 3 : ℝ) * (log t) ^ (2 / 3 : ℝ) :=
          mul_le_mul_of_nonneg_left hub (rpow_nonneg (le_of_lt h1p) _)
      _ = (log t) ^ ((1 / 3 : ℝ) + 2 / 3) := by rw [← rpow_add (by positivity)]
      _ = (log t) ^ (1 : ℝ) := by norm_num
      _ = log t := rpow_one _
  have hm : M * log (log t) ≤ log t :=
    calc M
        * log (log t) ≤ (max M 0) * log (log t) :=
          mul_le_mul_of_nonneg_right (le_max_left M _) (le_of_lt hloglogpos)
      _ = M' * log (log t) := by simp [hMp]
      _ ≤ (log t) ^ (1 / 3 : ℝ) * log (log t) :=
          mul_le_mul_of_nonneg_right hMcube (le_of_lt hloglogpos)
      _ ≤ log t := hmid
  exact ⟨hloglogpos, hm⟩

/-- (LEAN-PROVEN, pure logic) The cited UNCONDITIONAL unboundedness of S
    (Selberg mean square, via 0350) kills every uniform bound
    |S t| <= K for ALL t >= 3: the "all heights" form of the absolute
    clause is contradicted by classical analysis itself. -/
theorem noUniformAllT_of_citedUnbounded (S : ℝ → ℝ)
    (hU : sUnconditionallyUnbounded S) :
    ¬ ∃ K, ∀ t, 3 ≤ t → |S t| ≤ K := by
  intro h
  obtain ⟨K, hK⟩ := h
  have h1 := hU (K + 1)
  obtain ⟨t, ht, hgt⟩ := h1
  linarith [hK t ht, hgt]

/-- (LEAN-PROVEN, real analysis + pure logic) The RH Omega (Inoue, 0350)
    kills every uniform bound on S at all sufficiently large heights: on
    the published RH picture, S has no finite ceiling AT ALL - and here the
    stated Omega itself contradicts |S t| <= K for all large t. -/
theorem noUniformAllT_of_RHOmega (S : ℝ → ℝ) (hΩ : sOmegaRH S) :
    ¬ ∃ T0 K, ∀ t, T0 ≤ t → |S t| ≤ K := by
  intro h
  obtain ⟨T0, K, hK⟩ := h
  obtain ⟨H0, hH0, hA⟩ := hΩ
  set M := max (0 : ℝ) (2 * K + 2) with hMd
  have hM0 : 0 ≤ M := le_max_left 0 (2 * K + 2)
  obtain ⟨L, hL, hL'⟩ := logDivLoglog_eventuallyAbove M hM0
  set A := max (T0 + 1) (max H0 (max L (exp (exp (exp 1))))) with hAd
  have h1ee : 1 < exp (exp 1) := by
    have heq1 : exp 1 + 1 ≤ exp (exp 1) := add_one_le_exp (exp 1)
    have heq2 : 0 < exp 1 := exp_pos 1
    linarith [heq1, heq2]
  have hA1 : A ≥ T0 + 1 := le_max_left (T0 + 1) (max H0 (max L (exp (exp (exp 1)))))
  have hA2 : A ≥ H0 := by
    have h1 : H0 ≤ max H0 (max L (exp (exp (exp 1)))) := le_max_left H0 _
    have h2 : max H0 (max L (exp (exp (exp 1)))) ≤ max (T0 + 1) (max H0 (max L (exp (exp (exp 1))))) :=
      le_max_right (T0 + 1) _
    simpa [hAd] using (le_trans h1 h2)
  have hA3 : A ≥ L := by
    have h1 : L ≤ max L (exp (exp (exp 1))) := le_max_left L _
    have h2 : max L (exp (exp (exp 1))) ≤ max H0 (max L (exp (exp (exp 1)))) :=
      le_max_right H0 _
    have h3 : max H0 (max L (exp (exp (exp 1)))) ≤ max (T0 + 1) (max H0 (max L (exp (exp (exp 1))))) :=
      le_max_right (T0 + 1) _
    simpa [hAd] using (le_trans (le_trans h1 h2) h3)
  have hAe : A ≥ exp (exp (exp 1)) := by
    have h1 : exp (exp (exp 1)) ≤ max L (exp (exp (exp 1))) := le_max_right L _
    have h2 : max L (exp (exp (exp 1))) ≤ max H0 (max L (exp (exp (exp 1)))) :=
      le_max_right H0 _
    have h3 : max H0 (max L (exp (exp (exp 1)))) ≤ max (T0 + 1) (max H0 (max L (exp (exp (exp 1))))) :=
      le_max_right (T0 + 1) _
    simpa [hAd] using (le_trans (le_trans h1 h2) h3)
  have hA0 : 0 < A := by linarith [hA3, hL]
  have hLtA : 0 < log A := log_pos (show 1 < A from by
    have h21 : 1 < exp (exp 1) := h1ee
    have h12 : exp (exp 1) < exp (exp (exp 1)) := by
      have heq1 : exp 1 + 1 ≤ exp (exp 1) := add_one_le_exp (exp 1)
      have heq2 : 0 < exp 1 := exp_pos 1
      exact exp_lt_exp.mpr (by linarith [heq1, heq2])
    have h13 : 1 < exp (exp (exp 1)) := by
      calc 1 < exp (exp 1) := h21
          _ < exp (exp (exp 1)) := h12
    linarith [hAe, h13])
  have hlogA : log A ≥ exp (exp 1) := by
    have := (log_le_log_iff (exp_pos (exp (exp 1))) hA0).2 hAe
    simpa [log_exp] using this
  have hllA : 0 < log (log A) := log_pos (show 1 < log A from by
    have : 1 < exp (exp 1) := h1ee
    linarith [hlogA, this])
  have hlllA : 1 ≤ log (log (log A)) := by
    have hll : log (log A) ≥ exp 1 := by
      have := (log_le_log_iff (exp_pos (exp 1)) hLtA).2 hlogA
      simpa [log_exp] using this
    have := (log_le_log_iff (exp_pos 1) hllA).2 hll
    simpa [log_exp] using this
  have hm : M * log (log A) ≤ log A := (hL' A hA3).2
  have hRHS : 2 * K * log (log A) < log A * log (log (log A)) := by
    by_cases hKneg : 2 * K + 2 ≤ 0
    · have hM0b : M = 0 := by
        rw [hMd]
        exact max_eq_left hKneg
      have h2K : 2 * K < 0 := by linarith
      have h1 : 2 * K * log (log A) < 0 := by nlinarith [h2K, hllA]
      have h2 : 0 = M * log (log A) := by simp [hM0b]
      nlinarith [h1, h2]
    · have hM1 : M = 2 * K + 2 := by
        rw [hMd]
        exact max_eq_right (by linarith)
      have hdiff : 2 * K * log (log A) + 2 * log (log A) = (2 * K + 2) * log (log A) := by ring
      have hlt : 2 * K * log (log A) < (2 * K + 2) * log (log A) := by
        nlinarith [hdiff, hllA]
      have h2 : (2 * K + 2) * log (log A) ≤ log A := by
        simp [hM1] at hm
        exact hm
      have h3a : log A * 1 = 1 * log A := by ring
      have h3b : 1 * log A ≤ log (log (log A)) * log A :=
        mul_le_mul_of_nonneg_right hlllA (le_of_lt hLtA)
      have h3c : log (log (log A)) * log A = log A * log (log (log A)) := by ring
      have h3 : log A * 1 ≤ log A * log (log (log A)) :=
        calc log A * 1
            = 1 * log A := h3a
            _ ≤ log (log (log A)) * log A := h3b
            _ = log A * log (log (log A)) := h3c
      have hlogA1 : log A = log A * 1 := by ring
      calc 2 * K * log (log A)
          < (2 * K + 2) * log (log A) := hlt
        _ ≤ log A := h2
        _ = log A * 1 := hlogA1
        _ ≤ log A * log (log (log A)) := h3
  have hbig : (1 / 2) * ((log A * log (log (log A))) / log (log A)) > K := by
    have hsub : 0 < (1 / 2) * ((log A * log (log (log A))) / log (log A)) - K := by
      have : (1 / 2) * ((log A * log (log (log A))) / log (log A)) - K =
          (log A * log (log (log A)) - 2 * K * log (log A)) / (2 * log (log A)) := by
        field_simp [hllA.ne']
      rw [this]
      have hnum : 0 < log A * log (log (log A)) - 2 * K * log (log A) :=
        sub_pos.mpr hRHS
      exact div_pos hnum (by nlinarith [hllA])
    linarith [hsub]
  have htA := hA A hA2
  obtain ⟨t, htA, htB, htS⟩ := htA
  have hup : |S t| ≤ K := hK t (by linarith [htA, hA1])
  linarith [hup, htS, hbig]

/-- (LEAN-PROVEN, real analysis) The best published RH upper bound on S
    (CCM Thm 2, 13/50 eventual form) DIVERGES: for every K,
    (13/50) . (log t / log (log t)) > K for all sufficiently large t
    (equivalently 13 . log t > 50 . K . log (log t)). This is the machine
    record of 0350's claim (2): "every published upper bound on S
    diverges" - the published RH picture gives S no finite ceiling. -/
theorem upperRH_bound_diverges (K : ℝ) :
    ∃ L, L > 0 ∧ ∀ t ≥ L, 0 < log (log t) ∧ (13 / 50) * (log t / log (log t)) > K := by
  by_cases hK : 0 ≤ K
  · set M := (50 / 13 : ℝ) * K + 1 with hMd
    obtain ⟨L, hL, hL'⟩ := logDivLoglog_eventuallyAbove M (show 0 ≤ M from by
      nlinarith [hK, hMd])
    use L
    refine' ⟨hL, fun t ht => ?_⟩
    have hm := hL' t ht
    have hd : 0 < log (log t) := hm.1
    have hstr : (50 / 13 : ℝ) * K * log (log t) < log t := by
      have hm2 : ((50 / 13 : ℝ) * K + 1) * log (log t) ≤ log t := by
        simpa [hMd] using hm.2
      have hdiff : ((50 / 13 : ℝ) * K + 1) * log (log t) =
          (50 / 13 : ℝ) * K * log (log t) + log (log t) := by ring
      nlinarith [hm2, hdiff, hd]
    have hbig : (13 / 50 : ℝ) * (log t / log (log t)) > K := by
      have hc1 : K * log (log t) = (13 / 50 : ℝ) * ((50 / 13 : ℝ) * K * log (log t)) := by ring
      have hc2 : (13 / 50 : ℝ) * ((50 / 13 : ℝ) * K * log (log t)) < (13 / 50 : ℝ) * log t := by
        gcongr
      have hcalc : K * log (log t) < (13 / 50 : ℝ) * log t := by
        calc K * log (log t)
            = (13 / 50 : ℝ) * ((50 / 13 : ℝ) * K * log (log t)) := hc1
            _ < (13 / 50 : ℝ) * log t := hc2
      have hsub : 0 < (13 / 50 : ℝ) * (log t / log (log t)) - K := by
        have : (13 / 50 : ℝ) * (log t / log (log t)) - K =
            ((13 / 50 : ℝ) * log t - K * log (log t)) / log (log t) := by
          field_simp [hd.ne']
        rw [this]
        exact div_pos (sub_pos.mpr hcalc) hd
      linarith [hsub]
    exact ⟨hd, hbig⟩
  · obtain ⟨L, hL, hL'⟩ := logDivLoglog_eventuallyAbove 1 (by norm_num)
    use L
    refine' ⟨hL, fun t ht => ?_⟩
    have hm := hL' t ht
    have hd : 0 < log (log t) := hm.1
    have hlogt : 0 < log t := by linarith [hm.2, hd]
    have hrat : 0 < log t / log (log t) := div_pos hlogt hd
    have hbig : 0 < (13 / 50 : ℝ) * (log t / log (log t)) :=
      mul_pos (by norm_num) hrat
    exact ⟨hd, by linarith [hK, hbig]⟩

/-- (LEAN-PROVEN, pure logic) If S were unbounded AT THE ZERO ORDINATES
    (the named E19 gap), the absolute clause (a uniform finite
    at-zeros bound) would be False. No published source supplies the
    hypothesis as of 0350 - so the clause stands "under pressure - not
    refuted"; this lemma is exactly what a supplied at-zeros Omega would
    consume. -/
theorem atZeroUnbounded_kills_uniformZeros (S : ℝ → ℝ) (gamma : ℝ → Prop)
    (hZ : sUnboundedAtZeros S gamma) (hK : sUniformZerosBound S gamma) : False := by
  obtain ⟨K, hKb⟩ := hK
  have h1 := hZ (K + 1)
  obtain ⟨t, ht, hz, hzS⟩ := h1
  have hb : |S t| ≤ K := hKb t hz
  linarith [hb, hzS]

end SWall
