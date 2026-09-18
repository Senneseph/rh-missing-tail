#!/bin/bash
mkdir -p /tmp/zeta-dl/shards
for fn in zeros_8846000.dat zeros_10946000.dat zeros_13046000.dat zeros_15146000.dat \
          zeros_17246000.dat zeros_19346000.dat zeros_21446000.dat zeros_23546000.dat \
          zeros_25646000.dat zeros_27746000.dat zeros_29846000.dat; do
  for try in 1 2 3 4 5; do
    curl -sfL --max-time 3600 -C - -H "Cookie: human=1" \
      "https://beta.lmfdb.org/riemann-zeta-zeros/data/$fn" -o "/tmp/zeta-dl/shards/$fn" && break
    sleep 15
  done
  echo "$(date +%H:%M:%S) $fn $(stat -c%s /tmp/zeta-dl/shards/$fn 2>/dev/null)" 
done
echo "PULL-DONE $(date)"
