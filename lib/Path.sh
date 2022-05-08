#!/usr/bin/env bash

import String

Path_dirname() {
  basename "$(dirname "$1")"
}

Path_dirpath() {
  local filepath=""
  if filepath="$(Path_filepath "$@")"; then
    dirname "$filepath"
  else
    return 1
  fi
}

Path_expandTilde() {
  local file="$1"
  String_replace "$file" "#\~" "$HOME"
}

Path_extname() {
  local filename="$(Path_filename "$@")"
  if String_match "$filename" "\.[^./]+$"; then
    printf '%s\n' ".$(String_trimStart "$filename" "*." 1)"
  else
    echo ""
  fi
}

Path_filename() {
  basename "$1"
}

Path_filepath() {
  local file="$(Path_expandTilde "$1")"

  if ! [[ -e "$file" ]]; then
    echo "$1" not exist >&2
    return 1
  fi

  if [[ -f "$file" ]]; then
    printf '%s\n' "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
  elif [[ -d "$file" ]]; then
    # shellcheck disable=SC2005
    printf '%s\n' "$(cd "$file" && pwd)"
  fi
}

Path_isAbs() {
  [[ "$1" == /* ]]
}

Path_isRel() {
  ! Path_isAbs "$@"
}

Path_filenoext() {
  local filename="$(Path_filename "$@")"
  if String_match "$filename" "\.[^./]+$"; then
    String_trimEnd "$filename" ".*"
  else
    printf '%s\n' "$filename"
  fi
}

Path_pathnoext() {
  local pathname=""
  if pathname="$(Path_filepath "$@")"; then
    if String_match "$pathname" "\.[^./]+$"; then
      String_trimEnd "$pathname" ".*"
    else
      printf '%s\n' "$pathname"
    fi
  else
    return 1
  fi
}
