#!/usr/bin/env python3
"""day032 -- D(t) RE-CHANNEL: the IBP re-channel refinement (queue item 5).

day029_dcheck_splice found |D| = O(1) at every height: the im channel
is exactly pi*wband (wband = int rho - N_banded = -0.106322, a
computable constant), but the re channel carries a measured O(0.4-1.5)
offset.  The named refinement: redo the RE channel as an IBP against
the full counting function so the O_w common model error cancels by
construction and only the O(1e-4)-scale lattice random walk remains.

Exact identity (Stieltjes IBP; holds at every height incl. split mode):

  D_re(t) = S_re(t) - int_{G1}^{G2} f_rho(g; t) dg
          = Wb * f(b)  -  Int W(g) f'(g; t) dg

  f(g; t)   = re_p(g; t) = log|g^2 - t^2| - log(g^2 + 1/4)
              + 1/(2 (g^2 + 1/4))     (the kernel's own branch)
  N(g)      = #{ zeros g_i in (G1, g] }      (true count, step)
  R(g)      = int_{G1}^{g} rho(h) dh         (smooth model count)
  W(g)      = N(g) - R(g)                     (the lattice walk)
  Wb        = W(G2) = N_band - R(G2)          (closed form)
  b = G2 (the last zero IS G2, so the right-endpoint mass lands
  exactly on the boundary term -- no half-mass convention needed).

  Derivation: S_re = int f dN = N f(b) - int N f'  (Stieltjes IBP,
  N right-continuous step);  int N f' = N f(b) - S_re (weighted
  telescoping, EXACT finite sum);  int R f' = R(b) f(b) - int f rho
  (IBP on the smooth R; in split mode the R(t)*f(t) = 0*(-inf)
  boundary terms cancel by continuity of R).  Hence
  D_re = Wb f(b) - Int W f', with
  Int W f' = [N f(b) - S_re] - [R(b) f(b) - int f rho]  (exact).

Measured decomposition per height t (Iwalk := Int W f' below):
  D_re   = B_end - Iwalk          (B_end = Wb*f(b), closed form)
  Iwalk  = L - Q                  (L = N*f(b) - S_re, pure lattice
                                   fsum;  Q = R(b)*f(b) - int f_rho,
                                   dps-30 quad -- the O_w model
                                   error cancels by construction)
  Iwalk  = -Fsum - Rmndr          (Fsum = the lattice random walk
                                   content: sum (W - Wbar)*dF over
                                   the zeros, Wbar = the DATA mean of
                                   W at the zeros;  Rmndr = drift +
                                   ramp leftover + (in split mode)
                                   the log-singularity structure)
  Prediction (PLAIN mode, t > G2): |Fsum| ~ O(1e-4) (sqrt(N) |f'| gap
  walk level), Rmndr ~ O(0.1-0.4) smooth, B_end ~ O(0.1) -- together
  reproducing the day029 D_re values to quad noise.  SPLIT mode
  (t in (G1, G2]) additionally carries the log|t^2 - g^2| splice
  structure in Fsum/Rmndr at O(1) -- no O(1e-4) claim there.

Data/kernel reuse: day029_s1gap_hi.TailHi2 (the hi-run band), the
day029 pairlog branch (re part only here), the v3 singularity-aware
quad at the split-mode heights (t in (G1, G2]).  Float64 fsum for
all per-zero sums (per-chunk exact partials, exact outer fsum);
dps-30 mpmath for the endpoint closed forms and the model integral.
"""
import mpmath as mpm
mpm.mp.dps = 30
import time
import math
import sys
import numpy as np
sys.path.insert(0, '.')
import day029_s1gap_hi as H

T = H.TailHi2()
G1 = float(T.old[-1])          # 1.006345999849...e9
G2 = float(T.G_LAST)           # 2.001745999627...e9
Z2 = T.new[T.new0:]            # deduped new band = (G1, G2]
N = int(Z2.size)
EPS = mpm.mpf("1e-8")
NPTS = 400
TWO_PI = 2.0 * math.pi
CH = 33_000_000                # chunk size (memory discipline)


# ---------- closed-form model pieces --------------------

def R_of_vec(g):
    """R(g) = int_{G1}^{g} rho in float64 (vectorized; per-zero W)."""
    return (g * (np.log(g / TWO_PI) - 1.0)
            - G1 * (math.log(G1 / TWO_PI) - 1.0)) / TWO_PI


def f_of(g, t):
    """f(g; t) = re_p(g; t) in float64 (the kernel's own branch)."""
    A = g * g + 0.25
    return (np.log(np.abs(g * g - t * t)) - np.log(A) + 0.5 / A)


def f_of_m(t, g):
    """f(g; t) in mpmath dps-30 (endpoint values only)."""
    gm = mpm.mpf(repr(g))
    tm = mpm.mpf(repr(t))
    A = gm * gm + mpm.mpf("0.25")
    return mpm.log(abs(gm * gm - tm * tm)) - mpm.log(A) + 1 / (2 * A)


def geom(lo, hi, n):
    return [lo * (hi / lo) ** (mpm.mpf(j) / mpm.mpf(n))
            for j in range(n + 1)]


