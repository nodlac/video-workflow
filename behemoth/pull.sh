#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
project="${1:?Usage: pull.sh project-slug}"
valid_project "$project" || { echo 'Invalid project' >&2; exit 2; }
mkdir -p "$LOCAL_VIDEO_ROOT/$project/recordings"
rsync -av --partial -e ssh "$remote_host:$REMOTE_VIDEO_ROOT/incoming/$project/" "$LOCAL_VIDEO_ROOT/$project/recordings/"
echo 'No remote files deleted.'
