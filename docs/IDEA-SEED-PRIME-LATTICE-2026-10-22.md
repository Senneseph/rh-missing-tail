# IDEA SEED — the prime branching lattice ("reverse sieve")

Status: **SEED — documentation only. No plan of action, no execution.**
Owner's words, captured 2026-10-22 during the S18 run (compaction handoff
note: return to this FRESH; decide plan + execution after compaction).

---

## 1. The idea, in the owner's own words

> "What if we can connect all Primes together in a branching lattice tree
> based off the prime and 2 other primes to a triangle, and then say
> because of fermat's last theorem, they are especially connected as
> squares and then for every unique triad of primes in the progression of
> the numbers, each new one adding more 'triangles' we can link them
> together by common points and draw some NEW SYMMETRY or something
> established already that says 'a pair of prime triangles is bounded by
> [this property]' where [this property] could be a complex mesh of rules
> surrounding primes and triangles and squares and cubes and up to quartics
> as the limit for the interactions, but we connect the primes by common
> point and try to not have two points the same for many primes, we want
> highly unique combinations, so we have them as a second set of 'single
> points' and 'double points' and that is our 'prime contribution' to the
> problem, to actually tackle something going on.
>
> The hope is to establish some real facts and have this make a unique
> approach to solving the question — if not doing so outright, it
> establishes a valid scientific reasoning for bounding the growth of our
> face structures, etc, or at least simplifies it to known good limits of
> the basics. And here this is very basic, but an interesting idea of
> 'let's solve the reverse sieve by distributing its cuts in a new
> branching lattice system that is governed by its rules of creation for
> the primes from the integers.'"

## 2. Faithful reconstruction (my reading, for fresh-eyes checking)

Objects proposed:
- **V**: primes, in their natural progression.
- **Triads**: each new prime p forms triangles with "the prime and 2 other
  primes" — the lattice G grows by triad-attachment; triads linked by
  common points (vertices shared between triangles).
- **Multiplicity classes of lattice points**: "single points" and "double
  points" — a second set, recording HOW OFTEN a lattice point is hit
  (multiplicity 1 vs 2+). Ownership constraint: "not two points the same
  for many primes" = push for highly unique combinations (avoid
  multiplicity collisions across many primes).
- **The bounding property P**: the goal is a statement of the form
  "a pair of prime triangles is bounded by P", where P is a mesh of
  arithmetic rules spanning primes, triangles, squares, cubes, and
  **quartics as the interaction limit** (cubes = the FLT wall; quartics =
  the ceiling of the rule mesh).
- **FLT's role (as invoked)**: the no-nontrivial-x^n+y^n=z^n fact is what
  makes these prime combinations "especially connected as squares" —
  i.e. the additive cube-and-beyond relations are FORBIDDEN, so the
  square-level structure is the genuine/uniqueness-carrying layer.
- **The payoff sought**: (a) real new facts / a unique route to the main
  question; or at least (b) a rigorous reasoning line that BOUNDS THE
  GROWTH OF THE FACE STRUCTURES of this program (the S1/S4/cusp/wire
  faces), or (c) a simplification of that growth to "known good limits of
  the basics".
- **The one-line form**: "solve the REVERSE SIEVE by distributing its
  cuts in a new branching lattice system governed by the rules of
  creation of the primes from the integers."

## 3. Handles: established structures to check first (fresh-eyes list)

NOT a plan — just the nearest known land, so the fresh session starts with
handles instead of from zero:

- **Fermat's two-squares theorem** (the actual prime↔square bridge,
  likely what "connected as squares" wants): p = a² + b²  ⟺  p ≡ 1 (mod 4)
  (p odd prime). The squares layer of a prime lattice is governed by the
  splitting behavior of primes in ℤ[i]. If the "squares" in the idea mean
  sums of two squares, this is the entry door — and it is a real,
  complete, usable fact.
- **Möbius / squarefree structure of the ordinary sieve**: the classical
  sieve's cuts ARE already a branching lattice — inclusion–exclusion over
  squarefree integers (the divisor lattice of P(z)). In that lattice,
  "single points" ↔ μ = ±1 (squarefree cuts that count), "double points"
  ↔ μ = 0 (repeated prime factors, cuts that VANISH). "Not having two
  points the same for many primes" ↔ bounding the squareful mass. Known
  good limit in reach: squarefree density 6/π². If the reverse-sieve idea
  wants to re-distribute the cuts, the Möbius lattice is the object being
  reorganized.
- **FLT is the no-go statement, Fermat–Catalan its sharpened cousin**:
  x^p + y^q = z^r with 1/p + 1/q + 1/r < 1 has finitely many solutions
  (conjecture; theorems for many cases). "Quartics as the limit" is
  consistent with the exponent sum moving across 1 at {2,3,7+}, {2,4,5}...
  — a fresh-eyes question: is the quartic ceiling the exponent-sum
  boundary, or something else?
- **Dessin d'enfants / Belyi trees**: tree + black/white vertices with
  valence = the "single vs double point" multiplicity language is
  suspiciously close to Grothendieck's dessins; primes enter via
  discriminants of Belyi maps. If "branching lattice tree with two point
  types" is meant combinatorially, this is the closest established home.
- **Gauss circle problem / representation counts**: "a pair of prime
  triangles is bounded by P" is a boundedness statement about a counting
  function on a lattice — r_2(n)-style errors are the archetypal
  "growth of a face" problem, and its known-good-limit territory is
  explicit.
- **The program's own faces**: the wire kernels here (B5/S4 cusp factors,
  R_closed, the 8-factor product) are multiplicative over prime-related
  pieces — the "prime contribution" phrasing lands on structures the faces
  already consume. The question the owner names for the payoff: can the
  lattice viewpoint RE-DERIVE or BOUND the Lipschitz/wire-growth constants
  instead of measuring them?

## 4. Fresh-eyes questions (parked, no action)

1. Which meaning of "squares" is load-bearing — sums of two squares
   (Fermat 2-squares), literal lattice squares, or something else?
2. What exactly do "single points" / "double points" count — multiplicity
   of a lattice vertex across triads, or μ = ±1/0 in the sieve?
3. What is the precise statement the owner wants in the form "a pair of
   prime triangles is bounded by P" — and what would P need to be about
   the FACES of this program (growth bound on which face, which constant)?
4. Where does "governed by its rules of creation for the primes from the
   integers" land — generation of primes by the sieve process itself
   (reverse sieve = read the sieve backwards as a generator), or the
   additive structure of ℤ?
5. What "known good limits of the basics" does the owner already have in
   mind as the acceptable floor of success?

## 5. Discipline notes

- The owner's framing is honored: "really stupid but simple" = treat
  sincerely, expect the value to be in the re-organization of cuts and the
  multiplicity bookkeeping, not in the novelty of any single fact.
- No RH claim of any kind is made or implied by this seed.
- This is a SEED: do not start executing from this note alone; the
  post-compaction session owns the plan-of-action decision.
