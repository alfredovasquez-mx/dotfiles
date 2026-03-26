SHELL := /bin/bash

.PHONY: bootstrap-macos brew-bundle links tmux-plugins opencode-deps doctor

bootstrap-macos:
	./scripts/bootstrap-macos.sh

brew-bundle:
	brew bundle --file ./Brewfile

links:
	./scripts/install-home-links.sh

tmux-plugins:
	./scripts/install-tmux-plugins.sh

opencode-deps:
	./scripts/install-opencode-deps.sh

doctor:
	@echo "Repo: $$(pwd)"
	@echo "Git status:"
	@git status --short --branch
	@echo
	@echo "Key tools:"
	@command -v nvim >/dev/null 2>&1 && nvim --version | head -n 1 || echo "nvim: missing"
	@command -v tmux >/dev/null 2>&1 && tmux -V || echo "tmux: missing"
	@command -v gh >/dev/null 2>&1 && gh --version | head -n 1 || echo "gh: missing"
	@command -v fish >/dev/null 2>&1 && fish --version || echo "fish: missing"
	@command -v bun >/dev/null 2>&1 && bun --version || echo "bun: missing"
