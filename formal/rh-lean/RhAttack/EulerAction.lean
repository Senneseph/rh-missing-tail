/-
  Euler action identity (E7a) — the exact finite-sum identity, machine-checked.

  PROVENANCE (formula-ledger discipline, FORMULAS.md):
    Statement : THE-EULER-ACTION.md §1; FORMULAS.md §2.1 (Euler action /
                Abel-summation form: series side = action side).
    Oracle    : scripts/rh/day006_e7a_action_identity.py — dps-50, 5/5 PASS
                (record: scripts/rh/out_day006_euler_action_identity.txt).
    Port check: scripts/rh/out_day011_e7a_oracle20.txt — dps-20 LHS values of
                the same 5 instances; used by E7a.lean to cross-check the
                ported data (P-0.2 cross-engine discipline).

  THE IDENTITY. For any sequence a : ℕ → K, any weights b : ℕ → K, with

      A(k) := a(1) + a(2) + ... + a(k)          (A(0) = 0),

  and any N ≤ M:

      seriesSide  =  Σ_{n = N+1}^{M} a(n) · b(n)

      actionSide  =  A(M)·b(M) − A(N)·b(N)
                     + Σ_{m = N}^{M−1} A(m) · (b(m) − b(m+1))

      seriesSide = actionSide        holds EXACTLY, in every commutative ring.

  No analysis, no numerics, no convergence: pure finite algebra.
  The "Euler action" flavor is the choice of weights b(n) = n^(−s) —
  see E7a.lean, where the five oracle instances are re-instantiated
  with K = ℂ and cross-checked against the Python oracle (#eval).

  The 1-D sum below is written over Ico N M = {m | N ≤ m < M} (the
  half-open interval [N, M)); this is exactly {N, ..., M−1} when N ≤ M.
-/
import Mathlib

set_option linter.style.header false

universe u

variable {K : Type u} [CommRing K]

/-- Prefix sum  A(k) := ∑_{i=1}^{k} a(i),  with A(0) = 0 (empty sum). -/
def APart (a : ℕ → K) (k : ℕ) : K := ∑ i ∈ Finset.Icc 1 k, a i

@[simp] theorem APart_zero (a : ℕ → K) : APart a 0 = 0 := by
  simp [APart]

@[simp] theorem APart_succ (a : ℕ → K) (k : ℕ) :
    APart a (k + 1) = APart a k + a (k + 1) := by
  rw [APart, Finset.sum_Icc_succ_top (show 1 ≤ k + 1 by omega), APart]

/-- E7a (core form, inductive on the segment length L = M − N) — the Euler
    action identity:  for all a, b, N, L,

    Σ_{n=N+1}^{N+L} a(n)·b(n)
      = A(N+L)·b(N+L) − A(N)·b(N) + Σ_{m ∈ [N, N+L)} A(m)·(b(m) − b(m+1)),

    with A(k) the prefix sum (APart).  Exact in any commutative ring —
    no analysis, no numerics. -/
theorem eulerActionLen (a b : ℕ → K) (N L : ℕ) :
    (∑ n ∈ Finset.Icc (N + 1) (N + L), a n * b n) =
      APart a (N + L) * b (N + L) - APart a N * b N +
      (∑ m ∈ Finset.Ico N (N + L), APart a m * (b m - b (m + 1))) := by
  induction L with
  | zero =>
      -- Icc (N+1) N = ∅  and  Ico N N = ∅;  the boundary terms cancel
      simp
  | succ L ih =>
      -- one more step: both sides gain the term indexed at N + L + 1
      exact calc
        (∑ n ∈ Finset.Icc (N + 1) (N + L + 1), a n * b n) = _ := by
          rw [Finset.sum_Icc_succ_top (show N + 1 ≤ N + L + 1 by omega)]
        _ = _ := by
          rw [ih]
        _ = _ := by
          -- normalize  N + (L+1)  to  (N+L)+1 in the whole goal, then use
          --  Ico N (N+L+1) = Ico N (N+L) ∪ {N+L}  and the APart telescoping
          rw [show (N + (L + 1) : ℕ) = N + L + 1 by ring] at *
          have hset : Finset.Ico N (N + L + 1) =
              insert (N + L) (Finset.Ico N (N + L)) := by
            ext x
            simp only [Finset.mem_Ico, Finset.mem_insert]
            by_cases hx : x = N + L
            · subst hx
              omega
            · omega
          rw [hset, Finset.sum_insert (by simp [Finset.mem_Ico]), APart_succ]
          ring

/-- E7a — the Euler action identity.  For all a, b and N ≤ M:

    Σ_{n=N+1}^{M} a(n)·b(n)
      = A(M)·b(M) − A(N)·b(N) + Σ_{m=N}^{M−1} A(m)·(b(m) − b(m+1)),

    with A(k) the prefix sum (APart).  Exact in any commutative ring. -/
theorem eulerAction (a b : ℕ → K) (N M : ℕ) (h : N ≤ M) :
    (∑ n ∈ Finset.Icc (N + 1) M, a n * b n) =
      APart a M * b M - APart a N * b N +
      (∑ m ∈ Finset.Ico N M, APart a m * (b m - b (m + 1))) := by
  rw [← Nat.add_sub_of_le h]
  exact eulerActionLen a b N (M - N)
