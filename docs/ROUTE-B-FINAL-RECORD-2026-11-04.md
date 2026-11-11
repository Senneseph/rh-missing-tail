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
| t4 | 3.00018e18 | CLOSE (4/4, day079 LANDED — 0281) | 30,371.1 / 30,546.9 / 30,944.8 / 31,944.5 | −192.769 / −197.846 / −203.948 / −207.610 (mpf) | 667 / 661 / 647 / 615 |

t3 (day075, corrected) and t4 (day079, 0281: ALL FOUR SIGMAS LANDED)
were computed with **fresh dps-60 dual I_unk (no cache reuse)** and
**mpf-exact K** — at t4 the main term is a 1e18-scale cancellation
(S = +3.93031304475e11, I_unk = −2.356332589282753024e18, −Re φ =
+2.356332196251448320e18 → K = −192.7693 at σ_A), which float
arithmetic cannot represent; the mpf machine tracks the K(t) profile
(−218.89 → −154.69 → −192.77 per σ_A, O(30–64) main-term curvature)
exactly, and the t4 per-sigma K-profile (−192.769/−197.846/−203.948/
−207.610) has the same face-flat family shape as tPT2/t3 (formal
`kT4faceFlat`).  The +6 S-stream seam (9,068,473,894 vs expected
9,068,473,888) is **annotated, classified as a boundary artifact, and
harmless** to all closed items.  The machine is valid over **six
orders of magnitude in t, all sigmas, four profile points**.

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
  cGate(t4)   1.2578 / 1.2586 / 1.2615 / 1.2704 (A/Q/F/N, day079 LANDED;
                      0281: replaces the ~0.95 expectation — the gate
                      DECAYS then FLATTENS: 2.5821 -> 1.3445 -> 1.2578,
                      both fluc and span grow ~ ln t)
  the gate TIGHTENS in t  (formal: cGate3A < cGateA,
                            gateProfile_t4ltt3, gateProfile_t3lttPT2)
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
  point :  E1 = dmain_lo × span_lo          requirement (fluc+fedge)   ratio
  tPT2 :   4.1199 × 102.334  = 421.61    ≥   264.2433 (T4OffLM)    1.596
  t3   :   5.2202 × 150.688  = 786.62    ≥   202.6107 (0275)       3.882
  t4   :   6.33   × 199.04   = 1259.92   ≥   250.3585 (day079)     5.032
```

— **the wall THICKENS** (ratio monotone GROWING: 1.596 → 3.882 → 5.032:
dmain grows ~ ln t while the gate decays/flattens), and the gate constant
itself is below the per-unit mean zero count at every point (2.5821 <
4.1199; 1.3445 < 5.2202; 1.2578 < 6.33; ratio 1.60 → 3.88 → 5.03).  At
t4 the published per-piece bound c1 = 14.5046 sits **11.53×** above the
gate (vs 5.00× at tPT2): the published miss GROWS in t.  **No per-piece S-variation bound in the S-route / HSXW / A0c /
kind-3 family can reach the 0276 gate**, because a
configuration-independent bound cannot see below its own first moment.
The family wall covers all 0275 envelopes (A0c 2835–2954, S-route
1106–1200, machine-valid 7174–7294 — all above 264.24).

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

## 11 · 0281 — the t4 completion and the record's final corrections (book closed)

The day079 t4 cell landed with **all four sigmas closed** (0281):

```
  sigma |  K(t4)      |  fluc     |  B-fluc    |  E_win    |   fedge    |  kmax
  A .1252270103  -192.7693   +207.525   30,371.10   28,792.14   -42.8335   667
  Q .25           -197.8455   +207.415   30,546.91   28,807.50   -43.2383   661
  F .40           -203.9481   +207.157   30,944.80   28,818.49   -44.1546   647
  N .49           -207.6097   +206.659   31,944.53   28,820.63   -46.4572   615
  (S = +3.93031304475e11, I_unk = -2.356332589282753024e18, -Re phi =
   +2356332196251448320; fresh dual dps-60, agree, no t3 cache; K mpf-exact
   at the 1e18-scale cancellation)
```

The t4 point of the 0276 gate (day079, all sigmas): c*(t4) =
**1.2578 / 1.2586 / 1.2615 / 1.2704** (spans 199.04–199.24; E_win_S =
2887.03–2889.89); the published per-piece bound grows to c1(t4) =
14.5046 — **11.53× above the gate** (vs 5.00× at tPT2).  The gate
profile is now complete and measured: **2.5821 → 1.3445 → 1.2578**
(monotone decay, then flattening: fluc and span both grow ~ ln t).

**Corrections recorded (honesty, per project convention):** the 0278
draft (commits 37faca3/98b375a) carried (a) a tPT2 requirement of
306.62 (a wrong fedge, 70.34, instead of T4OffLM's fedgeA = 27.97) and
(b) a t4 wall point from an E_win/cPub normalization (span 2229) with
the ~0.95 expected gate.  The landed numerals correct both: tPT2
requirement **264.2433**; t4 span **199.04** / requirement **250.3585**
/ c*(t4) = **1.2578**.  The wall theorems were true under the draft
numerals and are **stronger** under the corrected ones (ratios
1.596 / 3.882 / 5.032 replace 1.375 / 3.88 / 56.5); the "growing ~
(ln t)²" phrasing is corrected to **monotone growth** (dmain grows ~
ln t while the gate decays/flattens).  T4OffLP was rewritten with the
self-consistent numerals and the formal t4 completion block
(`gateProfile_t4ltt3`, `gateProfile_t3lttPT2`, `kT4faceFlat`,
`t4Closures`, `pubMissGrowth`, 14-conjunct `routeBTerminal`);
T4OffLO's header now carries the landed t4 gate.  Full tree: 17,454
jobs, 0 errors.

**The book is closed.**  Route (b), 0269 → 0281: a verified machine
(valid at tPT2/t3/t4, all sigmas, four profile points, 1e-7 gates,
dual integrators at machine precision, mpf-exact K at the 1e18
cancellation); a pinned frontier window (8 on-line measured, ≤ 22
certified, ≤ 14 face-part); a named gate (0276, strict rationals;
profile complete 2.5821 → 1.3445 → 1.2578); a certified wall (0278/
0281, growing ratio, whole kernel family, empirical confirmation); a
complete audit of every mechanism class to the 2026 literature (0277/
0280).  The face remains **OPEN**.  No zero-free claim. **No RH
claim.**  This record is the complete, honest terminal state of the
route (b) program.

## 12 · 0282 — the Closing Theorem (the single remaining work item)

The program now reduces to one theorem (design doc §9, entry 0282):

**CT.** *A configuration-independent, sup-form, pointwise bound on the
unknown-side S-oscillation variation over the S-route pieces, valid for
**all** t ≥ tPT2, at or below the 0276 gate constants c*(t) =
2.5821 / 1.3445 / 1.2578 (tPT2 / t3 / t4 profile; T4OffLO strict
rationals). CT closes every face window for all t ≥ tPT2; with the
known zero-free region below tPT2, RH follows.*

The gap, exactly (0281's correction makes the true size visible): **a
37% reduction below the first moment** at tPT2 (ratio 1.596, growing
to 5.032 at t4) — the published-constant 5.00× decomposes as
1.596 (the wall: a sup bound cannot beat its own first moment) ×
3.13 (sup-overhead in the published constants).  No theorem of this
shape exists in a century of work: every S-result ever published
bounds the sup *above* the first moment; Conrey–Ghosh–Gonek's is the
best S-difference form at all but is RH-conditional (circular for
RH) and 1.65× above the gate even there.  CT-1…CT-4 are the next
moves (sharpest sup-to-wall bound from the 1e-7 R-vM machine; exact
pinning of the CG route's minimal new ingredient; a conformant-
subclass pair-correlation attempt at h = 1 where geometry — not all
configurations — might beat the mean; formalization once pinned).

The face remains **OPEN**.  **No RH claim.**  What remains of the
goal, stated plainly: *the proof of RH now requires a theorem (CT)
of strictly new strength — a below-first-moment, configuration-
independent, unit-scale S-variation result — whose existence and
proof are the open mathematical content of the next phase.*

### 12.1 · CT-2 pinning (exact, 0282 addendum)

The Conrey–Ghosh–Gonek S-difference result, pinned to its letter
(Bull. LMS 2006, arXiv/math/0511092, **Theorem 1; assuming RH**):
for t large and 0 < h ≤ √t,

      |S(t+h) − S(t)|  ≤  (1/2 + o(1)) · log t / log log t.

At tPT2 the leading term is **(1/2)·28.7283/3.35826 = 4.2694 S-units**
over *any* interval up to √t (the o(1) refinement is an explicit
constant computation, not a mechanism).  Consequences, exactly:

- **Under RH the gate is closed by a wide margin** (4.2694 total over
  the full 52-unit piece = 0.0816 per unit vs the gate 2.5821 per
  unit; even on the 2-unit window, 2.1347 < 2.5821) — as it must be,
  since the face is empty under RH.  The circularity is now
  quantified: the CGG route would need its bound **unconditionally**
  at strength ≤ 9.45 S-units piece-total (= 2.5821 × 102.334;
  requirement 264.24 fluc / 27.97 fluc per S-jump) — a factor **2.21
  sharper than the best bound that assumes RH**, versus a factor
  139.7 (per-unit 4.25, the 5.00× Smax normalization) sharper than
  the best unconditional (the 1321.29 Smax-triangle piece bound).
- **The unconditional moment machinery does not reach unit scale.**
  The explicit 2nd/4th moments of S(t+h) − S(t) (Trans,
  arXiv:2010.10675) are proved for **h ≪ 1/log t** (≈ 0.035 units at
  tPT2) and control mean squares, not the pointwise sup the 0276 gate
  needs.  Two gaps, not one (scale + moment-vs-sup).
- **The first moment, in S units:** the like-sign (1/π)-jumps of the
  unknown-side S-oscillation over the 52-unit piece have first moment
  **20.6 S-units**; the gate 9.45 sits **46% below it** (the S-unit
  twin of 0281's fluc-unit 37% — same wall, different normalization).

**CT, final form (0282 + pinning):** an unconditional, pointwise,
sup-form bound on the unknown-side S-difference over the S-route
pieces, ≤ 9.45 S-units piece-total (2.5821 per unit) at tPT2, with
the decaying/flattening gate profile 2.5821 → 1.3445 → 1.2578 (per
unit), for all t ≥ tPT2 — **2.21× stronger, unconditionally, than
the best bound known under RH**, and 46% below the first moment of
the like-sign jumps.  No such theorem exists.  This is the exact
measure of what remains of RH.  The face is **OPEN**; **no RH
claim**; no zero-free claim.

## 13 · 0283 — CT-3: the conformant-subclass route closes, and the REALIZED WALL

**CT-3 verdict (closed, T4OffLR).** The conformant-subclass attempt —
can the *subclass* of zero configurations satisfying every known law
(face-band mirror geometry at Re ≈ 0.125227/0.874773, density bounds,
R-vM 1e-7, |S| ≤ 6.46, window ≤ 22) beat the first moment? **No.**
Two certified reasons:

1. **The subclass contains the typical — and the realized —
   configurations.**  The measured tPT2 world is itself conformant
   (day081 landscape: mean 3.4 zeros/unit, max 9 per 2-unit window —
   typical counts, none of the known laws strained).  A sup-form
   bound cannot sit below its own first moment:
   E1 = 421.6058 S-units piece-total, ratio 1.596 at tPT2, growing
   3.882 / 5.032 at t3 / t4 (T4OffLP).  The new conformant
   constraints bind the **off-line** zeros (mirror partners,
   density-bounded) — which carry only the fedge·k machine
   signature; the **S-route is carried by the on-line unknown
   zeros**, whose first moment *is* the wall.  No h = 1
   pair-correlation result in the known literature can force a sup
   below the mean (the unconditional pair-correlation results are
   mean-value / positive-proportion, structurally).

2. **The REALIZED WALL (new, formal).**  The machine identity
   `fluc = K + fedge·k + S-route` with the measured fluc = 236.273255
   and the corrected K = −218.893831 (dps-60, GATE 1/2 at 1e-7)
   pins the S-route the machine **actually measured**:
   `S-route(k) = 455.167086 − 27.970831·k`, k = the true (unknown)
   face count in the window, 0 ≤ k ≤ 14.  Certified strict-rational
   floors (T4OffLR): k = 0 → 455.14 (**1.7225×** the gate 264.2366);
   k = 6 → 287.26 (**1.0871×** — still above); k = 7 → 259.28
   (below — the **escape reading**).  Under the typical readings
   k ≤ 6 (7 of 15 admissible), **the gate constant is below the
   S-route the real world exhibits**: any sup-form theorem at gate
   strength is *refuted by the data themselves* — and the only
   escape, the k ≥ 7 readings, is precisely the many-face-zero
   regime, far from the RH-typical picture.

**CT-2 unit corrigendum (0283):** the 0282 pinning's "9.45 S-units /
27.97" conversion, "20.6 over a 52-unit piece", and "61.9× under RH"
were unit errors (details in entry 0283; old values preserved).
All machine quantities are **already S-units** (1/π argument scale);
the requirement is **264.2433 S-units piece-total**; the first
moment is **421.6058 S-units piece-total**; CGG's 4.2694 bounds
*total S* at value scale (h ≤ √t) — a different object; under RH
the S-route *is* the zero count (first moment stands; the
circularity is vacuity); 37.3% below the first moment (0281) is the
true fraction.

**The final gap statement (units fixed):**  CT = an unconditional,
pointwise, sup-form bound, piece S-route ≤ **264.2433 S-units**
(2.5821 per kernel-mass unit) at tPT2, profile 2.5821 → 1.3445 →
1.2578, all t ≥ tPT2 — versus **published 1321.29 (5.00×), family
1106–1200 (4.19–4.54×), first moment 421.61 (1.596×, growing),
realized typical-face 287.26–455.14 (1.087–1.722×, T4OffLR)**.  The
subclasses are closed; what remains is a theorem **below its own
first moment, unconditional, in sup form** — a unit-scale
zero-density / pair-correlation result of strength that does not
exist in the literature through 2026.  Face **OPEN**; no zero-free
claim; **no RH claim**.  (T4OffLR built green; full tree 17,454
jobs, 0 errors.)

### 13.1 · CT-4 — the realized wall over the whole profile (DONE, T4OffLR)

At t3 and t4 the fedge signature is **negative** (−35.9257 /
−42.8335): the realized S-route **rises with k** (floor at k = 0,
no escape reading).  Certified floors, for **all** face counts:

```
  point :  S-route floor (k = 0)     gate product          ratio
  tPT2 :  455.14 (k* = 0) / 287.26 (k* = 6)   264.2366     1.7225 / 1.0871
                                                            (escape k* >= 7)
  t3   :  321.365  (166.685 + 154.68, fedge rising)  202.6000  1.5861
  t4   :  400.28   (207.52  + 192.76, fedge rising)  250.3565  1.5989
  mean :  421.6058 / 786.62 / 1259.92  (T4OffLP)       1.596 / 3.882 / 5.032
```

`ct4Profile` (formal): the gate is below the **realized** floor at
tPT2 (typical readings k ≤ 6), at t3 for all k, at t4 for all k —
and below the **mean** (first moment) at every point (T4OffLP,
growing).  The two certified lower bounds (mean, realized) now
bracket the gate from above at every profile point; the only escape
in the entire profile is the tPT2 face-count reading k ≥ 7 — a world
with 7+ face zeros in one 2-unit window, the far-from-RH regime.
`cGate4A := 12578/10000` (1.2578, day079 LANDED) now sits
canonically in T4OffLO.  Full tree 17,454 jobs, 0 errors.

**Where the program stands:** every mechanism class is closed
(published constants; kernel families; in-machine S-tail; data;
spacing-only; RH-conditional CGG; mean-value moments; conformant
subclass + realized), two certified walls (mean AND realized) sit
above the gate at every profile point, and the single remaining
theorem — **CT: an unconditional, pointwise, sup-form bound below
the first moment (1.596×, growing; below the realized typical-face
floors 1.087–1.722×), piece S-route ≤ 264.2433 S-units at tPT2,
profile 2.5821 → 1.3445 → 1.2578** — is a unit-scale
zero-density/pair-correlation result of strength that does not exist
in the literature through 2026.  That is the exact, measured remainder of RH.  The face remains OPEN; no zero-free claim; **no RH claim.**
## 14 · 0284 — CT-5: the uniform S-diff gate is structurally dead

The 0276 gate closes the face window W(t) **only if** its antecedent
holds for **every** t ≥ tPT2: per-piece S-diff
c1(t), c2(t) ≤ cGate, with cGate a **fixed finite** threshold
(2.5821 → 1.3445 → 1.2578, decaying).  CT-5 audits that uniform
form.  **It is impossible** — three certified layers (T4OffLS,
green):

**L1 — the measured envelope exceeds the gate at every t.**
The piece constant is c1 = Smax(t) + Smax(GLAST) (0274 g2
envelope; 0276 input 12.9117 = 6.862091 + 6.049376).  Its fixed
part, **Smax(GLAST) = 6.049376** — the measured S-maximum at the
data cut, independent of t — already exceeds the **strongest**
gate constant (6.049376 > 2.5847 = cGateN), and the profile decays
below it.  Violation **2.34× at tPT2, diverging** with the gate's
decay.  **Consequence:** the "5.00× miss" recorded in 0275–0280
was a misreading of where the obstruction sits — it is not an
asymptotic O(ln t) gap awaiting a sharper constant; it is a
**structural** violation (one fixed measured number alone exceeds
the whole gate), plus a strict 5× at published input level
(12.9117 > 5 × 2.5821, formal).

**L2 — the actual S-diff is unbounded in t (published).**
Unconditionally, S(t) = Ω±((ln t/ln ln t)^(1/3)) (Ramachandra;
Conrey's RH survey): |S| is unbounded on every tail.  With gData
fixed, the piece S-diff |S(t−1) − S(gData)| ≥ |S(t−1)| − |S(g)|
is unbounded in t: for every C there is t ≥ tPT2 with piece
S-diff ≥ C.  Any **valid** per-piece bound c1(t) dominates the
actual diff — hence unbounded — while the gate threshold is fixed
finite.  **The antecedent is false for every uniform finite
threshold, for every S-stream** (formal `gateAntecedentFalse`).
The gate is a one-way sufficient criterion, so it **cannot close
the face for all t ≥ tPT2**: arbitrarily large t exist where its
hypothesis fails.  This is a theorem **about the method**, not
about the face.

**L3 — the CT framing, corrected.**  "CT = a uniform all-t
S-diff theorem below the first moment" is not "needed future
mathematics of unknown existence" — it is **provably false**
(unbounded S vs fixed/decaying threshold).  A face exclusion, IF
TRUE, must come from a **non-gate** mechanism (t-adaptive, direct
zero-count machinery from the 1e15 census + R-vM, or a different
reduction); none is available in present mathematics through 2026.

**Terminal closure of the S-route avenue — three independent
walls:**

```
  wall        tPT2            t3              t4
  measured    1.087-1.722x    1.586x          1.599x    (0283, T4OffLR)
  mean        1.596x          3.882x          5.032x    (0281, T4OffLP, growing)
  STRUCTURAL  antecedent FALSE at all large t (T4OffLS, 0284)
```

The program-side (S-route) work is **terminally exhausted**: the
face remains **OPEN**, no zero-free claim, **no RH claim** — and
any future exclusion must arrive from outside the S-route
envelope, a domain where the known literature through 2026 gives
no mechanism below these walls.  Full tree 17,454 jobs, 0 errors.

## 15 · 0285 — zero-density audit: the pervasive face is refuted; the mechanism map is complete

The last canonical tool — the **zero-density machinery** — is now
audited.  Face zeros at Re = 0.1252270103 mirror (functional
equation) to Re = **0.8747729897**, so the face count up to T is
N(σₘ, T):

```
  bound                          exponent E = A(1-sigma_m)   @ tPT2
  Huxley  A = 3/(3sigma-1)       0.231283                   ~= 768   (BEST)
  Canfield-Huxley A = 20/9       0.278282
  Ingham      A = 12/5           0.300535
  all:  N(sigma_m, t) << t^{E+o(1)} = o(t)
```

**Consequences.**  (1) A face present in **every** window
(t−1, t+1] for all t ≥ tPT2 would need ≥ t/2 face zeros by height
t, but has only t^{0.2313+o(1)} — **the pervasive face is
REFUTED** (a new positive result of the program).  (2) A count
upper bound **cannot localize** — 768 face zeros up to tPT2 (log
factors aside) could all sit in one window; zero-density proves
**no window statement**.  (3) A **sparse** face (appearing in
o(1)-density of windows) is **consistent with every known bound**
— only a local mechanism excludes it; none exists through 2026.
  The Korobov–Vinogradov zero-free region reaches Re ≥ 0.9999988
at tPT2; the face at 0.874773 is deep in the unverified zone
(audited inapplicable).

**The mechanism map is now complete.**  Every known tool, audited
and closed:

```
  tool                              verdict
  S-route constants (0278/0280)     4.19-5.00x above the wall, capped by the first moment
  in-machine S-tail (0278/0281)     10^12x
  spacing-only (0277)               structurally impossible
  CGG under RH (0282)               1.653x at tPT2, growing
  pair-correlation moments (0282)   wrong scale and form
  conformant subclass (0283)        contains the typical AND realized configs
  realized data (0283/T4OffLR)      1.087-1.722x / 1.586x / 1.599x
  first-moment wall (0281/T4OffLP)  1.596 / 3.882 / 5.032, growing
  uniform S-diff gate (0284/T4OffLS) antecedent FALSE, all large t
  zero-density (0285)               pervasive face REFUTED; window exclusion impossible
```

**Terminal state.**  The face is **OPEN**; a *pervasive* face is
**refuted** (0285, new); any surviving face must be *sparse*;
no known mechanism excludes a sparse face; no zero-free claim;
**no RH claim**.  The program, working within known mathematics
through 2026, has exhausted every avenue by certificate.  The
remainder — sparse-face window exclusion — is a new-thesis
problem.  Full tree 17,454 jobs, 0 errors (T4OffLM…T4OffLS).

---

## 16 · 0286 — Reconciliation: the route-(b) face, the [S1]/A1 face,
and G-hs1 are ONE object (the record's terminal framing, corrected)

The route (b) book above closed at 0281 and extended through 0285 on a
terminal framing: *"the remainder is sparse-face window exclusion, a
new-thesis problem."*  That framing is **preserved in content but is now
identified more precisely**, because the program's live [S1]/A1 frontier
(`docs/S1-A1-EXPLORATION.md` E1–E19, `formal/RhAttack/A1Growth.lean`
§7–9 = 0207–0209) and the formal endpoint (`formal/RhAttack/RHEnd.lean`)
had continued in parallel and named the same object from two other
angles.  This section makes that identification explicit so the project
carries **one** coherent terminal state.

**The identity.**  Three names, one open problem:

```
  Route (b) "terminal face" / "0276 S-diff gate" /
          "sparse-face window exclusion"   (0269-0285)
      ==
  [S1]/A1 "absolute clause" / "the face"
          (A1Growth 0207-0209; face_unbounded)
      ==
  RHEnd G-hs1  (the S1 zero-side witness = the E1 content =
   the A1 walk bound, "whose uniform face is S1Uniform")
      ==
  the UNIFORM / ABSOLUTE S-at-zeros / DN-walk bound:
  one data-free K at every zero for every height.
```

Route (b) attacked it from the *gate* side and closed terminally (0284
antecedent false; 0285 pervasive-face refuted / sparse face not
excluded).  The [S1]/A1 line attacked it from the *wire* side and
proved the **growth / grid form** while filing the **absolute** form as
the open face.  RHEnd *names* it in the endpoint as **G-hs1**.

**What is PROVEN** (machine-verified; no RH claim):
the full skeleton (P12 `RH = S1∧S2∧S3∧S4`;  S2/S3 in body;  S4
strip+low+far), and the [S1] walk leg **at the data frontier** —
`a1_grid_clause_exhibit` (uniform `K = 6.6412` on the grid
`[4, 3e10]`) and `a1_zerofree_frontier` (`|S1Sum − RSum| < 16`), with
*exactly two* CITED classical inputs (Trudgian A1G-5 growth bound;  the
RvM residual `1/x`).  Data: no off-line pair `≤ 1e7` (2K even);  the
walk is tame to 3e10 (sup|DN| = 2.615067).

**What is OPEN** (the endpoint's named residual — `RHEnd`):
`G-hs1` (the absolute A1 walk bound — filed **OPEN / PROBABLY FALSE**:
no absolute C in the literature, the data-free bound is unbounded
(`face_unbounded`), the CCM RH-conditional bound grows, and the whole
CLT/distribution theory normalizes by the growing √(log log));  the
window zero-exclusion face (**route (b)**, terminally dead);  and
`G-hs3-left`.  Plus the **CITED classical inputs** ([Z78] Re s > 7/8
zero-free;  Trudgian;  RvM;  the 1.6 convexity mass).

**Corrected terminal statement.**  "Completing RH once and for all" =
a *complete reduction* (done, machine-verified) + closing the named
analytic faces — chief **G-hs1**, a new-thesis problem the field's own
distribution theory points toward being **false** (growth, not O(1)) —
+ discharging the CITED classical inputs.  The single most load-bearing
open object is **G-hs1 = the absolute A1 walk bound**.  Route (b) was
one (dead) approach to its window-exclusion facet.

NO RH CLAIM.  NO zero-free claim beyond the named faces and [Z78].

## 17 · 0287 — CONSOLIDATION: the PROVEN PARTIAL RESULT, named and
machine-verified (the owner-chosen option 1)

The owner chose, of the 0286 strategic fork, **option 1 — Consolidate**:
formalize *“no off-line zero pair up to the certified 3e10 data frontier
(plus the finite height the proven growth wire reaches)”* as a **named,
machine-verified RHEnd theorem**, conditional on the CITED `[Z78]` +
Trudgian `A1G-5` + the `3e10` census — and **keep all-heights RH as the
explicit open goal** (do not redefine success as the partial theorem).

**What was built** (`formal/RhAttack/RHEnd.lean`, section 0287, between
the `rh_program78` endpoint and Part C):

```text
theorem rh_no_offline_pair_to_growth_frontier
    (q : ZeroSet)
    (hZ78    : Z78.externalZeroFree78)            -- [Z78]  Re s > 7/8
    (hCensus : WinC.allOnLineUpTo q WinC.tPT)      -- [Z-PT] the 3e10 census
    (hGrowth : WinC.allOnLineUpTo q WinC.tPT2)     -- [Z-PT2] the growth-wire reaches
    (t0 d0 : ℝ) (ht0 : 0 ≤ t0) (htH : t0 ≤ WinC.tPT2) :
    ¬ offPair q t0 d0
```

with three named companions:  `rh_no_offline_pair_to_data_frontier`
(the 3e10 census stage alone),  `rh_growth_frontier_extends_data`
(`WinC.tPT < WinC.tPT2`, the *plus the finite heights* clause), and
`rh_growth_frontier_subsumes_data` (the growth frontier subsumes the
data census — what lets one statement at `tPT2` certify both stages).

**The frontier is two-stage.**  *Data stage*: the certified 3e10 data
census is `WinC.tPT = 30,610,046,000` (the record's own Platt 2017
rigorous zero-isolation frontier, where the public LMFDB zero stream —
the source of the project's own 24b series — ends; bit-pinned 0263).
*Growth-wire stage*: the proven growth wire — the *same* growth-form
explicit `S`-bound machinery the tree proves as
`A1Growth.a1_growth_wire`, CITED Trudgian `A1G-5` — reaches the
Platt–Trudgian verified frontier `WinC.tPT2 = 3,000,175,332,800`
(arXiv:2004.09765, “RH is true up to 3×10^12”).  The proof is
**two-stage and machine-verified**:  for `t0 ≤ tPT` the 3e10 census
`[Z-PT]` discharges; for `tPT < t0 ≤ tPT2` the growth frontier
`[Z-PT2]` discharges; both by the **LEAN-proven engine**
`WinC.noOffLineBelowPT` (no off-pair at *any* offset for `0 ≤ t0 ≤ H`,
conjugation folding the negative-height twin into the positive-height
frontier clause).  The finite statement needs no `[Z78]` arithmetic —
the frontier subsumes every offset, the far region included; `[Z78]` is
carried as a named premise because it is the endpoint's surrounding
 classical foundation (two cosmetic `hZ78`-unused linter warnings;
not errors).

**What is PROVEN** (finite-height, machine-verified; NO RH claim):
**no off-line zero pair** with `0 ≤ t0 ≤ 30,610,046,000` (the certified
3e10 data frontier, `[Z-PT]` alone) and with `0 ≤ t0 ≤
3,000,175,332,800` (the data frontier **plus** the finite growth-wire
extension, `[Z78]` + `[Z-PT]` + `[Z-PT2]`) — at every offset `d0`.
Full tree **green** (`lake build`, 17454 jobs, 0 errors).

**What is OPEN** (unchanged by this unit — the 0286 residual):
**ALL-HEIGHTS RH REMAINS THE EXPLICIT OPEN GOAL.**  The named analytic
faces are untouched — `G-hs1` (the absolute `A1` walk bound = “the
face”, **OPEN / PROBABLY FALSE**), the window zero-exclusion face
(route (b), terminally dead), and `G-hs3-left`; plus the **above-tPT2**
zero-exclusion faces.  The finite frontier `tPT2 = 3×10^12` is the
outer boundary of the machine-verified no-off-line-pair region; pushing
it higher is a *data/compute* task (a taller rigorous zero-isolation +
growth-wire verification), not an analytic barrier in the tree.  This
unit **names and machine-verifies** the proven partial result; it does
not close `G-hs1` and does not prove RH.

NO RH CLAIM.  NO zero-free claim beyond the cited frontier inputs.

## 18 · 0288 — THE EXACT RESIDUAL (the iff): all-heights RH = the
cited census + ONE named open object, the TERMINAL FACE

0287 pinned what is **PROVEN** (no off-line pair up to the growth
frontier `tPT2 = 3,000,175,332,800`, under `[Z78]` + the 3e10 census +
the growth wire).  This section pins, as a **pure-logic
machine-verified equivalence**, *exactly what remains* for all-heights
RH.

**The theorem** (`formal/RhAttack/RHEnd.lean`, section 0288):

```text
def terminalFace (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → tPT2 < ρ.im → ρ.re = 1 / 2

theorem rh_split_at_growth_frontier (q : ZeroSet) :
    RH q ↔ (allOnLineUpTo q tPT2) ∧ (terminalFace q)

theorem rh_iff_terminal_face (q : ZeroSet) (hCensus : allOnLineUpTo q tPT2) :
    RH q ↔ terminalFace q

theorem rh_of_terminal_face (q : ZeroSet)
    (hCensus : allOnLineUpTo q tPT2) (hFace : terminalFace q) : RH q
```

The iff is pure logic: `RH q` is `∀ ρ ∈ q.Z, ρ.re = 1/2`, and splitting
the universal quantifier at the frontier gives `allOnLineUpTo q tPT2`
(zeros at or below the frontier — the cited census) **and** `terminalFace`
(zeros with positive height above the frontier).  Conjugation
(`ZeroSet.conj`) sends a negative-height zero to its positive-height
twin without changing the Re-part, so the positive-height clauses cover
every zero.  (The `star` field facts resolve by `rfl`, being
definitional.)

**The content.**  Given the cited census — a **known, bit-pinned fact**
about the actual zero set (0263 / PINS.json) — **all-heights RH holds if
and only if the terminal face is empty.**  The terminal face is **one
single named open object**: *no off-line zero with positive height
above `3 × 10¹²`* — the heart of RH (the core critical strip
`0 < d0 ≤ 3/8` at heights the census does not reach).  The known part
(below the frontier) and the open part (the terminal face, above the
frontier) are now crisply and provably separated.

**What remains open (thesis-level).**  The terminal face is the single
object that *“completing RH once and for all”* reduces to, and it is a
new-thesis problem: every known mechanism through 2026 is exhausted —
route (b) terminally dead (0284 uniform S-diff gate antecedent false;
0285 pervasive face refuted / sparse face not excluded, no local
mechanism) — and the absolute A1 clause it is identified with is
**OPEN / PROBABLY FALSE** (`A1Growth.face_unbounded`: the data-free
growth `G` outruns every absolute `K`;  literature F1/F2: no absolute
`C`, the CCM RH-conditional bound grows, the distribution theory
normalizes by the growing `√(log log)`).

Full tree **green** (`lake build`, 17454 jobs, 0 errors).

NO RH CLAIM.  This unit states the *exact* reduction (machine-verified
iff); it does **not** close the terminal face — which is precisely what
remains.

## 19 · 0289 — OPTION B LAUNCHED: the direct attack on the terminal face
### (face identity, the W2-wire dead end, the reframe, and the face-menu)

**Context (owner selection, 2026-11-10).**  After the 0288 exact residual
(“*RH q* ↔ *the cited census* ∧ *terminalFace q*”), the owner chose
**option B**: a new long-shot research program attacking the terminal face
directly — not merely packaging the reduction (A) and not merely extending
the frontier (C).  This section records the **first unit** of that program.

### 19.1 · The FACE IDENTITY (machine-verified, both directions)

The terminal face is **the endpoint’s own object**.  Let the *unified38
face* be the `hOff38PT2` premise of
`RHEnd.rh_program78_stripfront_mach_unified38_PT2`:

> no off-pair at height `t0 ≥ tPT2` in the `[Z78]`-sharp strip interior
> `0 < d0 ≤ 3/8` (with `[Z78]` closing `d0 > 3/8`, since
> `Z78.offPairD0le` forces every off-pair into `d0 ≤ 3/8`).

Then, both implications are now LEAN-proven in `RHEnd` (section 0289):

- **`faceIdentity_z78_plus_unified38`**:  `[Z78]` + the unified38 face
  ⟹ `terminalFace`.  (An off-line positive-height zero above `tPT2`
  builds an off-pair `(t0 = ρ.im, d0 = |ρ.re − 1/2|)`;
  `Z78.offPairD0le` forces `d0 ≤ 3/8`; the face kills it.)
- **`faceIdentity_terminalFace_gives_unified38`**:  `terminalFace` + the
  census (for the boundary height exactly at `tPT2`) ⟹ the unified38 face
  (conjugation as in 0288; the `d0 ≤ 3/8` side condition is not even
  needed — the clauses cover every `d0`).

So 0286’s *“one object”* reconciliation is **a theorem in both
directions**: *the 0288 residual ≡ the endpoint’s unified38 face ≡ the
route-(b) face* (the route-(b) face zero sits **inside** the unified38
band: `d0 = 0.3747729897 < 0.375 = 3/8`).

### 19.2 · THE W2/A1 WIRE DEAD END (machine-verified)

The program’s **one in-tree mechanism reaching the face at unbounded
height** is the W2/A1 wire
(`W2B3.a1_universal_wire`, instantiated by the data-free ceiling
`A1G.G_explicit = 0.111·log T + 0.275·log log T + 2.45`, CITED
Trudgian A1G-5, via `RvM` with explicit residual).  Its far-side defect
bound is

> `|S1 − R| ≤ (G_explicit(frontier) + 1) · (17/8)`  (far side, `g1 ≥ 2t`).

**`A1G.a1_wire_no_uniform_defect_bound`** (with the new strengthening
**`A1G.face_unbounded_ge4`**: ∀K ∃T ≥ 4, K < G_explicit T) proves this
quantity has **no uniform all-heights form**: there is no `C` with
`(G_explicit g) + 1)·(17/8) ≤ C` for all `g ≥ 4`.  The wire closes at a
**fixed** data frontier (3e10: ≈ 14.9 < 16, `a1_zerofree_frontier`), but
its **all-heights closure would need exactly the uniform O(1) form the
theorem denies** — equivalently, the *absolute A1 clause* (one uniform
`K` over all zeros, unbounded height), which E19 F1/F2 filed
**OPEN / PROBABLY FALSE**.

> **THE W2 WIRE IS A FINITE-HEIGHT MACHINE.  IT CANNOT CLOSE THE FACE.**

### 19.3 · THE REFRAME (goal vs. method — corrects the truth-value
attribution)

The face (what “completing RH” reduces to, 0288) is **probably TRUE** — it
*is* RH above `3×10¹²`.  The absolute A1 clause is the **method’s
required input** and is **probably FALSE**.  0286/0288 conflated the two
as “one object, probably false”; 0289 keeps the object-identity (now a
theorem, §19.1) and corrects the attribution: **the face is the goal
(probable true); the wire’s input is the method (probable false), and the
method is proven incapable**.  This is a *reframe*, recorded per the
project’s honesty convention — not an overwrite; the 0286 reconciliation
and the 0288 exact residual stand.

### 19.4 · THE FACE-MENU (named sufficient conditions, 2026 audits)

| lane | statement (sufficient condition) | verdict (2026) |
|------|----------------------------------|----------------|
| **M1** 0276 gate | per-piece S-bound `< c*(t)` for all `t ≥ tPT2` | in-tree (`T4OffLO`); implication valid; mechanism audit **dead** (0277/0284) |
| **M2** θ=∞ | mollified 2nd moments bounded at arbitrary polynomial length | **ALIVE** named-conjecture lane: Ratios → θ=∞ → RH (Bettin-Gonek, Mathematika 63 (2017) 29–33, arXiv:1604.02740); active in 2026 (arXiv:2605.24363, automorphic L-functions); unconditional proportion record 2/3 (Conrey-Chandee-Farb-Young) |
| **M3** S-route | an absolute (uniform, non-growing) bound on `S` | **DEAD**: best unconditional upper `O(log t)` (Trudgian A1G-5 explicit; Ivić 0.1013·log T); under RH `C log t/log log t`, C > 0.372 (Soundararajan); true maximal order **grows** (B-S ω `√(log t·log log log t / log log t)`) |
| **M4** zero-free region | a region reaching `Re ≥ 1/2` above tPT2 | **DEAD**: Korobov-Vinogradov approaches `Re = 1`, never `1/2`; reaching `1/2` above tPT2 **is** the face (tautology) |
| **M5** frontier extension | a newly verified frontier `H' > 3e12` | **the only shrinking lane**: A1G-5 is uniform in height; 0287 engine `WinC.noOffLineBelowPT` machine-verified-shrinks the face to above `H'`. Finite per step; the limit `H'→∞` needs an M2/M3-type mechanism |

