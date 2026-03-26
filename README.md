# dotfiles

Curated personal configuration files tracked from `~/.config`.

Tracked:

- `fish`
- `gh`
- `ghostty`
- `git`
- `nvim`
- `opencode`
- `tmux`
- `starship.toml`

Not tracked on purpose:

- `gh/hosts.yml` (machine auth state)
- `fish/fish_variables`
- generated shell completions
- `tmux/plugins`
- `opencode/node_modules`

## Bootstrap

Clone into `~/.config` on a new Mac, then run:

```bash
make bootstrap-macos
```

Useful targets:

- `make brew-bundle`
- `make links`
- `make tmux-plugins`
- `make opencode-deps`
- `make doctor`
