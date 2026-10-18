/-
# (WinCount) the hWin face:  the record shadow at 3e9  +  the
classical-frontier shrink.

Two independent inputs shrink the OPEN CONTENT of the hWin face
(S4WC.hWinFace;  the face identity of S4WinCap,  discovery 0105, is
the equivalence of that face to zero-exclusion on [1000, inf) x
(0, 1/200)):

  (A)  [Z-PT],  THE CLASSICAL FRONTIER SHRNK.  The rigorous zero-
       isolation record (Platt,  "Isolating some non-trivial zeros
       of Zeta":  interval-arithmetic isolation of every non-trivial
       zero with 0 < Im <= tPT := 30,610,046,000  to +- 2^-102,  an
       independent verification of the line to that height;  the
       public LMFDB zeta-zero stream —  the source of the project's
       own 24b series  —  ends at exactly this height) pins a height
       below which no off-line zero exists.  Stated over the
       ABSTRACT ZeroSet as a CITED input  (the Z78-strip pattern of
       Z78Strip / Z78P12):
           allOnLineUpTo q tPT.
       Consequences (LEAN-PROVEN,  cite nothing beyond [Z-PT]):
           noOffPairBelowPT:  no off-pairs at all in [1000, tPT] x
              (0, 1/200);
           faceSplit:  S4WC.hWinFace q  <->  hWinFaceResidual q —
              under [Z-PT] the face is exactly zero-exclusion on
              (tPT, inf) x (0, 1/200):  the open face of the
              endpoint's hWin residual shrinks by a height factor of
              about 3e7 (from 1000 to 3.06e10).  The higher
              literature frontier (RH verified up to 3 x 10^12,
              Platt-Trudgian,  arXiv:2004.09765) would shrink it
              further and is named as an optional add-on input;  the
              tree pins the RECORD'S OWN frontier.
       [Z-PT] is a cited fact about the ACTUAL zero set;  the theorems
       are conditional on it as a named hypothesis.  No RH claim.

  (B)  THE 3e9 RECORD SHADOW  (a measured constraint,  the MFar /
       B7Far pattern):  the H1 3e9 stream record (day035 ceiling
       report;  the finish gate of day035_3e9_stream.sh) is pinned
       and re-gated in Lean:
           Nline  = 9064192826   (the exact on-line stream count
                                    up to t = 3e9),
           rvm3e9 = 9064192825.58 (the recorded RVM value at 3e9),
           PIN:  |Nline - rvm3e9| = 0.42 <= 3  (the fleet's own
              +-3 RVM finish gate,  machine-checked here).
       Plus two structural/constraint theorems over ANY ZeroSet:
           D_even:  Even (B0.D q t) —  the off-line excess of (0, t]
              is even (the whole-slice twin of B0.offSliceEven;  the
              fixed-point-free involution 1 - rho-bar tiles the
              off-line slice in 2-cycles).
           offExcessBound:  if q's on-line count at 3e9 equals the
              pinned Nline and its STRIP count passes the record's
              +-3 gate  (|Ntot - rvm3e9| <= 3 —  the same gate the
              fleet ran,  stated for the strip count,  which is what
              RVM counts),  then B0.D q (3e9) <= 2 —  AT MOST ONE
              OFF-LINE ORBIT below 3e9.  Record-derived:  it spends
              only B0's structural axioms + the two record pins +
              the gate.  Together with D_even the excess is 0 or 2.
       This is a measured constraint any candidate zero set
       consistent with the record must satisfy —  an independent
       shadow of the shrink (A).  No RH claim.

HONESTY SPLIT:  CITED [Z-PT] (classical,  named);  PINNED the record
pins (norm_num);  LEAN-PROVEN the vacuity,  the face split,  D_even,
the bound.  The endpoint (RHEnd.rh_program78) and its four named
residuals are UNTOUCHED — this module characterizes how small the
hWin residual's open content is,  it does not close it.

Lean 4.33.1 + mathlib v4.33.1.  DOC-FIRST:  every name used below
was verified against the pinned local mathlib / the local tree
(B0:  Ntot / Non / D / sliceFin / offSliceEven / eqNtotMinusNon /
conj / fe / nonReal;  P12.offPair;  S4WC:  hWinFace /
hwinFaceImpliesZeroExclusion;  Real.abs_of_nonneg / abs_of_nonpos;
Complex.star_re / star_im;  Finset.card_biUnion / mem_image /
filter_subset).
-/
import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.S4WinCap

