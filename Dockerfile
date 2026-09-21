# rh-missing-tail -- the project's reproducibility image
# (Docker-in-repo, per docs/COMPUTE-DEPLOY-PLAN.md).
#
# NOTE (disentangle): this is the image for THIS repo only.  The
# kainos-logos project keeps its own pinned dev image (ADR-0010);
# nothing is shared between the two, and this file must not import
# kainos assumptions.  The two images are separate artifacts.
#
# Pinned stack:
#   base    : python:3.12-slim by DIGEST (no :latest)
#   Python  : mpmath 1.4.1 + numpy 1.26.4, sha256-pinned (requirements.lock)
#   Lean    : 4.33.1 via elan (mathlib downloads on first `lake build`)
#   tools   : R, git, curl, editors (below)
#
# No auto-run at boot: the default CMD is a shell.  Run repo commands
# through the rh-reproduce wrapper:  docker run --rm -v "$PWD":/work
#   rh-missing-tail rh-reproduce python3 scripts/rh/rh_fetch_data.py low

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
# mathlib on first use (a few GB, once).
RUN curl -fsSL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
        -o /tmp/elan.sh \
    && sh /tmp/elan.sh -y --default-toolchain leanprover/lean4:v4.33.1 \
    && rm /tmp/elan.sh
ENV PATH="/root/.elan/bin:${PATH}"

# rh-reproduce: run a repo command from the checkout root (/work).
# Examples:
#   docker run --rm -v "$PWD":/work rh-missing-tail \
#       rh-reproduce python3 scripts/rh/day037_h1_3e10.py
#   docker run --rm -v "$PWD":/work rh-missing-tail \
#       rh-reproduce bash -c "cd formal && lake build"
RUN printf '#!/bin/sh\nset -e\ncd /work\nexec "$@"\n' > /usr/local/bin/rh-reproduce \
    && chmod +x /usr/local/bin/rh-reproduce

# the repository is bind-mounted over this directory at `docker run`
# time (the bind mount provides the code; the image carries the env).
WORKDIR /work
CMD ["bash"]
