#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

declare __dirname=""
__dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$__dirname/../libshell.sh"

check() {
  local file=""
  for file in "$@"; do
    IO_info "Checking $(Path_basename "$file")"

    checking "$file"
  done

  IO_success "All variables are defined"
}

checking() {
  local filename="$1"
  local readingFuncBody=0
  local -A definedVar=()
  local funcName=""
  local line=""
  while read -r line; do
    # ignore comments
    if String_match "$line" "^ *#"; then
      continue
    fi

    if String_eq "$line" "}"; then
      readingFuncBody=0
      continue
    fi

    if ((readingFuncBody)); then
      if String_match "$line" "local[-aAfFgiIlnrtux ]* ([a-zA-Z_]+)"; then
        local varName="${BASH_REMATCH[1]}"
        definedVar["$varName"]=1
      elif String_match "$line" "[( ]+([a-zA-Z_]+)[+ ]?=[^=]+" ||
        String_match "$line" "for ([a-zA-Z_]+) in" ||
        String_match "$line" "-t ([a-zA-Z_]+) "; then
        local varName="${BASH_REMATCH[1]}"
        if String_match "$varName" "^[A-Z_]+"; then
          continue
        fi
        if ! [[ ${definedVar["$varName"]+_} ]]; then
          IO_error "$funcName: Variable '$varName' is not defined" >&2
          return 1
        fi
      fi

      continue
    fi

    if String_match "$line" "^[a-zA-Z_]+\(\) *\{"; then
      readingFuncBody=1
      String_stripEnd "$line" "(*" 1 >/dev/null
      funcName="$RETVAL"

      IO_log "Checking function '$funcName'..."
      definedVar=()
    fi
  done <"$filename"
}

if (($#)); then
  check "$@"
fi
