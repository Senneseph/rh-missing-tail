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

open Real Set Complex

set_option linter.style.longLine false

-- the 127/127-digit exact rational cannot be split across lines (Lean
-- numerals are atomic) and `simpa [h2]` matches the B23 twin body
-- byte-for-byte (the identical line in Z78GapContact.lean carries the
-- same latent lint; it was never re-linted after the cached build).
set_option linter.unnecessarySimpa false

/-
[Z78FractionContact]  (PR #103 tracker record
`closest-fraction-contact`,  Joseph  Bebel;  internal  module  naming
`PR98Improvement`,  same  source  family  as  the  NINTH.)

PROVENANCE  (B6  section  8  adoption  protocol  -  the  TENTH
supersession  the  chain  has  absorbed,  after  0133 / 0142 / 0162 /
0195 / 0200 / 0203 / 0211 / the EIGHTH (0235) / the NINTH (0254);  see
Z78GapContact  and  Z78PosReserve  for  the  template):
* CATALOGUE  (a  pointer  -  pointers  are  NOT  provenance):  tracker
  catalogue  JSON  pull  2026-11-01T~12:30Z  (49  records;  snapshot
  firetime/catalogue snapshot + tmp/b6audit/tracker/watcher_0212.log)
  carries  this  record  MERGED  2026-11-01T12:23:55Z  (merge  commit
  8b1a0167c8e324099884152181e3fb2206510e88)  at  the  exact  boundary
  2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271
  (=  0.8733819666132075199...)  -  the  current  BOARD  BEST  (smallest
  theta  on  the  board;  second  is  saddle-closure-selected-gap at
  T  +  9.732e-22),  status  framework-verified,  first  verified
  2026-11-01T12:xxZ  (fire-time  state  check),  PR  #103,  Joseph
  Bebel,  title  "all-moduli  Dirichlet  nonvanishing  at  the  closest
  declarable  fraction  to  the  method-limiting  contact".  The
  boundary  is  the  closest  declarable  (machine)  fraction  above  the
  method-limiting  zero-free  contact  (777  -  sqrt  1081) / 852  -
  about  2.16e-254  above  it.
* PROVENANCE  FETCH  +  IDENTITY:  the  submission  source  was  fetched
  at  the  merge  commit  8b1a0167c8e324099884152181e3fb2206510e88  (repo
  GTimG/QuasiRiemannTracker;  238  files  in  the  submission  tree
  submissions/2026-11-01-closest-fraction-contact;  clone  at
  tmp/b6audit/prestage103/qr).  The  canonical  entry  (`Candidate.bound`
  in  src/Candidate/Main.lean;  canonical  theorem  `Qrh.PositiveGap.bound`
  in  src/Candidate/Local/Qrh/PositiveGap/BestEndpoint.lean)  states  the
  all-moduli  Dirichlet  nonvanishing  boundary  at  the  EXACT  rational
  280496628401749035803096.../321161460992211983469417...
  (127/127-digit  numerator/denominator,  coprime);  its  statement  text
  was  identity-checked  pre-stage  (head  cae2e523d4ec22c05ea91ff44d68efb8fd02293f,
  IDEM-PRESTAGE-103.md)  AND  re-verified  at  the  merge  commit  at
  fire  time  (the  exact  127-digit  numerator  appears  verbatim  in
  Main.lean  at  the  merge  checkout).
* BUILD  CONE:  the  proof  cone  is  the  NINTH's  cone  refined  -  the
  same  four  direct  Submissions  prefixes  (Submissions.openai_baseline,
  Submissions.hailey_collet_1252270103,
  Submissions.arvi_repeated_marks_on_sil_face,
  Submissions.arvi_selected_leaf)  plus  transitive  trees;  at  the  merge
  commit  ALL  seven  predecessor  prefix  trees  are  BYTE-IDENTICAL  to
  the  frozen  replay  copies  (five  against  the  frozen  EIGHTH
  checkout  z78s39;  positive-reserve  and  the  NINTH  tree  against
  their  own  frozen  merged  copies;  selected-leaf-refined  against
  the  merged-NINTH  tree)  -  the  merge  is  purely  additive  on  top  of
  the  NINTH  merge  (8b1a0167c  <-  069f1749  <-
  d4fba59d).
