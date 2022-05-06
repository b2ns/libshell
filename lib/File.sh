#!/usr/bin/env bash

function File_isDir() {
  [[ -d "$1" ]]
}

function File_isEmpty() {
  ! File_isNotEmpty "$@"
}

function File_isExecutable() {
  [[ -x "$1" ]]
}

function File_isExist() {
  [[ -e "$1" ]]
}

function File_isFile() {
  [[ -f "$1" ]]
}

function File_isNotEmpty() {
  [[ -s "$1" ]]
}

function File_isReadable() {
  [[ -r "$1" ]]
}

function File_isSame() {
  [[ "$1" -ef "$2" ]]
}

function File_isSymlink() {
  [[ -L "$1" ]]
}

function File_isWritable() {
  [[ -w "$1" ]]
}

function File_mkdir() {
  mkdir -p "$1"
}

function File_mkfile() {
  local dir="$(dirname "$1")"
  File_mkdir "$dir" && touch "$1"
}
