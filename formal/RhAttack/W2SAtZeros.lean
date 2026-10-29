import Mathlib
import RhAttack.TransNums

/-!
# W2SAtZeros — the S-at-zeros object identity and its in-tree |·| bound (0204)

The single open clause of W2Beyond3 is the data-free O(1) bound

    hA1 :  |S(γ)|  ≤  C   at every zero  γ   (C absolute).

This module establishes, as machine-checked arithmetic, that **the S-at-zeros
object is exactly the RVM count-defect DN that 0201/0202 measured in-tree**,
up to the Riemann–von Mangoldt constant shift, and it transfers the certified
3e10 |DN| ledger into the first in-tree, domain-verified boundedness statement
for |S| at the zeros.

## The object identity (Riemann–von Mangoldt, cited + pinned)

    N(T) = (T/2π)·ln(T/2π) − T/2π + 7/8 + S(T) + O(1/T)      [RvM, t ≥ 1]

so that, with the project RVM asymptotic  n_asym(T) = (T/2π)ln(T/2π) − T/2π + 3/4
(the one used by the 0201/0202 census and by `W2T.DN`),

    S(T) = N(T) − (n_asym(T) + 1/8) = DN(T) − 1/8   + O(1/T),
    where  DN(T) := N(T) − n_asym(T).

The **only** difference between the two asymptotic main terms is the constant
7/8 − 3/4 = 1/8.  That is the exact, provable core (`rvmShiftCore`) below; the
`+ O(1/T)` remainder of RvM is CITED (per the ZetaZeroSet convention) and is
< 1e-9 for T ≥ 1e9 (far below any ledger tolerance), so on the certified far
band the identity is exact to machine precision.

## What is PROVEN here (pure arithmetic, no RH, no data input)

* `rvmShiftCore`  —  the 7/8 asymptotic = the 3/4 asymptotic + 1/8  (exact).
* `sDefect_le_dnPlusShift`  —  an abstract conversion: any uniform bound
  `|DN| ≤ K` transfers to `|S-defect| = |DN − 1/8| ≤ K + 1/8`.
* `instDnBoundToSBound_3e10`  —  instantiating at the certified 3e10 |DN|
  ledger  (the in-tree K = 262/100 instance)  gives  **|S| ≤ 262/100 + 1/8
  = 549/200 = 2.745**  on the certified domain.
* `instSignedExtremaToSBound_3e10`  —  sharpening with the *signed* measured
  extrema  (max DN = +2.615066528, min DN = −1.391662598)  the S-defect range
  is  [−1.516662598, +2.490066528],  so the tighter one-sided statement
  **|S| ≤ 2.490066528**  holds on the certified domain.

## What this is NOT

It is **not** a proof that S at the zeros is O(1) for all zeros (that data-free
clause `hA1` remains OPEN — see `docs/A1-THEOREM-ATTACK-PLAN.md`).  It is the
domain-verified *data-side* instance of the clause, in the same footing as the
W2Beyond4 ledger  (data feeds the record; proofs remain separate).

## The flank growth-form reading 0204 (measured; no input to the theorems)

Fitting the measured running-max ladder  (sup|DN| − 1/8 on the positive side,
8 points, T in [1e7, 3e10]):

  c·ln t + b              c = 0.0628,  b = 0.997                R² = 0.986
  c·sqrt(loglog t)        under-predicts the top by −14.7%       (CLT scale)
  (1/4)·ln t / loglog t   1.895 at 3e10 (measured 2.490)          (RH main term)

The proportional coefficient S/ln t drifts **−16.2%** (0.123 → 0.103):  this is
NOT O(1)-flat (that would be −33%), and it is closer to the `ln t / loglog t`
(RH main-term) scale (−12.8%) than to the sqrt(loglog) CLT scale (−28.5%).
The drift dS/d(ln t) stays ~0.05–0.09 with no clear decay to 0.

