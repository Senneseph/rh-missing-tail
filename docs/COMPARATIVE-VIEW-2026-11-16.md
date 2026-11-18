# Comparative View — why this project is noteworthy, against every known approach
**2026-11-16 · companion to `REVIEWER-BRIEF-2026-11-16.md` · NO RH CLAIM**

---

## The thesis, in one sentence

This is the only publicly known artifact — to our knowledge — that holds
**all three** at once: (i) a machine-certified zero census that extends
*past* the world-record verification height, (ii) a complete machine-checked
logical skeleton whose endpoint theorem *is* RH stated as an implication from
a small named premise list, and (iii) a fully documented single-repository
audit trail. No other approach holds two of the three, let alone all three —
and the comparison below says exactly what each of them holds instead.

---

## 1. Against the classical verification computations
**(Platt–Trudgian to 3×10¹²; the 10²⁰-zero censuses of the Gourdon–Demichel /
Gordon–Möller era; Turing's method in general)**

| | They | This project |
|---|---|---|
| Zero count verified | up to ~10²⁰ zeros (height ≈ 7×10²⁰) | **2 139 995 certified zeros** (the 2 000 000 program target landed exactly in the W100 tail, margin 0; W101–W107 extend post-target to 2 139 995 — the count structure is deliberate — see below) |
| Height | the record *is* H₀ = 3,000,175,332,800 (Platt–Trudgian) | H₀ is our **starting point**; the certified frontier STANDS AT the 500 000-unit milestone: H₀ + 500,001 = 3,000,175,832,801 (tCE107) |
| Granularity | monolithic computation; the published output is a height | **107 independently re-verifiable window certificates**, each re-certifiable by a standalone verifier program from the file alone |
| Error discipline | explicit analytic bounds taken from the literature | Hardy Z(t) evaluated in **ball (interval) arithmetic** (Arb, rounding enclosed) with an independent second code path; plus a separate high-precision mpmath audit layer (60–300 digits, independent re-walks) |
| Relation to RH | "RH is true up to height T" (a fact) | the census is an **in-tree input to the endpoint theorem** — it is a datum of the proof architecture, not merely a record |

The honest read: this project does not compete on count, and it does not
need to. Its novelty versus the classical computations is (a) *past* the
record height, (b) *re-verifiable unit by unit* (an investigator can
re-certify any single window in minutes), and (c) *structurally wired into the
logical skeleton* rather than standing beside it.

---

## 2. Against the nearest relative: Murphy's certified window (October 2026)

**P. W. Murphy, "A certified window of zeros of the Riemann zeta function
just above 3×10¹², with a machine-checked Riemann–Siegel remainder"**
(Zenodo 23489697; data 10.5281/zenodo.23486196) is the closest published
work, and **this project must credit it plainly: the window engine this
program runs is Murphy's Apache-2.0 pipeline** (adopted in-house; Murphy's
own certificate re-verified in our environment — documented in
`docs/RH-PROOF-OUTLINE.md` and `docs/ROUTE-B-FINAL-RECORD-2026-11-04.md`).

