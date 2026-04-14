#!/bin/sh

helper="/Users/alfredo.vasquez/.config/tmux/scripts/window-label.sh"

tmux list-windows -a -F '#{session_name}:#{window_index}	#{pane_title}	#{pane_current_path}	#{window_name}	#{pane_current_command}' |
while IFS="$(printf '\t')" read -r target title path current_name current_cmd; do
  label="$("$helper" "$title" "$path" "$current_name" "$current_cmd" "bulk")"
  [ -n "$label" ] || continue
  [ "$label" = "$current_name" ] && continue
  tmux rename-window -t "$target" "$label" >/dev/null 2>&1
done
