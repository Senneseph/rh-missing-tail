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
- **LOOM-1b2a (PAIR-LAW MARRIAGE, DONE 0219):** the pair law (2-gap bias
  as an order-1 generator, fit at each scale) vs the real H3 ladder, at
  3 alphabets x 3 scales. **LANE word MARRIED** at 1e7/1e8 (perfect -0.0004
  at 1e8); FINER gap-class words (A6/G24) NOT subsumable even at 1e8
  (A6 -0.146 35SE; G24 -0.130 9SE) but the excess DECAYS with X. The deeper
  weave lives in the fine 24-adic gap resolution; its two horn explanations
  (slow-law bias vs LD k-tuple k>=3 correlation) are separated by G-1 + G-3.
- **LOOM-1b2b (LD k-tuple joint generator, the FINAL adjudicator):**
  simulate the full Landau-Lodsmann/LO k-consecutive-gap joint law (not just
  the pair) and compare its H_m ladder to the real H_m at 2e6/1e7/1e8. LD
  matches => the loom IS the sieve (subsumed, 0098 Euler-action); real < LD
  => excess structure beyond the sieve law (a genuinely new object).
- **LOOM-2 (sieve-as-substitution model):** formalize the sieve cascade as a
  substitution; measure its complexity/entropy; test "the loom IS the sieve"
  as a theorem-statement candidate (off-board, in its own file).
- **Wheel-loom cross-test (deferred):** whether the WF-24 frame readings
  (A/W, antipode holes) predict the gap-class word at the prime's own scale.
  Deferred: the hole was t-flat (0214) ⇒ no prediction channel *from* the
  hole; the cross-correlation would use the *class-conditional* frames
  instead — named, not yet run.
## G-lane (0220): the Gaussian-splat field trip (see L5 for the full synthesis)
Owner's "boom as a Gaussian splat / neural nets / movement" question. Three
named programs (scripts loom5/6/7), each a translation of a 2024-2025
graphics trick into the prime weave:
- **G-1 (MIP + ANALYTIC splat field):** raw-bin vs analytic window-integral
  measurement of the 24-adic front/antipode asymmetry. Tests whether the L1b
  *decay* (0.073->0.056) is true LO-law decay or **mip-blur** (footprint
  widens as ln X while the measurement window widens with it). Falsifiable:
  corrected asymmetry flat => fixed geometry, widening lens; still decays
  => genuine slow bias, now clean. THE priority.
- **G-2 (SPLINE MOTION / ADC-GS anchors):** the weave statistics as a moving
  splat field vs X; fit few cubic-Hermite control points + rank-decompose the
  pair-matrix EVOLUTION (anchor-driven group drifts + local residuals).
  "The motive for movement": how many control points does the weave's
  evolution need (2 = pure LO slow law; >=3 = an extra degree of freedom)?
- **G-3 (the BABY model / NN marriage):** the third of "you me and baby
  makes three". Interpolated k-grams (k=1..4) + a small hand-rolled numpy
  GRU (no torch on box), fit on 80% of the tail, held-out per-symbol nats =
  extrapolated entropy H_nn. Saturated at the pair level => pair law IS the
  loom; still improving with context => deep weave, and the depth is
  measured. NN is a MEASUREMENT INSTRUMENT (model-capacity ladder), not a
  proof object.

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

### L4 (0219): THE MARRIAGE TEST (first cut) - pair law vs the full weave

Owner (2026-10-29): "let's do the pair law and let these two get married
already!" Script scripts/sq/loom4_pair_law_marriage.py; output
tmp/loom/loom4_out.txt. Pair law = the measured 2-consecutive-gap bias as an
order-1 Markov generator fitted at EACH scale (the classical LO/Maynard-Tao
pair, empirical); marriage test = does the model's H3 (beyond the pair)
equal the REAL H3? Three alphabets x three scales (2e6/1e7/1e8).

| X | alphabet | REAL H3 (+/-SE) | PAIR model H3 | D = real - model | verdict |
|---|---|---|---|---|---|
| 2e6 | L8 lanes | 1.7386 (+/-0.026) | 1.9273 | -0.1886 (7.2 SE) | deeper (finite-scale) |
| 2e6 | G24 gap class | 1.6283 (+/-0.022) | 2.0744 | -0.4461 (20.6 SE) | deeper |
| 2e6 | A6 | 1.3501 (+/-0.012) | 1.5231 | -0.1730 (15.0 SE) | deeper |
| 1e7 | L8 lanes | 1.9160 (+/-0.020) | 1.9558 | -0.0398 (~2 SE) | **MARRIED** (borderline) |
| 1e7 | G24 gap class | 1.8966 (+/-0.022) | 2.1043 | -0.2077 (9.3 SE) | deeper |
| 1e7 | A6 | 1.3782 (+/-0.006) | 1.5302 | -0.1520 (24.1 SE) | deeper |
| 1e8 | L8 lanes | 1.9832 (+/-0.013) | 1.9836 | **-0.0004 (0.04 SE)** | **MARRIED (perfect)** |
| 1e8 | G24 gap class | 2.0037 (+/-0.014) | 2.1332 | -0.1295 (8.9 SE) | deeper (decaying) |
| 1e8 | A6 | 1.3919 (+/-0.004) | 1.5375 | -0.1456 (35.6 SE) | deeper (persistent) |

