# B7Far.lean  (412 lines)
WHAT:  THE B7 FAR-SIDE FACE: the census-drift mechanism, named.
HOW:   Consumes the MFa pins; adds the near-log PART nl = M - D pinned
         from the s33b record by exact arithmetic on the pins (nl9 =
         -609469941, nl10 = -667658569.9, nl30 = -695421601.6; 50-dp
         cross-check A ln t + B within 1.1/0.05/0.51 units = f64
         pipeline noise).  Five GATED (norm_num) gates:
         decompositionGates (nl = M - D exact on the pins), shareWindows
         (the near-log share |nl|/|M| in [5%,7%] / [0.06%,0.07%] /
         [0.007%,0.008%] at the three far pins - measured 5.87% /
         0.0683% / 0.0079%), shareDecay (share shrinks >=10x per decade
         and >=5x per 3x step), notLineInLnT (the second M drop ratio
         drop30/drop10 in [7,9], measured 8.0804, vs the ln-t line
         0.477121 and the t*ln-t family 2.2875 - the far M channel is
         NOT a continuation of the near log law), t2stepConsistency (the
         drop ratio sits within 1e-3 absolute of the PURE t^2 step ratio
         (t30^2-t10^2)/(t10^2-t9^2) = 8.0808081 at the exact pinned
         heights, measured gap 4.57e-4, while every competing family is
         >=0.79 away: the residual shape is the t^2 / kernel -t^2/g^2
         family, identified not asserted).  b7OpenFace (the S4Blind
         s4OpenFace pattern): the open MECHANISM as a Prop declaration -
         for any mechanism map gen, there exists a positive far-side
         count excess E, supported on the measured s29 g-window [2e8,
         1e11] (g = t/G), whose GENERATED drift hits the three pinned D
         values; measured at the pins, not proven.  No RH claim: the
         endpoint far region is vacuous in the body from [Z78]; this
         face is a measured constraint any RH proof must reproduce.
USES:  used by: B7Far section D (discovery 0112) - the WALK CONSUMER:
         the card's 'walk (B1)' candidate in the current module layout
         (the W2T.DN tail walk with the W2Beyond drift step law):
         b7WalkFace = the b7OpenFace pattern restricted to gen = the W2
         tail-walk drift operator over three consecutive steps (N0 = 0,
         Nas(0) = 0), PROVEN by construction (b7WalkHitAny /
         b7WalkFaceTrue) - for ANY three reals a, b, c there is a count
         grid whose walk drift hits them at steps 1, 2, 3 (grid: i -
         value_i at i in {1,2,3}, 0 elsewhere) - the WALK OPERATOR HAS
         EMPTY STRUCTURAL CONSTRAINT on a drift triple, so the walk is
         NOT excluded as the B7 mechanism and the open link of the walk
         candidate is exactly the E -> grid INPUT map (the excess
         driving the count-grid increments), which is not in the tree.
         SECTION E (discovery 0113) wires the SECOND consumer candidate
         - the old 'law-territory (B5)' - which in the current module
         layout is the P4 TAIL-LAW family (P4Limit, the EM-tail T3
         wall): the T3 tail bound (t3w_T3UB, the certified tail size at
         height t, cutoff n = floor(13t/8)) closes on the WHOLE wall
         range 1 <= t <= 1e8 (p4_25ae_wall_list_scale) - that is the
         wall the B7 record calls 'past-the-wall'. The law-territory
         candidate is STRUCTURALLY EXCLUDED (b7LawExcluded) on two exact
         grounds: POSITION - the B7 support window [2e8, 1e11] and the
         three pinned far heights sit beyond the wall range
         (b7WindowBeyondLawWall / b7PinsBeyondLawWall, norm_num), where
         the law makes no statement; MAGNITUDE - on the whole wall range
         the certified tail content is < 1/2 (lawTailBelowHalf: n = 0
         branch (0:R)^(-1/2) <= 1, n >= 1 branch n^(-1/2) <= 1 and 35/39
         < 1) while every pinned drift is > 1/2 (b7DriftAboveHalf,
         smallest |D9| = 9774967307, growing |D9| < |D10| < |D30|) -
         about 14 orders of magnitude apart. The two consumers bracket
         the mechanism space: the WALK candidate SURVIVES (realizable),
         the LAW-TERRITORY candidate is EXCLUDED, and the remaining B7
         mechanism content is the unnamed channel of the excess input E
         past the wall.
GOTCHA: nl is pinned as M - D (exact on the record), NOT recomputed as
          An * log t + Bn in Lean: the Real log never enters a gate; the
          ln predictions (0.477121, 2.2875) are documented 50-dp facts
          on the pinned heights, not Lean computations.
