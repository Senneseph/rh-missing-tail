# Prime lattice + FANTASY layer — exploration report (2026-10-22)

Status: **EXPLORATION COMPLETE (first construction pass)**. No RH claim is
made or implied anywhere in this document. Companion to
`docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md`; this is the
construct-then-report pass the owner requested after compaction.

Data: `tmp/sx1a_2e6.log`, `tmp/plattice_stats_*.json`,
`tmp/sx1b2_fantasy_stats.json`, `tmp/sx1b2_run.log`, `tmp/sx1c_run.log`.
Scripts: `tmp/sx1a_prime_lattice.py`, `tmp/sx1b2_fantasy_layer.py`,
`tmp/sx1c_triangles.py` (all exploration-grade, all run thread-capped to
respect the 4-cores-open standing rule).

---

## 1. What was constructed

Concrete reading of the seed's structure:

- **1-point prime** = a prime as a lattice vertex.
- **3-triangle connection** = a triad of primes. The natural concrete
  triad in "the progression of the numbers" is a **3-term arithmetic
  progression of primes** `(p, p+d, p+2d)`: three primes connected as a
  triangle, each new prime in the progression adding triangles with two
  earlier ones. (Necessarily `d` is even: a 3-term AP of odd primes has
  even common difference; the `2`-leg case is empty.)
- **2-point joinder** = a *pair* of primes shared by **≥ 2 distinct
  triads** — the seed's "double points" as the edge-level lattice. A pair
  `{u<v}` (gap g) sits in at most the three triads
  `(u−g, u, v)`, `(u, v, v+g)`, and (g even) `(u, (u+v)/2, v)`; it is a
  joinder iff ≥ 2 of those are prime-APs. In AP-notation, for the AP
  `(a, a+d, a+2d)`:
    - P1 = `{a, a+d}`: joinder iff `a−d` prime **or** midpoint `(2a+d)/2` prime,
    - P2 = `{a+d, a+2d}`: joinder iff `a+3d` prime **or** midpoint `(2a+3d)/2` prime,
    - P3 = `{a, a+2d}`: joinder iff `a−2d` prime **or** `a+4d` prime.
- **square layer** of a triad = the quantity `p² + (p+d)² − (p+2d)²`,
  the seed's "square bound of a²+b²=c² when they are all prime and
  different".
- **FANTASY layer** = the seed's "primes of the same size hitting primes
  that don't exist as the boundary to the other side of 1/2": the
  Riemann explicit formula — the smooth prediction `li(x)` and the
  actual count `π(x)` differ by *phantom primes*; the Riemann zeros are
  the Fourier spectrum of that deficit in `u = ln x`; the line Re = 1/2
  is the boundary, and the sum over on-line zeros is what the measured
  deficit is made of.

## 2. Facts established (this pass)

**F1 — no prime-Pythagorean structure exists.**
There is **no** `a² + b² = c²` with `a, b, c` all prime (distinct or
not). Proof (parity, complete): if `c = 2`, then `a²+b² = 4` is
impossible. If `a = 2`: `4 + b² = c² → (c−b)(c+b) = 4 → {c−b, c+b} =
{2, 2}` (impossible, `a>0`). Same for `b = 2`. Otherwise `a, b, c` odd:
`a² ≡ b² ≡ 1 (mod 8) → a² + b² ≡ 2 (mod 8)`, but squares are `0, 1, 4
(mod 8)` — never `2`. ∎
Exhaustive machine cross-check (parametric enumeration of every
Pythagorean family `(k²−m², 2km, k²+m²)·s` — complete, since an
all-prime multiple forces `s = 1`): **0 triples found for
a, b, c ≤ 2×10⁶** (and ≤ 2×10⁴). The square layer of the prime lattice
is *empty*: no prime triad closes to a Pythagorean square, ever.

**F2 — the square gap factorizes exactly.**
For every prime AP `(p, p+d, p+2d)`:
```
p² + (p+d)² − (p+2d)²  =  (p − 3d)(p + d).
```
Direct algebra; machine-verified on sampled APs (all agree).
The vanishing case `p = 3d` gives the triad `(3d, 4d, 5d)` — `4d` is
never prime — so the gap **never vanishes**: every prime triangle
misses the Pythagorean closure, and the miss is the exact product
`(p − 3d)(p + d)`. **This is the square bound the seed asks about:**
a prime triad is bounded away from squared-closure by exactly that
factor, `≥ p + d` in absolute value (since `|p − 3d| ≥ 1`).

**F3 — the minimal-miss structure is a congruence class.**
The gap is minimized exactly when `|p − 3d| = 1`, i.e. `p = 3d ± 1`,
and then `|gap| = p + d`. Measured (X = 2×10⁶):
- minimal-miss APs: **1,509** (0.03% of all 5.37×10⁸ APs) — the thin
  congruence constraint is rarer than a random 1/log² expectation would
  be, consistent with the two prime conditions `(p+d, p+2d) prime`
  being the active constraint;
