# SPINDLE GAME, PASS 5 (T7) — THE VARIATIONAL READING (F16)

Date: 2026-10-23. Owner variant question: *"is the NS 'game' one where
new primes compete to minimize the Euler action — predicting the next
gap to the next structure, optimizing the spindle structure / action
energy gradient, a slightly different objective each time?"*
Probe: tmp/sx6_variational.py (4.6s at X = 2e6, 2,204,797 spindles) +
1e8 prime-gap control (0.5s) + the F15 1e8 corner (T2).
NS posture: structural bounding template ONLY (T6). No RH claim.

## 0.  What  the  question  reduces  to  (and  is  allowed  to  mean)

By construction every valid spindle (p, d) is present — a prime never
chooses among its chords (valid = p − d and p − 2d prime, d even in
[2, 2000]).  So "primes minimize action" cannot mean per-prime chord
selection.  The only readings left are:  (a)  the prime chord-structure
sits at a SELECTION EDGE of some functional Φ vs the random-odd-
integer null at the same height (T7a);  (b)  the concentrated corner
of the game is where Φ is extreme (T7c);  (c)  the density transient
is a relaxation toward equilibrium (T7d);  (d)  the event/gap sequence
of the structure is PREDICTABLE beyond the null (T7e — the owner's
exact framing:  predicting the next gap and its cost).

## 1.  T7a  —  null  selection  test  (X  =  2e6;  200k  random  odd
    m  in  [1e6,  2e6)  as  null)

  - nonempty:  primes 148928/148933 = 1.0000;  null 200000/200000
    = 1.0000  (structure is UNIVERSAL at this scale on both sides).
  - chord  richness  n:  primes  mean  14.804 /  median  14  /
    p90  20  /  max  51;  null  mean  19.812  /  median  17  /
    p90  33  /  max  68.  KS  =  0.2853  (distinguishable).
  - **the  ratio  14.804 / 19.812  =  0.7472  ≈  3/4  EXACTLY.**
    The  3/4  is  the  classical  mod-3  screening  prediction:
    for  prime  p  (≠ 3),  both  death  classes  d  ≡  p  (kills
    p − d)  and  d  ≡  2p  (kills  p − 2d)  mod  3  cover  2/3
    of  the  even  chords;  survivors  d  ≡  0  (mod  3)  =  1/3.
    Random  odd  m  averages  survival  (2/3  +  1/3  +  1/3)/3
    =  4/9.  Ratio  (1/3)/(4/9)  =  3/4.  The  measured
    impoverishment  of  the  prime  chord-structure  is  the
    textbook  congruence  effect,  predicted  and  accounted
    for  —  no  selection  content  beyond  arithmetic.
  - per-chord  A:  primes  mean  1.257e12  (median  8.84e11)  vs
    null  2.323e12  (median  2.24e12):  ratio  0.541  —  primes
    46%  LOWER  area  per  chord.
  - per-chord  1/S  (thread  cost):  primes  0.4435  vs  null
    0.5220  (ratio  0.85)  —  primes  carry  MORE  threads
    (p − 1  even  forces  gcd(p − 1,  2d)  ≥  2).
  =>  the  prime  structure  is  sparser,  lower-area,  higher-
      thread  than  the  null  —  every  one  of  these  is
      congruence-class  arithmetic  of  the  prime  p  itself,
      not  an  optimization  choice.

## 2.  T7c  —  THE  CORNER  IS  LITERALLY  THE  AREA-MINIMIZING
    FAMILY

The  finite  corner  (A/S  <  100;  n  =  14,  all  p  ≤  4201;
scale-frozen  at  1e8  per  F15  T2  —  same  14,  min  8.5  at
(29,  d  =  6))  consists  of  spindles  with  **|p  −  5d|  =  1**:
p  ≡  ±1  (mod  10)  and  d  =  (p  ∓ 1)/5  —  the  chord  placed
EXACTLY  at  the  p/5  ZERO  of  A(p,  d),  achieving  the
per-p  minimum  area  A  =  1  ·  (p  −  2d):

      4201,  d  =  840:  r  =  d/p  =  0.2000  exact,  A  =  2521
        =  1  ·  2521
      3361,  d  =  672:  r  =  0.1999,  A  =  2017  =  1  ·  2017
      1861,  d  =  372:  r  =  0.1999,  A  =  1117  =  1  ·  1117
      2971,  d  =  594:  r  =  0.1999,  A  =  1783  =  1  ·  1783
      449,  d  =  90:  r  =  0.2004,  |449 − 450|  =  1
      389,  d  =  78:  r  =  0.2005,  |389 − 390|  =  1
      89,  d  =  18:  r  =  0.2022,  |89 − 90|  =  1
      29,  d  =  6:  r  =  0.2069,  |29 − 30|  =  1
      (plus  the  small-p  members,  some  with  |p  − 2d|  =  1,  3)

**In  this  game  the  "winners"  (small  A/S)  ARE  the  area
minimizers  —  and  the  minimization  resolves  to  the
congruence  class  p  ≡  1  (or  4)  mod  5.**  Honest  dual
reading:  the  A  form  carries  its  zero  at  d  =  p/5  by
construction  (the  NS  bounding  template),  so  the  corner
members  are  the  primes  for  which  the  template's  minimum
is  attainable  (|p  − 5d|  =  1  needs  (p  ∓ 1)  even  and  in
the  chord  range).  The  "competition  resolves  to  a  residue
class"  is  a  true  statement  ABOUT  THE  GAME;  it  is  arithmetic,
not  a  dynamical  choice.

