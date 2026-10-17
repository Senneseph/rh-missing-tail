# Instrumented mpmath RS run at the 5e8G height: capture S1 (and its
# internal width), rz = S1 + rssum*S3, and final z.  One dps per
# FRESH PROCESS (arg 1).
import sys, json, time
dps = int(sys.argv[1])
import mpmath as mp
import mpmath.libmp.gammazeta as GZ
import mpmath.functions.rszeta as RS

captured = {}

orig_sieved = GZ.zetasum_sieved
def sieved(critical_line, sre, sim, a, n, wp):
    re, im = orig_sieved(critical_line, sre, sim, a, n, wp)
    s2 = 2.0 ** wp
    captured['S1'] = [float(re) / s2, float(im) / s2]
    captured['wp_sum'] = wp
    captured['n_terms'] = n
    return re, im
GZ.zetasum_sieved = sieved

orig_set = RS.Rzeta_set
def rset(ctx, s, derivatives=[0]):
    rz = orig_set(ctx, s, derivatives)
    captured['rz'] = [float(mp.re(rz[0])), float(mp.im(rz[0]))]
    return rz
RS.Rzeta_set = rset

mp.mp.dps = dps
t = mp.mpf(15000522999990988800)   # exact f64 value as integer -> exact
t0 = time.time()
z = mp.zeta(mp.mpf('0.5') + 1j * t)
out = dict(dps=dps, t=15000522999990988800,
           logabsz=float(mp.log(abs(z))), absz=float(abs(z)),
           time=time.time() - t0, **{k: v for k, v in captured.items()})
rss_s3 = [out['rz'][i] - out['S1'][i] for i in range(2)]
out['rssumS3'] = rss_s3
out['rssumS3_mag'] = float((rss_s3[0]**2 + rss_s3[1]**2) ** 0.5)
print(json.dumps(out), flush=True)
