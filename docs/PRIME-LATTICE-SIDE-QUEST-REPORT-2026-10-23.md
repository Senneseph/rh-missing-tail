# PRIME-LATTICE SIDE-QUEST — WRAP-UP REPORT

Dates: 2026-10-22 → 2026-10-23.
Owner's idea: the branching prime lattice ("reverse sieve"), documented
verbatim in `docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md`, extended the
same night by the **lattice chimes** idea
(`docs/IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md`).
Both passes executed; this is the wrap-up on the side quest.

Companions: pass-1 record `docs/PRIME-LATTICE-EXPLORATION-2026-10-22.md`,
pass-2 record `docs/PRIME-LATTICE-CHIMES-2026-10-23.md`.

**No RH claim is made or implied anywhere in the side quest.** All
statements are zero-exclusion-free: theorems about integers, and
measured statistics of a constructed lattice.

---

## What was asked

1. Pass 1: take the branching lattice of primes (triads, single/double
   points, FLT-style square/cube connections) and "solve the reverse
   sieve by distributing its cuts in a new branching lattice system
   governed by the rules of creation for the primes from the integers."
2. Pass 2 (chimes): at every level where a sieve-branch accumulates a
   PRIME number of members the lattice "chimes"; matched leaf-triangles
   ("two parts of a heart") have a conjugation area; test whether the
   running total of areas at the chime levels acts as a COMPASS for the
   distance to the next prime — "can it predict the next prime?"

## What we built

- A concrete, verified lattice on X = 2e6 (148,933 primes, 537,257,294
  three-term prime APs): triads (p, p+d, p+2d), the joinder graph, the
  FANTASY layer (deficit spectrum of π vs li matched against
  critical-line zeros), and the branch-growth sieve of the chimes pass.
- Three independent run-to-run exactness cross-checks (AP counts,
  joinder edges, leaf census), each catching a real bug when it
  happened (re-zeta scan with the wrong zero object; an off-by-2 in the
  triangle census; a rank/value mix-up in chime heights) — the
  superseded buggy numbers are retired on disk, not silent.

## Achievements (numbered, each machine-verifiable)

**F1 (theorem-grade).** No a² + b² = c² with a, b, c all prime: mod-8
parity argument + exhaustive parametric enumeration (0 triples ≤ 2e6).
The lattice's **square layer is structurally empty**.

**F2 (theorem-grade, the "general rule").** For every prime AP the
square defect is exactly
   p² + (p+d)² − (p+2d)² = (p−3d)(p+d)
and the product **never vanishes** for a prime AP (vanishing requires
4d prime). This is the closed-form bound on the owner's "a pair of
prime triangles is bounded by [property]" — the bounding object is the
defect product, minimal |defect| = p+d at the p = 3d ± 1 family.

**F3 (measurement).** The minimal-miss class |p−3d| = 1: 1,509 APs at
X = 2e6 (out of 537,257,294), global min |defect| = 23 realized at
(17, 23, 29). Independently re-counted by two code paths in passes 1 and
2 (exact agreement) — the 1,509 is a fixed point of the exploration.

**F4 (measurement).** Scale/multiplicity: ~10,814 triads per prime on
average, minimum AP multiplicity 13 at X = 2e6 — "single vs double
points" is a local/growth distinction, not a global one, at this scale.

**F5 (measurement).** Joinder graph (window 1e5, 9,591 nodes):
1,311,218 edges (two independent runs agree exactly), max degree 395,
11,717,433 three-cycles, girth 3 — the lattice is dense and
small-world in its joinder layer.

**F6 (measurement, the FANTASY layer).** The deficit spectrum
[π(e^u) − li(e^u)]·u·e^{−u/2} has 16/16 dominant spectral peaks matched
to critical-line zero heights within 0.27 t-units (zeros found via the
real-valued Riemann Xi; N-values match Riemann–von Mangoldt to ±1;
all 813 zeros re-verified at dps 30). The lattice's growth deficit is
spectrally a zero spectrum — the owner's intuition, measured.

**F7 (measurement).** The explicit formula in the pass's own zeros:
π(x) = R(x) − Σ x^ρ/(ρ ln x) + smooth O(1..2) residual, T-stable on
[100, 1e7]; li − π > 0 everywhere sampled (min +4.08 at 100, max
+343.26 near 1e7) — the "phantom primes" of li are a positive
deficit with zero-spectral character.

