#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

ROOT="/Users/alfredo.vasquez/dev/personal/Alfredo/omerxx-dotfiles"

tmx_session "personal-omerxx-dotfiles-dev" "$ROOT"
tmx_window "editor" "nvim ."
tmx_window_in "ghostty" "$ROOT/ghostty"
tmx_window_in "tmux" "$ROOT/tmux"
tmx_window "git" "lazygit"
tmx_attach
