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

"Complete RH once and for all" = exhibit the real zero set `q` and discharge ALL six
premises. Per-premise audit:

## 2. Per-premise discharge status

| # | Premise | Shape | Status | Discharge mechanism |
|---|---------|-------|--------|--------------------|
| 0 | `q : ZeroSet` / `hqz` | `q` is the actual Mathlib zero set; `hqz` its definitional property | satisfied definitionally | none needed (instantiate with the actual set) |
| 1 | `honline` | on-line for `0 < |Im| < 707/50 = 14.14` | satisfied by trivial data (first few zeros; any published stream, e.g. Platt) | cited; subsumed by the hPT2 record |
| 2 | `hzF` | **zero-free** `∀ s, 0.8733819666133 < s.re → s ≠ 1 → ζ s ≠ 0` | **EXTERNAL CLASSICAL RECORD** — the [Z78] board EIGHTH (`positive-reserve-selected-gap`), kernel-verified on the board; in-tree absorption header in `Z78PosReserve.lean` | B6 adoption pipeline. **Live: PR #101 (#NINE, θ = 5458637291332547/6250000000000000 = 0.87338196661320752, better by 9.25e-14)** — board verify queued; conveyor pre-staged and 4.5/5 verified (`tmp/b6audit/prestage101/IDEM-PRESTAGE.md`); B23 single-shot generator pending merge |
| 3 | `hPT2` | **on-line data** `∀ ρ ∈ zeros, 0 < Im ρ ≤ 3,000,175,332,800 → Re ρ = 1/2` | satisfied by published rigorous computation | Platt–Trudgian arXiv:2004.09765 Thm 1 (12,363,153,437,138 zeros, interval arithmetic, independently verifies Platt tPT). Already CITED in-tree (`WinCount.lean` section D, Z78 pattern). In-house H1 3e10 fleet data = SCREEN-level fill with the 2026-09-29 forensic correction on the mcert column (`VALIANT-EFFORT-FORENSICS.md` §5) — an independent cross-check, NOT a certificate |
| 4 | `Qside` | one concrete zero-side scale (measured \|ζ\| fill under the A4.3 residual wire) | engine parameter; INERT under the 0126 endpoint shape (the S1/S3 strip faces dissolved into the exclusion face — §3) | kept for signature stability; supplies nothing to discharge |
| 5 | `hOffCPT2` | **no off-pair** on `[tPT2, ∞) × (0, 0.3733819666133]` | **THE TERMINAL FACE.** Open. | see §4 |

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
  would require θ → 1/2 — i.e. RH itself. Each θ improvement (like #NINE, −9.25e-14)
  only SHRINKS the face. NOT a closure, but a live record-layer improvement.
- **(c) Squeeze discharge under the per-point schedule (the program's own route, WARM).**
  The engine's S3 leg (fill <= wire side) is a body theorem of the wire machinery;
  the S1 leg (zero-side fill >= devProg) is a DATA record about the measured |zeta|
  fill under the A4.3 residual wire. Under the uniform `n4` schedule the S1 fill
  lower bound could not be established in body at required strength (0125/0126
  dissolution; S8 square-root schedule wall; uniform-wire island dies at t* =
  9.698e14, 0247). The 058e per-point witness run `n = C^(1/σ) t^(2/σ)` (C > 5000,
  e.g. C = 5001) puts the wire side (first T4 term + EM-tail mass <=
  1001/30006000000 of it) strictly below the own-mass floor `S4O.mown` on the
  WHOLE band for ALL t >= 1000 - t-independently, edge margin 2e-4 - and is now
  FORMALIZED as exact rational pins in `T4OffLC.lean` (0250). Re-activating (c) =
  measure the A4.3 fill under the PER-POINT run on the data range (first Python
  probe: fill vs devProg / wire-side at per-point run sizes, on-line positions of
  the verified range), and if the per-point fill lower bound is data-carryable,
  restate S1 as a body theorem and combine with B10.2 (bandEmpty under the new
  schedule) to close `hOffCPT2` in body. OPEN feasibility question = whether the
  fill record exists at per-point run sizes. This is the only closure route that
  stays INSIDE the program. Named, finite, measurable. **The next in-tree
  research direction.**
- **(d) External record asserting the band exclusion directly.** Equivalent to a
  proof of RH above the frontier; no such record exists and the board format has
  no vehicle for it. OUT OF SCOPE by design.

## 5. "Complete RH" — the spec, in order

1. **hOffCPT2** — the terminal face; route (c) is the program-internal candidate;
   its gate is the 058e/T4OffLC per-point margin foundation (now formal, 0250).
   Everything else is mechanical relative to this.
2. **hzF** — adopt the strongest MERGED board [Z78]-class record. #NINE (PR #101)
   pre-staged; one-shot conveyor ready (`IDEM-PRESTAGE.md`); B10.1-style margins are
   schedule-independent so the record layer is orthogonal to (c).
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
