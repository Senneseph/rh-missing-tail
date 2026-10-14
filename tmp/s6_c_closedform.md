# s6:  closed form of the squeeze factor c(s)

log c  =  [lm - log|main|] + Ex_m + corr + Q_f - S_U

main = (1/2) s (s-1) pi^{-s/2} / Gamma(s/2)
   (zeta = main * Prod_{pairs} (1-s/r1)(1-s/r2);  RH => s on C)

| t | LHS | I | Ex_m | corr | Q_f | S_U | Q_f-S_U | RHS | diff |
|---|---|---|---|---|---|---|---|---|---|
| 3.23217097e+09 | -0.00911048 | -75.38350534 | 0.011547733 | 8.254e-04 | -1.292998e+09 | -7.452136e+08 | -5.478e+08 | -547784755.63906682 | 5.478e+08 |
| 2.78842829e+10 | -1.55541075 | -82.92568970 | 0.011547733 | 5.341e-03 | -1.194259e+11 | -1.185964e+11 | -8.295e+08 | -829497794.71716309 | 8.295e+08 |

term sources:
  I      = lm - log|main|,  mpmath dps-30
  Ex_m   = grid exact (21136125 pts) + D-band RVM quad
  corr   = ledger B-fields (real parts)
  Q_f    = s5 run jsonl  (certified engine far quad;
           kernel W_pair + 0.5/(g^2+1/4))
  S_U    = this run,  pure W_pair,  mp.quad over g
           split at 1e18 for the far band

S_U band detail:
  (10000000, 31946000.1]:   t0  +5.313329136e+08   t1  +7.566984407e+08
  (1e+09, 1.002e+09]:   t0  +1.348717754e+07   t1  +3.999502714e+07
  (2e+09, 2.002e+09]:   t0  +2.964589086e+06   t1  +3.280424400e+07
  (3.0001046e+10, 1e+30]:   t0  -1.292998320e+09   t1  -1.194259300e+11

residual budget:  GN 0.5-step grid artifact (Door B) on la/re
  +  RVM-density quad error on the gap bands (no zeros on
  disk)  +  Q_f kernel convention (~1e-7).

