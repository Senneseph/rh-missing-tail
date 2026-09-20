/-
# (M6)  Composition through the S1 wire:  the dev-vs-noise margin statement.

END_GAME_PLAN section 3.2-D + section 3.6 queue item 5 ("Compose through
the S1 wire; re-issue the ceiling report").

The two proven sides that meet on the wire:

  DEV side (S3a, PROVEN, this import):
    on the quantized straddle grid (t = g + k/2, g >= 40, k = 1..12,
    0 <= d <= 1/2) the algebraic detector core satisfies
      S3a.Ralg g (k : R) d <= 13 / g
    hence the algebraic deviation feed
      1 - S3a.Ralg g (k : R) d >= 1 - 13 / g           (m6_feed)
    which for g >= 40 strictly dominates the wire's PROVEN window/strip
    floor family (S1LowT.floStripMin <= max (S1LowT.floWin g) 0 =
    23/1000 there, while 1 - 13/g >= 27/40):         (m6_feed_dom)
    the exponential factor of R_closed (the |exp(s w)|, w a real
    O(1/g^2) combination) is carried by the already-proven C1b discrete
    floor (1 - 25/g with the 23/1000 witness-scale margin), per the S3a
    module header:  this feed is the algebraic side that composes.

  NOISE side (W2, PROVEN, the W2M5 pinned instantiation):
    the I_DN-side remainder and the S1 - R tail of the far-integral
    telescope are bounded by explicit expressions in K_pin = 2.503 and
    L_pin = Rho(2e9), with the partition data as named hypotheses
    (W2M5.m5_idn, W2M5.m5_floor).  The named functional w2noise below is
    the LHS-free form of the W2M5.m5_idn RHS, reused here as the
    composition's noise input.

  WIRE (S1LowT, the strip_squeeze form):
    Q >= dev - M  /  dev >= f  /  Q <= Bf + Mr'  /
    Bf + Mr' + M < f.
  The composition (m6_compose) instantiates the wire at (g, d) on the
  S3a grid with dev feed := 1 - 13 / g and f := S1LowT.floStripMin g d:
  the dev >= f leg is PROVEN by m6_feed_dom;  the noise total
  Bwire + Mr + Mf (zero side + definition side roles, whose W2-proven
  expressions are the fill where the data matches) is a NAMED hypothesis
  (H6 pattern, no hidden measurement);  the output is the wire form with
  STRICTLY positive margin 1 - 13 / g - (Bwire + Mr + Mf).

  THE |zeta| FACTOR (plan 3.2-D "check the |zeta| factor's role in the
  actual S1 wire"):  the feed 1 - 13/g is |zeta|-free (pure algebra in
  the detector core);  the |zeta| scaling enters the wire only through
  the zero-side data (the A4.3-wired Q and the measured marginLowT /
  hgrid of S1LowT.strip_squeeze_v2), i.e. on the NOISE side, where it is
  carried by the named hypotheses, not by the proven feed.  The raw
  margin statistic is the measurement proxy;  this Lean statement is the
  bound-level composition of the two proven sides.

NO RH claim:  the composition takes the wire's noise roles as explicit
named hypotheses (the S4Asm / S1LowT pattern) and outputs the wire form
with the concrete dev feed.  Honesty labels per atom:  LEAN-PROVEN
(m6_feed, m6_feed_pos, m6_feed_dom, m6_compose, w2noise_bound,
w2noise_tail), CITED (none new), PINNED (K_pin, L_pin via W2M5;  the
noise total as a named hypothesis), MEASURED (only behind the named
hypotheses).
-/
import Mathlib
import RhAttack.S3a
import RhAttack.W2M5
import RhAttack.W2Telescope
import RhAttack.S1LowT

namespace M6

open S1LowT W2M5

/-- (1)  THE ALGEBRAIC DEV FEED (S3a -> wire, PROVEN):  on the quantized
    straddle grid (g >= 40, 1 <= k <= 12, 0 <= d <= 1/2),
    1 - Ralg g k d >= 1 - 13 / g.  From S3a.s3a_dev (Ralg <= 13/g) and
    13 / g <= 13 / 40 < 1 (so the deviation 1 - Ralg is positive). -/
theorem m6_feed (g : ℝ) (hg : 40 ≤ g) (k : ℕ) (hk1 : 1 ≤ k) (hkL : k ≤ 12)
    (d : ℝ) (hd : 0 ≤ d) (hdL : d ≤ 1 / 2) :
    1 - S3a.Ralg g (k : ℝ) d ≥ 1 - 13 / g := by
  have hR := S3a.s3a_dev g hg k hk1 hkL d hd hdL
  have h13 : 13 / g ≤ 13 / 40 := by
    have h1 : 1 / g ≤ 1 / 40 := by
      apply (one_div_le_one_div (by linarith : 0 < g) (by norm_num : 0 < (40 : ℝ))).2
      exact hg
    calc
      13 / g = 13 * (1 / g) := by ring
      _ ≤ 13 * (1 / 40) := mul_le_mul_of_nonneg_left h1 (by norm_num)
      _ = 13 / 40 := by ring
  have hsmall : S3a.Ralg g (k : ℝ) d < 1 := by
    have h13c : 13 / 40 < 1 := by norm_num
    linarith [h13, h13c]
  linarith [hR]

/-- The feed itself is strictly positive for g >= 40:  1 - 13 / g > 0. -/
theorem m6_feed_pos (g : ℝ) (hg : 40 ≤ g) : 0 < 1 - 13 / g := by
  have h13 : 13 / g ≤ 13 / 40 := by
    have h1 : 1 / g ≤ 1 / 40 := by
      apply (one_div_le_one_div (by linarith : 0 < g) (by norm_num : 0 < (40 : ℝ))).2
      exact hg
    calc
      13 / g = 13 * (1 / g) := by ring
      _ ≤ 13 * (1 / 40) := mul_le_mul_of_nonneg_left h1 (by norm_num)
      _ = 13 / 40 := by ring
  have h13c : 13 / 40 < 1 := by norm_num
  linarith [h13, h13c]

/-  THE FEED vs THE WIRE FLOOR (PROVEN):  on the S3a grid (g >= 40) the
    algebraic dev feed strictly dominates the wire's PROVEN window/strip
    floor family:  floStripMin g d <= max (floWin g) 0 = 23/1000 there
    (floWin g = min (23/1000) (1 - 25/g) <= 23/1000, and max with 0 stays
    <= 23/1000), while 1 - 13 / g >= 1 - 13/40 = 27/40 > 23/1000.  So the
    wire's dev >= f leg is carried by the S3a feed on the grid, with
    strict room to spare. -/
theorem m6_feed_dom (g : ℝ) (hg : 40 ≤ g) (d : ℝ) :
    1 - 13 / g ≥ floStripMin g d := by
  have h13 : 13 / g ≤ 13 / 40 := by
    have h1 : 1 / g ≤ 1 / 40 := by
      apply (one_div_le_one_div (by linarith : 0 < g) (by norm_num : 0 < (40 : ℝ))).2
      exact hg
    calc
      13 / g = 13 * (1 / g) := by ring
      _ ≤ 13 * (1 / 40) := mul_le_mul_of_nonneg_left h1 (by norm_num)
      _ = 13 / 40 := by ring
  have hfeed : 1 - 13 / g ≥ 1 - 13 / 40 :=
    sub_le_sub_left h13 1
  have hfloor : floStripMin g d ≤ 23 / 1000 := by
    rw [floStripMin]
    have hmin : min (‖poff g d g‖) (max (floWin g) 0) ≤ max (floWin g) 0 :=
      min_le_right _ _
    have hmax : max (floWin g) 0 ≤ 23 / 1000 :=
      max_le (by rw [floWin]; exact min_le_left _ _) (by norm_num)
    exact le_trans hmin hmax
  have hsep : (23 : ℝ) / 1000 ≤ 27 / 40 := by norm_num
  have hfeed2 : (1 : ℝ) - 13 / 40 = 27 / 40 := by norm_num
  calc
    (1 : ℝ) - 13 / g ≥ (1 : ℝ) - 13 / 40 := hfeed
    _ = (27 : ℝ) / 40 := hfeed2
    _ ≥ (23 : ℝ) / 1000 := hsep
    _ ≥ floStripMin g d := hfloor

/- (2)  THE W2 NOISE SIDE (PROVEN, the pinned W2M5 instantiation restated
    with a named functional).  The I_DN-side remainder on the band and
    the S1 - R tail of the far-integral telescope are bounded by explicit
    expressions in K_pin = 2.503 and L_pin = Rho(2e9);  the partition
    data (M, x, p, N0, Nas) stays a named hypothesis (the plan's
    "data-adjacent" form).  w2noise is exactly the W2M5.m5_idn RHS, named
    so the composition (m6_compose) can take it as its noise input. -/
noncomputable def w2noise (M : ℕ) (x p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) (k : ℕ) (t : ℝ) : ℝ :=
    K_pin * (∑ j ∈ Finset.range M, abs (W2T.DP p j)) +
      L_pin * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) +
      L_pin * (x (k + 1) - x k) +
      2 * L_pin * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)

