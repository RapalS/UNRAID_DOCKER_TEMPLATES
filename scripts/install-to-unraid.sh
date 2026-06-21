#!/usr/bin/env bash
# Copy a template XML to Unraid flash templates-user/ via SCP.
#
# Usage:
#   export UNRAID_HOST=192.168.1.10
#   export UNRAID_USER=root
#   ./scripts/install-to-unraid.sh templates/nornicdb-cpu.xml
#
# Optional:
#   UNRAID_DEST=/boot/config/plugins/dockerMan/templates-user

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UNRAID_HOST="${UNRAID_HOST:-}"
UNRAID_USER="${UNRAID_USER:-root}"
UNRAID_DEST="${UNRAID_DEST:-/boot/config/plugins/dockerMan/templates-user}"

if [[ $# -lt 1 ]]; then
  echo "Usage: UNRAID_HOST=ip ./scripts/install-to-unraid.sh <template.xml>" >&2
  exit 1
fi

if [[ -z "$UNRAID_HOST" ]]; then
  echo "Error: set UNRAID_HOST (e.g. export UNRAID_HOST=192.168.1.10)" >&2
  exit 1
fi

SRC="$1"
if [[ ! -f "$SRC" ]]; then
  SRC="${REPO_ROOT}/$1"
fi

if [[ ! -f "$SRC" ]]; then
  echo "Error: file not found: $1" >&2
  exit 1
fi

BASENAME="$(basename "$SRC")"
REMOTE="${UNRAID_USER}@${UNRAID_HOST}:${UNRAID_DEST}/${BASENAME}"

echo "Installing $SRC -> $REMOTE"
scp "$SRC" "$REMOTE"
echo "Done. In Unraid: Docker → Add Container → Template → User Templates → ${BASENAME%.xml}"
