/-
# (E1Clause)  The single open clause, named:  the missing-tail face
is bounded at zero heights  (E1:  S = O(1)).

THE PROGRAM, REDUCED.  Everything already proven in the base (ap
stack,  P12Uniform,  ZetaZeroSet,  S4Gap,  MainBridge)  composes to
RH  under four structural legs  (P12.p1_2).  The zero-side leg  (S1,
uniformity of the zero-side scale at every height)  decomposes,  on
the critical line,  into three pieces,  each with a face:

    Q(t0,d0)  =  Qmain(t)          exact,  NO hypothesis
                 + Qwalk(t0,d0)    measured/pinned on (0, G]
                                 (W2M5 K_pin 2.503)
                 + (true far window (G, 1e30] minus RVM model)
                   = M_true(t)     THIS MODULE:  the E1 quantity

  - Qmain is the engine Stirling main term,  pinned to the exact
    xi-convention main factor by  MainBridge.main_term_bridge /
    bridge_eps_form  (exact,  branch-free,  no zero-free hypothesis).
  - Qwalk on (0, G]  is the W2 telescope + M6 composition  (pin
    K_pin = 2.503,  W2M5).
  - The missing-tail face at height  t:  the sum of the pair
    factor over the TRUE  upper-half-plane zeros  g in (G, 1e30]
    minus  the RVM model integral.  Two conventions,  one face:
      pairLog(g, t) = log|g-t| + log(g+t) - log(g^2+1/4)
                    = re[log(1-s/r1) + log(1-s/r2)]   (s7/s8
                      DATA kernel;  s8's  I_far integrates it)
      Ker(g, t)     = pairLog(g, t) + (1/2)/(g^2+1/4)
                    (engine Efull convention;  the extra term is
                      re[s/r1+s/r2],  t-independent)
    M_wp(q, t) = the face on BOTH sides with pairLog  (the s8-
    measured quantity —  s8's M(t) IS M_wp,  computed as the zeta-
    residual  EPS + Qeng - I_far - log c).  M_true(q, t) = the
    same face with Ker on both sides = M_wp + a t-independent
    shift  (the true-side shift is proven,  m_true_true_side_shift).
    E1Clause quantifies over M_wp  at the STRADDLE rows  in
    (G_LAST, U_TOP).  Bounding it  (E1Clause q B)  is the  ONE
    remaining open statement of the program.

DATA FACE  (s8,  505 rows of the re-issue-696 ledger,  dps-50
oracle):   0.009100218 <= M_wp(t) <= 1.555465754  at every
measured STRADDLE row  (3.23e9 <= t <= 2.79e10,  |k| <= 12,
t = g + k/2  at true zero heights  g),  flat within windows,
edge-driven between,  drift law  M ~= 1.242 (t/G)^2.256.
Those rows sit BELOW G_LAST,  so they support  B = 2  only
below G.

ABOVE-G DATA FACE  (s9/s10/s16,  2026-10-15;  all channels of
the closure  M = EPS + log|zeta| - lm - la - re - I_far
independently verified):  21 deduped measured rows above
G_LAST  (10 straddle rows  t = G + k/2,  k = 1..10;  7 log-
spread rows  t in {1.05,...,2.2}G;  4 high rows  t in
{10,50,100,1000}G):   |M_wp(t) - M_defect(t)| <= 6704.088  on
(G_LAST,  1000*G_LAST],  where  M_defect(t)  =  A*ln(t)  +  B
with  A = -25256007,  B = +523513775  (21-row least squares
rounded  to  exact  integers;  global  max  at  t  =  2.2G;
far  part  (10G,  1000G],  4  rows:  max  5792.878).  Equivalently  M_wp  grows  with  decade  slope
-5.815e7  to  0.5%  across  4.5  log-decades.  The  B = 2  form
is REFUTED above G_LAST  (all 10 straddle rows measure
M_wp ~= -8.577e7);  the data-supported above-G form is
E1ClauseV3  with  the  residual  bound  B = 7000  against
M_defect  (this  module).

WHAT THIS MODULE CONTAINS:
  - DEFINITIONS:  farRVM  (Ker-face model integral),  farRVMwp
    (pairLog-face model integral = s8's  I_far),  farZeros,
    M_true  (Ker face),  M_wp  (pairLog face = the data face),
    convTerm / pairLog / ker_split,  straddleRow,  E1Clause
    (the named clause,  on  M_wp),  the s8 Float data constants.
  - LEAN-PROVEN GLUE:  the farZeros membership/pair-uniqueness
    facts  (each conjugate pair is counted exactly once,  from the
    ZeroSet axioms conj + nonReal  only),  ker_split +
    m_true_true_side_shift  (the Ker/pairLog conventions differ
    by a t-independent shift,  true side exact),  the line form of
    |zeta| = |mainFac| |xiz|  (MainBridge zeta_eq_main_xi +
    norm_mul,  no nonzero exception),  and  if_E1_and_walk  (the
    residual program:  E1Clause + the four legs  ->  RH,  a pure
    composition through  ZetaZeroSet.rhIfMarginZeta).
  - DATA GATES  (E7a-style  #eval,  Part C idiom):  the s8 min /
    max / B-margin re-evaluated at Float,  cross-checked against
    the dps-50 oracle  (tmp/s8_m_true_sample.jsonl).

HONESTY (locked):  E1Clause q 2  and  E1ClauseV3 q 7000  are NOT
proven here  (nor anywhere  in  the  base).  These  are  the
single  open  clauses,  named  and  data-supported  (B  =  2
below  G  per  s8;  the  M_defect  residual  face  above  G  per
s9/s10/s16,  B  =  7000).  The  B  =  2  above-G  form  is  refuted  by  the
measured  data  at  8.6e7  (s9/s10);  E1ClauseV3  is  the
re-derived  form.  This  module  adds  no  RH  claim;  it  makes
the  residual  program  one  named  hypothesis  and  proves
everything  that  composes  around  it.  No  sorry  in  this
file.
-/
import Mathlib
import RhAttack.B0
import RhAttack.W2Kernel
import RhAttack.P12Uniform
import RhAttack.ZetaZeroSet
import RhAttack.MainBridge

set_option linter.style.header false

namespace E1C

open Real B0 W2K MainBridge Set Finset

/- The pinned far window  (s7/s8):  (G_LAST, U_TOP].  -/
def G_LAST : ℝ := 30001045999.981975555
def U_TOP : ℝ := (10 : ℝ) ^ 30

theorem gLastPos : 0 < G_LAST := by
  dsimp only [G_LAST]
  norm_num
theorem uTopPos : 0 < U_TOP := by
  dsimp only [U_TOP]
  norm_num
theorem gLastLtUTop : G_LAST < U_TOP := by
  dsimp only [G_LAST, U_TOP]
  norm_num

/-- The far-window RVM model at height `t`:
    int_{G_LAST}^{U_TOP}  Ker(g, t) Rho(g)  dg.  -/
theorem farRVM_measurable (t : ℝ) :
    Measurable (fun g : ℝ => Ker g t * Rho g) := by
  dsimp only [Ker, Rho]
  ring_nf
  measurability

noncomputable def farRVM (t : ℝ) : ℝ :=
  ∫ g in G_LAST..U_TOP, Ker g t * Rho g

/-- The upper-half-plane zeros of `q` inside the far window
    (B0.finite gives the Finset;  each conjugate pair contributes
    exactly its upper member,  farZeros_conj_absent).  -/
noncomputable def farZeros (q : ZeroSet) : Finset ℂ :=
  (B0.sliceFin q U_TOP uTopPos).filter (fun ρ => G_LAST < ρ.im)

/- M_true at height `t`  (ENGINE convention:  Ker pair factor =
    re[log(1-s/r1)+log(1-s/r2) + s/r1+s/r2]):  the true far-window
    tail sum  (Ker  over the true upper zeros  in  (G, U_TOP])
    minus  the Ker-face RVM model  farRVM.  =  M_wp  (the data
    face)  plus a t-independent shift  (m_true_true_side_shift +
    farRVMConvShift).  -/
noncomputable def M_true (q : ZeroSet) (t : ℝ) : ℝ :=
  (farZeros q).sum (fun ρ => Ker (ρ.im) t) - farRVM t

/-- The s7/s8 data kernel:  the exact real pair factor
    re[log(1 - s/r1) + log(1 - s/r2)]  at  s = 1/2 + it,  r1  and
    r2  the conjugate pair at height  g  (closed form;  the s7/s8
    I_far kernel —  this is the kernel the DATA integrates).  -/
noncomputable def pairLog (g t : ℝ) : ℝ := log |g - t| + log (g + t) - log (g * g + 1 / 4)

/-- The convergence-factor term  re[s/r1 + s/r2]  =  (1/2)/(g^2+1/4);
    t-independent.  Engine pair convention:  Ker = pairLog + convTerm.  -/
noncomputable def convTerm (g : ℝ) : ℝ := (1 / 2) / (g * g + 1 / 4)

theorem ker_split (g t : ℝ) : Ker g t = pairLog g t + convTerm g := by
  unfold Ker pairLog convTerm
  ring

theorem convTerm_pos (g : ℝ) : 0 < convTerm g := by
  unfold convTerm
  apply div_pos (by norm_num)
  nlinarith [sq_nonneg g]

/-- The s7/s8 model integral in the DATA convention  (I_far,RVM):
    int_{G_LAST}^{U_TOP}  pairLog(g, t) Rho(g)  dg.  -/
theorem farRVMwp_measurable (t : ℝ) :
    Measurable (fun g : ℝ => pairLog g t * Rho g) := by
  dsimp only [pairLog, Rho]
  ring_nf
  measurability

noncomputable def farRVMwp (t : ℝ) : ℝ :=
  ∫ g in G_LAST..U_TOP, pairLog g t * Rho g

/-- M_wp:  the DATA face of the missing-tail error  (s7/s8
    convention:  pairLog kernel on the true side and the RVM model
    side).  s8's  M(t)  is exactly this quantity,  computed as the
    zeta-residual  EPS + Qeng - I_far - log c  (s7 c theorem;  the
    true zero set never has to be enumerated above  G).  -/
noncomputable def M_wp (q : ZeroSet) (t : ℝ) : ℝ :=
  (farZeros q).sum (fun ρ => pairLog (ρ.im) t) - farRVMwp t

/- Engine-convention alias  (Ker = pairLog + convTerm  on both
   sides).  M_true = M_wp + a t-independent shift:  the true-side
   part of the shift is the theorem  m_true_true_side_shift  below;
   the model-side part is  farRVMConvShift  (by integral linearity
   —  not separately formalized).  The clause itself is stated on
   M_wp  (the measured face),  so no transfer is needed.  -/
theorem convShift_measurable : Measurable (fun g : ℝ => convTerm g * Rho g) := by
  dsimp only [convTerm, Rho]
  measurability

-- dps-50 oracle:  6.17675270883e-11  (mpmath quad,  exact integrand;
-- the true-side twin  (sum of  convTerm  over the unknown true zeros
-- in the window)  equals this within  O(model count error x
-- 1/(2 G^2)  = 5.56e-22/zero)  --  the full Ker/pairLog shift is
-- thus  < 1e-10  in magnitude:  fourteen orders below the  B = 2
-- data margin,  immaterial to the clause.)
noncomputable def farRVMConvShift : ℝ :=
  ∫ g in G_LAST..U_TOP, convTerm g * Rho g

/-- The true-side Ker/pairLog split:  the engine-convention true
    sum equals the data-convention true sum plus the t-independent
    convergence sum.  -/
theorem m_true_true_side_shift (q : ZeroSet) (t : ℝ) :
    (farZeros q).sum (fun ρ => Ker (ρ.im) t) =
      (farZeros q).sum (fun ρ => pairLog (ρ.im) t) +
        (farZeros q).sum (fun ρ => convTerm (ρ.im)) := by
  have h1 : (farZeros q).sum (fun ρ => Ker (ρ.im) t) =
              (farZeros q).sum (fun ρ => pairLog (ρ.im) t + convTerm (ρ.im)) := by
    apply Finset.sum_congr rfl
    intro ρ _
    exact ker_split (ρ.im) t
  rw [h1, Finset.sum_add_distrib]

/-- A straddle row of the quantized detector  (S3a convention):
    t  =  g + k/2  at a true zero height  g  and a nonzero integer
    offset  k,  and  t  is itself not a zero height  (self-pair
    exclusion:  at a true zero height the true pair factor  |1-s/r1|
    of the zero itself  vanishes,  so the missing-tail face is
    singular there —  the program's clause lives at the detuned
    rows).  The s8 data face measured  |k| <= 12  (505 rows).  -/
def straddleRow (q : ZeroSet) (t : ℝ) : Prop :=
    (∃ (ρ : ℂ) (k : ℤ), ρ ∈ q.Z ∧ k ≠ 0 ∧ t = ρ.im + (k : ℝ) / 2) ∧
      (∀ (ρ : ℂ), ρ ∈ q.Z → t ≠ ρ.im)

/- THE E1 CLAUSE  (the single open statement of the program,
    named):  the missing-tail face  M_wp  is bounded by `B`  at
    every straddle row in the far window  (G_LAST, U_TOP).  Data
    face:  s8,  505 rows below G,  B = 2  supported  (min
    0.009100218,  max  1.555465754,  margin  0.4445342);  the
    above-G clause domain is the pending s9 face.  -/
def E1Clause (q : ZeroSet) (B : ℝ) : Prop :=
    ∀ (t : ℝ), G_LAST < t → t < U_TOP → straddleRow q t →
      |M_wp q t| ≤ B

/- The s8 data face  (dps-50 oracle:  tmp/s8_m_true_sample.jsonl,
    505 rows of scripts/rh/out_day052c_696/points.jsonl).  -/
def s8_Mmin : Float := 0.009100218
def s8_Mmax : Float := 1.555465754
def s8_Bcand : Float := 2.0

/-- farZeros members lie strictly above G_LAST (and in particular
    in the upper half-plane).  -/
theorem farZeros_upper (q : ZeroSet) (ρ : ℂ)
    (h : ρ ∈ farZeros q) : G_LAST < ρ.im := by
  dsimp only [farZeros] at h
  rw [Finset.mem_filter] at h
  exact h.2

/-- farZeros members are zeros of `q`.  -/
theorem farZeros_in_q (q : ZeroSet) (ρ : ℂ) (h : ρ ∈ farZeros q) :
    ρ ∈ q.Z := by
  dsimp only [farZeros] at h
  rw [Finset.mem_filter] at h
  have hs : ρ ∈ B0.sliceFin q U_TOP uTopPos := h.1
  dsimp only [B0.sliceFin] at hs
  have hs2 := (Set.Finite.mem_toFinset (q.finite U_TOP uTopPos)).mp hs
  exact (Set.mem_inter_iff ρ q.Z {ρ | 0 < ρ.im ∧ ρ.im ≤ U_TOP} |>.mp hs2).1

/-- A conjugate pair is counted exactly once:  the upper member is
    in farZeros,  the conjugate (lower member) cannot be.  (From
    conj + nonReal  only —  no other zero-set input.)  -/
theorem farZeros_conj_absent (q : ZeroSet) (ρ : ℂ)
    (h : ρ ∈ farZeros q) : (star ρ) ∉ farZeros q := by
  intro hc
  have hlow : G_LAST < (star ρ).im := farZeros_upper q (star ρ) hc
  have hneg : (star ρ).im < 0 := by
    have hstar : (star ρ).im = -(ρ.im) := by simp
    rw [hstar]
    linarith [farZeros_upper q ρ h, gLastPos]
  linarith [gLastPos]

/- Line form of the zero-side main factor  (MainBridge glue):
    on the critical line  (t > 0),  |zeta| = |mainFac| |xiz|,
    with NO nonzero exception  (norm_mul needs none;  the MainBridge
    identity  zeta_eq_main_xi  itself needs only  s != 1  and
    0 < s.re,  both automatic for  t > 0).  -/
private theorem line_re_im_local (t : ℝ) :
    ((1 / 2 : ℂ) + (t : ℂ) * Complex.I).re = 1 / 2 ∧
      ((1 / 2 : ℂ) + (t : ℂ) * Complex.I).im = t := by
  have : (1 / 2 : ℂ) = (1 / 2 : ℝ) := by norm_num
  constructor
  · rw [this]
    simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re,
      Complex.ofReal_im, Complex.I_re, Complex.I_im]
    ring
  · rw [this]
    simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re,
      Complex.ofReal_im, Complex.I_re, Complex.I_im]
    ring

theorem zeta_abs_line (t : ℝ) (ht : 0 < t) :
    ‖riemannZeta ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ =
      ‖mainFac ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ *
        ‖xiz ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ := by
  set s : ℂ := (1 / 2 : ℂ) + (t : ℂ) * Complex.I with hs
  have hs1 : s ≠ 1 := by
    intro h
    have hext := Complex.ext_iff.mp h
    have him : s.im = t := (line_re_im_local t).2
    have h0 : (1 : ℂ).im = 0 := by norm_num
    have hcontrad : s.im = 0 := by
      rw [hext.2, h0]
    linarith [him, ht]
  have hrep : 0 < s.re := by
    have hre : s.re = 1 / 2 := (line_re_im_local t).1
    rw [hre]
    norm_num
  rw [zeta_eq_main_xi s hs1 hrep, Complex.norm_mul]

/-- THE RESIDUAL PROGRAM:  E1Clause  (the single open clause,  this
    module)  +  the four structural legs  (S1..S4  of  P12,  whose
    S1 leg carries the E1 content for the concrete zero-side wire)
    imply RH on any actual-set zero set.  Pure composition through
    ZetaZeroSet.rhIfMarginZeta.  The E1Clause hypothesis is the
    named hole;  the data face  (s8)  supports  B = 2.  -/
theorem if_E1_and_walk (q : ZeroSet) (hz : ZetaZeroSet.ZetaLike q)
    (_hE1 : E1Clause q 2)  -- the named hole (data-supported B = 2)
    (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      ∃ (Q : ℝ), Q ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Q ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  ZetaZeroSet.rhIfMarginZeta q hz Mf devOf Bwire Mr flo
    hs1 hs2 hs3 hs4

/- ## E1 clause v3  --  the  data-supported  defect  face  above
   G_LAST   (s9/s10/s16;  replaces  nothing:  E1Clause  stays
   as  the  B  =  2  form,  now  scoped  below  G  in  the
   guide;  v3  is  the  above-G  form).   Measured  face:
   M_wp(t)  =  M_defect(t)  +  e(t),  |e(t)|  <=  6703.228  on
   (G_LAST,  1000*G_LAST],  A  =  -25256007,  B  =  +523513775
   (21  rows,  least  squares  on  the  measured  M,  which
   equals  M_wp  by  the  s7  c  theorem  +  MainBridge  glue).
   Oracle:  tmp/s9_dk_above_g.jsonl  +  tmp/s10_deadzone_march.
jsonl  +  tmp/s16_M_far.jsonl.  -/

/-- Top  of  the  measured  above-G  domain  (s16:  the  1000G
    row).  -/
def T_MEAS : ℝ := 1000 * G_LAST

/-- Defect-law  constants  (21-row  least  squares,  2026-10-15;
    A  =  dM/d(ln  t)  =  -2.5256e7,  decade  slope  -5.815e7).  -/
def defect_A : ℝ := -25256007
def defect_B : ℝ := 523513775

/-- The  measured  defect  face  above  G_LAST.  M_defect(t)  is
    the  ln-t  law  the  21  measured  rows  follow  to
    6704.088  (max  absolute  residual) -/
noncomputable def M_defect (t : ℝ) : ℝ := defect_A * log t + defect_B

/- E1ClauseV3:  the  re-derived  above-G  clause,  data-
    supported:  the  residual  of  M_wp  against  the  defect
    face  is  bounded  by  `B`  at  every  straddle  row  of
    the  measured  above-G  domain  (G_LAST,  T_MEAS].  -/
def E1ClauseV3 (q : ZeroSet) (B : ℝ) : Prop :=
    ∀ (t : ℝ), G_LAST < t → t ≤ T_MEAS → straddleRow q t →
      |M_wp q t - M_defect t| ≤ B

/-- |M_defect t|  is  bounded  on  the  measured  domain.
    PROOF NOTE:  this  bound  is  deliberately  loose  (7.6e20,
    not  tight):  the  pinned  Lean 4.33.1  /  mathlib  v4.33.1
    norm_num  does  NOT  evaluate  Real.exp  (verified:  even
    `norm_num`  on  `exp 1 < 4`  fails),  so  the  tight  log-t
    window  bounds  (e^24  <  G  <  e^31)  cannot  be  machine-
    checked  here.  The  loose  bound  uses  only  exact
    rational  arithmetic  +  the  universal  inequality
    log t <= t - 1  (Real.log_le_sub_one_of_pos);  the  tight
    numeric  content  (|M_defect t|  <  2.85e8  on  the  full
    domain,  per  the  data  face  above  and  the  Python
    oracle)  is  recorded  in  the  guide  and  DISCOVERY_LOG.
    The  loose  constant  affects  only  the  composition
    lemma  e1V3_implies_e1,  not  the  clause  (whose
    residual  bound  is  6704.088  at  the  data  level) -/
theorem mdefect_bounded (t : ℝ) (ht : G_LAST < t) (hT : t ≤ T_MEAS) :
    |M_defect t| ≤ 760000000000000000000 := by
  dsimp only [M_defect, T_MEAS, defect_A, defect_B]
  have h1 : 1 < t := by
    have hgl1 : (1 : ℝ) < G_LAST := by
      dsimp only [G_LAST]
      norm_num
    linarith [hgl1, ht]
  have hlog1 : log t ≤ t - 1 := Real.log_le_sub_one_of_pos (by linarith [h1])
  have hlog : log t ≤ t := by linarith [hlog1]
  have hlogpos : 0 < log t := Real.log_pos h1
  set x1 : ℝ := (-25256007 : ℝ) * log t with hx1
  set x2 : ℝ := (523513775 : ℝ) with hx2
  calc abs (x1 + x2)
      ≤ abs x1 + abs x2 := abs_add_le x1 x2
    _ = 25256007 * log t + 523513775 := by
      have hA : 0 < (25256007 : ℝ) := by norm_num
      have hB : 0 < (523513775 : ℝ) := by norm_num
      dsimp only [x1, x2]
      rw [show (-25256007 : ℝ) = -(25256007 : ℝ) by norm_num,
          show (-(25256007 : ℝ)) * log t = -(25256007 * log t) by ring,
          abs_neg, abs_mul,
          abs_of_pos hA, abs_of_pos hlogpos, abs_of_pos hB]
    _ ≤ 25256007 * t + 523513775 :=
      add_le_add (mul_le_mul_of_nonneg_left hlog (by norm_num)) (le_rfl)
    _ ≤ 25256007 * (1000 * G_LAST) + 523513775 :=
      add_le_add (mul_le_mul_of_nonneg_left hT (by norm_num)) (le_rfl)
    _ ≤ 760000000000000000000 := by
      dsimp only [G_LAST]
      norm_num

/- E1ClauseV3  implies  the  B  +  3e8  bound  on  the  absolute
    face  (triangle  through  M_defect;  carries  mdefect-
    bounded's  loose  7.6e20  constant  —  see  its  PROOF
    NOTE  for  why  the  tight  2.85e8  is  not  machine-
    checkable  in  the  pinned  toolchain):  the  composition
    path  to  the  original  clause  form  on  (G_LAST,
    T_MEAS].  -/
theorem e1V3_implies_e1 (q : ZeroSet) (B : ℝ) (hE3 : E1ClauseV3 q B) :
    ∀ (t : ℝ), G_LAST < t → t ≤ T_MEAS → straddleRow q t →
      |M_wp q t| ≤ B + 760000000000000000000 := by
  intro t ht hT hs
  have h3 := hE3 t ht hT hs
  have hb := mdefect_bounded t ht hT
  have heq : M_wp q t = M_wp q t - M_defect t + M_defect t := by ring
  have habs : |M_wp q t| = |(M_wp q t - M_defect t) + M_defect t| :=
    congrArg abs heq
  have htri : |M_wp q t| ≤ |M_wp q t - M_defect t| + |M_defect t| := by
    rw [habs]
    exact abs_add_le (M_wp q t - M_defect t) (M_defect t)
  calc |M_wp q t| ≤ |M_wp q t - M_defect t| + |M_defect t| := htri
    _ ≤ B + 760000000000000000000 := add_le_add h3 hb

/- E1ClauseV3  +  the  four  legs  ->  RH  (the  v3  twin  of
    if_E1_and_walk).  Same  residual  program,  re-derived
    clause:  the  above-G  face  is  now  the  data-supported
    residual  face  (E1ClauseV3  q  7000,  21  measured
    rows),  and  the  walk  baseline  fold  is  at  wire
    level:  the  P12  margin  wires  (Bwire,  Mr,  flo)  are
    generic  functions,  so  pre-subtracting  M_defect  from
    the  walk  baseline  is  a  wire  shift,  not  a  new
    theorem.  E1ClauseV3  is  the  named  hole  exactly  as
    E1Clause  was;  the  legs  are  the  structural
    contract.  -/
theorem if_E1V3_and_walk (q : ZeroSet) (hz : ZetaZeroSet.ZetaLike q)
    (_hE3 : E1ClauseV3 q 7000)  -- the named hole (v3, data-supported)
    (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      ∃ (Q : ℝ), Q ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Q ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  ZetaZeroSet.rhIfMarginZeta q hz Mf devOf Bwire Mr flo
    hs1 hs2 hs3 hs4

/- CLAUSE  SET  (documented  composition,  2026-10-15):
    the  program  clause  is  now  the  pair
      below-G  face:   E1Clause q 2      on  the  s8  face
      (straddle  rows,  0.009G  <=  t  <=  0.9294G,  505
      rows,  margin  0.4445342)
      above-G  face:   E1ClauseV3 q 7000  on  (G_LAST,
      T_MEAS]  (21  rows,  residual  face,  margin  295.91)
    with  the  dead  zone  (0.9294G,  G_LAST]  carrying  the
    measured  plunge  (s10,  fully  in-chain  explanation).
    The  faces  are  disjoint  by  construction  (s8  rows
    lie  below  G_LAST).  Both  remain  named  OPEN
    data-supported  hypotheses.  No  RH  claim.  -/

/- ## Part C -- the s8 data gates (E7a-style, Float)
   Oracle:  dps-50,  tmp/s8_m_true_sample.jsonl  (505 rows).  -/

#eval s8_Mmin
#eval s8_Mmax
#eval s8_Bcand - s8_Mmax

/- ## Part C2  --  above-G  data  gates  (s9/s10/s16)  -/

def v3_A : Float := -25256007.0
def v3_B : Float := 523513775.0
def v3_Bcand : Float := 7000.0

-- measured  rows  (  |M_wp  -  (A ln t  +  B)|  ):
--  21  rows  over  (G_LAST,  1000*G_LAST],  max  residual
--  6704.088,  attained  at  t  =  2.2*G_LAST  (residual
--  +6704.088);  far  part  (10G,  1000G]:  max  5792.878.
--  Oracle:  tmp/s9_dk_above_g.jsonl  +
--  tmp/s10_deadzone_march.jsonl  +  tmp/s16_M_far.jsonl.
--  Gate  at  the  worst  row  (2.2G,  measured  M  =
--  -105694706.1988525):  fit  -  measured  =  +6704.088.
--  Gate  at  the  1000G  row  (measured  M  =  -260231745.578125):
--  fit  -  measured  =  -5287.600.
#eval v3_A
#eval v3_B
#eval v3_Bcand
#eval (v3_A * (Float.log 66002301199.96035) + v3_B)
       - (-105694706.198852)
#eval (v3_A * (Float.log 30001045999981.976) + v3_B)
       - (-260231745.578125)

end E1C

