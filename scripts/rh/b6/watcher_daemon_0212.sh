#!/bin/bash
# 0212 B6 board watcher daemon (prepared, resumable, alerted).
# Cycle 300s; single python process; network-only, ~0 CPU.
# Owner compute policy: 4 cores always left open — this job uses none.
# Stop: kill $(cat $T/watcher_0212.pid); rm $T/watcher_0212.pid
T=/home/jsmille/Projects/rh-missing-tail/tmp/b6audit/tracker
LOG=$T/watcher_0212.log
PIDFILE=$T/watcher_0212.pid
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "watcher already running (pid $(cat "$PIDFILE"))"
  exit 0
fi
echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT
echo "watcher daemon started $(date -u +%Y-%m-%dT%H:%M:%SZ) pid $$" >> "$LOG"
while true; do
  ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  out=$(python3 "$T/tracker_watch2.py" 2>&1); rc=$?
  first=$(echo "$out" | head -1)
  echo "$ts rc=$rc | $first" >> "$LOG"
  sleep 300
done
