# QSide.lean  (251 lines)
WHAT:  The zero-side scale Qside, NAMED DATA FACE (day-020 audit band).
HOW:   Qside (the walk-spine Q of discovery 0088) IS the measured |zeta|
         fill resid(t) = |zeta(1/2 + it) - K_on(t)| (the s10 LHS, A0
         same-object), day-020 record: 4 candidate pairs, straddle
         window 12, overall worst t = 1006.7916 with resid = 0.08168,
         dev = 9.198, margin 112.6; Xval pin |x| = 0.019253844165493 <=
         xvalPin = 3.9665418656908, headroom 206x.  Gates (LEAN-PROVEN,
         exact-rational norm_num + Float #eval): gate_worst_margin
         (112.6x squeeze gap), gate_xval_headroom, gate_resid_below_dev
         (route-A), gate_def_dominates_fill (48x), bundled in
         qsideFaceGated; Part E: mPin = 1/112.6 (the C4 margin pin) +
         mPin_lt_half + section8_close_at_audit (LEAN-PROVEN: the
         section-8 closure arithmetically closes at the day-020 pins -
         no real X with the C2 lower bound dev*(1 - mPin) AND the C3
         margin bound dev/marginWorst; the engine's contradiction
         instantiated at the data face).
USES:  used by: (none yet - the face module; the C6 audit-point package
         of Closure.lean consumes this data).
GOTCHA: MEASURED/PINNED labels per the honesty convention: resid/dev/|x|
          are day-020 measurements carried as named data; per-pair
          rounded values deliberately NOT re-gated (the C7 4-sig-fig
          print-precision note); the band-level uniform extension is the
          named open item, not a claim here.
