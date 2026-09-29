"""day049e: root-cause verification for the fleet ledger's 1-eps margins.

Hypothesis (from reading day038's code):

  day038.cert_point pulls   (qrem30, qext30, qrem60, qext60, ...)
                            = quad_pair(T, tf, audit)
  where (day037/038 quad_pair, the 3e10-generation variant)
        qrem = quad over (G_LAST, 1e18]
        qext = quad over (G_LAST, 1e30]     <- the FULL remainder
  and ev_point multiplies BOTH into Kfull:
        Kfull *= e**qrem        <- (G_LAST, 1e18]
        Kfull *= e**qext        <- (G_LAST, 1e30], which CONTAINS
                                   (G_LAST, 1e18] already
  => the region (G_LAST, 1e18) is counted TWICE in the exponent.
     Re-part of that region ~ -1.508628600e9, so the real exponent
     drops from the true +0.2574 (= log 1.2938 = log|K|) to
     ~ -1.508628343e9, i.e. Kfull rounds to 0 at dps-30.
     Then residf = |z - 0| = |z| exactly, and
     mnew = |z|*dev/(pb + |z|) = dev = 1 - 3.5e-9
          = 0.9999999965  -- the ledger's mnew/mcert to 10 digits.

This script runs, at p01 (t = 3490744648.3185544014,
g = 3490744654.3185544014, nlt = 10609961701):

  A) day038.cert_point VERBATIM (current code, 8-thread GPU path,
     exactly the fleet path)  -> expected to reproduce the ledger
     row: mnew = mcert = 0.9999999965, residf = 1.3075849021,
     Efull ~ +1.508628600e9 (the double-count fingerprint).

  B) day038.cert_point with the FIX (quad_pair's ext term computed
     over the ADJACENT piece (1e18, 1e30] instead of (G_LAST,1e30],
     i.e. the day034/day048/day049a convention) -> expected to land
     at the CRT-verified p01 margin: mnew ~ 0.502658,
     residf ~ 2.601338, |Kfull| ~ 1.293756, Efull ~ +0.0108.

One GPU tail pass per variant (2 x ~35 min), 1 CPU + iGPU.
Read-only on the band. Respects the 2-physical-core reservation
(taskset at launch).
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import day038_h1_3e10_gpu as D38

T = D38.Tail3E10(verbose=False)
TF = 3490744648.3185544014
G = 3490744654.3185544014
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "out_day049e_verify_fix")
os.makedirs(OUT, exist_ok=True)

LEDGER = {  # widx00_x3490744654.pts, p01 row (5900x fleet)
    "mnew": 0.9999999965, "mcert": 0.9999999965,
    "residf": 1.3075849021, "zeta": 1.307585, "nlt": 10609961701}
CRT = {  # CRT margin protocol (day048 verified pipelines)
    "mnew": 0.502658103672, "residf": 2.601338, "K": 1.2937556}


def dump(tag, p):
    out = {
        "tag": tag,
        "mnew": float(p["mnew"]), "mcert": float(p["mcert"]),
        "residf": float(p["residf"]), "zeta": float(p["zeta"]),
        "dev": float(p["dev"]),
        "Efull": float(p["Efull"]),
        "Bexp": float(p["Bexp"]),
        "Bqrem": float(p["Bqrem"]), "Bqext": float(p["Bqext"]),
        "nlt": int(p["nlt"]), "flag": bool(p["flag"]),
    }
    print("== %s ==" % tag, flush=True)
    for k in ("mnew", "mcert", "residf", "zeta", "dev", "Efull",
              "nlt"):
        print("  %-10s = %s" % (k, out[k]), flush=True)
    with open(os.path.join(OUT, "%s.json" % tag), "w") as f:
        json.dump(out, f, indent=1)
    print("  (saved %s.json)" % tag, flush=True)
    return out


# ---- A) verbatim fleet path ---------------------------------------------
print("A) running VERBATIM day038.cert_point (8-thread GPU)...",
      flush=True)
pA = D38.cert_point(T, TF, G, audit=False, nthreads=8)
# K magnitude for the fingerprint (cert_point does not save it):
from mpmath import mp
mp.dps = 30
s30 = mp.mpc(0.5, mp.mpf(repr(TF)))
lm30 = D38.logmain25212(s30)
qrem30, qext30, qrem60, qext60, Bqrem, Bqext, aud = \
    D38.quad_pair(T, TF, audit=False)


def _ev(tag_qrem, tag_qext, tag_re, tag_im, dps):
    mp.dps = dps
    s = mp.mpc(0.5, mp.mpf(repr(TF)))
    lm = D38.logmain25212(s)
    (la, ar, _b1, _b2, _b3) = D38.prod_with_budget(TF)
    K = mp.e ** (lm + mp.mpf(repr(la)) + 1j * mp.mpf(repr(ar))
                 + mp.mpf(repr(tag_re)) + 1j * mp.mpf(repr(tag_im)))
    K = K * mp.e ** tag_qrem
    K = K * mp.e ** tag_qext
    return K


# (the K fingerprint e^{-1.508628600e9} is independent of the
#  exact tail digits at this level; the exponent real-parts below
#  carry the fingerprint)
mp.dps = 60
lm60 = D38.logmain25212(mp.mpc(0.5, mp.mpf(repr(TF))))
(la, ar, _b1, _b2, _b3) = D38.prod_with_budget(TF)
print("  qrem re = %s" % mp.nstr(mp.re(qrem60), 12), flush=True)
print("  qext re = %s" % mp.nstr(mp.re(qext60), 12), flush=True)
print("  (qext - qrem) re = %s  <- the piece (1e18,1e30] by difference"
      % mp.nstr(mp.re(qext60 - qrem60), 12), flush=True)
outA = dump("A_verbatim", pA)

# ---- B) patched composition (adjacent ext piece) -------------------------
_orig_quad_pair = D38.quad_pair


def quad_pair_adjacent(Targ, tf, audit=False):
    from mpmath import mp as _mp
    _mp.dps = 60
    s = _mp.mpc(0.5, _mp.mpf(repr(tf)))
    f = D38._kint(s)
    lo = repr(Targ.G_LAST)

    def sec(l, h, n, d):
        return D38.quad_section(f, l, h, n, d)

    rem30 = sec(lo, D38.REMHI, 400, 30)
    ext30 = sec(D38.REMHI, D38.REMHI2, 400, 30)   # ADJACENT piece
    rem60 = sec(lo, D38.REMHI, 400, 60)
    ext60 = sec(D38.REMHI, D38.REMHI2, 400, 60)
    B_qrem = abs(rem30 - rem60)
    B_qext = abs(ext30 - ext60)
    aud = None
    if audit:
        rem800 = (sec(lo, D38.REMHI, 800, 30),
                  sec(lo, D38.REMHI, 800, 60))
        ext800 = (sec(D38.REMHI, D38.REMHI2, 800, 30),
                  sec(D38.REMHI, D38.REMHI2, 800, 60))
        aud = {"rem": [float(abs(corners_r[i] - corners_r[j]))
                       for i in range(4) for j in range(i + 1, 4)]
               for corners_r in []} or None
        aud = {"rem": [float(abs(rem800[0] - rem800[1])),
                       float(abs(rem30 - rem800[0])),
                       float(abs(rem60 - rem800[1])),
                       float(abs(rem30 - rem60))],
               "ext": [float(abs(ext800[0] - ext800[1])),
                       float(abs(ext30 - ext800[0])),
                       float(abs(ext60 - ext800[1])),
                       float(abs(ext30 - ext60))]}
    return (rem30, ext30, rem60, ext60, B_qrem, B_qext, aud)


D38.quad_pair = quad_pair_adjacent
print("B) running day038.cert_point with ADJACENT-pie... "
      "(8-thread GPU)...", flush=True)
pB = D38.cert_point(T, TF, G, audit=False, nthreads=8)
D38.quad_pair = _orig_quad_pair

# K magnitude for B (fixed composition, dps-60):
qrem60b, qext60b, _r, _e, _b1, _b2, _a = quad_pair_adjacent(T, TF, audit=False)
mp.dps = 60
_lm = D38.logmain25212(mp.mpc(0.5, mp.mpf(repr(TF))))
(la, ar, _b1, _b2, _b3) = D38.prod_with_budget(TF)
# re/im: engine totals (quadruple-verified).  The engine's im
#  total ALREADY includes nlt*pi (f64) -- use it as-is:
RE_TAIL = -1519600917.8097972869873047
IM_TAIL = 33332178583.221424
K_B = mp.e ** (_lm + mp.mpf(repr(la)) + 1j * mp.mpf(repr(ar))
               + mp.mpf(repr(RE_TAIL)) + 1j * mp.mpf(repr(IM_TAIL)))
K_B = K_B * mp.e ** qrem60b
K_B = K_B * mp.e ** qext60b
outB = dump("B_adjacent_fixed", pB)
print("  |Kfixed|      = %s  (CRT reference 1.2937556)"
      % mp.nstr(abs(K_B), 12), flush=True)
print("  phase K-z     = %s rad (CRT: anti-parallel -> residf 2.6013)"
      % mp.nstr(mp.arg(K_B) - mp.arg(mp.zeta(mp.mpc(0.5, mp.mpf(repr(TF))))), 6),
      flush=True)

res = {
    "A_verbatim": outA,
    "B_adjacent_fixed": outB,
    "K_fixed_abs": mp.nstr(abs(K_B), 15),
    "ledger_p01": LEDGER,
    "crt_p01": CRT,
    "verdict_A": ("reproduces ledger"
                  if abs(outA["mnew"] - LEDGER["mnew"]) < 1e-9
                  else "does NOT reproduce ledger"),
    "verdict_B": ("recovers CRT margin"
                  if abs(outB["mnew"] - CRT["mnew"]) < 5e-4
                  else "does NOT recover CRT margin"),
}
with open(os.path.join(OUT, "RESULT_day049e.json"), "w") as f:
    json.dump(res, f, indent=1)
print("RESULT:", res["verdict_A"], "|", res["verdict_B"], flush=True)
print("DONE", flush=True)
