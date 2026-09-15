#!/bin/bash
# 25y: dps-30 certified pins of the S1-GAP (25x boundary sweep results)
cd /home/jsmille/Projects/rh-missing-tail/scripts/rh
echo "=== 25y pin 1: first robust sub-1 window (5.6e7, screen margin 0.5657) ===" >> hi1e9/pins_25y.log
python3 day024_p06_pin_25x.py S1GAP-first-sub1-5.6e7 56000000.118091769516468 55999996.118091769516468 >> hi1e9/pins_25y.log 2>&1
echo "=== 25y pin 2: deepest robust sub-1 window in (5.5e7, 2e8] (1.1e8, screen 0.4429) ===" >> hi1e9/pins_25y.log
python3 day024_p06_pin_25x.py S1GAP-deepest-sub1-1.1e8 109999999.909622058272362 109999999.409622058272362 >> hi1e9/pins_25y.log 2>&1
echo "=== 25y done ===" >> hi1e9/pins_25y.log
