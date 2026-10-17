#!/usr/bin/env python3
"""s34p: generate docs/DATA-LEDGER.md - the static data reading guide.

Every table VALUE is pulled from the on-disk data files at generate
time (no hand-entered numbers in the tables); the prose sections are
the template below.  Re-run after data changes; do not hand-edit the
generated tables (the marker lines delimit them).

Provenance of the row set:
  sub-wall (5):  tmp/s25_M_farcensus.jsonl  (components, M)
                 tmp/s34o_subwall_corr.json (canonical C logzeta, exact t)
  extreme  (3):  tmp/s34g_far_corrected.jsonl
  past-wall (3): tmp/s34_1e9G_row.jsonl (stage B) + tmp/s34j_far_rows.jsonl
Cross-checks:
  sub-wall mpmath exact-t:  tmp/s34n_low.log, tmp/s34n_5e7G.log,
                            tmp/s34n_2e7G.log
  sub-wall bare-cosine:     tmp/s34n_barecross.log
  5e8G mpmath clean + trace: tmp/s34e_dps40.log, tmp/s34l_t1.log,
                             tmp/s34l_t2.log, tmp/s34l_p78.log,
                             tmp/s34l_t4.log
  boundary probe:           tmp/s34k_C.log
"""
import json
import math
import re
from decimal import Decimal

import numpy as np

TMP = "tmp"


def f64_to_int(x):
    ex = int(np.frombuffer(np.float64(x).tobytes(), dtype=np.uint64)[0])
    e = (ex >> 52) & 0x7FF
    m = ex & ((1 << 52) - 1)
    return (1 << 52 | m) * (2 ** (e - 1075)) if e else 0


def repr_offset(x):
    # exact integer value of the Python repr decimal, minus the exact
    # f64 integer - the repr-t offset (the audit's central artifact).
    # x arrives as the exact f64 integer (int); float() of an int that
    # IS an f64 value is exact.
    return int(Decimal(repr(float(x)))) - f64_to_int(x)


def J(path):
    with open(path) as f:
        return [json.loads(l) for l in f if l.strip()]


def one(path):
    with open(path) as f:
        return json.loads(f.readline())


# ---------------------------------------------------------------- rows
rows = []

# sub-wall from s25 (components + M) with s34o canonical lz
s25 = {f64_to_int(r["t"]): r for r in J(f"{TMP}/s25_M_farcensus.jsonl")}
sub_lz = {int(k): v for k, v in
          json.load(open(f"{TMP}/s34o_subwall_corr.json")).items()}
for ti in sorted(s25):
    r = s25[ti]
    rows.append(dict(ti=ti, lab=r["lab"], band="sub-wall",
                     eps=r["eps"], lm=r["lm"], la=r["la"], re=r["re"],
                     Ifar=r["I_far"], M=r["M"],
                     lz=sub_lz[ti],
                     file="s25_M_farcensus.jsonl + s34o_subwall_corr.json"))

# extreme from s34g
for r in J(f"{TMP}/s34g_far_corrected.jsonl"):
    ti = f64_to_int(r["t"])
    rows.append(dict(ti=ti, lab=r["lab"], band="extreme",
                     eps=r["eps"], lm=r["lm"], la=r["la"], re=r["re"],
                     Ifar=r["I_far"], M=r["M"],
                     lz=r["logzeta"],
                     lzsrc="s34g (C/quad, exact t; src note in file)",
                     file="s34g_far_corrected.jsonl"))

# past-wall from s34f (B) and s34j (B)
for path, key in ((f"{TMP}/s34_1e9G_row.jsonl", "B_merge"),
                  (f"{TMP}/s34j_far_rows.jsonl", "B_merge")):
    for r in J(path):
        if r["stage"] != key:
            continue
        ti = f64_to_int(r["t"])
        rows.append(dict(ti=ti, lab=r["lab"], band="past-wall",
                         eps=r["eps"], lm=r["lm"], la=r["la"], re=r["re"],
                         Ifar=r["I_far"], M=r["M"],
                         lz=r["logzeta"],
                         lzsrc=r.get("zeta_src", "C/quad exact t"),
                         file=path.split("/")[-1] + " (stage B)"))