* STATIC  GATES  (2026-11-01,  merge  commit):  0  `sorry`  /  0  `admit`
  /  0  `axiom`  declarations  /  0  `native_decide`  across  the  whole
  submission  src  tree  (238  files).
* ZETA  SCOPE:  3  files  mention  zeta  case-insensitively:  2  INTENDED
  zeta-consequence  statements  (zeta_of_literal_numerator  in
  Return/EndpointFromNumerator,  zeta_of_global_sources  in
  Return/Tuning/EndpointFromSources  -  the  Stage-D3  class,  mirroring
  the  NINTH)  +  1  `RootZeta`  helper  use  in  PR98Improvement/GapAdapters
  (a  proof-side  root-number  helper,  not  a  zeta-evaluation
  bypass);  Stage  D3  re-probes  the  zeta  consequence  at  the  exact
  rational.
* REPLAY  (this  program,  independent  second-party,  fire-time):
  - Stage  C:  independent  per-module  kernel  compilation  of  the
    236  own  proof-cone  modules  (single  merged  olean  root  at
    firetime/work103  =  hard-link  copy  of  the  NINTH  frozen  root,
    lean  4.34.1,  gao5_replay  deps).  Identity  audit  vs  the  NINTH
    src:  202  byte-identical  /  33  differs  /  1  new
    (Return.Tuning.ContactQ);  vs  the  EIGHTH  src:  44  further
    differs  -  so  the  D1  union  D2  rebuild  set  (77  modules)  was
    recompiled  fresh  from  the  #103  sources  (driver  runs  plus  two
    tip  modules  compiled  individually:  Return.Tuning.Endpoint  and
    BestEndpoint;  three  earlier  transient  stale-dependency  events
    cleared  on  re-run  -  every  per-module  log  ends  rc=0):
    236/236  kernel-clean.  (Record:  tmp/b6audit/prestage103/firetime/
    -  stageC103*.log,  stageC_summary.json,  cone_identity_vs_nine.json,
    todo_D1uD2.json,  seq34.log,  seq34_logs/,  logs_closest-fraction-contact/
    per-module  logs.)
  - Stage  D:  D1  the  canonical  entry  `Candidate/Main.lean`  compiled
    from  the  merge  sources  against  the  fire-time  root:  rc=0;
    D2  axiom  audit  (#print  axioms,  fire-time):  `Candidate.bound`,
    `Qrh.PositiveGap.bound`,  `Qrh.PositiveGap.beta_le_theta`  all  =
    [propext,  Classical.choice,  Quot.sound]  -  standard  class  only;
    D3  zeta-consequence  (q=1)  at  the  exact  rational:  rc=0;
    D4  static  sweep  at  the  merge  commit:  0  sorry  /  0  admit  /
    0  axiom  decls  /  0  native_decide  /  3  zeta-mention  files  in
    the  238-file  tree  (the  set  above).  (Record:
    tmp/b6audit/prestage103/firetime/stageD/  -  axiomprobe_b24.lean,
    zeta_probe_b24.lean;  /tmp/b24_d1.log  D1.)
* STATUS  IN  THIS  PROGRAM:  a  NAMED  EXTERNAL  INPUT  of  the  same
  class  as  [Z78]  /  [Z78L]  /  [Z78T]  /  [Z78G]  /  [Z78C]  /
  [Z78SIL32]  /  [Z78FineChain]  /  [Z78DensityRefined]  /
  [Z78ArviDensity]  /  [Z78PosReserve]  /  [Z78GapContact]  -  a
  kernel-verified  external  theorem,  entered  only  as  a  hypothesis.
  The  boundary  is  the  exact  rational  itself  (the  record's  Lean
  statement  works  at  the  rational  -  no  bracketing).
* SNAPSHOT  CAVEAT:  the  tracker  board  is  a  moving  frontier;  a
  newer  verified  snapshot  supersedes  this  part  mechanically  (B6
  packet  section  8).  No  RH  claim  anywhere:  this  is  a  zero-free
  half-plane,  still  fractionContactD0max  =  T  -  1/2  =
  0.373381966613207519...  away  from  the  critical  line  in  off-line
  distance.  Still  far  from  1/2.
-/

namespace Z78FractionContact

/-- The  certified  rational  boundary:  the  tracker  record
    `closest-fraction-contact`  proves  its  all-Dirichlet  statement  at
    exactly  `2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341/3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271`
    (=  0.8733819666132075199...).  The  closest  declarable  fraction
    above  the  method-limiting  contact  (777  -  sqrt  1081) / 852. -/
noncomputable def fractionContactUpper : ℝ :=
    (↑2804966284017490358030969257914123810640482798488248385236764587735806455694206308975383836842958115341512355256943573632654341 : ℝ) / (↑3211614609922119834694179379888743028634953588197852962423516288191911449231164741438582626063161096341458934143644085157872271 : ℝ)

/-- The  off-line  distance  bound  it  yields:  an  off-pair  zero  sits
    in  `[1  -  fractionContactUpper,  fractionContactUpper]  x  C`
    (functional  equation),  hence  `d0  =  |Re  -  1/2|  <=
    fractionContactUpper  -  1/2`.  Exact  value:  0.373381966613207519...
    <  gapContactD0max  <  sil32D0max  <  colletD0max  <  gaoD0max  <
    qxD0max  <  3/8. -/
noncomputable def fractionContactD0max : ℝ := fractionContactUpper - 1 / 2

/-- The  boundary  is  strictly  below  the  [Z78GapContact]  boundary
    (norm_num  certificate  on  the  127/128-digit  exact  rational  vs
    the  NINTH  16-digit  rational):  this  is  what  makes
    [Z78FractionContact]  a  strict  strengthening  of
    [Z78GapContact]  -  and  transitively  of  every  predecessor. -/
theorem fractionContactUpper_lt_gapContact :
    fractionContactUpper < Z78GapContact.gapContactUpper := by
  dsimp only [fractionContactUpper, Z78GapContact.gapContactUpper]
  norm_num

/-- The  off-pair  bound  is  strictly  below  the  [Z78GapContact]
    off-pair  bound  (no  numeric  work:  subtraction  is  monotone). -/
theorem fractionContactD0max_lt_gapContactD0max :
    fractionContactD0max < Z78GapContact.gapContactD0max := by
  dsimp only [fractionContactD0max, Z78GapContact.gapContactD0max]
  exact sub_lt_sub_right fractionContactUpper_lt_gapContact (1 / 2)

/-- The  off-pair  bound  is  strictly  below  the  [Z78PosReserve]
    off-pair  bound  (transitivity  through  [Z78GapContact]). -/
theorem fractionContactD0max_lt_posReserveD0max :
    fractionContactD0max < Z78PosReserve.posReserveD0max :=
  lt_trans fractionContactD0max_lt_gapContactD0max
    Z78GapContact.gapContactD0max_lt_posReserveD0max

/-- The  off-pair  bound  is  strictly  below  3/8  (all  predecessors
    by  transitivity):  the  open  face  genuinely  shrinks. -/
theorem fractionContactD0max_lt_38 : fractionContactD0max < 3 / 8 :=
  lt_trans fractionContactD0max_lt_posReserveD0max
    Z78PosReserve.posReserveD0max_lt_38

/-- The  [Z78FractionContact]  named  external  input  (kernel-verified;
    see  header  for  provenance  and  status).  The  Riemann  zeta
    function  (Mathlib's  `riemannZeta`)  is  zero-free  in  the
    half-plane  `Re  s  >  fractionContactUpper`;  the  principal-pole
    guard  `s  !=  1`  is  the  [Z78Liu]  consequence-form  guard  (inert
    on  the  pinned  Mathlib,  where  `riemannZeta_one_ne_zero`). -/
def externalZeroFree78FractionContact : Prop :=
  forall (s : ℂ), fractionContactUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS
    [Z78GapContact]:  zero-free  on  `Re  s  >  fractionContactUpper`
    (with  `fractionContactUpper  <  gapContactUpper`)  implies
    zero-free  on  `Re  s  >  gapContactUpper`.  The  pole  guard  is
    carried  through  verbatim. -/
theorem extFractionContact_implies_extGapContact
    (hz : externalZeroFree78FractionContact) :
    Z78GapContact.externalZeroFree78GapContact := by
  intro s hs hguard
  exact hz s (lt_trans fractionContactUpper_lt_gapContact hs) hguard

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS  [Z78C]
    (transitivity  through  [Z78GapContact]  and  the  EIGHTH  chain). -/
theorem extFractionContact_implies_extCollet
    (hz : externalZeroFree78FractionContact) :
    Z78Collet.externalZeroFree78Collet :=
  Z78GapContact.extGapContact_implies_extCollet
    (extFractionContact_implies_extGapContact hz)

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS  [Z78G]
    (transitivity  through  [Z78GapContact]  and  the  EIGHTH  chain). -/
theorem extFractionContact_implies_extGao
    (hz : externalZeroFree78FractionContact) :
    Z78Gao.externalZeroFree78Gao :=
  Z78GapContact.extGapContact_implies_extGao
    (extFractionContact_implies_extGapContact hz)

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS  [Z78T]
    (transitivity  through  [Z78GapContact]  and  the  EIGHTH  chain). -/
theorem extFractionContact_implies_extTrack
    (hz : externalZeroFree78FractionContact) :
    Z78Track.externalZeroFree78Track :=
  Z78GapContact.extGapContact_implies_extTrack
    (extFractionContact_implies_extGapContact hz)

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS  [Z78L]
    (transitivity  through  [Z78GapContact]  and  the  EIGHTH  chain). -/
theorem extFractionContact_implies_extLiu
    (hz : externalZeroFree78FractionContact) :
    Z78Liu.externalZeroFree78Liu :=
  Z78GapContact.extGapContact_implies_extLiu
    (extFractionContact_implies_extGapContact hz)

/-- (PROVEN)  [Z78FractionContact]  STRICTLY  STRENGTHENS  [Z78]
    (transitivity  through  [Z78GapContact]  and  all  intermediate
    records). -/
theorem extFractionContact_implies_ext78
    (hz : externalZeroFree78FractionContact) :
    Z78.externalZeroFree78 :=
  Z78GapContact.extGapContact_implies_ext78
    (extFractionContact_implies_extGapContact hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - fractionContactUpper <= Re <= fractionContactUpper`
    under [Z78FractionContact].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78FractionContact]). -/
theorem zetaZeroStripFractionContact (hz : externalZeroFree78FractionContact) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - fractionContactUpper ≤ ρ.re ∧ ρ.re ≤ fractionContactUpper := by
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
  have hlo : 1 - fractionContactUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - fractionContactUpper := not_le.mp h
    have hc : fractionContactUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ fractionContactUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78GapContact]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= fractionContactD0max` — the sharp
    [Z78GapContact] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78GapContact]. -/
theorem offPairD0leFractionContact (q : ZeroSet) (hz : externalZeroFree78FractionContact)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (_ht0 : 0 < t0) (_hd0 : 0 < d0)
    (hp : P12.offPair q t0 d0) :
    d0 ≤ fractionContactD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripFractionContact hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ fractionContactD0max := by
    rw [abs_le]
    constructor
    · dsimp only [fractionContactD0max]
      nlinarith [hstrip.2]
    · dsimp only [fractionContactD0max]
      nlinarith [hstrip.1]
  exact hle



/-- Data  gates  (Float  world;  the  Real  forms  carry  the  theorems
    above).  Computed  from  the  certified  constants:
    `1  -  fractionContactUpper  =  0.12661803338679245`,
    `fractionContactD0max  =  fractionContactUpper  -  1/2  =
    0.37338196661320755`  (Float  rounding  of  the  exact  127-digit
    rational). -/
def zeroFreeThetaFractionContact : Float := 0.8733819666132075
def stripLoFractionContact : Float := 0.12661803338679245
def offPairD0MaxFractionContact : Float := 0.37338196661320755
#eval zeroFreeThetaFractionContact
#eval stripLoFractionContact
#eval offPairD0MaxFractionContact

end Z78FractionContact
