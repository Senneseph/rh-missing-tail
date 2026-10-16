# S1Cusp.lean  (549 lines)
WHAT:  Cusp-aware between-row bridge ABOVE G (E1 threat direction);
         sibling to S1Sample's t-Lipschitz bridge, which is out of scope
         above G (zero cusps of log|zeta| break the hLip premise).
HOW:   cuspPlunge (positive log cusp dominates a locally bounded-ABOVE
         smooth part; premise is BddAbove - a below-bound does NOT
         control the face from above); vFlankLeft/Right (strict down/up
         flanks from secant Lipschitz only, no derivative);
         cuspUpperBridge: row |f u| <= B, |t-u| <= Dv, row eps from
         every cusp, 0 <= c j <= C => f t <= B + L|t-u| + C n log(1 +
         Dv/eps) - uniform in the plunge (the face truly -> -oo at the
         cusps); e1CuspWholeFromRows glues onto E1C.Mres on (G_LAST,
         T_MEAS].
USES:  terminal (for now): the formal S1 above-G between-row control;
         P12 squeeze remains the operative DATA between-row control.
GOTCHA: Gates are the VACUITY record at measured constants: bridgeAdd =
          6.5570002736e15 = 9.367e11 x B(7000); rowCuspAmp 4.343 < B.
          Flat explicit params (no section/variable - they silently drop
          in this toolchain); pinned APIs: abs_add_le (triangle),
          abs_add' (anti-triangle form |x| <= |y| + |x+y|),
          Real.log_inv, mul_lt_mul_of_pos_left (a*b < a*c order),
          sum_const needs Fintype-pinned sorts, <- sum_sub_distrib.
