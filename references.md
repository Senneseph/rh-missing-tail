# References and the prior-art line

Items marked **[pin]** are used in this project's working notes but
their full bibliographic data must be checked against the primary
source before any submission. Nothing here is cited from model
recall without a check.

## Primary (verbatim, held locally)

- Riemann (1859), "Ueber die Anzahl der Primzahlen unter einer
  gegebenen Grösse"; English: D. R. Wilkins, *On the Number of Prime
  Numbers less than a Given Quantity* — tcd.ie (EZeta.pdf), copy at
  claymath.org. Used: the explicit formula in Li form, the f(x)
  definition, the F(x) Möbius inversion, the prime-density zero
  kernel 1/lnx − 2Σ x^{−1/2}cos(γ lnx)/lnx.
- GS25 = Goldston & Suriajaya (2026), "Zeta Zeros in a Narrow
  Vertical Box," arXiv:2603.28104 — full text held locally. Used:
  W(u) = 4/(4−u²), the unconditional Montgomery theorem (BGSTB24),
  Theorem 2 (2 − C reduction), C = 4/3 under the narrow-box
  assumption. Its reference list is a clean citable source for:
  - Montgomery (1973), Proc. Symp. Pure Math. 24.
  - Levinson (1974), Adv. in Math. 13:383–436.
  - Selberg (1946), Arch. Math. Naturvid. B 48(5):89–155.
  - Pratt–Robles–Zaharescu–Zeindler (2020), Res. Math. Sci. 7(2),
    Paper No. 2 (**the 41.7% on-line / 40.7% simple+on-line record**).
  - Baluyot–Goldston–Suriajaya–Turnage-Butterbaugh (2024), Acta
    Arith. 214:357–376 (unconditional pair correlation).
  - Same authors (2025), arXiv:2501.14545 (b = 0.001 ⇒ 67.25%).
  - Goldston–Suriajaya (2025), arXiv:2511.20059.
