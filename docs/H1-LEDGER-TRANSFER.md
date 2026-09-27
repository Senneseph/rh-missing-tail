# H1 ledger transfer: 5900X -> isomorph (this box)

Goal: when the 5900X H1 run finishes, pull its certified ledger into this
box (the merge hub). Owner runs the commands; this document is the ordered
list. Both boxes are Linux Mint, near-identical.

## What does and does not get copied

COPY (small, MB-scale, this is the actual deliverable):
  - scripts/rh/ckpt_h1_3e10/*.pts        (its per-window certified rows)
  - scripts/rh/out_day038_full_pts.txt   (its own assembly, provenance)
  - scripts/rh/out_day038_full.log       (engine log, provenance)
  - scripts/rh/out_day045.log            (supervisor log, provenance)

DO NOT COPY:
  - the band data (hi3e10 .f64, hi3e9, hi1e9, lshards, ~815 GB total):
    isomorph is the source of truth for all of it (built and verified
    here). The 5900X copy duplicates ours. No transfer needed.
  - venvs, docker images, the whole repo: the repo is the same git
    project; only the data files above exist in two places.

Merge afterwards (isomorph does this, not the owner): union rows by
(x, k); byte-diff every window both boxes certified (the overlap
windows are the cross-check); final 696-point assembly.

## One-time network setup

Both boxes must see each other on the same LAN (isomorph sits on
192.168.1.0/24, gateway 192.168.1.254).

On the 5900X (three commands, run once):
  1. ip -4 addr show | grep " 192\.168\."          -> note its IP (HOST)
     (if it shows a different subnet, the boxes are not on the same LAN;
      solve that first, nothing below works cross-network)
  2. sudo systemctl status ssh
     -> if not active:  sudo systemctl enable --now ssh
  3. sudo ufw status
     -> if "Status: active":  sudo ufw allow 22/tcp
       if "Status: inactive": do nothing

On isomorph (this box), once, to set up key auth (skippable, then use
passwords):
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519   (Enter at passphrase)
  ssh-copy-id <user>@HOST
  ssh <user>@HOST hostname                     # should be passwordless

Connectivity test from isomorph:
  ping -c 3 HOST

## Transfer (run on isomorph, after the 5900X run is FULL-DONE)

HOST = the 5900X LAN IP, USER = its login name.

Preview its size:
  ssh USER@HOST "du -sh ~/Projects/rh-missing-tail/scripts/rh/ckpt_h1_3e10"

Pull the ledger (resume-safe; re-running is a cheap top-up):
  mkdir -p ~/Projects/rh-missing-tail/incoming_5900x
  rsync -avz --partial USER@HOST:\
    /home/USER/Projects/rh-missing-tail/scripts/rh/ckpt_h1_3e10/\
    ~/Projects/rh-missing-tail/incoming_5900x/ckpt_h1_3e10/

Pull the provenance logs:
  rsync -avz USER@HOST:\
    /home/USER/Projects/rh-missing-tail/scripts/rh/out_day038_full_pts.txt \
    USER@HOST:/home/USER/Projects/rh-missing-tail/scripts/rh/out_day038_full.log \
    USER@HOST:/home/USER/Projects/rh-missing-tail/scripts/rh/out_day045.log \
    ~/Projects/rh-missing-tail/incoming_5900x/

Integrity (byte-exact):
  on the 5900X:  cd ~/Projects/rh-missing-tail/scripts/rh/ckpt_h1_3e10
                 md5sum *.pts > /tmp/ckpt_5900x.md5
  on isomorph:   cd ~/Projects/rh-missing-tail/incoming_5900x/ckpt_h1_3e10
                 md5sum -c /tmp/ckpt_5900x.md5   (copied over via scp)
  -> every line must say OK

Then report back; the merge hub handles the union + cross-check +
final assembly.

## Notes

- If the 5900X run is still going when the transfer happens, run the
  rsync again afterwards: rsync tops up only changed .pts files, so a
  second pass after FULL-DONE picks up the tail at zero cost.
- Nothing here touches the running H1 job on isomorph, the 10 TB
  drive, or any read-only data file.