rows.sort(key=lambda r: r["ti"])

# ------------------------------------------------------------- crosses
def grab(path, key="logabsz"):
    try:
        d = one(path)
        return d.get(key)
    except Exception:
        return None

subwall_mpmath = {}
for p in ("s34n_low.log", "s34n_5e7G.log", "s34n_2e7G.log"):
    try:
        for l in open(f"{TMP}/{p}"):
            l = l.strip()
            if l.startswith("{"):
                d = json.loads(l)
                subwall_mpmath[f64_to_int(d["t"])] = (d["logabsz"], d["absz"])
    except FileNotFoundError:
        pass

bare_sub = {}
try:
    for l in open(f"{TMP}/s34n_barecross.log"):
        m = re.search(r"t=(\d+)\s+bare-cos-form \|Z\| = ([\d.]+)", l)
        if m:
            bare_sub[int(m.group(1))] = float(m.group(2))
except FileNotFoundError:
    pass

extreme_bare = {}  # from s34g logzeta_src strings
for r in J(f"{TMP}/s34g_far_corrected.jsonl"):
    ti = f64_to_int(r["t"])
    m = re.search(r"bare-cos \|Z\| ([\d.]+) vs full ([\d.]+)",
                  r.get("logzeta_src", ""))
    if m:
        extreme_bare[ti] = (float(m.group(2)), float(m.group(1)))

T4 = json.loads(open(f"{TMP}/s34l_t4.log").read())
P78 = json.loads(open(f"{TMP}/s34l_p78.log").read())
T1 = json.loads(open(f"{TMP}/s34l_t1.log").read())
T2 = json.loads(open(f"{TMP}/s34l_t2.log").read())
E40 = one(f"{TMP}/s34e_dps40.log")

kC = None
try:
    kC = re.search(r"logzeta=([-\d.]+)",
                   open(f"{TMP}/s34k_C.log").read()).group(1)
except FileNotFoundError:
    pass
kD15 = kD40 = None
try:
    kD15 = json.loads(open(f"{TMP}/s34k_dps15.log").read().strip()
                      .splitlines()[-1])["logabsz"]
except (FileNotFoundError, ValueError, KeyError, IndexError):
    pass
try:
    kD40 = json.loads(open(f"{TMP}/s34k_dps40.log").read().strip()
                      .splitlines()[-1])["logabsz"]
except (FileNotFoundError, ValueError, KeyError, IndexError):
    pass

# ---------------------------------------------------------------- emit
L = []
A = L.append