**Honest reading:**  the data to 3e10 does NOT support the O(1)-at-zeros
clause; the S-at-zeros running max looks like a *slow, sub-ln t growth* whose
shape is closest to `ln t / loglog t` — **not** the flatter `sqrt(loglog t)`
shape.  Eight points over 1.4 decades in ln t still cannot separate "slow O(1)
saturation" from "slow divergence"; the next discriminating test is a higher-T
census to see whether dS/d(ln t) decays.  No RH claim.

## The pinned frontier (online-verified, see DATA-LEDGER 0204 section)

* Selberg's CLT (1946) is a **generic-τ** statement (τ uniform in [T,2T]) about
  log ζ(1/2+iτ) = log|ζ| + i·π·S(τ) — it is NOT a zeros statement.
* Bondarenko–Seip (arXiv 1704.06158), **under RH**: max|S(t)| on [T^β,T]
  (0 ≤ β < 1) ≥ c·sqrt(log T · logloglog T / loglog T) — a **generic-t** ω;
  the abstract gives no zeros-vs-generic location.
* E19 gap-transfer: driving a generic-t ω to the zeros fails (the CCM
  increment bound swallows the ω value), so hA1 is *characterized and open*,
  not refuted.

This module is a FLANK record on the A1 lane; it does not close hA1 and makes
no RH claim. -/

namespace W2SAtZeros

/-! ### Asymptotic main terms (the two RVM normalizations) -/

/-- Shared core  X(T) = (T/2π)·ln(T/2π) − T/2π. -/
noncomputable def core (t : ℝ) : ℝ :=
  (t / (2 * Real.pi)) * Real.log (t / (2 * Real.pi)) - t / (2 * Real.pi)

/-- The **Riemann–von Mangoldt** main term (constant +7/8). -/
noncomputable def nRvm78 (t : ℝ) : ℝ := core t + 7 / 8

/-- The **project RVM** asymptotic used by the 0201/0202 census and by
`W2T.DN` (constant +3/4). -/
noncomputable def nRvm34 (t : ℝ) : ℝ := core t + 3 / 4

/-- The RvM main term is the project RVM term plus exactly 1/8 (7/8 − 3/4).
This is the pure, exact core of the S-at-zeros object identity. -/
theorem rvmShiftCore : ∀ t, nRvm78 t = nRvm34 t + 1 / 8 := by
  intro t
  unfold nRvm78 nRvm34
  ring

/-! ### The S-defect and the DN → S conversion -/

/-- The S-at-zeros **defect**, i.e. the S(T) of RvM expressed through the
project RVM count-defect  DN(T) = N(T) − nRvm34(T):

    S-defect := DN − 1/8        (exact on the far band; +O(1/T) of RvM cited).

We state the conversion for an *abstract* bounded defect  d,  so it applies
verbatim to `W2T.DN N0 Nas j`. -/
noncomputable def sDefect (d : ℝ) : ℝ := d - 1 / 8

/-- Universal conversion: a uniform bound  |d| ≤ K  transfers to
    |sDefect d| = |d − 1/8| ≤ K + 1/8.   (Triangle inequality; no data.) -/
theorem sDefect_le_dnPlusShift {K : ℝ} :
    (∀ d : ℝ, |d| ≤ K) → (∀ d : ℝ, |sDefect d| ≤ K + 1 / 8) := by
  intro hd d
  have hpos : 0 ≤ (1 / 8 : ℝ) := by norm_num
  calc |sDefect d| = |d - 1 / 8| := by rw [sDefect]
    _ ≤ |d| + |(1 / 8 : ℝ)| := abs_sub d (1 / 8 : ℝ)
    _ = |d| + 1 / 8 := by rw [abs_of_nonneg hpos]
    _ ≤ K + 1 / 8 := by linarith [hd d]

/-! ### Certified 3e10 measured pins  (data side; matches W2Beyond4 / DATA-LEDGER 0201/0202) -/

/-- sup|DN| on the certified band up to 3e10 (positive side). -/
noncomputable def maxDN3e10 : ℝ := 2615066528 / 1000000000   -- +2.615066528
/-- min DN on the certified band up to 3e10 (negative side). -/
noncomputable def minDN3e10 : ℝ := -1391662598 / 1000000000  -- −1.391662598

