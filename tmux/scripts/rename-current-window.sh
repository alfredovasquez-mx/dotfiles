#!/bin/sh

HELPER="/Users/alfredo.vasquez/.config/tmux/scripts/window-label.sh"
TMUX_BIN="/opt/homebrew/bin/tmux"

[ -n "$TMUX" ] || exit 0
[ -x "$TMUX_BIN" ] || exit 0

target="$($TMUX_BIN display-message -p '#{session_name}:#{window_index}' 2>/dev/null)" || exit 0
current_name="$($TMUX_BIN display-message -p '#{window_name}' 2>/dev/null)" || exit 0
client_name="$($TMUX_BIN display-message -p '#{client_name}' 2>/dev/null)"
title_override="${1:-}"
path_override="${2:-}"
current_cmd="$($TMUX_BIN display-message -p '#{pane_current_command}' 2>/dev/null)"
title_source="pane"

if [ -n "$path_override" ]; then
  path="$path_override"
else
  path="$($TMUX_BIN display-message -p '#{pane_current_path}' 2>/dev/null)"
fi

if [ -n "$title_override" ]; then
  title="$title_override"
  title_source="override"
else
  title="$($TMUX_BIN display-message -p '#{pane_title}' 2>/dev/null)"
  title_source="current"
fi

label="$("$HELPER" "$title" "$path" "$current_name" "$current_cmd" "$title_source")"
[ -n "$label" ] || exit 0
[ "$label" = "$current_name" ] && exit 0

$TMUX_BIN rename-window -t "$target" "$label" >/dev/null 2>&1 || true

if [ -n "$client_name" ]; then
  $TMUX_BIN refresh-client -S -t "$client_name" >/dev/null 2>&1 || true
else
  $TMUX_BIN refresh-client -S >/dev/null 2>&1 || true
fi
