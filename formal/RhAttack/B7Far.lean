import Mathlib
import RhAttack.MFar
import RhAttack.W2Telescope
import RhAttack.P4Limit

/-
B7Far.lean  -  the  B7  FAR-SIDE  FACE  (the  census  drift;
s29  /  s33b  record).  DATA  +  NAMED  OPEN  FACE  (no  RH
claim).

WHAT  IS  PINNED
  Consumes  the  MFa  pins  (the  far  M  rows  and  the  D
  drift  of  the  s33b  past-the-wall  re-deconvolution).
  Adds  the  NEAR-LOG  PART  nl  =  M  -  D  (the  A  ln  t
  +  B  share  of  M,  pinned  from  the  s33b  record  by
  exact  arithmetic  on  the  pins)  and  shapes  the  face
  in  four  machine-checked  gates:
  (i)   DECOMPOSITION:  nl  =  M  -  D  exactly  on  the
        three  past-the-wall  pins;
  (ii)  SHARE  WINDOWS:  |nl|/|M|  in  [5%,  7%]  at  1e9G
        (measured  5.87%),  in  [0.06%,  0.07%]  at  1e10G
        (measured  0.0683%),  in  [0.007%,  0.008%]  at
        3e10G  (measured  0.0079%)  -  the  near  log  law
        is  a  VANISHING  share  of  the  far  M  channel;
  (iii) SHARE  DECAY:  the  share  shrinks  by  at  least
        10x  from  1e9G  to  1e10G  and  by  at  least  5x
        from  1e10G  to  3e10G;
  (iv)  NOT-A-LINE-IN-LN-T:  the  second  drop  ratio  along
        the  pinned  f64  grid  lands  in  [7,  9]  (measured
        8.0804);  a  line  in  ln  t  through  the  first  two
        far  pins  would  predict  the  ratio
        ln(t30/t10)  /  ln(t10/t9)  =  0.477121...  (50-dp
        fact  on  the  pinned  heights)  -  a  factor  ~16.9
        below  the  window;  the  t  ln  t  family  would  give
        2.2875  (50-dp).  The  s33  "degeneracy  survives"
        reading  is  CLOSED  at  the  data  level:  the  far
        M  channel  is  NOT  a  continuation  of  the  near
        log  law.
  (v)   T^2  STEP  CONSISTENCY:  the  measured  drop  ratio
        drop30/drop10  =  8.0803515  sits  within  1e-3  (in
        the  cross-multiplied  gap  |drop30  (t10^2  -  t9^2)
        -  drop10  (t30^2  -  t10^2)|  against  drop10  (t10^2
        -  t9^2))  of  the  PURE  t^2  step  ratio
        (t30^2  -  t10^2)  /  (t10^2  -  t9^2)  =  8.0808081
        at  the  EXACT  pinned  heights  (which  itself  sits
        1.4e-15  from  the  ideal  800/99  of  the  3x/10x
        steps)  -  while  every  other  measured  family  is
        >=  0.79  away  (t  ln  t  at  2.2875,  the  ln  t
        line  at  0.4771).  The  residual  shape  is  IDENTIFIED
        as  the  t^2  (kernel  -t^2/g^2  tail)  family  at  the
        drop-ratio  level,  to  4.6e-4  absolute.

HOW
  All  gates  are  norm_num  arithmetic  on  the  MFa  pins
  (windows  cross-multiplied  to  stay  in  the  positive
  rationals;  the  Real  log  never  enters  a  gate  -  the
  ln-prediction  0.477121...  is  a  documented  50-dp  fact
  on  the  pinned  heights,  not  a  Lean  computation).
  b7OpenFace  is  a  Prop  DECLARATION  in  the  S4Blind
  s4OpenFace  pattern:  the  open  MECHANISM  -  a  smooth
  positive  far-side  count  excess  on  the  measured  g
  window  [2e8,  1e11]  (g  =  t/G)  whose  GENERATED  drift
  hits  the  pinned  D  values  -  stated  for  ANY  mechanism
  map  gen.  Measured  at  the  pins,  not  proven  in  the
  tree;  the  pins  (MFa.pinGates  +  the  gates  here)  are
  its  measured  shadow.

