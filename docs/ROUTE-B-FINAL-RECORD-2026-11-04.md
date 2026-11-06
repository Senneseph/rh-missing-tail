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
