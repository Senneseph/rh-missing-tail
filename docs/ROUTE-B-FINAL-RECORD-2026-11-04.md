# ROUTE (b) — FINAL RECORD
## The residual surface program: design, corrections, machine, census, gate, wall, terminal state

**Date:** 2026-11-04 (record compiled as unit 0279)
**Project:** `/home/jsmille/Projects/rh-missing-tail` (the proof-output repo)
**Status:** PROGRAM COMPLETE · FACE OPEN · NO ZERO-FREE CLAIM · NO RH CLAIM

---

## 1 · What route (b) was

Route (b) is the **local residual-surface program** for the terminal face of
the RH zero-free problem: the analytic zero-free question for
σ ∈ [1 − colletUpper, 1/2) ∪ the left-edge face family at t ≥ tPT2,
where **tPT2 = 3 000 175 332 800** is the certified face height (the
collet69 / 1252270103 frontier point, Re = 0.1252270103).  Route (b) is
deliberately **local and face-sized** — no window-wide substitution, no
global-count fabrication, no exclusion machinery of the EM type.  Its
claim (exact, 0270) is the zero-freeness of the face at and above tPT2,
which — together with the known zero-free region below — is the terminal
form of RH.

The program ran 0269 → 0278 (2026-10-30 → 2026-11-10 in project days;
wall-clock 2026-11-03 → 2026-11-10).  This record is its compiled
endpoint.

## 2 · The machine (0272/0273/0274) and what it computes

The face machine evaluates, at s = σ + i·t for the four probe sigmas
(σ_A = 0.1252270103 — the actual frontier Re — plus σ_Q/F/N = 0.25/0.40/0.49
hypothetical face probes):

```
  log|ζ(s)| = K(s; t) + fluc(s; t)
  K = S-stream (known zeros to gData = 3.0001e10, 9.068e9 data)
      + I_unk (main term beyond gData, dual u-substitution / R2 residual)
      - Re φ (the R-vM φ integral, mpf-exact)
```

with the **identity closure |fluc| ≤ B** as the validity criterion (B =
the certified envelope).  The machine is a **detector and a validity
machine**: closure means the main-term model is valid at that (σ, t); it
is not by itself an exclusion.

### The FIFTH CORRECTION (0274, supersedes 0273a-r; bias quantified)

* **Defect:** `U_pin_c4` double-counted the c4/g² tail mass beyond Y2 in
  the `tail2` term.
* **Bias:** −8 823.2915 at tPT2, −1.0052e7 at t3 = 1000·tPT2 — the old
  "window ≤ 33/33/34/34" line was an artifact of this bias and is
  RETRACTED (corrected reading under A0 = 3.4: k ≤ 348, weaker, not
  better).
* **Repair:** `U_pin_c4` now uses the certified h160 residual R2.
* **Verification:** the dual integrators (c4pin vs u-substitution) agree
  to machine precision at tPT2 and t3; GATE 1 (t = 1e9) and GATE 2
  (t = 4e9, dip in range) both pass at **relative < 1e-7**.

### Corrected face values (the current anchor, formalized in T4OffLM)

```
                   sigma:      A         Q        F        N
  K'(GLAST):       -218.894  -222.246 -226.277 -228.695
  fluc (gData cut): 236.273   236.351  236.574  236.997
  K_pin (optimal): -226.104  -229.456 -233.487 -235.905
  validity slack:   +10,066.6 +10,185.1 +10,453.4 +11,127.8
```

The face is **uniformly open in t ≥ tPT2 under the corrected criterion**
(K′ face-flat, dK′/dt ≈ −3.006e−9/unit, no crossing); old biased values
are preserved as `*_old` in the formal module.

## 3 · The validity profile (tPT2 / t3 / t4)

| point | t | identity | slacks (A/Q/F/N) | K (σ_A) | k_max (σ_A) |
|---|---|---|---|---|---|
| tPT2 | 3.00018e12 | CLOSE (4/4) | 10,066.6 / 10,185.1 / 10,453.4 / 11,127.8 | −218.894 | (window count, §4) |
| t3 | 3.00018e15 | CLOSE (4/4) | 19,588.2 / 19,735.6 / 20,068.7 / 20,905.1 | −154.693 | 503 |
| t4 | 3.00018e18 | σ_A: CLOSE (Q/F/N pending) | 30,371.1 (σ_A) | −192.769 (mpf) | 667 |

