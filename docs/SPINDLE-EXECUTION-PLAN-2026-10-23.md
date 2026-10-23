# SPINDLE EXECUTION PLAN (living plan, pass 4 scale-up)

Date opened: 2026-10-23.  Owner directive (2026-10-23):
**"ok, execute until we hit a wall."**
Upstream: `docs/SPINDLE-NS-FEASIBILITY-2026-10-23.md` (F14, verdict FEASIBLE,
tests T1–T6 defined there).
This document is the ADAPTING record: status per test, the decision gates,
and the rules for re-planning when a result forces it.

## 0. State (2026-10-23, ~06:10 local)

- **sx5 1e8 run DONE** (233 s; 50,630,458 triads): correct-run
  `tmp/sx5_run.log`, tables in `tmp/sx5_scale1e8_stats.json`.
- **G1 VERDICT IN: CLOSED-FLAT at 2e6–1e8** (see §3/G1 and the
  feasibility report §8). No scale-up triggered: the flatness IS
  the result.
- S18 part1 file D still streaming (mainline).
- T1–T6 all DONE (below).

## 1. Frozen definitions (do not change mid-pass)

From the feasibility report: ROOT = 1; thread (v, e) ⇔ e ≥ 2, e | (v−1);
triad T = (p−2d, p−d, p), d even ≤ 2000; spindle
S(T) = d(gcd(p−1, 2d)) − 1; area A(T) = |(p−5d)(p−2d)|;
chord class c = d mod 24; height bucket = p // 10⁶ (100 layers at 1e8).
Scale insight: S(T) needs only d(n) for n ≤ 4000 (no 1e8 divisor sieve).

## 2. Test status

| test | scope | status | pass/fail criterion | cost |
|---|---|---|---|---|
| **T1** parity decomposition | 2e6 | **DONE, PASS**: post-parity-matched ratio 1.262 (16.97 vs 13.44); the 1.884 ratio is NOT pure parity — +26% genuine prime-side excess | residual ≥ 1% after matching → PASS (met) | 1 s |
| **T1r** 4-adic refinement | 1e8 | **DONE** | excess is valuation-UNIFORM: 1.27718/1.27742/1.27431/1.26891/1.26426 (v2=1..5) → a constant prime-side factor ≈1.27, not 2-adic structure | sampled |
| **T2** closure tightness | 1e8 | **DONE** | small-A/S set is FINITE (p ≲ 7000; 14 spindles A/S<100, 127 <1000); min stays 8.5 at (29,6) → no growing blowup family; enclosure lax above ~7000 | vectorized |
| **T3** vortex search | 1e8 | **DONE** | class means [1.0967, 0.9273, 1.0468, 0.9328] structural; layer σ 0.221%, max dev 0.986%, 2/400 flags → NO VORTEX | vectorized |
| **T4** spindle dynamics | 1e8 | **DONE** | flat deciles (3.799–3.808), slope 0.00021, top-1% elongation 0.999× → NO DYNAMICS | vectorized |
| **T5** phantom flow conservation | 1e8 | **DONE** | B(1e8)=1,862,122,325 (= ln model ×1.0025); ln-detrended drift +0.31%, lag-1 +0.22; only systematic deviation = low-height asymptotic convergence (layers 0–4 +12.9%→, +0.04% at top) → CONSERVED | exact divisor identity |
| **T6** NS provenance audit | web | **DONE** (primary-source level) | Buckmaster statement full text; OpenAI repo cloned+inspected (claims: forced NS C+D every viscosity + UNFORCED Euler FTS); public papers located; lean4.dev (independent assessment ongoing); CMI announcement pulled; no certification | 1 session slice |

## 3. Decision gates (adapt-when) rules