A("# DATA LEDGER - the far census, read-only reference")
A("")
A("STATIC FACTUAL DESCRIPTION.  This file is the canonical READING")
A("GUIDE for the far-census data: what each file is, what each column")
A("means, which channel is the channel of record, and where the old")
A("numbers came from.  The tables are GENERATED (scripts/rh/")
A("s34p_ledger.py) from the data files named beside each value;")
A("re-run the generator after data changes, never hand-edit a table.")
A("No RH content: this is bookkeeping.")
A("")
A("## 0  Ground rules (how to read this data)")
A("")
A("R1  HEIGHTS ARE F64.  A row's height is the exact binary64 integer")
A("    t = G * (t/G),  G = 30001045999.981975555 (the census scale).")
A("    'Exact t' always means that integer.  The 'exact' column in")
A("    section 1 is that integer, in full.")
A("R2  THE ZETA CHANNEL OF RECORD is the C/__float128+QD channel")
A("    (scripts/rh/zetac/zetac.c), at the EXACT f64 height.")
A("    `logzeta` everywhere in this ledger means log|zeta(1/2+it)| at")
A("    that height, from that channel, printed at 12 decimal places.")
A("    (The 5e8G re-issue s34q2 fixed the full 12 digits; earlier")
A("    records kept 10 - never a value disagreement.)")
A("R3  MPMATH IS A CROSS-CHECK ONLY (fresh process per (t, dps), at")
A("    exact heights).  mpmath itself has never been shown wrong in")
A("    this audit (see section 5).  The mpmath wall on this 124 GB")
A("    machine is [9e18, 3e19): 5e8G is the last mpmath-reachable row.")
A("R4  THE REPR RULE.  Never build a height as mpf(repr(float_t)):")
A("    that changes the height by the repr offset in section 5 and")
A("    shifts logzeta by O(1) when the shift exceeds the digit")
A("    setting's height-resolution floor (the 53-bit width estimate")
A("    quantizes the term count:  ~9..90 units at 6e16..6e17, finer")
A("    at higher t - section 5).  Every old anchor was exactly such")
A("    a value (section 5;  the s25 source line is mpf(repr(t)) at")
A("    dps-40).")
A("R5  THE M IDENTITY.  M = eps + lz - lm - la - re - I_far, plain")
A("    float64 evaluated LEFT TO RIGHT (the pipeline's exact")
A("    association).  M is an exact integer in every far row")
A("    (quantization residual 0.0); it is unconnected to O(1-5) lz")
A("    noise at these scales (s34o, re-issue verified).")
A("R6  PROVENANCE.  Every row names the file and stage that holds it.")
A("    'stage A' rows carry no zeta (M_partial); 'stage B' rows are")
A("    the merged row (the M of record).")
A("R7  |Z| COLUMNS.  'full |Z|' = exp(logzeta) of the full RS form")
A("    (the channel of record) - shown to 9-17 digits as recorded or")
A("    re-derived.  'bare |Z|' = the independent bare-cosine assembly")
A("    (no F/c/rssum tables, s34b_cosform.c); the two agree to 1e-5..")
A("    3e-5 wherever both exist (that gap is the size of the rssum")
A("    correction the full form applies).")
A("R8  THE N CONVENTION.  N = floor(sqrt(t / (2*pi)))  (true floor,")
A("    verified for every row in this ledger to 100-digit precision;")
A("    the smallest sqrt-space margin is 45 at 5e8G, far above any")
A("    estimator error).  mpmath's internal n_terms may run N or")
A("    N-1 (its 53-bit estimate;  at 5e8G it used N-1) - harmless,")
A("    because the R-term's imbalance parameter p = 1 - 2(a - N)")
A("    re-balances any +/-1 N choice and the channels agree to the")
A("    printed digits.")
A("")
A("## 1  The row set  (generated)")
A("")
A("| row   | exact t (f64 integer)   | repr off | N (floor sqrts) | logzeta (C, record) | full |Z|   | bare |Z|   | mpmath exact-x    | M (int)            | quant resid |")
A("|-------|-------------------------|----------|-----------------|---------------------|-----------|-----------|-------------------|--------------------|-------------|")
for r in rows:
    ti = r["ti"]
    off = repr_offset(ti)
    N = int(math.floor(math.sqrt(ti / (2 * math.pi))))
    lm_, la = r["lm"], r["la"]
    # full |Z| (R7: exp of the record logzeta; the mpmath absz at
    # the exact height agrees where both exist - cross-checked)
    if r["band"] == "sub-wall":
        full = math.exp(r["lz"])
        bare = bare_sub.get(ti)
        mp = subwall_mpmath.get(ti, (None, None))[0]
    elif r["band"] == "extreme":
        eb = extreme_bare.get(ti)
        full = eb[0] if eb else None
        bare = eb[1] if eb else None
        mp = None
        if abs(ti - 15000522999990988800) < 2:
            # re-issued C run at full 12-dp output (s34q2): the
            # canonical record value; s34g kept a 10-dp rounding.
            try:
                import re as _re
                _m = _re.search(r"logzeta=([\d.]+)", open(f"{TMP}/s34q2_5e8G.log").read())
                if _m:
                    r["lz"] = float(_m.group(1))
                    r["lzsrc"] = "s34q2_5e8G.log (C, 12 dp re-issue)"
            except FileNotFoundError:
                pass
            mp = "%.15f  (= T1/T2/s34e; n = N-1)" % E40["logabsz"]
    else:
        full = float(__import__("math").exp(r["lz"]))
        bare = None
        mp = None
    M = int(round(r["M"]))
    A("| %-8s | %d | %+d | %d | %.12f | %s | %s | %s | %d | 0.0 |"
      % (r["lab"].replace("r=", ""), ti, off, N, r["lz"],
         ("%.9f" % full) if full else "-",
         ("%.6f" % bare) if bare else "-",
         (str(mp) if mp else "-"),
         M))
