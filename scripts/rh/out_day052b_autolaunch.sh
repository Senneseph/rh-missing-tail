#!/bin/bash
# wait for the day052b smoke to finish;  launch the full 696
# only if it printed SMOKE PASS.  (2 cores for the smoke,
#  released before the 14-worker launch.)
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh
SMOKE_PID=$(pgrep -f "day052b_reissue_696" | head -1)
while kill -0 "$SMOKE_PID" 2>/dev/null; do sleep 300; done
echo "[autolaunch] smoke exited $(date)"
if grep -q "SMOKE PASS" out_day052b_smoke.log && grep -q "exit 0" /dev/null; then
  if tail -1 out_day052b_smoke.log | grep -q "SMOKE PASS"; then
    taskset -c 0-13 env OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 \
      nohup python3 day052b_reissue_696_seq.py > out_day052b.log 2>&1 &
    echo "[autolaunch] FULL 696 launched pid $! $(date)"
  else
    echo "[autolaunch] SMOKE not clean -- NOT launching"
  fi
else
  echo "[autolaunch] SMOKE PASS line missing -- NOT launching"
fi