## 3.  T7d  —  the  phantom  transient  (density  "reliability")

100-layer  excess  flux_tot / model_ln  −  1  (sx5  1e8  data):
e(0)  =  0.291  →  e(29)  =  0.1825  →  e(99)  =  0.1166.
Monotone  decay,  fast  at  first  (halving  by  ~layer  9),
settling  on  a  persistent  ~12%  floor  (the  systematic
ln-model  gap;  F15  T5  already  identified  this  as  the
low-height  asymptotic  convergence  of  the  divisor-density
model,  ln  detrend  drift  +0.31%).  A  rational  fit
e  ≈  0.215 / (1  +  0.0365  L)  gives  R²  =  0.46  on
the  head  30;  the  power  /  exponential  linearizations
score  worse  (R²  metric  on  the  original  scale  is  not
trustworthy  for  them  —  recorded  as  a  probe  caveat).
Reading:  the  "structure  matures"  at  the  DENSITY  level,
mildly  and  early;  no  event-level  dissipation  beyond.

## 4.  T7e  —  THE  PREDICTION  TEST  (the  owner's  gap  framing)

Event  sequence  =  distinct  structural  heights  (primes  with
≥  1  chord).  99.997%  of  primes  have  chords  at  2e6  (only
5  do  not)  —  so  the  game's  event  sequence  IS  the  prime
sequence,  and  the  controls  prove  it:

  lag-1  autocorrelation  (log  gap):
      spindle  primes   −0.0658   (−25σ  at  n  =  148928)
      ALL  primes       −0.0657   (identical  to  3  digits)
      random  odd  null −0.0003   (memoryless,  as  expected)
      1e8  ALL  primes  −0.0482   (−115σ  at  n  = 5,761,455)

  Fano  (100  bins  of  20000):  all-primes  11.8807  vs
  spindle-primes  11.8294  (identical  —  prime-count
  fluctuation,  not  spindle  effect).

  predictability  curve  (next  gap  median  vs  local  rate  in
  preceding  1e5  window,  2e6):
      deciles  0…9:  12  12  12  12  10  10  10  10  10  8
  (1e8:  14…14  12…12  over  a  1e6  window)  —  the  decrease
  is  the  trivial  local  prime-density  effect  (density  in
  the  window  is  information  about  the  next  prime  gap).

  search  cost:  spindle  gap  mean  13.43  ≈  ln(2e6)  =
  14.5  mean  prime  gap  (the  null's  6.07  is  a  40%-sample
  spacing  artifact  and  was  discarded).

**Verdict  on  the  prediction  framing:  the  game  does  not
predict.  The  PRIMES  do  —  and  only  weakly.**  The  negative
lag  (after  a  small  gap  a  larger  one  is  likelier;  the
anti-burst  /  packing-regular  signature)  is  the  known
prime-gap  alternation  (twin-bias  direction),  inherited
intact  by  the  spindle  sequence  (−0.0658  vs  −0.0657),
scale-stable  (−0.0482  at  1e8,  decaying  ~1/ln  x  as  the
twin-bias  theory  says),  and  absent  in  the  null.  The
"competition  to  predict  the  next  gap"  reduces  to  the
primes'  own  gap  autocorrelation;  the  chord  structure  adds
zero  (5  primes  changed  by  the  filter).

## 5.  F16  VERDICT

CLOSED-NEUTRAL  for  active  optimization  /  gap-prediction  by
the  primes,  with  two  POSITIVE  identifications:

  P1.  The  corner  (the  game's  only  concentrated  structure)
       is  exactly  the  area-minimizing  family  |p  − 5d|  =  1
       —  the  competition,  if  it  is  read  as  "who  wins  at
       small  A/S",  resolves  to  the  congruence  classes
       p  ≡  1,  4  (mod  5)  within  the  chord  range.  The
       winner  set  is  ARITHMETIC:  the  primes  that  can  put
       the  chord  on  the  template's  p/5  zero.
  P2.  The  only  predictability  in  the  system  is  the
       primes'  own  gap  alternation  (lag-1  −0.0657  at
       2e6,  −0.0482  at  1e8,  −115σ;  null  0.0003)  —
       anti-burst  and  scale-stable,  inherited  by  the  game
       verbatim.
  N1.  All  prime-vs-null  selection  statistics  (richness
       ratio  0.7472  ≈  3/4  mod-3  prediction;  A/chord
       0.54x;  1/S  0.85x)  are  congruence  arithmetic  of
       p  itself.  No  variational  content  beyond  arithmetic.
  N2.  The  density  transient  (29%  →  12%  floor)  is  the
       documented  ln-model  asymptotic  convergence;  mild,
       early,  density-level.

The  F15  CLOSED-FLAT  verdict  is  thereby  explained  from
the  variational  side  as  well:  the  game  is  at  (or  very
near)  the  minimum  of  every  functional  in  the  family,
because  there  is  no  degree  of  freedom  left  to  move  —
the  structure  is  fully  determined  by  the  primes  that
built  it,  and  those  are  themselves  only  weakly
self-predicting  (the  gap  alternation  being  the  entire
predictable  part).  NS  (T6  posture)  supplied  the  shape
of  the  question;  the  data  supplied  the  answer.

Files:  tmp/sx6_variational.py  +  tmp/sx6_variational_stats.json
+  the  1e8  control  (inline,  0.5s).  No  RH  claim  in
any  direction.
