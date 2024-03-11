#!/usr/bin/env bash
#
# SCRIPT NAME: daily-costs.sh
# DESCRIPTION: Generate a bar chart of Azure costs.
#
# Usage:
# ./daily-costs.sh {/path/to/file} [daily | monthly | yearly]

INPUT="${1:-AzureUsage-$(date +%F).json}"
GROUPING="${2:-daily}" # "monthly" # "yearly"
GROUP=""

case "${GROUPING}" in
  daily)
    GROUP="10"
    ;;

  monthly)
    GROUP="7"
    ;;

  yearly)
    GROUP="4"
    ;;
esac

[[ -z "${GROUP}" ]] && {
  echo "daily-costs.sh [daily | monthly | yearly]"
  exit 1
}

jq --arg group "${GROUP}" \
   -r 'group_by(.Date[:$group | tonumber])[] |
       {(.[0].Date[:$group | tonumber]): [.[] | .Cost] | add} |
       to_entries[][]' \
       "${INPUT}" | \
paste - - | \
uplot bar
