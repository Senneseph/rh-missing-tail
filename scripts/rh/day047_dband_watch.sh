#!/usr/bin/env bash
# day047 D-band watcher: marks the log when the day048->day047 splice run
# exits (cleanly or not). One-shot per launch; idempotent marker.
set -u
RH="$(cd "$(dirname "$0")" && pwd)"
LOG="$RH/out_day047_dband_splice.log"
PID=884478
while kill -0 "$PID" 2>/dev/null; do sleep 60; done
{
  echo "WATCHER: day047 process $PID exited at $(date '+%F %T EDT')"
  tail -n 6 "$LOG"
} >> "$LOG"
