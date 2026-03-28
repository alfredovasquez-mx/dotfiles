#!/bin/sh

set -eu

. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/lib/tmx.sh"

ROOT="/Users/alfredo.vasquez/dev/work/Kigo/kigo-app-services"

tmx_session "kigo-app-services-dev" "$ROOT"
tmx_window "editor" "nvim ."
tmx_window_in "mobile-bff" "$ROOT/kigo-mobile-bff"
tmx_window_in "payment-hub" "$ROOT/kigo-payment-hub"
tmx_window "git" "lazygit"
tmx_attach
