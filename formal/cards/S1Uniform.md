# S1Uniform.lean  (269 lines)
WHAT:  The S1 UNIFORM statement + walk composition (v3): the formal
         artifact closing P12.S1's 'uniform height = open' side and
         composing the whole chain into RH.
HOW:   (A) e1BelowGWholeFromSample: below G the M_wp face is finite C^1
         (it sums FAR zeros only) -> the two-sided sample->uniform
         bridge (S1Sample.sampleToUniform) on the (G0, GH] face domain,
         M_wp itself, NO defect subtraction; (B) s1UniformFace (shape) +
         s1UniformStatement (proven): the full program-domain face on
         (G0, T_MEAS] = two-sided below G + two-sided dead zone (GH,
         G_LAST] (the s10 measured plunge, max 85772092.455109) + ONE-
         SIDED upper (the E1 threat direction) above G (the face -> -oo
         at super-G zeros), proven by Part A + the hDead datum +
         S1Cusp.e1CuspWholeFromRows; (C) s1UniformAndWalk: the S1
         uniform premises (which carry the uniform statement - certified
         as hunif in the proof body) + the named data clause E1ClauseV3
         q 7000 + Qside + the four walk legs hs1-hs4 (the Qside
         contract) on P12.offPair -> RH q, pure composition through
         E1C.if_E1V3_and_walk.
USES:  terminal: the S1 formal artifact (uniform statement + walk);
         composes with the E1 v3 data clause and the P12 legs.
GOTCHA: Both bridge bounds are FORMAL BUT VACUOUS at measured constants:
          9.367e11 x 7000 above (bridgeAddData), 3.947e7 x 2 below
          (belowGUniformVacuous) - the operative between-row control is
          the cusp face robustness + the P12 squeeze leg; E1ClauseV3 q
          7000 stays the named data hole.
