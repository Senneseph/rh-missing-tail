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
#  WORKERS  =  13  here  (14-worker  cap  =  13  full-run
#  +  the  one  profile  worker  that  is  also  running;  2
#  physical  cores  stay  reserved).
#
#  The  supervisor  exits  only  on:  "H1  FULL-DONE"  (all
#  696),  a  band  integrity  failure  (rc  5),  a  corrupt
#  checkpoint  (instance  rc  3),  MAX_ATTEMPTS  (30),  or  a
#  lock  held  by  another  supervisor.
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
NEED=8846000 10946000 13046000 15146000 17246000 19346000 21446000 23546000 25646000 27746000 29846000
mkdir -p /tmp/zeta-dl/shards
for n in $NEED; do
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
MEM_HOLD_GIB=100
MEM_HOLDS=0
MEM_HOLD_MAX=288          # 24  h  of  5-min  holds,  then  give  up

MAX=30
i=0
while :; do
    i=$((i + 1))
    if [ "$i" -gt "$MAX" ]; then
        stamp "MAX_ATTEMPTS=$MAX  reached  --  stopping,  owner decides"
        break
    fi
    if grep -q "H1 FULL-DONE" out_day038_full.log 2>/dev/null; then
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
        continue
    fi
    MEM_HOLDS=0
    stamp "instance  $i  launching  (env  WORKERS=13  cap;  instance  memguard  derives  actual  count;  resume  from  ckpt_h1_3e10/)"
    taskset -c 0-27 env WORKERS=13 ZETA_SHARDS_DIR="$PWD/$SHARDS" \
        /home/jsmille/venvs/cupy/bin/cupy_py -u day038_h1_3e10_gpu.py \
        >> out_day038_full.log 2>&1
    rc=$?
    stamp "instance  $i  exited  rc=$rc"
    if [ "$rc" = "3" ]; then
        stamp "instance  reported  CORRUPT  CHECKPOINT  (rc=3)  --  stopping,  owner decides"
        break
    fi
done
stamp "day045 supervisor exit  (total  instances:  $i)"
