#!/bin/sh

set -eu

TMX_SESSION_NAME=""
TMX_ROOT=""
TMX_FIRST_WINDOW=1

tmx__quote() {
  printf "'%s'" "$(printf "%s" "$1" | sed "s/'/'\\\\''/g")"
}

tmx__attach_or_switch() {
  if [ -n "${TMUX:-}" ]; then
    exec tmux switch-client -t "$TMX_SESSION_NAME"
  fi

  exec tmux attach-session -t "$TMX_SESSION_NAME"
}

tmx_session() {
  TMX_SESSION_NAME="$1"
  TMX_ROOT="$2"
  TMX_FIRST_WINDOW=1

  if [ ! -d "$TMX_ROOT" ]; then
    printf 'tmx: path not found: %s\n' "$TMX_ROOT" >&2
    exit 1
  fi

  if tmux has-session -t "$TMX_SESSION_NAME" 2>/dev/null; then
    tmx__attach_or_switch
  fi

  tmux new-session -d -s "$TMX_SESSION_NAME" -c "$TMX_ROOT"
}

tmx_window() {
  name="$1"
  shift || true
  cmd="${*:-}"

  if [ "$TMX_FIRST_WINDOW" -eq 1 ]; then
    tmux rename-window -t "${TMX_SESSION_NAME}:1" "$name"
    target="${TMX_SESSION_NAME}:1"
    TMX_FIRST_WINDOW=0
  else
    tmux new-window -d -t "$TMX_SESSION_NAME" -n "$name" -c "$TMX_ROOT"
    target="${TMX_SESSION_NAME}:$name"
  fi

  if [ -n "$cmd" ]; then
    tmux send-keys -t "$target" "$cmd" C-m
  fi
}

tmx_window_in() {
  name="$1"
  path="$2"
  shift 2 || true
  cmd="${*:-}"

  if [ ! -d "$path" ]; then
    printf 'tmx: window path not found: %s\n' "$path" >&2
    exit 1
  fi

  if [ "$TMX_FIRST_WINDOW" -eq 1 ]; then
    tmux rename-window -t "${TMX_SESSION_NAME}:1" "$name"
    target="${TMX_SESSION_NAME}:1"
    TMX_FIRST_WINDOW=0
    start_cmd="cd $(tmx__quote "$path")"
    if [ -n "$cmd" ]; then
      start_cmd="$start_cmd && $cmd"
    fi
    tmux send-keys -t "$target" "$start_cmd" C-m
    return
  fi

  tmux new-window -d -t "$TMX_SESSION_NAME" -n "$name" -c "$path"
  target="${TMX_SESSION_NAME}:$name"

  if [ -n "$cmd" ]; then
    tmux send-keys -t "$target" "$cmd" C-m
  fi
}

tmx_attach() {
  tmx__attach_or_switch
}