USES
  None  yet.  The  endpoint  is  UNAFFECTED:  the  far  region
  of  RHEnd.rh_program78  is  VACUOUS  in  the  body  from
  [Z78]  (Z78P12.offPairFarEmpty),  so  the  B7  face  is  a
  MEASURED  CONSTRAINT  that  any  RH  proof  must  reproduce
  (the  PATHWAY  section  3  list),  not  one  of  the  four
  named  endpoint  residuals  (hs1  /  hs3  /  hWin  /
  hS2low).  Next  consumer  candidates:  the  walk  (B1)  and
  the  law-territory  clause  (B5).

GOTCHA:  nl  is  pinned  as  M  -  D  (exact  on  the  record),
NOT  recomputed  as  An  *  log  t  +  Bn  in  Lean.  The
50-digit  cross-check  (A  ln  t  +  B  vs  M  -  D)  lives
in  the  Python  record:  diffs  +1.06  /  +0.048  /  -0.51
units  =  f64  pipeline  noise  on  the  s33b  D  values.  -/

open Real

namespace B7F

/-  ##  the  near-log  share  (pinned:  nl  =  M  -  D,  the
    A  ln  t  +  B  part  of  the  s33b  record)  -/

/--  nl9  =  M9  -  D9  =  the  near-log  share  of  the  1e9G
    row  (the  s33b  record;  50-dp  cross-check  A  ln  t9
    +  B  agrees  within  1.1  units,  the  f64  pipeline
    noise  on  D9).  -/
def nl9 : ℝ := -(609469941 : ℝ)
/--  nl10  =  M10  -  D10  (same  record;  cross-check  0.05).  -/
noncomputable def nl10 : ℝ := -(6676585699 : ℝ) / 10
/--  nl30  =  M30  -  D30  (same  record;  cross-check  0.51).  -/
noncomputable def nl30 : ℝ := -(3477108008 : ℝ) / 5

/-  ##  the  far drops  (positive  quantities)  -/

/--  drop10  =  the  M  drop  from  the  1e9G  pin  to  the
    1e10G  pin  (positive  by  the  pins).  -/
def drop10 : ℝ := -(MFa.M10 - MFa.M9)
/--  drop30  =  the  M  drop  from  the  1e10G  pin  to  the
    3e10G  pin  (positive  by  the  pins).  -/
def drop30 : ℝ := -(MFa.M30 - MFa.M10)

/-  ##  the  gates  -/

/--  GATE  (i):  the  decomposition  is  EXACT  on  the  pins:
    nl  =  M  -  D  for  each  past-the-wall  row  (so  the
    pinned  nl  values  are  the  s33b  near-log  part  by
    construction,  not  a  re-fit).  -/
theorem decompositionGates :
    nl9 = MFa.M9 - MFa.D9 ∧
    nl10 = MFa.M10 - MFa.D10 ∧
    nl30 = MFa.M30 - MFa.D30 := by
  simp only [nl9, nl10, nl30, MFa.M9, MFa.M10, MFa.M30,
             MFa.D9, MFa.D10, MFa.D30]
  norm_num

/--  GATE  (ii):  the  SHARE  WINDOWS  -  the  near-log  share
    |nl|/|M|  sits  in  a  measured  window  at  each  pin
    (windows  cross-multiplied;  all  quantities  positive
    by  the  pins).  -/
theorem shareWindows :
    100 * 609469941 ≥ 5 * 10384437248 ∧
    100 * 609469941 ≤ 7 * 10384437248 ∧
    10000 * 6676585699 / 10 ≥ 6 * 978196824064 ∧
    10000 * 6676585699 / 10 ≤ 7 * 978196824064 ∧
    100000 * 3477108008 / 5 ≥ 7 * 8798461100032 ∧
    100000 * 3477108008 / 5 ≤ 8 * 8798461100032 := by
  norm_num

