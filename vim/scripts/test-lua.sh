#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
VIM_ROOT="$REPO_ROOT/vim"
STATE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nvim-test-state.XXXXXX")
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
NVIM_APPNAME="${NVIM_APPNAME:-dotfiles-test}"

cleanup() {
  rm -rf "$STATE_DIR"
}

trap cleanup EXIT INT TERM

mkdir -p "$XDG_CACHE_HOME"

export XDG_CACHE_HOME
export XDG_STATE_HOME="$STATE_DIR"
export NVIM_APPNAME

usage() {
  cat <<'EOF'
Usage: ./vim/scripts/test-lua.sh [path]
       ./vim/scripts/test-lua.sh [--fast|--slow] [path]

  no path                Run the full vim/tests suite
  vim/tests/..._test.lua Run one explicit test file
  vim/tests/<dir>        Run all tests under that test directory
  vim/.../*.lua          Run the related test file(s) for a source file or source subtree
  --fast                 Run only test files without child Neovim usage
  --slow                 Run only test files with child Neovim usage
  --help                 Show this help
EOF
}

profile=""
target=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --fast)
      profile="fast"
      ;;
    --slow)
      profile="slow"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [ -n "$target" ]; then
        echo "Only one path argument is supported." >&2
        usage >&2
        exit 1
      fi

      target="$1"
      ;;
  esac

  shift
done

export MINITEST_PROFILE="$profile"
export MINITEST_TARGET="$target"

cd "$REPO_ROOT"

nvim --headless --noplugin -u "$VIM_ROOT/scripts/minimal_init.lua" -c "lua dofile('vim/scripts/minitest.lua').run_from_env()"
