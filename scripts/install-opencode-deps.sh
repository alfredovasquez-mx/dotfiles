#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v bun >/dev/null 2>&1; then
  echo "bun is not installed; skipping opencode dependencies."
  exit 0
fi

cd "${ROOT}/opencode"
bun install

echo "opencode dependencies installed."
