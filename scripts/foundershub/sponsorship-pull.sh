#!/usr/bin/env bash
#
# SCRIPT NAME: sponsorship-pull.sh
# DESCRIPTION: Pull the latest usage data from Microsoft Azure Sponsorships
#
# Usage:
# ./sponsorship-pull.sh

curl \
  -X GET \
  --cookie "${COOKIE}" \
  --output "AzureUsage-$(date +%F).json" \
  --data "fileType=json" \
  --data "startDate=$(date +%Y-01-01)" \
  --data "endDate=$(date +%F)" \
  https://www.microsoftazuresponsorships.com/Usage/DownloadUsage
