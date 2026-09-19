#!/bin/bash
# unattended chain: crosscheck -> phase1 -> phase2 (item 7, H1-cert)
cd /home/jsmille/Projects/rh-missing-tail
LOG=tmp/day034b_chain.log
CCLOG=tmp/day034b_crosscheck.log
echo "chain start $(date)" >> $LOG
while true; do
  grep -q "CROSSCHECK: PASS" $CCLOG 2>/dev/null && { echo "crosscheck PASS -> phase1 $(date)" >> $LOG; break; }
  grep -q "CROSSCHECK: FAIL" $CCLOG 2>/dev/null && { echo "crosscheck FAIL -> ABORT $(date)" >> $LOG; exit 1; }
  if ! pgrep -f "day034b_h1cert.py crosscheck" > /dev/null; then
    grep -q "CROSSCHECK:" $CCLOG 2>/dev/null || { echo "crosscheck died without verdict -> ABORT $(date)" >> $LOG; exit 1; }
  fi
  sleep 60
done
rm -rf tmp/h1cert_p1
taskset -c 0-7 env P1WORKERS=8 python3 scripts/rh/day034b_h1cert.py phase1 >> $LOG 2>&1
rc1=$?
if [ $rc1 -ne 0 ]; then echo "phase1 rc=$rc1 -> ABORT $(date)" >> $LOG; exit $rc1; fi
nfiles=$(ls tmp/h1cert_p1/win_*.npz 2>/dev/null | wc -l)
echo "phase1 done: $nfiles window files -> phase2 $(date)" >> $LOG
[ "$nfiles" -eq 39 ] || { echo "expected 39 window files, got $nfiles -> ABORT" >> $LOG; exit 1; }
taskset -c 0-26 env P2WORKERS=27 python3 scripts/rh/day034b_h1cert.py phase2 >> $LOG 2>&1
rc2=$?
echo "phase2 rc=$rc2 $(date)" >> $LOG
exit $rc2
