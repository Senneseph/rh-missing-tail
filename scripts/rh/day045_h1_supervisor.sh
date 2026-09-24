#!/bin/bash
# day045 - H1  full-run  supervisor:  the  crash-safe  relaunch  loop
# for  the  checkpointed  full  fill  (day038  FULL  mode).
#
#  Guarantees  (checkpoint  design  in  day038):
#   -  every  point  (29  windows  x  24  offsets  =  696)  is
#     persisted  to  ckpt_h1_3e10/  the  moment  it  completes;
#   -  a  crash  (process  or  box)  loses  at  most  the  in-flight
#     points  (one  ~  100-min  sweep  each,  at  most  13  of
#     them);
#   -  any  restart  resumes  from  the  checkpoints  (resubmits
#     only  the  missing  point  jobs);
#   -  NOTHING  is  ever  silently  dropped:  mid-checkpoint
#     corruption  halts  the  supervisor  (owner  decides);
#     a  torn  partial  line  at  the  END  of  a  point  file
#     drops  exactly  that  one  point  (it  is  recomputed).
#
#  After  a  REBOOT  (which  kills  this  supervisor  too),  the
#  whole  recovery  is  these  two  lines:
#     cd  /home/jsmille/Projects/rh-missing-tail/scripts/rh
#     nohup  bash  day045_h1_supervisor.sh  >>  out_day045.log  2>&1  &
#
#  LAUNCH  =  env  WORKERS=4  H1_THREADS=8  :  4  GPU  CONTEXTS
#  (x 8 slab  threads  each  =  32  slab  threads  inside  the
#  100Gi  program  budget,  the  owner's  Strix-Halo  model:
#  40  CUs  -  6  reserved  =  34,  ~2.9GiB/thread).  Contexts
#  are  capped  by  the  8  SDMA  queues  (including  Xorg);
#  threads  are  not  --  threads  of  one  context  share  one
#  SDMA  queue  and  spread  over  the  CUs.  4  +  Xorg  =  5
#  clients  leaves  the  queue  budget  far  from  the  wall
#  (the  09:27/16:13  "No  more  SDMA  queue"  incidents  were
#  11-12  CLIENTS  =  10-11  processes  +  Xorg).
#
#
#  The  supervisor  exits  only  on:  an  instance  rc=0  with
#  "H1  FULL-DONE"  inside  THAT  INSTANCE'S  OWN  log  span
#  (slice  complete),  a  band  integrity  failure  (rc  5),  a
#  corrupt  checkpoint  (instance  rc  3),  MAX_ATTEMPTS  (30),
#  a  held  lock,  the  24  h  memory  hold,  or  the
#  AUTO-RESUME  budget  (see  the  stall  watchdog  below).
#
#  STALL  WATCHDOG  (best  effort,  owner-approved):  the  engine
#  can  die  SILENTLY  (a  worker  future  dies;  the  parent  wait
#  blocks  forever  --  no  rc,  no  crash,  no  log  lines;  seen
#  3  x  on  Strix).  While  an  instance  runs,  the  supervisor
#  samples  progress  (main-log  size  +  total  checkpointed
#  points)  every  60  s.  No  change  for  STALL_MIN  minutes
#  (default  30,  only  after  the  run  is  >=  STALL_MIN_RUN
#  minutes  old)  =>  best-effort  kill  +  relaunch;  the
#  deterministic  resume  re-scans  checkpoints  and  resubmits
#  only  the  missing  point(s).  If  that  does  not  work  --
#  after  AUTORESUME_MAX  (default  5)  auto-resumes  --  the
#  supervisor  gives  up  and  stops  (owner  decides).
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh || exit 1
exec 200>supervisor_day045.lock
if ! flock -n 200; then
    echo "$(date '+%F %T') ANOTHER SUPERVISOR HOLDS THE LOCK - exiting"
    exit 1