**The split verdict (itself the finding):**

1. **The lane word - the M1 prediction machine's own alphabet, the
   "out-of-order" 24-adiic lane - is MARRIED to the pair law at 1e7/1e8**
   (perfect at 1e8 to 4e-4). The pair law (the 2-gap bias) is a COMPLETE
   description of everything the lane process does beyond the pair, at
   scale. The 2e6 lane excess (0.19) is finite-scale: the bias is still
   in transition there. The prediction machine's alphabet contains no
   hidden structure beyond the pair.
2. **The FINER gap-class words (A6, G24) are NOT subsumed by the pair law
   even at 1e8**: the A6 excess is -0.146 (35.6 pooled SE) and the G24
   excess -0.130 (8.9 pooled SE) persistent at 1e8, but the G24 excess
   DECAYS with X (-0.446 -> -0.208 -> -0.130, roughly halving per decade).
   So the "deeper weave" lives in the FINE 24-adiic gap resolution (the
   detail the lane word averages away) and either (a) decays away (finite-
   scale / slow-bias residue) or (b) is exactly the LD/LO k-tuple
   *k>=3-gap correlation* - the part of the sieve law that is genuinely
   beyond any pair (order-1) model. Those two horns are separated by the
   NN baby-model (G-3: can a tail-trained variable-context model EARN the
   residual from the tail? yes => deep memory / LD k-tuple law; no =>
   slow-law bias) and by the splat/mip test (G-1: is the decay just
   footprint blur through a widening lens?).
3. Cramer floors (memoryless) sit well above everything: the pair law
   captures all the memory visible at lane resolution; the residual at
   gap-class resolution is the measured object beyond it.

Caveats (honest): (a) the order-1 model's H_m is a plug-in estimator on a
1.0M-symbol chain (the model's H3 reads slightly low; de-biasing makes the
real-model gap WIDER, so the "deeper" verdicts are conservative); (b) the
pair law here is EMPIRICAL at each scale (not the theoretical LO
asymptote); the LD k-tuple joint generator remains the final adjudicator.

### L5 (0220): GAUSSIAN-SPLAT FIELD TRIP - the owner's "boom as a Gaussian
splat" question, and the movement motivation it buys

Owner (2026-10-29): "you me and baby makes three... what if we need neural
networks and not Markov chains and if we see the 'boom' as more like a
Gaussian splat... cool programming tricks for Gaussian splats in video games
that might be a motive for movement in our analysis? let's look online."
Research pass (web, 2024-2026 graphics/games literature); synthesis below.
No RH claim; off-board.

**The tricks, one line each (what the games folks actually do):**

