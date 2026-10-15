import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform

open Real Set Complex

/-!
**Z78 — the external quasi-RH input (openai/math family 003) and the
strip corollary.**

PROVENANCE (no recall — every reference resolves):
  Source:  https://github.com/openai/math  (Apache-2.0, release
           2026-10-06; sparse clone at references/openai/math).
  Paper:   "The Quasi-Riemann Hypothesis: A Zero-Free Half-Plane
           Re s > 7/8" (30 Sep 2026, 199 pp); a companion 11/12
           proof (human edited) and "Uniform exclusion of
           Landau-Siegel zeros" (9 pp).  The paper states
           explicitly that RH remains OPEN.
  Lean:    the OAI library (2924 modules, ~486k lines, Lean 4.34.1)
           proves, in Mathlib's vocabulary, the exact statements
           `externalZeroFree78` / `externalZeroFreeDirichlet78` /
           `externalSiegelGap` below; the pinned Comparator
           challenge files carry the statements verbatim.
  VERIFICATION STATUS (as of 2026-10-15, logged 2026-10-15):
    * kernel-verified by at least two independent replays on
      two kernels sharing no code (Lean 4.34.1 default kernel
      + NanoDa checker; Goldblatt re-run 2026-10-07, 63 min,
      single machine; teal-sea laboratory replay 2026-10-08,
      `#print axioms` = exactly propext / Classical.choice /
      Quot.sound; Comparator runs exit 0 on the zeta,
      Dirichlet and Siegel configurations);
    * the proof import closure is published and text-scanned
      sorry-free (the sorry-freedom of the closure depends on
      a published 31k-line patch to one third-party
      dependency, pinned by the build);
    * HUMAN REVIEW IS STILL IN PROGRESS: the 199-page argument
      is largely unread as of this log entry; the Siegel-zero
      companion was checked line by line by W. D. Banks
      (arXiv 2610.15483, unrefereed); follow-up work (Baiying
      Liu, arXiv 2610.12234) imports the deep analytic inputs
      from the OpenAI preprint as a load-bearing dependency.
  STATUS IN THIS PROGRAM:  a NAMED EXTERNAL INPUT of a new
  input class — an independently kernel-verified external
  theorem (distinct from measured data faces and from
  citation-only classical facts).  It enters this module only
  as a hypothesis; the theorems below are PROVEN
  compositions from it.  No RH claim anywhere: 7/8 is not
  1/2.
  TOOLCHAIN NOTE (corroborated online, 2026-10-15):  the
  pinned Mathlib v4.33.1 predates the simp lemma
  `Complex.intCast_im` (integer cast has imaginary part 0),
  which exists in current Mathlib master (where
  `Data/Complex/Basic.lean` has moved to
  `Basic/Complex/Basic`); nothing was removed upstream.
  This module therefore proves the two integer-im
  sub-facts via `exact_mod_cast` + `ofReal_im`, which is the
  pinned-safe path.
-/

namespace Z78

/-- [Z78-ZETA]  (NAMED EXTERNAL INPUT, kernel-verified; see
    header for provenance.)  The Riemann zeta function
    (Mathlib's `riemannZeta`, the classical meromorphic
    zeta) is zero-free in the half-plane `Re s > 7/8`. -/
def externalZeroFree78 : Prop :=
  ∀ (s : ℂ), (7 / 8 : ℝ) < s.re → riemannZeta s ≠ 0

/-- [Z78-DIRICHLET]  (NAMED EXTERNAL INPUT, kernel-verified.)
    The same half-plane is zero-free for every Dirichlet
    L-function, uniformly over moduli and characters; the
    principal-character pole at `s = 1` is excluded. -/
def externalZeroFreeDirichlet78 : Prop :=
  ∀ (q : ℕ) [NeZero q] (χ : DirichletCharacter ℂ q) (s : ℂ),
    (7 / 8 : ℝ) < s.re → ¬ (χ = 1 ∧ s = 1) →
    DirichletCharacter.LFunction χ s ≠ 0

/-- [Z78-SIEGEL]  (NAMED EXTERNAL INPUT, kernel-verified;
    line-checked by Banks, arXiv 2610.15483.)  Uniform
    logarithmic exclusion of Landau-Siegel zeros: one
    constant `c > 0` works for every primitive nonprincipal
    real Dirichlet character of conductor `q >= 3`.  (Does
    not rule out real zeros elsewhere in (0,1).) -/
