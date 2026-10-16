# P12Uniform.lean  (157 lines)
WHAT:  P1.2: the closure decomposition (the Qside contract).
HOW:   closure = S1 zero side + S2 detector floor + S3 definition side +
         S4 squeeze; Qside (R x R -> R) is THE concrete zero-side scale
         (the measured |zeta| fill under A4.3): S1 = Qside >= devOf -
         Mf, S3 = Qside <= Bwire + Mr - ONE scale in both legs;
         squeeze_gives_margin + p1_2 (offPair vocabulary, pointwise
         atoms, covered-region composition).
USES:  used by: E1Clause, S1LowT, S4Asm, Z78P12, Z78Strip, ZetaZeroSet.
GOTCHA: 2026-10-16 re-typing: the old exists-Q (S1) / for-all-Q (S3)
          form decoupled the legs and made S3 unsatisfiable for ANY
          finite wire (a dead form) - the whole walk spine was retyped;
          discovery 0088.
