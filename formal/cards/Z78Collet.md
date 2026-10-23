# Z78Collet.lean  (345 lines)
WHAT:  The [Z78C] named external input: the QuasiRiemannTracker finite-
         ordinary-source-moments frontier (record hailey-
         collet-1252270103, PR #69, Hailey Collet / HaileyStorm, MERGED
         2026-10-23, merge commit 2cbdbe7c...) - the all-Dirichlet zero-
         free half-plane at the certified rational boundary
         8747729897/10^10 = 0.8747729897; a DIRECT descendant of [Z78G]
         (the record consumes PR67 = [Z78T] as input, adds 64 seed
         source faces, 221 derived source faces, a 301-node finite
         source DAG induction: a NEW structural cycle, not tuning).
HOW:   externalZeroFree78Collet (named prop; the zeta form is the chi =
         1 specialization, pole guard inert on the pinned Mathlib);
         colletUpper_lt_gao (norm_num cross-multiplication:
         8747729897*10^3 < 8748087*10^6);
         extColet_implies_extGao/_extTrack/_extLiu/_ext78 (STRICTLY
         STRENGTHENS the whole chain); zetaZeroStripCollet (1 -
         colletUpper <= Re <= colletUpper); offPairD0leCollet (d0 <=
         colletD0max = colletUpper - 1/2 = 3747729897/10^10 =
         0.3747729897 < gaoD0max < 3/8, SHARP). Float data gates:
         0.8747729897 / 0.1252270103 / 0.3747729897.
USES:  used by: RHEnd (part B16 - the CURRENT terminal endpoint
         rh_program78_stripfront_mach_unifiedCollet/_PT2; the 0142 Gao
         endpoint is a theorem of it via B16.4; face shrink gaoD0max -
         colletD0max = 3.57103e-5).
GOTCHA: same input class - a kernel-verified external theorem as a named
          prop, NOT a compiled dependency. VERIFICATION STANDING
          (discovery 0162): INDEPENDENT second-party replay at the
          FROZEN head ac76d5ef (tmp/b6audit/collet69/replay/): 6474/6474
          modules (3547 record + 2927 vendored OAI baseline) compiled
          from source against the tracker-pinned environment (Lean
          4.34.1 pinned binary; mathlib d13f23b7...), 0 failures, 3472s;
          canonical statements at the exact rational kernel-accepted in
          both claimed scopes; axiom cone exactly [propext,
          Classical.choice, Quot.sound]; 0 sorry in the 3547-file cone;
          snapshot guard sha256 8607635a... MERGE IDENTITY (2026-10-23):
          the merged head IS the frozen head (GitHub API: PR #69
          head.sha = ac76d5ef...), and the FULL merged submission tree
          is blob-SHA-identical to the replayed frozen copy (3549/3549
          files at the merge commit; spot hash ReturnConstants.lean md5
          b82c1770...) - the frozen-head replay is exactly the merged-
          head verification. PENDING NAMING: the standalone paper
          (haileystorm.github.io) was 404 at audit time - provenance
          TODO, does not block adoption (the B6 section-8 gate is the
          kernel replay). SNAPSHOT CAVEAT: the board moved again by the
          same mechanism (0133 [Z78]->[Z78T]; 0142 [Z78T]->[Z78G]; 0162
          [Z78G]->[Z78C]). CEILING NOTE (0147): the record sits 2.116e-4
          above its family's named-margin corner (0.8745613585650727).
          NO RH CLAIM: a zero-free half-plane, still 0.3747729897 from
          the critical line in off-line distance.