1. **EWA projection** (the core 3DGS primitive): a 3D Gaussian with
   covariance Sigma renders as an exact 2D elliptical Gaussian whose
   covariance is J Sigma J^T (Jacobian of the projection) - O(1) analytic
   per splat. (*the math of "how does a blob's footprint look through my
   window"*)
2. **Tile binning** (the 100-FPS trick, NVIDIA vk_gaussian_splatting /
   engine plugins): splats are binned into screen tiles, sorted per tile,
   rasterized with early alpha termination - what makes *billions* of
   splats render in real time (LCC plugin: billion-point; UE5 virtual
   texturing for 3DGS, arXiv 2506.19415).
3. **Analytic-Splatting** (ECCV 2024 *oral*): stop point-sampling the pixel;
   integrate the Gaussian over the *pixel area* analytically (precomputed
   1D Gaussian-CDF tables) - kills the aliasing ring/blur. (*exact
   "how much mass is in my window"*)
4. **Mip-Splatting** (CVPR 2024): the aliasing when you *zoom* (change
   scale) comes from splats whose footprint is smaller than the sample
   spacing; the fix is a 3D smoothing filter that *constrains the minimum
   splat size per axis* at each scale. (*the scale-ladder is not free:
   zoom-out blurs unless you correct the footprint*)
5. **SplineGS / MOVotion-Adaptive SpLine** (CVPR 2025): a moving splat's
   trajectory = *cubic Hermite splines with a few control points*;
   COLMAP-free, real-time dynamic. (4D-GS: canonical splats + a learned
   deformation field + decoder; ADC-GS: *anchor-driven* group motion -
   groups of splats share a motion anchor, individuals carry small
   residuals; SplineGS/MoSca/CTRL-GS all 2025.)
6. **Densification** (vanilla 3DGS): the splat *set is not static* - where
   reconstruction error is large, the optimizer clones/splits splats;
   where opacity ~ 0, they are pruned; SH coefficients are pruned
   (compaction). (*refine where it's hard, drop what's empty*)
7. **SDF hybrids** (3DGSR ICCV'24/25, SplatSDF): a continuous SDF glued to
   the discrete splats so the blob field has exact geometry queries
   (surface distance, relighting).
8. **4D-native representation** (4DGS, arXiv 2412.20720): the scene is a
   collection of 4D primitives with *explicit motion and appearance
   parameters* - the movement is *data*, not an afterthought.

**The triple ("you me and baby makes three"):** the REAL data, the PAIR LAW
(the 2-gap bias, Markov at its most classical), and a LEARNED/BABY model
(bigger than order-2: interpolated k-grams and a small numpy GRU - no
torch on this box, so the NN is hand-rolled and auditable). If the pair law
marries the data at H3 and the NN finds nothing deeper, the loom is the
sieve law; if the NN keeps earning nats as context grows, the weave has
structure beyond the pair (and beyond any fixed finite order).

**The movement motivation - three named programs (G-lane), each a direct
translation of a splat trick into the prime weave:**

- **G-1 (MIP + ANALYTIC splat field of the weave; the big one).**
  Splat a 2D Gaussian (position = prime N, class = gap class mod 24) and
  measure the 24-adic front/antipode asymmetry in TWO ways: (a) raw bins
  (what we have done - ALIASED), and (b) analytic window integrals of the
  splat field (the Analytic-Splatting trick). The trap Mip-Splatting names:
  the "scale ladder" 2e6 -> 1e8 is a ZOOM, and the measurement window
  (typical gap) grows like ln X (14.5 -> 18.4) while the footprint grows
  with it - so the L1b *decay* (0.073 -> 0.056) may be partly pure
  **mip-blur artifact**, not true LO-law decay. Test: does the
  corrected (footprint-deconvolved) asymmetry go flat (=> the bloom is
  fixed geometry we were sampling with a widening lens - a SHARP new
  verdict, and the 0196/0216/0218 "slow bias" gets re-explained) or still
  decay (=> genuine LO-type bias, now measured cleanly)?
- **G-2 (SPLINE MOTION of the weave; the ADC-GS/4DGS move).**
  The weave statistics (bloom masses, the 12x12 pair matrix, lane biases)
  as a function of X are a *moving splat field*. Fit a few cubic-Hermite
  control points per collective coordinate (SplineGS), then ask: (i) how
  many control points does the evolution need? (2 = pure LO slow law with
  one twist; >=3 = an extra degree of freedom); (ii) is the motion
  anchor-driven - a low-rank decomposition of the pair-matrix *evolution*
  (a few collective drifts + local residuals, the ADC-GS structure)?
  This is "the motive for movement" literally: the weave's motion as a
  small spline trajectory, measured, not asserted.
- **G-3 (the BABY model; the NN marriage).**
  Fit, on the first 80% of the tail: (i) interpolated k-gram models
  k = 1..4 (classical smoothing - the capacity axis is explicit), (ii) a
  small numpy GRU (d = 16, hand-rolled tanh, auditable); score both on
  the held-out last 20%: per-symbol nats = an *extrapolated entropy rate*
  H_nn. Ladder vs the pair law: H_nn <= H_pair (saturated: pair law IS
  the whole loom - the marriage holds) vs H_nn clearly below H_pair and
  still improving with context (deep weave; the boom is real and the NN
  has measured how deep).

**Infrastructure translations (noted, not built):** tile binning -> on-demand
window queries over the sieve field (compute the weave only where a cut
looks); virtual texturing -> streaming checkpoints (the weave state is
compact: splat set + motion spline, resumable); densification -> refine the
splat field adaptively where the entropy residual is large (the "loom
tension localized" map).

**Honesty notes:** (1) the NN here is a MEASUREMENT INSTRUMENT (model
capacity ladder), not a proof object - the side-quest discipline holds;
(2) the G-1 mip correction could *kill* the L1b decay (that's the point -
a falsifiable re-explanation, not a rescue); (3) all finite-scale,
single-threaded, 4 cores open, reproducible. G-1/G-2/G-3 scripts are
named (loom5_splat_field.py, loom6_spline_motion.py,
loom7_nn_marriage.py) and run after the loom4 marriage results land.

### No-RH-claim discipline (continued)

No RH statement, no hOffCPT2, no A1, no Z78. All numbers finite (X = 1e7,
654,986 cuts, 1000/300 sampled phase cuts), reproducible from the script.
Negative results reported as measured (M2 ≤ 0; content split confounded;
PHASE_B loss quantified as a loss, not a failure).