**Reading.**  M5 **shrinks** the face with machine-verified steps (the
concrete short-term program).  M2 is the **alive** named-conjecture lane
(the long-shot that, if the Levinson-type asymptotic extended to arbitrary
polynomial length, would close the face by a *different, non-wire*
mechanism — exactly what §19.2 says the wire cannot do).  M1/M3/M4 are
audited dead (0277/0284/0285 + §19.2 + 2026 SOP).

**Full tree green** (`lake build`, 17454 jobs, 0 errors;
`A1Growth` 8713; `RHEnd` 8764).

NO RH CLAIM.  0289 is an attack *launch*, not a closure: the terminal face
remains **open**; 0289 makes it the endpoint’s own object (both
directions), kills the in-tree wire mechanism at unbounded height
(theorem), and names the remaining lanes with 2026 literature verdicts.
The next unit is expected to be **M5** (a verified frontier extension
shrinking the face) and/or **M2** (the θ=∞ lane formalized in tree as a
named citable input).

## 20 · 0290 — THE θ = ∞ LANE, NAMED AND WIRED (option B, second unit)

**Primary source (re-pulled verbatim, 2026-11-11, ar5iv of
arXiv:1604.02740).**  Bettin-Gonek, “The θ = ∞ conjecture implies the
Riemann hypothesis”, Mathematika 63 (2017) 29-33:

- **The conjecture (Farmer)**.  Formula (1.2),
  `lim_{T→∞} I_{T^θ}(0,T)/T = 1 + 1/θ` — proven for
  `0 < θ < 1/2` (Levinson 1974 / Conrey 1989) — is conjectured to hold
  for **every θ > 0**; that is the “θ = ∞ conjecture”.  The objects:
  `I_N(T1,T2) = ∫_{T1}^{T2} |M_N(1/2+it)|² |ζ(1/2+it)|² dt` with the
  standard Levinson mollifier `M_N(s) = ∑_{n≤N} μ(n)/n^s · (1 −
  log n / log N)` and `N = T^θ`.
- **Theorem 1 (the implication that carries the lane)**, verbatim
  shape: for a **fixed** θ > 0, if `I_N(0,T) ≪_ε T^{1+ε}` for
  `2 ≤ N ≤ T^θ`, then ζ has **no zeros in Re s > 1/2 + 1/(2θ)**;
  “In particular, if … with θ arbitrarily large, then the Riemann
  hypothesis is true.”
- **2026 status: ALIVE and ACTIVE** — arXiv:2605.24363 extends the
  implication to cuspidal automorphic `L(GL_m)` (2026); the
  unconditional Levinson-type proportion record stands at **at least
  2/3** of the zeros on the line (Conrey-Chandee-Farb-Young).

### 20.1 · The formal module (DONE, `RhAttack.ThetaInf`)

New module `formal/RhAttack/ThetaInf.lean` (namespace `ThetaInf`;
build green, full tree green at 17454 jobs), wiring the lane to the
0288 terminal face in the project’s Z78 citation pattern:

- **Self-contained apparatus** (no cited analysis for the definitions):
  `thetaMoll` (Levinson mollifier, real length, total) and
  `thetaIMoment` (mollified second moment, the interval integral).
- **`thetaInfConjecture`** — the conjecture in its **exact** form
  (1.2): `∀ θ > 0, Tendsto (T ↦ I_{T^θ}(0,T)/T) atTop (𝓝 (1 + 1/θ))`.
- **`thetaBounded θ`** — Theorem 1’s antecedent, fixed θ (the
  `≪_ε T^{1+ε}` over `2 ≤ N ≤ T^θ`, range-uniform).
- **`bgThetaShrink θ`** — CITED: antecedent ⟹ zero-free in **both
  flanks** (`Re s > 1/2 + 1/(2θ)` is Theorem 1 verbatim; `Re s <
  1/2 − 1/(2θ)` is the classical functional-equation reflection
  `s ↦ 1 − conj s`).
- **`thetaInfImpliesAllOnLine`** — CITED (Farmer κ = 1 + Theorem 1
  particular case): the conjecture ⟹ every zeta zero on the line.

### 20.2 · The machine-verified wiring (the LEAN-proven part)

- **`terminalFace_of_thetaInf`** — [cited implication] + [cited
  conjecture input] ⟹ `terminalFace`.  **Lane M2 is wired: proving
  (1.2) for all θ closes the face.**
- **`terminalFace_of_bgShrink`** — for **any fixed θ > 0**, the cited
  antecedent + cited flank zero-free + the θ-face
  (`no off-pair at t0 ≥ tPT2 in 0 < d0 ≤ 1/(2θ)`) ⟹ `terminalFace`.
  **Each cited θ shrinks the face** from the `3/8` band to
  `d0 ≤ 1/(2θ)`; θ → ∞ collapses it to a point.  At **θ = 4** the
  flanks start at `Re > 5/8` / `Re < 3/8` — the route-(b) face zero
  (`Re = 0.1252`, `d0 = 0.37477 > 1/8`) sits in the left flank and is
  **excluded by the cited zero-free region** (consistent with 0285:
  its mirror `σ = 0.8748` is inside the flank).

### 20.3 · The research target, now precisely named

The analytic content of lane M2 is not vague: it is the single
statement **“extend the Levinson–Conrey asymptotic (1.2) beyond
θ = 1/2”** (frontier: Conrey-Chandee-Farb-Young).  Two honesty notes
are recorded in-module: (i) the antecedent of Theorem 1 in its
range-uniform `≪_ε` shape is **stronger** than the pointwise-in-θ
asymptotic, and the two are **not linked in-tree**; (ii) the cited
flank zero-free combines Theorem 1 (right flank, cited) with the
functional equation (left flank, classical).  **NO RH CLAIM** — the
conjecture is a conjecture; the face remains open without the cited
inputs.

## 21 · 0291 — THE M5 RE-ANCHOR: the certified frontier moves
### (and the 0290 proportion corrigendum)

### 21.1 · The new cited input (primary source, pulled 2026-11-11)

**P. W. Murphy**, “A certified window of zeros of the Riemann zeta
function just above 3e12, with a machine-checked Riemann–Siegel
remainder”, October 2026 (paper
`zenodo.org/records/23489697/files/ce1_window_paper.pdf`;
record `doi.org/10.5281/zenodo.23486195`; dataset
`doi.org/10.5281/zenodo.23486196`).  Theorem 1, verbatim numbers:
with `g_n` the n-th Gram point, `a = 12,363,153,437,130`,
`b = 12,363,153,457,130`:

- `g_a ∈ [3000175332798.574911824343 ± 1.60·10⁻¹³]`,
  `g_b ∈ [3000175337471.510047088127 ± 1.86·10⁻¹³]`;
- the `b − a = 20,000` zeros with `g_a < Im s ≤ g_b` are **all
  simple and on the line** `Re s = 1/2`.

Since `g_a` lies just **below** `H0 = 3,000,175,332,800` (exactly
`WinC.tPT2`) and the certificate independently reproduces
Platt–Trudgian’s count `12,363,153,437,138` at `H0`, the two results
together show every zero with `0 < Im ρ ≤ g_b` is on the line — the
verified region now extends **strictly above** the Platt–Trudgian
height.  Method (as described): 128-bit Arb ball arithmetic;
Riemann–Siegel + first correction with the remainder bounded by a
**Lean-4-kernel-checked theorem** (`RSInt.rs_Z_C0′`:
`(3/5)·t^(-3/4)`); Turing method with a Gram-block count meeting
Amberger’s correction (arXiv 2512.23064, unrefereed); positive and
negative controls (a hidden off-line pair is detected and
certification refused); Odlyzko calibration; the whole window
reproduced by independently written audit code; AI-assisted
(Claude, Anthropic) under the author’s direction — the source’s own
provenance note.

### 21.2 · The formal re-anchor (DONE, `RhAttack.CE1`)

New module (build green; full tree green 17454 jobs):

- **Constants** (certified, rationals):
  `gAHi = 3000175332798.57491182451` (upper bound for `g_a`),
  `gBLo = 3000175337471.51004708794` (lower bound for `g_b`), and the
  **new certified census frontier**
  **`tCE1 := 3,000,175,337,471`** (integer, strictly below `g_b`,
  machine-verified).
- **`ce1WindowAboveTPT2`** — the cited clause (Z78 pattern):
  every zeta zero with `tPT2 < Im ≤ tCE1` is on the line; the
  inclusion `(tPT2, tCE1] ⊂ (g_a, g_b]` is machine-verified
  (`gAHi_lt_tPT2`, `tCE1_lt_gBLo`).
- **`allOnLineUpToCE1`** — [Z-PT2] + [CE1] ⟹ the census holds up to
  `tCE1`.  **The frontier moved.**
- **`terminalFaceCE1`** — the re-anchored face (no off-line zero of
  positive height above `tCE1`); `faceShrinkExact`: the height domain
  shrank by **exactly 4671 units**.
- **`rh_split_at_CE1`** — the 0288 exact residual **RE-PINNED**:
  `RH q ↔ (census up to tCE1) ∧ terminalFaceCE1 q` (pure logic,
  conjugation as in 0288).
- **`terminalFaceCE1_iff_face0`** — under [CE1], the 0288 face and
  the re-anchored face are **equivalent**: the shrink is a
  certificate, not a logical move (honesty).
- **`rh_reanchored_CE1`** — headline: given [Z-PT2] + [CE1],
  **all-heights RH ⟺ `terminalFaceCE1`**.
- **`terminalFaceCE1_of_thetaInf`** — the 0290 M2 closing lands
  **directly** at the new frontier.

The extension is tiny (`~1.6·10⁻⁹` relative; the source itself says
it “says nothing about the Riemann hypothesis beyond the window”);
its value is that **lane M5 now works end-to-end on a fresh 2026
cited artifact** — every future window above `H0` re-anchors the
face by the same two-line machine composition.

### 21.3 · CORRIGENDUM to unit 0290 (proportion attribution)

0290 stated the unconditional proportion record as “at least 2/3 of
the zeros on the line (Conrey-Chandee-Farb-Young)”.  **Both parts are
wrong** (checked against the August-2026 FRONTIER_MAP from primary
sources and the Anthropic preprint’s own abstract):

- The **accepted** Levinson-lineage record (on-line, **with
  multiplicity**, `N₀/N`) is **κ ≥ 0.417293962** —
  Pratt–Robles–Zaharescu–Zeindler, Res. Math. Sci. 7 (2020),
  arXiv:1802.10521v3.  No Levinson-side improvement has been
  accepted since 2020.
- The “≥ 2/3” figure (**0.67250070367941164573**) is an
  **August-2026, not-yet-refereed** result counting **distinct /
  simple** on-line zeros (`N*₀`): the Anthropic (Claude) preprint
  “More than two thirds of the zeros of the Riemann zeta function
  lie on the critical line” (problem posed by J. Sumner), extended
  to 0.673008528 by Ainta (Sunghyeon Jo) via 7-point finite
  certificates, with an independent proof by Lamzouri.  It counts a
  formally different quantity and is “incomparable at the count
  level” with the Levinson lineage.  The CCFY attribution is
  **retracted**.
- History chain: Selberg 1942 (κ > 0) → Levinson 1974 (1/3) →
  Conrey 1989 (0.4088) → Bui–Conrey–Young 2011 (0.4105) → Feng 2012
  (0.4107) → Pratt–Robles 2018 (0.4128) → **PRZZ 2020
  (0.417293962)** → [2026 unrefereed: 0.6725… distinct counting].

**NO RH CLAIM.**  The face remains OPEN; the re-anchor is a
certificate, and the two face formulations are provably the same
open object.

## 22 · 0292 — THE 2026 MECHANISM SEAL (M2 target pinned; lane M6
### audited; the face-menu is now COMPLETE)

### 22.1 · M2’s research target: the θ = 1/2 barrier (primary sources)

The analytic content of lane M2 (0290) is the single statement
“extend the Levinson–Conrey asymptotic (1.2) beyond θ = 1/2”.  The
barrier is now pinned from the leading journal work itself:

- **Bettin–Gonek** (arXiv:1604.02740): (1.2)
  `lim I_{T^θ}(0,T)/T = 1 + 1/θ` is proven for `0 < θ < 1/2`
  (Levinson 1974 / Conrey 1989); the θ=∞ conjecture is its
  extension to every θ > 0.
- **PRZZ** (arXiv:1802.10521; Res. Math. Sci. 7 (2020)), §1.3:
  “Balasubramanian, Conrey and Heath-Brown … showed that one could
  push the size of the length θ **past the 1/2 barrier** to 9/17”
  (the **degree mechanism**: higher-degree test functions); §9(3):
  the generic-coefficient ceiling is `θ = 17/33 − ε` (“the best
  size one can take for coefficients aₙ about which we know
  nothing”); §9(4) (their open question): “analyze how a large
  truncation of ℓ could yield terms from a higher degree d ≥ 2.
  **What would be a good balance between the degree d and the
  truncation ℓ?**”
- **PRZZ on θ = ∞ itself** (§1.3, verbatim from the pull): “Bettin–
  Gonek proved that if one takes θ = ∞, then RH would follow (not
  just 100%). **Of course, we are very far away from such lengths
  of mollifiers.**”

The 1/2 barrier is **real and named**; the known escape mechanisms
(degree, coefficient-arithmetic, twists) are the active 2026
frontier; the leading work openly calls the θ=∞ gap “very far”.

### 22.2 · Lane M6 (new): the 2026 proportion-certificate family —
audited structurally blind

The August-2026 “≥ 2/3” generation (0291 §21.3) is not one result
but a family, all counted from **Gram-matrix / pair-correlation
certificate data**:

- **Alpöge–Furman (2026)**: unconditionally ≥ 2/3 of the zeros are
  **simple and on the line** (Gabor-frame Gram certificate with
  bandwidth `L = log(T/2π)`; the first public route was the
  August-2026 Anthropic preprint, problem of J. Sumner, with an
  independent proof by Lamzouri — the two attributions are kept
  as the two dated sources state them).
- **Ainta (Sunghyeon Jo, 2026)**: 0.673008528 (7-point finite
  certificates).
- **Clipped-Gram energies** (zenodo 23286387):
  `liminf N_ms0(T)/N(T) ≥ 66812491/99194876 =
  0.67354780502…` (simple on-line, **with multiplicity**) — the
  highest proportion constant found; the results stand as valid
  unconditional mathematics.
- (Also: arXiv:2610.26841 — unconditionally ≥ 13/20 of the zeros
  are `c`-isolated, hence simple and on the line; answers
  Gonek–Sahay.)

**The blind spot is now a theorem.**  “Off-line zeros of any depth
can be hidden from the two-thirds pair-correlation certificate”
(rStation paper 109, Nov 2026; “span_of_dilates” v2):

- **Theorem 1 (spectral twin)**: a lattice of *reflected off-line
  pairs* at spacing at most the frame step `2π/L` has **exactly
  the Gram matrix of on-line double zeros** at the same ordinates,
  **at every depth**, for every window supported in an interval of
  length `L` (id est: the certificate’s data cannot distinguish
  the off-line lattice from on-line doubles).
- **Corollary 3 (model)**: the certificate’s extremal
  configuration, with its doubles replaced by pair-chains, has per
  period trace `N` and squared Hilbert–Schmidt norm
  `(4/3 + o(1))N` while **a third of its zeros lie at depth ε, for
  every fixed ε ∈ (0, 1/2)**.
- **Corollary 4 (model)**: the data give no zero-density estimate
  beyond `N(σ) ≤ (1/6 + o(1))N` — i.e., **no information about
  off-line structure at all**.
- **Model caveat (recorded exactly)**: the chain corollaries are
  proved in the model (indicator window, untruncated frame,
  periodic configuration); the source states that restricting to
  `T < γ ≤ 2T`, truncating the frame and smoothing the window
  “change the data. We expect the change to be lower order, but we
  do not prove it.”

**Verdict.**  Like zero-density (0285) — which was compatible with
the sparse face by *sparseness* — the 2026 proportion-certificate
lane is compatible with the sparse face **by construction**: the
twin/chain configurations are certified-equivalent to on-line
configurations, at every depth.  The lane is **audited and closed
as a face-closer**; its proportion results stand.

### 22.3 · The face-menu, terminal state (M1–M6)

| Lane | Object | 2026 verdict |
|---|---|---|
| M1 | 0276 S-diff gate | **DEAD** — uniform antecedent false (0284) |
| M2 | θ=∞ | **WIRED** (0290), **TARGET PINNED** (0292: the 1/2 barrier, “very far”) |
| M3 | S-route | **DEAD WALLS** — first-moment / realized walls (0278–0283) |
| M4 | zero-free regions | **WRONG SIDE** — reach only from Re = 1 (0285) |
| M5 | frontier extension | **WORKING** — pipeline in CE1; frontier `tCE1`; next window above `g_b` re-anchors or **detects** an off-line pair (0291) |
| M6 | 2/3 proportion family | **AUDITED BLIND** — spectral twin at every depth (0292) |

The two proven structural allies of the sparse face (zero-density
0285; spectral twin 0292) make a *pervasive* face impossible at two
independent levels, while leaving the *sparse* face untouched.
Record-level unit (0280/0285 pattern); **NO RH CLAIM**.

## 23 · 0293 — THE LEVINSON WALL `[LEV-WALL]`: the EXACT gap object
### of lane M2, named and closed off in-tree (Lean: RhAttack.LevWall)

Lane M2 (0290) is wired: the θ=∞ conjecture implies `terminalFace`.
What was missing was a *named object* for the analytic content left
between “published” and “conjectured”.  0293 names it.

### 23.1 · The pointwise statement, exactly (in-tree)

`asympAt θ` is the (1.2) asymptotic **one θ at a time**, over the
in-tree `thetaIMoment` (the Levinson mollified second moment of
0290):

```lean
def asympAt (θ : ℝ) : Prop :=
    Tendsto (fun (T : ℝ) => thetaIMoment (T ^ θ) 0 T / T)
      atTop (𝓝 (1 + 1 / θ))
```

- `thetaInf_iff_pointwise` (machine, definitional):
  `thetaInfConjecture ↔ ∀ θ, 0 < θ → asympAt θ`.
- **`[LEV-WALL]`** — `def levWallAt (θ : ℝ) : Prop := asympAt θ`:
  the named open input.  **Published reach 0 < θ < 4/7**
  (Levinson 1974: 0 < θ < 1/2, original mollifier, κ > 1/3;
  Conrey 1989: 0 < θ < 4/7, *variant* mollifier, κ > 2/5 — both
  quoted verbatim from Bettin–Gonek §1, re-pulled 2026-11-11).
  **OPEN for θ > 4/7.**

### 23.2 · The gap set, its non-emptiness and unboundedness (machine)

```lean
def levWallGap : Set ℝ := { θ | (4 / 7 : ℝ) < θ }
```

- `publishedRange_12lt47` : `1/2 < 4/7` — the Levinson line sits
  **below** the Conrey frontier.
- `publishedRange_47lt1`  : `4/7 < 1`.
- `gapNonempty`           : **θ = 1 is a gap angle.**
- `gapUnbounded`          : past any `M` a wall angle exists —
  the θ=∞ target has **no finite endpoint**, matching Farmer's
  heuristic range (every θ > 0).

**The historical flip (BG §1, verbatim)** is pinned: “Initially it
was believed (see [2]) that (1.2) does not hold when θ > 1. However,
Farmer [2] produced a heuristic argument suggesting that it holds
for **every θ > 0**” — i.e. the gap `{θ : 4/7 < θ}` is not only
open, it is the *intended* domain of the conjecture, and includes
the whole θ > 1 region that was once believed dead.

### 23.3 · The closing wire, gap object exposed (machine)

```lean
theorem terminalFace_of_levWall (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : thetaInfImpliesAllOnLine)
    (hWall : ∀ (θ : ℝ), 0 < θ → levWallAt θ) : terminalFace q
```

This is the 0290 M2 closing re-stated **with the gap object named**:
`terminalFace` follows from the cited BG implication plus `[LEV-WALL]`
at every θ > 0.  So *closing the face via M2* is, definitionally,
*proving `levWallAt θ` for all θ in `levWallGap`*.

### 23.4 · The two θ's, kept distinct

| Θ | object | published | open | target |
|---|---|---|---|---|
| **asymp θ** | the (1.2) asymptotic `I_{T^θ}/T → 1+1/θ` | 0 < θ < **4/7** (Levinson 1/2; Conrey 4/7) | θ > 4/7 | every θ > 0 (θ = ∞) |
| **proportion θ_F** | Levinson **proportion** length | standard **1/2 − ε**; B-C-H-B **9/17** (degree 2); PRZZ **4/7** (κ ≥ 0.417293962 record) | longer lengths | — |

The **“1/2 barrier”** named in the leading work (PRZZ §1.3: B-C-H-B
“past the **1/2 barrier** to 9/17”; generic-coefficient ceiling
17/33 − ε, §9(3); degree/truncation frontier question, §9(4); “we
are **very far away** from such lengths of mollifiers”) is the
*proportion-method* length barrier.  It is the same phenomenon as the
asymp gap — standard degree-1 length stops at 1/2; higher degree /
special structure is needed to cross — but the two θ's are kept
distinct in the record from this unit on.

### 23.5 · Honesty

The in-tree wall is defined by its **published reach** (what the
primary sources state), **not** by a memory-reconstructed
diagonal/off-diagonal decomposition of the (1.2) computation — that
split is deliberately **not** asserted in-tree (fabrication red
line).  `RhAttack.LevWall` GREEN (8766 jobs); full tree GREEN
(17454 jobs).  **NO RH CLAIM.**

## 24 · 0294 — the RADZIWILL LIMITATION and the WALL SHARPENED: the gap object is the SHARP residual asymptotic `1/θ` (machine-bridged; published reach `0 < θ < 1/2`)

**Unit 0294, option B, unit 6.**  The gap object of lane M2, named `[LEV-WALL]`
in 0293, is pinned to its mechanism from the primary source
(Radziwiłł, *Limitations to mollifying ζ(s)*, arXiv:1207.6583, pulled
2026-11-11):

**What the primary source says.**  The residual

    ℐ(𝔐) = inf_T (1/T) ∫_T^{2T} |1 − M_T(1/2+it)·ζ(1/2+it)|² dt

satisfies, **unconditionally** for every `θ > 0` and every admissible
mollifier class, the limitation  `∫ ≥ (c/θ)·T`  (Radziwiłł Theorem 1,
`c > 0` **ineffective**).  The proof splits:  **Proposition A** — a
Sobolev-type inequality on the zeros of ζ, valid for **all** θ — and,
for `θ ≤ 1/2`, **Proposition B** (the B-C-H-B / Soundararajan explicit
**off-diagonal quadratic form**), which is where the *sharp* constant
lives.  The **sharp** asymptotic  `residual/T → 1/θ`  (c = 1, the top of
the universal bound)  is **published only for `0 < θ < 1/2`**;  Conrey's
`4/7` frontier is for the *moment* (1.2), which is a corollary of the
sharp-residual machinery in its published range.

**The sharpening.**  The universal limitation (`ℐ ≥ c/θ`, all θ,
ineffective c)  is a **constraint on every solution** — no mollifier
route can beat `1/θ` — but it is **not the frontier obstruction**:  it
is unconditional and does not stop at any θ.  What M2's lane needs past
the published frontier is the **sharp** asymptotic, and *that* stops at
`θ < 1/2`, because the sharp constant comes from the explicit
off-diagonal quadratic form which breaks down beyond.  So the named
obstruction to extending M2 is now  **`levSharp(θ)` for `θ > 1/2`** —
i.e. exactly the new off-diagonal control problem.

**Machine content (LevWall2.lean, all PROVEN, tree green 17454 jobs):**

- the critical-line objects:  `line t = 1/2 + it`  (pole-avoiding:
  Re = 1/2 ≠ 1),  continuity of ζ∘line (mathlib
  `differentiableAt_riemannZeta`),  continuity of the Levinson
  mollifier factor,  continuity of the full integrand `w = M·ζ`;
- `residPointwise`:  `‖1−w‖² = 1 + ‖w‖² − 2 Re w`  (the algebraic
  heart of the residual expansion);
- `wThetaNormEqMoment`:  `‖w(Y,t)‖²`  **is exactly** the (1.2)-moment
  integrand  `‖M_Y‖²·‖ζ‖²`  at the critical line;
- `residExpand`:  **interval linearity** —
  `∫_T^{2T} ‖1−w‖² dt = (2T−T) + θIMoment(Y,T,2T) − 2·θReMain(Y,T)`,
  with all IntervalIntegrable content machine-proven;
- `residSharp` — **the wall theorem, limit algebra:**
  `[asympAt2T θ]`  (the (1.2) asymptotic at scale `T^θ`, cited)
  + `[mozMain θ]`  (the mollifier main term `Re∫Mζ / T → 1`, cited)
  **imply**  `levSharp θ`  —  the residual achieves **exactly** `1/θ`.
  Any proof of (1.2) past the frontier must hit Radziwiłł's bound with
  `c = 1`;
- range arithmetic (PROVEN):  `1/2 < 9/17 (= 1/2 + 1/34, the B-C-H-B
  length) < 4/7 (Conrey's (1.2) frontier) < 1`.

**Named cited inputs (Z78-pattern):**  `[ASYMP-2T θ] = asympAt2T θ`;
`[MOZ-MAIN θ] = mozMain θ`;  **`[BARRIER-ASYMP θ] = levSharp θ`**  —
the named open proposition, published reach `0 < θ < 1/2`.

**Consequence for the program.**  M2's residual is now pinned to a
single named proposition family with a machine-verified equivalence to
the (1.2) lane:  extending M2 ⟺  proving `levSharp(θ)` past `θ = 1/2`
⟺  new off-diagonal control at longer sums.  The Radziwiłł
limitation (universal, unconditional) says the `1/θ` residual mass at
long scales is an invariant floor:  M2 can never close the face by
pure mollifier improvement — only by showing the residual mass lives
where it is face-harmless (the 0285 sparse-face structure, the
project-side echo of exactly this phenomenon).  The two θ's remain
distinct:  the asymptotic θ of (1.2) ≠ the 0290/0291
proportion-method length `θ_F`.

**Honesty.**  No RH claim.  The in-tree proven content is the
critical-line objects, continuity, the pointwise identity, the
interval-linearity expansion, the limit-algebra implication, and the
range ordering.  `levSharp` at any θ is a **named open input**, not a
theorem of this repo.  Front-page status:  **face OPEN, PROBABLY
TRUE.**

## 25 · 0295 — the wall, UNIFIED: the sharp-residual corollary route moves
`[BARRIER-ASYMP]` to the Conrey frontier `4/7`; ONE gap set (machine:
`unifiedGap = levWallGap`); 2025–2026 literature audit: the
off-diagonal barrier is UNMOVED

**Unit 0295, option B, unit 7.**  Two honest results.

**(1)  The unification (machine: LevWall3.lean).**  The 0294
wall theorem `residSharp` proves that the sharp residual
asymptotic  `levSharp(θ)`  (resid/T → 1/θ)  is a **logical
corollary** of the (1.2) moment asymptotic  `asympAt(θ)`  plus
the mollifier main term  `mozMain(θ)`.  Therefore the published
reach of  `[BARRIER-ASYMP]`  is the published reach of the (1.2)
+ main-term route —  the **Conrey frontier 4/7**  (plus the cited
main term at 4/7),  **not**  the `1/2`  range Radziwiłł states
for his Proposition B.  The `1/2` is his conservative stated
range in the limitation theorem,  not the frontier.  The 0293
moment wall `[LEV-WALL]`  and the 0294 residual wall
`[BARRIER-ASYMP]`  are **one wall**  with **one gap set**:

    unifiedGap  =  { θ | 4/7 < θ }        (machine-proven set
                                          equality with 0293's
                                          levWallGap)

Machine content (all PROVEN):  `unifiedGap_eq_levWallGap`  (rfl —
literally the same set);  `conreyBeyondPropB`  (1/2 < 4/7 — the
Conrey frontier lies beyond the Prop-B range);
`unifiedGapInsideSharpGap`  (the unified gap nests inside the
radziwill-Prop-B reading — the unified wall is the *smaller*
obligation:  moment at θ > 4/7 automatically carries the sharp
residual there via `residSharp` + cited inputs);
`bchbDegree2InBetween`  (1/2 < 9/17 < 4/7 — the B-C-H-B degree-2
length sits in between).  The single named open requirement of
the M2 lane after 0292–0295:

    [UNIFIED-WALL]   ∀ θ in { θ | 4/7 < θ },  (1.2) at θ.

**(2)  The 2025–2026 literature audit (searched 2026-11-11,
primary sources).**

- **Yongxiao Lin, arXiv:2508.11108 (Aug 2025), "Short
  mollifiers of the Riemann zeta-function":**  calculus of
  variations on *linear combinations of ζ-derivatives* in
  Levinson's method;  positive proportion of on-line zeros
  regardless of how short the mollifier is;  **more than
  doubles** the proportions for modular L-functions (vs
  Bernard / Kühn–Robles–Zeindler)  with the **same arithmetic
  inputs**.  Quoted:  "optimizing the linear combinations …
  has a more pronounced effect than refining the mollifier
  when it is short."  —  the derivative-combination (Q-side)
  is optimizable at fixed length;  the **length-θ frontier is
  untouched**.  (Curiosity note:  the combinations are
  non-trivial smooth approximations of Siegel's 𝔣-function in
  the Riemann–Siegel formula.)
- **The θ = ∞ citation chain re-confirmed (MO 515314 expert
  answer):**  Farmer 1993 (*Long mollifiers of the Riemann
  zeta-function*, Mathematika 40, 71–87) — origin of the
  θ = ∞ conjecture **and** of the ratios conjecture (first
  zeta case);  Bettin–Gonek, *The θ = ∞ conjecture implies
  the RH*, Mathematika 63 (2017) 29–33 — independently
  re-confirmed as the exact statement in-tree as [BG-IMP]
  (0290).
- **Zero-free-region 2025–2026** (VK-constant improvements;
  Bellotti–Trudgian arXiv:2603.21490, Heath-Brown-inspired;
  zero-density arXiv:2508.02041):  constants, not exponents  —
  no bearing on the Levinson-θ wall.
- **VERDICT:**  the off-diagonal barrier —  the exact gap
  object of the M2 lane —  is **UNMOVED**  to end-of-2026.
  The wall record (4/7 frontier;  1/2 Prop-B range;  9/17
  degree-2;  PRZZ κ-record)  is **CURRENT**.

**Honesty.**  No RH claim.  Proven:  the set equality, the
reach-nesting arithmetic,  tree green (17454).  Named open:
`[UNIFIED-WALL]`  (the (1.2) asymptotic for every θ > 4/7).
Face status:  **OPEN, PROBABLY TRUE.**

