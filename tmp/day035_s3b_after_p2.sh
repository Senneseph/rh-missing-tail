#!/bin/bash
# wait for phase2 to finish, then run the S3b anatomy probe SOLO
# (memory: one 23GB anon consumer at a time -- 2026-09-19 OOM lesson)
cd /home/jsmille/Projects/rh-missing-tail
LOG=tmp/day034b_chain.log
SLOG2=tmp/day035_s3b2.log
for i in $(seq 1 480); do          # up to 8h
  grep -q "^phase2 rc=" $LOG && break
  sleep 60
done
grep -q "^phase2 rc=0" $LOG || { echo "phase2 did not finish rc=0 -> no s3b run" > $SLOG2; echo "phase2 rc line: $(grep '^phase2 rc=' $LOG)" >> $SLOG2; exit 1; }
echo "phase2 complete $(date) -> s3b solo start" > $SLOG2
taskset -c 27 python3 -u scripts/rh/day035_s3b_ibp_anatomy.py >> $SLOG2 2>&1
echo "s3b rc=$? $(date)" >> $SLOG2
