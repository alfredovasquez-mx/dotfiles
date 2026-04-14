if not status is-interactive
    return
end

if not set -q TMUX
    return
end

set -g __codex_tmux_rename_script /Users/alfredo.vasquez/.config/tmux/scripts/rename-current-window.sh

function __codex_tmux_window_rename_now --argument-names explicit_title delay
    if not set -q TMUX
        return
    end

    if not test -x $__codex_tmux_rename_script
        return
    end

    set -l wait_time 0
    if test -n "$delay"
        set wait_time $delay
    end

    if test "$wait_time" != 0
        if test -n "$explicit_title"
            begin
                sleep $wait_time
                $__codex_tmux_rename_script "$explicit_title"
            end >/dev/null 2>&1 &
        else
            begin
                sleep $wait_time
                $__codex_tmux_rename_script
            end >/dev/null 2>&1 &
        end
    else
        if test -n "$explicit_title"
            $__codex_tmux_rename_script "$explicit_title" >/dev/null 2>&1 &
        else
            $__codex_tmux_rename_script >/dev/null 2>&1 &
        end
    end
end

function __codex_tmux_window_preexec --on-event fish_preexec
    set -l cmdline (string trim -- "$argv[1]")
    if test -n "$cmdline"
        __codex_tmux_window_rename_now "$cmdline"
    end
end

function __codex_tmux_window_postexec --on-event fish_postexec
    __codex_tmux_window_rename_now "" 0.03
end

function __codex_tmux_window_prompt --on-event fish_prompt
    __codex_tmux_window_rename_now "" 0.01
end

function __codex_tmux_window_pwd --on-variable PWD
    __codex_tmux_window_rename_now "" 0.01
end

__codex_tmux_window_rename_now "" 0.01
