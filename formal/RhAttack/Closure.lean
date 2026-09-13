/- P9 — the closure (outline 8): floor vs detector -> no off-line pair.

SPEC: kainos-logos plan/40-prize-islands/rh-attack/spec/closure-module-abstract.md
OUTLINE: rh-missing-tail docs/RH-PROOF-OUTLINE.md 8 (the closure), 7
  (the detector), 10 (the residual floor), 9 (status), 11 (sources).

ROLE: composes the five machine-proven/pinned pieces of the argument
into the conditional contradiction of 8.  At a candidate height t the
quantity
  Q(t) := | W_n(t) - [K_on(t) - (P_n - I)] |      (the 10 LHS; by
  P8Floor A0 identically |zeta(1/2+it) - K_on(t)|)
is squeezed from below by the zero side when a pair at height g sits
off the line at distance d0 (bridge + detector: Q >= dev(t) - Mf) and
from above by the definition side alone (P8Floor A4: Q <= Bfloor + Mr,
no counting input).  When the floor side sits strictly below the
detector after absorbing both tail bounds (the audited margin, PINNED),
the squeeze is empty at that point; combined with the minimality of
the first off-line pair height (B0 counting lemma, machine-proven)
this closes 8: D = 0, hence RH.

  8, verbatim: "Nothing in the argument counts zeros at any height
inside the proof." — the counting enters only through B0's structural
ZeroSet interface and the pinned constants of the margin/detector
hypotheses (CITED: the bridge zeta = kernel, DLMF 25.2.12; PINNED:
detector floor 0.9975 and margin 112.6x, day-020 audits).

STATUS (2026-09-16, Lean 4.33.1): pins (f_pin, d_min, margin_min,
m_pin), C1-far, C5, C0 (p9_min_offline_height), C5b
(p9_closure_rh_of_margin) GREEN — the 8 conditional closure is
complete (bridge + detector >= side, P8Floor definition-side < side,
B0 minimality, squeezed margin as the explicit measurement input).
The open analysis atom is C1b (spec closure-module-abstract.md 1):
the branch-locus d,t two-variable minimum of |R - 1| as a Lean
theorem — the promotion that would make the own-regime detector
floor (currently p9_f_pin, PINNED) a Lean-proven bound.

HONEST SPLIT (per-atom):
  C0 (B0 counting interface): LEAN-PROVEN (imported); the minimal
    off-line height p9_min_offline_height (spec C0-helper): LEAN-
    PROVEN (structural HNR/HCJ/HFIN only — no counting value).
  C1 — detector floor: far regime (t >= 2g, g >= 1) LEAN-PROVEN
    (P8Floor A4.1 import, restated at f_pin); own regime PINNED
    (day-010 d4d3 audit: 0.9975-1.0201 across the d-grid 0.005-0.5 on
    straddle windows |t - g| <= 10; closed form vs direct 4-zero to
    1e-16, day-020 worstcase run).  C1b (promoting the own regime to
    a Lean theorem) is OPEN.
  C5 (the arithmetic squeeze): LEAN-PROVEN.
  C5b (the 8 closure): LEAN-PROVEN under the explicit squeezed-
    margin hypothesis hmargin — its real witnesses ARE the pinned/
    cited measurement constants (bridge-tail bound Mf = the b3
    BSBAR explicit wire at the Xval pin, detector floor = p9_f_pin,
    definition-side floor = the P8Floor A4 composition, margin =
    p9_m_pin); the module does not re-invent the measurements and
    does not assume them inside Lean.

CITATIONS (outline 11 + day logs): DLMF 25.2.12 (the bridge);
  Platt-Trudgian (Sbar, M(G,t), J. Number Theory 147 (2015));
  Apostol 12.21 / DLMF 25.2.8 (the Re-1/2 W_n equality, cited in
  P4Limit/P8Floor); day-010 d4d3 audit (detector floor); day-020
  worstcase audit (margin 112.6x) + xval pin (3.9665, 206x).

DISCIPLINE: constants are computed, never recalled; no prize-claim
theorem named after RH (B0's RH_of_zeroD is the closed counting
lemma, P1 — this module composes under it); one green commit per
atom; probes deleted after use; numerics sanity-check only.

