# SieveAction.lean  (1355 lines)
WHAT:  KCS U2 (second orbit): the finite Fourier sieve operator package
         - the formal twin of discovery 0172.
HOW:   rou (primitive N-th root) + char_pow + dft + mark_notdiv + raman;
         mark_notdiv_idempotent (M^a = M^b pointwise),
         mark_notdiv_commute (M_p M_q = M_q M_p pointwise), chime_comb
         (F[1_{p|m}] = N*1_{a=0} - (N/p)*1_{(N/p)|a}, the 3-case comb
         formula - the 24-error wall), raman_prime_closed (p-1 / -1);
         WAVE-2 A (0177): rou_sum_orthogonality, mobius_sum_nat,
         mobius_unit_indicator, raman_inclusion_exclusion (the full-
         sieve symbol = the Ramanujan mu-sum); WAVE-2 B (0178):
         raman_multiplicativity (c_{mn}(K) = c_m(K)*c_n(K) for (m,n)=1 -
         divisor-product bijection Nat.Coprime.mul_injOn_divisors + mu
         multiplicativity on coprimes + coprime divisibility split),
         raman_full_support (c_N(a) & 0 for squarefree N - strong
         induction over the squarefree decomposition M = p*k + prime
         closed form (p-1 / -1) + B1 + nonzero product). Squarefree full
         support = the U2 measurement in theorem form.
USES:  N2 + N4 statements of KCS U2 (measurement: kcs2_fourier_sieve.py
         at N=210/30030); Wave-2 tail (raman_level_census /
         parseval_units) staged next.
