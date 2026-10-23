# SPINDLE EXECUTION PLAN (living plan, pass 4 scale-up)

Date opened: 2026-10-23.  Owner directive (2026-10-23):
**"ok, execute until we hit a wall."**
Upstream: `docs/SPINDLE-NS-FEASIBILITY-2026-10-23.md` (F14, verdict FEASIBLE,
tests T1–T6 defined there).
This document is the ADAPTING record: status per test, the decision gates,
and the rules for re-planning when a result forces it.

## 0. State (2026-10-23, ~06:10 local)

- **sx5 scale run RUNNING** (PID 3953087, 8 threads, S18 17 threads live —
  25/28 cores, 4 reserved ✓): `tmp/sx5_scale1e8.py` →
  `tmp/sx5_scale1e8_stats.json`, log `tmp/sx5_run.log`. X = 1e8,
  ~53M expected triads, est. 5–15 min.
- S18 part1 file D still streaming (mainline, 17:27 elapsed).
- T1 (parities at 2e6) DONE in-session (below).

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
| **T1r** 4-adic refinement | 1e8 | in sx5 | per v2(p−1) class k=1..6: ratio ≈ 1.0 → excess is higher-2-adic structure; one class ≫ 1.0 → localized | sampled, ~1 min |
| **T2** closure tightness | 1e8 | in sx5 | O(1) subfamily (A/S < 100) persists (n > 0 and grows vs 2e6 baseline n=0 for A/S<100? at 2e6 min was 8.5 so n>0 existed) → blowup-witness candidates; min drifts up → deep interior | ~1 min |
| **T3** vortex search | 1e8 | in sx5 | any (layer, class) cell with C > 1+3.5σ under finite budget → discrete concentration signature; none → uniform skeleton survives at 1e8 | ~1 min |
| **T4** spindle dynamics | 1e8 | in sx5 | power-law S ~ A^α with small α (0 < α < 0.2) plus persistent top-S decile stretch → "spaghetti elongation" family; monotone-decay deciles + α ≈ 0 → no dynamics | ~1 min |
| **T5** phantom flow conservation | 1e8 | in sx5 | layer flux flat (|drift| < 1e-3/layer, lag-1 ≈ 0) → conservative (incompressible) phantom flow; systematic drift → a discrete source/viscous term (both outcomes characterize the field) | ~2 min |
| **T6** NS provenance audit | web | NOT STARTED (bounded) | fetch Buckmaster–Alpöge preprint + OpenAI writeup if reachable (Cloudflare-gated so far); record what is auditable vs wall; high for external citation, low for lattice work | 1 session slice |

## 3. Decision gates (adapt-when) rules

- **G1 (after sx5 lands)**: interpret T2–T5 as ONE story:
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
- (to be appended as tests land)
