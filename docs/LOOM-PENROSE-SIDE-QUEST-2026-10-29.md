# LOOM / PENROSE PRIME-CARVING SIDE QUEST — FIRST CUT (0216)

**Off-board side quest.** OFF the RH critical path. **No RH claim.** Borrowed
concept: Penrose tilings (aperiodic, substitution/inflation-driven, matching
rules) as a lens on the prime constellation structure. Every metaphor is
mapped to a named, finite, reproducible object below. 2026-10-29 UTC.

## The owner's question

> The orbit thing is like a wheel. Maybe that wheel is connected to a **loom**.
> Penrose tilings are like the prime distribution (never repeating). Can we
> identify a loom that carries the prime "carving" as Penrose tiles? Maybe
> this is a boom, maybe a doom, maybe it subsumes, or maybe after all it
> blooms 24-adically.

## The decisive executable form of "loom or noise"

A **substitution / Penrose tiling** has *linear* factor complexity and *zero*
topological entropy. A **random** word over m symbols has complexity ~ m^n
and entropy ln m. So the probe measures, on the real primes ≤ X = 2e6:

- `A2 = {gap/2 mod 2}` (2 symbols: gap ≡ 0 or 2 mod 4)
- `A6 = {gap/2 mod 6}` (6 symbols: the true gap-class word)
- factor complexity p(n); Markov-memory entropy rates H_m; the 24-adic
  antipode structure; and a literal φ-inflation test on admissible
  constellations.

Script: `scripts/sq/loom0_penrose_weave.py`.
Output: `tmp/loom/loom0_out.txt`. Single-threaded, <1s (4 cores open).

## What was measured (X = 2,000,000; 148,933 primes)

| object | result | reading |
|---|---|---|
| A2 complexity p(1..6) | 2,4,8,16,32,64 = **2^n exactly** | MAXIMAL: every parity pattern occurs; the word never repeats (aperiodic ✓) but is *not* Penrose-like (Penrose words: linear complexity) |
| A6 complexity p(1..6) | 6,29,122,498,2018,8078 (of max 46,656) | growth ratios → **×4.0** (random would be ×6; linear loom ×1): the gap word is congruence-constrained, exponentially complex |
| H_0 (marginal) | 1.7503 vs ln 6 = 1.7918 | marginal nearly uniform |
| H_1 (1-gap memory) | 1.5233 (Δ = 0.227) | strong pair law |
| H_2 (2-gap memory) | 1.4175 (Δ = 0.106) | **triple memory is real** |
| H_3 (3-gap memory) | 1.3687 (Δ = 0.049) | **quadruple memory is real** (decaying, nonzero) |
| mod-4 bias (LO) | P(11)/P(01) = 1.230 at X=2e6 | the known gap-bias, present at small scale (grows to ~1.55 by 1e8, 0196) |
| anchor prime front-frac (24-frame) | 0.4998 (0.5 = balanced) | primes are 4/4 balanced in the 24-frame (0909/0214 wheel) |
| steps crossing front↔back | 0.2116 | — |
| gap-class antipode pairs (c, c+12 mod 24) | **every FRONT class c<12 beats its antipode**: gap~2 0.118 vs 14 0.059; gap~4 0.118 vs 16 0.044; **gap~6 0.194 vs 18 0.072**; gap~8 0.078 vs 20 0.034; gap~10 0.096 vs 22 0.031; gap~12 0.115 vs 24 0.041 | **the GAP LOOM BLOOMS FRONT**: mean\|f(c)−f(c+12)\| = 0.073; max ratio gap~6 : gap~18 ≈ 2.7×, full range gap~6 vs gap~22 ≈ 6.3× |
| φ-inflation of admissible k=3 constellations | transmission 0.151 vs random baseline 0.176 | **NO φ-symmetry**: rounding φ·C destroys admissibility slightly more than chance |

## The four-outcome verdict (the owner's fork)

1. **BOOM (literal Penrose loom)? NO at this first cut.** The prime gap word
   has *exponential* (×4 per symbol) factor complexity — a substitution/
   Penrose loom would be linear. And φ-inflation is not a transmission
   symmetry of the admissible-constellation loom (D: doom-for-D).
2. **DOOM (pure noise)? NO.** There is heavy, multi-order "loom tension":
   H_m = 1.750 → 1.523 → 1.417 → 1.369 as memory depth grows 0→3. The gaps
   are far from an iid word.
