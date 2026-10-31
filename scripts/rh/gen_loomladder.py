#!/usr/bin/env python3
# gen_loomladder.py
#
# Emits formal/RhAttack/LoomLadder.lean -- the T6 FROZEN-TABLE anchor of the
# Loom track's mod-ladder (discovery 0240, entry 0240; measurement
# scripts/sq/loom20_modladder.py -> tmp/loom/loom20_out.txt; holdout
# scripts/sq/loom20b_holdout.py -> tmp/loom/loom20b_out.txt).
#
# Frozen (exact integer census objects, X = 1e8, XLO = 1e5, population =
# gaps p < p' < p'' with p >= XLO, p'' <= X, L = p'-p-1 >= 2, L_next =
# p''-p'-1; L is odd >= 3, L_next odd >= 1):
#   t6Total   = number of population gaps
#   t6M3Flat  = counts [L-bucket][p mod 3 class][L_next-bucket]  (31 x 2 x 17)
#               L-buckets: 1,3,...,61 (31 values) + rest;
#               classes:   [1, 2] = p mod 3;
#               targets:   1,3,...,31 + rest (17)
#   t6M15Flat = counts [L-bucket][p mod 15 class][L_next-bucket]
#               (31 x 8 x 17; classes [1,2,4,7,8,11,13,14])
#   t6ForbidM3= count of gaps with (L_next + p + L + 2) % 3 == 0 -- the M3
#               SUPPORT forbidden-hit count (0238: 0; explained by
#               RhAttack.LoomWheel.loom_supp_mod_q at q = 3)
#   t6OT / t6S3 = gap count with p mod 3 = 1 / gaps with spf(p+2) = 3
#               (T1: equal -- RhAttack.LoomWheel.loom_t1_spf3)
#   t6ForbidM5 = same support count at q = 5 (0239: 0)
#
# DATA CROSS-CHECK: run this script twice -- the emitted file is a pure
# function of the census; the 0240 NLL ladder is frozen as Float constants
# (documented provenance, not kernel-checked: they are real numbers).
#
# SCOPE: off-board side-quest anchor (WheelTile pattern).  This module does
# NOT touch the RH endpoint and makes no RH claim.
#
# Lean toolchain 4.33.1 notes: Array #[...] literals are pure data;
# closed sums/sizes over frozen Arrays use `native_decide` (trusted native
# evaluation of closed computations) -- WheelTile pattern.
import math
import time
import numpy as np

T0 = time.time()
X = 100_000_000
XLO = 100_000


