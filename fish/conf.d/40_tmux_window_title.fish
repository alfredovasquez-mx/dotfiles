if not status is-interactive
    return
end

if not set -q TMUX
    return
end

set -g __codex_tmux_rename_script /Users/alfredo.vasquez/.config/tmux/scripts/rename-current-window.sh

function __codex_tmux_window_primary_command --argument-names cmdline
    set -l parts (string split ' ' -- (string trim -- "$cmdline"))

    for part in $parts
        if test -z "$part"
            continue
        end

        if string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' -- "$part"
            continue
        end

        switch $part
            case env command builtin sudo time nohup
                continue
        end

        echo $part
        return 0
    end

    return 1
end

function __codex_tmux_window_should_rename_preexec --argument-names cmdline
    set -l primary (__codex_tmux_window_primary_command "$cmdline")
    if test -z "$primary"
        return 1
    end

    switch $primary
        case nvim vim vi git lazygit gitui atac rainfrog pi opencode ssh mosh yazi lf ranger k9s htop btop top
            return 0
    end

    return 1
end

function __codex_tmux_window_rename_now --argument-names explicit_title delay path_override
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
                $__codex_tmux_rename_script "$explicit_title" "$path_override"
            end >/dev/null 2>&1 &
        else
            begin
                sleep $wait_time
                $__codex_tmux_rename_script "" "$path_override"
            end >/dev/null 2>&1 &
        end
    else
        if test -n "$explicit_title"
            $__codex_tmux_rename_script "$explicit_title" "$path_override" >/dev/null 2>&1 &
        else
            $__codex_tmux_rename_script "" "$path_override" >/dev/null 2>&1 &
        end
    end
end

function __codex_tmux_window_preexec --on-event fish_preexec
    set -l cmdline (string trim -- "$argv[1]")
    if test -n "$cmdline"; and __codex_tmux_window_should_rename_preexec "$cmdline"
        __codex_tmux_window_rename_now "$cmdline"
    end
end

function __codex_tmux_window_postexec --on-event fish_postexec
    __codex_tmux_window_rename_now "" 0.03 "$PWD"
end

function __codex_tmux_window_prompt --on-event fish_prompt
    __codex_tmux_window_rename_now "" 0.01 "$PWD"
end

function __codex_tmux_window_pwd --on-variable PWD
    $__codex_tmux_rename_script "" "$PWD" >/dev/null 2>&1
end

__codex_tmux_window_rename_now "" 0.01 "$PWD"
