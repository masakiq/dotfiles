#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
VIM_ROOT="$REPO_ROOT/vim"
CACHE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nvim-test-cache.XXXXXX")
STATE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nvim-test-state.XXXXXX")
DATA_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nvim-test-data.XXXXXX")

cleanup() {
  rm -rf "$CACHE_DIR" "$STATE_DIR" "$DATA_DIR"
}

trap cleanup EXIT INT TERM

export XDG_CACHE_HOME="$CACHE_DIR"
export XDG_STATE_HOME="$STATE_DIR"
export XDG_DATA_HOME="$DATA_DIR"
export MINITEST_FILE="${1:-}"

cd "$REPO_ROOT"

nvim --headless --noplugin -u "$VIM_ROOT/scripts/minimal_init.lua" -c "lua dofile('vim/scripts/minitest.lua').run_from_env()"
