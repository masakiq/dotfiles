# Repository Guidelines

## Project Structure & Module Organization

This repository manages editor and shell tooling through symlinked dotfiles. `vim/init.lua` is the Neovim entrypoint. Shared Lua helpers live in `vim/lua/`. Most day-to-day behavior changes belong in `vim/plugin/`, with grouped settings under `vim/plugin/config/` and language-specific LSP setup under `vim/plugin/lsp/`. Legacy Vim helpers live in `vim/functions/`. Other tool configs are split by app in `direnv/`, `diffview/`, `efm-langserver/`, and `tig/`. Treat `tmp/` as working notes and experiments, not long-term source of truth.

## Build, Test, and Development Commands

- `./install.sh`: symlink this repo into `~/.config/nvim`, `~/.vim`, `~/.config/direnv`, `~/.config/diffview`, and related targets.
- `./linktree.sh vim/plugin ~/.config/nvim/plugin`: mirror one directory tree as symlinks when you only need to refresh part of the config.
- `stylua vim`: format Lua files using the root `.stylua.toml`.
- `find vim -name '*.lua' -print0 | xargs -0 -n1 luac -p`: syntax-check Lua files before opening Neovim.

## Coding Style & Naming Conventions

Lua uses spaces with 2-space indentation; `.stylua.toml` is authoritative. Keep modules narrow and place code in the directory that owns the behavior: reusable helpers in `vim/lua/`, editor commands/autocmds in `vim/plugin/`, and grouped settings in `vim/plugin/config/`. Use `lower_snake_case` for filenames and local variables. Prefer descriptive user-command names such as `MarkdownPreviewITerm` and avoid broad refactors when a small, targeted config change is enough.

## Testing Guidelines

There is no dedicated automated test suite in this repo. For every Lua change, run `stylua` on the affected files, then run `luac -p` syntax checks. After relinking with `./install.sh`, manually smoke-test the edited feature in Neovim, especially keymaps, user commands, preview flows, and terminal integrations. If a change depends on external tools such as `cmux`, `tig`, or `swagger-ui-watcher`, note the prerequisite in the PR.

## Commit & Pull Request Guidelines

Recent history follows Conventional Commits with optional scopes, for example `feat(vim): ...`, `fix(tig): ...`, and `chore(vim): ...`. Keep commits scoped to one config area and write imperative subjects. PRs should explain the behavior change, list the commands used for verification, and mention any machine-specific assumptions. Include terminal output or a short screenshot/clip when the change affects interactive editor behavior.
