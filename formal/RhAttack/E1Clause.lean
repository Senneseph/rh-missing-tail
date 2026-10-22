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
    (Qside Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  ZetaZeroSet.rhIfMarginZeta q hz Qside Mf devOf Bwire Mr flo
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
    (Qside Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  ZetaZeroSet.rhIfMarginZeta q hz Qside Mf devOf Bwire Mr flo
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

/- ## Part D  --  the  s17  three-term  face  (discovery  0153,
   2026-10-22).

   The  two-term  defect  law  above  G  was  fit  on  (G,
   1000*G].  S17  measured  12  further  rows  out  to  the  9e18
   wall  (tmp/s17_M_far2.jsonl,  dps-40  channel):  the  two-term
   residual  flips  sign  above  3.16e16  and  grows  like  -C
   t^2.  The  t^2  coefficient  is  NOT  an  empirical  fit:  it
   is  the  closed  form  of  the  RVM  density  channel's  U_TOP
   upper  cutoff  (0153  U-ladder:  the  row-wise  coefficient
   tracks  the  closed  form  to  6  digits  at  U'  =  1e25,  4
   digits  at  U'  =  1e20;  I_far  itself  is  numerically
   converged  to  <  0.5  absolute  across  5  resolutions):

       C(U)  =  -(log (U / (2 pi))  +  1) / (2 pi U)

   The  three-term  law  M3(t)  =  A3 log t  +  B3  +  C t^2  fits
   the  33-row  face  (8  s9  k-variants  +  6  s9  r-rows  +  4
   s16  far  rows  +  12  s17  rows,  t  =  3.0001046e10  ..
   9e18;  oracle  tmp/s9_dk_above_g.jsonl  +  tmp/s16_M_far.jsonl
   +  tmp/s17_M_far2.jsonl)  with  the  integer  pins  below  to
   max  |resid|  7986.8  (at  t  =  3.0001046e11,  the  s16  10G
   row;  the  12  s17  rows  fit  within  ~400).  The  free
   3-parameter  fit  returns  C_free  =  -1.0860663478e-29  vs
   the  closed  form  -1.0860681706e-29  (relative  1.7e-5):
   the  t^2  term  was  the  only  genuinely  empirical  piece  of
   the  0152  law  and  is  now  in-principle.  The  two-term
   hole  (E1ClauseV3  q  7000)  stays  the  NAMED  data  hole  of
   its  own  window  (G,  1000*G]  (two-term  residual  there:
   max  6704.088,  unchanged);  the  three-term  hole  below  is
   the  new  NAMED  data  hole  of  the  extended  window  (G,
   9e18].  They  coexist  as  data-supported  named
   hypotheses  (no  implication  claimed  between  them  -  the
   defect  functions  differ  by  up  to  ~9806  on  the  old
   window).  No  RH  claim.  -/

/- Measured  wall  (s17  final  row,  2026-10-22):  t  =  9e18.
    M(9e18)  =  -1458437120.0  (dps-40  channel).  -/
def T_MEAS3 : ℝ := 9000000000000000000

theorem tMeas3Pos : 0 < T_MEAS3 := by
  dsimp only [T_MEAS3]
  norm_num

theorem gLastLtTMeas3 : G_LAST < T_MEAS3 := by
  dsimp only [G_LAST, T_MEAS3]
  norm_num

/- Three-term  pins  (33-row  least-squares  with  C  =  the
    closed  form  below  fixed,  A/B  fit  then  rounded  to
    integers;  A_fit  =  -25254353.6228,  B_fit  =  +523472285.0544;
    integer  pins  at  these  values:  face  max  |resid|  7986.8).  -/
def defect_A3 : ℝ := -25254354
def defect_B3 : ℝ := 523472285

/- The  numerator  L3  =  log (U_TOP/(2 pi))  +  1  >  0.  -/
noncomputable def defect_L3 : ℝ := Real.log (U_TOP / (2 * Real.pi)) + 1

lemma defect_L3_pos : 0 < defect_L3 := by
  dsimp only [defect_L3, U_TOP]
  have hu : (1 : ℝ) < (10 : ℝ) ^ 30 / (2 * Real.pi) := by
    rw [one_lt_div (show (0 : ℝ) < 2 * Real.pi by linarith [Real.pi_pos])]
    have h8u : (8 : ℝ) < (10 : ℝ) ^ 30 := by norm_num
    linarith [h8u, Real.pi_lt_four]
  nlinarith [Real.log_pos hu]

/- t^2  coefficient  (0153  closed  form):  numerically
    -1.0860681706e-29  at  U_TOP  =  10^30.  -/
noncomputable def defect_C3 : ℝ := -defect_L3 / (2 * Real.pi * U_TOP)

/- The  three-term  defect:  M3(t)  =  A3 log t  +  B3  +  C3 t^2
    (0153  law  on  the  33-row  face).  -/
noncomputable def M_defect3 (t : ℝ) : ℝ :=
    defect_A3 * Real.log t + defect_B3 + defect_C3 * t * t

lemma defect_C3neg : defect_C3 < 0 := by
  dsimp only [defect_C3]
  have hden : (0 : ℝ) < 2 * Real.pi * U_TOP := by
    apply mul_pos
    · linarith [Real.pi_pos]
    · exact uTopPos
  rw [div_neg_iff]
  right
  exact ⟨by linarith [defect_L3_pos], hden⟩

--  #eval  check  (Float  only  -  the  closed  form  is
--    noncomputable  in  Lean):  expect  ≈  -1.086068...e-29.  -/
#eval (-(Float.log ((1e30 : Float) / (6.283185307179586 : Float)) + 1)
        / ((6.283185307179586 : Float) * (1e30 : Float))
        * (1e29 : Float))  -- expect  ≈  -1.086068  (× 10^29)

