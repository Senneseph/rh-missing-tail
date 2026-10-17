# DATA LEDGER - the far census, read-only reference

STATIC FACTUAL DESCRIPTION.  This file is the canonical READING
GUIDE for the far-census data: what each file is, what each column
means, which channel is the channel of record, and where the old
numbers came from.  The tables are GENERATED (scripts/rh/
s34p_ledger.py) from the data files named beside each value;
re-run the generator after data changes, never hand-edit a table.
No RH content: this is bookkeeping.

## 0  Ground rules (how to read this data)

R1  HEIGHTS ARE F64.  A row's height is the exact binary64 integer
    t = G * (t/G),  G = 30001045999.981975555 (the census scale).
    'Exact t' always means that integer.  The 'exact' column in
    section 1 is that integer, in full.
R2  THE ZETA CHANNEL OF RECORD is the C/__float128+QD channel
    (scripts/rh/zetac/zetac.c), at the EXACT f64 height.
    `logzeta` everywhere in this ledger means log|zeta(1/2+it)| at
    that height, from that channel, printed at 12 decimal places.
    (The 5e8G re-issue s34q2 fixed the full 12 digits; earlier
    records kept 10 - never a value disagreement.)
R3  MPMATH IS A CROSS-CHECK ONLY (fresh process per (t, dps), at
    exact heights).  mpmath itself has never been shown wrong in
    this audit (see section 5).  The mpmath wall on this 124 GB
    machine is [9e18, 3e19): 5e8G is the last mpmath-reachable row.
R4  THE REPR RULE.  Never build a height as mpf(repr(float_t)):
    that changes the height by the repr offset in section 5 and
    shifts logzeta by O(1) when the shift exceeds the digit
    setting's height-resolution floor (the 53-bit width estimate
    quantizes the term count:  ~9..90 units at 6e16..6e17, finer
    at higher t - section 5).  Every old anchor was exactly such
    a value (section 5;  the s25 source line is mpf(repr(t)) at
    dps-40).
R5  THE M IDENTITY.  M = eps + lz - lm - la - re - I_far, plain
    float64 evaluated LEFT TO RIGHT (the pipeline's exact
    association).  M is an exact integer in every far row
    (quantization residual 0.0); it is unconnected to O(1-5) lz
    noise at these scales (s34o, re-issue verified).
R6  PROVENANCE.  Every row names the file and stage that holds it.
    'stage A' rows carry no zeta (M_partial); 'stage B' rows are
    the merged row (the M of record).
R7  |Z| COLUMNS.  'full |Z|' = exp(logzeta) of the full RS form
    (the channel of record) - shown to 9-17 digits as recorded or
    re-derived.  'bare |Z|' = the independent bare-cosine assembly
    (no F/c/rssum tables, s34b_cosform.c); the two agree to 1e-5..
    3e-5 wherever both exist (that gap is the size of the rssum
    correction the full form applies).
R8  THE N CONVENTION.  N = floor(sqrt(t / (2*pi)))  (true floor,
    verified for every row in this ledger to 100-digit precision;
    the smallest sqrt-space margin is 45 at 5e8G, far above any
    estimator error).  mpmath's internal n_terms may run N or
    N-1 (its 53-bit estimate;  at 5e8G it used N-1) - harmless,
    because the R-term's imbalance parameter p = 1 - 2(a - N)
    re-balances any +/-1 N choice and the channels agree to the
    printed digits.

## 1  The row set  (generated)

