#!/usr/bin/env bash
#
# SCRIPT NAME: kai-download.sh
# DESCRIPTION: Download files and reports from the Karambit.AI API
#
# USAGE:
# export KAI_API_KEY=...                        # Make sure the API key is provided
# ./kai-download.sh {sha256} [{kind}] [true]
#
# EXAMPLES:
# Example 1: Download a binary from the API
# ./kai-download.sh 2907428ff2cc7ee90b3790b93e7470a8780163e95b3bd63083b90861714a1895
#
# Example 2: Download an analysis report from the API
# ./kai-download.sh 2907428ff2cc7ee90b3790b93e7470a8780163e95b3bd63083b90861714a1895 karambyte_analysis

set -euo pipefail

export FILE_SHA256="${1}"
export KIND="${2:-bytes}"
export VERBOSE="${3:-${VERBOSE:-false}}"
if [[ "${VERBOSE}" = "true" ]]; then
  export VERBOSE="--verbose"
else
  export VERBOSE=""
fi

curl "https://api2.karambit.ai/api/v3/files/${FILE_SHA256}/kind/${KIND}" \
  --header "Authorization: Bearer ${KAI_API_KEY}" \
  --max-time 300 \
  --remote-header-name \
  --remote-name \
  --request GET \
  --retry 5 \
  --retry-delay 0 \
  --retry-max-time 600 \
  ${VERBOSE}