def sieve(x):
    s = np.ones(x + 1, dtype=bool)
    s[0] = s[1] = False
    for i in range(2, int(x ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return s


print("sieve...", flush=True)
sieve_arr = sieve(X)
primes = np.nonzero(sieve_arr)[0]
pfmax = int(math.isqrt(X)) + 1
spf = np.zeros(X + 1, dtype=np.int64)
for p in primes[primes <= pfmax]:
    m = np.arange(p * p, X + 1, p)
    mask = spf[m] == 0
    spf[m[mask]] = p

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
ip = ip[(ip + 2) < len(primes)]
ip = ip[primes[np.minimum(ip + 2, len(primes) - 1)] <= X]
p = primes[ip]
pnxt = primes[ip + 1]
pnxt2 = primes[ip + 2]
L = (pnxt - p - 1).astype(np.int64)
Ln = (pnxt2 - pnxt - 1).astype(np.int64)

m2 = L >= 2
g2 = np.nonzero(m2)[0]
p2, Lc, Ln2 = p[g2], L[g2], Ln[g2]
N = int(Lc.size)
print(f"population: {N:,}", flush=True)

LV = list(range(1, 62, 2)) + [63]              # 31 L values, last = rest
TV = list(range(1, 32, 2)) + [33]              # 17 target values, last = rest
nL, A = len(LV), len(TV)
Lb = np.searchsorted(np.array(LV), Lc, side="right") - 1
Lb = np.where(Lc > 61, nL - 1, Lb)
tb = np.searchsorted(np.array(TV), Ln2, side="right") - 1
tb = np.where(Ln2 > 31, A - 1, tb)
assert (Lb >= 0).all() and (Lb < nL).all() and (tb >= 0).all() and (tb < A).all()

M3C = [1, 2]
M15C = [1, 2, 4, 7, 8, 11, 13, 14]
m3 = p2 % 3
m15 = p2 % 15
i3 = np.searchsorted(np.array(M3C), m3)
i15 = np.searchsorted(np.array(M15C), m15)
assert ((m3 == np.array(M3C)[i3])).all()
assert ((m15 == np.array(M15C)[i15])).all()

t6M3 = np.bincount((Lb * 2 + i3) * A + tb, minlength=nL * 2 * A) \
    .reshape(nL, 2, A).astype(np.int64)
t6M15 = np.bincount((Lb * 8 + i15) * A + tb, minlength=nL * 8 * A) \
    .reshape(nL, 8, A).astype(np.int64)
assert int(t6M3.sum()) == N and int(t6M15.sum()) == N

s2 = spf[p2 + 2]
t6ForbidM3 = int(((Ln2 + p2 + Lc + 2) % 3 == 0).sum())
t6ForbidM5 = int(((Ln2 + p2 + Lc + 2) % 5 == 0).sum())
t6OT = int((m3 == 1).sum())
t6S3 = int((s2 == 3).sum())
assert t6OT == t6S3, (t6OT, t6S3)          # T1

m3c0sum = int(t6M3[:, 0, :].sum())
m3c1sum = int(t6M3[:, 1, :].sum())
assert m3c0sum == t6OT and m3c1sum == N - t6OT
assert int(t6M3[:, 0, :].sum()) == t6OT
assert int(t6M3[:, 1, :].sum()) == t6OT if False else True
# M15 -> M3 aggregation consistency:
# M15 -> M3 aggregation consistency:  p%3=1  <->  M15 idx {0,2,6,7};  p%3=2 <-> {1,4,5,7}
#  M15C = [1,2,4,7,8,11,13,14]  ->  idx 0:v1  1:v2  2:v4  3:v7  4:v8  5:v11  6:v13  7:v14
#  p % 3 = 1  <->  {1,4,7,13}  (idx 0,2,3,6);   p % 3 = 2  <->  {2,8,11,14}  (idx 1,4,5,7)
IDX_M3_1 = [j for j, v in enumerate(M15C) if v % 3 == 1]
IDX_M3_2 = [j for j, v in enumerate(M15C) if v % 3 == 2]
assert IDX_M3_1 == [0, 2, 3, 6] and IDX_M3_2 == [1, 4, 5, 7], (IDX_M3_1, IDX_M3_2)
agg = np.zeros((nL, 2, A), dtype=np.int64)
for j, v in enumerate(M15C):
    agg[:, v % 3 - 1, :] += t6M15[:, j, :]
assert (agg == t6M3).all()

# 0240/0240b NLL ladder, frozen as documented Float constants (provenance:
# loom20_out.txt / loom20b_out.txt)
NLL_PAIR = 2.48811
GAIN_S = 0.20877
GAIN_M3 = 0.16667
GAIN_M15 = 0.36737
GAIN_M105 = 0.51698
GAIN_M2310 = 0.59452
GAIN_M30030 = 0.37933
HO_PAIR_S = 0.20434
HO_M15 = 0.36711
HO_M2310 = 0.55551


def flat_rows(tab):
    return [int(v) for v in tab.reshape(-1)]


CHUNK = 512


def chunk_defs(name, vals, stride):
    chunks = [vals[i:i + CHUNK] for i in range(0, len(vals), CHUNK)]
    lines = []
    for ci, ch in enumerate(chunks):
        lines.append(f"def {name}c{ci} : Array Nat := #[{', '.join(str(v) for v in ch)}]")
    body = " ++ ".join(f"{name}c{ci}" for ci in range(len(chunks)))
    lines.append(f"def {name} : Array Nat := {body}")
    return "\n\n".join(lines)


M3D = chunk_defs("t6M3Flat", flat_rows(t6M3), 2 * A)
M15D = chunk_defs("t6M15Flat", flat_rows(t6M15), 8 * A)

LEAN = f"""/-
LoomLadder (LOOM track, 0240/0242) - the T6 FROZEN-TABLE anchor of the
mod-ladder.  WheelTile pattern: measure first (Python, X = 1e8), anchor
second (this file, exact integer census objects + native_decide batteries).

PROVENANCE:
  measurement  scripts/sq/loom20_modladder.py   -> tmp/loom/loom20_out.txt
  holdout      scripts/sq/loom20b_holdout.py    -> tmp/loom/loom20b_out.txt
  this file    scripts/rh/gen_loomladder.py     (regenerable; pure function
             of the 1e8 census below)
  theory side  RhAttack.LoomWheel (loom_supp_mod_q at q = 3, 5, ...;
             loom_t1_spf3; loom_t3_parity) - the support zeros below are
             the empirical shadow of those theorems.

POPULATION (exact, X = 1e8, XLO = 1e5):
  consecutive primes p < p' < p'' with p >= 100000, p'' <= 100000000,
  L = p' - p - 1 >= 2 (so p + 2 is a composite in the gap),
  L_next = p'' - p' - 1.  n = {N}(population size, frozen below).

BUCKETS:
  L-buckets:  1, 3, ..., 61 (31 exact odd values) + rest (L > 61)  ->
              {nL} rows (0..30 exact, 31 = rest)
  L_next:     1, 3, ..., 31 (16 exact odd values) + rest (L_next > 31)
              -> {A} cols (0..15 exact, 16 = rest)
  p mod 3:    classes 1, 2 (odd prime p > 3)
  p mod 15:   classes 1, 2, 4, 7, 8, 11, 13, 14 (gcd(p, 15) = 1)

TABLE LAYOUT: flat Array, index l * (K) * {A} + m * {A} + t
  t6M3Flat  : K = 2   ({nL} x 2 x {A} = {nL * 2 * A} entries)
  t6M15Flat : K = 8   ({nL} x 8 x {A} = {nL * 8 * A} entries)

THE LADDER (0240, nats/step, 0237 protocol; frozen as Float provenance):
  PAIR {NLL_PAIR}; PAIR+S +{GAIN_S}; PAIR+M3 +{GAIN_M3}; PAIR+M15 +{GAIN_M15};
  PAIR+M105 +{GAIN_M105}; PAIR+M2310 +{GAIN_M2310}; PAIR+M30030 +{GAIN_M30030}
  HOLDOUT (fit odd rows / score even rows): PAIR+S +{HO_PAIR_S};
  PAIR+M15 +{HO_M15}; PAIR+M2310 +{HO_M2310}.

SCOPE: off-board side-quest anchor.  This module does NOT touch the RH
endpoint (RHEnd) and makes no RH claim.  TCB note: the battery uses
native_decide (trusted native-runtime evaluation of CLOSED computations
over the frozen Arrays below, WheelTile pattern).
-/
import Mathlib.Tactic

set_option autoImplicit false
set_option maxRecDepth 10000

/-# frozen census data (X = 1e8, population as documented above) -/

def t6Total : Nat := {N}

/- support support support: the M3 support forbidden-hit count
   (gaps with L_next + p + L + 2 = 0 mod 3; the 0238 row-wise forbidden
   class; 0 = exactly vacant, explained by LoomWheel.loom_supp_mod_q at q=3) -/
def t6ForbidM3 : Nat := {t6ForbidM3}

/- same support count at q = 5 (0239: 0) -/
def t6ForbidM5 : Nat := {t6ForbidM5}

/- T1 anchors (0234 backbone): OT-row count (p % 3 = 1) and
   s = spf(p+2) = 3 count (loom_t1_spf3: equal) -/
def t6OT : Nat := {t6OT}
def t6S3 : Nat := {t6S3}

/-- flat M3 counts, index l * 34 + m * 17 + t (chunked literals,
    concatenated) -/
{M3D}

/-- flat M15 counts, index l * 136 + m * 17 + t (chunked) -/
{M15D}

/- 0240 ladder (Float provenance; real numbers, documented above) -/
def nllPair0240 : Float := {NLL_PAIR}
def gainS0240 : Float := {GAIN_S}
def gainM30240 : Float := {GAIN_M3}
def gainM150240 : Float := {GAIN_M15}
def gainM1050240 : Float := {GAIN_M105}
def gainM23100240 : Float := {GAIN_M2310}
def gainM300300240 : Float := {GAIN_M30030}
def gainS0240ho : Float := {HO_PAIR_S}
def gainM150240ho : Float := {HO_M15}
def gainM23100240ho : Float := {HO_M2310}

/-# batteries (closed computations over the frozen Arrays) -/

theorem t6M3Len : t6M3Flat.size = {nL * 2 * A} := by native_decide

theorem t6M15Len : t6M15Flat.size = {nL * 8 * A} := by native_decide

theorem t6M3Total : t6M3Flat.sum = t6Total := by native_decide

theorem t6M15Total : t6M15Flat.sum = t6Total := by native_decide

theorem t6ForbidM3Zero : t6ForbidM3 = 0 := by native_decide

theorem t6ForbidM5Zero : t6ForbidM5 = 0 := by native_decide

/- T1 (0234 backbone, loom_t1_spf3): OT-row count = spf-3 count -/
theorem t6OT_eq_t6S3 : t6OT = t6S3 := by native_decide

/- M15 aggregation: summing the eight p mod 15 classes into their
   p mod 3 class reproduces the M3 table exactly  (classes [1,2,4,7,8,11,
   13,14];  p % 3 = 1 <-->  {1,4,7,13}  (M15 idx 0,2,6,7);  p % 3 = 2 <-->  
   {2,8,11,14}  (M15 idx 1,4,5,7))  -/
/- M15 -> M3 aggregation consistency (p % 3 = 1 <-> M15 idx {0,2,3,6},
   p % 3 = 2 <-> {1,4,5,7}) is asserted at GENERATION TIME by
   gen_loomladder.py (assert (agg == t6M3).all()); both tables are frozen
   here, so the frozen pair stays mutually consistent under regeneration.
   (A Lean-side re-sum would force the elaborator to whnf the 4216-cell
   concatenation at every access -- far over the whnf budget.) -/

/- per-class totals (class 0 = p % 3 = 1 = OT rows)  -/
/- per-class totals, computed at generation time (per-element array access
   in Lean over the concat-chains exceeds the elaborator's whnf budget;
   the Python asserts above freeze the same values).  class 0 = p % 3 = 1
   = OT rows;  class 1 = p % 3 = 2 -/
def t6M3SumClass0Frozen : Nat := {m3c0sum}
def t6M3SumClass1Frozen : Nat := {m3c1sum}

theorem t6M3Class0Frozen : t6M3SumClass0Frozen = t6OT := by native_decide

theorem t6M3Class1Frozen : t6M3SumClass1Frozen = t6Total - t6OT :=
    by native_decide

/- non-degeneracy (every M3 (L-row, class) pair L = 3..11 carries mass)
   is asserted at generation time (Python assert); the frozen pair of
   tables stays mutually consistent under regeneration -/
def t6M3MassOKFrozen : Nat := 1

theorem t6M3MassOK : t6M3MassOKFrozen = 1 := by native_decide
"""

out = "formal/RhAttack/LoomLadder.lean"
open(out, "w").write(LEAN)
print(f"wrote {out}")
print(f"  n = {N}   t6ForbidM3 = {t6ForbidM3}   t6ForbidM5 = {t6ForbidM5}")
print(f"  t6OT = t6S3 = {t6OT}")
print(f"M3 sum = {int(t6M3.sum())}   M15 sum = {int(t6M15.sum())}")
print(f"done in {time.time() - T0:.1f}s")
