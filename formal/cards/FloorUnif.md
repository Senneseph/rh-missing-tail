# FloorUnif.lean  (274 lines)
WHAT:  Floor unification: S2 floor == S4 own-mass.
HOW:   ownKerC/ownKerIsNorm; poffIsOwnKerC (B5 product = S4 kernel
         body); poffOwnMass (|poff| = mown); floWinCap (cap 23/1000);
         mownBelowFloWinCap (<= 6/t^2 <= 6e-4 on 1000 <= t);
         floStripMin_eq_mownOnBand; s4StripUnifiedFloor;
         s2ActualFullBand.
USES:  terminal: the unified floor face; consumes Z78P12, S4Asm.
GOTCHA: exp(1/t^2) bounded by 3 via Real.exp_one_lt_three (norm_num
          cannot eval Real.exp in the pinned toolchain).