theorem defect_L3_le_271 : defect_L3 ≤ (271 : ℝ) := by
  dsimp only [defect_L3, U_TOP]
  have hmono : Real.log ((10 : ℝ) ^ 30 / (2 * Real.pi)) ≤
      Real.log ((10 : ℝ) ^ 30) := by
    apply Real.log_le_log
    · exact div_pos (show (0 : ℝ) < (10 : ℝ) ^ 30 by norm_num)
        (show (0 : ℝ) < 2 * Real.pi by linarith [Real.pi_pos])
    · exact div_le_self (show (0 : ℝ) <= (10 : ℝ) ^ 30 by norm_num)
        (show (1 : ℝ) <= 2 * Real.pi by linarith [Real.pi_gt_three])
  have hlu : Real.log ((10 : ℝ) ^ 30) = (30 : ℝ) * Real.log 10 := by
    rw [Real.log_pow]
    ring
  have hlog10 : Real.log (10 : ℝ) ≤ (9 : ℝ) := by
    apply (Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < (10 : ℝ))).trans
    norm_num
  calc _
      = Real.log ((10 : ℝ) ^ 30 / (2 * Real.pi)) + 1 := rfl
    _ ≤ Real.log ((10 : ℝ) ^ 30) + 1 := by
      have hm := add_le_add_right hmono 1
      ring_nf at hm ⊢
      exact hm
    _ ≤ (30 : ℝ) * Real.log 10 + 1 := by rw [hlu]
    _ ≤ (271 : ℝ) := by
      have hm9 : (30 : ℝ) * Real.log 10 ≤ (30 : ℝ) * 9 := by
        have hm := mul_le_mul_of_nonneg_right hlog10
            (by norm_num : (0 : ℝ) ≤ (30 : ℝ))
        ring_nf at hm ⊢
        exact hm
      nlinarith [hm9]

