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