fi
stamp() { echo "$(date '+%F %T') $*"; }

stamp "day045 supervisor start (lock held)"

# --- band integrity guard (read-only spot check;  never  writes) ----
BAND=hi3e10/zeros_2999e6_to_30000e6.f64
SZ=$(stat -c %s "$BAND")
PERM=$(stat -c %a "$BAND")
FIRST=$(od -An -j0 -N8 -tf8 "$BAND" | tr -d ' ')
LAST=$(od -An -j$((SZ - 8)) -N8 -tf8 "$BAND" | tr -d ' ')
stamp "band spot check:  size=$SZ  perm=$PERM  first=$FIRST  last=$LAST"
if [ "$SZ" != "740623021712" ] || [ "$PERM" != "555" ]; then
    stamp "BAND SIZE/PERM MISMATCH  (expect  size=740623021712  perm=555)  --  HOLD,  NO LAUNCH,  owner decides"
    exit 5
fi
if [ "$FIRST" != "2999246000.182257" ] || [ "$LAST" != "30001045999.981976" ]; then
    stamp "BAND FIRST/LAST MISMATCH  --  HOLD,  NO LAUNCH,  owner decides"
    exit 5
fi

# --- L-shard  guard  (the  reboot  wiped  /tmp/zeta-dl/shards;
# the  canonical  copy  is  now  in  the  repo:  lshards/,  md5
# pinned  in  lshards/md5.txt  =  beta.lmfdb.org  official  list).
# Verify  size  +  md5  of  the  11  needed  shards,  and  fall
# back  to  /tmp  for  old  code  paths.
SHARDS=lshards
# QUOTES  REQUIRED:  unquoted,  the  first  number  becomes  an
# env  prefix  and  10946000  the  command  slot  ("command  not
# found"),  $NEED  never  persists,  and  the  per-shard  loop
# below  silently  does  nothing  (catch  this  class:  the  guard
# was  no-op  for  every  launch  until  it  was  read  line-by-line).
NEED="8846000 10946000 13046000 15146000 17246000 19346000 21446000 23546000 25646000 27746000 29846000"
mkdir -p /tmp/zeta-dl/shards
cnt=0
for n in $NEED; do
    cnt=$((cnt + 1))
    f="$SHARDS/zeros_${n}.dat"
    if [ ! -s "$f" ]; then
        stamp "L-SHARD  MISSING:  $f  --  HOLD,  owner  decides"
        exit 7
    fi
    if [ ! -s "/tmp/zeta-dl/shards/zeros_${n}.dat" ]; then
        cp "$f" "/tmp/zeta-dl/shards/zeros_${n}.dat"
        stamp "L-shard  restored  to  /tmp:  zeros_${n}.dat"
    fi
done
if [ "$cnt" != "11" ]; then
    stamp "L-SHARD  COUNT  EXPECTED  11,  GOT  $cnt  --  HOLD,  owner  decides"
    exit 7
fi
# the  pins  are  extracted  from  the  official  lmfdb  list
# (lshards/md5.txt).  A  missing  list  used  to  make  the  grep
# below  a  silent  no-op  (gate  passed  with  zero  pins)
# --  that  is  now  a  hard  fail.
if [ ! -s "$SHARDS/md5.txt" ]; then
    stamp "L-SHARD  PIN  FILE  MISSING  (lshards/md5.txt,  the  official  lmfdb  md5  list)  --  HOLD,  owner  decides"
    exit 7
fi
(cd "$SHARDS" && grep -hE "\\*zeros_(8846000|10946000|13046000|15146000|17246000|19346000|21446000|23546000|25646000|27746000|29846000)\\.dat" md5.txt | sed 's/ \*/ /' > "/tmp/shardcheck.$$.txt") && if ! (cd "$SHARDS" && md5sum --quiet -c "/tmp/shardcheck.$$.txt" >/dev/null 2>&1); then stamp "L-SHARD  MD5  MISMATCH  --  HOLD,  owner  decides"; exit 7; fi
rm -f "/tmp/shardcheck.$$.txt"
stamp "L-shards  verified  (11  x  md5  against  official  lmfdb  pins)"

