# E1Clause.lean  (850 lines)
WHAT:  E1 clause: the above-G data clauses (two-term V3, three-term V3C
         of 0154).
HOW:   V3: M_defect = -25256007 ln t + 523513775 (B = 7000, 21-row pin)
         on (G, 1000 G]. V3C (0154): M_defect3 = A3 ln t + B3 + C3 t^2
         on (G, 9e18]: A3 = -25254354, B3 = 523472285, C3 = -(ln(U/(2
         pi)) + 1)/(2 pi U) in CLOSED FORM at the in-tree truncation U =
         U_TOP = 1e30 (defect_C3absT3: |C3| T3 <= 2439/10^12);
         mdefect3_bounded: |M_defect3 t| <= 2.3e26; e1V3C_implies_abs +
         if_E1V3C_and_walk (same Qside contract).
USES:  terminal (data clauses): two coexisting named holes above G -
         E1ClauseV3 q 7000 on (G, 1000 G], E1ClauseV3C q 10000 on (G,
         9e18] (33-row s9+s16+s17 face, max residual 7986.8 -> 25%
         margin); compose with the walk into RH.
GOTCHA: constants are DATA-SUPPORTED, not proven; C3's closed form is a
          model-level identity (I_far truncated at U_TOP), not a zeta
          theorem; re-gate only on new data.
