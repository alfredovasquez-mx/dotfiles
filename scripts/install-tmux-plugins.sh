#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${HOME}/.config/tmux/plugins"
TPM_DIR="${PLUGIN_DIR}/tpm"

mkdir -p "${PLUGIN_DIR}"

if [ ! -d "${TPM_DIR}" ]; then
  git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"
fi

"${TPM_DIR}/bin/install_plugins"

echo "tmux plugins installed."