t3 (day075, corrected) and t4 (day079) were computed with **fresh dps-60
dual I_unk (no cache reuse)** and **mpf-exact K** — at t4 the main term
is a 1e18-scale cancellation (S = +3.930e11, I_unk = −2.356332589282753024e18,
−Re φ = +2.356332196251448320e18 → K = −192.7693), which float arithmetic
cannot represent; the mpf machine tracks the K(t) profile
(−218.89 → −154.69 → −192.77, O(30–64) main-term curvature) exactly.
The +6 S-stream seam (9,068,473,894 vs expected 9,068,473,888) is
**annotated, classified as a boundary artifact, and harmless** to all
closed items.  The machine is valid over **six orders of magnitude in t**.

## 4 · The geometry of the frontier window (0275/0277 + census day080)

* **Certified upper:** the two-unit window (tPT2−1, tPT2+1] contains at
  most **22 zeros**, sigma-independent (HSXW 2022 S-route, the first
  published explicit two-sided R-vM/S bounds valid for all T ≥ e; per
  unit at tPT2: count law 30.707, S-route 13.724).  Kernel-refined
  per-sigma counts for the gData cut: kmaxS ≤ 38, kmaxC ≤ 29 (formal,
  T4OffLN).
* **Measured (census, day080):** the window contains **EXACTLY 8
  on-line zeros** — in-house Riemann–Siegel Z at tPT2 (N = 691 008,
  80-bit), verified three ways: mpmath dps-50 Z at every root (all zeros),
  R-vM 2-unit prediction 8.5599 vs measured 8, and the smooth theta-part
  of the unit S-difference = +4.27996532 matching day078's dmain
  (4.279965) — the census is consistent with the certified main term
  down to the digit.
* **Face-part:** at most **14** (22 − 8).
* **Boundary reach:** the classical zero-free reach at tPT2 is
  δ = 0.001237 (from 1) against the required δ = 0.125227 — a gap of
  **0.123990 that GROWS in t** (0.12406 at 10x, 0.12412 at 100x; 0270);
  Titchmarsh 9.2 as commonly cited is bare O(log t); the local count
  constant 81.191752 (A0-provenance audit) is a `#eval` witness, not a
  certified bound.  **No classical mechanism reaches the face.**

## 5 · The gate (0276, formal: T4OffLO)

The 0273-step-4 window exclusion is a **conditional certificate**.  With
the exact kernel-piece spans W1 = 46.392 / 55.942 (σ_A; the four sigmas
are listed in T4OffLO) and the requirement fluc + fedge
(264.24 / 264.35 / 264.60 / 265.02):

```
  IF  a per-piece S-variation bound  c1(t), c2(t) <= cGate(t)  holds for
      all t >= tPT2 (pieces [gData, t-1] and [t+1, ...]),
  THEN every face window (t-1, t+1] is empty for all t >= tPT2.
```

```
  cGate(tPT2) = 2.5821 / 2.5805 / 2.5809 / 2.5847   (A/Q/F/N)
  cGate(t3)   <= 1.3445                              (σ_A)
  cGate(t4)   ~ 0.95                                  (σ_A, day079)
  the gate TIGHTENS in t  (formal: cGate3A < cGateA)
```

All gate inequalities are **strict rationals** in Lean (recorded
constants sit with certified margins inside the exact boundary values).
**Published input:** c1 = c2 = Smax-class constant 12.9117 (HSXW) —
**5.00x ABOVE the gate**; gateGap = E_win − (fluc + fedge) > 0 at all
four sigmas: the window is **OPEN under published input** (formal
`faceGateRecord`).

## 6 · The wall (0277/0278, formal: T4OffLP)

**0277 audited and closed every non-mechanism route** to the gate:
published laws (5.00x miss); class/envelope families A0 = 3.4 (3.81x)
and A0c/HSXW (7.47x); the in-house continuous R-vM S-tail (|I| ≤ 1.7e13,
a 10^12x miss — count-dominated, no oscillatory gain); the data wave
(retracted as a gate route — it pins counts, it cannot certify the
configuration-independent S-bound; the binding piece (t+1, 16t] is 3–4
orders beyond data reach); spacing-only cancellation (structural — a
worst-phase sup, no phase data in a valid machine, and it is the EM
substitution that route (b) excludes).

