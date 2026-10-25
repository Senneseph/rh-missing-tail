"""s34a: table generator for the C quad Riemann-Siegel zeta channel.

The C program (scripts/rh/zetac/zetac.c) evaluates

    Z(t) = Re( 2 * exp(i*theta) * ( S1 + rssum * S3factor ) )

with the exact form of mpmath's Arias de Reyna implementation
(mpmath/functions/rszeta.py, Rzeta_simul at sigma = 1/2):

    a      = sqrt(t/(2*pi))          (the RS scale)
    N      = floor(a)
    p      = 1 - 2*(a - N)
    S1     = sum_{j=1}^{N} j^(-1/2 - i t)    (the big sum, streamed)
    arg3   = (t/2)*ln(t/(2*pi)) - t/2 - pi/8
    S3     = (-1)^(N-1) * a^(-1/2) * exp(-i*arg3)
    rssum  = sum_{n=0}^{L-1} sum_{k=0}^{floor(3n/2)}
             d[n,k] * Fp[3n-2k] / (pi^(2n-k) * (2i)^k) * a^(-n)
    Fp[m]  = sum_{k=0}^{2J-m} c[k] * p^k      (Horner; the F-polys)
    theta  = Im logGamma(1/4 + i t/2) - (t/2)*ln(pi)
    |zeta(1/2+it)| = |Z(t)|

The parameter chain (eps, L, M, J) and the tables (the complex
Taylor coefficients c[k] of the universal function F, and the
d[n,k] recurrence table at sigma = 1/2) depend on the working
precision and on a = sqrt(t/(2*pi)) ONLY through that chain.
This script reproduces the chain EXACTLY as mpmath computes it
(same formulas, same order, same constants) and dumps:

  * the parameter sets (L, M, J, N) for the target heights,
  * the complex coefficient table c[0..2*Jmax],
  * the d[n,k] table for n = 0..Lmax-1.

Everything is machine-computed - no hand values.  The generator
also self-tests the RECONSTRUCTED formula in Python against
mpmath's own rs_zeta at moderate heights (where N ~ 1e4-2e5 is
affordable) - that self-test validates the formula assembly
(tables, coefficients, factor structure) before any C code runs.
No RH claim; no zeros; a census zeta channel only.
"""
import json
import os
import sys

from mpmath import mp, mpf, mpc, floor, gamma, pi, ln, e, sqrt, exp, im, re, fac
from mpmath.functions.rszeta import _coef

BASE = "/home/jsmille/Projects/rh-missing-tail"
OUT = os.path.join(BASE, "scripts/rh/zetac")

# the working precision of the C channel (quad = 113 bits)
WP = 113
# the precision of the Python self-test (bits)
WPT = 140


def param_chain(t, wp):
    """Replicate the mpmath Rzeta_simul X-side parameter chain at
    sigma = 1/2 (b = 2, c = 9^(1/2)/4.44288, A = 3, B1 = 1).

    Same formulas and same order as mpmath/functions/rszeta.py,
    at working precision wp (bits).  Returns the dict with a, N,
    L, M, J and the eps ladder.
    """
    t = mpf(t)
    orig = mp.prec
    mp.prec = max(wp, 90)
    try:
        a = sqrt(t / (2 * pi))
        xasigma = a ** mpf("0.5")
        A1 = 2 ** (mp.mag(xasigma) - 1)
        eps = 2 ** (-wp)
        eps1 = eps / 6
        eps2 = eps * A1 / 3
        b, c = mpf(2), 3 / mpf("4.44288")
        A, B1 = mpf(3), mpf(1)
        L = 1
        while 3 * c * gamma(L * mpf("0.5")) * (b * a) ** (-L) >= eps2:
            L += 1
        L = max(2, L)
        assert 3 * L < 2 * a * a / 25, "L too large for this t"
        assert 3 * L + 2 + mpf("0.5") >= 0
        eps3 = eps2 / (4 * L)
        eps4 = eps3 / (3 * L)
        aux1 = ln(126.0657606 * A / eps4)
        aux2 = (2 * ln(pi) + ln(B1) + ln(a)) / 3 - ln(2 * pi) / 2
        m = 3 * L - 3
        aux3 = ((ln(gamma(m + 1)) - ln(gamma(m / 3 + 2))) / 2
                - ln(gamma((m + 1) / 2)))
        while aux1 < m * aux2 + aux3 and m > 1:
            m -= 1
            aux3 = ((ln(gamma(m + 1)) - ln(gamma(m / 3 + 2))) / 2
                    - ln(gamma((m + 1) / 2)))
        M = m
        h1 = eps4 / (632 * A)
        h2raw = B1 * a * mpf("126.31337419529260248")
        h2 = h1 * ((h2raw / M ** 2) ** ((M - 1) / 3)) / M
        h3 = min(h1, h2)
        J = 12
        jvalue = (2 * pi) ** J / gamma(J + 1)
        while jvalue > h3:
            J += 1
            jvalue = (2 * pi) * jvalue / J
    finally:
        mp.prec = orig
    return dict(a=a, N=floor(a), eps2=eps2, L=int(L), M=int(M), J=int(J))


