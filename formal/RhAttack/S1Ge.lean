/- S1Ge — the S1 zero-side leg of the walk spine, POINTWISE ATOM
    (the >= side of outline section-8 step 1, C2 in the closure
    spec's atom table).

ROLE: the P1.2 walk's S1 leg (hs1: Qside >= devOf - Mf) says the
zero-side scale at the pair dominates the deviation minus the
zero-side error.  POINTWISE, its core is the composition:

  A0   (LEAN-PROVEN, P8Floor p8_same_object):
       W_n(s) - (K - (P_n(s) - I(n,s))) = zeta(s) - K,
       so |def - zero| = |zeta(s) - K| is the A0 same object.
  A1r  (LEAN-PROVEN, reverse triangle, this module):
       |zeta(s) - K| = |W_n - (K - (P_n - I))|
                      >= |W_n| - |K - (P_n - I)|.
  A4.3 (the mass premise - named input, wired in the tree by
       P8Floor p8_residual_wired under |x| <= Xval(band)):
       |K - (P_n - I)| <= Mval,  Mval = the A4.3-wired bound.

  hence  |zeta(s) - K| >= |W_n| - Mval,
  and with the deviation face devW <= |W_n| (the measured kernel
  change, the A2c cited bridge + P4 EM floor at the pair's own
  height - the data face),

      |zeta(s) - K| >= devW - Mval      (the hs1 core).

STATUS vs the P1.2 spec (S1 row): LEAN-PROVEN POINTWISE under the
mass premise |x| <= Xval(band) - exactly as the spec records
("bridge zeta = kernel (DLMF 25.2.12, CITED) + the b3 BSBAR
explicit wire (A4.3 p8_residual_wired)").  The OPEN part the spec
names (uniformity of the premise in the height) is the measured
track (25x/25y: the P1.1e margin regime from ~5.6e7 upward) -
NOT claimed here.

HONESTY LABELS: LEAN-PROVEN (the composition, this module).
CITED (the A2c bridge |W_n| = |em_expr|, where the dev face reads
|W_n| - a data/proven face upstream).  NO RH claim: this is the
pointwise atom; the hs1 leg of the endpoint remains a named
residual supported (face by face) by the data program. -/
import Mathlib
import RhAttack.P4Limit
import RhAttack.P8Floor

open Real

noncomputable section

namespace S1Ge

/-- THE S1 >= SIDE ATOM (the walk's hs1 leg at its pointwise core):
    with the finite-kernel gap bounded by the A4.3-wired mass Mval
    and the deviation face devW below the zero-side kernel
    magnitude |W_n|, the zero-side fill |zeta(s) - K| (the A0 same
    object |def - zero|) dominates devW - Mval.  Pure composition
    over A0 (p8_same_object) + the reverse triangle + subtraction
    monotonicity; no zero, no product, no measurement enters. -/
theorem s1_ge_side (s : ℂ) (n : ℕ) (K : ℂ) (Mval devW : ℝ)
    (hM : ‖K - (p4_P n s - p4_I n s)‖ ≤ Mval)
    (hW : devW ≤ ‖p4_Wn s n‖) :
    ‖riemannZeta s - K‖ ≥ devW - Mval := by
  set r := K - (p4_P n s - p4_I n s) with hr
  have hobj : p4_Wn s n - r = riemannZeta s - K := p8_same_object s n K
  have hadd : p4_Wn s n = (riemannZeta s - K) + r := by
    rw [← hobj]
    ring
  -- reverse triangle: |W_n| <= |zeta - K| + |r|  (W_n = (zeta - K) + r)
  have htri : ‖p4_Wn s n‖ ≤ ‖riemannZeta s - K‖ + ‖r‖ := by
    rw [hadd]
    exact norm_add_le (riemannZeta s - K) r
  -- All four facts are linear in {devW, ‖Wn‖, ‖r‖, Mval, ‖zeta - K‖}:
  --   devW - Mval <= ‖Wn‖ - Mval <= ‖Wn‖ - ‖r‖ <= ‖zeta - K‖.
  linarith [htri, hM, hW]

end S1Ge
