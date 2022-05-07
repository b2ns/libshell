#!/usr/bin/env bash

import String

declare -gA ARGS_DEFINED_OPTIONS=()
declare -gA ARGS_OPTIONS=()
declare -ga ARGS_INPUT=()

function Args_define() {
  (($# == 0)) && return 0

  local allFlag="$1"
  readarray -t flags <<<"$(String_split "$1" " ")"
  local desc="${2-}"
  local valueType="${3-}"
  local defaultValue="${4-}"

  for singleFlag in "${flags[@]}"; do
    ARGS_DEFINED_OPTIONS[$singleFlag]="$allFlag"
  done
  ARGS_DEFINED_OPTIONS["${allFlag}#desc"]="$desc"
  ARGS_DEFINED_OPTIONS["${allFlag}#valueType"]="$valueType"
  if String_isNotEmpty "$defaultValue" && String_isEmpty "$valueType"; then
    ARGS_DEFINED_OPTIONS["${allFlag}#valueType"]="any"
  fi
  ARGS_DEFINED_OPTIONS["${allFlag}#defaultValue"]="$defaultValue"

  # set default value
  ARGS_OPTIONS[$allFlag]="$defaultValue"
}

function Args_defined() {
  if [[ ${ARGS_DEFINED_OPTIONS[$1]+_} ]]; then
    return 0
  else
    echo "Error: flag [$1] not defined" >&2
    return 1
  fi
}

function Args_get() {
  if Args_defined "$1"; then
    local allFlag="${ARGS_DEFINED_OPTIONS[$1]}"
    printf '%s\n' "${ARGS_OPTIONS[$allFlag]}"
  else
    return 1
  fi
}

function Args_getInput() {
  printf '%s\n' "${ARGS_INPUT[@]}"
}

function Args_has() {
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

function Args_help() {
  local headInfo=${1:-}
  local tailInfo=${2:-}
  local scriptName="$(String_trimStart "$0" "*/" 1)"
  # local scriptName="${0}"

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

function Args_parse() {
  local args=("$@")
  local singleFlag=""
  local allFlag=""
  local valueType=""
  local readingFlagValue=0

  # unify args
  # --format=json -> --format json
  local -a unifiedArgs=()
  for ((i = 0; i < "${#args[@]}"; i++)); do
    local arg="${args[$i]}"
    if String_match "$arg" "^--?[^=]+=.*"; then
      local flag="$(String_trimEnd "$arg" "=*" 1)"
      local value="$(String_trimStart "$arg" "*=")"
      unifiedArgs+=("$flag")
      unifiedArgs+=("$value")
    else
      unifiedArgs+=("$arg")
    fi
  done

  for ((i = 0; i < "${#unifiedArgs[@]}"; i++)); do
    local arg="${unifiedArgs[$i]}"

    if String_match "$arg" "^--?[^0-9]"; then
      if ((readingFlagValue == 1)); then
        echo "Error: flag [$singleFlag] expect a value of: $valueType" >&2
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
    else
      if ((readingFlagValue == 1)); then

        # check value type
        if (String_match "$valueType" "^\[.+\]$" && ! String_match "$valueType" " $arg ") ||
          (String_match "$valueType" "<int" && ! String_match "$arg" "^-?([1-9][0-9]*|0)$") ||
          (String_match "$valueType" "<float" && ! String_match "$arg" "^-?([1-9][0-9]*|0)\.[0-9]+$") ||
          (String_match "$valueType" "<num" && ! String_match "$arg" "^-?([1-9][0-9]*|0)(\.[0-9]+)?$"); then
          echo "Error: flag [$singleFlag] expect a value of: $valueType" >&2
          return 1
        fi

        ARGS_OPTIONS["$allFlag"]="$arg"
        readingFlagValue=0
      else
        ARGS_INPUT+=("$arg")
      fi
    fi

  done

  if ((readingFlagValue == 1)); then
    echo "Error: flag [$singleFlag] expect a value of: $valueType" >&2
    return 1
  fi
}
