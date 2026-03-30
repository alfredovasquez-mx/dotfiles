if not status is-interactive
    return
end

fish_vi_key_bindings

# Cursor shapes by mode.
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

# Fish completion colors aligned with Kanagawa Dragon.
set -g fish_pager_color_prefix 87a987 --bold
set -g fish_pager_color_completion 87a987
set -g fish_pager_color_description c4b28a
set -g fish_pager_color_selected_background --background=8a9a7b
set -g fish_pager_color_selected_prefix 181616 --bold
set -g fish_pager_color_selected_completion 181616 --bold
set -g fish_pager_color_selected_description 181616
