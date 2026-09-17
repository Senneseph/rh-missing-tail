# The RH route: ancestry, novelty, and why this specific walk has not been made before (2026-09-17)

> A standing reference document. Question it answers: *why has no one ever
> come this way — and has anyone already?* Written 2026-09-17, at the
> 25x[8]/day029 state (post-25af; the S4Asm assembly and the S1-GAP
> verdict-(A) pre-test are landed). Source of record: `docs/RH-PROOF-OUTLINE.md`
> for the current mathematics, `DISCOVERY_LOG.md` for the day-by-day.
> No prize claim is made or implied.

## 1. The route, in one paragraph

RH is decomposed (Lean-proven closure, `P12.p1_2`) into four structural
regimes **S1∧S2∧S3∧S4**. S2 (zero-side far/own-pole), S3 (definition
side), and S4 (the uniform squeeze over the blind spot — window regime
25ab, own-regime strip 25af with the t⁴ wire, assembly 25af/S4Asm) are
bound-level **LEAN theorems** at explicit constants. All that remains is
**S1: the on-line bridge residual** — the pointwise squeeze "def-side
residual < zero-side detector signal for every t" — which is now a
single, explicit, measurable inequality with a measured growth law
(residf(t) = |ζ(½+it) − K_on(t)|, measured 1.04 → 1.32 → 7.71 at
4e8 → 6e8 → 1e9, 25x[8]), screen-closed through the data extent
(1e9) pending the full corrected sweep + the dps-30 pin.

In classical language the S1 statement **is** "the on-line counting
defect is uniformly log-scale" — the 120-year-old equivalence
RH ⇔ S(T) = O(log T). The project's content is that the equivalence has
been *executed*: decomposed, per-pair-quantified, floored from below by
a theorem, floored from above by wires, and measured pointwise — until
what remains is one checkable inequality instead of an unquantified
conjecture.

## 2. The classical ancestors (attribution)

| Ancestor | What it is | Where it lives in this route |
|---|---|---|
| **von Mangoldt (1905)** | N(T) = N̂(T): zero counting via an explicit argument integral over the critical line. | The counting core (`B0` in Lean — the math is 1905, the formal proof is not). |
| **Littlewood (1913–14)** | The omega results: the explicit formula in the *off-line* direction — an off-line zero forces small |ζ|, because the prime-power side cannot cancel. | The **mechanism** of S2/P8. He used the formula's magnitude; the route adds a quantified *floor* on a single pair. |
| **The S(T) literature** (Titchmarsh et al., standard) | RH ⇔ S(T) = O(log T) uniformly, where S(T) = N(T) − N̂(T). | The S1 statement, in words. Proved *under* RH; the unconditional bound is the hypothesis itself. |
| **Huxley (T^{1/3}-class bound)** | Best unconditional S(T) ≪ bound, decades old; the known methods cannot interpolate toward log T. | The *gap is RH* — the exact reason the classical route stalls: there is no visible mechanism between T^{1/3} and log T. |
| **Conrey–Ghosh (1997), "The explicit formula for the Riemann zeta function"** | Test-function explicit formulas localizing zeros (with Gonek: large-gap structure). | The closest modern cousin of the bridge identity (E7a): a zero made explicit through the formula. They bound sums; the route bounds a *single pair's signature* from below. |
| **Platt–Trudgian (2021, arXiv 2010.13307)** | Rigorous interval-arithmetic verification of RH to 3×10¹², plus explicit S̄(T) constants. | The **ceiling** branch: exact zero-side computation to T*. Stops at the ceiling *because* the uniform residual bound is the proof — which is precisely the object S1 formalizes. |

## 3. Why the route has never been walked as a proof

1. **It was never a goal; it was the theorem.** In every textbook the
   bound "S(T) = O(log T)" is *identified with* RH, not treated as a
   step toward it. Equivalence statements don't generate research
   programs. Nobody has historically attacked the inequality — they
   attacked RH, via routes (zero-free regions, density, small values,
   average results) that never required this decomposition.

2. **The classical machinery is integrated, not per-pair.** The explicit
   formula is a *sum* — used for counting, density, averaged small
   values. This route's load-bearing move is the **per-pair detector
   floor**: |K|·dev ≥ p8_f_near_pin · |K| (0.9975, a LEAN theorem, P8)
   for a *specific* off-pair (t₀, d₀), with the def-side truncated at a
   chosen wire family. The literature has never used the explicit
   formula as a *detector* with a certified lower bound, because
   detection of an individual zero through summed machinery was never
   needed: classical arguments only need the sum.