**F8 (bridge verdict — the pass-1 closer).** The lattice sits **on**
the Hardy–Littlewood 3-term-AP prediction (K = 26.44 fit; R(d)
∈ [0.939, 1.022] over 3,333 admissible d; χ²/dof = 3.53) and the
near-miss classes are SMOOTLY UNDER-represented (0.51–0.63× the
corrected uniform-prime null), with a second **vanishing class** at
g = 5 (structurally: p = 3d ± 5 forces p+2d = 5(d∓1) composite).
No structured excess → pass 1 closed to appendix.

**F9 (chimes — this week's pass).**
- **207,028 chimes** censused on 78,498 growing branches (2e6), with the
  owner's own "2×3" example as the first chime (branch 2, count 2,
  height 6).
- **The isomorphism is real, in its testable form**: within a size
  class the normalized chime pattern {h/p = q_k} is EXACTLY identical
  at every prime level (structural), and the level × size-class table
  (χ² = 302,558, dof 6, perfectly banded) certifies that each level
  works its own new area with a uniform characteristic — the owner's
  "the next level must hit new areas that have a uniform
  characteristic," verifiable and true.
- **The hearts exist and were all found**: 4 complete conjugate pairs of
  prime triads mirrored about an integer axis (e.g. (97649, 130199,
  162749) ↔ (97651, 130201, 162751) about 32,550), heart area exactly
  8d (frozen F2-defect product), 1,509 total leaves = the F3 count
  again.
- **The compass is negative at this scale**: none of the four frozen
  reads (raw cumulative, local increment, standardized cumulative z,
  local growth rate) beats either baseline (ln p; li-inversion) on the
  27,805-gap hold-out — all correlations ≈ 0 ± 0.016, including for the
  baselines themselves (RMSE 11.8 ≈ the gap-scatter floor). Filing
  verdict per the protocol: isomorphism curiosity documented + filed
  next to the seed, with the full frozen machinery so a future
  scale-up (X ≥ 1e8, dense leaf population) re-runs with zero design
  ambiguity.

## What this means (honest read)

- The owner's construction intuition was **taken seriously and
  implemented to a frozen, reproducible spec** — both passes.
- What the lattice IS, at measured bounds: an exact (theorem-grade)
  re-organization of the 3-term-AP structure with two closed-form
  identities (F2 defect product; the vanishing classes), an
  isomorphism (F9) that is true in its testable form, and a deficit
  whose spectrum is the zero spectrum (F6) — the last one being the
  genuinely surprising connection: the lattice's "growth error"
  resonates at critical-line zero heights.
- What the lattice IS NOT, at X = 2e6: a carrier of structured excess
  over Hardy–Littlewood (F8), or a next-prime predictor over the
  density baseline (F9). The exploration closed where the protocol
  said it would close — with the recorded verdict, either way.
- Nothing here touches RH in either direction; the zero-spectrum fact
  (F6) is a measurement on a constructed signal, and its interpretation
  ("the same input class as the in-tree Z78* faces") is a note, not a
  claim.

## Where it stands now

- **Closed:** pass 1 (F1–F8) — appendix; chimes at 2e6 (F9) — filed with
  frozen machinery.
- **Open hooks (owner-gated, none in flight):**
  1. Scale-up pass: X = 1e8+ (branch/chime/heart machinery is O(sieve);
     the 207k-chime run took 0.5 s at 2e6 — a 50× scale is trivial;
     the leaf population becomes dense enough to make the compass
     verdict scale-bound rather than channel-starved).
  2. Lean formalization of F1/F2 and the two vanishing classes
     (theorem-grade content; small module; if the owner wants it in the
     tree).
  3. Leaf-triangle "area compass" with the FANTASY zero-sum as the
     baseline-II upgrade (the F7 machinery predicts locally at O(1..2)
     — a stronger baseline than li-inversion; only meaningful once the
     channel is dense, i.e. hook 1 first).

## File map (all reproducible)

pass 1:   tmp/sx1a_prime_lattice.py   tmp/sx1b2_fantasy_layer.py
          tmp/sx1c2_triangles.py      tmp/sx1d_diff.py
          tmp/sx1e_bridge.py          (+ logs/stats json next to each)
pass 2:   tmp/sx2_chimes.py           tmp/sx2_chimes_stats.json
          tmp/sx2_run.log
docs:     docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md
          docs/IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md
          docs/PRIME-LATTICE-EXPLORATION-2026-10-22.md
          docs/PRIME-LATTICE-CHIMES-2026-10-23.md
          docs/PRIME-LATTICE-SIDE-QUEST-REPORT-2026-10-23.md  (this file)

Superseded (buggy, kept for the record): tmp/sx1b_fantasy_layer.py,
tmp/sx1c_triangles.py.