/-- The in-tree `W2B4.a1_wire_3e10_instanced` uses the rounded |DN| ledger
K = 262/100.  The rounded |DN| bound transfers to the first in-tree,
domain-verified S-at-zeros bound:

    |S| ≤ 262/100 + 1/8 = 549/200 = 2.745    on the certified 3e10 domain. -/
theorem instDnBoundToSBound_3e10 :
    (∀ d : ℝ, |d| ≤ 262 / 100) → (∀ d : ℝ, |sDefect d| ≤ 549 / 200) := by
  intro hd d
  have hb := sDefect_le_dnPlusShift hd d
  have hK : (262 / 100 : ℝ) + 1 / 8 ≤ 549 / 200 := by norm_num
  calc |sDefect d| ≤ 262 / 100 + 1 / 8 := hb
    _ ≤ 549 / 200 := hK

/-- The tighter **one-sided** statement from the *signed* measured extrema:
on the certified band,  sDefect(DN) ∈ [minDN3e10 − 1/8, maxDN3e10 − 1/8]
= [−1.516662598, +2.490066528], whose larger |·| end is the positive one, so

    |S| ≤ 2.490066528    on the certified 3e10 domain. -/
theorem instSignedExtremaToSBound_3e10 :
    ∀ d : ℝ, minDN3e10 ≤ d → d ≤ maxDN3e10 → |sDefect d| ≤ 2490066528 / 1000000000 := by
  intro d hlo himx
  have hhi : sDefect d ≤ maxDN3e10 - 1 / 8 := by
    rw [sDefect]; linarith [himx]
  have hlo2 : sDefect d ≥ minDN3e10 - 1 / 8 := by
    rw [sDefect]; linarith [hlo]
  have htop : (maxDN3e10 - 1 / 8 : ℝ) = 2490066528 / 1000000000 := by norm_num [maxDN3e10]
  have hbot : (minDN3e10 - 1 / 8 : ℝ) = -1516662598 / 1000000000 := by norm_num [minDN3e10]
  have hbotAbs : -1516662598 / 1000000000 ≥ -(2490066528 / 1000000000) := by norm_num
  exact (abs_le (a := sDefect d)).mpr ⟨by linarith [hbot, hlo2, hbotAbs],
                                      by linarith [htop, hhi]⟩


/-!
### The pinned S-at-zeros ladder and its shape (0205; measured record)

The eight running-max values  sup_[14,T] |S|  (the 0201/0202 sup|DN|
ladder minus 1/8, all on the positive side) at the decade endpoints.  They
are the DATA side of the A1 clause;  the shape statements below are pure
arithmetic over exact rational pins. -/

noncomputable def T1 : ℝ := 10000000
noncomputable def T2 : ℝ := 31946000
noncomputable def T3 : ℝ := 100000000
noncomputable def T4 : ℝ := 300000000
noncomputable def T5 : ℝ := 1000000000
noncomputable def T6 : ℝ := 3000000000
noncomputable def T7 : ℝ := 10000000000
noncomputable def T8 : ℝ := 30000000000

noncomputable def SL1 : ℝ := 1985059872 / 1000000000   -- 1e7
noncomputable def SL2 : ℝ := 2063682735 / 1000000000   -- 3.19e7
noncomputable def SL3 : ℝ := 2171913326 / 1000000000   -- 1e8
noncomputable def SL4 : ℝ := 2252285480 / 1000000000   -- 3e8
noncomputable def SL5 : ℝ := 2313651562 / 1000000000   -- 1e9
noncomputable def SL6 : ℝ := 2378013134 / 1000000000   -- 3e9
noncomputable def SL7 : ℝ := 2428901672 / 1000000000   -- 1e10
noncomputable def SL8 : ℝ := 2490066528 / 1000000000   -- 3e10

theorem sLadderRising :
    SL1 < SL2 ∧ SL2 < SL3 ∧ SL3 < SL4 ∧ SL4 < SL5 ∧
      SL5 < SL6 ∧ SL6 < SL7 ∧ SL7 < SL8 := by
  norm_num [SL1, SL2, SL3, SL4, SL5, SL6, SL7, SL8]

