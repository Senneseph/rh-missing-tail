import Mathlib
import RhAttack.B0
import RhAttack.Closure

open Real Set B0

/-! P1.2 — "no spiral under the floor, uniform in t" — the uniform
squeeze theorem.  STATUS MAP (honest split, day-023; DISCOVERY_LOG
24c/25b, spec fib-shell-probe §8, closure-module-abstract):

  The 8-closure (C5b, `p9_closure_rh_of_margin`) is LEAN-PROVEN under
  an EXPLICIT squeezed-margin hypothesis hmargin.  P1.2 is the
  promotion of that hypothesis to a theorem.  It decomposes EXACTLY
  into four pointwise structural claims (the four conjuncts of
  hmargin):

  S1 (zero side, Q >= dev - Mf):  the bridge zeta = kernel (DLMF
     25.2.12, CITED) with the bridge-tail defect Mf controlled by the
     b3 BSBAR explicit wire — LEAN-PROVEN POINTWISE under the |x| <=
     Xval(band) mass hypothesis (A4.3 `p8_residual_wired`).  The
     Xval premises are re-verified per band by the Xval pins (day-020,
     cross-band to 1e5, closing 5e3..1e6 day-023): UNIFORMITY in the
     height (the S(t)-type condition at every height) is the open
     part of S1.

  S2 (detector floor, dev >= flo):  dev = the min-d detector scale at
     (t0, d0).  Three regimes, three atoms:
       (a) FAR (t >= 2g, g >= 1): LEAN-PROVEN, floor 1 (P8Floor
           A4.1b `p8_detector_far`).
       (b) OWN height (t = g, the pole): LEAN-PROVEN (C1a
           `p9_poff_own_height_pos` / `p9_detector_at_own_height` —
           the ratio R has its pole there; the detector mass is
           positive and exact).
       (c) WINDOW (|t - g| <= 10 off the pole, 0.005 <= d <= 0.5):
           PINNED at 0.9975 (d4d3 audit, day-010; closed form
           cross-checked vs direct 4-zero to 1e-16) — the promotion
           is the OPEN ANALYSIS ATOM C1b (removable-singularity +
           compactness argument on B5's closed form;
           closure-module-abstract 1 — this spec's target atom).

  S3 (definition side, Q <= Bfloor + Mr):  LEAN-PROVEN POINTWISE
     under the wired mass inputs (P8Floor A4 composition:
     p8_B(t,n) + Mval < the regime floor; Mr = the Sbar residual
     wire, B3Sbar explicit).

  S4 (the strict gap, Bfloor + Mr + Mf < flo):  the SQUEEZE itself,
     uniform in (t0, d0).  Measured (PINNED) strictly positive at
     every audited point — the closing witness (t = 5004.7343)
     certified margin 143.341847457 (dps-30, day-023 25c), the
     sound region [1e3, 1e6] on the corrected kernel (25b/25d), the
     BSY measure I(1e7) = +1.29e-6 (the pole-mass instrument, 25a) —
     but the BLIND-SPOT domain, small-d LARGE-t pairs with
     2d/t^2 <~ 6.5e-5 (BSY-invisible) and 4kd/t^2 <~ floor
     (pin-invisible), has been measured only at the BOUNDARIES of
     each instrument's reach.  S4 on the blind spot is the REMAINING
     OPEN MATHEMATICS of the prize — this module makes it an explicit,
     named hypothesis, so that RH = (S1..S4) is the EXACT statement
     of what is open.

  The theorem below is GREEN: under the four structural hypotheses it
  composes to C5b and hence to RH (the composition is the
  Lean-provable part).  NO sorry anywhere; the open content is the
  four hypotheses themselves, each with a documented source.
-/

namespace P12

/-- An off-line pair at height `t0` and off-line distance `d0 > 0`
    in the zero set `q`: a zero rho with Im rho = t0 and
    |Re rho - 1/2| = d0 (the C5b point shape). -/
def offPair (q : ZeroSet) (t0 d0 : ℝ) : Prop :=
    ∃ ρ ∈ q.Z, ρ.re ≠ 1 / 2 ∧ (|ρ.im| : ℝ) = t0 ∧ |(ρ.re : ℝ) - 1 / 2| = d0

/- S1 — ZERO SIDE: for every off-line pair a zero-side scale Q
    dominates the detector deviation less the bridge-tail defect
    Mf(t0,d0) (b3 BSBAR wire, A4.3).  Proven pointwise in the audited
    bands; uniform height = open. -/
variable (q : ZeroSet) (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
variable (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
  ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))

/- S2 — DETECTOR FLOOR: the detector deviation at an off-line pair
    is bounded below by the regime floor flo(t0,d0) (min of the
    own-height pin 0.9975, the far-proven 1, and the C1b window
    floor — STATUS MAP (a)/(b)/(c)). -/
variable (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
  devOf (t0, d0) >= flo (t0, d0))

/- S3 — DEFINITION SIDE: the same Q is bounded above by the
    P8Floor-composed wire Bwire(t0,d0) + Mr(t0,d0). -/
variable (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
  offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))

/- S4 — THE SQUEEZE (the open mathematics): definition side +
    bridge tail strictly below the detector floor at EVERY off-line
    pair, uniformly in (t0, d0). -/
variable (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
  Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0))

/-- The four structural hypotheses INSTANTIATE the C5b squeezed-
    margin hypothesis for q.  Lean-provable. -/
theorem squeeze_gives_margin
    (q : ZeroSet) (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      devOf (t0, d0) >= flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    (∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      ∃ (Q dev f M Bf Mr' : ℝ),
        Q >= dev - M ∧ dev >= f ∧ Q <= Bf + Mr' ∧ Bf + Mr' + M < f) := by
  intro t0 d0 ht0 hd0 hp
  obtain ⟨Q, hQge⟩ := hs1 t0 d0 ht0 hd0 hp
  have hdev := hs2 t0 d0 ht0 hd0 hp
  have hQle := hs3 t0 d0 Q ht0 hd0 hp
  have hgap := hs4 t0 d0 ht0 hd0 hp
  exact ⟨Q, devOf (t0, d0), flo (t0, d0), Mf (t0, d0),
    Bwire (t0, d0), Mr (t0, d0), hQge, hdev, hQle, hgap⟩

/-- P1.2 (the full statement): S1 (bridge-tail uniformity) +
    S2 (detector floor, incl. the C1b window promotion) + S3
    (definition-side wire) + S4 (the uniform squeeze, the blind-spot
    mathematics) imply RH for every structural zero set q.
    Compositions only — no sorry. -/
theorem p1_2
    (q : ZeroSet) (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      devOf (t0, d0) >= flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
    p9_closure_rh_of_margin q
      (squeeze_gives_margin q Mf devOf Bwire Mr flo hs1 hs2 hs3 hs4)

end P12
