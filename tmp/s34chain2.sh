#!/bin/bash
# chain2 v4: robust remainder of the mpmath probe chain.
# T1/T2: fresh dps40 width-trace at 5e8G EXACT t (determinism decision)
# T3:    prec-78 forced at EXACT t (Run1 width-state class test)
# T4:    fresh dps40 width-trace at REPR t+200 (old-anchor height test)
# s34k:  boundary probe a = 5.9039e8 (C + dps15 + dps40)
# All 92GB-class processes run STRICTLY SEQUENTIALLY, fresh process each.
cd /home/jsmille/Projects/rh-missing-tail || exit 1
PY=/home/jsmille/venvs/smud/bin/python
T5=15000522999990988800          # 5e8G exact f64 int
T4R=15000522999990989000         # 5e8G repr (old-anchor) height
echo "chain2v4 start $(date)"

# memory guard: wait until ~95GB is really free before the first 92GB run
while true; do
  AVL=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
  if [ "$AVL" -gt 95000000 ]; then break; fi
  echo "waiting for memory: $(awk 'BEGIN{print sprintf("%.1f GB", $1/1048576)}' <<< $AVL) available"
  sleep 120
done

echo "=== T1: s34l width-trace 5e8G exact, dps40 ==="
$PY tmp/s34l_width_trace.py $T5 40 > tmp/s34l_t1.log 2>&1
echo "T1 exit=$? $(date)"

echo "=== T2: s34l width-trace 5e8G exact, dps40 (2nd fresh process) ==="
$PY tmp/s34l_width_trace.py $T5 40 > tmp/s34l_t2.log 2>&1
echo "T2 exit=$? $(date)"

echo "=== T3: prec-78 forced at exact t ==="
$PY tmp/s34l_prec_direct.py $T5 prec78 > tmp/s34l_p78.log 2>&1
echo "T3 exit=$? $(date)"

echo "=== T4: s34l width-trace at repr height t+200, dps40 ==="
$PY tmp/s34l_width_trace.py $T4R 40 > tmp/s34l_t4.log 2>&1
echo "T4 exit=$? $(date)"

echo "=== s34k boundary probe t = 2190076357998684160 ==="
cd scripts/rh/zetac
ZETAC_TEST_T=2190076357998684160 OMP_NUM_THREADS=32 ./zetac > /home/jsmille/Projects/rh-missing-tail/tmp/s34k_C.log 2>&1
echo "s34k C exit=$? $(date)"
cd /home/jsmille/Projects/rh-missing-tail
$PY tmp/s34k_boundary_probe.py 15 > tmp/s34k_dps15.log 2>&1
echo "s34k dps15 exit=$? $(date)"
$PY tmp/s34k_boundary_probe.py 40 > tmp/s34k_dps40.log 2>&1
echo "s34k dps40 exit=$? $(date)"

echo done > tmp/s34k.done
echo "chain2v4 end $(date)"