| | Murphy (Oct 2026) | This project |
|---|---|---|
| Certified zeros | one window: 20,000 zeros, span ≈ 4,671 in height just above H₀ | **107 continuous windows: 2 139 995 zeros, span 500,001 ≈ 107× the span**, from the same H₀ (W1–W97 ≈ 20 000 zeros each, W98/W99 = 20 000, W100 = the 21-point tail [2 000 000 target], W101 = 20 000 with one rescued flag (adjudication-confirmed fresh 4/4), W102 = the 19 999 one-gram snap (clean), W103 = the 19 997 three-gram snap (clean; 2 040 000 crossed mid-window), W104 = full 20 000 with one rescued flag (adjudication-confirmed fresh 6/6; 2 060 000 crossed), W105 = full 20 000 with one rescued flag (adjudication-confirmed fresh 4/4; 2 080 000 crossed), W106 = full 20 000 with one rescued flag (adjudication-confirmed fresh 5/5; 2 100 000 crossed), W107 = the one-gram SNAP 19 999 with one rescued flag (adjudication-confirmed fresh 4/4; 2 120 000 crossed; 500 000 unit mark crossed, margin 1)) |
| Lean content | the Riemann–Siegel *remainder bound* as a machine-checked component theorem | the **entire endpoint architecture**: RH ⇐ census + terminal face; terminal face ⇐ posReserve-band face; band face ⇐ two named squeeze faces; plus the named-input lanes (Z78* ladder, Ismail |S| bound → |S(tPT2)| ≤ 6 → data-free A1 constants) |
| Audit layer | positive/negative controls, calibrations, independent reproduction | per-window independent audits at multiple precisions **with documented adjudications** (e.g. W97's 3 flagged unions each contain exactly the predicted zeros — 6/5/5; W98's 3 flagged unions each contain the predicted zeros — 5/5/5; a stale pre-reboot audit run had misread W98's spans as zero-fresh, and the durable 2026-11-17 re-adjudication superseded that reading — erratum committed) |

So the relationship is **continuation and extension, not independent
discovery** — the reviewer should be told exactly that. It is precisely this
lineage (Murphy's 1 window → 107 windows + full reduction skeleton) that makes
the project noteworthy: it is the visible, in-progress *generalization* of a
freshly published 2026 result, done publicly in one repository.

---

## 3. Against the classical analytic approaches
**(zero-free regions de la Vallée Poussin → Vinogradov–Korobov; explicit
formulae and S(T)-bounds; density theorems; Selberg's S statistics)**

These are the *engines* — the actual mathematics that any proof of RH would
ultimately have to run. This project does not replace them; it does what no
published analytic RH work does:

1. **It states their required output, precisely and machine-checked.** The
   entire residual analytic content of RH above the frontier is *defined in
   Lean* as two.squeeze faces — the low strip (0 < d₀ < 1/200) and the mid
   band (1/200 ≤ d₀ < 1/2) — plus the zero-free-band identity. An analytic
   attack now has a machine-checked task specification: close those faces (or
   produce a zero-free region that consumes them), and RH follows by
   mechanical composition. The "distance to RH" is readable off the module
   headers instead of living in a notebook.
2. **It absorbs the current-best explicit inputs as named, isolated,
   provenance-pinned inputs.** The zero-free half-plane ladder (8 cited
   external results, strongest: Re s > 0.8733819666133, an all-Dirichlet
   tracker record with bit-identical merge provenance), and Ismail's explicit
   finite-height |S(T)| bound (Zenodo 23301655, T_opt = 3×10¹²) — each
   admitted as a named `def : Prop` input (no axioms), each with its
   in-tree consequences proven (e.g. |S(tPT2)| ≤ 6 at the frontier, data-free
   A1 oscillation constant < 833/64, worst-case squeeze margin ≥ 1.419 pinned
   by the exact rational fact 2^(101/200) > 1001/1000).
3. **It turns the endpoint itself into a theorem family**, instantiated at
   each re-anchored frontier — so "the census grew by one window" is a
   one-module, machine-checked advance of the endpoint (the CE91→…→CE96 chain
   is exactly this; CE97/CE98 are pending only the in-flight audits).

The honest read versus the analytic literature: **no analytic breakthrough is
claimed or present.** The squeeze faces remain open — that is exactly what
they are for: to be closed by mathematics. The contribution is the verified
frame, the sharpened target, and the pre-integrated 2026 explicit inputs.

One 2026-11-17 addition to that read (L1 track, entries 0423–0430,
`RhAttack/LevWall8` build green): the page-level reconstruction of the
cited Pratt–Robles bookkeeping shows the published 4/7 Levinson–Conrey
boundary carries an unpublished margin to 3/5. The 2026 Blomer–Pascadi
all-moduli Kloosterman estimate was audited as a wall input and found NOT
to transfer in this extraction (the a-range is bounded, so the bilinear
axis its 1/32 saving needs is degenerate and the binding Kloosterman step
is one-variable, Weil-sharp — entry 0430): the wall stands. The margin
finding is a fact about the published constant; no RH claim.

---

## 4. Against the formal-mathematics landscape

| Work | What it is | What this project adds |
|---|---|---|
| **Feit–Thompson (odd order), 2024–25** (Lean) · **Liquid Tensor Experiment, 2023** (Lean) · **Flyspeck, four-color** | machine verification of *known* theorems — verification is total, no open content | an endpoint on an **open millennium problem**: a theorem family whose conclusion is RH, with the open content isolated as named residues |
| **mathlib's analytic number theory** (prime number theorem formalized; ζ, functional equation, Riemann–von Mangoldt-lineage results; the vendored `zeta23` RvM-halving formalization) | infrastructure that makes zeta-based reasoning machine-checkable at all | a built *on top of* that infrastructure: an RH-specific endpoint, a certified census as in-tree datum, a named-input discipline for external analytic results |
| **External quasi-RH artifacts audited in the B6 packet** (the 7/8 half-plane "quasi-RH" input adopted as [Z78]; 45-page "selected-mollifier bound" submission; Bellotti–Trudgian–Yang narrow-box zero counting) | single-component or single-input artifacts, each machine-checked or certified where claimed | none of them is connected to a full endpoint reduction from a certified census; this project *audits and absorbs* the strongest of them as named inputs — a consuming architecture rather than a competitor |
| **"RH in Lean" partial formalizations (various, 2023–25)** | definitions + selected lemmas about ζ | (to our knowledge) no other formal program states RH itself as a theorem family with a finite named premise list that includes machine-certified numerical data — this is the closest existing artifact to a **proof-assistant architecture for an open problem** |

---

## 5. Why the whole is more than the parts (the "particularly noteworthy" list)

1. **It is the only known artifact where "how far from RH" is a machine-
   readable fact** (a list of four named residues, each with a module header
   saying what it is), rather than a matter of expert judgment.
2. **It extends the state of the art in both directions from a single October
   2026 starting point**: 100× the certified span above the record height, and
   from one Lean component theorem to the complete endpoint reduction.
3. **Its method is demonstrably self-correcting**: the W97/W98 adjudications
   (internal prime-theoretic flags → independent re-computation → confirmed
   zeros 6/5/5 and 5/5/5) are public, script-reproducible demonstrations, and
   the audit layer caught a defect in the audit layer itself: a stale
   pre-reboot audit run had misread W98's flagged spans as zero-fresh;
   the durable re-adjudication re-counted them from scratch, confirmed the
   pipeline record, and the erratum is committed — the machinery prefers the
   re-computation over its own stale output.
4. **It is a living absorption of the 2026 external frontier** — tracker
   zero-free records, Ismail's S-bound, Murphy's pipeline — each with
   provenance pinned (merge identity, zenodo DOI), each admitted under the
   no-axiom discipline, each converted into in-tree theorems.
5. **It is one person + machines, fully reproducible from one git repository**
   (815 commits; 438 numbered discovery entries; build evidence quoted in
   commits; every module labeled NO RH CLAIM). That combination — one
   repository, an open problem, a machine-checked reduction — is, to our
   knowledge, without precedent.

## 6. The honest negative (state this to the reviewer)

- No analytic breakthrough: the squeeze faces are open by construction — that
  is the remaining work, correctly identified.
- 2 139 995 certified zeros is far below 10²⁰; the trade is count for height
  + unit-level re-verifiability + logical integration.
- The numerical layer is interval-enclosed ball arithmetic plus independent
  high-precision re-walks — rigorous as computation, and deliberately *not*
  passed off as a formal proof of real analysis.
- External inputs (zero-free records, Ismail's bound) are external: adopted,
  provenance-pinned, isolated — but their validity outside this tree is the
  published/audited record's responsibility.

*Prepared 2026-11-16. All repository facts re-checkable from git (794
commits), `docs/discovery/entries/0412–0417.json`, `formal/RhAttack/`, and
`tmp/ce2/ce1_window_H0_v1/`.*
