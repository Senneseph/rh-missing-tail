#!/usr/bin/env bash
# day043 - wait for the day042 queue to finish (and for the ollama
# copy to stop touching the NVMe),  then run the day038
# ONE-WINDOW PROFILE  (H1CERT_SMOKE)  —  the profile-first gate
# for the full  (i)  H1-launch  (the full launch itself stays the
# owner's call;  this is only the bounded  ~minutes  profile that
# produces the measured ETA).
#
# Bounded:  profile only  (one window  +  error-budget  bookkeeping).
# 14 workers on cores 0-27  (2 physical cores reserved,  owner cap).
#
# Launch:  nohup bash day043_profile_waiter.sh &
set -u
RH=/home/jsmille/Projects/rh-missing-tail/scripts/rh
QLOG=$RH/out_day042_queue.log
PLOG=$RH/out_day038_profile_aftergates.log

stamp() { date '+%F %T' | xargs -I{} echo "{} $1" >> "$PLOG"; }

stamp "profile waiter start"

# 1)  wait for the day042 queue to terminate  (max 18 hours).
for i in $(seq 1 540); do
  if grep -q "queue DONE" "$QLOG" 2>/dev/null; then
    break
  fi
  if grep -qE "aborting|GATES-FAIL|queue timeout" "$QLOG" 2>/dev/null; then
    stamp "queue ABORTED  (gates not PASS)  ->  no profile;  exiting"
    exit 1
  fi
  sleep 120
done
grep -q "queue DONE" "$QLOG" 2>/dev/null || {
  stamp "waiter timeout on the queue  ->  no profile;  exiting"
  exit 1
}
stamp "queue DONE seen"

# 2)  wait for the ollama copy  (NVMe reader)  to finish.
while pgrep -f "rsync.*ollama" > /dev/null 2>&1; do
  stamp "ollama copy still running  (NVMe contention)  ->  waiting"
  sleep 120
done
stamp "NVMe clear"

# 3)  the profile  (the exact day038 smoke env).
cd "$RH" || exit 1
export WORKERS=14
export H1CERT_SMOKE=1
stamp "profile start  (day038 H1CERT_SMOKE)"
taskset -c 0-27 ~/venvs/cupy/bin/cupy_py -u day038_h1_3e10_gpu.py > $PLOG.tmp 2>&1
RC=$?
cat $PLOG.tmp >> "$PLOG" 2>/dev/null
rm -f $PLOG.tmp
stamp "profile exit=$RC  (log:  $PLOG)"