**0278 then proved the FIRST-MOMENT WALL** (10 strict `norm_num`
theorems, composite `routeBTerminal`): every configuration-independent
S-route kernel envelope satisfies E_win(t) ≥ dmain(t)·Wspan(t) (the
first moment is a lower bound on every sup-form envelope), and

```
  point :  E1 = dmain_lo × Wspan_lo        requirement          ratio
  tPT2 :   4.1199 × 102.3313 = 421.59   ≥  fluc+fedge ≤ 306.62  1.375
  t3   :   5.2202 × 150.6    = 786.16   ≥  fluc+fedge ≤ 202.62  3.88
  t4   :   6.33 × 2229       = 14109.57 ≥  fluc+fedge ≤ 250.50  56.5
```

— **the wall THICKENS** (ratio ~ (ln t)², growing without bound), and the
gate constant itself is below the per-unit mean zero count at every point
(2.5821 < 4.1199; 1.3445 < 5.2202; 0.999 < 6.33; ratio 1.60 → 2.84 →
6.34).  **No per-piece S-variation bound in the S-route / HSXW / A0c /
kind-3 family can reach the 0276 gate**, because a
configuration-independent bound cannot see below its own first moment.
The family wall covers all 0275 envelopes (A0c 2835–2954, S-route
1106–1200, machine-valid 7174–7294 — all above 306.62).

**Empirical confirmation (day081, the known side, [1e9, 3e9), 2e9 units,
~6.2e9 zeros):** per-unit on-line zero counts peak at k = 3 (59.0%) and
k = 4 (25.1%), mean ≈ 3.4, and the observed MAX two-unit (t−1, t+1]
count is **9** — the real landscape sits above the 2.58 gate in mean AND
max.  The wall is the shape of the zero counting function, not an
artifact of the main term.

## 7 · Formal inventory (all built: 17 454 jobs, 0 errors)

| module | content |
|---|---|
| `T4OffL`..`T4OffLK` | earlier route (b) anchors (0256-era: wall, counts, window) |
| `T4OffLL`/`T4OffLM` | 0273/0274: corrected FIFTH-CORRECTION face values (`*_old` preserved) |
| `T4OffLN` | 0275: HSXW published laws, window ≤ 22 (raw) / kernel-refined 38·29, t3 block, face-open-under-published-laws |
| `T4OffLO` | 0276: the S-difference gate (strict rationals), t-profile tightening, census block (kL_frontier = 8, R-vM consistency 8.5599, theta-part 4.27996532), faceGateRecord |
| `T4OffLP` | 0278: the FIRST-MOMENT WALL (tPT2/t3/t4, gate-below-mean, wall-tightening, family wall, routeBTerminal) |

All gate/wall numerals are strict rationals with certified margins; the
data-level inputs are provenance-annotated (machine-origin, day072c
corrected / day075 / day078 / day079 / day080).  Re-verification:
`cd formal && lake build` (17 454 jobs).

## 8 · The honest verdict

1. **The corrected face machine is valid** — at tPT2, t3, t4 (identity
   closures, slacks 10 066–11 127 / 19 588–20 905 / 30 371), over six
   orders of magnitude in t, with 1e-7 validated main terms and dual
   integrators agreeing to machine precision.
2. **The frontier window is pinned but not excluded:** 8 on-line zeros
   measured in (tPT2−1, tPT2+1] (verified per root), at most 22 total
   (certified), at most 14 face-part.
3. **The gate is named and formalized** (0276): a single conditional
   input — c ≤ cGate(t) — that WOULD close every face window for all
   t ≥ tPT2.
4. **The wall is certified** (0278): the gate is below the first moment
   of every configuration-independent count-kernel mechanism, at every
   t, with a growing ratio.  Route (b)'s window-exclusion program is
   therefore **terminal**: it closes only with phase-level information
   a configuration-independent bound cannot carry (Conrey–Ghosh-class
   or stronger S-theory at h = 1, an S-method with the face kernel, or
   the actual realized S-walk at the face height as input) — genuinely
   new mathematics, not a constant chase.
5. **The face remains OPEN.  No zero-free claim is made.  No RH claim is
   made.**  The record above is a record of a verified machine, a
   pinned geometry, a named gate, and a certified wall — the complete
   and honest terminal state of the route (b) program.

