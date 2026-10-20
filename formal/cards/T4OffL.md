# T4OffL.lean  (1738 lines)
WHAT:  THE G-hs3-LEFT FLANK BARRIERS (discovery 0121, GATED) + THE S3
         LEFT WALL AT THE SQUARE-ROOT SCHEDULE (discovery 0125, GATED):
         the n^4 machine wire CANNOT close the S3 face at sigma < 1/2 on
         its own schedule (formal negative results, correcting the
         0119/0120 all-flanks wording; 0116-0120 cover sigma >= 1/2
         only, at t4o_sOff) - but the S3 LEFT LEG IS BODY-DISCHARGEABLE
         at the per-point square-root schedule n >= (n4 t)^{1/(2 sigma)}
         (t4l_wall_tuned), composed into the endpoint face
         (t4l_face_left_body / t4l_face_left_band).
HOW:   t4l_sOffL (left canonical point re = 1/2 - d0); t4l_expU (exp u
         <= 1/(1-u) for 0 <= u < 1, PURE log route:
         log_le_sub_one_of_pos + le_log_iff_exp_le - no numeric exp);
         floor pins t4l_floorPinEdge (floStripMin t (1/200) <= (1/9999)
         t^{-2}) / t4l_floorPinHalf (<= 2 t^{-2}); t4l_n4upper ((n4 t :
         R) <= 2*3.1e7 t^4 via Nat.ceil_lt_add_one: ceil_+(x) < x+1 <=
         2x); t4l_term1lb ((1/2)(n4 t)^{-99/200} >= (1/15750)
         t^{-99/50}; constant via sqrt(62000000) < 7875, exact pin);
         BARRIERS: t4l_barrier_edge (t >= 10^10 -> first T4 term AT THE
         n4 SCHEDULE > floor at the band edge; crossing threshold t >
         (15750/9999)^50 ~= 7.33e9; frontier margin ~13%) and
         t4l_barrier_sigma0 (1/2 > floor at EVERY schedule n > 0, d0 =
         1/2), plus t4l_squeezeImpos_edge/sigma0 (the squeeze cycle's S3
         side cannot hold) and t4l_barrier_edge_PT2 (the barrier at the
         CITED Platt-Trudgian frontier 3,000,175,332,800). S7 LEFT-TUNED
         SCHEDULE FAMILY (discovery 0123, GATED) - the POSITIVE DUAL of
         the barriers: t4l_schedA (sigma) = (9999/2)^{1/sigma} (the
         critical scale constant: (1/2)*A(sigma)^{-sigma} = 1/9999
         exactly), t4l_schedA_pos (positive for every sigma > 0),
         t4l_schedTerm1 (t >= 1000, sigma > 0: EVERY schedule n >=
         A(sigma)*t^{2/sigma} puts the first T4 term (1/2)n^{-sigma} <=
         (1/9999)t^{-2} - the edge-floor scale target, at or below),
         t4l_schedBeat4pin + t4l_schedBeat4 (at t = 10^10 and the band
         edge sigma = 99/200 the critical scale
         (9999/2)^{200/99}*t^{400/99} STRICTLY EXCEEDS the uniform
         machine schedule n4 <= 2*3.1e7*t^4 - pinned to the 99th power:
         (9999/2)^200*10^40 > 62000000^99), t4l_schedDiverge (for EVERY
         A > 0 there is a d0 in [1/200, 1/2) with A(1/2-d0) > A - the
         tuned constant is UNBOUNDED as d0 -> 1/2; NO d0-uniform
         schedule exists). CONSEQUENCE: satisfaction of the machined hs3
         face at a LEFT-flank witness (re = 1/2 - d0) is the remaining
         face G-hs3-left - analytic content: per-point closure needs a
         left-tuned schedule (decay n^{-sigma} beating t^{-2}); S7 gives
         that per-point schedule EXACTLY and proves no uniform one
         covers the band; d0 = 1/2 unreachable at every schedule. S8
         SQUARE-ROOT SCHEDULE AND S3 LEFT WALL (discovery 0125, GATED;
         file 1738 lines, 0 sorry) - the positive twin of S7 for the
         FULL S3 squeeze: t4l_schedB (t sigma) = (n4 t)^{1/(2 sigma)}
         (the square-root schedule: at n = schedB the first T4 term
         computes (1/2) n^{-sigma} = (1/2) (n4 t)^{-1/2} - exactly the
         on-line T1 scale), t4l_schedB_pos / t4l_schedB_ge_n4 /
         t4l_sched_pow (the single schedule fact: n >= schedB and a > 0
         imply n^a >= (n4 t)^{a/(2 sigma)}), left-norm helpers
         t4l_normsq_L / t4l_wall_norm1 (||sL|| <= ||sOn|| on the band) /
         t4l_shift_normsq / t4l_shift_norm / t4l_wall_norm_prod (the
         triple product sL(sL+1)(sL+2) is termwise norm-smaller than the
         on-line product), the T3 coefficient pins t4l_T3pin
         (31000000^{2/99} >= 500/499) / t4l_T3pin2 (>= 10/9) (exact
         99th-power norm_num) and t4l_T3margin ((n4
         t)^{(1-2sigma)/sigma} >= 5/(2(sigma+2)) for sigma <= 99/200;
         split at sigma = 1/4: pin2 route vs the n4-square route), the
         termwise walls t4l_wall_T1 / t4l_wall_T2 / t4l_wall_T3 against
         p8_B t (n4 t), THE MAIN LEFT WALL t4l_wall_tuned (t >= 1000,
         1/200 <= d0 < 1/2, every n >= t4l_schedB t (1/2 - d0):
         ||p4_em_expr (t4l_sOffL t d0) n|| <= p8_B t (n4 t)) - the
         mirror of t4wall_offline_le_bwires (T4OffD) on the left flank -
         and the endpoint-face composition t4l_face_left_body (the same
         witness satisfies ||p4_em_expr (sL) n|| <= S4A.BwireR t d0 +
         t4m_MwireOff t d0, via BwireR = p8_B t (n4 t) on the band) and
         t4l_face_left_band (for EVERY band off-pair at t0 >= 10^10, n =
         ceil(schedB) witnesses the wall). Pre-checked in
         tmp/s35b_leftflank_precheck.py (dps50 mpmath port): max
         termwise ratio at the schedule 1.0000 on the survey grid, T3
         pin worst log10 margin 0.3929 (~2.47x), right-wall port gate
         clean (max 0.7990). The d0 = 1/2 slice (sigma = 0) stays the
         0121 barrier (the schedule diverges there; excluded by d0 <
         1/2). The S1 leg is NOT closed by S8: the pre-check measured
         devProg / (p8_B + MrLift) >= 1.11 at the band edge d0 = 1/200,
         growing to ~1.1e4 by d0 = 1/2 - numerically, no tuned-tail
         Qside fits the band squeeze window (the emptiness question is
         the next unit, S9, pending the B6 cross-check).
