# PRIME-LATTICE CHIMES — EXECUTION RECORD (pass 2 of the side quest)

Date: 2026-10-23 (executed under owner directive "Let's fully develop this").
Protocol: `docs/IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md` section 3.
Pass-1 foundation: `docs/PRIME-LATTICE-EXPLORATION-2026-10-22.md` (F1–F8).
Scale: X = 2e6 (the pass-1 scale).
**No RH claim is made or implied.** "Predict the next prime" = statistical
next-gap prediction, per the seed's own framing.

Reproduce:

    OPENBLAS_NUM_THREADS=2 python3 tmp/sx2_chimes.py     # 0.5 s
    outputs: tmp/sx2_chimes_stats.json  (all tables)
             tmp/sx2_run.log

---

## 1. Frozen definitions (protocol 3.3 — pinned before any fitting)

1. **Branch.** B_p = { p·m : m prime, p·m ≤ X }; growth order = increasing
   m, so the k-th member is p·q_k (q_k = the k-th prime) and
   c_p = |B_p| = π(X/p). Branches exist for 78,498 primes p ≤ X/2.
2. **Chime.** (p, k) with k PRIME and k ≤ c_p; chime height h = p·q_k.
3. **Conjugation (frozen, seed candidate (a))** — the pass-1 minimal-miss
   family read as a mirror pair: leaf triads with |p − 3d| = 1:
   p = 3d−1 gives triad **A(d) = (3d−1, 4d−1, 5d−1)**,
   p = 3d+1 gives triad **B(d) = (3d+1, 4d+1, 5d+1)**; B(d) is the EXACT
   reflection of A(d) about the integer axis 3d (memberwise:
   3d±1 ↔ 3d∓1, 4d±1 ↔ 4d∓1, 5d±1 ↔ 5d∓1). d even; all six members prime
   for a heart; a single realized side is a "half-heart".
4. **Area (frozen).** F2 identity of pass 1: square defect of triad
   (p, p+d, p+2d) = (p−3d)(p+d), so leaf area = |defect|:
   A-leaf area = 4d−1, B-leaf area = 4d+1; a HEART area = (4d−1)+(4d+1)
   = **8d** — a clean closed form.
5. **Birth height** of a leaf = its max member (5d∓1).
6. **Compass reads** at the last chime height h* < p_next:
   R0 raw cumulative M(h*); R1 local increment M(h*) − M(h*_−100);
   R2 standardized cumulative z = (M − E[M])/se (E, se from a smoothed
   empirical birth-rate density, 200 bins); R3 local growth rate
   M(h*)/M(h*_−100).
7. **Baselines** (protocol 3.4): b1 = ln p (E[gap | height]);
   b2 = li-inversion, predicted next prime = li^{-1}(li(p) + 1) on the
   hold-out grid.
8. **Hold-out:** primes in (1.6e6, 2e6] — 27,805 next-gaps
   (gap min 2, median 12, mean 14.38, max 126; ln p mean 14.40).

---

## 2. Chime census (protocol step 2)

- **207,028 chimes** over (6, 1,999,967] = Σ_{p ≤ X/2} π(c_p).
- By level: p ≤ 1e3: 53,337; 1e3 < p ≤ 1e5: 76,555; p > 1e5: 77,136.
- Top branches (from the stats json):

  p      c_p      n_chimes   first chime h
  2      78498    7702       6    (= 2×3 — the owner's "2x3" example)
  3      54069    5506       9
  5      33860    3626       15
  7      24900    2751       21
  11     16477    1909       33

  Hand-checked: branch p = 7 has members 14(k=1), 21(k=2, CHIME),
  35(k=3, CHIME), 49(k=4, no), 77(k=5, CHIME), 91(k=6, no) — the k=2 chime
  at h = 21 matches the script's first-chime output.

### Isomorphism test

Statement and result:

- **Within a size class (fixed c_p), the normalized chime pattern
  { h/p = q_k : k prime, k ≤ c_p } is EXACTLY identical for every branch,
  at every prime level** — a structural isomorphism, true by construction
  (the member sequence of B_p is p·{q_1, q_2, …} scaled).
- **Across levels the size composition is perfectly banded**: c_p = π(X/p)
  decreases monotonically with p, so small p carries only the largest
  branches. The empirical level × size-class chime-count table (rows:
  p ≤ 1e3, 1e3 < p ≤ 1e5, p > 1e5; columns: c_p ≥ 1000, 10–999, 3–9, ≤ 2)
  is block-diagonal:

  [[42347, 10990,     0,     0],
   [    0, 65599, 10956,     0],
   [    0,     0, 56927, 20209]]

  vs the pooled row×col model:
  [[10910, 19732, 17489,  5206],
   [15659, 28321, 25102,  7473],
   [15778, 28536, 25292,  7530]]
  with χ² = 302,557.9 (dof 6). The extreme significance is the banded
  structure itself — it certifies that "the new level hits new areas":
  each p-level works only its own size class, and within that class the
  normalized event pattern is level-invariant.

The owner's isomorphism claim **holds in its testable form** (within-level,
normalized pattern identical at every connection level) and is documented
together with the mixing law across levels.

