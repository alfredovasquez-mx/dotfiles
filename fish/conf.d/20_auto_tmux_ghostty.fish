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
    if tmux ls >/dev/null 2>&1
        set target (tmux list-sessions -F '#{session_last_attached}\t#{session_activity}\t#{session_name}' | sort -r -n | awk 'NR == 1 { print $3 }')

        if test -n "$target"
            exec tmux attach-session -t "$target"
        end
    end

    exec tmux new-session -A -s main
end
