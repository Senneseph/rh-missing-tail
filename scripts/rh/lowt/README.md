# low-t zero data (0, 1200]

- `zeros_0_to_1p2e3.f64` — the 813 nontrivial zeros in (0, 1200],
  bit-exact slice of the committed `../zeros_T10000000_lmfdb.txt`
  (LMFDB 1e7 list, md5-locked project oracle).
  md5 2f5e5b17b12906db8bba9bcab105e6ea
- `zeros_0_to_1p2e3.dec20.txt` — same, %.20f text.
- `zeros_checkpoint.npz` — the final checkpoint of the independent
  mpmath bisection walk (day030_lowt_zeros.py, 225 zeros): matches
  the slice bit-exact in float64 (max |d| = 0.0) — the
  cross-check artifact referenced by the DISCOVERY_LOG day030
  low-t entry. Regenerable; kept as evidence, not load-bearing.

Verification record: monotone, min gap 0.2211 (pair 1054.7810 ->
1055.002146...), count 813 = N(1200) asymptotic (+0), all 813 at
the mpmath noise floor (|zeta(1/2+it)| <= 1.96e-12, gate 1e-8),
first-ten vs fetched published 20-digit table (< 1e-13).
