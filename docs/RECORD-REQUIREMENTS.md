# RECORD REQUIREMENTS — what "complete RH" precisely requires (0251)

Status: SPEC, derived from the green tree (full build 17454 jobs, master `b91cbc5`).
No RH claim. Off-board margin records are cited, not load-bearing.

## 1. The terminal endpoint (exact)

`formal/RhAttack/RHEnd.lean:3653` — full tree green:

```lean
theorem rh_program78_stripfront_mach_unifiedPosReserve_PT2 (q : ZeroSet)
    (hzF : Z78PosReserve.externalZeroFree78PosReserve)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78PosReserve.posReserveD0max → ¬ offPair q t0 d0) :
    RH q
```

with `offPair q t0 d0 := ∃ ρ ∈ q.Z, ρ.re ≠ 1/2 ∧ |ρ.im| = t0 ∧ |ρ.re − 1/2| = d0`
(`P12Uniform.lean:81`), `tPT2 = 3,000,175,332,800` (`WinCount.lean:538`),
`posReserveUpper = 8733819666133/10000000000000` and
`posReserveD0max = posReserveUpper − 1/2 = 0.3733819666133` (`Z78PosReserve.lean:95-101`).

POST-0256 (2026-11-01): the in-tree terminal endpoint is now the TEN shape
`rh_program78_stripfront_mach_unifiedFractionContact_PT2` with
`fractionContactUpper = 2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271`
(127/127-digit exact rational, ≈ 0.8733819666132075199290267786, the closest declarable fraction
above the method-contact (777 − √1081)/852) and
`fractionContactD0max = fractionContactUpper − 1/2`
(`Z78FractionContact.lean`); the NINE and EIGHTH constants survive as
predecessor refs (modules and B22/B23 lineages stay in the tree by the
in-place supersession convention).

"Complete RH once and for all" = exhibit the real zero set `q` and discharge ALL six
premises. Per-premise audit:

## 2. Per-premise discharge status

| # | Premise | Shape | Status | Discharge mechanism |
|---|---------|-------|--------|--------------------|
| 0 | `q : ZeroSet` / `hqz` | `q` is the actual Mathlib zero set; `hqz` its definitional property | satisfied definitionally | none needed (instantiate with the actual set) |
| 1 | `honline` | on-line for `0 < |Im| < 707/50 = 14.14` | satisfied by trivial data (first few zeros; any published stream, e.g. Platt) | cited; subsumed by the hPT2 record |
| 2 | `hzF` | **zero-free** `∀ s, θ < s.re → s ≠ 1 → ζ s ≠ 0` at the in-tree θ | **EXTERNAL CLASSICAL RECORD** — board TEN (`closest-fraction-contact`, θ = 2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271 ≈ 0.8733819666132075199290267786, the closest declarable fraction above the method-contact), **ADOPTED 0256 (MERGED 2026-11-01T12:23:55Z, merge 8b1a0167)**; in-tree absorption in `Z78FractionContact.lean` (B24); NINE (`positive-gap-contact-return`, θ = 0.87338196661320752) and EIGHTH (`positive-reserve-selected-gap`, θ = 0.8733819666133) remain as predecessor refs in `Z78GapContact.lean` / `Z78PosReserve.lean` | B6 adoption pipeline (fired 0256: fire-time stage C 236/236 kernel-clean, stage D all clean, full tree green; `tmp/b6audit/prestage103/firetime/`). **Next candidate (B25, same runbook): first MERGED record with θ < 2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271. Board re-audit at 0256: NO merged record sits below TEN** (runner-up `saddle-closure-selected-gap` is T + 9.732e-22, weaker) — the ladder idles at the family contact until the board moves |
| 3 | `hPT2` | **on-line data** `∀ ρ ∈ zeros, 0 < Im ρ ≤ 3,000,175,332,800 → Re ρ = 1/2` | satisfied by published rigorous computation | Platt–Trudgian arXiv:2004.09765 Thm 1 (12,363,153,437,138 zeros, interval arithmetic, independently verifies Platt tPT). Already CITED in-tree (`WinCount.lean` section D, Z78 pattern). In-house H1 3e10 fleet data = SCREEN-level fill with the 2026-09-29 forensic correction on the mcert column (`VALIANT-EFFORT-FORENSICS.md` §5) — an independent cross-check, NOT a certificate |
| 4 | `Qside` | one concrete zero-side scale (measured \|ζ\| fill under the A4.3 residual wire) | engine parameter; INERT under the 0126 endpoint shape (the S1/S3 strip faces dissolved into the exclusion face — §3) | kept for signature stability; supplies nothing to discharge |
| 5 | `hOffCPT2` | **no off-pair** on `[tPT2, ∞) × (0, fractionContactD0max]` (TEN bound (d0max) ≈ 0.3733819666132075199290267786; NINE shape: 0.37338196661320752; EIGHTH shape: 0.3733819666133) | **THE TERMINAL FACE.** Open. | see §4 |

