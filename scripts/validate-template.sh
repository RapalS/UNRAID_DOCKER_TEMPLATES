#!/usr/bin/env bash
# Validate Unraid Docker template XML files (Linux / Unraid SSH).
#
# Usage:
#   ./scripts/validate-template.sh templates/nornicdb-cpu.xml
#   ./scripts/validate-template.sh --strict

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALIDATE_PY="${REPO_ROOT}/scripts/validate.py"
STRICT=false
PATHS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict) STRICT=true; shift ;;
    *) PATHS+=("$1"); shift ;;
  esac
done

if [[ ${#PATHS[@]} -eq 0 ]]; then
  PATHS=("templates" "examples" "ca_profile.xml")
fi

ARGS=(--repo-root "$REPO_ROOT")
if $STRICT; then ARGS+=(--strict); fi
ARGS+=("${PATHS[@]}")

if command -v python3 >/dev/null 2>&1; then
  exec python3 "$VALIDATE_PY" "${ARGS[@]}"
elif command -v python >/dev/null 2>&1; then
  exec python "$VALIDATE_PY" "${ARGS[@]}"
else
  echo "Error: python3 or python required" >&2
  exit 1
fi
