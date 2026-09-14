#!/usr/bin/env bash
# day024_band_1e9.sh — BACKGROUND SUPERVISOR for open work item #4
# (the nominal data band (3.15e7, 1e9]).  Owner research-order: the
# dataset is the PUBLIC one (beta.lmfdb.org/riemann-zeta-zeros/data/,
# Platt-format shards — 24b record) — download, verify, store; do not
# recompute.
#
# The on-disk frontier is EXACT (GATE 0d, 2026-09-14): the last local
# shard zeros_29846000 ends at t = 31946000.000000, final zero #
# 73,426,758 (so the docs' "3.15e7" nominal edge was a rounding of
# 3.1946e7).  This stream covers the continuation:
#     zeros # 73,426,759 .. N(1.008446e9)   (shard starts in [3.1946e7,
#     1006346000], the last one overshooting 1e9 by ~8.44e5 rad).
#
# Gates (all loud, P-0.8):
#   GATE 0 (offline, run before launch — RECORD, not re-checked here):
#     (a) bit-exact anchor: first zeta zero 14.13472514173469379045…
#         decoded bit-identical at float64 (day024_platt_fast TEST1)
#     (b) cross-implementation: 2000 zeros @ the 2.9846e7 frontier
#         BIT-IDENTICAL vs the dps-50 mpmath exact decode (the 24b-
#         verified arithmetic) (TEST2b)
#     (c) full-shard structural pass: Nt continuity, block seams,
#         strict monotone, interval (t0 < z < t1), header-exact walk
#   Loop (per shard):
#     1. curl -L -C - (resumable)   2. md5 gate vs md5.txt
#     3. decode+append with CROSS-SHARD Nt0 continuity (lastN.txt)
#     4. state.txt / lastN.txt += ; transient shard removed
#   FINISH:
#     (a) band stats: total, t_max, min gap, strict monotone
#     (b) N(1e9) = 73426758 + count(band <= 1e9) vs Riemann-von
#         Mangoldt (main term + 7/8, S-bound tolerance 3)
#     (c) final cumulative Nt1 vs RVM(band end) tolerance 3
#     (d) BAND-1E9-DONE marker
#
# Assets (NOT in git — .gitignore):
#   scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64  (raw LE float64,
#       zeros sorted from the frontend frontier 3.1946e7, ~22 GB)
#   scripts/rh/hi1e9/manifest.tsv, state.txt, lastN.txt, supervisor.log
set -u
ROOT="/home/jsmille/Projects/rh-missing-tail/scripts/rh"
WORK="$ROOT/hi1e9"
OUT="$WORK/zeros_hi31946e6_to_1e9.f64"
MANIFEST="$WORK/manifest.tsv"
STATE="$WORK/state.txt"
LASTN="$WORK/lastN.txt"
LOG="$WORK/supervisor.log"
DL="/tmp/zeta-dl"
NEWDIR="$DL/shards_new"
DECODER="$ROOT/day024_platt_fast.py"
MD5="$DL/md5.txt"
FIRST=31946000
LAST=1006346000
FRONTIER_N=73426758     # last zero # on disk (GATE 0d)

mkdir -p "$WORK" "$NEWDIR"
log() { echo "$(date '+%F %T') $*" | tee -a "$LOG"; }

# --- preflight: index + md5 ---
curl -sfL --max-time 120 -H "Cookie: human=1" \
  "https://beta.lmfdb.org/riemann-zeta-zeros/data/" \
  -o "$DL/data_list_live.html" || { log "FATAL: index crawl failed"; exit 1; }
grep -q "zeros_31946000.dat" "$DL/data_list_live.html" \
  || { log "FATAL: index crawl got a gate page (cookie?)"; exit 1; }
grep -q "zeros_31946000.dat" "$MD5" || { log "FATAL: md5.txt missing/invalid"; exit 1; }
python3 - "$DL/data_list_live.html" "$FIRST" "$LAST" "$WORK/needed_shards.txt" <<'PYEOF'
import re, sys
html = open(sys.argv[1], encoding="ascii", errors="replace").read()
names = sorted({int(m.group(1)) for m in re.finditer(r"zeros_(\d+)\.dat", html)})
f, l, out = int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
need = [n for n in names if f <= n <= l]
open(out, "w").write("\n".join(str(n) for n in need))
print("NEEDED_SHARDS=%d" % len(need), flush=True)
assert all(("zeros_%d.dat" % n) in html for n in (need[0], need[-1]))
PYEOF
N_NEED=$(wc -l < "$WORK/needed_shards.txt")
[ "$N_NEED" -gt 100 ] || { log "FATAL: shard list implausible ($N_NEED)"; exit 1; }
[ -f "$LASTN" ] || echo "$FRONTIER_N" > "$LASTN"
log "preflight OK: $N_NEED shards in [$FIRST, $LAST]; frontier N = $FRONTIER_N; band file: $OUT"

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
a = np.fromfile(out, dtype=np.float64)
assert a.size > 1e8, "band implausibly small: %d" % a.size
d = np.diff(a)
assert d.min() > 0, "band NOT strictly monotone"
le = int(np.searchsorted(a, 1.0e9, side="right"))
def rvm(t):
    x = t / (2 * math.pi)
    return x * (math.log(x) - 1.0) + 7 / 8
N_1e9 = 73426758 + le
N_end = 73426758 + a.size
t_end = float(a[-1])
g1 = abs(N_1e9 - rvm(1e9))
g2 = abs(N_end - rvm(t_end))
print("BAND-FINISH total=%d zeros, t range [%.6f, %.6f]" % (a.size, a[0], a[-1]))
print("band min gap = %.9f" % d.min())
print("N(1e9) = %d vs RVM %.2f |diff| = %.0f (tol 3)" % (N_1e9, rvm(1e9), g1))
print("N(band end %.1f) = %d vs RVM %.2f |diff| = %.0f (tol 3)" % (t_end, N_end, rvm(t_end), g2))
assert g1 <= 3 and g2 <= 3, "RVM gate FAILED"
print("FINISH-GATES-PASS")
PYEOF
rc=$?
if [ "$rc" = 0 ]; then log "BAND-1E9-DONE"; else log "BAND-1E9-FAILED (finish gates rc=$rc)"; exit 1; fi
