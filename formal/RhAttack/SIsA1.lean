import Mathlib
import RhAttack.SIs
import RhAttack.W2SAtZeros
import RhAttack.W2Beyond3

open BigOperators

open Real
open W2T
open W2SAtZeros

noncomputable section

namespace SIsA1

/-!
# SIsA1 — the A1 clause under the named input [IS-S] (no axioms)

## ROLE
`W2B3.a1_universal_wire` / `a1_universal_o1` (W2Beyond3) close the far-side
kernel HALF of the S1-vs-Rsum oscillation under the walk-side A1 clause

    hA1_0, hA1M, hA1 :  |DN N0 Nas j| ≤ K  on the zero grid,

where the DATA-FREE universal K was the open item of that module (the
measured/certified ledger K's only cover the certified (10^7, 3×10^10] band).

This module discharges the A1 clause from the named input [IS-S]
(`SIs.ismailSBound`: Ismail's explicit finite-height bound
|S(T)| ≤ c1·log T + c2·log log T + c3 for T ≥ e, Zenodo 23301655 v3,
row T_opt = 3e12) via the REVERSE S→DN conversion:

    |d| = |sDefect d + 1/8| ≤ |sDefect d| + 1/8      (triangle)

combined with the increasing gauge `SIs.sboundMon`, so on any zero grid
x_0 = g1 ≤ x_1 ≤ ... ≤ x_M within the gauge domain,

    |DN_j| ≤ SIs.Sbound (x_M) + 1/8        (single data-free K over the grid),

and `a1_universal_o1` then delivers the oscillation bound
K·(17/8) with K read off the named input alone.

## HONESTY
LEAN-PROVEN: the pointwise + universal reverse conversions, the
increasing-gauge composition, the A1-triple elimination and the O(1)
consequence — all pure arithmetic over `SIs.sboundMon` and
`W2B3.a1_universal_o1`.  The single DATA-SIDE hypothesis carried is the
identification at the grid nodes |S(x_j)| = |sDefect (DN N0 Nas j)| — the
exact RVM object identity (S = DN − 1/8, the 7/8 − 3/4 shift of
`W2SAtZeros.rvmShiftCore` read at the grid nodes; the O(1/T) RvM count
remainder is a data-side note of the named input, immaterial at the
frontier scale).  NO RH claim: [IS-S] is a named input; this module is an
in-tree consequence of it plus the W2B3 wire.
-/

/-- THE REVERSE S→DN CONVERSION, pointwise: |d − 1/8| ≤ B gives
    |d| ≤ B + 1/8 (triangle; mirror of
    `W2SAtZeros.sDefect_le_dnPlusShift`, no data). -/
theorem dn_pt_sPlusShift (d : ℝ) {B : ℝ} (hB : |sDefect d| ≤ B) :
    |d| ≤ B + 1 / 8 := by
  calc |d|
      = |(sDefect d : ℝ) + 1 / 8| := by
         dsimp only [sDefect]
         ring
    _ ≤ |sDefect d| + 1 / 8 := by
         calc |(sDefect d : ℝ) + 1 / 8|
             ≤ |sDefect d| + |(1 / 8 : ℝ)| := abs_add_le (sDefect d) (1 / 8 : ℝ)
           _ = |sDefect d| + 1 / 8 := by
             rw [abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 8)]
    _ ≤ B + 1 / 8 := add_le_add_left hB (1 / 8 : ℝ)

/-- THE REVERSE S→DN CONVERSION, uniform over all reals: a universal S-
    defect bound |d − 1/8| ≤ K transfers to |d| ≤ K + 1/8. -/
theorem dn_le_sPlusShift {K : ℝ} :
    (∀ d : ℝ, |sDefect d| ≤ K) → (∀ d : ℝ, |d| ≤ K + 1 / 8) := by
  intro hd d
  exact dn_pt_sPlusShift d (hd d)

/-- INCREASING-GAUGE COMPOSITION: an S-defect bound by the gauge at each
    grid node lifts to a DN bound by the gauge at the grid TOP + 1/8
    (`SIs.sboundMon`: the gauge is increasing on [e, inf)). -/
theorem sgrid_dn_bound (M : ℕ) (d : ℕ → ℝ) (x : ℕ → ℝ)
    (hd : ∀ j ≤ M, exp 1 ≤ x j)
    (hinc : ∀ j ≤ M, x j ≤ x M)
    (hS : ∀ j ≤ M, |sDefect (d j)| ≤ SIs.Sbound (x j)) :
    ∀ j ≤ M, |d j| ≤ SIs.Sbound (x M) + 1 / 8 := by
  intro j hj
  exact dn_pt_sPlusShift (d j) (
    le_trans (hS j hj) (SIs.sboundMon (x j) (x M) (hd j hj) (hinc j hj)))

