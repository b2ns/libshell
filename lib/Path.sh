#!/usr/bin/env bash

import String

function Path_dirname() {
  basename "$(dirname "$1")"
}

function Path_dirpath() {
  local filepath=""
  if filepath="$(Path_filepath "$@")"; then
    dirname "$filepath"
  else
    return 1
  fi
}

function Path_expandTilde() {
  local file="$1"
  String_replace "$file" "#\~" "$HOME"
}

function Path_extname() {
  local filename="$(Path_filename "$@")"
  if String_match "$filename" "\.[^./]+$"; then
    echo ".$(String_trimStart "$filename" "*." 1)"
  else
    echo ""
  fi
}

function Path_filename() {
  basename "$1"
}

function Path_filepath() {
  local file="$(Path_expandTilde "$1")"

  if ! [[ -e "$file" ]]; then
    echo "$1" not exist >&2
    return 1
  fi

  if [[ -f "$file" ]]; then
    echo "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
  elif [[ -d "$file" ]]; then
    # shellcheck disable=SC2005
    echo "$(cd "$file" && pwd)"
  fi
}

function Path_isAbs() {
  [[ "$1" == /* ]]
}

function Path_isRel() {
  ! Path_isAbs "$@"
}

function Path_filenoext() {
  local filename="$(Path_filename "$@")"
  if String_match "$filename" "\.[^./]+$"; then
    String_trimEnd "$filename" ".*"
  else
    echo "$filename"
  fi
}

function Path_pathnoext() {
  local pathname=""
  if pathname="$(Path_filepath "$@")"; then
    if String_match "$pathname" "\.[^./]+$"; then
      String_trimEnd "$pathname" ".*"
    else
      echo "$pathname"
    fi
  else
    return 1
  fi
}
