#!/usr/bin/env bash
set -euo pipefail
CONFIG="${VIDEO_WORKFLOW_CONFIG:-$HOME/.config/video-workflow/callisto.env}"
[[ -f "$CONFIG" ]] || { echo "Missing config $CONFIG" >&2; exit 1; }
source "$CONFIG"
: "${VIDEO_ROOT:?}" "${ARCHIVE_ROOT:?}"
[[ "$ARCHIVE_ROOT" == /srv/video-archive ]] || { echo 'Unexpected archive path' >&2; exit 1; }
mountpoint -q "$ARCHIVE_ROOT" || { echo 'Seagate archive NOT mounted; refusing operation' >&2; exit 1; }
[[ -d "$VIDEO_ROOT/finished" ]] || { echo 'Finished directory missing' >&2; exit 1; }
mkdir -p "$ARCHIVE_ROOT/videos"
rsync -av --checksum --ignore-existing "$VIDEO_ROOT/finished/" "$ARCHIVE_ROOT/videos/"
echo 'Source files retained. Verify archive files before considering cleanup.'
