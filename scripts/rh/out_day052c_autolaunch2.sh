#!/bin/bash
# day052c autolaunch v2:  file-based -- wait for the SMOKE verdict
# line in the smoke log (no pgrep:  v1 tracked a pid that was not
# the smoke,  gave up at 02:23,  left the healthy smoke orphaned).
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh
LOG=out_day052c_smoke.log
while ! grep -q "SMOKE PASS" "$LOG" 2>/dev/null \
   && ! grep -q "SMOKE FAIL" "$LOG" 2>/dev/null; do sleep 120; done
echo "[autolaunch2] smoke verdict seen $(date)"
if grep -q "SMOKE PASS" "$LOG"; then
  taskset -c 0-13 env OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 \
    nohup python3 day052c_reissue_696_ledger.py > out_day052c.log 2>&1 &
  echo "[autolaunch2] FULL 505 re-issue launched pid $! $(date)"
else
  echo "[autolaunch2] SMOKE FAIL -- NOT launching (investigate)"
fi