def sing_safe_int_r(t, a, b):
    """quad of f(g;t)*rho(g) over [a, b] in dps-30 (real path);
    v3-aware when t in (a, b): split at t +- EPS + exact annulus of
    the log|t^2 - g^2| singularity (symmetric, rho ~ rho_t)."""
    a = mpm.mpf(repr(a))
    b = mpm.mpf(repr(b))
    tm = mpm.mpf(repr(t))

    def fr(gg):
        A = gg * gg + mpm.mpf("0.25")
        f = (mpm.log(abs(gg * gg - tm * tm)) - mpm.log(A)
             + 1 / (2 * A))
        rho_t = mpm.log(gg / (2 * mpm.pi)) / (2 * mpm.pi)
        return f * rho_t

    if not (a + EPS < tm - EPS < b):
        return float(mpm.quad(fr, geom(a, b, NPTS)))
    rho_t = mpm.log(tm / (2 * mpm.pi)) / (2 * mpm.pi)
    ann = rho_t * (2 * EPS * mpm.log(2 * tm)
                   + 2 * EPS * (mpm.log(EPS) - 1))
    gL = geom(a, tm - EPS, NPTS)
    gR = geom(tm + EPS, b, NPTS)
    return float(mpm.quad(fr, gL) + mpm.quad(fr, gR) + ann)


def stream_pass(t):
    """Streaming single pass over the band (O(chunk) memory):
    returns (S_re, Wtot, WdF, f1) with
      S_re  = fsum f(g_i);  Wtot = fsum W_i,  W_i = i - R(g_i) (1-indexed)
      WdF   = fsum W_i * (f_{i+1} - f_i) over i = 1..N-1
      f1    = f(g_1)
    Fsum = WdF - Wbar*(f(G2) - f1),  Wbar = Wtot/N  (telescoping
    sum of dF = f(G2) - f(g_1), exact)."""
    parts_S, parts_W, parts_P = [], [], []
    lastf = None
    f1 = None
    j = 0
    while j < N:
        c = Z2[j:j + CH].astype(np.float64, copy=False)
        fv = np.asarray(f_of(c, t), dtype=np.float64)
        i0 = j + 1
        idx = np.arange(i0, i0 + len(c), dtype=np.float64)
        Wv = idx - R_of_vec(c)
        if f1 is None:
            f1 = float(fv[0])
        parts_S.append(math.fsum(fv))
        parts_W.append(math.fsum(Wv))
        if lastf is not None:
            d0 = float(fv[0] - lastf)
            parts_P.append(float(Wv[0]) * d0)
        if len(fv) > 1:
            dd = fv[1:] - fv[:-1]
            parts_P.append(float(np.sum(Wv[:-1] * dd)))
        lastf = float(fv[-1])
        j += CH
    return (math.fsum(parts_S), math.fsum(parts_W),
            math.fsum(parts_P), f1)


if __name__ == "__main__":
    t0 = time.time()
    print("D(t) RE-CHANNEL IBP refinement  (day032, mpmath %s, dps-30)"
          % mpm.__version__, flush=True)
    print("G1 = %.13f   G2 = %.13f   N_band = %d" % (G1, G2, N),
          flush=True)
    Nf = mpm.mpf(N)
    Rb = (mpm.mpf(repr(G2))
          * (mpm.log(mpm.mpf(repr(G2)) / (2 * mpm.pi)) - 1)
          - mpm.mpf(repr(G1))
          * (mpm.log(mpm.mpf(repr(G1)) / (2 * mpm.pi)) - 1)) / (2 * mpm.pi)
    Wb = Nf - Rb
    print("R(G2) = %.9f   Wb = N - R(G2) = %.9f   (day029 wband = "
          "-0.106322 = R(G2) - N)" % (float(Rb), float(Wb)), flush=True)

    print("\nidentity per height:  D_re = B_end - Iwalk,  Iwalk = L - Q;"
          "  walk split:  -Iwalk = Fsum + Rmndr", flush=True)
    print("t         D_re        B_end     -Iwalk        L           Q"
          "        Fsum        Rmndr      |check|   mode", flush=True)
    for t in [1.5e9, 2.5e9, 4e9, 1e10]:
        t1 = time.time()
        S_re, Wtot, WdF, f1 = stream_pass(t)
        intf_rho = sing_safe_int_r(t, G1, G2)
        fG2m = f_of_m(t, G2)
        fG2 = float(fG2m)
        B_end = float(Wb * fG2m)
        L = N * fG2 - S_re
        Q = float(Rb * fG2m) - intf_rho
        Iwalk = L - Q
        D_re = S_re - intf_rho
        check = D_re - (B_end - Iwalk)
        Wbar = Wtot / N
        Fsum = WdF - Wbar * (fG2 - f1)
        Rmndr = -Iwalk - Fsum
        mode = "split" if G1 < t < G2 else "plain"
        print("%8.4g %12.9f %12.9f %12.9f %14.6f %14.6f %12.4e "
              "%12.4e %9.1e   %s (Wbar = %.6f, %.0fs)"
              % (t, D_re, B_end, -Iwalk, L, Q, Fsum, Rmndr, abs(check),
                 mode, Wbar, time.time() - t1), flush=True)
    print("\nDONE (%.0fs total)" % (time.time() - t0), flush=True)