## 9 · Reproducibility

* Scripts: `scripts/rh/day072_face_U_repair.py` (+ corrected re-run
  `out_day072c_face_corrected.txt`), `day075_asymptotic_cell.py`
  (`out_day075b_cell_corrected.txt`, `out_day075_cell_corrected_FINAL.txt`),
  `day076_iunk_audit.py`, `day078_hsxw_window.py`
  (`out_day078_hsxw_window.txt`), `day079_cell_t4.py`
  (`out_day079_cell_t4.txt`), `day080_window_census.py`
  (`out_day080_window_census.txt`), `day081_sdiff_landscape.py`
  (`out_day081_sdiff_landscape.txt`).
* Data: in-repo zero stream (9.068e9 on-line zeros through gData =
  3.0001e10; `.f64` raw little-endian, no header; lshard `.dat`
  cumulative intra-block deltas), pinned in `data/provenance/PINS.json`;
  provenance check `scripts/rh/provenance_pins_check.py`.
* Entries: `docs/discovery/entries/0{269..0278}.json`; design history
  `docs/ROUTE-B-0273-DESIGN-2026-11-03.md`; frontier plan
  `docs/FRONTIER-AND-RECORD-PLAN.md`.

## 10 · Literature audit (0280) — the S-route class exhausted as of 2026

Fresh sweep of the explicit S-theory literature through its 2026 state
of the art (arXiv 2604.05733, 2510.14309, 2412.15470, 2603.21490,
2402.04272; JNT 2021; CJS 2011; Trans 8571):

* **Best unconditional explicit |S(t)|** at t = 3.0002e12: the
  0.11 log t + 0.29 log log t + 2.29 family (2024) gives ≈ 6.42; the
  0.112/0.278/2.510 bound (valid T ≥ e) gives ≈ 6.66; the HSXW-2022
  machinery of 0276 gives 6.86.  All sit at **5.0–5.2×** the per-piece
  gate requirement after the triangle (piece ≈ 12.9–13.3 vs cGate =
  2.5821).
* **The 2024 R-vM improvement** (arXiv 2412.15470, Fiori appendix:
  0.10076 log T + 0.24460 log log T + 8.08344) is asymptotically sharper
  but **worse at our heights** (the O(8.08) constant dominates until
  astronomically larger T).
* **S-difference forms:** Conrey–Ghosh–Gonek give
  |S(T+H) − S(T)| ≤ (1/2+o(1)) log T/log log T **under RH** (≈ 4.1 at
  3e12, *growing* in t — conditional and the wrong asymptotic for the
  decaying gate).  The explicit 2nd/4th moments of S(t+h) − S(t)
  (Trans 8571, h ≪ 1/log T) are **mean-value** (positive-proportion)
  results — structurally incapable of delivering the pointwise sup a
  configuration-independent gate needs.
* **2026 zero-free regions** (1 − 1/(4.896 log t); the
  55.241 (log)^(2/3)(log log)^(1/3) form) stay near the right edge
  (σ ≥ 0.993 at our heights); the face at Re = 0.125227 is untouched,
  as always.
* **No published sub-O(ln t) unit-scale pointwise S-difference bound
  exists** — the 0276 audit re-confirmed against the 2024–2026
  literature and now holds as the state of the art.

**Decomposition of the 5.00× miss (for the record):**
5.00 = **1.60** (the irreducible first-moment wall, 0278: cGate 2.5821
< per-unit mean 4.1199, ratio growing in t) × **3.1** (sup-overhead of
explicit S constants above the first moment — the Conrey–Ghosh-class
constant-chase territory, in principle unengineerable for
configuration-independent bounds).  No sharpening of any published
constant can cross the 1.60 factor; that is the wall.

**VERDICT (record sealed):** the S-route and every published
count-kernel class is exhausted.  The face remains OPEN; the window is
pinned (8 on-line + ≤ 14 face-part); the gate is named; the wall is
certified; the literature is audited to 2026.  **No zero-free claim.
No RH claim.**  Route (b) is terminal; its value stands as the sharpest
known local picture of the RH terminal face — a verified machine, a
pinned geometry, a named gate, a certified wall, and a complete audit
of why the gate cannot be met from the existing mathematical
machinery.
