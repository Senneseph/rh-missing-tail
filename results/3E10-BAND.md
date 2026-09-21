# The 3e10 band — verified dataset (provenance)

File: `../scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64`
(10TB exFAT drive,  `rh-missing-tail/hi3e10/`),  f64 little-
endian,  one zero ordinate per 8 bytes,  strictly increasing
t of zeta zeros on the critical line.

**Content.**  t in `[2,999,246,000.182257,  30,001,045,999.981976]` —
the (2.999e9, 3.0e10] extension of the 3e9 band,  92,577,877,714
zeros.  Total at band end:  **N(3.0001e10) = 101,639,672,418**;
**N(3.0e10) = 101,635,962,231** (von Mangoldt RVM differs by
0.09 at 3.0e10 and by 0.78 at the band end;  tolerance 3 on
both).  Min gap in the band:  2.2888e-05.  Seam into the old
band (gap first zero minus 2,999,245,999.862950):  0.319307.

**Verification chain (each layer independent).**
1. **Per shard**:  12,858 LMFDB shards,  each md5-gated
   against the published manifest before any decode
   (12,858/12,858).
2. **Count chain**:  every shard carries per-block Nt0/Nt1
   (RVM integer counts at block ends);  the decoder asserts
   the in-shard chain,  the cross-shard Nt0 == running
   lastN,  and the seam into the previous block,  on EVERY
   one of the 12,858 shards at decode time.
3. **Ordered byte-exact append**:  single-threaded appender,
   appends in t order,  updates lastN/manifest/state only
   after each append;  band size in bytes == 8 x (running
   count) re-verified at every handoff and at the end:
   740,623,021,712 == 8 x 92,577,877,714,  CHAIN-EXACT.
4. **Full-band sweep** (day036 finish gates):  strict
   monotonicity over all 9.26e10 zeros,  positive min gap,
   seam in (0,1),  both RVM gates inside tolerance by a wide
   margin.

**Producer.**  `scripts/rh/day035_t25_orchestrator.py`
(12 md5-gated fetch/decode pipeline,  2 reserved cores
never touched) over `day035_3e10_stream.sh`'s state files;
decoder `day024_platt_fast.py` (unchanged,  half-ulp
boundary rule documented in-code from the zeros_4964846000
incident).  Every incident,  handoff,  and the OOM-killed
in-process gate:  see `DISCOVERY_LOG.md`.
