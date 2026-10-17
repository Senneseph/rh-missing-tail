# LowExcl.lean  (112 lines)
WHAT:  THE LOW-BAND OFF-PAIR EXCLUSION: the squeeze, stated as an
         impossibility about the zero set at the endpoint.
HOW:   endpointWireLow / endpointWireLowFull: the endpoint's Z78P12 wire
         aliases (BwireP + MrP, + MfP) are 0 below the program strip
         (LowWires' definitional-zero shape pulled through the aliases;
         MfP = 0).  lowBandLegsFalse: at a low-band point (0 < t0 <
         1000, 0 < d0 <= 1/2) the endpoint's three low-band legs in the
         EXACT endpoint leg form - hs1 (Qside >= RHEnd.devProg), hS2low
         (devProg >= p8_f_near_pin), hs3 (Qside <= BwireP + MrP) - are
         jointly contradictory (0.9975 <= devProg <= Qside <= 0), engine
         LowWires.lowBandSqueezeShape.  offPairExcludedLowBand: the
         corollary - no zero set carries an off-pair at any low-band
         height while the three legs hold there; the d0 > 1/2 half of
         the low band is vacuous from [Z78] alone
         (Z78P12.offPairFarEmpty, carried in the RHEnd body, not here).
         NO RH claim: the module proves what the endpoint's named legs
         imply in the low band.
USES:  used by: (none yet - the exclusion corollary the endpoint's low-
         band residual legs instantiate; LowWires supplies the wire
         shape, QSide the data-face vocabulary).
GOTCHA: the three low-band legs (hs1 / hS2low / hs3) remain NAMED
          residual faces of RHEnd.rh_program78 - but their JOINT
          obligation at every off-pair SELF-EXCLUDES low-band off-pairs
          by pure logic (no datum needed: the contradiction fires for
          ANY Qside, ANY devProg); the data program only feeds the legs
          for off-pairs at 1000 and above (audited band / window pin /
          [Z78]-vacuous far region apart from the named blind spot).
