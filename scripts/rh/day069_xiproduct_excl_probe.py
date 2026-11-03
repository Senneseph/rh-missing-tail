#!/usr/bin/env python3
"""day069 - 0273a: the xi-product exclusion probe at FACE heights
(route (b), after 0272; design: docs/ROUTE-B-0273-DESIGN-2026-11-03.md).

The mechanism (proved non-circular in the design doc): the Hadamard
product  xi(s) = xi(0) * prod_rho (1 - s/rho) e^{s/rho}  (xi(0) = -1/2,
rho over all nontrivial zeros) gives the identity

  log|zeta(s)| = log(1/2) - log|0.5 s (s-1) pi^{-s/2} Gamma(s/2)|
                 + S_known(s)  +  U(s)

  S_known(s) := sum_{0 < g <= 3e9}  f(g; s),   (KNOWN zeros, bit-pinned
               Platt record 0263; project zero tables, full coverage
               [14.13, 3.0013e9], streamed in float64 chunks)
                 f(g;s) = [log|1-s/r| + Re(s/r)] + [log|1-s/rb| + Re(s/rb)]
                           r = 1/2 + i g,  rb = 1/2 - i g
  U(s)        := the sum of the same f over zeros with g > 3e9
                 (UNKNOWN above tPT2: bounded, not evaluated).

  U(s) splits:  U = T1 (g in (3e9, tPT2]) + T2 (g > tPT2).  Each is
  split into a SMOOTH R-vM-density quad (exact, added to S_known to
  form K(s)) plus a FLUCTUATION  (sum - integral), bounded by
  integration by parts with  N(g,g+1] <= A0 log g  (Titchmarsh 9.2,
  as cited in docs/W2-LEAN-PLAN.md from Zeta23-RvM; A0 = 3.4):
      B_T1 = B1 (2 max|f| + Int|f'|),   B1 = A0 log(tPT2)
      B_T2 = B1 (f(tPT2) + Int_{tPT2}^{inf} |f'|)
      B_unk(s) = B_T1 + B_T2.

  EXCLUSION (design doc): if  K(s) > B_unk(s)  then  zeta(s) != 0.
  Proof: suppose zeta(s) = 0. For s' -> s, s' not a zero:
  log|zeta(s')| = K(s') + U(s') >= K(s') - B_unk(s') -> K(s) - B_unk(s)
  > 0, so |zeta(s')| > e^{K(s)-B_unk(s)} > 1 near s - contradicting
  zeta(s) = 0 (|zeta| -> 0). Non-circular: no knowledge of unknown zero
  positions beyond the Titchmarsh 9.2 disk bound; no RH assumption.

This probe measures, at sample points s in the face (t = tPT2,
sigma in {a, 0.25, 0.40, 0.49}, a = 0.1252270103 = 1-colletUpper):
  (a) K(s) = streamed S_known + smooth T1 quad + smooth T2 quad +
      Gamma/phi term   (float64 streaming + dps-50 mpmath);
  (b) B_unk(s) (the worst-case Titchmarsh-9.2 fluctuation bound);
  (c) the ACTUAL U(s) := log|zeta(s)| - K(s) (dps-50) - verified
      against B_unk (|U_actual| must be <= B_unk: the bound is valid);
  (d) the margin  K(s) - B_unk(s)  > 0  <=>  EXCLUDED at s.

Also: the empirical fluctuation B_emp on the last KNOWN band
(3e9 - 1.6e7 .. 3e9): max |N_data(g, g+D) - Int rho D|, D in
{100, 1000} - the realistic (non-worst-case) scale of the bound.

No RH claim: this is a measurement of whether the exclusion margin is
positive; a negative margin everywhere is itself the (useful) record
that the known field alone does not discharge the face.
"""
import numpy as np
import mpmath as mpm
import math
import os
import sys
import time

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)

TPT2 = mpm.mpf("3000175332800")
A0 = mpm.mpf("3.4")
SIGMA_A = mpm.mpf("0.1252270103")   # = 1 - colletUpper (0269)

