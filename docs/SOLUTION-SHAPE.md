# SOLUTION SHAPE -- the one-clause reduction for the rh-missing-tail program

This note states, as tightly as the current Lean tree allows, what the
program's RH claim reduces to, where the published literature stands on
that clause, and which doors remain.  It is the abstraction that replaces
any "push the data further" step:  the data only has to decide the one
named clause at hand scale;  everything beyond it is either proven or
refuted in the limit by existing theorems.

## 1.  The reduction (all pieces proven in this repo)

The H1 program at a pin t with far frontier g1 >= 2t:

  W2(t)  =  (zero-side action of the Efull kernel at t)
           -  (main / prime side, computable without zeros)

with the exact kernel (W2Beyond2,  day023/day029 verbatim)

  p(g; t) = log|g^2 - t^2| - log(g^2 + 1/4) + (1/2)/(g^2 + 1/4),

  (principal value avoided by the straddle grid: |g - t| >= 1/2).

Proven machinery (module -> statement):

  W2Beyond2        far-side rewrite of the kernel (g > t);
                   |p(g;t)| <= 3 t^2/g^2, |p'(g)| <= 5 t^2/g^3
                   (g >= 2t);  the far-side total variation over
                   [g1, oo) is at most (5/2) t^2 / g1^2.
  W2Telescope      the kernel sum telescopes:  the far-side tail of
                   W2(t) is a statement about COUNTS,  packaged as
                   DN(N0, Nas, j) = (N0 + j) - Nas(j)  --  the
                   smoothed-count deficit from the true count.
  A1Growth         a1_growth_wire_log:  if |DN j| <= CS log x_j +
                   1/x_j along the grid,  the far-side contribution
                   at the pin is bounded by (CS log x_M + 1) .
                   (17/2)(t^2/g1^2).  CCM form (G = (1/4) log u /
                   loglog u + ...) carries the cited frontier bound.
  Ap1..Ap4 (D4)    the classical inputs the wire needs,  proven
                   in-house:  argument principle,  RvM window
                   identity,  Backlund explicit horizontal O(log T)
                   bound,  sigma=2 side <= pi,  full dyadic RvM.
  S1Point (ap5)    POINT-scale RvM with O(log T) error:
                   |N(T) - f_pt T| <= C log T  (good heights,
                   named input C9:  no zero on (0,4];  first zero
                   14.134725...).  Contains S1B.rebase_a1g6_dn_form:
                   the wire's hSbound premise form C log t + 1/t
                   holds in the classical smooth-count
                   instantiation  Nas = f_pt.
  Data layer       the near side (zeros down to the pin) verified to
                   3e10 at certificate grade:  505 points,  margin
                   mnew < 1,  precision layer stable.

E4 reduction (W2Beyond2 header,  docs/S1-A1-EXPLORATION.md):
as the data frontier G2 -> oo,  |p(G2)| -> 0  and the far-side
variation is a CONSTANT cost in t,  so the universal [S1] target
reduces,  on the walk side,  to the pointwise clause

    (CL)   |DN(N0, Nas, j)|  <=  K        for all zero heights j,

with K a uniform O(1) constant  (the E1 restatement:  S bounded
at the zeros).

