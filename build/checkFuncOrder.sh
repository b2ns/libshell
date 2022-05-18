#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

declare __dirname=""
__dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$__dirname/../libshell.sh"

declare -ga LIBSHELL_FUNCNAMES=()

check() {
  local file=""
  for file in "$@"; do
    if String_match "$file" "(lib|test)/[^/]+\.sh$"; then
      if String_match "$file" "Args\..+\.sh|Color\..+\.sh"; then
        continue
      fi

      IO_info "Checking $(Path_basename "$file")"

      checking "$file"
    fi
  done

  IO_success "All functions are in order"
}

checking() {
  resetGlobal

  local filename="$1"
  local line=""
  while read -r line; do
    if String_match "$line" "^[A-Z][a-zA-Z_]+\(\) *\{"; then
      local funcName=""
      String_stripEnd "$line" "(*" 1 >/dev/null
      funcName="$RETVAL"

      if ((${#LIBSHELL_FUNCNAMES[@]})); then
        local preFuncName="${LIBSHELL_FUNCNAMES[-1]}"

        if [[ "$preFuncName" > "$funcName" ]]; then
          IO_error "Function $preFuncName or $funcName is not in order."
          return 1
        fi
      fi

      LIBSHELL_FUNCNAMES+=("$funcName")
    fi
  done <"$filename"
}

resetGlobal() {
  LIBSHELL_FUNCNAMES=()
}

if (($#)); then
  check "$@"
fi

# check "$__dirname/../lib/"*.sh
# check "$__dirname/../test/"*.test.sh
