/- S1Face — the hs1 face of the endpoint: the S1 (zero-side) leg
    at an ACTUAL off-line zero, and its named form at the audited
    day-020 band (the spine lettering of the walk).

ROLE: in RHEnd.rh_program78 the residual leg hs1 reads
    Qside (t0, d0) >= devOf (t0, d0) - Mf (t0, d0)
with Qside the concrete zero-side scale (discovery 0088).  This
module makes the leg's content explicit in two steps:

  (1) hs1AtZero — at an ACTUAL zero (zeta(s) = 0) the A0 fill
      |zeta - K| collapses to |K|, so the S1Ge pointwise atom
      (discovery 0093) reads EXACTLY the hs1 leg:
          |K| >= devW - Mval
      with the zero-side scale Q := |K| (the kernel magnitude at
      the zero), devW the deviation face (the measured kernel
      change at the pair's own height, read through the A2c cited
      bridge), and Mval the A4.3-wired mass bound (under the mass
      premise |x| <= Xval(band)).  The leg is therefore not a bare
      premise: it is the theorem S1Ge with the pins (devW, Mval)
      as its only data input.

  (2) hs1FaceAtAudit — the named face of hs1 at the audited
      day-020 band (QSide pins, discovery 0090/0091): the
      zero-side claim at the pinned deviation face, in its C2 form
      X >= devWorst * (1 - mPin) (mPin = 1/marginWorst, the C4
      margin pin, absorbs the A4.3 mass), and the measured resid
      pinned at X <= devWorst / marginWorst, are JOINTLY
      INCOMPATIBLE — machine-verified by exact-rational arithmetic
      (QSide.section8_close_at_audit, discovery 0091).  The face
      states, in the spine's lettering, that the zero-side leg and
      the data face cannot BOTH hold at the audited band — which
      is exactly the squeeze the endpoint consumes.

HONESTY: LEAN-PROVEN (hs1AtZero, a composition over S1Ge/p8 atoms;
hs1FaceAtAudit, the named alias of the exact-rational close).
PINNED (the day-020 constants via QSide).  NO RH claim: the face
is the NAMED residual made explicit - the data pins (devW, Mval,
uniform in the height) are the checkable content the data program
supplies; uniformity in the height is the open measured track
(25x: the P1.1e margin regime), not claimed here. -/
import Mathlib
import RhAttack.P4Limit
import RhAttack.S1Ge
import RhAttack.QSide

open Real

noncomputable section

namespace S1Face

/-- (1) THE HS1 LEG AT AN ACTUAL ZERO: with zeta(s) = 0 the A0 fill
    |zeta(s) - K| is |K|, and the S1Ge pointwise atom (its premises:
    the finite-kernel gap |K - (P_n - I)| <= Mval under the A4.3 mass
    wire, and the deviation face devW <= |W_n| at the pair's own
    height) reads exactly the walk's hs1 leg with the zero-side
    scale Q := |K|:  |K| >= devW - Mval.  No bare witness premise -
    the leg is the theorem with its data pins. -/
theorem hs1AtZero (s : ℂ) (n : ℕ) (K : ℂ) (Mval devW : ℝ)
    (hM : ‖K - (p4_P n s - p4_I n s)‖ ≤ Mval)
    (hW : devW ≤ ‖p4_Wn s n‖)
    (hzero : riemannZeta s = 0) :
    ‖K‖ ≥ devW - Mval := by
  have hf := S1Ge.s1_ge_side s n K Mval devW hM hW
  simpa [hzero, norm_neg] using hf

/-- (2) THE NAMED HS1 FACE AT THE AUDITED DAY-020 BAND (the spine
    lettering of RHEnd's residual leg hs1, explicit): in the
    walk's lettering the leg demands a zero-side scale X with
    X >= devOf - Mf; at the audited band with devOf := devWorst
    (the pinned deviation face) and the A4.3 mass absorbed into
    the C2 form, that is X >= devWorst * (1 - mPin); the data
    face (the measured resid under the A4.3 wiring) pins
    X <= devWorst / marginWorst at the worst point.  No real X
    serves both (exact-rational, QSide Part E). -/
theorem hs1FaceAtAudit :
    ¬ ∃ (X : ℝ), X ≥ QSide.devWorst * (1 - QSide.mPin) ∧
      X ≤ QSide.devWorst / QSide.marginWorst :=
  QSide.section8_close_at_audit

end S1Face
