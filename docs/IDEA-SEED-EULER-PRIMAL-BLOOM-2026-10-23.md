# IDEA SEED 3 — the EULER PRIMAL BLOOM accounting

Status: **SEED (captured) + FIRST CONSTRUCTION PASS EXECUTED 2026-10-23**
under the owner's directive "just go ahead and execute on the idea".
Companions: `docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md` (seed 1),
`docs/IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md` (seed 2),
`docs/PRIME-LATTICE-EXPLORATION-2026-10-22.md` (passes 1),
`docs/PRIME-LATTICE-CHIMES-2026-10-23.md` (pass 2).
Naming context: the in-repo `docs/THE-EULER-ACTION.md` (the exact
series-side summation-by-parts identity, verified 2026-09-09) — the
bloom's "accounting" is the ledger form of that identity applied to the
growth of a constructed prime structure.

---

## 1. The idea, in the owner's words

Statement (2026-10-23):

> "What if we organize the structure as a bloom where the 2-way pairwise
> grow at one rate and their offshoots are organized through vertices to
> the unique while the baseline triple prime phantoms form an 'electric
> field' outer boundary stalker and map of where the next vertex
> junctions into a fresh 3-way, 2-way, and 1-way uniques for each of the
> 24 steps in a fibonacci primal cycle we call this representation the
> Euler Primal Bloom accounting. so we measure the relationships and
> look for where the program can predict the bloom path of the future
> from the past and that is the measure"

Execution directive (2026-10-23):

> "just go ahead and execute on the idea, one 24-band should somehow
> define and predict the next / previous according to some rule of
> geometry and triangles, and how many pieces change between sections"

## 2. Faithful reconstruction (for the executing session)

Objects:

- **The BLOOM.** The sieve-growth of the prime set read as a flowering
  graph: each new prime is a VERTEX; its OFFSHOTS are the directions d
  (the difference rays d ≤ D back through the existing tree);
  offshoots are organized through the vertices into structures of
  three kinds.
- **2-way pairwise, one rate.** Direction d back from the new vertex
  p hits exactly one existing prime (p−d prime) but does not extend
  (p−2d not prime): a fresh PAIR — a 2-way piece. "Grow at one rate":
  all 2-way pieces are counted by the one rule (one member behind,
  none behind that).