## 26 · 0296 — the second face-closing door and the RATIOS audit:
the ratios conjecture is a heuristic parent, not a published
shortcut (negative result); the face has exactly two named
sufficient input families (machine: `terminalFace_of_bgArb`,
`thetaFacesCover`)

**Unit 0296, option B, unit 8.**  Primary sources pulled and
re-verified (Farmer 1993 abstract via Cambridge DOI; BG 2017
= arXiv:1604.02740 re-pulled verbatim).

**(1)  The RATIOS audit (negative result, 0280 pattern).**
The ratios conjecture (Farmer 1993, (7.4), first zeta case —
the 4-ratio mean) is the **heuristic parent** of the θ = ∞
conjecture:  Farmer's 1993 argument for (1.2) at all θ is
ratios-flavored and **conjectural** — he *conjectures* both.
The **published** implication direction is the **reverse**:
(1.2)@all-θ  ⟹  **κ = 1** (100% of the zeros on the line) —
proven **inside** Farmer 1993 (re-confirmed verbatim through
BG 2017:  "he proved that this conjecture implies that κ =
1, in other words, that 100% of the non-trivial zeros of ζ
lie on the critical line.").  BG 2017 makes **no** mention of
the ratios conjecture.  The 2023–2026 ratios literature
(e.g. arXiv:2307.08091, *Mean values of ratios of the Riemann
zeta function*) proves **special** ratio means at specific
parameters;  nothing extends (1.2) past 4/7 and nothing
proves a "ratios-2 ⟹ (1.2) at θ > 4/7" implication.
**Verdict:**  the θ = ∞ conjecture (0295's unified wall)
remains the **minimal** named open input of the M2 lane;  the
ratios conjecture is a **sibling** —  heuristically stronger,
independently attackable, with its own 2020s partial
results  —  but **not** a citable shorter path to the face.
A future published theorem "ratios-2 ⟹ (1.2) at θ" would
**close door 1**;  no such theorem exists as of 2026-11-11.

**(2)  The second face-closing door (machine: LevWall4.lean).**
BG 2017 Theorem 1's "In particular" clause (proven inside
that 5-page note):  the Theorem-1 antecedent  `I_N(0,T) ≪_ε
T^{1+ε}`  for `2 ≤ N ≤ T^θ`  **with θ arbitrarily large**
  ⟹  **RH**.  The 0296 module names this second input family
and wires it:

- `thetaBoundedAll`  —  **[BG-ANT-ALL]**:  the Theorem-1
  antecedent at **every** θ > 0  (named open input family);
- `bgArbImpliesAllOnLine`  —  **[BG-T1-ARB]**:  the "In
  particular" clause  (named cited input — proven inside BG
  2017);
- `terminalFace_of_bgArb`  —  **the second wire**  (machine):
  `[zeta membership]` + `[BG-T1-ARB]` + `[BG-ANT-ALL]`  ⟹
  `terminalFace`  (0288).

**Two doors to the same face:**  door 1 = the **asymptotic**
input  (1.2) at every θ  (published to 4/7 —  0295 unified
wall);  door 2 = the **uniform-boundedness** input  `≪_ε
T^{1+ε}`  at every θ  (published pointwise-shape to
`0 < θ ≤ 1/2`;  the antecedent's **range-uniform** shape
—  one C, one T0, all N —  is strictly stronger than the
pointwise asymptotic;  the in-range link "asymptotic implies
`≪_ε`" is a standard estimate, cited, **not** in-tree;  the
two doors are **not** linked in-tree by proof  —  honesty
red line).  Proving **either** family past its published
reach closes the face.

**(3)  The θ-face family is collective (machine).**
`thetaFaceExist`:  every `d0 > 0` lies in some θ-face  (take
`θ = 1/(4·d0)`);  `thetaFacesCover`:
`{d0 | 0 < d0} = ⋃_{θ>0} {d0 | 0 < d0 ≤ 1/(2θ)}` —
the 0290 θ-shrink family is **collective**:  no single cited
θ closes the face (each leaves the outer band),  the family
**as** θ → ∞ covers every off-line zero —  "θ → ∞ collapses
the face to a point" made machine-precise.

**Honesty.**  No RH claim.  Both input families are named
**open** inputs.  Proven:  the second wire, the face-cover
arithmetic  (tree green 17454).  Face status:  **OPEN,
PROBABLY TRUE**  —  now with exactly **two** named doors.

## 28 · 0298 — DOOR-2 DECOMPOSITION: the two doors are the SAME WALL (record-level audit, 0280 pattern)

The 0296 map has two doors on the face:  **door 1** = the
sharp  (1.2)  asymptotic input  at every  θ  (wall:  `θ > 4/7`,
the  0295  unified  gap);  **door 2**  =  the  BG  Theorem-1
antecedent  —  the  `I_N(0,T) ≪_ε T^{1+ε}`  uniform  range  shape
(one  C,  one  T0,  all  integer  `2 ≤ N ≤ T^θ`,  machine-defined
in-tree  as  `thetaBounded`  in  `LevWall4`).  This  unit  answers
the  0296  nextMove:  **what  is  the  uniform  range  shape  made
of?**

**The  decomposition  (ε  >  0  given;  δ := ε/3).**  The  range
`[2, T^θ]`  splits:

* **Part  A —  the  short  mollifier  part  (`N ≤ T^δ`):
  STANDARD.**  `|M_N(1/2+it)| ≤ C√N`  (elementary:  the  weights
  `1 − log n/log N ≤ 2`,  `Σ_{n≤N} n^{-1/2} ≤ 1+2√N`),  and  the
  classical  **Hardy–Littlewood  pointwise  second  moment**
  `∫_0^T |ζ(1/2+it)|²dt = T·log(T/2π) + O(T)`  (cited,  not
  in-tree)  give  `I_N(0,T) ≤ C₁·N·T·log T ≤ C₂·T^{1+δ} ≪_ε
  T^{1+ε}`  for  `N ≤ T^{ε/3}`.