COMPOSITION ROOT (how the atoms bring the 8 closure together):
  §8 asks: does a candidate off-line pair (g, d0) exist?  Suppose
  one does, in a B0 zero set q.  Then:
    1. C0 (p9_min_offline_height): a MINIMUM positive off-line pair
       height t0 exists (structural HNR/HCJ/HFIN only); let ρ0 be
       the off-line zero at t0, at distance d0 > 0 from Re = 1/2.
    2. The squeezed margin at (t0, d0) — hmargin in C5b — is the
       explicit measurement input: the zero side (bridge §6 +
       detector §7: Q >= dev - Mf, dev >= min-d detector scale
       fro) vs the definition side (§10 via P8Floor A4: Q <= Bfloor
       + Mr, no counting) with the audited strict gap Bfloor + Mr
       + Mf < fro (the day-020 worstcase margin 112.6x; the |z|
       side Xval pin 206x).
    3. C5 (p9_point_contradiction): the two sides are incompatible
       at (t0, d0) — the minimum off-line pair cannot sit off the
       line — contradicting the choice of ρ0.  Hence no off-line
       zero exists at any height: RH q (C5b).
  The composition is conditional by design: hmargin is a hypothesis
  (its instantiation with the pin constants is verified numerically,
  not in Lean — the C1b promotion is the remaining price).
-/

import Mathlib
import RhAttack.B0
import RhAttack.P8Floor

open Real Finset Set
open B0

/-! P9 · C1 — the detector floor: pins and the far-regime half.
-/

/-- PINNED detector floor (day-010 d4d3 audit; the near-regime edge of
    the measured |R - 1| = 0.997500 ... 1.020104 across the d-grid
    d = 0.005 ... 0.5 on straddle windows |t - g| <= 10).  MEASUREMENT,
    not a Lean-proven bound: the own-height (branch-locus) regime is
    the open atom C1b (spec closure-module-abstract.md 1). -/
def p9_f_pin : ℝ := 0.9975

/-- PINNED d-threshold (the spec's 3, Route A's price): the lower edge
    of the measured d-grid.  The P4 floor is d-independent and the
    detector has no dead-d window (B5 `b5NoffPos` + A3.1), so the
    measured edge is the operative threshold. -/
def p9_d_min : ℝ := 0.005

/-- PINNED margin constant (day-020 worstcase audit, record
    scripts/rh/out_day020_worstcase.txt): on the scanned windows
    (4 candidate pair heights g, straddle |t - g| <= 12, step 0.5)
    the pointwise decision has minimum margin 112.6 (worst at
    t = 1006.7916, g = 999.791572). -/
def p9_margin_min : ℝ := 112.6

/-- The margin as a fraction: floor + tails < detector * p9_m_pin. -/
noncomputable def p9_m_pin : ℝ := 1 / p9_margin_min

/-- Atom C1-far (LEAN-PROVEN, restated): in the far regime (g >= 1,
    t >= 2g) the detector scale already exceeds the pinned near floor:
    f_pin <= ||R(g, 0, t) - 1||.  (P8Floor A4.1b gives >= 1.) -/
theorem p9_far_detector_ge_pin (g t : ℝ) (hg : 1 <= g) (ht : 2 * g <= t) :
    p9_f_pin <= ‖Rratio g 0 t - 1‖ := by
  calc p9_f_pin <= 1 := by
        unfold p9_f_pin
        norm_num
    _ <= ‖Rratio g 0 t - 1‖ :=
        p8_far_detector_scale_ge_one g t hg ht

