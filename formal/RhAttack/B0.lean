/-
Copyright (c) 2026 kainos-logos rh-attack (owner-directed research;
AI co-developed instrument).
-/

/-
  **PIECE P1 — the counting lemma (RH ⇔ D ≡ 0).**  The counting
  reformulation of the Riemann Hypothesis over an *abstract* zero set —
  no ζ anywhere. Defines N_total / N_on / D on the zero set, proves D
  is a non-decreasing even-valued step, and proves
  RH(q) ↔ (∀ t > 0, D q t = 0).

  OUTLINE : docs/RH-PROOF-OUTLINE.md §2 (the counting language) and §9
             row P1.
  ROLE    : reframes RH as the counting statement D ≡ 0 that the
             detector acts on; the `zeroD_of_RH` / `RH_of_zeroD` halves
             are exactly what the certified 10⁷ record consumes
             (2K even ⇒ no off-line zero pair below 10⁷).
  APPROACH: the F2 four-tuple symmetry (each off-line zero carries its
             mirror 1 − ρ at the same height) + finiteness of the slice
             Finset. No analysis.
  STATUS  : GREEN on stable Lean 4.33.1 + mathlib (exit 0, re-verified
             2026-09-11).
  THEOREMS: `eqNtotMinusNon` (i) · `nondec` (ii) · `offSliceEven` (iii)
             · `zeroD_of_RH` + `RH_of_zeroD` ⇒ `RH_iff_Dzero` (iv).
             A Bool-level mirror (hyps / RHm / offSlice) sits at the
             bottom of the file for the data layer.
-/


import Mathlib

