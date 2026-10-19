# T4OffL.lean  (919 lines)
WHAT:  THE G-hs3-LEFT FLANK BARRIERS (discovery 0121, GATED): the n^4
         machine wire CANNOT close the S3 face at sigma < 1/2 - formal
         negative results, correcting the 0119/0120 all-flanks wording
         (0116-0120 cover sigma >= 1/2 only, at t4o_sOff).
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
         covers the band; d0 = 1/2 unreachable at every schedule.
USES:  used by: the endpoint face list (RHEnd stripfront residual is
         four faces: P1-P4 pins, window exclusion, machined hs3 at the
         RIGHT-flank witness, G-hs3-left); docs/KNOWN_LIMITATIONS.md
         0121 correction section; the S7 family is the constructive
         companion feeding the G-hs3-left squeeze candidate (per left-
         flank witness: run a schedule at or above
         A(sigma)*t^{2/sigma}).
GOTCHA: FORMAL NEGATIVE RESULTS about the machine wire - NO claim about
          zeta or RH (no zero existence implied). Pinned-mathlib
          gotchas: Real.rpow_mul direction is x^(yz) = (x^y)^z (use
          .symm for the other way); gcongr AUTO-DISCHARGES subgoals
          found in the local context (stray bullets = 'No goals to be
          solved'); calc continuation lines need a named have or a one-
          line by (a multi-line by swallows the '_ <=' line); one_div as
          a bare rw pattern is unreliable - use (one_div x).symm. Lean
          4.33.1 + mathlib v4.33.1, DOC-FIRST.
