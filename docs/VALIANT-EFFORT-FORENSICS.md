# Valiant-effort forensics — the 3e10 room, inspected

What this file is. A complete inventory of everything seen and
measured on the path that was supposed to close RH at the 3e10
frontier: the architecture, every instrument, every stone turned,
the exact numbers, what connects to what, what was seen but could
not yet be connected, and the clean "did / didn't" statement with
the ranked doors that remain. Companion to
A1-THEOREM-ATTACK-PLAN.md (the theorem-side plan) and
S1-A1-EXPLORATION.md (the E19 evidence line). This file makes no
RH claim and does not assert any result it does not cite as
machine-checked, cited, or measured.

Legend used throughout:
  LP  = LEAN-PROVEN in this repository (lake build green, 14/14).
  CIT = cited literature input (recorded in
        formal/RH-LEAN-PROVENANCE.md with source).
  MEA = measured data (file on disk, read-only, bit-pinned).
  SCR = screen-level (f64 engine, tracked budget not yet verified
        against an independent pipeline at that point).
  CRT = certificate-grade (independent re-verification passed).

## 1. The room (what was to be closed, exactly)

The closure is the machine-checked implication
`P12.p1_2` (composed into `ZetaZeroSet.rhIfMarginZeta`):

  [S1 bridge-tail uniformity]  (hs1)
  [S2 detector floor]          (hs2, devOf >= flo)
  [S3 definition-side wire]    (hs3, Q <= Bwire + Mr)
  [S4 the squeeze]             (hs4, Bwire + Mr + Mf < flo)
     for EVERY off-pair (t0, d0)
  =>  RH q

(LP; the composition is Lean; the four legs are fed by data and by
theorem inputs, as itemized in section 6.)

The operational claim the data was filling (pre-registered,
day037 docstring, inherited verbatim from day029/day034):

  margin_new(t, g_x) > 1 + eps_explicit  at EVERY straddle,
  grid x = 1e6 * 1.08^k,  anchor g_x = nearest real zero,
  straddles t = g_x + k/2,  k = -12..12 \ {0}

with

  margin_new = |z(1/2+it)| * dev / (p8_B(t, n4(t)) + residf)
  dev    = min over the 500-point delta grid |R_closed(g,t,d) - 1|
  residf = |z - Kfull|,
  Kfull  = exp(Lmain + la + i ar + re_tail + i im_tail)
           * exp(Qrem) * exp(Qext)

where Kfull is the full approximate-functional-equation
reconstruction from the tail over the ACTUAL zeros of
(1e7, G_LAST], G_LAST = 3.0001046e10, streamed from the verified
band (1.016e11 zeros, 815 GB, md5-chained).

Pre-registered readings (day034/docstring, inherited):
  C-1  margin_cert >= 1 at ALL grid points
       -> band fill RE-ISSUES at certificate grade.
  C-2  margin_cert < 1 <= margin_computed at isolated points
       -> reissue those points at dps-90/120; record decisions.
  C-3  margin_computed < 1 at any point
       -> the screen claim fails at certificate level; the
          Phase-1a ceiling report at that point IS the deliverable.

## 2. The instruments

1. The 815 GB verified band (sections L, A, B, C, D; D is the
   740 GB file (2.9992e9, 3.0001046e10]; two readable copies,
   md5-chained; read-only everywhere; third copy does not fit
   locally and was accepted as two-copy protected).  [MEA]
2. The H1 fleet engine (day038, GPU cupy threaded-slab engine;
   three machines: 8x-RTX-4090, v100, 5900X+3090Ti; 696/696
   points = 29 windows x 24 k; cross-machine rows 466/466
   bit-identical at overlap; ledger merged by h1merge_ingest with
   conflict-HALT).  [SCR — see section 5 for the blinding]
3. The CPU reference engine (day037: streamed f64 tail with
   certified per-slab Higham budgets; the day048 80-bit-exact
   longdouble tree as an independent f64-total oracle).  [CRT at
   the re-issued points]
4. The dps ladder: dps-30 (fleet), dps-45, dps-90, dps-120
   (zeta, quadrants, product, dev); the day049a pi-probe
   (single point, all four levels, same tail re/im, component
   phase comparison).  [CRT]