# --- PID  file  (owner's  win:  no  more  guessing) -------------------
mkdir -p ckpt_h1_3e10
echo "supervisor $$" > ckpt_h1_3e10/supervisor.pid.tmp
mv ckpt_h1_3e10/supervisor.pid.tmp ckpt_h1_3e10/supervisor.pid
stamp "supervisor pid $$  written  to  ckpt_h1_3e10/supervisor.pid"
trap 'rm -f ckpt_h1_3e10/supervisor.pid' EXIT

# --- memory  pre-guard:  never  launch  while  the  box  is  tight
# (llama  et  al  can  hold  +40Gi  at  any  time) ---------------------
mem_gib() { awk '/MemAvailable:/{printf "%d", $2/1048576}' /proc/meminfo; }
MEM_HOLD_GIB=${MEM_HOLD_GIB:-108}   # Strix: 28 reserve + (4x8x 2.5 GiB);  small-RAM boxes override (5900X: 18)
W_ENV_WORKERS=${WORKERS:-4}         # GPU contexts  (supervisor env = per-machine config)
W_ENV_THREADS=${H1_THREADS:-8}     # slab threads per context
W_CPUREANGE=${CPURANGE:-0-27}      # taskset range  (5900X: 0-23)
MEM_HOLDS=0
MEM_HOLD_MAX=288          # 24  h  of  5-min  holds,  then  give  up

MAX=30
i=0
autores=0
giveup=0

