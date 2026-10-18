# S1Marg.lean  (193 lines)
WHAT:  THE HS1 UNIFORMITY TRACK:  the P1.1e best-straddle margin regime,
         pinned - where the day-020 audited band (S1Face) closes, the
         uniform-in-height measured track is pinned at its frontier.
HOW:   Pin pattern (MFa/B7F):  the 25 certified candidate heights of the
         P1.1e BEST-STRADDLE CLOSURE STATISTIC (the margin |zeta| *
         min_d |R-1| / (B + |zeta - K|) of the hs1 composite squeeze at
         the best straddle point of the window) are pinned from three
         certified runs:  the 1e7 run (14 candidates [999.7916,
         249999.7765], per-t quadrature to 1e18), the 1e6 extension (4
         candidates to [999999.7934]), the (1e7, 1e9] band scan (7 REAL-
         zero candidates [10000000.24, 28000000.1729], dps-30 per-t
         quadrature, tail = exact discrete sum over 47,517,736 LMFDB
         zeros (1e7, 3e7] + density quad (3e7, 1e18] + analytic
         remainder).  Lean pins the regime-deciding anchors (g125/m125 =
         28.918 @ 125000.3524; g150/m150 = 38.053 @ 150000.2616, LAST
         certified >= 25; g200/m200 = 21.665 @ 199999.7053, FIRST
         certified < 25; g250/m250 = 15.504; g1e6/m1e6 = 13.068 @
         999999.7934; g1e7/m1e7 = 5.2362; g2e7/m2e7 = 1.4138, certified
         MINIMUM; g28e7/m28e7 = 1.7120 @ 28000000.1729, LAST certified)
         all as exact rationals from the printed 6-significant-figure
         record values.  THE GATES (margGates, one norm_num on the pins,
         exact rationals):  the 25x window (>= 25 at 125k/150k
         candidates, < 25 at 199999.7053 - closes between 1.5e5 and
         2e5); the >= 15 class to 2.5e5; the >= 13 class to 1e6; the >=
         1 class to 2.8e7 (min 1.4138 vs threshold 1 - 41% slack); the
         height order of the anchors; the DECAY order m125 > m250 > m1e6
         > m1e7 > m2e7 - the regime degrades monotonically with height.
         NAMED FACE (hs1MargFace, declared, b7OpenFace pattern):  for
         ANY zero set q and ANY margin statistic marg, every height
         carrying an off-pair zero has marg >= 1 - the open UNIFORM
         measured track of the hs1 leg (S1Face docstring: 'uniformity in
         the height is the open measured track'); the pinned gates are
         its measured shadow at the 25 certified candidates.  The 9
         higher band-scan rows (3.1e7-1e9, margins < 1) are EXPLORATORY
         (nominal decade points, density-only tails, NOT real zeros) -
         recorded as the signal that the composite is the limiting
         object above the certified regime, never cited as measurements.
USES:  used by: (none yet) - the measured constraint the hs1 uniformity
         track must reproduce (PATHWAY section 3); consumer candidate: a
         future endpoint restatement with hs1 uniform below the
         certified band.
GOTCHA: pins are the PRINTED 6-significant-figure values - every gate is
          slack against the last printed digit (min gap 1.4138 vs 1);
          the 'exp' rows must never be cited as measurements at real
          zeros; the statistic is the BEST-STRADDLE margin (the
          composite squeezes at the best straddle point of the window),
          not the worst-over-window margin (a P1.1c-class statistic).
