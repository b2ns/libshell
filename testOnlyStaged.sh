#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

declare -A files=()
for file in "$@"; do
  if [[ "$file" =~ lib/[^/]+\.sh$ ]]; then
    declare name="${file##*/}"
    declare namenoext="${name%.sh}"
    declare root="${file%lib/$name}"
    file="${root%/*}/test/${namenoext}.test.sh"
  fi
  if [[ -e "$file" ]] && [[ "$file" =~ test/[^/]+\.sh$ ]]; then
    files["$file"]=1
  fi
done

if ((${#files[@]})); then
  yarn testcmd "${!files[@]}"
fi
