# IDEA SEED 4 — the prime PATTERN-DIAGONAL (gap-history identity ×
# 24-adic Fibonacci shadow × Cantor diagonal)

Status: **SEED (captured 2026-10-28) + PROBE-0 EXECUTED 2026-10-28**
(owner's direction: "let's take a break and explore a new direction...
if it makes sense, this needs to go into a plan file").
Companions: `docs/IDEA-SEED-EULER-PRIMAL-BLOOM-2026-10-23.md` (seed 3,
the 24-wheel + Fibonacci shadow + the F13 prediction measure),
`docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md` (seed 1),
`docs/IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md` (seed 2).
Off-board side quest (sibling of the orbital two-body side quest).
**No RH claim.**

---

## 1. The idea, in the owner's words (2026-10-28, verbatim core)

> "We're basically doing taylor series from backwards, but we know the
> 24-adic fibonacci pattern can sort of predict a future where there is a
> 'deficit of primes' — information that we'd need in the taylor series for
> that period covered by (for example) a single 24-adic period of
> 'unexplored future' — we have a prime distribution algorithm that tells
> us how many primes should appear within that period. So what if we look
> at each prime as having an identity that is based on something like the
> spaces between primes in its history so for 5 we would have 5-3-2 and the
> spaces would be 2-1-1 (to go from 5 to 3 to 2 to 0), right? So each prime
> has a 'pattern' and what if we make Cantor's Diagonal for what the next
> patterns could be and we do some reasoning about the problem and say 'we
> can use the diagonal argument to help predict the spacing for the next
> primes and where they must fall, according to our future prediction
> mechanics, the orbital constraints, tail simplification and exploration,
> and everything else'. I'm not sure if this direction is sound or if we're
> already exploring it, but let's see where it goes."

## 2. Faithful reconstruction (pinned, for the executing session)

Objects:

- **The gap-history identity.** For a prime p = p_i with nearest-smaller
  prime chain p_i > p_{i-1} > ... > p_1 = 3 > p_0 = 2, the gap history is
  (g_{i-1}, g_{i-2}, ..., g_1, g_0, 2) — the consecutive gaps down to 2,
  then the constant 2→0 leg. **Convention pinned:** history(5) = (2, 1, 2)
  for the chain 5−3−2−0 (the owner's "2-1-1" reads the final 2→0 leg as 1;
  it is 2). For a LARGE prime the full history is the ENTIRE prime-gap word
  below it, reversed: the identity injects the whole prime set. The
  testable object is therefore the **windowed tail** (finite memory K).
- **The 24-adic Fibonacci shadow.** The FIB shadow of seed 3:
  S_b = (F_b mod 24, F_{b+1} mod 24) on the stage-0 wheel band
  b = p mod 24; Pisano period EXACTLY 24 (π(24) = lcm(π(8), π(3)) =
  lcm(12, 8) = 24). Claim under test: the shadow state (the "24-adic
  period") predicts the FUTURE DEFICIT of primes (li(x) − π(x)-type
  shortfall / the KCS odd-density residual) in the next window.
- **The candidate window ("unexplored future").** A future segment
  (p, p + L] with a prime-distribution-algorithm prediction (C = predicted
  count, total gap mass L, parity/wheel admissibility): the finite set of
  admissible gap words is the "pattern space"; the diagonal move is
  (i) witness aperiodicity of the real word against every periodic /
  finite-state (in particular period-24 shadow) candidate, and (ii) prune
  the candidate space by provable local impossibility (the wheel = the
  mod-2 sieve spectrum).
- **The diagonal argument, stated honestly.** Cantor diagonalizes a
  COUNTABLE list into an existence/non-existence certificate. It never
  LOCATES the next prime. Its sound uses here: (a) the aperiodicity
  certificate (Morse–Hedlund: p(k) > k for one k ⇒ the word is aperiodic;
  on the RAW unbounded-alphabet word, aperiodicity is a theorem — gaps are
  unbounded (Baker, 1862), so NO ultimately-periodic predictor, including
  every period-24 shadow cycle, can represent the full word); (b) the
  sofic/complexity audit (does some small N-state machine fit the
  coarsened word? bounded by factor-complexity growth).

## 3. What already exists (and what this adds)

Already in the program (reused, not re-derived):

- **Seed 3 / PRIME-BLOOM (2026-10-23):** the 24-wheel digit spectrum, the
  4-shape triangle census, the Fibonacci shadow as a carried feature, and
  **F13 (positive measure)**: next-VERTEX local triangle count predictable
  from the past at r = 0.2508 (local field overlap / local-state
  persistence); the **shadow-state table alone scored r = −0.009** — the
  geometry is the map, not the predictor, at X = 2e6.
- **Seed 1 / PRIME-LATTICE (F8):** the lattice sits on the ln-rate
  baseline (the structured-null verdict).
- **Seeded-Fibonacci periodicity law:** the /5 shadow-drop (c ≡ 3 mod 5
  under 5m: period exactly π(m)/5) — a fib-periodicity law NOT yet tested
  against prime deficits (a genuinely separate state space from mod 24).
- **24-adic front/back law:** multiplicities vs non-multiplicities, two
  front-back laws (day006 cyclotomic 12/24).
- **KCS U1a–U4c (the "orbital constraints"):** the exact sieve-action
  identity and the U3c residual LAW — the program's ACTUAL measured
  future-deficit mechanism (windowed odd-density deviation, verified to
  1e13; relative precision ~1e-4 at that scale).
- **The RH missing-tail program ("tail simplification" / "the taylor
  series from backwards"):** the extrapolation of the tail series into
  future periods consumes the prime main term (RVM) — the future prime
  data it needs at mean-field level is ALREADY supplied by RVM + the
  measured KCS residual shape.

New here: the windowed gap-history state, the diagonal/complexity
certificate, and the shadow→deficit test at the gap/deficit level (F13
tested the shadow against triangle COUNTS, not against the deficit).

## 4. PROBE-0 results (X = 2e6, bloom scale; 2026-10-28)

Reproduction: `scripts/rh/prime_pattern_diag_probe.py`
(→ `tmp/pattern_diag_probe.out`; ~6 s, 1 core).

A. **Identified — the identity compresses nothing (as claimed).**
   Windowed-tail collisions: K=1: 60 distinct tails (99.96% collision);
   K=3: 8,410 (94.35%); K=4: 36,726 (75.34%); K=6: 130,345 (12.48%).
   The full history = the prime word below p = the prime's own index.
   ⇒ the "pattern of p" as predictor must be WINDOWED (finite memory).

B. **Complexity audit: the real word has WEAK finite memory above the
   i.i.d.-from-marginals null.** Coarse gap classes (5 letters):
   p(2) = 74 < E_iid 81; p(3) = 586 < E_iid 729; p(4) = 4,517 < 6,410;
   p(5) = 26,447 < 39,309. Raw (g//2): p(2) = 1,030 vs shuffle-null
   1,244–1,295 (−19%); raw p grows sub-iid but superlinear (not SFT-tight,
   not period-24-tight either). Entropy rate (coarse): H1 = 2.9780,
   H2/2 = 1.4580, H3/3 = 0.9598 bits/letter vs shuffle 2.9792 / 1.4895 /
   0.9927 — ≈0.03 bits/letter of order structure beyond the marginals at
   the k = 3 scale.

C. **Diagonal witnesses (Morse–Hedlund), explicit.** p(3) = 586 > 3 with
   witnesses (2,2,4),(2,4,2),(4,2,4),(2,4,6); p(4) = 4,517 > 4 with six
   listed 4-grams; p(5) = 26,447 > 5. ⇒ the coarsened word is aperiodic;
   on the RAW word aperiodicity is a theorem (unbounded gaps, Baker 1862):
   the diagonal against ALL ultimately-periodic shadow candidates (incl.
   every period-24 cycle) wins on the full word.

D. **The 24-adic Fibonacci shadow test: REFUTED as a fib mechanism — it is
   the wheel spectrum in a Fibonacci costume.** b ↔ S_b is INJECTIVE on the
   8 prime bands (the shadow state carries exactly the band and nothing
   more). Per-band gap structure at X = 2e6: bands {5, 11, 17, 23} allow
   gap 2 (twin share 0.198–0.203, mean gap ≈ 12.9); bands
   {1, 7, 13, 19} forbid gap 2 (twin share 0.0000, min observed 4, mean
   gap ≈ 13.9). The "deficit" grouping signal (χ² = 39,432 vs shuffle-null
   median 776 over 24-shadow states on resid = ln p_i − g_i) is exactly
   this two-class wheel-allowed spectrum — a deterministic mod-24 sieve
   artifact, not Fibonacci dynamics. F13's independent shadow-table score
   (r = −0.009 on the triangle count) agrees: the shadow is not where the
   predictability lives. **The genuinely untested fib object is the
   seeded-fib /5-law shadow (X2 below) — a different state space.**

E. **The honest "predict the next spacing" test (bloom F13 protocol,
   held-out upper 20%, detrended flat-trend slice):**
   const (running mean): r = +0.0032, MAE 8.654;
   prev raw gap: r = −0.0565 (the known weak anti-persistence), MAE 12.541;
   prev2: r = −0.0641, MAE 10.988; prev3: r = −0.0585, MAE 10.323;
   **3-coarse-class windowed history: r = +0.0571, MAE 8.605 (−0.6% vs
   const).** Tiny but real: the WINDOWED HISTORY (the owner's identity, in
   its only sound form) beats the memoryless baseline; the raw gaps don't
   carry it — the coarse class does. (Compare F13: the 1000-ray
   neighborhood state r = 0.2508 — the local FIELD has ~4× more memory
   than the gap word.)

F. **Typicality:** the real coarse word is slightly MORE compressible than
   an i.i.d. draw from its own marginals (H3/3 = 0.9598 vs 0.9927) — the
   "unexplored future" window is above-chance predictable in the weak
   finite-memory sense, and nothing stronger shows at this scale.

## 5. Verdict (honest, component by component)

1. **Identity as predictor — SOUND, windowed only.** The full gap history
   is the prime set itself (injective = the index); the testable state is
   the windowed tail. It carries a small real signal (E: r ≈ +0.057).
2. **24-adic Fibonacci "future prime deficit" prediction — UNSOUND AS
   STATED at mod 24.** The shadow is informationally identical to the
   band mod 24; the measured deficit structure is the wheel-allowed gap
   spectrum (a sieve artifact). What the fib DOES do is the /5 shadow-drop
   law (seeded-fib) — untested against deficits; that is experiment X2.
3. **Cantor's diagonal — SOUND in its certificate form, NOT a locator.**
   It certifies aperiodicity (witnesses above; theorem on the raw word via
   Baker) and bounds which finite-state / shadow machines can represent
   the word. It cannot, in any formulation, tell us where the next prime
   falls — that would be a non-sequitur the program must not write.
4. **"Where they must fall" (the candidate-window prune) — REDUCES TO THE
   SIEVE.** Admissible gap words = admissible-tuple admissibility
   (Hardy–Littlewood singular series territory); the diagonal + wheel
   removes only the provably impossible. The KCS residual law (verified
   1e13) is the program's actual future-deficit mean field; at 2e6 the
   pattern mechanism adds no resolution beyond it (E, F).
5. **Sound overall DIRECTION.** The idea generates: (i) a real weak
   finite-memory law in the gap word, (ii) a provable aperiodicity
   certificate with explicit witnesses, (iii) a clean refutation record
   for the mod-24 shadow-as-predictor (protects the program from
   re-running F13's finding as a new result), and (iv) one genuinely
   open fib test (X2).

## 6. Feed condition for the "taylor series from backwards" (tail program)

The tail extrapolation into a future period needs future prime DATA at
mean-field precision. Supply chain already in the program: RVM main term
+ KCS measured residual shape (relative ~1e-4 at 1e13). The
pattern/diagonal mechanism earns a feed slot ONLY if it beats that
mean-field precision on the relevant window scale — not demonstrated at
2e6 (E/F); the criterion is recorded here, pre-registered.

## 7. Frozen next experiments (if the owner continues)

- **X2 — the seeded-fib /5 shadow vs deficit (the untested fib state).**
  States: the 20-cycle / 4-cycle / {0} split of the seeded-fib law at
  moduli 5m (the 4-cycle = the c ≡ 3 mod 5 class). Test: per-2000-prime
  block deficit d_k = (predicted count by RVM) − (actual count), grouped
  by the fib shadow state at the block start; chi vs 200-shuffle null +
  the band-mod-24 GROUPED comparison (to show the fib state carries
  information BEYOND the band — the D lesson). Scale 2e6 first.
  Pre-registered: skill above the band-grouped null = positive
  (a fib-deficit law exists at this scale); else the fib shadow is
  documented as map-only here, as in F13/D.
- **X3 — memory-length scan.** Skill of the K-coarse-class windowed
  predictor, K = 1..8 (train/holdout splits as in E; also the per-MAE
  curve). Find where the gap-WORD memory peaks; expect the neighborhood
  state (F13) to dominate → then the composite state = (K-tail) ⊕
  (local 1000-ray field).
- **X4 — scale-up of the complexity audit (X = 1e8, bloom hook (a)).**
  Does the above-i.i.d. excess (B/F) decay with scale (finite memory,
  Cramér-like null recovered) or persist (a law)? p(3)/E_iid and
  ΔH3/3 vs shuffle, plus the E-skill re-measured.
- **X5 — the Lean certificate (cheap, side-quest formal, NO RH claim).**
  (a) norm_num lemma: the six listed k=5 coarse 5-gram witnesses are
  distinct (finite statement, 9-letter alphabet); (b) statement + cited
  Baker (unbounded gaps) ⇒ the RAW gap word is aperiodic
  (no ultimately-periodic predictor); (c) norm_num lemma: b ↦ S_b is
  injective on the 8 prime bands (the mod-24 shadow ≡ the band). The
  honest artifact: a small `RhAttack`-adjacent side-quest module or
  standalone file under `formal/` following the W2M5 data-adjacent
  pattern — to be built when the side quest gets formal air.
  (Optional extension: a sofic bound — the real word is NOT a sofic
  shift with state ≤ N for a certified N, from the p(k) growth.)

## 8. Discipline

- Off-board side quest; never on the RH critical path; ≤ 2 cores on any
  run; scratch under `tmp/`; 4 cores always left open (standing rule).
- No RH claim in any artifact of this seed. "Deficit" language is the
  li-deficit / KCS-residual language, not a zeta-zero statement.
- The D refutation is a PROTECTION record: do not re-attribute mod-24
  band structure to the Fibonacci shadow in any later report.

## 9. Reproduction

    cd /home/jsmille/Projects/rh-missing-tail
    python3 scripts/rh/prime_pattern_diag_probe.py
    # → ~6 s, 1 core; output: X line, sections A–F; full: tmp/pattern_diag_probe.out
    # probe-0 artifacts: tmp/pattern_diag_probe.py (tmp copy),
    # tmp/pattern_diag_probe.out
## 10. THE LOCAL MODEL (owner's 2026-10-28 refinement, pinned) + PROBE-1 results

### 10.1 The model, as specified by the owner (pinned verbatim meaning)

The local model of the prime p on the integer line has **one central
state + four frames** (two frames x two times), all 24-step wide:

```
                 PAST                          FUTURE
        ABSOLUTE   [past-absolute]    [future-absolute]
        RELATIVE   [past-relative]    [future-relative]
                   +  CENTRAL: the normal orbit, the "state of the moment"
```

1. **Past-absolute** — "the full 24-step pattern for the absolute
   position of the current prime (the one starting from zero)": the
   base-24 digit word of p, least significant first (d_0, d_1, ...).
   The digits ARE the 24-step pattern of the position going back to 0.
2. **Past-relative** — "the full 24-step pattern back for the spaces":
   the last 24 gaps (spaces) behind p as a 24-symbol word.
3. **Future-relative** — the 24-step predicted PATTERN OF GAPS for the
   future. Prime distribution theory gives a per-step prediction that
   CHANGES EACH STEP ("the deficits should always be changing"): the ln
   density slope (smooth) + the wheel phase + the small-prime blockers
   (discrete step-jumps).
4. **Future-absolute** — the 24-step predicted PATTERN OF COUNTS for
   the next 24 absolute steps (each 24 units = one revolution of the
   wheel): expected counts (8 prime bands x local density).
5. **Central — the normal orbit, the state of the moment** — the local
   field state at p (the seed-3/bloom neighborhood state).

**The Taylor clause (owner):** the only place the FULL history is
allowed is "the normal taylor series (and related structures) that are
'the moment up to that point'". Everything else is 24-wide. This agrees
with probe 0 A (the full history = the prime set itself, no
compression) and with the tail program (infinite history enters only
through the Taylor accumulator).

### 10.2 Probe-1 results (X = 2e6, 1.2 s, 1 core; tmp/pattern_diag_probe1_full24.py)

Target 1 — the NEXT GAP magnitude (held-out upper 20%, detrended vs
ln(p_{i+1})):

```
  band (= p mod 24)                   r = +0.0118   MAE = 8.6318
  m2 = p mod 576 (digits d0,d1)       r = +0.0038   MAE = 8.6330
  m3 = p mod 13824 (digits d0..d2)    r = +0.0107   MAE = 8.6537
  p mod 5 only (d0 - d1)              r = +0.0047   MAE = 8.6315
  band x mod 5 [32 nodes]             r = +0.0336   MAE = 8.6111
  exact-gap tail K=1                  r = +0.0680
  exact-gap tail K=2                  r = +0.0742   <-- MEMORY PEAK
  exact-gap tail K=3                  r = +0.0555
  exact-gap tail K=4                  r = +0.0324
  exact-gap tail K>=6                 r ~= 0        (memory dies by K=6)
  central = 1/d_local (last 576 u)    r = -0.0317   <-- WRONG GRANULARITY
  (ln trend baseline MAE = 8.8893)
```

Target 2 — the TWIN event g[i] == 2 (the sharp sieve target; AUC,
Mann-Whitney, ties half-ranked):

```
  band (p mod 24 alone)               AUC = 0.7814   <-- the wheel phase is the engine
  band x mod 5                        AUC = 0.7354
  p mod 5 hard blocker                AUC = 0.6380   (theory ~0.66: blocked class = 1/4 of non-twins)
  a-priori blocker product (5,7,11)   AUC = 0.7416   (< band: missing the mod-3 block, which 24 holds)
  band x mod5 / graded mod5           AUC = 0.637 / 0.735
  twin share by p mod 5:  0.1329 / 0.1343 / 0.0000 / 0.1322
                            (class 3 = 0 mod5: BLOCKED, exactly 0)
```

Future-frame demo (the per-step pattern CHANGES each step, as the
owner said): at p = 1441051 the predicted gap word starts
14.181, 14.181, 14.181, **14.621**, 14.621, 14.181, ... — the +0.44
step-jumps are the mod-5 twin blocker firing as the running height
crosses h = 3 (mod 5); the smooth ln slope adds ~1e-5/step. The
absolute frame's per-step expected count likewise slopes down each
step (8/ln at the running height). The "deficit should always be
changing" is EXACTLY this: smooth ln slope + discrete wheel/phase
events.

### 10.3 Frame roles (verified, pinned)

- **Past-absolute = the PREDICTION ENGINE, not memory.** The base-24
  digits of p ARE the small-prime residues (d_0..d_1 carry mod 5 via
  d_0 - d_1, etc.). The wheel phase (d_0) alone is the strongest sieve
  predictor in hand (AUC 0.7814 on the twin event); deeper digits add
  the 5/7/11 refinements. This frame BUILDS the future frame.
- **Past-relative = the MEMORY frame.** Real short memory, peak
  r = 0.0742 at K = 2, decays to ~0 by K = 6. The 24-step width is
  MORE than the memory needs; 2-wide is the effective memory.
- **Future (rel + abs) = the THEORY frame** — built, not predicted:
  ln slope + wheel phase + small-prime blockers + the KCS residual law
  (the measured deficit shape to 1e13). Its per-prime realized minus
  predicted residual is the object in 10.4.
- **Central = the neighborhood field.** The 576-unit (24 absolute
  steps) local count is the WRONG granularity at this scale
  (r = -0.0317, pure noise); the working central state is the seed-3
  1000-ray neighborhood field (F13: r = 0.2508). Pinned: central =
  neighborhood-scale field, not a 24-step count.

### 10.4 THE PIECE NOT SEEN (named): the per-prime DEFICIT SIGNATURE

    signature(p)  :=  realized next-24-pattern (gaps + revolution
                      counts)  -  theory next-24-pattern (engine).

A 24-symbol vector per prime. It is the model's OUTPUT object — the
"deficit should always be changing" made into a data object per prime.
Not yet computed. Its typicality distribution (is the actual prime
typical in its deficit signature?) is the new measure this model
exists to produce. The cross-frame test (does central + past frames
predict which signature-CLASS the future lands in, above the theory
frame alone) is the prediction test. Both are frozen below.

### 10.5 Frozen experiments (update to section 7)

- **X6 — the deficit signature (the named object).** Assemble the
  theory 24-pattern for each prime (ln slope + wheel phase + 5,7,11
  blockers + KCS residual at the scale), the realized 24-pattern
  (next 24 gaps; next 24 revolution counts), take the difference;
  report its distribution + the typicality test (real word vs
  i.i.d.-from-marginals of the signature components).
- **X7 — the cross-frame test.** (central 1000-ray field) +
  (2-wide exact gap tail) + (band) -> signature class (coarse bins of
  the deficit signature), baseline-scored vs theory-frame-alone and
  shuffle. The composite-state test: does the four-frame state beat
  the theory frame on the realized future?
- **X8 — the a-priori twin score v2.** band UNION 5,7,11 blocker
  product (the mod-3 block lives in 24): expected AUC > 0.7814;
  the singular-series limit (all small primes) is the Hardy-Littlewood
  twin weight — measure the AUC curve as more small primes are
  included (the "more digits = more small primes = better a-priori"
  law; it must saturate at the singular series).
- X2 (seeded /5-fib shadow vs deficit), X3 (K-scan — now ANSWERED at
  2e6: peak K=2, dies K=6), X4 (scale-up), X5 (Lean certificate)
  stand as before.

### 10.6 Probe-1 correction record (append-only discipline)

- The twin AUC target had an OFF-BY-ONE: originally scored the
  blocker at P[i] against the twin at P[i+1] (gap g[i+1]); correct:
  the twin FROM P[i] is g[i] == 2. The misaligned version's
  AUC ~ 0.48 (slightly below 0.5) was the known TWIN ANTI-PERSISTENCE
  (after a twin, the next gap is less often a twin) — a real effect,
  just not the one being tested. Corrected.
- The tie-average rank formula was evaluated inside the incrementing
  loop (r advanced per element), corrupting AUC (unit test: "perfect"
  returned 1.4). Fixed: compute the group average once, before the
  element loop. AUC unit re-test: perfect = 1.0, all-tie = 0.5.
- Probe-0 section E's "prev raw gap" r = -0.0565 stands: it IS the
  consecutive-gap correlation (target g[i+1] vs feature g[i], the
  standard one-step-ahead convention).