| row   | exact t (f64 integer)   | repr off | N (floor sqrts) | logzeta (C, record) | full |Z|   | bare |Z|   | mpmath exact-x    | M (int)            | quant resid |
|-------|-------------------------|----------|-----------------|---------------------|-----------|-----------|-------------------|--------------------|-------------|
| 2e+06G   | 60002091999963952 | -2 | 97722205 | 0.865468081636 | 2.376118043 | - | 0.8654680816359783 | -452220768 | 0.0 |
| 5e+06G   | 150005229999909888 | +12 | 154512374 | -3.111670188752 | 0.044526525 | - | -3.1116701887516354 | -475565520 | 0.0 |
| 1e+07G   | 300010459999819776 | +24 | 218513495 | 0.122468610055 | 1.130283640 | - | 0.12246861005466814 | -493803232 | 0.0 |
| 2e+07G   | 600020919999639552 | +48 | 309024748 | 1.242954054874 | 3.465836629 | - | 1.2429540548736127 | -514240832 | 0.0 |
| 5e+07G   | 1500052299999098880 | +120 | 488611029 | -1.395123890841 | 0.247802334 | - | -1.3951238908408 | -557909504 | 0.0 |
| 1e+08G   | 3000104599998197760 | +240 | 691000345 | 1.455437142349 | 4.286356804 | 4.286386 | - | -648727552 | 0.0 |
| 3e+08G   | 9000313799994592256 | -256 | 1196847705 | 3.284789950625 | 26.703374699 | 26.703361 | - | -1458497536 | 0.0 |
| 5e+08G   | 15000522999990988800 | +200 | 1545123744 | 2.937019955061 | 18.859560149 | 18.859581 | 2.937019955061246  (= T1/T2/s34e; n = N-1) | -3035441152 | 0.0 |
| 1.0e+09G | 30001045999981977600 | +400 | 2185134954 | -1.211098446310 | 0.297869906 | - | - | -10384437248 | 0.0 |
| 1.0e+10G | 300010459999819726848 | -26848 | 6910003450 | 0.455887846369 | 1.577573404 | - | - | -978196824064 | 0.0 |
| 3.0e+10G | 900031379999459246080 | -46080 | 11968477057 | 2.012486593295 | 7.481898675 | - | - | -8798461100032 | 0.0 |

The repr offset column is the decimal-exact value of Python's
`repr(t)` minus the exact f64 integer (R4).  mpmath exact-x is
blank past the wall (R3).

Boundary probe (s34k, a = 5.9039e8, between the verified-clean 4.886e8 point and the 1e8G row):  t = 2190076357998684160,  N = 590390953.  Channels at the exact height:  C = -1.863686420607;  mpmath dps-15 = -1.86368642061;  mpmath dps-40 = -1.86368642061.  All three agree:  the boundary region carries NO precision- or dps-induced discrepancy -  the old dps-40 readings are the same height / artifact class as the far anchors.

## 2  Row components  (generated; as recorded, f64)

The M-identity inputs (R5).  `lm` and `I_far` are the two O(t) terms
whose cancellation carries all the information; they are stored at
full f64.

| row   | eps            | lm (f64)                  | la            | re             | I_far (f64)               |
|-------|----------------|---------------------------|---------------|----------------|---------------------------|
| 2e+06G   | 0.7046949139418724 | 4.712553285677634e+16 | 990851431.189519 | 3142501485085.287 | -4.71286758968921e+16 |
| 5e+06G   | 0.7046949139418724 | 1.17813832141941e+17 | 1029585102.079987 | 3328748870679.386 | -1.178171614448312e+17 |
| 1e+07G   | 0.7046949139418724 | 2.35627664283882e+17 | 1058885992.983411 | 3469639578967.088 | -2.356311344885437e+17 |
| 2e+07G   | 0.7046949139418724 | 4.712553285677642e+17 | 1088186883.886837 | 3610530287254.79 | -4.712589396719974e+17 |
| 5e+07G   | 0.7046949139418724 | 1.17813832141941e+18 | 1126920554.777305 | 3796777672848.882 | -1.178142118766094e+18 |
| 1e+08G   | 0.7046949139418724 | 2.356276642838821e+18 | 1156221445.680731 | 3937668381136.583 | -2.356280581014696e+18 |
| 3e+08G   | 0.7046949139418724 | 7.068829928516462e+18 | 1202662259.000379 | 4160974870472.633 | -7.068834089235497e+18 |
| 5e+08G   | 0.7046949139418724 | 1.17813832141941e+19 | 1224256007.474624 | 4264806475018.376 | -1.178138747718939e+19 |
| 1.0e+09G | 0.7046949139418724 | 2.356276642838821e+19 | 1253556898.378047 | 4405697183306.077 | -2.356277082495451e+19 |
| 1.0e+10G | 0.7046949139418724 | 2.35627664283882e+20 | 1350892351.075367 | 4873725985475.571 | -2.356276681807621e+20 |
| 3.0e+10G | 0.7046949139418724 | 7.068829928516462e+20 | 1397333164.395018 | 5097032474811.62 | -7.068829891516149e+20 |

## 3  The M identity and the far law  (pinned in Lean)

- M = eps + lz - lm - la - re - I_far (left-to-right f64, R5).
- Near-face fit (s33b record):  M ~ A ln t + B with
  A = -25271000,  B = +523877900  (max near residual 1123.82).
- Far drift  D = M - (A ln t + B)  (s33b record):
  D(1e9G)  = -9774967307.0
  D(1e10G) = -977529165494.1     |D10|/|D9|  = 100.00332
  D(3e10G) = -8797765678430.4    |D30|/|D10| = 9.0000033
  c = |D|/t^2 = 1.0860e-29, 1.0861e-29, 1.0861e-29 (0.1% stable)
  In g = t/G units:  M ~ -9.776e-9 * g^2  dominates.
