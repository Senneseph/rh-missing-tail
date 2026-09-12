/- B3Abel — the B-3 Abel section (§4 of B3.lean), pulled out as a pure move,
    day-016: same lines, same names, no changes. -/
import Mathlib
import RhAttack.B3Core

open BigOperators Real Nat Topology Rat
open Real Set MeasureTheory intervalIntegral

noncomputable section

-- =====================================================================
-- §4 the counting step N_L, the ray integrand, and the exact finite
--      Abel decomposition (the B-3 bridge kernel, ζ-free).
-- ---------------------------------------------------------------------
-- 4.33.1 API notes (doc-verified 2026-09-13 against the pinned
-- Mathlib 4.33.1 source; no guess-iterate):
--   * List algebra is fold-based in core (lean4 tag v4.33.1):
--     List.sum_nil / List.sum_cons / List.sum_append / List.prod_append
--     all exist (Init.Data.List.Lemmas, v4.33.1 tag source).
--   * the FTC used everywhere is the hasDerivAt form (no C¹ hypothesis):
--     integral_eq_sub_of_hasDerivAt
--     (Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean:1149):
--     (∀ x ∈ uIcc a b, HasDerivAt f (f' x) x) + IntervalIntegrable f'
--       ⟹ ∫ a..b f' = f b − f a.
--   * def intervalIntegral f a b := ∫ x in Ioc a b, f x − ∫ x in Ioc b a, f x
--     (Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean:657).
--   * value congr on ∫ a..b: integral_congr_uIoo (no integrability arg,
--     NullSingletonClass ℝ); pointwise → ae: Set.EqOn.aeEq_restrict +
--     restrict_Ioo_eq_restrict_Ioc + uIoc_of_le (Mathlib's own idiom,
--     Mathlib/.../IntervalIntegral/ContDiff.lean:34-46).
--   * HasDerivAt.contDiffOn does NOT exist in 4.33.1 — differentiability
--     is passed pointwise (HasDerivAt) + continuity of the derivative,
--     which the model functions provide in closed form.
-- =====================================================================

/-- N_L(x) = #{g ∈ L : g ≤ x} — the counting step over the finite height
    list L. -/
def NList (L : List ℝ) (x : ℝ) : ℝ :=
    (L.map (fun (g : ℝ) => if g ≤ x then (1 : ℝ) else 0)).sum

/-- The ray integrand at jump point c: (c ≤ x) ⟼ deriv f x, else 0. -/
def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

-- ---------------------------------------------------------------------
-- §4.1 integrability plumbing (the only nontrivial measure part)
-- ---------------------------------------------------------------------

variable {f : ℝ → ℝ} {a b c : ℝ}

/-- deriv f is interval-integrable when continuous on [a,b] (a < b). -/
theorem derivIntegrableCont (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (deriv f) volume a b :=
  hf'cont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)

/-- The ray integrand is interval-integrable (three cases on c). -/
theorem rayIntegrable (c : ℝ) (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (fun x => rayIntegrand f c x) volume a b := by
  by_cases hc' : c ≤ a
  · -- c ≤ a: ray integrand = deriv f pointwise on uIoc a b
    refine (derivIntegrableCont h'ab hf'cont).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        have hcxe : c ≤ x := by linarith [hc', hx.1]
        dsimp only [rayIntegrand]
        exact (if_pos hcxe).symm
      ) measurableSet_Ioo
  · by_cases hcb : b ≤ c
    · -- b ≤ c: ray integrand = 0 pointwise on uIoc a b
      have hzero : IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume a b :=
        continuousOn_const (c := (0 : ℝ)) (s := Icc a b)
          |>.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)
      refine hzero.congr_ae ?_
      rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
      exact Set.EqOn.aeEq_restrict
         (fun x (hx : x ∈ Ioo a b) => by
           have hnot : ¬ c ≤ x := by
             intro h1
             linarith [h1, hx.2, hcb]
           dsimp only [rayIntegrand]
           exact (if_neg hnot).symm
         ) measurableSet_Ioo
    · -- a < c < b: split uIoc a b = uIoc a c ∪ uIoc c b at c
      have hc'b : c < b := by linarith
      have hf'c : ContinuousOn (deriv f) (Icc c b) :=
        hf'cont.mono (Icc_subset_Icc (by linarith) le_rfl)
      have hset : uIoc a b = uIoc a c ∪ uIoc c b := by
        ext x
        rw [uIoc_of_le (le_of_lt h'ab),
            uIoc_of_le (le_of_lt (by linarith : a < c)),
            uIoc_of_le (le_of_lt hc'b)]
        simp only [Set.mem_Ioc, Set.mem_union]
        constructor
        · rintro ⟨ha, hxb⟩
          by_cases hc : c < x
          · exact Or.inr ⟨hc, hxb⟩
          · exact Or.inl ⟨ha, not_lt.mp hc⟩
        · rintro h
          cases h with
          | inl h1 =>
            exact ⟨h1.1, le_trans h1.2 (le_of_lt hc'b)⟩
          | inr h1 =>
            exact ⟨lt_trans (by linarith : a < c) h1.1, h1.2⟩
      have hL : IntegrableOn (fun x : ℝ => rayIntegrand f c x) (uIoc a c) := by
        have hz : IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume a c :=
          continuousOn_const (c := (0 : ℝ)) (s := Icc a c)
            |>.intervalIntegrable_of_Icc (μ := volume) (by linarith)
        have hz' : IntegrableOn (fun _ : ℝ => (0 : ℝ)) (uIoc a c) volume :=
          intervalIntegrable_iff.mp hz
        refine hz'.congr_fun_ae ?_
        rw [uIoc_of_le (by linarith), ← restrict_Ioo_eq_restrict_Ioc]
        exact Set.EqOn.aeEq_restrict
          (fun x (hx : x ∈ Ioo a c) => by
            have hnot : ¬ c ≤ x := by
              intro h1
              linarith [h1, hx.2]
            dsimp only [rayIntegrand]
            exact (if_neg hnot).symm
          ) measurableSet_Ioo
      have hR : IntegrableOn (fun x : ℝ => rayIntegrand f c x) (uIoc c b) := by
        have hII : IntervalIntegrable (fun x : ℝ => rayIntegrand f c x) volume c b :=
          (derivIntegrableCont hc'b hf'c).congr_ae (by
            rw [uIoc_of_le (le_of_lt hc'b), ← restrict_Ioo_eq_restrict_Ioc]
            exact Set.EqOn.aeEq_restrict
              (fun x (hx : x ∈ Ioo c b) => by
                have hcxe : c ≤ x := le_of_lt hx.1
                dsimp only [rayIntegrand]
                exact (if_pos hcxe).symm
              ) measurableSet_Ioo)
        exact intervalIntegrable_iff.mp hII
      rw [intervalIntegrable_iff]
      rw [hset]
      exact hL.union hR

/-- N_L · deriv f is interval-integrable (induction on L over the rays). -/
theorem NListRayIntegrable (L : List ℝ) (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (fun x => NList L x * deriv f x) volume a b := by
  induction L with
  | nil =>
    refine (continuousOn_const (c := (0 : ℝ)) (s := Icc a b)
        |>.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        dsimp only [NList]
        simp
      ) measurableSet_Ioo
  | cons g tail ih =>
    refine (IntervalIntegrable.add ih (rayIntegrable g h'ab hf'cont)).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        by_cases hg : g ≤ x
        · dsimp only [NList, rayIntegrand]
          simp [hg]
          ring
        · dsimp only [NList, rayIntegrand]
          simp [hg]
      ) measurableSet_Ioo

-- ---------------------------------------------------------------------
-- §4.2 the ray value (three cases on the jump point)
-- ---------------------------------------------------------------------

/-- ∫_a^b (c ≤ x ⟼ deriv f x | 0) = f b − f a | f b − f c | 0,
    according as c ≤ a | a < c < b | b ≤ c. -/
theorem rayInt_eval (c : ℝ) (h'ab : a < b)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, rayIntegrand f c x =
      if c ≤ a then f b - f a else if c < b then f b - f c else 0 := by
  by_cases hc' : c ≤ a
  · rw [if_pos hc']
    have hCong : ∀ x ∈ uIoo a b, rayIntegrand f c x = deriv f x := by
      intro x hx
      rw [uIoo_of_lt h'ab] at hx
      have hcxe : c ≤ x := by linarith [hc', hx.1]
      dsimp only [rayIntegrand]
      exact if_pos hcxe
    rw [integral_congr_uIoo hCong]
    exact integral_eq_sub_of_hasDerivAt
      (fun x (hx : x ∈ uIcc a b) =>
        hfderiv x (by
          rw [uIcc_of_le (le_of_lt h'ab)] at hx
          exact hx))
      (derivIntegrableCont h'ab hf'cont)
  · by_cases hcb : c < b
    · rw [if_neg hc', if_pos hcb]
      have hfda : ∀ x ∈ Icc a c, HasDerivAt f (deriv f x) x := fun x hx =>
        hfderiv x ⟨hx.1, hx.2.trans (le_of_lt hcb)⟩
      have hfda' : ContinuousOn (deriv f) (Icc a c) :=
        hf'cont.mono (Icc_subset_Icc le_rfl (le_of_lt hcb))
      have hfdc : ∀ x ∈ Icc c b, HasDerivAt f (deriv f x) x := fun x hx =>
        hfderiv x ⟨le_trans (by linarith : a ≤ c) hx.1, hx.2⟩
      have hfdc' : ContinuousOn (deriv f) (Icc c b) :=
        hf'cont.mono (Icc_subset_Icc (le_of_lt (by linarith)) le_rfl)
      have hadd : ∫ x in a..b, rayIntegrand f c x =
          (∫ x in a..c, rayIntegrand f c x) + (∫ x in c..b, rayIntegrand f c x) :=
        (integral_add_adjacent_intervals
          (rayIntegrable c (by linarith : a < c) hfda')
          (rayIntegrable c (by linarith : c < b) hfdc')).symm
      rw [hadd]
      have hleft : ∫ x in a..c, rayIntegrand f c x = 0 := by
        have hCong : ∀ x ∈ uIoo a c, rayIntegrand f c x = 0 := by
          intro x hx
          rw [uIoo_of_lt (by linarith : a < c)] at hx
          have hnot : ¬ c ≤ x := by
            intro h1
            linarith [h1, hx.2]
          dsimp only [rayIntegrand]
          exact if_neg hnot
        rw [integral_congr_uIoo hCong]
        exact integral_zero
      have hright : ∫ x in c..b, rayIntegrand f c x = ∫ x in c..b, deriv f x := by
        have hCong : ∀ x ∈ uIoo c b, rayIntegrand f c x = deriv f x := by
          intro x hx
          rw [uIoo_of_lt (by linarith : c < b)] at hx
          have hcxe : c ≤ x := le_of_lt hx.1
          dsimp only [rayIntegrand]
          exact if_pos hcxe
        rw [integral_congr_uIoo hCong]
      rw [hleft, hright]
      rw [zero_add]
      exact integral_eq_sub_of_hasDerivAt
        (fun x (hx : x ∈ uIcc c b) =>
          let hx' : x ∈ Icc c b := by simpa [uIcc_of_le (le_of_lt hcb)] using hx
          hfdc x hx')
        (derivIntegrableCont (by linarith : c < b) hfdc')
    · rw [if_neg hc', if_neg hcb]
      have hCong : ∀ x ∈ uIoo a b, rayIntegrand f c x = 0 := by
        intro x hx
        rw [uIoo_of_lt h'ab] at hx
        have hnot : ¬ c ≤ x := by
          intro h1
          linarith [h1, hx.2, hcb]
        dsimp only [rayIntegrand]
        exact if_neg hnot
      rw [integral_congr_uIoo hCong]
      exact integral_zero

-- ---------------------------------------------------------------------
-- §4.3 the exact finite Abel decomposition
-- ---------------------------------------------------------------------

/-- The three-case ray value (the RHS of rayInt_eval) rewritten in
    endpoint-sum form — the algebraic bridge b3Abel uses to fold
    rayInt_eval into the Abel sum. -/
theorem rayEndFormEq (a b g : ℝ) (f : ℝ → ℝ) (h'ab : a < b) :
    f b * (if g ≤ b then (1 : ℝ) else 0) - f a * (if g ≤ a then (1 : ℝ) else 0)
      - (if a < g ∧ g ≤ b then f g else 0) =
      if g ≤ a then f b - f a else if g < b then f b - f g else 0 := by
  -- Needs a < b: without it the g ≤ a, ¬g ≤ b branch (only possible when b < g ≤ a)
  -- makes the two sides unequal for general f.
  split_ifs <;>
  (try linarith) <;>
  (try ring) <;>
  (try {
    -- infeasible: ¬g ≤ a gives a < g and g < b gives g ≤ b
    have hconj : a < g ∧ g ≤ b := by
      constructor
      · linarith
      · linarith
    contradiction
  }) <;>
  (try {
    -- g = b and ¬(a < g ∧ g ≤ b): infeasible with a < b
    have hg0 : g = b := le_antisymm (by linarith) (by intro hlt; linarith)
    have hcon3 : a < g ∧ g ≤ b := by
      rw [hg0]
      exact ⟨h'ab, le_rfl⟩
    contradiction
  }) <;>
  (try {
    -- g = b (top endpoint): f b - f g = f b - f b.
    -- 4.33.1 pin (doc-verified online 2026-09-13): linarith does NOT turn
    -- ¬(g < b) into b ≤ g; not_lt : ¬a < b ↔ b ≤ a is a [simp] lemma
    -- (Mathlib/Order/Defs/LinearOrder.lean), so simp it into the context
    -- first, then linarith derives g = b from g ≤ b ∧ b ≤ g.
    simp only [not_lt] at *
    have hg0 : g = b := by linarith
    rw [hg0]
    ring
  }) <;>
  (try {
    -- g ≤ a < b forces g ≤ b, contradicting ¬g ≤ b
    have hg0 : g ≤ b := by linarith
    contradiction
  })

/-- The exact finite Abel identity: for the counting step N_L over the
    finite height list L,
      ∫_a^b N_L(x) f'(x) dx = f(b) N_L(b) − f(a) N_L(a) − Σ_{a<g≤b} f(g). 
    -/
theorem b3Abel (L : List ℝ) (h'ab : a < b)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, NList L x * deriv f x =
      f b * NList L b - f a * NList L a - (L.map (fun (g : ℝ) => if a < g ∧ g ≤ b then f g else 0)).sum
      := by
  induction L with
  | nil =>
    dsimp only [NList]
    -- 4.33.1: the goal now shows UNFOLDED list sums, so the h0-congruence
    -- pattern (folded) doesn't occur; simp the nil-algebra away instead
    -- (pins: List.map_nil/List.sum_nil core Init.Data.List.Lemmas; integral_zero
    -- as used in rayInt_eval).
    simp only [List.map_nil, List.sum_nil, mul_zero, zero_mul, sub_zero]
    exact integral_zero
  | cons g tail ih =>
    have hpt : ∀ x, NList (g :: tail) x * deriv f x =
        rayIntegrand f g x + NList tail x * deriv f x := by
      intro x
      by_cases hg : g ≤ x
      · dsimp only [NList, rayIntegrand]
        simp [hg]
        ring
      · dsimp only [NList, rayIntegrand]
        simp [hg]
    rw [integral_congr_uIoo (fun x _ => hpt x)]
    rw [integral_add (rayIntegrable g h'ab hf'cont) (NListRayIntegrable tail h'ab hf'cont)]
    have hsum := ih
    have hpt2 : ∫ x in a..b, rayIntegrand f g x =
        f b * (if g ≤ b then (1 : ℝ) else 0) - f a * (if g ≤ a then (1 : ℝ) else 0)
          - (if a < g ∧ g ≤ b then f g else 0) := by
      rw [rayInt_eval g h'ab hfderiv hf'cont, ← rayEndFormEq a b g f h'ab]
    rw [hpt2, hsum]
    dsimp only [NList]
    simp
    split_ifs <;> ring

-- ---------------------------------------------------------------------
-- §4.4 the smooth comparator (RVM main term) piece — IBP on N̂
-- ---------------------------------------------------------------------

variable (t₀ : ℝ)

/-- n̂ is continuous off 0. -/
theorem nHatContinuousOn {s : Set ℝ} (hs : ∀ x ∈ s, 0 < x) : ContinuousOn nHat s := by
  intro x hx
  have hpos : 0 < x * twoPiInv :=
    mul_pos (hs x hx) (inv_pos.mpr (by nlinarith [Real.pi_pos]))
  have h1 : ContinuousAt (fun z : ℝ => z * twoPiInv) x :=
    (continuousAt_id' (x : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (x * twoPiInv) :=
    Real.continuousAt_log (ne_of_gt hpos)
  have h3 : ContinuousAt (fun w : ℝ => w * twoPiInv) (log (x * twoPiInv)) :=
    (continuousAt_id' (log (x * twoPiInv))).mul continuousAt_const  -- 4.33.1: zero
    -- explicit args (pinned source Mathlib/Topology/Continuous.lean) — y and x are
    -- both implicit from the expected type
  exact (ContinuousAt.comp (g := fun w : ℝ => w * twoPiInv)
      (f := fun z : ℝ => log (z * twoPiInv)) (x := x)
      h3 (ContinuousAt.comp (g := log) (f := fun w : ℝ => w * twoPiInv) (x := x) h2 h1)
    ).continuousWithinAt (s := s)  -- 4.33.1 pin (ProbeK5-Q1 green): named-arg comp;
    -- term-mode h3.comp (h2.comp h1) fails to match the surface shapes

/-- N̂ is continuous off 0. -/
theorem NHatContinuousOn {s : Set ℝ} (hs : ∀ x ∈ s, 0 < x) : ContinuousOn NHat s := by
  intro x hx
  have hpos : 0 < x * twoPiInv :=
    mul_pos (hs x hx) (inv_pos.mpr (by nlinarith [Real.pi_pos]))
  have h1 : ContinuousAt (fun z : ℝ => z * twoPiInv) x :=
    (continuousAt_id' (x : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (x * twoPiInv) :=
    Real.continuousAt_log (ne_of_gt hpos)
  have hmid : ContinuousAt (fun z : ℝ => log (z * twoPiInv)) x :=
    ContinuousAt.comp (g := log) (f := fun w : ℝ => w * twoPiInv) (x := x) h2 h1  -- 4.33.1 pin (ProbeK5-Q1 green): named-arg comp (term-mode fails)
  have h6 : ContinuousAt (fun z : ℝ => log (z * twoPiInv) - 1) x :=
    hmid.sub continuousAt_const
  have h7 : ContinuousAt (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1)) x :=
    h1.mul h6
  have hC7 : ContinuousAt (fun _ : ℝ => (7 : ℝ) / 8) x := continuousAt_const
  have h8 : ContinuousAt
      (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1) + 7 / 8) x :=
    h7.add hC7
  exact h8.continuousWithinAt (s := s)

/-- The IBP bridge for the smooth comparator:
    ∫_a^b n̂ f = f(b) N̂(b) − f(a) N̂(a) − ∫_a^b N̂ f'. -/
theorem nHatIBP {f : ℝ → ℝ} {a b : ℝ} (h'ab : a < b) (h'a : 0 < a)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, nHat x * f x =
      NHat b * f b - NHat a * f a - (∫ x in a..b, NHat x * deriv f x) := by
  set H := fun x : ℝ => NHat x * f x with hH
  have hposx (x : ℝ) (hx : x ∈ Icc a b) : 0 < x := by linarith [h'a, hx.1]
  have hHderiv : ∀ x ∈ Icc a b, HasDerivAt H (nHat x * f x + NHat x * deriv f x) x := by
    intro x hx
    have hNH : HasDerivAt NHat (nHat x) x := NHat_deriv x (lt_of_lt_of_le h'a hx.1)
    have hf := hfderiv x hx
    rw [hH]
    exact hNH.mul hf
  have hHcont : ContinuousOn H (Icc a b) :=
    (NHatContinuousOn hposx).mul (HasDerivAt.continuousOn hfderiv)
  have hII_nHatf : IntervalIntegrable (fun x : ℝ => nHat x * f x) volume a b :=
    ((nHatContinuousOn hposx).mul (HasDerivAt.continuousOn hfderiv) :
      ContinuousOn (fun x : ℝ => nHat x * f x) (Icc a b)).intervalIntegrable_of_Icc
      (μ := volume) (le_of_lt h'ab)
  have hII_NHatf' : IntervalIntegrable (fun x : ℝ => NHat x * deriv f x) volume a b :=
    ((NHatContinuousOn hposx).mul hf'cont :
      ContinuousOn (fun x : ℝ => NHat x * deriv f x) (Icc a b)).intervalIntegrable_of_Icc
      (μ := volume) (le_of_lt h'ab)
  have hII_dH : IntervalIntegrable (deriv H) volume a b := by
    have hae : (deriv H) =ᵐ[volume.restrict (uIoc a b)]
        (fun x : ℝ => nHat x * f x + NHat x * deriv f x) := by
      rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
      exact Set.EqOn.aeEq_restrict
        (fun x (hx : x ∈ Ioo a b) =>
          HasDerivAt.deriv (hHderiv x ⟨le_of_lt hx.1, le_of_lt hx.2⟩)
        ) measurableSet_Ioo
    exact (hII_nHatf.add hII_NHatf').congr_ae hae.symm
  calc ∫ x in a..b, nHat x * f x
      = (∫ x in a..b, nHat x * f x + NHat x * deriv f x) - (∫ x in a..b, NHat x * deriv f x) :=
        eq_sub_of_add_eq (intervalIntegral.integral_add hII_nHatf hII_NHatf').symm
    _ = (∫ x in a..b, deriv H x) - (∫ x in a..b, NHat x * deriv f x) := by
      have hCong2 : ∀ x ∈ uIoo a b, (nHat x * f x + NHat x * deriv f x : ℝ) = deriv H x := by
        intro x hx
        rw [uIoo_of_lt h'ab] at hx
        exact (HasDerivAt.deriv (hHderiv x ⟨le_of_lt hx.1, le_of_lt hx.2⟩)).symm
      rw [integral_congr_uIoo hCong2]
      -- 4.33.1: that rw already closed the goal (rw auto-close pin); the old
      -- trailing `rfl` was "No goals to be solved"
    _ = NHat b * f b - NHat a * f a - (∫ x in a..b, NHat x * deriv f x) := by
      have hHftc : ∫ x in a..b, deriv H x = NHat b * f b - NHat a * f a :=
        integral_eq_sub_of_hasDerivAt
          (fun x (hx : x ∈ uIcc a b) => by
            rw [uIcc_of_le (le_of_lt h'ab)] at hx
            let h0 := hHderiv x hx
            exact h0.congr_deriv (HasDerivAt.deriv h0 |>.symm))
          hII_dH
      rw [hHftc]
end
