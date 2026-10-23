# PRIME BLOOM — PASS 3 EXECUTION RECORD (first construction)

Date: 2026-10-23, executed under the owner's directive "just go ahead
and execute on the idea".
Seed + frozen construction: `docs/IDEA-SEED-EULER-PRIMAL-BLOOM-2026-10-23.md`.
Scale X = 2e6, D = 2000 (1000 even rays per vertex).
Reproduce:

    OPENBLAS_NUM_THREADS=2 python3 tmp/sx3_bloom.py     # 7.4 s
    outputs: tmp/sx3_bloom_stats.json  (all tables)
             tmp/sx3_run.log

**No RH claim is made or implied.** "Phantoms" are li-deficit
bookkeeping of the constructed bloom; "predict the bloom path" is a
baseline-scored statistical skill test.

## 1. The bloom accounted (F10)

Per vertex (each of the 148,933 primes, in growth order), the 1000 even
rays back are partitioned exactly:

piece     meaning                                          total
f3  2,204,797   fresh triads (p−d, p−2d both prime)
f2 20,081,315   fresh pairs (p−d prime, p−2d not)
f1 126,646,888  fresh uniques (p−d not) = the phantom directions
sum 148,933,000 = 148,933 × 1000  exactly (100%-composition check ✓)

The phantom field measured from inside: **85.0% of all rays at the
average vertex are 1-way phantom directions** — the "electric field"
surrounds the bloom with a mean strength of 85%, and the F7 fact
(li − π > 0) is its population-level shadow.

## 2. The geometry of the triangles on the 24-gon (F11 — theorem-grade)

The 13 even chord-shape classes d mod 24 of the fresh triads:

shape  count        shape  count
0   537,290        8        14
6   558,905       10        15
12  554,642       14        14
18  553,843       16        17
2        13       20        18
4        16       22        10