# ---- coverage: contiguous known zeros [14.13, 3.0013e9] ----
COVERAGE = [
    ("txt",  "zeros_T10000000_ext_full.txt"),          # [14.13, 1e7]
    ("lshard88",   "lshards/zeros_8846000.dat"),       # [8.846e6, ..]
    ("lshard109",  "lshards/zeros_10946000.dat"),
    ("lshard130",  "lshards/zeros_13046000.dat"),
    ("lshard151",  "lshards/zeros_15146000.dat"),
    ("lshard172",  "lshards/zeros_17246000.dat"),
    ("lshard193",  "lshards/zeros_19346000.dat"),
    ("lshard214",  "lshards/zeros_21446000.dat"),
    ("lshard235",  "lshards/zeros_23546000.dat"),
    ("lshard256",  "lshards/zeros_25646000.dat"),
    ("lshard277",  "lshards/zeros_27746000.dat"),
    ("lshard298",  "lshards/zeros_29846000.dat"),      # -> ~3.2e7
    ("f64r", "hi1e9/zeros_hi31946e6_to_1e9.f64"),      # [3.1946e7, 1.0063e9]
    ("f64r", "hi1e9/zeros_1002e6_to_2000e6.f64"),      # [1.0021e9, 2.0017e9]
    ("f64r", "hi3e9/zeros_2002e6_to_3000e6.f64"),      # [2.0017e9, 2.9992e9]
    ("f64r", "hi3e9/extra/zeros_2999e6_to_3000e6.f64"),  # -> 3.0013e9
]

def load_gz(name, kind, gmax=3.002e9):
    if kind == "txt":
        a = np.loadtxt(name)
    elif kind.startswith("lshard"):
        a = load_lshard(name)
    elif kind == "f64r":
        a = np.fromfile(name, dtype=np.float64)
    else:
        raise ValueError(kind)
    a = a[np.isfinite(a)]
    a = a[(a > 14.0) & (a < gmax)]
    return a

# ---------- f-pair in numpy ----------
def fpair_chunk(g, sr, t, a):
    """f(g; s) explicit real form: s = sr + i t, a = 0.5 - sr.
    f = 0.5 ln(((a^2+(g-t)^2)/(0.25+g^2)))
      + 0.5 ln(((a^2+(g+t)^2)/(0.25+g^2)))
      + sr/(0.25+g^2)
    (== [log|1-s/r| + Re(s/r)] + [log|1-s/rb| + Re(s/rb)], identity
    verified against the direct xi product at s = 1/2+50i; the
    E1-Re terms are what make the pair sum convergent)."""
    g2 = g * g
    den = 0.25 + g2
    A = (a * a + (g - t) ** 2) / den
    B = (a * a + (g + t) ** 2) / den
    return 0.5 * (np.log(A) + np.log(B)) + sr / den

def load_lshard(path):
    """LMFDB .dat block format (day-023 reader): u64 nblk at offset 0, then
    per block [t0 f64][t1 f64][Nt0 u64][Nt1 u64] followed by (Nt1-Nt0)
    13-byte records: Z (288 bits), v = t0 + Z * 2^-101.  Vectorized parse."""
    import struct as _st
    d = open(path, "rb").read()
    (nblk,) = _st.unpack_from("Q", d, 0)
    off = 8
    out = []
    for _ in range(nblk):
        t0, t1, Nt0, Nt1 = _st.unpack_from("<ddQQ", d, off)
        off += 32
        cnt = Nt1 - Nt0
        buf = d[off:off + 13 * cnt]
        off += 13 * cnt
        b = np.frombuffer(buf, dtype=np.uint8).reshape(-1, 13)
        lo = np.frombuffer(b[:, 0:8].tobytes(), dtype="<u8").astype(np.float64) * (2.0 ** -101)
        mid = np.frombuffer(b[:, 8:12].tobytes(), dtype="<u4").astype(np.float64) * (2.0 ** -37)
        hi = b[:, 12].astype(np.float64) * (1.0 / 32.0)
        out.append(t0 + lo + mid + hi)
    return np.concatenate(out) if out else np.array([])


STREAM_CHUNK = 1 << 26   # 67M ~ 536MB per chunk

def stream_known_sum(sr, si, gmax=3.002e9):
    tot = np.float64(0.0)
    ntot = 0
    for (kind, name) in COVERAGE:
        if kind == "txt":
            a = np.loadtxt(name)
            a = a[(a > 14.0) & (a < gmax)]
        elif kind == "f64r":
            a = None
        else:  # lshard
            sz = os.path.getsize(name)
            n = (sz - 16) // 8
            a = None
        if a is not None:
            for i0 in range(0, a.size, STREAM_CHUNK):
                c = a[i0:i0 + STREAM_CHUNK]
                c = c[np.isfinite(c)]
                c = c[(c > 14.0) & (c < gmax)]
                if c.size:
                    tot += np.sum(fpair_chunk(c, sr, si), dtype=np.float64)
                    ntot += c.size
            continue
        # stream from disk in chunks
        if kind == "lshard":
            pass
    return float(tot), int(ntot)


