#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""day061 - Q2 in-body pin measurement: the decoupled S1 margin.

   0257 (day060) measured the decoupled bracket JOINT (R1 = wall_lo/
   (dev + Mval),  R4 = dev/wire).  The T4OffLE module needs the
   S1-side IN-BODY target instead:

       wall_lo(N_off) > own := |poff(t, d0, t)|          (A)

   because devStripMin = min(own, straddles...) <= own,  so
   wall_lo > own  ==>  wall_lo > devStripMin  (the S1 datum for
   the exclusion),  with the exclusion then closing in the body
   over  S2 (s2ActualFullBand) + S4 (s4StripUnifiedFloor) + the
   named hs3 face  (fill <= BwireR + MrR).

   wall_lo(N) = T1 - T2 - T3 at the LEFT point sL = (1/2-d0, t),
   run  N = ceil(npp(C_off, sigma, t)),  C_off = 1/(16 d0^2),
   sigma = 1/2 - d0   (the 0257 decoupled bracket,  exact engine
   forms,  dps 60,  no zeta evaluation,  no RH claim).

   Output:
     (1) worst of  wall_lo / own   over the band grid,  exact
         comparison at the worst grid point,  and the margin
         under the IN-BODY CEILING PIN  (N <= 2 * npp,  so
         T1(N) >= 2^-sigma * (1/(16 d0^2))^-1 ...  the coarse
         ceiling factor;  the pin also drops the -T2-T3 part to
         its 0257-measured scale).
     (2) the clean sub-band (t-min,  d0-range) on which the pin
         closes strictly.
     (3) comparison vs the single-C 5001 pin (058e) at the same
         grid points.
