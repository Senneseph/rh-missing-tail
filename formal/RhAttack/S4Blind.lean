import Mathlib
import RhAttack.P12Uniform
import RhAttack.S4Gap

/-! S4 BLIND-SPOT FACE — the remaining open mathematics, named
    (the P12 header, 25-series).

  S4 (the uniform squeeze, P12Uniform hs4) is measured
  strictly positive at the audited points (the closing witness
  t = 5004.7343 certified margin 143.341847457, dps-30, 25c;
  the sound region [1e3, 1e6] on the corrected kernel, 25b/25d)
  and at the window-regime squeeze-hold boundary t* =
  690349.0568 (25l/25n sweep, scripts/rh/day023_s4_sweep.py) —
  but the BLIND-SPOT domain, the small-d large-t OWN-REGIME
  pairs where the pole-mass instrument (the BSY measure,
  I(1e7) = +1.29e-6, 25a) is invisible (2 d / t^2 <~ 6.5e-5)
  and the pin is invisible (4 k d / t^2 below the floor), has
  been measured only at the BOUNDARIES of each instrument's
  reach.

  THIS MODULE NAMES THAT FACE AND MACHINE-VERIFIES ITS OWN-FLOOR
  FORM: on the blind-spot strip, the squeeze in the CONCRETE
  own-height wiring (flo = the 8-factor kernel mass S4O.mown,
  Bwire = S4G.BwireO) is PROVEN IMPOSSIBLE (S4G.s4c_squeeze_
  impossible, the 25p gap certificate, restated here on the
  blind-spot predicate) — so the residual S4 content on the
  blind spot lives in the WIRING / FLOOR choice off the own
  mass: it is the open mathematics, named, pinned at the
  measured boundary, and NOT proven in the tree.

  Honest split: LEAN-PROVEN — the blindSpot predicate, the
  own-floor impossibility on it, the pin gates.  MEASURED (not
  proven) — the pin constants themselves (25-series on record).
  NO RH claim; no RH content.  Lean 4.33.1 + Mathlib (pinned).
-/

namespace S4Bl
open Real

/-- The BLIND-SPOT domain (P12 header, 25a/25l/25n): the own-
    regime strip (candidate at its own height, 0 < d <= 1/2,
    t >= 1000) at the scale where the pole-mass instrument is
    invisible: 2 d / t^2 < 6.5e-5 (the 25a instrument scale:
    the BSY measure I(1e7) = +1.29e-6).  The 25n pin-
    invisibility (4 k d / t^2 below the floor) is a further
    restriction on the same domain; it is recorded in the
    header and not formalized (the k-count is a data-side
    quantity). -/
def blindSpot (t d : ℝ) : Prop :=
    1000 <= t ∧ 0 < d ∧ d <= 1 / 2 ∧ 2 * d / t ^ 2 < 65 / 1000000

/-- OWN-FLOOR IMPOSSIBILITY ON THE BLIND SPOT: the S4 squeeze
    BwireO + Mr + Mf < mown CANNOT hold at a blind-spot pair
    for any nonnegative Mr, Mf (S4G.s4c_squeeze_impossible on
    the strip part of the predicate).  Consequence (honest
    reading): the blind-spot residual of S4 is NOT in the
    own-floor inequality (that face is closed off HERE, in
    Lean) — it is in the wiring/floor choice off the own
    mass, which is the named open face. -/
theorem squeezeImpossibleOnBlind (t d Mr Mf : ℝ) (hb : blindSpot t d)
    (hMr : 0 <= Mr) (hMf : 0 <= Mf) :
    ¬(S4G.BwireO t + Mr + Mf < S4O.mown t d) := by
  have ht : 1000 <= t := hb.1
  have hd0 : 0 < d := hb.2.1
  have hd : d <= 1 / 2 := hb.2.2.1
  exact S4G.s4c_squeeze_impossible t d ht hd0 hd Mr Mf hMr hMf

/-  MEASURED boundary pins (25-series; the content is the
    measurement, the gates are arithmetic on the record): -/

/-- The window-regime squeeze-hold boundary (25l sweep): the
    window-pair squeeze holds for t <= t* = 690349.0568. -/
def tstarHold : ℝ := 690349.0568

/-- The window-regime deficit at the band edges (25l):
    delta_win(1e3) = -0.953692, delta_win(1e7-) = +5374.37. -/
def deltaWin1e3 : ℝ := -0.953692
def deltaWin1e7 : ℝ := 5374.37

/-- The closing witness and its certified margin (25c, dps-30):
    t = 5004.7343, margin 143.341847457. -/
def closeWitnessT : ℝ := 5004.7343
def closeWitnessMargin : ℝ := 143.341847457

/-- The pole-mass instrument scale (25a): I(1e7) = +1.29e-6. -/
def bsyI1e7 : ℝ := 0.00000129

/-- GATES (arithmetic on the pins; the pins themselves are
    measured data on the record): the band order 1e3 < t* <
    1e7, the negative-to-positive deficit crossing, the closed
    witness inside the sound region [1e3, 1e6], the positive
    certified margin, and the positive instrument scale. -/
theorem pinGates :
    1000 < tstarHold ∧ tstarHold < 10000000 ∧
    deltaWin1e3 < 0 ∧ 0 < deltaWin1e7 ∧
    1000 < closeWitnessT ∧ closeWitnessT < 1000000 ∧
    0 < closeWitnessMargin ∧ 0 < bsyI1e7 := by
  constructor
  · norm_num [tstarHold]
  · constructor
    · norm_num [tstarHold]
    · constructor
      · norm_num [deltaWin1e3]
      · constructor
        · norm_num [deltaWin1e7]
        · constructor
          · norm_num [closeWitnessT]
          · constructor
            · norm_num [closeWitnessT]
            · constructor
              · norm_num [closeWitnessMargin]
              · norm_num [bsyI1e7]

/-- THE NAMED OPEN FACE (declaration, not proof): S4 on the
    blind-spot pairs, in the own-height pin form.  The
    own-floor FORM of this face is machine-closed-off by
    squeezeImpossibleOnBlind — the face as declared here is
    the residual content of S4 at the blind spot in ANY
    wiring flo with flo >= mown (the S2 regime-floor
    direction): it is MEASURED at the boundaries (the pins
    above) and NOT proven in the tree.  This is the remaining
    open mathematics of the prize, now a named object. -/
def s4OpenFace (flo : ℝ × ℝ → ℝ) : Prop :=
    ∀ (t d : ℝ), blindSpot t d →
      S4G.BwireO t + 0 + 0 < flo (t, d) ∧ S4O.mown t d <= flo (t, d)

end S4Bl