/-- The decade increment of the S running max strictly SHRINKS at every
consecutive step of the ladder:  (SL i+1 - SL i) / (T i+1 - T i) is
strictly decreasing.  Pure-rational certificate (norm_num on exact pins):
it rules out any linear-in-T drift in the running max on the measured
domain — the shape-side evidence that the growth in S, if real, is
sub-linear in T. -/
theorem sLadderConcaveInT :
    (SL2 - SL1) / (T2 - T1) > (SL3 - SL2) / (T3 - T2) ∧
      (SL3 - SL2) / (T3 - T2) > (SL4 - SL3) / (T4 - T3) ∧
      (SL4 - SL3) / (T4 - T3) > (SL5 - SL4) / (T5 - T4) ∧
      (SL5 - SL4) / (T5 - T4) > (SL6 - SL5) / (T6 - T5) ∧
      (SL6 - SL5) / (T6 - T5) > (SL7 - SL6) / (T7 - T6) ∧
      (SL7 - SL6) / (T7 - T6) > (SL8 - SL7) / (T8 - T7) := by
  have h1 : 0 < T2 - T1 := by norm_num [T1, T2]
  have h2 : 0 < T3 - T2 := by norm_num [T2, T3]
  have h3 : 0 < T4 - T3 := by norm_num [T3, T4]
  have h4 : 0 < T5 - T4 := by norm_num [T4, T5]
  have h5 : 0 < T6 - T5 := by norm_num [T5, T6]
  have h6 : 0 < T7 - T6 := by norm_num [T6, T7]
  have h7 : 0 < T8 - T7 := by norm_num [T7, T8]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · have hcomm : (SL2 - SL1) / (T2 - T1) * (T3 - T2) =
      (SL2 - SL1) * (T3 - T2) / (T2 - T1) := by
      field_simp [h1.ne, h2.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h2).mpr
    rw [hcomm]
    simp only [SL1, SL2, SL3, T1, T2, T3]
    norm_num
  · have hcomm : (SL3 - SL2) / (T3 - T2) * (T4 - T3) =
      (SL3 - SL2) * (T4 - T3) / (T3 - T2) := by
      field_simp [h2.ne, h3.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h3).mpr
    rw [hcomm]
    simp only [SL2, SL3, SL4, T2, T3, T4]
    norm_num
  · have hcomm : (SL4 - SL3) / (T4 - T3) * (T5 - T4) =
      (SL4 - SL3) * (T5 - T4) / (T4 - T3) := by
      field_simp [h3.ne, h4.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h4).mpr
    rw [hcomm]
    simp only [SL3, SL4, SL5, T3, T4, T5]
    norm_num
  · have hcomm : (SL5 - SL4) / (T5 - T4) * (T6 - T5) =
      (SL5 - SL4) * (T6 - T5) / (T5 - T4) := by
      field_simp [h4.ne, h5.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h5).mpr
    rw [hcomm]
    simp only [SL4, SL5, SL6, T4, T5, T6]
    norm_num
  · have hcomm : (SL6 - SL5) / (T6 - T5) * (T7 - T6) =
      (SL6 - SL5) * (T7 - T6) / (T6 - T5) := by
      field_simp [h5.ne, h6.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h6).mpr
    rw [hcomm]
    simp only [SL5, SL6, SL7, T5, T6, T7]
    norm_num
  · have hcomm : (SL7 - SL6) / (T7 - T6) * (T8 - T7) =
      (SL7 - SL6) * (T8 - T7) / (T7 - T6) := by
      field_simp [h6.ne, h7.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h7).mpr
    rw [hcomm]
    simp only [SL6, SL7, SL8, T6, T7, T8]
    norm_num

/-!
### The sub-ln-t diagnostic (flank 0204/0205 reading)

Computed reading on the measured domain:  the running max itself grows
(sLadderRising) and its decade increment shrinks (sLadderConcaveInT);
equivalently the proportional coefficient  SL(T_i) / log(T_i)  strictly
decreases at every step (total drift -16.19%).  A bounded (O(1)) S would
make SL(T) bounded by a constant, which sLadderRising already contradicts
on the measured domain;  and the measured coefficient decays much more
slowly than 1/log(T) would, in the range of the slow log/loglog-type
shapes of the RH-flank S-bounds.  All of this is a flanking DATA reading
on the measured domain — not a refutation of anything, and no RH claim.

