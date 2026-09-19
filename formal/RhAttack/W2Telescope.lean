/-
W2Telescope (M2 of docs/W2-LEAN-PLAN.md): the finite-sum
telescope T1-T2 and the finite core of T3/T4, on an EXPLICIT
finite zero partition.  No integrals, no limits, no analytic
content — pure finite algebra.  This is the certificate
machinery the W2 bound theorem (M4) consumes.

Convention (day035 S3b/S3c/S3d verbatim, the LEFT-ENDPOINT
convention):  the partition is x_0 = G1 (a boundary point,
count N0, a natural number) < x_1 < ... < x_M = G2 (M DATA
zeros, x_j its j-th; the absolute count AT x_j is N(x_j) =
N0 + j).  Write
  p_j   := p(x_j)              (the kernel p(g;t) at the point)
  DP j  := p_(j+1) - p_j       (the p-jump over gap j)
  DN j  := (N0 + j) - Nas(x_j) (the defect at partition point j)
  S1Sum := sum_{j=1}^M p_j     (over DATA zeros only)
  DcSum := sum_{j=0}^{M-1} DN j * DP j
  B     := p_M * DN M - p_0 * DN 0
  NasSum:= sum_{j=0}^{M-1} Nas(x_j) * DP j
  RSum  := p_M * Nas M - p_0 * Nas 0 - NasSum
and use NAT indexing (j : N, p : N -> R = the p_j sequence)
for induction.  p_0 = p(G1), p_M = p(G2).

  (T1)  S1Sum = p_M*(N0 + M) - p_0*N0 - sum_{j=0}^{M-1} (N0+j)*DP j
        (the finite Stieltjes IBP — checked against data in
        every S3 run at GATE0, |d| < 1e-6, rounding only).
  (T2)  RSum = p_M*Nas M - p_0*Nas 0 - NasSum   (by definition;
        stated for spec parity).
  (T3f) S1Sum - RSum = B - DcSum.
        (The finite core of the plan's T3: writing N_j =
        DN j + Nas j in (T1) splits the sum.  The I_np piece
        of T3 and the I_DN of T4 are the INTEGRAL gap sums of
        section 1.3 — the content of M3.  Spec T4 says
        S1 - R = B - I_DN with I_DN - DcSum the per-gap
        correction; that decomposition is M3/M4, built on
        (T3f).)
-/
import Mathlib

open BigOperators

namespace W2T

def DP (p : ℕ → ℝ) (j : ℕ) : ℝ := p (j + 1) - p j

def DN (N0 : ℕ) (Nas : ℕ → ℝ) (j : ℕ) : ℝ := (N0 : ℝ) + j - Nas j

def S1Sum (M : ℕ) (p : ℕ → ℝ) : ℝ := ∑ j ∈ Finset.range M, p (j + 1)

def DcSum (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) : ℝ :=
  ∑ j ∈ Finset.range M, DN N0 Nas j * DP p j

def BTerm (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) : ℝ :=
  p M * DN N0 Nas M - p 0 * DN N0 Nas 0

def NasSum (M : ℕ) (p : ℕ → ℝ) (Nas : ℕ → ℝ) : ℝ :=
  ∑ j ∈ Finset.range M, Nas j * DP p j

def RSum (M : ℕ) (p : ℕ → ℝ) (Nas : ℕ → ℝ) : ℝ :=
  p M * Nas M - p 0 * Nas 0 - NasSum M p Nas

/-- (T1) the finite Stieltjes IBP.  Proof: induction on M;
each step adds one zero and one ring identity
`p_m (N0+m) + p_(m+1) = p_(m+1) (N0+m+1) - (N0+m) * (p_(m+1)
- p_m)`, closed by `ring`.  -/
theorem t1 (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) :
    S1Sum M p =
    p M * ((N0 : ℝ) + M) - p 0 * (N0 : ℝ) -
    ∑ j ∈ Finset.range M, ((N0 : ℝ) + j) * DP p j := by
  induction M with
  | zero =>
    simp [S1Sum, DP]
  | succ m ih =>
    rw [S1Sum, Finset.sum_range_succ]
    have hsum :
        ∑ j ∈ Finset.range (m + 1), ((N0 : ℝ) + j) * DP p j =
        ∑ j ∈ Finset.range m, ((N0 : ℝ) + j) * DP p j +
        ((N0 : ℝ) + m) * DP p m := by
      rw [Finset.sum_range_succ]
    rw [hsum, ← S1Sum, ih, DP]
    simp [Nat.cast_add, Nat.cast_one]
    ring

/-- (T2) the smooth side, by definition (spec parity).  -/
theorem t2 (M : ℕ) (p : ℕ → ℝ) (Nas : ℕ → ℝ) :
    RSum M p Nas =
    p M * Nas M - p 0 * Nas 0 -
    ∑ j ∈ Finset.range M, Nas j * DP p j := by
  rfl

/-- (T3f) the finite core of the telescope:  S1 - R = B - Dc.
Proof:  from (T1) split (N0 + j) = DN j + Nas j inside the
sum, distribute, sum_add_distrib, ring.  -/
theorem t3 (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) :
    S1Sum M p - RSum M p Nas = BTerm M p N0 Nas - DcSum M p N0 Nas := by
  rw [t1 M p N0]
  rw [BTerm, DcSum, RSum, NasSum]
  dsimp [DP, DN]
  have hsplit :
      ∑ j ∈ Finset.range M, ((N0 : ℝ) + j) * (p (j + 1) - p j) =
      ∑ j ∈ Finset.range M,
        (((N0 : ℝ) + j - Nas j) + Nas j) * (p (j + 1) - p j) := by
    apply Finset.sum_congr rfl
    intro j _
    ring
  rw [hsplit]
  have hdist :
      ∑ j ∈ Finset.range M,
          (((N0 : ℝ) + j - Nas j) + Nas j) * (p (j + 1) - p j) =
      ∑ j ∈ Finset.range M,
        (((N0 : ℝ) + j - Nas j) * (p (j + 1) - p j)
          + Nas j * (p (j + 1) - p j)) := by
    apply Finset.sum_congr rfl
    intro j _
    ring
  rw [hdist, Finset.sum_add_distrib]
  ring

end W2T
