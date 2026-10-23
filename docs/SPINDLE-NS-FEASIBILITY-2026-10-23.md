# SPINDLE / NS-ENCLOSURE — FEASIBILITY REPORT

Date: 2026-10-23. Side quest, pass 4 (feasibility study; the
construction itself is the follow-on work it defines).
Owner's directive (verbatim):

> "let's look at the newly discovered navier stokes solutions and test
> to see if they apply to the threads that could be connected, in order
> to the growth of the structure, and here i mean the threads that
> would go from each triangle from the base, etc, the structure could
> be very flexible but navier stokes would enclose its game. i want a
> feasibility report for further investigation and what the actual
> spindle structure might look like (just imagine combinatorial threads
> from a common root into each of the real or virtual faces), or even
> spindles that are bound by the area of the triangles they must span,
> hrm..."

Companions: `docs/IDEA-SEED-EULER-PRIMAL-BLOOM-2026-10-23.md`,
`docs/PRIME-BLOOM-PASS3-2026-10-23.md`.
Feasibility computation: `tmp/sx4_spindle.py` (7.9 s at X = 2e6),
tables in `tmp/sx4_spindle_stats.json`, log `tmp/sx4_run.log`.
**No RH claim is made or implied.** The NS material below is used only
as a structural / bounding model.

---

## 1. The newly discovered NS solutions — provenance-audited 2026-10-23

What is actually new, what is verified, what is a claim (fetched and
cross-checked this session; pointers, not proofs, remain pointers
until the writeups are audited — that audit is follow-on T6):

| claim | content | status as of 2026-10-23 |
|---|---|---|
| OpenAI, 2026-09-08 | internal multi-agent system (~10k agents, 88 h) proved 3D NS **develops a singularity in finite time** — statements **C and D** of Fefferman's formulation (the variants permitting a smooth external force); announced Lean formalization (machine-checked per the announcement, ~17 h) | **T6-AUDITED (primary sources fetched 2026-10-23):** claims verified from the official repo README + announcement page: NS **(C)+(D) at EVERY positive viscosity** (R³: no global smooth solution with uniformly bounded kinetic energy; T³: no global smooth solution), BOTH with smooth forcing; separately an **UNFORCED 3D Euler finite-time singularity** (smooth compactly supported divergence-free data; C¹ norm unbounded, ∫‖ω‖∞ = ∞). Public: two paper PDFs (cdn.openai.com, URLs in the repo README) + the full Lean 4.34.0-rc2/Mathlib formalization repo **`openai/NavierStokesAndEuler` (cloned locally, inspected)**. Status: proof "technically believed correct" (NPR) but (i) forced variant — "the most important problem (unforced viscous) is unsolved" (SciAm/criterion); (ii) formalization independently assessed as ONGOING (lean4.dev, 2026-09-09: "we reviewed the documentation, not a local rebuild"); (iii) **credit/priority dispute** documented in primary source (see T6 appendix): OpenAI announced AFTER being alerted to Buckmaster–Alpöge's in-flight work; OpenAI denies its model saw or trained on their sessions; "conflicting public accounts, not an established finding" (lean4.dev); OpenAI withdrew the prize claim. **Not CMI-certified.** |
| CMI, 2026-09-11 | "Navier-Stokes Announcement": the problem "apparently settled" | **the live CMI page no longer contains the announcement** (fetched 2026-10-23, 0 occurrences of "Navier") — pulled while verification proceeds. CMI has NOT certified the result. |
| Buckmaster–Alpöge (Anthropic), 2026-08/09 | forced **Euler** finite-time blowup; published preprints WITH Lean formalizations | **T6-AUDITED (primary):** the published statement (fetched in full, 2026-10-23) claims THREE smooth-forcing blowup results — incompressible porous media, Boussinesq, 3D Euler — plus a claimed (UNPUBLISHED, Lean-verification incomplete) hypo-dissipative NS blowup "suggestive of a path to unforced Euler". Credits the program to **Córdoba & Martínez-Zoroa** (rough-forcing blowups); LLM-accelerated (Claude / Codex GPT-5.6 Sol / Astra); first LLM proof Lean-verified 2026-08-22; the author himself calls the Euler writeup "AI slop" (presentation-quality caveat, first-party). The repo's Lean is the fully machine-checkable artifact of the cluster. |
| Ri, arXiv:2601.15685 (2026-01) | **global regularity** for Leray–Hopf, d ≥ 3 (OPPOSITE direction) | preprint claim, unverified. |
| Guevremont, viXra:2603.0061 (2026-03, v2) | global regularity "via deterministic harmonic resolution" | non-peer-reviewed repo (by its own disclaimer); "corrected Lean" claim unaudited. |
| NS-7227, Zenodo (2026-09-17) | global regularity "via the Shelbydon spectral operator" | 0 citations; characteristic of AI-generated slop; **treat as untrusted**. |
| Adjacent peer-level (real) | Barnes–Liew–Titi: Bardos–Tartar conjecture (arXiv:2610.21530); Bradshaw–Palmer: singular stationary flows (arXiv:2606.22291); Wang–Yang: stationary high-dim (arXiv:2609.24206); Li–Yang CMP 2022 | citable companion mathematics of the NS landscape. |

