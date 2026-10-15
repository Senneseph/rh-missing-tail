"""s13:  solve  for  the  scale-by-scale  discrepancy  that
produces  the  measured  defect.

Model:  M(t)  =  Sum_{bands  k}  D_k  *  pairLog(g_k,  t)  where
bands  k  =  [G*2^k,  G*2^(k+1)]  (k = 0..K,  up  to  U  =  1e30)
and  g_k  =  geometric  centroid.  D_k  =  net  signed
zero-count  discrepancy  of  band  k  (N_true  -  N_model).
Minimum-norm  least-squares  against  the  27  measured  M(t)
(s10  +  s9,  deduped).  Answers:  how  many  zeros  would  have
to  be  missing  /  extra  where  for  the  Rho  model  to  be
off  by  the  measured  defect  --  and  is  that  count
compatible  with  RH-scale  discrepancy  bounds  (|DN(x)|  <<
x^(7/64))?
"""
import json

import numpy as np

G = 30001045999.981975555
U = 1e30

rows = []
for f in ("tmp/s10_deadzone_march.jsonl", "tmp/s9_dk_above_g.jsonl"):
    for l in open(f):
        r = json.loads(l)
        rows.append((r["t"], r["M"]))
seen = {}
for t, m in rows:
    seen[round(t, 1)] = m
ts = np.array(sorted(seen))
Ms = np.array([seen[t] for t in ts])
print("rows:  %d" % len(ts), flush=True)

K = int(np.ceil(np.log2(U / G)))
ks = np.arange(K)
bk = G * (2.0 ** ks)                  # band  lower  edge
gk = np.sqrt(2.0) * bk                # centroid


def pairLog_vec(gk, t):
    d = np.abs(gk - t)
    out = (np.log(np.maximum(d, 1e-300)) + np.log(gk + t)
           - np.log(gk * gk + 0.25))
    return out

F = np.array([pairLog_vec(gk, t) for t in ts])   # 27 x 64
# minimum-norm  least  squares
D, res, rank, sv = np.linalg.lstsq(F, Ms, rcond=None)

print("bands:  %d  (K = %d),  lstsq  rank  =  %d,  residual  =  %.4e"
      % (K, K, rank, np.sqrt(np.sum((F @ D - Ms) ** 2) / len(Ms))))
print()
print("band  k   [from,   to]      D_k  (net  extra  zeros)")
tot = 0.0
for k in range(K):
    if abs(D[k]) < 1e-3 * max(np.abs(D)).max():
        continue
    tot += D[k]
    print("  %3d   %9.3e - %9.3e   %+.6e"
          % (k, bk[k], bk[k] * 2, D[k]))
print()
print("bands  with  |D_k|  >  1e-3  max:  %d"
      % int((np.abs(D) > 1e-3 * np.abs(D).max()).sum()))
print("signed  total  (all  bands):  %+.6e" % D.sum())
print()
# RH  comparison:  |DN(x)|  <<  x^(7/64):
print("RH-scale  comparison  (|DN(x)|  <<  x^(7/64)):")
for x in (1e13, 1e20, 1e30):
    print("  x = %.0e:  x^(7/64)  =  %.3e" % (x, x ** (7 / 64)))
PYEOF_UNUSED = None
