# INDEX — the `docs/` table of contents

The proof-related documents of this repository. The measured raw
outputs behind every figure live in the working tree
(`kainos-logos/scripts/`); the paths cited throughout resolve from
there.

## Start here

| Document | What it is |
|---|---|
| [PROJECT_GUIDE.md](PROJECT_GUIDE.md) | The user guide for a clean machine: the Docker container (digest-pinned, no auto-run at boot), plain-Python install, the repository map, the single data entry point (`scripts/rh/rh_fetch_data.py`), and the test commands from the no-data engine self-test to the full smoke-test to the Lean build. |

## Proof and argumentation

| Document | What it is |
|---|---|
| [RH-PROOF-OUTLINE.md](RH-PROOF-OUTLINE.md) | "The Riemann Hypothesis: A Path, and Its Current State" — the reader-facing mathematical exposition of the whole path and its current state, with full provenance for every number. |
| [STRAIGHTFORWARD-ASSESSMENT-2026-09-17.md](STRAIGHTFORWARD-ASSESSMENT-2026-09-17.md) | A self-contained, field-agnostic status snapshot (2026-09-17, post-25af): the machine-checkable-steps assessment with project details in parentheses — a snapshot layer over RH-PROOF-OUTLINE.md and DISCOVERY_LOG.md; written to be forwarded to a mathematician in any field. |
| [LOW-T-DATA-TERRITORY-PLAN.md](LOW-T-DATA-TERRITORY-PLAN.md) | 2026-09-18, DONE: the S4A low-t data territory (t0 < 1000, d0 <= 1/2) is FILLED at screen level - 207-pt sweep, margin_new >= 1 at ALL points, global min 7.35737123 at t0 = 0.5 (dps-50 anchor |d| 1.5e-4); 813-zero LMFDB slice pinned (md5 + residual 813/813 + independent walk bit-exact on 225). d0 > 1/2 stays CITED. |
| [QUAD-FIX-PLAN.md](QUAD-FIX-PLAN.md) | 2026-09-17/18, RESOLVED: the suspected mpmath complex-tail-quad defect was an A/B interval confound (sweep vs hi-run splice G); the same-interval per-cell A/B agrees 400/400 to all digits — no defect; all recorded Efull/margin values stand. Genuine residuals kept on record: the model-point singularity straddle (split the quad at g = t for t > G_last) and the splice-comparability calibration (script fix pending). |
| [ROUTE-ANCESTRY-AND-NOVELTY-2026-09-17.md](ROUTE-ANCESTRY-AND-NOVELTY-2026-09-17.md) | The route's intellectual history, 2026-09-17: the classical ancestors (von Mangoldt 1905, Littlewood 1913-14, the S(T) equivalence, Huxley, Conrey-Ghosh 1997, Platt-Trudgian 2021), why the route has never been walked as a proof, the novelty claims with their honest limits, and the last mile (the S1 residue as one watchable inequality). A standing reference document. |
| [KNOWN_LIMITATIONS.md](KNOWN_LIMITATIONS.md) | Our caveat, written before the scrutiny: the explicit attack surface — where a finite computation, an audited constant, or a cited theorem stands in for a proved universal statement (H1-H5 + the CITED ledger), what looks like a hole but is sound, and the fix for each item. A standing document of record. |
| [CEILING-REPORT-DAY035.md](CEILING-REPORT-DAY035.md) | The re-issued honest ceiling (day035): what is NOT established — the [S1] uniform walk bound (W2-beyond, planned), the measured [S3/S4] fills, the queued 3e10 extension — and the queue close-out (items 1-5 done; the sliver / d=1/2 edge / B-6A front page closed post-queue via `SliverEdge` + `ZetaZeroSet`). No RH claim; the single source of truth for the state. A POST-DATA ADDENDUM is appended to the doc: the 3e10 band landed (pins reproduced), the classification is Outcome A (A2-class so far), the ε data layer is certified. |
| [W2-BEYOND-ATTACK-PLAN.md](W2-BEYOND-ATTACK-PLAN.md) | The [S1] attack plan (day035): the exact target stated in the W2 walk form (the uniform bound on the zero-counting tail walk), the classical constraint (Littlewood Omega-pm: continuous S(t) is unbounded — the graded walk is the object, not "S is bounded"), routes R1 (3e10 data — LANDED) / R2 (per-step drift summation — steps 1-2 in Lean as W2Beyond0/W2Beyond1, the drift reduction; data layer COMPLETE on the 3e10 band, A2-class) / R3 (kernel decay) / R4 (conditional explicit S, margin analysis) in expected-effort order, and the verification protocol. The research continuation (the A1 universal form) is being explored in S1-A1-EXPLORATION.md. |
| [S1-A1-EXPLORATION.md](S1-A1-EXPLORATION.md) | The exploration log for the universal walk bound (the [S1]/A1 research theorem): append-only entries (E1: A1 restated as "S is bounded at the zeros" — ALIVE, relocated; E2: the absolute-sum barrier — the R2 mechanism is DEAD as a universal closer, ALIVE as the A2 domain engine, with the certified 3e10 total-variation record as the empirical core; E3: the tail-split architecture hypothesis, the literature pass, the barrier as a record, the compensation idea). Written to be read: ideas in play and their verdicts. |
| [COMPUTE-DEPLOY-PLAN.md](COMPUTE-DEPLOY-PLAN.md) | The big-data crunch + deploy plan (day035, written for cross-session durability): the ironclad-script contract (incl. the 2026-09-20 audit — 3 real bugs found and fixed in day035_3e10_stream.sh: shard-count assert, finish-gate SyntaxError, RAM-unsafe finish gate), live preflight numbers (3e10 IS public: 12,858 shards,
    md5-complete, ~700-750GB band; runtime ~11h sequential /
    ~3h with the T2.5 parallel decode — the 104-bit per-zero
    decode is the wall-time lever, and a GPU gives nothing), the Docker-in-repo container design (kainos ADR-0010 pinned pattern, mpmath 1.4.1 / numpy 1.26.4 lock, Lean 4.33.1 via elan, explicit rh-reproduce runner, NO auto-run at boot), cloud options with real pricing (DO droplet + 1TB volume ~$10-15 total; Hetzner EX101 value alt), the step-by-step launch protocol, pre-registered data outcomes, and the stop-rule work units T1-T5. |