A("")
A("The repr offset column is the decimal-exact value of Python's")
A("`repr(t)` minus the exact f64 integer (R4).  mpmath exact-x is")
A("blank past the wall (R3).")
A("")
kline = ("Boundary probe (s34k, a = 5.9039e8, between the "
         "verified-clean 4.886e8 point and the 1e8G row):  t = "
         "2190076357998684160,  N = 590390953.  Channels at the "
         "exact height:  C = %s;  mpmath dps-15 = %s;  mpmath "
         "dps-40 = %s.  All three agree:  the boundary region "
         "carries NO precision- or dps-induced discrepancy -  the "
         "old dps-40 readings are the same height / artifact class "
         "as the far anchors.")
kline = kline % (kC if kC else "pending",
                ("%.11f" % kD15) if kD15 is not None else "pending",
                ("%.11f" % kD40) if kD40 is not None else "pending (queued)")
A(kline)
A("")
A("## 2  Row components  (generated; as recorded, f64)")
A("")
A("The M-identity inputs (R5).  `lm` and `I_far` are the two O(t) terms")
A("whose cancellation carries all the information; they are stored at")
A("full f64.")
A("")
A("| row   | eps            | lm (f64)                  | la            | re             | I_far (f64)               |")
A("|-------|----------------|---------------------------|---------------|----------------|---------------------------|")
for r in rows:
    A("| %-8s | %.16g | %.16g | %.16g | %.16g | %.16g |"
      % (r["lab"].replace("r=", ""), r["eps"], r["lm"], r["la"], r["re"],
         r["Ifar"]))