namespace WinC

open B0
open Real Set Complex

/- — (A)  the classical frontier shrink — -/

/-- The rigorous zero-isolation height pinning the record's own zero-
    stream frontier (Platt's isolation;  the public stream ends here):
    30,610,046,000.  [Z-PT's height] -/
noncomputable def tPT : ℝ := 30610046000

/-- [Z-PT]  CITED classical input (Platt,  "Isolating some
    non-trivial zeros of Zeta":  rigorous interval-arithmetic
    isolation of every non-trivial zero with 0 < Im <= tPT to
    +- 2^-102;  an independent verification that the line carries
    them all to that height;  the public zero stream ends there):
    every zero of the set up to height H sits on the critical line.
    The higher literature frontier (RH verified up to 3 x 10^12,
    Platt-Trudgian,  arXiv:2004.09765) is a stronger add-on input;
    the tree pins the record's own frontier.  This is a fact about
    the ACTUAL zero set,  carried as a named hypothesis by design
    (the Z78 pattern). -/
def allOnLineUpTo (q : ZeroSet) (H : ℝ) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → 0 < ρ.im → ρ.im ≤ H → ρ.re = 1 / 2

/-- NO OFF-PAIR BELOW THE FRONTIER:  under [Z-PT] there is no
    off-line zero at (t0, d0) with 1000 <= t0 <= H,  0 < d0 < 1/200.
    An off-line zero at the negative height is sent by conjugation
    (HFE after HCJ) to a positive-height off-line twin. -/
theorem noOffPairBelowPT (q : ZeroSet) (H : ℝ)
    (hPT : allOnLineUpTo q H)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd0 : 0 < d0) (hdw : d0 < (1 / 200 : ℝ))
    (htH : t0 ≤ H) :
    ¬ P12.offPair q t0 d0 := by
  rintro ⟨ρ, hρ, hre, him, hdd⟩
  by_cases hpos : 0 < ρ.im
  · have habs : ρ.im = t0 := by
      rw [abs_of_nonneg (le_of_lt hpos)] at him
      exact him
    have hin : ρ.im ≤ H := by simpa [habs] using htH
    have hre' := hPT ρ hρ (by simpa [habs] using (by linarith [ht0])) hin
    exact hre hre'
  · have hneg : ρ.im < 0 := by
      have hle : ρ.im ≤ 0 := not_lt.mp hpos
      have hne : ρ.im ≠ 0 := q.nonReal ρ hρ
      exact lt_of_le_of_ne hle hne
    have habs : -ρ.im = t0 := by
      rw [abs_of_nonpos (le_of_lt hneg)] at him
      exact him
    have hst : star ρ ∈ q.Z := q.conj ρ hρ
    have himst : 0 < (star ρ).im := by
      simp only [star]
      linarith [habs, ht0]
    have himst2 : (star ρ).im = t0 := by
      simp only [star] at ⊢
      exact habs
    have hin2 : (star ρ).im ≤ H := by
      rw [himst2]
      exact htH
    have hre' : (star ρ).re = 1 / 2 := hPT _ hst himst hin2
    rw [show (star ρ).re = ρ.re by simp [star]] at hre'
    exact hre hre'

/-- THE RESIDUAL FACE (named):  zero-exclusion of off-line zeros
    strictly ABOVE the record's frontier,  on the window band.  Under
    [Z-PT] this is exactly the hWin face (faceSplit).  The residual
    IS OPEN:  no instrument in the tree reaches (tPT, inf) x
    (0, 1/200)  —  the classical zero-free regions stop at
    Re > 1 - c/ln t,  nowhere near Re = 1/2 +- 1/200,  and the
    measured zero walk ends at the frontier. -/
def hWinFaceResidual (q : ZeroSet) : Prop :=
    ∀ (t0 d0 : ℝ), 1000 ≤ t0 → t0 > tPT → 0 < d0 → d0 < (1 / 200 : ℝ) →
      ¬ P12.offPair q t0 d0

/-- THE FACE SPLIT:  under [Z-PT] at the record's frontier,  the
    hWin face of S4WinCap is equivalent to the residual (zero-
    exclusion above the frontier). -/
theorem faceSplit (q : ZeroSet)
    (hPT : allOnLineUpTo q tPT) :
    S4WC.hWinFace q ↔ hWinFaceResidual q := by
  constructor
  · intro hf t0 d0 ht0 htpt hd0 hdw
    exact (S4WC.hwinFaceImpliesZeroExclusion q hf) t0 d0 ht0 hd0 hdw
  · intro hr t0 d0 ht0 hd0 hdw hz
    by_cases hle : t0 ≤ tPT
    · exact False.elim ((noOffPairBelowPT q tPT hPT t0 d0 ht0 hd0 hdw hle) hz)
    · exact False.elim ((hr t0 d0 ht0 (not_le.mp hle) hd0 hdw) hz)

/- — (B)  the 3e9 record shadow — -/

/-- The record height (H1 3e9 stream,  day035). -/
noncomputable def tdata : ℝ := 3000000000

/-- The EXACT on-line zero count up to t = 3e9 in the H1 verified
    stream (day035 ceiling report:  "N(3e9) = 9,064,192,826 EXACT"). -/
def Nline : ℕ := 9064192826

/-- The recorded RVM value at t = 3e9 (day035 ceiling report:
    "RVM(3e9) = 9,064,192,825.58").  RVM counts the STRIP zeros
    (critical strip,  0 < Im <= t,  distinct). -/
def rvm3e9 : ℚ := 906419282558 / 100

/-- The record pins,  re-gated in Lean:  the on-line count is 21/50
    above the recorded RVM value,  and the difference is inside the
    fleet's own +-3 finish gate. -/
theorem pinGates :
    (Nline : ℚ) - rvm3e9 = 21 / 50 ∧ abs ((Nline : ℝ) - (rvm3e9 : ℝ)) ≤ 3 := by
  constructor <;> norm_num [Nline, rvm3e9]

/-- D_EVEN:  for ANY ZeroSet,  the off-line excess of (0, t] is even.
    The whole-slice twin of B0.offSliceEven:  the map
    ι(ρ) = 1 - rho-bar is a fixed-point-free involution of the
    off-line slice (HFE after HCJ;  the height is EXACTLY preserved
    —  im(ιρ) = im(ρ) —  so 0 < im <= t survives;  a fixed point
    would have Re = 1/2 and so would not be off-line).  The
    2-cycle blocks tile the slice,  so its cardinality is even:
    D = B0.D q t is 2 x (number of off-line orbit pairs). -/
theorem D_even (q : ZeroSet) (t : ℝ) (ht : 0 < t) : Even (D q t ht) := by
  let S : Finset ℂ := (sliceFin q t ht).filter (fun ρ => ρ.re ≠ 1 / 2)
  have hS : D q t ht = S.card := by
    dsimp only [S, D, sliceFin]
  rw [hS]
  let ι (ρ : ℂ) : ℂ := (1 : ℂ) - star ρ
  -- (a) ι maps S into S
  have hiS : ∀ ρ ∈ S, ι ρ ∈ S := by
    intro ρ hρ
    simp only [S, Finset.mem_filter] at hρ ⊢
    have hZT : ρ ∈ q.Z ∧ 0 < ρ.im ∧ ρ.im ≤ t := by
      simpa [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff] using hρ.1
    have hZstar : star ρ ∈ q.Z := q.conj ρ hZT.1
    have him : (ι ρ).im = ρ.im := by
      simp only [star, ι, sub_im, Complex.one_im]
      ring
    constructor
    · set_option linter.unnecessarySimpa false in
      rw [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff]
      exact ⟨q.fe (star ρ) hZstar, by simpa [him] using hZT.2.1,
        by simpa [him] using hZT.2.2⟩
    · by_contra h
      simp only [star, ι, sub_re, Complex.one_re] at h
      exact hρ.2 (by nlinarith)
  -- (b) ι is an involution
  have hinvol : ∀ ρ, ι (ι ρ) = ρ := by
    intro ρ
    have : star ((1 : ℂ) - star ρ) = star (1 : ℂ) - star (star ρ) := by
      rw [sub_eq_add_neg, star_add, star_neg, ← sub_eq_add_neg]
    rw [show ι (ι ρ) = (1 : ℂ) - star ((1 : ℂ) - star ρ) from rfl, this,
      star_involutive, star_one]
    ring
  -- (c) ι has no fixed point on S (a fixed point would have Re = 1/2)
  have hfp : ∀ ρ ∈ S, ι ρ ≠ ρ := by
    intro ρ hρ
    simp only [S, Finset.mem_filter] at hρ
    by_contra h
    have hre : ρ.re = 1 / 2 := by
      have := congr_arg Complex.re h
      simp only [star, ι, sub_re, Complex.one_re] at this
      nlinarith
    exact hρ.2 hre
  -- (d) the 2-cycle blocks {ρ, ιρ} tile S,  2 members each
  let orb (ρ : ℂ) : Finset ℂ := S.filter (fun x => x = ρ ∨ x = ι ρ)
  have hcard2 : ∀ ρ ∈ S, (orb ρ).card = 2 := by
    intro ρ hρ
    have hmem : ι ρ ∈ S := hiS ρ hρ
    have heq : (orb ρ : Finset ℂ) = {ρ, ι ρ} := by
      ext x
      simp only [orb, Finset.mem_filter, Finset.mem_insert, Finset.mem_singleton]
      constructor
      · rintro ⟨hxs, hx⟩
        exact hx
      · rintro (h | h)
        · rw [h]
          exact ⟨hρ, Or.inl rfl⟩
        · rw [h]
          exact ⟨hmem, Or.inr rfl⟩
    rw [heq, Finset.card_pair_eq_two_iff]
    exact (hfp ρ hρ).symm
  let B : Finset (Finset ℂ) := S.image orb
  have hBcard2 : ∀ b ∈ B, (b : Finset ℂ).card = 2 := by
    rintro b hb
    obtain ⟨ρ, hρ, hbe⟩ := Finset.mem_image.mp hb
    rw [hbe.symm]
    exact hcard2 ρ hρ
  -- (e) distinct orbit blocks are disjoint
  have hdisjB : ((↑B : Set (Finset ℂ))).PairwiseDisjoint id := by
    intro b hb b' hb' hne
    obtain ⟨ρ, hρ, hbe⟩ := Finset.mem_image.mp hb
    obtain ⟨ρ', hρ', hbe'⟩ := Finset.mem_image.mp hb'
    have h0 : (b : Finset ℂ) ∩ b' = ∅ := by
      ext x
      rw [← hbe, ← hbe', Finset.mem_inter]
      dsimp only [orb]
      simp only [Finset.mem_filter]
      constructor
      · rintro ⟨⟨_, hd⟩, ⟨_, hd2⟩⟩
        rcases hd with h | h
        · rcases hd2 with h2 | h2
          · have hρ' : ρ = ρ' := h.symm.trans h2
            exact (hne (by rw [← hbe, ← hbe', hρ'])).elim
          · have hrho : ρ = ι ρ' := h.symm.trans h2
            have hinv : ι (ι ρ') = ρ' := hinvol ρ'
            exact (hne (by
              rw [← hbe, ← hbe', hrho]
              ext y
              dsimp only [orb]
              simp only [Finset.mem_filter]
              simp [hinv]
              tauto)).elim
        · rcases hd2 with h2 | h2
          · have hiota : ι ρ = ρ' := h.symm.trans h2
            have hrho : ρ = ι ρ' := (hinvol ρ).symm.trans (congr_arg ι hiota)
            have hinv : ι (ι ρ') = ρ' :=
                (hiota.symm.trans (congr_arg ι hrho)).symm
            exact (hne (by
              rw [← hbe, ← hbe', hrho]
              ext y
              dsimp only [orb]
              simp only [Finset.mem_filter]
              simp [hinv]
              tauto)).elim
          · have hi2 : ι ρ = ι ρ' := h.symm.trans h2
            have hrho : ρ = ρ' :=
                (hinvol ρ).symm.trans ((congr_arg ι hi2).trans (hinvol ρ'))
            exact (hne (by rw [← hbe, ← hbe', hrho])).elim
      · intro hx
        simp at hx
    simpa [Finset.disjoint_iff_inter_eq_empty] using h0
  have hunion : B.biUnion id = S := by
    ext x
    constructor
    · intro hmem
      dsimp only [B] at hmem
      rw [Finset.mem_biUnion] at hmem
      obtain ⟨b, hb, hx⟩ := hmem
      obtain ⟨ρ, hρ, hbe⟩ := Finset.mem_image.mp hb
      rw [hbe.symm] at hx
      have horb : x ∈ S := by
        dsimp only [S, orb, id] at hx
        rw [Finset.mem_filter] at hx
        exact hx.1
      exact horb
    · intro hx
      dsimp only [B]
      rw [Finset.mem_biUnion]
      refine ⟨orb x, ?hborb, ?hmem⟩
      · rw [Finset.mem_image]
        exact ⟨x, hx, rfl⟩
      · dsimp only [S] at hx
        dsimp only [S, orb, id] at ⊢
        apply Finset.mem_filter.mpr
        constructor
        · exact hx
        · exact Or.inl rfl
  -- (f) |block union| = 2 * |blocks|
  have hsum1 : B.sum (fun b => (b : Finset ℂ).card) = B.sum (fun _ => 2) := by
    apply Finset.sum_congr rfl
    rintro b hb
    exact hBcard2 b hb
  have hsum2 : B.sum (fun _ => 2) = 2 * B.card := by
    rw [Finset.sum_const 2, nsmul_eq_mul, Nat.cast_id, Nat.mul_comm]
  have hmain : (B.biUnion id : Finset ℂ).card = 2 * B.card := by
    calc
      (B.biUnion id : Finset ℂ).card = B.sum (fun b => (b : Finset ℂ).card) :=
          Finset.card_biUnion hdisjB
      _ = B.sum (fun _ => 2) := hsum1
      _ = 2 * B.card := hsum2
  have hS2 : (S : Finset ℂ).card = (B.biUnion id : Finset ℂ).card := by
    rw [hunion.symm]
  rw [hS2, hmain]
  exact even_two_mul B.card

/-- THE 3e9 OFF-LINE EXCESS BOUND (record shadow).  For ANY ZeroSet
    q:  if q's on-line count at tdata matches the pinned stream count
    (the record data fact about the actual set) and q's strip count
    passes the record's +-3 RVM finish gate  (stated for the strip
    count,  which is what RVM counts),  then the off-line excess of
    (0, tdata] is at most n - 1.  The gate gives  D + 21/50 <= n
    (the strip count is Nline + D,  and the RVM pin sits 21/50 below
    Nline);  since D is a natural number,  D <= n - 1. -/
theorem offExcessBound (q : ZeroSet) (n : ℕ) (hn : 1 ≤ n)
    (ht0 : 0 < tdata)
    (hline : Non q tdata ht0 = Nline)
    (hrvm : abs ((Ntot q tdata ht0 : ℝ) - (rvm3e9 : ℝ)) ≤ (n : ℝ)) :
    D q tdata ht0 ≤ n - 1 := by
  have ht : (0 : ℝ) < tdata := ht0
  have hD : D q tdata ht = Ntot q tdata ht - Non q tdata ht :=
    eqNtotMinusNon q tdata ht
  have hnonle : Non q tdata ht ≤ Ntot q tdata ht := by
    dsimp only [Non, Ntot, sliceFin]
    exact Finset.card_mono (Finset.filter_subset _ _)
  have hNtotNnonD : Ntot q tdata ht = Non q tdata ht + D q tdata ht := by
    rw [hD]
    exact (Nat.add_sub_cancel' hnonle).symm
  have hreal : (Ntot q tdata ht : ℝ) = ((Nline : ℝ)) + (D q tdata ht : ℝ) := by
    rw [hNtotNnonD, hline]
    push_cast
    ring
  have hdiff : (D q tdata ht : ℝ) + 21 / 50 =
      (Ntot q tdata ht : ℝ) - (rvm3e9 : ℝ) := by
    rw [hreal]
    have hd : (Nline : ℝ) - (rvm3e9 : ℝ) = 21 / 50 := by norm_num [Nline, rvm3e9]
    rw [show (Nline : ℝ) + (D q tdata ht : ℝ) - (rvm3e9 : ℝ) =
        (D q tdata ht : ℝ) + ((Nline : ℝ) - (rvm3e9 : ℝ)) by ring]
    rw [hd]
  have hDlt : (D q tdata ht : ℝ) + 21 / 50 ≤ (n : ℝ) := by
    have habs : abs ((D q tdata ht : ℝ) + 21 / 50) ≤ (n : ℝ) := by
      simpa [hdiff] using hrvm
    exact (abs_le.mp habs).2
  have hlt : D q tdata ht < n := by
    have h3 : (D q tdata ht : ℝ) < (D q tdata ht : ℝ) + 21 / 50 :=
      lt_add_of_pos_right _ (by norm_num)
    exact_mod_cast (lt_of_lt_of_le h3 hDlt)
  have hsub : D q tdata ht ≤ n - 1 := by
    have hn' : (n - 1) + 1 = n := Nat.sub_add_cancel hn
    rw [← hn'] at hlt
    exact (Nat.lt_succ_iff).mp hlt
  by_contra hc
  exact hc hsub

end WinC