/-- THE NAMED-INPUT BRIDGE: [IS-S] + the RVM identification at the grid
    nodes give |DN_j| ≤ Sbound(x_j) + 1/8 at each node (data-free: the
    K-scale is Ismail's gauge itself). -/
theorem ismail_sgrid_dn (M : ℕ) (d : ℕ → ℝ) (x : ℕ → ℝ)
    (S' : ℝ → ℝ) (hIS : SIs.ismailSBound S')
    (hd : ∀ j ≤ M, exp 1 ≤ x j)
    (hsid : ∀ j ≤ M, |S' (x j)| = |sDefect (d j)|) :
    ∀ j ≤ M, |d j| ≤ SIs.Sbound (x j) + 1 / 8 := by
  intro j hj
  have hISj := hIS (x j) (hd j hj)
  exact dn_pt_sPlusShift (d j) (by simpa [hsid j hj] using hISj)

/-- The gauge is positive on its domain (c1 log T, c2 log log T, c3 all
    nonneg with c3 > 0; log T ≥ 1, log log T ≥ 0 on [e, inf)). -/
theorem boundPos {T : ℝ} (hT : exp 1 ≤ T) : (0 : ℝ) < SIs.Sbound T := by
  dsimp only [SIs.Sbound]
  have hc1 : (0 : ℝ) < SIs.c1 := by
    unfold SIs.c1
    norm_num
  have hc2 : (0 : ℝ) ≤ SIs.c2 := by
    unfold SIs.c2
    norm_num
  have hc3 : (0 : ℝ) < SIs.c3 := by
    unfold SIs.c3
    norm_num
  have hlog : (1 : ℝ) ≤ Real.log T := by
    have := Real.log_le_log (by positivity : 0 < (Real.exp 1 : ℝ)) hT
    simpa using this
  have hlogp : (0 : ℝ) < Real.log T := by linarith [hlog]
  have hll : (0 : ℝ) ≤ Real.log (Real.log T) :=
    Real.log_nonneg hlog
  nlinarith [mul_nonneg hc2 hll, mul_nonneg (le_of_lt hc1) (le_of_lt hlogp), hc3]

/-- THE O(1) CONSEQUENCE: the A1-triple (hA1_0, hA1M, hA1) is discharged by
    [IS-S] + the RVM identification on any ascending grid in the gauge
    domain starting at the frontier g1: the S1-vs-Rsum oscillation is bounded
    by (Sbound(x_M) + 1/8)·(17/8) - K read off the named input alone. -/
theorem a1_o1_from_ismail (M : ℕ) (N0 : ℕ) (Nas : ℕ → ℝ) (x : ℕ → ℝ)
    (t g1 : ℝ) (S' : ℝ → ℝ)
    (hIS : SIs.ismailSBound S')
    (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hgrid : ∀ j ≤ M, exp 1 ≤ x j)
    (hinc : ∀ j ≤ M, x j ≤ x M)
    (hsid : ∀ j ≤ M, |S' (x j)| = |sDefect (DN N0 Nas j)|) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      (SIs.Sbound (x M) + 1 / 8) * (17 / 8) := by
  have hK : ∀ j ≤ M, abs (DN N0 Nas j) ≤ SIs.Sbound (x M) + 1 / 8 := by
    intro j hj
    have hSj := hIS (x j) (hgrid j hj)
    have hSj' : |sDefect (DN N0 Nas j)| ≤ SIs.Sbound (x M) :=
      le_trans (by simpa [hsid j hj] using hSj)
        (SIs.sboundMon (x j) (x M) (hgrid j hj) (hinc j hj))
    exact dn_pt_sPlusShift (DN N0 Nas j) hSj'
  apply W2B3.a1_universal_o1 M N0 Nas x t g1 (SIs.Sbound (x M) + 1 / 8)
    hM h1 hfar hx0 hxinc
  · linarith [boundPos (hgrid M le_rfl)]
  · exact hK 0 (by norm_num : (0 : ℕ) ≤ M)
  · exact hK M le_rfl
  · intro j hj
    exact hK j (le_of_lt (Finset.mem_range.mp hj))

end SIsA1
end