| [PREPRINT-DRAFT-DAY035.md](PREPRINT-DRAFT-DAY035.md) | The pre-print draft (tpf) for owner revision and hosting: the argument and its statistic, the data to 3e10 (the post-data revision — the 3e9 spine pins verbatim, the 3e10 layer appended, the four Lean components incl. the R2 walk-bound step, the ceiling restated), the pre-registered outcomes preserved verbatim with the post-data classification (Outcome A, A2-class so far) as a labeled addendum, the honest ceiling, and the machine-checking statement. |
| [3E10-CLOUD-RUNBOOK.md](3E10-CLOUD-RUNBOOK.md) | The 3e10 zero-band cloud extension (owner's run): machine requirements, the resumable md5-gated stream script (scripts/rh/day035_3e10_stream.sh), finish gates, the post-run S3e re-point. The decision-maker for the walk's shape past 9.06e9 zeros. |
| [H1-LEDGER-TRANSFER.md](H1-LEDGER-TRANSFER.md) | The 5900X -> isomorph ledger transfer: what gets copied (per-window .pts + provenance logs, MB-scale) and what does not (the band data — this box is its source of truth), the one-time LAN setup (subnet check, sshd, ufw, key auth), the rsync + md5 round-trip commands, and the top-up note for runs still finishing. |
| [H1-FILL-ANALYSIS-PLAN.md](H1-FILL-ANALYSIS-PLAN.md) | The bulletproof, checkpointed procedure from "fleet ledgers arrive" to "696-point ledger analyzed": the storage check, the data-safety invariants (read-only sources, widx99-only writes, conflict/corruption HALTs), the pre-built self-tested merge tool (scripts/rh/h1merge_ingest.py), the final full-grid assembly, the pre-registered C-1/C-2/C-3 reading, the statistics/cross-check/provenance analysis, and the honest document updates (no RH claim at any step). |
| [END_GAME_PLAN.md](END_GAME_PLAN.md) | The end-game plan: the 3.6 attack queue (items 1-5, closed day035), the 3.7 close-out, the remaining honest items (now pointing at ZetaZeroSet + W2-BEYOND-ATTACK-PLAN), and section 3.9's 3e10 landing plan. A 3.10 POST-LANDING APPEND is appended: the [S1] data layer DONE and certified (A2-class, Outcome A), the fill grade DECIDED (H1-full, engine built and self-tested, profile-gated), and the T2 Docker + preprint-swap items DONE. |
| [SPECTRAL-SOLUTION-LYRICS-ASIDE.md](SPECTRAL-SOLUTION-LYRICS-ASIDE.md) | The “A Spectral Solution” lyric read in project context: a by-the-way annotation linking each stanza to its real referent (the P8 floor 0.9975, the t²/t⁴ wires, the A5 terminals, the P12 closure, the discipline record — “we took the operator apart”), with no-mirror lines left as music. Linked from the song's credit block. Companion to the day-023 structural map `spectral-reframe` (working tree). Art first: the song is pre-project and owns its meaning; this file only points. |
| [RH-OUTLINE.md](RH-OUTLINE.md) | The staged proof scaffold: the outline with the per-piece status (mirror of the planning artifact; its source of record lives in the working tree — see the file header). A planning document, not a proof. |
| [THE-EULER-ACTION.md](THE-EULER-ACTION.md) | The Euler action identity — the flat-action (total-differential) reading of summation-by-parts, its recognition map into the zeta map (D = −P as edge flux; the M₁ width ladder as exact period-cell interior action; the onset as an edge-vs-zero budget crossing), with its measured results (E7a exact at dps-50; E2 exact width tables; E7b zero-side onset test),
and the naming section (tpf) carrying the two telescope name candidates (periscope primary;
Monkey King bar the silly one) plus the phi verdict (golden flavor belongs to the width
ladder — 5 and 13 are consecutive Fibonacci primes). |

## Measured records

| Document | What it is |
|---|---|
| [zero-finder.md](zero-finder.md) | The certified zero finder: n → ρₙ = ½ + iγₙ, computed (walk-and-certify pipeline), with the honest precision statement. |
| [width-ladder-tables.md](width-ladder-tables.md) | The M₁ width tables (χ₅, χ₁₃, τ₁₂, F₂₄), the D = −P certificate, the drift coefficient, the onset ratio, the antipodal structure at the first even modulus. |
| [certified-zero-survey.md](certified-zero-survey.md) | The certified exclusion to 10⁷: N, S, 2K, twins, max\|S\| per decade, the walk-defect post-mortem; engine and precision labels on every figure. |
| [e7b1-detector-b5-core.md](e7b1-detector-b5-core.md) | The exact off-line pair kernel deviation (the E7b *detector* half of the zero-side bridge): an EXACT formula plus a 6-digit measurement in the certified kernel context. |

## Machine-checked core

- [../formal/RH-LEAN-PROVENANCE.md](../formal/RH-LEAN-PROVENANCE.md) —
  home, source of record, and sync rule for the Lean package in
  `formal/` (the proof files themselves: `formal/RhAttack/`, the `rhattack`
  gate — one-command verify: `cd formal/ && lake build && lake exe
  rhattack`).
