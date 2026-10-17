/- LowExcl — the LOW-BAND OFF-PAIR EXCLUSION at the endpoint
    (the squeeze as a machine-proven impossibility, not a shape).

CONTEXT: the endpoint RHEnd.rh_program78 leaves three residual
data faces below the program strip (t0 < 1000):
  hs1    Qside (t0, d0) >= devProg (t0, d0)      (the S1 zero side)
  hs3    Qside (t0, d0) <= BwireP + MrP          (the S3 def wire)
  hS2low devProg (t0, d0) >= p8_f_near_pin       (the S2 floor pin)
LowWires records that the endpoint R-wires are DEFINITIONALLY 0
below the strip, so the three legs are the squeeze
  0.9975 <= devProg <= Qside <= 0
at any low-band point.  This module closes that shape into the
endpoint statement: at a low-band candidate off-pair, the three
legs (in the endpoint's exact leg form, over the concrete wires
BwireP/MrP/devProg) are JOINTLY INCONSISTENT — hence no zero set
can carry an off-line zero there while the walk-spine legs hold.

The engine is LowWires.lowBandSqueezeShape (LEAN-PROVEN); this
module supplies the endpoint-level wire/def simplifications and
the exclusion corollary.  The data content is exactly the three
legs themselves (hs1 / hs3 / hS2low are named residual faces at
the endpoint - this module does not remove them, it shows their
joint form EXCLUDES low-band off-pairs, so the residual that
must be supported is "the legs hold at every off-pair", which in
the low band is a statement about a set proven empty).  The
d0 > 1/2 half of the low band is vacuous from [Z78] alone
(Z78P12.offPairFarEmpty) and is carried in the endpoint body,
not here.

HONESTY LABELS: LEAN-PROVEN (definitional wire shape, squeeze
composition, exclusion corollary).  NO RH claim: this module
proves what the endpoint's named legs imply IN THE LOW BAND; it
makes no claim about the far region or about RH. -/
import Mathlib
import RhAttack.S4Asm
import RhAttack.S1LowT
import RhAttack.P12Uniform
import RhAttack.Z78P12
import RhAttack.RHEnd
import RhAttack.LowWires

open Real

noncomputable section

namespace LowExcl

/-! ## Part A - the endpoint wire below the strip. -/

/-- The endpoint's S3 wire sum (BwireP + MrP) is 0 below the
    program strip (S4Asm's definitional-zero wire shape, pulled
    through the endpoint's Z78P12 aliases). -/
theorem endpointWireLow (t0 d0 : ℝ) (ht0u : t0 < (1000 : ℝ)) :
    Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) = 0 := by
  have hb : S4A.BwireR t0 d0 = 0 := LowWires.bwireR_low_zero t0 d0 ht0u
  have hm : S4A.MrR t0 d0 = 0 := LowWires.mrr_low_zero t0 d0 ht0u
  dsimp only [Z78P12.BwireP, Z78P12.MrP]
  rw [hb, hm]
  norm_num

/-- The endpoint's full S4 wire sum (including MfP = 0) is 0
    below the strip. -/
theorem endpointWireLowFull (t0 d0 : ℝ) (ht0u : t0 < (1000 : ℝ)) :
    Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) + Z78P12.MfP (t0, d0)
      = 0 := by
  rw [show Z78P12.MfP (t0, d0) = 0 by rfl, add_zero]
  exact endpointWireLow t0 d0 ht0u

/-! ## Part B - the three-leg squeeze in endpoint leg form. -/

/-- THE LOW-BAND THREE-LEG SQUEEZE (endpoint form): at a low-band
    point (0 < t0 < 1000) the endpoint's three low-band legs —
    the S1 zero side (Qside >= devProg), the S2 floor pin
    (devProg >= the near pin 0.9975), and the S3 definition-side
    wire (Qside <= BwireP + MrP = 0) — are jointly
    contradictory:  0.9975 <= devProg <= Qside <= 0.  Engine:
    LowWires.lowBandSqueezeShape. -/
theorem lowBandLegsFalse (t0 d0 : ℝ) (Qside : ℝ × ℝ → ℝ)
    (ht0 : 0 < t0) (ht0u : t0 < (1000 : ℝ)) (hd0 : 0 < d0) (hd0u : d0 ≤ 1 / 2)
    (hs1 : Qside (t0, d0) ≥ RHEnd.devProg (t0, d0))
    (hS2low : RHEnd.devProg (t0, d0) ≥ p8_f_near_pin)
    (hs3 : Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0)) :
    False := by
  have hwire : Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) = 0 :=
    endpointWireLow t0 d0 ht0u
  have hh3 : Qside (t0, d0) ≤ (0 : ℝ) := by simpa [hwire] using hs3
  have hdev : RHEnd.devProg (t0, d0) = S1LowT.devStripMin t0 d0 := rfl
  exact LowWires.lowBandSqueezeShape t0 d0 Qside
    (by simpa only [hdev] using hs1)
    (by simpa only [hdev] using hS2low)
    hh3

/-! ## Part C - the exclusion corollary. -/

/-- THE LOW-BAND OFF-PAIR EXCLUSION: no zero set q carries an
    off-pair (an off-line zero) at a low-band height (0 < t0 <
    1000, 0 < d0 <= 1/2) while the endpoint's walk-spine legs
    (hs1 the zero side, hS2low the floor pin, hs3 the def-side
    wire) hold at that point.  This is the squeeze
    (discovery 0089) stated as an exclusion about the zero set,
    in the endpoint's exact leg form over the concrete wires. -/
theorem offPairExcludedLowBand (q : ZeroSet) (t0 d0 : ℝ)
    (Qside : ℝ × ℝ → ℝ)
    (ht0 : 0 < t0) (ht0u : t0 < (1000 : ℝ)) (hd0 : 0 < d0) (hd0u : d0 ≤ 1 / 2)
    (hs1 : Qside (t0, d0) ≥ RHEnd.devProg (t0, d0))
    (hS2low : RHEnd.devProg (t0, d0) ≥ p8_f_near_pin)
    (hs3 : Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0)) :
    ¬ P12.offPair q t0 d0 := by
  intro hp
  exact lowBandLegsFalse t0 d0 Qside ht0 ht0u hd0 hd0u hs1 hS2low hs3

end LowExcl
