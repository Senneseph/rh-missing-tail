import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu
import RhAttack.Z78Track
import RhAttack.Z78Gao
import RhAttack.Z78Collet
import RhAttack.Z78Sil32
import RhAttack.Z78FineChain
import RhAttack.Z78DensityRefined
import RhAttack.Z78ArviDensity
import RhAttack.Z78PosReserve
import RhAttack.Z78GapContact
import RhAttack.Z78FractionContact

open Real Set Complex

set_option linter.style.longLine false

-- the 127/128-digit exact rational cannot be split across lines (Lean
-- numerals are atomic); same latent-lint carry as the B23/B24 twins.
set_option linter.unnecessarySimpa false

/-
[Z78ContinuumAnchor]  (PR  #141  tracker  record  `continuum-anchor`,
Joseph  Bebel;  internal  module  naming  `Candidate.Local.Qrh.TwoSlot`,
same  source  family  as  the  TENTH,  extending  Sil's  PR137  marked-
anchor  induction.)

PROVENANCE  (B6  section  8  adoption  protocol  -  the  ELEVENTH
supersession  the  chain  has  absorbed,  after  0133 / 0142 / 0162 /
0195  /  0200  /  0203  /  0211  /  the  EIGHTH  (0235)  /  the  NINTH
(0254)  /  the  TENTH  (0256);  see  Z78FractionContact,  Z78GapContact
and  Z78PosReserve  for  the  template):
*  CATALOGUE  (a  pointer  -  pointers  are  NOT  provenance):  tracker
  catalogue  JSON  pull  2026-11-24T~07:40Z  (56  records;  the  B6
  fire-time  sweep)  carries  this  record  MERGED  2026-11-13T08:28:53Z
  (merge  commit  a0a0212652c3e97c36c917ee7b671e6c27a6d0fc)  at  the  exact  boundary
  9908119238306612133369374975000622988619121777878229799765263366946606045502455625911569003364955967645745531862430068266267717/11345012023616779600791582323373494582287250283647959965785871011074347975117040113347744503437234376916434871293982689424818700
  (=  0.87334585610671857680118...)  -  the  current  BOARD  BEST
  (smallest  theta  on  the  board;  the  companion  record
  continuum-exact-contact  carries  the  same  ranked  fraction  and  an
  exact  degree-nine  root  contact  below  it,  merged  2026-11-15;
  third  is  marked-anchor-induction  at  2183367/2500000
  =  0.8733468).  PR  #141,  Joseph  Bebel,  title  "Dirichlet
  nonvanishing  at  0.8733458561067185768  via  continuum  marked
  anchors".  The  boundary  is  the  upper  Farey  neighbour  (256-char
  declaration  limit)  of  the  degree-nine  continuum  contact.
*  PROVENANCE  FETCH  +  IDENTITY:  the  submission  source  was  fetched
  at  the  merge  commit  a0a0212652c3e97c36c917ee7b671e6c27a6d0fc  (repo
  GTimG/QuasiRiemannTracker;  633  files  in  the  submission  tree
  submissions/2026-11-13-continuum-anchor;  clone  at
  tmp/b6audit/prestage141/qr).  The  canonical  entry  (`Candidate.bound`
  in  src/Candidate/Main.lean)  states  the  all-moduli  Dirichlet
  nonvanishing  boundary  at  the  EXACT  rational  9908119238306612.../
  1134501202361677...  (127/128-digit  numerator/denominator,  coprime),  re-verified
  verbatim  at  the  merge  checkout  at  fire  time.
*  BUILD  CONE:  631  own  proof-cone  modules  (self-contained  -  the
  PR  vendoes  its  refined  source  in-tree;  no  cross-imports  of
  any  predecessor  submission  tree).  External  imports  resolve
  against  the  five  EIGHTH-cone  lineages  (Submissions.openai_baseline,
  Submissions.hailey_collet_1252270103,
  Submissions.sil_density_split_20261026,
  Submissions.arvi_repeated_marks_on_sil_face_20261025,
  Submissions.arvi_selected_leaf)  +  Mathlib  deps  -  all  present  in
  the  TEN  merged  olean  root.  The  merge  is  purely  additive  (all
  633  files  added  vs  the  pre-merge  base  26ac5e1d).
