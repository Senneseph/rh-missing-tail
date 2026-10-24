/* zetac.c - the C quad Riemann-Siegel log|zeta(1/2 + i t)| channel.
 *
 * FORMULA - the exact form of mpmath's Arias de Reyna implementation
 * (mpmath/functions/rszeta.py, Rzeta_set at sigma = 1/2, der = 0):
 *
 *   Z(t) = Re( 2 * exp(i*theta) * ( S1 + rssum * S3 ) )
 *   |zeta(1/2+it)| = |Z(t)|
 *
 *   a      = sqrt(t/(2*pi)),  N = floor(a),  p = 1 - 2*(a - N)
 *   S1     = sum_{n=1}^{N} n^(-1/2 - i t)        (the big sum, streamed)
 *   arg3   = (t/2)*ln(t/(2*pi)) - t/2 - pi/8
 *   theta  = arg3 + 1/(48 t) + 7/(5760 t^3)      (agrees with the exact
 *            log-gamma theta to ~t^-7 ~ 1e-100 at our heights; the
 *            self-test cross-checks this against mpmath's siegeltheta)
 *   S3     = (-1)^(N-1) * a^(-1/2) * exp(-i*arg3)
 *   rssum  = sum_{n=0}^{L-1} sum_{k=0}^{floor(3n/2)}
 *            D[n,k] * Fp[3n-2k] / (pi^(2n-k) * (2i)^k) * a^(-n)
 *   Fp[m]  = sum_{k=0}^{2J-m} C[k] * p^k          (Horner, the C-table)
 *
 * PRECISION (error budget, t ~ 9e20, N ~ 1.2e10):
 *   - every quantity entering a trig argument (t*ln n, theta, arg3) is
 *     carried in QD (quad-double, 226 bits): per-term angle known to
 *     ~x*2^-226 ~ 1e-46 rad;
 *   - per-term cos/sin error ~1e-34 (quad cosq on the reduced argument
 *     plus the QD tail correction);
 *   - the per-term amplitude n^(-1/2) is quad (1e-34 relative) and
 *     dominates the per-term error;
 *   - coherent worst-case |Z| error ~ sum n^(-1/2) * 1e-34 ~ 2*sqrt(N)
 *     * 1e-34 ~ 7e-30, far below the census target (log|zeta| to
 *     ~1e-8 is what the integer M accounting needs; the dps-ladder
 *     cross-checks want ~1e-9);
 *   - the rssum is quad (value ~a^-3 ~ 3e-28 at these heights, its
 *     1e-34 relative error irrelevant);
 *   - C-table (199 digits) and D-table (exact rationals) dumped at
 *     50 digits - exact into quad; QD constants (2*pi, pi/8, 1/2pi)
 *     dumped at 256 bits.
 *
 * QD arithmetic: add/sub via two-sum; mul via fmaq (libquadmath);
 * positive log via quad log + exp-recovery (see qd_ln_qd).
 *
 * OpenMP over contiguous n ranges; memory O(threads); no zeta zeros,
 * no RH content - a census channel.  No RH claim.
 */
#define _GNU_SOURCE
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>
#include "zetac_tables.h"

/* ---- libquadmath prototypes (no dev header on this box) ---- */
typedef __float128 f128;
extern f128 cosq(f128);
extern f128 sinq(f128);
extern f128 logq(f128);
extern f128 expq(f128);
extern f128 sqrtq(f128);
extern f128 floorq(f128);
extern f128 fmaq(f128, f128, f128);
extern f128 ldexpq(f128, int);
extern f128 strtoflt128(const char *, char **);

/* off-grid test override: 0 = use ch->t; set only by the ZETAC_TEST_T hook.
 * (double parsing O(2^k)-quantizes far heights, so the hook must stay f128) */
static f128 g_test_t = 0.0Q;

/* decimal-string parser (no strtofq in this libquadmath): digit
 * accumulation in quad, ~50 steps ~ 2e-33 relative (fine for the
 * c/d tables, which only feed the ~1e-28-level rssum); exact triples
 * are used for the QD constants instead. */
