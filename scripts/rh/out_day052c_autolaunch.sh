# SUPERSEDED by out_day052c_autolaunch2.sh:  v1's pgrep picked up a
# short-lived wrapper pid (gave up at 02:23 while the smoke parent +
# 14 workers were healthy).  v2 waits on the SMOKE PASS/FAIL verdict
# LINE in the smoke log (file-based,  race-free).
#!/bin/bash
# wait for the day052c smoke (24 worst-24 points vs day049f refs);
# launch the full in-hand-505 run only on SMOKE PASS.
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh
SMOKE_PID=$(pgrep -f "day052c_reissue" | head -1)
while kill -0 "$SMOKE_PID" 2>/dev/null; do sleep 300; done
echo "[autolaunch] smoke exited $(date)"
if tail -5 out_day052c_smoke.log 2>/dev/null | grep -q "SMOKE PASS"; then
  taskset -c 0-13 env OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 \
    nohup python3 day052c_reissue_696_ledger.py > out_day052c.log 2>&1 &
  echo "[autolaunch] FULL 505 re-issue launched pid $! $(date)"
else
  echo "[autolaunch] SMOKE not clean -- NOT launching"
fi