- All of the above is machine-checked in Lean:  formal/RhAttack/
  MFar.lean  (pinGates, norm_num; the pins are the pinned values).
- The B7 position-amplitude degeneracy is therefore BROKEN on the
  measured domain: the far law is not the near log law; the
  residual shape is exactly identified.

## 4  Channels

- C/quad (channel of record):  scripts/rh/zetac/zetac.c, quadmath
  linked against the runtime .so (no dev headers; hand-declared
  prototypes).  __float128 arithmetic with QD hi/lo (hi+lo f128,
  ~226 bits effective) for every trig argument (t ln n, theta);
  the R-term (rssum) F/c tables are generated integer triples
  (s34a_zetac_tables.py -> zetac_tables.h).  The table's t
  literals round to the EXACT f64 row integers (verified digit
  by digit), so table runs are at exact heights.  The
  ZETAC_TEST_T hook parses f128 (strtoflt128) and feeds an f128
  override - after the double-quantization fix (trap T2).
- Bare cosine:  scripts/rh/zetac/s34b_cosform.c - the same S1 sum
  without the R-term; independent enough (no tables) that agreement
  to 1e-5..3e-5 is a real cross-check (R7).
- mpmath (cross-check):  1.4.1, CPython 3.12.  Always: fresh
  process, exact height via mp.mpf(<integer literal>), one (t, dps)
  per process.  Memory wall: N * ~54..62 bytes, N = floor(sqrt(t/
  2pi)) -> ~1.5e19 ceiling on 124 GB (dps ladders do not move the
  wall).

## 5  The repr-t artifact record  (what the OLD numbers are)

Every old census zeta value was computed at mpf(repr(f64 t)) - the
DECIMAL value of the repr string, offset from the exact integer by
the column in section 1.  Zero density here is ~6 per unit t, so
the offsets shift logzeta by O(1).  The old values are reproduced
at their repr heights by independent channels:

| row   | recorded old anchor   | repr height | reproduced by                        |
|-------|-----------------------|-------------|--------------------------------------|
| 5e7G  | 0.5676737452478491    | t + 120     | mpmath exact at repr: 0.5676737452478491 (16 digits) |
| 1e8G  | 4.4929618099354       | t + 240     | C at repr: 4.492961809935 |
| 3e8G  | -1.5728021802385705   | t - 256     | C at repr: -1.572802180239 |
| 5e8G  | 1.7289704098          | t + 200     | mpmath exact at repr (T4): 1.7289704098077738, CLEAN width chain (173/235) |
| 2e6G  | -0.8770866008849694  | t - 2       | s34x (fresh dps-40 at repr): -0.8770866008849694, dt = 0.0 (bit-exact) |
| 5e6G  | 0.2604606616623537   | t + 12      | s34x: 0.2604606616623537, dt = 0.0 (bit-exact) |
| 1e7G  | 1.639866401622982    | t + 24      | s34x: 1.639866401622982, dt = 0.0 (bit-exact) |
| 2e7G  | -0.4652521468916362  | t + 48      | s34x: -0.4652521468916362, dt = 0.0 (bit-exact) |

Resolution caveat (s34w, measured):  at COARSE digit settings
(dps-15) the 2..48-unit shifts of the four low rows are INVISIBLE
to mpmath - the dps-15 values at the repr heights equal the
exact-height values to 1e-11.  The width chain's 53-bit estimate
quantizes the term count, and at 6e16..6e17 that gives an
effective height resolution of ~9..90 units:  shifts below the
resolution floor do not move the value, shifts above it do (the
5e7G-5e8G shifts of 120..256 units are visible even at dps-15).
The old s25 anchors were taken at dps-40 (finer resolution), where
the 2..48-unit shifts DO show:  s34x (fresh process per height,
dps-40) reproduces all four old low anchors BIT-EXACTLY (dt =
0.0 to the printed float;  tmp/s34x_lowrepr_dps40.log), and the
exact-2e6G control comes back at the canonical value to 1 ulp
(the exact value is dps-stable).  The repr-t artifact record is
now closed for the ENTIRE row set.

