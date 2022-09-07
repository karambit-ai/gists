#!/usr/bin/env bash
#
# The user runs the script by providing a list of packages to install with the
# asdf package manager via stdin. The entries are provided as space-delimited
# pairs or triplets consisting of the plugin name, plugin source, and/or
# plugin version.
#
# e.g.
#
# ```
# $0 <<EOF
# github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git
# EOF
# ```

set -eo pipefail

[[ ! -f "${HOME}/.asdf/asdf.sh" ]] && {
  git clone https://github.com/asdf-vm/asdf ~/.asdf --branch v0.10.2
}

# shellcheck disable=1091
. "${HOME}/.asdf/asdf.sh"

# ---------------------------------------------------------------------------- #

# Provide a lookup function for the sources for common asdf plugins.

asdf_source() {
  case "${1}" in
  "azure-cli") echo "https://github.com/itspngu/asdf-azure-cli" ;;
  "clojure") echo "https://github.com/asdf-community/asdf-clojure.git" ;;
  "cloudflared") echo "https://github.com/threkk/asdf-cloudflared.git" ;;
  "flyctl") echo "https://github.com/erhlee-bird/asdf-flyctl.git" ;;
  "github-cli") echo "https://github.com/bartlomiejdanek/asdf-github-cli.git" ;;
  "lein") echo "https://github.com/miorimmax/asdf-lein.git" ;;
  "terraform") echo "https://github.com/asdf-community/asdf-hashicorp.git" ;;
  "terraform-ls") echo "https://github.com/asdf-community/asdf-hashicorp.git" ;;
  "terragrunt") echo "https://github.com/ohmer/asdf-terragrunt" ;;
  "vault") echo "https://github.com/asdf-community/asdf-hashicorp.git" ;;
  esac
}

# ---------------------------------------------------------------------------- #

# Install plugins with asdf.

while IFS= read -r line || [ -n "$line" ]; do
  read -a linevars -r <<<"${line}"
  # <plugin name> <plugin source> [<plugin version>]
  #
  # If <plugin source> is set to "-", a known source will be provided if
  # available. See the `asdf_source` function above.
  #
  # If not provided, the plugin version will be determined by:
  #
  # 1. looking up the plugin in ~/.tool-versions
  # 2. defaulting to "latest"
  name="${linevars[0]}"
  source="${linevars[1]}"
  version="${linevars[2]}"

  [[ -z "${name}" ]] && continue
  [[ -z "${source}" ]] && source="-"
  [[ "${source}" = "-" ]] && source="$(asdf_source "${name}")"
  [[ -z "${source}" ]] && {
    echo "[-] Missing source value for package '${name}'"
    exit 1
  }
  # shellcheck disable=2015
  [[ -z "${version}" ]] && version="$(grep "${name}" "${HOME}/.tool-versions" 2>/dev/null | cut -d ' ' -f 2)" || :
  [[ -z "${version}" ]] && version="latest"

  asdf plugin add "${name}" "${source}" || :
  asdf install "${name}" "${version}" || :
  asdf global "${name}" "${version}"
done

# ---------------------------------------------------------------------------- #
