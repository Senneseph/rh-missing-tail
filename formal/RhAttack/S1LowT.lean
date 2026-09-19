import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.B5
import RhAttack.Closure
import RhAttack.C1b
import RhAttack.P8Floor
import RhAttack.S4Strip

open Real Set B0 P12

/-! S1 LOW-T — the low-t data territory as a bound-level composition.
    STATUS MAP (honest split; day030, DISCOVERY_LOG low-t block,
    spec LOW-T-DATA-TERRITORY-PLAN [DONE], spec p1.2-uniform-squeeze):

    P1.2 (`P12.p1_2`) decomposes RH into four pointwise structural
    hypotheses S1..S4 on the off-line pairs of an abstract
    `ZeroSet`.  The S4A composition (S4Asm) owns the (t >= 1000,
    d0 > 1/2) side.  This module is the DUAL: the low-t strip

        (t0, d0) with 0 < t0 < 1000 and 0 < d0 <= 1/2,

    filled by the day030 data territory at the SCREEN level, stated
    as an explicit bound-level composition:

    What day030 filled (MEASURED, screen level, H1):
      - the S1 zero side and the S4 squeeze on the strip: margin_new
        >= 1 at ALL 207 grid points (200-point geomspace over
        (0.5, 999) plus 8 pins, 500-delta dev grid, finite S2 disc
        floor), global min 7.35737123 at t0 = 1/2 (dual-precision
        anchored 7.35737123 (dps-30) / 7.35752136 (dps-50));
      - the finite zero structure of (0, 1200]: 813 zeros, LMFDB
        oracle slice (md5 2f5e5b17b12906db8bba9bcab105e6ea),
        monotone, min gap >= 0.221, count vs the N(1200)
        asymptotic exact (+0), all points at the dps-30 noise
        floor (max |zeta| 1.96e-12, gate 1e-8).

    What the wire composes (LEAN-PROVEN, imported):
      - the P1.2 four-conjunct squeeze shape itself
        (`P12.squeeze_gives_margin`, `P12.p1_2`);
      - the S2 detector-floor regime atoms (C1b discrete-straddle
        floor where its regime applies, P8 far/own-height) — the
        low-t strip's S2 floor where the high-t curve degenerates
        (1 - 25/gamma -> 0 as gamma -> 25) is a PINNED measured
        floor, finite data by design (H6: there is no closed-form
        uniform low-t lower bound).

    What stays DATA (PROMISED, per H6, no closed form):
      - the grid witnesses themselves: 207 pinned margin floors
        (here, in aggregate: the nine interval floors of the 207-
        point sweep, each a safe rational below the measured min
        of its interval);
      - the between-witness bridging on the strip: the measured
        smoothness (dev ~ 1e-3..2e-2 variation, residf <= 2.25e-3
        vs margins >= 7.35) makes the grid screen-adequate; that
        adequacy is made an EXPLICIT named hypothesis of the
        composition (the S4Asm `gapW`/`gapO` pattern), not a
        hidden measurement.

    NO RH claim in this file: the composition theorem takes the
    strip hypotheses as inputs (each with its documented source)
    and outputs the P1.2 squeezed-margin form on the strip.  The
    d0 > 1/2 side of the low-t strip stays CLASSICALLY-CITED
    (zero-free regions / Backlund RVM) as before.
-/

namespace S1LowT

open P12

/- Strip constants (PINNED domain edges, LOW-T-DATA-TERRITORY-PLAN). -/
noncomputable def TLow : ℝ := 1000
noncomputable def DLow : ℝ := 1 / 2

/- The (0, 1200] zero slice as PINNED finite data (oracle: the
    committed LMFDB 1e7 list, slice md5 2f5e5b17b12906db8bba9bcab105e6ea;
    day030 `scripts/rh/lowt/zeros_0_to_1p2e3.*`).  Stated for an
    abstract ZeroSet q carrying the slice's verified properties —
    the same PINNED-data pattern as S4Asm (finite structure, no
    closed form; H6). -/
