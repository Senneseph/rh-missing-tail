#!/usr/bin/env bash
# ============ day046_slice_queue.sh — auto-advance through H1 slices =================
# Watches the current H1 instance; the moment it exits CLEANLY (engine printed
# FULL-DONE), launches the next slice from the queue file. If it exits WITHOUT
# FULL-DONE (hang, crash-loop, owner stop), HOLDs and refuses to launch — owner decides.
#
# Queue file: ckpt_h1_3e10/slice.queue
#   one H1_WINDOWS spec per line,  '#' comments ok,  consumed top-down
# State:   ckpt_h1_3e10/slice_queue.state  (entries consumed, survives restarts)
# Pid:     ckpt_h1_3e10/slice_queue.pid
# Log:     out_slice_queue.log
#
# LAUNCH:   nohup bash day046_slice_queue.sh >/dev/null 2>&1 &
# STOP:     kill $(cat ckpt_h1_3e10/slice_queue.pid)    (running instance is untouched)

set -u
S="$(cd "$(dirname "$0")" && pwd)"
CK="$S/ckpt_h1_3e10"
Q="$CK/slice.queue"
STATE="$CK/slice_queue.state"
PIDF="$CK/slice_queue.pid"
LOG="$S/out_slice_queue.log"
MAINLOG="$S/out_day038_full.log"

say(){ echo "[$(date '+%F %T')] $*" >> "$LOG"; }

echo $$ > "$PIDF"
say "slice-queue watcher started (pid $$)"
[ -f "$STATE" ] || echo 0 > "$STATE"

sleep_holding(){ sleep 60; }

while :; do
  n_consumed=$(cat "$STATE")
  # next unconsumed entry (line number = n_consumed + 1 among spec lines)
  entry=$(grep -vnE '^\s*(#|$)' "$Q" 2>/dev/null | awk -F: -v off="$n_consumed" 'NR==off+1{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  running=$(ps -eo pid,cmd | grep -cE "[d]ay045_h1_supervisor.sh|[d]ay038_h1_3e10_gpu.py")

  if [ "$running" -gt 0 ]; then
    # current instance still going — wait for it to exit
    sleep_holding
    continue
  fi

  # nothing running: decide
  if [ -z "$entry" ]; then
    say "queue exhausted, no running instance — watcher idle-exit"
    rm -f "$PIDF"
    exit 0
  fi

  # did the last run finish cleanly?  (FULL-DONE must appear in the recent tail of
  # the main log;  it is printed only after the window set is 24/24 x all and
  # the ledger assembly ran.)
  if tail -n 200 "$MAINLOG" 2>/dev/null | grep -q "H1  FULL-DONE"; then
    # only trust it if this marker came AFTER the queue last consumed an entry or
    # run — the marker is run-scoped: the engine reprints its banner each instance.
    say "previous run FULL-DONE — launching next slice: H1_WINDOWS=\"$entry\""
    n_consumed=$((n_consumed + 1))
    echo "$n_consumed" > "$STATE"
    before=$(stat -c %s "$S/out_day045.log" 2>/dev/null || echo 0)
    ( cd "$S" && H1_WINDOWS="$entry" nohup bash day045_h1_supervisor.sh >> out_day045.log 2>&1 & )
    # Confirm via the LOG, not via ps:  a ps match can be some OTHER
    # supervisor still holding the lock, in which case the new one
    # exited with "ANOTHER SUPERVISOR HOLDS THE LOCK".
    sleep 20
    if tail -c +$((before + 1)) "$S/out_day045.log" 2>/dev/null | grep -q "instance  1  launching"; then
      say "launch confirmed (instance 1 launching in supervisors log)"
    else
      if tail -c +$((before + 1)) "$S/out_day045.log" 2>/dev/null | grep -q "ANOTHER SUPERVISOR HOLDS THE LOCK"; then
        say "HOLD: launch of \"$entry\" refused — another supervisor holds the lock. Owner decides (stop the other, or re-run the watcher)."
      else
        say "HOLD: launch of \"$entry\" not confirmed in supervisor log — owner decides"
      fi
      rm -f "$PIDF"; exit 10
    fi
    rm -f "$MAINLOG.done-mark"
  else
    say "HOLD: no running instance and NO recent FULL-DONE — previous slice did not complete clean. Next would have been: $entry. Owner decides (re-run slice, fix, or clear queue)."
    rm -f "$PIDF"
    exit 8
  fi
done
