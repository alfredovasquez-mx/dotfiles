#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

tmx_session "kipuve-dev" "/Users/alfredo.vasquez/dev/work/Kigo/kipuve"
tmx_window "editor" "nvim ."
tmx_window "server"
tmx_window "infra"
tmx_window "git" "lazygit"
tmx_attach