**F11 (theorem-grade).** A bloom triad (p−2d, p−d, p) of primes with
p ≥ 5 exists only when d ≡ 0 (mod 6) — i.e. on the four long-chord
shapes {0, 6, 12, 18} mod 24 — or when the triad contains the prime 3
(the 8 short-chord shapes then host EXACTLY the 3-spike triads
(3, 3+d, 3+2d), 117 of them at X = 2e6: 13+16+14+15+14+17+18+10).
Proof: if d ≢ 0 (mod 3), the three members cover all residues mod 3,
so one is 3. The 4 live shapes carry 2,204,780 of 2,204,797
triads (99.999%). This is the "rule of geometry and triangles" the
directive asked for: on the 24-gon, prime triangles inscribe ONLY the
d ≡ 0 mod 6 chords (plus the vanishing-class 3-spike degenerates),
exactly as the F2 identity governed the flat lattice. The 8 dead shape
classes are the second vanishing class (F8's g=5-type story) read on
the wheel.

## 3. The multi-spectrum map (F12 — mappable, uniform)

Base-24 digits d_0..d_4 (five stages of 24 bands). Stage marginals:

- stage 0 (the sieve wheel): the 8 unit bands each hold ~18,500–18,673
  primes (18,618 ± 0.3% — uniform across the prime bands); bands 2, 3
  hold the singletons 2 and 3; **16 bands hold NOTHING** — the phantom
  outer boundary, by residue, exactly as the seed predicted.
- stage 1: all 24 bands ~6,140–6,274 (uniform).
- stage 4 (the top digit): 28,546 / 25,282 / 24,327 / 23,798 / 23,308 /
  23,011 / 661 / 0… (population decay, not structure).

Transition tables T_s (a → b, s = 0..3, each 24×24): every prime-band
row is FLAT — top-3 children ≈ 788–811 out of ~772 mean per child
(stage 0 → 1), i.e. the "entire notional projection" of each band is a
uniform spread over its 24 children at every stage. The multi-spectrum
is mappable (the four tables + five marginals are the map, in
tmp/sx3_bloom_stats.json) and its entire structure at this scale is
the EQUIDISTRIBUTION skeleton: primes are equidistributed in base-24
digits. The Fibonacci shadow (24 states; the Pisano(24) = 24 period is
asserted in code) rides on the stage-0 wheel; on the prime bands the
shadow is a function of the band, so it carries no information beyond
it (measured: identical skill, §5).

## 4. The piece-change censuses (F12b)

- Per-prime Δf3 (consecutive vertices): 91.2% of consecutive primes
  change their triangle count; p99 |Δ| = 11 (the bloom ticks at every
  vertex).
- Per-revolution Δf3 (24-integer blocks): 96.9% non-zero; p99 |Δ| = 58.
- Multi-scale ROLLOVER (at each 24^k boundary, window vs rest):

  k  B        f3 near   f3 away   ratio    f1 near   f1 away
  1  24       14.804    14.804    1.000    850.39    850.35
  2  576      14.800    14.804    1.000    850.38    850.36
  3  13824    14.617    14.805    0.987    853.05    850.35
  4  331776    9.696*   14.806     0.655    902.43    850.35

  *DEBUNKED in the pass audit: the k=4 "dip" is the boundary-0
  window [0, 50) (primes 2..47, structurally f3 ≈ 1) — a low-height
  artifact, not a 24⁴-rollover effect. The five true 24⁴ boundaries
  give means 17.75 / 14.70 / 12.71 / 14.67 / 12.50 (n = 4..15 each,
  ≈ baseline), and the random-offset window null (19.58) matches the
  height-model expectation (≈19.3). **ALL FOUR SCALES: ZERO
  ROLLOVER RESPONSE** — how many pieces change between sections at the
  digit-rollover geometry: essentially the same as off-boundary.

## 5. THE MEASURE (F13) — "can the program predict the bloom path of
the future from the past?"

Held-out: upper 20%. Predict the NEXT vertex's fresh-triangle count
f3_next:

predictor (train-fit)                 r (hold-out)
moving average of f3, window 100       +0.2508
moving average, DETRENDED (residuals   +0.2508
  after removing c/ln² from both)
ln-rate c/ln²(p) (HL baseline)          +0.0245
band-24 table (cond. on next prime's   −0.009
  band, known from wheel progression)
Fibonacci shadow-state table           −0.009
marginal mean                          −0.000
shuffle                                +0.004

Per-revolution (24-block) f3: moving avg 100 = +0.0939 vs ln-rate
+0.0216, shuffle +0.0099.

**F13 (measure, positive).** The bloom path IS predictable from the
past, above every baseline, at the vertex scale (r = 0.2508) and, more
weakly, at the revolution scale (r = 0.0939). The detrended equality
(0.2508 = 0.2508 to 4 digits while the ln-trend alone scores 0.0245)
localizes the mechanism: this is NOT trend tracking — it is LOCAL
PERSISTENCE: consecutive vertices probe almost the same prime field
(their 1000-ray neighborhoods overlap heavily), so the recent
piece-count state carries forward a Markov-like local memory. What the
24-band / triangle-shape / Fibonacci geometry contributes by itself:
−0.009 — at this scale the geometry is not where the predictability
lives; it supplies the MAP (the uniform multi-spectrum, the 4-shape
triangulation rule, the phantom boundary), and the local state rides
on top of it. This is the F8/F9-shaped result one level finer:
structured null at the level of the wheel, genuine local state in the
neighbourhood.

## 6. Verdict

1. The Euler Primal Bloom is a well-defined accounting (100%
   composition per vertex; 5-stage digit spectrum; 4 transition tables;
   24-state Fibonacci shadow) — mappable, by construction, at every
   band.
2. Its geometry at X = 2e6 is exactly the equidistribution skeleton
   plus one clean triangular rule (F11) and the phantom boundary
   (16 dead wheel bands, 85% phantom rays). No structured excess over
   the skeleton (consistent with F8).
3. The piece-change census is flat: digit rollovers at all four scales
   leave the bloom unchanged (91% of vertices still tick).
4. THE MEASURE is POSITIVE: past → next-vertex skill r = 0.2508,
   detrend-stable, above ln-rate / band / shadow / marginal / shuffle;
   the mechanism is local field overlap (local state), not the wheel
   geometry alone.
5. File: construction docs (this file + the seed) with frozen
   definitions; the open hooks are (a) scale-up X ≥ 1e8 where the
   local-state predictor should strengthen or decay decisively,
   (b) a proper local-state model (the overlap-lag structure of the
   1000-ray neighborhoods — e.g. f3 at p vs f3 at p+gap as a
   function of the shared-ray count), and (c) the multi-spectrum at
   stage 5+ (X ≥ 7.96e6) where the next digit stage first appears.

Reproduction: tmp/sx3_bloom.py, tmp/sx3_bloom_stats.json,
tmp/sx3_run.log. Runtime 7.4 s at X = 2e6 (12-worker S18 zeta stream
running concurrently; run used ≤ 2 cores).