- `|gap| = p+d` over minimal-miss APs: min **23**, median 651,503,
  p99 1,568,041.
- The **global minimum-miss triad is (17, 23, 29)**:
  `17² + 23² − 29² = −23 = −(p+d)`, with `|17 − 18| = 1` — the
  prime lattice misses the 3-4-5-shaped closure by exactly its own
  scale, at the smallest possible scale. (17, 23, 29 is the smallest
  prime AP with `p = 3d−1`.)

**F4 — scale / multiplicity.**
- Prime APs `(p, p+d, p+2d ≤ X)` at X = 2×10⁶: **537,257,294**
  (reproduced by two independent runs and by an independent
  endpoint-midpoint arbiter at X = 2×10⁴: match = True).
- Average triads per prime ≈ 10,814; histogram at X = 2×10⁶: **no
  prime has multiplicity < 13** — in the *global* AP count the
  1-point/2-point regime does not exist at this size; every prime is
  deeply joined. (The seed's single/double distinction is therefore a
  *local/growth* statement — see §5 — not a statement about the global
  multiplicity at large X.)

**F5 — the joinder graph is dense and has girth 3.**
- X = 2×10⁴: joinder-pair graph on all primes: 69,784 edges,
  **girth 3** (triangles exist), 1 component.
- X = 2×10⁶ (window W = 10⁵): **9,591 nodes, 1,311,218 joinder
  edges** (two independent runs agree to the edge), **max degree
  395**, and **11,717,433 triangles (3-rings)** — e.g. (3, 11, 71),
  (3, 11, 251), (3, 23, 4871): hand-checked (3,11,71): pair
  {3,11} is joinder via (3,11,19) and (3,7,11); {11,71} via
  (11,41,71) and (11,71,131); {71,3} via (3,37,71) and (3,71,139).
  The "rings of relationships" the seed names are the 3-cycles of this
  graph: triples of primes pairwise joinder-linked.
- Record of an error caught in this pass: a first triangle-count run
  carried an off-by-2 common-difference bug and reported 2,428,790
  edges; the corrected run reproduces A's 1,311,218 exactly. The
  buggy script is kept in `tmp` for the record, its numbers retired.

**F6 — the FANTASY layer is the zero spectrum (periodogram identity).**
With `R(u) = [π(e^u) − li(e^u)]·u·e^{−u/2}` on x ∈ [148, 10⁷], the
top **16 dominant oscillation frequencies of the phantom-prime deficit
all land on Riemann critical-line zero heights** (|Δ| ≤ 0.27 t-units;
e.g. peak 14.124 vs zero 14.1347; peak 48.023 vs 48.0052 — diff 0.018;
peak 64.972 vs 65.1125): **16/16 match**. The "primes that don't
exist" oscillate *at the frequencies of the zeros* — the explicit
formula made measurable.
The zero list was found by scanning the real-valued Riemann
Ξ(t) = Re ξ(½+it) — **not** zeta(½+it) (which is not real on the line;
scanning its real part yields spurious sign changes — caught and
corrected in this pass). All 813 scanned zeros re-verify at dps=30
(|Ξ| < 10⁻⁸), and their count matches Riemann–von Mangoldt to ±1 at
four heights: N(120)=38, N(300)=138, N(600)=341, **N(1200)=813**.
The 12 lowest zeros cross-check the standard table to 10⁻³.

**F7 — the deficit is a pure deficit up to 10⁷, and the explicit
formula verifies numerically with this pass's own zero list.**
- `li(x) − π(x) > 0` at every sampled point of [100, 10⁷] (0.0% 
  negative): min +4.08 at x = 100, max **+343.26 at x ≈ 9.99×10⁶**.
  Up to 10⁷ the phantom primes are all *missing* primes (the count
  sits below the smooth prediction); the sign first flips at
  Skewes' ≈ 1.39822×10³¹⁶ (known fact, RH-conditional estimate).
- The explicit formula, in the prime-counting form
  `π(x) = R(x) − Σ_ρ x^ρ/(ρ ln x) + O(smooth)`, where
  `R(x) = Σ_μ(x,k) μ(k)/k · li(x^{1/k})` is the Möbius-converted li,
  **verifies numerically** using only the 813 zeros this pass found:
  | x | A(x) = π(x) − R(x) + Σ_{t≤1200}
  | T = 120 | T = 1200 |
  |---|---|---|
  | 100 | −0.564 | −0.553 |
  | 300 | +0.032 | +0.033 |
  | 1000 | −0.332 | −0.341 |
  | 10⁴ | +2.046 | +2.049 |
  The residual is smooth (prime-power structure around x = 100 = 10²,
  1000 = 10³, 10⁴ = 2⁴5⁴), O(1)–O(2) in size, and T-stable (drift
  < 0.01 between T = 120 and T = 1200): the zero sum *is* the full
  oscillatory content of the phantom deficit up to this height.

