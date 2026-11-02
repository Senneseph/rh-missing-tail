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
| `[Z-PT2]` (hPT2) | on-line data up to tPT2 = 3,000,175,332,800 | **provenance-complete AND BIT-PINNED (0263)**: Platt isolation record (tPT2 is Platt's exact isolation frontier, `WinCount.lean` L538) + Platt–Trudgian arXiv:2004.09765 independent verification (12,363,153,437,138 zeros, interval arithmetic), cited in tree (`WinCount.lean` section D, Z78 pattern); both cited papers now SHA-256-anchored in `data/provenance/PINS.json` (P-T arXiv v1 + Platt 2017 AAM in repo; LMFDB stream slice 11 shards pinned; verifier `scripts/rh/provenance_pins_check.py` exit 0). Coverage = [0, tPT2] exactly — no gap. |
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
   **FORMALIZED 0258 (T4OffLE landed, build green 17454, zero warnings):**
   the formal unit is in tree. `t4LE_emFloor` is the in-body EM-kernel
   floor at EVERY run (the reverse triangle on the wall's own
   decomposition; the run is a free parameter - the decoupling itself,
   in body); the decoupled fill run `nIdeal`/`Noff` (C_off = C*/2) has
   its scale pin in body (nIdeal >= 250000 on the band, ceil loss
   <= 2x); and `t4LE_squeeze_decoupled` runs the strict squeeze cycle
   in body (BwireR + MrR < floStripMin = own < wallLo <= kernel <= fill
   <= BwireR + MrR) given (i) the cited A2c bridge (fill = kernel norm
   at the run), (ii) the NAMED S3 face at the pair, (iii) the MEASURED
   PIN (wallLo > own; day061: 2.0000 uniform, worst 1.999999; coarse
   ceiling pin >= 1.419123). The S1 side of the terminal squeeze leaves
   the named-face set. **DISCHARGED 0259 (T4OffLF landed, build green
   17454 jobs, zero warnings): the measured pin is now an IN-BODY
   closed-form inequality on the whole band (1000 <= t, 1/200 <= d0 <
   1/2), at EVERY run N in [nIdeal, 2 nIdeal], in particular N = Noff -
   the bound chain T1b - T2b - T3b >= A (2^(101/200) - 1.03^-8 -
   1.23^-9) > A (1 + 2^-24) (1 + 10^-6) >= own, strict step 2^(101/200)
   > 1001/1000 in exact rationals (norm_num), worst margin ratio 1.4191
   at (1000, 1/200) (day062, dps 62, every step a Lean lemma).**
   `T4OffLF.squeeze_discharged` runs the squeeze on the band from the
   two external faces alone; the face residue is now {S3 face} + {cited
   A2c bridge}. hOffCPT2 stays open; this is a support-face narrowing
   record, not an RH claim. The next named fire is the S3 face itself
   (or a frontier-extension board record under the B25 watch).
   **EXHAUSTED 0260 (T4OffLG landed, build green 17454 jobs, zero
   warnings; NEGATIVE record): the S3 face is FALSE at the Noff fill
   run on the whole band, proven in body - kernel(Noff) >= wallLo
   (Noff) > own > BwireR + MrR (T4OffLG.s3legInfeas, pure closed
   chain), worst infeasibility margin 2.2271 at (1000, 1/200),
   t-flat (day063, exact B3Core model): the decoupled squeeze's
   premise set is inconsistent in body and CANNOT discharge an
   off-pair - the Q2 decoupled construction is CLOSED as a route,
   both legs in body (S1 carries with factor 2.0000, 0258/0259; S3
   cannot, 0260). **EXHAUSTED FOR ALL d0 0261 (T4OffLH landed, build
   green 17454 jobs; negative margin record + in-body near-line band):
   the near-line half-subband (0, 1e-3] is now covered IN BODY - S1
   Noff >= schedB (T4OffLH.NoFf_above_sched), S2 wallLo(Noff) <=
   BwireR + MrR (T4OffLH.noTension_target, worst ratio at d0near
   1e-3: 0.089 wall-ratio / 0.0445 own-ratio), S3 tension => d0 >
   d0near (T4OffLH.tensionImpliesAbove); the measured seams
   (1e-3, d0star] and [d0star, 1/200) (day064: 0/60 closure points,
   wallLo/own = 2.0000 uniform, best wallLo/(BwireR+MrR) = 0.971 at
   the d0star edge, Noff/schedB crossing 1 at d0star =
   31000000^(-1/4)/4 = 3.350423e-3, t-independent; t-flat on
   [1e3, 1e16]) join 0260's in-body [1/200, 1/2): tension (T, onset
   ~4.74e-3, t-uniform) and S3-face (F, d0 <= d0star = 3.35e-3) are
   DISJOINT in d0 at target height - the Q2 decoupled family has NO
   contradiction zone for ANY d0 at ANY t >= tPT2. The Q2 line
   (0257-0261) is closed as a closure route for hOffCPT2. Sharpened
   residue: any S3 leg discharging a tension-zone pair (d0 > ~4.74e-3)
   must bound the TRUE fill |zeta - (p4_P - p4_I) Noff|, NOT the EM
   kernel lower bound (which sits above the wire wall there) - route
   (a) zeta-data-class input or route (b) genuinely new argument
   outside the EM-squeeze class (asymmetric EM families, 3.1e-46
   certificate scale, no blocker). hOffCPT2 stays open.
   **GENERALIZED 0262 (T4OffLI landed, build green 17454 jobs;
   negative record): the infeasibility of 0260 generalizes with the
   FREE RUN PARAMETER - at ANY run N (not just Noff), given the
   squeeze's own two external premises (the cited A2c bridge at N
   and the pin wallLo(N) > own), the S3-face premise is FALSE in
   body: fill(N) = kernel(N) [bridge] >= wallLo(N)
   [T4OffLE.t4LE_floor_off, run-free] > own [pin] = floStripMin
   [t4LE_flo_eq_own] > BwireR + MrR [FUnif.s4StripUnifiedFloor,
   MfR = 0]. The premise set {bridge, face, pin} is jointly
   inconsistent in body for EVERY N: NO squeeze instance -
   in-program schedule run (0252/0253), decoupled fill run Noff
   (0257-0261), or any un-named run - can discharge hOffCPT2 on
   [1/200, 1/2) at target height. T4OffLG.s3faceFalseAtNoff
   re-derives as the Noff instantiation (0259 pin supplies the pin
   premise). Residue narrowed: surviving inputs must sit OUTSIDE
   the {pin + bridge + face} structure - route (a) zeta-data-class
   records (B24/B25 board conveyor; board idle at the TEN family
   contact, watcher armed) or route (b) a direct bound on the TRUE
   fill that does not route through the EM-truncation cycle. The
   0257 'asymmetric family' question is settled accordingly: an
   asymmetric construction that reuses the squeeze cycle at a run
   is killed by the same chain; a surviving one must bound the true
   fill without asserting the pin on that run. hOffCPT2 stays open.
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
| (D) Platt checksum pinning | hours | provenance hardening | **CLOSED 0263**: cited papers + stream slice SHA-256-pinned (data/provenance/PINS.json, verifier exit 0) |
| (E) open-question pursuit (1) decoupled-run variant — CLOSED 0260/0261 (S3-leg infeasible at Noff, in body); (2) asymmetric EM families — RESOLVED BY 0262 (any instance reusing the {pin+bridge+face} cycle at a run is killed in body; a surviving one must bound the true fill without the pin on that run); (3) genuinely new argument outside the squeeze class — OPEN (research) | research scale | the only non-board path to hOffCPT2 |

## 4. Honesty boundary

- The endpoint is CONDITIONAL (three named external inputs + the terminal
  face). It stays conditional until the records exist.
- The 0244–0247 wire maps, T4OffLB/LC/LD anchors, and the 058e/day059
  measurements are OFF-BOARD POSITIVE-DUAL MARGIN RECORDS: machine-verified,
  exact, explicit — they characterize mechanism reach; they assert no zero
  non-existence and make NO RH claim.
- Everything in this plan is scoped work; nothing here is a claim about
  RH.