USES:  used by: the endpoint face list (RHEnd stripfront residual is
         four faces: P1-P4 pins, window exclusion, machined hs3 at the
         RIGHT-flank witness, G-hs3-left); docs/KNOWN_LIMITATIONS.md
         0121 correction section; the S7 family is the constructive
         companion feeding the G-hs3-left squeeze candidate (per left-
         flank witness: run a schedule at or above
         A(sigma)*t^{2/sigma}); S8 (0125) is the machine discharge of
         the S3 LEFT LEG at the square-root schedule, feeding the S9
         residual analysis (the S1-leg / band-emptiness question).
GOTCHA: No RH claim: the S6 barriers are FORMAL NEGATIVE RESULTS about
          the machine wire, S7 their positive dual (the explicit per-
          point constructive schedule), and S8 an EXPLICIT wire estimate
          between named functions on a concrete band - none touches zeta
          zeros. Pinned-mathlib gotchas (S8 repair log):
          linarith/nlinarith FAIL on a Nat.cast numeral times a variable
          (2 : Nat) * x until norm_num normalizes the cast; norm_num
          CANNOT prove 0 <= sqrt(3)/540 (no sqrt eval) - use positivity;
          positivity CANNOT prove 0 <= x^8 from 1000 <= x without an
          explicit 0 < t in context; mul_le_mul_of_nonneg_left gives c*a
          <= c*b (factor on the LEFT) and _right gives a*c <= b*c - the
          factor position must match the goal term exactly;
          div_le_div_iff0 .mpr yields a*d <= c*b - close with
          mul_le_mul_of_nonneg_right (factor on the right); no
          pow_le_pow_right / pow_le_pow (use pow_le_pow_left0 or
          gcongr/nlinarith); no MulLeftStrictMono instance for reals
          (avoid mul_lt_mul_of_le_of_lt); Real.rpow_nonneg takes the
          exact exponent TERM - negated-fraction shapes differ as terms;
          sq_le_sq in this pin is an iff (a^2 <= b^2 <-> |a| <= |b|);
          p8_B inlines (1/2 + t*I) instead of t4o_sOn - the final
          definitional step needs dsimp only [p8_B, t4o_sOn];
          t4o_normsq-style normsq rewrites need the dsimp of the point
          def BEFORE the rw. Lean 4.33.1 + mathlib v4.33.1, DOC-FIRST.