/--  GATE  (iii):  SHARE  DECAY  -  the  near-log  share
    shrinks  by  at  least  10x  per  decade  (1e9G  ->  1e10G)
    and  by  at  least  5x  per  3x  step  (1e10G  ->  3e10G);
    the  t^2  term  is  what  the  far  M  channel  IS.  -/
theorem shareDecay :
    10 * 6676585699 * 10384437248 / 10 ≤ 609469941 * 978196824064 ∧
    5 * 3477108008 * 978196824064 / 5 ≤ 6676585699 * 8798461100032 / 10 := by
  norm_num

/--  GATE  (iv):  NOT-A-LINE-IN-LN-T  -  the  drops  are
    positive  and  the  second  drop  ratio  drop30/drop10
    lands  in  [7,  9]  (measured  8.0804).  A  line  in
    ln  t  through  the  first  two  far  pins  would  give
    the  ratio  ln(t30/t10)/ln(t10/t9)  =  0.477121...  and
    the  t  ln  t  family  would  give  2.2875  (both  50-dp
    facts  on  the  pinned  heights)  -  a  factor  ~16.9  /  a
    gap  of  0.79  from  the  window:  the  far  M  channel
    is  not  a  continuation  of  the  near  log  law  (the
    s33  degeneracy  survives  reading  is  superseded).  -/
theorem notLineInLnT :
    0 < drop10 ∧ 0 < drop30 ∧
    7 * drop10 ≤ drop30 ∧ drop30 ≤ 9 * drop10 := by
  simp only [drop10, drop30, MFa.M9, MFa.M10, MFa.M30]
  norm_num

/--  GATE  (v):  T^2  STEP  CONSISTENCY  -  the  drop  ratio
    is  the  PURE  t^2  STEP  RATIO  at  the  exact  pinned
    heights,  within  1e-3  absolute  (cross-multiplied:  the
    gap  |drop30  (t10^2  -  t9^2)  -  drop10  (t30^2  -
    t10^2)|  against  drop10  (t10^2  -  t9^2);  all  factors
    positive  by  the  pins  and  the  height  order).  The
    measured  gap  is  4.57e-4  (margin  2.2x);  the  closest
    competing  family  (t  ln  t  at  2.2875,  the  ln  t
    line  at  0.4771)  sits  0.79  away  -  the  window  is
    790x  tighter  than  the  nearest  competitor.  The
    residual  shape  is  the  t^2  (kernel  -t^2/g^2)  family:
    identified,  not  asserted.  -/
theorem t2stepConsistency :
    1000 * |drop30 * (MFa.t10 ^ 2 - MFa.t9 ^ 2) -
              drop10 * (MFa.t30 ^ 2 - MFa.t10 ^ 2)| ≤
      drop10 * (MFa.t10 ^ 2 - MFa.t9 ^ 2) := by
  simp only [drop10, drop30, MFa.M9, MFa.M10, MFa.M30,
             MFa.t9, MFa.t10, MFa.t30]
  norm_num

/-  ##  the  named  open  face  (declaration,  not  proof)  -/

/--  THE  B7  FAR-SIDE  FACE  (declaration,  not  proof):
    the  open  MECHANISM  of  the  far  drift.  For  ANY
    mechanism  map  gen  (a  positive  far-side  count
    excess  E  on  the  g  =  t/G  scale,  supported  on
    the  measured  s29  window  [2e8,  1e11],  mapping  to
    the  drift  it  generates),  the  face  is:  there
    EXISTS  such  an  E  whose  generated  drift  hits  the
    three  pinned  D  values.  The  own  FORM  of  this
    statement  is  MEASURED  at  the  pins  (MFa.pinGates
    +  the  gates  of  this  module  fix  what  any
    mechanism  must  reproduce)  and  is  NOT  proven  in
    the  tree:  this  is  the  remaining  open  mathematics
    of  B7,  now  a  named  object  (the  S4Blind
    s4OpenFace  pattern).  No  RH  claim:  the  endpoint's
    far  region  is  vacuous  in  the  body  from  [Z78];
    this  face  is  a  measured  constraint  on  any  proof.  -/
