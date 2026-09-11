#!/usr/bin/env bash
# day010_ext6e6_supervisor.sh — supervised [3e5, 6e6] GPU zero walk (D1 data).
# SAFETY (owner requirement: correct answer, never an unbounded loop):
#  * MAX_RESTARTS=3 — after 3 restarts the supervisor STOPS and reports STALLED.
#  * STALL = walk log quiet for 45 min while the process is alive (a healthy
#    pass prints a line every ~14 min) -> kill process group, RESUME.
#  * RESUME point = last segment boundary having BOTH dt and dt2 flip files
#    (the walk itself certifies per segment and breaks on dt/dt2 mismatch).
#  * CERT-FAIL = dt/dt2 DISAGREE logged by the current instance -> NO
#    automatic resume past a certificate failure; supervisor stops for a
#    human decision.
#  * Final chain (only after a real DONE line): strict-monotone + count +
#    S O(1) float check, then onset re-run G=6e6 in the VERIFIED docker
#    environment (mpmath 1.3.0) -> out_day010_onset_G6e6.txt.
set -u
cd /home/jsmille/Projects/kainos-logos/scripts/rh || exit 1
W1=6000000
W0_START=300000
SEG=200000
LOG=out_day010_ext6e6_supervisor.txt
RUN=out_day010_ext6e6_walk.txt
CUPY=~/venvs/cupy/bin/cupy_py
MAX_RESTARTS=3
STALL_SECS=2700
FINAL=zeros_T6000000_ext_full.txt
touch "$LOG"
log(){ echo "[$(date -u +%H:%M:%S)] $*" | tee -a "$LOG"; }

resume_w0(){
  local b=300000 f0 f1
  while [ "$b" -lt "$W1" ]; do
    local b1=$(( b + SEG )); [ "$b1" -gt "$W1" ] && b1=$W1
    f0="flips_seg_$(printf %09d $b)_$(printf %09d $b1)_dt.txt"
    f1="flips_seg_$(printf %09d $b)_$(printf %09d $b1)_dt2.txt"
    if [ -f "$f0" ] && [ -f "$f1" ]; then b=$b1; else echo "$b"; return 0; fi
  done
  echo "$W1"   # everything already walked; nothing to do
}

W0=$W0_START
ANCHOR=zeros_T300000_ext_full.txt
restart=0
while :; do
  if [ -f "$FINAL" ] && tail -50 "$RUN" | grep -q "^DONE:"; then log "DONE already present — skip to chain"; break; fi
  W0=$(resume_w0)
  if [ "$W0" -ge "$W1" ]; then log "resume: all segments present but no DONE — verifying chain directly"; break; fi
  ANCHOR=zeros_T${W0}_ext_full.txt
  [ "$W0" = "300000" ] && ANCHOR=zeros_T300000_ext_full.txt
  [ -f "$ANCHOR" ] || { log "FATAL: anchor $ANCHOR missing — stopping (no loop)"; exit 1; }
  mark=$(wc -c < "$RUN")
  log "LAUNCH W0=$W0 W1=$W1 anchor=$ANCHOR (restart=$restart)"
  setsid "$CUPY" day009b_zero_walk_1e5_6e6_gpu.py "$W1" "$W0" "$ANCHOR" >>"$RUN" 2>&1 &
  pid=$!
  stalled=0
  while kill -0 "$pid" 2>/dev/null; do
    sleep 300
    now=$(date +%s); mt=$(stat -c %Y "$RUN" 2>/dev/null || echo "$now")
    if [ $(( now - mt )) -gt "$STALL_SECS" ]; then
      log "STALL: log quiet $(( (now-mt)/60 )) min — killing group $pid"
      kill -TERM -"$pid" 2>/dev/null; sleep 45; kill -KILL -"$pid" 2>/dev/null
      stalled=1; break
    fi
  done
  if tail -n +$(( mark + 1 )) "$RUN" | grep -q "^DONE:"; then log "instance DONE"; break; fi
  if tail -n +$(( mark + 1 )) "$RUN" | grep -q "DISAGREE"; then
    log "CERT-FAIL: dt/dt2 disagree in this instance — NO auto-resume past a certificate failure. STOPPED for human decision."; exit 2
  fi
  if [ $(( restart )) -ge "$MAX_RESTARTS" ]; then
    log "STALLED: MAX_RESTARTS=$MAX_RESTARTS reached — supervisor stopping (no loop)."; exit 1
  fi
  restart=$(( restart + 1 ))
  log "instance ended (${stalled:+stalled}; exit) — restart $restart/$MAX_RESTARTS"
done

log "FINAL CHAIN: verifying $FINAL"
python3 -u chain_verify_6e6.py >>"$LOG" 2>&1 || { log "CHAIN-VERIFY FAILED — stopping (no false certification)"; exit 3; }
log "FINAL CHAIN: onset re-run G=6e6 in verified docker env (mpmath 1.3.0)"
# G_MAX = list coverage (6000000; was a 600000 typo in day-010)
docker run --rm -v /home/jsmille/Projects/kainos-logos:/work kainos-dev:dev \
  python3 -u /work/scripts/rh/day009c_onset_pred_ext.py \
  /work/scripts/rh/zeros_T${W1}_ext_full.txt 6000000 \
  > scripts/rh/out_day010_onset_G6e6.txt 2>&1
if [ $? -eq 0 ]; then log "CHAIN DONE: onset G=6e6 -> out_day010_onset_G6e6.txt"; else log "CHAIN ONSET RUN FAILED — inspect out_day010_onset_G6e6.txt"; exit 4; fi
