# rh-missing-tail -- the project image:  reproducibility  (CPU)
# AND  HPC  deployment  (NVIDIA  GPU,  e.g.  vast.ai  nodes).
# (Docker-in-repo,  per  docs/COMPUTE-DEPLOY-PLAN.md.)
#
#
# Pinned  stack:
#   base    :  python:3.12-slim  by  DIGEST  (no  :latest)
#   Python  :  mpmath  1.4.1  +  numpy  1.26.4,  sha256-pinned
#             (requirements.lock)  --  identical  to  the  production
#             bare-metal  venvs  (Strix  Halo  /  5900X)
#   GPU     :  cupy-cuda12x  13.6.0  +  fastrlock,  sha256-pinned
#             (requirements-cuda.lock)  --  the  latest  cupy  that
#             still  runs  on  numpy  1.26.4;  for  NVIDIA  hosts
#   Lean    :  4.33.1  via  elan  (mathlib  downloads  on  first
#             `lake  build`)
#   tools   :  R,  git,  curl,  editors  (below)
#
# CODE  is  BAKED  in  at  the  engine's  pinned  absolute  path
# /home/jsmille/Projects/rh-missing-tail  (R_H,  day038  line  100;
# the  supervisor  pins  the  venv  wrapper  at  line  191  --  that
# name  is  materialized  as  a  forwarder  to  the  image  python).
# DATA  never  ships;  fetch  it  on  the  node  with
# scripts/rh/rh_fetch_data.py  (L-shards  +  zero  bands).  The  old
# bind-mount  model  still  works:  mount  a  fresh  checkout  over
# the  path  (or  /work,  the  symlink)  to  override  the  baked  copy.
#
# No  auto-run  at  boot:  the  default  CMD  is  a  shell.  Run  repo
# commands  through  the  rh-reproduce  wrapper:  docker  run  --rm
#   rh-missing-tail:hpc-cuda12  rh-reproduce  python3  scripts/rh/rh_fetch_data.py  low

FROM python:3.12-slim@sha256:2c941e860699f878900b0edc2403613c234d4b32eda3cc9fa7036991a2a63c4a

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# the math stack, fully hash-pinned
COPY requirements.lock /tmp/requirements.lock
RUN pip install --require-hashes -r /tmp/requirements.lock \
    && rm /tmp/requirements.lock

# User-facing tools.  Editors:  emacs and nano are the real installs;
# vi/vim & co. are provided below as shims that launch emacs.
# only bozos use anything but emacs
RUN apt-get update && apt-get install -y --no-install-recommends \
        nano emacs-nox r-base-core git curl ca-certificates xz-utils \
    && for e in vi vim vim.tiny vim.gtk vim.basic ex view rvim rvim.tiny; do \
         printf '#!/bin/sh\nexec emacs-nox "$@"\n' > /usr/local/bin/$e \
         && chmod +x /usr/local/bin/$e; \
       done \
    && printf 'alias vi=emacs-nox\nalias vim=emacs-nox\nalias ex=emacs-nox\nalias view=emacs-nox\n' \
         >> /etc/bash.bashrc \
    && rm -rf /var/lib/apt/lists/*

# Lean 4.33.1 via elan (pinned).  `lake build` in formal/ downloads
# mathlib on first use (a few GB, once) and compiles it from source.
RUN curl -fsSL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
        -o /tmp/elan.sh \
    && sh /tmp/elan.sh -y --default-toolchain leanprover/lean4:v4.33.1 \
    && rm /tmp/elan.sh
ENV PATH="/root/.elan/bin:${PATH}"
# elan-init sets the default but does not always install it (it must be
# explicit:  the image is expected to be self-contained, no first-run
# toolchain download).
RUN elan toolchain install leanprover/lean4:v4.33.1

# rh-reproduce: run a repo command from the checkout root (/work,
# a symlink to the pinned path below).
RUN printf '#!/bin/sh\nset -e\ncd /work\nexec "$@"\n' > /usr/local/bin/rh-reproduce \
    && chmod +x /usr/local/bin/rh-reproduce

# ---- HPC  GPU  stack  (NVIDIA  hosts)  -----------------------------
# cupy-cuda12x  13.6.0:  the  latest  cupy  compatible  with  the
# production  venv's  numpy  1.26.4  (cupy  14  demands  numpy  2.x,
# which  would  move  the  image  off  the  measured  stack).
COPY requirements-cuda.lock /tmp/requirements-cuda.lock
RUN pip install --require-hashes -r /tmp/requirements-cuda.lock \
    && rm /tmp/requirements-cuda.lock

# ---- bake  the  code  at  the  engine's  pinned  path  --------------
# scripts/  formal/  docs/  results/  =  code  +  specs  only;
# .dockerignore  keeps  out  all  ZERO  DATA  (*.f64,  *.dat,  band
# dirs,  checkpoints)  --  fetch  on  the  node  with
# scripts/rh/rh_fetch_data.py  (L-shards  +  the  A/B/C/D  bands).
COPY requirements.lock requirements-cuda.lock PLAN.md README.md DISCOVERY_LOG.md references.md /home/jsmille/Projects/rh-missing-tail/
COPY scripts/ /home/jsmille/Projects/rh-missing-tail/scripts/
COPY formal/ /home/jsmille/Projects/rh-missing-tail/formal/
COPY docs/ /home/jsmille/Projects/rh-missing-tail/docs/
COPY results/ /home/jsmille/Projects/rh-missing-tail/results/
# materialize  the  pinned  venv  wrapper  name  (day045  line  191)
# as  a  forwarder  to  the  image  python  --  the  bare-metal
# machine's  real  venv  keeps  working  unchanged  (the  image  only
# ever  runs  where  the  path  is  free).
RUN mkdir -p /home/jsmille/venvs/cupy/bin \
    && printf '#!/bin/sh\nexec python -u "$@"\n' > /home/jsmille/venvs/cupy/bin/cupy_py \
    && chmod +x /home/jsmille/venvs/cupy/bin/cupy_py \
    && ln -sfn /home/jsmille/Projects/rh-missing-tail /work

WORKDIR /home/jsmille/Projects/rh-missing-tail
CMD ["bash"]
