#!/usr/bin/env sh

TMUX_BIN="/opt/homebrew/bin/tmux"
SESH_BIN="/opt/homebrew/bin/sesh"
FZF_TMUX_BIN="/opt/homebrew/bin/fzf-tmux"
CONNECT_SCRIPT="/Users/alfredo.vasquez/.config/tmux/scripts/sesh-connect.sh"

SIZE="$($TMUX_BIN display-message -p '#{client_width}x#{client_height}' 2>/dev/null || true)"

if [ -n "$SIZE" ]; then
  $TMUX_BIN set-option -g default-size "$SIZE" >/dev/null 2>&1 || true
fi

CHOICE="$($SESH_BIN list --icons | $FZF_TMUX_BIN -p 80%,70% \
  --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
  --header '  ^a all ^t tmux ^g configs ^x zoxide ^d kill' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(⚡  )+reload(/opt/homebrew/bin/sesh list --icons)' \
  --bind 'ctrl-t:change-prompt(  )+reload(/opt/homebrew/bin/sesh list -t --icons)' \
  --bind 'ctrl-g:change-prompt(  )+reload(/opt/homebrew/bin/sesh list -c --icons)' \
  --bind 'ctrl-x:change-prompt(  )+reload(/opt/homebrew/bin/sesh list -z --icons)' \
  --bind 'ctrl-d:execute(/opt/homebrew/bin/tmux kill-session -t {2..})+reload(/opt/homebrew/bin/sesh list --icons)' \
  --preview-window 'right:55%' \
  --preview '/opt/homebrew/bin/sesh preview {}')"

[ -n "$CHOICE" ] || exit 0

exec "$CONNECT_SCRIPT" "$CHOICE"
