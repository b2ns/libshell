#!/usr/bin/env bash

import String

declare -gA ARGS_DEFINED_OPTIONS=()
declare -gA ARGS_REQUIRED_OPTIONS=()
declare -gA ARGS_OPTIONS=()
declare -ga ARGS_INPUT=()

Args_define() {
  (($# == 0)) && return 0

  local allFlag="$1"
  readarray -t flags <<<"$(String_split "$1" " ")"
  local desc="${2-}"
  local valueType="${3-}"
  local defaultValue="${4-}"

  for singleFlag in "${flags[@]}"; do
    # check invalid flag
    __validateDefineFlag__ "$singleFlag" || return 1

    # check duplicate flag
    if Args_defined "$singleFlag" 2>/dev/null; then
      echo "Error: duplicate flag defined: [$singleFlag]" >&2
      return 1
    fi

    ARGS_DEFINED_OPTIONS[$singleFlag]="$allFlag"
  done

  ARGS_DEFINED_OPTIONS["${allFlag}#desc"]="$desc"

  if String_match "$valueType" ">!+$"; then
    valueType="$(String_trimEnd "$valueType" "!*" 1)"
    ARGS_REQUIRED_OPTIONS[$allFlag]=1
  fi
  ARGS_DEFINED_OPTIONS["${allFlag}#valueType"]="$valueType"

  ARGS_DEFINED_OPTIONS["${allFlag}#defaultValue"]="$defaultValue"

  # set default value
  ARGS_OPTIONS[$allFlag]="$defaultValue"
}

Args_defined() {
  if [[ ${ARGS_DEFINED_OPTIONS[$1]+_} ]]; then
    return 0
  else
    echo "Error: flag [$1] not defined" >&2
    return 1
  fi
}

Args_get() {
  if Args_defined "$1"; then
    local allFlag="${ARGS_DEFINED_OPTIONS[$1]}"
    printf '%s\n' "${ARGS_OPTIONS[$allFlag]}"
  else
    return 1
  fi
}

Args_getInput() {
  printf '%s\n' "${ARGS_INPUT[@]}"
}

Args_has() {
  local value=""
  if value="$(Args_get "$1" 2>/dev/null)"; then
    if String_isEmpty "$value"; then
      return 1
    else
      return 0
    fi
  else
    return 1
  fi
}

Args_help() {
  local headInfo=${1:-}
  local tailInfo=${2:-}
  local scriptName="$(String_trimStart "$0" "*/" 1)"

  String_isNotEmpty "$scriptName" && printf '%s\n' "$scriptName"

  if String_isNotEmpty "$headInfo"; then
    printf '%s\n' "$headInfo"
  fi

  echo

  for key in "${!ARGS_OPTIONS[@]}"; do
    local msg="[$key]"
    local desc="${ARGS_DEFINED_OPTIONS["$key#desc"]}"
    local valueType="${ARGS_DEFINED_OPTIONS["$key#valueType"]}"
    local defaultValue="${ARGS_DEFINED_OPTIONS["$key#defaultValue"]}"
    String_isNotEmpty "$desc" && msg="$msg - $desc"
    String_isNotEmpty "$valueType" && msg="$msg ($valueType)"
    String_isNotEmpty "$defaultValue" && msg="$msg (default: $defaultValue)"
    printf '  %s\n' "$msg"
    echo
  done

  if String_isNotEmpty "$tailInfo"; then
    printf '%s\n' "$tailInfo"
  fi
}

Args_parse() {
  local args=("$@")
  local singleFlag=""
  local allFlag=""
  local valueType=""
  local readingFlagValue=0

  # unify args
  # --format=json -> --format json
  # -cvf -> -c -v -f
  # -cvf=json -> -c -v -f json
  local -a unifiedArgs=()
  for ((i = 0; i < "${#args[@]}"; i++)); do
    local arg="${args[$i]}"
    if __validateInputFlag__ "$arg" 2>/dev/null; then
      if String_match "$arg" "^--[^=]+=.*$"; then
        local flag="$(String_trimEnd "$arg" "=*" 1)"
        local value="$(String_trimStart "$arg" "*=")"
        unifiedArgs+=("$flag")
        unifiedArgs+=("$value")
      elif String_match "$arg" "^-[^-]+$"; then
        local value="$(String_trimStart "$arg" "*=")"
        local arg_="$(String_trimEnd "$arg" "=*" 1)"

        arg_="$(String_trimStart "$arg_" "-")"
        readarray -t flags <<<"$(String_split "$arg_" "")"
        for singleFlag in "${flags[@]}"; do
          unifiedArgs+=("-$singleFlag")
        done

        [[ "$value" != "$arg" ]] && unifiedArgs+=("$value")
      else
        unifiedArgs+=("$arg")
      fi
    else
      unifiedArgs+=("$arg")
    fi
  done

  for ((i = 0; i < "${#unifiedArgs[@]}"; i++)); do
    local arg="${unifiedArgs[$i]}"

    if __validateDefineFlag__ "$arg" 2>/dev/null; then
      if ((readingFlagValue == 1)); then
        echo "Error: flag [$singleFlag] expect a value" >&2
        return 1
      fi

      singleFlag="$arg"
      if ! Args_defined "$singleFlag"; then
        return 1
      fi

      allFlag="${ARGS_DEFINED_OPTIONS[$singleFlag]}"
      valueType="${ARGS_DEFINED_OPTIONS["$allFlag#valueType"]}"
      if String_isEmpty "$valueType"; then
        ARGS_OPTIONS["$allFlag"]=1
      else
        readingFlagValue=1
      fi
      unset ARGS_REQUIRED_OPTIONS["$allFlag"]
    else
      if ((readingFlagValue == 1)); then

        # check value type
        if String_match "$valueType" "^(<|\[)"; then
          if (String_match "$valueType" "^\[.+\]$" && ! String_match "$valueType" " $arg ") ||
            (String_match "$valueType" "<int" && ! String_match "$arg" "^-?([1-9][0-9]*|0)$") ||
            (String_match "$valueType" "<float" && ! String_match "$arg" "^-?([1-9][0-9]*|0)\.[0-9]+$") ||
            (String_match "$valueType" "<num" && ! String_match "$arg" "^-?([1-9][0-9]*|0)(\.[0-9]+)?$"); then
            echo "Error: flag [$singleFlag] expect a value of: $valueType" >&2
            return 1
          fi
        else
          $valueType "$arg" || return 1
        fi

        ARGS_OPTIONS["$allFlag"]="$arg"
        readingFlagValue=0
      else
        ARGS_INPUT+=("$arg")
      fi
    fi

  done

  if ((readingFlagValue == 1)); then
    echo "Error: flag [$singleFlag] expect a value" >&2
    return 1
  fi

  for key in "${!ARGS_REQUIRED_OPTIONS[@]}"; do
    echo "Error: flag [$key] is required" >&2
    return 1
  done
}

__validateDefineFlag__() {
  if ! String_match "$1" "^-[a-zA-Z_]$" && ! String_match "$1" "^--[0-9a-zA-Z_-]+$"; then
    echo "Error: invalid flag defined: [$1]" >&2
    return 1
  fi
}

__validateInputFlag__() {
  if ! String_match "$1" "^-[a-zA-Z_]+(=.*)?$" && ! String_match "$1" "^--[0-9a-zA-Z_-]+(=.*)?$"; then
    echo "Error: invalid flag input: [$1]" >&2
    return 1
  fi
}
