import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip

open Real Set Complex

/-!
**Z78Liu — [Z78L]: the Liu successor of the 7/8 quasi-RH input,
and its strip corollary.**

PROVENANCE (no recall — every reference resolves):
  Source:  Baiying Liu (Purdue), "Slightly improved zero-free
           half-planes for the quasi-Riemann hypothesis",
           arXiv 2610.12234 (v2, 2026-10-12).
  Repo:    https://github.com/liubaiying101/Improved-zero-free-
           half-planes-for-the-quasi-Riemann-hypothesis
           (Lean; last push 2026-10-12; 9 MB; 10 proof files).
  Math:    varying the parameters of the OpenAI 7/8 argument
           (b, l, kappa) improves the zero-free boundary from
           7/8 = 0.875 to B_inf = 0.874957019420098946...,
           where B_inf = (18*xi+7)/(18*xi+9) and xi is the
           unique root of 1188*x^3 - 2160*x^2 + 171*x + 190
           in (0.38858, 0.38859).  The formalization proves
           `zeta_nonzero (s) (hs : B_inf < s.re) (hpole :
           s ≠ 1) : riemannZeta s ≠ 0` (Mathlib's zeta),
           with the certified decimal bracket
           874957019420098946/10^18 < B_inf <
           874957019420098947/10^18 (its generated signature
           audit, theorem `boundary_bracket`).  B_inf < 7/8,
           so this is a STRICTLY STRONGER zero-free claim
           than [Z78] (it covers the band (B_inf, 7/8]).
  VERIFICATION STATUS (recorded in the repo's README_on_lean.md;
    re-inspected for this module, 2026-10-20):
    * "PASS (11 October 2026, Hong Kong)": all eight merged OAI
      foundation files and both manuscript proof files passed
      fresh strict replay with Lean 4.34.1
      (--trust=0, -DautoImplicit=false, -DwarningAsError=true,
      -DmaxHeartbeats=0); all seven generated final-signature
      checks passed; the 312 audited declarations use only
      `propext`, `Classical.choice`, `Quot.sound`;
    * the proof delta (Parts I-IV, the parameter changes and
      the improved bound) is HUMAN-WRITTEN Lean by the author
      (the OAI foundation files OAI01-OAI08 are the pinned 2,925
      required OAI modules, carried with attribution);
    * recorded caveats (honest scope, kept on record): the
      replay reused pinned external package artifacts (a clean
      network bootstrap of the dependencies was not exercised);
      it "does not claim a second complete invocation of the
      packaged checker"; optimality is for the specified
      comparison system, "not an optimality assertion about all
      possible analytic methods or actual zero distributions";
      it "proves neither the Riemann hypothesis nor
      nonvanishing on the boundary Re(s) = B_inf".
  STATUS IN THIS PROGRAM:  a NAMED EXTERNAL INPUT of the same
  class as [Z78] — a kernel-verified external theorem, entered
  only as a hypothesis.  Because its formalized zeta statement
  uses the certified rational UPPER boundary
  `liuBUpper = 874957019420098947/10^18` in place of the
  algebraic B_inf (zero-free on Re > B_inf implies zero-free on
  Re > liuBUpper, the smaller region), the input below carries
  only exact rationals.  The pole guard `s ≠ 1` is carried from
  her statement; it is inert for this program's purposes on the
  pinned Mathlib, where `riemannZeta 1 = (γ - log(4π))/2 ≠ 0`
  (`riemannZeta_one_ne_zero`).  No RH claim anywhere: this is a
  zero-free half-plane slightly stronger than 7/8, still far
  from 1/2.
-/

namespace Z78Liu

/-- The certified rational upper boundary: the repo's signature
    audit proves `B_inf < liuBUpper` (decimal bracket, see
    header).  Exact: `874957019420098947 / 10^18`. -/
noncomputable def liuBUpper : ℝ := (874957019420098947 : ℝ) / 10 ^ 18

/-- The off-line distance bound it yields: an off-pair zero sits
    in `[1 - liuBUpper, liuBUpper] x C` (functional equation),
    hence `d0 = |Re - 1/2| <= liuBUpper - 1/2`.  Exact value:
    `374957019420098947 / 10^18 < 3/8` (a strict improvement on
    the [Z78] value). -/
noncomputable def liuD0max : ℝ := liuBUpper - 1 / 2

/-- The boundary is strictly below 7/8 (norm_num certificate):
    this is what makes [Z78L] a strict strengthening of [Z78]. -/
theorem liuBUpper_lt_78 : liuBUpper < 7 / 8 := by
  dsimp only [liuBUpper]
  norm_num

/-- The bound is strictly below the [Z78] off-pair bound 3/8
    (norm_num certificate): the open face genuinely shrinks. -/
theorem liuD0max_lt_38 : liuD0max < 3 / 8 := by
  dsimp only [liuD0max, liuBUpper]
  norm_num

/-- The [Z78L] named external input (kernel-verified; see header
    for provenance and status).  The Riemann zeta function
    (Mathlib's `riemannZeta`) is zero-free in the half-plane
    `Re s > liuBUpper`; the principal-pole guard `s ≠ 1` is
    carried verbatim from the formalized statement (inert on the
    pinned Mathlib, where `riemannZeta_one_ne_zero`).  This is
    a WEAKENED form of the formalized statement — which works
    at the algebraic boundary `B_inf < liuBUpper` — hence a
    valid consequence of the verified theorem. -/
def externalZeroFree78Liu : Prop :=
  ∀ (s : ℂ), liuBUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78L] STRICTLY STRENGTHENS [Z78]: zero-free on
    `Re s > liuBUpper` (with `liuBUpper < 7/8`) implies zero-free
    on `Re s > 7/8`.  At the one point the guard could bite
    (`s = 1`), the pinned Mathlib assigns
    `riemannZeta 1 = (γ - log(4π))/2 ≠ 0`. -/
theorem extLiu_implies_ext78 (hzL : externalZeroFree78Liu) :
    Z78.externalZeroFree78 := by
  intro s hs
  intro hz
  have hs1 : s ≠ 1 := by
    intro heq
    rw [heq] at hz
    exact riemannZeta_one_ne_zero hz
  exact (hzL s (lt_trans liuBUpper_lt_78 hs) hs1) hz

/-- (PROVEN)  Every non-real zero of the zeta function lies in
    the strip `1 - liuBUpper <= Re <= liuBUpper` under [Z78L].
    Identical argument to `Z78.zetaZeroStrip` with the sharper
    boundary: upper edge = [Z78L] itself; lower edge = the
    functional equation (all factors non-zero for a non-real
    point) pushes `zeta(1 - rho) = 0`, and [Z78L] applied to
    `1 - rho` gives the lower edge.  The pole guard is
    discharged by non-reality (upper edge) and `1 - rho ≠ 1`
    (lower edge). -/
theorem zetaZeroStripLiu (hzL : externalZeroFree78Liu) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - liuBUpper ≤ ρ.re ∧ ρ.re ≤ liuBUpper := by
  have h1neρ : (1 : ℂ) - ρ ≠ 1 := by
    intro h
    have hρ0 : ρ = 0 := by
      have := congr_arg (· + ρ) h
      rw [sub_add_cancel] at this
      have := congr_arg (· - (1 : ℂ)) this
      ring_nf at this
      exact this.symm
    exact hρim (by rw [hρ0]; exact zero_im)
  have hρne1 : ρ ≠ 1 := by
    intro heq
    exact hρim (by rw [heq]; norm_num)
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
  have hlo : 1 - liuBUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - liuBUpper := not_le.mp h
    have hc : liuBUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hzL (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ liuBUpper := by
    by_contra h
    exact (hzL ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract zero
    set, under [Z78L]: if every element of `q.Z` is an actual
    zero of Mathlib's zeta (the classical instantiation the B-0
    header leaves to citation), then every off-line pair (t0,
    d0) of `q` has off-line distance `d0 <= liuD0max` — the
    sharp Liu value (zeros sit in `[1 - liuBUpper, liuBUpper]`,
    so `|Re - 1/2| <= liuBUpper - 1/2`, both edges the same
    distance `liuD0max` from the line).  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays empty
    for any actual-set zero set under [Z78L]. -/
theorem offPairD0leLiu (q : ZeroSet) (hzL : externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ liuD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripLiu hzL ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ liuD0max := by
    rw [abs_le]
    constructor
    · dsimp only [liuD0max]
      nlinarith [hstrip.2]
    · dsimp only [liuD0max]
      nlinarith [hstrip.1]
  simpa using hle

/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - liuBUpper = 125042980579901053/10^18`,
    `liuD0max = 374957019420098947/10^18`. -/
def zeroFreeThetaLiu : Float := 0.874957019420098947
def stripLoLiu : Float := 0.125042980579901053
def offPairD0MaxLiu : Float := 0.374957019420098947
#eval zeroFreeThetaLiu
#eval stripLoLiu
#eval offPairD0MaxLiu

end Z78Liu
