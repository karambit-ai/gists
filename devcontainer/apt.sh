#!/usr/bin/env bash
#
# The user runs the script by providing a list of packages to install with the
# apt package manager via stdin.
#
# It first installs a list of packages common to most development environments.
#
# e.g.
#
# ```
# $0 <<EOF
# curl
# jq
# make
# EOF
# ```

set -eo pipefail

export DEBIAN_FRONTEND=noninteractive

packages=$(</dev/stdin)

apt update
# shellcheck disable=2086
apt-get -y install --no-install-recommends \
  acl \
  curl \
  direnv \
  entr \
  fzf \
  g++ \
  gcc \
  git \
  gpg \
  jq \
  less \
  make \
  pre-commit \
  python3-pip \
  python3-venv \
  ripgrep \
  rlwrap \
  rsync \
  tmux \
  vim \
  wget \
  ${packages}
