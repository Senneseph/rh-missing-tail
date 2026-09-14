import Mathlib
import RhAttack.S4Window
import RhAttack.S4Own
import RhAttack.S4Gap
import RhAttack.P12Uniform

/- 25q — S4 ASSEMBLY (the residue statement, one import).

   After the green atoms 25m (S4a window), 25n/25o (S4b own-strip
   identity + scale), 25p (S4c gap certificate), the ENTIRE open
   content of the S4 squeeze — and hence of P1.2's S4 hypothesis and
   the bound-level RH residue — reduces to exactly TWO named gaps:

   GAP-W (window regime): for t > T0 = 1.1e5,
       p8_B(t, floor(13t/8)) + M e^{Xwire t} Xwire t < 0.9975
       for 0 <= M <= Zbound t.
     GREEN on [1000, T0] (S4a, s4a_is_gapw_low_window);
     numerically GREEN to t* = 690349.0568 (PINNED, 25l[3]);
     fails at the bound level beyond t* (Bwire ~ sqrt(t),
     measured deficit O(1) — 25l[3]/25f[4]).

   GAP-O (own regime, the strip 0 < d <= 1/2, t >= 1000):
       BwireO(t) + Mr(t) + Mf(t) < mown(t, d)
       with BwireO = p8_B(t, floor(13t/8)).
     PROVEN IMPOSSIBLE at the current wires: S4c
     (s4c_own_strip_gap: mown < BwireO; hence
     gapO_current_wires_impossible).  Closing GAP-O REQUIRES a
     strictly sharper P4-floor wire than p8_B at list scale —
     the gap is structural (mown = O(t^{-2}) vs
     Bwire >= (1/2)(13t/8)^{-1/2} = O(t^{-1/2})).

   So: RH (via P1.2, P12Uniform.p1_2) under S1+S2+S3
   (pointwise green, documented in P12Uniform) + GAP-W + a
   SHARPER OWN-REGIME WIRE (any wire W with W <= mown - Mr - Mf
   on the strip replaces BwireO in gapO).

   Honest split: LEAN-PROVEN — the gap definitions, the
   impossibility (S4c), the low-window green (S4a), and the
   P1.2 composition (P12).  PINNED — tStar (25l[3] bisection,
   day023_s4_sweep.py; a measurement, not a proof).  Lean
   4.33.1 + Mathlib (pinned).
-/

namespace S4A
open Real B0

/-- GAP-W: the window-regime squeeze BEYOND the green window
    T0 = 1.1e5.  (On [1000, T0] it is GREEN — S4a.) -/
def gapW : Prop :=
    ∀ (t : ℝ), S4W.T0 < t → ∀ (M : ℝ), 0 ≤ M → M ≤ S4W.Zbound t →
      p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
          S4W.Xwire t < p8_f_near_pin

/-- S4a IS gapW on the green window [1000, T0]. -/
theorem s4a_is_gapw_low_window (t : ℝ) (ht : 1000 ≤ t) (htu : t ≤ S4W.T0)
    (hX : S4W.Xwire S4W.T0 ≤ S4W.RX) (M : ℝ) (hM : 0 ≤ M)
    (hMz : M ≤ S4W.Zbound t) :
    p8_B t (Nat.floor (13 * t / 8)) + M * Real.exp (S4W.Xwire t) *
        S4W.Xwire t < p8_f_near_pin :=
  S4W.s4a_window_squeeze t ht htu hX M hM hMz

/-- GAP-O: the own-regime squeeze on the strip at the CURRENT
    wires: definition side = BwireO = p8_B(t, floor(13t/8))
    plus nonnegative residual Mr and tail Mf; floor = mown(t,d)
    (exact own-height detector mass, S4b). -/
def gapO (Mr Mf : ℝ → ℝ) : Prop :=
    ∀ (t d : ℝ), 1000 ≤ t → 0 < d → d ≤ 1 / 2 →
      S4G.BwireO t + Mr t + Mf t < S4O.mown t d

/-- S4c, in gap-form: GAP-O is IMPOSSIBLE at the current wires —
    for any nonnegative Mr, Mf the strip squeeze fails somewhere
    (in fact at EVERY strip pair with t >= 1000). -/
theorem gapO_current_wires_impossible (Mr Mf : ℝ → ℝ)
    (hMr : ∀ t, 0 ≤ Mr t) (hMf : ∀ t, 0 ≤ Mf t) :
    ¬gapO Mr Mf := by
  intro hg
  have h := hg (1000 : ℝ) (1 / 2) (by norm_num) (by norm_num) (by norm_num)
  exact S4G.s4c_squeeze_impossible (1000 : ℝ) (1 / 2)
    (by norm_num) (by norm_num) (by norm_num) (Mr 1000) (Mf 1000)
    (hMr 1000) (hMf 1000) h

/-- PINNED (25l[3], day023_s4_sweep.py — bisection on the
    closed-form wires; a MEASUREMENT, not a proof): the
    window-regime squeeze holds numerically up to
    t* = 690349.0568 and fails beyond it (deficit 0.54 @ 1e6,
    +4.35 @ 3.15e7, Bwire-dominated). -/
def tStar : ℝ := 690349.0568

/-- THE RESIDUE COMPOSITION: S1 + S2 + S3 + S4 (the four
    structural hypotheses of P1.2) imply RH — restated here so
    the S4Asm module is self-contained: with S4 = (gapW ∧ gapO)
    instantiated at the current wires, RH follows; gapO is
    impossible there (S4c), so the bound-level residue is exactly
    gapW plus a sharper own-regime wire. -/
theorem rh_from_structural_hypotheses
    (q : ZeroSet) (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      ∃ (Q : ℝ), Q >= devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) >= flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 → Q <= Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  P12.p1_2 q Mf devOf Bwire Mr flo hs1 hs2 hs3 hs4

end S4A
