# FRONTIER-AND-RECORD-PLAN (hPT2 / hOffCPT2) — 2026-11-01 (discovery 0255)

Companion to `docs/RECORD-REQUIREMENTS.md` (0251). That spec says WHAT the
completion layer is; this plan scopes the COMPUTE and names the remaining
open questions. No RH claim anywhere in this document.

## 1. Where the endpoint stands (evidence-verified 2026-11-01)

The terminal theorem `RHEnd.rh_program78_stripfront_mach_unifiedPosReserve_PT2`
(→ `..._unifiedGapContact_PT2` once PR #101 merges and B23 fires — pre-staged
and compile-validated, see `tmp/b6audit/prestage101/CONVEYOR-101.md`) stands on
exactly three external records:

| record | obligation | status |
|---|---|---|
| `[Z78]` (hzF) | zero-free half-plane θ | **TEN in tree (0256)**: `closest-fraction-contact` at the exact 127/127-digit rational ≈ 0.8733819666132075199290267786... (PR #103 MERGED 2026-11-01T12:23:55Z, stage C 236/236 replay clean, B24 in-tree); NINE/EIGHTH survive as predecessor refs. Board idle below TEN (runner-up T + 9.732e-22, weaker) — the record family is at its method contact (777 − √1081)/852 |
| `[Z-PT2]` (hPT2) | on-line data up to tPT2 = 3,000,175,332,800 | **provenance-complete**: Platt isolation record (tPT2 is Platt's exact isolation frontier, `WinCount.lean` L538) + Platt–Trudgian arXiv:2004.09765 independent verification (12,363,153,437,138 zeros, interval arithmetic), cited in tree (`WinCount.lean` section D, Z78 pattern). Coverage = [0, tPT2] exactly — no gap. |
| `hOffCPT2` | no off-pair on [tPT2, ∞) × (0, posReserveD0max] | the TERMINAL FACE (0251 §4) |

hPT2/honline/hqz/Qside: no gating work. hzF: at the family contact (conveyor ready for the next MERGED record below TEN).

## 2. hPT2 in-house integrity program (forensics closure)

**State (evidence: `docs/VALIANT-EFFORT-FORENSICS.md` §5,
`scripts/rh/h1_final_fleet/VERIFICATION.md`):** the 2026-09-29 forensics
voided the 3e10 fleet CERTIFIED claim (deterministic assembly bug in the
day037/day038 engine: nested quad_pair remainder double-counted into Kfull →
mcert = 1.0000 on every row, bit-identically across machines; the pre-patch
module reproduces the ledger rows to all 10 printed digits). The SCREEN-level
fill remains valid. The engine is FIXED (two-line fix + |Kfull| ~ O(|z|)
assembly selftest, committed), and the re-issue pipelines
(day048 margin re-issue, day049a pi-probe, day049f worst-24) carry genuinely
CRT-verified margins (worst re-issued piece: mnew 0.50265809882 vs the ledger
0.9999999965 fingerprint).

**Compute scoping (evidence: `docs/H1-FLEET-RUNBOOK.md` §5 measured pace):**
- 3e10-scale re-issue on the fixed engine: local 3-machine fleet
  ~12–24 h wall (GPU box: 288-window half in ~8–12 h at 24–40 pts/h with
  4 contexts; CPU fallback ~428 MB/s per context). This box: 4 cores must
  stay open (standing discipline) — the fleet pattern uses 3 machines; on
  this box alone, CPU mode, ~10–20h wall for the affected windows.
- An in-house certified run toward tPT2 (3e12): from 3e10 to 3e12 is ~100×
  the interval → ~100–150 local fleet-days (cloud-burst class).
  **Strictly BELOW the cited record's coverage** (the Platt/P–T citation
  already certifies [0, tPT2] with an independent verification) — it buys
  in-house self-containment ONLY, not endpoint progress.

**Recommendation:**
- YES: 3e10 fixed-engine re-issue (closes the forensic loop in-house;
  1–1.5 days; turns the screen-level fill into a certified cross-check).
  This is integrity work — it does not gate the endpoint.
- NO (defer/infeasible as scoped): in-house run toward 3e12 — fleet-scale
  with strictly less coverage than the citation it would sit beside.
- OPTIONAL (cheap, per 0251 §5.3): pinned zero-stream checksums for the
  Platt data (provenance hardening, hours not days).

## 3. hOffCPT2 — the terminal face, status and named open questions

**Dead routes (all recorded, none reopen):**
- (a) direct far-strip zero computation — data-side infeasible (0251 §4).
- (c) per-point schedule squeeze — MEASURED NEGATIVE (0252) and FORMALIZED
  (0253, T4OffLD): the 0123 single-C family's two leg thresholds coincide
  (reciprocal knife edge r1·r3 = 1 in body); no C > 0 closes both legs at
  any band point; strict margin, not a touch (t4LD_productStrict).
- (d) direct band-exclusion record — out of scope by design (≡ RH above the
  frontier; no board vehicle).

**Live mechanisms:**
- (b) board ladder — each MERGED [Z78]-class record shrinks the face by
  its δθ. EIGHTH→NINE −9.248e-14 (0254); NINE→TEN −7.097e-20 (0256): the
  frontier is converging, and TEN is the closest declarable fraction above
  the method-contact (777 − √1081)/852 — this record family is at its
  limit; further shrinkage needs a different family or a full-RH board
  record. The ladder alone closes the face only in the limit θ → 1/2 — a
  convergence statement, not a termination. The B-series machinery
  (`CONVEYOR-101.md`/`CONVEYOR-103.md`, B23/B24/B25...) is the repeatable
  adoption loop (idle until a weaker MERGED record appears).

**Named open questions (parked, precisely scoped):**
1. **Decoupled-run variant.** 0252 measured the SINGLE-C section of the
   0123 family (fill leg and wire leg tied to one C — the per-point witness
   run and its on-line counterpart). The 2026-10-16 Qside re-typing note
   (P12Uniform.lean, S1 block) records that the DECOUPLED leg form
   ("exists Q in S1 / for-all Q in S3") was tried in the engine's design and
   REJECTED: it "decoupled the legs and made S3 unsatisfiable for ANY
   finite wire" — the squeeze witness Q is ONE concrete scale, the same in
   S1 and S3 (see `squeeze_gives_margin`: one Q in
   `Q >= dev − M ∧ Q <= Bf + Mr'`). A run-decoupled variant (S1 certified at
   fill run C1, S3 at wire run C2, C1 < C* < C2) would need (i) a re-typed
   S3 statement with independent wire runs (against the record above) and
   (ii) new per-pin measurement data at the decoupled run. **MEASURED 0257
   (day060 probe, closed forms):** the decoupled construction Coff < C* <
   Con is trivially satisfiable at the closed-form leg level (108/108 band
   points, margin ratio 2.0000, C*1 == C*4 == 1/(8 d0^2) to machine
   precision) and is EXACTLY the shared-value pathology the note describes
   (the legs then bound different quantities). CLOSED SHARPENED as a
   decoupling route; the only residue is the tail-transfer certificate of
   (i)+(ii) — now scoped under Q2.
2. **Asymmetric EM families.** Any family where the S1 fill engine and the
   S4 tail wall do not share the (1/2)C⁻¹t⁻² scale (e.g. higher-order EM
   truncation with a tail-transfer certificate between runs) escapes the
   knife-edge identity. 0252/0253 close the 0123 family, not all families.
   **MEASURED 0257 (day060 first-order probe, closed forms):** the
   tail-transfer certificate a single-shared-value squeeze at decoupled
   runs would need has measured term scale cert/devProg = 3.1e-46 at
   (tPT2, 1/200) (d23 = 7.2e-76 / 2.7e-75, |dMval| = 6.8e-84, dps-60):
   NOTHING at the scale level blocks it. RE-SCOPED from research surface
   to a FORMAL work item: re-typed single-shared-value S3 statement +
   certificate in body + decoupled-run per-pin data (research scale).
3. **Frontier extension (0126 route A, B6-board family).** An external
   record family that extends the certified on-line frontier past tPT2
   (new isolation record beyond Platt) would re-label the face to a higher
   frontier H with the same face on [H, ∞) — a move, not a close; becomes
   a close only at H = ∞ (i.e. a full on-line record) — the same limit as
   (b) in the other direction.

**Decision matrix (owner's call):**
| option | cost | endpoint effect |
|---|---|---|
| (A) wait for a new BOARD merge below TEN | 0 (watcher alive) | hzF face −δθ per weaker MERGED record (B25 fires one-shot); board idle at the family contact as of 0256 |
| (B) 3e10 re-issue fleet | 1–1.5 days local | integrity loop only (forensics closure); no gating |
| (C) in-house 3e12 run | 100–150 fleet-days (cloud) | none (citation already covers [0, tPT2]) |
| (D) Platt checksum pinning | hours | provenance hardening |
| (E) open-question pursuit (1)–(3) | research scale | the only non-board paths to hOffCPT2 |

## 4. Honesty boundary

- The endpoint is CONDITIONAL (three named external inputs + the terminal
  face). It stays conditional until the records exist.
- The 0244–0247 wire maps, T4OffLB/LC/LD anchors, and the 058e/day059
  measurements are OFF-BOARD POSITIVE-DUAL MARGIN RECORDS: machine-verified,
  exact, explicit — they characterize mechanism reach; they assert no zero
  non-existence and make NO RH claim.
- Everything in this plan is scoped work; nothing here is a claim about
  RH.
