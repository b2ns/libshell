#!/usr/bin/env bash

# shellcheck disable=SC2155
declare -g LIB_SHELL_PATH="$(cd "${BASH_SOURCE[0]%/*}" && pwd)/lib"
declare -Ag LIB_SHELL_IMPORTED_LIBS
declare -g IMPORT_ALL_LIBS="${IMPORT_ALL_LIBS:-1}"

function import() {

  local scriptRoot="${BASH_SOURCE[1]:-$0}"
  scriptRoot="$(cd "${scriptRoot%/*}" && pwd)"
  for lib in "$@"; do
    if [[ "$lib" == './'* ]]; then
      lib="${lib:2}"
    fi
    __source_path__ "${scriptRoot}/${lib}" || __source_path__ "${lib}" || __source_path__ "${LIB_SHELL_PATH}/${lib}"
  done
}

function __source_path__() {
  local lib="$1"
  if [[ -d "$lib" ]]; then
    for file in "$lib"/*.sh; do
      __source_file__ "$file"
    done
  else
    __source_file__ "$lib" || __source_file__ "${lib}.sh"
  fi
}

function __source_file__() {
  local lib="$1"

  [[ ! -f "$lib" ]] && return 1

  lib="$(__abspath__ "$lib")"

  if [[ -f "$lib" ]]; then
    if [[ ${LIB_SHELL_IMPORTED_LIBS["$lib"]+_} ]]; then
      return 0
    fi

    LIB_SHELL_IMPORTED_LIBS+=(["$lib"]=1)

    # shellcheck disable=SC1090
    source "$lib"
  fi
}

function __abspath__() {
  local file="$1"
  if [[ "$file" == "/"* ]]; then
    echo "$file"
  else
    echo "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
  fi
}

# import all libs
# use IMPORT_ALL_LIBS=0 to disable this feature
if [[ "$IMPORT_ALL_LIBS" != 0 ]]; then
  for lib in "${LIB_SHELL_PATH}"/*.sh; do
    import "$lib"
  done
fi