3. **The modern explicit-constants branch only needed ceilings.**
   Interval arithmetic to 3×10¹² (Platt–Trudgian) is a *verification*,
   and verification by design stops at T*. A proof needs the uniform
   residual bound — one inequality for all t — so the field's
   computational branch naturally has never built toward it, and the
   analytic branch has never needed per-pair floors.

The two halves that would have to be combined for this route — (i) the
exact zero-side (ceiling branch) and (ii) the uniform def-side bound
(analytic branch) — have been developed in parallel, for different
purposes, by different communities.

## 4. What this project adds (the novelty claims, honest limits)

**Claim: to our knowledge, no published work contains the decomposed,
per-pair-quantified, bounded-squeeze version of the route.** Supporting
limits of the claim: it is a research claim, not an exhaustive survey;
the closest single ancestors (Conrey–Ghosh 1997; Platt–Trudgian 2021)
were checked by name and scope on 2026-09-17 and contain neither the
per-pair floor nor the regime-decomposed wire closure.

The specific additions, none of which exists in the forms cited:

1. **The per-pair detector floor as a theorem** (P8, LEAN-PROVEN):
   the prime-power side of the explicit formula, at a zero's own
   signature, has a certified lower bound (0.9975 near / 1 far, A5
   terminals) — the explicit formula as a *detector*, not a sum.
2. **The regime decomposition + bound-level closure of all regimes but
   S1** (S2/S3/S4 LEAN): the S4 squeeze in particular required asking
   "which truncation family n(t) minimizes the def-side floor on this
   regime" — the growing-wire families (n = ⌊t²⌋ window; n = ⌈3.1·10⁷·t⁴⌉
   strip, 25ab/25af) and the **S4-Sharp impossibility theorems** (no
   n ≤ 13t/8 family can close the strip squeeze). The question has not
   been asked before, because no one had a floor to close against.
3. **The full-horizon kernel** (25x/25af, re-sharp on 2026-09-17): the
   model kernel's (10¹⁸, ∞) product section — *reported-only* in the
   25x records — folded in at (10¹⁸, 10³⁰] quadrature. Nobody had
   folded that section in at this scale, and folding it in dissolves
   the S1-GAP sub-1 dips (25y pins were artifacts of that section plus
   the list-scale P4 floor; verdict (A), day029).
4. **The decoupling itself**: RH ⇔ S1∧S2∧S3∧S4 with S2∧S3∧S4 done, so
   the open question is *one explicit inequality with a measured growth
   law* (residf, watch item: 93% of |ζ|·dev at the 1e9 frontier), not an
   unquantified "bound the S-function." The residue can now be *watched*,
   fitted, and pinned — which is a different epistemic situation from
   the classical one.

## 5. The last mile, and what it would take

The residue (S1) is the classical equivalence executed: prove the
corrected def-side residual stays under the zero-side signal for all t.
The mathematical object it reduces to is the **Sbar/S1 wire** — the
Platt–Trudgian Cor 1 class (log-scale) bound on the on-line counting
defect, *formalized* (currently CITED) and composed against the
decaying t⁴ P4 floor (already a theorem). Two honest uncertainties
remain, and both are now *questionable in principle*:

- **residf growth**: measured t²-class (1.04 → 7.71, 4e8 → 1e9) would
  eventually beat the log-scale wire if it continues; the correct
  fit/artifact separation over the sweep windows is the live item
  (day029 sweep running; dps-30 pin at the tightest window queued).
- **the Sbar wire itself** (CITED): the formalization debt is bounded
  and mechanical (b3BoundExplicit atoms), with no research risk.

If the last inequality holds, the route is a proof. If it fails, the
route yields the exact location of the wall — the pre-registered ceiling
report with true attribution — which is itself a result nobody could
write before, because only this decomposition makes the wall a number.

*Companion documents: `RH-PROOF-OUTLINE.md` (the path and its current
state), `STRAIGHTFORWARD-ASSESSMENT-2026-09-17.md` (field-agnostic
snapshot), `DISCOVERY_LOG.md` (25x[8]/day029 entry).*
