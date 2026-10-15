"""s17:  growth-family  discriminator  on  the  full  M(t)  set
(s10  +  s9  below  part  +  s16  high-t  rows).

Fit  families  (  t  >  G  rows  only  ):

  F1  ln:      M  =  a ln(t)  +  b
  F2  pole:    M  =  a t ln((t-G)/G)  +  b t  +  c
  F3  farbias: M  =  a (t/G)^2  +  b (t/G)  +  c
  F4  mixed:   M  =  a ln(t)  +  b (t/G)^2  +  c

Family  with  the  smallest  max  residual  identifies  the
generator  class  of  the  far  substitution  error.
"""
import json

import numpy as np

G = 30001045999.981975555

rows = {}
for f in ("tmp/s10_deadzone_march.jsonl", "tmp/s9_dk_above_g.jsonl",
          "tmp/s16_M_far.jsonl"):
    import os
    if not os.path.exists(f):
        continue
    for l in open(f):
        r = json.loads(l)
        if r["t"] > G:
            rows[round(float(r["t"]), 1)] = float(r["M"])

ts = np.array(sorted(rows))
Ms = np.array([rows[t] for t in ts])
tG = ts / G
print("rows:  %d     t/G:  %.5f .. %.0f"
      % (len(ts), tG[0], tG[-1]), flush=True)


def fit(name, X, M):
    c, _, rank, _ = np.linalg.lstsq(X, M, rcond=None)
    f = X @ c
    md = np.max(np.abs(f - M))
    rm = float(np.sqrt(np.mean((f - M) ** 2)))
    print("%-8s  max  res  =  %11.4e   rms  =  %10.4e   coeffs  =  %s"
          % (name, md, rm,
             ["%+.4e" % v for v in c]))
    return md


ln_t = np.log(ts)
tln = tG * np.log(np.maximum(tG - 1, 1e-12))
t2 = tG ** 2

F1 = np.column_stack([ln_t, np.ones_like(ln_t)])
F2 = np.column_stack([tln, tG, np.ones_like(tG)])
F3 = np.column_stack([t2, tG, np.ones_like(tG)])
F4 = np.column_stack([ln_t, t2, np.ones_like(tG)])

m1 = fit("F1 ln", F1, Ms)
m2 = fit("F2 pole", F2, Ms)
m3 = fit("F3 farbias", F3, Ms)
m4 = fit("F4 mixed", F4, Ms)
print()

#  below-part  only  (  t  <  3G  )  sanity:
mask = tG < 3.0
if mask.sum() >= 5:
    print("below-part  (  t  <  3G,  n  =  %d  ):" % mask.sum())
    fit("F1", F1[mask], Ms[mask])
    fit("F2", F2[mask], Ms[mask])
    fit("F3", F3[mask], Ms[mask])
    fit("F4", F4[mask], Ms[mask])