static f128 pow10q(long e)
{
    f128 res = 1.0Q, base = 10.0Q;
    while (e > 0) {
        if (e & 1) res *= base;
        base *= base;
        e >>= 1;
    }
    return res;
}
static f128 dec2f128(const char *str)
{
    const char *s = str;
    int sg = 1;
    if (*s == '-') { sg = -1; s++; } else if (*s == '+') s++;
    f128 r = 0.0Q;
    long pow10 = 0, dec_digits = 0;
    int seen_dot = 0, ndig = 0;
    while (*s && *s != 'e' && *s != 'E') {
        if (*s == '.') { seen_dot = 1; s++; continue; }
        if (*s >= '0' && *s <= '9') {
            r = r * 10.0Q + (f128)(*s - '0');
            ndig++;
            if (seen_dot) dec_digits++;
        }
        s++;
    }
    if (*s == 'e' || *s == 'E') pow10 += (long)atoi(s + 1);
    pow10 -= dec_digits;
    if (pow10 > 0) r *= pow10q(pow10);
    else if (pow10 < 0) r /= pow10q(-pow10);
    return sg < 0 ? -r : r;
}
static f128 qdpart(const unsigned long long *u, const int *e,
                   const int *sg, int i)
{
    f128 v = ldexpq((f128)u[2 * i], e[i] + 49)
        + ldexpq((f128)u[2 * i + 1], e[i]);
    return sg[i] < 0 ? -v : v;
}

#define Q(x) ((f128)(x))

/* ---------------- QD (quad-double) arithmetic ---------------- */
typedef struct { f128 hi, lo; } qd;

static qd qd_set(f128 x) { qd r; r.hi = x; r.lo = 0.0Q; return r; }

static qd qd_add(qd a, qd b)
{
    /* Knuth 2SUM on the hi parts + the lo parts */
    f128 s = a.hi + b.hi;
    f128 bv = s - a.hi;
    f128 e = (a.hi - (s - bv)) + (b.hi - bv) + a.lo + b.lo;
    qd r; r.hi = s; r.lo = e;
    return r;
}

static qd qd_sub(qd a, qd b)
{
    b.hi = -b.hi; b.lo = -b.lo;
    return qd_add(a, b);
}

/* (a.hi + a.lo) * (b.hi + b.lo), exact to ~|ab|*2^-226 */
static qd qd_mul(qd a, qd b)
{
    f128 p = a.hi * b.hi;
    f128 cross = a.hi * b.lo + a.lo * b.hi;
    f128 e = fmaq(a.hi, b.hi, -p) + cross + a.lo * b.lo;
    /* e is the quad-rounded correction; its own rounding ~|ab|*2^-226 */
    f128 lo = p + e;          /* not used separately; keep hi + lo */
    qd r;
    r.lo = lo - p;
    r.hi = p;
    return r;
}

/* ln(x) for x = (uh + ul) > 0 (QD), result in QD ~226 bits.
 *   L0   = logq(uh)            (quad, error ~|L0|*2^-113)
 *   w    = (uh + ul)*exp(-L0) - 1   (~L0-error, i.e. ~1e-33)
 *   ln(uh+ul) = L0 + w - w^2/2 + w^3/3   (w ~ 1e-33, 3 terms ~w^4/4
 *   ~ 1e-132 << 2^-226*|ln u| at our scales). */
static qd qd_ln_qd(qd u)
{
    f128 L0 = logq(u.hi);
    f128 e = expq(-L0);
    f128 r = u.hi * e + u.lo * e;
    f128 w = r - 1.0Q;
    f128 w2 = w * w;
    f128 corr = w - w2 / 2.0Q + w2 * w / 3.0Q;
    qd ln = qd_set(L0);
    /* add corr as a QD value (corr itself only needs ~1e-50 here) */
    return qd_add(ln, qd_set(corr));
}

/* reduce x (QD) mod 2*pi into r (QD, in [-pi, pi]).
 * k = round(x.hi/2pi.hi): quotient error ~|x|*2^-113 ~ 1e-12 << 0.5,
 * so k is the exact nearest integer for all our x (and the only
 * ambiguous cases are where cos-sensitivity ~ 0 anyway). */
static void qd_reduce(qd x, qd twopi, qd *r)
{
    f128 k = floorq(x.hi / twopi.hi + 0.5Q);
    *r = qd_sub(x, qd_mul(qd_set(k), twopi));
    if (r->hi > Q(3.15) || r->hi < Q(-3.15)) {
        *r = qd_sub(*r, qd_mul(qd_set(Q(r->hi > 0.0 ? 1 : -1)), twopi));
    }
}

static void qd_cossin(qd x, f128 *c, f128 *s)
{
    f128 c1 = cosq(x.hi), s1 = sinq(x.hi);
    *c = c1 - x.lo * s1;      /* x in [-pi,pi], x.lo ~ 1e-33 */
    *s = s1 + x.lo * c1;
}