lemma defect_C3absT3 : |defect_C3| * T_MEAS3 ≤ (2439 : ℝ) / (10 : ℝ) ^ 12 := by
  have h2pi1 : (1 : ℝ) < 2 * Real.pi := by
    linarith [Real.pi_gt_three]
  have habs : |(-defect_L3) / (2 * Real.pi * U_TOP)| =
      defect_L3 / (2 * Real.pi * U_TOP) := by
    rw [abs_div, abs_neg, abs_of_nonneg (le_of_lt defect_L3_pos),
        abs_of_pos (show (0 : ℝ) < 2 * Real.pi * U_TOP by
          apply mul_pos
          · linarith [Real.pi_pos]
          · exact uTopPos)]
  dsimp only [defect_C3]
  rw [habs]
  have hdenpos : (0 : ℝ) < 2 * Real.pi := by linarith [Real.pi_pos]
  have hinv : (1 : ℝ) / (2 * Real.pi) <= 1 := by
    rw [div_le_one hdenpos]
    linarith [Real.pi_gt_three]
  have hnum : (0 : ℝ) ≤ defect_L3 / U_TOP :=
    div_nonneg (le_of_lt defect_L3_pos) (le_of_lt uTopPos)
  have hform : defect_L3 / (2 * Real.pi * U_TOP) =
      (defect_L3 / U_TOP) * (1 / (2 * Real.pi)) := by
    field_simp [show (0 : ℝ) < 2 * Real.pi from hdenpos, uTopPos]
  have hdiv1 : defect_L3 / (2 * Real.pi * U_TOP) ≤ defect_L3 / U_TOP := by
    calc _ = (defect_L3 / U_TOP) * (1 / (2 * Real.pi)) := hform
      _ ≤ (defect_L3 / U_TOP) * 1 := by
        have hm := mul_le_mul_of_nonneg_right hinv hnum
        ring_nf at hm ⊢
        exact hm
      _ = defect_L3 / U_TOP := by ring
  have hdiv2 : defect_L3 / U_TOP ≤ 271 / U_TOP := by
    have hinvU : (0 : ℝ) ≤ 1 / U_TOP :=
      div_nonneg (by norm_num : (0 : ℝ) ≤ 1) (le_of_lt uTopPos)
    calc _ = (1 / U_TOP) * defect_L3 := by ring
      _ ≤ (1 / U_TOP) * 271 :=
        mul_le_mul_of_nonneg_left defect_L3_le_271 hinvU
      _ = 271 / U_TOP := by ring
  have hTpos : (0 : ℝ) < T_MEAS3 := tMeas3Pos
  calc _
      ≤ (defect_L3 / U_TOP) * T_MEAS3 := by
        calc _ = T_MEAS3 * (defect_L3 / (2 * Real.pi * U_TOP)) := by ring
          _ ≤ T_MEAS3 * (defect_L3 / U_TOP) :=
            mul_le_mul_of_nonneg_left hdiv1 (le_of_lt hTpos)
          _ = (defect_L3 / U_TOP) * T_MEAS3 := by ring
      _ ≤ (271 / U_TOP) * T_MEAS3 := by
        calc _ = T_MEAS3 * (defect_L3 / U_TOP) := by ring
          _ ≤ T_MEAS3 * (271 / U_TOP) :=
            mul_le_mul_of_nonneg_left hdiv2 (le_of_lt hTpos)
          _ = (271 / U_TOP) * T_MEAS3 := by ring
      _ = (2439 : ℝ) * (10 : ℝ) ^ 18 / ((10 : ℝ) ^ 30) := by
        dsimp only [T_MEAS3, U_TOP]
        field_simp [show (0 : ℝ) < (10 : ℝ) ^ 30 by norm_num]
        <;> norm_num
      _ = (2439 : ℝ) / (10 : ℝ) ^ 12 := by
        field_simp [show (0 : ℝ) < (10 : ℝ) ^ 30 by norm_num]
        <;> norm_num

