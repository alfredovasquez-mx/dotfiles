if status is-interactive
# Commands to run in interactive sessions can go here
end
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
starship init fish | source
set -g fish_greeting
direnv hook fish | source

#kigo-tunnels scripts
fish_add_path ~/bin
alias kt="kigo-tunnels"
alias kt-start="kigo-tunnels start all"
alias kt-stop="kigo-tunnels stop all"
alias kt-status="kigo-tunnels status all"
alias kt-rds="kigo-tunnels start rds"
alias kt-redis="kigo-tunnels start redis"
alias brain="cd ~/brain"
alias kigo="cd /Users/alfredo.vasquez/dev/work/kigo"
alias bits="cd /Users/alfredo.vasquez/dev/personal/c0deB1ts"
alias avmx="cd /Users/alfredo.vasquez/dev/personal/alfredovasquez-mx"

function kscanner
    ssh kigo-scanner $argv
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :


# Added route for kiro-cli
fish_add_path $HOME/.local/bin

# zoxide initialization
zoxide init fish | source

# opencode
fish_add_path /Users/alfredo.vasquez/.opencode/bin
