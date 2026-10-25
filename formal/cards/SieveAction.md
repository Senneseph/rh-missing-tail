# SieveAction.lean  (556 lines)
WHAT:  KCS U2 (second orbit): the finite Fourier sieve operator package
         - the formal twin of discovery 0172.
HOW:   rou (primitive N-th root) + char_pow + dft + mark_notdiv + raman;
         mark_notdiv_idempotent (M^a = M^b pointwise),
         mark_notdiv_commute (M_p M_q = M_q M_p pointwise), chime_comb
         (F[1_{p|m}] = N*1_{a=0} - (N/p)*1_{(N/p)|a}, the 3-case comb
         formula - the 24-error wall), raman_prime_closed (p-1 / -1).
USES:  N2 statement of KCS U2 (measurement: kcs2_fourier_sieve.py at
         N=210/30030); Wave-2 (raman_full_support / inclusion-exclusion
         / multiplicativity / parseval_units) staged next.
