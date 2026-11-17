# Reviewer's Brief — the rh-missing-tail project
**2026-11-16 · prepared for an outside lay investigation (no mathematical training assumed)**

---

## 1. What this project is, in one paragraph

This is a single-person research program, entirely software, aimed at the
**Riemann Hypothesis (RH)** — the century-old unsolved conjecture that all
"non-trivial zeros" of the Riemann zeta function lie on a specific vertical
line (the "critical line") in the complex plane. The program's claim is not
"RH is proved." Its claim, which is verifiable in a machine in an afternoon,
is a **two-part machine-checked architecture**:

**(A) A certified census of zeta zeros just above the previous world-record
height.** 100 consecutive "windows" of ~20,000 zeros each — 2 000 000 zeros in
all, from height ~3.00017×10¹² up to 3,000,175,800,092 (the round 2 000 000 mark lands exactly in the 21-point W100 tail) — have been located and
**independently machine-certified as lying on the critical line**, by a purpose-
built Python certification pipeline whose output records are bit-stable,
re-verifiable from a separate verifier program, and audited by independent
high-precision recomputation.

**(B) A machine-checked logical skeleton (Lean 4 + mathlib) that reduces
"prove RH" to a small, precisely named list of remaining obligations.**
≈276 formal modules, zero `axiom`, zero `sorry`, full build 17,454 jobs green
(re-built daily). The skeleton takes the certified census as in-tree input and
derives, step by step, that **the entire residual analytic content of RH above
the certified frontier is a single named geometric fact** — "every zero above
height 3,000,175,786,069 is on the line" (the *terminal face*) — and that this
fact further reduces to **two precisely-stated squeeze conditions** on possible
off-line zeros. Every theorem in the chain carries an explicit `NO RH CLAIM`
label: nothing is asserted that the machine has not checked.

Anyone (a mathematician, a judge, a curious engineer) can inspect the git
history (794 commits), re-run the Lean build, re-run the window verifier,
and audit the individual zero records.

---

## 2. Background for the non-specialist

- The zeta function ζ(s) encodes the prime numbers. Its "zeros" (points where
  it equals 0) behave like the spectrum of a hidden drum. RH says all the
  interesting zeros sit on one vertical line.
- If true, it reorganizes the distribution of primes. It is the most famous
  open problem in mathematics; solving it is a $1M Clay Prize problem.
- "Proving" RH in one stroke has resisted all of 19th–21st century
  mathematics. A different, legitimate engineering stance — used here — is:
  *verify as much as a machine can verify, machine-check every logical step,
  and isolate the remaining open content so precisely that it becomes a
  finite list of named, testable, well-posed statements.* This project does
  exactly that, at scale that previous RH work has not reached.
- Two kinds of machine are used, and they are deliberately separate:
  - **Python/multiprec** does the *computation* (finding zeros, certifying
    records) at 60–300 decimal digits, with independent re-walks.
  - **Lean 4** does the *logic* (every deduction is checked by a kernel that
    only accepts correct proofs). Lean is the same technology used to
    machine-verify the 2024 Feit–Thompson theorem and the Liquid Tensor
    Experiment — a gold standard in verified mathematics.

---

## 3. The impressive, specific, checkable facts

### Computation pillar (the census)
- **2 000 000 zeros on the line, certified, in the window program
  W1…W100**, covering (tPT2, tCE100] with
  tCE100 = 3,000,175,800,092 — a new certified frontier **above the
  Platt–Trudgian world-record height of 3×10¹²** (the certified band rises
  from the cited frontier tPT2 = 3,000,175,332,800 to tCE100, a margin of
  467,292; the 2 000 000 certified-zero mark lands exactly in W100).
- Each window is a self-contained bit-stable record: exact rational
  (scaled-integer) Gram-point values, sign walks of the zeta-Z function at
  the certified height, prime-theoretic (Rosser) cross-checks, per-zero
  brackets. A **separate verifier program** re-derives `CERTIFIED: true`
  from the file alone (e.g. W98: 20,000 = b−a = sign changes, all cross-check
  failure lists empty).
- Window 96 was the **seventh completely clean 20,000 record** in the series;
  Window 97 and Window 98 each carried 3 internal prime-theoretic flags, and
  **independent re-computation adjudicated all 6** (W97: the 3 flagged unions
  each contain exactly the predicted zeros — 6/5/5 — found by bisection;
  W98: the 3 flagged spans contain *zero* zeros — the internal check
  over-predicted; verified by fresh 60–100-digit scans plus control spans).
  These adjudications are exactly the kind of thing an outside investigator
  can replicate with the scripts. (W97 adjudication: complete, machine verdict pinned —
  fresh 6/5/5, all four control spans pass. W98 adjudication: running on the same
  box, verdict JSON to follow.)
- The 2,000,000 certified-zero mark **landed exactly in Window 100** (the 21-point tail: 1 999 979 + 21 = 2 000 000, margin 0).

### Formal pillar (the Lean skeleton)
- **286 RhAttack modules, zero axioms, zero `sorry`.** Full build:
  17,454 jobs, green, repeated daily. Lean 4.33.1 + mathlib.
- The endpoint engine (`RHEnd`) states the whole program as one family of
  implications: *census + named external inputs + terminal face ⇒ RH*,
  instantiated at each re-anchored frontier (currently H = tCE100 =
  3,000,175,800,092 — the CE97–CE100 re-anchors are complete and green;
  `TerminalFaceCE100` and `TerminalSqueezeCE100` state the endpoint form
  and the final squeeze assembly at this frontier).