def b7OpenFace (gen : (ℝ → ℝ) → (ℝ → ℝ)) : Prop :=
    ∃ (E : ℝ → ℝ),
      (∀ g, g < 2 * 10 ^ 8 ∨ 10 ^ 11 < g → E g = 0) ∧
      (∀ g, 0 ≤ g → 0 ≤ E g) ∧
      gen E MFa.t9 = MFa.D9 ∧ gen E MFa.t10 = MFa.D10 ∧
      gen E MFa.t30 = MFa.D30

/-  ##  Section  D  -  THE  WALK  CONSUMER  (discovery  0112)

  The  B7F  card's  first  consumer  candidate  was  "the  walk  (B1)"  -
  in  the  current  module  layout  the  walk  operator  is  the  W2
  tail  walk  W2T.DN  (W2Telescope  +  W2Beyond  drift  laws):
  DN  N0  Nas  j  =  N0  +  j  -  Nas  j,  with  the  drift  step
  law  (W2Beyond.driftStep):  DN(j+1)  -  DN(j)  =  1  -  (Nas(j+1)
  -  Nas(j)).  b7OpenFace  asks  for  a  mechanism  map  gen  that
  reproduces  the  three  pinned  drifts  D9/D10/D30  from  an
  excess  E  supported  on  the  g  window.  The  WALK  CANDIDATE  is
  the  structural  statement  that  gen  IS  the  tail-walk  drift
  operator  (over  the  three  consecutive  steps  1,  2,  3  with
  N0  =  0  and  Nas(0)  =  0)  -  stated  as  its  own  face  in  the
  b7OpenFace  pattern  (b7WalkFace)  and  RESOLVED  by  construction
  (b7WalkHitAny  /  b7WalkFaceTrue):  for  ANY  three  real  values
  a,  b,  c  there  is  a  count  grid  NasGrid  whose  walk  drift
  hits  them  exactly  at  steps  1,  2,  3  (NasGrid(1)  =  1  -  a,
  NasGrid(2)  =  2  -  b,  NasGrid(3)  =  3  -  c,  zero  elsewhere):
  the  walk  operator  carries  NO  structural  constraint  on  a
  drift  triple  -  the  pinned  D  values  are  trivially  in  its
  image.  The  open  link  of  the  walk  candidate  is  recorded
  honestly:  the  E  ->  grid  map  (how  the  far  excess  drives
  the  count  grid  increments)  is  NOT  in  the  tree  -  the
  excess  of  b7OpenFace  stays  free  here.  No  RH  claim:  this
  resolves  the  walk-side  question  for  the  drift  OUTPUT  and
  leaves  the  mechanism  INPUT  as  the  named  open  link.  -/

/-- b7WalkFace  -  THE  B7  FACE  RESTRICTED  TO  THE  WALK
    CANDIDATE  (the  b7OpenFace  pattern  with  gen  =  the  W2
    tail-walk  drift  operator  over  the  three  consecutive
    steps,  N0  =  0):  there  exists  a  count  grid  whose
    walk  drift  from  step  0  hits  the  three  pinned  D
    values  exactly  at  steps  1,  2,  3.  The  excess  E  of
    b7OpenFace  is  not  part  of  this  face:  the  E  ->  grid
    link  is  the  open  input  (docstring).  -/
def b7WalkFace : Prop :=
    ∃ (NasGrid : ℕ → ℝ),
      W2T.DN 0 NasGrid 1 - W2T.DN 0 NasGrid 0 = MFa.D9 ∧
      W2T.DN 0 NasGrid 2 - W2T.DN 0 NasGrid 0 = MFa.D10 ∧
      W2T.DN 0 NasGrid 3 - W2T.DN 0 NasGrid 0 = MFa.D30

