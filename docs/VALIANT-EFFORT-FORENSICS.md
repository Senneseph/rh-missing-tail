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
   three machines: an 8x-RTX-4090 volume, a v100 box, and a
   third machine (32 GB VRAM); 696/696
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
  The third machine's ledger, stored on this disk -- 180-row
  distribution of the mnew column:
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
  intact — versus the GPU fleet path, whose point ASSEMBLY
  (the exponent stack feeding Kfull) never had an independent
  check of any kind.  Section 5 (corrected) shows that is
  exactly where it broke:  the ledger's assembled K is ~0 in
  every row,  and the 1 - eps columns are dev in disguise.

  The question "is 0.502 just FP noise near the 0.5 threshold, or
  a planted round number?" answers itself from the geometry.  In
  the measured anti-parallel configuration (phase(K) - phase(z) =
  pi) the residual is residf = |z| + |K| and the margin reduces
  EXACTLY to margin = 1 / (1 + |K|/|z|).  The two re-issued worst
  points measure |K|/|z| = 0.990941 (x = 3.23481e9, margin
  0.502276) and 0.989404 (x = 3.49074e9, margin 0.502658):  each
  independently measured amplitude ratio reproduces its margin to
  5 digits, and the margin ramps smoothly with x (0.50228 ->
  0.50363 across the worst-10).  A planted value (or FP noise
  around 0.5) would not carry the geometrically consistent
  per-point ratio.  So 0.502 is structure, not noise:  the margin
  is the reciprocal-amplitude form 1/(1 + c) with c ~ 0.99
  measured.  The remaining open question is why the true
  anti-parallel K and the fleet instrument's K differ at all
  (section 5);  the discriminating experiments are running below.

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

  ### 3.9 The CLT line, pinned item by item (online research pass)
  The D3 surviving route (distribution line) re-surveyed against the
  2024-26 literature, each pinned paper classified:
    P1  arXiv:2507.04150 (Fazzari-Gerspach-Minelli),
        read in full.  SETUP:  N_phi(t) = sum over zeros
        of phi( (log T / 2 pi) (gamma - t) )  (the Hughes-
        Rudnick mock zero-count),  phi even,  phi^ smooth
        compactly supported,  eta = half-width of  supp
        phi^  (in mean-spacing units).  Theorems:
          T1.1  (unconditional):  for fixed h, l,  even k,
                supp phi^  in  (-2/(k+2),  2/(k+2)),
                (1/T) int_T^{2T} (log zeta)^h (conj)^l
                (N_phi - phi^(0))^k dt  =  1(h=l) mu_k
                sigma_phi^k h! (loglog T)^h + O((loglog T)^h'/2).
                COROLLARY 1.3:  log zeta(1/2 + i tau_k) /
                sqrt(loglog T) -> complex N(0,1)  under the
                zero-weighted measure  dmu = |N_phi - phi^(0)|^k
                dt / C   (the t-average is REWEIGHTED toward
                zero-statistic fluctuations).
          T1.2  (RH):  the IMAGINARY PART  Im log zeta = the
                argument  (hence  pi . S)  extends to the
                NATURAL BARRIER  supp phi^  in  (-2/k,  2/k)
                (the full Hughes-Rudnick support).  COROLLARY
                1.4  (RH):  pi . S(1/2 + i tau_k) /
                sqrt((1/2) loglog T) -> N(0,1)  zero-weighted
                (no variance suppression at the zeros).
          PROP 1.5  (RH):  correlation  (1/T) int log zeta .
                (N_phi - phi^(0)) dt = -phi(0)/2 + O(sqrt
                (loglog T) / log T);  the correlation coefficient
                decays  ~  1/sqrt(loglog T)  --  log zeta and
                the local zero statistic are  ASYMPTOTICALLY
                INDEPENDENT,  but only at a slow polyloglog rate.
        ROLE FOR E19:  this IS the zero-weighted S-CLT (the
        argument-side one):  it is a theorem,  not data,  that
        S stays fully Gaussian at zero-weighted points  (RH-
        conditional for the barrier support;  the unconditional
        complex-CLT half  (T1.1/C1.3)  already covers  Im log
        zeta with the restricted  2/(k+2)  support).
        Consequences:  (a)  the  S-level  flat-at-zeros  clause
        is refuted in the limit  (P1  + P2  +  classical  omegas,
        all mutually consistent with the day054 data);  (b)
        by  Prop 1.5  the leading  sqrt(loglog)  fluctuation
        SURVIVES the zero-weighting (independence,  no cancel-  
        lation),  so any flatness of the  WIRE-COMBINED  margin
        would have to live in the SECONDARY terms  (beyond the
        leading  Gaussian  scale)  --  exactly  the  secondary-
        term  regime  P3/P4/P5  study;  (c)  no  effective  T0
        (asymptotic  moment  theorem)  --  the  empirical  zero-
        scale  margin  measurement  (day056,  section  3.10)
        is  the  effective  counterpart.
    P2  arXiv:2510.14309 (Inoue-Kobayashi-Toma,  v2 2026).  
        Theorem 1 (RH,  EXPLICIT):  for  h in  [C/log T,
        c/loglog T],  sup_{t in [T,2T]} +/-(S(t+h)-S(t)) >=
        (1-E) . sqrt(h log T / pi)  with explicit E  ≈ sqrt(h
        loglog T)  + min-terms.  Zero-scale oscillation of S
        quantified under RH at the zero scale (h ~ 1/log T gives
        (1-o(1)) . sqrt(2/pi)).  Theorem 2 (RH):  r-gap
        constants improved to sqrt(2/r) -- the S-oscillation
        is used exactly via the RVM integral (N(t+h)-N(t) is
        an integer in between).  Theorem 3:  the M-O/resonance
        method's barrier (lambda_1 >= 3.022,  mu_1 <= 0.508).
        Method:  resonance (Soundararajan,  Bondarenko-Seip,
        Montgomery-Odlyzko lineage).
    P3  arXiv:2407.14867 (Wang,  to appear Lit. Math. J.).
        UNCONDITIONAL moment asymptotics + weighted CLT for
        S(t,f) ~ sqrt(loglog q)  in the LEVEL aspect (prime-
        level cusp forms).  Family-direction template:  the
        non-degenerate sqrt(loglog) S-distribution exists as a
        theorem once the parameter is a family -- not yet for
        zeta in the t-direction.
    P4  arXiv:2505.23573 (Yu).  UNCONDITIONAL Selberg-type
        zero-density (twisted GL2 family) + CLT for the
        argument over the character family.  Second template;
        the zero-density engine is the shared ingredient.
    P5  arXiv:2511.18275 (Jerby,  v2 2025-12),  read for
        this  purpose.  Under  RH:  Montgomery  pair  cor-
        relation  for  the  zeros  of  Hardy's  Z-function.  
        Mechanism  (exact):  a  finite-dimensional  variational
        space  of  sections  Z_N(t;a)  approximating  Z  on
        windows  [2N,2N+2];  the  "real  hall"  RH_N  =  the
        sections  whose  zeros  stay  real  and  simple  under
        homotopy  --  the  coefficient  space  IS  the  ensemble;
        any  admissible  measure  with  smooth  positive
        density  on  it  gives,  via  a  Skorokhod  SDE  with
        reflection  at  the  discriminant  boundary,  unfolded-  
        zero  dynamics  equal  in  law  to  Dyson  BM  beta=2
        in  the  bulk  -->  (modern  DBM/log-gas  universality)
        ensemble-averaged  local  pair  correlation  ->  GUE
        sine  kernel.  The  UPGRADE  to  the  deterministic  Z
        zeros:  the  CANONICAL  section  Z_N(t;1)  over  distinct
        windows  is  shown  to  behave  like  decorrelated
        samples  of  the  GUE  ensemble  --  and  the
        decorrelation  step  is  exactly  WHERE  "Selberg's
        probabilistic  theory  of  S(t)"  is  invoked  (S's
        oscillation  is  the  INPUT  mixing  mechanism,  not
        the  OUTPUT).  D3  ROLE:  P5  is  the  zero-STATISTICS
        side  under  RH;  with  P1  (S  stays  fully  Gaussian
        even  under  zero-weighting,  leading-order  indepen-  
        dence  of  S  vs  zero  statistics)  it  gives  the
        complete  asymptotic  under-RH  picture:  BOTH  sides
        fully  random,  no  flatness  anywhere  at  leading
        order.  P5  does  NOT  deliver  a  zero-restricted  
        value  distribution  for  S  itself  (none  of  P1-P5
        does,  effectively);  it  is  new,  RH-conditional,  
        asymptotic  (no  T0);  treat  the  main  theorem  with
        appropriate  caution  (a  proven-MC-under-RH  claim  
        of  this  size  will  take  time  to  settle  in  peer
        review)  while  the  machinery  (real  hall  +  SDE-
        reflection  +  S-mixing  upgrade)  is  a  concrete
        in-house  source  for  the  zero-side  half  of  any
        future  D3  formalization.
  Reading for D3 (updated after the P1 full read):  the flat
    clause  |S(gamma)| <= C  is refuted in the limit by theorem
    --  P1  (zero-WEIGHTED S-CLT:  S  stays  fully  Gaussian,
    variance  (1/2) loglog T,  at zero-weighted points;  under
    RH  up  to  the  2/k  barrier;  unconditionally  via  the
    complex-CLT  half  at  the  restricted  2/(k+2)  support)
    +  P2  (zero-scale  oscillation  (1-o(1)) sqrt(c'/pi))
    +  the  classical  zeros-omegas  (3.7).  Prop 1.5  adds the
    mechanism  verdict:  the  leading  sqrt(loglog)  fluctuation
    is  ASYMPTOTICALLY  INDEPENDENT  of  the  local  zero  stat-
    istic  (correlation  ~  1/sqrt(loglog T),  slow  decay),  so
    no  leading-order  cancellation  at  zeros  exists  to  ex-
    plain  a  flat  clause;  any  flatness  must  be  a  second-
    ary-term  property  of  the  specific  wire  combination.
    What  remains  open:  (i)  the  EFFECTIVE  zero-restricted
    t-direction  S-CLT  with  an  explicit  T0  (none  published
    --  all  CLT  lines  are  asymptotic;  P5  is  the  closest
    machinery  and  assumes  RH);  (ii)  whether  the  margin
    itself  (wire-combined,  not  S  alone)  is  flat  at  zero
    resolution  --  the  day056  single-zero  margin  sweep
    (3.10)  is  the  empirical  adjudication  of  exactly  that.

### 3.10 Zero-scale oscillation:  P2 read in full + the measured
          zero-scale smoothness, and the single-zero test
  P2 (Inoue-Kobayashi-Toma) read in full this session (8-page
  PDF,  theorem statements extracted):
    (i)  Theorem 1 (RH,  effective):  for every large T and
         every h in [C/log T,  c/loglog T] (absolute C large,
         c small),  sup over t in [T,2T] of +/-(S(t+h)-S(t))
         >= (1-E) sqrt(h log T / pi),  E an explicit sum of a
         pi h loglog T term and a minimum of algebraic
         loglog/log terms.  AT THE EXACT ZERO SCALE h = c'/log
         T every E-term tends to 0 (the first as loglog T/
         log T,  the second as (loglog T)^{3/2}/sqrt(log T)),
         so the zero-scale increment is  (1-o(1)) .
         sqrt(c'/pi)  --  ~0.56  at  c' = 1.  This is the
         quantitative refutation mechanism for any  "S is
         flat at the zero scale"  clause  (RH-conditional,
         counting-only,  no gap transfer).
    (ii) Definition used:  S(t)  =  (1/pi) arg zeta(1/2+it)
         =  (1/pi) Im int_{1}^{1/2+it}  zeta'/zeta  (the
         horizontal-line integral form -- the same object the
         in-house D4 line now manipulates in Lean).
    (iii) Theorem 3 pins the M-O/resonance barrier (large
         gaps <= ~3.022,  small >= ~0.508,  L <= T),  so the
         sqrt(2/r) constants of Theorem 2 are optimal for that
         method;  the route to sharper statements is the
         Hall/Bui-Milinovich side,  not resonance.
  MEASURED zero-scale smoothness (505-point ledger,
  reissue 3e10):
    The ledger's k-layers are SLIDING t-windows of width
    5.0 stepped by 0.5.  At the band scale the zero
    density is (1/2pi) log(t/2pi) ~ 3.1 per unit t,  so a
    width-5.0 window embraces ~16 zeros  and  a 0.5 step
    is ~1.7 zero-spacings.  Across all 483 adjacent-in-t
    pairs:  min dmnew = -3.19e-4,  max = +3.14e-4,
    median = -8e-8,  max |dmnew| = 3.19e-4,  p99 |dmnew|
    = 1.79e-4.  THE DATA-FREE MARGIN IS FLAT AT ZERO-
    SCALE-NEIGHBORING RESOLUTION:  windows shifted by 0.5
    in t  (~2 zero-spacings,  ~98% overlap)  move the
    margin by at most ~3e-4.
  S-SIDE SINGLE-ZERO SWEEP (this session,  scripts/rh/
  s0_singlezero_swalk.py,  dps-25 vs dps-45 identical to
  6 digits):  S(t) = (1/pi) arg zeta(1/2+it),  continuous
  branch,  stepped by 0.025  (a quarter zero-spacing)
  over 5 t-units  at the band-head anchor (t0 ~ 3.23217e9
  region)  and at 1e10:  per-step S-increments ~0.08
  median,  ~0.14 mean  (S units),  with the 15-16 steps
  crossing a zero showing S-jumps ~0.92  (a +1 zero jump
  with in-step drift cancelling part of it).  The 15-16
  crossings in 5 units  MATCH THE RVM PREDICTION ~15.9
  for that window,  and  every crossing is on the
  critical line at sigma = 1/2  (a weak local RH-
  consistency signal,  not a proof).  Against P2:  the
  sqrt(h log T / pi)  scale at h = 0.025 is ~0.42  (S
  units,  a SUP lower bound over the dyadic):  the
  measured typical smooth increment  (0.08-0.14)  and the
  crossing events  (~0.92)  bracket it as expected.  The
  data is QUALITATIVELY CONSISTENT WITH P2'S ZERO-SCALE
  OSCILLATION at true zero resolution.
  The tension,  quantified:  at TRUE zero resolution the
  S function IS rough  (smooth increments ~0.08-0.14 per
  quarter-spacing,  +~1 per crossing,  O(1) wandering),
  while the margin is flat to 3e-4 at 0.5 shifts.
  Compatibility requires the margin's S-dependence to be
  (a)  WINDOW-AVERAGED  (width 5.0 vs spacing ~0.29:  S
  structure integrates out),  (b)  BOUNDED OFF  (an O(1)
  contribution absorbed into the 0.502 baseline),  or
  (c)  CANCELLED IN THE WIRE  (the RVM identity now house-
  PROVEN in Lean is exactly the mechanism that can cancel
  the S-term against the N-count side of the certificate).
  The flat-at-zeros clause is still NOT adjudicated:  the
  ledger  (window resolution)  cannot see the S structure;
  the S-side at single-zero resolution is confirmed rough
  --  so the margin's flatness at zero scale,  if real,  is
  an S-INSENSITIVITY property of the certificate,  which
  the in-house wire |S1-R| <= G(xM) . (17/8) . t^2/g1^2
  now makes a PROVABLE statement about.
  NAMED EXPERIMENT (engine-side single-zero sweep):
  re-evaluate the margin (or the pre-normalization S1-R
  residual) itself at t-resolution ~0.02-0.05  (one zero
  per step)  at the two anchors -- e.g.  200 steps each
  with the day037 engine at dps-30,  or a margin-only fast
  pass -- and compare its single-step deltas with the S-
  side deltas just measured.  Roughness tracking the S-side
  size  =>  the margin does carry the zero-scale S
  structure  and P2's oscillation lower bound becomes the
  in-data refutation mechanism for any flat clause;
  continued smoothness  =>  the margin is provably S-
  insensitive at zero scale  (the wire's S-contribution is
  cancelled/averaged)  and the flat-clause question moves
  entirely to the main-term  (G = C log)  side.  Formal
  counterpart:  the D4 line  (ap1-ap4,  all house-PROVEN
  this session)  supplies the exact wire,  so the S-
  sensitivity of the margin is now a PROVEN computable
  quantity,  not an assertion.

  [ADJUDICATED -- section 3.11:  the experiment was run as
  the s3 ledger-reconstruction sweep;  the FIRST branch
  fired:  the margin carries zero-scale structure  (see
  3.11(4)).]

### 3.11  The squeeze identity decoded,  and the single-zero
          door adjudicated  (DOOR B)
  (1)  THE IDENTITY.  One arithmetic pass over  (Kabs,
       zeta,  residf)  per ledger row  (505 points,  22
       windows)  shows
           Kfull / zeta(1/2+it)  =  -c(t),  c(t) > 0 real,
       at ALL 505 certified points  (phase exactly pi  to
       >= 7 digits).  Hence  residf = (1+c(t))|zeta|  and
       mnew = dev/(1+c(t)) ~ 1/(1+c(t))  (dev ~ 1  exactly
       -- the straddle is empty of zeros by construction,
       R_closed ~ 3e-10,  Bdev ~ 5e-32;  pb ~ 1e-24).
       The margin is a PURE READOUT of the identity ratio;
       the 505 band rise  0.502 -> 0.826  is exactly
       1/(1+c(x))  with  c = 0.9909 (3.23e9)  ...  0.2111
       (2.79e10)  collapsing near G_LAST = 3.0001e10.
  (2)  THE RECONSTRUCTION  (s3,  scripts/rh/s3_ledger_
       recon_margin_sweep.py).  Kfull rebuilt at any t
       from the ledger's own recorded parts  (re, im at
       the nearest row)  plus corrections:  la/ar  BIT-
       EXACT re-evaluation of the engine's _prod_budget_
       day034 over M.GN  (verified:  max diff 0.0 against
       the ledger rows);  re = row-re + near-window log-
       kernel difference  (window 1.5);  im = row-im +
       pi-sawtooth + exact smooth-im window;  quadrature
       (G_LAST, 1e18] + (1e18, 1e30]  120 log-nodes
       dps-30;  zeta dps-30;  dev over the 500-d grid.
       GATE:  all 18 ledger rows of the three anchors
       (3.23e9,  7.54e9,  2.79e10)  reproduced to
       max |dmnew| = 9.6e-9 < 1e-5  (100x tighter than
       the engine's own Bexp budget 3.9e-4).
  (3)  THE QUADRATURE  (a near-miss worth recording).  The
       far integral
           int_{G_LAST}^{1e30} bracket(g) (ln g/2pi) dg
       =  -1.2929983e9  (window A,  t ~ 3.2e9):  the
       integrand is O(2e9)/ln-unit at the lower limit
       (h(u) ~ t^2 e^{-u} (u/2pi)^2),  so O(1e9) values
       are EXPECTED.  Verified three ways:  mp.quad 400-
       node log-quad  (the engine's exact call)  gives
       -1292998320.49;  mp.quad tanh-sinh dps-35 on clean
       two-point u-intervals  gives -1292998324.50;  a
       1e6-point u-grid trapezoid  gives -1292998230.52.
       All agree to 1e-3 absolute on the 1.29e9 exponent.
       TWO TRAPS  (for the record):  integrating in ln-
       space instead of g-space  (wrong measure:  the RVM
       density is dN = (ln g/2pi) dg,  not
       (ln g/2pi) dln g)  gives -0.02;  and a complex128
       g-linear trapezoid over 15 octaves  gives 10x-
       1000x garbage.
  (4)  THE DOOR  (the named experiment of 3.10,  first
       branch).  At the true 0.025 step  (one zero-
       spacing;  357 steps,  three ~3-unit windows),  the
       margin is ROUGH:  |dm| median 4.4e-3,  p99 8.7e-2,
       max 1.7e-1  (per-window medians 7.0e-3 / 5.1e-3 /
       5.8e-5;  means ~1.1e-2).  S at the same scale:
       |dS| median 0.08,  mean 0.25,  max 1.9  (twin-
       zero steps);  net S change +9.5 .. +12.5 over the
       ~3-unit grids  (= ~1 per zero,  by definition).
       The 505-point "flatness"  (max 3.2e-4 at the 0.5
       step)  is a SAMPLING ARTIFACT:  the 0.5 step is 20
       zero-spacings and averages the wiggle out.
       Alignment of the top margin steps with S-crossing
       steps is WEAK  (0-2 of 5  per anchor)  --  the
       margin is an ATTENUATED low-pass of the zero-scale
       S-flow  (via the identity ratio  c(t)),  not a
       replica of it.
  (5)  CONSEQUENCES.
       (a)  The 3.8/3.10 "tension"  resolves:  S rough at
           zero scale  (measured)  AND margin rough at
           zero scale  (measured)  --  correlated,  no
           tension;  the margin's zero-scale wiggle IS
           the S-flow of the discrete product,  absorbed
           into the identity ratio  c(t)  by the Efull
           identity.
       (b)  The program's one open clause is UNCHANGED:
           E1 / (CL)  =  |DN| <= K uniform at zero heights
           =  S = O(1) at the zeros  --  open
           unconditionally  (3.8 citations),  refuted in
           the limit under RH  (P1 zero-weighted CLT;
           P2 zero-scale oscillation;  the measured |dS|
           mean 0.25 per 0.025 step at 3e10 sits inside
           P2's oscillation bound).  The squeeze was a
           zero-EXCLUSION certificate all along  (an off-
           line zero at offset d lifts the margin by ~
           (d/(t-g))^2 . c/(1+c):  d = 0.1  ->  +3.7e-2,
           ~100x the 0.5-step certificate floor 3e-4),
           not a flat-clause carrier.
       (c)  DOOR B is the adjudication:  the 505-level
           "flat clause" hypothesis  (margin structurally
           flat at zeros)  is REFUTED at true resolution;
           the re-scoped verified-theorem statement
           stands:  RH verified to 3e10  (data + wire +
           squeeze as zero-exclusion),  the far-side
           counts O(log t)-constrained  (A1Growth),  and
           the margin's growth shape  (window-constant
           1/(1+c(x))  plus a zero-scale S-flow wiggle of
           measured amplitude)  as the explicit sub-RH
           content.
       (d)  Queued,  not load-bearing:  the closed form of
           c(t)  (the explicit factor of the Efull
           identity:  window-constant part + zero-scale
           wiggle)  --  a one-line theorem once the
           wiggle's carrier  (the product's own S-flow)
           is named and the window-constant part matched
           to the kernel normalization.

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

## 5. The instrument's blind spot (the key forensic finding, corrected)

  The initial reading ("the GPU tail and the CPU reference
  disagree at the unit level in K at the worst straddles") was
  WRONG about the tail.  The tail is FAITHFUL, and the real
  finding is sharper: the fleet's point EVALUATION assembled a
  K that is ~0 -- at every point, on every row, on every
  machine.

  (a) The tail is settled.  At p01, four independent pipelines
      now agree on the tail totals (re, im) to ~1e-9 relative:
      the day037 CPU engine (day048, bit-replicated in-stream),
      an independent 80-bit-exact longdouble tree (day048), the
      day038 iGPU fleet path re-run TODAY (day049c, 8 threads:
      re = -1519600917.8097978, im = 33332178583.221424, nlt
      exact), and V4 (day049b/2, a fresh windowed f64/f128
      pipeline whose coverage arithmetic reconciles with the
      engine to the last element once the A/B stitch and the C
      section are applied -- the v1 run's delta from the engine
      was EXACTLY the un-stitched A/B overlap block plus the
      missing C section, which independently verified the
      engine's stream composition).  re = -1.5196009178e9,
      im = 3.3332178583e10 (+ nlt*pi).
  (b) The ledger says K ~= 0 everywhere.  The recorded ledger
      rows for the whole p01 window (all k = -12..12 straddles,
      h1_final_fleet/5900x/ckpt/widx00_x3490744654.pts) show
      residf = zeta -- the |z| column -- to EVERY printed digit
      in EVERY row (p01: residf = 1.3075849021 vs zeta =
      1.307585; the k = -2 row: residf = 25.0236256388 vs
      zeta = 25.023626).  residf = |z - Kfull| = |z| means
      Kfull ~= 0 at every point the fleet evaluated -- not a
      worst-straddle effect, a GLOBAL assembly effect.
  (c) Why the ledger then reads 1 - eps.  The margin is
      mnew = |z|*dev/(pb + residf); with residf = |z| it
      reduces to mnew ~= dev -- and dev at these straddles is
      1 - 3.5e-9 BY CONSTRUCTION (the straddle points measure
      the squeeze precisely by dev).  The certificate is
      mcert = z_cert*dev_cert/(pb + residf + dK + B_z) with dK
      scaling with |K|: at K = 0 it degenerates to
      mcert ~= dev ~= 1.  The recorded 696/696 "mcert =
      1.0000" certificate was therefore a DEGENERATE PASS
      (dev-grade), never a certified squeeze margin.  The C-3
      event stands exactly as logged: the certificate-level
      claim at the worst straddles fails, because the true
      margins are ~0.502 (section 3.4) and the ledger's pass
      values are the dev column in disguise.
  (d) How K became 0.  The exponent of Kfull is a four-term
      cancellation of O(1e9) numbers down to O(1): lm (the log
      of the DLMF 25.2.12 main factor) ~= +2.7416e9 real part,
      la (the log of the (0,1e7] zero product) ~= +0.2866e9,
      re (the full tail's log) ~= -1.5196e9, and q (the two
      log-weighted remainder integrals) ~= -1.5086e9 --
      summing to +0.2574 = log(1.2938) = log|K| (pi-probe
      verified the stack dps-invariant at 30/45/90/120).
      Losing -- or offsetting by ~1e9 -- any one of {lm, la,
      re} drives the real part to ~ -0.3e9 .. -2.7e9, i.e.
      K = 0 to any practical precision: at dps-30 anything
      below ~1e-30 rounds to 0 against |z| ~ O(1) in the
      subtraction, and mpmath's e^{-1e9} is an exact tiny mpf
      that the dps-30 context erases.
  (e) Why nothing on the fleet caught it.  The ledger's B
      columns (Bexp 4.022e-4, Btail_re 4.000e-4, Bqrem
      1.527e-21, Bz 6.795e-22, ...) are dps-30/60 SPREADS per
      component -- they certify stability, not absolute
      correctness: a component ~1e9 off but dps-stable is
      invisible to them.  The fleet selftests (c: GPU == CPU
      on the overlap patch; f: GPU-threaded == GPU-sequential)
      cover the TAIL's summation only; the assembly gets no
      selftest at all (there is no check like "|Kfull| is
      O(|z|)" or "residf < |z| at a pre-issued control
      point").  The whole pipeline can assemble K = 0 on every
      machine and every diagnostic still passes.  The blind
      spot is the point ASSEMBLY, not the tail.
  (f) ROOT CAUSE (named,  from the committed code):  the
      3e10-generation quad_pair (day037 CPU and day038 GPU,
      identical) returns
            rem = 400-node quad over (G_LAST, 1e18]
            ext = 400-node quad over (G_LAST, 1e30]   <- the
                     FULL remainder,  containing rem's range
      and cert_point / ev_point multiply BOTH into Kfull:
            Kfull *= exp(rem)      (G_LAST .. 1e18)
            Kfull *= exp(ext)      (G_LAST .. 1e30,  so the
                                    (G_LAST, 1e18) region is
                                    counted TWICE)
      The real part of the doubly-counted region is
      -1.508628600e9,  so the real part of Kfull's exponent
      drops from the true +0.2574 (= log 1.2938 = log|K|) to
      ~ -1.508628e9:  Kfull = e^{-1.51e9} rounds to 0 at
      dps-30,  residf = |z - 0| = |z| to 10 digits,  and
      mnew = |z|*dev/(pb + |z|) = dev = 1 - 3.5e-9 =
      0.9999999965 -- the ledger's mnew AND mcert to 10
      digits,  on every row,  every machine,  deterministically.
      The 1e7/1e9-generation quad_pair (day034) uses the
      ADJACENT form (ext over (1e18, 1e30]);  the 3e10 port
      changed ext to the full range (to make the B_qext budget
      cover the whole remainder) without adjusting the
      composition -- the porting slip.
  (g) Verification (day049e,  running on this box):  two
      point passes at p01 through day038's own cert_point,
      fleet path (8-thread GPU) --
        A) the fleet code VERBATIM:  expected to reproduce
           the ledger row exactly (mnew = 0.9999999965,
           residf = 1.3075849021,  and the fingerprint
           Efull ~ +1.508628600e9,  cert_point's own
           diagnostic,  not a ledger column);
        B) with the two-line fix (quad_pair's ext computed
           over the adjacent (1e18, 1e30] piece):  expected
           to land at the CRT-verified margin 0.502658
           (residf 2.601338,  |K| 1.293756,  Efull +0.0108).
      The pure-math level of B is ALREADY confirmed (CPU
      probe,  dps-60,  engine f64 tail totals,  patched
      composition):  |K| = 1.29375561063,  residf =
      2.60134051277,  Efull = +0.010633,  margin =
      0.5026581069 -- the CRT-verified V2 value
      (0.502658103672) to 1e-8.  The LANDED confirmations:
      the first day049e A) pass (the pre-patch fleet
      module,  8-thread GPU tail;  a json wrap glitch lost
      its printed row) printed the nested q-terms inside
      the fleet module itself (qrem re = -1.508628600e9
      over (G_LAST, 1e18];  qext re = -1.508628679e9 over
      (G_LAST, 1e30],  the NESTED full remainder;  the
      piece by difference,  -78.7544122433,  matches a
      direct adjacent quadrature to 12 digits).  The
      verbatim fingerprint was then completed
      composition-side on the EXACT pre-patch fleet module
      (git show of the committed file,  dps-30,  engine
      f64 tail totals):  mnew = 0.9999999965 and residf =
      1.3075849021 -- the ledger's two signature columns
      to ALL 10 printed digits -- with |K| ~ 0 and Efull =
      +1508628600.27 (the predicted +1.508628600e9
      fingerprint).  And the fixed composition through the
      full fleet GPU machinery at p01 (8-thread tail
      sweep,  adjacent pieces):  mnew = 0.50265809882
      (CRT V2 0.502658103672 to 5e-9),  residf =
      2.60134055470,  mcert = 0.50253253632 (a real,
      non-degenerate certificate),  Efull = +0.0106325,
      nlt exact.  The pre/post states of the same module
      differ by exactly the ledger-vs-truth difference:
      the mechanism is proven,  not merely suspected.  An
      independent accidental replica of the bug (my V4b
      pipeline,  which used the same nested pair by
      mistake) separately reproduced the ledger margin to
      all 10 printed digits (0.999999996538).  Final B line
      (in-memory rebind path,  same 8-thread GPU tail):
      mnew = 0.5026580988241343 -- identical to the A line
      to 2e-16,  |K| = 1.29375629943,  and K exactly
      ANTI-PARALLEL to z (phase -3.1416 rad):  the
      0.502 = 1/(1 + c) geometric signature (section 3.4)
      reproduced through the fleet machinery itself.
      (Run 2's A/B lines are the POST-patch module in two
      independent in-memory forms;  the pre-patch verbatim
      counterpart is the composition probe above,  and the
      first A pass is the lost-line GPU run noted in 5g.)  The on-disk fix (day037 + day038) is
      committed alongside,  plus the missing assembly
      selftest (two lines in cert_point:  |Kfull| must be
      O(|z|);  the 3e10 pipeline can now never again ship a
      degenerate row as "ok").

  Blast radius (audited this pass):  day037 (3e10 CPU) and
  day038 (3e10 GPU) carry the nested pair -- the only
  certified-margin pipeline of the 3e10 generation,  whose
  696-row fill is the affected artifact (and anything
  derived from it).  day029/day034/day034b (the 1e9/3e9/1e7
  certificate era) use the adjacent form:  unaffected.
  day048/day049a (this week's re-issues) use the adjacent
  form:  unaffected -- which is exactly why the re-issued
  true margins (0.502658) were correct all along.  The 3e10
  fleet's "696/696 certificate" claim is therefore void at
  certificate grade (every ledger row is the dev column in
  disguise);  the SCREEN-level fill (which points were
  evaluated,  nlt,  budgets,  flags) remains valid.  The
  re-issue (D2) is a fleet run of the fixed engine.

  **5.1 Anti-poisoning signature scan (five signatures, re-read
  after (b)-(f)).**
  The question "accidental bug vs planted value" is answered by
  signatures, not by vibes:
    (1) the AT-PASS-LINE LAW-SHAPED reading.  A plant that
        makes the line look pass would read like a pass:
        1 - eps.  The ledger's worst-straddle mnew column IS
        law-shaped 1 - 4.6e-9 to 9 digits; the re-issued truth
        is not (0.502).  Status: SUPERSEDED -- the 1 - eps is
        now MECHANICALLY EXPLAINED (item c: with K = 0 the
        margin reduces to mnew ~= dev ~= 1 - 3.5e-9 by
        construction).  A law-shaped pass reading that the
        instrument's own arithmetic produces is the signature
        of an instrument fault, not of a plant.
    (2) the ROUND-CONSTANT DECOMPOSITION.  If 0.502 were a
        plant, it should look arbitrary or round; it
        decomposes exactly as 1/(1 + c) with c measured
        independently per point (0.990941, 0.989404) and a
        smooth x-ramp.  Status: kills 0.502-as-plant.
    (3) the MACHINE-SPECIFIC FINGERPRINT.  A one-off machine
        hack (local memory corruption, a single GPU's glitch)
        is falsified by 3 machines on 2 GPU stacks (CUDA-4090,
        CUDA-v100, ROCm-Strix) being 466/466 bit-identical for
        the fill; and the K ~= 0 effect, had it come from
        machine state (GPU memory), could not be bit-identical
        across machines -- it is a DETERMINISTIC assembly /
        environment effect shared by all three.  Status:
        machine-specific causes dead.
    (4) the MECHANISM-SHAPE -- RESOLVED.  The bug localizes
        to a 2-line porting slip in the committed code
        (quad_pair's "ext" switched from an adjacent piece to
        a nested range during the 3e10 rewrite;  ev_point's
        multiplication of both terms kept as-is),  and its
        fix "reads" as a natural correction:  adjacent
        pieces (restoring day034's convention) + the two-line
        |K| ~ O(|z|) assembly selftest.  No magic constants,
        no environment dependence,  no per-machine or per-run
        state.  Status: CONFIRMED ACCIDENTAL -- the
        verbatim pre-patch fleet module reproduces the
        ledger row to all 10 printed digits (mnew,
        residf,  fingerprint Efull) and the patched module
        recovers the CRT margin (0.50265809882) through
        the full GPU fleet path.
    (5) the PROVENANCE GAPS.  Data layer: the fill consumed the
        band verbatim; source drift is KILLED by the live byte
        checks below (all four band md5s identical to the
        pre-fleet cross-machine record, including D at 740 GB).
        Code layer: day038 committed before the fleet
        (e180eae), unchanged since; its TAIL is now
        quadruple-verified (item a) and its ASSEMBLY (the
        lm/la/re/q stack feeding cert_point) is the remaining
        suspect surface -- plus the fleet run's python /
        maths-library environment, which is NOT in the repo
        (the gap day049d is built to close).
  Live results this pass (executed, not planned):
    - nlt live re-derivation: at all 180 heights where the
      local ledger records nlt, re-deriving the exact zero
      count below t from the CURRENT band files gives identical
      values, 0 mismatches.  The files produce exactly the
      zero-counts the fleet engine saw at run time.
    - band md5 live (A+B+C+D = 815 GB): all four byte-identical
      to the pre-fleet cross-machine record (A 7575f1e1..., B
      f54aa4ee..., C eeb9a361..., D 5baa1b07...).  Source
      drift is definitively closed; the band data is exactly
      what the fleet consumed.
    - fleet ledger cross-check (this pass, read-only): the
      whole p01 window's 24 rows carry residf = zeta to every
      printed digit (item b); VERIFICATION.md's 696/696 claim
      rested on the mcert column, which at K = 0 degenerates to
      dev-grade 1.0000 (item c).
  Net: the data layer is closed; the tail is closed (item
  a); the point assembly is closed by naming (item f); the
  remaining work is mechanical: day049e's A/B confirmations
  (running), the two-line fix + the missing assembly
  selftest (committed this pass), and the re-issue of the
  696-point fill (D2).

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
      those points (0.9999999965) are an instrument artifact:
      the fleet's point assembly degenerated to Kfull ~ 0,
      which makes the margin reduce to dev and the certificate
      to 1.0000 (section 5, items b-c), not a true margin.
  What we CAN say with the evidence in hand: the room's door is
  a factor-2 margin shortfall at the worst straddles, caused
  by a reconstruction that is the exact negative of zeta there
  (a pipeline artifact, identified down to the component class:
  the POINT ASSEMBLY's O(1e9) exponent stack lost or offset one
  term in the fleet run -- not the tail, which is now
  quadruple-verified; not the data, bit-pinned; not the
  zeta/quad/product math; not the precision level); plus a
  data-free wire that is within a factor ~3 of the data at the
  frontier; plus a clause (absolute O(1)) whose truth or
  falsity at the zeros is a named open problem with both ends
  surveyed (3.7, 3.8).

## 7. The doors, ranked (when we decide to keep going)

  D1  Audit the full tail AND the point assembly:  the
      slab-by-slab GPU-vs-CPU diff has LANDED (the tail is
      faithful:  GPU 8-thread total = CPU engine total = the
      80-bit tree);  the real fault is the ledger's assembled
      K ~ 0 (section 5, items b-f).  Cost:  hours on this box
      (it hosts the verified band and a ROCm GPU;  no
      rental).  RUNNING:  day049c per-slab CSV (closing),
      day049d (the fleet's own cert_point,  component table —
      the discriminator);  then the two-line missing selftest
      (|Kfull| ~ O(|z|) at pre-issued control points) and the
      re-issue of the fill.  Effect:  names where the ~1e9
      went (current code/env vs fleet-run environment) and
      whether the 696-point fill is re-issuable at certificate
      grade — the single most direct path to "the room works."
  D2  Re-issue of the degraded fill with the fixed engine.
      DONE (worst region):  day049f,  the worst-24 negative-k
      points (7 anchors in 3.2e9..5.13e9,  k = -12..-8),
      all 24 landed at dps-120 ld-exact:  margins
      0.502276..0.505784,  24/24 below the certificate line,
      fit  m = 0.496408 + 0.001780*(x/1e9) - 0.000004*k
      (x carries 99.5% of the variance,  k flat to 4e-6),
      dps-90/120 agree to 0,  the 8 shared day048 points
      reproduce to full printed precision,  and the two
      verify-engine points carry the bit-exact engine-replica
      margins agreeing with ld-exact to ~4e-7 (the f64-tail
      level).  RUNNING (owner GO,  this box,  14 of 16 cores):
      day052c_reissue_696_ledger.py,  the full IN-HAND 505-point
      ledger through the fixed engine's own certificate arm
      (f64 tail budgets,  dps-30/60 fast parts,  margin_new +
      margin_cert per point,  fleet's 21-column row format,
      resume-safe at POINT granularity,  selftest green at
      launch).  day052c is LEDGER-DRIVEN:  cert_point on the
      ledger's own (t, g) per point,  no zero lookup at all --
      the point set is exactly what the fleet ledger says  (the
      grid-driven day052b died in its smoke,  see D2a).  Cost
      model (unchanged by the vector multi-t dead end --  see
      day053 STATUS):  each point pays one full (1e7, G_LAST]
      band sweep,  ~70 min at the measured 14-way concurrency
      ceiling --  corrected by the first-wave pace data:  the
      per-point cost is slab_budget's ~12-16 GB of array traffic
      per 2^25 slab (memory-bandwidth-bound at ~1-2 GB/s per core
      under 14-way,  the drive itself does 5.9 GB/s),  ~240 min
      per point as measured,  ~3-5 days total for 505;  the
      engine's slab_budget was pass-minimized (A/B-verified
      bit-equal sub_sums and bit-exact B terms,  containment
      selftests (a)/(b)/(d) green) and the run moved to a
      SIMD-dispatch numpy (AVX-512 SKX) venv.  A 24-point smoke
      (the worst-24 points cross-checked
      against their deep day049f references:  pt00/pt01 against
      the bit-exact engine-replica margins,  the other 22
      against the dps-90 f64 and dps-120 ld-exact margins,
      every gate ~10x looser than the observed <=1.5e-6 spread
      and ~10^4 tighter than the clamp bug's 5e-3 signature)
      gates the full launch via an autolaunch supervisor.
      Effect:  the true certificate-grade ledger replaces the
      artifact one,  point for point.
  D2a  Smoke-caught engine bug + the true ledger scope
      (2026-09-30).  (i)  day037's nearest_zero indexed the
      band-only 740 GB D file (92.58e9 zeros in (2.999e9, 3.0e10])
      with GLOBAL zero offsets (d0 = 9.04e9,  as if the file were
      the full 812 GB tail).  For every anchor x below the band
      entry at file offset d0*8 (t = 5.7908e9) -- 8 of the 29
      windows --  the binary search clamps to that one zero;  the
      day052b smoke measured the consequence (0.50740 margin at
      the clamped straddle vs the ledger's true 0.50228 at the
      same (x, k)).  Fixed to file-local offsets;  verified
      bit-exact against the fleet ledger's own g values for six
      low-band anchors;  selftest(d) gates it at every launch.
      (ii)  The in-hand ledger --  union of the three fleet
      sources,  deduped by (k, x) -- is 505 points,  not the
      nominal 29 x 24 = 696:  191 (k, x) pairs were never
      generated (the fleet was shut down mid-run;  the
      long-known "505-pt interim reading" was this).  The
      re-issue covers exactly the 505 in-hand;  the 191 fill
      points are a separate optional follow-up (new data,  a
      different claim -- not a re-issue).
  D2-final  Re-issue complete -- the true 3e10 H1 ledger.
      All 505 in-hand points re-issued on the fixed engine
      (14 workers, 123 h;  smoke 24/24 bit-exact against the
      day049f references;  full run 0 flags).  Results
      (scripts/rh/out_day052c_696/interpret.md):
      - certificate census:  505/505 mcert < 1;  zero rows
        on or above the certificate line;  zero flags.
      - worst point:  x = 3.2322e9 (band head),  margin
        0.502275 -- exactly the worst-24 prediction;  best
        0.825703 at x = 2.7884e10.
      - margins rise smoothly and monotonically in x
        (per-anchor means 0.502276 to 0.825689 over 22
        anchors;  the per-anchor spread stays below 0.001).
      - artifact delta (reissue minus artifact):  min
        -0.4977,  median -0.4892,  n matched 505 -- the
        artifact's worst rows (truly about 0.5) all sat at
        about 1.0;  the single root cause is confirmed at
        full-fleet scale,  and no other pathology hides in
        the 481.
      - geometry:  mnew = 0.445916 + 0.010153*(x/1e9)
        + 5.22e-6*k across 3.2e9..2.8e10 (R^2 = 0.868);
        the worst-24 in-band fit remains the local form.
      The pre-fix fleet ledger is now a historical artifact.
      The certificate-grade H1 statement over 3e10 rests on
      out_day052c_696/reissue_ledger_3e10.pts plus the
      day055 precision layer (dps-30/90/120 stability over
      all 505).
  D3  The absolute-O(1) clause itself: zero-scale transfer
      theorem (prove O(1)/gap-away, or refute at the zeros).
      Frontier difficulty; the direct gap-transfer route is a
      documented dead end (3.7); the distribution line
      (Selberg-CLT-at-the-zeros) is the surviving route.
  D4  The argument-principle line in Lean (ap1-ap3): make the
      classical S-identity and the 17/8 telescope house-PROVEN
      instead of CITED.  SCOPE UPDATE from the research pass:
      (i)  the earlier  "mathlib has no argumentPrinciple"  
      scouting is STALE at our pin:  the pinned mathlib
      (v4.33.1,  verified against the local lake package)
      now ships  Mathlib/Analysis/Meromorphic/{Basic,Order,
      Divisor}  with  MeromorphicOn.divisor  (a locally-
      finsuppWithin carrying  meromorphicOrderAt,  positive
      at zeros,  negative at poles)  and  divisor_apply /
      divisor_ball_support_finite.  The COUNTING DATA half of
      ap1 is library-ready at the pin.
      (ii)  the argument principle itself is available
      upstream as a maintained Lean theorem:  Tau Ceti
      (Lean-FRO-incubated community library,  
      github.com/TauCetiProject/TauCeti)  carries
      TauCeti.Analysis.Contour.Argument.Principle,
       TauCeti.Contour.argumentPrinciple  --  for f
      meromorphic on the closed disc  C(c,R)  with nonzero-
      order points in a finite set inside,  the contour
      integral of f'/f  equals  2*pi*i  times the sum of the
      orders.  Borrow-with-citation candidate per the iron
      rule (new upstream,  review before any use).
      (iii)  the Zeta23 borrow source has MOVED:  
      github.com/anthropics/zeta-23-lean now resolves to
      anthropics/formal-math  with the lean package under
      zeta23/;  the documented  RvM/Backlund.lean path is
      not on main (the file was reorganized);  a fresh file
      inventory of zeta23/Solution and zeta23/Zeta23 is
      needed before borrowing from there.
      Build order:  ap1  =  argumentPrinciple (TauCeti
      borrow or in-house port on MeromorphicOn)  ->  ap2  =
      the S-identity wire  N(T) = main + 7/8 + S(T) + O(1/T)
      with  S = (1/pi) . arg  zeta  from ap1 plus the RVM
      residual;  ap3  =  the Backlund-line explicit input
      (17/2 base cost)  from the relocated zeta23 port or
      an in-house constant.  The 17/8 wire-cost identity
      itself is already LEAN-PROVEN  (pin_wire_cost_at_half).
      AP1 STAGE 1 COMPLETE (in-house,  NOT borrowed):  the
      zeta23 argument-principle base was ported into
      formal/RhAttack/Ap1*.lean  (tactic AdditiveCombination,
      rectangle calculus,  residue calculus on rectangles
      incl.  ResidueTheoremInRectangle,  and the weighted
      argument principle  rectangleIntegral'_mul_logDeriv
      plus  residueTheorem_finset  and
      finite_zeros_rectangle).  Source:  anthropics/formal-
      math  commit  e1a4e65  (former  zeta-23-lean,  Apache-
      2.0,  attribution preserved in file headers;  port is
      cited in  formal/RH-LEAN-PROVENANCE.md).  All needed
      mathlib lemmas verified present at the pinned
      v4.33.1  (incl.  the  Rectangle  definition and
      rectangle_eq_convexHull  in  Mathlib.Data.Complex /
      Analysis.Complex.Convex  themselves).  Build green;
      two SELF-TEST theorems in  Ap1ArgumentPrinciple.lean
      run the ported principle in working form
      (ap1_selftest_residue_finset:  single-pole count = 1;
      ap1_selftest_weighted_simple_zero:  weighted zero-sum
      evaluation),  zero sorry.  The simple-pole residue
      section (residue,  sumResiduesIn,  HasSimplePolesOn,
      RectangleIntegral'_eq_sumResiduesIn)  was ported in
      the same pass.  AP2 COMPLETE:  the RVM window identity
      is now house-PROVEN --  the zero-count layer
      (Ap2Defs/Ap2Counting/Ap2Statement/Ap2Seam/Ap2Reflect/
      Ap2CountByIntegral,  from the same source commit)  gives
      rectangleIntegral'_logDeriv_completedZeta_eq_Ncount:
      (1/2pi i)-int  Lambda'/Lambda  around  the  [(-1,iT1),
      (2,iT2)]  rectangle  equals  N(T1,T2)  (nontrivial
      zeros,  multiplicity = analytic order),  for window
      edges off the zero ordinates;  zetaSeam  discharged
      from Mathlib  (finiteness + reflection  rho -> 1-rho')
      with NO paper inputs.  Self-test:
      ap2_selftest_RH_counts_on_line  (under RH the same
      contour integral equals the on-line count  N0).
      AP3 COMPLETE (same source commit):  the whole
      bound layer is now house-PROVEN --
      Ap3Prelude  (instance hygiene),  Ap3StrongPNTPrefix
      (the Jensen disk zero-count  ZerosBound,  482-line
      PNT+ prefix),  Ap3ZetaBounds  (the  three  needed
      ZetaBounds lemmas  out of the  3060-line  PNT+
      port:  Zeta0 /  Zeta0EqZeta  /  ZetaBnd_aux1b
      with their ~450-line  helper closure),
      Ap3Growth  (explicit half-plane  bound  1/2 +
      1/|1-s| + |s|/sigma  [Tit 2.1.4],  linear growth
      (5/2 + delta^-1)|t|,  |zeta - 1| <=  zeta(2) - 1
      for  Re  >=  2),  Ap3Halving  (reflection
      halving  N <=  2 x  right-half  count),
      Ap3BacklundDefs  (reZeroSet),  Ap3LocalCount
      (Jensen/Landau  local  zero  count),
      Ap3ReZeroCount  (the  Jensen bound
      reZeroSet_card_le  counting  the  Re-zeros  of  the
      horizontal  segment  via the ported disk
      ZerosBound),  and  Ap3Backlund:  the  explicit
      Backlund horizontal  bound  backlund_horizontal
      (|Im int_{1/2}^{2}  zeta'/zeta  d(sigma)|  <=  the
      explicit  O(log T)  form  with the  raw  ~310 log T
      integral  constant)  plus  vertical_two
      (the  sigma  =  2  side  is  bounded  by  pi).
      This  is  exactly  the  17/2  base-cost  input  the
      A1Growth line  previously  carried  as  CITED
      (A1G-6)  --  the  counting  side  of  the  S-identity
      wire  (N-window  =  contour  +  main  +  the  two
      bound  inputs)  is  now  fully  house-PROVEN
      end-to-end  through  the  ported  argument
      principle.  Remaining  on  the  D4  line:  the
      main-term  assembly  (RvM/MainTerm + Fold +
      GammaSide  +  the  23-line  Statement  assembler
      =  the  full  RvM  formula  N(T1,T2)  =  int  mu  +
      (1/pi) Im  int  zeta'/zeta  +  bounds)  --  PORTED
      AND COMPLETE (ap4):  Ap3Hypotheses  (the
      GammaFacts  +  PaperInputs  structures,  the  paper
      inputs  as  explicit  hypotheses  by  design),
      Ap3RvMDefs  (GoodHeight,  halfContour,
      the  RiemannVonMangoldt  packaging),
      Ap3XiLogDeriv  (logDeriv  Lambda  =  logDeriv  zeta
      +  logDeriv  Gamma,  conj-symmetry),
      Ap3ZetaConj,  Ap3NcountWindow,  Ap3Fold  (the
      fold:  N(T1,T2)  =  (1/pi) Im halfContour
      Lambda'/Lambda  via  Lambda(1-s')  =  Lambda(s)),
      Ap3GammaSide  ((1/pi)(halfContour  logDeriv
      Gamma).im  =  int  mu),  Ap3MainTerm  (the
      parametric  assembly  rvM_main_param  and  its
      corollaries),  Ap3RvMStatement  (the  assembler),
      and  the  full  GammaFacts  discharge
      (Ap3GammaSeries  the  digamma  series,
      Ap3GammaStirling,  Ap3GammaMu  the  mu  asymptotic,
      Ap3GammaIntMu,  Ap3GammaStirlingVert  the
      vertical  Stirling  estimate,
      Ap3GammaComplete:  gammaFacts,  proved  from
      Mathlib  alone).  TOP-LEVEL  RESULT  now
      house-PROVEN  in  this  repo  with  NO  paper
      inputs  and  no  extra  hypotheses:
      riemannVonMangoldt  gammaFacts,  i.e.
      N(T,2T)  =  (T/2pi)  ell1(T)  +  O(log T)  and
      the  packaged  RiemannVonMangoldt
      zetaZeroConfig  (self-tests
      ap4_selftest_rvM_main_no_extra_hypotheses  and
      ap4_selftest_riemannVonMangoldt_no_extra_hypotheses).
      D4 VERDICT:  the  classical  S-identity  wire  is
      end-to-end  LEAN-PROVEN  in-house  --  argument
      principle  (ap1)  +  window  identity  (ap2)  +
      side  bounds  (ap3)  +  main  term  and  full  RvM
      (ap4)  --  34  ported  files  (about  7.5k  lines),
      all  from  the  cited  Apache-2.0  source  commit
      e1a4e65  +  mathlib,  zero  sorry,  build  green.
      **ap5  (in-house,  no  borrow):**  RhAttack/
      S1Point.lean  proves  the  POINT-scale  RvM  with
      O(log T)  error:  |N(T) - f_pt T|  ≤  C·log T  at
      good  heights  T  ≥  T0,  under  the  single  named
      input  C9  (no  nontrivial  zero  on  (0,4]:  first
      zero  14.134725...).  This  is  the  classical
      S-defect  bound  (Backlund  1918  /  Titchmarsh  9.4
      point  form)  that  A1G-6  used  to  CITE:  the
      rebase  is  now  a  formal  theorem  --
      S1B.rebase_a1g6_dn_form  gives  the  wire's  hSbound
      premise  form  C·log t  +  1/t  for  the  classical
      smooth  count  (Nas  =  f_pt).  ~450  lines
      in-house,  zero  sorry,  all  four  rhattack  gates
      PASS.  The  only  remaining  CITED  input  of
      A1Growth.lean  is  the  Trudgian  II  explicit
      S-bound  (A1G-5),  the  unconditional  frontier  by
      design.
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
    scripts/rh/ckpt_h1_3e10/ + the third machine's ckpt rows
    (stored on this disk under the fleet delivery;  the
    pre-merge local rows -- the ones containing the
    0.9999999965 artifact values)
  Code:
    scripts/rh/day037_h1_3e10.py (CPU reference engine, VERBATIM
                             imported by day048/049a)
    scripts/rh/day048_reissue_prec.py (the re-issue protocol)
    scripts/rh/day049a_pi_probe.py (the pi-probe, this pass)
    scripts/rh/day049b_v4_recompute.py (V4 fourth margin
      pipeline:  near-region dps-60 direct over exact f64 zeros
      + far-region f128 windows;  results pending)
    scripts/rh/day049c_slab_diff.py (D1 slab-by-slab GPU-vs-CPU
      diff:  fleet 8-thread path + both cores per slab;  totals
      phase landed,  per-slab CSV running)
    scripts/rh/day049b2_parent.py (V4 finisher:  accumulation +
      dps-60 near sum + margin)
    scripts/rh/day049d_certpoint.py (the fleet's own cert_point,
      verbatim,  at p01:  the assembly discriminator;  queued
      after D1)
    scripts/rh/day038_h1_3e10_gpu.py (the fleet GPU engine;
      row format at _point_row; SELFTEST(c)/(f) scope in its
      docstring; last modified e180eae, before the fleet)
  Verification (this pass):
    scripts/rh/out_band_md5_live.txt (live A/B/C/D md5,  all
      matching the pre-fleet record -- source drift closed)
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
