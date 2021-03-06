#!/usr/bin/env bash

# check bash version 4.3+
if ((${BASH_VERSINFO[0]:-0} < 4)) || ((BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3)); then
  echo "libshell requires bash version 4.3 or higher"
  exit 1
fi

declare -gi LIBSHELL_SOURCED="${LIBSHELL_SOURCED:-0}"

# libshell has been sourced so we just return
((LIBSHELL_SOURCED)) && return 0

declare -g LIBSHELL_PATH=""
LIBSHELL_PATH="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)/lib"
declare -gA LIBSHELL_IMPORTED_LIBS=()
declare -gi IMPORT_ALL_LIBS="${IMPORT_ALL_LIBS:-1}"

# a special variable to store return value of the last function call
# get the return value of function through this global variable
# rather than using stdout with subshell, which is poor for performance
# shellcheck disable=SC2034
declare -g RETVAL=""

import() {
  local scriptRoot=""
  scriptRoot="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[1]}")")" && pwd)"

  local lib=""
  for lib in "$@"; do
    if [[ "$lib" == './'* ]]; then
      lib="${lib:2}"
    fi
    if ! __source_path__ "$scriptRoot/$lib" && ! __source_path__ "$lib" && ! __source_path__ "$LIBSHELL_PATH/$lib"; then
      echo "Error: failed to import $lib" >&2
      return 1
    fi
  done
}

__source_path__() {
  local lib="$1"
  if [[ -d "$lib" ]]; then
    local file=""
    for file in "$lib"/*.sh; do
      __source_file__ "$file"
    done
  else
    __source_file__ "$lib" || __source_file__ "${lib}.sh"
  fi
}

__source_file__() {
  local lib="$1"

  [[ ! -f "$lib" ]] && return 1

  lib="$(__abspath__ "$lib")"

  if [[ ${LIBSHELL_IMPORTED_LIBS["$lib"]+_} ]]; then
    return 0
  fi

  LIBSHELL_IMPORTED_LIBS+=(["$lib"]=1)

  source "$lib"
}

__abspath__() {
  local file="$1"
  printf '%s\n' "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
}

# import all libs
# use IMPORT_ALL_LIBS=0 to disable this feature
if ((IMPORT_ALL_LIBS)); then
  import "$LIBSHELL_PATH"/*.sh
fi

# libshell has been sourced
LIBSHELL_SOURCED=1
