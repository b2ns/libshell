#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

declare scriptRoot=""
scriptRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$scriptRoot/../libshell.sh"

declare -gA LIBSHELL_FUNC=()
declare -gA LIBSHELL_FUNC_TMP=()
declare -ga LIBSHELL_FUNCNAMES=()

build() {
  local file=""
  for file in "$@"; do
    local libName=""
    Path_filenoext "$file" >/dev/null
    libName="$RETVAL"

    IO_info "Building ${libName}.md"

    parse "$file"

    genDoc "$scriptRoot/../doc/${libName}.md" "$libName"
  done

  IO_success "done!"
}

parse() {
  resetGlobal

  local filename="$1"
  local -i readingExampleFlag=0
  local line=""
  while read -r line; do
    if String_match "$line" "^# *@end"; then
      readingExampleFlag=0
      continue
    fi

    if ((readingExampleFlag)); then
      local code=""
      String_stripStart "$line" "#" >/dev/null
      code="$RETVAL"

      String_stripStart "$code" "* " >/dev/null
      code="$RETVAL"

      if [[ ${LIBSHELL_FUNC_TMP[example]+_} ]]; then
        LIBSHELL_FUNC_TMP[example]="${LIBSHELL_FUNC_TMP[example]}\n$code"
      else
        LIBSHELL_FUNC_TMP[example]="$code"
      fi
      continue
    fi

    if String_match "$line" "^# *@example"; then
      readingExampleFlag=1
      if [[ ${LIBSHELL_FUNC_TMP[example]+_} ]]; then
        LIBSHELL_FUNC_TMP[example]="${LIBSHELL_FUNC_TMP[example]}\n"
      fi
      continue
    fi

    if String_match "$line" "^# *@"; then
      local tmp=""
      local atName=""
      local value=""

      String_stripStart "$line" "*@" >/dev/null
      tmp="$RETVAL"

      String_stripEnd "$tmp" " *" 1 >/dev/null
      atName="$RETVAL"

      String_stripStart "$line" "*@$atName" >/dev/null
      value="$RETVAL"

      String_stripStart "$value" " *" >/dev/null
      value="$RETVAL"

      # escape special characters
      local symbol=""
      for symbol in \\ \` \~ \* \+ - \. \[ \]; do
        String_replaceAll "$value" "\\$symbol" "\\$symbol" >/dev/null
        value="$RETVAL"
      done

      if [[ ${LIBSHELL_FUNC_TMP[$atName]+_} ]]; then
        LIBSHELL_FUNC_TMP[$atName]="${LIBSHELL_FUNC_TMP[$atName]}|||$value"
      else
        LIBSHELL_FUNC_TMP[$atName]="$value"
      fi

      continue
    fi

    if String_match "$line" "^[^_][a-zA-Z_]+\(\) *\{"; then
      local funcName=""
      String_stripEnd "$line" "(*" 1 >/dev/null
      funcName="$RETVAL"
      LIBSHELL_FUNCNAMES+=("$funcName")

      local key=""
      for key in "${!LIBSHELL_FUNC_TMP[@]}"; do
        LIBSHELL_FUNC["${funcName}#$key"]="${LIBSHELL_FUNC_TMP[$key]}"
      done
      LIBSHELL_FUNC_TMP=()
      continue
    fi
  done <"$filename"
}

genDoc() {
  local outputFile="$1"
  local libName="$2"
  local outputText="### $libName\n"

  # gen anchor link
  local funcName=""
  for funcName in "${LIBSHELL_FUNCNAMES[@]}"; do
    local name="$funcName"
    outputText="$outputText\n- [$name](#$name)"
  done

  local funcName=""
  for funcName in "${LIBSHELL_FUNCNAMES[@]}"; do
    local name="$funcName"

    # @deprecated
    if [[ ${LIBSHELL_FUNC["${funcName}#deprecated"]+_} ]]; then
      name="$name (deprecated)"
    fi
    outputText="$outputText\n\n#### $name"
    outputText="$outputText\n\n___"

    # @desc
    if [[ ${LIBSHELL_FUNC["${funcName}#desc"]+_} ]]; then
      local desc="${LIBSHELL_FUNC["${funcName}#desc"]}"
      String_split "$desc" "|||" >/dev/null
      desc=("${RETVAL[@]}")

      local tmpStr=""
      local item=""
      for item in "${desc[@]}"; do
        tmpStr="$tmpStr\n\n> $item"
      done

      outputText="$outputText$tmpStr"
    fi

    # @param
    if [[ ${LIBSHELL_FUNC["${funcName}#param"]+_} ]]; then
      local params="${LIBSHELL_FUNC["${funcName}#param"]}"
      String_split "$params" "|||" >/dev/null
      params=("${RETVAL[@]}")

      local tmpStr=""
      local item=""
      for item in "${params[@]}"; do
        if String_match "$item" "<(.*)>"; then
          String_replace "$item" "<${BASH_REMATCH[1]}>" "<*${BASH_REMATCH[1]}*>" >/dev/null
          item="$RETVAL"
        fi

        if String_match "$item" "^([^ ]*) <"; then
          String_replace "$item" "${BASH_REMATCH[1]} <" "**${BASH_REMATCH[1]}** <" >/dev/null
          item="$RETVAL"
        fi

        tmpStr="$tmpStr\n- $item"
      done

      outputText="$outputText\n$tmpStr"
    fi

    # @return
    if [[ ${LIBSHELL_FUNC["${funcName}#return"]+_} ]]; then
      local ret="${LIBSHELL_FUNC["${funcName}#return"]}"
      String_split "$ret" "|||" >/dev/null
      ret=("${RETVAL[@]}")

      local tmpStr=""
      local item=""
      for item in "${ret[@]}"; do
        if String_match "$item" "<(.*)>"; then
          String_replace "$item" "<${BASH_REMATCH[1]}>" "<*${BASH_REMATCH[1]}*>" >/dev/null
          item="$RETVAL"
        fi

        tmpStr="$tmpStr\n+ **@return** $item"
      done

      outputText="$outputText\n$tmpStr"
    fi

    # @example
    if [[ ${LIBSHELL_FUNC["${funcName}#example"]+_} ]]; then
      local example="${LIBSHELL_FUNC["${funcName}#example"]}"

      local tmpStr='```sh'
      tmpStr="$tmpStr\n$example"
      tmpStr="$tmpStr\n"'```'

      outputText="$outputText\n\n$tmpStr"
    fi

  done

  printf "$outputText%s" "" >"$outputFile"
}

resetGlobal() {
  LIBSHELL_FUNC=()
  LIBSHELL_FUNC_TMP=()
  LIBSHELL_FUNCNAMES=()
}

# let's build it
build "$scriptRoot/../lib/"*.sh