5. The Lean proof unit (RhAttack.*; 14/14 gates; zero sorry).  [LP]

## 3. The stones, in order

### 3.1 The S1 walk / A2 data layer  [MEA]
  sup |DN| over (2.9992e9, 3.0001e10]      = 2.615067  (pinned)
  sup |DN| global (1e7, 3.0e10]            = 2.615067
  DN(0) at the seam (from the 3e9 walk)    = +0.525129318
  DN at band end (next band's start pin)   = +0.904983521
  SUM_EPS over all 92,577,877,713 gaps     = 31,037,858,563.15
  + margin (1e-4 x gaps)                   = 9,257,787.77
  SUM_EPS_CERT (the rigorous walk ceiling) = 31,047,116,350.92
  N(3.0e10)                                = 101,635,962,231
  (results/3E10-EPSILON.md; the 4.8e-7 selftest discriminater
  passed before the run; the per-gap budget is f64-certified.)

  Reading: the telescope walk stays bounded (measured 2.62) past
  9.06e9 zeros to 1.016e11 zeros; the proven ceiling over it is
  3.1e10 (the E2 barrier: proven, data-tight to 0.03%, but not
  tight-fit; LP in E2Barrier). The data side of [S1] is closed
  at A2 class. What it is NOT: a data-free O(1) theorem (that is
  A1, sections 3.6 and 6).

### 3.2 The H1-696 fill ledger  [MEA at SCR level — blinding in 5]
  29 windows x 24 k, all mcerT/rows present, zero NaN, 466/466
  cross-machine bit-identical (MERGED ledger is the canonical
  record; scripts/rh/h1_final_fleet/).
  Local (5900x) 180-row distribution of the mnew column:
    min 0.9999999965, p5 0.9999999974, median 0.9999999995,
    max 1.0000000034,  96/180 below 1.
  The 505-point interim reading found  margin - 1 ~ A(x) * k,
  odd in k, 96.4% of variance in that one linear term, worst at
  x = 3.23e9, k = -12 (margin 1 - 3.7e-9).

  CRITICAL (day048, on the record since): the ledger's "mnew"
  column values (~1 +/- 4e-9) are NOT the margin at those
  heights once the tail is re-verified independently — see 3.4.
  The drift law described the ledger values, i.e. it was a law
  ABOUT THE ARTIFACT (section 5 explains the artifact).

### 3.3 The day047 D-band signed defect  [MEA, CRT-adjacent]
  D-band (the (2.9992e9, 3e10] splice), 5 heights, 92,219,492,047
  zeros streamed at the wire-nearest height:
    |D| = 1.628 (3.23e9 straddle), 2.691 (1e10), 1.015 (1.5e10),
          5.171 (2.5e10), 5.041 (2.99e10)
  D(2.99e10) = 4.9789 - 0.7885i.  Sum-side precision PASS
  (fsum == mpmath-dps-30 bit-exact).
  Pre-registered O(1) reading FIRED; the refutation branch
  (|D| >> O(1)) never fired; no growth toward the frontier
  (the wire-nearest 5.041 is BELOW the 2.5e10 value 5.171).
  Structure: ~1..2.7 on the lower half, ~5.0..5.2 on the upper
  half (window effect: the D-band window is ~10x the day029
  splice window).
  Consequence (E18 closed): every number the [S1] wire consumes
  on the data side is now measured at 3e10; what remains for
  [S1] is the data-free O(1) signed-defect theorem itself
  (E15's target; E7: not claimed in the literature).

### 3.4 The day048 margin re-issue + the day049a pi-probe
  [CRT — the decisive data finding]

  The C-2 prescription re-issued the worst-10 negative-k points
  (4 windows, k = -12..-9; dps-90/120; f64-pairwise V1 vs
  80-bit-exact V2; full engine replication at two of them):

    x            margin (all variants agree to < 4e-7)
    3.23217e9    0.502276
    3.49074e9    0.502658
    3.77000e9    0.503099
    4.07160e9    0.503626

  - dps-90 == dps-120 bit-identical at every re-issued point.
  - f64-pairwise vs 80-bit-exact tail: agreement <= 1.7e-6 in re
    (V1-V2 margin delta <= 4e-7).
  - The in-stream engine replica is BIT-EXACT against the real
    CPU engine call (verify: replica_bit_exact = True at both
    audited points).
  - The margin is a function of x ALONE (at fixed x the four k
    values agree to < 2e-6); it rises smoothly and monotonely
    0.50228 -> 0.50363 across the four windows.

  Component anatomy at the two audited points (same t, g):

    p01 (x=3.49e9, k=-12):
      |z| = 1.307585   dev = 1.000   pb = 7.4e-24
      |Kfull| = 1.2937556   phase(K) - phase(z) = +3.1416 rad
      residf = |z - Kfull| = 2.601341
      margin = |z|*dev/(pb + residf) = 0.502658
    p00 (x=3.23e9, k=-12): |z| = 1.63484, |Kfull| = 1.62003,
      residf = 3.25487, margin = 0.502276.

  The geometry: Kfull is ANTI-PARALLEL to z (phase difference
  exactly pi to 4 digits) with amplitude ~|z|, so the
  reconstruction defect is ~|z| + |Kfull| ~ 2|z| — exactly the
  factor-2 denominator that halves the margin.

  The pi-probe (day049a: same point, dps = 30/45/90/120, same
  80-bit-exact tail re/im at every level, all components
  compared): lm, la, ar, qrem, qext are IDENTICAL to every
  printed digit at all four precisions, and Kfull is identical
  at all four precisions (|K| = 1.2937556, phase = 4.1815 rad,
  margin = 0.502658). dps-30 is NOT defective. The anti-
  parallel Kfull is the TRUE value at every precision of the
  zeta/quad/product stack.

  Therefore the ledger row (0.9999999965 at that point) cannot
  be reproduced by the current math at ANY dps with the
  verified tail. The ledger row's own stored columns (zeta =
  1.307585, dev = 1.000, residf = 1.3075849021) put K_fleet on
  the circle of radius |z| centered at z (the locus of K with
  |z - K| = |z| + 4.6e-9: K_fleet ~ 0, ~ 2z, or z + i z all
  qualify; |K_fleet| is anything from 0 to ~2.615). The
  verified Kfull = 1.29376 * exp(i pi) * (z/|z|) sits at
  distance 2.6013 from z — it is NOT on that circle. The fleet
  engine's K and the verified K disagree at the UNIT level, far
  outside every f64/quad/product budget on record (<= 4e-4
  scale); which tail is right is decided by the verification
  weight: the current tail has (a) the real CPU engine call
  bit-exactly replicated in-stream, (b) an independent 80-bit-
  exact longdouble tree agreeing to 1.7e-6, (c) nlt exact by
  binary search over the same files, (d) the md5-chained band
  intact — versus the GPU fleet tail, which has no independent
  full-tail re-verification (section 5).

### 3.5 The W2M6 data-free re-pin, refuted AT THE PIN  [LP+CIT]
  K_mil(T) = 0.111 log T + 0.275 loglog T + 2.45 + 1/8
  (Trudgian II uniform S-bound [A1G-5] + the exact 1/8
  zero-grid convention, E16; attributed in-repo as "Milino
  form" — corrected: the constants and arXiv:1208.5846 are
  Trudgian's; the nearby Milino/CCC paper is a different
  result, see [A1G-7]).
  Pinned in Lean (norm_num, exact rational):
    K_mil(3e10) in [6.12, 6.15)
    pG1(t) >= 11.51 for t >= 3.2e9  (|pG1| = pG1 there)
    K_mil(3e10) * |pG1(t)| >= 70  for every band height 3.2e9
  The walk-channel price K * C (C >= |p(G1)|) therefore exceeds
  70 > 1 >= dev_feed = 1 - 13/t on the whole band: the data-FREE
  walk-channel branch of the [S1] wire is REFUTED AT THE PIN —
  exactly, from the cited bound plus the band's own left-pin
  kernel (refutation_3e10; the measured full-channel figures
  509..608 on the 505 in-hand straddles are strictly LARGER;
  this file's floor is LP).
  Reading: the data-free branch of the [S1] walk-channel wire
  cannot close the band at the pin; the data (measured K,
  section 3.1) is what carries that wire, and its data-free
  replacement is 2+ orders too big.

### 3.6 The growth-form A1 wire  [LP + CIT]
  A1Growth.lean: the universal wire instantiated at
  data-free GROWTH bounds on |DN j|:
    - unconditional G(T) = 0.111 log T + 0.275 loglog T + 2.450
      (Trudgian II, [A1G-5]; LEAN-PROVEN non-decreasing on
      [4, oo]; the single cited auxiliary fact is e < 4);
      at the frontier G < 7 (Lean pins; cited numerics log 3e10
      < 25, loglog < 4), so the DATA-FREE far-side wire is
      |S1 - R| < 8 * (17/8) = 17 (pin_explicit_wire_3e10);
      the adjacent Platt-Trudgian 2015 form (0.11/0.29/2.29,
      [A1G-7](a)) would push the data-free frontier K just
      under 6.9 (G ~ 5.87).
    - the RH CCM form (1/4) log/loglog + ... (arXiv:1309.1526
      Thm 2, [A1G-3]) carried as explicit cited premises.
  Against: the MEASURED far-side wire is 2.615067 * (17/8) ~
  5.55, and the certified-majorant wire is 3.1e10 * (17/8) ~
  6.7e10. The data-free wire is within a factor ~3 of the
  measured wire at the frontier — a constant-factor gap, not an
  order-of-magnitude or shape gap.

### 3.7 The E19 verdict on the absolute clause
  [CIT-heavy; the verdict is documented, the theorem is NOT proven]
  The clause "exists C: |S(gamma)| <= C at ALL zeros, data-free"
  is OPEN, under strong pressure, and characterized:
    - every published bound GROWS (all-t unconditional O(log t);
      RH (1/4) log log / loglog + corrections; omegas at the
      zeros: unconditional Omega((log t / loglog t)^{1/3}) —
      Tsang; RH Omega(sq(log t * logloglog t / loglog t)) —
      Bondarenko-Seip; per Dobner 2101.01747).
    - the sqrt(loglog)-normalized CLT line (Selberg 1946 to
      2024-26: 2407.14867, 2505.23573, 2511.18275, 2507.04150,
      2510.14309) contradicts a flat-at-all-zeros bound in the
      limit.
    - the data's flatness to 3e10 (section 3.1: 2.615) is
      explained by the growth scales being numerically 1.78 /
      1.97 / 2.96 / 1.90 at 3e10 — the "all clocks read about 2"
      red hat: the data cannot distinguish truly-O(1) from
      slowly-growing at 3e10.
    - the attempted zero-specific REFUTATION (Omega values +
      CCM gap-transfer) FAILED cleanly: the transfer error
      swallows the Omega value (ratio -> oo); filed as a documented
      dead end, not silently dropped.

### 3.8 The zeros-restricted frontier  [CIT]
  "At present there is no unconditional improvement on
  S(t) = O(log t)" (arXiv:2010.13307, 2021) and "no satisfactory
  results seem to be known" for S(gamma+H) - S(gamma-H)
  (arXiv:1706.08268, 2017): even restricted to the zeros, the
  published frontier is the all-t O(log t) scale. The growth-
  form wire of 3.6 therefore sits at the frontier; no sharper
  data-free clause exists in the literature to import.

## 4. What connects to what (the composition map)

  hs1 (zero side, S1 walk)  <-  data: 3e9 walk pin, 3e10 band
      walk, sup|DN| 2.615 (MEA);  theorem: data-free O(1) walk
      bound = A1 (GROWTH form LP at every G above the data;
      absolute form OPEN, 3.7);  the CERTIFIED-MAJORANT version
      (3.1e10) is LP (E2Barrier) but 10^10x above the data.
  hs2 (detector)            <-  the H1 margin statistic > 1 at
      the straddles; data: 696-point fill (SCR, blinded —
      section 5), re-issued worst-10 (CRT: 0.502 < 1).
  hs3 (definition wire)     <-  Bwire: MEASURED K = 2.615
      (factor 17/8) on the far side; data-free replacement:
      K = G + 1 < 7 (LP, 3.6) with wire < 17; the WALK-CHANNEL
      data-free variant is refuted at the pin (3.5, >= 70).
  hs4 (the squeeze)         <-  the composition of the above;
      the blind-spot mathematics; the C-3 event of section 3.4
      means the measured legs do NOT currently hold at
      certificate grade at the worst straddles.

  The conditional (four legs => RH) is LP at every level. The
  data supplies the legs. At 3e10 the measured legs: walk side
  COMPLETE (A2), squeeze-side fill AT SCREEN LEVEL ONLY (the
  certificate re-issue fired C-3 and the re-issued true margins
  are 0.502 at the worst straddles). Hence the closure is not
  closed at the frontier, at certificate grade. That is the
  state. Nothing above was stretched to say otherwise.

## 5. The instrument's blind spot (the key forensic finding)

  The fleet engine (day038 GPU cupy threaded-slab) and the CPU
  reference (day037) disagree on the tail at the worst
  straddles by a UNIT-level difference in K (the fleet K on
  the |z|-circle around z, the verified K at distance 2.6013
  anti-parallel — section 3.4) — far outside every budget on
  record (tail budgets 4e-4 scale) and far outside f64-vs-
  80bit (1.7e-6). The selftests as written cover: (c) GPU ==
  CPU on the OVERLAP PATCH only; (f) GPU-threaded == GPU-
  sequential on the band. No selftest compares the GPU FULL-
  TAIL totals against the CPU reference at high relative
  precision on the live band. That is the missing gate.

  Mechanism candidates (LEADS, not conclusions — in order of
  fit to the evidence):
    (i)  the POLE CHUNK.  The re-issue documents a single pole
         chunk in the tail (kernel ~ t/(g^2+1/4), log-terms
         near-singular at g ~ t) whose range spans 24 across the
         chunk — exactly the region that breaks the smooth-
         ratio property used by the exact-80bit tree, and the
         region where f64 rounding of log|g^2 - t^2| at g ~ t
         is worst. The worst straddles are exactly the k < 0
         points where the anchor zero sits just ABOVE t and the
         pole chunk is live in the tail. The margin's smooth
         monotone x-structure (0.50228 -> 0.50363) matches an
         x-dependent (t-dependent) pole-chunk effect.
    (ii) a SEAM/OVERLAP chunk: the documented A/B overlap
         (152 rounding-level zeros at init, e180eae-era reader
         fixes around it) is a smaller-magnitude candidate; its
         per-term kernel values at t ~ 3.5e9 are ~3.5e-9 (im)
         and ~O(40) (re) — a unit-level K shift (section 3.4
         geometry) is reachable from mis-handled aggregate over
         a bounded number of such terms.
    (iii) nothing to do with the data: a dps-30 mpmath
         composition difference — EXCLUDED by the pi-probe
         (dps-30 reproduces the dps-120 Kfull exactly with the
         same tail).
  The decisive audit (when a GPU box is available): run the
  GPU tail and the CPU tail at 3-5 audit heights and diff
  re/im term-chunk-by-chunk over the pole chunk and the A/B
  seam. That single experiment will name the mechanism.

## 6. The did / didn't statement

  Did it? NO — at the 3e10 frontier the closure did not close,
  at certificate grade, and it is not closed at the theorem
  level either (the absolute-O(1) clause of A1 is open and
  characterized, 3.7). Specifically:
    - the conditional implication (legs => RH) is LP;
    - the walk data side of [S1] is complete (A2) to 3e10;
    - the growth-form A1 wire is LP (unconditional at the
      frontier, data-free K < 7, wire < 17; RH CCM form carried
      as cited premises);
    - the data-free WALK-CHANNEL wire is refuted at the pin
      (>= 70), exactly;
    - the measured squeeze-side fill C-3 FAILED at the
      certificate level: the worst-straddle margins are 0.502
      (CRT), and the 696-point "certificate" ledger's values at
      those points (0.9999999965) are an instrument artifact
      (GPU full-tail blind spot, section 5), not a true margin.
  What we CAN say with the evidence in hand: the room's door is
  a factor-2 margin shortfall at the worst straddles, caused
  by a reconstruction that is the exact negative of zeta there
  (a pipeline artifact, identified down to the component class:
  the GPU full tail, not the zeta/quad/product math, not the
  f64 totals, not the precision level); plus a data-free wire
  that is within a factor ~3 of the data at the frontier; plus
  a clause (absolute O(1)) whose truth or falsity at the zeros
  is a named open problem with both ends surveyed (3.7, 3.8).

## 7. The doors, ranked (when we decide to keep going)

  D1  Audit the GPU vs CPU full tail (pole chunk + A/B seam,
      chunk-by-chunk diff at 3-5 heights), name the mechanism,
      add the missing full-tail selftest, fix the engine.
      Cost: one GPU-box session, hours. Effect: tells us whether
      the 696-point fill is re-issuable at certificate grade —
      the single most direct path to "the room works."
  D2  CPU-reference re-issue of the 696-point fill (no engine
      fix needed; day048 pace ~180 min per 10 points x 4
      workers on this box -> 696 points ~ 4-8 days single-box;
      fleet-able once D1 lands the selftest). Effect: the true
      margin map of the band — Holmes-complete data: every
      straddle, CRT grade.
  D3  The absolute-O(1) clause itself: zero-scale transfer
      theorem (prove O(1)/gap-away, or refute at the zeros).
      Frontier difficulty; the direct gap-transfer route is a
      documented dead end (3.7); the distribution line
      (Selberg-CLT-at-the-zeros) is the surviving route.
  D4  The argument-principle line in Lean (ap1-ap3): make the
      classical S-identity and the 17/8 telescope house-PROVEN
      instead of CITED. Prettier door; mathlib has no
      argumentPrinciple/windingNumber in the pin (scouted);
      Zeta23's Backlund port is the borrow candidate ([A1G-6]).
  D5  Push the data beyond 3e10 (the next band): the growth
      scales (1.78..2.96 at 3e10) will start to separate
      "truly O(1)" from "slowly growing"; the census of |DN|
      at zeros gains a second decade. Needs the owner's go
      (new band, fleet, 2-core reservation).

## 8. Evidence appendix

  Data (read-only, bit-pinned):
    scripts/rh/h1_final_fleet/   (696/696 ledger, VERIFICATION.md,
                              MD5SUMS.txt, per-machine subdirs)
    scripts/rh/out_day048_pts/   (re-issue .res + SUMMARY.txt)
    scripts/rh/out_pi_probe.txt  (the day049a pi-probe output)
    results/3E10-EPSILON.md      (the A2 walk certificate)
    scripts/rh/ckpt_h1_3e10/ + the 5900x ckpt rows (fleet
    source, the pre-merge local rows — the ones containing the
    0.9999999965 artifact values)
  Code:
    scripts/rh/day037_h1_3e10.py (CPU reference engine, VERBATIM
                             imported by day048/049a)
    scripts/rh/day048_reissue_prec.py (the re-issue protocol)
    scripts/rh/day049a_pi_probe.py (the pi-probe, this pass)
    scripts/rh/day038_h1_3e10_gpu.py (the fleet GPU engine;
      row format at _point_row; SELFTEST(c)/(f) scope in its
      docstring; last modified e180eae, before the fleet)
  Lean (LP; lake build green, 14/14, zero sorry):
    formal/RhAttack/A1Growth.lean (growth-form wire; explicit
                                   Trudgian wire; frontier pins)
    formal/RhAttack/W2M6.lean     (K_mil pins; channel >= 70;
                                   refutation at the pin;
                                   Trudgian attribution note)
    formal/RhAttack/ZetaZeroSet.lean + P12Uniform.lean (the
                                   conditional closure, LP)
    formal/RH-LEAN-PROVENANCE.md  (A1G-1..A1G-7 citation pins)
  Literature (CIT, verified online this pass):
    Trudgian, arXiv:1208.5846 (Th. 1: 0.111/0.275/2.450, T >= e)
    Platt-Trudgian 2015 via arXiv:2010.13307 (0.11/0.29/2.29;
      "no unconditional improvement on S = O(log t)")
    arXiv:1706.08268 (S(gamma+H)-S(gamma-H): no satisfactory
      results — the zeros-restricted frontier)
    Carneiro-Chandee-Milinovich, arXiv:1503.00955 (RH
      (1/4)log/loglog, simple proof; the Ole Miss "new_S(t)"
      paper is this line)
    Zeta23 (github.com/anthropics/zeta-23-lean) Backlund port
    (borrow candidate, not imported)
    CCM arXiv:1309.1526 (Thm 2 form, carried as cited premises
      in A1Growth.a1_growth_wire_ccm)

  Nothing in this file is a date; git is the timestamp
  authority. Nothing here asserts more than the legend marks.
