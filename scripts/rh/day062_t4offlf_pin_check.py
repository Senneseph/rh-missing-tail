#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""day062 - T4OffLF pin cross-check: the IN-BODY bound chain for
   wallLo(t, d0, N) > own on the band, BEFORE the Lean fire.

   The in-body chain (every step a Lean lemma):
     (1) nIdeal >= t^4/(256 d0^4)          [nIdeal = X^(1/sigma),
         X = t^2/(16 d0^2) >= 250000 >= 1, 1/sigma >= 2]
     (2) T1(Noff) >= 4 d0^2 t^-2 * 2^(1/2 + d0)
         [T1 decreasing, Noff <= 2 nIdeal,
          nIdeal^(-sigma) = 16 d0^2 t^-2 EXACT]
     (3) T2(nIdeal) <= sqrt(t^2+1/4)/12 * 4096 d0^6 / t^6
         [||sL|| = sqrt(sigma^2+t^2) <= sqrt(t^2+1/4),
          T2 decreasing in n, (1) for n]
     (4) T3(nIdeal) <= (sqrt3/216) * cK * 1048576 d0^10 t^-7 / (sigma+2)
         with cK = (1001/1000)*(501/500)^2  [||sL(sL+1)(sL+2)||
         <= (t+1)(t+2)^2 <= cK t^3 for t >= 1000, 1/(sigma+2) <= 1/2,
         n^(-sigma-2) = n^(-sigma) * n^(-1) * n^(-1),  EACH  n^(-1)
         <= 256 d0^4 / t^4  via  nIdeal >= t^4/(256 d0^4)]
     (5) own = mown <= 4 d0^2 t^-2 (1 + d0^2/(4 t^2)) exp(1/t^2)
         [in-tree S4Own: Cown < 1/t^2, exp Cown <= exp(1/t^2);
          (d^2+4t^2)/(AB) <= 4 t^-2 (1 + d^2/(4t^2)), A,B >= t^2]
     (6) exp(1/t^2) <= exp(1e-6) <= 1 + 1e-6/(1-1e-6)  (tsum tail)
   PIN:   L0b := 4 d0^2 t^-2 2^(1/2+d0) - T2b - T3b  >  own
   over the band  t >= 1000, 1/200 <= d0 < 1/2.

   dps 60, closed forms, no zeta, no RH claim.
   Output: grid of (L0b/own, exact T2b, T3b, own upper) + the
          worst point + the worst RHS pieces.
