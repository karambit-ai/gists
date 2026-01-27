#!/usr/bin/env bash
#
# Setup bashrc hooks for tools like asdf and direnv.
# Note that in GitHub Actions, adding `shell: bash` will run with `--noprofile`
# and `--norc` and not load these hooks.

set -eo pipefail

cat <<EOF >>/etc/bash.bashrc

. "\${ASDF_DATA_DIR:-~/.asdf}/asdf.sh"
. "\${ASDF_DATA_DIR:-~/.asdf}/completions/asdf.bash"
if [[ -f "\${ASDF_DATA_DIR:-~/.asdf}/tool-versions" ]]; then
  cp "\${ASDF_DATA_DIR:-~/.asdf}/tool-versions" ~/.tool-versions || :
fi

eval "\$(direnv hook bash)"

EOF