## 3. What the in-body squeeze proves (B10 audit, RHEnd.lean)

Proven IN BODY (no hypothesis beyond the structural premises):
- **B10.1 `t4l_bandWireBelow`**: at ANY band off-pair (1000 ≤ t0, 1/200 ≤ d0 ≤ 1/2),
  `BwireP(t0,d0) + Mr(t0,d0) < devProg(t0,d0)` — the endpoint wire + mass sits
  STRICTLY below the detector floor, flank-independent.
- **B10.2 `t4l_bandEmpty`**: the squeeze window is EMPTY in body — no scale `Qside`
  can satisfy BOTH engine legs S1 (`Qside ≥ devProg`) and S3 (`Qside ≤ Bwire + Mr`)
  at a band off-pair.
- **B10.3 `t4l_stripFacesEmpty`**: the old B9 strip-face bundle (G-hs1, hs3-right,
  G-hs3-left) is JOINTLY CONTRADICTORY at every band off-pair at/above the frontier.
- **B10.4/B10.5**: the B9 endpoint is body-equivalent (for the endpoint) to the
  vacant form: at general frontier H the vacant endpoint carries TWO exclusion
  faces (band `hNoStrip` + window `hWinH`); the current `_PT2` endpoint unifies
  them into ONE face `hOffCPT2` on `d0 <= posReserveD0max` because the upper
  slice `(posReserveD0max, 1/2]` is excluded in body from hzF + functional
  equation (a zero there is a zero with `Re > posReserveUpper` or `Re < 1 -
  posReserveUpper`). Proof anatomy (`RHEnd.lean:1700+`): S2 leg fully in body;
  S1/S3/S4 legs case-split as below-H vacuous from hPT2 / above-H band+window
  from the face / far from [Z78].

Reading: the in-body squeeze is a *conditional* exclusion — an off-pair in the band
would force the measured zero-side fill to lie in the EMPTY interval
`(devProg, Bwire + Mr]` (empty by B10.1). The S1/S3 legs themselves are NOT provable
in body at the required strength (that is the 0125/0126 dissolution): closing the
conditional into an unconditional `¬ offPair` needs exactly one more ingredient —
§4.

## 4. The terminal face `hOffCPT2` — closure routes (all named)

- **(a) Direct far-strip zero computation.** Verify no off-line zero in
  `[3e12, ∞) × width 0.373`. Data-side infeasible: published verification works at
  line-width ~2^-102 isolation; a 0.373-wide negative certificate is orders of
  magnitude beyond current methods. DEAD as a near-term route.
- **(b) Stronger classical zero-free regions.** From `hzF` + functional equation all
  zeros lie in `d0 ≤ posReserveD0max`; to exclude off-pairs by zero-free region alone
  would require θ → 1/2 — i.e. RH itself. Each θ improvement (EIGHTH→NINE
  −9.248e-14 ADOPTED 0254; NINE→TEN −7.097e-20 ADOPTED 0256) only SHRINKS the
  face. NOT a closure, but a live record-layer improvement — and the TEN record
  sits within ~2.2e-254 of the method-contact (777 − √1081)/852, so THIS
  record family is at its limit; further shrinkage needs a different family.
