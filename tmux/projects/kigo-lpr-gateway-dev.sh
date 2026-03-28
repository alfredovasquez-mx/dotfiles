#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

tmx_session "kigo-lpr-gateway-dev" "/Users/alfredo.vasquez/dev/work/Kigo/kigo-lpr/kigo-lpr-gateway"
tmx_window "editor" "nvim ."
tmx_window "gateway"
tmx_window "logs"
tmx_window "git" "lazygit"
tmx_attach