- **1-way uniques / "organized through vertices to the unique".** A
  direction where the offshoot terminates at once (p−d not prime): a
  fresh 1-way UNIQUE — a stub, the leaf-tip of the bloom. The
  offshoots (2-way) that fail to extend ARE organized into their
  terminating unique at the vertex (a 2-ray that dies becomes a 1-count
  endpoint). (The executor's split, pinned in the pass doc.)
- **3-way.** p−d and p−2d both prime: a fresh TRIAD — the leaf triangle
  of pass 1, a 3-way piece, the "triangle" of the owner's geometry.
- **Baseline triple prime phantoms / the "electric field" outer
  boundary stalker.** The FANTASY phantoms (seed 1 F7: li(x) − π(x) > 0,
  the primes the counting prediction posits that do not exist) form the
  OUTER BOUNDARY of the bloom — the field around it — and STALK the
  boundary: at each vertex the phantom directions (the 1-way dead
  rays) are exactly where a phantom "should" have been. The mapping:
  the 1-way unique directions ARE the phantom boundary, measured from
  the inside. (F7's deficit spectrum is the field's spectral
  character — pass 1 F6.)
- **The 24 steps — MULTI-SPECTRUM incremental bands (the refined,
  executed construction).** "Move past the first number and then the
  second, third": the BASE-24 DIGIT SPECTRUM. For p < 2e6 < 24^5 the
  digits d_0 = p mod 24, d_1 = (p/24) mod 24, …, d_4 = (p/24^4) mod 24
  give FIVE STAGES of 24 bands each; stage s = digit d_s, and the
  stages advance as the numbers roll (digit 0 wraps at every 24,
  digit 1 at every 576, …). Stage 0 is the sieve wheel (primes ≥ 5 in
  the 8 unit bands {±1, ±7, ±11, ±17, ±19, ±23}; 16 empty phantom
  bands = the outer boundary; bands 2, 3 hold the singletons 2 and 3).
  "For every 24-band there is an entire notional projection and
  progression": each band's population is PROJECTED onto the next
  stage — the 24×24 TRANSITION TABLE T_s(a→b) = #primes with
  d_s = a, d_{s+1} = b (s = 0..3). Every band thus carries a full
  projection map to the next stage's 24 bands, and the four tables
  (plus the five stage marginals) are the multi-spectrum — mappable
  by construction. The FIBONACCI SHADOW: the Fibonacci wheel mod 24
  has Pisano period EXACTLY 24 (π(24) = lcm(π(8), π(3)) = lcm(12,8) =
  24), so the shadow S_b = (F_b mod 24, F_{b+1} mod 24) on the stage-0
  wheel has its next/previous DETERMINED by the Fibonacci recurrence —
  the "rule of geometry" that defines next/previous on the wheel — and
  the TRIANGLES are the inscribed wheel-triangles of the fresh triads:
  chord-shape class d mod 24 (12 shapes).
- **Sections and the piece-change census.** One SECTION = one band of
  one stage, or (finest) one revolution of 24 consecutive integers.
  "How many pieces change between sections": the census Δ of fresh
  1/2/3-way pieces and of wheel-triangle shapes between consecutive
  sections — INCLUDING the multi-scale ROLLOVER census: at each
  24^k-boundary (where digit d_{k−1} wraps and digit d_k advances),
  how many pieces change vs the off-boundary norm.
- **THE MEASURE (the testable claim).** The bloom path of the FUTURE
  (next sections' piece counts and triangle shapes) is PREDICTABLE from
  the PAST (the running state of the accounting ledger: piece totals,
  per-band profile, the Fibonacci shadow, the current triangle shapes)
  to better-than-baseline accuracy. Baselines: (i) the
  Hardy–Littlewood / ln-rate expectation at the current height;
  (ii) the marginal (unconditional) profile; (iii) shuffled sections.
  Skill above all three = "the program can predict the bloom path" =
  the measure is positive; else the bloom is a structured null (on-
  prediction ledger, as the F8 bridge found for the lattice) and the
  piece-change census is its documented geometry.

## 3. Frozen construction (pass 3, pinned before fitting)

Scale X = 2e6 (the side-quest scale; the machinery of passes 1–2 is
reused, so the verdict is commensurable). D = 2000 (even d ≤ 2000,
i.e. 1000 rays per vertex).
1. **PER-VERTEX BLOOM** at prime p_n (n the prime index):
   - f3(n) = # even d ≤ D : p−d prime ∧ p−2d prime   (fresh triads)
   - f2(n) = # even d ≤ D : p−d prime ∧ p−2d NOT prime (fresh pairs)
   - f1(n) = # even d ≤ D : p−d NOT prime                (fresh uniques
     = the phantom directions of this vertex)
   - f1+f2+f3 = 1000 exactly (the 100%-composition accounting).
2. **WHEEL-TRIANGLE SHAPE** of each fresh triad at p_n: s = d mod 24
   (12 even shapes; the inscribed chord class on the 24-gon).
3. **THE 24-STEP FIBONACCI SHADOW**: table S_b = (F_b mod 24,
   F_{b+1} mod 24) for b = 0..23 (F_0 = 0, F_1 = 1); the shadow map
   b → b+1 is the Fibonacci recurrence (the "rule of geometry" that
   defines next/previous on the wheel).
4. **DIGIT SPECTRUM + TRANSITION TABLES (the multi-spectrum map)**:
   for each prime p: digits d_0..d_4 in base 24 (five stages).
   Stage marginals M_s(a) = #primes with d_s = a (5 × 24).
   Transition tables T_s(a,b) = #primes with d_s = a, d_{s+1} = b
   (s = 0..3; four 24×24 tables). These ARE the "entire notional
   projection and progression happening for every 24-band".
5. **SECTIONS AND THE PIECE-CHANGE CENSUS** — three readings:
   (A) per-prime: band sequence (d_0(p_n)) with (f1, f2, f3) + shape
       set in growth order; Δ between consecutive primes of the same
       band-visit cycle.
   (B) per-revolution: blocks [24k, 24k+23], R_k = (Σf1, Σf2, Σf3,
       shape-set); ΔR_k between consecutive revolutions.
   (C) multi-scale ROLLOVER: at each 24^k-boundary (k = 1..4, where
       digit d_{k−1} wraps and d_k advances), the fresh-piece count in
       the boundary window vs the off-boundary norm — "how many pieces
       change between sections" at every scale.
6. **THE FIBONACCI SHADOW**: S_b = (F_b mod 24, F_{b+1} mod 24),
   b = 0..23 (Pisano period exactly 24) — the deterministic next/
   previous rule on the stage-0 wheel; carried as a per-prime feature
   (shadow at b = d_0(p)).
7. **THE MEASURE (prediction tests, all baseline-scored)**:
   (A) SELF-SIMILARITY OF THE SPECTRUM: does the normalized row-
       profile of T_0 predict the row-profile of T_1, T_2, T_3 (cor-
       relation + RMSE)? High = "the same notional progression at
       every stage" = the spectrum is predictable from stage 0 alone.
   (B) NEXT-VERTEX SKILL: predict the next prime's f3 from the PAST
       (moving-average state, current band, shadow band, recent triad
       shape mix) vs baselines (i) ln-rate E[f3|p], (ii) marginal,
       (iii) shuffle. Held-out: upper 20% of primes.
   (C) NEXT-REVOLUTION SKILL: same for R_k (upper 20% held-out).
   Positive skill over all three baselines on any reading = the
   measure is positive; else the bloom is the F8-shaped structured
   null and the census + tables are its documented geometry.

## 4. Relationship to the prior passes

- Pass 1 (F1–F8) supplied the lattice, the FANTASY phantom field
  (F6/F7), and the on-prediction bridge verdict (F8) — the prior for
  this pass: if the lattice sits on the prediction (it does, per F8),
  the bloom ledger will likely sit on the ln-rate baseline (the
  F8-shaped null); a positive measure would be the structured excess
  read through the wheel + triangle-geometry lens.
- Pass 2 (chimes, F9) is the same test shape (past → future,
  baseline-scored) at a coarser state; the bloom is its finer-lens
  successor (24-wheel, triangle shapes, phantom boundary).

## 5. Discipline notes

- No RH claim is made or implied; "phantoms" are li-deficit artifacts,
  "predict the bloom path" is a statistical skill test on a
  constructed growth process.
- The phantom-field mapping (1-way = boundary) is a definition of the
  representation, validated where it can be (F7's positive deficit),
  not a claim about the phantom set itself.
- Everything frozen above is in the pass doc
  `docs/PRIME-BLOOM-PASS3-2026-10-23.md` with the execution results.