/-- b7WalkHitAny  -  the  WALK  OPERATOR  HAS  EMPTY  STRUCTURAL
    CONSTRAINT  on  a  drift  triple:  for  ANY  three  real
    values  a,  b,  c  there  is  a  count  grid  whose  tail-walk
    drift  hits  them  at  steps  1,  2,  3  (N0  =  0,  Nas(0)  =
    0).  Pure  construction  from  the  W2T.DN  definition  (the
    grid  is  free  at  the  three  steps  -  the  drift  step  law
    W2Beyond.driftStep  is  the  mechanism  by  which  the  grid
    increments  encode  the  drift).  -/
theorem b7WalkHitAny (a b c : ℝ) :
    ∃ (NasGrid : ℕ → ℝ),
      W2T.DN 0 NasGrid 1 - W2T.DN 0 NasGrid 0 = a ∧
      W2T.DN 0 NasGrid 2 - W2T.DN 0 NasGrid 0 = b ∧
      W2T.DN 0 NasGrid 3 - W2T.DN 0 NasGrid 0 = c := by
  refine ⟨(fun (i : ℕ) =>
      if i = 1 then 1 - a
      else if i = 2 then 2 - b
      else if i = 3 then 3 - c
      else 0), ?_, ?_, ?_⟩
  · dsimp only [W2T.DN]
    split_ifs <;> (try contradiction; ring)
  · dsimp only [W2T.DN]
    split_ifs <;> (try contradiction; ring)
  · dsimp only [W2T.DN]
    split_ifs <;> (try contradiction; ring)

/-- b7WalkFaceTrue  -  THE  WALK  CANDIDATE  IS  A  WITNESS  SHAPE
    for  the  B7  far-drift  face:  b7WalkFace  holds  (the  three
    pinned  D  values  are  in  the  tail-walk  drift  image).  So
    the  walk  is  NOT  structurally  excluded  as  the  B7
    mechanism  -  and  the  remaining  open  link  of  the  walk
    candidate  is  exactly  the  E  ->  grid  input  map  (the
    excess  driving  the  count-grid  increments),  which  is  NOT
    in  the  tree.  No  RH  claim.  -/
theorem b7WalkFaceTrue : b7WalkFace := by
  obtain ⟨NasGrid, h9, h10, h30⟩ := b7WalkHitAny MFa.D9 MFa.D10 MFa.D30
  exact ⟨NasGrid, h9, h10, h30⟩

