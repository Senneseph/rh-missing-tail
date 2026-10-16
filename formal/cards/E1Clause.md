# E1Clause.lean  (509 lines)
WHAT:  E1 clause v3: the above-G data clause.
HOW:   E1ClauseV3 q B on (G, T_MEAS]: M_defect(t) = -25256007 ln t +
         523513775, B = 7000 data-supported; mdefect_bounded (loose by
         design: norm_num cannot eval Real.exp); if_E1V3_and_walk.
USES:  terminal (data clause): composes with the walk into RH.
GOTCHA: constants are DATA-SUPPORTED, not proven; re-gate only on new
          near-band data.