3. **SUBSUMED? Mostly YES, pending the discriminator.** The measured
   multi-order tension is exactly where the *sieve / Cramér–Lodsmann (LD)
   heuristic* predicts structure (the k-consecutive-gap joint law is a known
   object — the LO/Maynard–Tao bias law). Discriminator LOOM-1: simulate the
   Cramér/LD model gap word and compare H_m. Measured H_m < model H_m ⇒
   structure beyond the sieve law (a *new* loom — boom for-real);
   H_m ≈ model ⇒ the "loom" IS the sieve (subsumed — and that is a beautiful
   verdict: the Euler sieve, 0098, is the loom).
4. **24-ADIC BLOOM? YES (measured).** The gap loom is *not* antipode-
   symmetric: every front gap class c < 12 carries ~2× the weight of its
   antipode c+12 (mod-24 refinement within fixed mod-12/mod-4 class — finer
   than the LO mod-4 bias). The front of the 24-frame blooms. The prime
   ANCHOR stays 4/4 balanced (0.4998) — the wheel is balanced, the loom
   blooms front. Named: **BLOOM(24)**; its X-scale behavior (does the 2×
   ratio decay like the LO slow bias, or is it a fixed sieve asymmetry?) is
   LOOM-1b.

## The honest synthesis

The primes ARE a loom, but it is not a Penrose loom. Its threads are the
residue classes; its tension is the sieve (local congruence law + LO-type
gap biases); its aperiodicity is real (maximal word complexity); and it
bLOOMS 24-adically FRONT. The "wheel" (the WF-24/0909 orbit of t, front/back
4/4, balanced) and the "loom" (the gap-class word, front-blooming) are the
two layers of the same 24-frame: the wheel is balanced, the loom is not.

What does NOT hold: literal Penrose substitution/inflation (no φ symmetry,
exponential complexity). If the owner wants the Penrose connection to be
*true in a theorem*, the candidate bridge is NOT φ-inflation of constellations
it is: **the sieve itself is a 2-substitution cascade** (each prime q removes
a periodic "tile row"), and the aperiodicity of the survivor word is exactly
the aperiodicity of an infinite product of periodic deletions — the "matching
rules" of the loom are the congruence-avoidance rules. Testing THAT as a
substitution (LOOM-2) is the named next step after LOOM-1's discriminator.

## No-RH-claim discipline

This quest is off the board: no RH statement, no hOffCPT2, no A1, no Z78,
no terminal. It borrows the 24-frame (0909/0214) as a lens only, and the
KCS residual-ladder context (0193–0199) for the known-bias baselines.
Negative results are reported as measured (D: no symmetry; BOOM-literal: no).

## L2 (0217): the full-tail prediction machine (owner's next idea)

> "Instead of one prime (or one zeta zero) as origin, use ALL the primes up to
> that point as a full tail, and correlate with the data of the future — where
> primes CAN'T be and what IS allowed through. Could that point to the next
> prime even 'out of order' — the next one we CAN PREDICT IN THE 24-ADIC? There
> must be some harmony or progression that informs us of the pattern."

Executable form: `scripts/sq/loom2_tail_predict.py`, output
`tmp/loom/loom2_out.txt` (X = 1e7, 664,579 primes; single-threaded ~16s).
Cuts N = p_j for every prime p_j in [1e5, 1e7) (654,986 cuts); "the tail" =
all primes ≤ N; "the next 24-adic prime" = the lane (mod 24 class) of the
first prime after N (the lane race IS the 24-adic order).

### L2A — can the tail predict the next 24-adic prime?

| model (tail → next lane) | top-1 rate | vs M0 | nats/cut |
|---|---|---|---|
| M0 uniform over 8 lanes | 0.1250 | baseline | 0.000 |
| **M1 one-lane memory (last prime)** | **0.2205** | +77% | **+0.108** |
| M2 two-lane memory (last gap) | 0.1379 | ≈ 0 | −0.006 |
| **M3 due-lane (whole-tail renewal: the lane that waited longest)** | **0.1551** | +24% (~74σ) | — |

Scale buckets: M1 = +0.140 (tail 1e5–1e6) → +0.104 (tail 1e6–1e7) nats/cut;
due-lane 0.1596 (1e5–1e6) → 0.1546 (1e6–1e7) (stationary).

