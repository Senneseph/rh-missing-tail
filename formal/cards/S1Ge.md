# S1Ge.lean  (73 lines)
WHAT:  THE S1 >= SIDE ATOM: the walk's zero-side leg at its pointwise
         core.
HOW:   s1_ge_side: with the finite-kernel gap |K - (P_n - I)| <= Mval
         (the A4.3-wired mass, P8Floor p8_residual_wired under |x| <=
         Xval) and the deviation face devW <= |W_n| (the measured kernel
         change at the pair's own height via the A2c cited bridge), the
         zero-side fill |zeta(s) - K| (the A0 same object |def - zero|,
         P8Floor p8_same_object) dominates devW - Mval - the hs1 leg
         (Qside >= devOf - Mf) at its pointwise core.  Proof: reverse
         triangle (Wn = (zeta - K) + r, norm_add_le) + linarith over the
         four linear facts; the A2c bridge |W_n| = |em_expr| is CITED
         (DLMF 25.2.8 / Apostol 12.21) - the dev face reads |W_n|
         through it.  Per the P1.2 spec S1 row: LEAN-PROVEN POINTWISE
         under the mass premise - the OPEN part the spec names
         (uniformity of the premise in the height) is the measured track
         (P1.1e margin regime), NOT claimed.  No RH claim.
USES:  used by: (face modules pending - the low-band/audit-band hs1 data
         faces instantiate the atom upstream).
GOTCHA: the hs1 leg of the endpoint remains a NAMED residual supported
          face-by-face by the data program - this module is the
          pointwise atom only.
