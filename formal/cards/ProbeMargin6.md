# ProbeMargin6.lean  (58 lines)
WHAT:  Probe: the squeeze-wire core, standalone.
HOW:   margin6_unsat: NOT (Q >= dev - Mf AND dev >= flo AND Q <= Bf + Mr
         AND Bf + Mr + Mf < flo) for all real values - the
         p9_point_contradiction arithmetic re-proved with Mathlib ONLY
         (no RhAttack imports), confirming the squeeze core rests on no
         project definition.
USES:  used by: (none - standalone cross-check).
GOTCHA: liveness audit of discovery 0089: the joint unsatisfiability is
          the LIVE engine (the contradiction is joint across four
          checkable legs, at an existing off-pair) - distinct from the
          0088 dead form where it sat inside one leg.
