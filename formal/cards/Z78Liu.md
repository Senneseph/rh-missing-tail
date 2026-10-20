# Z78Liu.lean  (262 lines)
WHAT:  The [Z78L] named external input: the Liu successor of the 7/8
         quasi-RH (arXiv 2610.12234).
HOW:   externalZeroFree78Liu (named prop WITH provenance: Liu, 'Slightly
         improved zero-free half-planes for the quasi-Riemann
         hypothesis', human Lean formalization with recorded strict
         replay PASS - 312 declarations, axioms exactly
         propext/Classical.choice/Quot.sound; the certified rational
         upper boundary liuBUpper = 874957019420098947/10^18 < 7/8 in
         place of the algebraic B_inf = 0.874957019420098946..., pole
         guard carried from her statement, inert on the pinned Mathlib
         via riemannZeta_one_ne_zero); extLiu_implies_ext78 ([Z78L]
         STRICTLY STRENGTHENS [Z78], norm_num certified);
         zetaZeroStripLiu (1 - liuBUpper <= Re <= liuBUpper);
         offPairD0leLiu (d0 <= liuD0max = liuBUpper - 1/2 =
         374957019420098947/10^18 < 3/8, SHARP).
USES:  used by: RHEnd (part B13).
GOTCHA: same input class as Z78Strip - a kernel-verified external
          theorem as a named prop, NOT a compiled dependency; its
          foundation inherits the B6 OAI 003 input class, its parameter-
          improvement delta is human-written Lean. A NO-GO on [Z78L]
          reverts the program to the 0129 terminal form (nothing else
          depends on it).