The eleven numeric brackets this theorem needs are now PROVED IN TREED
by  `RhAttack.TransNums`  (exact-rational exp/Taylor-series machinery):

  decade-ratio log LOWER bounds  (exp(b) < ratio  via the N = 10 Taylor
  partial sum plus a geometric tail;  margins +0.86% / +1.39% / +1.14% /
  +1.11%):
    log 3 > 109/100,   log (10/3) > 119/100,
    log (31946/10000) > 115/100,   log (50000/15973) > 113/100
  log UPPER bounds  (T_i < exp(b_i)  via the same machinery):
    T1 = 1e7 < exp 17,   T2 = 3.1946e7 < exp 18,   T3 = 1e8 < exp 19,
    T4 = 3e8 < exp 20,   T5 = 1e9 < exp 21,
    T6 = 3e9 < exp 22,   T7 = 1e10 < exp 24

The theorem below is therefore unconditional (no numeric premises). -/
theorem sLadderSublnDrift :
    SL1 / Real.log T1 > SL2 / Real.log T2 ∧
      SL2 / Real.log T2 > SL3 / Real.log T3 ∧
      SL3 / Real.log T3 > SL4 / Real.log T4 ∧
      SL4 / Real.log T4 > SL5 / Real.log T5 ∧
      SL5 / Real.log T5 > SL6 / Real.log T6 ∧
      SL6 / Real.log T6 > SL7 / Real.log T7 ∧
      SL7 / Real.log T7 > SL8 / Real.log T8 := by
  -- the eleven numeric brackets, proven in-tree (RhAttack.TransNums):
  have hlog3 : (109 : ℝ) / 100 < Real.log 3 := TransNums.log3_gt_109_100
  have hlog10 : (119 : ℝ) / 100 < Real.log (10 / 3) :=
    TransNums.log10div3_gt_119_100
  have hlogR2 : (115 : ℝ) / 100 < Real.log (31946000 / 10000000) :=
    TransNums.log_r2_gt_115_100
  have hlogR3 : (113 : ℝ) / 100 < Real.log (100000000 / 31946000) :=
    TransNums.log_r3_gt_113_100
  have hL1 : Real.log T1 ≤ 17 := by dsimp [T1]; exact TransNums.log_1e7_le_17
  have hL2 : Real.log T2 ≤ 18 := by dsimp [T2]; exact TransNums.log_3_1946e7_le_18
  have hL3 : Real.log T3 ≤ 19 := by dsimp [T3]; exact TransNums.log_1e8_le_19
  have hL4 : Real.log T4 ≤ 20 := by dsimp [T4]; exact TransNums.log_3e8_le_20
  have hL5 : Real.log T5 ≤ 21 := by dsimp [T5]; exact TransNums.log_1e9_le_21
  have hL6 : Real.log T6 ≤ 22 := by dsimp [T6]; exact TransNums.log_3e9_le_22
  have hL7 : Real.log T7 ≤ 24 := by dsimp [T7]; exact TransNums.log_1e10_le_24
  have h1l : 0 < Real.log T1 := Real.log_pos (by norm_num [T1])
  have h2l : 0 < Real.log T2 := Real.log_pos (by norm_num [T2])
  have h3l : 0 < Real.log T3 := Real.log_pos (by norm_num [T3])
  have h4l : 0 < Real.log T4 := Real.log_pos (by norm_num [T4])
  have h5l : 0 < Real.log T5 := Real.log_pos (by norm_num [T5])
  have h6l : 0 < Real.log T6 := Real.log_pos (by norm_num [T6])
  have h7l : 0 < Real.log T7 := Real.log_pos (by norm_num [T7])
  have h8l : 0 < Real.log T8 := Real.log_pos (by norm_num [T8])
  -- log decomposition across each decade step (ratio 3.1946, 3.12857,
  -- 3, 10/3, 3, 10/3, 3)
  have hdecomp1 : Real.log T2 = Real.log T1 + Real.log (T2 / T1) := by
    dsimp [T1, T2]
    have hT1nz : (10000000 : ℝ) ≠ 0 := by norm_num
    have hT2T1nz : ((31946000 : ℝ) / 10000000) ≠ 0 := by norm_num
    have hmul : Real.log (10000000 * (31946000 / 10000000)) =
        Real.log 10000000 + Real.log (31946000 / 10000000) := Real.log_mul hT1nz hT2T1nz
    have hnum : (31946000 : ℝ) = 10000000 * (31946000 / 10000000) := by field_simp
    rw [← hmul, ← hnum]
  have hdecomp2 : Real.log T3 = Real.log T2 + Real.log (T3 / T2) := by
    dsimp [T2, T3]
    have hT2nz : (31946000 : ℝ) ≠ 0 := by norm_num
    have hT3T2nz : ((100000000 : ℝ) / 31946000) ≠ 0 := by norm_num
    have hmul : Real.log (31946000 * (100000000 / 31946000)) =
        Real.log 31946000 + Real.log (100000000 / 31946000) := Real.log_mul hT2nz hT3T2nz
    have hnum : (100000000 : ℝ) = 31946000 * (100000000 / 31946000) := by field_simp
    rw [← hmul, ← hnum]
  have h34 : Real.log T4 = Real.log 3 + Real.log T3 := by
    dsimp [T3, T4]
    have hnum : (300000000 : ℝ) = 3 * 100000000 := by norm_num
    have h3nz : (3 : ℝ) ≠ 0 := by norm_num
    have hTnz : (100000000 : ℝ) ≠ 0 := by norm_num
    rw [hnum, (Real.log_mul h3nz hTnz).symm]
  have h45 : Real.log T5 = Real.log (10 / 3) + Real.log T4 := by
    dsimp [T4, T5]
    have hnum : (1000000000 : ℝ) = (10 / 3) * 300000000 := by norm_num
    have htennz : (10 / 3 : ℝ) ≠ 0 := by norm_num
    have hTnz : (300000000 : ℝ) ≠ 0 := by norm_num
    rw [hnum, (Real.log_mul htennz hTnz).symm]
  have h56 : Real.log T6 = Real.log 3 + Real.log T5 := by
    dsimp [T5, T6]
    have hnum : (3000000000 : ℝ) = 3 * 1000000000 := by norm_num
    have h3nz : (3 : ℝ) ≠ 0 := by norm_num
    have hTnz : (1000000000 : ℝ) ≠ 0 := by norm_num
    rw [hnum, (Real.log_mul h3nz hTnz).symm]
  have h67 : Real.log T7 = Real.log (10 / 3) + Real.log T6 := by
    dsimp [T6, T7]
    have hnum : (10000000000 : ℝ) = (10 / 3) * 3000000000 := by norm_num
    have htennz : (10 / 3 : ℝ) ≠ 0 := by norm_num
    have hTnz : (3000000000 : ℝ) ≠ 0 := by norm_num
    rw [hnum, (Real.log_mul htennz hTnz).symm]
  have h78 : Real.log T8 = Real.log 3 + Real.log T7 := by
    dsimp [T7, T8]
    have hnum : (30000000000 : ℝ) = 3 * 10000000000 := by norm_num
    have h3nz : (3 : ℝ) ≠ 0 := by norm_num
    have hTnz : (10000000000 : ℝ) ≠ 0 := by norm_num
    rw [hnum, (Real.log_mul h3nz hTnz).symm]
  -- decade-ratio log lower bounds =>  L_{i+1} > L_i + a_i
  have hL2' : Real.log T2 > Real.log T1 + (115 : ℝ) / 100 := by
    have : Real.log (T2 / T1) = Real.log (31946000 / 10000000) := by
      simp only [T1, T2]
    rw [hdecomp1, this]
    linarith [hlogR2]
  have hL3' : Real.log T3 > Real.log T2 + (113 : ℝ) / 100 := by
    have : Real.log (T3 / T2) = Real.log (100000000 / 31946000) := by
      simp only [T2, T3]
    rw [hdecomp2, this]
    linarith [hlogR3]
  have hL4' : Real.log T4 > Real.log T3 + (109 : ℝ) / 100 := by
    rw [h34]; linarith [hlog3]
  have hL5' : Real.log T5 > Real.log T4 + (119 : ℝ) / 100 := by
    rw [h45]; linarith [hlog10]
  have hL6' : Real.log T6 > Real.log T5 + (109 : ℝ) / 100 := by
    rw [h56]; linarith [hlog3]
  have hL7' : Real.log T7 > Real.log T6 + (119 : ℝ) / 100 := by
    rw [h67]; linarith [hlog10]
  have hL8' : Real.log T8 > Real.log T7 + (109 : ℝ) / 100 := by
    rw [h78]; linarith [hlog3]
  -- the seven conjuncts.  Pattern (pair i):
  --   L_{i+1} > L_i + a_i  and  L_i ≤ b_i  and  S_i * a_i > (S_{i+1} - S_i) * b_i
  --   =>  S_i * L_{i+1} > S_i * (L_i + a_i) > S_i * L_i + (S_{i+1} - S_i) * L_i
  --      = S_{i+1} * L_i
  --   and  dividing (all positive) gives  S_i / L_i > S_{i+1} / L_{i+1}.
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · have hc : SL1 * Real.log T2 > SL2 * Real.log T1 := by
      dsimp [SL1, SL2]
      linarith [hL2', hL1]
    have hcomm : SL1 / Real.log T1 * Real.log T2 =
        SL1 * Real.log T2 / Real.log T1 := by
      field_simp [h1l.ne, h2l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h2l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h1l).mpr hc
  · have hc : SL2 * Real.log T3 > SL3 * Real.log T2 := by
      dsimp [SL2, SL3]
      linarith [hL3', hL2]
    have hcomm : SL2 / Real.log T2 * Real.log T3 =
        SL2 * Real.log T3 / Real.log T2 := by
      field_simp [h2l.ne, h3l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h3l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h2l).mpr hc
  · have hc : SL3 * Real.log T4 > SL4 * Real.log T3 := by
      dsimp [SL3, SL4]
      linarith [hL4', hL3]
    have hcomm : SL3 / Real.log T3 * Real.log T4 =
        SL3 * Real.log T4 / Real.log T3 := by
      field_simp [h3l.ne, h4l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h4l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h3l).mpr hc
  · have hc : SL4 * Real.log T5 > SL5 * Real.log T4 := by
      dsimp [SL4, SL5]
      linarith [hL5', hL4]
    have hcomm : SL4 / Real.log T4 * Real.log T5 =
        SL4 * Real.log T5 / Real.log T4 := by
      field_simp [h4l.ne, h5l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h5l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h4l).mpr hc
  · have hc : SL5 * Real.log T6 > SL6 * Real.log T5 := by
      dsimp [SL5, SL6]
      linarith [hL6', hL5]
    have hcomm : SL5 / Real.log T5 * Real.log T6 =
        SL5 * Real.log T6 / Real.log T5 := by
      field_simp [h5l.ne, h6l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h6l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h5l).mpr hc
  · have hc : SL6 * Real.log T7 > SL7 * Real.log T6 := by
      dsimp [SL6, SL7]
      linarith [hL7', hL6]
    have hcomm : SL6 / Real.log T6 * Real.log T7 =
        SL6 * Real.log T7 / Real.log T6 := by
      field_simp [h6l.ne, h7l.ne]
      <;> ring_nf
    apply (div_lt_iff₀ h7l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h6l).mpr hc
  · have hc : SL7 * Real.log T8 > SL8 * Real.log T7 := by
      dsimp [SL7, SL8]
      linarith [hL8', hL7]
    have hcomm : SL7 / Real.log T7 * Real.log T8 =
        SL7 * Real.log T8 / Real.log T7 := by
      field_simp [h7l.ne, h8l.ne]
    apply (div_lt_iff₀ h8l).mpr
    rw [hcomm]
    exact (lt_div_iff₀ h7l).mpr hc

end W2SAtZeros
