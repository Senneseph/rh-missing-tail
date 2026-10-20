# RHEnd.lean  (2043 lines)
WHAT:  THE ENDPOINT of the program on the ACTUAL zeta zero set under the
         named external input [Z78] (Re s > 7/8 zero-free), at the
         CONCRETE wire. RESIDUAL LEDGER after Part B10 (discovery 0126):
         the strip-band face bundle (G-hs1, hs3-right, G-hs3-left) is
         JOINTLY EMPTY IN BODY (t4l_bandWireBelow: wire + mass < devProg
         on the strip band, flank-independent; t4l_bandEmpty: no Qside
         satisfies both squeeze legs at a band off-pair;
         t4l_stripFacesEmpty: the three B9 strip faces are jointly
         contradictory at every band off-pair) and COLLAPSES to ONE
         band-zero-exclusion face hNoStrip
         (rh_program78_stripfront_mach_vacant/_PT2; B10.5: the B9
         endpoint implies the vacant endpoint in body). The residual in
         the unverified region is exactly two zero-exclusion faces
         (band, window) + [Z78] + the below-frontier record - no
         analytic face remains in the tree.
HOW:   wire: Mf = Z78P12.MfP (0 tail), devOf = devProg (the concrete
         strip detector), Bwire/Mr = Z78P12.BwireP/MrP (the residue
         wires), flo = floProg (the unified S2 floor on the covered
         region 1000 <= t0, d0 <= 1/2; the near pin 0.9975 elsewhere).
         PROVEN IN BODY: S2 covered (FUnif.s2ActualFullBand, the unified
         actual-set floor); S4 strip band (FUnif.s4StripUnifiedFloor,
         squeeze and S2 floor are ONE object on 1/200 <= d0 <= 1/2); S4
         low band (TRIVIAL - the residue wires are 0 below 1000, floor =
         the pin, 0 < 0.9975); the far region (VACUOUS from [Z78] alone
         - Z78P12.offPairFarEmpty). NAMED RESIDUAL: hs1 the S1 witness:
         Qside >= devProg - the E1 content, uniform face via S1Uniform;
         hs3 the S3 wire: THE SAME Qside <= BwireP + MrP (Qside
         contract); hWin the S4 window-pin shape (25m/25ab closure
         pinned at 0.9975 vs the unified floor <= own mass <= 6e-4 there
         - Part C gate: ratio 1662.5), hS2low the S2 low-band pin (H6
         regime; sliver part vacuous under the named on-line record).
USES:  terminal: the one-clause endpoint; composes
         S4A.rh_from_regime_closures + Z78/Z78P12 + FloorUnif + S1LowT +
         P8Floor (p8_f_near_pin) + S1Face/P4Limit (Part B2).
