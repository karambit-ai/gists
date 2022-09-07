#!/usr/bin/env bash
#
# This script prepares a repository for devcontainer usage.

set -eo pipefail

dl() {
  [[ -z "${2}" ]] && set -- "${1}" "${1}"

  # Download and backup a file from the gists repository.
  echo "[+] Downloading ${1} to ${2}..."
  backup="${2}.bak.$(date -Iseconds)"

  [[ -f "${2}" ]] && mv "${2}" "${backup}"
  curl -Ls "https://raw.githubusercontent.com/karambit-ai/gists/main/${1}" >"${2}"

  # Delete the backup if the sha256sum values match.
  sha_backup="$(sha256sum "${2}" | awk '{print $1}')"
  sha_new="$(sha256sum "${backup}" | awk '{print $1}')"
  [[ "${sha_backup}" == "${sha_new}" ]] && rm "${backup}"
}

# Download curl if not installed.
if ! command -v curl &>/dev/null; then
  apt update
  apt install --no-install-recommends -y curl
fi

# Create a .devcontainer directory if it doesn't exist.
[[ ! -e .devcontainer/scripts ]] && mkdir -p .devcontainer/scripts

# Download the devcontainer scripts and back up existing ones.
curl -Ls https://api.github.com/repos/karambit-ai/gists/contents/devcontainer | jq -r '.[].path' |
  while IFS= read -r remotepath || [ -n "${remotepath}" ]; do
    file="$(basename "${remotepath}")"
    localpath=".devcontainer/scripts/${file}"

    dl "${remotepath}" "${localpath}"
    if [[ "${file}" == *.sh ]]; then
      chmod +x "${localpath}"
    fi
  done

# Download the devcontainer configuration and Dockerfile and backup existing
# ones.
dl .devcontainer/devcontainer.json
dl .devcontainer/Dockerfile
