#!/usr/bin/env bash
#
# This script prepares a repository for devcontainer usage.
#
# For initial setup, run:
#
# ```bash
# curl https://raw.githubusercontent.com/karambit-ai/gists/main/devcontainer/bootstrap.sh | bash
# ```

set -eo pipefail

dl() {
  [[ -z "${2}" ]] && set -- "${1}" "${1}"
  mkdir -p "$(dirname "${2}")"

  # Download and backup a file from the gists repository.
  echo "[+] Downloading ${1} to ${2}..."
  backup="${2}.bak.$(date -Iseconds)"

  [[ -f "${2}" ]] && mv "${2}" "${backup}"
  curl -Ls "https://raw.githubusercontent.com/karambit-ai/gists/main/${1}" >"${2}"

  # Delete the backup if the sha256sum values match.
  if [[ -f "${backup}" ]]; then
    sha_backup="$(sha256sum "${2}" | awk '{print $1}')"
    sha_new="$(sha256sum "${backup}" | awk '{print $1}')"
    [[ "${sha_backup}" == "${sha_new}" ]] && rm "${backup}"
  fi
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
#
# NB: These files will overwrite repository-specific customizations. Users
#     updating a repository by means of this script should take care to compare
#     the new files with the backed up ones and manually merge any changes.
dl .devcontainer/devcontainer.json
sed -i -r "s|karambit-ai/gists|karambit-ai/${PWD##*/}|" .devcontainer/devcontainer.json || :
dl .devcontainer/devcontainer.json.tpl
dl .devcontainer/Ubuntu/devcontainer.json
dl .devcontainer/Ubuntu/Dockerfile
dl .github/workflows/devcontainer_build.yml
dl .pre-commit-config.yaml
touch .tool-versions
