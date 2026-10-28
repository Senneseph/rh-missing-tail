import Mathlib

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

end W2SAtZeros
