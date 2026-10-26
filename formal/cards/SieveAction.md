# SieveAction.lean  (1973 lines)
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
         support = the U2 measurement in theorem form; WAVE-2 C (0179):
         level_census (the k-level divisor census) and parseval_units -
         the Parseval identity sum_a |F[f](a)|^2 = N * sum_m |f(m)|^2 in
         general form (DFT expansion + conjugate sum + triple-sum
         reindexing over product Finsets + the root of unity kernel
         collapse (if m = n then N else 0) + normSq bridge). The kernel
         lemma rou_sum_orthogonality is the exact engine of the kcs2
         numpy measurement.
USES:  N2 + N4 statements of KCS U2 (measurement: kcs2_fourier_sieve.py
         at N=210/30030); Wave-2 complete through C (A 0177, B 0178, C
         0179). Next: Wave-3 (sieve-action composition identities for
         the orbit program).
