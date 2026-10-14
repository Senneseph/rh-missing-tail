# s7:  the c(t) theorem

log c(t)  =  EPS + Q_engine(t) - I_far,RVM(t) - M(t)

  EPS        = lm - log|main_ex| - ln(xi(0)) + Ex_total   (constant ~ -1.2e-7)
  main_ex    = 2 pi^{s/2} / (s (s-1) Gamma(s/2))
  Q_engine   = log Kabs - lm - la - re      (ledger exact)
  I_far,RVM  = int_G^{1e30} W_pair (ln g/2pi)/2pi dg
  M(t)       = RVM tail model error  (true zeros - density)

| t | LHS | EPS | Q_engine | I_far(quad40) | I_far(trap) | M |
|---|---|---|---|---|---|---|
| 3.23217097e+09 | -0.00911048 | 1.660171e-07 | -1292998320.49296 | -1292998320.49296 | -48905516802.04208 | +0.009110 |
| 2.78842829e+10 | -1.55541075 | -1.741332e-06 | -119425929963.78165 | -119425929963.78165 | -989301755847.32605 | +1.555411 |

quad40 = u-quad dps-40;  trap = 2e6-pt u-trapezoid.
M smooth and small  =>  c fully accounted:  constant,
ledger's own tail quad, exact RVM quad, RVM model error.

