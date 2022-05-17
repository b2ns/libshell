#!/usr/bin/env bash

import String
import IO
import Array

Path_basename() {
  local file="${1:-.}"
  local ext="${2:-}"
  if String_notEq "$file" "/"; then
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"

    String_stripStart "${file}" "*/" 1 >/dev/null
    file="$RETVAL"
  fi

  if String_notEmpty "$ext"; then
    String_stripEnd "$file" "$ext" >/dev/null
    file="$RETVAL"
  fi

  RETVAL="$file"
  printf '%s\n' "$file"
}

Path_dirname() {
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

Path_dirpath() {
  local file=""
  Path_filepath "$@" >/dev/null || return 1
  file="$RETVAL"

  Path_dirname "$file" >/dev/null
  file="$RETVAL"

  RETVAL="$file"
  printf '%s\n' "$file"
}

Path_extname() {
  local filename=""
  local res=""
  Path_basename "$@" >/dev/null
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

Path_filepath() {
  local file=""

  __expandTilde__ "$1" >/dev/null
  file="$RETVAL"

  if ! [[ -e "$file" ]]; then
    IO_error "$1 not exist" >&2
    return 1
  fi

  local res=""
  local pwd="$PWD"

  if [[ -f "$file" ]]; then
    local dir=""
    local name=""

    Path_dirname "$file" >/dev/null
    dir="$RETVAL"

    Path_basename "$file" >/dev/null
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

Path_join() {
  (($# == 0)) && {
    RETVAL="."
    echo "."
    return 0
  }

  local str=""
  local -a arr=()

  Array_filter "$@" String_notEmpty >/dev/null
  arr=("${RETVAL[@]}")

  Array_join "${arr[@]}" "/" >/dev/null
  str="$RETVAL"

  __trimSlash__ "$str" >/dev/null
  str="$RETVAL"

  String_replaceAll "$str" "\.\." "\\/\\/" >/dev/null
  str="$RETVAL"

  String_replaceAll "$str" "\./" "" >/dev/null
  str="$RETVAL"

  String_replaceAll "$str" "\\\/" "." >/dev/null
  str="$RETVAL"

  if String_endsWith "$str" "/."; then
    String_stripEnd "$str" "/." >/dev/null
    str="$RETVAL"
  fi

  while String_match "$str" "([^./]+/\.\./?)"; do
    String_replaceAll "$str" "${BASH_REMATCH[1]}" "" >/dev/null
    str="$RETVAL"

    __trimSlash__ "$str" >/dev/null
    str="$RETVAL"
  done

  if String_match "$str" "^/\.\."; then
    String_replaceAll "$str" "\.\." "" >/dev/null
    str="$RETVAL"
  fi

  __trimSlash__ "$str" >/dev/null
  str="$RETVAL"

  if String_notEq "/" "$str" && String_endsWith "/"; then
    String_stripEnd "$str" "/" >/dev/null
    str="$RETVAL"
  fi

  RETVAL="${str:-.}"
  printf '%s\n' "${str:-.}"
}

__expandTilde__() {
  String_replace "$1" "#\~" "$HOME"
}

__trimSlash__() {
  local str="$1"
  local tmp=""
  while String_notEq "$tmp" "$str"; do
    tmp="$str"
    String_replaceAll "$str" "\/\/" "/" >/dev/null
    str="$RETVAL"
  done

  RETVAL="$str"
  printf '%s\n' "$str"
}
