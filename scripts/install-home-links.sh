#!/usr/bin/env bash
set -euo pipefail

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "${target}")"

  if [ -L "${target}" ] || [ -e "${target}" ]; then
    if [ "$(readlink "${target}" 2>/dev/null || true)" = "${source}" ]; then
      return
    fi
    mv "${target}" "${target}.backup.$(date +%Y%m%d%H%M%S)"
  fi

  ln -s "${source}" "${target}"
}

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link_file "${ROOT}/tmux/tmux.conf" "${HOME}/.tmux.conf"
link_file "${ROOT}/git/config" "${HOME}/.gitconfig"

echo "Home links installed."