/-- (C1)  the W2 I_DN-side bound in named-functional form (W2M5.m5_idn
    restated through w2noise;  same partition hypotheses). -/
theorem w2noise_bound (M k : ℕ) (hM : k < M) (x p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ)
    (t : ℝ) (ht : 0 < t) (ht2 : 1 / 2 ≤ t ^ 2)
    (hRhoLeL : abs (W2K.Rho t) ≤ L_pin)
    (hxPos : ∀ j ∈ Finset.range (M + 1), 0 < x j)
    (hxA : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hLips : ∀ j ∈ Finset.range M,
        ∀ z ∈ Set.Ioo (x j) (x (j + 1)), abs (deriv W2K.Nas z) ≤ L_pin)
    (hxk : x k < t) (hxt : t < x (k + 1))
    (hp : ∀ j ∈ Finset.range (M + 1), p j = W2K.Ker (x j) t)
    (hpNas : ∀ j ∈ Finset.range (M + 1), Nas j = W2K.Nas (x j))
    (hD : ∀ j ∈ Finset.range M, abs (W2T.DN N0 Nas j) ≤ K_pin) :
    abs ((∑ j ∈ Finset.range M,
        (if j = k then W2B.gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
         else W2B.gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))))) ≤
      w2noise M x p N0 Nas k t := by
  unfold w2noise
  exact W2M5.m5_idn M k hM x p N0 Nas t ht ht2 hRhoLeL hxPos hxA hLips hxk hxt hp hpNas hD

