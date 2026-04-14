set -gx ATAC_THEME "$HOME/.config/atac/themes/kanagawa-dragon.toml"
set -gx ATAC_KEY_BINDINGS "$HOME/.config/atac/key_bindings/vim_key_bindings.toml"

function __atac_project_root
    git rev-parse --show-toplevel 2>/dev/null
    or pwd
end

function __atac_has_explicit_directory --argument-names argv0
    for arg in $argv
        if test "$arg" = "-d" -o "$arg" = "--directory"
            return 0
        end
    end

    return 1
end

function atac
    if set -q ATAC_MAIN_DIR
        command atac $argv
        return $status
    end

    if __atac_has_explicit_directory $argv
        command atac $argv
        return $status
    end

    set -l root (__atac_project_root)
    if test -d "$root/.atac"
        env ATAC_MAIN_DIR="$root/.atac" command atac $argv
    else
        command atac $argv
    end
end

function atacp
    set -l root (__atac_project_root)
    env ATAC_MAIN_DIR="$root/.atac" atac $argv
end

function atac-init-project
    set -l root (__atac_project_root)
    set -l template "$HOME/.config/atac/templates/project"

    mkdir -p "$root/.atac"

    test -f "$root/.atac/atac.toml"; or cp "$template/atac.toml" "$root/.atac/atac.toml"
    test -f "$root/.atac/.env.local"; or cp "$template/.env.local" "$root/.atac/.env.local"
    test -f "$root/.atac/.env.dev"; or cp "$template/.env.dev" "$root/.atac/.env.dev"
    test -f "$root/.atac/.env.prod"; or cp "$template/.env.prod" "$root/.atac/.env.prod"
    test -f "$root/.atac/.env.mise"; or cp "$template/.env.mise" "$root/.atac/.env.mise"

    echo "ATAC initialized in $root/.atac"
end
