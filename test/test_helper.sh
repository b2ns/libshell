#!/usr/bin/env bash

load_lib() {
  load '../node_modules/bats-support/load'
  load '../node_modules/bats-assert/load'
  load '../node_modules/bats-file/load'
  IMPORT_ALL_LIBS=0 load '../libshell'
}

load_lib

setupFiles() {
  local files=("$@")
  local file=""
  for file in "${files[@]}"; do
    local control="${file%%:*}"
    [[ "$control" == *"nocreate"* ]] && continue

    file="${file#*:}"
    if [[ "$control" == *"dir"* ]]; then
      makeDir "$file"
    else
      makeFile "$file"
    fi
  done
}

teardownFiles() {
  local files=("$@")
  local file=""
  local -i len="${#files[@]}"
  local -i i=""
  for ((i = len - 1; i >= 0; i--)); do
    file="${files[$i]}"
    local control="${file%%:*}"
    [[ "$control" == *"noremove"* ]] && continue

    file="${file#*:}"
    removeFile "$file"
  done
}

makeFile() {
  local file="$1"
  [[ -z "$file" ]] && return
  if ! [[ -e "$file" ]]; then
    : >"$file"
  fi
}

makeDir() {
  local dir="$1"
  [[ -z "$dir" ]] && return
  if ! [[ -e "$dir" ]]; then
    mkdir "$dir"
  fi
}

removeFile() {
  local file="$1"
  [[ -z "$file" ]] && return
  if [[ -f "$file" ]]; then
    rm "$file"
  elif [[ -d "$file" ]]; then
    rmdir "$file"
  fi
}
