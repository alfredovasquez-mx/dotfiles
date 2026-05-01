if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Editor for pi and other tools
set -gx EDITOR nvim

mise activate fish | source
starship init fish | source
source ~/.config/fish/functions/fish_mode_prompt.fish
set -g fish_greeting
set -gx BRAVE_API_KEY BSAivkRYFuQ05BYj8ToroSg0CQ864wk

#kigo-tunnels scripts
fish_add_path ~/bin
alias kt="kigo-tunnels"
alias kt-start="kigo-tunnels start all"
alias kt-stop="kigo-tunnels stop all"
alias kt-status="kigo-tunnels status all"
alias kt-pg="kigo-tunnels start pg"
alias kt-rds="kigo-tunnels start rds"
alias kt-redis="kigo-tunnels start redis"

# Pi sin loader nativo de prompts (pi-prompt-template-model los maneja)
alias pi="command pi --no-prompt-templates"
alias brain="cd ~/brain"
alias sz="sessionize"
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

# Database credentials for MCP (database-mcp)
# PostgreSQL
set -gx PG_HOST 127.0.0.1
set -gx PG_PORT 5432
set -gx PG_USER "alfredo.vasquez"
set -gx PG_PASSWORD "3^PvsmYNDb!tXywRtZ!D"
set -gx PG_DATABASE kibot

# MySQL
set -gx MYSQL_HOST 127.0.0.1
set -gx MYSQL_PORT 8081
set -gx MYSQL_USER "alfredo.vasquez"
set -gx MYSQL_PASSWORD "4y%3t)L9Qr4V"
set -gx MYSQL_DATABASE parkingmeter_kigo
