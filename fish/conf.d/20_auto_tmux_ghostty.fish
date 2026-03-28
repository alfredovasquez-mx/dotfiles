if not status is-interactive
    return
end

if set -q TMUX
    return
end

if set -q SSH_TTY
    return
end

if not command -q tmux
    return
end

set is_ghostty 0

if test "$TERM_PROGRAM" = "ghostty"
    set is_ghostty 1
else if string match -q "xterm-ghostty*" -- "$TERM"
    set is_ghostty 1
end

if test $is_ghostty -eq 1
    exec ~/.local/bin/tmux-last
end
