# B7Far.lean  (205 lines)
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
USES:  used by: (none yet - the endpoint's four named residuals
         hs1/hs3/hWin/hS2low are untouched; next consumer candidates:
         the walk (B1) and the law-territory clause (B5)).
GOTCHA: nl is pinned as M - D (exact on the record), NOT recomputed as
          An * log t + Bn in Lean: the Real log never enters a gate; the
          ln predictions (0.477121, 2.2875) are documented 50-dp facts
          on the pinned heights, not Lean computations.
