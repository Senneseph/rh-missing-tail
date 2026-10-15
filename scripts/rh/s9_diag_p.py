"""s9 diagnostic 3:  march  P(t)  =  log|zeta| - lm - I_far  across  G.
No streaming  (la/re  are  the  separate  data side).  If  P  is  smooth
across  t = G,  the  -8.6e7  anomaly  lives  in  the  streamed  data side.
"""
import sys
import time

sys.path.insert(0, ".")
import s9_dk_above_g as S

G = S.G_LAST


def main():
    ts = [G - 2.0, G - 1.0, G - 0.5, G - 0.25, G - 0.1, G - 0.01,
          G + 0.01, G + 0.1, G + 0.25, G + 0.5, G + 1.0, G + 2.0]
    print("t                    P = lzeta - lm - Ifar")
    prev = None
    for t in ts:
        t0 = time.time()
        lm = S.lm_re(t)
        with S.workdps(40):
            lz = S.mlog(abs(S.mp.zeta(S.mpc(0.5, S.mp.mpf(repr(t))))))
        lz = float(lz)
        ifar = S.i_far_split(t, 40)
        p = lz - lm - ifar
        step = "" if prev is None else "  dP = %+.9e" % (p - prev)
        print("%.12f  %+.12f%s  (%.0f s)" % (t, p, step,
                                             time.time() - t0),
              flush=True)
        prev = p


if __name__ == "__main__":
    main()
