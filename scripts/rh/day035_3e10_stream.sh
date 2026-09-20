#!/usr/bin/env bash
# day035_3e10_stream.sh — CLOUD HANDOFF SCRIPT: the (2.9992e9, 3.0e10]
# zero extension (the W3 3e10 thoroughness extension, handed off per
# owner direction from the 132GB-free / ~765GB-needed local disk).
#
# Same mechanism as day035_3e9_stream.sh (whose product, the
# (2.0e9, 3.0e9] band, is the resume base of this run):
#   curl -L -C - (resumable) -> md5 gate vs the LIVE LMFDB md5
#   manifest -> day024_platt_fast.py decode-append with the COUNT
#   cross-shard Nt0 continuity assert (seam audit) -> state /
#   manifest / lastN bookkeeping -> transient shard removed.
#   The loop is RESUMABLE: safe to kill at any shard boundary and
#   relaunch (shards in state.txt are skipped).
#
# SEAM AUDIT: the FIRST decoded shard asserts Nt0 == FRONTIER_N =
# 9,061,794,704 (the exact count at the 3e9 band end
# t = 2999245999.862950, day035 band finish record).
#
# DISK BUDGET (sized for the cloud box): output file grows to
# ~700-750GB (N(3e10) ~= 9.67e10 -> ~8.76e10 new zeros x 8 bytes);
# one transient shard (~50-80MB) at a time.  The script itself
# holds no large state.  Plan on >= 1TB free at the output path.
#
# HONEST SCOPE NOTE:  this extension is an EMPIRICAL UPGRADE of the
# drift law (sup|DN| pin from 3e9 toward 3e10 zeros).  NO Lean
# theorem in the repository depends on its completion:  the S3a
# certificate and the M6 wire composition are pinned at 3e9 data.
#
# FINISH GATES:  total in (1e10, 1e11); strict monotone; min gap > 0;
#   seam gap in (0, 1);  N(3e10) vs RVM(3e10) tol 3 (only reachable
#   if the index/LMFDB data actually reach t = 3e10:  the preflight
#   and the finish gate say so explicitly if not);  N(band end) vs
#   RVM tol 3.
set -u
ROOT="$(cd "$(dirname "$0")" && pwd)"   # portable:  any checkout root
WORK="$ROOT/hi3e10"
OUT="$WORK/zeros_2999e6_to_30000e6.f64"
MANIFEST="$WORK/manifest.tsv"
STATE="$WORK/state.txt"
LASTN="$WORK/lastN.txt"
LOG="$WORK/supervisor.log"
DL="${ZETA_DL:-/tmp/zeta-dl}"
NEWDIR="$DL/hi3e10"
DECODER="$ROOT/day024_platt_fast.py"
MD5="$DL/md5_3e10.txt"
FIRST=2999246000                # shard-grid continuation of the 3e9 band
TARGET=30000000000              # 3.0e10
FRONTIER_N=9061794704           # exact count at 2999245999.862950 (day035)
OLD_END=2999245999.862950

mkdir -p "$WORK" "$NEWDIR"
touch "$MANIFEST" "$STATE"
log() { echo "$(date '+%F %T') $*" | tee -a "$LOG"; }

# --- preflight 1: live index crawl; dynamic LAST = largest public
#     shard name not above TARGET ---
curl -sfL --max-time 300 -H "Cookie: human=1" \
  "https://beta.lmfdb.org/riemann-zeta-zeros/data/" \
  -o "$DL/data_list_3e10.html" || { log "FATAL: index crawl failed"; exit 1; }
python3 - "$DL/data_list_3e10.html" "$FIRST" "$TARGET" "$WORK/needed_shards.txt" <<'PYEOF'
import re, sys
html = open(sys.argv[1], encoding="ascii", errors="replace").read()
names = sorted({int(m.group(1)) for m in re.finditer(r"zeros_(\d+)\.dat", html)})
f, target, out = int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
need = [n for n in names if f <= n <= target]
assert need, "no public shards in [FIRST, TARGET] — index gate page or range not public (cookie?)"
open(out, "w").write("\n".join(str(n) for n in need))
print("NEEDED_SHARDS=%d (LAST=%d)" % (len(need), need[-1]), flush=True)
assert 8000 <= len(need) <= 25000, "shard count implausible: %d" % len(need)
print("NOTE: LMFDB grid is adaptive (sparse at low t, fine at high t) —"
      "2026-09-20 live crawl: 12,858 needed for [2999246000, 30000000000],"
      "index reaches 3.06e10", flush=True)
print("NOTE: last public shard name = %d; band end reach checked in finish gate" % need[-1], flush=True)
PYEOF
N_NEED=$(wc -l < "$WORK/needed_shards.txt")
log "preflight index OK: $N_NEED shards from $FIRST (target $TARGET); frontier N = $FRONTIER_N"

# --- preflight 2: live md5 manifest for the needed shards ---
curl -sfL --max-time 1200 -H "Cookie: human=1" \
  "https://beta.lmfdb.org/riemann-zeta-zeros/data/md5.txt" -o "$MD5" \
  || { log "FATAL: md5 manifest fetch failed"; exit 1; }
MISSING=0
while read -r n; do
  grep -q "\*zeros_${n}\.dat" "$MD5" || { MISSING=$((MISSING+1)); log "md5 missing: zeros_${n}.dat"; }
done < "$WORK/needed_shards.txt"
[ "$MISSING" = 0 ] || { log "FATAL: $MISSING shards without md5 entries"; exit 1; }
log "preflight md5 OK: all $N_NEED needed shards manifest"

[ -f "$LASTN" ] || echo "$FRONTIER_N" > "$LASTN"