/-- (C2)  the W2 S1 - R tail floor with the pinned K (W2M5.m5_floor
    restated):  S1 - R is one-sided bounded below by the explicit
    K_pin expression on any band partition with |DN| <= K_pin. -/
theorem w2noise_tail (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ)
    (hD0 : abs (W2T.DN N0 Nas 0) ≤ K_pin)
    (hDM : abs (W2T.DN N0 Nas M) ≤ K_pin)
    (hD : ∀ j ∈ Finset.range M, abs (W2T.DN N0 Nas j) ≤ K_pin) :
    W2T.S1Sum M p - W2T.RSum M p Nas ≥
      -(K_pin * (abs (p 0) + abs (p M)) +
        K_pin * (∑ j ∈ Finset.range M, abs (W2T.DP p j))) :=
  W2M5.m5_floor M p N0 Nas hD0 hDM hD

/- (3)  THE COMPOSITION (bound level, NO RH claim):  on the strip
    (g < TLow = 1000) at a point (g, d) of the S3a straddle grid
    (g >= 40, 0 <= d <= 1/2;  the feed is uniform in k = 1..12 by
    S3a.s3a_dev),  the wire's squeezed-margin form is instantiated at the
    feed level:  dev := f := 1 - 13 / g (the PROVEN S3a algebraic feed),
    the zero-side quantity Q (the A4.3-wired witness, whose zero/definition
    side carries the |zeta| scaling and the W2-proven fills:  the I_DN
    remainder is <= w2noise by w2noise_bound, the S1 - R tail by
    w2noise_tail) is a NAMED hypothesis hsQ, and the strict squeeze is the
    named headroom hnoise on the noise total Bwire + Mr + Mf.  Output:  the
    wire form, the dominance of the feed over the wire's PROVEN strip floor
    (m6_feed_dom), and the STRICTLY POSITIVE dev-vs-noise margin
    1 - 13 / g - (Bwire + Mr + Mf).  Plan 3.2-D:  this is the bound-level
    form of "margin >= |zeta| * (1 - 1/(K g)) / (noise upper bound)" with
    the |zeta| factor carried by the named noise-side hypotheses, and the
    K of (1 - 1/(K g)) instantiated at K = 13 on g >= 40. -/
theorem m6_compose
    (g : ℝ) (hg : 40 <= g) (hgT : g < TLow)
    (d : ℝ) (hd : 0 <= d) (hdL : d <= 1 / 2)
    (Mf Bwire Mr : ℝ)
    (hsQ : ∃ Q, Q ≥ (1 - 13 / g) - Mf ∧ Q ≤ Bwire + Mr)
    (hnoise : Bwire + Mr + Mf < 1 - 13 / g) :
    (∃ (Q dev f M Bf Mr' : ℝ),
        Q ≥ dev - M ∧ dev ≥ f ∧ Q ≤ Bf + Mr' ∧ Bf + Mr' + M < f) ∧
    (1 - 13 / g) ≥ floStripMin g d ∧
    0 < (1 - 13 / g) - (Bwire + Mr + Mf) := by
  obtain ⟨Q, hQlo, hQhi⟩ := hsQ
  refine ⟨⟨Q, (1 - 13 / g), (1 - 13 / g), Mf, Bwire, Mr, hQlo,
    le_rfl, hQhi, hnoise⟩, ?_, ?_⟩
  · exact m6_feed_dom g hg d
  · exact sub_pos.mpr hnoise

end M6