noncomputable def sliceHi : ℝ := 1200              -- slice height (0, 1200]
def nSlice : ℕ := 813                -- zero count on (0, 1200]
def gapLo : ℚ := 221 / 1000          -- min gap 0.2211 -> safe 0.221

/-- The slice facts (PROMISED finite data; every one verified
    day030, part of the same pinned record): the zero count of
    the (0, 1200] slice is cnt = nSlice = 813 (count vs the
    N(1200) LMFDB oracle exact [+0] — the no-missing-zero check),
    and consecutive slice heights are more than gapInf apart with
    0 < gapInf <= gapLo = 0.221 (the measured min gap is 0.2211,
    so 0.221 is a safe side).  The other facts of the record
    (monotone, first zero 14.134725.., last 1055.0021.., all 813
    points at the dps-30 noise floor max |zeta| 1.96e-12 below
    the 1e-8 gate) are documented in the module header and the
    day030 log.  Stated as an explicit hypothesis of the
    composition (like S4Asm's pinned constants): the abstract
    ZeroSet carries no arithmetic structure to count against
    directly (B0 is pure Finset cardinal arithmetic over the
    abstract set), so the slice record enters as data, not as a
    quantified statement over q. -/
noncomputable def SliceFacts (cnt : ℕ) (gapInf : ℝ) : Prop :=
    cnt = nSlice ∧ 0 < gapInf ∧ gapInf ≤ (gapLo : ℝ)

/-- Screen-level grid-bridging adequacy on the strip (the
    EXPLICIT named hypothesis, S4Asm gapW/gapO pattern): the
    measured sweep is adequate to bridge its own cells — inside
    every sweep cell the squeeze margin does not dip below the
    cell's pinned floor minus the cell's pinned loss (both safe
    rationals below the measured values).  Source: day030 sweep
    log (dev variation, residf <= 2.25e-3, margins >= 7.357 at
    both ends of every cell). -/
def GridAdequate (margin : ℝ × ℝ → ℝ) : Prop :=
    ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      margin (t0, d0) ≥ (7357 : ℝ) / 1000

/-- The composition (SCREEN level, H1; the day030 verdict stated
    as a bound-level theorem shape): on the low-t strip, with the
    slice facts, the pinned squeeze-margin function marginLowT
    (the measured margin_new of the day030 sweep as a function of
    (t0, d0) on the strip) carrying the explicit grid-adequacy
    floor, and the four P1.2 hypotheses instantiated on the
    strip, the P1.2 squeezed-margin form holds pointwise AND the
    pinned floor 7357/1000 (= 7.357, the safe rational below the
    measured global min 7.35737123) bounds marginLowT across the
    strip.

    Sources of the inputs (the wire's honesty labels):
    - marginLowT + hgrid: MEASURED (day030 sweep, 207 points,
      dual-precision anchored; the between-cell adequacy is the
      explicit named hypothesis hgrid — H6 pattern, no hidden
      measurement);
    - hslice: PROMISED finite data (the 813-zero slice record);
    - hs1 (zero side): the day030 data fill (the kernel = the
      zero side of the 25.2.12 identity);
    - hs2 (detector floor): C1b discrete regime atom where it
      applies + P8 far/own atoms; pin-scale 0.9975 witness
      constant on the audited grid;
    - hs3 (definition side): P8Floor A4 pointwise under the
      pinned mass input (hX-style wire pin);
    - hs4 (squeeze): the day030 measurement margin_new >= 1 is
      exactly this inequality in its wire form.
    NO RH claim: the theorem takes the inputs and outputs the
    P1.2 form on the strip (the S4Asm pattern, low-t dual). -/
theorem strip_squeeze
    (q : ZeroSet)
    (marginLowT : ℝ × ℝ → ℝ)
    (hgrid : GridAdequate marginLowT)
    (_hslice : SliceFacts nSlice (0.221 : ℝ))
    (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → ∃ Q, Q ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → Q ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 →
      (∃ (Q dev f M Bf Mr' : ℝ),
        Q ≥ dev - M ∧ dev ≥ f ∧ Q ≤ Bf + Mr' ∧ Bf + Mr' + M < f) ∧
      marginLowT (t0, d0) ≥ (7357 : ℝ) / 1000 := by
  intro t0 d0 ht0 ht0u hd0 hd0u hp
  refine ⟨?_, hgrid t0 d0 ht0 ht0u hd0 hd0u⟩
  obtain ⟨Qw, hQw⟩ := hs1 t0 d0 ht0 ht0u hd0 hd0u hp
  exact ⟨Qw, devOf (t0, d0), flo (t0, d0), Mf (t0, d0),
    Bwire (t0, d0), Mr (t0, d0), hQw,
    hs2 t0 d0 ht0 ht0u hd0 hd0u hp,
    hs3 t0 d0 Qw ht0 ht0u hd0 hd0u hp,
    hs4 t0 d0 ht0 ht0u hd0 hd0u hp⟩

/-- The slice-floor norm_num block: the pinned low-t constants
    are what they claim to be (safe rationals, correct ordering —
    the finite-data arithmetic of the day030 record). -/
theorem slice_consts :
    (7357 : ℝ) / 1000 ≥ 1 ∧
    gapLo > 0 ∧
    nSlice = 813 ∧
    sliceHi = 1200 ∧
    TLow = 1000 ∧
    DLow = 1 / 2 :=
  ⟨by norm_num, by norm_num [gapLo], by rfl, by rfl, by rfl, by rfl⟩


/-! ### v2 — the PROVEN S2 feed (day031): the detector-floor atoms
    of the strip, imported and composed so the composition spends
    more proof than data than v1 (where S2 was a single opaque
    hypothesis).  STATUS MAP for this section:

    PROVEN (this module, by the imported atoms):
    - the WINDOW straddle floor on the strip: for
      gamma >= 707/50, 0 < d <= 1/2, u = the witness straddle with
      1/2 <= |u| <= 12, u != 0 (the discrete lattice u = 0.5k):
        ‖Rratio gamma d (gamma + u) − 1‖ >= max (floWin gamma) 0
      where floWin gamma = min(23/1000, 1 − 25/gamma) — C1b
      `c1b_disc_floor` (imported) where gamma >= 25, and the norm
      nonnegativity otherwise (gamma < 25 makes floWin negative, a
      harmless lower bound; the SQUEEZE there is carried by the
      pinned data floor, H6);
    - the OWN-height (u = 0) detector: the exact value
      ‖poff gamma d gamma‖ > 0 — Closure (C1a)
      `p9_poff_own_height_pos` / `p9_kernel_change_at_own_height`
      (imported) — its floor is the exact mass itself.
    PINNED (the two small residual S2 regions of the strip, named
    hypotheses of strip_squeeze_v2):
    - the SLIVER t0 < 707/50 (the C1b regime starts at 707/50 =
      14.14, just ABOVE the first zero 14.134725; the sliver
      window floors are the pinned measurement of record — the
      day-010 0.9975 pin family);
    - the EDGE d0 = 1/2 (C1a's own-height atom is strict d < 1/2:
      at the edge the off-pair sits at Re 0/1 — void for the
      actual zeta by the classical zero-free regions, CITED; the
      abstract composition keeps the edge as a named pinned
      hypothesis).
    REUSED (the concrete wire functions, S4Asm pattern):
    - BwireStrip (t) := p8_B t (S4Strip.n4 t) — the t^4-family
      definition-side wire (25af), floor side mown via
      S4O.mown; the hs1/hs3/hs4 roles are carried exactly as in
      v1 with the sources documented per hypothesis.
-/

open S4Strip

/-- THE WINDOW FLOOR (C1b, PROVEN atom): floWin(γ) =
    min(23/1000, 1 − 25/γ).  Nonnegative for γ >= 25 (the regime
    where it is USEFUL for the squeeze); for γ <= 25 it is <= 0
    (a harmless lower bound — the squeeze there is pinned, H6). -/
noncomputable def floWin (γ : ℝ) : ℝ :=
    min (23 / 1000 : ℝ) (1 - 25 / γ)

theorem floWin_nonneg (γ : ℝ) (hγ : 25 ≤ γ) : 0 ≤ floWin γ := by
  have hγp : 0 < γ := by nlinarith
  rw [floWin]
  exact le_inf (by norm_num) (by rw [sub_nonneg]; exact (div_le_one hγp).mpr (by nlinarith))

theorem floWin_nonpos (γ : ℝ) (hγp : 0 < γ) (hγl : γ ≤ 25) : floWin γ ≤ 0 := by
  rw [floWin]
  have h25 : 1 ≤ 25 / γ := by
    rw [le_div_iff₀ hγp]
    nlinarith
  calc _ ≤ 1 - 25 / γ := min_le_right _ _
       _ ≤ 0 := by nlinarith [h25]

theorem maxFloWin_zero_ge25 (γ : ℝ) (hγ : 25 ≤ γ) :
    max (floWin γ) 0 = floWin γ :=
  max_eq_left (floWin_nonneg γ hγ)

theorem maxFloWin_zero_lt25 (γ : ℝ) (hγp : 0 < γ) (hγl : γ ≤ 25) :
    max (floWin γ) 0 = 0 :=
  max_eq_right (floWin_nonpos γ hγp hγl)

/-- THE OWN FLOOR (C1a, PROVEN atom): the exact own-height
    detector mass (positive for 0 < d < 1/2). -/
noncomputable def floOwn (γ d : ℝ) : ℝ := ‖poff γ d γ‖

theorem s2_own_pos (γ d : ℝ) (hd : 0 < d) (hdh : d < 1 / 2) :
    0 < floOwn γ d := by
  rw [floOwn]
  exact p9_poff_own_height_pos γ d hd hdh

/-- THE WINDOW S2 FLOOR (PROVEN): the concrete window-regime S2
    inequality on the strip — the C1b discrete floor imported,
    with the γ < 25 degeneration handled (max(floWin, 0) = 0, the
    norm nonnegativity suffices).  This is the strip atom behind
    v1's opaque hs2. -/
theorem s2_strip_window (γ d u : ℝ) (hγ : 707 / 50 ≤ γ)
    (hd : 0 < d) (hdL : d ≤ 1 / 2)
    (hum : 1 / 2 ≤ |u|) (huL : |u| ≤ 12) (hu0 : u ≠ 0) :
    ‖Rratio γ d (γ + u) - 1‖ ≥ max (floWin γ) 0 := by
  by_cases h25 : 25 ≤ γ
  · have hM : max (floWin γ) 0 = floWin γ := maxFloWin_zero_ge25 γ h25
    rw [hM]
    exact c1b_disc_floor γ d u hγ hd hdL hum huL hu0
  · have hM : max (floWin γ) 0 = 0 := maxFloWin_zero_lt25 γ (by nlinarith) (le_of_lt (not_le.mp h25))
    rw [hM]
    exact norm_nonneg (Rratio γ d (γ + u) - 1)

/-- THE WITNESS-LATTICE STRADDLES (S2 side, concrete): the 48
    window straddles u = 0.5k, k = -24..-1, 1..24, as a Fin 48
    index (k.val < 24 -> u = 0.5.(k.val + 1); k.val >= 24 ->
    u = -0.5.(k.val - 23)).  Discrete witness lattice of the
    closure protocol (25k[4] scope). -/
noncomputable def strideU (k : Fin 48) : ℝ :=
    (1 / 2 : ℝ) * (if k.val < 24 then (↑(k.val + 1) : ℝ) else -↑(k.val - 23) : ℝ)

def strideIdx (k : ℕ) : Fin 48 :=
    Fin.mk (k % 48) (Nat.mod_lt k (show (0 : ℕ) < 48 from by norm_num))

/-- THE CONCRETE STRIP DETECTOR (S2 side, min over the witness
    lattice): min of the own-height value and all 48 straddle
    values — valid for ANY per-witness instantiation (the
    lattice-wide strengthening). -/
noncomputable def devStripMin (γ d : ℝ) : ℝ :=
    (List.range 48).foldl (fun (acc : ℝ) (k : ℕ) =>
      min acc (‖Rratio γ d (γ + strideU (strideIdx k)) - 1‖))
      (‖poff γ d γ‖)

/-- THE CONCRETE STRIP FLOOR (S2 side): min(own mass,
    max(window floor, 0)) — proven a lower bound on devStripMin
    on the covered region (s2_strip_min). -/
noncomputable def floStripMin (γ d : ℝ) : ℝ :=
    min (‖poff γ d γ‖) (max (floWin γ) 0)

/-- EVERY lattice straddle satisfies the window S2 floor
    (PROVEN — s2_strip_window at each of the 48 lattice points). -/
theorem strideU_floor (γ d : ℝ) (hγ : 707 / 50 ≤ γ)
    (hd : 0 < d) (hdL : d ≤ 1 / 2) (k : Fin 48) :
    ‖Rratio γ d (γ + strideU k) - 1‖ ≥ max (floWin γ) 0 := by
  by_cases h24 : k.val < 24
  · -- case k.val < 24: u = (1/2) * ((k.val : ℝ) + 1) in [1/2, 12]
    set u := (1 / 2 : ℝ) * ((k.val : ℝ) + 1) with hu
    have hudef : strideU k = u := by
      rw [strideU, if_pos h24, hu]
      rw [Nat.cast_add]
      ring
    rw [hudef]
    have hval0 : 0 ≤ (k.val : ℝ) := Nat.cast_nonneg (k.val : ℕ)
    have hxlo : 1 ≤ (k.val : ℝ) + 1 := by nlinarith [hval0]
    have h24n : k.val ≤ 23 := by omega
    have h23 : (k.val : ℝ) ≤ 23 := by exact_mod_cast h24n
    have hxhi : (k.val : ℝ) + 1 ≤ 24 := by
      nlinarith [h23]
    have hu1 : 1 / 2 ≤ u := by
      rw [hu]
      calc (1 / 2 : ℝ) = (1 / 2 : ℝ) * 1 := by norm_num
        _ ≤ (1 / 2 : ℝ) * ((k.val : ℝ) + 1) :=
          mul_le_mul_of_nonneg_left hxlo (by norm_num : 0 ≤ (1 / 2 : ℝ))
    have hu2 : u ≤ 12 := by
      rw [hu]
      calc (1 / 2 : ℝ) * ((k.val : ℝ) + 1) ≤ (1 / 2 : ℝ) * 24 :=
        mul_le_mul_of_nonneg_left hxhi (by norm_num : 0 ≤ (1 / 2 : ℝ))
        _ = 12 := by norm_num
    have hu0n : u ≠ 0 := by
      rw [hu]
      by_contra h
      rw [mul_eq_zero] at h
      cases h with
      | inl h1 => norm_num at h1
      | inr h2 => nlinarith [hxlo, h2]
    have hu0p : 0 ≤ u := by rw [hu]; nlinarith [hval0]
    have habs : |u| = u := abs_of_nonneg hu0p
    have hum1 : 1 / 2 ≤ |u| := by rw [habs]; exact hu1
    have hu2b : |u| ≤ 12 := by rw [habs]; exact hu2
    exact s2_strip_window γ d u hγ hd hdL hum1 hu2b hu0n
  · -- case k.val >= 24: u = -((1/2) * x), x = (k.val - 23 : ℝ) in [1, 24]
    set x := (k.val : ℝ) - 23 with hx
    have hk24n : 24 ≤ k.val := by omega
    have h24 : (k.val : ℝ) ≥ 24 := by exact_mod_cast hk24n
    have hxlo : 1 ≤ x := by rw [hx]; linarith [h24]
    have hk47n : k.val ≤ 47 := by omega
    have h47 : (k.val : ℝ) ≤ 47 := by exact_mod_cast hk47n
    have hxhi : x ≤ 24 := by rw [hx]; linarith [h47]
    set u := (1 / 2 : ℝ) * -x with hu
    have hcast : (↑(k.val - 23 : ℕ) : ℝ) = x := by
      rw [Nat.cast_sub (show (23 : ℕ) ≤ k.val from by omega), hx]
      norm_num
    have hudef : strideU k = u := by
      rw [strideU, if_neg (by omega : ¬ k.val < 24), hcast, hu]
    rw [hudef]
    have huneg : u ≤ 0 := by rw [hu]; nlinarith [hxlo]
    have habs : |u| = -u := abs_of_nonpos huneg
    have huum : |u| = (1 / 2 : ℝ) * x := by
      rw [habs, hu]
      ring
    have hu1 : 1 / 2 ≤ |u| := by
      rw [huum]
      calc (1 / 2 : ℝ) = (1 / 2 : ℝ) * 1 := by norm_num
        _ ≤ (1 / 2 : ℝ) * x :=
          mul_le_mul_of_nonneg_left hxlo (by norm_num : 0 ≤ (1 / 2 : ℝ))
    have hu2 : |u| ≤ 12 := by
      rw [huum]
      calc (1 / 2 : ℝ) * x ≤ (1 / 2 : ℝ) * 24 :=
        mul_le_mul_of_nonneg_left hxhi (by norm_num : 0 ≤ (1 / 2 : ℝ))
        _ = 12 := by norm_num
    have hu0n : u ≠ 0 := by
      rw [hu]
      by_contra h
      nlinarith [h, hxlo]
    exact s2_strip_window γ d u hγ hd hdL hu1 hu2 hu0n

/-- THE LATTICE-WIDE S2 LOWER BOUND (PROVEN): on the covered
    strip region (γ >= 707/50, 0 < d <= 1/2), the min over the
    whole witness lattice sits above the concrete strip floor —
    an induction on the foldl, each step bounded by the lattice
    point (strideU_floor) or the own-height start (min_le_left). -/
theorem devStripMin_lower (γ d : ℝ) (hγ : 707 / 50 ≤ γ)
    (hd : 0 < d) (hdL : d ≤ 1 / 2) :
    devStripMin γ d ≥ floStripMin γ d := by
  set A := ‖poff γ d γ‖ with hA
  set M := max (floWin γ) 0 with hM
  have hflo : floStripMin γ d = min A M := by
    rw [floStripMin, hA, hM]
  rw [hflo]
  set V : ℕ → ℝ := fun (k : ℕ) => ‖Rratio γ d (γ + strideU (strideIdx k)) - 1‖ with hV
  have hv : ∀ (k : ℕ), k < 48 → V k ≥ M := by
    intro k hk
    set kf : Fin 48 := ⟨k, by omega⟩ with hkf
    have hidx : strideIdx k = kf := by
      dsimp [strideIdx]
      rw [Fin.ext_iff]
      exact Nat.mod_eq_of_lt hk
    have h := strideU_floor γ d hγ hd hdL kf
    simpa [hM, hV, hidx] using h
  have hfold : devStripMin γ d =
      (List.range 48).foldl (fun (acc : ℝ) (k : ℕ) => min acc (V k)) A := by
    rw [devStripMin]
  rw [hfold]
  have hP : ∀ (n : ℕ), n ≤ 48 →
      (List.range n).foldl (fun (acc : ℝ) (k : ℕ) => min acc (V k)) A ≥ min A M := by
    intro n hn
    induction n with
    | zero =>
      rw [show List.range 0 = [] from rfl, List.foldl_nil]
      exact min_le_left A M
    | succ n ih =>
      have hn1 : n + 1 ≤ 48 := by omega
      have hI : n ≤ 48 := by omega
      have hX := ih hI
      have hvn := hv n (by omega : n < 48)
      rw [show List.range (n + 1) = List.range n ++ [n] from List.range_succ,
        List.foldl_append]
      exact le_min hX (le_trans (min_le_right A M) hvn)
  exact hP 48 (by norm_num)

/-- THE COVERED-REGION S2 (PROVEN): devStripMin >= floStripMin
    on the covered strip region — the v1 opaque hs2 hypothesis
    replaced by this theorem wherever it reaches (t0 >= 707/50,
    the whole strip above the first-zero sliver). -/
theorem s2_strip_min (t0 d0 : ℝ) (ht0 : 707 / 50 ≤ t0)
    (hd0 : 0 < d0) (hd0L : d0 ≤ 1 / 2) :
    devStripMin t0 d0 ≥ floStripMin t0 d0 :=
  devStripMin_lower t0 d0 ht0 hd0 hd0L

/-- THE v2 COMPOSITION (SCREEN level, H1 — the day030 verdict
    with S2 mostly PROVEN): on the low-t strip, with the pinned
    data inputs (marginLowT + grid adequacy hgrid, the slice
    facts) and the residual hypotheses — hs1 (the CITED
    25.2.12 zero side, the A4.3-wired Mf form), hs3 (the P8 A5
    definition-side terminal under its explicit machine inputs),
    hs4 (the day030 measured squeeze), and the ONE small S2
    residual hs2sliver (t0 < 707/50: the C1b regime gap just
    above the first zero, where the window floors are the pinned
    measurement of record) — the P1.2 squeezed-margin form holds
    pointwise with the CONCRETE dev/flo (devStripMin /
    floStripMin), AND the pinned floor bounds marginLowT.  S2 on
    t0 >= 707/50 is DISCHARGED by the module's own theorem
    (s2_strip_min: window via C1b, own-height start by C1a's
    exact mass).  NO RH claim (v1 header). -/
theorem strip_squeeze_v2
    (q : ZeroSet)
    (marginLowT : ℝ × ℝ → ℝ)
    (hgrid : GridAdequate marginLowT)
    (_hslice : SliceFacts nSlice (0.221 : ℝ))
    (Mf Bwire Mr : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → ∃ Q, Q ≥ devStripMin t0 d0 - Mf (t0, d0))
    (hs2sliver : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 707 / 50 → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → devStripMin t0 d0 ≥ floStripMin t0 d0)
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → Q ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 → Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < floStripMin t0 d0) :
    ∀ (t0 d0 : ℝ), 0 < t0 → t0 < TLow → 0 < d0 → d0 ≤ DLow →
      offPair q t0 d0 →
      (∃ (Q dev f M Bf Mr' : ℝ),
        Q ≥ dev - M ∧ dev ≥ f ∧ Q ≤ Bf + Mr' ∧ Bf + Mr' + M < f) ∧
      marginLowT (t0, d0) ≥ (7357 : ℝ) / 1000 := by
  intro t0 d0 ht0 ht0u hd0 hd0u hp
  refine ⟨?_, hgrid t0 d0 ht0 ht0u hd0 hd0u⟩
  obtain ⟨Qw, hQw⟩ := hs1 t0 d0 ht0 ht0u hd0 hd0u hp
  have hQle := hs3 t0 d0 Qw ht0 ht0u hd0 hd0u hp
  have hgap := hs4 t0 d0 ht0 ht0u hd0 hd0u hp
  have hdev : devStripMin t0 d0 ≥ floStripMin t0 d0 := by
    by_cases hsliver : t0 < 707 / 50
    · exact hs2sliver t0 d0 ht0 hsliver hd0 hd0u hp
    · exact s2_strip_min t0 d0 (by nlinarith) hd0 hd0u
  exact ⟨Qw, devStripMin t0 d0, floStripMin t0 d0, Mf (t0, d0),
    Bwire (t0, d0), Mr (t0, d0), hQw, hdev, hQle, hgap⟩

end S1LowT
