#!/usr/bin/env bash
# day035_3e9_stream.sh — BACKGROUND SUPERVISOR: the (2.0e9, 3.0e9]
# zero extension (W3 decision-maker, disk-feasible scope; the full
# 3e10 is disk-blocked).
#
# Continues the hi3e10 band (zeros_1002e6_to_2000e6.f64, ending at
# t = 2001745999.627241, N = 5,919,172,358 -- S3d-audited) at the
# shard-grid boundary 2001746000.  Same mechanism as
# day024_band_1e9.sh:  curl -L -C - (resumable) -> md5 gate vs the
# full LMFDB list (/tmp/zeta-dl/md5.txt, 14580 entries, covers the
# whole range) -> day024_platt_fast.py decode-append with the
# COUNT cross-shard Nt0 continuity assert (seam audit) -> state /
# manifest / lastN bookkeeping -> transient shard removed.
#
# SEAM AUDIT: the FIRST shard asserts Nt0 == 5,919,172,358 (the
# exact count at the hi3e10 band end, S3d) against LMFDB's own
# block bookkeeping.
#
# Disk budget: OUT grew to ~31.4GB max + one transient shard
# (~78MB).  Fits with wide margin on the 132GB-free disk.
#
# Finish gates:  total in (2e9, 5e9); strict monotone; min gap > 0;
#   N(3e9) vs RVM(3e9) tol 3;  N(band end) vs RVM tol 3;
#   first zero within one gap class of the old band end
#   (0 < new[0] - 2001745999.627241 < 1.0).
set -u
ROOT="/home/jsmille/Projects/rh-missing-tail/scripts/rh"
WORK="$ROOT/hi3e9"
OUT="$WORK/zeros_2002e6_to_3000e6.f64"
MANIFEST="$WORK/manifest.tsv"
STATE="$WORK/state.txt"
LASTN="$WORK/lastN.txt"
LOG="$WORK/supervisor.log"
DL="/tmp/zeta-dl"
NEWDIR="$DL/hi3e9"
DECODER="$ROOT/day024_platt_fast.py"
MD5="$DL/md5.txt"
FIRST=2001746000
LAST=2999246000
FRONTIER_N=5919172358     # exact count at 2001745999.627241 (S3d)

mkdir -p "$WORK" "$NEWDIR"
touch "$MANIFEST" "$STATE"
log() { echo "$(date '+%F %T') $*" | tee -a "$LOG"; }

# --- preflight: live index + md5 ---
curl -sfL --max-time 120 -H "Cookie: human=1" \
  "https://beta.lmfdb.org/riemann-zeta-zeros/data/" \
  -o "$DL/data_list_3e9.html" || { log "FATAL: index crawl failed"; exit 1; }
grep -q "zeros_${FIRST}\.dat" "$DL/data_list_3e9.html" \
  || { log "FATAL: index crawl got a gate page or range not public (cookie?)"; exit 1; }
grep -q "zeros_${LAST}\.dat" "$DL/data_list_3e9.html" \
  || { log "FATAL: LAST shard zeros_${LAST}.dat not in live index"; exit 1; }
grep -q "zeros_${FIRST}\.dat" "$MD5" \
  || { log "FATAL: md5.txt missing entry for FIRST shard"; exit 1; }
python3 - "$DL/data_list_3e9.html" "$FIRST" "$LAST" "$WORK/needed_shards.txt" <<'PYEOF'
import re, sys
html = open(sys.argv[1], encoding="ascii", errors="replace").read()
names = sorted({int(m.group(1)) for m in re.finditer(r"zeros_(\d+)\.dat", html)})
f, l, out = int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
need = [n for n in names if f <= n <= l]
open(out, "w").write("\n".join(str(n) for n in need))
print("NEEDED_SHARDS=%d" % len(need), flush=True)
assert 400 <= len(need) <= 560, "shard count implausible: %d" % len(need)
assert all(("zeros_%d.dat" % n) in html for n in (need[0], need[-1]))
PYEOF
N_NEED=$(wc -l < "$WORK/needed_shards.txt")
log "preflight OK: $N_NEED shards in [$FIRST, $LAST]; frontier N = $FRONTIER_N; band file: $OUT"
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
  if [ $((done_n % 25)) -eq 0 ] || [ "$n" = "$LAST" ]; then
    mins=$(( ( $(date +%s) - t_wall ) / 60 ))
    est=$(( ( $(date +%s) - t_wall ) / done_n * ( N_NEED - done_n ) / 60 ))
    log "progress: $done_n/$N_NEED shards (last $fn, N up to $Nt1f); wall ${mins}m; ETA ~${est}m"
  fi
done < "$WORK/needed_shards.txt"

# --- finish gates ---
python3 - "$OUT" <<'PYEOF'
import numpy as np, sys, math
out = sys.argv[1]
FRONTIER_N = 5919172358
OLD_END = 2001745999.627241
a = np.fromfile(out, dtype=np.float64)
assert 2e9 < a.size < 5e9, "band size implausible: %d" % a.size
d = np.diff(a)
assert d.min() > 0, "band NOT strictly monotone"
def rvm(t):
    x = t / (2 * math.pi)
    return x * (math.log(x) - 1.0) + 7 / 8
le = int(np.searchsorted(a, 3.0e9, side="right"))
N_3e9 = FRONTIER_N + le
N_end = FRONTIER_N + a.size
t_end = float(a[-1])
g1 = N_3e9 - rvm(3e9)
g2 = N_end - rvm(t_end)
g0 = float(a[0]) - OLD_END
print("BAND-FINISH total=%d zeros, t range [%.6f, %.6f]" % (a.size, a[0], t_end))
print("band min gap = %.9f" % d.min())
print("seam: first new zero - old band end = %.6f (must be in (0, 1))" % g0)
print("N(3e9) = %d vs RVM %.2f |diff| = %.2f (tol 3)" % (N_3e9, rvm(3e9), g1))
print("N(band end %.1f) = %d vs RVM %.2f |diff| = %.2f (tol 3)" % (t_end, N_end, rvm(t_end), g2))
assert 0.0 < g0 < 1.0, "seam gap FAILED"
assert abs(g1) <= 3 and abs(g2) <= 3, "RVM gate FAILED"
print("FINISH-GATES-PASS")
PYEOF
rc=$?
if [ "$rc" = 0 ]; then log "BAND-3E9-DONE"; else log "BAND-3E9-FAILED (finish gates rc=$rc)"; exit 1; fi