GOTCHA: No RH claim: hs1/hs3/hWin/hS2low are OPEN (data and bound-level,
          as the chart carries); this module only NAMES the residual
          once, at the concrete wire. Part C #evals: 0.9975, 0.0006,
          1662.500000. PART B2 (discovery 0095): rh_program78_s1pins
          RESTATES the endpoint with the bare hs1 scale inequality
          REPLACED by the PIN FAMILY over the witness zero (P1 fill =
          the A0 fill; P2 the kernel-magnitude pin devFacePt <= |W_n|;
          P3 the A4.3 mass pin; P4 the absorption pin devProg + mval <=
          devFacePt) - the hs1 leg is DERIVED IN BODY via
          S1Face.hs1AtZero; the residual narrows from the bare
          inequality to the PIN family (same content, checkable shape).
          PART B3 (discovery 0107): rh_program78_winpt RESTATES the
          endpoint with hWin DERIVED IN BODY from the CITED classical
          frontier [Z-PT] (all non-trivial zeros up to tPT =
          30,610,046,000 on the line - the rigorous interval-verified
          zero-isolation record, cited like [Z78]) plus the residual
          face WinC.hWinFaceResidual (zero-exclusion of off-line zeros
          on (tPT, inf) x (0, 1/200)): S4WC's face identity makes the
          hWin premise exactly zero-exclusion on [1000, inf) x (0,
          1/200), and WinC.faceSplit splits it at the frontier (no off-
          pairs on [1000, tPT] from [Z-PT] alone) - the endpoint's hWin
          premise narrows to zero-exclusion above the frontier, the open
          height interval of the residual shrinking by a factor of ~3e7;
          the 3e9 record shadow (WinC.offExcessBound: off-line excess
          below 3e9 is 0 or 2 under the record's +-3 gate) is an
          independent record-derived constraint on the same open region,
          kept out of the endpoint premises; no RH claim. PART B4
          (discovery 0110): rh_program78_frontier - the endpoint
          COLLAPSED TO THE CITED FRONTIER: every named residual is
          quantified over off-pairs, and [Z-PT] excludes ALL off-line
          zeros below tPT at ANY offset (WinC.noOffLineBelowPT: t0 = 0
          by non-realness, 0 < t0 by the sign argument with the
          conjugate twin) - so below the frontier all four residuals are
          VACUOUS and above it only bound-level content remains: the
          theorem takes [Z-PT] + hs1/hS3 restricted to t0 >= tPT + the
          hWin residual face (zero-exclusion on (tPT, inf) x (0,
          1/200)); hS2low DISAPPEARS ENTIRELY (its domain (0, 1000) sits
          below the frontier). The entire residue of the endpoint (four
          named residuals on (0, inf) x (0, 1/2)) reduces to content
          STRICTLY ABOVE tPT = 3.06e10; no RH claim - the open content
          is the above-frontier bound-level faces, where no instrument
          in the tree reaches. PART B5 (discovery 0111):
          rh_program78_stripfront - the endpoint OVER THE STRIP
          FRONTIER: in the strip band (t0 >= 1000,  1/200 <= d0 <= 1/2)
          the four closure legs form a contradiction at any off-pair
          (S1:  scale >= devProg;  S2:  devProg >= floStripMin IN BODY
          no cap;  S3:  scale <= Bwire + Mr;  S4: Bwire + Mr <
          floStripMin IN BODY no cap),  and in the window band above tPT
          the hWin zero-exclusion kills every off-pair -  so the hs1/hs3
          premises shrink from all d0 in (0,  1/2] to the STRIP BAND
          above tPT. The named gaps behind the two strip faces
          (docstring):  G-hs3 = the off-line LIFT of the critical-line
          T4 wire  (p8_B_floor needs  Re  s  = 1/2;  an off-pair zero is
          off the line by definition;  no kernel upper bound at off-line
          points in the tree;  the P3 mass pin is a premise by design)
          and  G-hs1  =  the  scale  anti-degeneracy  lower  bound
          (body has kernel UPPER bounds and detector LOWER bounds only;
          measured shadow  =  the  S1Marg  margin  track).  G-hs1  +
          G-hs3  on  (tPT,  inf) x [1/200,  1/2] ARE the strip-band
          zero-exclusion;  the entire above-frontier residue of the
          endpoint is named:  two analytic gap statements plus the
          window face.  No RH claim. PART B6/B7 (discoveries 0117-0119):
          the machined stripfront endpoint rh_program78_stripfront_mach
          (+_PT2) - the G-hs3 face MACHINED at the lifted wires: the S3
          face carries the OFF-LINE EM wall (T4OffD: wall <= strip
          B-wire, termwise) + the OFF-LINE lifted M-wire (T4OffM, the
          CITED 1.6 convexity mass); the S3 leg closes IN BODY via
          t4wall_offline_le_bwires and the S4 strip leg is t4m_margin
          (lifted wire < floStripMin, ~16 orders); MrLift = the off-line
          M-wire in the strip band, S4A.MrR elsewhere. PART B8
          (discovery 0120): rh_program78_stripfront_mach_s1pins (+_PT2)
          - G-hs1 entered as the P1-P4 PIN FAMILY at the strip-band
          witness zero, the S1 leg derived in body via S1Face.hs1AtZero.
          PART B9 (discovery 0122): the hs3 face SPLIT BY FLANK -
          t4l_flankSplit (an off-pair with d0 != 0 is a right-flank or
          left-flank off-pair; the |.|-shape pins re = 1/2 +- d0),
          t4l_rightFaceOfSingle (the B7 single-face premise restricts to
          the right-flank face), and rh_program78_stripfront_mach_left
          (+_PT2): right-flank face = the machine-closable B7 shape
          (T4OffD in body), left-flank face hs3LeftH = the pair-level S3
          squeeze (Qside <= Bwire + Mr) = the NAMED ANALYTIC FACE
          G-hs3-left (T4OffL, discovery 0121: the n4 wire cannot produce
          it - band edge t >= 10^10, sigma = 0 unreachable, no uniform
          schedule). The S4 (floor) side is FLANK-INDEPENDENT
          (t4m_margin) - only the S3 (wire) side carries the flank. The
          endpoint residual in the machine is now exactly the four-face
          ledger: G-hs1 (data), window zero-exclusion (record), machined
          hs3 at the right witness (cited 1.6 mass), G-hs3-left
          (analytic); file 1505 lines. PART B10 (discovery 0126, after
          T4OffL S7/S8 + the S35B pre-check): the band squeeze window is
          EMPTY IN BODY, flank-independent - t4l_bandWireBelow (on the
          strip band at any off-pair: BwireP + MrLift < devProg -
          t4m_margin (S4 in body, 0118) composed with S2 in body
          (FUnif.s2ActualFullBand); the S35B pre-check measured the
          actual margin: devProg / (p8_B + MrLift) >= 1.1136 at the band
          edge d0 = 1/200, ~1.1e4 by d0 = 1/2), t4l_bandEmpty (no scale
          Qside satisfies BOTH squeeze legs at a band off-pair),
          t4l_stripFacesEmpty (the B9 three-face bundle G-hs1 +
          hs3-right + G-hs3-left is jointly CONTRADICTORY at every band
          off-pair: right branch via the T4OffD wall in body, left
          branch direct) - G-hs3-left (and its right-flank twin)
          DISSOLVE AS INDEPENDENT FACES: they are components of the
          strip-band zero-exclusion face.
          rh_program78_stripfront_mach_vacant (+_PT2): the endpoint with
          the bundle replaced by ONE band-zero-exclusion face hNoStrip
          (the S4 strip case no longer needs t4m_margin);
          rh_program78_stripfront_mach_vacant_ofB9 (+_PT2): the B9
          endpoint implies the vacant endpoint in body - for the
          endpoint the three-face bundle is EQUIVALENT to the single
          zero-exclusion face. The endpoint residual in the unverified
          region is now exactly two zero-exclusion faces (band, window)
          + [Z78] + the below-frontier record; the S1 pin family (B8) is
          the DATA SIDE of the squeeze, and the squeeze certificate
          certifies the band exclusion in body when the pins hold. PART
          B11 (discovery 0127): the above-frontier residual UNIFIED TO
          ONE FACE - the band face (hNoStrip, 1/200 <= d0) and the
          window face (hWinH, d0 < 1/200) have the identical form (zero-
          exclusion above the frontier; the 1/200 boundary is a proof
          artifact of the squeeze cycle, not a face boundary) and the
          far region d0 > 1/2 is closed in body from [Z78] - so the
          endpoint's above-frontier residue is the SINGLE face hOff (no
          off-pair on [H, inf) x (0, 1/2]):
          rh_program78_stripfront_mach_unified (+_PT2 at the Platt-
          Trudgian frontier) states the endpoint with that one face plus
          the record below the frontier plus [Z78];
          rh_program78_stripfront_mach_unified_ofB10 (+_PT2_ofB10)
          proves the B10 endpoint (two-face form) implies the unified
          endpoint in body - the unification loses nothing. File 2043
          lines, 0 sorry, full tree green. The above-frontier ledger is
          now exactly: ONE record-footing zero-exclusion face + [Z78] +
          the below-frontier record. No RH claim: everything in B10/B11
          is either body composition of the 0118 S4 wire margin with the
          S2 floor closure, or a zero-exclusion face on record footing
          with the [Z-PT2] record.
