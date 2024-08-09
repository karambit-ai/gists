#!/usr/bin/env bash

set -eo pipefail

# NB: Construct the Vault headers based on the available Cloudflare Access
#     environment variables.

HEADERS=()
if [[ -n "${CF_TOKEN}" ]]; then
  HEADERS+=(-header="CF-Access-Token=${CF_TOKEN}")
elif [[ -n "${CF_ACCESS_CLIENT_SECRET}" ]]; then
  HEADERS+=(-header="CF-Access-Client-Id=${CF_ACCESS_CLIENT_ID}")
  HEADERS+=(-header="CF-Access-Client-Secret=${CF_ACCESS_CLIENT_SECRET}")
fi

# NB: Reorder the Vault arguments such that we try and capture the preceding
#     command/subcommands and insert the header arguments between them and the
#     arguments.
#
# e.g. vault kv list infra/ -> vault kv list -header ... infra/

ARGS=("${@}")
LEADING=()
NUM_ARGS=$#
if [[ $NUM_ARGS = 1 ]]; then
  # NB: If there is only a single argument, assume that the argument is the
  #     command.
  #
  # e.g. ./scripts/cf_vault.sh status
  NUM_ARGS=2
fi

for ((i = 0; i < NUM_ARGS; i++)); do
  # NB: Iterate through the arguments and stop at well-known subcommand markers
  #     and the presence of any flag arguments where we can safely inject the
  #     header flags.
  #
  # e.g. ./scripts/cf_vault.sh kv write auth/cloudflare/login jwt=${CF_TOKEN} role=infra
  arg=${ARGS[i]}
  case ${arg} in
  -*)
    break
    ;;
  # kv ...
  get | read | write | list)
    LEADING+=("${arg}")
    shift
    break
    ;;
  # token ...
  lookup)
    LEADING+=("${arg}")
    shift
    break
    ;;
  esac
  LEADING+=("${arg}")
  shift
done

[[ -n "${DEBUG:-}" ]] && set -x
vault "${LEADING[@]}" "${HEADERS[@]}" "${@}"