## 3. "This general rule sets the bounds" — what the exploration
actually fixed

The exploration pinned the sentence down to **two explicit identities**:

1. **Lattice side.** The bound on a prime triad's square defect is the
   exact factor `(p−3d)(p+d)` (F2), minimized at the congruence class
   `p = 3d ± 1` with minimum `p+d` (F3). The square layer of the
   lattice is empty (F1) — so the "bounded by P" statement for prime
   triangles is *decidable and exact*: P = the (p−3d)(p+d) factor, and
   the quartic-and-below mesh the seed sketches terminates at the
   cubic wall *by theorem* (the FLT no-go), with the square level the
   only live one — and even the square level is structurally empty.
2. **FANTASY side.** The bound on the phantom-prime term is the
   explicit-formula zero sum, verified numerically in this pass by
   F7: `π(x) = R(x) − Σ x^ρ/(ρ ln x) + O(1–2)`, the spectrum of the
   deficit *is* the critical line (F6), and the size of what leaks to
   the "other side of 1/2" is a function of which zeros exist where —
   i.e. the zero-free region is precisely the bounding object on the
   phantom side. That zero-free region is **the same input class as
   this program's in-tree `d0 ≤ d0max` faces** (`[Z78G]` etc.). The
   general rule (explicit formula + zero-free region) sets the bounds
   on both faces of the duality: the prime-count face (lattice / sieve
   side) and the zero face (this program's formal frontier).

**Honest scope.** The lattice-side facts (F1–F5) are new, concrete,
machine-verified combinatorial results about prime APs and their
joinder graph. The FANTASY-side result (F6–F7) is a clean numerical
rederivation of a classical identity (explicit formula), at the range
where it is directly measurable. What is **not** yet established: a
*new* bound on this program's face-growth constants derived from the
lattice side — the channel from "AP-lattice statistics" to
"zero-free-region input" has not been constructed; the exploration
shows the duality lives at the explicit formula and both ends use the
known objects. That is the decision point for continuation (§5).

## 4. Files

| artifact | path |
|---|---|
| seed (owner's words) | `docs/IDEA-SEED-PRIME-LATTICE-2026-10-22.md` |
| lattice explorer (v2) | `tmp/sx1a_prime_lattice.py` → `tmp/sx1a_2e6.log`, `tmp/plattice_stats_{20000,2000000}.json` |
| FANTASY layer (corrected Ξ-scan) | `tmp/sx1b2_fantasy_layer.py` → `tmp/sx1b2_run.log`, `tmp/sx1b2_fantasy_stats.json` |
| zero audit + identity verification | `tmp/sx1b3_audit.py` → `tmp/sx1b3_audit.json` |
| triangle census (corrected) | `tmp/sx1c2_triangles.py` → `tmp/sx1c2_run.log` |
| superseded drafts (kept for the record) | `tmp/sx1b_fantasy_layer.py` (Re-zeta scan — wrong object), `tmp/sx1c_triangles.py` (off-by-2 dd bug), `tmp/sx1d_diff.py` (A/C logic equivalence arbiter) |

## 5. Verdict — should we continue?

**Yes — one more bounded pass, then archive.** The construction
produced real, checkable facts (F1–F3 are theorem-grade; F4–F7 are
measurement-grade, each cross-verified), and the seed's "general rule"
is now two named, numerically-verified identities rather than a mood. The continuation that would make the
pass *complete in the sense the seed hopes* — "bounding the growth of
our face structures" — is a specific, bounded experiment, not open
ended:

1. **The bridge test (the only real open question).** The lattice side
   has its own gap statistic — the triad gap `d` and the square defect
   `(p−3d)(p+d)`; the FANTASY side has the phantom deficit whose
   *frequencies* are the zeros. The testable claim: **the AP-gap
   statistics of the prime lattice (F4/F5) carry no information beyond
   the zero-free-region bound itself** — i.e. the reorganization
   simplifies to "known good limits of the basics" (the seed's floor
   of acceptable success) — or it does (a new channel). Concretely:
   compare the empirical AP-gap distribution at X = 2×10⁶ against the
   Hardy–Littlewood prime-AP prediction (a 3-line chi-square); if the
   lattice sits on the known prediction to its own noise, the seed's
   contribution is the F1–F3 fact set + the duality map, and the
   exploration **closes into an appendix**; if there is a structured
   excess (particularly in the minimal-miss class F3), that is a new
   object worth a follow-up pass.
2. **F2 as a small in-tree Lean fact** (optional, cheap): the
   `(p−3d)(p+d)` factorization and the no-prime-Pythagorean theorem
   (F1) are ~20 lines of Lean; putting even F1 in the tree would give
   the seed its first *formal* fact. Do it only if the bridge test
   says "continue".
3. **Stop rule.** If (1) shows the lattice is on-prediction, stop:
   write the appendix (F1–F7 + verdict), commit, archive the scripts —
   the seed has then paid for real facts at one pass of compute.
