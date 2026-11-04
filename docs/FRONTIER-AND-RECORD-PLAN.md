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
| (E) open-question pursuit (1) decoupled-run variant — CLOSED 0260/0261 (S3-leg infeasible at Noff, in body); (2) asymmetric EM families — CLOSED BY 0262+0266 (0262: the {pin+bridge+face} cycle killed in body at every pinned run; 0266: the face-premise pair {S3 face, pin} internally inconsistent at EVERY run WITHOUT the bridge premise — total EM-class exhaustion, day065 map 36/36 EXHAUSTED; no EM run/scale/asymmetry survives; 0267/0268 sharpen the record to interval-valued face death on [nIdeal, Nstar) in closed form); (3) A2c bridge in body — COMPLETE 0265/0266 (bridge an in-body theorem; _inbody squeeze companions; T4OffLJ total-exhaustion record); (4) genuinely new argument outside the squeeze class — OPEN (research): now the ONLY live route to hOffCPT2 beside board/data route (a); 0269 pins its exact content (analytic zero-freeness of sigma in [1-colletUpper, 1/2] at t >= tPT2 - IS the terminal face = RH); 0270 scopes it: Claim (b) exact + gap probe (no classical boundary/density reaches it: K-V left edge 0.001237 vs target 0.125227 at tPT2) + tool review (Levinson and density ruled out; explicit-formula-at-explicit-heights = FIRST attack line, project-native) — see docs/ROUTE-B-SCOPE-2026-11-03.md; 0271: day066 window survey shows the grid is 1.2e6 oscillation periods coarse (zero spacing ~0.205 at 3e12) - a window-wide |zeta| below-bound is CERTIFIED-VOID (depends on unknown zero positions above tPT2); attack line corrected to the LOCAL disk explicit-formula identity at a single off-line zero (prime side explicit + known-zero side exact via Platt 0263 + unknown-zero side bounded by R-vM spacing) — 0272 calibration unit; 0272 GREEN: single-zero Efull identity verified to 7e-25 at 5 on-line zeros (removable value = zero-derivative residue); LESSON: the identity holds for ANY zero and cannot exclude off-line zeros alone - the exclusion enters via the explicit-formula COUNT + R-vM boundary bound + exact known-zero side; 0273 (entry 0273, RE-CORRECTED same day after day070/day071 forensics): day068 count-residual calibration GREEN in known territory (9 rectangles, worst residual 3.4e-37 = the dps-40 noise floor, the AP counting mechanism is CALIBRATED); day069 xi-product face probe at tPT2: NOT VALIDATED - the printed EXCLUDED labels are provisional (the validity check |U|<=B_unk fails because the printed U_actual is contaminated by two pinned defects: the lshard .dat reader emits garbage after a leading stretch (~54.9M spurious zeros injected, ~4.55e7 real zeros missing in 8.85e6..3.19e7) and the unknown-side MAIN TERM quad over (3.001e9,16t) is off by O(1e12); the earlier 'the xi kernel is the wrong lever' reading is RETRACTED as premature); day070/day071 t=1e9 anchor forensics pin every side: U_true = -1.13363e9 +/-0.1 in closed form, Re log phi dps-60 stable, zeta dps-60 stable, S_required = +3.4823e8, the hi-f64 chain + T10M txt proven continuous and correctly read (3-way dps-30 cross-check passed on the extra file), clean anchor residual -1.3e7 at the known data-gap floor - the xi mechanism itself is NOT in doubt; no exclusion claim, no RH claim. NEXT UNIT 0273a-r: (1) repair the lshard reader across all blocks (gate: every shard internally continuous, per-block counts within 0.1% R-vM); (2) re-close the t=1e9 anchor to the data-floor; (3) recompute the tPT2 unknown-side MAIN TERM by u-substitution (analytic 2ln|u-1| dip extraction + dps-50 fine+log regular quad + exact c4/g^2 tail, error << B_unk); (4) re-run the 4 face sigmas with corrected K': the corrected fluctuation log|zeta(s)|-K' against B_unk is the theorem's premise - certified exclusion of the probed face points iff K'-B_unk > 0 (K' ~ +4.6e11 ~ 3e7 x B_unk); 0273a-r then RAN TO COMPLETION (same session, 2026-11-07; supersedes this NEXT-UNIT line): lshard reader repaired (13-byte records = CUMULATIVE intra-block deltas; all 11 shards validated); t=1e9 anchor closed at the data floor (rel 1.7e-7); tPT2 main term dual-validated (gates rel 2.18e-9 / 4.37e-10, tPT2 spread rel 3.5e-9); identity closes INSIDE the certified bound at face height (|fluct| = 9052 <= B_unk = 25,210, all four sigmas) - BUT K' = -9,042 (face-flat) < B_unk and K' - B_unk = -34,253..-35,679 < 0: the probed face at tPT2 is NOT excluded; the EXPECTED K' ~ +4.6e11 was the broken-reader artifact. 0274 optimal-split (in-repo ordinates actually run to 3e10, hi3e10 band 92,577,877,714 zeros): face NOT excluded at the strongest data cut - premise holds with positive slack (B_unk - fluc = +1,243.29..+2,304.48, optimal cut); FIRST CERTIFIED FACE REDUCTION: frontier unit window (tPT2-1, tPT2+1] carries <= 33/33/34/34 zeros (vs ~196 raw law); gap to window exclusion +936..+955 (9.4-10.2% envelope sharpening would close sigA = next unit 0275); formal record LANDED (T4OffLM: validA..N / openA..N / windowA..N / gapToExclA..N / gDataBelowTPT2Over100, composite faceOpenAtTPT2); day073b pin K'_opt = -9,049.40..-9,059.20 (density residual -7.2100); day074 slope dK'/dt = -3.006e-9 (K' t-frozen, no crossing in t). FOURTH CORRECTION: the 'K' - B_unk < 0 wall margin' framing of the first 0274 draft is WITHDRAWN (criterion defect - B_unk is the all-configuration envelope; the signed numbers are true arithmetic, not exclusion margins); see sec 3bis. Route (b) as designed is REFUTED at face height with a fully validated machine (excludes nothing; the face is conformant). 0273b (top-edge AP rectangle AT tPT2) stays documented but is computationally infeasible with direct dps-40 zeta (superseded) - full record: docs/ROUTE-B-0273-DESIGN-2026-11-03.md (incl. 0274 appendix), entries 0273/0274 | (4) research scale | (3) DONE — 0262's record citation-free and premise-minimal; (4) the terminal face itself |


## 3bis. 0273a-r / 0273xi / 0274 FINAL STATUS (2026-11-07, discoveries 0273-0274)

The route-(b) explicit-formula program (0270 attack line 3) has been executed to
completion with a fully validated machine. Authoritative record: entry 0273
(re-corrected final), entry 0274, docs/ROUTE-B-0273-DESIGN-2026-11-03.md (incl.
the 0274 appendix), formal module RhAttack.T4OffLM (the named wall record),
scripts/rh/day068..day074 + outputs.

**What landed (validated):**
1. day068: the AP rectangular count-residual mechanism is CALIBRATED in known
   territory (9 rectangles, worst residual 3.409e-37 = dps-40 noise floor).
2. The lshard .dat reader was REPAIRED (13-byte records are cumulative
   intra-block deltas: Z_k = lo + mid*2^64 + hi*2^96, v_k = t0 + cumsum(Z)*2^-101)
   and validated on all 11 shards (54,902,376 zeros, 1:1 vs T10M text overlap to
   3e-4, seams exact). The earlier 4.5e7-injected / 4.5e7-missing garbage is gone.
3. The t = 1e9 anchor identity closes end-to-end at the data floor (residual
   ~192 on the 1.13e9 scale = rel 1.7e-7): the xi-product mechanism (S known
   side + U unknown side + phi + zeta) is validated at low height.
4. Day072: the tPT2 unknown-side main term is dual (c4-decomp g-space pin vs
   u-substitution y-space, dps-60, 0.01-step dip core windows; gates at t = 1e9
   rel 2.18e-9 and t = 4e9 dip-in-range rel 4.37e-10; tPT2 dual spread rel
   3.5e-9): I_unk = -2.498792312e12 (sigma-flat). The S stream over the repaired
   data (9,068,473,888 zeros): S = +1.424601076e11. K' = S + I_unk - Re log phi
   + log(1/2) = -9,042.2 / -9,045.5 / -9,049.6 / -9,052.0 for the four probed
   sigmas (the left-edge value 0.1252270103, 1/4, 2/5, 49/100).
5. Day073 (0274 unit A): the in-repo zero ORDINATES actually run to 3.0e10
   (hi3e10 band: 92,577,877,714 zeros, raw f64, last = 30,001,045,999.981976).
   At the optimal split G = 3e10: K'_opt in [K3 - 1799.20, K3 + 1799.20] (all
   sigmas), certified B_unk_opt = 10,302.85 / 10,421.49 / 10,690.00 /
   11,364.76 (exact telescoping per-unit form, B1 = 3.4 ln tPT2, asserted
   monotone pieces). Max-band K'_opt - B_unk_opt = -17,545.84 / -17,667.83 /
   -17,940.37 / -18,617.55 < 0 on EVERY probed sigma: the wall PERSISTS at the
   optimal data cut.
6. The identity closes INSIDE its certified bound at face height (|fluct| =
   9,052.4..9,053.1 <= B_unk = 25,210..26,627 all four sigmas): the mechanism's
   validity premise holds; the failure is the SIGN OF K', not the bound.
7. Formal landing: RhAttack/T4OffLM.lean (T4OffL* class, off-board negative
   margin record): faceSigma, gData, gDataBelowTPT2Over100 (the 100x data gap
   as a named theorem), K3A..K3N, bandOpt, BunkA..N, kOptNeg* (K'_opt negative
   on its whole band), wallA..wallN, named margins marginA..N =
   -17,545.835335 / -17,667.827874 / -17,940.368635 / -18,617.546604, plus the
   composite faceWallAtTPT2. No RH claim.

**The honest verdict (no RH claim, nothing is excluded):** the pointwise
xi-product + R-vM per-unit count-law attack line (0270 line 3) is REFUTED at
face height: the corrected main term K' is negative on its whole validated band
and strictly below the certified fluctuation bound, at BOTH data cuts available
in the repo (GLAST cut: K' - B = -34.3k..-35.7k; optimal 3e10 cut:
-17.5k..-18.6k). The tPT2 split (with hypothetical full Platt ordinates) would
only shift the band by O(B1 TV) ~ 4.6k and the wall persists (margin
~-8.3k worst case). The 0270 line-2 sub-claim (a uniform left-edge |zeta|
lower bound at sigma = 0.1252270103 for t >= tPT2) remains the open lever of
the rectangle-AP approach; per-cell rectangle AP above tPT2 is a finite
computation that cannot by itself cover the infinite face.

**Provenance map of the gap (authoritative, 2026-11-07):**
- in-repo zero ORDINATES: (0, 3.0001e10] (T10M text + 11 lshards + hi-f64
  chain + 3e10 band; 3e10 band is the ceiling).
- [Z-PT2] (Platt-Trudgian arXiv:2004.09765, pinned 0263): ON-LINE-NESS of all
  zeros in (0, tPT2] by rigorous interval sign-change counting. The paper
  itself states NO zero list beyond the counting was generated ("we had
  nowhere to store that many zeroes"): no ordinates for (3e10, 3e12] exist in
  the repo or in the cited record; producing them is the 100-150 fleet-day
  (C) run.
- the terminal face (claim (b)) lives at t >= tPT2 = 3.0002e12: 100x above the
  ordinate data and 30x above the citation boundary.

**0274 FINAL (2026-11-07, landed; entry 0274; FOURTH CORRECTION):**
day073b pinned K'_opt at the data floor: -9,049.3953 / -9,052.7478 /
-9,056.7786 / -9,059.1966 (92,571,198,520 zeros in (GLAST, gData]; SUM =
+987,406,884,352.812; density residual SUM - Int = -7.2100 sigma-flat to 4
digits; two-form rel 2.2e-8; pre-flight worst 1.8e-15). day074 settled the
t-slope at t = tPT2 + 3e9 (dual main term rel 3.5e-9, identity closure ALL
FOUR): dK'/dt = -3.006e-9 per unit (sigma-flat, measured to ~1e-10): K' is
t-FROZEN (the 0273 'decreasing in t (dK'/dt ~ -0.04)' line is WITHDRAWN -
the leading asymmetries cancel exactly in K': -pi/4 (I_unk) vs +pi/4 (phi),
-2N_G1/t (I_unk) vs +2N_G1/t (S)). **FOURTH CORRECTION (the exclusion
criterion defect, 0274):** the 0273-design step-4 criterion 'K' - B_unk > 0
<=> exclusion' is WITHDRAWN - B_unk is the ALL-configuration envelope
(covers a probe-disk zero) and K' < 0 < B_unk is by construction, not a
margin; the signed 'wall' numbers (-17.5k..-20.4k) are true arithmetic but
not exclusion margins. **Sound record:** the premise HOLDS with positive
slack (B_unk - fluc = +1,243.29 / +1,361.85 / +1,630.13 / +2,304.48 at the
optimal cut): the face is CONFORMANT - NO EXCLUSION (T4OffLM openA..N); and
the FIRST CERTIFIED FACE REDUCTION: the frontier unit window (tPT2-1,
tPT2+1] on the zero ORDINATES contains at most 33/33/34/34 zeros (vs ~196
raw law: 5.9x; T4OffLM windowA..N); the gap to window exclusion is E_win -
fluc = +936.4 / +946.7 / +954.0 / +955.0 (a 9.4-10.2% envelope sharpening
closes sigA). **NEXT UNIT 0275 (named):** envelope sharpening WITHOUT new
data (sharp local-count constant A0: 3.4 -> ~3.08, kernel/TV sharpening)
targeted at E_win < fluc at sigA => the frontier window certified EMPTY;
then the t-supremum for the face-wide statement. Beside it: (a) the fleet
3e12 data extension (the only concrete data path) and (b') a genuinely new
mechanism. The terminal face (claim (b), hence RH) remains OPEN at this
record. No RH claim.

## 3ter. 0274 FIFTH CORRECTION + 0275 COMPLETE (2026-11-09)

**FIFTH CORRECTION (a defect of 0250, found while validating the 0275
asymptotic cell):** `U_pin_c4` (scripts/rh/day072_face_U_repair.py)
double-counted the c4/g^2 tail beyond Y2 = 2^24*160*t (bias -8,823.29 at
tPT2, -1.0052e7 at t3): every 0273a-r/0274 K'/fluc line using the c4pin
main term was contaminated. Corrected: K'(GLAST) = -218.89/-222.25/
-226.28/-228.70 (face-FLAT, |K'| < 240), fluc (gData cut) = 236.27/236.35/
236.57/236.99 (lower bounds), validity slack 10,066.58..11,127.77 (98%).
The draft 0274 window line 'k <= 33/33/34/34 (5.9x reduction)' is
RETRACTED as a bias artifact (A0c with corrected fluc gives k <= 348,
weaker than the raw 195). Unchanged: S stream, zeta, kernels, Bunk/Ewin
envelopes, day074 slope (-3.006e-9), and the 0274 VERDICT (face OPEN,
validity + no exclusion). No RH claim.

**0275 COMPLETE (envelope sharpening without new data):**
1. A0 provenance: A0 = 3.4 is a DATA-LEVEL CLASS CONSTANT (3e10 band
   sup 2.48e9 / 3e9 band 2.615), NOT a theorem constant; Zeta23's local
   count is existential (witness 81.191752, #eval, not certified);
   Titchmarsh 9.2 is bare O(log t) (0275a).
2. HSXW 2022 (Hasanalizade-Shen-Wong, J. Number Theory 235:219-241)
   Cor 1.2/1.4: the FIRST published explicit two-sided R-vM/S bounds
   valid at all T >= e (analytic above T0 = 3.061e10, database below) ->
   applicable at tPT2/t3 WITHOUT local data. Per-unit at tPT2: count law
   30.707 (3.2x sharper than 3.4), S-route 13.724 (sharpest published);
   raw frontier window (tPT2-1, tPT2+1] **<= 22 zeros** (sigma-independent,
   PUBLISHED; 8.9x below the raw A0c 195; replaces the retracted 33 line);
   kernel S-route k <= 39 per sigma (gData cut); count-law HSXW k <= 104.
   The 0274 corrected record is simultaneously VALID under this pair
   (full S-route envelope 1106.18..1199.76 >= fluc 236.27..236.99, slack
   78-80%). Landed: formal/RhAttack/T4OffLN.lean (green) + T4OffLM
   rewritten Fifth (green).
3. t3 asymptotic cell (t3 = 1000*tPT2, day075b corrected): identity closure
   ALL FOUR (|fluc| <= B A0c with slack 19,588..20,905 = 98-99%),
   K(t3) = -154.69..-166.69 (face-flat at 1000x too), fluc(t3) =
   166.41..166.99, window counts growing in t (A0c k_max 458..503; raw
   HSXW two-unit <= 26). The old 'day075 closure FAIL' was the bias
   -1.0052e7; the corrected cell CLOSES (out_day075_cell_corrected_FINAL.txt;
   the first run OOM'd on 24-56GB in-RAM f64 loads; streamed 2^22-chunk
   reader fixed it).
4. 0275 VERDICT: window exclusion (E_win < fluc) requires a per-unit
   S-difference <= 2.5801 at sigA; the best published gives 6.46 (6.1x
   the requirement) and the gap GROWS in t: per-unit-law window exclusion
   is STRUCTURALLY INFEASIBLE at this face. The face at tPT2 and t3 is
   OPEN. Next unit 0276 = a genuinely new mechanism for S(t+1)-S(t) at
   face height (the per-unit family is exhausted); beside it route (a)
   fleet data past tPT2 (100-150 fleet-days) and the asymptotic map. No
   RH claim.

## 3quater. 0276: THE S-DIFFERENCE GATE (conditional exclusion certificate, 2026-11-04)

**0276 COMPLETE (entry 0276):** 0275's "structurally infeasible under
published input" is sharpened into the EXACT named input the next
mechanism must deliver, certified conditionally in Lean
(formal/RhAttack/T4OffLO.lean, all norm_num, 8736-job build green).

1. GATE (t = tPT2, gData cut). The S-route envelope is piece-linear in
   its per-piece S-diff constants (day078 e_win_s; 0274 kernel shape
   unchanged): E_win_S = c1*W1 + c2*W2 (W1 = 46.3914/46.4268/46.4521/
   46.4571, W2 = 55.9417/56.0125/56.0631/56.0730 sigma A/Q/F/N). W(t) is
   CERTIFIED EMPTY at sigma iff c1, c2 <= cGate(sigma) =
   (fluc+fedge)/(W1+W2). The gate (T4OffLM FIFTH-CORRECTION fluc/fedge):
       cGate(tPT2) = 2.5821 / 2.5805 / 2.5809 / 2.5847  (A/Q/F/N)
   recorded as rationals STRICTLY below the exact boundary (strict
   margin 3.4e-3..1.4e-2, theorems gateStrictA/Q/F/N).
2. PUBLISHED INPUT MISSES THE GATE 5.00x. c1 = c2 = 12.9117 at tPT2
   (HSXW Cor 1.4, two applications: Smax(t)+Smax(GLAST) = 6.862091 +
   6.049376); gateGap = E_win_S - (fluc+fedge) = 1,057.05/1,058.31/
   1,059.04/1,058.81 > 0 (window OPEN under the published law = the 0275
   verdict, now a named conditional input).
3. THE GATE STATEMENT. IF for every t >= tPT2 the unknown-side
   S-fluctuation obeys a per-piece S-diff c <= cGate (uniform in t,
   cGate = tPT2 values), THEN E_win_S(t) < fluc(t) + fedge(t) at every
   t and probed sigma -> W(t) = (t-1, t+1] carries NO face zero at any
   t >= tPT2 (all-t face window = countable union of cell statements,
   0269 reduction + T4OffLM.kUniform).
4. T-PROFILE (the gate TIGHTENS in t). cGate(A, tPT2) = 2.5821; cGate
   (A, t3) = 1.3445 (day075b/dag078: (166.685+35.9257)/150.688;
   cGate3tight certified); cGate(A, t4) ~ 0.95 expected (day079 cell,
   t4 = 1e6*tPT2, running: dual I_unk dps-60 AGREE rel 1.15e-23 all
   four; S stream n = 9,068,473,894 same +6 boundary-seam count).
   Structural basis: fluc t-FROZEN (day074 dK'/dt = -3.006e-9) vs
   E_win ~ (ln t)*(kernel ~ ln t). CAVEAT: three-point profile; monotone
   decay between points EXPECTED not proven - a face-wide use needs
   pointwise verification at suspect heights.
5. LITERATURE + ROUTES. Search 2026-11-04: NO published pointwise
   unit-scale S-diff below O(ln t) (Backlund-family |S(t)| pointwise,
   moment bounds at h ~ 1/ln t - neither reaches the gate); cGate is
   PAIR-CORRELATION-STRENGTH input (unproven). Fleet (a) (100-150
   fleet-days, Strix 32-core) pins k_L (on-line count (t-1, t], 0263
   census) but does NOT close the gate (the S-FLUCTUATION bound is
   unchanged by zero data) - fleet (a) stays for the count side. NEXT
   UNIT 0277 = the mechanism (research): prove c <= cGate uniform in t
   >= tPT2 (face-localized pair correlation of unknown zeros against the
   known-side S-stream, or a new face-kernel S-method). If 0277 fails,
   the 0275/0276 ceiling holds and the program returns to fleet (a).
6. VERDICT: the gate is the exact remaining input of the face;
   published misses it 5.00x at tPT2 (gaps growing in t); the face
   window and the face REMAIN OPEN. No RH claim. No zero-free claim.

## 4. Honesty boundary

- The endpoint is CONDITIONAL (three named external inputs + the terminal
  face). It stays conditional until the records exist.
- The 0244–0247 wire maps, T4OffLB/LC/LD anchors, and the 058e/day059
  measurements are OFF-BOARD POSITIVE-DUAL MARGIN RECORDS: machine-verified,
  exact, explicit — they characterize mechanism reach; they assert no zero
  non-existence and make NO RH claim.
- Everything in this plan is scoped work; nothing here is a claim about
  RH.

## 3quinquies. 0277/0278: the gate audit and the FIRST-MOMENT WALL (2026-11-04..10)

**0277 (entry 0277): the gate-closure audit — CLOSED.** Every
non-mechanism route to the 0276 gate audited and closed: published
(5.00x), class families (3.2-4.9x), in-machine continuous R-vM S-tail
(1.7e13, 10^12x), data wave (retracted as a gate route — it cannot
certify the S-bound itself), spacing-only (structural). Plus the
frontier window CENSUS (day080): (tPT2-1, tPT2+1] contains EXACTLY 8
on-line zeros (in-house RS-Z at tPT2, 80-bit, per-root mpmath-verified,
R-vM prediction 8.5599 consistent) — face-part window at most 14
(22 certified minus 8).

**0278 (entry 0278): the FIRST-MOMENT WALL — the mechanism scope is
CLOSED.** The 0276 gate sits BELOW THE FIRST MOMENT of the zero-count
kernel it bounds: E_win,1st(t) = dmain(t)·Wspan(t) = 421.59 (tPT2) /
786.18 (t3) / 14109.57 (t4) vs the requirement 306.62 / 202.62 / 250.50
(ratios 1.375 / 3.88 / 56.5 — the wall THICKENS in t); cGate < dmain at
every point (2.5821 < 4.1199 etc., ratio growing). No
configuration-independent S-route/kernel bound can reach the gate.
Certified: `formal/RhAttack/T4OffLP.lean` (10 strict norm_num theorems;
routeBTerminal; full tree 17,454 jobs, 0 errors). Empirical
confirmation (day081): the known-side per-unit zero count over [1e9,
3e9) has mean ~3.4 and MAX two-unit window count 9 — above the 2.58
gate in mean and max. The t4 cell (day079) landed its 4th profile
point (sigma_A: K = -192.7693 mpf-exact, fluc = +207.525, identity
closure, slack +30,371; sigma Q/F/N rows pending ~4-13h each).

**TERMINAL STATE OF ROUTE (b) (design doc section 8):** machine valid
at tPT2/t3/t4 (slacks 10,066..11,127 / 19,588..20,905 / 30,371); face
window (8 on-line + <= 14 face-part); gate named and formalized; wall
certified. The face remains OPEN; NO RH CLAIM. Next unit 0279 = the
final record compilation (preprint-grade endpoint of the program).
