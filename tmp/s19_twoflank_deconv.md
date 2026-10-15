# s19  two-flank  e(g)  deconvolution

M(t)  =  Int_G^1e30  pairLog(g,t)  e(g)  dg,  exact  analytic
band  kernels  (cusp  included),  Tikhonov  (first-diff),
rows  =  79  (both  flanks),  bands  =  2078.

best  lam  =  10000,  max|res|  =  1.4045e+00
max|e|  =  1.3923e-02  per  unit  g

PHYSICS  (min-norm  read,  lam-insensitive):
  -  NO  boundary  layer  at  G:  Int_(G,G+500]  e dg  =
    O(1e-7);  the  near-G  delta  hypothesis  dies.
  -  a  smooth  negative  bias  over  the  first  ~1000G,
    cumulative  ~ 1e10  zeros  by  1000G,  built  at
    local  amplitude  <=  0.4%  of  Rho;
  -  (1e4*G,  1e30]  is  unobservable  gauge  for  all
    measured  rows  (t  <=  1000G).