The 5e8G 'two classes' of the instrumented runs were the two
HEIGHTS:  T1/T2 (fresh dps-40, exact t) -> 2.937019955061246
(= C, all digits, deterministic);  T4 (fresh dps-40, repr t+200)
-> 1.7289704098077738 (the old anchor) through the same clean
width chain;  T3 (prec 78 forced at exact t) -> the CORRECT
2.937019955061246 (the low-width state does not corrupt).  The
old evidence's 'wp_sum = 175' capture was a misattributed field.
Verdict:  mpmath was not wrong at any height in this audit;  the
upstream issue is closed as a local audit record (docs/
MPMATH-RSSUM-ISSUE.md, v2).

## 6  File map  (what each file is, and what to read in it)

- tmp/s25_M_farcensus.jsonl  -  5 sub-wall rows: components + M.
  Its `logzeta` column is the OLD (repr-t) anchor - HISTORICAL,
  superseded by the canonical lz below.  Do not read it as a
  current zeta value.
- tmp/s34o_subwall_corr.json  -  the 5 sub-wall CANONICAL logzeta
  values (C, exact t).
- tmp/s34g_far_corrected.jsonl  -  3 extreme rows: components,
  canonical logzeta (C exact t), old-anchor comparison, M,
  quantization.
- tmp/s34_1e9G_row.jsonl  -  1e9G:  stage A (no zeta, M_partial +
  f64 partial-sum match) and stage B (merged; M of record).
- tmp/s34j_far_rows.jsonl  -  1e10G, 3e10G:  same A/B structure.
- tmp/s34o_far_reissued.jsonl  -  the 8-row re-issue summary:  M
  old vs new (all 0 shift), quantization (all 0.0).
- tmp/s33b_stdout.txt  -  the past-the-wall re-deconvolution (39
  rows):  near-face A/B fit, the D drift table (section 3), the
  P1-P4 family scan.
- tmp/s34l_t1.log / _t2.log  -  T1/T2:  fresh dps-40 width traces
  at exact 5e8G (entry 173, S1 width 235, clean value).
- tmp/s34l_p78.log  -  T3:  prec-78 forced at exact 5e8G (clean
  value; entry 115, S1 width 177).
- tmp/s34l_t4.log  -  T4:  fresh dps-40 at repr 5e8G (the old
  anchor value, clean chain).
- tmp/s34q2_5e8G.log  -  the 5e8G C re-issue at full 12-digit
  output (logzeta = 2.937019955061, N = 1545123744);  the
  canonical record value for that row (s34g kept 10 digits).
- tmp/s34k_C.log / s34k_dps15.log / s34k_dps40.log  -  the
  boundary probe (t = 2190076357998684160):  all three
  channels agree (section 1).
- tmp/s34w_lowshift.log  -  the four low-row repr probes at
  dps-15 (shifts invisible;  the resolution-floor data).  tmp/
s34x_lowrepr_dps40.log  -  the same four at dps-40 (the old
  anchors, bit-exact) + the exact-height control.
- tmp/s34e_dps40.log  -  the clean instrumented dps-40 run at
  exact 5e8G (S1, rssumS3 = 1.18e-5, n_terms).
- tmp/s34p_5e7G_shift.log / s34u_sens.log / s34v_3e8G.log /
  s34n_*.log  -  the repr-shift reproductions and C/mpmath exact
  crosses named above.
- tmp/s34o_far_reissued.jsonl + the B-stage rows above are the M
  of record;  formal/RhAttack/MFar.lean is the machine-checked pin
  of the far law;  docs/PATHWAY-TO-A-SOLUTION.md is the narrative
  (this ledger is its data appendix).

## 7  Traps found in this audit  (bug list, all closed)

T1  repr-t heights (mpf(repr(f64 t))):  every old far anchor.  Fix:
    exact integer literals everywhere; this ledger's R1/R4.
T2  double-t quantization:  the C struct held t as a C double and
    the test hook parsed with strtod - both silently snap far
    heights to the f64 grid and fake height-flatness.  Fixed:  f128
    hook + override;  the table literals were verified to round to
    the exact integers, so no recorded C value moved.
T3  12-digit logzeta printing:  the C channel prints logzeta at 12
    decimals;  M absorbs that (R5) - verified by s34o.  When a
    value needs more digits, re-run and print more; do not assume
    the 12th digit is exact for anything but the M identity.
T4  misattributed width capture:  the old evidence 'wp_sum = 175'
    was not S1's working width of a corrupted run (T3/T4
    show the value is a height effect;  the width state is not
    the cause).
T5  the mpmath memory wall (N * elem):  do not queue dps ladders or
    far rows past 1.5e19 on this box;  the C channel is the
    past-wall route (staggered launches, one fresh process per (t,
    dps)).

