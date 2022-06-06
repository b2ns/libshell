#!/usr/bin/env bash

import String
import IO
import Array

# @desc get basename of the given path
# @param path <string>
# @param extname <string> | <number> provide 1 if you dont know the extension name
# @return basename <string>

# @example
# Path_basename "~/path/to/foo.sh"
# # output: foo.sh
#
# Path_basename "~/path/to/foo.sh" ".sh"
# # output: foo
#
# # if you dont know the extension name, you can use the following
# Path_basename "~/path/to/foo.sh" 1
# # output: foo
# @end
Path_basename() {
  local file="${1:-.}"
  local ext="${2:-}"
  if String_notEq "$file" "/"; then
    String_stripEnd "${file}" "/" >/dev/null
    file="$RETVAL"

    String_stripStart "${file}" "*/" 1 >/dev/null
    file="$RETVAL"
  fi

  if String_eq "$ext" "1"; then
    Path_extname "$file" >/dev/null
    ext="$RETVAL"
  fi

  if String_notEmpty "$ext"; then
    String_stripEnd "$file" "$ext" >/dev/null
    file="$RETVAL"
  fi

  RETVAL="$file"
  printf '%s\n' "$file"
}

# @desc get dirname of the given path
# @param path <string>
# @return dirname <string>

# @example
# Path_dirname "~/path/to/foo.sh"
# # output: ~/path/to
#
# Path_dirname "../foo.sh"
# # output: ..
# @end
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

# @desc get extension of the given path
# @param path <string>
# @return extension name <string>

# @example
# Path_extname "~/path/to/foo.sh"
# # output: .sh
# @end
Path_extname() {
  local file="$1"
  local ext=""
  if String_match "$file" "[^./]+\.[^./]+$"; then
    String_stripStart "$file" "*." 1 >/dev/null
    ext=".$RETVAL"

    RETVAL="$ext"
    printf '%s\n' "$ext"
  else
    RETVAL=""
    echo ""
  fi
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

  local -a args=("$@")
  local str=""
  local -a arr=()

  Array_filter args String_notEmpty >/dev/null
  # shellcheck disable=SC2034
  arr=("${RETVAL[@]}")

  Array_join arr "/" >/dev/null
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

Path_resolve() {
  (($# == 0)) && {
    RETVAL="$PWD"
    printf '%s\n' "$PWD"
    return 0
  }

  local -a args=("$@")
  local -i len="$#"
  local res=""
  local -i i=""
  for ((i = ((len - 1)); i >= 0; i--)); do
    local item="${args[i]}"
    Path_join "$item" "$res" >/dev/null
    res="$RETVAL"

    if Path_isAbs "$res"; then
      RETVAL="$res"
      printf '%s\n' "$res"
      return 0
    fi
  done

  Path_join "$PWD" "$res" >/dev/null
  res="$RETVAL"

  RETVAL="$res"
  printf '%s\n' "$res"
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
