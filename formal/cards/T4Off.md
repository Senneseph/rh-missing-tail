# T4Off.lean  (655 lines)
WHAT:  THE OFF-LINE LIFT OF THE T4 TAIL WALL (the G-hs3 attack,
         discovery 0116).
HOW:   p4_op2c_bound_gen / p4_f2_tail_bound_gen / p4_T4_bound_gen:  the
         T4 wall of P4Limit (the B-wire source, on the critical line)
         LIFTED OFF THE LINE - every statement holds for -1 < s.re (BOTH
         sides of the line) with exact off-line powers n^{-(s.re)},
         n^{-(s.re+1)}, n^{-(s.re+2)}/(s.re+2).  The wall's proof
         structure (per-period IBP with the B3 primitive, |B3poly| <=
         sqrt(3)/36, the FTC reassembly, the M->inf bounded-limit
         passage) uses the critical-line hypothesis in exactly three
         places (the two endpoint power norms, the tail exponent step)
         and all three lift uniformly.  Sharpness at the line:
         t4genTerm12_at_line / t4genTerm3_at_line show the gen theorems
         specialize EXACTLY to the on-line T4 statement (sqrt(3)/540
         constant recovered).  THE REMAINING G-hs3 CONTENT (named in the
         file docstring):  G-hs3-i (the EM scale at an off-pair zero via
         the lifted wall) - CLOSED HERE;  G-hs3-ii (the P6 finite-kernel
         gap / Mr wire LIFTED OFF THE LINE - the g-product terms carry
         g^{-sigma} factors the on-line wire never evaluates) - OPEN;
         G-hs3-iii (the margin composition: off-line scale + gap <
         floStripMin on the strip band above the frontier) - OPEN (needs
         ii first).
USES:  used by: (the endpoint's hs3 leg - with G-hs3-ii + G-hs3-iii
         closed, hs3 holds in BODY at every off-pair above the frontier
         and drops out of the endpoint premises; RHEnd stripfront
         variants are the consumer shape).
GOTCHA: No RH claim:  bound theorems about a concrete kernel expression,
          exactly the status of the on-line T4 wall.  Lean 4.33.1 +
          mathlib v4.33.1, DOC-FIRST (every lemma name taken from its
          usage in P4Limit).
