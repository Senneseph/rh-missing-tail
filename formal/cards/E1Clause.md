# E1Clause.lean  (870 lines)
WHAT:  E1 clause: the above-G data clauses (two-term V3, three-term V3C
         of 0154).
HOW:   V3: M_defect = -25256007 ln t + 523513775 (B = 7000, 21-row pin)
         on (G, 1000 G]. V3C (0154, window extended to 9e20 by 0165 9e21
         by 0168, 9e23 by 0176): M_defect3 = A3 ln t + B3 + C3 t^2 on
         (G, 9e23]: A3 = -25254354, B3 = 523472285, C3 = -(ln(U/(2 pi))
         + 1)/(2 pi U) in CLOSED FORM at the in-tree truncation U =
         U_TOP = 1e30 (defect_C3absT3: |C3| T3 <= 2439/10^7);
         mdefect3_bounded: |M_defect3 t| <= 2.3e31; e1V3C_implies_abs +
         if_E1V3C_and_walk (same Qside contract).
USES:  terminal (data clauses): two coexisting named holes above G -
         E1ClauseV3 q 7000 on (G, 1000 G], E1ClauseV3C q 100000000 on
         (G, 9e23] (40-row face: the 33 s9+s16+s17 rows through 9e18 +
         the 7 s34 far rows at 3e19/3e20/9e20/3e21/9e21/3e23/9e23 same-N
         bare-zeta crosses (d: 3.28e-6 .. 1.25e-6), max residual
         6.333622e7 at 9e23 -> 37% margin;
         0164/0165/0167/0168/0174/0176); compose with the walk into RH.
GOTCHA: constants are DATA-SUPPORTED, not proven; C3's closed form is a
          model-level identity (I_far truncated at U_TOP), not a zeta
          theorem; re-gate only on new data.
