# s8:  M(t)  at all 505 ledger rows

M(t) = EPS(t) + Q_engine(t) - I_far,RVM(t) - log c(t)
     =  true RVM tail model error  =  E1's measurable face

rows:  505    (t from 3.23217e+09 to 2.78843e+10)

| stat | M | EPS |
|------|---|-----|
| min  | +0.009100218 | -0.000001741 |
| p01  | +0.009101979 | -0.000001741 |
| med  | +0.043389335 | +0.000000166 |
| p99  | +1.555446366 | +0.000002073 |
| max  | +1.555465754 | +0.000002073 |
| |M| max   | +1.555465754 | |

## M by height decade  (drift test)

| log10 t bin | n | M med | M min | M max |
|---|---|---|---|---|
| 9.0 | 192 | +0.01683310 | +0.00910022 | +0.02710297 |
| 10.0 | 313 | +0.27167783 | +0.03149237 | +1.55546575 |

## fits  (window medians,  22 windows)

| fit | params | max abs residual |
|-----|--------|------------------|
| M = a ln t + b  | a=0.44815 b=-10.00343 | +0.7801 |
| M = s (t/G)^p  (log fit) | s=1.24175 p=2.2562 | +0.3903 (in ln M) |

window-internal spread  (max over windows of the
per-window M range,  22 windows):  +1.768e-03
top window  (t = 2.788e10):  +1.287e-03

trap cross-check rows:

  t=3.49074466e+09  quad-trap = -5.916e-02
  t=3.77000422e+09  quad-trap = -6.925e-02
  t=4.39733293e+09  quad-trap = -9.506e-02
  t=5.12904913e+09  quad-trap = -1.309e-01
  t=5.98252291e+09  quad-trap = -1.811e-01
  t=6.97801472e+09  quad-trap = -2.521e-01
  t=1.39490837e+10  quad-trap = -1.331e+00
  t=1.62702112e+10  quad-trap = -2.103e+00
  t=1.89775744e+10  quad-trap = -3.584e+00
  t=2.58187804e+10  quad-trap = -1.927e+01
