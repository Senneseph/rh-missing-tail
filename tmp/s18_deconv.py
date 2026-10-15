"""s18:  regularized  deconvolution  of  the  far  discrepancy.

  M(t)  =  Int_G^U  pairLog(g,t)  e(g)  dg  +  const
  31  measured  t-rows  (  0.108G  ..  1000G  ...  well,  the
  s8  below-G  rows  too  --  all  of  them  )  ->  e(g)  on  a
  log  grid,  Tikhonov  (  2nd  derivative  in  ln g  ).

Outputs:  the  profile  e  =  c0 g^0  +  ...  (  effective
missing  /  extra  zero  density  per  unit  g  above  G  ),
its  cumulative  charge  E(T)  =  Int_G^T  e,  and  the
reconstruction  fit.
"""
import json

import numpy as np

G = 30001045999.981975555

rows = {}
#  all  measured  M(t)  rows  we  have:
for f, tf_ in (("tmp/s8_m_true_sample.jsonl", "s8"),
               ("tmp/s10_deadzone_march.jsonl", "s10"),
               ("tmp/s9_dk_above_g.jsonl", "s9"),
               ("tmp/s16_M_far.jsonl", "s16")):
    import os
    if not os.path.exists(f):
        continue
    for l in open(f):
        r = json.loads(l)
        if tf_ == "s8":
            t, M = float(r["t"]), float(r["M"])
        else:
            t, M = float(r["t"]), float(r["M"])
        rows[round(t, 1)] = M

ts = np.array(sorted(rows))
Ms = np.array([rows[t] for t in ts])
print("rows:  %d   t/G  =  %.5f .. %.0f"
      % (len(ts), ts[0] / G, ts[-1] / G), flush=True)

#  log  grid  for  g  in  (G,  1e16G)  --  leverage  beyond  1e16G
#  is  ~  (t/g)^2  =  (1e-16 *  t/G)^2  <  1e-28:  irrelevant.
K = 80
lg = np.linspace(0.0, 16.0, K)             #  u  =  ln(g/G)
g = G * np.exp(lg)
dg = np.diff(np.concatenate([[np.log(G)], np.log(g)]))

#  kernel  matrix
def pairLog(g_, t_):
    g_ = np.asarray(g_, float)
    return (np.log(np.abs(g_ - t_)) + np.log(g_ + t_)
            - np.log(np.square(g_) + 0.25))

Kmat = np.array([pairLog(g, t) for t in ts])     #  n_t x K

#  Tikhonov:  minimize  |K e  -  Ms|^2  +  lam * |D2 e|^2
D2 = np.zeros_like(lg)
h = lg[1] - lg[0]
D2[1:-1] = (1 / h ** 2)
for lam in (1e3, 1e4, 1e5, 1e6, 5e6):
    A = Kmat.T @ Kmat + lam * D2
    b = Kmat.T @ Ms
    e = np.linalg.solve(A, b)
    fit = Kmat @ e
    md = np.max(np.abs(fit - Ms))
    print("lam  =  %.1e:  max  res  =  %.4e" % (lam, md))
    if lam == 1e6:
        best = e
        best_fit = fit

e = best
print()
print("profile  e(g)   (  net  far  zero  density  bias,  per  "
      "unit  g  )")
print("  u  =  ln(g/G)    g              e(g)      cum  E(T)  "
      "=  Int  e")
cum = 0.0
for i in range(K):
    w = (g[i + 1] - g[i]) if i < K - 1 else 0.0
    cum += 0.5 * (e[i] + (e[i + 1] if i < K - 1 else e[i])) * w
    if i % 8 == 0 or g[i] < 3 * G:
        print("  %8.4f       %12.4e   %+.5e  %+.5e"
              % (lg[i], g[i], e[i], cum))
print()
print("total  charge  E(U)  over  (G,  1e16 G ):  %+.5e" % cum)
print("max |e|  =  %.4e" % np.max(np.abs(e)))
print("max  residual  of  the  chosen  fit:  %.4e"
      % np.max(np.abs(best_fit - Ms)))
print("min  t-derivative  check:  dM/dt  measured  vs  model  "
      "at  a  few  heights:")
idx = [0, len(ts) // 3, 2 * len(ts) // 3, len(ts) - 1]
for i in idx:
    dmeas = None
    if 0 < i < len(ts) - 1:
        dmeas = (Ms[i + 1] - Ms[i - 1]) / (ts[i + 1] - ts[i - 1])
    dmmod = ((Kmat[i - 1] @ e) - (Kmat[i + 1] @ e)) \
        / (ts[i - 1] - ts[i + 1])
    print("  t/G  =  %8.4f   dM/dt  meas  =  %+.4e   model  =  "
          "%+.4e" % (ts[i] / G, dmeas if dmeas is not None
                    else 0.0, dmmod))
