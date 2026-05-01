#!/bin/sh

helper="/Users/alfredo.vasquez/.config/tmux/scripts/window-label.sh"

tmux list-windows -a -F '#{session_name}:#{window_index}	#{pane_title}	#{pane_current_path}	#{window_name}	#{pane_current_command}	#{@codex_sesh_state}	#{@codex_sesh_cmd}	#{window_zoomed_flag}' |
while IFS="$(printf '\t')" read -r target title path current_name current_cmd window_state configured_cmd zoomed; do
  label="$("$helper" "$title" "$path" "$current_name" "$current_cmd" "bulk" "$window_state" "$configured_cmd" "$zoomed")"
  [ -n "$label" ] || continue
  [ "$label" = "$current_name" ] && continue
  tmux rename-window -t "$target" "$label" >/dev/null 2>&1
done
