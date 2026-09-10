# rh-lean — the E7a identity, machine-checked (Lean 4 + Mathlib)

Formal core of the kainos-logos RH-attack E7a line: **the Euler action
identity is proven exactly in Lean**, and its five certified oracle
instances are cross-checked by an independent Lean float64 re-implementation
against the Python oracle (dps-20 values).

This is the first step of the M4 plan
(`plan/40-prize-islands/rh-attack/prompts/M4-lean-e7a.md`): exact identities
as computers — the finite algebraic core first, zero-side analytic
statements later (out of phase 1 by design).

## What is in here

| File | Content |
|---|---|
| `RhAttack/EulerAction.lean` | **The theorem.** `eulerAction`: for every commutative ring `K`, every `a,b : ℕ → K`, and `N ≤ M`,  `Σ_{n=N+1}^{M} a(n)·b(n) = A(M)·b(M) − A(N)·b(N) + Σ_{m=N}^{M−1} A(m)·(b(m)−b(m+1))`  with `A(k) = Σ_{i≤k} a(i)`. Proof: induction on the segment length, closed by `abel`/`ring`. No numerics, no analysis — pure finite algebra. |
| `RhAttack/E7a.lean` | The five oracle instances, ported. (A) Exact integer cross-checks: the χ₅ and LCG ±1 paths, all ten recorded `A(M)`, `A(N)` values — via `#eval` (kernel-exact `ℤ`). (B) The full LHS pipeline `Σ a(n)·n^(−s)` in lean float64 (raw `Float` pairs; the additive pipeline is a bare recursive sum — Float carries no provable ring axioms, so this is deliberately outside Mathlib's arithmetic layer), cross-checked against the oracle. |
| `Main.lean` | Executable `rhattack`: recomputes the five instances and reports the deviation from the Python oracle. |
| `out_rhattack_day011.txt` | Recorded run (2026-09-10): **CROSS-CHECK PASS, 5/5, worst |diff| = 0.019664 × 10⁻¹².** |

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
and `CROSS-CHECK PASS`.

A transcription error anywhere in the ported paths/heights/endpoints would
appear as a difference of order 1 (≈ 10¹² in the scaled units shown), so the
PASS line is a genuine statement about the port.

## Honesty labels

- `eulerAction` — **proved** in Lean (exact, `lake build`-verified).
- The five-instance numeric agreement — **measured** (float64 vs dps-20;
  expected ~1e-13, observed worst 2×10⁻¹⁴).
- This package proves the finite algebraic core only. Nothing here touches
  zeros, RH, or analytic continuation. (E7b is out of phase 1 scope, and the
  zero-side analytic statements are a later milestone.)