def main():
    print("0273a: xi-product exclusion probe at face heights (t = tPT2)")
    print(f"tPT2 = {float(TPT2):.9g}")
    print()

    # ---------- empirical fluctuation on the last known band ----------
    print("empirical fluctuation (known band 3e9 - 1.6e7 .. 3e9):")
    sz = os.path.getsize("hi3e9/zeros_2002e6_to_3000e6.f64")
    ntot = (sz - 0) // 8
    gmax_bytes = 8 * 50000000  # last 50M zeros
    a = np.fromfile("hi3e9/zeros_2002e6_to_3000e6.f64", dtype=np.float64,
                    offset=ntot * 8 - gmax_bytes, count=50000000)
    if a[0] > 2.9e9:
        a = a[np.isfinite(a)]
    for D in (100.0, 1000.0):
        # grid of g at step 1.0 over the band
        g0 = float(np.floor(a[0])) + 100
        g1 = float(a[-1]) - 100
        gs = np.arange(g0, float(a[-1]) - D, 1.0)
        cnt = np.searchsorted(a, gs + D, side="right") - np.searchsorted(a, gs, side="left")
        # integral of rho over (g, g+D] (trapezoid)
        rho = lambda x: np.log(x / (2 * np.pi)) / (2 * np.pi)
        integ = rho(gs + D) * D  # rho slowly varying: mid-point approx
        err = np.abs(cnt - integ)
        print(f"  D = {D:6.0f}:  max|N_data - Int rho| = {err.max():.4f}   "
              f"(band {float(a[0]):.6g} .. {float(a[-1]):.6g}, {a.size} zeros)")
    print()

    def phi_term_mpmath(s):
        return mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2)
                        * mpm.gamma(s / 2))

    def f_mpmath(g, s):
        """Explicit real form (rational + logs), no branch issues:
        with a = 0.5 - sr (distance of s from the line in re),
        f(g) = 0.5*ln( ((a^2 + (g-t)^2) + ... ) )  - see derivation:
        |1-s/r|^2 = ((0.5-sr)^2 + (g-t)^2) / (0.25+g^2)
        |1-s/rb|^2 = ((0.5-sr)^2 + (g+t)^2) / (0.25+g^2)
        Re(s/r) + Re(s/rb) = sr/(0.25+g^2)
        """
        sr = float(s.real)
        t = float(s.imag)
        a = mpm.mpf("0.5") - sr
        g2 = g * g + mpm.mpf("0.25")
        A = (a * a + (g - t) ** 2) / g2
        B = (a * a + (g + t) ** 2) / g2
        return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2

    def fpabs_mpmath(g, s):
        return mpm.fabs(f_mpmath(g, s))

    def fprime_mpmath(g, s):
        dg = g * mpm.mpf("1e-9")
        return (f_mpmath(g + dg, s) - f_mpmath(g, s)) / dg


    def rho_mpmath(g):
        return mpm.log(g / (2 * mpm.pi)) / (2 * mpm.pi)

    def U_tail(s, g0):
        """Smooth unknown-side integral Int_{g0}^{inf} f rho dg (0273a
        fixed version): finite dip-resolved quad g0..16t + exact 2nd-order
        analytic tail (f ~ c4/g^2 for g >> t; c4 = a^2-1/4-t^2+sr) +
        numerical O(t^4/g^4) correction quad on [16t, 256t].  Verified
        vs the xi-pinned U_true at t = 1e9 to the data floor (1.4e5)."""
        t = TPT2
        sr = mpm.mpf(str(float(s.real)))
        a = mpm.mpf("0.5") - sr
        gc = mpm.mpf(16) * t
        pts = [g0 * (gc / g0) ** (mpm.mpf(j) / 2000) for j in range(2001)]
        for m8 in range(int(t - 200), int(t + 201), 2):
            if g0 < m8 < gc:
                pts.append(mpm.mpf(m8))
        pts = sorted(set(pts))
        fin = mpm.quad(lambda g: f_mpmath(g, s) * rho_mpmath(g), pts)
        c4 = a * a - mpm.mpf("0.25") - t * t + sr
        ana = (c4 / (2 * mpm.pi)) * (1 + mpm.log(gc / (2 * mpm.pi))) / gc
        corr_pts = [gc * (mpm.mpf(256) ** (mpm.mpf(j) / 12)) for j in range(13)]
        corr = mpm.quad(lambda g: (f_mpmath(g, s) - c4 / (g * g))
                        * rho_mpmath(g), corr_pts)
        return fin + ana + corr

    def smooth_T1(s):
        t = float(s.imag)
        # log-spaced + dense linear breakpoints around the dip at g = t
        pts = []
        k = 300
        for j in range(k + 1):
            pts.append(mpm.mpf("3e9") * (TPT2 / mpm.mpf("3e9")) ** (mpm.mpf(j) / k))
        for m8 in range(-80, 81, 1):
            pts.append(TPT2 + mpm.mpf(m8))
        pts = sorted(set(pts))
        pts = [p for p in pts if p > mpm.mpf("3e9") * (1 + 1e-9)]
        pts = [p for p in pts if p <= TPT2]
        return mpm.quad(lambda g: f_mpmath(g, s) * rho_mpmath(g), pts)

    def smooth_T2(s):
        t = float(s.imag)
        pts = [TPT2, TPT2 * 2, TPT2 * 4, TPT2 * 8, TPT2 * 16, TPT2 * 32]
        return mpm.quad(lambda g: f_mpmath(g, s) * rho_mpmath(g), pts)

    def bound_terms(s, g1=mpm.mpf("3e9")):
        """B_T1 = B1*(|f(g1)| + |f(t2)| + TV(f) on (g1, t2]) with
        B1 = A0*log(tPT2) (Titchmarsh 9.2 count error B); same for T2
        on (t2, inf) (f(t2) shared).  TV via dense |f'| quad (the dip
        at g ~ t is O(1)-wide in g - resolved by a fine linear grid)."""
        B1 = A0 * mpm.log(TPT2)
        t = float(s.imag)
        fg1 = mpm.fabs(f_mpmath(g1, s))
        ft2 = mpm.fabs(f_mpmath(TPT2, s))
        # TV on (g1, TPT2]: log grid + fine linear grid over the dip
        pts = []
        k = 200
        for j in range(k + 1):
            pts.append(g1 * (TPT2 / g1) ** (mpm.mpf(j) / k))
        for m8 in range(-200, 201, 2):
            pts.append(TPT2 + mpm.mpf(m8))
        pts = sorted(set(p for p in pts if g1 < p <= TPT2))
        tv1 = mpm.quad(lambda g: mpm.fabs((f_mpmath(g + g * 1e-9, s)
                                           - f_mpmath(g, s)) / (g * 1e-9)), pts)
        pts2 = [TPT2 + mpm.mpf(m8) for m8 in range(0, 201, 2)]
        pts2.append(TPT2 * 2)
        # for g > t2 the f' ~ 2t/g^2 scale: fine grid then log grid
        tail_pts = [TPT2 * (2 ** j) for j in range(0, 6)]
        tv2 = mpm.quad(lambda g: mpm.fabs((f_mpmath(g + g * 1e-9, s)
                                           - f_mpmath(g, s)) / (g * 1e-9)),
                       tail_pts)
        # add the dip-exit segment (TPT2+200 .. TPT2*2) already covered
        BT1 = B1 * (fg1 + ft2 + tv1)
        BT2 = B1 * (ft2 + tv2)
        return BT1, BT2, B1

    sigmas = [SIGMA_A, mpm.mpf("0.25"), mpm.mpf("0.40"), mpm.mpf("0.49")]
    print(f"{'sigma':>12} | {'K(s)':>12} | {'B_unk':>12} | U_actual:14 | "
          f"|U|<=B:6 | zeta-excluded:12 | |zeta(s)|:12")
    worst = {}
    # exact last known zero (the deduped union ends at the last value of
    # the final hi file): U_tail must start HERE, not at 3e9, or the
    # (3e9, GLAST] zeros are double-counted (smooth + discrete).
    _ex = "hi3e9/extra/zeros_2999e6_to_3000e6.f64"
    _nrec = (os.path.getsize(_ex) - 16) // 8
    GLAST = float(np.fromfile(_ex, dtype=np.float64,
                              offset=16 + (_nrec - 1) * 8, count=1)[0])
    print(f"GLAST (last known zero) = {GLAST!r}\n")
    for sm in sigmas:
        t0 = time.time()
        sr = float(sm)
        si = float(TPT2)
        s = mpm.mpc(sr, si)
        # (a) streamed known sum (float64), DEDUPED across the band
        # overlaps. Protocol (files ascending, each internally sorted):
        # file i keeps zeros v with b_{i-1} < v <= b_i where b_i is the
        # FIRST zero of file i (so a zero equal to a boundary is owned
        # by the file that starts at it). The hi1e9 pair overlaps by
        # 15.75M zeros without this; the boundary values are exact
        # float64 reads, so the ownership is deterministic.
        def _first_value(kind, name):
            if kind == "txt":
                return float(np.loadtxt(name)[:1][0])
            if kind == "f64r":
                return float(np.fromfile(name, dtype=np.float64, offset=16,
                                         count=1)[0])
            return float(load_lshard(name)[0])
        bvals = [_first_value(k, n) for (k, n) in COVERAGE]
        tot = np.float64(0.0)
        ntot = 0
        for idx, (kind, name) in enumerate(COVERAGE):
            # file idx owns zeros v with bvals[idx] <= v < bvals[idx+1]
            lo = bvals[idx]
            hi = bvals[idx + 1] if idx + 1 < len(COVERAGE) else 3.002e9
            if kind == "txt":
                arr = np.loadtxt(name)
                arr = arr[np.isfinite(arr)]
                arr = arr[(arr >= lo) & (arr < hi)]
                it = (i for i in range(0, arr.size, STREAM_CHUNK))
                for i0 in it:
                    c = arr[i0:i0 + STREAM_CHUNK]
                    if c.size:
                        tot += np.sum(fpair_chunk(c, sr, si, 0.5 - sr),
                                      dtype=np.float64)
                        ntot += c.size
                continue
            if kind == "f64r":
                sz = os.path.getsize(name)
                n = (sz - 16) // 8
                for i0 in range(0, n, STREAM_CHUNK):
                    c = np.fromfile(name, dtype=np.float64, offset=16 + i0 * 8,
                                    count=min(STREAM_CHUNK, n - i0))
                    c = c[np.isfinite(c)]
                    c = c[(c >= lo) & (c < hi)]
                    if c.size:
                        tot += np.sum(fpair_chunk(c, sr, si, 0.5 - sr),
                                      dtype=np.float64)
                        ntot += c.size
                continue
            # lshard: LMFDB .dat block format (u64 nblk + [t0,t1,Nt0,Nt1]
            # + 13-byte 288-bit zero records; NOT a raw f64 stream)
            arr = load_lshard(name)
            arr = arr[(arr >= lo) & (arr < hi)]
            for i0 in range(0, arr.size, STREAM_CHUNK):
                c = arr[i0:i0 + STREAM_CHUNK]
                if c.size:
                    tot += np.sum(fpair_chunk(c, sr, si, 0.5 - sr),
                                  dtype=np.float64)
                    ntot += c.size
        # (a) mpmath smooth + gamma
        mpm.mp.dps = 50
        Usm = U_tail(s, mpm.mpf(str(GLAST)))
        phi = mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2)
                      * mpm.gamma(s / 2))
        K = float(tot) + float(Usm) - float(mpm.re(phi)) \
            + float(mpm.log(mpm.mpf("0.5")))
        # (b) bound
        BT1, BT2, B1 = bound_terms(s)
        Bunk = float(BT1 + BT2)
        # (c) actual |zeta| (dps-50)
        zv = mpm.zeta(s)
        absz = mpm.fabs(zv)
        logabsz = float(mpm.log(absz))
        Uact = logabsz - K
        ok = "yes" if abs(Uact) <= Bunk else "NO"
        excl = "EXCLUDED" if K > Bunk else "-"
        print(f"{float(sr):>12.9f} | {float(K):+12.6f} | {float(Bunk):+12.6f} | "
              f"{float(Uact):+14.6f} | {ok:6} | {excl:12} | {float(absz):.6e}   "
              f"({int(time.time() - t0)}s, {ntot} zeros)")
        sys.stdout.flush()
    print()
    print("interpretation:")
    print(" - U_actual must land inside B_unk (bound validity check).")
    print(" - EXCLUDED at s means the known field alone (Titchmarsh-9.2")
    print("   unknown side) disproves a zero at s. If never excluded, the")
    print("   known field alone does not discharge the face (0273c: the")
    print("   psi-sup lever or the 1/8-sliver density arithmetic).")


if __name__ == "__main__":
    main()
