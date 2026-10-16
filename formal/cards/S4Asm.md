# S4Asm.lean  (435 lines)
WHAT:  S4 assembly: the squeeze composition.
HOW:   gapW / gapO; s4asm_strip_region_S4 (the PROVEN t^4 covered
         squeeze on 1000 <= t, 1/200 <= d <= 1/2);
         s4asm_residue_S4_covered (the bound-level residue: the named
         open S4 gap); rh_from_structural_hypotheses +
         rh_from_regime_closures (P1.2 with S4 by regime closures, Qside
         contract).
USES:  used by: FloorUnif, Z78P12, RHEnd.
GOTCHA: the residue is NAMED, not sorry: it is the bound-level open gap
          of S4.
