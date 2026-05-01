#!/bin/sh

title="$1"
path="$2"
window_name="$3"
current_cmd="$4"
title_source="${5:-pane}"
window_state="${6:-}"
configured_cmd="${7:-}"
zoomed="${8:-0}"

first_token() {
  printf '%s' "$1" | awk '{print $1}'
}

normalize_token() {
  case "$1" in
    */*)
      basename "$1"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

basename_or_home() {
  case "$1" in
    "" ) printf '%s' "$window_name" ;;
    "$HOME" ) printf '~' ;;
    * ) basename "$1" ;;
  esac
}

# Funcion para imprimir con icono (respeta zoom)
print_with_icon() {
  _icon="$1"
  _text="$2"
  if [ "$zoomed" = "1" ]; then
    printf '%s %s' "󰁌" "$_text"
  else
    printf '%s %s' "$_icon" "$_text"
  fi
}

token="$(first_token "$title")"

if [ -z "$token" ] && [ -n "$current_cmd" ]; then
  token="$(first_token "$current_cmd")"
fi

if [ -n "$configured_cmd" ]; then
  configured_token="$(normalize_token "$(first_token "$configured_cmd")")"
else
  configured_token=""
fi

if [ -z "$title" ] && [ -z "$current_cmd" ]; then
  printf '%s' "$window_name"
  exit 0
fi

# Si hay un comando configurado de sesh y el shell esta esperando, usar el comando configurado
if [ -n "$configured_token" ] && [ "$current_cmd" = "fish" -o "$current_cmd" = "zsh" -o "$current_cmd" = "bash" -o "$current_cmd" = "sh" ]; then
  case "$window_state:$title_source:$title" in
    pending-*:bulk:|starting:bulk:|pending-*:bulk:*Alfredos-MacBook-Air.local*|starting:bulk:*Alfredos-MacBook-Air.local*|pending-*:bulk:~*|starting:bulk:~*|pending-*:bulk:/*|starting:bulk:/*|pending-*:current:*Alfredos-MacBook-Air.local*|starting:current:*Alfredos-MacBook-Air.local*)
      token="$configured_token"
      title="$configured_cmd"
      ;;
  esac
fi

if [ "$title_source" = "current" ]; then
  case "$current_cmd" in
    fish|zsh|bash|sh)
      print_with_icon "" "$(basename_or_home "$path")"
      exit 0
      ;;
  esac
fi

if [ "$current_cmd" = "fish" ] || [ "$current_cmd" = "zsh" ] || [ "$current_cmd" = "bash" ] || [ "$current_cmd" = "sh" ]; then
  case "$title_source:$token:$title" in
    current:*|bulk::|bulk:fish:*|bulk:zsh:*|bulk:bash:*|bulk:sh:*|bulk:ssh:*|bulk:*@*:*|bulk:*.local*:*|bulk:*:~*|bulk:*:/*)
      print_with_icon "" "$(basename_or_home "$path")"
      exit 0
      ;;
  esac
fi

case "$token" in
  PI*|Pi*|pi*)
    print_with_icon "π" "Pi"
    ;;
  OC*|OpenCode*|opencode*)
    print_with_icon "" "OpenCode"
    ;;
  KIRO*|Kiro*|kiro-cli*)
    print_with_icon "󰒓" "Kiro"
    ;;
  nvim*|vim*)
    print_with_icon "" "$token"
    ;;
  git|lazygit*|gitui*)
    print_with_icon "󰊢" "$token"
    ;;
  atac*)
    print_with_icon "󱂛" "$token"
    ;;
  rainfrog*)
    print_with_icon "󱘖" "$token"
    ;;
  docker*|orb*|colima*)
    print_with_icon "" "$token"
    ;;
  python*|python3*|ipython*)
    print_with_icon "" "$token"
    ;;
  node*|nodejs*|npm*|pnpm*|yarn*|bun*)
    print_with_icon "" "$token"
    ;;
  fish|zsh|bash|sh)
    print_with_icon "" "$(basename_or_home "$path")"
    ;;
  *@*|*.local*)
    print_with_icon "󰣀" "$token"
    ;;
  *)
    case "$title" in
      "~"*|/*)
        print_with_icon "" "$(basename_or_home "$path")"
        ;;
      *)
        print_with_icon "" "$token"
        ;;
    esac
    ;;
esac