"""
import sys
sys.path.insert(0, '.')
mp = __import__('mpmath')
mp.mp.dps = 62
if not hasattr(mp.mpf, 'nstr'):
    mp.mpf.nstr = lambda self, n=59: mp.nstr(self, n)

import day059_route_c_s1_perpoint as E   # 0252 engine forms

HALF = mp.mpf('0.5')
T_PT2 = mp.mpf('3000175332800')
D0MAX = mp.mpf('0.3733819666132075199290267786')  # TEN face d0


def nIdeal(t, d0):
    sigma = HALF - d0
    return (16 * d0 * d0) ** (-1 / sigma) * t ** (2 / sigma)


def T1s(sigma, n):
    return mp.mpf('1/2') * n ** (-sigma)


def T2abs(sL, sigma, n):
    return (abs(sL) / 12) * n ** (-sigma - 1)


def T3abs(sL, sigma, n):
    return (mp.sqrt(3) / 216) * abs(
        sL * (sL + 1) * (sL + 2)) * n ** (-(sigma + 2)) / (sigma + 2)


def own_exact(t, d0):
    return abs(E.poff(t, d0, t))


def main():
    ts = [mp.mpf('1000'), mp.mpf('1e4'), mp.mpf('1e6'), mp.mpf('1e8'),
          T_PT2, mp.mpf('1e14'), mp.mpf('1e16'), mp.mpf('1e18'),
          mp.mpf('1e20')]
    d0s = [mp.mpf('1/200'), mp.mpf('1/100'), mp.mpf('0.1'), mp.mpf('0.2'),
           mp.mpf('0.3'), mp.mpf('0.35'), D0MAX, mp.mpf('0.49'),
           mp.mpf('0.499999')]

    cK = mp.mpf('1001') / 1000 * (mp.mpf('501') / 500) ** 2
    worst = None
    P = lambda *a: sys.stdout.write('  ' + ' '.join(map(str, a)) + '\n')
    P('day062 - T4OffLF in-body bound chain cross-check (dps 62)')
    P('  L0b = 4 d0^2 t^-2 * 2^(1/2+d0) - T2b - T3b   (body lower wallLo)')
    P('  ownU = 4 d0^2 t^-2 (1 + d0^2/(4 t^2)) exp(1/t^2)  (body own cap)')
    P('')
    P('  t          d0           L0b/own  ownU/own  T2b/(4d2t-2)  T3b/(4d2t-2)  own/(4d0 2 t^-2)')
    P('  ' + '-' * 100)
    for t in ts:
        for d0 in d0s:
            sigma = HALF - d0
            ni = nIdeal(t, d0)
            sL = mp.mpc(HALF - d0, t)
            T1b = mp.mpf('4') * d0 ** 2 * t ** (-2) * 2 ** (HALF + d0)
            T2b = mp.sqrt(t ** 2 + mp.mpf('1/4')) / 12 * 4096 * d0 ** 6 / t ** 6
            T3b = (mp.sqrt(3) / 216) * cK * 1048576 * d0 ** 10 \
                * t ** (-7) / (sigma + 2)
            # validity:  the bound must sit ABOVE the exact T3 at
            # nIdeal  (and  L0b  above  the  exact  wall_lo  at
            # Noff):
            T3_exact = T3abs(sL, sigma, ni)
            assert T3b >= T3_exact, (float(t), float(d0),
                                     float(T3b), float(T3_exact))
            ownU = mp.mpf('4') * d0 ** 2 * t ** (-2) * (
                1 + d0 ** 2 / (4 * t ** 2)) * mp.e ** (t ** (-2))
            L0b = T1b - T2b - T3b
            Noff = mp.ceil(ni)
            w_true = T1s(sigma, Noff) - T2abs(sL, sigma,
                                              Noff) \
                - T3abs(sL, sigma, Noff)
            #  the  in-body  bound  must  sit  BELOW  the  exact
            #  wall_lo  at  the  actual  ceiling  run  (it  is  the
            #  uniform  lower  bound  over  N  in  [nIdeal,  2 nIdeal]):
            assert L0b <= w_true * (1 + mp.mpf('1e-12')), \
                ('L0b ABOVE true wall_lo:  ', float(t), float(d0),
                 float(L0b), float(w_true))
            own = own_exact(t, d0)
            lead = mp.mpf('4') * d0 ** 2 * t ** (-2)
            r = L0b / own
            rU = ownU / own
            e2 = T2b / lead
            e3 = T3b / lead
            ownlead = own / lead
            if worst is None or r < worst[0]:
                worst = (r, t, d0, rU, e2, e3, ownlead)
            P('  %-11s %12.6f  %11.6e  %11.12f  %11.3e  %11.3e  %11.12f'
              % (mp.nstr(t, 10) if t < 1e4 else mp.nstr(t, 6), float(d0),
                 float(r), float(rU), float(e2), float(e3), float(ownlead)))
    r, t, d0, rU, e2, e3, ownlead = worst
    P('')
    P('  WORST  L0b/own   = %.10f  at  t = %s,  d0 = %.10f'
      % (float(r), mp.nstr(t, 12), float(d0)))
    P('    ownU/own       = %.12f   (RHS cap / exact own)' % float(rU))
    P('    T2b/(lead)     = %.3e    (epsilon_2)' % float(e2))
    P('    T3b/(lead)     = %.3e    (epsilon_3)' % float(e3))
    P('    own/(4 d0^2 t^-2) = %.12f' % float(ownlead))
    P('')
    P('  PIN pieces (worst point):')
    P('    2^(1/2 + d0)     = %.10f' % float(2 ** (HALF + d0)))
    P('    2^(1/2+1/200)    = %.10f   (the d0-minimum on the band)'
      % float(2 ** (HALF + mp.mpf('1/200'))))
    P('    2^(101/200)      = %.10f   (EXACT form;  pin against 1.0001)'
      % float(2 ** (mp.mpf('101') / 200)))
    P('    2^(101/200)^200  = 2^101  =  1.0001^200 ?')
    P('      2^101             = %s' % mp.nstr(2 ** 101, 40))
    P('      1.0001^200        = %s'
      % mp.nstr((mp.mpf('1.0001')) ** 200, 30))
    P('    2^101 / 1.0001^200  = %s   (huge:  the pin is trivially safe)'
      % mp.nstr(mp.mpf(2) ** 101 / (mp.mpf('1.0001')) ** 200, 25))
    P('    exp(1e-6)          = %s' % mp.nstr(mp.e ** mp.mpf('1e-6'), 25))
    P('    1 + 1e-6/(1-1e-6)  = %s   (the tsum-tail bound)'
      % mp.nstr(1 + mp.mpf('1e-6') / (1 - mp.mpf('1e-6')), 25))
    P('')
    P('  VERDICT: ' + ('in-body chain L0b > own CLOSES on the grid'
                       if r > 1 else 'DOES NOT CLOSE'))


if __name__ == '__main__':
    main()