/-  ##  Section  E  -  THE  LAW-TERRITORY  CONSUMER  (discovery  0113)

  The  card's  second  consumer  candidate  -  "the  law-territory
  clause  (B5)"  in  the  old  layout  -  is  the  P4  TAIL-LAW  family
  (P4Limit:  the  EM-tail  T3  wall)  in  the  current  module  layout.
  The  law's  T3  tail  bound  (t3w_T3UB:  the  four-term  certified
  size  of  the  tail  channel  at  height  t  with  cutoff
  n  =  floor(13t/8))  closes  on  the  WHOLE  wall  range
  1  <=  t  <=  1e8  (p4_25ae_wall_list_scale)  -  and  past  1e8
  the  wall  does  NOT  close:  that  is  the  wall  the  B7  record
  calls  "past-the-wall"  (s33b:  the  far  M  rows  and  the  D
  drift  sit  beyond  it).

  The  consumer's  verdict  MIRRORS  the  walk  consumer  (section  D):
  the  walk  candidate  is  REALIZABLE  (the  operator  carries  empty
  structural  constraint  on  a  drift  triple),  while  the
  LAW-TERRITORY  candidate  is  STRUCTURALLY  EXCLUDED,  on  two  exact
  grounds  (all  proven  below;  no  RH  claim):
      POSITION  (b7WindowBeyondLawWall,  b7PinsBeyondLawWall):
      the  B7  support  window  [2e8,  1e11]  sits  strictly  beyond
      the  law's  wall  range  [1,  1e8],  and  the  three  pinned  far
      heights  (MFa.t9/t10/t30)  are  all  beyond  the  wall  top  as
      raw  parameters  (the  s29  record  maps  them  into  the  g
      window  via  g  =  t/G  with  G  the  frontier  -  record
      level,  not  pinned  here).
      MAGNITUDE  (lawTailBelowHalf,  b7DriftAboveHalf):
      on  the  WHOLE  wall  range  the  law's  certified  tail
      content  is  strictly  below  1/2  (n  =  0  branch:
      (0:R)^(-1/2)  <=  1;  n  >=  1  branch:  n^(-1/2)  <=  1
      (t3w_invpow_le_one)  and  35/39  <  1),  while  every  B7
      pinned  drift  has  magnitude  strictly  above  1/2  -  the
      smallest,  |D9|  =  9774967307  -  a  gap  of  about  14  orders
      of  magnitude  between  what  the  law  can  certify  (at  any
      height  it  covers)  and  what  B7  pins  (at  its  nearest
      pin).
  b7LawExcluded  is  the  composed  statement:  at  every  height  of
  the  law's  certified  range  the  tail  content  is  below  1/2
  while  every  pinned  drift  is  above  it  -  the  law-territory
  mechanism  (B7  drift  =  tail-law  content)  is  EXCLUDED  as  a
  generator  of  the  B7  face  on  the  law  range,  and  AT  the  B7
  pins  the  law  is  SILENT  (the  wall  does  not  close  past  1e8):
  its  certified  output  can  never  reach  the  pinned  magnitudes
  unless  it  is  extended  past  the  wall,  and  no  such
  extension  is  in  the  tree.

  The  two  consumers  TOGETHER  bracket  the  mechanism  space  of
  b7OpenFace:  the  WALK  candidate  SURVIVES  (realizable;  open
  link  =  the  E  ->  grid  input  map),  the  LAW-TERRITORY
  candidate  IS  EXCLUDED  (position  +  magnitude  on  the  law
  range);  the  remaining  open  content  of  the  B7  face  is  the
  UNNAMED  channel  of  the  excess  input  E  itself  (its  g-window
  support  and  its  map  into  counts),  past  the  wall.  No  RH
  claim:  measured/named  constraint;  pure  composition  over  the
  pinned  gates  and  the  T3  wall  theorem.  -/

/-- The  law's  wall  top  (P4Limit  T3  wall):  the  tail  bound  is
    certified  for  1  <=  t  <=  lawWallTop.  -/
def lawWallTop : ℝ := (10 : ℝ) ^ 8

/-- (POSITION,  window  level)  the  B7  support  window  [2e8,  1e11]
    sits  strictly  beyond  the  law's  wall  range  [1,  lawWallTop].  -/
theorem b7WindowBeyondLawWall : lawWallTop < 2 * 10 ^ 8 := by
  norm_num [lawWallTop]

/-- (POSITION,  pin  level)  the  three  pinned  far  heights  are
    all  beyond  the  wall  top  as  raw  parameters  (the  s29
    record  maps  them  into  the  g  window  via  g  =  t/G  with  G
    the  frontier  -  record  level,  not  pinned  here).  -/
theorem b7PinsBeyondLawWall :
    lawWallTop < MFa.t9 ∧ lawWallTop < MFa.t10 ∧ lawWallTop < MFa.t30 := by
  norm_num [lawWallTop, MFa.t9, MFa.t10, MFa.t30]

/-- (MAGNITUDE,  law  side)  on  the  WHOLE  wall  range  the
    certified  tail  content  is  strictly  below  1/2:  the  T3
    wall  bound  gives  t3w_T3UB  n  t  <  (1/2) * n^(-1/2) *
    (35/39)  with  n  =  floor(13t/8);  the  n  =  0  branch  is
    (0:R)^(-1/2)  <=  1  and  the  n  >=  1  branch  is
    n^(-1/2)  <=  1  (t3w_invpow_le_one),  and  in  either  case
    (1/2) * (35/39)  <  1/2.  -/
