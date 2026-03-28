#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

tmx_session "kigo-enforcement-dev" "/Users/alfredo.vasquez/dev/work/Kigo/kigo-enforcement"
tmx_window "editor" "nvim ."
tmx_window "server"
tmx_window "logs"
tmx_window "git" "lazygit"
tmx_attach
