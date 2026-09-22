#!/bin/bash
# day044 - H1 full-run launcher,  gated  on  the  (i)  profile
# (owner  pre-authorized  the  full  H1:  "you  have  my  permission
#  to  kick  off  H1  when  the  time  is  right";  the  profile  is
#  the  gate  that  measures  the  ETA  and  the  error  budget).
#
#  Waits  for  the  profile  (out_day038_profile_aftergates.log)  to
#  complete  ("wall  = "  line  =  _summary  done),  then  applies
#  the  PRE-REGISTERED  reading:
#    C-1:  "STATUS:  C-1  candidate  (all  points  certified  >=  1)"
#          ->  LAUNCH  the  full  H1  (14  workers,  cores  0-27).
#    anything  else  (C-2/C-3  reading,  or  crash)  ->  HOLD:
#          stamp  the  reason,  do  not  launch,  owner  decides.
#
#  Read-only  until  the  final  launch  line.  Log:  out_day044_h1_waiter.log
cd "$(dirname "$0")" || exit 1
LOG=out_day044_h1_waiter.log

stamp() { echo "$(date '+%F %T') $*"; } >> "$LOG" 2>&1

stamp "day044 waiter start (waiting for the (i) profile to complete)"
i=0
while ! grep -q "wall = " out_day038_profile_aftergates.log 2>/dev/null; do
    if grep -q "Traceback" out_day038_profile_aftergates.log 2>/dev/null; then
        stamp "profile CRASHED (Traceback in log) -> HOLD, no launch, owner decides"
        tail -15 out_day038_profile_aftergates.log >> "$LOG" 2>&1
        exit 2
    fi
    if ! pgrep -f "day038_h1_3e10_gpu.py" > /dev/null 2>&1; then
        stamp "profile PROCESS GONE without completion -> HOLD, no launch"
        tail -15 out_day038_profile_aftergates.log >> "$LOG" 2>&1
        exit 3
    fi
    sleep 120
    i=$((i + 1))
    if [ "$i" -gt 360 ]; then
        stamp "waiter TIMEOUT (120h) before profile completion"
        exit 1
    fi
done

PSTATUS=$(grep "STATUS:" out_day038_profile_aftergates.log | tail -1)
stamp "profile complete:  $PSTATUS"
grep -E "worst certified margin|margin_cert < 1|margin_new  < 1|wall = " \
    out_day038_profile_aftergates.log | tail -6 >> "$LOG" 2>&1

if grep -q "STATUS: C-1 candidate (all points certified >= 1)" \
        out_day038_profile_aftergates.log; then
    stamp "C-1  pre-registered  reading  met  ->  LAUNCHING  full  H1"
    stamp "  (14  workers,  taskset  0-27,  cupy  venv,  no  SMOKE)"
    nohup taskset -c 0-27 env WORKERS=14 \
        ~/venvs/cupy/bin/cupy_py -u day038_h1_3e10_gpu.py \
        > out_day038_full.log 2>&1 &
    stamp "full  H1  pid  $!   (log:  out_day038_full.log)"
else
    stamp "NOT  C-1  ->  HOLD.  No  full  launch.  Owner  decides."
    stamp "  (pre-registered  readings  C-2/C-3  apply  —  see"
    stamp "   day038  header  and  docs/COMPUTE-DEPLOY-PLAN.md)"
fi
stamp "day044 waiter done"