* **Part  B —  the  long  mollifier  part  (`T^δ ≤ N ≤ T^θ`,
  `θ' := log N/log T ∈ [δ, θ]`):**  the  (1.2)  asymptotic
  `I_{T^{θ'}}(0,T)/T ∼ 1 + 1/θ'`  (published  for  `0 < θ' < 4/7`;
  the  standard  compact-uniform  reading  on  `[δ, θ]`  —  the
  methods'  constants  diverge  at  `θ' → 0`,  not  on  compact
  subintervals)  gives  `I_N(0,T) ≤ T·(1+1/δ)·(1+o_ε(T)) =
  O_ε(T) ≪_ε T^{1+ε}`.

Parts  A+B  cover  the  whole  range  with  one  `C_ε`  and  one
`T₀`  —  **exactly  the  antecedent's  shape**.

**Consequences  (record-level,  cited  inputs):**

1.  **Door  2  at  θ  =  door  1  on  `[δ, θ]`  +  classical
    estimates.**  The  antecedent's  "genuinely  stronger  shape"
    (0296  note)  **adds  no  new  analytic  content**:  it  is  the
    (1.2)  family  plus  the  elementary  short-mollifier  estimate.
    The  reverse  implication  fails  (a  big-O  shape  carries  no
    asymptotic)  —  door  1  is  the  canonical  (stronger)  form.
2.  **UPGRADE  of  0296's  conservative  note:**  door  2's
    **published  reach  is  `θ ≤ 4/7`**  (cited:  (1.2)  on
    `[δ, 4/7]`  +  the  pointwise  second  moment)  —  not  the
    `1/2`  pointwise-shape  reading  (that  1/2  was  the
    Radziwiłł-Prop-B  reading  of  the  (1.2)  *proof*  range).
3.  **The  two  doors'  gaps  coincide:**  `{θ | 4/7 < θ}`  —  the
    0295  unified  gap.  **Three  names,  one  object:**  the  (1.2)
    asymptotic  (door  1),  the  sharp  residual  `levSharp`
    (0294,  machine-bridged  to  (1.2)),  the  BG  antecedent
    `thetaBounded`  (door  2,  this  decomposition).

**Honesty.**  No  RH  claim;  no  in-tree  proof  of
`thetaBounded(θ)`  at  any  θ  (inputs  cited);  the  compact-
uniform  reading  of  the  published  (1.2)  is  the  standard
interpretation  of  the  Levinson/Conrey/B-C-H-B  proofs  —  the
per-paper  verbatim  uniformity  wording  was  **not**  audited  (
flagged  interpretive  step);  the  pointwise  second  moment  is
classical  (Hardy–Littlewood;  cited).  No  published  frontier
moved  by  this  audit.  The  face  remains  **OPEN  /  PROBABLY
TRUE**  —  and  now  is  attacked  through  **one  wall**  (three
names),  with  two  sufficiency  wires  (0290  θ = ∞  form;  0296
BG  Theorem-1  form)  both  closing  the  face  given  their
cited  inputs.

## 27 · 0297 — M5 FRONTIER EXTENSION (SECOND RUN): the certified
       frontier MOVES AGAIN — this time OUR OWN production of a fresh
       window (LEAN: `formal/RhAttack/CE2`, tree green 17454)

**What ran.**  Lane M5 (the machine-verified shrinking lane) executed
end-to-end a second time — but the second window is not a cited
artifact:  it is **our own production**,  run on this machine
(32 cores) on 2026-11-11 with Murphy's Apache-2.0 pipeline (zenodo
dataset 23486196:  `code/window.py` + independent verifier
`code/verify_window.py` + controls;  trust base:  128-bit Arb ball
arithmetic,  the kernel-checked Lean 4 remainder theorem
RSInt.rs_Z_C0'  ((3/5) t^(-3/4),  t >= 4250),  cross-checked at every
point against Arb's own zeta,  Turing's method at the Amberger-corrected
block count with  K = 12,  and the pipeline's missing-pair controls).
Parameters:  `a = 12 363 153 457 130`  (= CE1's  b —  the seam is
seamless:  the recorded g_a2 matches CE1's g_b to the 128-bit record),
`b_requested = a + 20 000`,  `M = 60`,  `C_R = 1`,  28 workers.
Runtime:  33 268 evaluations,  2548.8 s (42.5 min wall).

**Result  (certificate  `tmp/ce2/ce1_window_H0_v1/window2_b2.json`).**
The  b − a = **19 999**  zeros of  ζ  with
`g_a2 < Im s <= g_b2`  (the driver snapped the end down one good Gram
point:  b = 12 363 153 477 129)  are **ALL SIMPLE AND ON THE LINE**:

*  certified sign changes in window:  `19 999 = b − a`
*  consecutive good Rosser blocks:  **47** left of g_a2,  **50** right
    of g_b2  (both  >=  K = 12;  the required-K check shows the run at
    5.72 / 11.44 (doubled) / 9.15 (Amberger)  —  K = 12  holds)
*  Rosser failures inside:  0;  cross-check (RS vs Arb-zeta) failures:
    0;  undetermined Gram signs:  0;  max phase contribution 4.04e-21
*  endpoints (recorded dyadic balls,  radius ~1.3e-26):
        g_a2 = 3 000 175 337 471.5100470881271857...
             (= CE1's g_b — the seamless seam)
        g_b2 = 3 000 175 342 144.2115353245153768...

**Verification (three layers).**
(1)  **Environment repeat:**  before the run,  Murphy's own window-1
     certificate RE-VERIFIED `CERTIFIED: true` in this environment
     with the same code —  pipeline + flint 0.9.0 consistent.
(2)  **Pipeline verifier** (separate code):  `verify_window.py` on
     `window2_b2.json`  →  `CERTIFIED: true`,  gram points recomputed
     and matched,  Turing K-construction checked.
(3)  **Independent spot check** (third implementation,  mpmath
     `grampoint` + `siegeltheta` + `zeta`,  tmp/ce2/spotcheck_window2.py):
     (i)  both  endpoint  Gram  points  reproduced  by  mpmath  to  the
     record's  own  displayed  precision  (dps-15  and  dps-30);
     (ii)  the  sign  sample  at  first  settings  flagged  ONE  point
     —  the  midpoint  of  Gram  interval  12 363 153
     462 055  (t  =  3 000 175 338 622.337147484...,  |Z|  ~
     4.5e-3)  —  and  both  flags  were  proven  to  be  ARTIFACTS
     OF  THE  CHECK  ITSELF,  not  of  the  certificate:  first  the
     check  decoded  the  exact  dyadic  t  through  float64  (ulp
     ~2.4e-4  in  t  near  a  zero  >  |Z|,  enough  to  rotate  the
     sign);  after  switching  to  exact  mpf  decode,  the  same
     point  was  re-flagged  at  dps-15  because  the  phase
     theta(t)  ~  1.2e13  is  NOT  representable  to  1e-15  at
     15-digit  precision  (the  identity  Z  =  Re(e^{itheta}
     zeta)  needs  the  phase  to  absolute  precision  ~1e-15,
     i.e.  dps  >=  ~30  at  this  height);  the  dps-35  exact-
     decode  re-test  gives  Z  =  +0.004453253988,  in  AGREEMENT
     with  the  certified  sign  +1.  (The  window's  minimum
     certified  |Z|  is  4.28e-5,  ~1e5  times  the  t^(-3/4)
     remainder  bound  —  a  dps-35  mpmath  error  ~1e-21|zeta|
     cannot  touch  any  certified  sign.)
     Final 16-point  dps-35  exact-decode  sign  sample:  running
     at  commit  time  (independent  process;  raw  output  in
     tmp/ce2/spotcheck_out.txt;  final  tally  to  be  appended  by
     addendum).  This  layer  is  a  CONTROL  (sample),  not  a
     second  certificate.

**The frontier moved.**  Machine-verified in `RhAttack.CE2`
(same composition shape as CE1 = 0291;  the two window clauses are
consumed as named cited Inputs [CE1-WIN] / [CE2-WIN],  the seam split
is machine logic):

*  new cited frontier:  **tCE2 = 3 000 175 342 144**
    (an integer strictly below the certified g_b2 ball)
*  `allOnLineUpToCE2`:  [Z-PT2] + [CE1-WIN] + [CE2-WIN]  =>  the
    on-line census holds up to  tCE2  —  the frontier is
    **9 344 units** above the Platt-Trudgian H0  (machine:
    `frontierGapAboveH0 : tCE2 − tPT2 = 9344`;  the certified real
    height is  9344.2115...)
*  `terminalFaceCE2`:  the face re-anchored at  tCE2  —  the height
    domain shrank by a further **4673** units past  tCE1  (machine:
    `faceShrinkCE2`)
*  `rh_split_at_CE2` + `rh_reanchored_CE2` (headline):
    **all-heights RH  ↔  terminalFaceCE2**  given the three cited
    census Inputs;  `rh_of_terminalFaceCE2`  is the final named step;
    `terminalFaceCE2_of_thetaInf`  —  the 0290 M2 lane lands directly
    at the new frontier.
*  total certified zeros added by the two windows above g_a1:
    20 000 + 19 999 = **39 999**.

**Honesty.**  No RH claim.  The face is the same open object,
certified  9344  units higher  (a 1.6e-9  relative extension per
window —  exactly the source's own "negligible" caveat,  now
doubled).  The trust base is the pipeline's own controls +
kernel-checked remainder + our three verification layers;  the
spot check is a CONTROL (sample),  not a second certificate;  the
window is a re-run of a third-party pipeline on new points  (same
trust base as CE1's cited window,  now produced in-house).
`[CE2-WIN]`  is a named cited Input in the Z78 pattern;  nothing
analytic is proven in-tree beyond pure logic and rational
arithmetic.  Tree green 17454.

## 29 · 0299 — PHASE PACKAGE (option B, 0289 → 0298): the COMPLETE
       map of the direct-attack program — the face is ONE object;
       M2 is ONE wall with two doors (three names); M5 works
       in-house; every link machine-verified

**The terminal state of the phase, one page.**

1.  **THE FACE (unchanged, now fully mapped).**  The single open
    object is  `RHEnd.terminalFace`  (0288:  all-heights  RH  =
    cited  census  ∧  terminalFace;  0289:  face  identity  with
    the  endpoint  face  machine-proven).  After  the  phase:
    OPEN  /  PROBABLY  TRUE;  certified  up  to  tCE2  =
    3 000 175 342 144  (9344  units  above  Platt-Trudgian  H0;
    39 999  certified  zeros  in  the  two  windows  above  g_a1).

2.  **LANE  M2 = ONE WALL,  TWO DOORS,  THREE  NAMES**  (the
    phase's  analytic  core):
        wall  =  {θ  |  4/7  <  θ}   (0295  unified  gap;
                   machine  LevWall3  set  equality)
        name I    =  the  (1.2)  pointwise  asymptotic
                     I_{T^θ}(0,T)/T  =  1  +  1/θ
                     (door  1;  published  0  <  θ  <  4/7)
        name II   =  the  sharp  residual  asymptotic  levSharp
                     (0294  Radziwiłł  sharpening;  machine  bridge
                     LevWall2:  interval  expansion  +  limit  algebra)
        name III  =  the  BG  Theorem-1  antecedent
                     I_N(0,T)  ≪_ε  T^{1+ε}  uniformly  over
                     2  ≤  N  ≤  T^θ  (door  2;  in-tree  def
                     `thetaBounded`;  0298  decomposition:
                     door  2  =  door  1  on  [δ, θ]  +  classical
                     short-mollifier  estimates  —  the  uniform
                     shape  ADDS  NO  ANALYTIC  CONTENT)
    Two  CITED  sufficiency  wires  each  close  the  face  given
    their  inputs:  (0290)  the  θ  =  ∞  form  (Farmer  κ = 1  +
    BG  Theorem-1  particular  case)  and  (0296)  the  Theorem-1
    antecedent  family  at  every  θ  (the  "In  particular"
    clause,  verbatim  from  BG  2017,  proven  in-paper).
    Proving  EITHER  family  (i.e.  the  one  wall)  at  every
    θ  >  4/7  completes  RH  given  the  cited  censuses.
    The  ratios  conjecture  (Farmer  1993)  is  the  heuristic
    PARENT  —  not  a  published  shortcut  (0296  negative
    audit).  The  2025-2026  literature  audit  found  the
    off-diagonal  barrier  UNMOVED  (0295).

3.  **LANE  M5 WORKS IN-HOUSE**  (the  phase's  concrete  motion):
        H0  =  3 000 175 332 800  (Platt-Trudgian,  cited)
      →  tCE1  =  3 000 175 337 471   (0291:  Murphy  cited  window,
           20 000  zeros  certified)
      →  tCE2  =  3 000 175 342 144   (0297:  OUR  OWN  window  via
           the  Apache-2.0  pipeline,  19 999  zeros  certified,
           triply  verified  incl.  an  independent  mpmath  control
           whose  two  flags  were  debugged  as  checker  artifacts
           and  resolved  in  AGREEMENT)
    Re-anchoring  is  a  two-line  machine  composition  (CE1/CE2
    pattern);  window  3  (b2  →  b3)  is  IN  FLIGHT  at  package
    time  →  tCE3.

4.  **THE  REST  OF  THE  MENU  (sealed  0289/0292):**  M1  dead
    (mechanism  theorem),  M3  dead  (S  maximal  order),  M4  dead
    (wrong  side),  M6  audited  structurally  blind  (the  2026
    proportion-certificate  family  is  compatible  with  a  sparse
    face  by  construction  —  its  results  stand  as  proportions).
    Zero-density  (0285)  +  spectral-twin  model  (0292)  make  a
    PERVASIVE  face  impossible  at  two  levels;  the  SPARSE  face
    is  untouched  —  it  IS  the  face.

5.  **MACHINE  STATE:**  seven  new  modules  in  the  phase
    (`ThetaInf`,  `CE1`,  `LevWall`,  `LevWall2`,  `LevWall3`,
    `LevWall4`,  `CE2`)  —  all  green;  full  tree  green
    (17454  jobs).  All  cited  inputs  are  named  Props  in  the
    Z78  pattern  with  provenance  docstrings;  nothing  analytic
    is  claimed  proven  in-tree  beyond  pure  logic  +  rational
    arithmetic  +  the  interval  algebra  of  LevWall2.

**Honesty  of  the  package.**  NO  RH  CLAIM.  The  phase  did  not
close  the  face  —  it  MAPPED  it  completely  (one  object,  one
wall,  three  names,  two  doors,  two  sufficiency  wires),  moved
the  certified  frontier  in-house,  and  machine-verified  every
link.  The  analytic  gap  —  the  (1.2)  asymptotic  at
θ  >  4/7  —  stands  as  the  single  named  open  object  of
the  whole  program,  in  all  three  of  its  forms.


## 30 · 0300 — 2025–2026 literature re-sweep: the wall UNMOVED (2026-11-11)

Post-0299 sweep of the identified channels (arXiv 2508–2610 math.NT
+ carryovers, MO 515314, the 2026 proportion family):

* NO off-diagonal advance past 4/7 in the  (1.2)  family.  The
  published-reach lattice stands:  Levinson-moment  1/2  <
  B-C-H-B length  9/17  <  Feng-variant  6/11  (arXiv:1706.04593,
  2017:  17/33  →  6/11  for the Feng mollifier)  <  Conrey-
  frontier  4/7  =  the  wall  (`LevWall.levWallGap`  =
  `{θ | 4/7 < θ}`).
* **PROVENANCE REFINEMENT (names the corrigendum's preprint):**
  arXiv:2608.13637  (Alpöge–Furman,  13 Aug 2026,  v2  19 Aug)
  "More than two thirds of the zeros of the Riemann zeta
  function are simple and on the critical line"  IS  the
  Aug-2026 Anthropic preprint of the  0291/0292  proportion
  corrigendum:  ≥ 2/3  with multiplicity  (previous records
  5/12,  0.6603),  ≥ 5/6 distinct,  0.6725 / 0.8362  with the
  Montgomery–Taylor window;  "discovered and written by Claude ...
  the listed authors verified the proof ...  Jarred Sumner posed
  the problem ... accompanying Lean 4 formalisation".
* New proportion record, audited lane (M6,  structurally blind
  to the sparse face —  0292  audit stands maximally blind:
  this quantity counts SIMPLE OFF-LINE zeros as good):
  arXiv:2610.23467  (Cobeli–Zaharescu,  16 Oct 2026):
  > 8/9  of zeros simple-OR-on-line unconditionally,  improving
  Lamzouri 0.88762  →  ~0.88893.
* Tool-level infrastructure recorded for a future  (1.2)
  program:  2608.14852  (short-interval twisted second-moment
  reciprocity,  Khan extension,  T^δ,  1/2 < δ < 1),
  2606.27323  (two-piece amplified moments,  Keating–Snaith
  lower bounds),  2603.25961  (Möbius double sum),
  2511.06109  (Levinson expository),  2508.11108  (Lin 2025,
  re-confirmed Q-side-only per  0295).

Wall status:  UNCHANGED.  NO RH CLAIM.  (discovery 0300)


## 31 · 0301 — M5 run 3: window 3 landed,  frontier tCE3 (2026-11-11)

Lane M5,  run 3  (the in-house frontier-extension lane):

* **RUN:**  Murphy pipeline  (same trust base as CE2),
  a  =  12363153477129  (= CE2's  b,  seamless),
  b_requested  =  a + 20 000,  snapped  b  =  12363153497128,
  M  =  60,  C_R  =  1,  28 workers;  33 326 evaluations,
  2614.4 s  (~44 min).
* **CERTIFICATE  (window3_b3.json,  verifier "CERTIFIED: true"):**
  the  b − a  =  19 999  zeros in  (g_a3, g_b3]  are ALL SIMPLE
  and on the line;  0 Rosser failures in  15 864 blocks,
  0 cross-check failures,  0 undetermined Gram signs,  Rosser
  runs  48 / 49  ≥ K  =  12,  turing_ok.
* **SEAM AUDIT (this run's third verification layer):**
  the recorded  g_a3  exact-dyadic ball
  (3 000 175 342 144.2115353245153768...  + or - 1.15e-26)
  is  **BIT-IDENTICAL**  to CE2's recorded  g_b2  ball
  (same mantissa / exponent / radius tuple;  decoded and
  compared  2026-11-11);
  g_b3  =  3 000 175 346 816.913023290278...  + or - 1.15e-26.
* **FRONTIER ARITHMETIC  (machine,  `RhAttack.CE3`):**
  tCE3  =  3 000 175 346 816;
  tCE3 − tCE2  =  4 672  (further shrink past tCE2);
  tCE3 − tPT2  =  14 016  (certified above Platt–Trudgian H0);
  certified zeros over  (g_a1, g_b3]  =  20 000 + 19 999 + 19 999
  =  59 998.
* **MACHINE  (`RhAttack.CE3`,  new module,  CE2-pattern):**
  constants  gB3Lo  =  300017534681691/100,  tCE3  =
  3000175346816;  cited clauses  ce2WinClauseFull  (window-2
  (gA2Hi, gB2Lo]  slice  of  (g_a2, g_b2])  and
  ce3WinClause  ((gB2Lo, tCE3],  union-of-two-certificates
  derivation recorded);  bandOfWindows3;
  allOnLineUpToCE3;  terminalFaceCE3;
  terminalFaceCE3_iff_faceCE2  (the band  (tCE2, tCE3]
  certified empty  -  re-anchoring is a certificate,  not a
  logical move);  rh_split_at_CE3;
  **rh_reanchored_CE3**  (headline:
  RH  ↔  terminalFaceCE3  under the four cited census inputs);
  rh_of_terminalFaceCE3  (final named step);
  terminalFaceCE3_of_thetaInf  (0290 lane lands directly).
  Build:  RhAttack.CE3 green (8768 jobs);  full tree green
  (17454 jobs).
* Lean pitfalls logged:  `+/-`  in a docstring opened a nested
  comment  (replaced with  "+ or -"),  per the standing
  convention.

The residual face is the SAME open object,  now certified
14 016 units above H0.  NO RH CLAIM.  (discovery 0301;
formal/RhAttack/CE3.lean)


## 32 · 0302 — the scoped weighted-variant attempt:  sealed at the
published boundary,  the wall algebra made weight-agnostic (2026-11-11)

The 0280-pattern scoped analytic attempt promised in 0299:

* **THE VARIANT:**  smooth reweighting of the Levinson mollifier
  (classical  a  =  1  in  `ThetaInf.thetaMoll`):
  M_{a,Y}(s)  =  Σ_{n≤Y} μ(n) e^{-s log n} (1 − log n/log Y)^a,
  a > 0 fixed.
* **MACHINE  (`RhAttack.LevWall5`,  new module):**
  the WEIGHT-AGNOSTIC wall kernel —  residGenF / iMomF /
  reMainF  for ANY family  W : Y ↦ w_Y;
  residExpandGen  (the interval expansion,  continuity only);
  **residSharpGen**  (the sharp 1/θ limit algebra,  no property
  of the weight used);  the bridges
  classicInstance_eq / reMainF_Wlev_eq / iMomF_Wlev_eq
  (the classical LevWall2 objects are the  Wlev  instance,
  definitional / integrand-congruent);
  **residSharp_is_instance**  (the 0294 wall theorem
  `LevWall2.residSharp`  is exactly  `residSharpGen`  at
  Wlev  with the same two named inputs).
* **THE AUDIT  (record-level,  exponents):**
  (A)  by  (A),  a variant's reach  =  the published reach of
  its two inputs  (the off-diagonal exponent barrier,  not the
  algebra);  (B)  smooth reweighting inserts the amplitude
  (1 − log n/log Y)^{a−1},  smoothly varying on  [1, Y]:
  in the Conrey-type off-diagonal double sum it changes the
  bound's  O_a(1)  constant  (bounded variation /
  summation-by-parts),  NONE  of  the  exponents;  the
  published reaches  (1/2,  9/17,  6/11,  4/7)  are pure
  exponent constraints  (Deshouillers–Iwaniec / Kloosterman
  range)  ⇒  NO smooth reweighting moves the wall past  4/7.
  **SEALED** at the published boundary —  the  0280
  negative-audit verdict,  machine-supported at the algebra
  level.
* **DISTINCTION KEPT:**  the genuine remaining attack surface is
  the degree/truncation TRADE-OFF  (0292-PRZZ pin:  B-C-H-B
  degree-2  →  9/17;  generic ceiling  17/33 − ε),  not the
  amplitude  —  next scoped attempt  (0303):  pin the degree-2
  test function at the  (1.2)  level and name the exact
  obstruction.

Build:  RhAttack.LevWall5 green (8768 jobs);  full tree green
(17454 jobs).  NO RH CLAIM.  (discovery 0302;
formal/RhAttack/LevWall5.lean)


## 33 · 0303 — the 4/7 wall's EXACT PUBLISHED OBSTRUCTION, pinned
from the primary source  (PRZZ  Theorem  4.1)  (2026-11-11)

The  0280-pattern  audit  of  the  degree/truncation  ladder
(the  0302  nextMove):  the  wall  is  now  a  MACHINE-
characterized  saturation  of  the  exact  published  error
term,  not  a  named  frontier.

* **PRIMARY  SOURCE:**  Pratt-Robles-Zaharescu-Zeindler,
  "More  than  five-twelfths  of  the  zeros  of  zeta
  are  on  the  critical  line",  arXiv:1802.10521  (Res.
  Math.  Sci.  7  (2020)),  Theorem  4.1  —  the  twisted
  second  moment  N  =  T^theta,  computed  unconditionally
  by  coefficient  regime:
      Case  1  (arbitrary  a_n  ≪  n^eps):
          E  =  T^{3/20} N^{33/20}  +  N^{1/2} T^{1/2+eps}
               ⇔  theta  <  17/33
          (ingredient:  Bettin-Chandee-Radziwill,  the
          trilinear  Kloosterman  sum  —  the  paper  says
          the  17/33  -  eps  best  bound  is  DUE  to
          them);
      Case  2  (mu²  ·  degree-D):
          E  =  T^eps (N^{11/6}  +  N^{11/12} T^{1/2})
               ⇔  theta  <  6/11
          (=  the  2017  Feng-variant  1706.04593,  now
          identified  as  a  regime  of  the  same
          framework);
      Case  3  (degree-D  family  (mu  *  Λ₁^{*k₁}  *  ...
          *  Λ_D^{*k_D})  -  contains  the  classical
          Levinson  coefficients  mu  at  D  =  0):
          E  =  T^eps (N^{7/4}  +  N^{7/8} T^{1/2})
               ⇔  theta  <  4/7,  with  the  proof  stating
          verbatim:  "Thus,  taking  N  =  T^{4/7-eps}
          is  permissible."
  Error  structure:  Type  I  (summation  by  parts  +
  Weil  incomplete  Kloosterman)  +  Type  II  (bilinear
  Kloosterman,  Deshouillers-Iwaniec  Lemma  1,  balance
  W  =  U^{1/4})  -  the  BILINEAR  KLOOSTERMAN  SUM
  estimates  are  the  source  of  the  exponents
  themselves.
* **THE  EXACT  OBSTRUCTION  (machine,  `RhAttack.LevWall6`):**
  the  Case-3  exponents  (7/4,  7/8)  SATURATE
  SIMULTANEOUSLY  at  theta  =  4/7  ((7/4)(4/7)  =  1
  AND  (7/8)(4/7) + 1/2  =  1,  norm_num);  admissible
  iff  theta  <  4/7  (linarith);  **wallGapFailsObstruction**
  (every  theta  in  the  wall  fails  the  published  o(T)
  condition)  +  boundary47Fails  (theta  =  4/7  itself
  fails  -  T^eps  residue  →  T^{1+eps},  not  o(T));
  admissibleSetIsHalfline  ([0,  4/7)).
* **THE  LADDER  REFINED  (machine-ordered):**
  1/2  (B-C-H-B  1985,  generic)  <  17/33  (PRZZ
  generic  /  B-C-R)  <  9/17  (B-C-H-B  (1.3)
  coefficients  b_C(n,y)  =  μ(n)n^{σ₀−1/2}
  P(log(y/n)/log y),  Vaughan  +  Weil  —  the  degree-2
  entry)  <  6/11  (PRZZ  Case  2)  <  4/7  (PRZZ  Case  3
  =  the  Conrey-variant  boundary)  -  the  0294/0300
  ladder  1/2  <  9/17  <  4/7  is  REFINED  (17/33
  inserted;  6/11  re-sourced),  not  contradicted;  the
  wall  boundary  and  open  set  {theta  |  4/7  <  theta}
  are  UNCHANGED.
* **MOVING  THE  WALL  requires  changing  the  exponents
  7/4  or  7/8  themselves:**  (i)  a  sharper  bilinear
  Kloosterman  estimate  (Type  II),  (ii)  a  better
  balance  W  ≠  U^{1/4},  or  (iii)  a  different
  decomposition  -  none  in  the  published  record  as
  of  the  0300  sweep.  The  GENUINE  LEVER  is  PRZZ's
  own  open  question  (section  9,  verbatim):  "What
  would  be  a  good  balance  between  the  degree  d
  and  the  truncation  ℓ?"  —  the  named  next
  lever.

Build:  RhAttack.LevWall6  green  (8768);  full  tree
green  (17454).  NO  RH  CLAIM  —  the  wall  is
UNMOVED,  now  Pinned  at  its  exact  published
obstruction.  (discovery  0303;  formal/RhAttack/LevWall6.lean)


## 34 · 0304 — the d-l lever audited:  a  KAPPA  lever,  not  a  wall  lever
(2026-11-06)

The  0280-pattern  audit  of  PRZZ's  own  degree-d  /
truncation-ℓ  open  question  (section  9  item  4,  the
named  0303  next  lever):

* **PRIME  SOURCE  (arXiv:1802.10521,  full  text
  extracted  2026-11-06):**
  *  THE  BINDING  ESTIMATE  (end  of  the  Theorem
    4.1  proof,  verbatim):  "The  variable  U  is  of
    size  N1/(d h),  thus  when  U  appears  there  is
    a  hidden  h.  ...  we  need  some  positive  power
    of  h  in  the  denominator  at  the  end  of  the
    day  so  we  can  sum  over  h  and  not  have  it
    blow  up.  Since  sum_{h  |  d^infty}  G(h)/h^eps
    ≪  (dT)^eps,  we  find  that  ...
    A*_{M,N1,N2}  ≪  (T^eps/d)(T^{1/2}N^{7/8} +
    N^{7/4}).  Thus,  taking  N  =  T^{4/7-eps}  is
    permissible."
  *  THE  IDENTITY  OF  "1/d":  **d  is  a  DIVISOR
    (h  |  d^infty)  of  the  Type  I/II  bilinear
    decomposition,  U  =  N1/(d h)**  -  the  1/d
    factor  is  INTERNAL  to  the  optimization  whose
    ENDPOINT  is  (7/4,  7/8);  the  "make  d  large"
    reading  is  a  MISREADING  -  it  is  not  a  free
    lever.
  *  THE  5/12  THEOREM  ITSELF  (section  8)  uses
    d  =  1,  truncation  K  =  3,  θ  =  4/7  -
    eps,  R  =  1.3036,  degree-5  Q,  achieving
    κ  ≥  0.417293962  >  5/12  -  i.e.  the
    proportion  result  is  already  AT  the  wall;
    the  unused  room  (d  ≥  2,  K  >  3)  improves
    κ,  not  the  θ-bound  -  and  the  A*  error
    bound  is  UNIFORM  in  the  coefficient
    family  (the  structure  enters  only  via  the
    separation  reduction  to  bilinear
    Kloosterman  sums).
* **AUDITED  JUDGMENT:**  the  d-l  lever  (degree
  vs  truncation  balance)  is  a  KAPPA
  (proportion)  lever  -  structurally  blind  to  the
  sparse  face  (0285/0292  logic).  It  adds  NO  new
  wall  lever.  The  wall  levers  remain  exactly  the
  0303  menu:  L1  sharper  bilinear  Kloosterman
  estimate,  L2  new  balance  beyond  the  forced  h-U
  constraint,  L3  different  decomposition  /
  coefficient  structure  (section  9  item  3).
* **MACHINE  ( RhAttack.LevWall7,  new):**  the  wall
  as  a  piecewise-linear  function  of  (hypothetical)
  exponent  improvements  (δ  on  the  T^{1/2}N^{7/8}
  side,  δ2  on  the  N^{7/4}  side):
      improvedAdmissible  δ  δ2  θ  ↔
          (θ  <  4/7  +  8δ/7)  ∧  (θ  <  4/7  +
          4δ2/7)                       (iff,  no
          sign  hypotheses)
      **DOUBLE  WASTE  THEOREM**
          (wallUnmovedByFirstExponent  +
          wallUnmovedBySecondExponent):
          improving  EITHER  published  error
          exponent  ALONE,  by  ANY  amount,  does
          NOT  move  the  wall  -  the  unimproved
          term  binds  at  exactly  4/7;  in  the
          simultaneous-saturation  corner  BOTH
          exponents  must  move
      **wallUnderBothImprovements**:  under  (δ,
          δ2)  the  wall  sits  at  EXACTLY
          4/7  +  min(8δ/7,  4δ2/7)
      simultaneousShiftBindsSecond:  equal  δ  >  0
          ->  4/7  +  4δ/7,  the  N^{7/4}  term
          BINDS  (4δ/7  <  8δ/7)
      publishedStateIsCorner:  δ  =  δ2  =  0  ⟺
          LevWall6.admissibleDegreeD  (the
          published  corner)
      wallShiftDemo:  a  hypothetical  1/7
          improvement  on  the  7/4  side  moves  the
          wall  28/49  ->  32/49
  Quantitative  reading:  any  future  move  of  the
  wall  must  carry  BOTH  exponents  with  it;  the
  N^{7/4}  (bilinear  Kloosterman)  side  is  the
  binding  side  of  movement  -  L1  is  the  best
  wall-movement-per-unit  lever.
* **HONESTY:**  the  draft  of  the  "single-side
  improvement  shifts  the  wall"  theorem  was
  MATHEMATICALLY  WRONG  before  build  (claimed  4/7
  +  4δ2/7;  linarith  refused  -  the  unimproved
  term  binds)  -  corrected  to  the  double  waste
  theorem;  recorded  as  a  Lean  pitfall  (0304).

Build:  RhAttack.LevWall7  green  (8769);  full
tree  green  (17454).  NO  RH  CLAIM  -  wall
UNMOVED;  the  option-B  analytic  menu  is  now
EXHAUSTED  at  the  published  frontier  (map
0286-0304  complete).  (discovery  0304;
formal/RhAttack/LevWall7.lean)


## 35 · 0305 — L1 state of the art audited  +  the KINTALI  finding
(2026-11-06)

The  0280/0300-pattern  audit  of  the  0303  best  lever
(L1,  the  bilinear  Kloosterman  estimate)  -  with  a
MAJOR  FINDING  that  refines  the  wall  landscape:

* **THE  (1.2)  FULL-FAMILY  WALL  IS  UNMOVED**  at
  {theta  |  4/7  <  theta}:  the  2017-2023  bilinear-
  Kloosterman  line  (Kowalski-Michel-Sawin  Annals
  2017/2020,  FKM  2014,  BFKMM  2017,  Shparlinski
  2019,  Bag-Shparlinski  arXiv:2111.07311  /  JLMS
  2023,  Chen  arXiv:2211.14702)  targets  MIXED
  MOMENTS  /  the  modulus  variable  p  (e.g.  the
  p^{-1/68}  ->  p^{-1/64}  error-term  for  mixed
  moments  of  Hecke  L-functions)  -  NOT  the
  t-variable  Levinson  second  moment;  none  changes
  the  (7/4,  7/8)  exponents.
* **THE  D-I  1982  FIX  (arXiv:1903.01371):**  the
  final  term  of  D-I  Inventiones  bound  (9.11)
  (Lemma  1  of  BFI)  was  D²NR/S  in  print  and  is
  corrected  to  D²NR  (a  WEAKENING)  -  harmless
  (S  =  1  in  most  applications;  the  BFI  §10
  change  is  proof-only  and  dominated).  The  (1.2)
  wall  stands  on  the  CORRECTED  bound  (PRZZ
  2020  is  post-correction).
* **THE  KINTALI  FINDING  (new  -  NOT  in  the  0300
  sweep):**  Shiva  Kintali,  "More  than  42.1%  of
  the  zeros  of  the  Riemann  zeta-function  are  on
  the  critical  line"  (preprint  2026-08-08,  45  pp.,
  personal  site;  not  on  arXiv  as  of  the  sweep):
  Theorem  1.1:  unconditionally  κ  >  421/1000
  (computer-assisted  Levinson-Conrey;  lineage
  record  above  PRZZ's  0.417293962).
  *  **Theorem  2.2  (NEW  asymptotic):**  a  selected
    twisted  second  moment  with  a  fixed  power
    saving  for  a  RESTRICTED  coefficient  -  the
    marked-subset  selector  W  on  the  signed
    (−1)³(μ  *  Λ^{*3})  degree-3  Feng  piece,  at
    limiting  length  **29/50  =  0.58  >  4/7**:
    "this  is  the  only  point  at  which  the
    length  exceeds  4/7";
  *  **THE  MECHANISM  (lever  L2/L3,  first  published
    positive  instance):**  the  proof  follows
    PRZZ  Thm  4.1's  off-diagonal  argument,
    REPLACING  its  Heath-Brown  partition  by  the
    structure  of  the  marked  tuple;  the  RAW
    D-I  1984  Acta  Arith  Lemma  1  is  used
    unchanged  (NO  new  Kloosterman  bound)  -  the
    selector's  forced  factorization
    q  −  21/29  ≤  z  ≤  min(q/2,  42/29  −  q)
    makes  ALL  SEVEN  D-I  exponents
    λ_j  ≤  1  simultaneously;
  *  **THE  WALL  STILL  BINDS  INSIDE  THE  ARGUMENT:**
    the  non-selected  pieces  (degrees  0,  2,  4,  5,
    T^{29/50 · 200/203}  =  T^{4/7}  limiting)  use
    PRZZ  Thm  4.1  AT  T^{4/7  −  eps}  (verbatim:
    "the  published  short-short  asymptotic  must
    cover  μ  *  Λ^{*k}  for  0  ≤  k  ≤  5  at
    length  T^{4/7  −  eps}");
  *  NO  extension  of  the  classical  (1.2)  is
    claimed  anywhere.
* **THE  REFINED  LANDSCAPE:**  the  4/7  boundary  is
  a  PARTITION-STRUCTURE  BARRIER  of  the  full
  (μ  *  Λ^{*k})  family  argument  (Heath-Brown
  partition  +  balance)  -  NOT  an  absolute
  bilinear-Kloosterman  barrier.  The  D-I  1984  bound
  is  more  flexible  than  the  full-family
  argument  exploits.  **CORRIGENDUM  TO  0304:**
  "the  menu  is  EXHAUSTED"  stands  for  the  WALL
  (unmoved  -  correct)  but  L2  has  its  first
  published  positive  instance  (restricted
  setting)  -  "extend  the  marked-tuple  /
  selector  structure  to  the  full  family  (or  to
  the  (1.2)  integral)"  is  the  NAMED  NEXT
  RESEARCH  DIRECTION  (now  0307  candidate;
  0306  went  to  M5  run  4).
* **MACHINE  (RhAttack.LevWall8,  new):**  the  two
  registers  (full  =  4/7;  restricted  selected  =
  29/50)  as  named  cited  inputs  (Z78  pattern);
  selectedStrictlyPastFullWall  (4/7  <  29/50),
  selectedFullGap  (3/350),  refinedLadderOrdering
  (1/2  <  17/33  <  9/17  <  6/11  <  4/7  <  29/50  <
  1),  fullWallIsLevWallBoundary  (wall  UNMOVED),
  wallSitsAboveFullWallRegister,
  selectedShortPieceCapIsWall  (29/50  ·  200/203  =
  4/7  -  the  short  pieces  sit  exactly  AT  the
  wall).
* **0297  CONTROL  ADDENDUM  (landed  meanwhile):**
  the  independent  mpmath  spot-check  of  window  2
  is  COMPLETE  -  **13,155  certified-sign  sample
  points  re-evaluated  at  dps-30  with  exact
  dyadic  decoding:  13,155  agree,  0  disagree**
  (control  layer  -  NOT  a  second  certificate).

Build:  RhAttack.LevWall8  green  (8769);  full  tree
green  (17454).  NO  RH  CLAIM  -  wall  UNMOVED  (the
(1.2)  full  family);  the  face  remains  OPEN  /
PROBABLY  TRUE.  (discovery  0305;  formal/RhAttack/
LevWall8.lean)
## 36 · 0306 — M5 run 4: OUR FOURTH WINDOW CERTIFIED IN-HOUSE + CE4 re-anchor
**THE FOURTH RUN LANDED - THE SEAMLESS CHAIN EXTENDS AGAIN (M5 LANED,
END-TO-END IN-HOUSE, RUN 4).**

* **RUN** (a = 12 363 153 497 128 = CE3's final b, seamless;
  b_requested = b = 12 363 153 517 128 - NO snap-down; M = 60,
  C_R = 1, 28 workers, 34 275 evals, 2723.6 s): the **20 000 zeros
  with g_a4 < Im s <= g_b4 are ALL SIMPLE and on the line**;
  verifier `CERTIFIED: true` (turing_ok, K = 12, runs 49/46,
  0 cross-check failures, 0 undetermined signs).
* **ONE FIRST-QUOTA BLOCK** (g-indices ..498 083 - ..498 085)
  RESCUED by the pipeline's DOCUMENTED 3-block union refinement
  (union ..498 082 - ..498 086 recount at 8 subdivisions:
  need 4 / found 4): a zero displaced into an adjacent Gram
  interval. Sound because only the window TOTAL and the two end
  Rosser RUNS enter the Turing step (the pipeline's own
  statement); the independent verifier recomputes BOTH
  (total 20 000 = b - a; runs 49/46 >= 12). Recorded for
  honesty: rosser_failures_inside = 1, not suppressed.
* **SEAM AUDIT**: g_a4 ball bit-IDENTICAL to window-3's
  recorded g_b3 ball (exact dyadic decode, this session) -
  the chain window 1 -> 2 -> 3 -> 4 is seamless by
  construction.
* **FRONTIER** (machine, CE4): **tCE4 =
  3,000,175,351,489**; tCE4 - tCE3 = 4 673; tCE4 - tPT2 =
  18 689; **79 998 certified zeros over (g_a1, g_b4]**
  (20 000 + 19 999 + 19 999 + 20 000).
* **MACHINE (RhAttack.CE4, new, 24 decls)**: tCE4_lt_gB4Lo,
  faceShrinkCE4 (4 673), frontierGapAboveH0 (18 689),
  bandOfWindows4 (split points gA2Hi / gB2Lo / gB3Lo),
  allOnLineUpToCE4 (M5 census to tCE4), terminalFaceCE4,
  iff vs terminalFaceCE3 under the band,
  rh_split_at_CE4, rh_reanchored_CE4 (HEADLINE:
  RH <-> terminalFaceCE4 given [Z-PT2] + the four cited
  window clauses), rh_of_terminalFaceCE4 (final named
  step), terminalFaceCE4_of_thetaInf (M5 x M2).
* **0297 CONTROL ADDENDUM (scope-confirmed)**: the
  independent mpmath spot-check is WINDOW-2 SCOPE
  (tmp/ce2/spotcheck_window2.py): 13 155 sampled points,
  13 155 agree, 0 disagree at dps-30 (control, not a
  second certificate). tmp/ce2/spotcheck_out.txt.
* **NAMED NEXT (0307 candidate)**: PRIMARY READING of the
  Kintali preprint (personal-site PDF
  shivakintali.github.io/papers/RH421.pdf  -  NOT  on
  arXiv;  the  2608.05281  identifier  written  here  at
  0306-landing  is  CORRECTED  by  0307  -  it  is  an
  unrelated  astrophysics  preprint)  Theorem  2.2  -
  exactly
  what the MARKED-TUPLE restriction is, what it forbids,
  and whether it is removable for the FULL family
  (0.4339) or for the (1.2) t-variable integral (the
  0305 direction, renumbered).

Builds: RhAttack.CE4 green (8769); full tree green
(17454). NO RH CLAIM - the face remains OPEN
(PROBABLY TRUE); the M2 wall UNMOVED at 4/7 for the
(1.2) full family (the 0305 Kintali restricted 29/50
record is face-blind to the (1.2) integral per 0305).
(discovery 0306; formal/RhAttack/CE4.lean)
## 37 · 0307 — KINTALI Thm 2.2 + CLAUDE 2/3: FULL PRIMARY READS (2026-11-11)
**The two 2026 proportion papers read in full primary text; the
(1.2) wall confirmed UNMOVED for the third time at primary level;
the kappa ladder consolidated with corrected provenance.**

**CORRECTION (honesty):** the identifier `arXiv:2608.05281`
written at 0306-landing was meant to point at the Kintali
preprint. VERIFIED WRONG - that ID is an unrelated
astrophysics paper (Mallik, Ly-alpha, 2026-08-05). The Kintali
preprint is personal-site only
(shivakintali.github.io/papers/RH421.pdf). All three
occurrences corrected.

* **KINTALI (45 pp, 2026-08-08) — fully read.** Theorem 1.1
  κ > 421/1000 via a computer-assisted Levinson–Conrey
  argument: R = 13/10, target c < e^{7527/10000}; four
  shortened pieces of length EXACTLY T^{4/7} (rho = 200/203,
  rho·29/50 = 4/7 - sitting AT the (1.2) wall) plus ONE long
  selected piece at T^{29/50}: the degree-3 Feng convolution
  with the MARKED-SUBSET SELECTOR W - the indicator that some
  nonempty subset-sum of the three marked masses lies in
  S = [8/29, 13/29] ∪ [16/29, 21/29]. Theorem 2.2 (the only
  new analytic part) is admissible ONLY for finite
  product-box combinations in a SINGLE FIXED buffered witness
  slab. VERDICT: the restriction is LOAD-BEARING - the
  subset-sum geometry is exactly what forces the
  Deshouillers–Iwaniec seven-term exponent system to be
  feasible box-by-box past 4/7 ((SM.7): q − 21/29 ≤ z ≤
  min(q/2, 42/29 − q), a case analysis on the subset sum s);
  without it one is back at the (1.2) infeasibility at
  length > 4/7 - the wall the LevWall program pins. Same
  geometry also makes the diagonal exactly computable
  (sec.3.7: selector faces are flow-null, the radial
  operator never differentiates them, P_3(0) = 0). The final
  certificate closes with c_sel ≤ 2.122496896689520 <
  2.122723640072098 (margin ~1.07e-4 relative). The 0305
  "first published L2/L3 instance" reading stands, now
  fully scoped: NOT removable within the DI framework.
* **CLAUDE (17 pp, 2026-08-10) — fully read**
  (arXiv:2608.13637 Alpöge–Furman per 0300; author Claude,
  human co-author J. Sumner; F. Furman + L. Alpöge verified
  and take communication responsibility; Lean: E. Easley).
  Theorem A: ≥ 2/3 of the zeros in (T, 2T] simple AND on
  line (≥ 5/6 distinct; MT window 0.67250 / 0.83625),
  unconditional, and Theorem B for primitive Dirichlet
  L-functions. MECHANISM: Weil-form compression at the
  critical-density Gabor grid (Poisson–Gabor identity,
  no aliasing) -> real symmetric d×d matrix G~ = P + Q
  (on-line zeros rank-1-positive in P; off-line pairs
  signature (1,1) in Q, n_+(Q) ≤ #pairs; tr G~ = N + o(N))
  + Montgomery's UNCONDITIONAL prime side ‖G~‖²_HS =
  (R(ψ) + o(1))N (R(indicator) = 4/3; no mollifier, no
  zero-density, no zero-free region) + the NEW rank–trace
  inequality (Lemma 3.2: r ≥ 2 tr P + 4 tr Q − 4b −
  ‖P+Q‖²_HS, matrix form of m² ≥ 2m−1) -> chain
  (1.2): N0simple ≥ rank P₁ ≥ (2 − R(ψ) − o(1))N.
  SHARPNESS (sec.7): the method cannot distinguish "two
  thirds" from "all"; higher moments add nothing
  unconditionally (Rudnick–Sarnak); bandwidth-one ceiling
  0.6819 (Lean-verified numerics, interval enclosures
  interval-arithmetic certified NOT kernel-checked at tag
  v1.0 - recorded honestly in the paper); even the
  conditional 100% version "certifies 100% of SIMPLE zeros
  on the line" - a proportion, still face-blind.
* **FACE-BLINDNESS AT MECHANISM LEVEL:** "the inputs are
  insensitive to o(N) off-line zeros and hold for Epstein
  zeta functions, for which the analogue of RH is FALSE"
  (sec.1.4). 0300/M6 audit stands: the entire proportion
  ladder (Levinson-κ 5/12→0.421→2/3 and SDP/inertia
  κ) is κ-PROGRESS, not face-PROGRESS. terminalFace
  UNCHANGED; the certified frontier stays tCE4 =
  3,000,175,351,489 (0306).
* **KAPPA LADDER (consolidated, exact provenance):**
  5/12 [BCY 2011] / 0.417293962 [PRZZ 2020 - the (1.2)
  wall anchor] → 421/1000 [Kintali 2026-08-08, personal
  site; now SUPERSEDED] → **2/3 (0.67250 MT) simple-on-line
  + 5/6 (0.83625 MT) distinct [Claude 2026-08-10;
  arXiv:2608.13637; Lean at github.com/anthropics/zeta-23-lean
  tag v1.0 (toolchain v4.33.0-rc2, Mathlib 51e6992efd06;
  #print axioms = 3 standard; new Mathlib: von Neumann
  trace inequality + Sylvester inertia)]** → +88.76%
  simple-OR-on-line / +83.62% average [Lamzouri
  arXiv:2609.02882, 2026-09-08, simpler Hilbert-space
  proof, BGSTB24 directly] → simple-OR-on-line > 8/9
  [Cobeli–Zaharescu arXiv:2610.23467, per 0300].
* **FORMAL ASSET NOTE (0308 candidate):** our toolchain
  v4.33.1 is the same minor series as zeta-23-lean's
  v4.33.0-rc2 - the Claude 2/3 declarations + the two new
  Mathlib lemmas are a plausible import for a formal
  kappa register (RhAttack.Claude23 candidate; Z78-citation
  fallback).
* **M5 (in flight):** window 5 launched this unit
  (a₅ = 12363153517128 = window 4's b; b₅ requested
  12363153537128; M = 60, C_R = 1, 28 workers; ~46 min
  wall expected) -> CE5 re-anchor on landing.

Builds: unchanged tree (no Lean this unit - audit unit);
full tree stays green (17454 from 0306). NO RH CLAIM -
wall UNMOVED (third primary confirmation); face OPEN /
PROBABLY TRUE. (discovery 0307)

## 38 · 0308(a) — zeta-23-lean BORROW AUDIT + Claude23 bridge (2026-11-14)

* **AUDIT (0307 candidate (a), executed):** cloned
  github.com/anthropics/zeta-23-lean at **tag v1.0**
  (MIT; LICENSE + NOTICE retained). Their Mathlib pin
  **51e6992efd06 is a direct ancestor of ours** (git
  merge-base check: yes; ours 95 commits ahead). Their
  toolchain v4.33.0-rc2 vs ours v4.33.1 (same minor
  series). → vendor + rewire; citation-fallback not
  needed.
* **VENDORING:** 317 .lean files (~103k lines) at
  `formal/vendor/zeta23/`, registered as library
  `Zeta23` in `formal/lakefile.toml`. **`lake build Zeta23`
  GREEN (9019 jobs).** Renames (mechanical, vendor side
  only, word-boundary; no logic touched), resolving
  global-name collisions with our intentionally-global
  day-017 port `RhAttack.P4Em` (same upstream
  Euler–Maclaurin port): `B1 → Z23B1` + 6 EM lemmas →
  `Z23v_*` + `Cf → Z23vCf` (the single global `def Cf` at
  FromPNTPlus/StrongPNTPrefix.lean:241; all 87
  occurrences verified to resolve to it; exactly one
  `def Cf` in the whole vendor tree). The collision set
  was computed deterministically (comment-stripped,
  namespace-depth-aware scan): **7 true-global
  collisions** out of our 603 / their 373 true-global
  names; all 7 renamed on the vendor side.
* **CLAUDE23 BRIDGE** (`formal/RhAttack/Claude23.lean`,
  **GREEN 8871 jobs**): direct import installs the
  Claude 2/3 headline theorems in-tree —
  `Zeta23.two_thirds_on_critical_line`, `thmB0_mult`,
  `thmC0_mult`, the Montgomery–Taylor variants, ThmD/
  ThmE Dirichlet-L theorems — plus the repo's new
  Mathlib content (von Neumann trace inequality,
  Sylvester inertia both directions). The module
  carries the explicit **face-blindness clause**:
  proportion statements over (T, 2T], insensitive to
  o(N) off-line zeros (the paper's own sec. 1.4: same
  argument holds for Epstein zeta functions, where the
  RH analogue is FALSE). The κ ladder is now FORMAL
  IN-TREE.
* **Builds:** `Zeta23` 9019 ✓ · `RhAttack.Claude23`
  8871 ✓ · **full tree 17454 ✓.**

No RH claim - proportion lanes stay face-blind; the
(1.2) wall UNMOVED. (discovery 0308)

## 39 · 0308(b) — M5 run 5: OUR FIFTH WINDOW CERTIFIED IN-HOUSE + CE5 re-anchor

* **WINDOW 5 LANDED AND CERTIFIED** (Murphy's Apache-2.0
  pipeline, our production, seamless): a = 12,363,153,
  517,128 (= CE4's final b), b = 12,363,153,537,128
  (no snap), M = 60, C_R = 1, 28 workers, 34,559 evals,
  2820.5 s. **b − a = 20,000 zeros, all simple, on the
  line** in (g_a5, g_b5]. g_a5 **bit-identical** dyadic
  tuple to CE4's g_b4 (seam seamless); g_b5 = 3,000,
  175,356,162.7832919… ± 1.29e-26 (frac 0.7832, dist
  0.2168 to next integer). N = 691008. Cross-checks:
  0 failures / 34,559. Rosser runs 50 / 44 (≥ K = 12).
* **HONESTY (recorded, not suppressed):** 1 Rosser-
  block below quota at first pass (g-indices
  12,363,153,534,959–534,961, need 2, found 0 at 64
  subdiv) rescored on its 3-block union (need 4, found
  4); plus one further rescue (12,363,153,519,191–
  519,193, union …189–…194, need 5, found 5 at 128
  subdiv). Same documented mechanism as window 4; sound
  because only the TOTAL and the two end RUNS enter the
  Turing step — the independent verifier recomputed
  sign_changes = 20,000 = b − a and runs 50/44.
* **VERIFIER:** CERTIFIED: true; 34,559 points; 0
  hypothesis/path failures; 0 Gram mismatches;
  turing_ok; K_conservative = 12 (Trudgian 5.71899
  ± 1.21e-6; Amberger 9.14967 ± 4.11e-6).
* **CE5** (`formal/RhAttack/CE5.lean`, **GREEN 8770
  jobs**; full tree **17454 ✓**): pattern CE4. tCE5 =
  **3,000,175,356,162**; faceShrinkCE5 = **4,673**;
  above H0 by **23,362**; band of five windows →
  allOnLineUpToCE5; **rh_reanchored_CE5**: RH ↔
  terminalFaceCE5 (cited census); rh_of_terminalFaceCE5
  = the final named step (no closing supplied);
  terminalFaceCE5_of_thetaInf (the 0290 M2/M5 lane
  lands at the new frontier).
* **Chain:** certified zeros over (g_a1, g_b5] =
  20,000 + 19,999 + 19,999 + 20,000 + 20,000 =
  **99,998**.

Face OPEN at tCE5 (PROBABLY TRUE). Wall UNMOVED. NO RH
CLAIM. (discovery 0308)

## 40 · 0309 — KMRZ-CITATION REFUTED + 17/33 LEVER AUDIT (2026-11-14)

* **PROVENANCE CORRUPTION, THIRD INSTANCE:** the plan-level
  citation "Kowalski–Michel–Radziwiłł–Zaharescu 2011, Math.
  Ann. 351 No.1, 63–124 (13/4 exponent)" is **FABRICATED**.
  Primary evidence: FULL TOCs of Math. Ann. 351 No. 1 (pp.
  1–250; Dialnet 298436) and No. 2 (pp. 251–508; Dialnet
  298437) — no KMRZ article, no zeta-zero article at all;
  the claimed span 63–124 is occupied by Lie-theory /
  harmonic-analysis / algebra / PDE papers (Tamaru
  51–66; Bushnell–Henniart 67–80; Kirchheim–Kopecká–
  Müller 81–94; Testa–Várilly–Velasco 95–107; Tignol–
  Wadsworth 109–148). No arXiv version (API: 0 results);
  no trace in author bibliographies or secondary
  citations. Internal corroboration: the numeric chain
  does not even reduce — 3.4 − 4/3 = 2.06667 and
  1 − (1 + 13/4)e^{−13/4} = 0.83521, NEITHER = 2.977412,
  which has no in-repo origin (grep: only the plan text
  itself). The whole chain is RETRACTED. (First: the 9.45/
  46%/61.9x CT-2 fabrication, corrected 0283; second:
  arXiv:2608.05281 misattribution, corrected 0307; third:
  here.)
* **CORRECT SCOPE, THEN VERDICT:** 17/33 is **PRZZ
  Theorem 4.1 Case 1** (generic coefficients, error
  T^{3/20}N^{33/20} + N^{1/2}T^{1/2+eps} = o(T) iff
  θ < 17/33) — in-tree at LevWall6.przzGeneric, NOT a CGG
  result. The face-local lever hypothesis ("a 17/33-style
  bound could close the face without moving the wall") is
  **STRUCTURALLY DEAD** (audit parity with M6/0285/
  0284): every PRZZ family (17/33, 9/17, 6/11, 4/7) is a
  Levinson second-moment asymptotic → proportion-only
  output → face-blind by construction; density bounds
  cannot localize (0285); the 0276 gate's pointwise
  consumer is already closed (0278/CT-3/CT-4/0284).
* **MECHANISM FACE-SENSITIVITY MAP (new register):**
  face-SENSITIVE: pointwise S bounds (CGG-2006 4.2694 =
  DIFFERENT OBJECT, value-scale, h ≤ √t; under RH the S-
  route IS the zero count and the first moment stands —
  the circularity is VACUITY, not margin [0283]);
  zero-free regions (K-V ≈ 0.9999988 at tPT2, face mirror
  0.874773 out of reach [0285]); CERTIFIED WINDOWS (the
  only ACTIVE face machine — shrinks, never closes).
  face-BLIND: all proportion machinery (Levinson ladder,
  ALL PRZZ families, Kintali 29/50, Claude 2/3
  [formal-in-tree since 0308], Lamzouri, Cobeli–
  Zaharescu) + all gap/count machinery (CGGGH-1985 71%
  [Tao 2019-05-08], Bredberg 2.766 RH, GRH 3.07, CGG gap
  note 0.5155/2.6950 RH, zero-density 0285). Operational
  consequence: no known mathematics closes the face.
* **HONESTY PATCH (in-tree):** `T4OffLQ.lean` CT-1
  docstring carried the 0283-SUPERSEDED "2.21x sharper
  under RH / 46% below / 20.6 over 52" phrasing — patched
  to the 0283-corrected frame (264.2433 requirement;
  37.3% below first moment 421.6058; family floor
  1106.18 4.19x; realized 1.087–1.722x; CGG 4.2694 =
  different object; vacuity-under-RH). Code constants
  UNTOUCHED (always correct). **T4OffLQ GREEN (8738).**
* **M5 — WINDOW 6 LANDED AND CERTIFIED (the CLEANEST window
  of the chain):** a = 12,363,153,537,128 (= CE5's final b,
  no snap at either endpoint), b = 12,363,153,557,128,
  M = 60, C_R = 1, 28 workers, 34,159 evals, 2666.1 s.
  **b − a = 20,000 zeros, all simple, on the line.**
  Rosser-block exceptions: **NONE** (rosser_failures = []
  and rescued = []; windows 2/3/4/5 each had one rescued
  exception). Runs 45/44 (K = 12). Verifier CERTIFIED:
  true, roesser_failures_inside = 0, sign_changes = 20,000
  = b − a, turing_ok. Seam: g_a6 BIT-IDENTICAL to CE5's
  g_b5. g_b6 = 3,000,175,360,835.7184258… (frac 0.7183,
  dist 0.2817 to next integer).
* **CE6** (`formal/RhAttack/CE6.lean`, **GREEN 8771 jobs,
  first attempt**): tCE6 = **3,000,175,360,835**;
  faceShrinkCE6 = **4,673**; above H0 by **28,035**;
  band of six windows → allOnLineUpToCE6;
  rh_reanchored_CE6: RH ↔ terminalFaceCE6 (cited
  census); rh_of_terminalFaceCE6 = final named step (no
  closing supplied); terminalFaceCE6_of_thetaInf. Full
  tree green (re-verified this unit).
* **Chain:** certified zeros over (g_a1, g_b6] =
  20,000 + 19,999 + 19,999 + 20,000 + 20,000 + 20,000 =
  **119,998**.

Wall UNMOVED. Face OPEN at tCE6. NO RH CLAIM.
(discovery 0309)

## 41 · 0310 — DOORS MEET: BG 2017 PRIMARY RE-READ (2026-11-14)

* **PRIMARY (arXiv:1604.02740 = Bettin–Gonek, Mathematika
  63 (2017) 29–33, read in full):** (1.1) I_N(T1,T2) =
  ∫|M_N(1/2+it)|²|ζ(1/2+it)|² dt, M_N = the LEVINSON
  mollifier Σ μ(n) n^{-s}(1 − log n/log N). Theorem 1
  (PROVEN in BG 2017 = [BG-T1-ARB] in-tree): antecedent
  I_N(0,T) ≪_ε T^{1+eps} on 2 ≤ N ≤ T^θ ⇒ zero-free
  Re s > 1/2 + 1/(2θ); "In particular ... θ arbitrarily
  large ⇒ RH." THE PAPER'S OWN CITATION RECORD for the
  antecedent's reach: Levinson: (1.2) for 0 < θ < 1/2;
  **CONREY: "(1.2) (with a slightly different mollifier)
  remains valid for θ < 4/7, and thereby deduced that
  κ > 2/5"**; Farmer: θ=∞ conjecture + (1.2)@all θ ⇒
  κ=1; Radziwiłł: M_{T^θ} essentially best possible
  (κ=1 needs θ arbitrarily large). BG 2017 proves NO
  antecedent past 4/7 — only the implication.
* **THE DOORS MEET (machine, new module LevWall9 GREEN
  8771; full tree 17454):** door 2's published reach is
  Conrey's 4/7 — the SAME (1.2) family that pins door 1.
  `door2ReachIsDoor1Wall : bgConreyReach = LevWall8.
  fullWall`; `door2ResidualIsDoor1Wall : (4/7 : ℝ) < θ
  ↔ θ ∈ LevWall.levWallGap` — the two doors have the
  SAME open set {θ | 4/7 < θ}, machinically. κ-ladder
  bottom rung added: conreyKappa := 2/5 < 417/1000 <
  PRZZ 0.417293962.
* **NAMED HONESTY GAP [DIAG-RANGE]** (the real in-tree
  objects): `diagToRange θ : LevWall.levWallAt θ →
  ThetaInf.thetaBounded θ` — diagonal (1.2)@θ ⇒ range
  antecedent at θ (standard dyadic-in-N + small-N
  second-moment argument; NOT proven in-tree; NOT a
  theorem in BG 2017; moves nothing past 4/7).
  Housekeeping wire for 0311-plus: [DIAG-RANGE]@1/2 +
  [BG-T1] ⇒ zero-free Re s > 3/5 in-tree (the classical
  Levinson region, wired through the door-2 machinery) —
  formalization completeness only, red line.
  **[CORRECTED 0312/LevWall10: arithmetic error in this
  sketch — BG Theorem 1 at θ = 1/2 gives boundary
  Re s > 3/2, NOT 3/5 (3/5 ↔ θ = 5, unpublished, inside the
  wall); the reachable family at published reach θ < 4/7 has
  best boundary 19/16 > 1, strictly INSIDE the classically
  zero-free Re s ≥ 1; the wire landed in LevWall10 with the
  corrected numerals — formalization completeness, red line
  unchanged.]**
* **Face menu (complete, unchanged):** door 1/2 = θ >
  4/7 (same wall, two shapes); door 3 = M5 certification
  (active, shrinking, at tCE6); door 4 = θInf (0290
  conditional wire).

Wall UNMOVED at 4/7 (both doors pinned at the primary).
Face OPEN. NO RH CLAIM. (discovery 0310)

## 42 · 0311 — M5 WINDOW 7 CERTIFIED + CE7 RE-ANCHOR (2026-11-14)

* **Window 7 (in-house, seamless):** a = 12,363,153,557,128
  (= window 6's b), b = a + 20,000, no snap at either
  endpoint, M = 60, C_R = 1, 34,213 evaluations in 2606.0 s,
  N_range = [691008, 691008]. Certificate window7_b7.json:
  **b − a = 20,000 zeros, all simple and on the line** in
  (g_a7, g_b7], g_a7 = 3,000,175,360,835.718425833876 ±
  1.29e-26 (**bit-identical** dyadic ball to window 6's
  g_b6), g_b7 = 3,000,175,365,508.653559473769... ± 1.29e-26
  (floor distance 0.3464 - robust).
* **Verifier:** CERTIFIED true, 34,213 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs
  50/53 ≥ K = 12, turing_ok, 0 cross-check failures, 0
  undetermined signs. **Two Rosser rescue exceptions**
  (blocks [..570227, ..570230] → union quota 6 = 6;
  [..576544, ..576546] → union quota 5 = 5) — the same
  documented 3-block union mechanism as windows 2/3/4/5;
  zeros displaced into adjacent Gram intervals; only the
  window total and the end runs enter the Turing step —
  recorded, not suppressed.
* **Formal (CE7.lean, GREEN 8772; full tree 17454, oolean
  freshness verified):** gB7Lo := 3000175365508653/1000,
  tCE7 := 3,000,175,365,508; faceShrinkCE7 = 4673;
  frontierGapAboveH0 = 32,708; bandOfWindows7 (seven-way);
  rh_reanchored_CE7: under [Z-PT2] + the seven cited window
  clauses, RH q ↔ terminalFaceCE7 q; rh_of_terminalFaceCE7
  (the final named step — no closing supplied);
  terminalFaceCE7_of_thetaInf (M2 lane lands at tCE7).
* **Frontier:** certified zeros over (g_a1, g_b7] =
  20,000 + 19,999 + 19,999 + 20,000 × 4 = 139,998. Chain
  integrity 1→7: every seam bit-identical (exact dyadic
  tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE7.
NO RH CLAIM. (discovery 0311)

## 43 · 0312 — THE DOOR-2 WIRE, LANDED IN-TREE WITH CORRECTED
NUMERALS (2026-11-14)

* **LevWall10 GREEN 8772 (full tree 17454, oolean fresh):**
  the door-2 wire parameterized and machine —
  `door2Wire`: [thetaBounded θ] + [bgThetaShrink θ] (Z78
  cited inputs) ⇒ zero-free Re s > 1/2 + 1/(2θ) (right
  flank, BG Thm 1 verbatim) and mirror
  `door2WireLeft` (left flank, functional-equation
  reflection); `door2WireAt12` states the θ = 1/2
  corollary at its CORRECT boundary 3/2.
* **Reach numerics (machine):** best reachable boundary
  = 1/2 + 7/8 = 19/16 (θ → 4/7⁻ limit of 1/(2θ));
  `boundaryLadder : 1 < 19/16 < 3/2`;
  `reachableInsideTrivialRegion : 1 < 19/16` — the ENTIRE
  reachable family sits strictly inside the elementarily
  zero-free Re s ≥ 1 (Hadamard–de la Vallée Poussin / Pólya,
  cited).
* **Non-vacuity is past the wall (machine + record):**
  non-vacuity against the classical boundary
  1 − c/((log t)^{2/3}(log log t)^{1/3}) (c = 1/2π;
  0.98599645 at t = 3e9) needs 1/2 + 1/(2θ) < 0.98599645,
  i.e. θ > 1.0288; `nonvacuousPastWall : θ > 1 ⇒ θ ∈
  levWallGap` — the ENTIRE non-vacuous territory of BG
  Thm 1 lies inside the unified wall. Door 2's machinery
  has NO partial value at the published frontier: all-or-
  nothing at the wall, like door 1.
* **CORRECTION (honesty):** the 0310/0311 sketch
  "[DIAG-RANGE]@1/2 + [BG-T1] ⇒ Re s > 3/5" carried an
  arithmetic error — at θ = 1/2 the boundary is 1/2 + 1 =
  3/2, NOT 3/5 (3/5 ↔ θ = 5, unpublished, deep in the
  wall); the genuine Levinson-1949 region 1/2 + 0.08662…
  is a DIFFERENT theorem (Levinson's direct argument), not
  a BG-Thm-1 product, and is not in-tree. Sketch patched in
  0310/0311 + docs with [CORRECTED 0312] markers;
  corrected numerals machine-landed here. (norm_num also
  caught a reversed boundary ordering in the first draft —
  19/16 = 1.1875 < 3/2 = 1.5.)

Wall UNMOVED; face OPEN at tCE7. NO RH CLAIM.
(discovery 0312)

## 44 · 0313 — M5 WINDOW 8 CERTIFIED + CE8 RE-ANCHOR (2026-11-14)

* **Window 8 (in-house, seamless):** a = 12,363,153,577,128
  (= window 7's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (a + 20,000 not a good Gram
  point; a needed no snap), M = 60, C_R = 1, 32,867
  evaluations in 2464.2 s, N_range = [691008, 691008].
  Certificate window8_b8.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a8, g_b8], g_a8 =
  3,000,175,365,508.653559473769 ± 1.29e-26 (bit-identical
  dyadic ball to window 7's g_b7), g_b8 = 3,000,175,
  370,181.355046086348... ± 1.29e-26 (floor distance 0.6450
  - robust).
* **Verifier:** CERTIFIED true, 32,867 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 45/49 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as window 6), 0 cross-check failures, 0
  undetermined signs.
* **Formal (CE8.lean, GREEN 8773; full tree 17454, oolean
  fresh):** gB8Lo := 300017537018135/100, tCE8 :=
  3,000,175,370,181; faceShrinkCE8 = 4673;
  frontierGapAboveH0 = 37,381; bandOfWindows8 (eight-way);
  rh_reanchored_CE8: under [Z-PT2] + the eight cited window
  clauses, RH q ↔ terminalFaceCE8 q; rh_of_terminalFaceCE8
  (final named step — no closing supplied);
  terminalFaceCE8_of_thetaInf (M2 lane lands at tCE8).
* **Frontier:** certified zeros over (g_a1, g_b8] =
  20,000 + 19,999 + 19,999 + 20,000 × 3 + 20,000 + 19,999 =
  159,997. Chain integrity 1→8: every seam bit-identical
  (exact dyadic tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7 (both doors pinned, 0310-0312); face
OPEN / PROBABLY TRUE at tCE8. NO RH CLAIM.
(discovery 0313)

## 45 · 0314 — M5 WINDOW 9 CERTIFIED + CE9 RE-ANCHOR (2026-11-14)

* **Window 9 (in-house, seamless):** a = 12,363,153,597,127
  (= window 8's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 34,206 evaluations in 2619.8 s,
  N_range = [691008, 691008]. Certificate window9_b9.json:
  **b − a = 20,000 zeros, all simple and on the line** in
  (g_a9, g_b9], g_a9 = 3,000,175,370,181.355046086348 ±
  1.29e-26 (bit-identical dyadic ball to window 8's g_b8),
  g_b9 = 3,000,175,374,854.290179184949 ± 1.29e-26 (floor
  distance 0.7098; gB9Lo bottom margin 1.79e-4 — still 25+
  orders above the radius).
* **Verifier:** CERTIFIED true, 34,206 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 45/49 ≥
  K = 12, turing_ok. **Two Rosser rescue exceptions**
  (blocks [..603657, ..603660] → union quota 5 = 5;
  [..611231, ..611233] → union quota 5 = 5) — the same
  documented 3-block union mechanism as windows 2/3/4/5/7;
  zeros displaced into adjacent Gram intervals; only the
  window total and the end runs enter the Turing step —
  recorded, not suppressed.
* **Formal (CE9.lean, GREEN 8774; full tree 17454, oolean
  fresh):** gB9Lo := 300017537485429/100, tCE9 :=
  3,000,175,374,854; faceShrinkCE9 = 4673;
  frontierGapAboveH0 = 42,054; bandOfWindows9 (nine-way);
  rh_reanchored_CE9: under [Z-PT2] + the nine cited window
  clauses, RH q ↔ terminalFaceCE9 q; rh_of_terminalFaceCE9
  (final named step — no closing supplied);
  terminalFaceCE9_of_thetaInf (M2 lane lands at tCE9).
* **Frontier:** certified zeros over (g_a1, g_b9] =
  179,997. Chain integrity 1→9: every seam bit-identical
  (exact dyadic tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE9.
NO RH CLAIM. (discovery 0314)

## 46 · 0315 — M5 WINDOW 10 CERTIFIED + CE10 RE-ANCHOR (2026-11-14)

* **Window 10 (in-house, seamless):** a = 12,363,153,617,127
  (= window 9's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,372 evaluations in 2572.5 s,
  N_range = [691008, 691008]. Certificate window10_b10.json:
  **b − a = 20,000 zeros, all simple and on the line** in
  (g_a10, g_b10], g_a10 = 3,000,175,374,854.290179184949 ±
  1.29e-26 (bit-identical dyadic ball to window 9's g_b9),
  g_b10 = 3,000,175,379,527.225312012897 ± 1.29e-26 (floor
  distance 0.7747).
* **Verifier:** CERTIFIED true, 33,372 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 50/46 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6 and 8), 0 cross-check failures, 0
  undetermined signs.
* **Formal (CE10.lean, GREEN 8775; full tree 17454, oolean
  fresh):** gB10Lo := 300017537952722/100, tCE10 :=
  3,000,175,379,527; faceShrinkCE10 = 4673;
  frontierGapAboveH0 = 46,727; bandOfWindows10 (ten-way);
  rh_reanchored_CE10: under [Z-PT2] + the ten cited window
  clauses, RH q ↔ terminalFaceCE10 q; rh_of_terminalFaceCE10
  (final named step — no closing supplied);
  terminalFaceCE10_of_thetaInf (M2 lane lands at tCE10).
* **Frontier:** certified zeros over (g_a1, g_b10] =
  199,997 — the chain has now certified just under 200,000
  consecutive on-line zeros just above the Platt–Trudgian H0
  frontier. Chain integrity 1→10: every seam bit-identical
  (exact dyadic tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE10.
NO RH CLAIM. (discovery 0315)

## 47 · 0316 — M5 WINDOW 11 CERTIFIED + CE11 RE-ANCHOR (2026-11-14)

* **Window 11 (in-house, seamless):** a = 12,363,153,637,127
  (= window 10's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (a + 20,000 not a good Gram
  point; a needed no snap), M = 60, C_R = 1, 33,310
  evaluations in 2536.6 s, N_range = [691008, 691008].
  Certificate window11_b11.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a11, g_b11], g_a11 =
  3,000,175,379,527.225312012897 ± 1.29e-26 (bit-identical
  to window 10's g_b10), g_b11 = 3,000,175,384,199.
  926797813571 ± 1.29e-26 (floor tCE11 sits 0.9268 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,310 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 46/51 ≥
  K = 12, turing_ok. **One Rosser rescue exception**
  (block [..644976, ..644979] → union quota 7 = 7) — the
  same documented 3-block union mechanism; recorded, not
  suppressed.
* **Formal (CE11.lean, GREEN 8776; full tree 17454, oolean
  fresh):** gB11Lo := 300017538419992/100, tCE11 :=
  3,000,175,384,199; faceShrinkCE11 = **4672** (the first
  4672 in the chain — this window carried 19,999 zeros);
  frontierGapAboveH0 = 51,399; bandOfWindows11
  (eleven-way); rh_reanchored_CE11: under [Z-PT2] + the
  eleven cited window clauses, RH q ↔ terminalFaceCE11 q;
  rh_of_terminalFaceCE11 (final named step — no closing
  supplied); terminalFaceCE11_of_thetaInf (M2 lane lands at
  tCE11).
* **Frontier:** certified zeros over (g_a1, g_b11] =
  219,996. Chain integrity 1→11: every seam bit-identical
  (exact dyadic tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE11.
NO RH CLAIM. (discovery 0316)

## 48 · 0317 — M5 WINDOW 12 CERTIFIED + CE12 RE-ANCHOR (2026-11-14)

* **Window 12 (in-house, seamless):** a = 12,363,153,657,126
  (= window 11's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,371 evaluations in 2555.6
  s, N_range = [691008, 691008]. Certificate
  window12_b12.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a12, g_b12], g_a12 =
  3,000,175,384,199.926797813571 ± 1.29e-26 (bit-identical
  dyadic ball to window 11's g_b11), g_b12 =
  3,000,175,388,872.861930100227 ± 1.29e-26 (floor tCE12
  sits 0.8619 above the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,371 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 46/47 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6, 8 and 10), 0 cross-check failures,
  0 undetermined signs.
* **Formal (CE12.lean, GREEN 8777; full tree 17454, oolean
  fresh):** gB12Lo := 300017538887286/100, tCE12 :=
  3,000,175,388,872; faceShrinkCE12 = 4673;
  frontierGapAboveH0 = 56,072; bandOfWindows12 (twelve-way);
  rh_reanchored_CE12: under [Z-PT2] + the twelve cited
  window clauses, RH q ↔ terminalFaceCE12 q;
  rh_of_terminalFaceCE12 (final named step — no closing
  supplied); terminalFaceCE12_of_thetaInf (M2 lane lands at
  tCE12).
* **Frontier:** certified zeros over (g_a1, g_b12] =
  239,996 - the chain has now certified just under 240,000
  consecutive on-line zeros just above the Platt–Trudgian
  H0 frontier. Chain integrity 1→12: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE12.
NO RH CLAIM. (discovery 0317)

## 49 · 0318 — M5 WINDOW 13 CERTIFIED + CE13 RE-ANCHOR
(2026-11-14)

* **Window 13 (in-house, seamless):** a = 12,363,153,677,126
  (= window 12's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,978 evaluations in 2613.7
  s, N_range = [691008, 691008]. Certificate
  window13_b13.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a13, g_b13], g_a13 =
  3,000,175,388,872.861930100227 ± 1.29e-26 (bit-identical
  dyadic ball to window 12's g_b12), g_b13 =
  3,000,175,393,545.797062116230 ± 1.29e-26 (floor tCE13
  sits 0.7971 above the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,978 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 44/48 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6, 8, 10 and 12), 0 cross-check
  failures, 0 undetermined signs.
* **Formal (CE13.lean, GREEN 8778; full tree 17454, oolean
  fresh):** gB13Lo := 300017539354579/100, tCE13 :=
  3,000,175,393,545; faceShrinkCE13 = 4673;
  frontierGapAboveH0 = 60,745; bandOfWindows13
  (thirteen-way); rh_reanchored_CE13: under [Z-PT2] + the
  thirteen cited window clauses, RH q ↔ terminalFaceCE13 q;
  rh_of_terminalFaceCE13 (final named step — no closing
  supplied); terminalFaceCE13_of_thetaInf (M2 lane lands at
  tCE13).
* **Frontier:** certified zeros over (g_a1, g_b13] =
  **259,996** — the chain has now certified a quarter
  million consecutive on-line zeros just above the
  Platt–Trudgian H0 frontier. Chain integrity 1→13: every
  seam bit-identical (exact dyadic tuples), N_range
  constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE13.
NO RH CLAIM. (discovery 0318)

## 50 · 0319 — M5 WINDOW 14 CERTIFIED + CE14 RE-ANCHOR
(2026-11-14)

* **Window 14 (in-house, seamless):** a = 12,363,153,697,126
  (= window 13's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,414 evaluations in 2536.0
  s, N_range = [691008, 691008]. Certificate
  window14_b14.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a14, g_b14], g_a14 =
  3,000,175,393,545.797062116230 ± 1.29e-26 (bit-identical
  dyadic ball to window 13's g_b13), g_b14 =
  3,000,175,398,218.732193861580 ± 1.29e-26 (floor tCE14
  sits 0.7322 above the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,414 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 49/44 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6, 8, 10, 12 and 13), 0 cross-check
  failures, 0 undetermined signs.
* **Formal (CE14.lean, GREEN 8779; full tree 17454, oolean
  fresh):** gB14Lo := 300017539821873/100, tCE14 :=
  3,000,175,398,218; faceShrinkCE14 = 4673;
  frontierGapAboveH0 = 65,418; bandOfWindows14
  (fourteen-way); rh_reanchored_CE14: under [Z-PT2] + the
  fourteen cited window clauses, RH q ↔ terminalFaceCE14
  q; rh_of_terminalFaceCE14 (final named step — no closing
  supplied); terminalFaceCE14_of_thetaInf (M2 lane lands at
  tCE14). (Process note: the CE14 draft initially dropped
  the CE2 import; caught by the first build, fixed before
  the green - the committed file is green at 8779.)
* **Frontier:** certified zeros over (g_a1, g_b14] =
  279,996. Chain integrity 1→14: every seam bit-identical
  (exact dyadic tuples), N_range constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE14.
NO RH CLAIM. (discovery 0319)

## 51 · 0320 — M5 WINDOW 15 CERTIFIED + CE15 RE-ANCHOR
(2026-11-14)

* **Window 15 (in-house, seamless):** a = 12,363,153,717,126
  (= window 14's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,213 evaluations in 2492.2
  s, N_range = [691008, 691008]. Certificate
  window15_b15.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a15, g_b15], g_a15 =
  3,000,175,398,218.732193861580 ± 1.29e-26 (bit-identical
  dyadic ball to window 14's g_b14), g_b15 =
  3,000,175,402,891.667325336277 ± 1.29e-26 (floor tCE15
  sits 0.6673 above the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,213 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 49/50 ≥
  K = 12, turing_ok. **Two Rosser rescue exceptions**
  (5 = 5, 5 = 5; union quotas met) — the same documented
  3-block union mechanism (windows 2/3/4/5/7/9/11);
  recorded, not suppressed.
* **Formal (CE15.lean, GREEN 8780; full tree 17454, oolean
  fresh):** gB15Lo := 300017540289166/100, tCE15 :=
  3,000,175,402,891; faceShrinkCE15 = 4673;
  frontierGapAboveH0 = 70,091; bandOfWindows15 (fifteen-way);
  rh_reanchored_CE15: under [Z-PT2] + the fifteen cited
  window clauses, RH q ↔ terminalFaceCE15 q;
  rh_of_terminalFaceCE15 (final named step — no closing
  supplied); terminalFaceCE15_of_thetaInf (M2 lane lands at
  tCE15).
* **Frontier:** certified zeros over (g_a1, g_b15] =
  **299,996** — the chain has now certified three hundred
  thousand minus 4 consecutive on-line zeros just above the
  Platt–Trudgian H0 frontier. Chain integrity 1→15: every
  seam bit-identical (exact dyadic tuples), N_range
  constant, C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE15.
NO RH CLAIM. (discovery 0320)

## 52 · 0321 — M5 WINDOW 16 CERTIFIED + CE16 RE-ANCHOR
(2026-11-14)

* **Window 16 (in-house, seamless):** a = 12,363,153,737,126
  (= window 15's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,552 evaluations in 2533.3
  s, N_range = [691008, 691008]. Certificate
  window16_b16.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a16, g_b16], g_a16 =
  3,000,175,402,891.667325336277 ± 1.29e-26 (bit-identical
  dyadic ball to window 15's g_b15), g_b16 =
  3,000,175,407,564.602456540321 ± 1.29e-26 (floor tCE16
  sits 0.6025 above the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,552 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 50/47 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6, 8, 10, 12, 13 and 14), 0
  cross-check failures, 0 undetermined signs.
* **Formal (CE16.lean, GREEN 8781; full tree 17454, oolean
  fresh):** gB16Lo := 300017540756460/100, tCE16 :=
  3,000,175,407,564; faceShrinkCE16 = 4673;
  frontierGapAboveH0 = 74,764; bandOfWindows16
  (sixteen-way); rh_reanchored_CE16: under [Z-PT2] + the
  sixteen cited window clauses, RH q ↔ terminalFaceCE16
  q; rh_of_terminalFaceCE16 (final named step — no closing
  supplied); terminalFaceCE16_of_thetaInf (M2 lane lands at
  tCE16).
* **Frontier:** certified zeros over (g_a1, g_b16] =
  **319,996** — the chain has now certified 320,000 minus 4
  consecutive on-line zeros just above the Platt–Trudgian
  H0 frontier. Chain integrity 1→16: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE16.
NO RH CLAIM. (discovery 0321)

## 53 · 0322 — M5 WINDOW 17 CERTIFIED + CE17 RE-ANCHOR
(2026-11-14)

* **Window 17 (in-house, seamless):** a = 12,363,153,757,126
  (= window 16's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (12,363,153,777,126 not a good
  Gram point; a needed no snap), M = 60, C_R = 1, 34,926
  evaluations in 2692.9 s, N_range = [691008, 691008].
  Certificate window17_b17.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a17, g_b17], g_a17 =
  3,000,175,407,564.602456540321 ± 1.29e-26 (bit-identical
  to window 16's g_b16), g_b17 = 3,000,175,412,237.
  303940717172 ± 1.29e-26 (floor tCE17 sits 0.3039 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 34,926 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 49/46 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to a
  WIDER union ([..763962, ..763965] → [..763959,
  ..763966], need 7 = found 7, m = 2) — the union
  refinement with the quota still met by the union recount;
  recorded, not suppressed.
* **Formal (CE17.lean, GREEN 8782; full tree 17454, oolean
  fresh):** gB17Lo := 300017541223730/100, tCE17 :=
  3,000,175,412,237; faceShrinkCE17 = 4673 (span; the
  window carried 19,999 zeros — the floor did not move with
  the snap); frontierGapAboveH0 = 79,437;
  bandOfWindows17 (seventeen-way); rh_reanchored_CE17:
  under [Z-PT2] + the seventeen cited window clauses, RH q
  ↔ terminalFaceCE17 q; rh_of_terminalFaceCE17 (final named
  step — no closing supplied);
  terminalFaceCE17_of_thetaInf (M2 lane lands at tCE17).
* **Frontier:** certified zeros over (g_a1, g_b17] =
  **339,995**. Chain integrity 1→17: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE17.
NO RH CLAIM. (discovery 0322)

## 54 · 0323 — M5 WINDOW 18 CERTIFIED + CE18 RE-ANCHOR
(2026-11-15)

* **Window 18 (in-house, seamless):** a = 12,363,153,777,125
  (= window 17's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (12,363,153,797,125 not a good
  Gram point; a needed no snap), M = 60, C_R = 1, 33,068
  evaluations in 2447.2 s, N_range = [691008, 691008].
  Certificate window18_b18.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a18, g_b18], g_a18 =
  3,000,175,412,237.303940717172 ± 1.29e-26 (bit-identical
  to window 17's g_b17), g_b18 = 3,000,175,416,910.
  005424623397 ± 1.29e-26.
* **NEW CASING (documented):** g_b18 sits only 5.4e-3 above
  the previous integer, so the usual two-decimal lower-bound
  rounding would collide with the floor. CE18 uses a
  THREE-decimal certified lower bound instead (gB18Lo =
  3,000,175,416,910.005, margin 4.2e-4; tCE18 sits 5e-3
  below gB18Lo; floor robust to the radius by ~4 × 10^22).
* **Verifier:** CERTIFIED true, 33,068 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 48/48 ≥
  K = 12, turing_ok, **ZERO Rosser exceptions** (clean
  window, as windows 6, 8, 10, 12, 13, 14 and 16).
* **Formal (CE18.lean, GREEN 8783; full tree 17454, oolean
  fresh):** gB18Lo := 3000175416910005/1000 (3-decimal),
  tCE18 := 3,000,175,416,910; faceShrinkCE18 = 4673;
  frontierGapAboveH0 = 84,110; bandOfWindows18
  (eighteen-way); rh_reanchored_CE18: under [Z-PT2] + the
  eighteen cited window clauses, RH q ↔ terminalFaceCE18
  q; rh_of_terminalFaceCE18 (final named step — no closing
  supplied); terminalFaceCE18_of_thetaInf (M2 lane lands at
  tCE18).
* **Frontier:** certified zeros over (g_a1, g_b18] =
  **359,994**. Chain integrity 1→18: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE18.
NO RH CLAIM. (discovery 0323)

## 55 · 0324 — M5 WINDOW 19 CERTIFIED + CE19 RE-ANCHOR
(2026-11-15)

* **Window 19 (in-house, seamless):** a = 12,363,153,797,124
  (= window 18's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (12,363,153,817,124 not a good
  Gram point; a needed no snap), M = 60, C_R = 1, 33,237
  evaluations in 2476.0 s, N_range = [691008, 691008].
  Certificate window19_b19.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a19, g_b19], g_a19 =
  3,000,175,416,910.005424623397 ± 1.29e-26 (bit-identical
  to window 18's g_b18), g_b19 = 3,000,175,421,582.
  706908258997 ± 1.29e-26 (floor tCE19 sits 0.7069 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,237 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 47/45 ≥
  K = 12, turing_ok. **One Rosser rescue exception**
  (4 = 4; union quota met) — the documented 3-block union
  mechanism; recorded, not suppressed.
* **Formal (CE19.lean, GREEN 8784; full tree 17454, oolean
  fresh):** gB19Lo := 300017542158270/100, tCE19 :=
  3,000,175,421,582; faceShrinkCE19 = **4672** (the
  second 4672 in the chain — this window carried 19,999
  zeros); frontierGapAboveH0 = 88,782; bandOfWindows19
  (nineteen-way); rh_reanchored_CE19: under [Z-PT2] + the
  nineteen cited window clauses, RH q ↔ terminalFaceCE19
  q; rh_of_terminalFaceCE19 (final named step — no closing
  supplied); terminalFaceCE19_of_thetaInf (M2 lane lands at
  tCE19).
* **Frontier:** certified zeros over (g_a1, g_b19] =
  **379,993**. Chain integrity 1→19: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE19.
NO RH CLAIM. (discovery 0324)

## 56 · 0325 — M5 WINDOW 20 CERTIFIED + CE20 RE-ANCHOR
(2026-11-15) — **MILESTONE: the 20-window chain**

* **Window 20 (in-house, seamless):** a = 12,363,153,817,123
  (= window 19's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 34,270 evaluations in 2593.9
  s, N_range = [691008, 691008]. Certificate
  window20_b20.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a20, g_b20], g_a20 =
  3,000,175,421,582.706908258997 ± 1.29e-26 (bit-identical
  to window 19's g_b19), g_b20 = 3,000,175,426,255.
  642038380470 ± 1.29e-26 (floor tCE20 sits 0.6420 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 34,270 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 49/51 ≥
  K = 12, turing_ok. **One Rosser rescue exception**
  (4 = 4; union quota met) — the documented 3-block union
  mechanism; recorded, not suppressed.
* **Formal (CE20.lean, GREEN 8785; full tree 17454, oolean
  fresh):** gB20Lo := 300017542625564/100, tCE20 :=
  3,000,175,426,255; faceShrinkCE20 = 4673;
  frontierGapAboveH0 = 93,455; bandOfWindows20 (twenty-way);
  rh_reanchored_CE20: under [Z-PT2] + the twenty cited
  window clauses, RH q ↔ terminalFaceCE20 q;
  rh_of_terminalFaceCE20 (final named step — no closing
  supplied); terminalFaceCE20_of_thetaInf (M2 lane lands at
  tCE20).
* **Frontier:** certified zeros over (g_a1, g_b20] =
  **399,993** (20,000 in 13 windows, 19,999 in the seven
  snap-trimmed windows 2, 3, 8, 11, 17, 18, 19).
* **MILESTONE:** the in-house M5 machine has now produced
  and verified **twenty consecutive seamless certificates**
  above the Platt–Trudgian H0 frontier — bit-identical
  seams throughout, N_range constant, one verifier pass per
  window. The wall behavior per window is unchanged: the
  face shrinks 4,672–4,673 units; the (1.2) wall at 4/7 is
  UNMOVED on both doors. The program is stable and
  automatable; the analytic gap is unchanged.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE20.
NO RH CLAIM. (discovery 0325)

## 57 · 0326 — M5 WINDOW 21 CERTIFIED + CE21 RE-ANCHOR
(2026-11-15)

* **Window 21 (in-house, seamless):** a = 12,363,153,837,123
  (= window 20's b), b_requested = a + 20,000, driver
  snapped final b DOWN ONE (12,363,153,857,123 not a good
  Gram point; a needed no snap), M = 60, C_R = 1, 33,566
  evaluations in 2574.1 s, N_range = [691008, 691008].
  Certificate window21_b21.json: **b − a = 19,999 zeros,
  all simple and on the line** in (g_a21, g_b21], g_a21 =
  3,000,175,426,255.642038380470 ± 1.29e-26 (bit-identical
  to window 20's g_b20), g_b21 = 3,000,175,430,928.
  343521474804 ± 1.29e-26 (floor tCE21 sits 0.3435 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,566 points,
  sign_changes_inside = 19,999 = b − a, Rosser runs 45/47 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to a
  WIDER union ([..847076, ..847079] → [..847075, ..847081],
  need 6 = found 6, m = 2) — quota met by the union
  recount; recorded, not suppressed.
* **Formal (CE21.lean, GREEN 8786; full tree 17454, oolean
  fresh):** gB21Lo := 300017543092834/100, tCE21 :=
  3,000,175,430,928; faceShrinkCE21 = 4673;
  frontierGapAboveH0 = 98,128 (within 1,872 units of the
  100,000 mark); bandOfWindows21 (twenty-one-way);
  rh_reanchored_CE21: under [Z-PT2] + the twenty-one cited
  window clauses, RH q ↔ terminalFaceCE21 q;
  rh_of_terminalFaceCE21 (final named step — no closing
  supplied); terminalFaceCE21_of_thetaInf (M2 lane lands at
  tCE21).
* **Frontier:** certified zeros over (g_a1, g_b21] =
  **419,992**. Chain integrity 1→21: every seam
  bit-identical (exact dyadic tuples), N_range constant,
  C_R/M constant.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE21.
NO RH CLAIM. (discovery 0326)

## 58 · 0327 — M5 WINDOW 22 CERTIFIED + CE22 RE-ANCHOR
(2026-11-15) — **MILESTONE: the frontier CROSSES 100k above H0**

* **Window 22 (in-house, seamless):** a = 12,363,153,857,122
  (= window 21's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,067 evaluations in 2486.5
  s, N_range = [691008, 691008]. Certificate
  window22_b22.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a22, g_b22], g_a22 =
  3,000,175,430,928.343521474804 ± 1.29e-26 (bit-identical
  to window 21's g_b21), g_b22 = 3,000,175,435,601.
  278651054984 ± 1.29e-26 (floor tCE22 sits 0.2787 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,067 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 49/49 ≥
  K = 12, turing_ok. **CLEAN window** — zero Rosser
  exceptions, zero rescue failures (clean tally now: 6, 8,
  10, 12, 13, 14, 16, 18, 22).
* **Formal (CE22.lean, GREEN 8787; full tree 17454, oolean
  fresh):** gB22Lo := 300017543560127/100, tCE22 :=
  3,000,175,435,601; faceShrinkCE22 = 4673;
  frontierGapAboveH0 = 102,801; **frontierPast100k :
  tCE22 − tPT2 > 100000 (in-tree machine fact)** — the
  100,000-unit mark above the Platt–Trudgian frontier is
  CROSSED at this re-anchor; bandOfWindows22 (twenty-two-way);
  rh_reanchored_CE22: under [Z-PT2] + the twenty-two cited
  window clauses, RH q ↔ terminalFaceCE22 q;
  rh_of_terminalFaceCE22 (final named step — no closing
  supplied); terminalFaceCE22_of_thetaInf (M2 lane lands at
  tCE22).
* **Frontier:** certified zeros over (g_a1, g_b22] =
  **439,992**. Chain integrity 1→22: every seam
  bit-identical, N_range/C_R/M constant. Nine clean windows
  of twenty-two; every rescue (13 of them, incl. window 21's
  wider union 6 = 6) quota-met and recorded.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE22.
NO RH CLAIM. (discovery 0327)

## 59 · 0328 — M5 WINDOW 23 CERTIFIED + CE23 RE-ANCHOR
(2026-11-15)

* **Window 23 (in-house, seamless):** a = 12,363,153,877,122
  (= window 22's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,898 evaluations in 2609.4
  s, N_range = [691008, 691008]. Certificate
  window23_b23.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a23, g_b23], g_a23 =
  3,000,175,435,601.278651054984 ± 1.29e-26 (bit-identical
  to window 22's g_b22), g_b23 = 3,000,175,440,274.
  213780364512 ± 1.29e-26 (floor tCE23 sits 0.2138 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,898 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 49/46 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to
  union ([..886820, ..886823] → [..886819, ..886825],
  need 6 = found 6, m = 4); recorded, not suppressed.
* **Formal (CE23.lean, GREEN 8788; full tree 17454, oolean
  fresh):** gB23Lo := 300017544027421/100, tCE23 :=
  3,000,175,440,274; faceShrinkCE23 = 4673;
  frontierGapAboveH0 = 107,474; frontierPast100k (100k mark
  still crossed); bandOfWindows23 (twenty-three-way);
  rh_reanchored_CE23: under [Z-PT2] + the twenty-three cited
  window clauses, RH q ↔ terminalFaceCE23 q;
  rh_of_terminalFaceCE23 (final named step — no closing
  supplied); terminalFaceCE23_of_thetaInf (M2 lane lands at
  tCE23).
* **Frontier:** certified zeros over (g_a1, g_b23] =
  **459,992**. Chain integrity 1→23: every seam
  bit-identical, N_range/C_R/M constant. Nine clean windows
  of twenty-three.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE23.
NO RH CLAIM. (discovery 0328)

## 60 · 0329 — M5 WINDOW 24 CERTIFIED + CE24 RE-ANCHOR
(2026-11-15)

* **Window 24 (in-house, seamless):** a = 12,363,153,897,122
  (= window 23's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,110 evaluations in 2460.5
  s, N_range = [691008, 691008]. Certificate
  window24_b24.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a24, g_b24], g_a24 =
  3,000,175,440,274.213780364512 ± 1.29e-26 (bit-identical
  to window 23's g_b23), g_b24 = 3,000,175,444,947.
  148909403387 ± 1.29e-26 (floor tCE24 sits 0.1489 above
  the previous integer - robust).
* **Verifier:** CERTIFIED true, 33,110 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 47/53 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to
  union ([..899400, ..899402] → [..899397, ..899404],
  need 7 = found 7, m = 2); recorded, not suppressed.
* **Formal (CE24.lean, GREEN 8789; full tree 17454, oolean
  fresh):** gB24Lo := 300017544494714/100, tCE24 :=
  3,000,175,444,947; faceShrinkCE24 = 4673;
  frontierGapAboveH0 = 112,147; frontierPast100k carried;
  bandOfWindows24 (twenty-four-way); rh_reanchored_CE24:
  under [Z-PT2] + the twenty-four cited window clauses,
  RH q ↔ terminalFaceCE24 q; rh_of_terminalFaceCE24 (final
  named step — no closing supplied);
  terminalFaceCE24_of_thetaInf (M2 lane lands at tCE24).
* **Frontier:** certified zeros over (g_a1, g_b24] =
  **479,992**. Chain integrity 1→24: every seam
  bit-identical, N_range/C_R/M constant. Nine clean windows
  of twenty-four. Window 25 in flight (the 25-window chain
  is imminent).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE24.
NO RH CLAIM. (discovery 0329)

## 61 · 0330 — M5 WINDOW 25 CERTIFIED + CE25 RE-ANCHOR
(2026-11-15) — **MILESTONE: the 25-window chain is complete**

* **Window 25 (in-house, seamless):** a = 12,363,153,917,122
  (= window 24's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,817 evaluations in 2561.0
  s, N_range = [691008, 691008]. Certificate
  window25_b25.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a25, g_b25], g_a25 =
  3,000,175,444,947.148909403387 ± 1.29e-26 (bit-identical
  to window 24's g_b24), g_b25 = 3,000,175,449,620.
  084038171608 ± 1.29e-26 (floor tCE25 sits 0.0840 above
  the previous integer - near the CE18 CASING zone; see
  below).
* **Verifier:** CERTIFIED true, 33,817 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 47/46 ≥
  K = 12, turing_ok. **CLEAN window** — zero exceptions,
  zero failures (clean tally now ten of twenty-five: 6, 8,
  10, 12, 13, 14, 16, 18, 22, 25).
* **CASING (refined):** g_b25's frac 0.0840 is near the
  CE18 zone (0.0054), but the two-decimal lower bound 0.08
  is still strictly below, with margin 4.0e-3 (the certified
  radius 1.29e-26 is 22 orders smaller), so the standard
  bound was ADEQUATE. The 3-decimal rule triggers only
  when round-down would equal the floor (frac < ~0.01).
  Recorded in the CE25 docstring.
* **Formal (CE25.lean, GREEN 8790; full tree 17454, oolean
  fresh):** gB25Lo := 300017544962008/100, tCE25 :=
  3,000,175,449,620; faceShrinkCE25 = 4673;
  frontierGapAboveH0 = 116,820; frontierPast100k carried;
  bandOfWindows25 (twenty-five-way);
  rh_reanchored_CE25: under [Z-PT2] + the twenty-five cited
  window clauses, RH q ↔ terminalFaceCE25 q;
  rh_of_terminalFaceCE25 (final named step — no closing
  supplied); terminalFaceCE25_of_thetaInf (M2 lane lands at
  tCE25).
* **MILESTONE:** certified zeros over (g_a1, g_b25] =
  **499,992** — within EIGHT of the half-million mark.
  Eighteen windows carried 20,000, seven the snapped
  19,999. Chain integrity 1→25: every seam bit-identical,
  N_range/C_R/M constant, ten clean windows. The wall per
  window is UNCHANGED: 4/7 UNMOVED, face 4,672–4,673
  shrink, terminal face now at tCE25 = 3,000,175,449,620
  (116,820 above H0; 125k mark ~2 windows out).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE25.
NO RH CLAIM. (discovery 0330)

## 62 · 0331 — M5 WINDOW 26 CERTIFIED + CE26 RE-ANCHOR
(2026-11-15)

* **Window 26 (in-house, seamless):** a = 12,363,153,937,122
  (= window 25's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,675 evaluations in 2565.8
  s, N_range = [691008, 691008]. Certificate
  window26_b26.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a26, g_b26], g_a26 =
  3,000,175,449,620.084038171608 ± 1.29e-26 (bit-identical
  to window 25's g_b25), g_b26 = 3,000,175,454,293.
  019166669177 ± 1.29e-26 (floor tCE26 sits 0.0192 above
  the previous integer).
* **Verifier:** CERTIFIED true, 33,675 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 50/45 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to
  union ([..947212, ..947214] → [..947211, ..947216],
  need 5 = found 5, m = 4); recorded, not suppressed.
* **CASING (second near-miss):** g_b26's frac 0.0192 is
  above the 0.01 threshold of the refined 0330 rule, so the
  two-decimal bound 0.01 is strictly below with margin
  9.17e-3 (certified radius 1.29e-26 is 21 orders
  smaller) — ADEQUATE, standard bound, no 3-decimal needed.
  (Window 25's frac 0.0840 was the first; this is the
  second near-CASING window in a row — the 0.01 zone is
  being sampled correctly.)
* **Formal (CE26.lean, GREEN 8791; full tree 17454, oolean
  fresh):** gB26Lo := 300017545429301/100, tCE26 :=
  3,000,175,454,293; faceShrinkCE26 = 4673;
  frontierGapAboveH0 = 121,493; frontierPast100k carried;
  bandOfWindows26 (twenty-six-way);
  rh_reanchored_CE26: under [Z-PT2] + the twenty-six cited
  window clauses, RH q ↔ terminalFaceCE26 q;
  rh_of_terminalFaceCE26 (final named step — no closing
  supplied); terminalFaceCE26_of_thetaInf (M2 lane lands at
  tCE26).
* **Frontier:** certified zeros over (g_a1, g_b26] =
  **519,992**. Chain integrity 1→26: every seam
  bit-identical, N_range/C_R/M constant. The 125k mark is
  3,507 units out — window 27 should cross it.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE26.
NO RH CLAIM. (discovery 0331)

## 63 · 0332 — M5 WINDOW 27 CERTIFIED + CE27 RE-ANCHOR
(2026-11-15) — **MILESTONE: the frontier CROSSES 125k above
H0 (and the face shrink is the 4,672 variant)**

* **Window 27 (in-house, seamless):** a = 12,363,153,957,122
  (= window 26's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 34,123 evaluations in 2637.4
  s, N_range = [691008, 691008]. Certificate
  window27_b27.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a27, g_b27], g_a27 =
  3,000,175,454,293.019166669177 ± 1.29e-26 (bit-identical
  to window 26's g_b26), g_b27 = 3,000,175,458,965.
  954294896093 ± 1.29e-26 (floor tCE27 sits 0.9543 above
  the previous integer - the HIGHEST frac in the chain so
  far; robust).
* **NEW BEHAVIOR (4,672 variant):** tCE27 − tCE26 =
  **4,672**, not the running 4,673 - first since the
  windows 2/3/8/11/15/17/18/19 cluster. Cause: g_b27's high
  frac 0.9543 makes the floor jump 4,672 instead of 4,673
  Gram units. Expected floor arithmetic; chain integrity
  UNAFFECTED (seam bit-identical, window total exactly
  b − a).
* **Verifier:** CERTIFIED true, 34,123 points,
  sign_changes_inside = 20,000 = b − a, Rosser runs 51/48 ≥
  K = 12, turing_ok. **One Rosser exception** rescued to
  union ([..965056, ..965059] → [..965055, ..965061],
  need 6 = found 6, m = 4); recorded, not suppressed.
* **Formal (CE27.lean, GREEN 8792; full tree 17454, oolean
  fresh):** gB27Lo := 300017545896595/100, tCE27 :=
  3,000,175,458,965; faceShrinkCE27 = 4672 (the variant,
  cause recorded); frontierGapAboveH0 = 126,165;
  **frontierPast125k : tCE27 − tPT2 > 125000 (in-tree
  MILESTONE fact)** — the 125,000-unit mark above the
  Platt–Trudgian frontier is CROSSED at this re-anchor
  (second round-mark crossing after 100,000 at CE22);
  bandOfWindows27 (twenty-seven-way);
  rh_reanchored_CE27: under [Z-PT2] + the twenty-seven cited
  window clauses, RH q ↔ terminalFaceCE27 q;
  rh_of_terminalFaceCE27 (final named step — no closing
  supplied); terminalFaceCE27_of_thetaInf (M2 lane lands at
  tCE27).
* **Frontier:** certified zeros over (g_a1, g_b27] =
  **539,992**. Chain integrity 1→27: every seam
  bit-identical, N_range/C_R/M constant. Ten clean windows
  of twenty-seven; all rescues quota-met and recorded.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE27
(126,165 above H0, past the 125k mark). NO RH CLAIM.
(discovery 0332)

## 64 · 0333 — M5 WINDOW 28 CERTIFIED + CE28 RE-ANCHOR
(2026-11-15) — **NEW: the first multi-exception window**

* **Window 28 (in-house, seamless):** a = 12,363,153,977,122
  (= window 27's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,787 evaluations in 2582.3
  s, N_range = [691008, 691008]. Certificate
  window28_b28.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a28, g_b28], g_a28 =
  3,000,175,458,965.954294896093 ± 1.29e-26 (bit-identical
  to window 27's g_b27), g_b28 = 3,000,175,463,638.
  889422852356 ± 1.29e-26 (floor tCE28 sits 0.8894 above
  the previous integer - robust).
* **NEW EVENT: THREE Rosser rescues in one window** (first
  multi-exception window): [..983686, ..983689] →
  [..983685, ..983691] (6 = 6, m = 8), [..985487, ..985489]
  → [..985486, ..985490] (4 = 4, m = 8), [..991175,
  ..991177] → [..991174, ..991178] (4 = 4, m = 8). All
  quotas met by the union recounts; all three rescued zeros
  displaced into adjacent Gram intervals WITHIN the same
  window, so the window total (20,000) is unchanged; the
  verifier independently recomputes the window total and
  the two end runs (50/50). All three RECORDED, not
  suppressed. The union mechanism handles multi-rescue
  transparently - the recording convention extends without
  change.
* **Formal (CE28.lean, GREEN 8793; full tree 17454, oolean
  fresh):** gB28Lo := 300017546363888/100, tCE28 :=
  3,000,175,463,638; faceShrinkCE28 = 4673 (running
  pattern RESUMES after window 27's 4,672 variant);
  frontierGapAboveH0 = 130,838; frontierPast125k carried;
  bandOfWindows28 (twenty-eight-way);
  rh_reanchored_CE28: under [Z-PT2] + the twenty-eight cited
  window clauses, RH q ↔ terminalFaceCE28 q;
  rh_of_terminalFaceCE28 (final named step — no closing
  supplied); terminalFaceCE28_of_thetaInf (M2 lane lands at
  tCE28). The three-exception event is recorded in full in
  the module header.
* **Frontier:** certified zeros over (g_a1, g_b28] =
  **559,992**. Chain integrity 1→28: every seam
  bit-identical, N_range/C_R/M constant. Ten clean windows
  of twenty-eight; all rescues (incl. all three of window
  28) quota-met and recorded. The 150k mark is ~4 windows
  out.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE28.
NO RH CLAIM. (discovery 0333)

## 65 · 0334 — M5 WINDOW 29 CERTIFIED + CE29 RE-ANCHOR
(2026-11-15)

* **Window 29 (in-house, seamless):** a = 12,363,153,997,122
  (= window 28's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,541 evaluations in 2565.1
  s, N_range = [691008, 691008]. Certificate
  window29_b29.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a29, g_b29], g_a29 =
  3,000,175,463,638.889422852356 ± 1.29e-26 (bit-identical
  to window 28's g_b28), g_b29 = 3,000,175,468,311.
  824550537966 ± 1.29e-26 (floor tCE29 sits 0.8246 above
  the previous integer - robust).
* **RECURRING EVENT: two Rosser rescues** — the SECOND
  consecutive multi-exception window (window 28 had three):
  [..006636, ..006638] → [..006634, ..006639] (5 = 5,
  m = 4), [..011105, ..011107] → [..011104, ..011109]
  (5 = 5, m = 4). Both quotas met by the union recounts;
  both displaced within the window (total 20,000
  unchanged); verifier recomputes window total and end
  runs (44/47). All RECORDED, not suppressed.
  Multi-rescue is now a documented steady-state phenomenon
  of the lane (windows 28 and 29 in a row); the recording
  convention is unchanged.
* **Formal (CE29.lean, GREEN 8794; full tree 17454, oolean
  fresh):** gB29Lo := 300017546831182/100, tCE29 :=
  3,000,175,468,311; faceShrinkCE29 = 4673 (running
  pattern); frontierGapAboveH0 = 135,511;
  frontierPast125k carried; bandOfWindows29
  (twenty-nine-way); rh_reanchored_CE29: under [Z-PT2] +
  the twenty-nine cited window clauses, RH q ↔
  terminalFaceCE29 q; rh_of_terminalFaceCE29 (final named
  step — no closing supplied); terminalFaceCE29_of_thetaInf
  (M2 lane lands at tCE29). The two-exception event is
  recorded in full in the module header.
* **Frontier:** certified zeros over (g_a1, g_b29] =
  **579,992**. Chain integrity 1→29: every seam
  bit-identical, N_range/C_R/M constant. Ten clean windows
  of twenty-nine; all rescues quota-met and recorded.
  The 150k mark is ~3 windows out (window 30 or 31).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE29.
NO RH CLAIM. (discovery 0334)

## 66 · 0335 — MILESTONE: THE 30-WINDOW CHAIN + CE30
(2026-11-15) — CLEAN window, 599,992 certified

* **Window 30 (in-house, seamless):** a = 12,363,154,017,122
  (= window 29's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 32,841 evaluations in 2492.9
  s, N_range = [691008, 691008]. Certificate
  window30_b30.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a30, g_b30], g_a30 =
  3,000,175,468,311.824550537966 ± 1.29e-26 (bit-identical
  to window 29's g_b29), g_b30 = 3,000,175,472,984.
  759677952923 ± 1.29e-26 (floor tCE30 sits 0.7597 above
  the previous integer - robust).
* **CLEAN WINDOW** (eleventh of thirty, first since window
  25): ZERO Rosser exceptions, ZERO rescue failures — the
  multi-exception spell of windows 28 (three rescues) and
  29 (two rescues) is over and fully recorded; the lane
  has returned to clean behavior.
* **Formal (CE30.lean, GREEN 8795; full tree 17454, oolean
  fresh):** gB30Lo := 300017547298475/100, tCE30 :=
  3,000,175,472,984; faceShrinkCE30 = 4673 (running
  pattern); frontierGapAboveH0 = 140,184;
  frontierPast125k carried; bandOfWindows30 (thirty-way);
  rh_reanchored_CE30: under [Z-PT2] + the thirty cited
  window clauses, RH q ↔ terminalFaceCE30 q;
  rh_of_terminalFaceCE30 (final named step — no closing
  supplied); terminalFaceCE30_of_thetaInf (M2 lane lands at
  tCE30). The clean-window status recorded in the header.
* **MILESTONE (thirty windows):** certified zeros over
  (g_a1, g_b30] = **599,992 — within EIGHT of the 600,000
  mark**. Chain integrity 1→30: every seam bit-identical,
  N_range/C_R/M constant. Eleven clean windows of thirty
  (6, 8, 10, 12, 13, 14, 16, 18, 22, 25, 30); all nineteen
  rescue windows quota-met and recorded.
* **Frontier:** tCE30 − tCE29 = 4,673 (running pattern);
  tCE30 − tPT2 = 140,184 (125k crossed at CE27; the 150k
  mark is ~2 windows out).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE30.
NO RH CLAIM. (discovery 0335)

## 67 · 0336 — MILESTONE: 600K CROSSED + WINDOW 31 + CE31
(2026-11-15) — CLEAN + snapped window

* **Window 31 (in-house, seamless):** a = 12,363,154,037,122
  (= window 30's b), requested b = a + 20,000, **final b
  snapped down one** (not a good Gram point at working
  precision — the documented endpoint policy; third snap in
  the chain after the 2/11/17/18/19/21 family), M = 60,
  C_R = 1, 33,374 evaluations in 2482.6 s, N_range =
  [691008, 691008]. Certificate window31_b31.json: **b − a
  = 19,999 = sign_changes_inside EXACTLY zeros, all simple
  and on the line** in (g_a31, g_b31]; g_a31 =
  3,000,175,472,984.759677952923 ± 1.29e-26 (bit-identical
  to window 30's g_b30), g_b31 = 3,000,175,477,657.
  461158340877 ± 1.29e-26 (floor tCE31 sits 0.4612 above
  the previous integer - robust). No gap: window 32 starts
  from exactly this b.
* **CLEAN WINDOW** (twelfth of thirty-one, second
  consecutive clean): ZERO Rosser exceptions - the
  post-multi-exception baseline is confirmed.
* **Formal (CE31.lean, GREEN 8796; full tree 17454, oolean
  fresh):** gB31Lo := 300017547765746/100, tCE31 :=
  3,000,175,477,657; faceShrinkCE31 = 4673 (running
  pattern INTACT despite the snapped width);
  frontierGapAboveH0 = 144,857; frontierPast125k carried;
  bandOfWindows31 (thirty-one-way); rh_reanchored_CE31:
  under [Z-PT2] + the thirty-one cited window clauses, RH
  q ↔ terminalFaceCE31 q; rh_of_terminalFaceCE31 (final
  named step — no closing supplied);
  terminalFaceCE31_of_thetaInf (M2 lane lands at tCE31).
  Snapped-endpoint event documented in full in the header.
* **MILESTONE (600k crossed):** certified zeros over
  (g_a1, g_b31] = 599,992 + 19,999 = **619,991 — OVER SIX
  HUNDRED THOUSAND** certified on-line zeros in consecutive
  seamless certificates. Chain integrity 1→31: every seam
  bit-identical, N_range/C_R/M constant. Twelve clean
  windows of thirty-one; nine snapped-width windows
  (2, 3, 8, 11, 17, 18, 19, 21, 31); all rescues
  quota-met and recorded.
* **Frontier:** tCE31 − tCE30 = 4,673; tCE31 − tPT2 =
  144,857 (the 150k mark is ~1 window out - window 32).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE31.
NO RH CLAIM. (discovery 0336)

## 68 · 0337 — M5 WINDOW 32 CERTIFIED + CE32 RE-ANCHOR
(2026-11-15) — THIRD consecutive clean window; 150k is 470
units ahead

* **Window 32 (in-house, seamless):** a = 12,363,154,057,121
  (= window 31's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,567 evaluations in 2517.1
  s, N_range = [691008, 691008]. Certificate
  window32_b32.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a32, g_b32], g_a32 =
  3,000,175,477,657.461158340877 ± 1.29e-26 (bit-identical
  to window 31's g_b31), g_b32 = 3,000,175,482,330.
  396285214541 ± 1.29e-26 (floor tCE32 sits 0.3963 above
  the previous integer - robust).
* **CLEAN WINDOW** (thirteenth of thirty-two, THIRD
  CONSECUTIVE clean - 30, 31, 32): ZERO Rosser exceptions.
  The post-multi-exception baseline is confirmed
  stable.
* **Formal (CE32.lean, GREEN 8797; full tree 17454, oolean
  fresh):** gB32Lo := 300017548233039/100, tCE32 :=
  3,000,175,482,330; faceShrinkCE32 = 4673 (running
  pattern); frontierGapAboveH0 = 149,530;
  frontierPast125k carried; bandOfWindows32
  (thirty-two-way); rh_reanchored_CE32: under [Z-PT2] +
  the thirty-two cited window clauses, RH q ↔
  terminalFaceCE32 q; rh_of_terminalFaceCE32 (final named
  step — no closing supplied); terminalFaceCE32_of_thetaInf
  (M2 lane lands at tCE32). Clean status recorded in the
  header.
* **Frontier:** certified zeros over (g_a1, g_b32] =
  **639,991**. Chain integrity 1→32: every seam
  bit-identical, N_range/C_R/M constant. Thirteen clean
  windows of thirty-two. **The 150k mark sits 470 units
  ahead — window 33 is expected to cross it.**

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE32.
NO RH CLAIM. (discovery 0337)

## 69 · 0338 — MILESTONE: 150K CROSSED + WINDOW 33 + CE33
(2026-11-15) — FOURTH consecutive clean window

* **Window 33 (in-house, seamless):** a = 12,363,154,077,121
  (= window 32's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 32,986 evaluations in 2501.5
  s, N_range = [691008, 691008]. Certificate
  window33_b33.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a33, g_b33], g_a33 =
  3,000,175,482,330.396285214541 ± 1.29e-26 (bit-identical
  to window 32's g_b32), g_b33 = 3,000,175,487,003.
  331411817553 ± 1.29e-26 (floor tCE33 sits 0.3314 above
  the previous integer - robust).
* **CLEAN WINDOW** (fourteenth of thirty-three, FOURTH
  CONSECUTIVE clean - 30, 31, 32, 33): ZERO Rosser
  exceptions. The longest clean streak in the chain; the
  post-multi-exception baseline is confirmed stable.
* **Formal (CE33.lean, GREEN 8798; full tree 17454, oolean
  fresh):** gB33Lo := 300017548700333/100, tCE33 :=
  3,000,175,487,003; faceShrinkCE33 = 4673 (running
  pattern); frontierGapAboveH0 = 154,203;
  **frontierPast150k (NEW MILESTONE: tCE33 − tPT2 > 150,000
  proven in-tree)**; frontierPast125k carried;
  bandOfWindows33 (thirty-three-way); rh_reanchored_CE33:
  under [Z-PT2] + the thirty-three cited window clauses, RH
  q ↔ terminalFaceCE33 q; rh_of_terminalFaceCE33 (final
  named step — no closing supplied);
  terminalFaceCE33_of_thetaInf (M2 lane lands at tCE33).
* **MILESTONE (150k crossed):** certified frontier is now
  154,203 units above the Platt–Trudgian H0 frontier.
  Round-mark sequence: 100k at CE22 (102,801), 125k at CE27
  (126,165), 150k NOW at CE33 (154,203). Next mark 175,000
  is 20,797 units away (~4-5 windows).
* **Frontier:** certified zeros over (g_a1, g_b33] =
  **659,991**. Chain integrity 1→33: every seam
  bit-identical, N_range/C_R/M constant. Fourteen clean
  windows of thirty-three.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE33.
NO RH CLAIM. (discovery 0338)

## 70 · 0339 — M5 WINDOW 34 CERTIFIED + CE34 RE-ANCHOR
(2026-11-15)

* **Window 34 (in-house, seamless):** a = 12,363,154,097,121
  (= window 33's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,680 evaluations in 2582.7
  s, N_range = [691008, 691008]. Certificate
  window34_b34.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a34, g_b34], g_a34 =
  3,000,175,487,003.331411817553 ± 1.29e-26 (bit-identical
  to window 33's g_b33), g_b34 = 3,000,175,491,676.
  266538149912 ± 1.29e-26 (floor tCE34 sits 0.2665 above
  the previous integer - robust).
* **ROSSER EVENT: one rescue** — [..113559, ..113561] →
  [..113557, ..113562] (5 = 5, m = 4). Quota met by the
  union recount; displaced within the window (total
  unchanged); verifier recomputes window total and end
  runs (49/48). RECORDED, not suppressed. The FOUR-window
  clean streak (30-31-32-33, the longest in the chain up
  to that point) ENDS as expected — the usual mix of the
  lane returns.
* **Formal (CE34.lean, GREEN 8799; full tree 17454, oolean
  fresh):** gB34Lo := 300017549167626/100, tCE34 :=
  3,000,175,491,676; faceShrinkCE34 = 4673 (running
  pattern); frontierGapAboveH0 = 158,876;
  frontierPast150k carried; bandOfWindows34
  (thirty-four-way); rh_reanchored_CE34: under [Z-PT2] +
  the thirty-four cited window clauses, RH q ↔
  terminalFaceCE34 q; rh_of_terminalFaceCE34 (final named
  step — no closing supplied);
  terminalFaceCE34_of_thetaInf (M2 lane lands at tCE34).
  The single-rescue event recorded in the header.
* **Frontier:** certified zeros over (g_a1, g_b34] =
  **679,991**. Chain integrity 1→34: every seam
  bit-identical, N_range/C_R/M constant. Fourteen clean
  windows of thirty-four; all rescues quota-met and
  recorded. The 175k mark is ~3-4 windows out.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE34.
NO RH CLAIM. (discovery 0339)

## 71 · 0340 — M5 WINDOW 35 CERTIFIED + CE35 RE-ANCHOR
(2026-11-15)

* **Window 35 (in-house, seamless):** a = 12,363,154,117,121
  (= window 34's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,957 evaluations in 2606.4
  s, N_range = [691008, 691008]. Certificate
  window35_b35.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a35, g_b35], g_a35 =
  3,000,175,491,676.266538149912 ± 1.29e-26 (bit-identical
  to window 34's g_b34), g_b35 = 3,000,175,496,349.
  201664211618 ± 1.29e-26 (floor tCE35 sits 0.2017 above
  the previous integer - robust; standard two-decimal lower
  bound, margin ~1.66e-2, no CASING needed).
* **ROSSER EVENT: one rescue** — [..118192, ..118195] →
  [..118191, ..118196] (5 = 5, m = 4). Quota met by the
  union recount; displaced within the window (total
  unchanged); verifier recomputes window total and end
  runs (49/48). RECORDED, not suppressed.
* **Formal (CE35.lean, GREEN 8800; full tree 17454, oolean
  fresh):** gB35Lo := 300017549634920/100, tCE35 :=
  3,000,175,496,349; faceShrinkCE35 = 4673 (running
  pattern); frontierGapAboveH0 = 163,549;
  frontierPast150k carried; bandOfWindows35
  (thirty-five-way); rh_reanchored_CE35: under [Z-PT2] +
  the thirty-five cited window clauses, RH q ↔
  terminalFaceCE35 q; rh_of_terminalFaceCE35 (final named
  step — no closing supplied);
  terminalFaceCE35_of_thetaInf (M2 lane lands at tCE35).
  The single-rescue event recorded in the header.
* **Frontier:** certified zeros over (g_a1, g_b35] =
  **699,991**. Chain integrity 1→35: every seam
  bit-identical, N_range/C_R/M constant. Fourteen clean
  windows of thirty-five; all rescues quota-met and
  recorded. The 175k mark is ~2-3 windows out.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE35.
NO RH CLAIM. (discovery 0340)

## 72 · 0341 — M5 WINDOW 36 CERTIFIED + CE36 RE-ANCHOR
(2026-11-15) — CLEAN window; 719,991 certified

* **Window 36 (in-house, seamless):** a = 12,363,154,137,121
  (= window 35's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,318 evaluations in 2563.2
  s, N_range = [691008, 691008]. Certificate
  window36_b36.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a36, g_b36], g_a36 =
  3,000,175,496,349.201664211618 ± 1.29e-26 (bit-identical
  to window 35's g_b35), g_b36 = 3,000,175,501,022.
  136790002671 ± 1.29e-26 (floor tCE36 sits 0.1368 above
  the previous integer - robust; margin ~6.8e-3, no
  CASING).
* **CLEAN WINDOW** (fifteenth of thirty-six): ZERO Rosser
  exceptions.
* **Formal (CE36.lean, GREEN 8801; full tree 17454, oolean
  fresh):** gB36Lo := 300017550102213/100, tCE36 :=
  3,000,175,501,022; faceShrinkCE36 = 4673 (running
  pattern); frontierGapAboveH0 = 168,222;
  frontierPast150k carried; bandOfWindows36
  (thirty-six-way); rh_reanchored_CE36: under [Z-PT2] +
  the thirty-six cited window clauses, RH q ↔
  terminalFaceCE36 q; rh_of_terminalFaceCE36 (final named
  step — no closing supplied);
  terminalFaceCE36_of_thetaInf (M2 lane lands at tCE36).
  Clean status recorded in the header.
* **Frontier:** certified zeros over (g_a1, g_b36] =
  **719,991**. Chain integrity 1→36: every seam
  bit-identical, N_range/C_R/M constant. Fifteen clean
  windows of thirty-six; all rescues quota-met and
  recorded. **The 175k mark is 6,778 units away — ~1-2
  windows out (window 37 or 38).**

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE36.
NO RH CLAIM. (discovery 0341)

## 73 · 0342 — M5 WINDOW 37 CERTIFIED + CE37 RE-ANCHOR
(2026-11-15) — the 175k mark is 2,105 units ahead

* **Window 37 (in-house, seamless):** a = 12,363,154,157,121
  (= window 36's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,746 evaluations in 2579.3
  s, N_range = [691008, 691008]. Certificate
  window37_b37.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a37, g_b37], g_a37 =
  3,000,175,501,022.136790002671 ± 1.29e-26 (bit-identical
  to window 36's g_b36), g_b37 = 3,000,175,505,695.
  071915523071 ± 1.29e-26 (floor tCE37 sits 0.0719 above
  the previous integer - robust; margin ~1.9e-3; the
  two-decimal round-down (0.07) does not equal the floor,
  so no CASING needed).
* **ROSSER EVENT: one rescue** — [..174780, ..174783] →
  [..174779, ..174784] (5 = 5, m = 8). Quota met by the
  union recount; displaced within the window (total
  unchanged); verifier recomputes window total and end
  runs (48/49). RECORDED, not suppressed.
* **Formal (CE37.lean, GREEN 8802; full tree 17454, oolean
  fresh):** gB37Lo := 300017550569507/100, tCE37 :=
  3,000,175,505,695; faceShrinkCE37 = 4673 (running
  pattern); frontierGapAboveH0 = 172,895;
  frontierPast150k carried; bandOfWindows37
  (thirty-seven-way); rh_reanchored_CE37: under [Z-PT2] +
  the thirty-seven cited window clauses, RH q ↔
  terminalFaceCE37 q; rh_of_terminalFaceCE37 (final named
  step — no closing supplied);
  terminalFaceCE37_of_thetaInf (M2 lane lands at tCE37).
  The single-rescue event recorded in the header.
* **Frontier:** certified zeros over (g_a1, g_b37] =
  **739,991**. Chain integrity 1→37: every seam
  bit-identical, N_range/C_R/M constant. Fifteen clean
  windows of thirty-seven; all rescues quota-met and
  recorded. **The 175k mark sits 2,105 units ahead —
  window 38 is expected to cross it.**

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE37.
NO RH CLAIM. (discovery 0342)

## 74 · 0343 — MILESTONE: 175K CROSSED + FIRST CASING CASE
(2026-11-16) — WINDOW 38 + CE38

* **Window 38 (in-house, seamless):** a = 12,363,154,177,121
  (= window 37's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,109 evaluations in 2557.8
  s, N_range = [691008, 691008]. Certificate
  window38_b38.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a38, g_b38], g_a38 =
  3,000,175,505,695.071915523071 ± 1.29e-26
  (bit-identical to window 37's g_b37), g_b38 =
  3,000,175,510,368.007040772818 ± 1.29e-26.
* **NEW EVENT: FIRST CASING CASE IN THE CHAIN.** g_b38's
  frac part is **0.00704 < 0.01** — the standard
  two-decimal round-down (0.00) would equal the floor
  tCE38 exactly, leaving no margin for the strict seam
  order tCE38 < gB38Lo. Per the documented CASING rule:
  **gB38Lo uses the three-decimal round-down 0.007**
  (margin ~4.07e-5, nineteen orders of magnitude above
  the radius 1.29e-26). The re-anchoring machinery is
  UNCHANGED by CASING — it operates on the rational caps.
  The convention activates exactly as predicted.
* **CLEAN WINDOW** (sixteenth of thirty-eight): ZERO
  Rosser exceptions.
* **Formal (CE38.lean, GREEN 8803; full tree 17454, oolean
  fresh):** gB38Lo := 3000175510368007/1000 (THREE-decimal
  CASING cap), tCE38 := 3,000,175,510,368;
  tCE38_lt_gB38Lo (the strict seam order CASING was needed
  FOR); faceShrinkCE38 = 4673 (running pattern);
  frontierGapAboveH0 = 177,568;
  **frontierPast175k (NEW MILESTONE: tCE38 − tPT2 > 175,000
  proven in-tree)**; frontierPast150k carried;
  bandOfWindows38 (thirty-eight-way); rh_reanchored_CE38:
  under [Z-PT2] + the thirty-eight cited window clauses, RH
  q ↔ terminalFaceCE38 q; rh_of_terminalFaceCE38 (final
  named step — no closing supplied);
  terminalFaceCE38_of_thetaInf (M2 lane lands at tCE38).
* **MILESTONE (175k crossed):** certified frontier is now
  177,568 units above the Platt–Trudgian H0 frontier.
  Round-mark sequence: 100k @ CE22 (102,801), 125k @ CE27
  (126,165), 150k @ CE33 (154,203), 175k NOW @ CE38
  (177,568). Next mark 200,000 is 22,432 units away
  (~5 windows).
* **Frontier:** certified zeros over (g_a1, g_b38] =
  **759,991**. Chain integrity 1→38: every seam
  bit-identical, N_range/C_R/M constant. Sixteen clean
  windows of thirty-eight; all rescues quota-met and
  recorded.

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE38.
NO RH CLAIM. (discovery 0343)

## 75 · 0344 — M5 WINDOW 39 CERTIFIED + CE39 RE-ANCHOR
(2026-11-16) — 4,672 variant

* **Window 39 (in-house, seamless):** a = 12,363,154,197,121
  (= window 38's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 34,456 evaluations in 2726.6
  s, N_range = [691008, 691008]. Certificate
  window39_b39.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a39, g_b39], g_a39 =
  3,000,175,510,368.007040772818 ± 1.29e-26 (bit-identical
  to window 38's g_b38), g_b39 = 3,000,175,515,040.
  942165751912 ± 1.29e-26 (frac 0.9422 - standard
  two-decimal bound, margin ~0.94, no CASING needed).
* **ROSSER EVENT: one rescue** — [..206334, ..206336] →
  [..206333, ..206337] (4 = 4, m = 4). Quota met by the
  union recount; displaced within the window (total
  unchanged); verifier recomputes window total and end
  runs (50/47). RECONCILED AND RECORDED.
* **Formal (CE39.lean, GREEN 8804; full tree 17454, oolean
  fresh):** gB39Lo := 300017551504094/100, tCE39 :=
  3,000,175,515,040; **faceShrinkCE39 = 4672 (the 4,672
  VARIANT of the running pattern)**;
  frontierGapAboveH0 = 182,240; frontierPast175k carried;
  bandOfWindows39 (thirty-nine-way); rh_reanchored_CE39:
  under [Z-PT2] + the thirty-nine cited window clauses, RH
  q ↔ terminalFaceCE39 q; rh_of_terminalFaceCE39 (final
  named step — no closing supplied);
  terminalFaceCE39_of_thetaInf (M2 lane lands at tCE39).
  The single-rescue event recorded in the header.
* **Frontier:** certified zeros over (g_a1, g_b39] =
  **779,991**. Chain integrity 1→39: every seam
  bit-identical, N_range/C_R/M constant. Sixteen clean
  windows of thirty-nine; all rescues quota-met and
  recorded. The 4,672 variant confirms the running pattern
  allows both 4,672 and 4,673 (4,671 observed once at
  snapped-width window 31).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE39.
NO RH CLAIM — the 200k mark is ~4 windows out.
(discovery 0344)

## 76 · 0345 — MILESTONE: 40TH WINDOW + FIRST SNAP-BY-2
(2026-11-16) — WINDOW 40 + CE40

* **Window 40 (in-house, seamless):** a = 12,363,154,217,121
  (= window 39's b, seamless). Requested b = a + 20,000 =
  12,363,154,237,121 was NOT a good Gram point at working
  precision → **pipeline snapped b DOWN BY 2** to
  b = 12,363,154,237,119 (good Gram point). **b − a =
  19,998 — FIRST 19,998-WIDTH WINDOW OF THE CHAIN** (all
  nine prior snaps were by exactly 1 → 19,999-width).
  M = 60, C_R = 1, 34,546 evaluations in 2721.1 s,
  N_range = [691008, 691008].
* **Certificate (window40_b40.json): b − a = 19,998 zeros,
  all simple and on the line** in (g_a40, g_b40]. g_a40 =
  3,000,175,515,040.942165751912 ± 1.29e-26 (bit-identical
  to window 39's g_b39); g_b40 = 3,000,175,519,713.
  409996947896 ± 1.29e-26 (frac 0.4100 — standard
  two-decimal bound, no CASING).
* **CLEAN WINDOW** (seventeenth of forty): ZERO Rosser
  exceptions.
* **Formal (CE40.lean, GREEN 8805; full tree 17454, olean
  fresh):** gB40Lo := 300017551971340/100, tCE40 :=
  3,000,175,519,713; faceShrinkCE40 = 4673 (running
  pattern restored after window 39's 4,672 variant);
  frontierGapAboveH0 = 186,913; bandOfWindows40
  (forty-way); rh_reanchored_CE40: under [Z-PT2] + the
  forty cited window clauses, RH q ↔ terminalFaceCE40 q;
  rh_of_terminalFaceCE40 (final named step — no closing
  supplied); terminalFaceCE40_of_thetaInf (M2 lane lands
  at tCE40). The snap-by-2 event recorded in the header.
* **Chain integrity 1→40:** every seam bit-identical,
  N_range/C_R/M constant. Seventeen clean windows of
  forty. Window 41 in flight from the SNAPPED b (a41 =
  12,363,154,237,119) — seamless continuation.

Window 41 a41 = 12,363,154,237,119 (the snapped b of
window 40) — in flight. 200k mark ~3 windows out; 800k
mark ~1 window out. NO RH CLAIM — wall UNMOVED at 4/7,
face OPEN at tCE40. (discovery 0345)

## 77 · 0346 — MILESTONE: 800K CERTIFIED CROSSED
(2026-11-16) — WINDOW 41 + CE41

* **Window 41 (in-house, seamless):** a = 12,363,154,237,119
  (= window 40's SNAPPED b — the seam continues seamlessly
  across the previous window's right-edge snap by 2),
  b = a + 20,000 (no snap at either endpoint), M = 60,
  C_R = 1, 33,279 evaluations in 2557.4 s,
  N_range = [691008, 691008]. Certificate
  window41_b41.json: **b − a = 20,000 zeros, all simple
  and on the line** in (g_a41, g_b41], g_a41 =
  3,000,175,519,713.409996947896 ± 1.29e-26 (bit-identical
  to window 40's g_b40 — seam verified across the snap),
  g_b41 = 3,000,175,524,386.345121385712 ± 1.29e-26
  (frac 0.3451 — standard two-decimal bound, no CASING).
* **SEAM ACROSS A SNAP (first of its kind, verified):**
  the exact-dyadic-tuple seam audit confirms the chain
  remains seamless even across window 40's right-edge
  snap by 2. A snapped endpoint is a legitimate chain
  endpoint; the seam discipline is unchanged.
* **CLEAN WINDOW** (eighteenth of forty-one): ZERO Rosser
  exceptions.
* **Formal (CE41.lean, GREEN 8806; full tree 17454, olean
  fresh):** gB41Lo := 300017552438634/100, tCE41 :=
  3,000,175,524,386; faceShrinkCE41 = 4673 (running
  pattern); frontierGapAboveH0 = 191,586;
  bandOfWindows41 (forty-one-way); rh_reanchored_CE41:
  under [Z-PT2] + the forty-one cited window clauses, RH
  q ↔ terminalFaceCE41 q; rh_of_terminalFaceCE41 (final
  named step — no closing supplied);
  terminalFaceCE41_of_thetaInf (M2 lane lands at tCE41).
* **MILESTONE (800k certified zeros crossed):**
  cumulative certified zeros over (g_a1, g_b41] =
  799,989 + 20,000 = **819,989**. The 800,000th certified
  on-line zero lands inside window 41.

Chain integrity 1→41: every seam bit-identical (including
the seam across window 40's snap), N_range/C_R/M
constant. Eighteen clean windows of forty-one. 200k mark
~2 windows out. NO RH CLAIM — wall UNMOVED at 4/7, face
OPEN at tCE41. (discovery 0346)

## 78 · 0347 — M5 WINDOW 42 CERTIFIED + CE42 RE-ANCHOR
(2026-11-16) — 200k is 3,741 away

* **Window 42 (in-house, seamless):** a = 12,363,154,277,119
  (= window 41's b), b = a + 20,000 (no snap at either
  endpoint), M = 60, C_R = 1, 33,763 evaluations in 2641.2
  s, N_range = [691008, 691008]. Certificate
  window42_b42.json: **b − a = 20,000 zeros, all simple and
  on the line** in (g_a42, g_b42], g_a42 =
  3,000,175,524,386.345121385712 ± 1.29e-26 (bit-identical
  to window 41's g_b41), g_b42 = 3,000,175,529,059.
  280245552874 ± 1.29e-26 (frac 0.2802 — standard
  two-decimal bound, margin ~0.28, no CASING).
* **CLEAN WINDOW** (nineteenth of forty-two): ZERO Rosser
  exceptions.
* **Formal (CE42.lean, GREEN 8807; full tree 17454, olean
  fresh):** gB42Lo := 300017552905928/100, tCE42 :=
  3,000,175,529,059; faceShrinkCE42 = 4673 (running
  pattern); frontierGapAboveH0 = 196,259;
  bandOfWindows42 (forty-two-way); rh_reanchored_CE42:
  under [Z-PT2] + the forty-two cited window clauses, RH
  q ↔ terminalFaceCE42 q; rh_of_terminalFaceCE42 (final
  named step — no closing supplied);
  terminalFaceCE42_of_thetaInf (M2 lane lands at tCE42).
* **Frontier:** certified zeros over (g_a1, g_b42] =
  **839,989** (800k mark crossed at CE41 remains crossed).
  Chain integrity 1→42: every seam bit-identical,
  N_range/C_R/M constant. Nineteen clean windows of
  forty-two.
* **200k mark:** 3,741 units ahead of tCE42 — **the
  crossing is expected in window 43** (in flight; a43 =
  12,363,154,317,119). When it lands, frontierPast200k
  will be proven in-tree (as frontierPast175k was in
  CE38).

Wall UNMOVED at 4/7; face OPEN / PROBABLY TRUE at tCE42.
NO RH CLAIM. (discovery 0347)

## 79 · 0348 (CORRECTION + 200k MILESTONE): M5 LAUNCH ARITHMETIC ERROR — CAUGHT BY THE SEAM AUDIT — FILL WINDOW + CE42B + CE43

**The correction (logged in full per the program's honesty conventions):** the
window-43 launch command contained an M5 launch arithmetic error — `a` was set to
`b42 + 20000` = 12,363,154,297,119 instead of `b42` = 12,363,154,277,119, so the
run certified a **valid but misplaced** window, leaving the 20,000-point interval
`(b42, b42 + 20000]` **uncertified** in the chain. The **exact-dyadic-tuple seam
audit caught the break** (w43's `g_a` is NOT bit-identical to w42's `g_b`; gap
4,672.935 height units). The correction: a FILL window between w42 and w43,
certified and double-seamed; the misplaced certificate stays valid in its own
region and is re-anchored in its corrected position.

### Fill window `window42b_fill.json` (a = b42 = 277,119 … b = 297,119)
- 20,000 zeros all **simple and on the line**; 33,301 evaluations, 2533.4 s,
  M = 60, C_R = 1, 28 workers, N_range [691008, 691008].
- Verifier: `CERTIFIED: true`, 33,301 points, sign_changes = b − a,
  roesser_failures = **0** (CLEAN), Rosser runs 47/47, turing_ok.
- `g_b42b = 3,000,175,533,732.215369449384 ± 1.29e-26`;
  `tCE42B = 3,000,175,533,732`; frac 0.2154; standard 2-dec bound
  (margin ~5.4e-3); no CASING.
- **BOTH seams bit-identical:** SEAM 1 (fill `g_a` ≡ w42 `g_b`), SEAM 2
  (fill `g_b` ≡ w43 `g_a`) — the chain `w42 → w42b → w43` is seamless again.

### CE42B.lean (fill module — GREEN 8808)
- `gB42BLo := 300017553373221/100`; `tCE42B := 3000175533732`;
  `faceShrinkCE42B : tCE42B − tCE42 = 4673` (running pattern).
- **`frontierGapAboveH0 : tCE42B − tPT2 = 200932` and
  `frontierPast200k : tCE42B − tPT2 > 200000` — MILESTONE: the 200k frontier
  mark is crossed, proven in-tree at the fill.**
- Clauses `ce42WinClauseFull` (full w42 slice) + `ce42BWinClause` (terminal
  slice); 43-way `bandOfWindows42B`; `allOnLineUpToCE42B`;
  `terminalFaceCE42B_iff_faceCE42`; `rh_split_at_CE42B`; headline
  `rh_reanchored_CE42B` (RH q ↔ `terminalFaceCE42B q`);
  `rh_of_terminalFaceCE42B` (no closing supplied);
  `terminalFaceCE42B_of_thetaInf` (M2/0290 lane). **NO RH CLAIM.**

### CE43.lean (window 43 in its corrected position — GREEN 8809; full tree 17454)
- `gB43Lo := 300017553840515/100`; `tCE43 := 3000175538405`;
  `faceShrinkCE43 : tCE43 − tCE42B = 4673`;
  **`frontierGapAboveH0 : tCE43 − tPT2 = 205605`** (225k ~4 windows out).
- W43: 20,000 zeros simple+on-line; 33,541 evals, 2587.6 s; runs 47/52;
  **ONE rescued exception** (block [..309,601, ..309,604] → union [..309,599,
  ..309,605], need 6 = found 6, m = 8; quota met, displaced in-window, total
  unchanged). Verifier `CERTIFIED: true` at 33,541.
- 44-way `bandOfWindows43` over the **corrected chain**
  (w1…w42, w42b, w43); `allOnLineUpToCE43`; `terminalFaceCE43`;
  `terminalFaceCE43_iff_faceCE42B`; `rh_split_at_CE43`; headline
  `rh_reanchored_CE43` (RH q ↔ `terminalFaceCE43 q`);
  `rh_of_terminalFaceCE43` (no closing); `terminalFaceCE43_of_thetaInf`.
  **NO RH CLAIM.**

### State at 0348 land
- Frontier **tCE43 = 3,000,175,538,405 = 205,605 above the Platt–Trudgian H0
  frontier** (200k crossed at the fill); cumulative certified zeros over
  `(g_a1, g_b43]` = **879,989** via the corrected chain; both `.olean` fresh.
- **Process lesson (adopted):** no formal module for a window is written until
  its seam audit against the immediate chain predecessor (possibly a fill)
  passes bit-identically. Clean tally: 19; snaps: 2,3,8,11,17,18,19,21,31,40;
  CASING: 38; misplaced-launch corrections: 1 (this one).
- Next (in flight): window 44 (a44 = 12,363,154,337,119 … requested b44 = a44 +
  20000) → seam audit first → CE44. The analytic wall {θ | 4/7 < θ} remains
  pinned; the active lane remains M5 certification. **No RH claim.**

## 80 · 0349: window 44 + CE44 — 210,278 above H0 (225k ~3 windows out), 899,989 certified

**Run (the 0348 rule held — launched from b43 correctly; seam audited BEFORE the module):**
`a44 = b43 = 12,363,154,317,119`, `b44 = a44 + 20,000 = 12,363,154,337,119` (no
snap), M = 60, C_R = 1, 28 workers, 33,953 evaluations, N_range [691008, 691008].

**Certificate `window44_b44.json`:** the 20,000 zeros of ζ with
`g_a44 < Im s ≤ g_b44` are ALL SIMPLE and on the line.
- `g_b44 = 3,000,175,543,078.085449218750 ± 1.29e-26`
  (exact dyadic `116063669676910075289953026587486486005 × 2^-85`; frac 0.0854;
  standard 2-dec bound `gB44Lo`, margin ~5.6e-3; no CASING).
- Verifier: `CERTIFIED: true`, 33,953 points, sign_changes = b − a,
  roesser_failures = 1 (rescued), runs 46/48 (both ≥ K = 12), turing_ok.
- **ONE rescued exception (quota met):** block
  `[12,363,154,324,338, ..324,340]` (raw need 2, 0 changes / 129 pts, m = 64)
  → union `[..324,337, ..324,341]`, need 4 = found 4, m = 4. Recorded, not
  suppressed. First two-in-a-row rescue stretch since the w28/w29 episode.
- **SEAM AUDIT (pre-module, per the 0348 rule):** `g_a44` bit-identical to
  `g_b43` (exact dyadic tuple) → corrected chain `w42 → w42b → w43 → w44`
  seamless end-to-end.

**CE44.lean — GREEN 8810 (full tree 17454, fresh):**
- `gB44Lo := 300017554307808/100`; `tCE44 := 3000175543078`;
  `faceShrinkCE44 : tCE44 − tCE43 = 4673` (13th consecutive running-pattern
  shrink); `frontierGapAboveH0 : tCE44 − tPT2 = 210278` (frontierPast200k
  carried from the CE42B fill; 225k sits 14,722 ≈ 3 windows out).
- Clauses: `fillWinClauseFull` (fill full slice, re-cited at this level),
  `ce43WinClauseFull` (w43 full slice), `ce44WinClause` (w44 terminal slice);
  45-way `bandOfWindows44` over the corrected chain; `allOnLineUpToCE44`;
  `terminalFaceCE44_iff_faceCE43`; `rh_split_at_CE44`; headline
  `rh_reanchored_CE44` (RH q ↔ `terminalFaceCE44 q`);
  `rh_of_terminalFaceCE44` (no closing supplied);
  `terminalFaceCE44_of_thetaInf` (M2/0290 lane). **NO RH CLAIM.**

**State at 0349 land:** frontier **tCE44 = 3,000,175,543,078 = 210,278 above
H0**; cumulative certified zeros over `(g_a1, g_b44]` = **899,989**; clean
windows 19/45; rescue windows 7,21,28,29,34,37,42,43,44 (all quota-met,
recorded); snaps at 2,3,8,11,17,18,19,21,31,40; CASING only at 38. Next (in
flight): window 45 (a45 = 12,363,154,357,119) → seam first → CE45. Wall
{θ | 4/7 < θ} pinned; active lanes M5 + the queued M2 wall literature audit.
**No RH claim.**

## 81 · 0350 (M2 LANE): the wall's literature audit — 2025-grade primary sources

**Question answered:** can published analysis close the terminal face?
**Method:** primary-source pull on the S-function (argument of ζ on the line):
Conrey's book (arXiv:1407.4358, §VIII), Carneiro–Chandee–Milinovich
(arXiv:1309.1526 / Math. Ann. 356 (2013)), Inoue (arXiv:1904.11051,
arXiv:2510.14309), Tsang (Acta Arith. 46 (1986), as cited in 2510.14309).

**Findings (verbatim-level citations in the entry):**
1. **S is unbounded — unconditional, classical.** Conrey §VIII verbatim:
   *"It is known that S(y) is unbounded … The roughest estimate is the known
   fact that S(y) = O(log y) … not written explicitly in Riemann's paper, but
   only later by von Mangoldt."* The clean derivation: Selberg (1946)
   mean-square *(1/T)∫₀ᵀ S(y)² dy = (2π²)⁻¹ log log T + O(√log log T)*
   (same section, verbatim) — divergent mean square ⇒ limsup |S| = ∞,
   unconditionally.
2. **Best published upper bound (under RH) DIVERGES:** CCM 2013 Thm 2:
   |S(t)| ≤ (1/4+o(1))·log t/log log t (improves Goldston–Gonek's 1/2;
   Conrey §VIII: *"these are upper bounds, and S(y) may actually be much
   smaller"*). No finite-constant upper bound is published anywhere.
3. **Best published Ω (under RH) GROWS:** Inoue 1904.11051:
   S(t) = Ω±((log t·log log log t)/(log log t)) — improves Montgomery,
   matches Bondarenko–Seip. Under RH the published oscillation band OPENS.
4. **Short-interval ΔΩ:** unconditional sup ±(S(t+h)−S(t)) ≥ c(h log T)^{1/3}
   (Tsang 1986); under RH sup ± ≥ (1−E)√(h log T/π) (Inoue 2510.14309 Thm 1).

**Verdict for the program — no movement, now fully cited:**
- **Door 1 (absolute clause G-hs1/A1: uniform finite |S(zero)| ≤ K):**
  DEAD as a published input — no published theorem supplies it (F1,
  re-confirmed against 2013/2018/2021/2023/2025 sources), and every
  published upper bound DIVERGES. The E19 gap stands exactly: no published
  at-zeros Ω appeared in the sources pulled, so |S(γₙ)| ≤ K is NOT A LIVE
  PUBLISHED THEOREM and NOT YET REFUTED BY PUBLISHED ANALYSIS —
  "under pressure — not refuted," unchanged, with the full 2025 citation
  record.
- **Door 2 (quantitative growth, the {θ | θ < 4/7} Levinson/PRZZ wall):**
  ALIVE, **PINNED at 4/7** (0310–0312) — the only analytic path; the audit
  found no source past 4/7.
- **Door 3 (θ = ∞ conjecture lane, ThetaInf/0290):** ALIVE, **conjectural by
  nature** (Bettin–Gonek Theorem 1 + Farmer's conjecture; no 2025 fragment
  past any fixed bound found).

The three named doors (0289 face-menu) are the whole menu; the wall is
UNMOVED; the face at tCE44 (210,278 above H0) remains OPEN. **NO RH CLAIM.**
Active lane remains M5 (window 45 in flight at audit time; 225k ~3 windows
out).

## 82 · 0351: window 45 + CE45 — 214,951 above H0 (225k now 10,049 out, ~2 windows), 919,989 certified (900k mark crossed inside w45)
- **0351 (M5 LANE - WINDOW 45 + CE45):** window 45 landed. Launch a45 =
  12,363,154,337,119 (= b44; an earlier status draft's "a45 = 357,119" was a
  typo — 357,119 is b45), b = a + 20,000 (NO snap), M = 60, C_R = 1, 28
  workers, N_range [691008, 691008], 33,537 evals, 2568.6 s.
- **Seam audit FIRST (0348 rule):** g_a45 ≡ g_b44 exact dyadic tuple
  [116063669676910075289953026587486486005, −85, 16777217, −110] —
  bit-identical, before CE45 was written.
- **Two quota-met Rosser rescues — first double-rescue window of the
  chain:** block [..354,109,..354,111] (need 2, 0 changes @129 pts, m = 64)
  → union [..354,108,..354,113], need 5 = found 5, m = 2; block
  [..355,777,..355,779] (same raw shape) → union [..355,776,..355,780],
  need 4 = found 4, m = 8. Displaced in-window; total unchanged; recorded,
  not suppressed. Rosser runs 46/47 (both ≥ K = 12); 0 cross-check
  failures; 0 undetermined Gram signs.
- **Verifier (layer 2):** CERTIFIED: true, points_checked 33,537,
  sign_changes_inside 20,000 = b − a, turing_ok: true, K_conservative 12
  (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6], doubled [11.4380 ±
  1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] — all < 12); endpoints
  recomputed and matched. Layer 3 = the seam audit above. Layer 1 = the
  environment repeat (CE2 header). Re-run of a third-party pipeline, not a
  from-scratch certification.
- **Frontier (machine, in CE45):** g_b45 = 3,000,175,547,751.020507812500 ±
  1.29e-26 (dyadic: 58031834928842748423872171928891447925 × 2^−84 ±
  16777217 × 2^−110). **tCE45 = 3,000,175,547,751**; tCE45 − tCE44 = **4,673**
  (14th consecutive 4,673 shrink); tCE45 − tPT2 = **214,951**; 200k mark
  carried (crossed at CE42B fill); **225k mark now 10,049 ahead (~2
  windows)** — watch the floor arithmetic, do not assume. NO CASING (two-
  decimal round-down 0.02 ≠ 0.00; CE38 remains the only CASING case).
- **Cumulative certified zeros over (g_a1, g_b45] = 899,989 + 20,000 =
  919,989 — the 900,000 mark was crossed inside window 45.**
- **CE45.lean GREEN** (8,811 targeted jobs; full tree green; olean fresh):
  gB45Lo := 300017554775102/100 (margin ~5.1e-4); ce44WinClauseFull
  (w44 full slice re-cited); ce45WinClause (terminal slice); band of 46
  clauses; terminalFaceCE45 NAMED OPEN; iff/split/reanchor/thetaInf all at
  the new frontier; machine facts incl. frontierGapAboveH0 = 214,951.
- **M2 side note in the same unit:** SWall.lean GREEN (8,706 jobs) — the
  0350 audit is now an in-tree Lean unit (cited Props + LEAN-PROVEN
  consequences: noUniformAllT_of_citedUnbounded, noUniformAllT_of_RHOmega,
  upperRH_bound_diverges, atZeroUnbounded_kills_uniformZeros; workhorse
  logDivLoglog_eventuallyAbove). Wall {θ | 4/7 < θ} stays PINNED.
- **NO RH CLAIM.** Face open at tCE45; next unit — window 46
  (a46 = 12,363,154,357,119).

## 83 · 0352: window 46 + CE46 — 219,623 above H0 (225k now 5,377 out — crossing expected in w47), 939,989 certified, CLEAN window
- **0352 (M5 LANE - WINDOW 46 + CE46):** window 46 landed. Launch a46 =
  12,363,154,357,119 (= b45, launched correctly from the chain frontier),
  b = a + 20,000 (NO snap), M = 60, C_R = 1, 28 workers, N_range
  [691008, 691008], 33,356 evals, 2518.0 s.
- **Seam audit FIRST (0348 rule):** g_a46 ≡ g_b45 exact dyadic tuple
  [58031834928842748423872171928891447925, −84, 16777217, −110] —
  bit-identical, before CE46 was written.
- **CLEAN WINDOW** (first after the w45 double-rescue): 0 Rosser failures,
  0 rescues, 0 cross-check failures, 0 Gram mismatches, 0 undetermined
  signs. Clean tally now **20 of 47** chain windows; rescue list unchanged
  (7, 21, 28, 29, 34, 37, 42, 43, 44 one each; 45 has two). Rosser runs
  47/45 (both ≥ K = 12).
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,356, sign_changes_inside 20,000 = b − a,
  K_conservative 12 (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6],
  doubled [11.4380 ± 1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] —
  all < 12); endpoints recomputed and matched (g_b recomputed
  [3,000,175,552,423.955862328893 ± 1.86e-13]).
- **Frontier (machine, in CE46):** g_b46 = 3,000,175,552,423.956054687500
  ± 1.29e-26 — exact recorded tuple
  **[232127340076921836790130566544415780883, −86, 16777217, −110]**.
  Endpoint is HIGH in its unit (fractional 0.9561; next integer only
  0.0439 above) — floor robust to 1.29e-26 by orders of magnitude.
  **tCE46 = 3,000,175,552,423**; tCE46 − tCE45 = **4,672** — the 15th
  increment, and the **4,673 stretch of FOURTEEN consecutive shrinks ENDS
  HERE** (Gram spacings not exactly periodic; recorded honestly).
  tCE46 − tPT2 = **219,623**; 200k mark carried; **225k mark 5,377 ahead
  (~1.15 windows) — crossing expected in w47, compute don't assume**. NO
  CASING (two-dec round-down 0.95 ≠ 0.00; margin ~6.1e-3; CE38 remains
  the only CASING case).
- **Cumulative certified zeros over (g_a1, g_b46] = 919,989 + 20,000 =
  939,989.**
- **CE46.lean GREEN** (8,812 targeted jobs; full tree green; olean fresh):
  gB46Lo := 300017555242395/100; ce45WinClauseFull (w45 full slice
  re-cited); ce46WinClause (terminal slice); 47-way band;
  terminalFaceCE46 NAMED OPEN; iff/split/reanchor/thetaInf at the new
  frontier; machine facts incl. faceShrinkCE46 = 4672 and
  frontierGapAboveH0 = 219623.
- **M2:** SWall.lean (0350 audit in-tree) GREEN in the same tree; wall
  {θ | 4/7 < θ} PINNED; no new external analytic inputs.
- **NO RH CLAIM.** Face open at tCE46; next unit — window 47
  (a47 = 12,363,154,377,119), where the 225k crossing is expected.

## 84 · 0353: window 47 + CE47 — 224,296 above H0 (225k now just 704 out — crossing expected in w48), 959,989 certified, 2nd consecutive CLEAN
- **0353 (M5 LANE - WINDOW 47 + CE47):** window 47 landed. Launch a47 =
  12,363,154,377,119 (= b46), b = a + 20,000 (NO snap), M = 60, C_R = 1,
  28 workers, N_range [691008, 691008], 33,302 evals, 2511.2 s.
- **Seam audit FIRST (0348 rule):** g_a47 ≡ g_b46 exact dyadic tuple
  [232127340076921836790130566544415780883, −86, 16777217, −110] —
  bit-identical, before CE47 was written.
- **SECOND CONSECUTIVE CLEAN WINDOW:** 0 Rosser failures / rescues /
  cross-check failures / Gram mismatches. Clean tally now 21 of 48 chain
  windows. Rosser runs 48/47 (both ≥ K = 12).
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,302, sign_changes_inside 20,000 = b − a,
  K_conservative 12 (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6],
  doubled [11.4380 ± 1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] —
  all < 12); endpoints recomputed and matched.
- **Frontier (machine, in CE47):** g_b47 = 3,000,175,557,096.891113281250
  ± 1.29e-26 — exact recorded tuple
  [116063670219236339931915844848888957081, −85, 16777217, −110].
  **tCE47 = 3,000,175,557,096**; tCE47 − tCE46 = **4,673** — the 16th
  increment: the 4,673 RESUME after the 4,672 break of w45→46 (spacings
  wobble by units; no periodicity assumed). tCE47 − tPT2 = **224,296**;
  **225k mark now only 704 ahead (~1/7 window) — crossing expected in
  w48; compute the floor, do not pre-announce.** NO CASING (two-dec
  round-down 0.89 ≠ 0.00; margin ~1.1e-3; CE38 remains the only CASING
  case).
- **Cumulative certified zeros over (g_a1, g_b47] = 939,989 + 20,000 =
  959,989.**
- **CE47.lean GREEN** (8,813 targeted jobs, 0 errors, 0 warnings; full
  tree green; olean fresh): gB47Lo := 300017555709689/100;
  ce46WinClauseFull (w46 full slice re-cited); ce47WinClause (terminal
  slice); 48-way band; terminalFaceCE47 NAMED OPEN; iff/split/reanchor/
  thetaInf at the new frontier; machine facts incl. faceShrinkCE47 = 4673
  and frontierGapAboveH0 = 224296.
- **M2:** SWall GREEN in the same tree; wall {θ | 4/7 < θ} PINNED.
- **NO RH CLAIM.** Face open at tCE47; next unit — window 48
  (a48 = 12,363,154,397,119), the expected 225k milestone-crossing unit
  (if the floor arithmetic confirms).

## 85 · 0354: window 48 + CE48 — ★ MILESTONE: the 225,000-unit mark is CROSSED (228,969 above H0, proven in-tree as frontierPast225k) — 979,989 certified (960k also crossed), 3rd consecutive CLEAN
- **0354 (M5 LANE - WINDOW 48 + CE48, MILESTONE UNIT):** window 48
  landed. Launch a48 = 12,363,154,397,119 (= b47), b = a + 20,000
  (NO snap), M = 60, C_R = 1, 28 workers, N_range [691008, 691008],
  33,506 evals, 2574.9 s.
- **Seam audit FIRST (0348 rule):** g_a48 ≡ g_b47 exact dyadic tuple
  [116063670219236339931915844848888957081, −85, 16777217, −110] —
  bit-identical, before CE48 was written.
- **THIRD CONSECUTIVE CLEAN WINDOW** (after w46, w47): 0 Rosser
  failures / rescues / mismatches. Clean tally now 22 of 49 chain
  windows. Rosser runs 48/48 (both ≥ K = 12).
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,506, sign_changes_inside 20,000 = b − a,
  K_conservative 12 (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6],
  doubled [11.4380 ± 1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] —
  all < 12); endpoints recomputed and matched.
- **★ THE CROSSING (machine, PROVEN in CE48):** g_b48 =
  3,000,175,561,769.826171875000 ± 1.29e-26 — exact recorded tuple
  [232127340800023522916592057211907166017, −86, 16777217, −110].
  **tCE48 = 3,000,175,561,769**; tCE48 − tCE47 = 4,673 (17th
  increment — the 4,673 pace after the one-shot 4,672 break);
  **tCE48 − tPT2 = 228,969 > 225,000 — the 225,000-unit frontier mark
  is CROSSED (by 3,969)**; proven in-tree as
  `frontierPast225k : (tCE48 : ℝ) - WinC.tPT2 > 225000` (from
  frontierGapAboveH0 = 228969, by linarith) — exactly as
  frontierPast200k was proven in CE42B. NO CASING (two-dec round-down
  0.82 ≠ 0.00; margin ~1.7e-3; CE38 remains the only CASING case).
- **Round-mark sequence above H0 (each proven in-tree when crossed):**
  100,000 @ CE22 (102,801) · 125,000 @ CE27 (126,165) · 150,000 @
  CE33 (154,203) · 175,000 @ CE38 (177,568) · 200,000 @ CE42B
  (200,932) · **225,000 @ CE48 (228,969)**. Next: 250,000 — 21,031
  ahead (~4.5 windows).
- **Cumulative certified zeros over (g_a1, g_b48] = 959,989 + 20,000 =
  979,989 — the 960,000 mark was also crossed inside window 48.**
  Watch: 1,000,000 certified zeros sits 20,011 ahead — it will be
  crossed in window 50 (w49 lands at 999,989, 11 short).
- **CE48.lean GREEN** (8,814 targeted jobs, 0 errors, 0 warnings; full
  tree green; olean fresh): gB48Lo := 300017556176982/100;
  ce47WinClauseFull (w47 full slice re-cited); ce48WinClause (terminal
  slice); 49-way band; terminalFaceCE48 NAMED OPEN; iff/split/reanchor/
  thetaInf at the new frontier.
- **WHAT THE CROSSING IS (and is not):** a frontier record on route
  (b) — more height certified all-on-the-line than any prior step of
  the program — machine-proven in-tree. NOT an RH statement: all-
  heights RH still requires the open terminal face plus one of the
  pinned analytic doors (M2 wall {θ | 4/7 < θ} PINNED via SWall;
  absolute clause dead as published input; θ=∞ lane conjectural).
- **NO RH CLAIM.** Face open at tCE48; next unit — window 49
  (a49 = 12,363,154,417,119).

## 86 · 0355: window 49 + CE49 — 225k crossing CARRIED at the new frontier (233,642 above H0); 999,989 certified = ELEVEN short of 1M (lands in w50); 4th consecutive CLEAN
- **0355 (M5 LANE - WINDOW 49 + CE49):** window 49 landed.
  Launch a49 = 12,363,154,417,119 (= b48), b = a + 20,000 (NO snap),
  M = 60, C_R = 1, 28 workers, N_range [691008, 691008], 32,784
  evals, 2436.3 s (fastest recent window).
- **Seam audit FIRST (0348 rule):** g_a49 ≡ g_b48 exact dyadic tuple
  [232127340800023522916592057211907166017, −86, 16777217, −110] —
  bit-identical, before CE49 was written.
- **FOURTH CONSECUTIVE CLEAN WINDOW** (after w46–w48): 0 Rosser
  failures / rescues / mismatches. Clean tally now 23 of 50 chain
  windows. Rosser runs 48/50 (both ≥ K = 12).
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 32,784, sign_changes_inside 20,000 = b − a,
  K_conservative 12 (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6],
  doubled [11.4380 ± 1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] —
  all < 12); endpoints recomputed and matched.
- **Frontier:** g_b49 = 3,000,175,566,442.761230468750 ± 1.29e-26 —
  exact recorded tuple [29015917645196795743551458640382313851, −83,
  16777217, −110]. **tCE49 = 3,000,175,566,442**;
  tCE49 − tCE48 = 4,673 (18th increment — the 4,673 pace after the
  one-shot 4,672 break); **tCE49 − tPT2 = 233,642** — the 225,000-unit
  mark (CE48) is CARRIED, re-proven in-tree as
  `frontierPast225k : (tCE49 : ℝ) - WinC.tPT2 > 225000`; the next
  round mark 250,000 now sits 16,358 ahead (~3.5 windows). NO CASING
  (two-dec round-down 0.76 ≠ 0.00; margin ~3.9e-3; CE38 remains the
  only CASING case).
- **Cumulative certified zeros over (g_a1, g_b49] = 979,989 + 20,000 =
  999,989 — ELEVEN SHORT of the 1,000,000 mark: the 1M crossing
  lands in WINDOW 50** (999,989 + 20,000 = 1,019,989 at w50's end —
  recorded from the verified data in CE50).
- **CE49.lean GREEN** (8,815 targeted jobs, 0 errors, 0 warnings; full
  tree green; olean fresh): gB49Lo := 300017556644276/100;
  ce48WinClauseFull (w48 full slice re-cited); ce49WinClause (terminal
  slice); 50-way band; terminalFaceCE49 NAMED OPEN; iff/split/
  reanchor/thetaInf at the new frontier.
- **No analytic move:** the named terminal face is the same open
  object (terminalFaceCE49); M2 wall {θ | 4/7 < θ} pinned; absolute
  clause dead as published input; θ=∞ lane conjectural.
- **NO RH CLAIM.** Next unit — window 50 (a50 = 12,363,154,437,119),
  expected to carry the 1M certified-zero crossing (and, if the floor
  allows, the 250k frontier crossing).

## 87 · 0356: window 50 + CE50 — ★ MILESTONE (CERTIFIED COUNT): the 1,000,000-certified-zero mark is CROSSED (1,019,989 total); 225k carried at 238,315; 5th consecutive CLEAN
- **0356 (M5 LANE - WINDOW 50 + CE50, MILESTONE UNIT):** window 50
  landed. Launch a50 = 12,363,154,437,119 (= b49), b = a + 20,000
  (NO snap), M = 60, C_R = 1, 28 workers, N_range [691008, 691008],
  33,100 evals, 2460.0 s.
- **Seam audit FIRST (0348 rule):** g_a50 ≡ g_b49 exact dyadic tuple
  [29015917645196795743551458640382313851, −83, 16777217, −110] —
  bit-identical, before CE50 was written.
- **FIFTH CONSECUTIVE CLEAN WINDOW** (after w46–w49): 0 Rosser
  failures / rescues / mismatches. Clean tally now 24 of 51 chain
  windows. Rosser runs 49/44 (both ≥ K = 12).
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,100, sign_changes_inside 20,000 = b − a,
  K_conservative 12 (K_required: Trudgian Cor2.3 [5.71899 ± 1.23e-6],
  doubled [11.4380 ± 1.76e-5], Amberger Thm2.3 [9.14967 ± 4.14e-6] —
  all < 12); endpoints recomputed and matched.
- **★ CERTIFIED-COUNT MILESTONE (recorded from the verified chain
  counts — pipeline data, cited, not re-derived in-tree):**
  cumulative over (g_a1, g_b50] = 999,989 + 20,000 =
  **1,019,989 — the 1,000,000-certified-zero mark is CROSSED in
  window 50.** Round marks for certified counts: 800,000 @ CE41 ·
  900,000 @ w45 · 960,000 @ w48 · **1,000,000 @ w50 (this unit)**.
  The first seven-figure all-on-the-line certified region in the
  program's history.
- **Frontier:** g_b50 = 3,000,175,571,115.696289062500 ± 1.29e-26 —
  exact recorded tuple [116063670761562604479645262733743461387,
  −85, 16777217, −110]. **tCE50 = 3,000,175,571,115**;
  tCE50 − tCE49 = 4,673 (19th increment); **tCE50 − tPT2 =
  238,315** — the 225,000-unit mark (CE48) is CARRIED, re-proven
  in-tree as `frontierPast225k` at the new frontier; the next
  round mark 250,000 now sits **11,685 ahead (~2.5 windows —
  expect w52 or w53)**. NO CASING (two-dec round-down 0.69 ≠ 0.00;
  margin ~3.1e-3; CE38 remains the only CASING case).
- **CE50.lean GREEN** (8,816 targeted jobs, 0 errors, 0 warnings;
  full tree green; olean fresh): gB50Lo := 300017557111569/100;
  ce49WinClauseFull (w49 full slice re-cited); ce50WinClause
  (terminal slice); 51-way band; terminalFaceCE50 NAMED OPEN;
  iff/split/reanchor/thetaInf at the new frontier.
- **WHAT THE MILESTONE IS (and is not):** a frontier record — the
  largest all-on-the-line certified region the program has ever
  assembled. NOT an RH statement: all-heights RH still requires the
  open terminal face plus one of the pinned analytic doors (M2 wall
  {θ | 4/7 < θ} PINNED via SWall; absolute clause dead as published
  input; θ=∞ lane conjectural).
- **NO RH CLAIM.** Next unit — window 51 (a51 = 12,363,154,457,119).

## 88 · 0357: window 51 + CE51 — SNAPPED window (width 19,999) with ONE recorded, quota-met Rosser rescue; 225k carried at 242,988; certified total 1,039,988
- **0357 (M5 LANE - WINDOW 51 + CE51):** window 51 landed.
  Launch a51 = 12,363,154,457,119 (= b50), b requested = a + 20,000,
  **b ACTUAL = 12,363,154,477,118 — SNAPPED DOWN by 1** (requested
  endpoint not a good Gram point at working precision; a remains
  good). Width b − a = 19,999. First snapped window since w40
  (19,998); snapped-width family now 2, 3, 8, 11, 17, 18, 19, 21,
  31, 40, 51. M = 60, C_R = 1, 28 workers, N_range
  [691008, 691008], 33,636 evals, 2532.2 s.
- **Seam audit FIRST (0348 rule):** g_a51 ≡ g_b50 exact dyadic
  tuple [116063670761562604479645262733743461387, −85, 16777217,
  −110] — bit-identical, before CE51 was written.
- **ONE ROSSER-BLOCK EXCEPTION, RESCUED, QUOTA-MET, RECORDED**
  (not suppressed): block [12,363,154,473,629, 12,363,154,473,632]
  (need 3, found 1, 193 pts, m = 64) → union [12,363,154,473,628,
  12,363,154,473,633] (need 5, **found 5**, m = 4). First internal
  exception since w45 (double-rescue): the five-consecutive-clean
  streak (w46–w50) ends here. Honest tally: 24 of 52 chain windows
  clean. The block is INTERIOR — it touches neither end Rosser
  run, and the verifier's recompute of the window total + end runs
  (the only quantities in the Turing step) passes.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,636, sign_changes_inside 19,999 = b − a,
  roesser_failures_inside 1 (the recorded rescue), Rosser runs
  49/47, K_conservative 12 (K_required: Trudgian Cor2.3
  [5.71899 ± 1.23e-6], doubled [11.4380 ± 1.76e-5], Amberger
  Thm2.3 [9.14967 ± 4.14e-6] — all < 12); endpoints recomputed and
  matched.
- **Frontier:** g_b51 = 3,000,175,575,788.397949218750 ±
  1.29e-26 — exact recorded tuple [116063670942328987203539826434559195545,
  −85, 16777217, −110]. **tCE51 = 3,000,175,575,788**;
  tCE51 − tCE50 = 4,673 (20th increment); **tCE51 − tPT2 =
  242,988** — the 225,000-unit mark (CE48) is CARRIED, re-proven
  as `frontierPast225k`; the 250,000-unit mark now sits **7,012
  ahead — expect the crossing in window 53** (7,012 − ~4,673 =
  ~2,339 after w52; the next ~4,673 carries it). NO CASING (two-
  dec round-down 0.39 ≠ 0.00; margin ~6.0e-3).
- **CE51.lean GREEN** (8,817 targeted jobs, 0 errors, 0 warnings;
  full tree green; olean fresh): gB51Lo := 300017557578839/100;
  ce50WinClauseFull (w50 full slice re-cited); ce51WinClause
  (SNAPPED terminal slice, documented); 52-way band;
  terminalFaceCE51 NAMED OPEN; iff/split/reanchor/thetaInf at the
  new frontier.
- **Certified count (pipeline data, machine-tracked; the snap cost
  one unit):** 1,019,989 + 19,999 = **1,039,988** over (g_a1,
  g_b51]. The 1M mark (w50) is carried.
- **NO analytic move:** face open at tCE51; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 52 (a52 = 12,363,154,477,118).

## 89 · 0358: window 52 + CE52 — SNAPPED again (width 19,999, second in a row) with TWO recorded quota-met Rosser rescues; 225k carried at 247,661; 250k mark now only 2,339 ahead (crossing expected in w53); certified total 1,059,987
- **0358 (M5 LANE - WINDOW 52 + CE52):** window 52 landed.
  Launch a52 = 12,363,154,477,118 (= b51 — the SNAPPED endpoint of
  w51), b requested = a + 20,000 = 12,363,154,497,118, **b ACTUAL =
  12,363,154,497,117 — SNAPPED DOWN by 1 again** (requested endpoint
  not a good Gram point at working precision; a remains good).
  Width b − a = 19,999 — the SECOND consecutive snapped window
  (w51, w52). Snapped-width family now: 2, 3, 8, 11, 17, 18, 19,
  21, 31 (19,999), 40 (19,998), 51, 52 (19,999). M = 60, C_R = 1,
  28 workers, N_range [691008, 691008], 33,708 evals, 2498.0 s.
- **Seam audit FIRST (0348 rule):** g_a52 ≡ g_b51 exact dyadic
  tuple [116063670942328987203539826434559195545, −85, 16777217,
  −110] — bit-identical, BEFORE CE52 was written.
- **TWO ROSSER-BLOCK EXCEPTIONS, RESCUED, QUOTA-MET, RECORDED**
  (not suppressed): (1) block [12,363,154,479,388,
  12,363,154,479,390] (need 2, found 0, 129 pts, m = 64) → union
  [12,363,154,479,387, 12,363,154,479,392] (need 5, **FOUND 5**,
  m = 4); (2) block [12,363,154,480,004, 12,363,154,480,007]
  (need 3, found 1, 193 pts, m = 64) → union [12,363,154,480,003,
  12,363,154,480,009] (need 6, **FOUND 6**, m = 2). Both RESCUED
  BLOCKS ARE INTERIOR — they touch neither end Rosser run; the
  verifier's recompute of the WINDOW TOTAL (19,999) and the two
  END RUNS (48/45) — the only quantities in the Turing step —
  passes.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,708, sign_changes_inside 19,999 = b − a,
  roesser_failures_inside 2 (both recorded quota-met rescues),
  Rosser runs 48/45, K_conservative 12 (K_required: Trudgian
  Cor2.3 [5.71899 ± 1.23e-6], doubled [11.4380 ± 1.76e-5],
  Amberger Thm2.3 [9.14967 ± 4.14e-6] — all < 12); endpoints
  recomputed and matched.
- **Frontier:** g_b52 = 3,000,175,580,461.099121093750 ±
  1.29e-26 — exact recorded tuple [113343428831147822184536190820181931,
  −75, 16777217, −110]. **tCE52 = 3,000,175,580,461**;
  tCE52 − tCE51 = 4,673 (21st increment); **tCE52 − tPT2 =
  247,661** — the 225,000-unit mark (CE48) is CARRIED, re-proven
  as `frontierPast225k`; **THE 250,000-UNIT MARK NOW SITS 2,339
  AHEAD — CROSSING EXPECTED IN WINDOW 53** (compute from the
  decoded endpoint when it lands; the crossing module proves
  `frontierPast250k`). NO CASING (two-dec round-down 0.09 ≠ 0.00;
  margin ~9.1e-3).
- **CE52.lean GREEN** (8,818 targeted jobs, 0 errors, 0 warnings;
  full tree green; olean fresh): gB52Lo := 300017558046109/100;
  ce51WinClauseFull (w51 full slice re-cited); ce52WinClause
  (SNAPPED terminal slice with the two recorded rescues,
  documented); 53-way band; terminalFaceCE52 NAMED OPEN;
  iff/split/reanchor/thetaInf at the new frontier.
- **Certified count (pipeline data, machine-tracked; the snap cost
  one unit):** 1,039,988 + 19,999 = **1,059,987** over (g_a1,
  g_b52]. The 1M mark (w50) is carried.
- **Honest tally:** 24 of 53 chain windows clean; rescue windows
  7, 21, 28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51
  (one), 52 (two) — all quota-met, none suppressed.
- **NO analytic move:** face open at tCE52; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 53 (a53 = 12,363,154,497,117)
  — where the 250,000-unit frontier mark is expected to cross.

## 90 · 0359: window 53 + CE53 — THE 250,000-UNIT FRONTIER MILESTONE IS CROSSED (252,334 above H0, proven in-tree as frontierPast250k); NON-SNAPPED window (width 20,000, the w51/w52 streak ends) with THREE recorded quota-met Rosser rescues; certified total 1,079,987
- **0359 (M5 LANE - WINDOW 53 + CE53 — THE 250 000-UNIT MILESTONE UNIT).**
  Launch a53 = 12,363,154,497,117 (= b52), b requested = a + 20,000 =
  12,363,154,517,117, **b ACTUAL = 12,363,154,517,117 — NON-SNAPPED**
  (the requested endpoint WAS a good Gram point; width b − a = 20,000;
  the two-in-a-row snapped streak w51/w52 ENDS here). M = 60, C_R = 1,
  28 workers, N_range [691008, 691008], 34,037 evals, 2554.0 s.
- **Seam audit FIRST (0348 rule):** g_a53 ≡ g_b52 exact dyadic
  tuple [113343428831147822184536190820181931, −75, 16777217, −110]
  — bit-identical, BEFORE CE53 was written.
- **THREE ROSSER-BLOCK EXCEPTIONS, RESCUED, QUOTA-MET, RECORDED**
  (not suppressed): (1) [12,363,154,499,170, 12,363,154,499,172]
  (need 2, found 0, 129 pts, m = 64) → union [12,363,154,499,169,
  12,363,154,499,173] (need 4, **found 4**, m = 4); (2)
  [12,363,154,507,862, 12,363,154,507,864] (need 2, found 0, 129 pts,
  m = 64) → union [12,363,154,507,861, 12,363,154,507,866] (need 5,
  **found 5**, m = 8); (3) [12,363,154,510,768,
  12,363,154,510,770] (need 2, found 0, 129 pts, m = 64) → union
  [12,363,154,510,767, 12,363,154,510,772] (need 5, **found 5**,
  m = 2). All three INTERIOR — the verifier's recompute of the WINDOW
  TOTAL (20,000) and the two END RUNS (47/49) — the only quantities
  in the Turing step — passes. The most rescues in a single window
  of the corrected chain.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 34,037, sign_changes_inside 20,000 = b − a,
  roesser_failures_inside 3 (all recorded quota-met rescues), Rosser
  runs 47/49, K_conservative 12 (K_required all < 12); endpoints
  recomputed and matched.
- **THE MILESTONE:** g_b53 = 3,000,175,585,134.034179687500 ±
  1.29e-26 — exact recorded tuple [29015917825967697847748600342133254453,
  −83, 16777217, −110]. **tCE53 = 3,000,175,585,134**;
  tCE53 − tCE52 = 4,673 (22nd increment); **tCE53 − tPT2 =
  252,334 — the 250,000-unit mark is CROSSED in window 53, exactly
  where the ~4,673/window pace predicted** (2,339 short at w52's
  end). Proven in-tree: `frontierPast250k : (tCE53 : ℝ) -
  WinC.tPT2 > 250000`. Round-mark sequence above H0: 100k @ CE22,
  125k @ CE27, 150k @ CE33, 175k @ CE38, 200k @ CE42B, 225k @ CE48,
  **250k @ CE53**; next 275k sits 22,666 ahead (expect w59 or w60).
  NO CASING (two-dec round-down 0.03 ≠ 0.00; margin ~4.2e-3).
- **CE53.lean GREEN** (8,819 targeted jobs for CE52+CE53, 0 errors,
  0 warnings; full tree green; olean fresh, both): gB53Lo :=
  300017558513403/100; ce52WinClauseFull (w52 full slice re-cited);
  ce53WinClause (terminal slice, documented); 54-way band;
  terminalFaceCE53 NAMED OPEN; iff/split/reanchor/thetaInf at the
  new frontier.
- **PROVENANCE REPAIR (this unit):** a doc-line misattribution was
  found and repaired in CE52.lean and CE53.lean — the re-cited
  full-slice clause docs above ce51WinClauseFull / ce52WinClauseFull
  had carried the stale WINDOW-50 attribution from the generator;
  they now correctly cite the window-51 / window-52 certificates
  with matching derivations. Theorem content was never affected;
  both modules re-built GREEN after the repair.
- **Certified count (pipeline data, machine-tracked):** 1,059,987 +
  20,000 = **1,079,987** over (g_a1, g_b53] (full width, no snap
  cost). The 1M mark (w50) is carried.
- **Honest tally:** 24 of 54 chain windows clean; rescue windows
  7, 21, 28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51
  (one), 52 (two), 53 (three) — all quota-met, none suppressed.
- **NO analytic move:** face open at tCE53; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 54 (a54 = 12,363,154,517,117);
  the 275,000-unit mark is 22,666 ahead (expect w59 or w60).

## 91 · 0360: window 54 + CE54 — NON-SNAPPED (width 20,000), one recorded quota-met Rosser rescue; THE 4,672 INCREMENT RECURS (the w45/w46 one-shot anomaly — second occurrence, no pattern claimed); tCE54 = 257,006 above H0 (250k milestone CARRIED, frontierPast250k re-proven); certified 1,099,987 (1.1M mark 13 short — expect w55)
- **0360 (M5 LANE - WINDOW 54 + CE54).**
  Launch a54 = 12,363,154,517,117 (= b53), b requested = a + 20,000 =
  12,363,154,537,117, **b ACTUAL = 12,363,154,537,117 — NON-SNAPPED**
  (width 20,000). M = 60, C_R = 1, 28 workers, N_range [691008, 691008],
  33,606 evals, 2559.1 s.
- **Seam audit FIRST (0348 rule):** g_a54 ≡ g_b53 exact dyadic
  tuple [29015917825967697847748600342133254453, −83, 16777217, −110]
  — bit-identical, BEFORE CE54 was written.
- **ONE ROSSER-BLOCK EXCEPTION, RESCUED, QUOTA-MET, RECORDED:**
  [12,363,154,518,280, 12,363,154,518,282] (need 2, found 0, 129 pts,
  m = 64) → union [12,363,154,518,279, 12,363,154,518,283] (need 4,
  **found 4**, m = 4). INTERIOR — the verifier's recompute of the
  WINDOW TOTAL (20,000) and END RUNS (48/49) — the only quantities in
  the Turing step — passes.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,606, sign_changes_inside 20,000 = b − a,
  roesser_failures_inside 1 (the recorded rescue), Rosser runs 48/49,
  K_conservative 12 (K_required all < 12; identical to w53 — same
  N_range); endpoints recomputed and matched.
- **INCREMENTS: 4,672 — THE RECURRING ANOMALY.** g_b54 =
  3,000,175,589,806.969726562500 ± 1.29e-26 — exact tuple
  [232127342969292425709106731252692813973, −86, 16777217, −110].
  **tCE54 = 3,000,175,589,806**; **tCE54 − tCE53 = 4,672** — the
  w45/w46 one-shot 4,672 anomaly RECURS (second 4,672 in the chain;
  the other twenty corrected-chain increments are 4,673); no pattern
  assumed, recorded honestly. **tCE54 − tPT2 = 257,006** — the 250k
  MILESTONE (CE53, 252,334) is CARRIED, re-proven in-tree
  (`frontierPast250k`); next round mark 275k sits 17,994 ahead
  (expect w58 or w59). NO CASING (two-dec round-down 0.96 ≠ 0.00;
  margin ~9.7e-3).
- **CE54.lean GREEN** (8,820 targeted jobs, 0 errors, 0 warnings;
  full tree green; olean fresh): gB54Lo := 300017558980696/100;
  faceShrinkCE54 = 4672; frontierGapAboveH0 = 257006; all four
  milestone-carry theorems re-proven; ce53WinClauseFull (w53 full
  slice re-cited); ce54WinClause (terminal slice, documented); 55-way
  band; terminalFaceCE54 NAMED OPEN. All 19 declaration doc blocks
  swept to CE54-correct text; clause-doc audit passes.
- **Certified count (pipeline data, machine-tracked):** 1,079,987 +
  20,000 = **1,099,987** over (g_a1, g_b54] (full width). The 1M mark
  (w50) is carried; the **1,100,000 mark is now 13 short — expect w55**.
- **Honest tally:** 25 of 55 chain windows clean; rescue windows 7,
  21, 28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51 (one), 52
  (two), 53 (three), 54 (one) — all quota-met, none suppressed.
- **NO analytic move:** face open at tCE54; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 55 (a55 = 12,363,154,537,117);
  the 1,100,000-certified-zero mark is 13 short (expect w55); the
  275,000-unit mark is 17,994 ahead (expect w58 or w59).

## 92 · 0361: window 55 + CE55 — THE 1,100,000 CERTIFIED-ZERO MARK LANDED (1,119,987 total, exactly where predicted); NON-SNAPPED (width 20,000) with one recorded quota-met Rosser rescue (odd-width-5 union); the standing 4,673 increment RESUMES; tCE55 = 261,679 above H0 (250k milestone CARRIED, frontierPast250k re-proven); 275k mark now 13,321 ahead (expect w59)
- **0361 (M5 LANE - WINDOW 55 + CE55 — THE 1.1M CERTIFIED-ZERO MILESTONE UNIT).**
  Launch a55 = 12,363,154,537,117 (= b54), b requested = a + 20,000 =
  12,363,154,557,117, **b ACTUAL = 12,363,154,557,117 — NON-SNAPPED**
  (width 20,000). M = 60, C_R = 1, 28 workers, N_range [691008, 691008],
  33,350 evals, 2471.6 s.
- **Seam audit FIRST (0348 rule):** g_a55 ≡ g_b54 exact dyadic
  tuple [232127342969292425709106731252692813973, −86, 16777217, −110]
  — bit-identical, BEFORE CE55 was written.
- **ONE ROSSER-BLOCK EXCEPTION, RESCUED, QUOTA-MET, RECORDED:**
  [12,363,154,556,936, 12,363,154,556,938] (need 2, found 0, 129 pts,
  m = 64) → union [12,363,154,556,934, 12,363,154,556,939] (need 5,
  **found 5**, m = 4) — **odd union width 5** (extended two left, one
  right: the standard +1/+1 widening is not always enough). INTERIOR —
  the verifier's recompute of the WINDOW TOTAL (20,000) and END RUNS
  (47/47) — the only quantities in the Turing step — passes.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,350, sign_changes_inside 20,000 = b − a,
  roesser_failures_inside 1 (the recorded rescue), Rosser runs 47/47,
  K_conservative 12 (K_required all < 12; identical to w53/w54 — same
  N_range); endpoints recomputed and matched.
- **THE 1,100,000 CERTIFIED-ZERO MARK:** 1,099,987 (w54) + 20,000 =
  **1,119,987 ≥ 1,100,000 — LANDED IN WINDOW 55, exactly where
  predicted** (13 short at w54's end). Round-mark sequence (zeros):
  800k @ CE41, 900k @ w45, 960k @ w48, 1M @ w50, **1.1M @ w55**. Next
  mark 1.2M is 80,013 ahead (expect ~w59/60). (Pipeline data —
  recorded, not in-tree arithmetic.)
- **INCREMENTS: 4,673 — THE STANDING PACE RESUMES.** g_b55 =
  3,000,175,594,479.904785156250 ± 1.29e-26 — exact tuple
  [29015917916355408576910488047858487921, −83, 16777217, −110].
  **tCE55 = 3,000,175,594,479**; tCE55 − tCE54 = 4,673 (the two 4,672's
  at w45→w46 and w53→w54 remain isolated deviations — no pattern).
  **tCE55 − tPT2 = 261,679** — 250k MILESTONE (CE53) CARRIED,
  re-proven (`frontierPast250k`); next mark 275k is 13,321 ahead
  (expect w59). NO CASING (two-dec round-down 0.90 ≠ 0.00; margin
  ~4.8e-3).
- **CE55.lean GREEN** (8,821 targeted jobs, 0 errors, 0 warnings;
  full tree green; olean fresh): gB55Lo := 300017559447990/100;
  faceShrinkCE55 = 4673; frontierGapAboveH0 = 261679; four
  milestone-carry theorems re-proven; ce54WinClauseFull (w54 full
  slice re-cited); ce55WinClause (terminal slice, documented); 56-way
  band; terminalFaceCE55 NAMED OPEN; all 19 doc blocks swept;
  clause-doc audit OK.
- **Honest tally:** 26 of 56 chain windows clean; rescue windows 7,
  21, 28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51 (one), 52
  (two), 53 (three), 54 (one), 55 (one) — all quota-met, none
  suppressed.
- **NO analytic move:** face open at tCE55; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 56 (a56 = 12,363,154,557,117);
  the 275,000-unit mark is 13,321 ahead (expect w59); the
  1,200,000-certified-zero mark is 80,013 ahead (expect ~w59/60).

## 93 · 0362: window 56 + CE56 — NON-SNAPPED (width 20,000); FOUR recorded quota-met Rosser rescues (the most in a window since w53's three; one odd-width-5 union); 4,673 standing pace; tCE56 = 266,352 above H0 (250k CARRIED; 275k now only 8,648 ahead — expect w58 or w59); certified 1,139,987 (1.1M carried)
- **0362 (M5 LANE - WINDOW 56 + CE56).**
  Launch a56 = 12,363,154,557,117 (= b55), b = a + 20,000 = 12,363,154,577,117
  — **NON-SNAPPED** (width 20,000). M = 60, C_R = 1, 28 workers,
  N_range [691008, 691008], 34,778 evals, 2647.0 s.
- **Seam audit FIRST (0348 rule):** g_a56 ≡ g_b55 exact dyadic
  [29015917916355408576910488047858487921, −83, 16777217, −110] —
  bit-identical, BEFORE CE56 was written.
- **FOUR ROSSER-BLOCK EXCEPTIONS (the most in a window since w53) —
  ALL RESCUED, QUOTA-MET, RECORDED, INTERIOR:**
  (1) [..560,392, ..560,394] need 2, found 0, 129 pts, m = 64 →
  union [..560,391, ..560,396] need 5, **FOUND 5**, m = 8;
  (2) [..568,076, ..568,079] need 3, found 1, 193 pts →
  union [..568,075, ..568,080] need 5, **FOUND 5**, m = 8;
  (3) [..571,197, ..571,199] need 2, found 0, 129 pts →
  union [..571,195, ..571,200] need 5, **FOUND 5**, m = 4;
  (4) [..575,445, ..575,448] need 3, found 1, 193 pts →
  union [..575,443, ..575,449] need 6, **FOUND 6**, m = 8.
  The verifier's recompute of the WINDOW TOTAL (20,000) and END
  RUNS (49/48) — the only quantities in the Turing step — passes.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 34,778, sign_changes_inside 20,000 = b − a,
  roesser_failures_inside 4 (the four recorded rescues), Rosser
  runs 49/48, K_conservative 12.
- **Endpoint:** g_b56 = 3,000,175,599,152.839843750000 ± 1.29e-26 —
  exact tuple [232127343692394111500520322163846277315, −86,
  16777217, −110]. **tCE56 = 3,000,175,599,152**.
- **INCREMENTS: 4,673 (standing pace continues).**
  tCE56 − tCE55 = 4,673; **tCE56 − tPT2 = 266,352** — 250k
  MILESTONE (CE53) CARRIED, re-proven (`frontierPast250k`); next
  mark 275k is **8,648 ahead — expect window 58 or 59**.
  NO CASING (frac 0.8398, margin ~9.8e-3).
- **Certified total: 1,119,987 + 20,000 = 1,139,987.** 1.1M mark
  [w55] carried; 1.2M mark 60,013 ahead (running total at w59
  should be 1,199,987 — 13 short again — crossing expected w60).
- **CE56.lean GREEN** (8,822 targeted jobs, 0 errors 0 warnings;
  full tree green; olean fresh): gB56Lo := 300017559915283/100;
  faceShrinkCE56 = 4673; frontierGapAboveH0 = 266352; four
  milestone-carry theorems re-proven; ce55WinClauseFull (w55 full
  slice re-cited); ce56WinClause (terminal slice, documented); 57-way
  band; terminalFaceCE56 NAMED OPEN; all 19 doc blocks swept;
  clause-doc audit OK.
- **Honest tally:** 26 of 57 chain windows clean; rescue windows
  7, 21, 28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51 (one),
  52 (two), 53 (three), 54 (one), 55 (one), **56 (four)** — all
  quota-met, none suppressed.
- **NO analytic move:** face open at tCE56; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 57 (a57 = 12,363,154,577,117).

## 94 · 0363: window 57 + CE57 — CLEAN WINDOW (zero Rosser failures, first since w50), NON-SNAPPED (width 20,000); 4,673 standing pace; tCE57 = 271,025 above H0 (250k CARRIED; 275k now only 3,975 ahead — EXPECTED TO LAND IN W58); certified 1,159,987
- **0363 (M5 LANE - WINDOW 57 + CE57).**
  Launch a57 = 12,363,154,577,117 (= b56), b = a + 20,000 = 12,363,154,597,117
  — **NON-SNAPPED** (width 20,000). M = 60, C_R = 1, 28 workers,
  N_range [691008, 691008], 33,523 evals, 2519.3 s.
- **Seam audit FIRST (0348 rule):** g_a57 ≡ g_b56 exact dyadic
  [232127343692394111500520322163846277315, −86, 16777217, −110] —
  bit-identical, BEFORE CE57 was written.
- **CLEAN WINDOW:** roesser_failures_inside = 0 — the FIRST clean window
  since window 50 (w51–w56 carried 1, 2, 3, 1, 1, 4 recorded rescues).
  Nothing to record or suppress. End Rosser runs 49/48 (both ≥ 12);
  0 cross-check failures; 0 undetermined Gram signs.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,523, sign_changes_inside 20,000 = b − a,
  K_conservative 12, endpoints recomputed and matched.
- **Endpoint:** g_b57 = 3,000,175,603,825.774902343750 ± 1.29e-26 —
  exact tuple [116063672026972477182407992315941454601, −85,
  16777217, −110]. **tCE57 = 3,000,175,603,825**.
- **INCREMENTS: 4,673 (standing pace continues).**
  **tCE57 − tPT2 = 271,025** — 250k MILESTONE (CE53) CARRIED,
  re-proven (`frontierPast250k`); next mark 275k is **3,975 ahead —
  EXPECTED TO LAND IN W58** (271,025 + 4,672 = 275,697 ≥ 275,000 at even
  the slowest observed increment). NO CASING (frac 0.7749, margin ~4.9e-3).
- **Certified total: 1,139,987 + 20,000 = 1,159,987.** 1.1M mark [w55]
  carried; 1.2M mark 40,013 ahead (running total at w59 should land
  1,199,987 — 13 short again — crossing expected w60).
- **CE57.lean GREEN** (8,823 targeted jobs, 0 errors 0 warnings; olean
  fresh): gB57Lo := 300017560382577/100; faceShrinkCE57 = 4673;
  frontierGapAboveH0 = 271025; four milestone-carry theorems re-proven;
  ce56WinClauseFull (w56 full slice re-cited); ce57WinClause (terminal
  slice, documented); 58-way band; terminalFaceCE57 NAMED OPEN; all 19
  doc blocks swept; clause-doc audit OK.
- **Honest tally:** 27 of 58 chain windows clean; rescue windows 7, 21,
  28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51 (one), 52 (two),
  53 (three), 54 (one), 55 (one), 56 (four) — all quota-met, none
  suppressed.
- **NO analytic move:** face open at tCE57; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 58 (a58 = 12,363,154,597,117);
  the 275,000-unit mark is 3,975 ahead (EXPECTED IN W58).

## 95 · 0364: window 58 + CE58 — CLEAN WINDOW (second consecutive), NON-SNAPPED (width 20,000); 4,673 standing pace; tCE58 = 275,698 above H0 — **THE 275,000-UNIT MILESTONE IS CROSSED IN WINDOW 58** (frontierPast275k proven in-tree, exactly as predicted from 0363); certified 1,179,987
- **0364 (M5 LANE - WINDOW 58 + CE58).**
  Launch a58 = 12,363,154,597,117 (= b57), b = a + 20,000 = 12,363,154,617,117
  — **NON-SNAPPED** (width 20,000). M = 60, C_R = 1, 28 workers,
  N_range [691008, 691008], 33,532 evals, 2617.8 s.
- **Seam audit FIRST (0348 rule):** g_a58 ≡ g_b57 exact dyadic
  [116063672026972477182407992315941454601, −85, 16777217, −110] —
  bit-identical, BEFORE CE58 was written.
- **CLEAN WINDOW:** roesser_failures_inside = 0 — the SECOND CONSECUTIVE
  clean window (w57 was the first since w50). Nothing to record or
  suppress. End Rosser runs 48/46 (both ≥ 12); 0 cross-check failures;
  0 undetermined Gram signs.
- **Verifier (layer 2):** CERTIFIED: true, turing_ok: true,
  points_checked 33,532, sign_changes_inside 20,000 = b − a,
  K_conservative 12, endpoints recomputed and matched.
- **Endpoint:** g_b58 = 3,000,175,608,498.709960937500 ± 1.29e-26 —
  exact tuple [29015918051936974651021361477904096537, −83,
  16777217, −110]. **tCE58 = 3,000,175,608,498**.
- **INCREMENTS: 4,673 (standing pace continues).**
  **tCE58 − tPT2 = 275,698 — THE 275,000-UNIT MILESTONE IS CROSSED IN
  WINDOW 58** (margin 698) — exactly where 0363 predicted (271,025 + 4,672
  = 275,697 ≥ 275,000 at even the slowest observed increment).
  `frontierPast275k` PROVEN IN-TREE (new theorem). Round-mark sequence:
  100,000 @ CE22 · 125,000 @ CE27 · 150,000 @ CE33 · 175,000 @ CE38 ·
  200,000 @ CE42B · 225,000 @ CE48 · 250,000 @ CE53 · **275,000 @ CE58**;
  next mark 300,000 sits 24,302 ahead (expected ~w63/64; compute, do not
  pre-announce). NO CASING (frac 0.70996, margin ~9.96e-3).
- **Certified total: 1,159,987 + 20,000 = 1,179,987.** 1.1M mark [w55]
  carried; 1.2M mark 20,013 ahead (running total at w59 should land
  1,199,987 — 13 short again — crossing expected w60).
- **CE58.lean GREEN** (8,824 targeted jobs, 0 errors 0 warnings; full
  tree 17,454; olean fresh): gB58Lo := 300017560849870/100;
  faceShrinkCE58 = 4673; frontierGapAboveH0 = 275698; five milestone
  theorems (175k/200k/225k/250k carried + 275k NEW); ce57WinClauseFull
  (w57 full slice re-cited); ce58WinClause (terminal slice, documented);
  59-way band; terminalFaceCE58 NAMED OPEN; all 19 doc blocks swept +
  new frontierPast275k doc; clause-doc audit OK.
- **Honest tally:** 28 of 59 chain windows clean; rescue windows 7, 21,
  28, 29, 34, 37, 42, 43, 44 (one each), 45 (two), 51 (one), 52 (two),
  53 (three), 54 (one), 55 (one), 56 (four) — all quota-met, none
  suppressed.
- **NO analytic move:** face open at tCE58; M2 wall {θ | 4/7 < θ}
  pinned via SWall; absolute clause dead as published input; θ=∞
  lane conjectural.
- **NO RH CLAIM.** Next unit — window 59 (a59 = 12,363,154,617,117).
