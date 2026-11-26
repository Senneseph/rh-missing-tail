# RH-SOLUTION — the Riemann Hypothesis is proved (2026-11-20)

**Status: SOLVED and machine-verified.** On **20 November 2026**, Levent Alpöge
(Anthropic), working with Claude (an unreleased Anthropic model), released a
formal proof of the Riemann Hypothesis — and of the Generalized Riemann
Hypothesis for all Dirichlet L-functions — in Lean. On **21 November 2026**
the Lean FRO and the Mathlib Initiative jointly **certified** that both the
statement and the proof are correct. As of 26 November 2026 every independent
check has finished and passed. This document is the worktree's record of the
solution: what it is, where it lives, what the argument is, and what was
checked.

---

## 1. The statement (as proved)

The proof's `Main.lean` establishes five theorems (statements verbatim from
the challenge file, which imports only Mathlib; all notions are Mathlib's own):

**1. The Riemann Hypothesis** — Mathlib's own vetted definition
(`Mathlib/NumberTheory/LSeries/RiemannZeta.lean`):

```lean
def RiemannHypothesis : Prop :=
  ∀ (s : ℂ) (_ : riemannZeta s = 0) (_ : ¬∃ n : ℕ, s = -2 * (n + 1)) (_ : s ≠ 1),
    s.re = 1 / 2

theorem riemannHypothesis : RiemannHypothesis
```

i.e. every zero of ζ other than the trivial zeros −2, −4, −6, … has real part
1/2 (the `s ≠ 1` clause exists because Mathlib assigns ζ a conventional value
at its pole).

**2.** `riemannZeta_eq_zero_re` — the same statement written out; Lean accepts
the two formulations as definitionally equal.

**3.** `LFunction_ne_zero_of_half_lt_re` — for every modulus N ≥ 1 and every
Dirichlet character χ mod N (primitive or not): L(χ, s) ≠ 0 whenever
Re s > 1/2 (except the trivial character at its pole s = 1).

**4.** `LFunction_eq_zero_re` — for every Dirichlet L-function, zeros in the
critical strip (0 < Re s < 1) lie on the line Re s = 1/2.

**5.** `LFunction_eq_zero_re_of_isPrimitive` — the same for primitive
characters (the usual GRH statement).

**Scope:** RH + GRH for Dirichlet L-functions are proved. Extended RH, grand
RH, and automorphic L-functions in general are NOT among the checked
statements (Alpöge expects ERH to follow "with more time").

## 2. Where the proof lives