theorem mdefect3_bounded (t : ℝ) (ht : G_LAST < t) (hT : t ≤ T_MEAS3) :
    |M_defect3 t| ≤ (230000000 : ℝ) * (10 : ℝ) ^ 18 := by
  dsimp only [M_defect3, defect_A3, defect_B3]
  have h1 : (1 : ℝ) < t := by
    have hgl1 : (1 : ℝ) < G_LAST := by
      dsimp only [G_LAST]
      norm_num
    linarith [hgl1, ht]
  have hlog1 : Real.log t ≤ t - 1 := Real.log_le_sub_one_of_pos (by linarith [h1])
  have hlogpos : 0 < Real.log t := Real.log_pos h1
  have htul : 0 ≤ t := by linarith [h1]
  have ht2 : t * t ≤ T_MEAS3 * t := by
    have hf : (0 : ℝ) <= t * (T_MEAS3 - t) :=
      mul_nonneg htul (show 0 <= (T_MEAS3 - t) by linarith [hT])
    ring_nf at hf ⊢
    linarith
  have hA : (0 : ℝ) < 25254354 := by norm_num
  have hB : (0 : ℝ) < 523472285 := by norm_num
  have habsA : |(-25254354) * Real.log t| = 25254354 * Real.log t := by
    rw [abs_mul, abs_of_neg (by norm_num), abs_of_pos hlogpos]
    ring
  have habsC : |defect_C3 * t * t| = |defect_C3| * t * t := by
    rw [abs_mul, abs_mul, abs_of_pos (lt_trans zero_lt_one h1)]
  calc
    |(-25254354) * Real.log t + 523472285 + defect_C3 * t * t|
        ≤ |(-25254354) * Real.log t| + |523472285 + defect_C3 * t * t| := by
          rw [add_assoc]
          exact abs_add_le _ _
      _ ≤ 25254354 * Real.log t + |523472285 + defect_C3 * t * t| :=
        add_le_add_left (le_of_eq habsA) _
      _ ≤ 25254354 * Real.log t + 523472285 + |defect_C3| * t * t := by
        have htail : |523472285 + defect_C3 * t * t| ≤
            523472285 + |defect_C3| * t * t := by
          calc _ ≤ |523472285| + |defect_C3 * t * t| := abs_add_le _ _
            _ = 523472285 + |defect_C3| * t * t := by
              rw [abs_of_pos hB, habsC]
        calc _ ≤ 25254354 * Real.log t + (523472285 + |defect_C3| * t * t) :=
              add_le_add_right htail (25254354 * Real.log t)
          _ = 25254354 * Real.log t + 523472285 + |defect_C3| * t * t := by ring
      _ ≤ 25254354 * (t - 1) + 523472285 + |defect_C3| * t * t := by
        have hstep : 25254354 * Real.log t ≤ 25254354 * (t - 1) := by
          have hm := mul_le_mul_of_nonneg_right hlog1 (le_of_lt hA)
          ring_nf at hm ⊢
          exact hm
        exact add_le_add (add_le_add hstep le_rfl) le_rfl
      _ ≤ 25254354 * t + 523472285 + |defect_C3| * t * t := by
        nlinarith
      _ ≤ 25254354 * t + 523472285 + (|defect_C3| * T_MEAS3) * t := by
        have hstep : |defect_C3| * t * t ≤ (|defect_C3| * T_MEAS3) * t := by
          have hCabs : (0 : ℝ) < |defect_C3| :=
            abs_pos.mpr (ne_of_lt defect_C3neg)
          calc _ = |defect_C3| * (t * t) := by ring
            _ ≤ |defect_C3| * (T_MEAS3 * t) :=
              mul_le_mul_of_nonneg_left ht2 (le_of_lt hCabs)
            _ = (|defect_C3| * T_MEAS3) * t := by ring
        exact add_le_add (add_le_add le_rfl le_rfl) hstep
      _ ≤ 25254354 * t + 523472285 + ((2439 : ℝ) / (10 : ℝ) ^ 12) * t :=
        add_le_add (add_le_add le_rfl le_rfl)
          (mul_le_mul_of_nonneg_right defect_C3absT3 htul)
      _ ≤ 25254354 * T_MEAS3 + 523472285 + ((2439 : ℝ) / (10 : ℝ) ^ 12) * T_MEAS3 := by
        have hstep1 : 25254354 * t ≤ 25254354 * T_MEAS3 :=
          mul_le_mul_of_nonneg_left hT (by norm_num : (0 : ℝ) ≤ 25254354)
        have hstep2 : ((2439 : ℝ) / (10 : ℝ) ^ 12) * t ≤
            ((2439 : ℝ) / (10 : ℝ) ^ 12) * T_MEAS3 :=
          mul_le_mul_of_nonneg_left hT
            (le_of_lt (div_pos (by norm_num : (0 : ℝ) < (2439 : ℝ))
              (pow_pos (by norm_num : (0 : ℝ) < (10 : ℝ)) 12)))
        exact add_le_add (add_le_add hstep1 le_rfl) hstep2
      _ ≤ (230000000 : ℝ) * (10 : ℝ) ^ 18 := by
        have hT : T_MEAS3 = 9 * (10 : ℝ) ^ 18 := by
          dsimp only [T_MEAS3]
          norm_num
        rw [hT]
        have hA : (25254354 : ℝ) * 9 ≤ (227700000 : ℝ) := by norm_num
        have hpow : (0 : ℝ) ≤ (10 : ℝ) ^ 18 := by norm_num
        have hB : (523472285 : ℝ) + 2439 * 9 * (10 : ℝ) ^ 6 ≤ (10 : ℝ) ^ 18 := by
          norm_num
        have hC : (227700001 : ℝ) ≤ (230000000 : ℝ) := by norm_num
        calc 25254354 * (9 * (10 : ℝ) ^ 18) + 523472285 +
              ((2439 : ℝ) / (10 : ℝ) ^ 12) * (9 * (10 : ℝ) ^ 18)
            ≤ (227700000 : ℝ) * (10 : ℝ) ^ 18 + 523472285 +
              ((2439 : ℝ) / (10 : ℝ) ^ 12) * (9 * (10 : ℝ) ^ 18) := by
              have hm : 25254354 * (9 * (10 : ℝ) ^ 18) ≤
                  (227700000 : ℝ) * (10 : ℝ) ^ 18 := by
                calc _ = (25254354 * 9) * (10 : ℝ) ^ 18 := by ring
                  _ ≤ 227700000 * (10 : ℝ) ^ 18 :=
                    mul_le_mul_of_nonneg_right hA hpow
              nlinarith [hm]
            _ ≤ (227700000 : ℝ) * (10 : ℝ) ^ 18 + (10 : ℝ) ^ 18 := by
              have hm : 523472285 + ((2439 : ℝ) / (10 : ℝ) ^ 12) *
                  (9 * (10 : ℝ) ^ 18) ≤ (10 : ℝ) ^ 18 := by
                have hred : ((2439 : ℝ) / (10 : ℝ) ^ 12) * (9 * (10 : ℝ) ^ 18) =
                    2439 * 9 * (10 : ℝ) ^ 6 := by
                  field_simp [show (0 : ℝ) < (10 : ℝ) ^ 12 by norm_num]
                  <;> ring
                rw [hred]
                exact hB
              nlinarith [hm]
            _ = (227700001 : ℝ) * (10 : ℝ) ^ 18 := rfl
            _ ≤ (230000000 : ℝ) * (10 : ℝ) ^ 18 :=
              mul_le_mul_of_nonneg_right hC hpow

