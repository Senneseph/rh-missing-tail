#!/usr/bin/env bash
# day042 - post-gate queue  (owner-directed #4:  D2, D3, D4).
#
# Waits for the day036 finish gates to reach a verdict on the
# re-fetched 3e10 band,  then:
#   -  GATE PASS   =>  chmod a-w the band  (persisted data rule),
#       run day040  (D2 top-100 excursions + D4 decade eps),
#       run day041  (D3 dps-30 S-at-zeros kill-shot on the top 5).
#   -  GATE FAIL   =>  abort immediately:  no chmod,  no probes
#       (the band is NOT canonical until the gates pass).
#
# Bounded jobs:  day040 ~ 40-50 min single-thread streaming;
# day041 ~ a few minutes (110 dps-30 evaluations).  Read-only on
# the band;  one core  (taskset -c 28).
#
# Launch:  nohup bash day042_postgate_queue.sh &
#   (this script itself is a waiter,  it holds no CPU).
set -u
RH=/home/jsmille/Projects/rh-missing-tail/scripts/rh
BAND=$RH/hi3e10/zeros_2999e6_to_30000e6.f64
GLOG=$RH/out_day036_gates_refetch.log
QLOG=$RH/out_day042_queue.log

stamp() { date '+%F %T' | xargs -I{} echo "{} $1" >> $QLOG; }

stamp "queue start (D2/D3/D4 post-gate)"

# 1)  wait for the gate verdict  (max 9 hours).
for i in $(seq 1 540); do
  if grep -q "FINISH-GATES-PASS" "$GLOG" 2>/dev/null; then
    break
  fi
  if grep -qE "AssertionError|Traceback" "$GLOG" 2>/dev/null; then
    stamp "GATES-FAIL detected  (no chmod,  no probes);  aborting"
    exit 1
  fi
  if ! pgrep -f "day036_finish_gates.py run" > /dev/null 2>&1; then
    stamp "gate process dead without PASS  (no chmod,  no probes);"
    stamp "aborting"
    exit 1
  fi
  sleep 120
done
grep -q "FINISH-GATES-PASS" "$GLOG" 2>/dev/null || {
  stamp "queue timeout waiting for the gates  (no chmod,  no probes)"
  exit 1
}
stamp "gates PASS seen  ->  band is canonical;  chmod a-w"
chmod a-w "$BAND"
stamp "chmod a-w done  ($(stat -c '%s bytes  %A' "$BAND"))"

# 2)  D2 + D4  (single D-band sweep;  consistency re-derives the
#     certified A2 pins as a live self-check).
stamp "day040 start  (D2 + D4)"
taskset -c 28 python3 "$RH/day040_d2d4_dband.py" >> $QLOG 2>&1
RC40=$?
stamp "day040 exit=$RC40"

# 3)  D3  (needs the day040 top-100 table).
if [ $RC40 -eq 0 ] && [ -f "$RH/out_day040_top100.tsv" ]; then
  stamp "day041 start  (D3)"
  taskset -c 28 python3 "$RH/day041_d3_dps30.py" >> $QLOG 2>&1
  RC41=$?
  stamp "day041 exit=$RC41"
else
  stamp "day041 SKIPPED  (day040 failed or no top-100 table)"
fi

stamp "queue DONE  (logs:  out_day040_dband.txt,  out_day041_d3.txt)"