def coeff_table(J):
    """c[0..2J] - the complex Taylor coefficients of

        F(z) = (exp(pi i (z^2/2 + 3/8)) - i sqrt(2) cos(pi z/2))
               / (2 cos(pi z)) = sum c_n z^n    (c_odd = 0)

    via mpmath's own _coef (the same machinery the production
    channel uses), at 60-digit precision.
    """
    orig = mp.prec
    mp.prec = 60
    try:
        eps6 = (2 * pi) ** J / (gamma(J + 1) * 3 * J)
        res = _coef(mp, J, eps6)
        newJ, neweps6, c, pipowers = res
        return [c.get(k, mpf(0)) for k in range(0, 2 * J + 1)]
    finally:
        mp.prec = orig


def d_table(L):
    """d[0,n,k] at sigma = 1/2 (psigma = 0), n = 0..L-1."""
    d = {}
    d[(0, 0)] = mpf(1)
    d[(-1, 0)] = mpf(1)
    for n in range(1, L):
        for k in range(0, 3 * n // 2 + 1):
            m = 3 * n - 2 * k
            if m != 0:
                c1 = mpf(1) / (4 * m)
                c3 = -mpf(m + 1)
                val = c3 * d.get((n - 1, k - 2), mpf(0)) + c1 * d.get(
                    (n - 1, k), mpf(0))
            else:
                val = mpf(0)
                for r in range(0, k):
                    add = d.get((n, r), mpf(0)) * fac(2 * k - 2 * r) / fac(k - r)
                    val -= ((-1) ** (k - r)) * add
            d[(n, k)] = val
    return d


G = 30001045999.981975555
TARGETS = (1e8, 3e8, 5e8, 1e9, 1e10, 3e10, 1e11, 3e11,
           1e12, 3e12)  # as t/G
# NOTE: every N must be the EXACT floor(a) at the target height
# (mpmath in param_chain) - decimal x10-scaling of a smaller chain's
# N does NOT preserve floor(a) and breaks the rssum domain (p in
# (-1, 1]) - the 3e21/9e21 chains were once hand-scaled and went
# defective (discovery 0167).


def chains_for(wplist):
    out = {}
    for r in TARGETS:
        t = G * r
        out[t] = param_chain(mpf(t), wplist)
    return out


def dump_tables():
    os.makedirs(OUT, exist_ok=True)
    chains = chains_for(WP)
    for t, ch in chains.items():
        print("t/G = %.3g   t = %.17g   N = %.9e   L = %d  M = %d  J = %d"
              % (t / G, t, ch["N"], ch["L"], ch["M"], ch["J"]))
    Jmax = max(ch["J"] for ch in chains.values())
    Lmax = max(ch["L"] for ch in chains.values())
    print("table sizes: Jmax = %d (c-table 0..%d), Lmax = %d"
          % (Jmax, 2 * Jmax, Lmax))
    print("computing c-table (J = %d) ... " % Jmax, flush=True)
    ctab = coeff_table(Jmax)
    print("computing d-table (L = %d) ... " % Lmax, flush=True)
    dtab = d_table(Lmax)

    # QD constants.  mpmath mpf is an exact dyadic: x._mpf_ =
    # (sign, bits, exponent), value = bits*2^exponent.  hi = x rounded
    # (nearest, ties even) to a 113-bit significand; lo = x - hi the
    # next 113 bits (the remainder is ~|x|*2^-226).  Each part is
    # emitted as (top64, bot, exp): value = (top64*2^49 + bot)*2^exp
    # with top64 < 2^64, bot < 2^49 -- exact in C via two ldexpq adds
    # (no overlap, 113 bits total).
    def qdconst(x):
        (sgn, b, e, _t) = x._mpf_
        assert sgn == 0, "qdconst: positive only"

        def r113(vbits, vexp):
            # v > 0 exact int pair; return (sig113, exp113) nearest
            vbc = vbits.bit_length()
            if vbc <= 113:
                return vbits, vexp
            drop = vbc - 113
            top = vbits >> drop
            lo = vbits - (top << drop)
            mid = 1 << (drop - 1)
            if lo > mid or (lo == mid and (top & 1)):
                top += 1
            return top, vexp + drop

        hi_b, hi_e = r113(b, e)
        # lo = b*2^e - hi_b*2^hi_e = (b - hi_b*2^(hi_e-e))*2^e
        diff = b - (hi_b << (hi_e - e))
        los = 0
        lo_b, lo_e = 0, 0
        if diff > 0:
            lo_b, lo_e = r113(diff, e)
            los = 1
        elif diff < 0:
            lo_b, lo_e = r113(-diff, e)
            los = -1

        def emit(vb, ve):
            return (vb >> 49, vb & ((1 << 49) - 1), ve)

        return (emit(hi_b, hi_e), emit(lo_b, lo_e), 1, los)

    mp.prec = 300
    TWOPY_QD = qdconst(2 * pi)
    PI8_QD = qdconst(pi / 8)
    INV2PI_QD = qdconst(1 / (2 * pi))
    mp.prec = 60


    lines = []
    lines.append("/* zetac_tables.h - generated by s34a_zetac_tables.py */")
    lines.append("/* QD constants: part = (top64*2^49 + bot) * 2^exp */")
    for nm, qd in (("ZETAC_TWOPY", TWOPY_QD),
                   ("ZETAC_PI8", PI8_QD),
                   ("ZETAC_INV2PI", INV2PI_QD)):
        (h, l, sh, sl) = qd
        lines.append("static const unsigned long long %s_U[4] = {%d, %d, "
                     "%d, %d};" % (nm, h[0], h[1], l[0], l[1]))
        lines.append("static const int %s_E[2] = {%d, %d};"
                     % (nm, h[2], l[2]))
        lines.append("static const int %s_S[2] = {%d, %d};"
                     % (nm, sh, sl))
    lines.append("/* c[k] = complex Taylor coefficients of F, k = 0..%d"
                 % (2 * Jmax))
    lines.append("/* 50-digit decimal literals (exact into quad) */")
    lines.append("#define ZETAC_CTAB_LEN %d" % (2 * Jmax + 1))
    lines.append("static const char *ZETAC_CRE[] = {")
    for k in range(0, 2 * Jmax + 1):
        v = ctab[k]
        cr = mp.nstr(re(v), 50) if v != 0 else "0"
        ci = mp.nstr(im(v), 50) if v != 0 else "0"
        lines.append('  "%s", "%s", /* c[%d] */' % (cr, ci, k))
    lines.append("};")
    lines.append("")
    lines.append("#define ZETAC_LMAX %d" % Lmax)
    lines.append("/* the d table: per n, k = 0..floor(3n/2) */")
    lines.append("static const char *ZETAC_DVALS[] = {")
    for n in range(Lmax):
        vals = []
        for k in range(3 * n // 2 + 1):
            v = dtab.get((n, k), mpf(0))
            vals.append(mp.nstr(v, 50) if v != 0 else "0")
        lines.append("  /* n=%d: */ %s," % (n,
                     ", ".join('"%s"' % v for v in vals)))
    lines.append("};")
    lines.append("")
    lines.append("/* target chains: t (f64 value), L, M, J, N */")
    lines.append("struct zchain { double t; int L; int M; int J; unsigned long long N; };")
    lines.append("static const struct zchain ZETAC_CHAINS[] = {")
    for t, ch in chains.items():
        lines.append("  {%r, %d, %d, %d, %dULL}, /* t/G = %.3g */"
                     % (t, ch["L"], ch["M"], ch["J"], int(ch["N"]), t / G))
    lines.append("};")
    idx = 0
    idxs = []
    for n in range(Lmax):
        idxs.append(idx)
        idx += 3 * n // 2 + 1
    lines.append("static const int ZETAC_DIDX[] = {%s};"
                 % ", ".join(str(i) for i in idxs))
    hdr = os.path.join(OUT, "zetac_tables.h")
    open(hdr, "w").write("\n".join(lines) + "\n")
    print("wrote", hdr)

    side = os.path.join(OUT, "zetac_tables.json")
    json.dump(dict(
        G=G, WP=WP, Jmax=Jmax, Lmax=Lmax,
        chains=[dict(t=t, t_over_G=t / G, L=ch["L"], M=ch["M"],
                     J=ch["J"], N=int(ch["N"])) for t, ch in chains.items()],
        ctab=[[mp.nstr(re(c), 50), mp.nstr(im(c), 50)] for c in ctab],
        dtab={"%d:%d" % (n, k):
              (mp.nstr(dtab.get((n, k), mpf(0)), 50)
               if dtab.get((n, k), mpf(0)) != 0 else "0")
              for n in range(Lmax) for k in range(3 * n // 2 + 1)},
    ), open(side, "w"), indent=1)
    print("wrote", side)


def assemble(t, ch, ctab_all, dtab_all):
    """Assemble Z(t) from the dumped tables (Python/mpf version).

    ctab is sliced to the chain's J (the first 2J+1 coefficients),
    dtab sliced to the chain's L.
    """
    J, L, M = ch["J"], ch["L"], ch["M"]
    a, N, p = ch["a"], int(ch["N"]), 1 - 2 * (ch["a"] - ch["N"])
    ctab = ctab_all[:2 * J + 1]
    cc = list(ctab)
    Fp = []
    for m in range(0, M + 1):
        val = mpf(0)
        for k in range(2 * J - m - 1, -1, -1):
            val = val * p + cc[k]
        Fp.append(val)
        for k in range(0, 2 * J - m - 1):
            cc[k] = (k + 1) * cc[k + 1]
    rssum = mpf(0) + 0j * 0
    for n in range(0, L):
        term = mpf(0)
        for k in range(0, 3 * n // 2 + 1):
            dv = dtab_all.get((n, k), mpf(0))
            idx = 3 * n - 2 * k
            Fv = Fp[idx] if idx <= M else mpf(0)
            term += dv * Fv / (pi ** (2 * n - k)) / (mpc(0, 1) * 2) ** k
        rssum += term * a ** (-n)
    return p, Fp, rssum, J


def selftest():
    """Validate the assembled formula against mpmath's own channel.

    At moderate heights (t ~ 6e11..6e12, N ~ 1e5..2e5 - affordable
    as a direct mpf loop at 60 bits).  The assembled Z(t) must
    agree with Re(e^{i theta} zeta(1/2+it)) at dps-80 to the
    expected truncation level (~the eps2 of the self-test chain
    at the self-test working precision).
    """
    Jask = 0
    ct = None
    mp.prec = 140
    dtab_cache = {}

    def getctab(J):
        nonlocal ct
        if ct is None or len(ct) < 2 * J + 1:
            ct = coeff_table(J)
        return ct

    def getdtab(L):
        if L not in dtab_cache:
            dtab_cache[L] = d_table(L)
        return dtab_cache[L]

    for r in (20.0, 50.0, 100.0, 200.0):
        t = mpf(G) * mpf(r)
        ch = param_chain(t, WPT)
        ctab = getctab(ch["J"])
        dt = getdtab(ch["L"])
        p, Fp, rssum, J = assemble(t, ch, ctab, dt)
        a = ch["a"]
        N2 = int(ch["N"])
        s1 = mpc(0, 0)
        for j in range(1, N2 + 1):
            s1 += mpf(j) ** (-mpf("0.5") - 1j * t)
        arg3 = (t / 2) * ln(t / (2 * pi)) - t / 2 - pi / 8
        S3 = ((-1) ** (N2 - 1)) * a ** (-mpf("0.5")) * exp(mpc(0, -arg3))
        theta = im(mp.loggamma(mpf("0.25") + 1j * t / 2)) - ln(pi) / 2 * t
        Z = (2 * exp(mpc(0, theta)) * (s1 + rssum * S3)).real
        # reference: mpmath's own production channel (160 bits)
        mp.prec = 160
        zref = re(mp.rs_zeta(mpf("0.5") + 1j * t) *
                  exp(mpc(0, im(mp.loggamma(mpf("0.25") + 1j * t / 2))
                       - ln(mp.pi) / 2 * t)))
        mp.prec = 140
        print("t/G = %.3g   |Z| = %.15e   ref |Z| = %.15e   "
              "|diff| = %.3e   (N = %d, L = %d, M = %d, J = %d)"
              % (float(t) / G, abs(Z), abs(zref), abs(Z - zref),
                 N2, ch["L"], ch["M"], ch["J"]))


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        selftest()
    else:
        dump_tables()