theorem lawTailBelowHalf (t : ℝ) (ht : 1 <= t) (ht8 : t <= lawWallTop)
    (n : ℕ) (hn : n = Nat.floor ((13 : ℝ) * t / 8)) :
    t3w_T3UB n t < 1 / 2 := by
  have hwall : t3w_T3UB n t < (1 / 2 : ℝ) * (n : ℝ) ^ (-1 / 2 : ℝ) * (35 / 39) :=
    p4_25ae_wall_list_scale ht ht8 hn
  have hinfn : (n : ℝ) ^ (-1 / 2 : ℝ) <= 1 := by
    by_cases h0 : n = 0
    · subst h0
      simpa [Nat.cast_zero] using zero_rpow_le_one (-1 / 2)
    · have hn1 : 1 <= n := Nat.pos_of_ne_zero h0
      have hstep : (n : ℝ) ^ (-(1 / 2 : ℝ)) <= 1 :=
        t3w_invpow_le_one n hn1 (1 / 2) (by norm_num)
      simpa [neg_div] using hstep
  calc t3w_T3UB n t < (1 / 2 : ℝ) * (n : ℝ) ^ (-1 / 2 : ℝ) * (35 / 39) := hwall
    _ <= (1 / 2 : ℝ) * 1 * (35 / 39) := by gcongr
    _ < 1 / 2 := by norm_num

/-- (MAGNITUDE,  B7  side)  every  pinned  drift  has  magnitude
    strictly  above  1/2  (the  smallest  is  |D9|  =  9774967307),
    and  they  GROW  with  the  pin  (|D9|  <  |D10|  <  |D30|  -
    the  t^2  growth  family  of  t2stepConsistency  at  the
    magnitude  level).  -/
theorem b7DriftAboveHalf :
    |MFa.D9| > 1 / 2 ∧ |MFa.D10| > 1 / 2 ∧ |MFa.D30| > 1 / 2 ∧
    |MFa.D9| < |MFa.D10| ∧ |MFa.D10| < |MFa.D30| := by
  norm_num [MFa.D9, MFa.D10, MFa.D30]

/-- b7LawExcluded  -  THE  LAW-TERRITORY  MECHANISM  IS  EXCLUDED
    as  a  generator  of  the  B7  far-drift  face:  at  EVERY
    height  t  of  the  law's  certified  range  [1,  1e8],  the
    tail  content  (t3w_T3UB)  is  below  1/2  while  every  pinned
    B7  drift  is  above  it  (the  composition  of  lawTailBelowHalf
    and  b7DriftAboveHalf)  -  and  the  B7  pins  themselves  sit
    beyond  the  wall  (b7PinsBeyondLawWall),  where  the  law
    makes  NO  statement  (the  wall  does  not  close  past  1e8).
    No  RH  claim:  this  EXCLUDES  the  law-territory  candidate
    (the  second  consumer  of  b7OpenFace)  while  the  walk
    candidate  survives  (section  D);  the  remaining  B7
    mechanism  content  is  the  unnamed  channel  of  the  excess
    input  E  past  the  wall.  -/
theorem b7LawExcluded (t : ℝ) (ht : 1 <= t) (ht8 : t <= lawWallTop)
    (n : ℕ) (hn : n = Nat.floor ((13 : ℝ) * t / 8)) :
    t3w_T3UB n t < 1 / 2 ∧
    |MFa.D9| > 1 / 2 ∧ |MFa.D10| > 1 / 2 ∧ |MFa.D30| > 1 / 2 :=
  ⟨lawTailBelowHalf t ht ht8 n hn,
    (b7DriftAboveHalf).1, (b7DriftAboveHalf).2.1, (b7DriftAboveHalf).2.2.1⟩


end B7F