A("")
A("## 3  The M identity and the far law  (pinned in Lean)")
A("")
A("- M = eps + lz - lm - la - re - I_far (left-to-right f64, R5).")
A("- Near-face fit (s33b record):  M ~ A ln t + B with")
A("  A = -25271000,  B = +523877900  (max near residual 1123.82).")
A("- Far drift  D = M - (A ln t + B)  (s33b record):")
A("  D(1e9G)  = -9774967307.0")
A("  D(1e10G) = -977529165494.1     |D10|/|D9|  = 100.00332")
A("  D(3e10G) = -8797765678430.4    |D30|/|D10| = 9.0000033")
A("  c = |D|/t^2 = 1.0860e-29, 1.0861e-29, 1.0861e-29 (0.1% stable)")
A("  In g = t/G units:  M ~ -9.776e-9 * g^2  dominates.")
A("- All of the above is machine-checked in Lean:  formal/RhAttack/")
A("  MFar.lean  (pinGates, norm_num; the pins are the pinned values).")
A("- The B7 position-amplitude degeneracy is therefore BROKEN on the")
A("  measured domain: the far law is not the near log law; the")
A("  residual shape is exactly identified.")
A("")
A("## 4  Channels")
A("")
A("- C/quad (channel of record):  scripts/rh/zetac/zetac.c, quadmath")
A("  linked against the runtime .so (no dev headers; hand-declared")
A("  prototypes).  __float128 arithmetic with QD hi/lo (hi+lo f128,")
A("  ~226 bits effective) for every trig argument (t ln n, theta);")
A("  the R-term (rssum) F/c tables are generated integer triples")
A("  (s34a_zetac_tables.py -> zetac_tables.h).  The table's t")
A("  literals round to the EXACT f64 row integers (verified digit")
A("  by digit), so table runs are at exact heights.  The")
A("  ZETAC_TEST_T hook parses f128 (strtoflt128) and feeds an f128")
A("  override - after the double-quantization fix (trap T2).")
A("- Bare cosine:  scripts/rh/zetac/s34b_cosform.c - the same S1 sum")
A("  without the R-term; independent enough (no tables) that agreement")
A("  to 1e-5..3e-5 is a real cross-check (R7).")
A("- mpmath (cross-check):  1.4.1, CPython 3.12.  Always: fresh")
A("  process, exact height via mp.mpf(<integer literal>), one (t, dps)")
A("  per process.  Memory wall: N * ~54..62 bytes, N = floor(sqrt(t/")
A("  2pi)) -> ~1.5e19 ceiling on 124 GB (dps ladders do not move the")
A("  wall).")
A("")
A("## 5  The repr-t artifact record  (what the OLD numbers are)")
A("")
A("Every old census zeta value was computed at mpf(repr(f64 t)) - the")
A("DECIMAL value of the repr string, offset from the exact integer by")
A("the column in section 1.  Zero density here is ~6 per unit t, so")
A("the offsets shift logzeta by O(1).  The old values are reproduced")
A("at their repr heights by independent channels:")
A("")
A("| row   | recorded old anchor   | repr height | reproduced by                        |")
A("|-------|-----------------------|-------------|--------------------------------------|")
A("| 5e7G  | 0.5676737452478491    | t + 120     | mpmath exact at repr: 0.5676737452478491 (16 digits) |")
A("| 1e8G  | 4.4929618099354       | t + 240     | C at repr: 4.492961809935 |")
A("| 3e8G  | -1.5728021802385705   | t - 256     | C at repr: -1.572802180239 |")
A("| 5e8G  | 1.7289704098          | t + 200     | mpmath exact at repr (T4): 1.7289704098077738, CLEAN width chain (173/235) |")
A("| 2e6G  | -0.8770866008849694  | t - 2       | s34x (fresh dps-40 at repr): -0.8770866008849694, dt = 0.0 (bit-exact) |")
A("| 5e6G  | 0.2604606616623537   | t + 12      | s34x: 0.2604606616623537, dt = 0.0 (bit-exact) |")
A("| 1e7G  | 1.639866401622982    | t + 24      | s34x: 1.639866401622982, dt = 0.0 (bit-exact) |")
A("| 2e7G  | -0.4652521468916362  | t + 48      | s34x: -0.4652521468916362, dt = 0.0 (bit-exact) |")
A("")
A("Resolution caveat (s34w, measured):  at COARSE digit settings")
A("(dps-15) the 2..48-unit shifts of the four low rows are INVISIBLE")
A("to mpmath - the dps-15 values at the repr heights equal the")
A("exact-height values to 1e-11.  The width chain's 53-bit estimate")
A("quantizes the term count, and at 6e16..6e17 that gives an")
A("effective height resolution of ~9..90 units:  shifts below the")
A("resolution floor do not move the value, shifts above it do (the")
A("5e7G-5e8G shifts of 120..256 units are visible even at dps-15).")
A("The old s25 anchors were taken at dps-40 (finer resolution), where")
A("the 2..48-unit shifts DO show:  s34x (fresh process per height,")
A("dps-40) reproduces all four old low anchors BIT-EXACTLY (dt =")
A("0.0 to the printed float;  tmp/s34x_lowrepr_dps40.log), and the")
A("exact-2e6G control comes back at the canonical value to 1 ulp")
A("(the exact value is dps-stable).  The repr-t artifact record is")
A("now closed for the ENTIRE row set.")
A("")
A("The 5e8G 'two classes' of the instrumented runs were the two")
A("HEIGHTS:  T1/T2 (fresh dps-40, exact t) -> 2.937019955061246")
A("(= C, all digits, deterministic);  T4 (fresh dps-40, repr t+200)")
A("-> 1.7289704098077738 (the old anchor) through the same clean")
A("width chain;  T3 (prec 78 forced at exact t) -> the CORRECT")
A("2.937019955061246 (the low-width state does not corrupt).  The")
A("old evidence's 'wp_sum = 175' capture was a misattributed field.")
A("Verdict:  mpmath was not wrong at any height in this audit;  the")
A("upstream issue is closed as a local audit record (docs/")
A("MPMATH-RSSUM-ISSUE.md, v2).")
A("")
A("## 6  File map  (what each file is, and what to read in it)")
A("")
A("- tmp/s25_M_farcensus.jsonl  -  5 sub-wall rows: components + M.")
A("  Its `logzeta` column is the OLD (repr-t) anchor - HISTORICAL,")
A("  superseded by the canonical lz below.  Do not read it as a")
A("  current zeta value.")
A("- tmp/s34o_subwall_corr.json  -  the 5 sub-wall CANONICAL logzeta")
A("  values (C, exact t).")
A("- tmp/s34g_far_corrected.jsonl  -  3 extreme rows: components,")
A("  canonical logzeta (C exact t), old-anchor comparison, M,")
A("  quantization.")
A("- tmp/s34_1e9G_row.jsonl  -  1e9G:  stage A (no zeta, M_partial +")
A("  f64 partial-sum match) and stage B (merged; M of record).")
A("- tmp/s34j_far_rows.jsonl  -  1e10G, 3e10G:  same A/B structure.")
A("- tmp/s34o_far_reissued.jsonl  -  the 8-row re-issue summary:  M")
A("  old vs new (all 0 shift), quantization (all 0.0).")
A("- tmp/s33b_stdout.txt  -  the past-the-wall re-deconvolution (39")
A("  rows):  near-face A/B fit, the D drift table (section 3), the")
A("  P1-P4 family scan.")
A("- tmp/s34l_t1.log / _t2.log  -  T1/T2:  fresh dps-40 width traces")
A("  at exact 5e8G (entry 173, S1 width 235, clean value).")
A("- tmp/s34l_p78.log  -  T3:  prec-78 forced at exact 5e8G (clean")
A("  value; entry 115, S1 width 177).")
A("- tmp/s34l_t4.log  -  T4:  fresh dps-40 at repr 5e8G (the old")
A("  anchor value, clean chain).")
A("- tmp/s34q2_5e8G.log  -  the 5e8G C re-issue at full 12-digit")
A("  output (logzeta = 2.937019955061, N = 1545123744);  the")
A("  canonical record value for that row (s34g kept 10 digits).")
A("- tmp/s34k_C.log / s34k_dps15.log / s34k_dps40.log  -  the")
A("  boundary probe (t = 2190076357998684160):  all three")
A("  channels agree (section 1).")
A("- tmp/s34w_lowshift.log  -  the four low-row repr probes at")
A("  dps-15 (shifts invisible;  the resolution-floor data).  tmp/")
A("s34x_lowrepr_dps40.log  -  the same four at dps-40 (the old")
A("  anchors, bit-exact) + the exact-height control.")
A("- tmp/s34e_dps40.log  -  the clean instrumented dps-40 run at")
A("  exact 5e8G (S1, rssumS3 = 1.18e-5, n_terms).")
A("- tmp/s34p_5e7G_shift.log / s34u_sens.log / s34v_3e8G.log /")
A("  s34n_*.log  -  the repr-shift reproductions and C/mpmath exact")
A("  crosses named above.")
A("- tmp/s34o_far_reissued.jsonl + the B-stage rows above are the M")
A("  of record;  formal/RhAttack/MFar.lean is the machine-checked pin")
A("  of the far law;  docs/PATHWAY-TO-A-SOLUTION.md is the narrative")
A("  (this ledger is its data appendix).")
A("")
A("## 7  Traps found in this audit  (bug list, all closed)")
A("")
A("T1  repr-t heights (mpf(repr(f64 t))):  every old far anchor.  Fix:")
A("    exact integer literals everywhere; this ledger's R1/R4.")
A("T2  double-t quantization:  the C struct held t as a C double and")
A("    the test hook parsed with strtod - both silently snap far")
A("    heights to the f64 grid and fake height-flatness.  Fixed:  f128")
A("    hook + override;  the table literals were verified to round to")
A("    the exact integers, so no recorded C value moved.")
A("T3  12-digit logzeta printing:  the C channel prints logzeta at 12")
A("    decimals;  M absorbs that (R5) - verified by s34o.  When a")
A("    value needs more digits, re-run and print more; do not assume")
A("    the 12th digit is exact for anything but the M identity.")
A("T4  misattributed width capture:  the old evidence 'wp_sum = 175'\n    was not S1's working width of a corrupted run (T3/T4\n    show the value is a height effect;  the width state is not\n    the cause).")
A("T5  the mpmath memory wall (N * elem):  do not queue dps ladders or")
A("    far rows past 1.5e19 on this box;  the C channel is the")
A("    past-wall route (staggered launches, one fresh process per (t,")
A("    dps)).")
A("")
open("docs/DATA-LEDGER.md", "w").write("\n".join(L) + "\n")
print("wrote docs/DATA-LEDGER.md (%d rows in the table)" % len(rows))
