# rh-lean — the E7a identity and the B-4 on-line pair identity, machine-checked (Lean 4 + Mathlib)

Formal core of the kainos-logos RH-attack exact-identity lines:
**the Euler action identity (E7a) is proven exactly in Lean**, and its
five certified oracle instances are cross-checked by an independent
Lean float64 re-implementation against the Python oracle (dps-20
values); **the B-4 on-line pair identity is proven in four pieces**
(T1 exact closed form; T2 log-magnitude; T3a/T3b the phase, exactly
mod 2π in the circle type `Real.Angle` / in ℝ with an explicit 2πℤ
multiple) and cross-checked on its 16 recorded points (float64
closed form vs direct fac-product evaluation).

This is the first step of the M4 plan
(`plan/40-prize-islands/rh-attack/prompts/M4-lean-e7a.md`): exact identities
as computers — the finite algebraic core first, zero-side analytic
statements later (out of phase 1 by design).

## What is in here

| File | Content |
|---|---|
| `RhAttack/EulerAction.lean` | **The theorem.** `eulerAction`: for every commutative ring `K`, every `a,b : ℕ → K`, and `N ≤ M`,  `Σ_{n=N+1}^{M} a(n)·b(n) = A(M)·b(M) − A(N)·b(N) + Σ_{m=N}^{M−1} A(m)·(b(m)−b(m+1))`  with `A(k) = Σ_{i≤k} a(i)`. Proof: induction on the segment length, closed by `abel`/`ring`. No numerics, no analysis — pure finite algebra. |
| `RhAttack/E7a.lean` | The five oracle instances, ported. (A) Exact integer cross-checks: the χ₅ and LCG ±1 paths, all ten recorded `A(M)`, `A(N)` values — via `#eval` (kernel-exact `ℤ`). (B) The full LHS pipeline `Σ a(n)·n^(−s)` in lean float64 (raw `Float` pairs; the additive pipeline is a bare recursive sum — Float carries no provable ring axioms, so this is deliberately outside Mathlib's arithmetic layer), cross-checked against the oracle. |
| `RhAttack/B4.lean` | **The B-4 theorems.** `pairClosedForm` (T1: F_ρ1·F_ρ2 = (γ²−t²)·Bv·e^{s·Bv}, exact, all γ,t>0); `pairLogAbs` (T2: log ‖·‖ = ½·Bv + log |1−(t²+¼)·Bv|, t≠γ); `pairArgAngle` (T3a: arg sum = t·Bv + (π if t>γ else 0), exact mod 2π in `Real.Angle`, t≠γ); `pairArLedger` (T3b: same, ℝ form ∃ k : ℤ, t≠γ). Plus the `B4Float` cross-check (16 recorded points). |
| `Main.lean` | Executable `rhattack`: recomputes the five E7a instances, the exact-ℤ A-values, and the B-4 16-point table; reports all deviations. |
| `out_rhattack_day011.txt` | Recorded run (2026-09-10): **E7a CROSS-CHECK PASS 5/5 (worst |diff| = 0.019664 × 10⁻¹²) + B-4 CROSS-CHECK PASS 16/16 (worst dLa = 85.27 × 10⁻¹⁵, dAr = 0.44 × 10⁻¹⁵).** |

## Provenance (no recall — every number traces)

- Identity source of record: `plan/40-prize-islands/rh-attack/FORMULAS.md` §2.1
  (E7a), oracle file `plan/40-prize-islands/rh-attack/THE-EULER-ACTION.md`.
- Python oracle: `../rh/day006_e7a_action_identity.py`
  (dps-50, 5/5 PASS, residuals ~1e-51..1e-53 in
  `../rh/out_day006_euler_action_identity.txt`).
- Port values (dps-20 LHS of each instance): `../rh/out_day011_e7a_oracle20.txt`.

## Reproduce from scratch (fresh machine)

```sh
# 1. toolchain (https://www.lean-lang.org): installs elan + lean + lake
#    (in this environment elan.leanlang.org is unreachable — install elan
#    manually from its GitHub release, then `elan-init -y`.)
# 2. build (fetches the prebuilt Mathlib cache from the community store —
#    minutes, not an hours-long build)
lake build
# 3. run the cross-check
lake exe rhattack
```

Expected output: five LHS lines within ~1e-13 of the oracle values, the
exact ℤ data line
`A(133)=-1 A(3)=-1 A(307)=0 A(7)=0 A(1012)=0 A(12)=0 | A(1007)=-5 A(7)=1 A(100)=0 A(1)= -1`,
`CROSS-CHECK PASS`, then the 16-row B-4 table and `B-4 CROSS-CHECK PASS`.

A transcription error anywhere in the ported paths/heights/endpoints would
appear as a difference of order 1 (≈ 10¹² in the scaled units shown), so the
PASS line is a genuine statement about the port.

## Honesty labels

- `eulerAction` — **proved** in Lean (exact, `lake build`-verified).
- The five-instance numeric agreement — **measured** (float64 vs dps-20;
  expected ~1e-13, observed worst 2×10⁻¹⁴).
- `pairClosedForm` (T1), `pairLogAbs` (T2), `pairArgAngle` (T3a),
  `pairArLedger` (T3b) — **proved** in Lean (exact; T2/T3 carry the
  t ≠ γ exclusion exactly as the record does; T1 holds even at t = γ).
  The statements are the per-pair closed form of DLMF 25.2.12 for the
  on-line conjugate pair — the zero-side *factor*, not a statement about
  the zeros of ζ.
- The 16-point B-4 numeric agreement — **measured** (float64 closed form
  vs float64 direct product; expected ~1e-14 double roundoff, observed
  worst dLa ≈ 8.5×10⁻¹⁴, dAr ≈ 4.4×10⁻¹⁶ — the same order as the
  independent dps-25 cross-validation in `out_day010_pair_unit.txt`).
- Nothing here touches RH. The zero-side analytic statements (E7b and
  beyond) are later milestones.