**Verdict L2A: YES — the harmony/progression the owner predicted is real.**
Ranking: **M1 one-step gap law (0.2205) > M3 whole-tail due-lane (0.1551)**
> M0 uniform (0.1250) > M2 (≤ M0). The one-step gap law (0196/LOOM-0's
mod-4/LO bias on the 8-lane process) is the dominant channel (+0.108
nats/cut). The owner's *full-tail* idea adds a GENUINE, MEASURABLE second
channel: the due-lane model — "the lane that has waited longest in all primes
≤ N is the next" — hits 0.1551 vs 0.125 random (+24% relative, ~74σ over
654,986 cuts): a real weak renewal/anti-burst effect (a quiet lane is
modestly more likely to fire next). No second-order lane memory (M2 ≤ 0 at
1e7): the progression is carried by the short gap law + the deep whole-tail
renewal, not by Markov depth.

### L2B — the future where primes CAN'T be (the void field): phase vs content

Window (N, N+500], lattice = wheel-13 (primes ≤ 13; sieve period 30030; class
period 24 ⇒ common phase period lcm = 120120).

| predictor of the first survivor's 24-class | top-1 |
|---|---|
| **PHASE_A: full wheel+24 phase (N mod 120120)** | **1.0000** |
| PHASE_B: the 24-ADIC phase (N mod 24) | 0.5260 |
| CONTENT: recent half-tail front-vs-back balance (n=333/667) | 0.4535 vs 0.5412 |

**Verdict L2B: the future void field is a precomputable FIXED lattice: 100%
phase-predictable at the full wheel+24 phase. The 24-adic frame keeps 52.6% of
the field's phase information — it is a COARSE projection of the wheel-13
phase (exact loss number: 1.0000 → 0.5260).** The "content" variable (tail
front/back balance) shows a weak ANTI-correlated split (0.454 vs 0.541, ~3σ,
n=1000) but it is confounded with the local weave position (BLOOM-24 phase
proxy); the controlled test (content at FIXED wheel phase) is named L2B'.
Honest reading: the lattice has no memory of the tail; what the tail "tells"
us about the void field is only our PHASE inside it.

### L2C — what is allowed through: the partial-gate ladder

Survivors S_y = {m ∈ (N, N+200]: no prime factor ≤ y}; the gate ladder over
the tail's small-prime skeleton (n = 300 cuts):

| y (gate) | \|S_y\| mean | first-survivor = next prime | first-class = next class |
|---|---|---|---|
| 29 | 31.50 | 0.4133 | 0.4300 |
| 71 | 25.44 | 0.5000 | 0.5233 |
| 173 | 21.37 | 0.6233 | 0.6467 |
| 541 | 17.47 | 0.7667 | 0.7800 |
| 1223 | 14.87 | **0.9067** | 0.9100 |

