#!/usr/bin/env bash

import String

Path_dirName() {
  local file="$1"
  local res=""
  if String_eq "$file" "/"; then
    res="/"
  elif String_isEmpty "$file"; then
    res="."
  else
    file="./$file"
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"
    String_stripEnd "${file}" "/*" >/dev/null
    file="$RETVAL"
    String_stripStart "${file}" "./" >/dev/null
    file="$RETVAL"
    if String_isEmpty "$file"; then
      res="/"
    else
      res="$file"
    fi
  fi
  RETVAL="$res"
  printf "%s" "$res"
}

Path_dirname() {
  local file="$1"
  local res=""
  if String_eq "$file" "/"; then
    res="/"
  elif String_isEmpty "$file"; then
    res="."
  else
    file="/$file"
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"
    String_stripEnd "${file}" "/*" >/dev/null
    file="$RETVAL"
    Path_filename "$file" >/dev/null
    res="$RETVAL"
  fi
  RETVAL="$res"
  printf "%s" "$res"
}

Path_dirpath() {
  local file=""
  local res=""
  Path_filepath "$@" >/dev/null || return 1
  file="$RETVAL"
  if String_eq "$file" "/"; then
    res="/"
  else
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"
    String_stripEnd "${file}" "/*" >/dev/null
    res="$RETVAL"
  fi
  RETVAL="$res"
  printf "%s" "$res"
}

Path_expandTilde() {
  local file="$1"
  String_replace "$file" "#\~" "$HOME"
}

Path_extname() {
  local filename=""
  Path_filename "$@" >/dev/null
  filename="$RETVAL"
  if String_match "$filename" "\.[^./]+$"; then
    String_stripStart "$filename" "*." 1 >/dev/null
    local res=".$RETVAL"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    RETVAL=""
    echo ""
  fi
}

Path_filename() {
  local file="$1"
  local res=""
  if String_eq "$file" "/"; then
    res="/"
  elif String_isEmpty "$file"; then
    res="."
  else
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"
    String_stripStart "${file}" "*/" 1 >/dev/null
    res="$RETVAL"
  fi
  RETVAL="$res"
  printf "%s" "$res"
}

Path_filepath() {
  local file=""
  Path_expandTilde "$1" >/dev/null
  file="$RETVAL"

  if ! [[ -e "$file" ]]; then
    echo "$1" not exist >&2
    return 1
  fi

  if [[ -f "$file" ]]; then
    local res=""
    local dir=""
    local name=""
    Path_dirName "$file" >/dev/null
    dir="$RETVAL"
    Path_filename "$file" >/dev/null
    name="$RETVAL"
    res="$(cd "$dir" && pwd)/$name"
    RETVAL="$res"
    printf '%s\n' "$res"
  elif [[ -d "$file" ]]; then
    local res=""
    res="$(cd "$file" && pwd)"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

Path_isAbs() {
  [[ "$1" == /* ]]
}

Path_isRel() {
  ! Path_isAbs "$@"
}

Path_filenoext() {
  local filename=""
  Path_filename "$@" >/dev/null
  filename="$RETVAL"
  if String_match "$filename" "\.[^./]+$"; then
    String_stripEnd "$filename" ".*"
  else
    RETVAL="$filename"
    printf '%s\n' "$filename"
  fi
}

Path_pathnoext() {
  local pathname=""
  Path_filepath "$@" >/dev/null || return 1
  pathname="$RETVAL"
  if String_match "$pathname" "\.[^./]+$"; then
    String_stripEnd "$pathname" ".*"
  else
    RETVAL="$pathname"
    printf '%s\n' "$pathname"
  fi
}
