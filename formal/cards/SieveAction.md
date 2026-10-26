# SieveAction.lean  (1075 lines)
WHAT:  KCS U2 (second orbit): the finite Fourier sieve operator package
         - the formal twin of discovery 0172.
HOW:   rou (primitive N-th root) + char_pow + dft + mark_notdiv + raman;
         mark_notdiv_idempotent (M^a = M^b pointwise),
         mark_notdiv_commute (M_p M_q = M_q M_p pointwise), chime_comb
         (F[1_{p|m}] = N*1_{a=0} - (N/p)*1_{(N/p)|a}, the 3-case comb
         formula - the 24-error wall), raman_prime_closed (p-1 / -1);
         WAVE-2 A2 (0177): mobius_sum_nat (Mertens vanishing),
         mobius_unit_indicator (1_{(m,N)=1} = mu-sum over common
         divisors), raman_inclusion_exclusion (the full-sieve symbol is
         the Ramanujan sum: sum_{d|N, (N/d)|a} mu(d)*(N/d) - via sum-
         swap + Finset.sum_bij reindex m=d*j + level collapse (rou N)^d
         = (rou (N/d)) + rou_sum_orthogonality), rou_sum_orthogonality
         (additive-character orthogonality).
USES:  N2 + N4 statements of KCS U2 (measurement: kcs2_fourier_sieve.py
         at N=210/30030); Wave-2 remainder (raman_multiplicativity /
         raman_full_support / raman_level_census / parseval_units)
         staged next.
