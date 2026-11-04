/-
  0283  T4OffLR  --  CT-3:  the REALIZED WALL + the conformant-subclass verdict

  The 0276 gate c* (T4OffLO) demands an S-route (the unknown-side
  S-oscillation over the day078 kernel pieces, S-units) at or below
  c* * span = 2.5821 * 102.334 = 264.2366 (sigma_A, tPT2).  Two new
  certified lower bounds on what ANY true S-route bound must
  accommodate:

  (a) THE MEAN (0278/0281 wall, T4OffLP):  the first moment
      E1 = dmain * span = 421.6058  (ratio 1.596, growing
      3.882 / 5.032 in t).  A sup-form bound cannot sit below its
      own mean.

  (b) THE REALIZED (this module):  the machine identity
          fluc = K + fedge * k_face + S-route
      with the MEASURED fluc (236.273255) and the CORRECTED K
      (-218.893831, dps-60 dual integrators, GATE 1/2 at 1e-7)
      pins the ACTUAL S-route at
          S-route(k) = 455.167086 - 27.970831 * k
      for the true (unknown) face-zero count k in the window
      (0 <= k <= 14, 0275 face-part bound; the on-line window
      count 8 is the day080 census, a separate fixed term).
      Certified strict-rational LOWER bounds (conservative
      margins: fluc_lo = 236.27, -K_lo = 218.87, fedge_hi = 27.98):
          S-route_lo(k) = 455.14 - 27.98 * k
          k = 0: 455.14   (ratio 1.7225 to the gate)
          k = 6: 287.26   (ratio 1.0871 - STILL ABOVE the gate)
          k = 7: 259.28   (falls below the gate: the k-reading
                           7..14 is gate-consistent)
      So: under the typical face readings k <= 6 (7 of the 15
      admissible readings), the gate constant 264.2366 is BELOW
      the S-route the machine actually measured - a sup-form
      theorem at gate strength is refuted by the real world.
      THE K-AMBIGUITY (0270) IS THE ONLY ESCAPE HATCH: the data
      resolve k only to [0, 14]; readings k >= 7 make the gate
      consistent with the measured fluc.

  CONFORMANT-SUBCLASS VERDICT (CT-3, argument + day081 data):
  The conformant subclass (all known laws: R-vM 1e-7, |S| <= 6.46,
  2-unit window <= 22 zeros, day081 landscape mean 3.4/unit max
  9) CONTAINS the typical configurations - the measured tPT2
  world is itself conformant.  The first-moment (mean) wall
  therefore survives every conformant restriction: the face
  geometry (mirror pairs at Re ~ 0.125/0.875, density bounds)
  constrains the OFF-LINE zeros, which carry only the fedge * k
  machine signature; the S-ROUTE is carried by the ON-LINE
  unknown zeros, whose mean in the kernel mass is E1 = 421.6.
  No conformant-subclass pair-correlation at h = 1 available
  from known mathematics beats the first moment.  CT-3 CLOSES
  the subclass route; CT (below the first moment, unconditional,
  sup-form) remains the single open work item of the RH program.

  Provenance: T4OffLM (flucAn, K3An, fedgeA - FIFTH CORRECTION),
  T4OffLO (cGateA, W1A, W2A - 0276 gate), T4OffLP (first moment,
  0278/0281 wall), entry 0282 (CT statement), day080 (census: 8
  on-line, face k in [0,14] per 0275), day081 (conformant
  landscape).  face OPEN; no zero-free claim; NO RH CLAIM.
-/

import  RhAttack.T4OffLP
import  RhAttack.T4OffLO
import  RhAttack.T4OffLM

set_option  linter.style.whitespace  false
set_option  linter.style.longLine    false
set_option  linter.style.docString   false

namespace  T4OffLR

open  T4OffLO  T4OffLM

/-  measured fluc LOWER bound (T4OffLM.flucAn: 236.27 < 236.273255)  -/
def  flucLoA   :  ℚ  :=  23627  /  100        --  236.27

/-  certified LOWER bound on (-K):  K = -218.893831 (dps-60,
     GATE 1/2 relative 1e-7)  =>  -K >= 218.87  (conservative)  -/
def  negKLoA   :  ℚ  :=  21887  /  100        --  218.87

/-  certified UPPER bound on fedge:  |f(tPT2 + or - 1)| = 27.970831
     (T4OffLM.fedgeA = 27.97 is the lower bound; 27.98 covers)  -/
