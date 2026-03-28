#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

tmx_session "kigo-lpr-cams-dev" "/Users/alfredo.vasquez/dev/work/Kigo/kigo-lpr/kigo-lpr-cams"
tmx_window "editor" "nvim ."
tmx_window "server"
tmx_window "infra"
tmx_window "git" "lazygit"
tmx_attach