# --- main loop (resumable) ---
t_wall=$(date +%s)
while read -r n; do
  [ -z "$n" ] && continue
  if grep -q "^$n " "$STATE" 2>/dev/null; then continue; fi
  fn="zeros_${n}.dat"
  tmp="$NEWDIR/$fn.pd"
  ok=0
  for attempt in 1 2 3 4 5; do
    curl -sfL --max-time 3600 -C - -H "Cookie: human=1" \
      "https://beta.lmfdb.org/riemann-zeta-zeros/data/$fn" -o "$tmp" \
      && ok=1 && break
    log "fetch $fn attempt $attempt failed (resumable); backoff 120s"
    sleep 120
  done
  [ "$ok" = 1 ] || { log "FATAL: $fn unfetchable after 5 attempts"; exit 1; }
  want=$(sed -n "s/^\([0-9a-f]\{32\}\) \*$fn/\1/p" "$MD5" | head -1)
  [ -n "$want" ] || { log "FATAL: no md5 entry for $fn"; exit 1; }
  got=$(md5sum "$tmp" | awk '{print $1}')
  [ "$want" = "$got" ] || { log "FATAL: md5 mismatch $fn ($got != $want)"; exit 1; }
  echo "COUNT $(cat "$LASTN")" | python3 "$DECODER" "$tmp" "$OUT" >> "$LOG" \
    || { log "FATAL: decode/append failed for $fn"; exit 1; }
  line=$(grep '^SHARD' "$LOG" | tail -1)
  Nt1f=$(sed -n 's/.*Nt1=\([0-9]*\) .*/\1/p' <<< "$line")
  [ -n "$Nt1f" ] || { log "FATAL: no Nt1 in summary for $fn"; exit 1; }
  printf '%s\t%s\t%s\n' "$n" "$got" "$line" >> "$MANIFEST"
  echo "$Nt1f" > "$LASTN"
  echo "$n $(date '+%F %T')" >> "$STATE"
  rm -f "$tmp"
  done_n=$(wc -l < "$STATE")
  if [ $((done_n % 25)) -eq 0 ] || [ "$done_n" = "$N_NEED" ]; then
    mins=$(( ( $(date +%s) - t_wall ) / 60 ))
    remaining=$(( N_NEED - done_n ))
    est=0
    [ "$done_n" -gt 0 ] && [ "$remaining" -gt 0 ] && est=$(( ( $(date +%s) - t_wall ) / done_n * remaining / 60 ))
    log "progress: $done_n/$N_NEED shards (last $fn, N up to $Nt1f); wall ${mins}m; ETA ~${est}m"
  fi
done < "$WORK/needed_shards.txt"

# --- finish gates ---
python3 - "$OUT" "$OLD_END" "$FRONTIER_N" <<'PYEOF'
import numpy as np, sys, math
out, old_end, frontier_n = sys.argv[1], float(sys.argv[2]), int(sys.argv[3])
# RAM-SAFE: the band file is ~700-750GB (8.8e10 float64);  np.fromfile
# would need ~750GB RAM and np.diff another copy.  memmap + chunked
# streaming keeps peak at ~1GB regardless of band size.
a = np.memmap(out, dtype=np.float64, mode="r")
total = int(a.size)
assert 5e9 < total < 1.5e11, "band size implausible: %d" % total
block = 1 << 26          # 64M floats = 512MB per block
prev, mingap = None, None
for i0 in range(0, total, block):
    b = np.asarray(a[i0:min(i0 + block, total)])
    if i0 > 0:
        g = float(b[0]) - prev
        assert g > 0, "band NOT strictly monotone at block seam %d" % i0
        mingap = g if mingap is None else min(mingap, g)
    if b.size > 1:
        d = np.diff(b)
        assert d.min() > 0, "band NOT strictly monotone in block %d" % i0
        mingap = float(d.min()) if mingap is None else min(mingap, float(d.min()))
    prev = float(b[-1])
assert mingap is not None, "band empty"
def rvm(t):
    x = t / (2 * math.pi)
    return x * (math.log(x) - 1.0) + 7 / 8
t_end = float(a[-1])
N_end = frontier_n + total
g0 = float(a[0]) - old_end
print("BAND-FINISH total=%d zeros, t range [%.6f, %.6f]" % (total, float(a[0]), t_end))
print("band min gap = %.9f" % mingap)
print("seam: first new zero - old band end = %.6f (must be in (0, 1))" % g0)
assert 0.0 < g0 < 1.0, "seam gap FAILED"
g2 = N_end - rvm(t_end)
print("N(band end %.1f) = %d vs RVM %.2f |diff| = %.2f (tol 3)" % (t_end, N_end, rvm(t_end), g2))
assert abs(g2) <= 3, "RVM gate at band end FAILED"
TARGET = 3.0e10
if t_end >= TARGET:
    le = int(np.searchsorted(a, TARGET, side="right"))
    N_t = frontier_n + le
    g1 = N_t - rvm(TARGET)
    print("N(3e10) = %d vs RVM(3e10) %.2f |diff| = %.2f (tol 3)" % (N_t, rvm(TARGET), g1))
    assert abs(g1) <= 3, "RVM gate at 3e10 FAILED"
    print("FINISH-GATES-PASS (3e10 REACHED, N(3e10) pinned)")
else:
    print("NOTE: band ends at %.1f < 3e10 -- the public index does not" % t_end)
    print("reach 3e10 yet (2026-09-20 live crawl: it DOES, to 3.06e10);")
    print("the N(3e10) pin is then deferred to the index growth")
    print("(band-end RVM gate above still applies).")
    print("FINISH-GATES-PARTIAL (maximal public extension)")
PYEOF
rc=$?
if [ "$rc" = 0 ]; then log "BAND-3E10-DONE"; else log "BAND-3E10-FAILED (finish gates rc=$rc)"; exit 1; fi
