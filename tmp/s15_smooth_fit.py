"""s15:  generate  the  defect  law  from  a  smooth  far-density
bias.

  M(t)  =  Int_G^U  pairLog(g,t)  *  e(g)  dg   ,  g  in  (G, U]
  e(g)  =  c0  +  c1 ln g  +  c2 / g        (basis)
  c_i  by  least  squares  against  the  27  measured  M(t)
  rows  (s10  +  s9).

Interpret:  a  smooth  bias  e(g)  in  the  far  zero  density
(Rho  model  vs  truth)  --  if  it  fits  to  ~  1e3  (residual
scale  of  the  ln-t  law),  the  far  defect  is  a  global
density  statement;  check  its  cumulative  N  (x  =  1e11)
against  the  published  exact  zero  count.
"""
import json

import mpmath as mp
import numpy as np

G = 30001045999.981975555
U = 1e30

rows = {}
for f in ("tmp/s10_deadzone_march.jsonl", "tmp/s9_dk_above_g.jsonl"):
    for l in open(f):
        r = json.loads(l)
        if r["t"] > G:
            rows[round(float(r["t"]), 1)] = float(r["M"])
ts = np.array(sorted(rows))
Ms = np.array([rows[t] for t in ts])
print("rows:  %d" % len(ts), flush=True)


def f_pair(g, t):
    g = mp.mpf(g); t = mp.mpf(t)
    return (mp.log(abs(g - t)) + mp.log(g + t)
            - mp.log(g*g + mp.mpf("0.25")))


def phi(t, basis):
    """Int_G^U  pairLog  *  basis  dg  via  log-scale  variable
    u  =  ln(g/G):  g  =  G e^u,  dg  =  G e^u du,  u  in  [0, L].
    Cusp  at  u*  =  ln(t/G)  if  t  in  (G, U)."""
    Gm = mp.mpf("%.15g" % G)
    L = mp.log(mp.mpf("1e30") / Gm)
    tm = mp.mpf("%.15g" % float(t))
    def integrand(u):
        g = Gm * mp.e**u
        return f_pair(g, tm) * basis(g) * g
    us = None
    tf = float(t)
    if G < tf < 1e30:
        us = float(mp.log(tm / Gm))
    if us is None:
        return float(mp.quad(integrand, [mp.mpf("0"), L]))
    d = mp.mpf("1e-9")
    segs = [mp.mpf("0"), mp.mpf(us) - d, mp.mpf(us) + d, L]
    out = mp.mpf("0")
    for a, b in zip(segs[:-1], segs[1:]):
        out += mp.quad(integrand, [a, b], error=0, verbose=0)
    return float(out)


with mp.workdps(30):
    bases = [lambda g: mp.mpf("1"),
             lambda g: mp.log(g),
             lambda g: 1 / g]
    Phi = []
    for t in ts:
        row = [float(phi(t, b)) for b in bases]
        Phi.append(row)
        print("  phi  @  t  =  %.6e:  %s" % (t,
              ["%+.6e" % x for x in row]), flush=True)

Phi = np.array(Phi)
c, res, rank, sv = np.linalg.lstsq(Phi, Ms, rcond=None)
fit = Phi @ c
print()
print("c0  =  %+.8e" % c[0])
print("c1  =  %+.8e" % c[1])
print("c2  =  %+.8e" % c[2])
print("rank  =  %d" % rank)
print("max  residual  (  vs  measured  M  ):  %.4e"
      % np.max(np.abs(fit - Ms)))
print("rms  residual:  %.4e"
      % np.sqrt(np.mean((fit - Ms) ** 2)))
print()
print("cumulative  dN(x)  implied  by  e(g)  (  N  =  int  e  ):")
for x in (2e11, 1e12, 1e15, 1e20, 1e30):
    #  c0  *  x  +  c1  *  (x ln x  -  x)  +  c2  *  ln x
    val = c[0]*x + c[1]*(x*np.log(x) - x) + c[2]*np.log(x)
    print("  dN(%.1e)  =  %+.6e" % (x, val))
