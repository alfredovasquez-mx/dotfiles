#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BREW_FORMULAE=(
  fish
  gh
  tmux
  neovim
  starship
  fzf
  fd
  ripgrep
  lazygit
  shfmt
  stylua
  bun
)

BREW_CASKS=(
  ghostty
)

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_brew_packages() {
  echo "Installing Homebrew formulae..."
  brew install "${BREW_FORMULAE[@]}"

  echo "Installing Homebrew casks..."
  brew install --cask "${BREW_CASKS[@]}"
}

run_script() {
  local script="$1"
  echo "Running ${script}..."
  "${ROOT}/scripts/${script}"
}

main() {
  ensure_homebrew
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || brew shellenv)"
  brew update
  install_brew_packages
  run_script "install-home-links.sh"
  run_script "install-tmux-plugins.sh"
  run_script "install-opencode-deps.sh"

  echo
  echo "Bootstrap complete."
  echo "Next steps:"
  echo "  1. Launch Ghostty and Neovim once so plugins can finish syncing."
  echo "  2. Run: gh auth login"
  echo "  3. If you use fish as default shell: chsh -s \$(which fish)"
}

main "$@"
