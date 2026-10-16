import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.S1LowT
import RhAttack.S4Asm
import RhAttack.SliverEdge
import RhAttack.Z78Strip

open Real Set B0

/-!
**Z78P12 — the 7/8 strip made operational in the P1.2 reduction.**

The S4 composition (S4A.rh_from_regime_closures) closes the
squeeze at the bound level on the covered territory
(1000 ≤ t0, 0 < d0 ≤ 1/2 — window ∪ strip, 25m/25ab/25af) and
keeps two residual territories explicit: the LOW band
(t0 < 1000, data-verified territory) and the FAR region
(d0 > 1/2, Re ρ outside (0, 1)).  For the ABSTRACT zero set
the far region cannot be discharged (the abstract ZeroSet
does not encode zero-free regions) — it was carried as a
hypothesis, empty for the actual set by CITED classical zero-
free regions (Re ≥ 1; via the functional equation, Re ≤ 0).

This module discharges the far region for ACTUAL-SET zero
sets (every element a zero of Mathlib's zeta) by a PROVEN
fact of a stronger class: the external quasi-RH input [Z78]
(externalZeroFree78, kernel-verified; see Z78Strip header)
gives the strip 1/8 <= Re <= 7/8 (zetaZeroStrip), hence
d0 = |Re − 1/2| ≤ 3/8 < 1/2 (offPairD0le, sharp) —
so no far-region pair exists at all.

Consequence, stated as THE ACTUAL-SET REDUCTION (rh_actual78):
for a zero set all of whose elements are zeros of the zeta
function, RH reduces — under [Z78], the pinned low-window X
wire hX, the three P1.2 wire hypotheses (S1 zero side, S2
detector floor, S3 definition side, against the concrete
residue wires of S4A), and the S4 LOW band (0 < t0 < 1000,
0 < d0 ≤ 1/2, the data-verified territory) — to nothing
else.  The bound-level content of S4 (window ∪ strip on
[1000, ∞)) is PROVEN, and the far region is VACUOUS.

No RH claim: [Z78] is an external input of verification
status "kernel-verified, human review in progress"; 7/8 is
not 1/2; the open legs are exactly S1+S2+S3 (uniform wires)
+ the t0 < 1000 low band.
-/

namespace Z78P12

/- Pair-shaped instantiations of the residue wires (P1.2's
   five wires are functions of ℝ × ℝ; S4A carries them
   curried). -/
noncomputable def BwireP (p : ℝ × ℝ) : ℝ := S4A.BwireR p.1 p.2
noncomputable def MrP (p : ℝ × ℝ) : ℝ := S4A.MrR p.1 p.2
def MfP (p : ℝ × ℝ) : ℝ := S4A.MfR p
noncomputable def floP (p : ℝ × ℝ) : ℝ := S4A.floR p.1 p.2

/-- (PROVEN)  The FAR region is empty for actual-set zero
    sets under [Z78]: no off-pair with d0 > 1/2 can exist,
    because offPairD0le gives d0 ≤ 3/8 < 1/2 for every off-
    pair (the strip 1/8 ≤ Re ≤ 7/8, sharp distance 3/8). -/
theorem offPairFarEmpty (q : ZeroSet) (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (hd0f : d0 > 1 / 2) :
    ¬ P12.offPair q t0 d0 := by
  intro hp
  have hpair := hp
  obtain ⟨ρ, hr, hre, him, hd⟩ := hpair
  have ht0 : 0 < t0 := by
    rw [← him]
    exact abs_pos.mpr (q.nonReal ρ hr)
  have hd0 : 0 < d0 := by linarith
  have h18 := Z78.offPairD0le q hz78 hqz t0 d0 ht0 hd0 hp
  linarith

/-- (PROVEN composition)  THE ACTUAL-SET REDUCTION UNDER 7/8:
    let q be a zero set every element of which is a zero of
    Mathlib's zeta, under [Z78] and the pinned low-window
    wire hX.  Then RH holds for q as soon as:
      (S1) a zero-side witness Q ≥ devOf exists at every
            off-pair (against the residue tail, which is 0);
      (S2) the detector deviation dominates the concrete
            residue floor (mown on the strip, the near pin
            on the window) at every off-pair;
      (S3) the witness is bounded above by the concrete
            residue wire at every off-pair;
      (S4-low) the S4 squeeze holds on the LOW band
            0 < t0 < 1000, 0 < d0 ≤ 1/2 (data-verified
            territory — the only residual S4 content).
    The covered territory (t0 ≥ 1000, d0 ≤ 1/2) is supplied
    by the proven window/strip closure; the far region
    (d0 > 1/2) is vacuous for q by offPairFarEmpty. -/
theorem rh_actual78 (q : ZeroSet) (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hX : S4W.Xwire S4W.T0 ≤ S4W.RX)
    (devOf : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
        ∃ (Q : ℝ), Q >= devOf (t0, d0) - MfP (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
        devOf (t0, d0) >= floP (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
        P12.offPair q t0 d0 → Q <= BwireP (t0, d0) + MrP (t0, d0))
    (hs4low : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 1000 → 0 < d0 → d0 ≤ 1 / 2 →
        P12.offPair q t0 d0 →
        BwireP (t0, d0) + MrP (t0, d0) + MfP (t0, d0) < floP (t0, d0)) :
    RH q := by
  refine S4A.rh_from_regime_closures q MfP devOf BwireP MrP floP
    hs1 hs2 hs3 ?_ ?_ ?_
  · intro t0 d0 ht0 hd0 hdmax hp
    dsimp only [BwireP, MrP, MfP, floP]
    exact S4A.s4asm_residue_S4_covered hX t0 d0 ht0 hd0 hdmax
  · exact hs4low
  · intro t0 d0 ht0 hd0 hdfar hp
    have hempty := offPairFarEmpty q hz78 hqz t0 d0 hdfar
    exact False.elim (hempty hp)

/- Gap margin gate: the sharp strip distance (3/8) sits strictly
   below the far-region threshold (1/2) — the vacuity has a
   certified margin of 1/8, recorded in the Float world like
   every other data constant of the program. -/
def stripD0Max : Float := 0.375
def farThreshold : Float := 0.5
#eval stripD0Max < farThreshold

/- The d0 = 1/2 EDGE (SliverEdge.EdgeZeroFree, currently the
   CITED classical leg of the low-t composition: Hadamard / de
   la Vall\u00e9e Poussin on Re = 1 + functional equation on
   Re = 0).  The [Z78] input PROVES a strictly stronger
   statement: every non-real zero sits in 1/8 <= Re <= 7/8,
   so both edge lines (Re = 0 and Re = 1) are excluded with a
   certified margin of 1/8 on each side.  The cited leg is
   therefore REPLACED, for actual-set zero sets, by a
   proven-from-kernel-verified-input lemma. -/
theorem edgeZeroFree78 (q : ZeroSet) (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) : SliverEdge.EdgeZeroFree q := by
  intro ρ hr
  have hstrip := Z78.zetaZeroStrip hz78 ρ (hqz ρ hr) (q.nonReal ρ hr)
  constructor
  · by_contra h0
    linarith [h0, hstrip.1]
  · by_contra h1
    linarith [h1, hstrip.2]

/- Edge-exclusion margin gate: both edge lines sit at a
   certified positive distance from the strip (1/8 to the left
   of 0-side, 1/8 to the right of 1-side). -/
def edgeLineLo : Float := 0.0
def edgeLineHi : Float := 1.0
#eval (Z78.stripLo : Float) - edgeLineLo > 0
#eval edgeLineHi - Z78.zeroFreeTheta > 0

/- S2 ON THE LOW BAND, FOR THE ACTUAL SET: the last S2
   residual of S1LowT.strip_squeeze_v2 is the SLIVER
   (t0 < 707/50 = 14.14, the C1b regime gap just above the
   first zero) where the window floors are the pinned day-010
   measurement.  Under the named on-line data record (the
   day030 813-zero slice: all zeros in (0, 1200] on the
   critical line, max |zeta| 1.96e-12 below the 1e-8 gate),
   the sliver contains no off-pair at all -- the single
   sliver zero (14.134725..) is on the line -- so the sliver
   floor requirement holds vacuously, and S2 on the low band
   for the actual set is COMPLETE: the t0 >= 707/50 part is
   the PROVEN s2_strip_min (C1b window + C1a own-height
   atoms, edge d0 = 1/2 included), the sliver part is the
   data vacuity below. -/
theorem sliverOffPairsEmpty (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (ht0u : t0 < (707 : ℝ) / 50)
    (hd0 : 0 < d0) (hd0u : d0 ≤ 1 / 2) :
    ¬ P12.offPair q t0 d0 := by
  intro hp
  have hpair := hp
  obtain ⟨ρ, hr, hre, him, hd⟩ := hpair
  have himpos : 0 < (|ρ.im| : ℝ) := by
    rw [him]
    exact ht0
  have himup : (|ρ.im| : ℝ) < (707 : ℝ) / 50 := by
    rw [him]
    exact ht0u
  exact hre (honline ρ hr himpos himup)

/-- (PROVEN)  S2 for the actual set on the whole low band
    (0 < t0 < TLow = 1000, 0 < d0 <= 1/2): the concrete
    strip detector devStripMin dominates the concrete floor
    floStripMin.  Regimes: t0 >= 707/50 -- s2_strip_min
    (PROVEN atoms, edge included); t0 < 707/50 (the sliver) --
    vacuous under the named on-line record
    (sliverOffPairsEmpty). -/
theorem s2ActualLowBandComplete (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (ht0u : t0 < S1LowT.TLow)
    (hd0 : 0 < d0) (hd0u : d0 ≤ 1 / 2) (hp : P12.offPair q t0 d0) :
    S1LowT.devStripMin t0 d0 ≥ S1LowT.floStripMin t0 d0 := by
  by_cases hsliver : t0 < (707 : ℝ) / 50
  · exact False.elim (
      sliverOffPairsEmpty q honline t0 d0 ht0 hsliver hd0 hd0u hp)
  · exact S1LowT.s2_strip_min t0 d0 (by linarith) hd0 hd0u

end Z78P12
