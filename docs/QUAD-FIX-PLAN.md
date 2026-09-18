# QUAD-FIX PLAN — mpmath complex-tail-quad defect in the S1 kernel (2026-09-17, IN PROGRESS)

Status: **OPEN — in flight.** This file is the reference document for the
fix until it lands; every step has an acceptance criterion and a status.
Companion to: `docs/KNOWN_LIMITATIONS.md`, `DISCOVERY_LOG.md`.

## The symptom (exact, reproduced)

At t = 999999994.6157 (the sweep's 1e9-window t_best), G = 1.0063459998e9
splice, dps-30, the kernel tail quad (G, 1e18] — the sweep's own
construction (complex integrand p(g)·ρ(g), 401-point breakpoint grid):

| construction | re-part |
|---|---|
| `H.quad_rem` (complex integrand, 401-pt list) — what every run used | **−1709644719.5582716** |
| real integrand, same 401-pt list | −4236379269.6977525 |
| real integrand, single interval `[G, 1e18]` | −4236379269.6977525 |
| real integrand, per-cell sum over the same 400 cells | −4236379269.6977525 |

The three real-path constructions agree to 13 digits = ground truth
(mpmath per-cell tanh-sinh, each cell fully self-converged). The
complex path is off by **+2.5267e9**. **Identical on mpmath 1.3.0 and
1.4.1** (both host builds) → systematic mpmath complex-quad weakness,
NOT a version regression, NOT the sympy-downgrade.

## What was ruled out / established

1. **mpmath list semantics**: a >2-point list = breakpoints (split into
   consecutive subintervals) — docs + microtest (`quad(x, [0,1,2,3]) = 4.5`).
2. **Docs warning (verbatim)**: "For functions that are smooth … but
   contain sharp mid-interval peaks or many 'bumps', `quad()` may fail to
   provide full accuracy." The documented remedies are split / maxdegree /
   cross-check — done; the cross-check (real path) is the authority.
3. **sympy pin**: sympy 1.14.0 requires `mpmath<1.4` — this is what
   downgraded mpmath when sympy was installed for a temporary
   Taylor-series product. mpmath 1.4.1 (latest on PyPI) now installed
   (user-level); sympy still imports and works; if a sympy script ever
   breaks at runtime it moves to its own venv (owner-approved).
4. **Sum-vs-integral theory**: over (G, 1e18] the zero count is ~6e14;
   the density integrand is smooth there (t < G); Σ f(γ_n) − ∫ fρ dg
   fluctuation ~ √N·(f′·gap/2) ~ **O(1e-5)** → the correctly-converged
   density integral IS the true tail sum (the 13-digit triple-agreement
   is the measured instance of this).
5. **Cell 0 (the steep boundary-layer cell) is FINE on both paths**
   (verbose: both converge to estimated error 1e-41 at degree 5,
   complex re == real to all digits) → the defect is in one or more of
   the other 399 cells (a complex-convergence early stop somewhere with
   |ΔI| small while Re(I_k) − Re(I_∞) is still large — the mpmath
   `estimate_error` Richardson scale on the complex sequence).
6. **The entire recorded history (onset → 25x → sweep → hi-run) was
   computed with the complex path**: every Efull value, every residf,
   every margin is a COMPLEX-PATH value. (The onset-scale runs, t ≤ 1e5,
   passed at 0.3–5.8% — the complex path is approximately right there;
   the defect scale grows with the boundary-layer integral magnitude.)

## Why this is verdict-level (not cosmetic)

- The Efull O(1) series (0.0009 → 2.5839 at 1e9) is the complex-path
  kernel ratio. With the corrected (true) tail, the 1859-kernel ratio
  |ζ/K| at 1e9 is O(e^9)-scale — the "kernel ≈ ζ" story at splice
  heights is an artifact; the O(1) series was measuring the quad's
  error, not the kernel.
- The squeeze margin mnew = |ζ|·dev/(p8_B + |ζ − K|): with the true
  tail, |K| → 0 and the margin **relaxes to dev = min_δ|R(s,δ) − 1|**.
  Measured dev at the six anchor heights: 1.0000000028 / 1.0000000025 /
  **0.9999999973 (1.6e9 — BELOW 1)** / 1.0000000006 / 1.0000000062 /
  0.999973-class. So at the corrected kernel:
  - every margin ≈ dev (≈ 1 ± 1e-6),
  - the "margin ≥ 1" A-1/A-2 verdict **still holds in direction** (it
    holds in both constructions at all windows/straddles),
  - but the LEVEL changes (recorded 1.08–3.77 → corrected ≈ dev),
  - and the S1 story becomes exactly the **near-floor** story the P8
    floor was built for: the realized scale is the pinned
    [0.9975, 1.0201] band, with a quantified sub-1 dip
    (−2.7e-9 at 1.6e9) — the H3 danger zone, measured instead of
    assumed.
  - The Efull "saturation vs divergence" question is REPLACED by
    "does the realized dev floor stay ≥ 1 / within the pin" — the S1
    asymptotic question in its corrected form.

## The fix (steps, acceptance, status)

1. **Locate the defect** — per-cell complex vs real quad over the 400
   cells; tabulate |Δ| per cell + the stopping degree (verbose) of the
   bad cells. *Acceptance: the bad cell(s) identified and the
   early-stop mechanism visible in the degree trace.* — **IN FLIGHT**
2. **Fix the quad layer** — the kernel tail (`quad_rem`/`quad_ext`
   usage in the sweep/hi/calibration/model scripts) integrates **re and
   im as separate REAL quads** (validated construction); the complex
   path is retained for audit only. *Acceptance: A/B battery at the 1e9
   anchor — fixed kernel re-part == real-path ground truth to < 1e-6.*
3. **Re-run the anchors** — 1e9 anchor + the 5 straddle t_best's
   (single t each, corrected kernel): corrected Efull, corrected
   margin, dev, zeta. *Acceptance: corrected margin == dev to < 1e-6
   at each height; corrected table committed.* (≤ 6 workers — keep
   2 cores free on this 32-core box.)
4. **Restate the record** — DISCOVERY_LOG + KNOWN_LIMITATIONS +
   RH-PROOF-OUTLINE S1 row: historical numbers tagged
   COMPLEX-PATH; corrected table; S1 asymptotic question re-expressed
   (dev floor, not Efull); the sub-1 dev dip at 1.6e9 quantified.
   Verify the pinned constants feeding S1 are kernel-independent
   (p8_f_near_pin = 0.9975 comes from the closed-form R audit —
   confirm at this step).
5. **Lean side check** — no theorem change expected (S1 is stated at
   bound level against the P8 floor, not against measured Efull);
   confirm and note.
6. **(owner's call)** file the mpmath issue with the A/B + cell-level
   repro.

## Environment state at discovery

- host: mpmath **1.4.1 — FINAL (owner decision 2026-09-17: keep it in
  place, do not revisit the version question)**; user site,
  `--break-system-packages`. sympy 1.14.0's metadata pin `mpmath<1.4`
  is now unsatisfied — runtime verified fine; if a sympy script ever
  breaks, it moves to its own venv (owner-approved); do not touch
  sympy until then. mpmath 1.3.0 was the previously-downgraded build.
- scratch directory: `rh-missing-tail/tmp/` (288 text files migrated in
  2026-09-17 from system /tmp by the owner; git-ignored; use this for
  all future scratch/logs, not system /tmp). The only non-project file
  found in it during the ownership check: `gameoverlay_ui.txt`
  (Steam log) — flagged for owner deletion.
- Known-good historical reference: docker mpmath 1.3.0 (onset
  environment, 2026-09-10 record).
- Runs in flight: step-1 cell diff (background).
