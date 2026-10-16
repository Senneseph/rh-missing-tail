# B3Core.lean  (458 lines)
WHAT:  B3 primitives: the RVM flat density layer.
HOW:   twoPiInv, nHat (ln(x/2pi)/2pi), NHat (x/2pi(ln(x/2pi)-1)+7/8); fT
         model functions; regime e <= G <= B, 0 < t < G.
USES:  used by: B3, B3Abel, B3Sbar, S4Growth, S4Strip, S4Window.
GOTCHA: twoPiInv is a canonical atom: log-arguments must keep using it.