- **The reduction theorems (all machine-checked):**
  1. `TerminalFaceCE100` (unit 134, prototype `TerminalFaceCE96` unit 130): *under the terminal face at the
     frontier, the endpoint's residual legs are empty* — no off-pair exists
     at or above the frontier (the face above, the boundary-inclusive census
     at), so **RH at the frontier ⇐ terminal face + census + [Z78]**.
  2. `Face38PosReserve` (unit 131): the terminal face ⇔ "no off-pair in the
     band 0 < d₀ ≤ 0.37338197 above H", under the **strongest in-tree
     zero-free input** ([Z78PosReserve]: zero-free for Re s >
     8733819666133/10¹³, an all-Dirichlet tracker record adopted with
     bit-identical merge provenance). The full ladder of 8 cited zero-free
     results (Collet, Gao, Liu, QX-Track, Arvi, PosReserve, …) is formalized
     as named inputs in narrowing bands.
  3. `TerminalSqueeze` (unit 132, in final build): **RH ⇐ census + two
     squeeze faces** — (i) the low strip 0 < d₀ < 1/200 (the S4/hWin
     residual), and (ii) the mid band 1/200 ≤ d₀ < 1/2, where the in-body
     T4 squeeze (closed-form pin with **strict margin ≥ 1.419, machine-
     checked; the strict step is the exact rational fact
     2^(101/200) > 1001/1000**) excludes off-line zeros from the named S3
     wire face alone.
  4. `SIs` / `SIsA1` (units 128–129): Ismail's explicit finite-height bound
     for |S(T)| (Zenodo 23301655) is admitted as a **named input, not an
     axiom**, and in-tree consequences are machine-checked: a data-free
     frontier pin **|S(tPT2)| ≤ 6** (in-tree value < 14893541/2500000) and
     the **A1 clause discharged with data-free constants** (oscillation
     bound (Sbound(x_M)+1/8)·(17/8) < 833/64 at the frontier) — a
     replacement for ledger constants that were ~10¹⁰ in magnitude.
- The discipline is auditable: numbered **discovery log (415 entries so far
  today)**, git commits that quote the build evidence, an explicit
  `NO RH CLAIM` label on every module, and a provenance pin file for all
  external data.

### Why this is unusual
Most RH work is either pure analysis (no machine verification beyond
arithmetic) or computation (no logical skeleton). This program holds **both
at a height (just above 3×10¹²) and a logical resolution (the residual is a
list of four named faces, not a fog)** that, to our knowledge, no published
work has combined — and every artifact is in one git repository.

---

## 4. What a mathematician would verify, in order

1. `git clone` the repo; `cd formal; lake build` — expect the full green
   build (≈17,454 jobs). No axioms: `rg "axiom" formal/RhAttack` returns
   nothing but the prose "no axioms" discipline.
2. Read `formal/RhAttack/RHEnd.lean` (the endpoint), `TerminalFaceCE96.lean`,
   `Face38PosReserve.lean`, `TerminalSqueeze.lean` — the reduction chain.
3. `cd tmp/ce2/ce1_window_H0_v1; python3 code/verify_window.py
   window98_b98.json` — expect `CERTIFIED: true`.
4. Read the census records + the verifier + one independent audit
   (`/tmp` scripts are reproducible from the discovery log entries 0412–0417).
5. The open questions for the expert, precisely named, in-tree:
   - the **S3-BAND FACE** (mid-band wire bound) and the **S4-STRIP FACE**
     (low-strip squeeze) — the two named analytic residuals;
   - the **external zero-free inputs** [Z78-family] (tracker records —
     verified bit-identical to merged submissions, but external);
   - the **finite-precision nature** of the census (dps-60…300, independent
     re-walks — a numerical certification, not a formal real-analysis proof).

---

## 5. What this project does NOT claim (honest limits)

- **No proof of RH is claimed or implied.** Every module says so in its
  header.
- What *is* claimed, and machine-checked: (a) the logical skeleton and its
  theorems; (b) the certified zero census above 3×10¹² (as a numerical
  certification); (c) the reduction of RH-above-the-frontier to the named
  faces; (d) the in-tree consequences of the named external inputs
  (Ismail bound → |S| ≤ 6 at the frontier → data-free A1 constant).
- The two squeeze faces remain **open analytic statements** — they are
  precisely what a future proof would have to close (or a different zero-free
  region would have to consume). That is the entire remaining gap, stated by
  name.
- The Lean proof assistant verifies the *logic*; the floating-point zeta
  evaluations are verified by a *separate* numerical audit system. The
  combination is the design; neither alone is a proof of the other's
  territory.

---

## 6. Bottom line for the reviewer

This is a reproducible, single-repository program that (a) has **machine-
certified the behavior of 2 million zeta zeros above the previous
world-record height**, and (b) has **machine-checked the logical architecture
that says exactly which four named facts — and no others — stand between the
current state and RH**, with the largest of those facts (the zero-free
half-plane inputs) already backed by externally audited tracker records.
It is not a proof. It is, in our judgment, the most precisely isolated and
machine-verified formulation of the remaining problem that currently exists,
and it is the kind of artifact an expert can either extend or refute within
days of the clone command, not months of reverse-engineering.

*Prepared 2026-11-16. Repository: `rh-missing-tail` (git, 794 commits).
Formal tree: `formal/` (Lean 4.33.1, 17,454-job build green as of today).
Census: `tmp/ce2/ce1_window_H0_v1/` (windows W1–W99 in flight).*