*  STATIC  GATES  (2026-11-24,  merge  commit):  0  `sorry`  /  0  `admit`
  /  0  `axiom`  declarations  /  0  `native_decide`  across  the  whole
  submission  src  tree  (633  files).
*  ZETA  SCOPE:  2  files  mention  zeta:  2  INTENDED  zeta-consequence
  statements  (zeta_of_literal_numerator  in
  Library/PositiveGap/Return/EndpointFromNumerator,
  zeta_of_global_sources  in
  Library/PositiveGap/Return/Tuning/EndpointFromSources  -  the
  Stage-D3  class,  mirroring  the  NINTH/TENTH).  Stage  D3  re-probes
  the  zeta  consequence  at  the  exact  rational.
*  REPLAY  (this  program,  independent  second-party,  fire-time
  2026-11-24):
  -  Stage  C:  independent  per-module  kernel  compilation  of  the
    631  own  proof-cone  modules  (single  merged  olean  root  at
    firetime/work141  =  hard-link  copy  of  the  TENTH  root,  lean
    4.34.1,  gao5_replay  deps):  631/631  kernel-clean.  (Record:
    tmp/b6audit/prestage141/firetime/  -  stageC141.log,
    logs_continuum-anchor/  per-module  logs.)
  -  Stage  D:  D1  the  canonical  entry  `Candidate/Main.lean`
    compiled  from  the  merge  sources  against  the  fire-time  root;
    D2  axiom  audit  (#print  axioms):  `Candidate.bound`  =
    [propext,  Classical.choice,  Quot.sound]  -  standard  class  only;
    D3  zeta-consequence  (q=1)  at  the  exact  rational;
    D4  static  sweep  at  the  merge  commit  (0/0/0/0  above).
    (Record:  tmp/b6audit/prestage141/firetime/stageD/.)
*  STATUS  IN  THIS  PROGRAM:  a  NAMED  EXTERNAL  INPUT  of  the  same
  class  as  [Z78]  /  [Z78L]  /  [Z78T]  /  [Z78G]  /  [Z78C]  /
  [Z78SIL32]  /  [Z78FineChain]  /  [Z78DensityRefined]  /
  [Z78ArviDensity]  /  [Z78PosReserve]  /  [Z78GapContact]  /
  [Z78FractionContact]  -  a  kernel-verified  external  theorem,
  entered  only  as  a  hypothesis.  The  boundary  is  the  exact
  rational  itself  (the  record's  Lean  statement  works  at  the
  rational  -  no  bracketing).
*  SNAPSHOT  CAVEAT:  the  tracker  board  is  a  moving  frontier;  a
  newer  verified  snapshot  supersedes  this  part  mechanically  (B6
  packet  section  8).  No  RH  claim  anywhere:  this  is  a  zero-free
  half-plane,  still  continuumAnchorD0max  =  T  -  1/2  =
  0.3733458561067185768...  away  from  the  critical  line  in
  off-line  distance.  Still  far  from  1/2.
-/

namespace Z78ContinuumAnchor

/--  The  certified  rational  boundary:  the  tracker  record
    `continuum-anchor`  proves  its  all-Dirichlet  statement  at
    exactly  `9908119238306612133369374975000622988619121777878229799765263366946606045502455625911569003364955967645745531862430068266267717/11345012023616779600791582323373494582287250283647959965785871011074347975117040113347744503437234376916434871293982689424818700`
    (=  0.87334585610671857680118...).  The  upper  Farey  neighbour
    (256-character  declaration  limit)  of  the  degree-nine
    continuum  contact.  -/
noncomputable def continuumAnchorUpper : ℝ :=
    (↑9908119238306612133369374975000622988619121777878229799765263366946606045502455625911569003364955967645745531862430068266267717 : ℝ) / (↑11345012023616779600791582323373494582287250283647959965785871011074347975117040113347744503437234376916434871293982689424818700 : ℝ)

/--  The  off-line  distance  bound  it  yields:  an  off-pair  zero
    sits  in  `[1  -  continuumAnchorUpper,  continuumAnchorUpper]  x  C`
    (functional  equation),  hence  `d0  =  |Re  -  1/2|  <=
    continuumAnchorUpper  -  1/2`.  Exact  value:
    0.3733458561067185768...  <  fractionContactD0max  <
    gapContactD0max  <  sil32D0max  <  colletD0max  <  gaoD0max  <
    qxD0max  <  3/8.  -/
noncomputable def continuumAnchorD0max : ℝ := continuumAnchorUpper - 1 / 2

/--  The  boundary  is  strictly  below  the  [Z78FractionContact]
    boundary  (norm_num  certificate  on  the  127/128-digit  exact
    rational  vs  the  TENTH  127/127-digit  rational):  this  is  what
    makes  [Z78ContinuumAnchor]  a  strict  strengthening  of
    [Z78FractionContact]  -  and  transitively  of  every  predecessor.  -/
theorem continuumAnchorUpper_lt_fractionContact :
    continuumAnchorUpper < Z78FractionContact.fractionContactUpper := by
  dsimp only [continuumAnchorUpper, Z78FractionContact.fractionContactUpper]
  norm_num

/--  The  off-pair  bound  is  strictly  below  the
    [Z78FractionContact]  off-pair  bound  (no  numeric  work:
    subtraction  is  monotone).  -/
theorem continuumAnchorD0max_lt_fractionContactD0max :
    continuumAnchorD0max < Z78FractionContact.fractionContactD0max := by
  dsimp only [continuumAnchorD0max, Z78FractionContact.fractionContactD0max]
  exact sub_lt_sub_right continuumAnchorUpper_lt_fractionContact (1 / 2)

/--  The  off-pair  bound  is  strictly  below  the  [Z78PosReserve]
    off-pair  bound  (transitivity  through  [Z78FractionContact]).  -/
theorem continuumAnchorD0max_lt_posReserveD0max :
    continuumAnchorD0max < Z78PosReserve.posReserveD0max :=
  lt_trans continuumAnchorD0max_lt_fractionContactD0max
    Z78FractionContact.fractionContactD0max_lt_posReserveD0max

/--  The  off-pair  bound  is  strictly  below  3/8  (all  predecessors
    by  transitivity):  the  open  face  genuinely  shrinks.  -/
theorem continuumAnchorD0max_lt_38 : continuumAnchorD0max < 3 / 8 :=
  lt_trans continuumAnchorD0max_lt_posReserveD0max
    Z78PosReserve.posReserveD0max_lt_38

/--  The  [Z78ContinuumAnchor]  named  external  input  (kernel-verified;
    see  header  for  provenance  and  status).  The  Riemann  zeta
    function  (Mathlib's  `riemannZeta`)  is  zero-free  in  the
    half-plane  `Re  s  >  continuumAnchorUpper`;  the  principal-pole
    guard  `s  !=  1`  is  the  [Z78Liu]  consequence-form  guard  (inert
    on  the  pinned  Mathlib,  where  `riemannZeta_one_ne_zero`).  -/
def externalZeroFree78ContinuumAnchor : Prop :=
  forall (s : ℂ), continuumAnchorUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS
    [Z78FractionContact]:  zero-free  on  `Re  s  >  continuumAnchorUpper`
    (with  `continuumAnchorUpper  <  fractionContactUpper`)  implies
    zero-free  on  `Re  s  >  fractionContactUpper`.  The  pole  guard  is
    carried  through  verbatim.  -/
theorem extContinuumAnchor_implies_extFractionContact
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78FractionContact.externalZeroFree78FractionContact := by
  intro s hs hguard
  exact hz s (lt_trans continuumAnchorUpper_lt_fractionContact hs) hguard

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS  [Z78C]
    (transitivity  through  [Z78FractionContact]  and  the  EIGHTH
    chain).  -/
theorem extContinuumAnchor_implies_extCollet
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78Collet.externalZeroFree78Collet :=
  Z78FractionContact.extFractionContact_implies_extCollet
    (extContinuumAnchor_implies_extFractionContact hz)

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS  [Z78G]
    (transitivity  through  [Z78FractionContact]  and  the  EIGHTH
    chain).  -/
theorem extContinuumAnchor_implies_extGao
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78Gao.externalZeroFree78Gao :=
  Z78FractionContact.extFractionContact_implies_extGao
    (extContinuumAnchor_implies_extFractionContact hz)

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS  [Z78T]
    (transitivity  through  [Z78FractionContact]  and  the  EIGHTH
    chain).  -/
theorem extContinuumAnchor_implies_extTrack
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78Track.externalZeroFree78Track :=
  Z78FractionContact.extFractionContact_implies_extTrack
    (extContinuumAnchor_implies_extFractionContact hz)

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS  [Z78L]
    (transitivity  through  [Z78FractionContact]  and  the  EIGHTH
    chain).  -/
theorem extContinuumAnchor_implies_extLiu
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78Liu.externalZeroFree78Liu :=
  Z78FractionContact.extFractionContact_implies_extLiu
    (extContinuumAnchor_implies_extFractionContact hz)

/--  (PROVEN)  [Z78ContinuumAnchor]  STRICTLY  STRENGTHENS  [Z78]
    (transitivity  through  [Z78FractionContact]  and  all  intermediate
    records).  -/
theorem extContinuumAnchor_implies_ext78
    (hz : externalZeroFree78ContinuumAnchor) :
    Z78.externalZeroFree78 :=
  Z78FractionContact.extFractionContact_implies_ext78
    (extContinuumAnchor_implies_extFractionContact hz)

/--  (PROVEN)  Every  non-real  zero  of  the  zeta  function  lies
    in  the  strip  `1  -  continuumAnchorUpper  <=  Re  <=
    continuumAnchorUpper`  under  [Z78ContinuumAnchor].  Identical
    argument  to  `Z78Gao.zetaZeroStripGao`  with  the  sharper
    boundary  ([Z78ContinuumAnchor]).  -/
theorem zetaZeroStripContinuumAnchor (hz : externalZeroFree78ContinuumAnchor) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - continuumAnchorUpper ≤ ρ.re ∧ ρ.re ≤ continuumAnchorUpper := by
  have h1neρ : (1 : ℂ) - ρ ≠ 1 := by
    intro h
    have hρ0 : ρ = 0 := by
      have := congr_arg (· + ρ) h
      rw [sub_add_cancel] at this
      have := congr_arg (· - (1 : ℂ)) this
      ring_nf at this
      exact this.symm
    exact hρim (by rw [hρ0]; exact zero_im)
  have hρne1 : ρ ≠ 1 := by
    intro heq
    exact hρim (by rw [heq]; norm_num)
  have hneNm : ∀ n : ℕ, (1 : ℂ) - ρ ≠ -n := by
    intro n hn
    have := congr_arg (· + ρ) hn
    rw [sub_add_cancel] at this
    have h1 : ρ = (1 : ℂ) + (n : ℂ) := by
      have := congr_arg (· + (n : ℂ)) this
      ring_nf at this
      exact this.symm
    have h0 : ρ.im = 0 := by
      rw [h1, add_im, one_im]
      have h2 : ((n : ℕ) : ℂ) = (((n : ℕ) : ℝ) : ℂ) := rfl
      rw [h2, ofReal_im]
      simp
    exact hρim h0
  have hfe : riemannZeta ρ =
      2 * (2 * π) ^ (-(1 - ρ)) * Gamma (1 - ρ) *
      cos ((π : ℂ) * (1 - ρ) / 2) * riemannZeta (1 - ρ) := by
    have hL : (1 : ℂ) - (1 - ρ) = ρ := by ring
    simpa [hL] using riemannZeta_one_sub hneNm h1neρ
  have hc2p : (2 * π : ℂ) ≠ 0 := by
    intro h
    rw [mul_eq_zero] at h
    rcases h with h2 | hπ
    · have h2n : (2 : ℂ) ≠ 0 := by
        intro h2b
        have h2re : (2 : ℂ).re = (2 : ℝ) := by norm_num
        have := congr_arg Complex.re h2b
        rw [h2re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        exact (by norm_num : (2 : ℝ) ≠ 0) this
      exact h2n h2
    · have hπn : (π : ℂ) ≠ 0 := by
        intro hπb
        have := congr_arg Complex.re hπb
        rw [ofReal_re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        nlinarith [Real.pi_pos]
      exact hπn hπ
  have hexp : (2 * π : ℂ) ^ (-(1 - ρ)) ≠ 0 :=
    cpow_ne_zero_iff.mpr (Or.inl hc2p)
  have hgm : Gamma (1 - ρ) ≠ 0 :=
    Gamma_ne_zero hneNm
  have hcos : cos ((π : ℂ) * (1 - ρ) / 2) ≠ 0 := by
    intro h
    obtain ⟨k, hk⟩ := (Complex.cos_eq_zero_iff).1 h
    field_simp [show (π : ℂ) ≠ 0 from by
      intro h; simp only [Complex.ext_iff] at h; exact (Real.pi_pos).ne' h.1] at hk
    have hρ' : ρ = -(2 * ↑k : ℂ) := by
      have := congr_arg (· - (1 : ℂ)) hk
      ring_nf at this
      rw [← neg_inj, neg_neg]
      rw [mul_comm] at this
      exact this
    have h0 : ρ.im = 0 := by
      rw [hρ', neg_im]
      have h1r : ((2 * k : ℤ) : ℝ) = 2 * (k : ℝ) := by norm_num
      have h2 : ((↑(2 * k : ℤ)) : ℂ) = (↑(2 * k : ℝ) : ℂ) := by exact_mod_cast h1r
      simpa [h2] using (ofReal_im (2 * (k : ℝ)))
    exact hρim h0
  have h1rho0 : riemannZeta (1 - ρ) = 0 := by
    by_contra hnz
    have hzρ : riemannZeta ρ ≠ 0 := by
      rw [hfe]
      refine mul_ne_zero ?_ hnz
      refine mul_ne_zero ?_ hcos
      refine mul_ne_zero ?_ hgm
      exact mul_ne_zero (by norm_num : (2 : ℂ) ≠ 0) hexp
    exact hzρ hρ
  have hlo : 1 - continuumAnchorUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - continuumAnchorUpper := not_le.mp h
    have hc : continuumAnchorUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ continuumAnchorUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩


/--  (PROVEN,  glue)  The  instantiating  step  for  an  abstract
    zero  set,  under  [Z78ContinuumAnchor]:  if  every  element  of
    `q.Z`  is  an  actual  zero  of  Mathlib's  zeta  (the  classical
    instantiation  the  B-0  header  leaves  to  citation),  then
    every  off-line  pair  (t0,  d0)  of  `q`  has  off-line
    distance  `d0  <=  continuumAnchorD0max`  -  the  sharp
    [Z78ContinuumAnchor]  value.  In  particular  `d0  <  3/8  <  1/2`,
    so  the  far  region  (d0  >  1/2)  stays  empty  for  any
    actual-set  zero  set  under  [Z78ContinuumAnchor].  -/
theorem offPairD0leContinuumAnchor (q : ZeroSet) (hz : externalZeroFree78ContinuumAnchor)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (_ht0 : 0 < t0) (_hd0 : 0 < d0)
    (hp : P12.offPair q t0 d0) :
    d0 ≤ continuumAnchorD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripContinuumAnchor hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ continuumAnchorD0max := by
    rw [abs_le]
    constructor
    · dsimp only [continuumAnchorD0max]
      nlinarith [hstrip.2]
    · dsimp only [continuumAnchorD0max]
      nlinarith [hstrip.1]
  exact hle



/--  Data  gates  (Float  world;  the  Real  forms  carry  the  theorems
    above).  Computed  from  the  certified  constants:
    `1  -  continuumAnchorUpper  =  0.12665414389328142`,
    `continuumAnchorD0max  =  continuumAnchorUpper  -  1/2  =
    0.37334585610671855`  (Float  rounding  of  the  exact  127-digit
    rational).  -/
def zeroFreeThetaContinuumAnchor : Float := 0.8733458561067186
def stripLoContinuumAnchor : Float := 0.12665414389328142
def offPairD0MaxContinuumAnchor : Float := 0.37334585610671855
#eval zeroFreeThetaContinuumAnchor
#eval stripLoContinuumAnchor
#eval offPairD0MaxContinuumAnchor

end Z78ContinuumAnchor
