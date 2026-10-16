# LowWires.lean  (109 lines)
WHAT:  The LOW-BAND wire shape of the endpoint, machine-proven.
HOW:   Below the program strip (t0 < 1000) the R-wires are
         DEFINITIONALLY zero (bwireR_low_zero, mrr_low_zero, mfr_zero,
         wireSumLow) and the endpoint floor is the near pin
         (floProg_low_pin : floProg = 0.9975; devProg_low : devProg =
         devStripMin); s4low_trivial (the S4 low leg: 0 < 0.9975,
         standalone form of RHEnd's in-body hs4low_pin);
         lowBandSqueezeShape: the three nontrivial low-band legs are
         JOINTLY contradictory at any low-band off-pair (0.9975 <=
         devStripMin <= Qside <= 0 -> False) - the live squeeze engine
         at the low-band wire configuration, sibling of
         QSide.section8_close_at_audit.
USES:  used by: (none yet - the shape module documenting the low-band
         instance of RHEnd's walk).
GOTCHA: the legs stay the NAMED residual of the endpoint (hs1 = C2 >=
          side face, hS2low = the day-030 floor pin, hs3 = the zero-wire
          shape); this module pins only the wire SHAPE they run on - no
          RH claim.
