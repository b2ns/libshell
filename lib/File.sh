#!/usr/bin/env bash

import Path

File_isDir() {
  [[ -d "$1" ]]
}

File_isEmpty() {
  ! File_notEmpty "$@"
}

File_isExecutable() {
  [[ -x "$1" ]]
}

File_isExist() {
  [[ -e "$1" ]]
}

File_isFile() {
  [[ -f "$1" ]]
}

File_notEmpty() {
  [[ -s "$1" ]]
}

File_isReadable() {
  [[ -r "$1" ]]
}

File_isSame() {
  [[ "$1" -ef "$2" ]]
}

File_isSymlink() {
  [[ -L "$1" ]]
}

File_isWritable() {
  [[ -w "$1" ]]
}

File_mkdir() {
  mkdir -p "$1"
}

File_mkfile() {
  local dir=""
  Path_dirName "$1"
  dir="$RETVAL"
  File_mkdir "$dir" && : >"$1"
}