"""
import sys, io
sys.path.insert(0, '.')
mp = __import__('mpmath')
mp.mp.dps = 60
if not hasattr(mp.mpf, 'nstr'):
    mp.mpf.nstr = lambda self, n=59: mp.nstr(self, n)

import day059_route_c_s1_perpoint as E   # the 0252 engine (shared forms)

HALF = mp.mpf('0.5')

T_PT2 = mp.mpf('3000175332800')
D0MAX = mp.mpf('0.3733819666132075199290267786')  # TEN face, d0


def P(*a):
    line = ' '.join(str(x) for x in a)
    sys.stdout.write(line + '\n')


def floWin(g):
    # Lean S1LowT.floWin : min (23/1000) (1 - 25/g)
    return min(mp.mpf('0.023'), 1 - 25 / g)


def flo_strip(t, d0):
    # Lean floStripMin = min( |poff t d0 t|, max(floWin t, 0) )
    return min(abs(E.poff(t, d0, t)), max(floWin(t), mp.mpf(0)))


def wall_lo(t, d0, n):
    sL = mp.mpc(HALF - d0, t)
    sigma = HALF - d0
    return (E.T1(sigma, n) - E.T2(sL, sigma, n)
            - E.T3(sL, sigma, n))


def main():
    outs = open('day061_q2_inbody_pin.txt', 'w')
    _P = lambda *a: (sys.stdout.write(('  ' + ' '.join(map(str, a)) + '\n')),
                     outs.write(('  ' + ' '.join(map(str, a)) + '\n')))
    P('day061 - Q2 in-body pin (T4OffLE target):  wall_lo(N_off) > own')
    P('  C_off = 1/(16 d0^2)   (the 0257 decoupled bracket,  S1 side)')
    P('  sigma = 1/2 - d0,  N_off = ceil(npp(C_off, sigma, t))')
    P('  own(t,d0) = |poff(t, d0, t)|  (the own-mass of the pair)')
    P('  flo(t,d0) = min(own, max(floWin,0))   [Lean floStripMin]')
    P('  dev(t,d0) = devStripMin  (min(own, 48 straddles)) <= own')
    P('')

    ts = [mp.mpf('1000'), mp.mpf('1e6'), mp.mpf('1e8'), T_PT2,
          mp.mpf('1e16'), mp.mpf('1e18'), mp.mpf('1e20')]
    d0s = [
        mp.mpf('1/200'),
        mp.mpf('1/150'),
        mp.mpf('1/120'),
        mp.mpf('1/100'),
        mp.mpf('0.1'),
        mp.mpf('0.15'),
        mp.mpf('0.2'),
        mp.mpf('0.25'),
        mp.mpf('0.3'),
        mp.mpf('0.35'),
        mp.mpf('0.37'),
        D0MAX,
        mp.mpf('0.373'),
        mp.mpf('0.3733'),
        mp.mpf('0.37338'),
        mp.mpf('0.373381'),
        mp.mpf('0.373381966613'),
    ]
    d0s = sorted(set(d0s))

    P('  grid:  t in %d points  x  d0 in %d points'
      % (len(ts), len(d0s)))
    P('')
    P('  t          d0          sigma      wall/own   wall/flo   Rdev    '
      'pin/own    single-C5001')
    P('  ' + '-' * 88)

    worst = None   # (wall/own, t, d0)
    worst_pin = None
    open_cnt = 0
    for t in ts:
        for d0 in d0s:
            sigma = HALF - d0
            if sigma <= 0:
                continue
            n_off = E.npp(1 / (16 * d0 * d0), sigma, t)
            w = wall_lo(t, d0, n_off)
            own = abs(E.poff(t, d0, t))
            flo = flo_strip(t, d0)
            dev = E.devStripMin(t, d0)
            r_own = (w / own) if own > 0 else mp.mpf('inf')
            r_flo = (w / flo) if flo > 0 else mp.mpf('inf')
            r_dev = (w / dev) if dev > 0 else mp.mpf('inf')
            # the in-body ceiling pin:  N <= npp + 1 <= 2*npp  (npp >= 1),
            # T1(N) >= (2*npp)^-sigma = 2^-sigma * C_off^-1 * t^-2,
            # and the T2+T3 part keeps the 0257 measured scale <= (T2+T3)
            # at the IDEAL run (decreasing in n?  T2,T3 decrease in n at
            # fixed s)  ->  pin_wall = 2^-sigma * C_off^-1 * t^-2 - (T2+T3)
            pin = (mp.mpf('1/2') * (2 ** (-sigma))) \
                * (1 / (1 / (16 * d0 * d0))) * t ** (-2) \
                - E.T2(mp.mpc(HALF - d0, t), sigma, n_off) \
                - E.T3(mp.mpc(HALF - d0, t), sigma, n_off)
            r_pin = (pin / own) if own > 0 else mp.mpf('inf')
            # single-C 5001 comparison (the 058e pin family)
            n5 = E.npp(mp.mpf('5001'), sigma, t)
            r5 = wall_lo(t, d0, n5) / own
            if worst is None or r_own < worst[0]:
                worst = (r_own, t, d0)
            if worst_pin is None or r_pin < worst_pin[0]:
                worst_pin = (r_pin, t, d0)
            if r_own <= 1:
                open_cnt += 1
            _P('  %-11s %11.5f %11.6f %11.5f  %10.5e  %10.5e  %10.5e  %10.5e'
               % (mp.nstr(t, 10) if t < 1e4 else mp.nstr(t, 6),
                  float(d0), float(sigma),
                  float(r_own), float(r_flo), float(r_dev),
                  float(r_pin), float(r5)))
    P('')
    P('  OPEN (wall_lo <= own) grid points:  %d / %d'
      % (open_cnt, len(ts) * len(d0s)))
    P('')
    rt, td, dd = worst
    P('  WORST wall_lo/own  = %.6e  at  t = %s,  d0 = %.9f'
      % (float(rt), mp.nstr(td, 12), float(dd)))
    rp, tp, dp = worst_pin
    P('  WORST pin/own      = %.6e  at  t = %s,  d0 = %.9f'
      % (float(rp), mp.nstr(tp, 12), float(dp)))
    P('')
    P('  VERDICT (dps-60,  closed forms,  zero-set maps only -')
    P('  the pinned straddle/own data of the 0252 engine):  the S1')
    P('  in-body target  wall_lo > own  ' +
      ('CLOSES on the grid if the worst ratio > 1.'
       if rt > 1 else 'DOES NOT close on the grid.'))
    outs.close()


if __name__ == '__main__':
    main()
