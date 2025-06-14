#!/usr/bin/env sh
# linktree.sh
# How to use: ./linktree.sh <SOURCE_DIR> <DEST_DIR>

set -euo pipefail

usage() {
  echo "Usage: $0 <SOURCE_DIR> <DEST_DIR>" >&2
  exit 1
}

[[ $# -ne 2 ]] && usage

src_raw=$1
dest_raw=$2

[[ -e "$src_raw" && ! -d "$src_raw" ]] && {
  echo "Error: $src_raw exists but is not a directory." >&2
  exit 1
}
[[ -e "$dest_raw" && ! -d "$dest_raw" ]] && {
  echo "Error: $dest_raw exists but is not a directory." >&2
  exit 1
}

mkdir -p "$src_raw"
mkdir -p "$dest_raw"
# ---------------------------------------------------------------------

if command -v readlink >/dev/null && readlink -f / >/dev/null 2>&1; then
  src=$(readlink -f "$src_raw")
  dest=$(readlink -f "$dest_raw")
else
  src=$(cd "$src_raw" && pwd)
  dest=$(cd "$dest_raw" && pwd)
fi

cd "$src"

find . -mindepth 1 -print0 | while IFS= read -r -d '' path; do
  target="$dest/$path"

  if [[ -d "$path" ]]; then
    mkdir -p "$target"
  else
    mkdir -p "$(dirname "$target")"
    ln -sf "$src/$path" "$target"
  fi
done
