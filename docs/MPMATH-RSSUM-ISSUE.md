# MPMATH RS-ZETA FAR-HEIGHT ANCHOR AUDIT (v2, revised)

**Status: LOCAL AUDIT RECORD. Upstream filing on hold pending the
s34l/s34k trace results (T2-T4).**

## Short version

The "corrupted far mpmath anchors" of the s31z2/s30 census are, so far,
**not mpmath corruption at all.** They are **height artifacts**: every old
census probe evaluated `mpm.zeta(1/2 + i*t)` at `mpf(repr(t))` -- the
decimal-repr round-trip of the row's f64 height -- not at the row's exact
f64 integer `t`. At far heights the repr decimal differs from the exact
integer by O(10..10^4) in `t`, and `|Z(t)|` varies violently on that scale
(zero density ~ 6 per unit `t` at these heights).

Reproducing the repr height under an independent C/quad channel returns
the old anchor values exactly:

| row   | old mpmath anchor      | repr t (offset)       | independent C at repr t | C at exact t (canonical) |
|-------|------------------------|-----------------------|-------------------------|--------------------------|
| 5e7G  | 0.5676737452478491     | ...880 + 120          | (mpmath @repr: 0.5676737452478491, exact digits) | -1.395123890841 |
| 1e8G  | 4.4929618099354        | ...760 + 240          | 4.492961809935          | 1.455437142349           |
| 3e8G  | -1.5728021802385705    | ...256 - 256          | -1.572802180239         | 3.284789950625           |
| 5e8G  | 1.7289704098           | ...8800 + 200 (s31z2) | -- (T: repr mpmath pending) | 2.937019955061 |

The 5e7G column was reproduced with fresh mpmath at the repr height
(matches the recorded anchor to all 16 printed digits). The 1e8G/3e8G
columns were reproduced with the C/quad channel at the repr height
(matches to 12-13 digits).

## What was wrong in the old census scripts

`scripts/rh/s30_far_extreme.py` (and `s31z2_5e8G_zeta.py`) did:

    t = S.G_LAST * 1e8          # f64, e.g. 3000104599998197760 (+0)
    z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(t))))   # <= repr(t) = "3.000104599998198e+18"

`repr(t)` is a 17-significant-digit decimal. `mpf(repr(t))` parses it
**exactly** (decimal exactness is a feature of mpmath). That exact decimal
is NOT the f64 integer: it is the decimal value of the shortest
round-trip string, offset from the f64 by a small integer:

    row     exact f64 t              repr decimal t        offset
    2e6G    60002091999963952        ...99639 50            -2
    5e6G    150005229999909888       ...99909 900           +12
    1e7G    300010459999819776       ...99776+24            +24
    2e7G    600020919999639552       ...639600              +48
    5e7G    1500052299999098880      ...099000              +120
    1e8G    3000104599998197760      ...198000              +240
    3e8G    9000313799994592256      ...4592000             -256
    5e8G    15000522999990988800     ...0989000             +200
    1e9G    30001045999981977600     ...1978000             +400
    1e10G   300010459999819726848    ...19700000            -26848
    3e10G   900031379999459246080    ...459200000           -46080

At these heights zero spacing is ~0.16 in t, so an offset of +120 passes
through ~700 zeros: the "wrong" anchors are simply the true zeta values at
slightly different heights. They were never wrong *as values at their
heights*; they were anchored to the wrong height.

## The separate 5e8G two-state observation (pending resolution)

The instrumented s34e pair (fresh processes, both at the **exact** t, both
dps-40, one zeta call each) produced:

- clean: log|zeta| = 2.937019955061246, captured widths entry=173 / S1=235
- other: log|zeta| = 1.7289704098      , captured field "wp_sum" = 175

Revised reading: the old "anchor" 1.7289704098 came from s31z2, which ran
at the **repr** height (t+200). The instrumented "other" run ran at the
**exact** height. So the two 5e8G values may be a height difference (repr
vs exact), not a state difference. Open tests:

- T: fresh mpmath dps-40 at repr 5e8G (t+200):
  - if it returns 1.72897  -> fully explained by the repr artifact;
  - if it returns a third value -> genuine two-state behavior at one height.
- T: forced low entry precision (~dps 23) at exact 5e8G:
  - if it returns 1.72897  -> the value is a deterministic function of the
    entry width state; the "corruption" is the width ladder misbehaving at
    that mid width;
  - if it returns something else -> no link to the width state.

Pending results are logged in the discovery entry 010x for this work.

## C-channel note (fixed)

The C/quad channel's `struct zchain` originally held `t` as a C `double`,
and its `ZETAC_TEST_T` hook parsed with `strtod`. Both silently quantize
far heights to the f64 grid (O(2^k) at these t), collapsing off-grid probe
heights onto the row integer. The table rows themselves are unaffected
(their literals round to the exact f64 row integers). Fixed: the hook now
parses with `strtoflt128` and feeds an f128 override into
`compute_height`. After the fix the C channel demonstrably distinguishes
neighboring heights (1e8G exact vs +240: logzeta 1.455437142349 vs
4.492961809935).

## Verdict (current)

1. mpmath 1.4.1 has not been shown to be wrong at any height in this
   audit; every "corrupted" value so far reappears exactly at its repr
   height under an independent channel.
2. The canonical rows now use exact f64 heights with the C/quad channel of
   record:
   1e8G 1.455437142349 / 3e8G 3.284789950625 / 5e8G 2.937019955061 /
   1e9G -1.211098446310 / 1e10G 0.455887846369 / 3e10G 2.012486593295.
3. The far-row M integers recomputed on exact-t channels are unchanged
   (s34g: quantization residual 0 for 1e8G/3e8G/5e8G).
4. THE 5e8G TWO-STATE QUESTION IS CLOSED: the two values were two
   HEIGHTS (exact t vs repr t+200), not two width states.  T1/T2 (fresh
   dps-40, exact t) and T3 (prec-78 forced, exact t) all return the
   clean 2.937019955061246 (= C, all digits);  T4 (fresh dps-40, repr
   t+200) returns the old 1.7289704098077738 through the SAME clean
   width chain.  The old evidence 'wp_sum = 175' was a misattributed
   field, not a corrupted low width.
5. RESOLUTION FLOOR (s34w):  at coarse digit settings (dps-15) the
   repr shifts of the low rows (2..48 units at 6e16..6e17) are
   INVISIBLE - the width estimate (53-bit branch) quantizes the sieved
   term count to an effective height resolution of ~9..90 units.  The
   old s25 anchors were taken at dps-40, where those shifts show;  the
   high-row shifts (120..256 units) show even at dps-15.
6. BOUNDARY (s34k, t = 2190076357998684160, a = 5.9039e8):  C =
   -1.863686420607;  mpmath dps-15 = dps-40 = -1.8636864206066681
   (bit-identical through 17 digits).  No precision- or dps-induced
   discrepancy at the boundary;  the historical 'dps-40 collapse'
   readings are the same height / artifact class.
7. The static data reading guide (exact heights, repr offsets, channels,
   old anchors, M identity inputs, provenance, trap list) is the
   generated ledger:  docs/DATA-LEDGER.md.