# --- stall  watchdog  config  (best  effort  auto-resume) ----------
STALL_MIN=${STALL_MIN:-30}           # no  log/ckpt  change  this  long  =>  stall
STALL_MIN_RUN=${STALL_MIN_RUN:-45}   # instance  must  have  been  up  this  long  first
AUTORESUME_MAX=${AUTORESUME_MAX:-5}  # then  give  up:  owner  decides
pts_total(){ cat ckpt_h1_3e10/*.pts 2>/dev/null | grep -c '^ok,'; }
kill_instance_tree(){
    # unambiguous  on  this  machine:  the  only  processes  whose
    # cmdline  is  the  engine  are  THIS  instance  (+  its  mp
    # spawn  children);  the  supervisor's  own  cmdline  never  matches.
    pkill -TERM -f day038_h1_3e10_gpu.py 2>/dev/null
    local t=0
    while [ "$t" -lt 20 ] && pgrep -f day038_h1_3e10_gpu.py >/dev/null 2>&1; do
        t=$((t + 1)); sleep 1
    done
    if pgrep -f day038_h1_3e10_gpu.py >/dev/null 2>&1; then
        pkill -KILL -f day038_h1_3e10_gpu.py 2>/dev/null
        sleep 2
    fi
}

while :; do
    i=$((i + 1))
    if [ "$i" -gt "$MAX" ]; then
        stamp "MAX_ATTEMPTS=$MAX  reached  --  stopping,  owner decides"
        break
    fi
    AVAIL=$(mem_gib)
    if [ "$AVAIL" -lt "$MEM_HOLD_GIB" ]; then
        MEM_HOLDS=$((MEM_HOLDS + 1))
        if [ "$MEM_HOLDS" -gt "$MEM_HOLD_MAX" ]; then
            stamp "memory  hold  >  24  h  (MemAvailable  $AVAIL  GiB)  --  stopping,  owner decides"
            break
        fi
        stamp "MEM  HOLD  $MEM_HOLDS:  MemAvailable  $AVAIL  GiB  <  $MEM_HOLD_GIB  GiB  --  sleeping  300  s"
        sleep 300
        i=$((i - 1))   # memory  holds  do  not  consume  an  attempt
        continue
    fi
    MEM_HOLDS=0
    WSEL=${H1_WINDOWS:-}
    WENV=; [ -n "$WSEL" ] && WENV="H1_WINDOWS=$WSEL"   # no inner quotes:  env gets the raw token
    stamp "instance  $i  launching  (env  WORKERS=$W_ENV_WORKERS  contexts  x  H1_THREADS=$W_ENV_THREADS  threads;  windows=${WSEL:-all};  instance  memguard  derives  actual  count;  resume  from  ckpt_h1_3e10/)"
    LOGPOS=$(stat -c %s out_day038_full.log 2>/dev/null || echo 0)
    # shellcheck disable=SC2086
    taskset -c "$W_CPUREANGE" env WORKERS="$W_ENV_WORKERS" H1_THREADS="$W_ENV_THREADS" H1_PER_THREAD_GIB=2.5 \
        H1_GPU_CLIENT_BUDGET=11 H1_XORG_CLIENTS=1 $WENV \
        ZETA_SHARDS_DIR="$PWD/$SHARDS" \
        /home/jsmille/venvs/cupy/bin/cupy_py -u day038_h1_3e10_gpu.py \
        >> out_day038_full.log 2>&1 &
    IPID=$!
    # --- watchdog  sampling  (progress  =  log  size  OR  pts) ----
    last_sz=$LOGPOS
    last_pt=$(pts_total)
    last_change=$(date +%s)
    t0=$last_change
    while kill -0 "$IPID" 2>/dev/null; do
        sleep 60
        now=$(date +%s)
        sz=$(stat -c %s out_day038_full.log 2>/dev/null || echo "$last_sz")
        pt=$(pts_total)
        if [ "$sz" != "$last_sz" ] || [ "$pt" != "$last_pt" ]; then
            last_sz=$sz; last_pt=$pt; last_change=$now
        fi
        idle_min=$(( (now - last_change) / 60 ))
        run_min=$(( (now - t0) / 60 ))
        if [ "$idle_min" -ge "$STALL_MIN" ] && [ "$run_min" -ge "$STALL_MIN_RUN" ]; then
            if [ "$autores" -ge "$AUTORESUME_MAX" ]; then
                stamp "WATCHDOG:  auto-resume  budget  exhausted  ($AUTORESUME_MAX  used,  still  stalling)  --  stopping,  owner decides"
                kill_instance_tree
                giveup=1
                break
            fi
            autores=$((autores + 1))
            stamp "WATCHDOG  STALL:  no  progress  for  ${idle_min}  min  (pts=$pt)  --  best-effort  auto-resume  $autores/$AUTORESUME_MAX  (kill  +  relaunch;  resume  re-scans  checkpoints)"
            kill_instance_tree
            break
        fi
    done
    wait "$IPID" 2>/dev/null
    rc=$?
    stamp "instance  $i  exited  rc=$rc"
    if [ "$giveup" = "1" ]; then
        break
    fi
    if [ "$rc" = "3" ]; then
        stamp "instance  reported  CORRUPT  CHECKPOINT  (rc=3)  --  stopping,  owner decides"
        break
    fi
    if [ "$rc" = "0" ]; then
        # FULL-DONE  counts  only  if  it  appeared  in  THIS
        # instance's  own  log  span  (the  main  log  is
        # append-only  across  slices;  an  earlier  slice's
        # marker  must  not  end  this  one).
        if tail -c +$((LOGPOS + 1)) out_day038_full.log 2>/dev/null | grep -q "H1 *FULL-DONE"; then
            stamp "instance  $i  rc=0  with  FULL-DONE  in  its  own  span  --  slice  complete"
            break
        fi
    fi
done
if [ "$autores" -gt 0 ]; then
    stamp "watchdog  summary:  $autores  auto-resume(s)  used  over  this  supervisor  lifetime"
fi
stamp "day045 supervisor exit  (total  instances:  $i)"
