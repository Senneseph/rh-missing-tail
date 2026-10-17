"""s34l: width-trace determinism probe (full variant).

Fresh process.  Args: t (integer), dps.  Records EVERY Rzeta_set /
zetasum_sieved call (list, not overwrite) plus the internal width
chain (wpinitial at zeta entry, at Rzeta_set entry; eps1; wpsum;
wprssum; wps3; wpend) and the final value.  One json line out.
"""
import sys, json, time
t = int(sys.argv[1])
dps = int(sys.argv[2])
import mpmath as mp
import mpmath.libmp.gammazeta as GZ
import mpmath.functions.rszeta as RS

rec = {"calls_sieved": [], "calls_rz": [], "widths": {}}
zeta_prec_at_entry = None

orig_zeta_half = RS.z_half
def zhalf(ctx, tval, der=0):
    rec["widths"]["prec_at_zhalf_entry"] = ctx.prec
    zz = orig_zeta_half(ctx, tval, der)
    return zz
RS.z_half = zhalf

orig_set = RS.Rzeta_set
def rset(ctx, s, derivatives=[0]):
    rec["calls_rz"].append(dict(prec_entry=ctx.prec,
                                derivs=list(derivatives)))
    orig = ctx.prec
    rz = orig_set(ctx, s, derivatives)
    rec["calls_rz"][-1]["rz"] = [float(mp.re(rz[0])), float(mp.im(rz[0]))]
    rec["calls_rz"][-1]["prec_exit"] = ctx.prec
    return rz
RS.Rzeta_set = rset

orig_sieved = GZ.zetasum_sieved
def sieved(critical_line, sre, sim, a, n, wp):
    re, im = orig_sieved(critical_line, sre, sim, a, n, wp)
    rec["calls_sieved"].append(dict(wp=wp, n=int(n),
                                    sre=f"sre({sre.bit_length() if sre else 0}b)",
                                    sim_bits=sim.bit_length() if sim else 0))
    return re, im
GZ.zetasum_sieved = sieved

mp.mp.dps = dps
zeta_prec_at_entry = mp.mp.prec
ti = mp.mpf(t)
z0 = time.time()
z = mp.zeta(mp.mpf('0.5') + 1j * ti)
out = dict(t=t, dps=dps, prec_user=zeta_prec_at_entry,
           logabsz=float(mp.log(abs(z))),
           absz=float(abs(z)),
           time=time.time() - z0,
           calls_sieved=rec["calls_sieved"],
           calls_rz=rec["calls_rz"],
           widths=rec["widths"])
print(json.dumps(out), flush=True)
