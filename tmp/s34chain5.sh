#!/usr/bin/env bash
# chain6: low sub-wall repr-shift tests (needs ~25GB headroom, after the
# 92GB traces have gone). Fresh process per row inside s34w.
echo "chain6 start $(date)"
while true; do
  AVL=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
  if [ "$AVL" -gt 30000000 ] && ! pgrep -f "s34l_width_trace|s34l_prec_direct|s34k_boundary" | grep -q .; then break; fi
  sleep 120
done
echo "chain6: running s34w lowshift at $(date)"
/home/jsmille/venvs/smud/bin/python tmp/s34w_lowshift.py > tmp/s34w_lowshift.log 2>&1
echo "chain6: s34w done at $(date)"
echo done > tmp/s34w.done