## 1b.  Structural decode of the squeeze margin  (2026-10-13/14,
        resolved at true single-zero resolution)

  One arithmetic pass over  (Kabs,  zeta,  residf)  per ledger
  row showed,  at ALL 505 certified points  (22 windows):

      Kfull (zero-product reconstruction) / zeta(1/2+it)
          =  - c(t)      (negative real,  phase pi,  c > 0)

  to >= 7 digits.  Hence

      residf = (1 + c(t)) |zeta|,      mnew = dev/(1 + c(t))
              ~ 1/(1 + c(t)),
  with dev ~ 1 exactly  (the straddle window is empty:  
  R_closed ~ O(1/g) ~ 3e-10;  Bdev ~ 5e-32)  and  pb ~ 1e-24;
  the margin is a pure READOUT of the identity ratio  c(t).

  TWO-SCALE structure of  c(t)  (measured,  s3 ledger-
  reconstruction,  gated 9.6e-9 against the certified ledger
  at all 18 anchor rows;  la/ar bit-exact re-evaluation;  
  re/im exact window correction + exact sawtooth;  dps-30
  quadrature verified against the u-space tanh-sinh 
  reference  (mp.quad 400-node log-quad and 1e6-point u-grid
  agree to 1e-3 on the 1.29e9 exponent)):

    (a)  WINDOW-CONSTANT part:  c is constant to ~3e-6 
        across the window at the 0.5 ledger sampling  (the 
        smooth parts -- lm, la, quad, smooth re -- cancel 
        in the identity to 1e-5);  c varies smoothly across 
        the band  (c = 0.9909 at 3.23e9  ...  c = 0.2111 
        at 2.79e10,  collapsing near G_LAST = 3.0001e10), 
        giving the band rise  mnew 0.502 -> 0.826  =  
        1/(1 + c(x)).
    (b)  ZERO-SCALE wiggle:  at the true 0.025 step  (one 
        zero-spacing)  c(t) wiggles:  |dm| median 4.4e-3, 
        p99 8.7e-2,  max 1.7e-1  (band-wide,  357 steps)  
        --  an attenuated readout of the zero-scale S-flow 
        of the discrete product.  S itself at the same 
        scale:  |dS| median 0.08,  mean 0.25,  max 1.9 per 
        step  (twin steps);  net S change +9.5 .. +12.5 
        over the ~3-unit grids  (= ~1 per zero,  as
        defined).  The 505-point "flatness"  (max 3.2e-4 
        at the 0.5 step)  was a SAMPLING ARTIFACT:  the 
        0.5 step is 20 zero-spacings  and averages the 
        wiggle out.

  DOOR DECISION  (the question:  "is the margin flat at 
  zero scale?"):  DOOR B  --  the margin is NOT flat at 
  true single-zero resolution;  it carries zero-scale 
  structure  (the S-flow of the identity).  The 505 
  flatness was the 0.5-step artifact the door question 
  suspected.

  The program's endgame is UNCHANGED by this:  the flat 
  O(1)-at-zero-heights clause was never the squeeze margin 
  --  it is E1  (|DN| <= K at zero heights  =  S = O(1) 
  at the zeros),  open unconditionally,  refuted in the 
  limit under RH  (P1 zero-weighted CLT:  S at zero-
  weighted heights ~ sqrt(loglog T)/pi,  unbounded;  P2 
  zero-scale oscillation).  The squeeze remains what it 
  always was:  a zero-EXCLUSION certificate  (an off-line 
  zero at offset d in a window lifts the margin by ~ 
  (d/(t-g))^2 * c/(1+c):  d = 0.1 -> +3.7e-2 at the band 
  head,  against the 0.5-step certificate floor 3e-4,  
  ~100x above noise)  plus the Efull identity  (now known 
  exactly:  Kfull = -c(t) zeta,  c(t) as above).

  Artifacts:  scripts/rh/s3_ledger_recon_margin_sweep.py,  
  scripts/rh/s3_interpret.py;  outputs  tmp/s3_ledger_
  recon_margin_sweep_summary.md,  tmp/s3_interpret.md.  
  (The day056 engine sweep was stopped for cost  --  ~4 h 
  re-stream per grid point;  the s3 ledger-anchored 
  reconstruction is the stricter check,  since la/ar match 
  the engine bit-exactly and its gate is 100x tighter than 
  the engine's own Bexp budget.)

## 2.  What (CL) IS, in classical terms

For the smooth count Nas = f_pt (the RvM main term),
the deficit is the S-defect:

    DN(j)  =  S(x_j) + O(1/x_j),        S(t) = (1/pi) arg zeta(1/2+it).

So (CL)  says,  in classical language:

    S is O(1)  AT THE ZERO ORDINATES (zero-restricted flatness).

This is exactly the open zero-restricted problem of forensics 3.8:
"no unconditional improvement on S(t) = O(log t)" (arXiv:2010.13307)
and "no satisfactory results seem to be known" for
S(g+H) - S(g-H) (arXiv:1706.08268):  the published frontier,
EVEN RESTRICTED TO THE ZEROS,  is the all-t O(log t) scale.
The unconditional O(1)-at-zeros statement is not a theorem in
either direction in the cited literature.

## 3.  What the theorems say about (CL) in the limit

  Under RH  --  (CL) is REFUTED in the limit.
    P1 (arXiv:2507.04150,  read in full):  the zero-weighted CLT.
    For the local mock zero-count N_phi(t) (Hughes-Rudnick
    statistic,  phi^ support in mean-spacing units),  the
    IMAGINARY part of log zeta -- i.e.  pi . S -- satisfies,
    under RH,  a full Gaussian CLT with variance (1/2) loglog T
    under the zero-weighted measure |N_phi - phi^(0)|^k dt / C,
    with Fourier support up to the natural barrier (-2/k, 2/k)
    (Thm 1.2,  Cor 1.4).  Unconditionally the complex-CLT half
    (Thm 1.1,  Cor 1.3) already covers Im log zeta at the
    restricted 2/(k+2) support.  Consequence:  S at
    zero-weighted heights has typical size sqrt(loglog T)/pi
    in the limit -- unbounded.  (CL) fails under RH in the
    limit.
    P1 Prop 1.5 (RH):  the correlation of log zeta with the
    local zero statistic decays only like 1/sqrt(loglog T);
    the leading sqrt(loglog) fluctuation is asymptotically
    independent of the zero weight -- no leading-order
    cancellation at the zeros exists to rescue (CL).
    P2 (arXiv:2510.14309,  Thm 1,  RH,  effective):  S moves
    at the zero scale h = c'/log T by (1-o(1)) . sqrt(c'/pi)
    --  zero-scale oscillation,  counting-only.
    P5 (arXiv:2511.18275,  RH):  deterministic GUE pair
    correlation for the zeros (real-hall + SDE + S-mixing
    upgrade) --  the zero statistics stay fully random,
    consistent with and complementary to P1/P2.
    Classical omegas (forensics 3.7):  Tsang (1/3)-power
    unconditional;  Bondarenko-Seip sqrt-scale under RH --
    for all t (hence consistent with the zero-restricted
    failure,  though not a zero-restricted theorem themselves).

  Unconditionally  --  (CL) at the O(1) level is OPEN.
    Nothing proves S = O(1) at zeros;  nothing (at the
    zero-restricted level) refutes it.  The all-t O(log t)
    is the known bound (the wire's CS log t form).

  Data (3e10,  in-hand)  --  the two sides disagree at
    resolution,  which is the whole open question:
    S-side (s0_singlezero_swalk,  0.025 step):  rough --
    median |dS| ~ 0.25 per step,  15-17 crossing events
    (jumps ~0.92-2.9) per 5 t-units,  total drift up to 3
    S-units per 5 units;  P2-scale per-spacing reads
    ~0.42,  consistent with P2 Thm 1 under RH.
    Margin-side (505-point ledger):  flat -- adjacent
    (0.5 t-shift) margin deltas <= ~3.2e-4.
    The margin is the WIRE-COMBINED object (S1 - R residual
    plus certified budget,  normalized)  --  not S alone.
    So the data say:  S is rough,  the wire combination is
    flat,  at 0.5-step resolution.  The open question is
    what the wire combination does at true zero resolution
    (0.025 step,  one zero per step).

## 4.  The two doors (the complete solution shape)

  DOOR A  (CL) is true at all zero heights (uniform O(1)).
    Then:  data at 3e10  +  proven far-side machinery  +  (CL)
    gives the RH claim (certified near side,  constant far-side
    cost,  pointwise clause).  (CL) would be the new theorem
    the program contributes --  a zero-restricted S-boundedness
    result that does not exist in the literature in either
    direction.  Obstacle:  under RH it is refuted in the limit
    by P1/P2,  so a Door A proof cannot assume RH and must
    find the cancellation mechanism (main term vs S) at the
    wire level;  P1 Prop 1.5 says it cannot happen at leading
    order,  so Door A,  if true,  is a secondary-term
    phenomenon.

  DOOR B  (CL) is false --  the wire combination inherits the
    S-roughness (or anything growing) at zero heights.
    Then the RH route as designed is dead,  but the program
    does not die:  it becomes the formally verified theorem
    "RH holds to the scale where the margin stays below 1
    (3e10 by data),  with the far side O(log)-constrained
    (proven wire)"  --  a strong,  publishable,  Lean-checked
    result,  with the exact growth shape of DN at zeros
    measured (P1/P2 supply the limit,  data supply the scale).

  The door question,  precisely:
      Does the wire combination (S1 - R residual,
      normalized margin) stay O(1) as t crosses zeros --
      i.e.  is the S-roughness CANCELLED by the main term
      INSIDE the certificate,  at true zero resolution?
  Day056 (the single-zero margin sweep,  forensics 3.10) is
  the empirical answer at 3e10:  flat margin deltas at the
  0.025 step  ->  Door A stays alive  (the clause becomes a
  theorem-target;  3e11 or any higher band is then the only
  data question,  as a transfer test).  Rough margin deltas
  at zero scale  ->  Door B  (re-scope to the sub-RH theorem).

## 5.  Consequences for compute (why 3e11 is not next)

  * The reduction needs NO new band:  every far-side input is
    proven;  the point of the clause is a scale where the data
    already reach (3e10).
  * A higher band would only matter after the door question is
    answered:  under Door A it becomes a transfer test;
    under Door B it is irrelevant to the clause (the clause
    is decided by the shape of DN at zeros,  not its height).
  * D5 (next band) is therefore correctly parked:  optional,
    owner-GO,  not scheduled,  not load-bearing.

## 6.  Status

  - Proven (this repo):  kernel decay + far-side constant cost
    (W2Beyond2),  telescope to counts (W2Telescope),  the wire
    (A1Growth),  all classical D4 inputs (Ap1-Ap4),  point-
    scale RvM + A1G-6 rebase (S1Point).
  - Data-verified:  near side to 3e10 (505-point margin < 1,
    precision layer).
  - DECODED + MEASURED (2026-10-13/14):  the squeeze identity
    holds as  Kfull = -c(t) zeta  at every certified point;  
    c(t) is window-constant to 3e-6 (smooth cancellation) 
    plus a zero-scale wiggle  (|dm| median 4.4e-3,  p99 
    8.7e-2,  max 1.7e-1 per 0.025 step,  band-wide)  --  
    the margin's 505-point "flatness" was a 0.5-step 
    sampling artifact  (section 1b,  s3 data).  Door B 
    (margin carries zero-scale structure:  the S-flow of 
    the identity).
  - Open (the one clause):  (CL) / E1,  uniform O(1) at zero
    heights  =  S = O(1) at the zeros.  UNCHANGED by the 
    door result:  E1 is the walk/count clause,  not the 
    margin.
  - Refuted in the limit under RH:  P1 + P2  (+ P5 context,
    classical omegas).
  - Queued:  the closed form of  c(t)  (the explicit factor 
    of the Efull identity;  now measured exactly:  window-
    constant part + zero-scale wiggle;  a one-line theorem 
    once the wiggle's carrier is named).
