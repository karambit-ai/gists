#!/usr/bin/env bash
#
# SCRIPT NAME: kai-upload.sh
# DESCRIPTION: Upload a file with a privileged endpoint and queue up an analysis
#              job with the Karambit.AI API
#
# USAGE:
# export KAI_API_KEY=...
# ./kai-upload.sh {/path/to/file}
#
# EXAMPLES:
# Example 1:
# ./kai-upload.sh "$(which ls)"

set -euo pipefail

export FILE_MD5="$(md5sum "${1}" | cut -d ' ' -f 1)"
export FILE_SHA1="$(sha1sum "${1}" | cut -d ' ' -f 1)"
export FILE_SHA256="$(sha256sum "${1}" | cut -d ' ' -f 1)"
export DIGEST="md5=${FILE_MD5},sha1=${FILE_SHA1},sha256=${FILE_SHA256}"

curl "https://api.karambit.ai/v1/files/upload" \
  --fail \
  --request PUT \
  --header "Authorization: Bearer ${KAI_API_KEY}" \
  --header "Digest: ${DIGEST}" \
  --header "Transfer-Encoding: chunked" \
  --max-time 300 \
  --retry 5 \
  --retry-delay 0 \
  --retry-max-time 600 \
  --show-error \
  --silent \
  --upload-file "${1}"

sleep 5

curl "https://api.karambit.ai/v1/files/${FILE_SHA256}/analyze" \
  --fail \
  --header "Authorization: Bearer ${KAI_API_KEY}" \
  --request PUT \
  --show-error \
  --silent

