#!/bin/bash
# day045b - STOP  the  H1  full  run  (supervisor  +  instance
# +  workers)  from  the  PID  files.  No  pattern  kills:
#  every  PID  from  the  files  is  verified  against  its
#  live  cmdline  BEFORE  any  signal  (PID  reuse  safety).
#
#  Usage:  bash  day045b_h1_stop.sh
#  Reads:  ckpt_h1_3e10/supervisor.pid,  ckpt_h1_3e10/run.pids
#  (format:  one  "role SP pid"  per  line)
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh || exit 1
D=ckpt_h1_3e10
PIDS=""
for f in $D/supervisor.pid $D/run.pids; do
    [ -f "$f" ] || continue
    while read -r role pid; do
        case "$role" in
            '#'*) continue ;;
            '' )  continue ;;
            supervisor|parent|worker)
                case "$pid" in
                    ''|*[!0-9]*) continue ;;
                esac
                PIDS="$PIDS $pid"
                ;;
        esac
    done < "$f"
done
# descendant  scan:  the  pid  file  can  predate  the  pool
# spawn  (workers  appear  after  the  submits);  live  children
# of  any  on-file  parent  are  part  of  the  run.
for parent in $PIDS; do
    [ -d "/proc/$parent" ] || continue
    for d in /proc/[0-9]*; do
        c=${d#/proc/}
        ppid=$(grep -m1 "^PPid:" "$d/status" 2>/dev/null | awk '{print $2}')
        if [ "$ppid" = "$parent" ]; then
            cmd=$(tr '\0' ' ' < "$d/cmdline" 2>/dev/null)
            case "$cmd" in
                *day038_h1_3e10_gpu.py*) PIDS="$PIDS $c" ;;
            esac
        fi
    done
done
if [ -z "$PIDS" ]; then
    echo "no pids on file -- nothing to stop (files missing or empty)"
    exit 0
fi
echo "pid files list:$(for p in $PIDS; do echo -n " $p"; done; echo)"
for p in $PIDS; do
    [ -d "/proc/$p" ] || { echo "pid $p: gone"; continue; }
    cmd=$(tr '\0' ' ' < "/proc/$p/cmdline" 2>/dev/null)
    case "$cmd" in
        *day038_h1_3e10_gpu.py*|*day045_h1_supervisor.sh*)
            kill -TERM "$p" 2>/dev/null && echo "pid $p: TERM sent (cmdline verified)" ;;
        *)
            echo "pid $p: SKIPPED (cmdline mismatch: ${cmd:0:70})" ;;
    esac
done
sleep 4
alive=""
for p in $PIDS; do
    [ -d "/proc/$p" ] && alive="$alive $p"
done
# a bash supervisor in  its  watchdog  sleep  defers  TERM  until
# the  sleep  child  exits  --  give  it  more  grace  before
# declaring  failure.
for t in 1 2 3; do
    [ -n "$alive" ] || break
    sleep 5
    alive=""
    for p in $PIDS; do
        [ -d "/proc/$p" ] && alive="$alive $p"
    done
done
if [ -n "$alive" ]; then
    echo "STILL ALIVE after TERM:$alive  (manual:  kill -KILL ...  only after re-verifying cmdline)"
    exit 1
fi
echo "all stopped."
