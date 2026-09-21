#!/bin/bash
# day037 H1-3e10 PROFILE launch (owner green-lit;  owner core rule:
# 2 physical cores always reserved -> workers pinned to cores 0-13)
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh
export H1CERT_SMOKE=${H1CERT_SMOKE:-1}   # 1 = one-window profile
export WORKERS=${WORKERS:-14}
nohup taskset -c 0-27 python3 -u day037_h1_3e10.py \
  > out_day037_run.log 2> out_day037_run.err &
echo "launched pid $!"