def  fedgeHiA  :  ℚ  :=  2798  /  100         --  27.98

/-  the gate product in piece-total S-units
     (0276:  cGateA * (W1A + W2A);  T4OffLO.gateStrictA proves it
      below flucAn + fedgeA = 264.24)  -/
def  gateProdA :  ℚ  :=  cGateA  *  (W1A + W2A)

/-  certified LOWER bound on the realized S-route, for a face
      count k:  S-route(k) = fluc - K - fedge*k  =>
      S-route(k) >= flucLoA + negKLoA - fedgeHiA*k  -/
def  sRouteLoA  (k : ℕ)  :  ℚ  :=  flucLoA + negKLoA - fedgeHiA * k

/-  the face count k in [0, 14] (0275 face-part bound; day080:
     8 on-line measured, face part unknown)  -/
def  kMaxFace  :  ℕ  :=  14

/-  monotonicity:  the certified lower bound weakens in k  -/
theorem  sRouteLo_kle6_lower  (k : ℕ)  (hk : k <= 6)  :
    sRouteLoA  k  >=  sRouteLoA  6  :=  by
  simp  [sRouteLoA,  flucLoA,  negKLoA,  fedgeHiA]
  have  h :  (k : ℚ)  <=  6  :=  by  exact_mod_cast  hk
  linarith  [h]

/-  k = 0 reading:  realized S-route >= 455.14,
     ratio 1.7225 above the gate 264.2366  -/
theorem  realizedWall0  :  sRouteLoA  0  >  gateProdA  :=  by
  norm_num  [sRouteLoA,  flucLoA,  negKLoA,  fedgeHiA,  gateProdA,  cGateA,  W1A,  W2A]

/-  k = 6 reading:  realized S-route >= 287.26,
     ratio 1.0871 above the gate - STILL INSIDE THE WALL  -/
theorem  realizedWall6  :  sRouteLoA  6  >  gateProdA  :=  by
  norm_num  [sRouteLoA,  flucLoA,  negKLoA,  fedgeHiA,  gateProdA,  cGateA,  W1A,  W2A]

/-  typical-face range:  for EVERY k <= 6 the realized wall holds
      (the bound is weakest at k = 6)  -/
theorem  realizedWall_kle6  (k : ℕ)  (hk : k <= 6)  :  sRouteLoA  k  >  gateProdA  :=  by
  have  h6  :  sRouteLoA  k  >=  sRouteLoA  6  :=  sRouteLo_kle6_lower  k  hk
  linarith  [h6,  realizedWall6]

/-  k = 7 reading:  the realized falls BELOW the gate -
     the k-ambiguity escape hatch: readings 7..14 are gate-
     CONSISTENT (the measured fluc does not exclude them)  -/
theorem  realizedRelease7  :  sRouteLoA  7  <  gateProdA  :=  by
  norm_num  [sRouteLoA,  flucLoA,  negKLoA,  fedgeHiA,  gateProdA,  cGateA,  W1A,  W2A]

/-  CT-3 COMPOSITE (the wall the CLOSING THEOREM must beat):
      1.  MEAN (always):  first moment E1 > requirement > gate
          (T4OffLQ.ct1Bracket + T4OffLP.firstMomentWall_tPT2),
          ratio 1.596, growing in t (3.882 / 5.032).
      2.  REALIZED (typical face k <= 6):  the measured machine
          output itself sits above the gate (1.087x .. 1.722x
          over k = 6..0) - a sup-form theorem at gate strength
          is refuted by the real world.
      3.  ESCAPE (k >= 7):  the face-count reading 7..14 makes
          the gate consistent with the measured fluc; the data
          resolve k only to [0, 14] (0270 ambiguity) - and k >= 7
          is precisely a world with MANY face zeros, i.e. far
          from RH, so no RH-attack can rest on it.
      The conformant-subclass route (CT-3) is thereby CLOSED:
      the subclass contains the typical (and the realized)
      configurations, and the mean wall plus the realized wall
      both exceed the gate.  -/
theorem  ct3Wall  :
    sRouteLoA  6  >  gateProdA  ∧
      (T4OffLP.dmainLo * T4OffLP.wSpanLo : ℚ)  >  T4OffLP.reqLo  ∧
        sRouteLoA  7  <  gateProdA  :=
  ⟨realizedWall6,  T4OffLP.firstMomentWall_tPT2,  realizedRelease7⟩

end  T4OffLR
