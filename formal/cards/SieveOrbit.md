# SieveOrbit.lean  (1251 lines)
WHAT:  KCS U4a + U4b + U4(c) (second orbit): the LEGENDRE EXACT identity
         (the machine-checked inclusion-exclusion engine of the sieve
         action, the zeta-free face of the orbit program), the discrete
         level-1 exact sieve band L1 <= Phi <= U2 (the 0181 width
         number, proved), and the U4(c) structural parity/anchor
         statement (structural, not a barrier theorem).
HOW:   U4a: phi_list (the Legendre recursion def), nodup_prime_split,
         phi_list_count, phi_list_mono, prime_dvd_prod_of_prime_list,
         legendre_identity ((phi_list x ps : Z) = sum_{d | prod ps} (mu
         d : Z) * floor(x / d) - induction on ps via
         Nat.Coprime.mul_injOn_divisors + the coprime mu-split),
         legendre_count_eq (the sum = count bridge). U4b:
         pairset/orderedpairset (the unordered and ordered distinct
         prime pairs), mcount (prime-divisibility counting function),
         L1/U2pair/U2 (the integer level-1 band endpoints), offdiagset
         (the n-covering off-diagonal), slack_t/slack_s (the pointwise
         lower/upper residuals, non-negative via slack_t_nonneg /
         slack_s_nonneg), card_mulps, mcount_single_sum (the floor sum =
         the counting sum), offdiag_pointwise + mcount_offdiag_sum
         (m*(m-1) = the pairwise off- diagonal count), ordered_parts
         (+_disjoint), ordered_eq_two_pair (the ordered pair sum = 2 x
         the unordered sum, sum_bij through Prod.swap), x_ones_sum /
         mcount_single_sum_Z / mcount_offdiag_sum_Z (the integer
         bridges), phi_indicator (Phi = the 0/1 survivor sum),
         level1_lower + level1_upper, and level1_sandwich (THE band: L1
         x ps <= (phi_list x ps : Z) <= U2 x ps). U4c (structural):
         level1_width_eq_pairwise (W = U2 - L1 = U2pair - the width IS
         the pairwise mass, the backbone of the 0181 width number),
         level1_width_nonneg, level1_position_in_band (0 <= Phi - L1 <=
         W - the sandwich corollary; the measured anchor is 0181's rho =
         (Phi - L1)/W, 0.84 -> 0.67 x-stable and z-decaying).
USES:  U4a + U4b + U4c of KCS U4 in theorem form; measured counterparts:
         tmp/kcs1_out.txt (U1a exact identity + U1b residual/worst case)
         and tmp/kcs4b_out.txt (0181 width/position: W/xV 2.10->10.12,
         rho 0.84->0.67 x-stable). Next: the U1c two-process zeta/sieve
         residual harness (also O1 of the orbital side-quest: the
         falsifiable core of the orbit reading).
GOTCHA: No RH claim: pure finite combinatorics over Nat/Int (no
          analysis, no axioms, no external provenance). Pinned-mathlib
          gotchas (0180): an ascribed division (x / d : Z) elaborates to
          Int.ediv (the ascription drives the instance) - write cast-of-
          natdiv explicitly. U4b additions (0183): a sum body does NOT
          extend past an infix - or + (in the sum-over-n of 'f n - g n'
          the '- g n' is OUTSIDE the sum with n free - parenthesize the
          whole summand); an ascribed summand (t : Z) lifts the
          operands, so (a / b : Z) is Int.ediv of lifts, NOT the cast of
          the Nat quotient - bridge such sums pointwise with norm_cast
          to Nat.cast (t) form before cast_sum rewrites (Int.ofNat terms
          do not match the Nat.cast_sum rw pattern - in a proof goal
          bridge with rw [show Int.ofNat t = (t : Z) from by norm_cast]
          first); hite : ite = 0 proves by rw [if_neg (Nat.succ_ne_zero
          k)] alone (rw auto-closes the 0 = 0, so no trailing norm_num);
          the disjointness application shape after rw
          [Finset.disjoint_left] at hdisj is 'hdisj ho hd' (membership
          proofs only, first-set side first); do not pre-rewrite hL
          where a calc's final target still contains hL.LHS (it breaks
          the calc's defeq target).
