#!/bin/sh

# Authenticate with Cloudflare to receive a token that allows us to communicate
# and authenticate with Vault.
#
# Authorizations are determined by the email claim that is passed to Vault.
#
# Use this by running `. scripts/login.sh`
#
# If you need to refresh any tokens that may have expired, run `unset`.
# e.g. `unset VAULT_TOKEN`

echomaybe() {
  # NB: Silence output when not running interactively.
  if [ -z "$KAI_SILENT_LOGIN" ]; then
    case $- in
    *i*) echo "${@}" ;;
    esac
  fi
}

# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
is_sourced() {
  if [ -n "$ZSH_VERSION" ]; then
    case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
  else  # Add additional POSIX-compatible shell names here, if needed.
    case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
  fi
  return 1  # NOT sourced.
}

if ! is_sourced; then
  echo "Don't run this script directly but rather source it."
  echo ""
  echo "Usage: . login.sh"
  exit 1
fi

if command -v cf-vault >/dev/null 2>&1; then
  cf_vault="cf-vault"
elif command -v cf_vault >/dev/null 2>&1; then
  cf_vault="cf_vault"
else
  cf_vault="./cf_vault.sh"
fi

# NB: Use a while loop here as an interruptible control flow structure and
#     ensure that a break is guaranteed at the end.
#
#     This script is sourced not run so we can't invoke exit.
while true; do
  # First, check for a valid Cloudflare token.
  #
  # This is either `CF_TOKEN` for users or `CF_ACCESS_CLIENT_SECRET` for service
  # token clients.
  if [ -z "${CF_ACCESS_CLIENT_SECRET}" ] && [ -z "${CF_TOKEN}" ]; then
    CF_TOKEN="$(cloudflared access login https://vault.karambit.ai | sed '/^[[:space:]]*$/d' | tail -n 1)"
    export CF_TOKEN

    if [ -n "${CF_TOKEN}" ]; then
      echomaybe "[+] Acquired Cloudflare Access token"
    else
      echomaybe "[-] Failed to acquire Cloudflare Access token"
      break
    fi
  fi

  # Next, if a Vault Approle is available, use it to retrieve a token.
  if [ -z "${VAULT_TOKEN}" ] && [ -n "${VAULT_APP_ROLE_ID}" ] && [ -n "${VAULT_APP_ROLE_SECRET}" ]; then
    VAULT_TOKEN="$(${cf_vault} write -format=json auth/approle/login \
      role_id="${VAULT_APP_ROLE_ID}" \
      secret_id="${VAULT_APP_ROLE_SECRET}" \
      | jq -r '.auth.client_token')"
    export VAULT_TOKEN

    if [ -n "${VAULT_TOKEN}" ]; then
      echomaybe "[+] Acquired Vault token (approle)"
    else
      echomaybe "[-] Failed to acquire Vault token (approle)"
      break
    fi
  fi

  # If no VAULT_TOKEN is available, try and retrieve a new one.
  if [ -z "${VAULT_TOKEN}" ]; then
    export VAULT_ADDR="https://vault.karambit.ai"
    VAULT_TOKEN="$(${cf_vault} write -format="json" auth/cloudflare/login \
      jwt="${CF_TOKEN}" \
      role="${1:-infra}" \
      | jq -r '.auth.client_token')"
    export VAULT_TOKEN

    if [ -n "${VAULT_TOKEN}" ]; then
      echomaybe "[+] Acquired Vault token"
    else
      echomaybe "[-] Failed to acquire Vault token"
      break
    fi
  fi

  # Load and set a few generally applicable environment variables.
  CF_ACCOUNT_ID="$(${cf_vault} kv get -format=json vars/cloudflare/production/meta | jq -r '.data.data.account_id')"
  export CF_ACCOUNT_ID

  break
done
