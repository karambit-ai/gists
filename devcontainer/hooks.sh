#!/usr/bin/env bash
#
# Setup bashrc hooks for tools like asdf and direnv.

set -eo pipefail

cat <<EOF >>/etc/bash.bashrc

. "\${ASDF_DATA_DIR:-~/.asdf}/asdf.sh"
. "\${ASDF_DATA_DIR:-~/.asdf}/completions/asdf.bash"

eval "\$(direnv hook bash)"

EOF
