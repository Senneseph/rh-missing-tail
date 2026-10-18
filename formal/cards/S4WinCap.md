# S4WinCap.lean  (769 lines)
WHAT:  THE hWin WINDOW FLOOR CAP + FACE IDENTITY: the window face is
         zero-exclusion, named and certified.
HOW:   Three new formal facts (namespace S4WC; no RH claim). (1)
         poffOwnMown: at the pair's OWN HEIGHT the B5 off-line factor
         product has mass exactly S4O.mown (B5's four canonical factors
         at (t,d,t) are exactly the 8-factor S4Own kernel; S4O.hMownProd
         is the 25n closed-form bridge; the B5/S4O zero identification
         rhoPP=z1 etc. with halfR = (2:R)^-1 = 1/2 is a lemma chain
         closed by dsimp + Complex.ext + simp/ring). (2) floorBelowWire:
         on the WHOLE window band 1000 <= t, 0 < d < 1/200, the unified
         S2 floor floStripMin t d is STRICTLY BELOW the window S4 wire's
         first tail term (hence below the wire total): floStripMin <=
         |poff| = mown < 31/(10^5 t^2) [mownWindowScale: each own-kernel
         factor pinned separately - 4d^2 < 1/10000 from d < 1/200,
         1+1/(16t^2) <= 16000001/16000000, exp(1/t^2) <= 1/(1-1/t^2) <=
         1000000/999999 via log x <= x-1], then 31/(10^5 t^2) <
         (1/2)^2/sqrt(13t/8) for t <= T0=110000 [nearTailBelowScale:
         squaring chain 12493t/8 < 12493t^4/8 < 2e9 t^4 <= 2.5e9 t^4 =
         50000^2 t^4, all explicit mul_le/mul_lt in the exact left/right
         form of the goal] and < 1/(2t) for t > T0 [farTailBelowScale:
         62t < 100000 t^2 by div_lt_div_iff0 cross-multiplication]; the
         tail term is the leading term of p8_B at the wire index
         (floor(13t/8) near, floor(t^2) far, via S4W.hpow1 and
         floor_le). (3) The FACE IDENTITY: def hWinFace (restates the
         hWin hypothesis of RHEnd.rh_program78 verbatim with the Z78P12
         wire aliases) is EQUIVALENT to zero-exclusion of off-line zeros
         on [1000, inf) x (0, 1/200): hwinFaceImpliesZeroExclusion (a
         face-holding zero set has no off-pairs in the band: wire+Mr+Mf
         < floor and floor < wire, Mr >= 0 [hMrgen, branch on t <= T0
         with S4W.hXwire_pos / hXgrowPos], Mf = 0, contradiction by
         lt_irrefl) and zeroExclusionImpliesFace (vacuous direction).
         hXgrowPos: S4G.Xgrow t > 0 for t > T0 (every factor positive;
         Sbar > 0 by the S4W.hLn27 ln-pin with 27 <= t^2). MEASURED
         BACKSTOP (survey s35a, tmp/s35a_hwin_far_survey.py, log
         tmp/s35a_hwin_survey.log, reproduces the Lean pins before
         results): margin floStripMin - (Bwire+Mr) < 0 at every surveyed
         point on t in [1e3..3e10] x d in (1e-9, 1/200), floor =
         4d^2/t^2 to rel 2e-13, Xwire(T0) = 1.827275e-3 <= RX, 25m total
         at T0 = 0.936536 < 0.9975. THE FACE ITSELF IS OPEN: it asserts
         zero-exclusion on a band no instrument in the tree reaches
         (classical zero-free regions give Re >= 1 - c/ln t, nowhere
         near 1/2 - 1/200). The endpoint and its four named residuals
         are untouched; hWin is now CHARACTERIZED.
USES:  used by: (none yet) - it characterizes the hWin face of
         RHEnd.rh_program78; the next consumer is the endpoint
         restatement or a future zero-free-region import that would
         discharge the face.
GOTCHA: explicit-algebra discipline: every mul_*_of_* call matches the
          goal's LITERAL parse (left/right factor position), every div
          comparison is cross-multiplied via the 0-suffixed iff's, no
          Real log enters the pins; the T0 = 110000 bridges are rfl on
          the def, not norm_num; the 16000001/16000000 literal is
          elaborated identically at every use (a literal-type mismatch
          broke the first attempt).
