/* s34b_cosform.c - INDEPENDENT cross-check assembly at the extreme
 * heights: the bare cosine Riemann-Siegel form (DLMF 25.10.2/3):
 *
 *   Z(t) = 2 * sum_{n=1}^{N} cos(theta(t) - t ln n) / sqrt(n) + R(t)
 *   R(t) = O(t^(-1/4))  ->  ~2.4e-5 at t = 3e18,  ~1.1e-5 at 9e18.
 *
 * This assembly shares NOTHING with zetac.c's F/c-table/rssum path:
 * no c-table, no d-table, no Horner, no S3, no rssum.  Only the QD
 * arithmetic, the 2*pi constant triplet, and the theta series
 * (theta = (t/2)ln(t/2pi) - t/2 - pi/8 + 1/48t + 7/5760t^3, verified
 * against the exact log-gamma theta to ~2e-24 at t <= 1e4 and better
 * for larger t).  The bare sum is Z to O(t^-1/4), enough to tell
 * |Z| = 89 from |Z| = 4.3 to one part in 10^4.  No RH content.
 */
#define _GNU_SOURCE
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include "zetac_tables.h"

typedef __float128 f128;
extern f128 cosq(f128);
extern f128 sinq(f128);
extern f128 logq(f128);
extern f128 expq(f128);
extern f128 sqrtq(f128);
extern f128 floorq(f128);
extern f128 fmaq(f128, f128, f128);
extern f128 ldexpq(f128, int);

#define Q(x) ((f128)(x))

typedef struct { f128 hi, lo; } qd;

static qd qd_set(f128 x) { qd r; r.hi = x; r.lo = 0.0Q; return r; }

static qd qd_add(qd a, qd b)
{
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

static qd qd_mul(qd a, qd b)
{
    f128 p = a.hi * b.hi;
    f128 cross = a.hi * b.lo + a.lo * b.hi;
    f128 e = fmaq(a.hi, b.hi, -p) + cross + a.lo * b.lo;
    f128 lo = p + e;
    qd r; r.lo = lo - p; r.hi = p;
    return r;
}

static qd qd_ln_qd(qd u)
{
    f128 L0 = logq(u.hi);
    f128 e = expq(-L0);
    f128 r = u.hi * e + u.lo * e;
    f128 w = r - 1.0Q;
    f128 w2 = w * w;
    f128 corr = w - w2 / 2.0Q + w2 * w / 3.0Q;
    qd ln = qd_set(L0);
    return qd_add(ln, qd_set(corr));
}

static void qd_reduce(qd x, qd twopi, qd *r)
{
    f128 k = floorq(x.hi / twopi.hi + 0.5Q);
    *r = qd_sub(x, qd_mul(qd_set(k), twopi));
    if (r->hi > Q(3.15) || r->hi < Q(-3.15)) {
        *r = qd_sub(*r, qd_mul(qd_set(Q(r->hi > 0.0 ? 1 : -1)), twopi));
    }
}

static f128 qdpart(const unsigned long long *u, const int *e,
                   const int *sg, int i)
{
    f128 v = ldexpq((f128)u[2 * i], e[i] + 49)
        + ldexpq((f128)u[2 * i + 1], e[i]);
    return sg[i] < 0 ? -v : v;
}

int main(int argc, char **argv)
{
    static qd TWOPY, PI8, INV2PI;
    TWOPY.hi = qdpart(ZETAC_TWOPY_U, ZETAC_TWOPY_E, ZETAC_TWOPY_S, 0);
    TWOPY.lo = qdpart(ZETAC_TWOPY_U, ZETAC_TWOPY_E, ZETAC_TWOPY_S, 1);
    PI8.hi = qdpart(ZETAC_PI8_U, ZETAC_PI8_E, ZETAC_PI8_S, 0);
    PI8.lo = qdpart(ZETAC_PI8_U, ZETAC_PI8_E, ZETAC_PI8_S, 1);
    INV2PI.hi = qdpart(ZETAC_INV2PI_U, ZETAC_INV2PI_E, ZETAC_INV2PI_S, 0);
    INV2PI.lo = qdpart(ZETAC_INV2PI_U, ZETAC_INV2PI_E, ZETAC_INV2PI_S, 1);

    const int nch = (int)(sizeof(ZETAC_CHAINS) / sizeof(ZETAC_CHAINS[0]));
    int only = -1;
    if (argc > 1) only = atoi(argv[1]);

    for (int i = 0; i < nch; i++) {
        if (only >= 0 && only != i) continue;
        const struct zchain *ch = &ZETAC_CHAINS[i];
        f128 tq = ch->t;
        unsigned long long N = ch->N;

        /* theta (QD) */
        qd u = qd_mul(qd_set(tq), INV2PI);
        qd lnu = qd_ln_qd(u);
        qd t2 = qd_set(Q(0.5) * tq);
        qd arg3 = qd_sub(qd_mul(t2, lnu), t2);
        arg3 = qd_sub(arg3, PI8);
        f128 small = 1.0Q / (48.0Q * tq) + Q(7.0 / 5760.0) / (tq * tq * tq);
        qd theta = qd_add(arg3, qd_set(small));

        /* bare cosine sum (no R term: O(t^-1/4) ~ 1e-5 at these t) */
        int nth = omp_get_max_threads();
        if (nth > 256) nth = 256;
        static f128 tres[256];
        memset(tres, 0, nth * sizeof(f128));
        unsigned long long chunk = (N + nth - 1) / nth;
        #pragma omp parallel for schedule(static)
        for (int th = 0; th < nth; th++) {
            unsigned long long lo = (unsigned long long)th * chunk + 1;
            unsigned long long hi = lo + chunk - 1;
            if (hi > N) hi = N;
            if (lo > N) continue;
            f128 acc = 0.0Q;
            for (unsigned long long n = lo; n <= hi; n++) {
                f128 nq = (f128)n;
                qd lnq = qd_ln_qd(qd_set(nq));
                qd ang = qd_sub(theta, qd_mul(qd_set(tq), lnq));
                qd r;
                qd_reduce(ang, TWOPY, &r);
                f128 c = cosq(r.hi) - r.lo * sinq(r.hi);
                f128 amp = 1.0Q / sqrtq(nq);
                acc += amp * c;
            }
            tres[th] = acc;
        }
        double t0 = omp_get_wtime();
        f128 sum = 0.0Q;
        for (int th = 0; th < nth; th++) sum += tres[th];
        f128 Z = 2.0Q * sum;
        if (Z < 0.0Q) Z = -Z;
        printf("t=%.17g  bare-cos-form |Z| = %.12f  (true |zeta| within "
               "~2.5e-5; N=%llu)  %.1f s\n",
               (double)ch->t, (double)Z, N, omp_get_wtime() - t0);
        fflush(stdout);
    }
    return 0;
}
