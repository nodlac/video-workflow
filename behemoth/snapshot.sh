#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
project="${1:?Usage: snapshot.sh project-slug}"
valid_project "$project" || { echo 'Invalid project' >&2; exit 2; }
workdir="$LOCAL_VIDEO_ROOT/$project"
[[ -d "$workdir" ]] || { echo 'Project missing' >&2; exit 1; }
id="$(date -u +%Y%m%dT%H%M%SZ)-$$"
target="$REMOTE_VIDEO_ROOT/project-snapshots/$project/$id"
ssh "$remote_host" mkdir -p "$target"
rsync -av --partial --exclude='/recordings/' -e ssh "$workdir/" "$remote_host:$target/"
echo "Snapshot stored at $target. Verify a restore before cleanup."
