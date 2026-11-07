#!/usr/bin/env bash
set -euo pipefail
CONFIG="${VIDEO_WORKFLOW_CONFIG:-$HOME/.config/video-workflow/behemoth.env}"
[[ -f "$CONFIG" ]] || { echo "Missing config $CONFIG" >&2; exit 1; }
source "$CONFIG"
: "${CALLISTO_HOST:?}" "${CALLISTO_USER:?}" "${REMOTE_VIDEO_ROOT:?}" "${LOCAL_VIDEO_ROOT:?}"
valid_project() { [[ "$1" =~ ^[a-z0-9][a-z0-9-]{0,62}$ ]]; }
remote_host="$CALLISTO_USER@$CALLISTO_HOST"