def externalSiegelGap : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ (q : ℕ) [NeZero q], 3 ≤ q →
    ∀ χ : DirichletCharacter ℂ q,
      DirichletCharacter.IsPrimitive χ → χ ≠ 1 →
      (∀ a : ZMod q, (χ a).im = 0) →
      ∀ β : ℝ, 0 < β → β < 1 → DirichletCharacter.LFunction χ (β : ℂ) = 0 →
        c ≤ (1 - β) * Real.log (q : ℝ)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1/8 <= Re <= 7/8`.  Upper edge: [Z78]
    itself.  Lower edge: the functional equation gives
    `zeta(rho) = [factors] * zeta(1 - rho)` with every
    factor non-zero for a non-real rho (exponential factor
    via `cpow_ne_zero_iff`, Gamma via `Gamma_ne_zero`, cos
    via `cos_eq_zero_iff` plus non-reality of rho), so
    `zeta(rho) = 0` forces `zeta(1 - rho) = 0`, and [Z78]
    applied to `1 - rho` gives the lower edge. -/
theorem zetaZeroStrip (hz78 : externalZeroFree78) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    (1 / 8 : ℝ) ≤ ρ.re ∧ ρ.re ≤ (7 / 8 : ℝ) := by
  have h1neρ : (1 : ℂ) - ρ ≠ 1 := by
    intro h
    have hρ0 : ρ = 0 := by
      have := congr_arg (· + ρ) h
      rw [sub_add_cancel] at this
      have := congr_arg (· - (1 : ℂ)) this
      ring_nf at this
      exact this.symm
    exact hρim (by rw [hρ0]; exact zero_im)
  have hneNm : ∀ n : ℕ, (1 : ℂ) - ρ ≠ -n := by
    intro n hn
    have := congr_arg (· + ρ) hn
    rw [sub_add_cancel] at this
    have h1 : ρ = (1 : ℂ) + (n : ℂ) := by
      have := congr_arg (· + (n : ℂ)) this
      ring_nf at this
      exact this.symm
    have h0 : ρ.im = 0 := by
      rw [h1, add_im, one_im]
      have h2 : ((n : ℕ) : ℂ) = (((n : ℕ) : ℝ) : ℂ) := rfl
      rw [h2, ofReal_im]
      simp
    exact hρim h0
  have hfe : riemannZeta ρ =
      2 * (2 * π) ^ (-(1 - ρ)) * Gamma (1 - ρ) *
      cos ((π : ℂ) * (1 - ρ) / 2) * riemannZeta (1 - ρ) := by
    simpa using riemannZeta_one_sub hneNm h1neρ
  have hc2p : (2 * π : ℂ) ≠ 0 := by
    intro h
    rw [mul_eq_zero] at h
    rcases h with h2 | hπ
    · have h2n : (2 : ℂ) ≠ 0 := by
        intro h2b
        have h2re : (2 : ℂ).re = (2 : ℝ) := by norm_num
        have := congr_arg Complex.re h2b
        rw [h2re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        exact (by norm_num : (2 : ℝ) ≠ 0) this
      exact h2n h2
    · have hπn : (π : ℂ) ≠ 0 := by
        intro hπb
        have := congr_arg Complex.re hπb
        rw [ofReal_re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        nlinarith [Real.pi_pos]
      exact hπn hπ
  have hexp : (2 * π : ℂ) ^ (-(1 - ρ)) ≠ 0 :=
    cpow_ne_zero_iff.mpr (Or.inl hc2p)
  have hgm : Gamma (1 - ρ) ≠ 0 :=
    Gamma_ne_zero hneNm
  have hcos : cos ((π : ℂ) * (1 - ρ) / 2) ≠ 0 := by
    intro h
    obtain ⟨k, hk⟩ := (Complex.cos_eq_zero_iff).1 h
    field_simp [show (π : ℂ) ≠ 0 from by
      intro h; simp only [Complex.ext_iff] at h; exact (Real.pi_pos).ne' h.1] at hk
    have hρ' : ρ = -(2 * ↑k : ℂ) := by
      have := congr_arg (· - (1 : ℂ)) hk
      ring_nf at this
      rw [← neg_inj, neg_neg]
      rw [mul_comm] at this
      exact this
    have h0 : ρ.im = 0 := by
      rw [hρ', neg_im]
      have h1r : ((2 * k : ℤ) : ℝ) = 2 * (k : ℝ) := by norm_num
      have h2 : ((↑(2 * k : ℤ)) : ℂ) = (↑(2 * k : ℝ) : ℂ) := by exact_mod_cast h1r
      simpa [h2] using (ofReal_im (2 * (k : ℝ)))
    exact hρim h0
  have h1rho0 : riemannZeta (1 - ρ) = 0 := by
    by_contra hnz
    have hzρ : riemannZeta ρ ≠ 0 := by
      rw [hfe]
      refine mul_ne_zero ?_ hnz
      refine mul_ne_zero ?_ hcos
      refine mul_ne_zero ?_ hgm
      exact mul_ne_zero (by norm_num : (2 : ℂ) ≠ 0) hexp
    exact hzρ hρ
  have hlo : (1 / 8 : ℝ) ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < (1 / 8 : ℝ) := not_le.mp h
    have hc : (7 / 8 : ℝ) < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz78 (1 - ρ) hc) h1rho0
  have hhi : ρ.re ≤ (7 / 8 : ℝ) := by
    by_contra h
    exact (hz78 ρ (not_le.mp h)) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set: if every element of `q.Z` is an actual zero of
    Mathlib's zeta (the classical instantiation the B-0
    header leaves to citation), then every off-line pair
    (t0, d0) of `q` has off-line distance `d0 <= 3/8`: the
    zero sits in the strip `1/8 <= Re <= 7/8`, at most
    `3/8` off the line. -/
theorem offPairD0le (q : ZeroSet) (hz78 : externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ 3 / 8 := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStrip hz78 ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ 3 / 8 := by
    rw [abs_le]
    constructor
    · nlinarith [hstrip.1]
    · nlinarith [hstrip.2]
  simpa using hle

/- Data gates (Float world; the Real forms carry the
   theorems above). -/
def zeroFreeTheta : Float := 0.875
def stripLo : Float := 0.125
def offPairD0Max : Float := 0.375
#eval zeroFreeTheta
#eval stripLo
#eval offPairD0Max

end Z78