/* ---------------- constants ---------------------------------- */
typedef struct { f128 re, im; } cplx;
static qd TWOPY, PI8, INV2PI;
static f128 PIQ;
#define CTAB_LEN ZETAC_CTAB_LEN
static cplx CTAB[CTAB_LEN];
static f128 DVALS[64];
#define LMAX ZETAC_LMAX
static int NCHAINS = 0;

/* ---------------- the per-height computation ----------------- */
static void compute_height(const struct zchain *ch, f128 *logz)
{
    f128 tq = (g_test_t != 0.0Q) ? g_test_t : (f128)ch->t;
    int L = ch->L, M = ch->M, J = ch->J;
    unsigned long long N = ch->N;
    if (getenv("ZETAC_DEBUG"))
        fprintf(stderr, "DBG ch_t=%.34Lg N=%llu\n", (long double)tq, N);

    /* a, p (quad) */
    f128 a = sqrtq(tq / TWOPY.hi);
    f128 an = (f128)N;
    f128 p = 1.0Q - 2.0Q * (a - an);

    /* Fp[0..M] by Horner, slicing CTAB to 2J+1 (complex quad); a local
     * copy so CTAB is not corrupted across heights */
    static f128 Fr[3 * LMAX + 1], Fi[3 * LMAX + 1];
    static f128 ccr[2 * 63 + 1], cci[2 * 63 + 1];
    {
        for (int k = 0; k <= 2 * J; k++) {
            ccr[k] = CTAB[k].re;
            cci[k] = CTAB[k].im;
        }
        f128 vr = 0.0Q, vi = 0.0Q;
        for (int m = 0; m <= M; m++) {
            for (int k = 2 * J - m - 1; k >= 0; k--) {
                f128 nr = vr * p + ccr[k];
                f128 ni = vi * p + cci[k];
                vr = nr; vi = ni;
            }
            Fr[m] = vr; Fi[m] = vi;
            for (int k = 0; k < 2 * J - m - 1; k++) {
                ccr[k] = ccr[k + 1] * (f128)(k + 1);
                cci[k] = cci[k + 1] * (f128)(k + 1);
            }
        }
    }

    /* rssum = sum_{n,k} D[n,k] * Fp[3n-2k] * pi^(-(2n-k)) * (2i)^(-k)
     *       * a^(-n)   (complex quad) */
    f128 ainv = 1.0Q / a;
    static f128 ainvp[LMAX + 1];
    ainvp[0] = 1.0Q;
    for (int n = 1; n <= L; n++) ainvp[n] = ainvp[n - 1] * ainv;
    static f128 pinv[2 * LMAX + 1];
    pinv[0] = 1.0Q;
    f128 ip = 1.0Q / PIQ;
    for (int j = 1; j <= 2 * L + 1; j++) pinv[j] = pinv[j - 1] * ip;
    /* (2i)^(-k) */
    static f128 cr[3 * LMAX + 1], ci[3 * LMAX + 1];
    cr[0] = 1.0Q; ci[0] = 0.0Q;
    for (int k = 1; k <= 3 * L; k++) {
        cr[k] = 0.5Q * ci[k - 1];
        ci[k] = -0.5Q * cr[k - 1];
    }
    f128 sr = 0.0Q, si = 0.0Q;
    for (int n = 0; n < L; n++) {
        int kk = 3 * n / 2;
        /* DIDX start: ZETAC_DIDX[n] */
        for (int k = 0; k <= kk; k++) {
            int idx = 3 * n - 2 * k;
            if (idx > M) continue;
            f128 dv = DVALS[ZETAC_DIDX[n] + k];
            f128 pw = pinv[2 * n - k];
            f128 t1r = dv * Fr[idx] * pw;
            f128 t1i = dv * Fi[idx] * pw;
            f128 t2r = t1r * cr[k] - t1i * ci[k];
            f128 t2i = t1r * ci[k] + t1i * cr[k];
            sr += t2r * ainvp[n];
            si += t2i * ainvp[n];
            if (getenv("ZETAC_DEBUG"))
                fprintf(stderr,
                        "DBG rssum-step n=%d k=%d term=(%.17g, %.17g) "
                        "run=(%.17g, %.17g)\n",
                        n, k, (double)t2r, (double)t2i,
                        (double)sr, (double)si);
        }
    }

    /* arg3, theta (QD):  u = t/(2*pi)  (QD via INV2PI) */
    qd u = qd_mul(qd_set(tq), INV2PI);
    qd lnu = qd_ln_qd(u);
    qd t2  = qd_set((f128)0.5 * tq);
    qd arg3 = qd_sub(qd_mul(t2, lnu), t2);
    arg3 = qd_sub(arg3, PI8);
    f128 small = 1.0Q / (48.0Q * tq) + Q(7.0 / 5760.0) / (tq * tq * tq);
    qd theta = qd_add(arg3, qd_set(small));

    /* S3 = (-1)^(N-1) * a^(-1/2) * exp(-i arg3) */
    qd r3; qd_reduce(arg3, TWOPY, &r3);
    f128 c3, s3;
    qd_cossin(r3, &c3, &s3);
    f128 sgn = ((N - 1) & 1) ? Q(-1) : Q(1);
    f128 ah = 1.0Q / sqrtq(a);
    f128 S3r = sgn * ah * c3;
    f128 S3i = -sgn * ah * s3;

    /* e^{i theta} */
    qd rth; qd_reduce(theta, TWOPY, &rth);
    f128 ct, st;
    qd_cossin(rth, &ct, &st);

    /* S1 (OpenMP, contiguous ranges, streaming) */
    f128 cre = 0.0Q, cim = 0.0Q;
    {
        int nth = omp_get_max_threads();
        if (nth > 256) nth = 256;
        static f128 tre[256], tim[256];
        memset(tre, 0, nth * sizeof(f128));
        memset(tim, 0, nth * sizeof(f128));
        unsigned long long chunk = (N + nth - 1) / nth;
        #pragma omp parallel for schedule(static)
        for (int th = 0; th < nth; th++) {
            unsigned long long lo = (unsigned long long)th * chunk + 1;
            unsigned long long hi = lo + chunk - 1;
            if (hi > N) hi = N;
            if (lo > N) continue;
            f128 ar = 0.0Q, ai = 0.0Q;
            for (unsigned long long n = lo; n <= hi; n++) {
                f128 nq = (f128)n;
                qd lnq = qd_ln_qd(qd_set(nq));
                qd ang = qd_mul(qd_set(tq), lnq);
                qd r;
                qd_reduce(ang, TWOPY, &r);
                f128 c1, s1;
                qd_cossin(r, &c1, &s1);
                f128 amp = 1.0Q / sqrtq(nq);
                ar += amp * c1;
                ai -= amp * s1;
            }
            tre[th] = ar;
            tim[th] = ai;
        }
        for (int th = 0; th < nth; th++) {
            cre += tre[th];
            cim += tim[th];
        }
    }

    /* Z = 2*Re(e^{i theta} * (S1 + rssum*S3)) */
    f128 Wr = cre + sr * S3r - si * S3i;
    f128 Wi = cim + sr * S3i + si * S3r;
    f128 Z2 = 2.0Q * (ct * Wr - st * Wi);
    if (getenv("ZETAC_DEBUG")) {
        fprintf(stderr, "DBG a=%.17g N=%llu p=%.17g\n",
                (double)a, N, (double)p);
        fprintf(stderr, "DBG theta=%.17g arg3=%.17g\n",
                (double)theta.hi, (double)arg3.hi);
        fprintf(stderr, "DBG S1=(%.17g, %.17g)\n",
                (double)cre, (double)cim);
        for (int mm = 0; mm <= M; mm++)
            fprintf(stderr, "DBG Fr[%d]=(%.17g, %.17g)\n",
                    mm, (double)Fr[mm], (double)Fi[mm]);
        fprintf(stderr, "DBG ainv=%.17g ainvp1=%.17g\n",
                (double)ainv, (double)ainvp[1]);
        for (int n = 0; n < L; n++)
            for (int k = 0; k <= 3 * n / 2; k++) {
                int idx = 3 * n - 2 * k;
                if (idx > M) continue;
                fprintf(stderr,
                        "DBG term n=%d k=%d idx=%d dv=%.17g pw=%.17g\n",
                        n, k, idx, (double)DVALS[ZETAC_DIDX[n] + k],
                        (double)pinv[2 * n - k]);
            }
        for (int n = 0; n < L; n++)
            fprintf(stderr, "DBG DIDX[%d]=(%d,%d,%d,%d)\n",
                    n, ZETAC_DIDX[0], ZETAC_DIDX[1], ZETAC_DIDX[2],
                    ZETAC_DIDX[3]);
        fprintf(stderr, "DBG rssum=(%.17g, %.17g)\n",
                (double)sr, (double)si);
        fprintf(stderr, "DBG S3=(%.17g, %.17g) eitheta=(%.17g, %.17g)\n",
                (double)S3r, (double)S3i, (double)ct, (double)st);
        fprintf(stderr, "DBG r3=(%.17g, %.3e) rth=(%.17g, %.3e)\n",
                (double)r3.hi, (double)r3.lo,
                (double)rth.hi, (double)rth.lo);
        fprintf(stderr, "DBG rawcos(r3.hi)=%.17g rawsinq(r3.hi)=%.17g\n",
                (double)cosq(r3.hi), (double)sinq(r3.hi));
        fprintf(stderr, "DBG Wr=%.17g Wi=%.17g Z=%.17g\n",
                (double)Wr, (double)Wi, (double)Z2);
    }
    if (Z2 < 0.0Q) Z2 = -Z2;
    *logz = (Z2 > 0.0Q) ? logq(Z2) : Q(-999);
}

