#!/bin/bash
# day038 H1-3e10 iGPU engine launcher (cups venv: LD_LIBRARY_PATH is
# exported by the cupy_py wrapper BEFORE python starts - do not
# substitute plain python3).
#   ./launch_day038_gpu.sh        profile: top window only
#   FULL=1 ./launch_day038_gpu.sh full run: 29 windows (725 straddles)
cd "$(dirname "$0")"
export WORKERS=14                 # owner core cap (2 cores reserved)
if [ "$FULL" != "1" ]; then
    export H1CERT_SMOKE=1
fi
nohup taskset -c 0-27 ~/venvs/cupy/bin/cupy_py -u day038_h1_3e10_gpu.py \
    > out_day038_run.log 2> out_day038_run.err &
echo "launched pid $! (log: out_day038_run.log)"
