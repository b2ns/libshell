#!/usr/bin/env bash

import String

Path_dirName() {
  local file="${1:-.}"
  if String_notEq "$file" "/"; then
    file="./$file"

    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"

    String_stripEnd "${file}" "/*" >/dev/null
    file="$RETVAL"

    String_stripStart "${file}" "./" >/dev/null
    file="$RETVAL"
  fi
  RETVAL="${file:-/}"
  printf '%s\n' "${file:-/}"
}

Path_dirname() {
  local file="${1:-.}"
  if String_notEq "$file" "/"; then
    file="/$file"

    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"

    String_stripEnd "${file}" "/*" >/dev/null
    file="$RETVAL"

    Path_filename "$file" >/dev/null
    file="$RETVAL"
  fi
  RETVAL="${file:-/}"
  printf '%s\n' "${file:-/}"
}

Path_dirpath() {
  local file=""
  Path_filepath "$@" >/dev/null || return 1
  file="$RETVAL"

  Path_dirName "$file" >/dev/null
  file="$RETVAL"

  RETVAL="$file"
  printf '%s\n' "$file"
}

Path_expandTilde() {
  String_replace "$1" "#\~" "$HOME"
}

Path_extname() {
  local filename=""
  local res=""
  Path_filename "$@" >/dev/null
  filename="$RETVAL"
  if String_match "$filename" "[^./]+\.[^./]+$"; then
    String_stripStart "$filename" "*." 1 >/dev/null
    res=".$RETVAL"

    RETVAL="$res"
    printf '%s\n' "$res"
  else
    RETVAL=""
    echo ""
  fi
}

Path_filename() {
  local file="${1:-.}"
  if String_notEq "$file" "/"; then
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"

    String_stripStart "${file}" "*/" 1 >/dev/null
    file="$RETVAL"
  fi
  RETVAL="$file"
  printf '%s\n' "$file"
}

Path_filepath() {
  local file=""

  Path_expandTilde "$1" >/dev/null
  file="$RETVAL"

  if ! [[ -e "$file" ]]; then
    echo "$1" not exist >&2
    return 1
  fi

  local res=""
  local pwd="$PWD"

  if [[ -f "$file" ]]; then
    local dir=""
    local name=""

    Path_dirName "$file" >/dev/null
    dir="$RETVAL"

    Path_filename "$file" >/dev/null
    name="$RETVAL"

    cd "$dir" || return 1
    res="$PWD/$name"
  elif [[ -d "$file" ]]; then
    cd "$file" || return 1
    res="$PWD"
  fi
  cd "$pwd" || return 1
  RETVAL="$res"
  printf '%s\n' "$res"
}

Path_isAbs() {
  String_startsWith "$1" "/"
}

Path_isRel() {
  ! Path_isAbs "$@"
}

Path_filenoext() {
  local filename=""
  local ext=""
  Path_filename "$@" >/dev/null
  filename="$RETVAL"

  Path_extname "$filename" >/dev/null
  ext="$RETVAL"

  String_stripEnd "$filename" "$ext" >/dev/null
  filename="$RETVAL"

  RETVAL="$filename"
  printf '%s\n' "$filename"
}

Path_pathnoext() {
  local pathname=""
  local ext=""
  Path_filepath "$@" >/dev/null || return 1
  pathname="$RETVAL"

  Path_extname "$pathname" >/dev/null
  ext="$RETVAL"

  String_stripEnd "$pathname" "$ext" >/dev/null
  pathname="$RETVAL"

  RETVAL="$pathname"
  printf '%s\n' "$pathname"
}