- **(c) Squeeze discharge under the per-point schedule - MEASURED NEGATIVE (0252, day059 probe; closed).**  The engine's S3 leg is structural (triangle + 3-term EM bound + A4.3/P5 mass, at any run) and the S4 wire margin at the per-point run is Lean-pinned for C > 5000 (058e/T4OffLC, 0250), but the day059 probe measures the full two-leg map:  the S1 fill leg (the S1Ge lower bound (T1-T2-T3) - Mval against devProg) closes iff C < C*(t,d0) = t^-2/(2 devProg) ~ 1/(8 d0^2) pointwise, while the S4 wire-margin leg (per-point wire < floor) closes iff C > t^-2/(2 floor) >= t^-2/(2 devProg) (floor <= devProg, S2 in body).  The knife-edge thresholds coincide, so NO C > 0 closes both legs at ANY band point:  joint closure = 0 points measured on the full grid (t 1e3..1e16 x d0 1/200..posReserveD0max x C 1..1e8);  knife edge exact at tPT2 (R1(C) = 5000/C, R3(C) = C/5000 to 10 digits;  C = 5000:  both = 1.0000000000);  C*(d0) = 1/(8 d0^2 f) runs 5000 (d0 = 1/200) -> 1913 (0.008084) -> 193.4 (0.025421) -> 50 (0.05) -> 0.8965 (posReserveD0max), t-independent to O(t^-2);  C = 5001 closes S3/S4 on the whole band (margin >= 2e-4, edge-worst, T4OffLC-pinned) and its S1 mirror is open on the whole band (edge deficit 2e-4;  at posReserveD0max the fill lower bound is 1/5577 of the requirement;  worst R1 = 1.79286e-4);  C = 4999.5 (in-tree 0123) is the exact mirror.  Cross-validated:  R1 = 5000/C to 10 digits at the edge reproduces the 058e
  C > 5000 threshold exactly (R1 = 1 iff C = 5000);  R1(C = 5001) < 1 on the
  whole band (0.9998 at the edge, 1.79e-4 at posReserveD0max) is the S1 mirror
  image of the 058e/0245 whole-band wire closure at C > 5000;  uniform-n4
  reference R1@n4(edge) = 1.1535..1.3552 (t = 1e9..1e16), npp/n4 = 1.33..1.84
  (the per-point run is not an artifact).  Consequence:  the per-point witness family is EXHAUSTED as a discharge mechanism for hOffCPT2 - the 0126 window-emptiness fact (t4l_bandEmpty) is schedule-independent and now quantified with exact thresholds at the per-point family.  The per-point route is CLOSED, not deferred.
- **(d) External record asserting the band exclusion directly.** Equivalent to a
  proof of RH above the frontier; no such record exists and the board format has
  no vehicle for it. OUT OF SCOPE by design.

## 5. "Complete RH" — the spec, in order

1. **hOffCPT2** — the terminal face. In-program candidates: route (c)
   per-point-schedule squeeze — CLOSED NEGATIVE by measurement (0252, the day059
   knife edge: no C in the 0123 family closes both squeeze legs at any band point);
   route (a) direct zero computation — DEAD (0251); route (b) stronger zero-free
   regions — shrinks only. What remains IN-PROGRAM: a genuinely new
   (non-schedule, non-squeeze-family) analytic argument for the band exclusion,
   if one is found — nothing in the tree blocks it (B10.4/B10.5 give the endpoint
   equivalence either way). Otherwise the face is discharged by (A) a
   frontier/record extension above tPT2 — the external record layer (0126 route A,
   the B6-board family). Everything else is mechanical relative to this.
2. **hzF** — adopt the strongest MERGED board [Z78]-class record. **ADOPTED at
   #TEN (0256):** PR #103 `closest-fraction-contact` MERGED
   2026-11-01T12:23:55Z (merge 8b1a0167) at the exact 127/127-digit rational
   2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271; fire-time replay clean (stage C 236/236, stage D all gates at the
   exact rational); in-tree successor `Z78FractionContact.lean` (B24, 13
   theorems, terminal `rh_program78_stripfront_mach_unifiedFractionContact_PT2`);
   full tree green. B10.1-style margins are schedule-independent so the record
   layer is orthogonal to (c). Next adoption (B25) fires on the first MERGED
   record below θ = 2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271 — same runbook; board idle at the family contact
   (no merged record below TEN as of 0256).
3. **hPT2 / honline** — provenance-complete (Platt–Trudgian citation in tree;
   in-house screen data as cross-check). Optional hardening: pinned zero-stream
   checksums. Low priority; does not gate.
4. **hqz / Qside** — no work (definitional; inert).

## 6. Honesty boundary

- The endpoint is a CONDITIONAL theorem (three named external inputs + one face).
- The 0244-0247 wire maps, the T4OffLB / T4OffLC anchors, and the 058e schedule
  measurement are OFF-BOARD POSITIVE-DUAL MARGIN RECORDS: machine-verified, exact,
  explicit — they characterize mechanism reach; they do NOT assert zero non-
  existence and make NO RH claim.
- No zeta evaluation, no zero-existence statement, anywhere in the above.
