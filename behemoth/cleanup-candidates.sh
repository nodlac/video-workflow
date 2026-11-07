#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
echo 'READ ONLY: candidate project directories older than 30 days; NO DELETION'
[[ -d "$LOCAL_VIDEO_ROOT" ]] && find "$LOCAL_VIDEO_ROOT" -mindepth 1 -maxdepth 1 -type d -mtime +29 -print
