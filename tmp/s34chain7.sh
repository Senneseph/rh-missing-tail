#!/bin/bash
# chain7: hold until s34k boundary probes finish (s34k.done), then run
# the low-row dps-40 repr confirmations.  Memory staggered after the
# live s34k mpmath probes.
while [ ! -f /home/jsmille/Projects/rh-missing-tail/tmp/s34k.done ]; do sleep 60; done
echo "chain7: s34k done, running s34x at $(date)"
cd /home/jsmille/Projects/rh-missing-tail
/home/jsmille/venvs/smud/bin/python tmp/s34x_lowrepr_dps40.py > tmp/s34x_lowrepr_dps40.log 2>&1
echo "chain7: s34x exit=$? at $(date)"
touch tmp/s34x.done
