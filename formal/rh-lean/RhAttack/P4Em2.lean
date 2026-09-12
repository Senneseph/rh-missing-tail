/- P4Em2 — P4 atom-2b: the GLOBAL finite second-order Euler–Maclaurin law.

OUTLINE piece: P4 (the rigorous missing-tail law, §9 row P4), atom-2b
(spec: kainos plan/40-prize-islands/rh-attack/spec/p4-tail-law-abstract.md
§T3; the §4 finite target).

ROLE: stitches the per-period second-order identity
(RhAttack.P4Tail.int_B1f'_period, atom-2) over every unit period of
[n, m] into the global finite law

  ∑ k ∈ Finset.Ioc n m, f k
    = ∫_n^m f + ½(f m − f n) + (1/12)(f′ m − f′ n) − ½·∫_n^m B̂₂·f″ dx

the finite core of the Riemann 1859 identity, from which the
missing-tail W_n(t) form follows at σ = ½ (P4 no-ζ core convention:
the finite/derivative EM machinery is machine-checked here; the 1859
continuation identification is cited under the same convention as
B-3's DLMF 25.2.12 citation).

Built exclusively from:
  (1) the 1st-order sum identity at integer endpoints
      (RhAttack.P4Em.sum_eq_integral_add_integral_deriv, published),
  (2) the per-period 2nd-order identity
      (RhAttack.P4Tail.int_B1f'_period, atom-2),
  (3) additivity of adjacent interval integrals
      (intervalIntegral.sum_integral_adjacent_intervals_Ico —
      Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean, used
      here exactly as in Mathlib's Analysis/SumIntegralComparisons.lean
      with `a := (↑·)` and `Nat.cast_add`/`Nat.cast_one` endpoint
      normalization, as in Mathlib's NumberTheory/AbelSummation.lean),
  (4) one local finite additive telescope (ico_sum_telescope, this file).

APPROACH / pinned APIs (Lean 4.33.1, mathlib f001ca3a4):
  * `Set.uIcc a b` is the UNORDERED CLOSED interval `Icc (min a b)
    (max a b)` (Order/Interval/Set/UnorderedInterval.lean:59); with
    ordered endpoints, `Set.uIcc_of_le (h : a ≤ b) : uIcc a b = Icc a b`
    and `Set.mem_uIcc_of_le`.
  * The additivity lemma's period endpoints are nat-cast form
    `a (k + 1) = ((k + 1 : ℕ) : ℝ)`; the source notation
    `(j + 1 : ℝ)` elaborates to real-add form `((j : ℝ) + 1)`. Bridge:
    `simp only [Nat.cast_add, Nat.cast_one]` (both directions), or for
    `rw` first `rw [← Nat.cast_one]` (the real literal `1` is OfNat,
    not defeq to `↑(1 : ℕ)`).
  * `ContinuousOn` restriction is `ContinuousOn.mono`
    (Topology/ContinuousOn.lean:320); there is NO `restrict_set` in
    this checkout.
  * `Finset.sum_insert (by simp [Finset.mem_Ico])` + `abel` for the
    telescope step; `rw` auto-closes rfl goals in this toolchain.
  * `push_cast; ring` closes the mixed ℝ-scalar/𝕜 endpoint forms
    (probed).

STATUS: GREEN (day-019, 2026-09-12, Lean 4.33.1): both theorems compile;
full build 17424 jobs, 0 errors; all four `rhattack` gates PASS.
(First red pass landed day-017/018 — the fixed errors are captured in
the day-019 journal and the wiki.)
THEOREMS: ico_sum_telescope, em2_finite -/
import Mathlib
import RhAttack.P4Em
import RhAttack.P4Tail

open Real Set MeasureTheory intervalIntegral Finset

variable {𝕜 : Type*} [RCLike 𝕜]

noncomputable section

/-- Finite additive telescope over `Ico n m` in any additive commutative
    group: `∑ i ∈ Ico n m, (g (i + 1) - g i) = g m - g n`.

Used by `em2_finite` to collapse the sum of the per-period endpoint
differences `f′(j+1) − f′(j)` into `f′(m) − f′(n)`. `n = m` is the
reflexive base case. -/
theorem ico_sum_telescope (g : ℕ → 𝕜) (n m : ℕ) (hnm : n ≤ m) :
    ∑ i ∈ Finset.Ico n m, (g (i + 1) - g i) = g m - g n := by
  refine Nat.le_induction ?_ ?_ m hnm
  · simp
  · intro p _ IH
    have hsplit : Finset.Ico n (p + 1) = insert p (Finset.Ico n p) := by
      ext i
      simp [Finset.mem_Ico]
      omega
    rw [hsplit, Finset.sum_insert (by simp [Finset.mem_Ico]), IH]
    abel

section
variable (f : ℝ → 𝕜)

/-- The P4 finite second-order Euler--Maclaurin identity, global form at
    integer endpoints `n ≤ m` (outline §4/§9 -- the rigorous finite law
    behind the missing tail; the finite core of the Riemann 1859 identity).

    ```
    ∑ k ∈ Finset.Ioc n m, f k
      = ∫_n^m f + ½(f m − f n) + (1/12)(f′ m − f′ n) − ½·∫_n^m B̂₂·f″ dx
    ```

    `Set.uIcc (n : ℝ) (m : ℝ)` with `n ≤ m` is just `Set.Icc (n : ℝ)
    (m : ℝ)` (unordered closed interval), so the hypotheses are: `f`
    differentiable on `[n, m]`; `f′` continuous on `[n, m]`; `f′`
    differentiable (i.e. `f` twice differentiable) on
    `uIcc (n : ℝ) (m : ℝ)`; `f″` continuous on `[n, m]`. The edge
    terms use the ordinary `deriv` at the (hence differentiable)
    endpoints. `n = m` holds as the empty/reflexive case. -/
theorem em2_finite (n m : ℕ) (hnm : n ≤ m)
    (hf_diff : ∀ t ∈ Set.Icc (n : ℝ) (m : ℝ), DifferentiableAt ℝ f t)
    (hcont_f' : ContinuousOn (deriv f) (Set.Icc (n : ℝ) (m : ℝ)))
    (hd2 : ∀ t ∈ Set.uIcc (n : ℝ) (m : ℝ), DifferentiableAt ℝ (deriv f) t)
    (hcont_f'' : ContinuousOn (deriv (deriv f)) (Set.Icc (n : ℝ) (m : ℝ))) :
    ∑ k ∈ Finset.Ioc n m, f k =
      (∫ x in (n : ℝ)..(m : ℝ), f x) +
      (1 / 2 : 𝕜) * (f (m : ℝ) - f (n : ℝ)) +
      (1 / 12 : 𝕜) * (deriv f (m : ℝ) - deriv f (n : ℝ)) -
      (1 / 2 : 𝕜) * (∫ x in (n : ℝ)..(m : ℝ), B2 x * deriv (deriv f) x) := by
  -- n, m are naturals: floors are themselves, and B1 = -1/2 there.
  have hnfl : ⌊(n : ℝ)⌋₊ = n := by
    norm_cast
    rw [Nat.floor_eq_iff (Nat.cast_nonneg n)]
    constructor <;> norm_num
  have hmfl : ⌊(m : ℝ)⌋₊ = m := by
    norm_cast
    rw [Nat.floor_eq_iff (Nat.cast_nonneg m)]
    constructor <;> norm_num
  have hB1n : B1 (n : ℝ) = -1 / 2 := by
    dsimp only [B1]
    rw [hnfl]
    ring
  have hB1m : B1 (m : ℝ) = -1 / 2 := by
    dsimp only [B1]
    rw [hmfl]
    ring
  -- Each unit period [j, j+1] (j ∈ Ico n m) sits inside [n, m].
  have hp_Icc (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      Set.Icc (j : ℝ) (j + 1 : ℝ) ⊆ Set.Icc (n : ℝ) (m : ℝ) := by
    intro t ⟨hlo, hhi⟩
    have h1 : (n : ℝ) ≤ (j : ℝ) := Nat.cast_le.mpr (Finset.mem_Ico.mp hj).1
    have h2 : (j + 1 : ℝ) ≤ (m : ℝ) := by
      rw [show (j + 1 : ℝ) = ((j + 1 : ℕ) : ℝ) from by simp [Nat.cast_add, Nat.cast_one]]
      exact Nat.cast_le.mpr (Nat.succ_le_of_lt (Finset.mem_Ico.mp hj).2)
    exact ⟨by linarith [h1, hlo], by linarith [h2, hhi]⟩
  -- `Set.uIcc a b` is the unordered closed interval; for ordered
  -- endpoints it is just `Icc` (this is all the per-period atoms need).
  have hp_uIcc (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      Set.uIcc (j : ℝ) (j + 1 : ℝ) ⊆ Set.Icc (n : ℝ) (m : ℝ) := by
    intro t ht
    rw [Set.uIcc_of_le (by linarith)] at ht
    exact hp_Icc j hj ht
  have hp_uIcc_to (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      Set.uIcc (j : ℝ) (j + 1 : ℝ) ⊆ Set.uIcc (n : ℝ) (m : ℝ) := by
    intro t ht
    rw [Set.uIcc_of_le (by linarith)] at ht
    exact Set.mem_uIcc_of_le (hp_Icc j hj ht).1 (hp_Icc j hj ht).2
  -- Per-period integrability of the two stitched integrands. The period
  -- endpoint is written in nat-cast form `((j + 1 : ℕ) : ℝ)` so that it
  -- matches `a (k + 1)` in `sum_integral_adjacent_intervals_Ico` (the
  -- SumIntegralComparisons pattern); the real-add form is bridged by
  -- `Nat.cast_add` / `Nat.cast_one`.
  have hIB1 (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      IntervalIntegrable (fun t => deriv f t * B1 t) volume (j : ℝ) ((j + 1 : ℕ) : ℝ) := by
    simpa [Nat.cast_add, Nat.cast_one] using
      intervalIntegrable_deriv_mul_B1 (f := f) (a := (j : ℝ)) (b := (j + 1 : ℝ))
        (by norm_num) (by norm_num) (hcont_f'.mono (hp_uIcc j hj))
  have hIB2 (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      IntervalIntegrable (fun t => B2 t * deriv (deriv f) t) volume (j : ℝ) ((j + 1 : ℕ) : ℝ) := by
    simpa [Nat.cast_add, Nat.cast_one] using
      intervalIntegrable_B2_mul_deriv2 f (j : ℝ) (j + 1 : ℝ) (by norm_num) (by norm_num)
        (hcont_f''.mono (hp_uIcc j hj))
  -- The per-period second-order identity (atom-2, the RCLike core) on each j.
  have hper (j : ℕ) (hj : j ∈ Finset.Ico n m) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x) =
        (1 / 12 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
        (1 / 2 : 𝕜) * (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) :=
    int_B1f'_period (f := f) (j := j)
      (fun t ht => hd2 _ (hp_uIcc_to j hj ht))
      (hcont_f'.mono (hp_uIcc j hj))
      (hcont_f''.mono (hp_uIcc j hj))
  -- Stitch the per-period identity over [n, m]: additivity, endpoint-form
  -- bridges (Nat.cast_add / Nat.cast_one), per-period application, scalar
  -- extraction, additivity again, telescope.
  have hstitch : (∫ x in (n : ℝ)..(m : ℝ), deriv f x * B1 x) =
      (1 / 12 : 𝕜) * (deriv f (m : ℝ) - deriv f (n : ℝ)) -
      (1 / 2 : 𝕜) * (∫ x in (n : ℝ)..(m : ℝ), B2 x * deriv (deriv f) x) := by
    calc
      (∫ x in (n : ℝ)..(m : ℝ), deriv f x * B1 x)
          = ∑ j ∈ Finset.Ico n m, (∫ x in (j : ℝ)..((j + 1 : ℕ) : ℝ), deriv f x * B1 x) := by
        rw [← sum_integral_adjacent_intervals_Ico (a := fun k => (k : ℝ))
          (hmn := hnm) (hint := fun j hj => hIB1 j (by simpa using hj))]
      _ = ∑ j ∈ Finset.Ico n m, (∫ x in (j : ℝ)..(j + 1 : ℝ), deriv f x * B1 x) := by
        simp only [Nat.cast_add, Nat.cast_one]
      _ = ∑ j ∈ Finset.Ico n m, (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x) := by
        apply Finset.sum_congr rfl
        intro j _
        apply intervalIntegral.integral_congr
        intro x _
        ring
      _ = ∑ j ∈ Finset.Ico n m,
          ((1 / 12 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
          (1 / 2 : 𝕜) * (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x)) := by
        refine Finset.sum_congr rfl (fun j hj => hper j hj)
      _ = (1 / 12 : 𝕜) * (∑ j ∈ Finset.Ico n m, (deriv f (j + 1 : ℝ) - deriv f (j : ℝ))) -
          (1 / 2 : 𝕜) * (∑ j ∈ Finset.Ico n m,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x)) := by
        rw [Finset.sum_sub_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
      _ = (1 / 12 : 𝕜) * (∑ j ∈ Finset.Ico n m,
            (deriv f ((j + 1 : ℕ) : ℝ) - deriv f (j : ℝ))) -
          (1 / 2 : 𝕜) * (∑ j ∈ Finset.Ico n m,
            (∫ x in (j : ℝ)..((j + 1 : ℕ) : ℝ), B2 x * deriv (deriv f) x)) := by
        simp only [Nat.cast_add, Nat.cast_one]
      _ = (1 / 12 : 𝕜) * (deriv f (m : ℝ) - deriv f (n : ℝ)) -
          (1 / 2 : 𝕜) * (∫ x in (n : ℝ)..(m : ℝ), B2 x * deriv (deriv f) x) := by
        rw [ico_sum_telescope (fun j => deriv f (j : ℝ)) n m hnm,
          sum_integral_adjacent_intervals_Ico (a := fun k => (k : ℝ)) (hmn := hnm)
            (hint := fun j hj => hIB2 j (by simpa using hj))]
  calc
    ∑ k ∈ Finset.Ioc n m, f k
        = ∑ k ∈ Finset.Ioc ⌊(n : ℝ)⌋₊ ⌊(m : ℝ)⌋₊, f k := by
      rw [hnfl, hmfl]
    _ = f (n : ℝ) * B1 (n : ℝ) - f (m : ℝ) * B1 (m : ℝ) +
        (∫ x in (n : ℝ)..(m : ℝ), f x) +
        (∫ x in (n : ℝ)..(m : ℝ), deriv f x * B1 x) := by
      exact sum_eq_integral_add_integral_deriv (f := f) (a := (n : ℝ)) (b := (m : ℝ))
        (Nat.cast_nonneg n) (Nat.cast_le.mpr hnm) hf_diff
        (hcont_f'.mono (Set.uIcc_subset_Icc ⟨le_rfl, Nat.cast_le.mpr hnm⟩ ⟨Nat.cast_le.mpr hnm, le_rfl⟩))
    _ = (1 / 2 : 𝕜) * (f (m : ℝ) - f (n : ℝ)) +
        (∫ x in (n : ℝ)..(m : ℝ), f x) +
        (∫ x in (n : ℝ)..(m : ℝ), deriv f x * B1 x) := by
      rw [hB1n, hB1m]
      push_cast
      ring
    _ = (1 / 2 : 𝕜) * (f (m : ℝ) - f (n : ℝ)) +
        (∫ x in (n : ℝ)..(m : ℝ), f x) +
        (((1 / 12 : 𝕜) * (deriv f (m : ℝ) - deriv f (n : ℝ))) -
        (1 / 2 : 𝕜) * (∫ x in (n : ℝ)..(m : ℝ), B2 x * deriv (deriv f) x)) := by
      rw [hstitch]
    _ = (∫ x in (n : ℝ)..(m : ℝ), f x) +
        (1 / 2 : 𝕜) * (f (m : ℝ) - f (n : ℝ)) +
        (1 / 12 : 𝕜) * (deriv f (m : ℝ) - deriv f (n : ℝ)) -
        (1 / 2 : 𝕜) * (∫ x in (n : ℝ)..(m : ℝ), B2 x * deriv (deriv f) x) := by
      ring

end

end