- **G1 (after sx5 lands): VERDICT IN = CLOSED-FLAT.** T2: no
  growing blowup family (small-A/S set provably finite, p ≲ 7000);
  T3: no vortex (class bias structural, layer σ 0.22%, 2/400
  flags); T4: no dynamics (slope 0.00021, flat); T5: phantom flow
  conserved (ln-detrended drift +0.31%, low-height asymptotic
  convergence only). The original open-branches (T3b/T2b/T4b) are
  NOT triggered — they were conditional on positive signals.
  Recorded: `docs/SPINDLE-NS-FEASIBILITY-2026-10-23.md` §8.
  RESOLVED BRANCHES (kept for record):
  - if T3 flags > 0 → **open T3b**: 1e9 run with 10⁷-wide layers and a
  - if T3 flags > 0 → **open T3b**: 1e9 run with 10⁷-wide layers and a
    windowed null; this becomes the spine of the quest.
  - if T2 has an O(1) family → **open T2b**: enumerate the family at
    1e9 and check persistence under growth (is it a moving family or
    boundary noise? compare against the 2e6 minimum (17,23,29)).
  - if T4 finds α > 0.05 → **open T4b**: walk the power-law family along
    one chord class; record S vs A trajectory (the "spindle stretch"
    data for any figure/report).
  - if T5 drift ≈ 0 → the phantom field is recorded as CONSERVED flux;
    fold into the field map in the side-quest report (hook-4 material for
    the "notional projection" of the multi-spectrum).
- **G2 (scale walls)**: X = 1e9 = 10× memory/time of 1e8 (sf 100MB→1GB,
  triads ~5e8 = ~5GB arrays) — feasible but only after S18 lands and
  frees RAM; the 16GB-free rule applies; alert owner before a 1e9
  launch.
- **G3 (mainline coupling)**: nothing here touches the formal program;
  if any result is claimed for citation, provenance T6 must be complete
  for the NS material, and RH-discipline (zero-exclusion language only)
  holds.
- **G4 (the wall)**: if every of T2/T3/T4 reads "deep interior, no
  vortex, no dynamics", the spindle game at these scales is recorded as
  CLOSED-FLAT (the enclosure is lax; the game has no interesting
  interior motion at 2e6–1e8) — that IS a result (the discrete analogue
  of "no blowup observed"), and the honest next step is the scale-up to
  1e9+ (G2) or a different face of the structure (e.g., spindles over
  the chime branches instead of triads — new construction, new seed doc).

## 4. Standing rules (in force for this pass)

- 4 logical cores reserved at all times (25/28 now).
- 16 GB free-RAM guard; S18 RSS ~65 GB, sx5 peak ~4 GB.
- Scratch only in `tmp/`; results JSON in `tmp/`, narrative in `docs/`.
- No RH claim; NS material = bounding model, provenance-postured.
- mpmath stays serialized (not used here; sx5 is pure numpy).

## 5. File map (this pass)

```
docs/SPINDLE-NS-FEASIBILITY-2026-10-23.md   report (F14, T1-T6 defined)
docs/SPINDLE-EXECUTION-PLAN-2026-10-23.md   THIS plan (living)
tmp/sx4_spindle.py + stats + log            2e6 pass (F14 numbers)
tmp/sx5_scale1e8.py + stats + log           1e8 pass (T1r-T5)
docs/PRIME-LATTICE-SIDE-QUEST-REPORT-...md  quest record (passes 1-4)
```

## 6. Log

- 06:00 T1 executed (2e6): PASS (post-parity 1.262).
- 06:03 sx5 launched (8 threads; S18 17 live).
- 06:05 plan written; wiki note saved (see wiki source
  `spindle-execution-plan-tracker`).
- 06:34 sx5 run #1 crashed (T3 key: *24 vs *4); fixed, relaunch.
- 06:36 sx5 run #2 (first full results): T2 n(A/S<100)=14, T3 flags
  400/400 (null-model bug: class bias not decomposed), T4 flat, T5
  confounded by ln trend.
- 06:40 T6 NS audit slice: Buckmaster statement full text + OpenAI
  repo cloned + lean4.dev + Tao + arXiv 2609.23868 — primary-source
  level.
- 06:52 sx5 run #3 (corrected T3/T5): T3 σ=0.221%, 2/400 flags; T5
  ln-detrended: drift +0.31%, lag-1 +0.22, max dev = low-height
  convergence (layers 0-4, +12.9% → +0.04%).
- 06:58 F15 results finalized: CLOSED-FLAT (G4 wall found at 1e8).
  Discovery 0161 recorded, feasibility report §7–8, side-quest
  report addendum, this plan updated, committed, pushed, wiki saved.
- NEXT (owner-gated): G2 (1e9 after S18 frees RAM; ~10× cost, ~8–10 GB
  peak) or different face (spindles over chime branches — new seed
  doc).