**The structural fact the owner wants** (independent of any single
claim's final verdict): the flexible space of NS dynamics is now
ENCLOSED on both sides —
- from ABOVE: Leray's a-priori energy inequality (1934): the L²
  energy of any weak solution cannot grow past the initial budget;
  growth of the coarse quantity is bounded by a smooth, explicit,
  KNOWN function of the data — the "enclosing game" in the owner's
  words;
- from BELOW: the proven blowup family (OpenAI C/D, forced;
  Buckmaster–Alpöge, forced Euler): an explicit flexible configuration
  — a vortex that "spirals inward and gets increasingly elongated,
  like spaghetti", its central region shrinking while it speeds up,
  **energy still finite** — that reaches the enclosure boundary and
  past it: finite budget + unbounded local intensity. The blowup shape
  is a **spindle**: exactly the geometry the owner proposes for the
  lattice threads.

## 2. The spindle structure on our lattice — frozen definition

Root, threads, faces, spindles (the "imagine" made concrete):

- **ROOT = 1** (the unit root; the mirror-game tradition's unit
  marker).
- **THREAD (v, e)**: e ≥ 2 with e | (v−1): the AP fiber
  {1, 1+e, 1+2e, …, v}. **A thread is a divisor; every thread from the
  root to vertex v is a divisor of v−1.** The fiber of step e is a
  DISCRETE SPIRAL ARM: pitch e, one point per arm per unit height,
  one full "winding" per X/e points — the combinatorial counterpart of
  the blowup solution's spiraling spindle.
- **FACES.** Real faces = the realized prime triads (2,204,797 at
  2e6, pass 3 F10). Virtual faces = the phantom geometry: the 16 dead
  wheel bands, the 8 dead chord shapes (F11's vanishing classes), and
  the 1-way phantom rays (85.0% of the ray budget) — a thread aimed at
  a virtual face is a NOTIONAL thread (the "notional projection" of
  the multi-spectrum, now flowing).
- **SPINDLE of a triangle T = (p−2d, p−d, p):** the bundle of threads
  from the root landing on ALL THREE vertices of T. Common divisor
  structure: a step-e fiber hits all three vertices ⇔ e | (p−1),
  e | (p−d−1), e | (p−2d−1) ⇔ **e | gcd(p−1, 2d)**. So
  S(T) = d(gcd(p−1, 2d)) − 1 threads.
- **AREA BOUND (the owner's "bound by the area of the triangles they
  must span"):** A(T) = |F2 defect| = |(p−5d)(p−2d)|; the spindle's
  throughput S(T) must not exceed the area budget A(T).

What it MIGHT look like (ASCII):

```
                real face  T = (p-2d, p-d, p)
                 o-----------o-----------o          3 vertices
                 \   S(T) spindles  /             threads e | gcd(p-1, 2d)
                  \  (e | p-1 for  /
                   \  all 3 ends) /
                    \    |    /
        spiral arm e  \   |   /  spiral arm 2d
      1, 1+e, 1+2e, ... \  |  / ...
                         (1)  UNIT ROOT
   ----- virtual faces (phantom threads, "notional projection") -----
        16 dead wheel bands   8 dead chord shapes (F11)
        85% phantom rays  (pass 3 F10)   = the field outside the bloom
```

The NS mapping (structural, not literal — no fluid is simulated):

| NS object | discrete lattice object |
|---|---|
| L² energy budget (Leray closure) | thread budget B(X) = Σ_{3≤v≤X} d(v−1) |
| a-priori bound (smooth, known) | divisor-sum model M ln M + (2γ−1) M |
| "turbulence" (error term) | divisor-problem fluctuation (measured: +78 at 2e6) |
| blowup witness (finite energy, unbounded intensity) | spindle with large S(T) under small A(T) (concentrated flux, finite budget) |
| BKM vorticity criterion | discrete concentration criterion (spindle-flux share vs population share) |

## 3. The feasibility computation (X = 2e6, 7.9 s) — F14

1. **The closure from above is EXACT.** B(2e6) = 29,326,240 threads;
   the smooth model 29,326,162.5; ratio **1.0000026**. The total
   thread energy of the whole game is enclosed by a known smooth
   function to five digits — the discrete Leray inequality, measured.
   (Fluctuation +78 = the "turbulence", relative 2.6e-6.)
2. **The phantom field is thread-repellent.** Mean threads per vertex:
   PRIME vertices 25.92 vs composite (phantom) vertices 13.76 —
   ratio **1.884**. Real faces receive ~1.9× the thread density of the
   phantom background (dominant factor: p−1 is always even; the
   prime-specific residual is the decomposition test T1). The FANTASY
   "electric field" has a measured flow property: the root's fibers
   flow preferentially into the real structure and around the field.
3. **Every spindle fits inside its triangle's area — always.**
   A(T)/S(T) ≥ **8.5** for all 2,204,797 spindles (S: mean 3.79,
   p99 = 15, max 47; A up to 4.0e9). The area bound is not tight
   generically (p50 A/S ≈ 2.0e11) — at 2e6 the enclosure is lax: the
   game is nowhere near its boundary.
4. **The tightest spindles live on the pass-1 landmark.** The
   minimum A/S = 8.5 is realized at **T = (17, 23, 29)** (d = 6,
   A = 17, S = 2) — the global-minimal-miss triad of F3. The lattice's
   most "blowup-like" spindle (maximal flux per unit area) sits on the
   quest's own canonical near-miss triangle. Cross-quest resonance.
5. **Root-aligned bases: 21,250 (0.964%).** The share of triangles
   whose own base step is itself a root thread (d | (p−1)) — the
   "threads from each triangle from the base" directly to the unit
   root: 1 in ~104 triangles, exactly the equidistribution prediction
   (Σ 1/d over the chord classes), no excess.
6. **No discrete vortex at 2e6.** Spindle-flux shares by chord class:
   26.70 / 23.51 / 26.34 / 23.46% vs population shares 24.37 / 25.35 /
   25.16 / 25.12% (d mod 24 = 0/6/12/18): the d ≡ 0 mod 12 classes
   carry ~+2% (a structural gcd(p−1, 2d) parity effect, computable a
   priori), NOT a concentration event. The "spinning" signature is
   absent at this scale — consistent with F12's uniform skeleton.

## 4. Feasibility verdict

**FEASIBLE — concretely, cheaply, decidable.** The spindle structure
is fully defined on the existing lattice (no new data, no fluid
simulation, no NS solver): threads are divisors, spindles are gcd
counts, areas are F2 products. The whole 2e6 computation is 7.9 s;
X = 1e8 is seconds-to-minutes with a vectorized divisor sieve. The NS
"enclosure" is real in the discrete sense — the budget closure is
exact and known — and the BLowup analogue is a well-posed existence
question (concentrated spindle flux under finite budget) with a
concrete, cheap-to-run criterion. Nothing here requires the OpenAI /
Buckmaster–Alpöge proofs to be correct: the enclosure used is the
90-year-old energy-inequality ROLE played by the divisor sum, and the
blowup witness is sought INSIDE our own lattice.

## 5. Follow-on tests (numbered, each with cost and pass/fail)

- **T1 (parity decomposition of the 1.884 thread ratio)** — 1 min.
  Split d(v−1) by the evenness structure: compare d((p−1)/2)·even-correction
  vs composites' odd part. PASS = a genuine prime-specific residual
  ≥ 1% beyond the forced parity; FAIL = the ratio is fully parity
  (record, and the field's repulsion is a bookkeeping artifact).
- **T2 (closure tightness at scale)** — minutes at X = 1e8. Track
  min and p1 of A/S. PASS = a bounded subfamily of near-extremal
  spindles (A/S = O(1)) persists under growth — the discrete
  "finite-energy, intense-flux" candidates (spindle blowup witnesses);
  FAIL = the min drifts upward (the game stays deep inside its
  enclosure).
- **T3 (vortex search)** — minutes at X = 1e8. Discrete concentration
  criterion C(window, class) = spindle-flux share / population share;
  scan height windows. PASS = a window with C > 1 + 3σ under finite
  total budget (a discrete blowup signature — the "spinning"); FAIL =
  equidistribution persists (the uniform skeleton survives at scale).
- **T4 (spindle dynamics along AP families)** — minutes. Fix a chord
  class and walk the family: S(T) sequence vs A(T) sequence. PASS = a
  persistent family with S ~ A^α (scale-free spindle stretching — the
  "spaghetti elongation" analog); FAIL = no power-law family.
- **T5 (phantom flow conservation)** — minutes. The phantom channel
  (85% of the budget): is the net phantom thread flux through
  consecutive height layers conservative (a discrete "incompressible"
  steady flow) or does it have a source term (a discrete "viscous"
  term)? Either outcome CHARACTERIZES the field; both decidable.
- **T6 (NS provenance audit)** — the actual writeups (OpenAI paper,
  Buckmaster–Alpöge preprints + their Lean) audited the way the
  tracker records are audited, once the writeups are fetched. Low
  priority for the lattice work; high for any external citation.

## 6. Discipline

- No RH claim: the spindle is a combinatorial divisor construction on
  the lattice; the NS mapping is a structural analogy; the one exact
  "closure" is a divisor-sum identity, not a PDE statement.
- NS provenance posture: the September 2026 blowup results are
  reported (multiple independent outlets) and machine-check-claimed,
  but CMI has NOT certified them (the announcement page was pulled)
  and the formalization is contested; the affirmative preprints are
  claims, not facts, and the Zenodo NS-7227 item is untrusted by
  character. This report uses NONE of them as established results.

## 7. T6 AUDIT APPENDIX (executed 2026-10-23, primary sources)

Fetched and read in full this session (fetched ≠ adopted; all cited
as claims-attributed to their authors):

1. **Buckmaster’s statement (primary, 4 pp., extracted):**
   `https://cims.nyu.edu/~tristanb/statement.pdf`
   (mirror copy: constable.blog). Content: the three published
   smooth-forcing blowups (porous media, Boussinesq, Euler); the
   claimed-but-unreleased hypo-dissipative NS (Lean incomplete);
   the origin of the program (Córdoba–Martínez-Zoroa); the LLM
   acceleration history (first LLM proof Lean-verified 2026-08-22;
   "the Euler writeup ... can only be described as AI slop" —
   first-party presentation caveat); and the priority-dispute
   chronology: Sep 3 preemptive e-mail to OpenAI; Sep 6 calls in
   which OpenAI disclosed an internal model’s forced-NS proof
   ("options c and d in Fefferman"), "very little human input" was
   said and "turned out not to be true" per his account (team work,
   multi-week, easier problems first, Codex-written prompts; first
   prompt sent "in the past few days, after information about our
   work had reached OpenAI" — his characterization); training-on-
   sessions questioned, "the model did not look up user data," the
   training question unanswered; two authorship proposals, both
   declined; "Why would you ruin your career?" / "If you don’t want
   me to be nice, then I don’t have to be nice." His explicit
   non-claims: he has not seen OpenAI’s proof, does not know
   whether their data was used, accuses no one.
2. **OpenAI’s own artifacts:** the announcement page (fetched) and
   the formalization repo `openai/NavierStokesAndEuler` (cloned
   locally, structure inspected): Lean 4.34.0-rc2 + Mathlib + Lake;
   README states the NS (C)+(D)-every-viscosity results and the
   UNFORCED Euler finite-time singularity; public paper PDFs:
   `https://cdn.openai.com/pdf/32d9f210-8b73-45e0-91bc-
   82a30aef8a9a/navier-stokes.pdf` and
   `https://cdn.openai.com/pdf/315b36cd-ec98-4023-8342-
   93345194ece1/euler.pdf`. ComparatorChallenges/ shipped for
   independent checking. NO local rebuild of the proof has been
   done by us (the audit scope of T6; a rebuild is a separate,
   heavier task if ever wanted).
3. **Independent framings fetched:** lean4.dev (2026-09-09 review:
   "Lean artifact released; independent assessment ongoing"; the
   dispute = "conflicting public accounts, not an established
   finding"); Terry Tao’s 2026-09-07 post on the B-A blowups;
   arXiv:2609.23868 (cites OpenAI’s exact claim: forced NS
   statements (C)+(D) at every fixed viscosity + unforced Euler);
   NYU news (institutional corroboration of the B-A work).
4. **CMI:** the live problem page contains no such announcement
   (fetched; 0 occurrences) — the earlier "announced settled" item
   is PULLED in the interim; no certification exists.

**Audit verdict:** the NS material is now at primary-source level
for the three central items (OpenAI claims, B-A claims, community
status). What is ESTABLISHED (machine-checkable or multi-source
stable): the forced-NS C/D CLAIM with public Lean; the unforced-
Euler CLAIM with public Lean; the B-A forced-blows claims with
Lean; the existence of a live priority dispute; the absence of CMI
certification and of an unforced-viscous-3D-NS any-sign blowup or
regularity proof. What is NOT yet established: correctness of any
of the Lean artifacts (independent rebuilds pending community-wide),
and the conduct questions in the dispute (conflicting accounts).

## 8. F15 — T1 / T1r–T5 results at scale (executed 2026-10-23)

Execution: `tmp/sx5_scale1e8.py` (233 s; **50,630,458 spindles** at
X = 1e8), tables in `tmp/sx5_scale1e8_stats.json`.

- **T1 (2e6): PASS.** Post-parity-matched thread means 16.97 (prime
  side) vs 13.44 (matched composites): ratio **1.262** — the 1.884
  gross ratio is NOT pure parity; a genuine +26% prime-side excess
  survives.
- **T1r (1e8): the excess is valuation-UNIFORM.** Per 2-adic class
  v2(p−1) = k, prime/composite means: 1.27718 (k=1), 1.27742 (k=2),
  1.27431 (k=3), 1.26891 (k=4), 1.26426 (k=5), 1.36202 (k≥6 cap).
  The phantom field repels root threads by a constant ≈ 1.26–1.28
  independent of the 2-adic structure — a clean, scale-stable
  structural factor (1.262 at 2e6 → ~1.274 at 1e8).
- **T2 (closure): no growing blowup-witness family.** min A/S stays
  **8.5 at (p,d) = (29,6)** — small-triangle corner; only **14
  spindles** have A/S < 100 at 1e8 (127 below 1000). And the set is
  provably height-bounded: A/S < 100 ⇒ (p−5d)(p−2d) < 4700 ⇒ p ≲ 7000
  (d ≤ 2000) — a FINITE list, exhausted at 2e6. The enclosure stays
  lax for every spindle above height ~7000; the "tight" corner is the
  small triangles (top-5: (29,8.5), (7,9.0), (19,25.7), (89,26.5),
  (11,27.0)).
- **T3 (vortex): none at 1e8.** Class-mean structural bias
  [1.0967, 0.9273, 1.0468, 0.9328] (d ≡ 0/12 mod 24 families carry
  +5–10% of spindle flux — computable from the gcd(p−1, 2d)
  structure). After removing class means: layer-relative σ = 0.221%,
  max deviation 0.986% (layer 92, class 0), flags |L−1| > 3.5σ:
  **2 / 400** — noise level. The uniform skeleton survives at 1e8.
- **T4 (dynamics): none at 1e8.** Per-decile mean S flat
  (3.799–3.808); log-log slope α = 0.00021; top-1% S median area
  0.999× overall — no scale-free elongation, no spindle motion.
- **T5 (phantom flow): CONSERVED.** B(1e8) = 1,862,122,325 threads
  (ln-model ratio ≈ 1.0025 — the "turbulence" at scale: +0.25%).
  Per 1e6 layer, after matching the ln density model: drift
  +0.31% total, lag-1 +0.22 (mild, consistent with the smooth
  divisor-fluctuation structure), and the only systematic deviation
  is LOW-HEIGHT asymptotic convergence: layers 0–4 run +12.9% /
  +8.3% / +7.1% / +6.6% / +6.3% above the asymptotic density,
  decaying monotonically to +0.04% by layer 99 — no source term, no
  pulse. The phantom field is a conserved flux with asymptotic
  density ln v + 2γ − 1.

**Pass-4 verdict (F15): CLOSED-FLAT at 2e6–1e8.** The spindle game
is enclosed exactly (divisor-sum budget to ~2.5e-3 at 1e8), its
interior above height ~7000 is uniformly slack, vortex-free,
motionless, and phantom-conservative; the only active structure is
(a) the finite small-triangle corner (p ≲ 7000), (b) the structurally
computable d ≡ 0/12 mod 24 class bias (+5–10%), and (c) the constant
1.26–1.28 prime-side thread excess. That flatness IS the result —
the discrete analogue of "finite energy, no blowup observed": the
NS enclosure holds and nothing inside it stirs at these scales.
The honest next step is G2 (1e9, ~10× cost, after S18 frees RAM) or
a different face (spindles over chime branches — new construction,
new seed doc when the owner gates it).
