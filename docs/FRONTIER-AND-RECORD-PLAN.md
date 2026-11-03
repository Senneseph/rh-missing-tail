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
   **ATTACK STARTED 0264 (P8A2c U0 landed, build green 17454 jobs,
   zero module warnings): the cited A2c bridge itself is now under
   formal attack - the 0255 parked question (1).** The identity-
   theorem plan: on U = {s | s.re > -1} \ {1}, both sides
   (W = zeta - p4_P n + p4_I n, and p4_em_expr s n) are analytic
   and equal on {Re s > 1} (P4Limit.p4_identity, LEAN) => equal on
   U by the identity principle => the bridge is an in-body theorem,
   and 0262's squeeze infeasibility stands on its own premises
   without the citation. U0 in body: D/U domains (open, D convex +
   connected), the 3-segment path geometry through the vertical line
   {Re = 2} (anchor + segment lemmas segA/segM - every path point
   stays in U), and a2c_sL_in_Dcut (band off-points in U). U1-U6
   roadmap pinned with all Mathlib APIs verified in this checkout
   (hasFDerivAt_integral_of_dominated_loc_of_lip, DifferentiableOn.
   analyticOnNhd, AnalyticOnNhd algebra, eqOn_of_preconnected_of_
   eventuallyEq, analyticOn_riemannZeta; template: Mathlib
   ZetaAsymp:477 does exactly this move zeta-on-{1}^c style). The
   only genuinely new mathematics is U1-U4: s-analyticity of the
   tail integral INT_{Ioi n} (B2 x) s(s+1) x^(-s-2) dx on
   {Re s > -1} (its exact absolute-convergence domain).
   **COMPLETE 0265/0266 (P8A2c U1-U6 + T4OffLJ landed, build green
   17454 jobs, zero module warnings): the A2c bridge is IN BODY
   (0265: identity theorem on {s | s.re > -1} \ {1} at basepoint
   2+2i against p4_identity at Re s > 1; a2c_inbody_identity +
   a2c_sL_bridge + seven _inbody squeeze companions in T4OffLE/
   LF/LG/LI). The squeeze line advances to TOTAL EXHAUSTION
   (0266: T4OffLJ - the face-premise pair {S3 face, pin} is
   jointly impossible IN BODY at EVERY run on the band, no bridge
   premise, no pin fact; weak-pin face-death extension
   s3faceDeadWeakPin; day065 map 36/36 band points EXHAUSTED -
   live window W = (N1, min(N2,N3)) empty everywhere, N1 >= N2 a
   direct consequence of the in-body S4 gap wire < own; strict
   A2c-exact fill at t = 1e3: |em(sL,Noff)|/wallLo - 1 <= 6.1e-15,
   |em(sL,Noff)|/own = 2.000000 - the 0259 pin in the exact fill).
   The EM-squeeze class has no premise-consistent instance
   anywhere on the band at target height; the 0262 record stands
   in its strongest form, citation-free. Residue for hOffCPT2 =
   the NON-EM class ONLY: (a) board / zeta-data records above
   tPT2 (external, board idle at the TEN contact, watcher armed)
   or (b) a direct |zeta| lower bound / genuinely new argument at
   height >= tPT2, sigma in [1/2 - d0max, 1/2], outside the EM
   kernel entirely - research scale, the terminal face itself.
   Named next formal fire: the weak-pin range extension (in-body
   range-pin wallLo(N) > own for N in [nIdeal, 2 nIdeal] +
   wallLo monotonicity in N - components already in T4OffLF).
   **LANDED 0267 (T4OffLK): pinRange (the range pin, verbatim port of
   the 0259 pin with the free N in [nIdeal, 2 nIdeal]) +
   s3faceInfeasiblePinRange (S3 face infeasible THROUGHOUT the range
   via weak-pin + S4 gap; no pin premise) - the first in-body
   face-infeasibility over an INTERVAL of runs. Next formal fire:
   the WIRE-CROSSING extension (wallLo(N) > wire for N beyond
   2 nIdeal up to the day065 N1 crossing - a closed log/rpow chain;
   day065 margins: tightest log10(N1/N2) = 0.094 at (1e3, 1/200),
   robust at every grid point).
   **LANDED 0268 (T4OffLL, the wire-crossing fire): Nstar in CLOSED
   FORM - (2*(BwireR+MrR+C2+C3))^(-(1/(1/2-d0))), the crossing where
   the T1-only wall (T2/T3 frozen at their 2*nIdeal values) touches
   the wire; wirePos + Nstar_pos + wallLoAboveWire (wall strictly
   above wire for every run in [2*nIdeal, Nstar)) +
   s3faceInfeasibleBelowNstar (A2c-exact fill strictly above the wire
   for every run in [nIdeal, Nstar), by cases 0267-range /
   0266-atom). The S3 face is now premise-impossible in one piece
   across [nIdeal, Nstar) - the interval-valued face-death record
   reaches the (frozen-tail) wire crossing in closed form; numerics
   (50-dp): Nstar < N1 strictly at every point, N1/Nstar = 1+4e-16
   at (1e3,1/200) - the frozen crossing IS the true crossing up to
   relative 1e-16 at small d0. Next formal fire (optional
   sharpen): unfreeze T2/T3 for N > 2*nIdeal to push the face-death
   region from Nstar to the true N1 (gain = relative tail size).
   **REDUCTION 0269 (read-level, cross-checked in tree): the whole
   terminal face quantified.** hOffCPT2 = no off-pair at t0 >= tPT2,
   0 < d0 <= colletD0max = 8747729897/10^10 - 1/2 = 0.3747729897
   (the [Z78C] functional-equation shell: off-line zeros above the
   frontier sit in sigma in [0.125227, 0.874773]). Face split at
   target height: nearline (0, 1e-3] IN BODY (0261); two measured
   seams (1e-3, 1/200) (0261/day064, 0/60, t-flat); strip band
   [1/200, 0.374773] = 98.7% of the width, discharged IN BODY (B10:
   t4l_bandWireBelow/t4l_bandEmpty/t4l_stripFacesEmpty: wire+Mr <
   devProg from t4m_margin + FUnif.s2ActualFullBand) GIVEN the G-hs1
   pin family at band zeros (B8: P1 hFill in body at a zero; P2 hDev
   CENSUS-DEPENDENT; P3 hMass measured; P4 hAbsorb in-body). THE
   ENTIRE RESIDUE OF RH = {P1-P4 at t0 >= tPT2} + {nearline seams}.
   Route (a) = extend the pin/data machinery past tPT2 (board). Route
   (b) sharpened = analytic zero-freeness of sigma in
   [1-colletUpper, 1/2] at t >= tPT2 - a DIRECT |zeta| exclusion
   never using the census kernels; with [Z78C]'s shell it IS full RH
   above the frontier (the whole B10/squeeze/EM machinery 0257-0268
   then becomes irrelevant - it is the data-side bookkeeping of
   route (a)).
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
| (E) open-question pursuit (1) decoupled-run variant — CLOSED 0260/0261 (S3-leg infeasible at Noff, in body); (2) asymmetric EM families — CLOSED BY 0262+0266 (0262: the {pin+bridge+face} cycle killed in body at every pinned run; 0266: the face-premise pair {S3 face, pin} internally inconsistent at EVERY run WITHOUT the bridge premise — total EM-class exhaustion, day065 map 36/36 EXHAUSTED; no EM run/scale/asymmetry survives; 0267/0268 sharpen the record to interval-valued face death on [nIdeal, Nstar) in closed form); (3) A2c bridge in body — COMPLETE 0265/0266 (bridge an in-body theorem; _inbody squeeze companions; T4OffLJ total-exhaustion record); (4) genuinely new argument outside the squeeze class — OPEN (research): now the ONLY live route to hOffCPT2 beside board/data route (a); 0269 pins its exact content (analytic zero-freeness of sigma in [1-colletUpper, 1/2] at t >= tPT2 - IS the terminal face = RH); 0270 scopes it: Claim (b) exact + gap probe (no classical boundary/density reaches it: K-V left edge 0.001237 vs target 0.125227 at tPT2) + tool review (Levinson and density ruled out; explicit-formula-at-explicit-heights = FIRST attack line, project-native) — see docs/ROUTE-B-SCOPE-2026-11-03.md; 0271: day066 window survey shows the grid is 1.2e6 oscillation periods coarse (zero spacing ~0.205 at 3e12) - a window-wide |zeta| below-bound is CERTIFIED-VOID (depends on unknown zero positions above tPT2); attack line corrected to the LOCAL disk explicit-formula identity at a single off-line zero (prime side explicit + known-zero side exact via Platt 0263 + unknown-zero side bounded by R-vM spacing) — 0272 calibration unit; 0272 GREEN: single-zero Efull identity verified to 7e-25 at 5 on-line zeros (removable value = zero-derivative residue); LESSON: the identity holds for ANY zero and cannot exclude off-line zeros alone - the exclusion enters via the explicit-formula COUNT + R-vM boundary bound + exact known-zero side; 0273 = count-residual calibration in the fully-known territory below tPT2 (error budget must stay < 1/2 at (t >= tPT2, strip) to discharge Claim (b)) | (4) research scale | (3) DONE — 0262's record citation-free and premise-minimal; (4) the terminal face itself |

## 4. Honesty boundary

- The endpoint is CONDITIONAL (three named external inputs + the terminal
  face). It stays conditional until the records exist.
- The 0244–0247 wire maps, T4OffLB/LC/LD anchors, and the 058e/day059
  measurements are OFF-BOARD POSITIVE-DUAL MARGIN RECORDS: machine-verified,
  exact, explicit — they characterize mechanism reach; they assert no zero
  non-existence and make NO RH claim.
- Everything in this plan is scoped work; nothing here is a claim about
  RH.
