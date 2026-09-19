# BACK-POCKET NOTES — 2026-09-19 (night)

Status: FLAVOR FILE. Verified facts and closed dead ends from the
end-of-day speculation turns (owner's back-pocket facts, each
checked against exact arithmetic before being kept). No project
claims; no prize claim made or implied. Dead ends are recorded as
such, per owner direction ("it's fine if the doc is empty or has
only dead ends we closed off").

## 1. The cube identity and its neighborhood (verified)

- sum of k cubed, k = 1..n, equals T(n) squared, T(n) = n(n+1)/2
  (the triangular number). Verified at n = 10: 3025 = 55 squared.
- Mechanism (the point, not the identity): it TELESCOPES.
  T(k) squared minus T(k minus 1) squared equals k cubed, exactly
  (verified: 1, 8, 27, 64, 125). A "weird transformation" of this
  species is a summand that is the discrete derivative of a simpler
  object; the sum then collapses to boundary terms.
- Classification of the power sums S(p)(n) = sum k to the p,
  k = 1..n (sympy-verified for p = 1..12; obstruction arguments
  noted where general):
  - p = 2: product form n(n+1)(2n+1)/6 (Gauss).
  - p = 3: the UNIQUE exponent for which S(p) is a perfect power
    of a rational polynomial. Obstructions: for even p the factor
    (2n+1) appears to the first power (no higher root can absorb
    it); for odd p, S(p) is a polynomial in n(n+1), of the form
    x squared times R(x) over a constant, and R(0) is a negative
    or square-free rational (verified p = 5, 7, 9, 11:
    minus-1/12, 1/12, minus-3/20, 5/12 — none a square in the
    rationals). The square-free-final-clause for all odd p is
    stated here as verified-up-to-12 with visible obstruction, not
    as a proven general theorem.
  - GOLDEN QUADRATIC (verified up to p = 12): the first exponents
    at which the factorization peels off the irreducible golden
    quadratic n squared + n minus 1 (roots carry the square root
    of 5) are p = 9 and p = 10. Near-golden quadratics at smaller
    p: p = 4: 3n squared + 3n minus 1 (discriminant 21);
    p = 5: 2n squared + 2n minus 1 (discriminant 12);
    p = 9: n squared + n minus 1 (discriminant 5). The
    discriminants drift down toward the golden value. First
    appearance within the verified range; not claimed further.
- Lesson (this is what we keep): an apparently wild sum is
  controllable exactly when the summand is a discrete derivative
  of something simpler. Both genuine finds of tonight were that
  species: the Efull imaginary channel collapsing to pi times a
  counting defect (a telescoping), and the S3a detector bound
  (a sum-of-squares ratio kept in check by quantization). The
  named next probe (day030 sub-item "full counting-function
  IBP") is precisely the telescoping test for the Efull lattice
  walk.

## 2. The Fibonacci mirror (verified, corrected to the exact fact)

Conventions: F(0) = 0, F(1) = 1 (0-indexed); 1-based list
position P(n) = n plus 1.

- Exact identity: P(n) minus F(n) equals 1 if and only if
  F(n) = n. The "unit recurrence" the owner reached for IS the
  fixed-point condition, exactly.
- Fixed points: EXACTLY {0, 1, 5}. Proof: direct check at
  0..5; from n = 5 on, F(n) minus n grows strictly (its step is
  F(n) minus 1, already 4 at n = 5, increasing), so F(n) = n
  never recurs; the small side is exhausted by inspection.
- The full difference census, d(n) = P(n) minus F(n)
  (verified to n = 10): +1, +1, +2, +2, +2, +1, minus-1,
  minus-5, minus-12, minus-24, minus-44, ... strictly
  decreasing from n = 6 (step 1 minus F(n minus 1) < 0). So the
  whole small-n shape is: a +1 pair at the fixed points 0, 1;
  a +2 window of exactly three indices (n = 2, 3, 4 — the same
  fact as "F(n) = n minus 1 holds exactly for 2, 3, 4",
  also terminal by the same monotonicity); a +1 re-emergence at
  the third fixed point 5; then the cliff: the first overtake at
  n = 6 (d = minus-1, the anti-mirror) and never back to
  plus-or-minus-1.
- The owner's three sightings (the +1 at the first 1, the +1 at
  F(5) = 5 read as position 6, and the F(6) case) are exactly the
  elements of this set; the proposed "general law" (n-th
  Fibonacci minus its index equals the unit) holds at the three
  fixed points only, and nowhere else.
- The prime-fractal recurrence question ("what it does when it
  recurses in the big picture of the fractal that is the primes"):
  CLOSED DEAD END as far as known. The recurrence location is a
  Binet-type exponential-versus-linear crossing — a growth-rate
  artifact whose exact location (0, 1, 5) carries no known
  number-theoretic specialness. No mechanism connecting the
  fixed points to prime behavior was found. Recorded as
  "no lead found", not "impossible".
- Charted neighborhood (reference only, NOT our thread;
  standard facts, not re-verified this session):
  - rank of apparition: for a prime p, the least k with
    p dividing F(k) divides p minus the Legendre symbol (5 over p)
    — the primes' mod-5 category (via the Legendre symbol of 5)
    controls their first entry into the Fibonacci divisibility
    layer; this is the genuine "back door with a plate on it".
  - F(n) prime implies n prime or n = 4 (one-way; the converse
    fails).
  - whether infinitely many Fibonacci primes exist: OPEN.

## 3. Closed dead ends (no further work planned)

- Fibonacci fixed points to prime structure: no mechanism found;
  Binet crossing is generic. (Section 2.)
- "Other exponents with clean closures": none beyond the cube for
  perfect powers (p = 3 unique, verified to 12 plus obstruction);
  the golden quadratic at p = 9, 10 is the first nontrivial core
  factorization in the verified range and is kept as a curiosity,
  not a tool, until it earns one.
- "0 to 1 holds uncountably many points but no primes": category
  error — primes are defined on integers only; the interval
  contains no candidates. The inhabited boundary is 1 (the
  unique positive unit, excluded from primality by definition;
  every prime after it). Flavor, kept on the shelf.

## 4. Active probes saved from this night (the useful part)

- TELESCOPING TEST for the Efull lattice walk: is the log-kernel
  weight a discrete derivative on the zero lattice (the sum over
  zeros equals boundary terms plus a small remainder)? This is
  the day030 sub-item "full counting-function IBP", and it is
  the direct application of the cube-identity lesson. Exact
  algebra first, before any theorem is written.
- Residual-walk correlation with local zero-gap structure (loads
  the 22GB zero arrays once, after the day034 run frees memory).
- W3 falsification: the staged 3e10 zero chain extends the
  evidence edge into real-zero territory; the decision-maker for
  the theorem investment.