- The 2026 Claude/Anthropic result: ≥ 2/3 (0.6725 optimized) of
  zeros in (T, 2T] simple *and* on the line; ≥ 0.83625 distinct;
  verified by Conrey & Goldston; public Lean 4 formalization.
  arXiv:2608.13637 / 2609.02882 (cleaner), note arXiv:2603.28104.
  (Recorded in this project's EXTERNAL note; RH itself: untouched.)

## Working (pin before submission)

- Berry (1995) [pin] — the optimal-truncation / remainder structure
  of the Riemann–Siegel formula; the "balance at N ≈ √(t/2π)"
  statement used in P-A.1.
- Trudgian (2011) [pin] — sharp rigorous bounds for the first ten
  Riemann–Siegel remainder terms (the algorithm inside mpmath).
- Berndt (1975) [pin] — Euler–Maclaurin tails of character sums via
  generalized Bernoulli functions (the classical cell-integral
  framework).
- Conrey (1989) [pin] — 40% simple zeros (the lineage step between
  Levinson and the PRZZ20 record).
- mpmath; numpy; CuPy (ROCm 7.x; GPU fp64 validated 1.5×10⁻⁹ vs
  CPU); TypeScript strict (functional lint: no for/if), Node 22;
  Docker (kainos-dev).

## The prior-art line (honest, per the project's audit)

**Classical (not claimed by this work):** Abel summation / the 1D
Stokes identity; Euler–Maclaurin with generalized Bernoulli
characters; Hurwitz-zeta residue splits; the 1859 explicit formula;
optimal truncation (Berry/Trudgian); the pair-correlation school
(Selberg → Montgomery → Levinson → Conrey → PRZZ20 → BGSTB → the
2026 result); the ½-phenomena listed in P-G as individual facts.

**New here (the audited contribution):** (1) the exact identity used
*as a computation* — dps-verified on generic paths (E7a) and as the
fit-free 18-phase M₁ engine (E2-exact, 1e-10); (2) the measured
structure it pins: the two-valued q=5 table, the all-integer q=13
table, D = −P at 18/18 at 1e-10, mirror symmetry M₁(r) = M₁(−r),
the zero-sum rolling trace, t-independence, and the cross-phase
drift coupling (3/5 + 2i/5)·(t/N); (3) the onset as a budget
crossing with C/|I| = ½·(t/N) (4 digits) and its identification
with the unit-magnification configuration; (4) the flatness
reading of series-side universality and the P-Z exact/remainder
decomposition; (5) the instrument and its measured reliability
(defect discovery + correction pipeline, twin-floor protocol);
(6) the certified finite-range stock (no off-line pair below 10⁶).

If a seasoned reader recognizes (2)–(4) as known under other names,
we want that reference: it is the single most valuable input this
repository can receive.

## The giants whose footsteps we directly tread

Logged so the record does not seem ungrateful.  Entries carry
the classical result we stand on,  where it lives (web-checked
against the primary source where noted,  [pin] otherwise),  and
exactly what this project uses from it.  Nothing here is claimed
as new.

- **Euler** — the product identity behind the zero-count (the
  prime harmonic series / ζ-product line,  from the *De
  seriebus infinitis* papers,  1748) [pin the exact
  volume/pages at submission].  The "Euler action" identity of
  this project is our flat 1-D reading of that classical
  identity — classical fact,  project-unique framing —  and it
  is the count the telescope telescopes.
- **Riemann (1859)** — the explicit formula,  the f(x)/F(x)
  machinery,  N(t),  and the hypothesis itself.  Held verbatim
  in this repository (see Primary section above);  Wilkins's
  English translation is the working copy.
- **von Mangoldt (1905)** — "Zur Verteilung der Nullstellen
der Riemannschen Funktion,"  *Mathematische Annalen* 60,
  1–19 (provenance-verified during the naming pass).  The
  rigorous N(t) = main(t) + S(t) separation —  the exact
  identity the telescope walks.  The approach-name (tpf) carries
  his name.
- **Hadamard (1896)** — "Sur la distribution des zéros de la
  fonction ζ(s) et ses conséquences arithmétiques,"  *Bulletin
de la Société Mathématique de France* 24,  199–220 (numdam
  copy);  **de la Vallée Poussin (1899)** — "Sur la fonction
  ζ(s) de Riemann et le nombre des nombres premiers inférieurs
  à une limite donnée,"  *Mémoires de l'Académie royale de
  Belgique* 59,  1–74 (Persée).  The zero-free region:  our
  CITED edge line (Re = 1,  and the functional-equation mirror
  Re = 0) stands on their work (SliverEdge `EdgeZeroFree` is
  the CITES-only leg).
- **Hardy & Littlewood (1921)** — "The zeros of Riemann's
  Zeta-Function on the critical line,"  *Mathematische
  Zeitschrift* 10,  283–317;  and **Littlewood (1924)** —
  "On the Zeros of the Riemann Zeta-Function,"  *Proc. London
  Math. Soc.* (2) 24,  295–318 (both web-checked).  The Ω±
  results on S(t):  the HONESTY CORE of the W2-beyond plan —
  the continuous S(t) is unbounded,  which is why the object of
  the uniform bound is the graded zero-grid walk,  not S(t)
  itself.  This project would have been quietly wrong without
  their work;  it is not,  because of it.
- **Siegel (1905)** — the Riemann–Siegel formula in its
  refined computational form (Göttingen Nachrichten;  refining
  Riemann's 1859 formula) [pin the exact issue/page].  The
  engine under every arg ζ(1/2+it) evaluation the walks
  consume.
- **Titchmarsh** — *The Theory of the Riemann Zeta-Function*,
  2nd ed.,  Oxford (1986),  §9.7 — the door's mark in modern
  dress:  the S(t) = O(log log t)-type bound ⟹ RH equivalence;
  the standard reference line used in the attack plan and the
  named provenance appendix.
- **Platt (2015)** — "Isolating some non-trivial zeros of
  zeta,"  *Math. Comp.* 84 (doi 10.1090/S0025-5718-2014-
  02884-6) — the algorithm behind the LMFDB census;  and
  **Platt & Trudgian (2015)** — *J. Number Theory* 147,
  842–851 (Corollary 1:  the computational door-mark) —
  provenance-verified during the naming pass.  Their precision
  discipline (zeros to ±2.5×10⁻³¹,  completeness by rigorous
  Turing's method) is what makes our md5-gated ingest a
  certificate rather than a hope.
- **The LMFDB collective** — beta.lmfdb.org/riemann-zeta-
  zeros:  the public census our run ingests (12,857 shards
  from the 3×10⁹ frontier toward 3×10¹⁰ in the current run),
  with the raw-data reader convention from the LMFDB
  repository's *platt_zeros.py* (Jonathan Bober) —  the 104-bit
  record format our decoder (day024_platt_fast.py) was
  verified against BEFORE trust,  and still md5-matches on
  every shard of every run.  A database as a witness:  the
  newest kind of giant —  the one that keeps the receipts.

A note on windmills:  we tilt at these knowing,  per the
owner's ruling,  that they might be giants —  and the
footprints in this file suggest they were.