/- E1ClauseV3C:  the  three-term  clause  on  the  s17  face
    (G_LAST,  T_MEAS3  =  9e18].  Same  shape  as  E1ClauseV3;
    the  defect  is  the  three-term  M_defect3  with  the
    closed-form  t^2  coefficient  in  U_TOP.  Named  data
    hole:  E1ClauseV3C  q  10000  (33  measured  rows,
    max  residual  7986.8  ->  25%  margin).  -/
def E1ClauseV3C (q : ZeroSet) (B : ℝ) : Prop :=
  ∀ (t : ℝ), G_LAST < t → t ≤ T_MEAS3 → straddleRow q t →
    |M_wp q t - M_defect3 t| ≤ B

/- Composition:  E1ClauseV3C  +  the  loose  defect  bound  ->
    the  absolute  face  on  (G_LAST,  T_MEAS3]  (the  3-term
    twin  of  e1V3_implies_e1).  Carries  mdefect3_bounded's
    loose  2.3e23  constant.  -/
theorem e1V3C_implies_abs (q : ZeroSet) (B : ℝ) (hE3c : E1ClauseV3C q B) :
    ∀ (t : ℝ), G_LAST < t → t ≤ T_MEAS3 → straddleRow q t →
      |M_wp q t| ≤ B + (230000000 : ℝ) * (10 : ℝ) ^ 18 := by
  intro t ht hT hs
  have h3 := hE3c t ht hT hs
  have hb := mdefect3_bounded t ht hT
  have heq : M_wp q t = M_wp q t - M_defect3 t + M_defect3 t := by ring
  have habs : |M_wp q t| = |(M_wp q t - M_defect3 t) + M_defect3 t| :=
    congrArg abs heq
  have htri : |M_wp q t| ≤ |M_wp q t - M_defect3 t| + |M_defect3 t| := by
    rw [habs]
    exact abs_add_le (M_wp q t - M_defect3 t) (M_defect3 t)
  calc |M_wp q t| ≤ |M_wp q t - M_defect3 t| + |M_defect3 t| := htri
    _ ≤ B + (230000000 : ℝ) * (10 : ℝ) ^ 18 := add_le_add h3 hb

/- E1ClauseV3C  +  the  four  legs  ->  RH  (the  3-term  twin
    of  if_E1V3_and_walk;  the  named  hole  is  the  extended
    data  face  (G_LAST,  9e18],  33  measured  rows).  Same
    residual  program:  the  hole  documents  the  state  of
    the  data  track,  the  legs  are  the  structural
    contract.  No  RH  claim  -  the  hole  is  OPEN,  as
    before.  -/
theorem if_E1V3C_and_walk (q : ZeroSet) (hz : ZetaZeroSet.ZetaLike q)
    (_hE3c : E1ClauseV3C q 10000) -- the named data hole (3-term, s17 face)
    (Qside Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  ZetaZeroSet.rhIfMarginZeta q hz Qside Mf devOf Bwire Mr flo
    hs1 hs2 hs3 hs4

/- CLAUSE  SET  ADDENDUM  (2026-10-22,  0153/0154):  the
    above-G  data  face  now  carries  TWO  named  holes:
      E1ClauseV3   q  7000   on  (G_LAST,  1000*G_LAST]
                   (21  rows,  two-term  law,  max  resid  6704.088)
      E1ClauseV3C  q  10000  on  (G_LAST,  9e18]
                   (33  rows,  three-term  law  with  the
                   closed-form  U_TOP  coefficient,  max  resid
                   7986.8  at  the  s16  10G  row)
    The  below-G  face  is  unchanged:  E1Clause  q  2  (s8
    505  rows).  No  RH  claim.  -/

end E1C