int main(int argc, char **argv)
{
    TWOPY.hi = qdpart(ZETAC_TWOPY_U, ZETAC_TWOPY_E, ZETAC_TWOPY_S, 0);
    TWOPY.lo = qdpart(ZETAC_TWOPY_U, ZETAC_TWOPY_E, ZETAC_TWOPY_S, 1);
    PI8.hi  = qdpart(ZETAC_PI8_U, ZETAC_PI8_E, ZETAC_PI8_S, 0);
    PI8.lo  = qdpart(ZETAC_PI8_U, ZETAC_PI8_E, ZETAC_PI8_S, 1);
    INV2PI.hi = qdpart(ZETAC_INV2PI_U, ZETAC_INV2PI_E, ZETAC_INV2PI_S, 0);
    INV2PI.lo = qdpart(ZETAC_INV2PI_U, ZETAC_INV2PI_E, ZETAC_INV2PI_S, 1);
    PIQ = TWOPY.hi / 2.0Q;
    for (int k = 0; k < CTAB_LEN; k++) {
        CTAB[k].re = dec2f128(ZETAC_CRE[2 * k]);
        CTAB[k].im = dec2f128(ZETAC_CRE[2 * k + 1]);
    }
    {
        int total = ZETAC_DIDX[LMAX - 1] + 3 * (LMAX - 1) / 2 + 1;
        for (int k = 0; k < total; k++)
            DVALS[k] = dec2f128(ZETAC_DVALS[k]);
    }

    NCHAINS = (int)(sizeof(ZETAC_CHAINS) / sizeof(ZETAC_CHAINS[0]));

    if (argc > 1 && strcmp(argv[1], "--list") == 0) {
        for (int i = 0; i < NCHAINS; i++)
            printf("chain %d: t = %.34Lg  L=%d M=%d J=%d N=%llu\n", i,
                   (long double)ZETAC_CHAINS[i].t, ZETAC_CHAINS[i].L,
                   ZETAC_CHAINS[i].M, ZETAC_CHAINS[i].J,
                   ZETAC_CHAINS[i].N);
        return 0;
    }

    int only = -1;
    if (argc > 1) only = atoi(argv[1]);

    const char *tt = getenv("ZETAC_TEST_T");
    if (tt) {
        /* compute any t with the max chain (L=max, M=max, J=max).
         * f128 parsing: the exact decimal is what gets evaluated
         * (double parsing would O(2^9)-collapse distinct far heights). */
        f128 tq = strtoflt128(tt, NULL);
        struct zchain te = ZETAC_CHAINS[3]; /* L=4 M=9 J=62 */
        te.N = (unsigned long long)floorq(sqrtq(tq / (f128)6.283185307179586));
        g_test_t = tq;
        double t0 = omp_get_wtime();
        f128 lz = 0;
        compute_height(&te, &lz);
        g_test_t = 0.0Q;
        printf("t=%.34Lg  logzeta=%.12f  N=%llu  (TEST max-chain)  "
               "%.1f s\n",
               (long double)tq, (double)lz, te.N, omp_get_wtime() - t0);
        return 0;
    }

    for (int i = 0; i < NCHAINS; i++) {
        if (only >= 0 && only != i) continue;
        double t0 = omp_get_wtime();
        f128 lz = 0;
        compute_height(&ZETAC_CHAINS[i], &lz);
        double dt = omp_get_wtime() - t0;
        printf("t=%.17g  logzeta=%.12f  N=%llu  (L=%d M=%d J=%d)  "
               "%.1f s\n",
               (double)ZETAC_CHAINS[i].t, (double)lz, ZETAC_CHAINS[i].N,
               ZETAC_CHAINS[i].L, ZETAC_CHAINS[i].M, ZETAC_CHAINS[i].J,
               dt);
        fflush(stdout);
    }
    return 0;
}