/-! P9 · C5 — the point contradiction (the arithmetic squeeze).

    At a point t with a candidate off-line pair at height g:
    Q := |W_n(t) - [K_on(t) - (P_n - I)]|      (the 10 LHS)
    dev := the zero-side kernel change if the pair moved to d0:
             dev = |K_on(t)| * |R(g, d0, t) - 1|    (7 algebra)
    flo := the min-d detector scale f(d, t) |K_on(t)|
             (flo <= dev: d0 is one of the d's)
    Mf := the bridge tail error bound at t    (5 / P5: M(G, t) —
             the b3BoundExplicit wire, P8Floor A4.3; CITED boundary:
             zeta = kernel)
    Bfloor + Mr := the definition-side floor (P8Floor A2a/A4.3:
             p8_B t n + mass e^Xval Xval)
    Squeeze:  flo - Mf <= Q  (bridge + detector, >= side)
              Q <= Bfloor + Mr   (10, < side, definition side alone)
    with the margin  Bfloor + Mr + Mf < flo  the two are empty.
-/

/-- Atom C5 (LEAN-PROVEN; the squeeze): the floor side (Bfloor + Mr)
    strictly below the detector (flo) after absorbing the bridge-tail
    bound (Mf) makes the two sides of the 10 statement incompatible at
    the point: Q >= flo - Mf and Q <= Bfloor + Mr < flo - Mf. -/
theorem p9_point_contradiction (Q dev flo Mf Bfloor Mr : ℝ)
    (hQge : Q >= dev - Mf)
    (hDev : dev >= flo)
    (hQle : Q <= Bfloor + Mr)
    (hMargin : Bfloor + Mr + Mf < flo) : False := by
  have hLo : flo - Mf <= Q := by
    linarith [hQge, hDev]
  have hHi : Q < flo - Mf := by
    linarith [hQle, hMargin]
  linarith [hLo, hHi]

/-! P9 · C0 — the minimal off-line pair height (over B0's interface).

    If an off-line zero exists at all (in any B0 ZeroSet), a MINIMUM
    positive off-line pair height t0 > 0 exists, at which an off-line
    zero sits, and every off-line zero's pair-height is >= t0.
    Counting-free in the sense of 8: only the structural HNR (no
    real zeros), HCJ (conjugation symmetry) and HFIN (finiteness of
    the height slice) properties of ZeroSet are used — no counting
    value, no height bound, no analytic input.
-/

/-- Atom C0 (LEAN-PROVEN): the minimal positive off-line pair height.
    hzero exhibits the off-line zero at the minimum height; hmin is
    the minimality (every off-line zero height >= t0). -/
theorem p9_min_offline_height (q : ZeroSet)
    (hoff : ∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2) :
    ∃ t0, 0 < t0 ∧
      (∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2 ∧ (|ρ.im| : ℝ) = t0) ∧
      ∀ ρ ∈ q.Z, ρ.re ≠ 1 / 2 → 0 < |ρ.im| → t0 ≤ |ρ.im| := by
  obtain ⟨ρ0, hρ0, hoff0⟩ := hoff
  -- (1) a positive-height off-line zero (conjugation if needed; the
  --     B0 RH_of_zeroD idiom: HNR makes Im ≠ 0)
  have hpos : ∃ (θ : Complex), θ ∈ q.Z ∧ θ.re ≠ 1 / 2 ∧ 0 < θ.im := by
    by_cases him : 0 < (ρ0.im : ℝ)
    · exact ⟨ρ0, hρ0, hoff0, him⟩
    · have hne : (ρ0.im : ℝ) ≠ 0 := by simpa using q.nonReal ρ0 hρ0
      have hneg : (ρ0.im : ℝ) < 0 := lt_of_le_of_ne (le_of_not_gt him) hne
      have hcj : star ρ0 ∈ q.Z := q.conj ρ0 hρ0
      have href : (star ρ0).re ≠ 1 / 2 := by
        intro h
        have hrec : (star ρ0).re = ρ0.re := by simp only [star]
        exact hoff0 (by rwa [hrec] at h)
      exact ⟨star ρ0, hcj, href, by
        change 0 < -(ρ0.im)
        linarith [hneg]⟩
  obtain ⟨θ, hθ, hθo, hθp⟩ := hpos
  -- (2) the finite slice at height θ.im (HFIN), filtered to off-line
  --     zeros, with explicit membership iff's (no let-opaqueness)
  set S := (q.finite θ.im hθp).toFinset with hSdef
  have hS (z : Complex) : z ∈ S ↔ z ∈ q.Z ∧ 0 < z.im ∧ z.im ≤ θ.im := by
    rw [hSdef]
    simp [Finite.mem_toFinset, Set.mem_inter_iff]
  set H := S.filter (fun z : Complex => (z.re : ℝ) ≠ 1 / 2) with hHdef
  have hH (z : Complex) : z ∈ H ↔ z ∈ S ∧ (z.re : ℝ) ≠ 1 / 2 := by
    rw [hHdef]
    simp [Finset.mem_filter]
  have hθS : θ ∈ S := (hS θ).mpr ⟨hθ, hθp, le_rfl⟩
  have hθH : θ ∈ H := (hH θ).mpr ⟨hθS, hθo⟩
  have hHne : H.Nonempty := ⟨θ, hθH⟩
  -- (3) the height image (Finset ℝ) and its minimum; `set … with`
  --     equations (local lets are opaque to the checker)
  set Hh := H.image (fun z : Complex => (z.im : ℝ)) with hHhdef
  have hHhne : Hh.Nonempty := by
    rw [hHhdef]
    exact Finset.image_nonempty.mpr hHne
  let t0 := Hh.min' hHhne
  have hle (y : ℝ) (hy : y ∈ Hh) : t0 ≤ y := by
    have hleast : IsLeast (↑Hh) (Hh.min' hHhne) := Finset.isLeast_min' Hh hHhne
    have hlb : ∀ a ∈ Hh, Hh.min' hHhne ≤ a := by
      simpa [lowerBounds] using hleast.2
    exact hlb y hy
  have ht0p : 0 < t0 := by
    obtain ⟨z, hz, hzeq⟩ := Finset.mem_image.mp (Finset.min'_mem Hh hHhne)
    have hzHS : z ∈ S ∧ (z.re : ℝ) ≠ 1 / 2 := (hH z).mp hz
    have hzSlice : z ∈ q.Z ∧ 0 < z.im ∧ z.im ≤ θ.im := (hS z).mp hzHS.1
    have hzi : 0 < (z.im : ℝ) := hzSlice.2.1
    change 0 < (Hh.min' hHhne : ℝ)
    rw [← hzeq]
    exact hzi
  have hzero : ∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2 ∧ (|ρ.im| : ℝ) = t0 := by
    obtain ⟨z, hz, hzeq⟩ := Finset.mem_image.mp (Finset.min'_mem Hh hHhne)
    have hzHS : z ∈ S ∧ (z.re : ℝ) ≠ 1 / 2 := (hH z).mp hz
    have hzSlice : z ∈ q.Z ∧ 0 < z.im ∧ z.im ≤ θ.im := (hS z).mp hzHS.1
    refine ⟨z, hzSlice.1, hzHS.2, ?_⟩
    rw [abs_of_pos hzSlice.2.1]
    exact hzeq
  -- (4) minimality over ALL off-line zero heights: the positive-
  --     height representative of any off-line zero is either inside
  --     the slice (its height is an element of Hh) or above it
  --     (t0 <= θ.im < its height)
  have hmin : ∀ ρ ∈ q.Z, ρ.re ≠ 1 / 2 → 0 < |ρ.im| → t0 ≤ |ρ.im| := by
    intro ρ hρ hoffρ him
    have hrep : ∃ (θp : Complex), θp ∈ q.Z ∧ θp.re ≠ 1 / 2 ∧ 0 < θp.im ∧ θp.im = |ρ.im| := by
      by_cases himp : 0 < (ρ.im : ℝ)
      · refine ⟨ρ, hρ, hoffρ, himp, ?_⟩
        rw [abs_of_pos himp]
      · have hne : (ρ.im : ℝ) ≠ 0 := by simpa using q.nonReal ρ hρ
        have hneg : (ρ.im : ℝ) < 0 := lt_of_le_of_ne (le_of_not_gt himp) hne
        have hcj : star ρ ∈ q.Z := q.conj ρ hρ
        have hco : (star ρ).re ≠ 1 / 2 := by
          intro h
          have hrec : (star ρ).re = ρ.re := by simp only [star]
          exact hoffρ (by rwa [hrec] at h)
        exact ⟨star ρ, hcj, hco, by
          change 0 < -(ρ.im)
          linarith [hneg], by
          have hcoim : (star ρ).im = -ρ.im := by simp only [star]
          rw [hcoim, abs_of_neg (by simpa using hneg)]⟩
    obtain ⟨θp, hθp, hθpo, hθppos, hθpeq⟩ := hrep
    by_cases hbig : θ.im < (θp.im : ℝ)
    · -- θp is above the slice: t0 <= θ.im < θp.im
      have hhθ : (θ.im : ℝ) ∈ Hh := by
        rw [hHhdef]
        exact Finset.mem_image.mpr ⟨θ, hθH, rfl⟩
      calc t0 ≤ θ.im := hle (θ.im) hhθ
        _ ≤ θp.im := le_of_lt hbig
        _ = |ρ.im| := by rw [hθpeq]
    · -- θp is inside the slice (0 < θp.im <= θ.im): θp ∈ H
      have hθpS : θp ∈ S := (hS θp).mpr ⟨hθp, hθppos, le_of_not_gt hbig⟩
      have hθpH : θp ∈ H := (hH θp).mpr ⟨hθpS, hθpo⟩
      have hhθp : (θp.im : ℝ) ∈ Hh := by
        rw [hHhdef]
        exact Finset.mem_image.mpr ⟨θp, hθpH, rfl⟩
      calc t0 ≤ (θp.im : ℝ) := hle (θp.im) hhθp
        _ = |ρ.im| := by rw [hθpeq]
  exact ⟨t0, ht0p, hzero, hmin⟩

/-! P9 · C5b — the 8 closure (minimality + the squeezed margin).

    Assume RH fails for the zero set q.  By C0 there is a MINIMUM
    positive off-line pair height t0 with an off-line zero ρ0 at
    distance d0 > 0 flom the line.  The squeezed-margin hypothesis
    (hmargin: at every off-line pair height (t0, d0) the arithmetic
    squeeze of C5 holds — its four real witnesses ARE the pinned/
    cited measurement constants: the bridge-tail bound Mf, the
    detector floor flo, the P8Floor definition-side floor Bfloor +
    Mr, day-020 worstcase audit) makes the point contradiction at
    (t0, d0): the off-line zero at the minimum height cannot exist.
    Hence — by the by_contra route — no off-line zero exists at any
    height: RH q.

    8, verbatim: "Nothing in the argument counts zeros at any
    height inside the proof."  The only structural counting input is
    B0's ZeroSet (HNR/HCJ/HFIN — no counting values); the only
    analytic input is the margin hypothesis, which the day-020
    worstcase audit verifies pointwise on the scanned windows with
    minimum margin 112.6 (and the Xval pin 206x on the |z| side).
    The hypothesis is kept EXPLICIT (not assumed true in Lean): the
    promotion of the own-height branch-locus detector floor to a
    Lean theorem is the open atom C1b (spec closure-module-
    abstract.md 1; the outline "Route A's price").
-/

/-- Atom C5b (LEAN-PROVEN under the explicit squeezed-margin
    hypothesis; the 8 conditional closure): RH holds for q.  When
    the margin hypothesis is instantiated with the audited pin
    constants (p9_m_pin, p9_f_pin, p9_d_min and the P8Floor/B3 wires),
    this is the final composition: bridge + detector >= side,
    definition-side < side (P8Floor A4), B0 minimality (C0). -/
theorem p9_closure_rh_of_margin (q : ZeroSet)
    (hmargin : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      (∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2 ∧ (|ρ.im| : ℝ) = t0 ∧
        |(ρ.re : ℝ) - 1 / 2| = d0) →
      ∃ (Q dev flo Mf Bfloor Mr : ℝ),
        Q >= dev - Mf ∧ dev >= flo ∧
        Q <= Bfloor + Mr ∧ Bfloor + Mr + Mf < flo) :
    RH q := by
  by_contra hnot
  have hOff : ∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2 := by
    by_contra h
    have hall : RH q := by
      intro ρ hρ
      by_contra hre
      exact h ⟨ρ, hρ, hre⟩
    exact hnot hall
  obtain ⟨t0, ht0, hzero, hmin⟩ := p9_min_offline_height q hOff
  obtain ⟨ρ0, hρ0, hre0, him0⟩ := hzero
  have hd0 : 0 < |(ρ0.re : ℝ) - 1 / 2| := by
    by_contra h
    have ha0 : |(ρ0.re : ℝ) - 1 / 2| = 0 :=
      le_antisymm (le_of_not_gt h) (abs_nonneg _)
    have hdiff : (ρ0.re : ℝ) - 1 / 2 = 0 := (abs_eq_zero (a := (ρ0.re - 1 / 2))).mp ha0
    exact hre0 (by simpa [sub_eq_zero] using hdiff)
  specialize hmargin t0 (|(ρ0.re : ℝ) - 1 / 2|) ht0 hd0
    ⟨ρ0, hρ0, hre0, him0, rfl⟩
  obtain ⟨Q, dev, flo, Mf, Bfloor, Mr, hQge, hDev, hQle, hMargin⟩ := hmargin
  exact p9_point_contradiction Q dev flo Mf Bfloor Mr hQge hDev hQle hMargin
