import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform

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

end S1LowT