---

## 3. Leaf/heart matching and the frozen area (protocol step 3)

- Minimal-miss leaves realized at X = 2e6: **A-side: 786, B-side: 723,
  total 1,509** — an EXACT cross-validation of the pass-1 F3 census
  (1,509 minimal-miss APs at X = 2e6, independent code).
- **Complete hearts (both twins realized): 4** — the "matched leaf
  triangles, two parts of a heart":

  d        triad A                     triad B                     8d
  32550    (97649, 130199, 162749)     (97651, 130201, 162751)     260400
  112860   (338579, 451439, 564299)    (338581, 451441, 564301)    902880
  175350   (526049, 701399, 876749)    (526051, 701401, 876751)    1402800
  192660   (577979, 770639, 963299)    (577981, 770641, 963301)    1541280

  Every entry is a verified all-prime triple; each pair is a mirror
  image about the integer axis 3d.
- Total area (all 1,509 leaves): **1,034,557,977**. The running total
  M(h) at the last chime equals this total; the smoothed-empirical
  expectation E[M] = 988,386,952 (−4.5% relative) — the expectation
  model is consistent with the realized births.

---

## 4. The compass test (protocol step 4) — READ

Hold-out (1.6e6, 2e6], 27,805 gaps, 4 reads vs 2 baselines:

read                             pearson     spearman      RMSE(next-p)
R0 cumulative raw                +0.0061     +0.0115       8.9e8 (null)
R1 local increment (blk=100)     −0.0149     −0.0115       1.4e6
R2 standardized cumulative z     +0.0038     +0.0006       18.6
R3 local growth rate             −0.0156     −0.0150       17.9
──────────────────────────────────────────────────────────────────
b1 ln(p)                         +0.0060     +0.0115       11.8
b2 li-inversion                  +0.0061     +0.0114       11.8

**Success criterion (seed 3.4): a read beats b1 AND b2 on both
correlation rank and localization → NONE of R0–R3 qualifies.**
The raw cumulative (the literal read) is at the null (+0.0115 ≈ the
baselines' own correlation with the gap — all four quantities show no
measurable information about the individual next gap at this scale).

### Honest caveats

- **Channel sparsity.** 1,509 leaves against 207,028 chimes (≈ 1 leaf
  born per 137 chimes) and only 4 complete hearts: the metric's
  information channel is thin at X = 2e6. A negative verdict at this
  scale bounds the 2e6-scale claim, not all scales.
- The baselines themselves predict nothing at this scale (spearman
  +0.0115; RMSE 11.8 ≈ the inherent gap-scatter floor around mean 14.38)
  — the test measures *measurable* improvement, and none is present.

---

## 5. Verdict (protocol 3.4 "otherwise" branch — documented + filed)

1. **The chime isomorphism is real and exact within level**: every
   prime-connection level runs the same normalized prime-count pattern
   {q_k} scaled by p, over its own (size-class) area of the lattice —
   "the next level hits new areas that have a uniform characteristic"
   holds as a structural statement, and the χ² table is the certificate
   of the level→size-class assignment.
2. **The compass does not beat the li baseline** at X = 2e6 (none of the
   four frozen reads; all correlations ≈ 0 ± 0.016). Consistent with the
   pass-1 bridge verdict (the lattice sits on the Hardy–Littlewood
   3-term-AP prediction — a metric built from it inherits the
   prediction).
3. The idea is **filed next to the seed** with its complete frozen
   machinery (branch, chime, mirror conjugation A/B(d), 8d heart area,
   birth height, R0–R3 reads, b1/b2 baselines, hold-out split) so a
   future scale-up pass (X = 1e8+ where the leaf population is orders
   of magnitude denser) can re-run with zero design ambiguity.
   Not executed in this quest (owner budget).

No RH claim: nothing here is a statement about zeta zeros in either
direction; the compass is a prime-gap prediction test only.

---

## 6. Reproduction

- Script: `tmp/sx2_chimes.py` (numpy, seconds to run; thread-capped).
- Tables: `tmp/sx2_chimes_stats.json` (census, isomorphism table, top
  branches, reads, baselines, gap stats).
- Log: `tmp/sx2_run.log`. Runtime 0.5 s at X = 2e6 (12-worker S18 zeta
  stream was running concurrently; run used ≤ 2 cores).