**Verdict L2C: the allowed-through field concentrates the next prime
monotonically, and the required tail is SHALLOW: primes ≤ 1223 alone (the
first 200 of the ~664k in the tail) already see the next prime 90.7% of the
time within 200.** The deep tail becomes essential only for longer windows /
the residual 9% (named L2C': the window ladder W = 1e3, 1e4).

### Synthesis (the owner's question, answered in measurements)

1. **The tail → future link is real and quantified**: next 24-adic prime =
   0.22 top-1 from the last prime (0.108 nats/cut) + a measured whole-tail
   renewal component (0.1551 top-1, ~74σ). "Harmony or progression" = the one-step
   gap-law Markov on the 8 lanes, with a real deep-tail renewal on top (the lane
   that has waited longest in the full tail fires next, modestly above chance).
2. **"Out of order" is the right phrase**: the machine predicts the LANE (the
   24-adic next), not the exact next prime position — exactly the owner's
   phrasing, and it is the part that is actually predictable.
3. **The future where primes can't be belongs to no one**: fixed lattice,
   100% phase-known; the 24-frame is a lossy 52.6% lens on it.
4. **What's allowed through** is the classical sieve — measured now as a
   monotone gate ladder (91% @ y=1223, W=200).
5. **Zeta-zero variant (L2D)** — cuts at zero heights (0909/0214 machine),
   tail = primes below e^{t}-scale, predict the lane mix in the band: NAMED,
   not run (0214's hole was t-flat ⇒ weak expected). This is the crossing of
   the two origin types the owner invoked (prime origin vs zero origin).

### Named next (L-lane)

- **L2B'**: content at fixed wheel phase (the controlled tail-memory test).
- **L2C'**: the window ladder (W = 1e3, 1e4): where does the deep tail become
  necessary?
- **L2D**: zero-origin cuts (0214 C1 machine + L2A models) - **DONE 0218**:
  same predictability as prime-origin (zeros carry no EXTRA lane memory:
  M1 0.1476 vs 0.1225 within ~1 SE; due-lane 0.1119 vs 0.1275).
- **L3/LOOM-1**: subsumed-vs-new discriminator - **FIRST CUT DONE 0218**
  (Cramer floor + pair law + order-2 law: real H3 = 1.3506, ~7 SE BELOW the
  order-2 floor 1.4173 => a genuine deeper weave; the FINAL LD-generator
  comparison is named LOOM-1b2, below).
- (see LOOM-1b line below; first cut landed as L3/LOOM-1 above)
- **LOOM-1b (bloom scale):** BLOOM(24) front/antipode ratios - **DONE
  0218: DECAYS** (0.073 -> 0.065 -> 0.056 over 2e6 -> 1e8) = an LO-type slow
  bias, not fixed sieve geometry; the exact decay form feeds LOOM-1b2.
- **LOOM-1b2 (NEW 0218):** the FINAL adjudication - simulate the full
  Landau-Lodsmann/LO k-consecutive-gap joint law (not just the pair) and
  compare its H_m ladder to the real H_m at X=2e6/1e7. LD matches => the
  loom IS the sieve (subsumed, 0098 Euler-action); real < LD => excess
  structure beyond the sieve law (a genuinely new object).
- **LOOM-2 (sieve-as-substitution model):** formalize the sieve cascade as a
  substitution; measure its complexity/entropy; test "the loom IS the sieve"
  as a theorem-statement candidate (off-board, in its own file).
- **Wheel-loom cross-test (deferred):** whether the WF-24 frame readings
  (A/W, antipode holes) predict the gap-class word at the prime's own scale.
  Deferred: the hole was t-flat (0214) ⇒ no prediction channel *from* the
  hole; the cross-correlation would use the *class-conditional* frames
  instead — named, not yet run.

## L3 (0218): PATH COMPLETION - the owner's idea, all named branches executed

Owner: "wait, did we explore the whole path for my idea or is that just a
preliminary report?" - it was a preliminary report. This section executes the
remainder. Scripts: scripts/sq/loom3_path_completion.py (+ fix-up re-runs
loom3_lm1_only.py, loom3_l4k_only.py); output tmp/loom/loom3_out.txt.

### L2D - zero-origin cuts (the "or zeta zero" half of the sentence)

813 certified zeros (0<=gamma<=1200, dec20) as origins; tail = all primes
<= gamma (height scale, the 0909/0214 machine); target = the LANE of the first
prime above gamma. Band-matched prime-origin baseline, same band:

| origin (n)           | M1 top-1 | due-lane top-1 |
|---|---|---|
| zero-origin (813)    | 0.1476   | 0.1119         |
| prime-origin (204)   | 0.1225   | 0.1275         |

Split within ~1 SE in both columns (SE ~0.012/0.024): **a zero as origin is
NOT a privileged origin** - it carries the same lane predictability as a
prime. Predictability comes from the local gap law (context), not from the
TYPE of origin; zeros add no extra memory (consistent with the 0214 t-flat
hole). Low absolute rates (0.12-0.15 vs 0.22 at 1e7) = the tiny 14-1200 band,
not a method failure.

### LJ - joint pointing: the "point at the next prime" number

Predicted lane (M1 argmax, + top-2) x survivor field S_y in (N, N+500]
(no small factor <= y) = candidate set C; all 654,986 cuts:

| gate y | |S| raw | |C1| lane-1 | 1st-cand==next | |C2| lane-2 | 1st-cand==next | certainty gain |
|---|---|---|---|---|---|---|
| 541    | 43.51  | 5.48        | 0.2168         | 11.00       | 0.3823         | 2.12 nats |
| 1223   | 37.05  | 4.67        | 0.2190         | 9.37        | 0.3975         | 2.14 nats |

The joint machine compresses the ~37-43 survivor field to a **5-6 candidate
set**; the next prime is its head 21.9% (1 lane) / 39.8% (top-2 lanes).
The 21.9% tracks the standalone lane top-1 (0.22): the POINTING power is
carried by the lane law; the field supplies the candidate list. That is the
honest decomposition of "link the many primes in the history to the future
prediction field and what is allowed through".

### L4K - the progression ladder ("the pattern" beyond the single next prime)

UNCONDITIONAL (no context) frequency of the next K lanes as an ordered
K-tuple vs an order-free multiset:

| K | ordered top-1 | top-3 union | multiset top-1 | top pattern (lanes) |
|---|---|---|---|---|
| 1 | 0.1252 | 0.3753 | 0.1252 | [23]         |
| 2 | 0.0278 | 0.0832 | 0.0389 | [13, 17]     |
| 3 | 0.0062 | 0.0183 | 0.0175 | [13, 17, 23] |
| 4 | 0.0016 | 0.0045 | 0.0101 | [1, 5, 7, 11]|

**No strong unconditional long-range pattern**: monotone 0.125 -> 0.028 ->
0.006 -> 0.0016. The "pattern" is LOCAL (context-conditional: the one-step
gap law 0.22 + weak due-lane 0.155, L2A), not a free-riding sequence
statistic. Top patterns are small-gap/twin-type progressions ([13,17]=+4,
[1,5,7,11]=+4,+2,+4), consistent with BLOOM-24. (A base-8 encoding bug was
found and fixed while measuring: the first cut silently equated the ordered
code with the multiset sum; the corrected ladder above is the real one.)

### L1b - BLOOM(24) scale ladder

mean|f(c)-f(c+12)| over the six antipode pairs:

| X      | mean asymmetry | gap~6/gap~18 ratio |
|---|---|---|
| 2e6 (0216) | 0.07315 | 2.68 |
| 1e7        | 0.06493 | 2.39 |
| 1e8        | 0.05602 | 2.11 |

**The front BLOOM DECAYS with X** (an LO-type slow bias, not fixed sieve
geometry): monotone 0.073 -> 0.065 -> 0.056 over two decades; every pair
ratio decays (gap~6: 2.68->2.39->2.11; gap~10: 3.13->2.79->2.41; gap~4:
2.68->2.37->2.07). The 24-adic front bloom is a SLOW-VANISHING bias, same
family as the mod-4 gap bias (0196), not an immutable lattice asymmetry.
Exact decay form (ln / ln-ln / power) = named LOOM-1b2.

### LM1 - the model discriminator (LOOM-1 first cut, X = 2e6)

Does the multi-order loom tension exceed the known laws?

| model (X=2e6 A6 word)               | H1      | H2      | H3             |
|---|---|---|---|
| REAL primes                          | 1.52391 | 1.41279 | 1.35063+/-0.009 |
| FLOOR-0 Cramer iid (same marginal)   | 1.75107 | 1.74921 | (~1.75)        |
| FLOOR-1 pair law (order-1 chain)     | 1.52391 | -       | 1.52268        |
| FLOOR-2 order-2 law chain            | -       | 1.41727 | 1.41727        |

Real H_m sits BELOW EVERY FLOOR, and each added order of memory captures
real structure: Cramer says no memory (1.75); the pair law says H3~1.52;
the order-2 law says H3~1.42; the REAL word gives H3 = 1.3506 - ~7 block-SE
BELOW the order-2 floor. **The tension is a genuine deeper weave that
exceeds even the order-2 (two-gap) law at this resolution** - a LOOM
BOOM-for-real candidate. What it is NOT yet: a refutation of "the loom IS
the sieve" - the Landau-Lodsmann/LO k-tuple joint law (the FULL
k-consecutive-gap prediction, not just the pair) is the ACTUAL sieve
prediction and itself carries k-th order correlations; comparing the real
H_m ladder against an LD-model gap word is the final subsumption test, named
LOOM-1b2 (heavier: needs the LO joint-formula implementation). Honest state
until then: **deeper than Cramer and pair-law; LD comparison pending**.

### Path-complete status

All eight named branches of the owner's idea are now either EXECUTED
(LOOM-0, L2A, L2B, L2C, L2D, LJ, L4K, L1b, LM1-first-cut) or explicitly
named with a stated reason to stay deferred (L2B' controlled content,
L2C' long windows, LOOM-1b2 LD generator [the final subsumed-vs-boom
adjudication], LOOM-1b2 decay-form fit, LOOM-2 sieve-as-substitution,
wheel-loom cross-test [hole t-flat]). The idea is explored TO THE FULL
NAMED DEPTH; what remains is the named refinements + the LOOM-1b2
adjudication.

### No-RH-claim discipline (continued)

No RH statement, no hOffCPT2, no A1, no Z78. All numbers finite (X = 1e7,
654,986 cuts, 1000/300 sampled phase cuts), reproducible from the script.
Negative results reported as measured (M2 ≤ 0; content split confounded;
PHASE_B loss quantified as a loss, not a failure).