-- linter.style.header (new in 4.34-rc2) wants the module doc-string as
-- the FIRST command after the imports, but the rc2 parser rejects a
-- doc-string immediately followed by `open` (probed: "unexpected token
-- 'open'"). The parseable layout is open → doc-string → first decl,
-- with the doc-string attached to `structure ZeroSet` below; the
-- position linter is therefore disabled file-wide here.
set_option linter.style.header false

open Set Finset Complex

/-- **B-0** — the counting equivalence RH ⇔ D ≡ 0, for an abstract zero set.
    The structure below is the structural input of this file (see header).

    PROVENANCE (no recall — every reference resolves):
      Statement: plan/40-prize-islands/rh-attack/RH-PROOF-OUTLINE.md v0.6,
        [B-0]: "Counting equivalence: D(t) := N_total(t) − N_on(t) is
        even-valued, step, RH ⇔ D(t) ≡ 0. D jumps by 2 at each off-line
        pair height (F-0.3: a 4-tuple contributes two zeros at the same
        positive height). Statement is a 2-line counting argument from
        F-0.1–F-0.5."
      The F-0.1–F-0.5 block of the same file is the classical input.
        THIS formalization spends exactly four of those facts — the fields
        of the ZeroSet structure below — and no other part of the F-0 block.
    HONESTY LABELS (claim policy: certified artifact, no RH claim).
    - The theorems are about an ABSTRACT ZeroSet: a set Z : Set ℂ carrying
      the four structural properties the classical facts give the actual
      non-trivial zeros of ζ:
          (HNR, F-0.1+F-0.2)  non-real
          (HCJ, F-0.3)        closed under ρ ↦ ρ̄          (conjugation)
          (HFE, F-0.3)        closed under ρ ↦ 1−ρ        (functional equation)
          (HFIN, F-0.4/RVM)   finitely many up to each height t > 0
        Instantiating them for the actual zero set is the classical step
        the outline leaves to citation (ζ>0 on (0,1), the functional
        equation, RVM — not in Mathlib; F-0.1 citation pending). Nothing
        in this file is a statement about ζ.
    - Counting convention: DISTINCT zeros (the project's N counts flips
      of Z(t), i.e. distinct heights — day-3/4/9 census convention). A
      multiplicity-valued version is a refinement (the same pairing
      applies to multiplicities via the 4-tuple symmetry).
    - No analysis anywhere: pure Set/Finset cardinal arithmetic over ℂ.
    - Hypothesis usage is exact: the even-jump theorem spends HCJ + HFE +
      HFIN (HNR does not enter); RH ⇒ D≡0 spends HFIN only;
      D≡0 ⇒ RH spends HNR + HCJ (the off-line zero of negative height is
      sent to positive height by conjugation, Re-part unchanged, before
      it can be counted) + HFIN.
    - Style note (Lean 4.34.0-rc2 ground rules, READ-THE-DOCS verdict —
      verbatim quotes from the reference manual):
      (a) "Namespaces and Sections": "When the name of a section variable
          is encountered in a non-theorem declaration, it is added as a
          parameter … All section variables are added in the order in
          which they are declared, before all other parameters." — and
          `variable (…)` declares an EXPLICIT section variable; braces
          make it implicit. The original blocker of this file (error
          "expected Set ℂ" at `sliceFin t ht`) is exactly this rule:
          `def sliceFin (t : ℝ) (ht : 0 < t)` written inside a section
          with explicit `(Z : Set ℂ)` `(hFIN : …)` silently becomes
          `sliceFin (Z : Set ℂ) (hFIN : …) (t : ℝ) (ht : 0 < t)` (verified
          by `#check`), so `sliceFin t ht` unified my `t : ℝ` with the
          expected FIRST argument `Z : Set ℂ`.
      (b) "Terms, Implicit Parameters": ordinary implicits are values
          "that Lean should determine via unification. In other words, each
          call site should have exactly one potential argument value that
          would cause the function call as a whole to be well-typed." —
          implicits are NOT filled by scanning the local context for a
          constant of the right type; the manual's own error example is
          exactly my probe's shape. No feature was removed in
          4.33→4.34 (the release notes contain no such entry): the
          "disabled synthesis" hypothesis in an earlier draft of this
          header was a misreading, corrected 2026-09-10 after reading the
          manual.
      (c) Consequence (design): the state travels as the single zeroSet
          argument (explicit) of every def/theorem — the same idiom as
          B4/E7a. No section `variable`s are relied on for state.
      (d) Documented lemma-discovery tools (used in place of name-guessing
          or source-grepping; all present in 4.34.0-rc2): `#search "query
          string ending in . or ?"` (semantic, via leansearch.net),
          `#find <type pattern>` (shape search over open imports),
          `apply?` / `exact?` / `simp?` (goal-state suggestions), Loogle
          (type-pattern search service).
    - The theorem layer is classical over Set ℂ (noncomputable). The
      exact computable cross-check is the B0Model namespace below: the
      same counting code re-implemented over finite (ℚ × ℚ) zero lists,
      #eval-able, three synthetic models covering both directions and the
      even-jump structure.
-/
structure ZeroSet where
  /-- the zero set (distinct zeros, day-3/4/9 census convention) -/
  Z : Set ℂ
  /-- (HNR, F-0.1+F-0.2): non-trivial zeros are non-real -/
  nonReal : ∀ ρ ∈ Z, ρ.im ≠ 0
  /-- (HCJ, F-0.3): closed under complex conjugation -/
  conj : ∀ ρ ∈ Z, star ρ ∈ Z
  /-- (HFE, F-0.3): closed under the functional equation ρ ↦ 1 − ρ -/
  fe : ∀ ρ ∈ Z, (1 : ℂ) - ρ ∈ Z
  /-- (HFIN, F-0.4/RVM): finitely many zeros up to each height t > 0 -/
  finite : (t : ℝ) → 0 < t → (Z ∩ {ρ | 0 < ρ.im ∧ ρ.im ≤ t}).Finite

namespace B0

open Classical

/-- The finitely many zeros in (0, t], as a Finset. -/
noncomputable def sliceFin (q : ZeroSet) (t : ℝ) (ht : 0 < t) : Finset ℂ :=
  (q.finite t ht).toFinset

/-- N_total(t): zeros of positive height ≤ t (F-0.4 convention). -/
noncomputable def Ntot (q : ZeroSet) (t : ℝ) (ht : 0 < t) : ℕ :=
  (sliceFin q t ht).card

/-- N_on(t): those with Re = ½. -/
noncomputable def Non (q : ZeroSet) (t : ℝ) (ht : 0 < t) : ℕ :=
  ((sliceFin q t ht).filter (fun ρ => ρ.re = 1 / 2)).card

/-- **B-0's D(t)** = N_total(t) − N_on(t): the number of OFF-LINE zeros
    with 0 < Im ρ ≤ t. -/
noncomputable def D (q : ZeroSet) (t : ℝ) (ht : 0 < t) : ℕ :=
  ((sliceFin q t ht).filter (fun ρ => ρ.re ≠ 1 / 2)).card

/-- The counting form of RH for an abstract zero set: every zero on-line. -/
def RH (q : ZeroSet) : Prop := ∀ ρ ∈ q.Z, ρ.re = 1 / 2

-- ---------------- the counting core ----------------

/-- **B-0 (i).** D(t) = N_total(t) − N_on(t), literally: the off-line
    slice is the complement of the on-line slice inside the finite
    slice. (So D is ℕ-valued, and its values are countings of the
    finite slices — the "even-valued, step" part is (ii)+(iii).) -/
theorem eqNtotMinusNon (q : ZeroSet) (t : ℝ) (ht : 0 < t) :
    D q t ht = Ntot q t ht - Non q t ht := by
  let fs := sliceFin q t ht
  let fe := fs.filter (fun ρ => ρ.re = 1 / 2)
  let fn := fs.filter (fun ρ => ρ.re ≠ 1 / 2)
  rw [show D q t ht = fn.card from rfl, show Ntot q t ht = fs.card from rfl,
    show Non q t ht = fe.card from rfl]
  have hint : (fe : Finset ℂ) ∩ fn = ∅ := by
    ext x
    dsimp only [fe, fn] at ⊢
    rw [Finset.mem_inter, Finset.mem_filter, Finset.mem_filter]
    simp
    tauto
  have hadd : fs = (fe : Finset ℂ) ∪ fn := by
    ext x
    dsimp only [fe, fn] at ⊢
    simp only [Finset.mem_filter, Finset.mem_union]
    tauto
  have hcard : Finset.card fs = Finset.card fe + Finset.card fn := by
    calc
      Finset.card fs = Finset.card ((fe : Finset ℂ) ∪ fn) := by rw [hadd]
      _ = Finset.card fe + Finset.card fn - Finset.card (fe ∩ fn) :=
          Finset.card_union fe fn
      _ = Finset.card fe + Finset.card fn := by
          rw [hint, Finset.card_empty, Nat.sub_zero]
  omega

/-- **B-0 (ii).** D is a non-decreasing step function of t. -/
theorem nondec (q : ZeroSet) (t u : ℝ) (ht : 0 < t) (hu : 0 < u) (hle : t ≤ u) :
    D q t ht ≤ D q u hu := by
  let ft := (sliceFin q t ht : Finset ℂ).filter (fun ρ => ρ.re ≠ 1 / 2)
  let fu := (sliceFin q u hu : Finset ℂ).filter (fun ρ => ρ.re ≠ 1 / 2)
  have hsub : ft ≤ fu := by
    intro x hx
    dsimp only [ft, fu] at hx ⊢
    simp only [Finset.mem_filter] at hx ⊢
    have hZT : x ∈ q.Z ∧ 0 < x.im ∧ x.im ≤ t := by
      simpa [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff] using hx.1
    have hfu : x ∈ sliceFin q u hu := by
      rw [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff]
      exact ⟨hZT.1, hZT.2.1, le_trans hZT.2.2 hle⟩
    exact ⟨hfu, hx.2⟩
  exact Finset.card_mono hsub

-- ---------------- the even jump (the heart of B-0) ----------------

/-- **B-0 (iii).** The off-line zeros at one positive height t₀ come in
    2-cycles: the map ι(ρ) = 1 − ρ̄ is a fixed-point-free involution of the
    slice (HFE after HCJ; height and off-lineness are preserved; a fixed
    point would have Re = ½ and so be off the slice). A finite set with a
    fixed-point-free involution has even cardinality, so the number of
    off-line zeros at any single height is even: D jumps by multiples of
    2, and a height carries off-line zeros iff it carries the whole pair
    {β + it₀, (1−β) + it₀}. -/
theorem offSliceEven (q : ZeroSet) (t₀ : ℝ) (ht₀ : 0 < t₀) :
    Even (Finset.card ((sliceFin q t₀ ht₀ : Finset ℂ).filter
      (fun ρ => ρ.im = t₀ ∧ ρ.re ≠ 1 / 2))) := by
  let f (ρ : ℂ) : Prop := ρ.im = t₀ ∧ ρ.re ≠ 1 / 2
  let S : Finset ℂ := (sliceFin q t₀ ht₀).filter f
  let ι (ρ : ℂ) : ℂ := (1 : ℂ) - star ρ
  show Even (Finset.card S)
  -- (a) ι maps S into S
  have hiS : ∀ ρ ∈ S, ι ρ ∈ S := by
    intro ρ hρ
    simp only [S, f, Finset.mem_filter] at hρ ⊢
    have hZT : ρ ∈ q.Z ∧ 0 < ρ.im ∧ ρ.im ≤ t₀ := by
      simpa [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff] using hρ.1
    have hZstar : star ρ ∈ q.Z := q.conj ρ hZT.1
    have him : (ι ρ).im = t₀ := by
      simp only [star, ι, sub_im, Complex.one_im]
      linarith [hρ.2.1]
    constructor
    · set_option linter.unnecessarySimpa false in
      rw [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff]
      exact ⟨q.fe (star ρ) hZstar, by simpa [him] using ht₀,
        by simpa [him] using le_rfl⟩
    · constructor
      · exact him
      · by_contra h
        simp only [star, ι, sub_re, Complex.one_re] at h
        exact hρ.2.2 (by nlinarith)
  -- (b) ι is an involution
  have hinvol : ∀ ρ, ι (ι ρ) = ρ := by
    intro ρ
    have : star ((1 : ℂ) - star ρ) = star (1 : ℂ) - star (star ρ) := by
      rw [sub_eq_add_neg, star_add, star_neg, ← sub_eq_add_neg]
    rw [show ι (ι ρ) = (1 : ℂ) - star ((1 : ℂ) - star ρ) from rfl, this,
      star_involutive, star_one]
    ring
  -- (c) ι has no fixed point on S (a fixed point would have Re = ½)
  have hfp : ∀ ρ ∈ S, ι ρ ≠ ρ := by
    intro ρ hρ
    simp only [S, f, Finset.mem_filter] at hρ
    by_contra h
    have hre : ρ.re = 1 / 2 := by
      have := congr_arg Complex.re h
      simp only [star, ι, sub_re, Complex.one_re] at this
      nlinarith
    exact hρ.2.2 hre
  -- (d) the 2-cycle blocks {ρ, ιρ} tile S, 2 members each
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
      · -- forward: an element of both blocks sits in the same orbit
        rintro ⟨⟨_, hd⟩, ⟨_, hd2⟩⟩
        rcases hd with h | h
        · -- h : x = ρ
          rcases hd2 with h2 | h2
          · -- x = ρ, x = ρ': ρ = ρ', so b = b'
            have hρ' : ρ = ρ' := h.symm.trans h2
            exact (hne (by rw [← hbe, ← hbe', hρ'])).elim
          · -- x = ρ, x = ιρ': ρ = ιρ'; same block, swapped
            have hrho : ρ = ι ρ' := h.symm.trans h2
            have hinv : ι (ι ρ') = ρ' := hinvol ρ'
            exact (hne (by
              rw [← hbe, ← hbe', hrho]
              ext y
              dsimp only [orb]
              simp only [Finset.mem_filter]
              simp [hinv]
              tauto)).elim
        · -- h : x = ιρ
          rcases hd2 with h2 | h2
          · -- x = ιρ, x = ρ': ιρ = ρ'; same block, swapped
            have hiota : ι ρ = ρ' := h.symm.trans h2
            have hrho : ρ = ι ρ' := (hinvol ρ).symm.trans (congr_arg ι hiota)
            have hinv : ι (ι ρ') = ρ' :=
                (hiota.symm.trans (congr_arg ι hrho)).symm
            exact (hne (by
              rw [← hbe, ← hbe']
              ext y
              dsimp only [orb]
              simp only [Finset.mem_filter]
              simp [hrho, hinv]
              tauto)).elim
          · -- x = ιρ, x = ιρ': ιρ = ιρ' ⇒ ρ = ρ', so b = b'
            have hi2 : ι ρ = ι ρ' := h.symm.trans h2
            have hrho : ρ = ρ' :=
                (hinvol ρ).symm.trans ((congr_arg ι hi2).trans (hinvol ρ'))
            exact (hne (by rw [← hbe, ← hbe', hrho])).elim
      · -- backward: nothing is in the empty intersection
        intro hx
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
        dsimp only [S, f, orb, id] at hx
        rw [Finset.mem_filter] at hx
        exact hx.1
      exact horb
    · intro hx
      have hxS : x ∈ S := by
        dsimp only [S, f] at hx ⊢
        simp only [Finset.mem_filter] at hx ⊢
        exact hx
      dsimp only [B]
      rw [Finset.mem_biUnion]
      refine ⟨orb x, ?hborb, ?hmem⟩
      · rw [Finset.mem_image]
        exact ⟨x, hxS, rfl⟩
      · dsimp only [S, f] at hx
        simp only [Finset.mem_filter] at hx
        dsimp only [S, f, orb, id] at ⊢
        apply Finset.mem_filter.mpr
        constructor
        · apply Finset.mem_filter.mpr
          exact hx
        · exact Or.inl rfl

  -- (g) |B-block union| = 2 · |B|: pairwise-disjoint 2-member blocks
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
  have hS2 : (Finset.card S : ℕ) = (B.biUnion id : Finset ℂ).card := by
    rw [hunion.symm]
  rw [hS2, hmain]
  exact even_two_mul B.card

-- ---------------- the equivalence ----------------

/-- **B-0 (iv), half 1.** RH ⇒ D ≡ 0. -/
theorem zeroD_of_RH (q : ZeroSet) (h : RH q) (t : ℝ) (ht : 0 < t) :
    D q t ht = 0 := by
  simp only [D]
  have hempty : (sliceFin q t ht : Finset ℂ).filter
      (fun ρ => ρ.re ≠ 1 / 2) = ∅ := by
    apply Finset.filter_false_of_mem
    rintro x hx hne
    have hZA : x ∈ q.Z ∧ 0 < x.im ∧ x.im ≤ t := by
      simpa [sliceFin, Finite.mem_toFinset, Set.mem_inter_iff] using hx
    exact hne (h x hZA.1)
  rw [hempty, Finset.card_empty]

/-- **B-0 (iv), half 2.** D ≡ 0 ⇒ RH. Any off-line zero of NEGATIVE
    height is sent by conjugation (HCJ; the Re-part is unchanged) to a
    zero of positive height that D would count — so D ≡ 0 rules it out
    too. -/
theorem RH_of_zeroD (q : ZeroSet)
    (hD : ∀ (t : ℝ) (ht : 0 < t), D q t ht = 0) : RH q := by
  -- the counting engine: an off-line zero θ of positive height sits in D(θ.im)
  have hcount (θ : ℂ) (hθ : θ ∈ q.Z) (hoff : θ.re ≠ 1 / 2) (himθ : 0 < θ.im) :
      1 ≤ D q θ.im himθ := by
    simp only [D]
    have hmem : θ ∈ (q.finite θ.im himθ).toFinset := by
      rw [Finite.mem_toFinset, Set.mem_inter_iff]
      exact ⟨hθ, himθ, le_rfl⟩
    rw [Finset.one_le_card]
    exact ⟨θ, Finset.mem_filter.mpr ⟨hmem, hoff⟩⟩
  intro ρ hρ
  by_contra hre
  have hnonreal : ρ.im ≠ 0 := q.nonReal ρ hρ
  by_cases himpos : 0 < ρ.im
  · have hcard := hcount ρ hρ hre himpos
    rw [hD (ρ.im) himpos] at hcard
    linarith
  · have him0 : ρ.im ≤ 0 := not_lt.mp himpos
    have himneg : ρ.im < 0 := lt_of_le_of_ne him0 hnonreal
    have hcj : star ρ ∈ q.Z := q.conj ρ hρ
    have himc : 0 < (star ρ).im := by
      simp only [star]
      linarith [himneg]
    have hrec : (star ρ).re = ρ.re := by simp only [star]
    have hrecOff : (star ρ).re ≠ 1 / 2 := by
      intro h
      exact hre (by simpa [hrec] using h)
    have hcard := hcount (star ρ) hcj hrecOff himc
    rw [hD (star ρ).im himc] at hcard
    linarith

/-- **B-0.** The counting equivalence: RH (all zeros on-line) iff the
    off-line count D vanishes at every height. Together with
    eqNtotMinusNon, nondec and offSliceEven this is the outline's [B-0]:
    D is ℕ-valued, a step, even-jumping function of the height, and
    RH ⇔ D ≡ 0. -/
theorem RH_iff_Dzero (q : ZeroSet) :
    RH q ↔ (∀ (t : ℝ) (ht : 0 < t), D q t ht = 0) :=
  ⟨fun h t ht => zeroD_of_RH q h t ht, fun hD => RH_of_zeroD q hD⟩

theorem probeConj (z : ℂ) : (star z).im = -z.im := by
  simp only [star]

end B0

-- =====================================================================
-- PART 4 — the exact (ℚ × ℚ) synthetic model (computable, #eval-able)
-- =====================================================================
-- The theorem layer above is classical over Set ℂ (hence noncomputable:
-- ℝ carries no computable order). This layer re-implements the SAME
-- counting code over finite zero lists with EXACT rational coordinates,
-- where every operation is computable and the whole pipeline is
-- #eval-able.
-- The models:
--   M1 — only on-line zeros (three on-line 2-member ±-tuples): RH true,
--        D ≡ 0.
--   M2 — M1 + one off-line pair at height 1 ({⅓ + i, ⅔ + i} and
--        conjugates): RH false; D jumps by exactly 2 at t = 1, even
--        slices everywhere.
--   M3 — M2 + a second off-line pair at height 4: D steps 0 → 2 → 4.
-- What is checked: the four structural hypotheses hold (closure under
-- ρ ↦ ρ̄ and ρ ↦ 1−ρ, non-real); the identity D = Ntot − Non at every
-- model height (B-0 (i)); RH ↔ (D ≡ 0 at all heights) in both
-- directions; and the even-jump law (B-0 (iii)) at every height.
namespace B0Model
-- Fully computable: plain lists of exact rational coordinates (ℚ × ℚ),
-- no Finset (Finset.toList is noncomputable in this toolchain).
def hypNonReal (L : List (ℚ × ℚ)) : Bool := L.all (·.2 ≠ 0)
def hypConj (L : List (ℚ × ℚ)) : Bool := L.all (fun p => (p.1, -p.2) ∈ L)
def hypFE (L : List (ℚ × ℚ)) : Bool := L.all (fun p => (1 - p.1, -p.2) ∈ L)
def hyps (L : List (ℚ × ℚ)) : Bool :=
  hypNonReal L && hypConj L && hypFE L

def Ntot (L : List (ℚ × ℚ)) (t : ℚ) : ℕ :=
  (L.filter (fun p => 0 < p.2 ∧ p.2 ≤ t)).length
def Non (L : List (ℚ × ℚ)) (t : ℚ) : ℕ :=
  (L.filter (fun p => 0 < p.2 ∧ p.2 ≤ t ∧ p.1 = 1 / 2)).length
def D (L : List (ℚ × ℚ)) (t : ℚ) : ℕ :=
  (L.filter (fun p => 0 < p.2 ∧ p.2 ≤ t ∧ p.1 ≠ 1 / 2)).length

def RHm (L : List (ℚ × ℚ)) : Bool := L.all (·.1 = 1 / 2)
def offSlice (L : List (ℚ × ℚ)) (t : ℚ) : List (ℚ × ℚ) :=
  L.filter (fun p => p.2 = t ∧ p.1 ≠ 1 / 2)
def sliceEven (L : List (ℚ × ℚ)) (t : ℚ) : Bool :=
  (offSlice L t).length % 2 = 0

def heights (L : List (ℚ × ℚ)) : List ℚ := L.map (·.2)

def M1 : List (ℚ × ℚ) :=
  [(1/2, 1), (1/2, -1), (1/2, 2), (1/2, -2), (1/2, 3), (1/2, -3)]
def M2 : List (ℚ × ℚ) :=
  M1 ++ [(1/3, 1), (2/3, 1), (1/3, -1), (2/3, -1)]
def M3 : List (ℚ × ℚ) :=
  M2 ++ [(2/5, 4), (3/5, 4), (2/5, -4), (3/5, -4)]

#eval! -- the four structural hypotheses (distinct zeros, non-real,
       -- closed under conjugation and under 1 − ρ):
  (B0Model.hyps M1, B0Model.hyps M2, B0Model.hyps M3)

#eval! -- M1 satisfies RH: D vanishes at all model heights (B-0 (iv),
       -- RH ⇒ D≡0) — row: (RH flag, D at each height)
  (B0Model.RHm M1, (B0Model.heights M1).map (B0Model.D M1))

#eval! -- M2 is NOT RH: D jumps by exactly 2 at the off-line height 1;
       -- slices are even at every height (B-0 (iii))
  (B0Model.RHm M2, (B0Model.heights M2).map (B0Model.D M2),
    (B0Model.heights M2).map (B0Model.sliceEven M2))

#eval! -- M3: two off-line pair heights (1 and 4) — D steps 0 → 2 → 4,
       -- the D≡0 ⇒ RH direction fails exactly where an off-line pair is:
  (B0Model.RHm M3, (B0Model.heights M3).map (B0Model.D M3),
    (B0Model.heights M3).map (B0Model.sliceEven M3))

#eval! -- the counting identity D = Ntot − Non at every height of M2 and M3
       -- (the #eval-able image of B-0 (i)): rows (Ntot, Non, D, Ntot−Non)
  ((B0Model.heights M2).map (fun t =>
     (B0Model.Ntot M2 t, B0Model.Non M2 t, B0Model.D M2 t,
       B0Model.Ntot M2 t - B0Model.Non M2 t)),
   (B0Model.heights M3).map (fun t =>
     (B0Model.Ntot M3 t, B0Model.Non M3 t, B0Model.D M3 t,
       B0Model.Ntot M3 t - B0Model.Non M3 t)))

end B0Model
