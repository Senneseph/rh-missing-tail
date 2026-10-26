# SieveOrbit.lean  (377 lines)
WHAT:  KCS U4a (second orbit): the LEGENDRE EXACT identity - the
         machine-checked inclusion-exclusion engine of the sieve action
         (the zeta-free face of the orbit program).
HOW:   phi_list (the Legendre recursion def), nodup_prime_split,
         phi_list_count (the recursion IS the count of n in [1,x]
         coprime to prod ps - set equality through classical.em splits +
         the p-multiples-as-scaled-tail-set image lemma
         (Nat.mul_div_cancel' + le_div_iff_mul_le)), phi_list_mono
         (monotonicity in x via Finset.card_mono),
         prime_dvd_prod_of_prime_list (p prime, p | prod ls -> p in ls),
         legendre_identity (THE identity: (phi_list x ps : Z) = sum_{d |
         prod ps} (mu d : Z) * (x / d) - induction on ps; the engine:
         (p*P).divisors = p.divisors x P.divisors via
         Nat.Coprime.mul_injOn_divisors + sum_image + sum_product +
         Prime.divisors = {1,p} + sum_pair, and the coprime
         multiplicative split mu(p*d) = mu p * mu d = -mu d
         (map_mul_of_coprime) making the p-half of the divisor sum
         exactly the negated x/p-summand of the recursion),
         legendre_count_eq (the sum = count bridge).
USES:  U4a of KCS U4 in theorem form; measured counterparts:
         tmp/kcs1_out.txt (U1a exact identity + U1b residual/worst case,
         identity=EXACT rows). Next: U4(b) orbit composition identities
         + the U1c two-process zeta/sieve residual harness.
GOTCHA: No RH claim: pure finite combinatorics over Nat/Int (no
          analysis, no axioms, no external provenance). Pinned-mathlib
          gotchas (0180): an ascribed division (x / d : Z) elaborates to
          Int.ediv (the ascription drives the instance) - write cast-of-
          natdiv explicitly; rintro decomposes under negations (use
          intro + obtain for (X & Y) & ~Z); omega is unreliable on
          division/prime atoms (not_le + le_of_lt_succ + le_antisymm +
          succ_le_of_lt (Prime.pos)); rw [one_mul] rewrites ALL
          occurrences at once; a let-bound product dangles under inner
          induction on the same variable - lift the list lemma
          standalone (auto-generalized IH is curried over the dependent
          hprime chain); Finset.sum_pair orders follow the set order
          ({1,p} -> f 1 + f p, hence ne_one .symm).