| Artifact | Location |
|---|---|
| Announcement note (4 pp) | `https://alpo.ge/remark.pdf` (this worktree's independent copy: sha256 `3fc97784b71ddd44ff8aa0a177e99622a1c61b13cfa843a0989ee4a7a0cfeb8d`, 245,114 bytes) |
| Source archive | `https://alpo.ge/lean.tar.gz.part01` … `.part14` (239,275,554 bytes joined; sha256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`) |
| Community mirror | `https://github.com/leanprover-community/riemann-hypothesis` (byte-identical to the archive apart from added Comparator files) |
| Verification record | `https://math.mit.edu/~drew/grh/` (Andrew Sutherland, MIT — "All checks have finished", page updated 2026-11-25 22:05 UTC) |
| Exported proof (61.57 GB ndjson) | `https://math.mit.edu/~drew/grh/solution.ndjson.zst` (7.70 GB compressed; unpacked sha256 `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`) |
| Challenge (5 statements, `sorry`) | `https://math.mit.edu/~drew/grh/challenge.ndjson.zst` (unpacked sha256 `bd484ac9886a96f26b1d9a7a59ebd45b7a70d102c015d4f31f9302bbdd6ab2b9`) |
| Lean FRO + Mathlib certification | `https://leanprover-community.github.io/blog/posts/riemann-hypothesis/` |
| Shorter version (Sernau, 2026-11-25) | 300,000 lines "readable" / 76,000 lines "compact", Apache-2.0; checks at `https://math.mit.edu/~drew/shortgrh/` |
| Independent tracker | `https://mathandcobb.org/rh-claims/` (Álvaro Lozano-Robledo) |
| Proof digests | Rubinstein (Waterloo) guide + `zeta-paper.pdf`; Robin Zhang (IHÉS) preliminary note; Naskręcki's `riemann-rev` map; Epstein's blueprint; Adriazola's reconstruction; Brox's distillation (WIP) |

Toolchain: **Lean v4.33.1** (commit `819816b2`) + **Mathlib v4.33.1**
(`0df444a3`) — the *same toolchain pinned by this worktree*. 175,187 modules,
≈17 million lines, ≈1.3 GB compressed source; the exported proof is
61,570,595,788 bytes.

## 3. What the argument is

Reconstructed from Alpöge's note, the Lean community's records, and the
independent AI-assisted digests of the source (Zhang, Rubinstein). Tao's
preliminary review: the proof "appears to use the full power of modern
developments on the Langlands program and arithmetic geometry"; a core idea is
to **transport methods from the Weil conjectures to the integers**.

**(a) The target.** RH is attacked through a quantitative bound on the
smoothed prime error of de la Vallée-Poussin type (the definitive switch,
2026-10-20, to):

```
G(x) = ∑_{n ≤ x} Λ(n)·(x/n − 1)₊ − x log x + (1 + γ)·x
```

(the cumulative von Mangoldt sum minus the PNT main term, plus the γ
correction).

**(b) The main estimate (the hard step).** For every ε > 0 and A there exists
Y > A such that

```
G(x) ≤ x^{1/2 + ε}        for  Y < x < Y^{3/2}.
```

A one-sided, *intermittent* estimate — a priori weaker than the uniform
error bound ψ(x) = x + O(x^{1/2+ε}) that would give RH directly.

**(c) Why the weaker estimate suffices (Landau–Turán bridge).** The Mellin
transform of the smoothed error term has poles at the zeta zeros. Repeated
differentiation of the transform introduces weights that concentrate the
integral on an interval where the weaker estimate holds; the resulting
derivative bounds are incompatible with any pole to the right of the critical
line. This is essentially classical oscillation machinery of Landau and
Turán.

**(d) Proving the main estimate — Stepanov's method over the integers.**
The engine is a descendant of **Stepanov's** argument for the RH over
function fields (Weil's theorem), where a divisor is controlled via its
*multiplicity*. Multiplicity is hard to find over the integers; the new
Fourier-analytic toy-setting idea replaces it with **chaining theta lifts**:

- Iterated theta lifts between totally definite unitary groups,
  U(X₀) → U(X₁) → … → U(Xₘ), of the shape π ↦ π ⊞ μⱼ[t]; each lift mimics one
  unit of multiplicity, and composing m lifts multiplies the associated
  integral matrices, so divisibility exponents **add**.
- **Arithmetic side** (Chebyshev's binomial-coefficient method, generalized):
  special values of theta functions and their derivatives are algebraic
  integers after normalization, so they carry prime-power divisibility that
  assembles the left-hand side of prime-power sum estimates — the terms that
  feed G(x).
- **Analytic side:** the absolute values of those special values are bounded
  by Gaussian-sum-type estimates (prototypical example:
  Tₙ = Θ⁽ⁿ⁾(0) = ∑_{λ∈ℤ[i]} λⁿ e^{−π|λ|²} on the square lattice).
- **Arakelov theory** lets the divisibility (arithmetic) data be compared
  against the analytic size estimates of the periods of the lifted forms.
- The long argument produces a **pair of competing error terms** in m: one of
  order m, the other of order x/m. Choosing the chain length
  **m ≈ √x** — Alpöge: "Claude's suggested length of chain of theta lifts …
  was √X. (And yet, what else could it be?)" — yields the required bound on
  G(x).

**(e) Supporting machinery** (from the timeline in Alpöge's note,
2026-10-06 → 2026-11-16): the Stepanov determinant; divisibility of invariant
derivations on CM curves (D p ≡ 0 for p inert); the `qN = M^k + R` sign-only
Weil–Deligne trick; Guinand–Weil sign + variance test-function arguments;
definite signs from middle cohomology via quadrics/Bertini; Gauss-sum
cancellation replaced by iterated Parseval; Iwasawa towers (Behrend); Bost's
slope inequality; the Rallis seesaw (periods of the iterated lift are Bessel
periods independent of the Hecke characters; GGP); the relative trace formula
via the sixfold cover of GL₅ (automorphy of μ as a period integral of
thetas); divisibility of order-m terms via Chowla–Selberg, Weyl and Siegel
mass; a weakened Vandiver-type statement for the surviving K₁-classes;
covolume computations and congruences between lifts. The 177,492-line
library portion (of the 300k-line readable version) supplies: class field
theory, Artin reciprocity, étale cohomology, Hodge structures, Galois
representations of modular forms, p-adic Hodge theory, crystalline
cohomology, Kisin modules, Shimura varieties, the Siegel–Weil and Rallis
formulas, the simple trace formula, Chowla–Selberg, Pólya–Vinogradov, and
the PNT for arithmetic progressions — "basically all number theory produced
in the last 50 years" (Nuccio, via the Lean community records).

**Status of human understanding** (as of 2026-11-26): no complete
human-readable account of the full argument is published yet; the
community is digesting the proof (Tao: digestion "is still some way off").
Alpöge predicts the scope will be "greatly simplified."

## 4. Verification record (authoritative)

**Lean FRO + Mathlib Initiative joint statement (2026-11-21):**
> "We have full confidence that Alpöge's proof of the Riemann Hypothesis is
> correct, and we congratulate him on this achievement. … We hereby certify
> that both the statement and the proof of the Riemann Hypothesis are
> correct. The four criteria [of the Lean community's checking protocol] are
> all satisfied."

All four criteria: (1) the statement is Mathlib's own vetted
`RiemannHypothesis`; (2) the library compiles (dozens of independent
compilations, identical export); (3) the proved theorem is exactly the
challenge statement, confirmed by two independent comparator tools; (4) the
exported raw proof passes multiple proof checkers, including third-party
checkers with formal soundness proofs relative to set theory, run on the
inert export (out of reach of any malicious code in the source).

**Sutherland's independent check table (all pass; "All checks have finished",
2026-11-25):**

- All **175,187 modules compile** (Lean v4.33.1, Mathlib v4.33.1), zero
  errors.
- `#print axioms` for the five theorems: **only `propext`,
  `Classical.choice`, `Quot.sound`** (the three standard axioms); no axioms
  declared outside Lean core (15 in the environment, all in `Init`).
- Mathlib `.olean` files **byte-identical** to the official cache
  (8,322 Mathlib + 378 dependency files).
- **Independent sandboxed rebuild** (no network, read-only source, separate
  machine): `lake build Main` exit 0; the export made inside the sandbox is
  **byte-identical** (61.57 GB, sha256 `5ea74b91…244e`) to the published
  export.
- **Kernel replay of every module**: `leanchecker` 175,187/175,187, zero
  rejections.
- **Independent kernels accept the full export**: `nanoda` (independent Rust
  kernel, 27 min 42 s / 80 threads); Lean's **default kernel** (48 h 3 min,
  peak 82.6 GiB; 9 h 8 min with a benign allocator-tuning env var); Lean's
  **paranoid kernel** (72 h 20 min; 10 h 0 min tuned).
- **Statement matching**: Comparator v4.33.0 end-to-end and
  `lake comparator` (v4.36.0) both report **"Your solution is okay!"**;
  `con-leche --compare` and `con-ron --compare` (independent implementations)
  confirm all five theorems are justified by the solution against the
  challenge.
- `lean4lean` passes all 175,187 compiled modules (five needed a raised step
  limit on `decide`-heavy computations; passed on rerun).
- One known non-determinism: a single module (`…/LocModel.olean`) compiles to
  two byte-different outputs under parallel elaboration (an auto-generated
  equation lemma picks up a bound-variable name from whichever of two
  adjacent thems reaches it first — bound-variable names play no part in
  kernel checking; the export is unaffected and byte-identical either way;
  upstream Lean issue #15498, fixed in v4.36.0).
- **Arithmetic cross-checks** (independent formalization `kimihiro64/Robin1984`
  on the same toolchain): combining the proof with Robin1984 yields
  hypothesis-free theorems that never mention zeta zeros — **Robin's
  inequality**, **Lagarias's inequality**, and a **corrected ideal Robin
  statement for every cyclotomic field** — all of which pass the same
  independent-kernel gauntlet.
- **Shorter versions** (Sernau, 2026-11-25): the 300k-line "readable" and
  76k-line "compact" Apache-2.0 proofs — Sutherland finished testing both on
  2026-11-26, confirming they are correct. Of the 300k lines, 177,492 are
  library (known results missing from Mathlib at the time) and 122,410 are
  the new argument.
- **Press/academic confirmation**: Scientific American (2026-11-20/21,
  updated): "Mathematicians are now certain the … proof … is real"; Nature
  (2026-11-20); the Mathlib community statement (2026-11-22). Clay CMI
  president Martin Bridson: "an announcement of historic significance."

## 5. The competing claim (distinct from the verified solution)

Also announced 2026-11-20: Alessandro Maria Masullo's *The Music of the
Primes* (a human, non-AI manuscript claiming GRH, posted via Ravi Vakil as a
"hurried announcement"). As of 2026-11-26 it is **not** certified: formal
verification is in progress (see the tracker page). It is tracked separately
at `https://mathandcobb.org/rh-claims/`. The verified solution to the
Millennium Problem is the Alpöge proof.

## 6. Independent checks performed in this worktree (2026-11-26)

All artifacts fetched from `math.mit.edu/~drew/grh/` and `alpo.ge` and
verified on this machine (124 GB RAM, 32 cores, 239 GB free disk):

- `alpo.ge/remark.pdf` downloaded and hashed: sha256
  `3fc97784b71ddd44ff8aa0a177e99622a1c61b13cfa843a0989ee4a7a0cfeb8d`.
- Archive parts 01/07/14 at alpo.ge: HTTP 200 (all 14 parts exist).
- `github.com/Deicyde/riemann-hypothesis` redirects to
  `github.com/leanprover-community/riemann-hypothesis` (adopted by the Lean
  community).
- **`challenge.ndjson.zst` (350 MB unpacked): sha256
  `bd484ac9886a96f26b1d9a7a59ebd45b7a70d102c015d4f31f9302bbdd6ab2b9` —
  MATCHES the published hash byte for byte** (the five verified statements,
  importing only Mathlib).
- **`solution.ndjson.zst` (7.70 GB compressed): sha256
  `61a8938ad5f5e57397c1c0e3b954916af546d9004ade01c3555744a681b05381` —
  MATCHES the published compressed hash; unpacked to
  `solution.ndjson` (61,570,595,788 bytes): sha256
  `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e` —
  MATCHES the published unpacked hash byte for byte.**
- **con-leche `--compare` (independent Lean kernel with a formal proof of
  consistency — it cannot accept a proof of False; built from commit
  `5dc36dc1` with Lean v4.36.0): PASS.** Output (2026-11-26, this machine,
  32 threads, 9 min 57 s, peak RSS 44.67 GiB):
  > con-leche: accepted 51692 declarations, 5 axioms justified by the
  > solution solution.ndjson (1468418 declarations accepted) (--verified)
  > con-leche: theorem **riemannHypothesis** justified by the solution
  > con-leche: theorem riemannZeta_eq_zero_re justified by the solution
  > con-leche: theorem LFunction_ne_zero_of_half_lt_re justified by the
  > solution
  > con-leche: theorem LFunction_eq_zero_re justified by the solution
  > con-leche: theorem LFunction_eq_zero_re_of_isPrimitive justified by the
  > solution

  The declaration counts (1,468,418 solution / 51,692 challenge) exactly
  reproduce Sutherland's independent record.
- **nanoda** (second independent Rust kernel, `ammkrn/nanoda_lib` v0.4.32,
  built locally): **PASS.** Output (2026-11-26, this machine, 32 threads):
  > Checked 1484733 declarations with no typechecker errors, 1 pretty
  > printer errors: [ "Unable to print axioms", ]
  > (exit 0)

  The single "pretty printer error" is cosmetic (the axioms' names could not
  be pretty-printed); it is not a typechecking failure. Both independent
  kernels on this machine (con-leche, nanoda) accept the full byte-verified
  export, independently reproducing the core of the community verification;
  con-leche's `--compare` additionally confirms the five theorems are exactly
  the challenge statements justified by the solution.

## 7. Relation to this worktree's honline program

This worktree's own program (`formal/RhAttack/…`, the CE lanes, the honline
Phases 0–3) was designed to establish `honline`/RH along an independent
route (eta-kernel Mellin transforms, strip identities, disk counting, orbit
arguments), under an explicit **no-RH-claim invariant** governing the
program's *own* output. The external, verified solution does not invalidate
that work — it recontextualizes it: the program's remaining phases
(2.3.2 Euler transform, Phase 3 disk count, Assembly) are no longer
necessary to settle RH, and the program now stands as (a) an independent
formal-verification artifact, (b) a large bank of certified numerical
results (CE census frontier), and (c) a potential cross-check substrate for
the new proof. Discovery entry 0504 records the transition.

**Caveats carried honestly:** a full human-readable account of the argument
is not yet published; the verification rests on the kernels and Mathlib
definitions being what they are intended to be (standard formal-verification
caveat); the Association for Human Mathematics has raised process
concerns (attribution, human certainty) that are orthogonal to the kernel
checks.
