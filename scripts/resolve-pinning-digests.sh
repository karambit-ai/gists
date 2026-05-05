#!/usr/bin/env bash
# Resolve digests for the SEC-177 gists devcontainer pinning.
#
# Run on a host with `docker` available.
#
# The `mcr.microsoft.com/*` lookup is public — no login required.
#
# Emits `image:tag@sha256:…` lines to stdout.  Pipe to a capture file
# and paste back to the agent:
#
#   ./scripts/resolve-pinning-digests.sh | tee digest_output.txt

set -euo pipefail

resolve() {
    local ref="$1"
    local digest
    if digest="$(docker buildx imagetools inspect "${ref}" --format '{{json .Manifest}}' 2>/dev/null | jq -r '.digest')" \
        && [ -n "${digest}" ] && [ "${digest}" != "null" ]; then
        printf '%s@%s\n' "${ref}" "${digest}"
    else
        printf 'FAILED: %s\n' "${ref}" >&2
        return 1
    fi
}

echo "# .devcontainer/Ubuntu/Dockerfile FROM line (public Microsoft Container Registry)"
# Pinning the noble (Ubuntu 24.04) base devcontainer image.
resolve "mcr.microsoft.com/vscode/devcontainers/base:noble" || true

echo
echo "Done."
