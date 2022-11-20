#!/usr/bin/env bash
# shellcheck disable=SC2128

import String
import IO
import Array

declare -gA LIBSHELL_ARGS_DEFINED_OPTIONS=()
declare -gA LIBSHELL_ARGS_REQUIRED_OPTIONS=()
declare -gA LIBSHELL_ARGS_OPTIONS=()
declare -ga LIBSHELL_ARGS_INPUT=()
declare -gi LIBSHELL_ARGS_HAS_PARSED=0

# @desc define command arguments options
# @param argName <string> - e.g.; "-h --help"
# @param desc <string> - description of the argument
# @param argType <string> - type of the argument. must be one of <any> | <int> | <float> | <number> | [choice1 choice2 ...]. use a suffix ! (i.e.; <any>!) to indicate the argument is required. can also define a custom type check function here.
# @param defaultValue <any> - default value of the argument

# @example
# Args_define "-r --readonly" "Readonly"
# Args_define "-o --output" "Output" "<any>"
# Args_define "-j --job" "Running jobs" "<int>" 2
# Args_define "--te" "Truncation error" "<float>" 0.00001
# Args_define "-f --format" "Output format" "[json yaml toml xml csv]" "json"
# Args_define "-p --pwd" "Password is required" "<any>!"

# checkEqualCustom() {
# if [[ "$1" != "custom" ]]; then
# echo "Expected 'custom', got '$1'"
# return 1
# fi
# }
# Args_define "-c --custom" "Custom" checkEqualCustom
# # or use a string as lambda function
# # Args_define "-c --custom" "Custom" '[[ "$1" != "custom" ]] && echo "Expected custom, got $1";return 1'

# Args_define "-v -V --version" "Show version"
# Args_define "-h --help" "Show help"
# @end
Args_define() {
  if ((LIBSHELL_ARGS_HAS_PARSED)); then
    IO_error "Error: can't define options after calling Args_parse" >&2
    return 1
  fi

  (($# == 0)) && return 0

  local allFlag="$1"
  String_split "$allFlag" " " >/dev/null
  local -a flags=("${RETVAL[@]}")

  local desc="${2-}"
  local valueType="${3-}"
  local defaultValue="${4-}"

  local singleFlag=""
  for singleFlag in "${flags[@]}"; do
    # check invalid flag
    __validateDefineFlag__ "$singleFlag" || return 1

    # check duplicate flag
    if __argsDefined__ "$singleFlag" 2>/dev/null; then
      IO_error "Error: duplicate flag defined: [$singleFlag]" >&2
      return 1
    fi

    LIBSHELL_ARGS_DEFINED_OPTIONS[$singleFlag]="$allFlag"
  done

  LIBSHELL_ARGS_DEFINED_OPTIONS["${allFlag}#desc"]="$desc"

  if String_match "$valueType" ">!+$"; then
    String_stripEnd "$valueType" "!*" 1 >/dev/null
    valueType="$RETVAL"

    LIBSHELL_ARGS_REQUIRED_OPTIONS[$allFlag]=1
  fi

  LIBSHELL_ARGS_DEFINED_OPTIONS["${allFlag}#valueType"]="$valueType"

  LIBSHELL_ARGS_DEFINED_OPTIONS["${allFlag}#defaultValue"]="$defaultValue"

  # set default value
  LIBSHELL_ARGS_OPTIONS[$allFlag]="$defaultValue"
}

# @desc get command arguments value passed in
# @param argName <string> e.g.; "-j" or "--job"
# @return <any> value passed in

# @example
# Args_get "-j"
# # equivalent
# Args_get "--job"
# @end
Args_get() {
  __warnParsingArgs__ || return 1
  __argsDefined__ "$1" || return 1

  local allFlag="${LIBSHELL_ARGS_DEFINED_OPTIONS[$1]}"
  local value="${LIBSHELL_ARGS_OPTIONS[$allFlag]}"

  RETVAL="$value"
  printf '%s\n' "$value"
}

# @desc get all input text other than command arguments value
# @return <array>

# @example
# # pass arguments to the ./script.sh
# ./script.sh -f toml ./file1 ../file2 path/to/file3
# ######################
# # then get the files to process
# Args_getInput
# # output: "./file1 ../file2 path/to/file3"
# @end
Args_getInput() {
  __warnParsingArgs__ || return 1
  RETVAL=("${LIBSHELL_ARGS_INPUT[@]}")
  printf '%s\n' "${LIBSHELL_ARGS_INPUT[@]}"
}

# @desc check if command argument is passed
# @param argName <string> e.g.; "-j" or "--job"

# @example
# Args_has "-j"
# # equivalent
# Args_has "--job"
# @end

Args_has() {
  local value=""

  Args_get "$1" >/dev/null || return 1
  value="$RETVAL"

  String_notEmpty "$value"
}

# @desc show help info based on what you have defined
# @param insertBefore <string> insert text before this help info
# @param insertAfter <string> insert text after this help info

# @example
# Args_help
# Args_help "Usage: foo [options]" "more info here..."
# @end
Args_help() {
  local headInfo=${1:-}
  local tailInfo=${2:-}
  local scriptName=""

  String_stripStart "$0" "*/" 1 >/dev/null
  scriptName="$RETVAL"

  echo

  String_notEmpty "$scriptName" && printf '%s\n' "$scriptName"

  String_notEmpty "$headInfo" && printf '%s\n' "$headInfo"

  echo

  # get max padding length
  local -i paddingLen=0
  local -a keys=()
  local key=""
  for key in "${!LIBSHELL_ARGS_OPTIONS[@]}"; do
    keys+=("$key")

    local -i len="${#key}"

    ((len > paddingLen)) && paddingLen="$len"
  done

  # sort keys
  sortMethod() {
    local a="$1"
    local op="$2"
    local b="$3"
    if [[ "$op" == ">" ]]; then
      [[ "$a" > "$b" ]]
    elif [[ "$op" == "<" ]]; then
      [[ "$a" < "$b" ]]
    else
      [[ "$a" == "$b" ]]
    fi
  }
  Array_sort keys sortMethod >/dev/null

  local key=""
  for key in "${keys[@]}"; do
    local msg=""
    String_padEnd "$key" "$paddingLen" >/dev/null
    msg="$RETVAL"

    local desc="${LIBSHELL_ARGS_DEFINED_OPTIONS["$key#desc"]}"
    local valueType="${LIBSHELL_ARGS_DEFINED_OPTIONS["$key#valueType"]}"
    local defaultValue="${LIBSHELL_ARGS_DEFINED_OPTIONS["$key#defaultValue"]}"
    String_notEmpty "$desc" && msg="$msg - $desc"
    String_notEmpty "$valueType" && msg="$msg ($valueType)"
    String_notEmpty "$defaultValue" && msg="$msg (default: $defaultValue)"
    printf '  %s\n' "$msg"
  done

  String_notEmpty "$tailInfo" && printf '%s\n' "$tailInfo"

  echo
}

# @desc parse command arguments
# @param argv <array> command arguments

# @example
# #must be called after Args_define()
# Args_parse "$@"
# @end
Args_parse() {
  local -a args=("$@")
  local singleFlag=""
  local allFlag=""
  local valueType=""
  local -i readingFlagValue=0
  local -i escapeFlag=0

  # unify args
  # --format=json -> --format json
  # -cvf -> -c -v -f
  # -cvf=json -> -c -v -f json
  local -a unifiedArgs=()
  local -i i
  for ((i = 0; i < "${#args[@]}"; i++)); do
    local arg="${args[$i]}"

    # use '--' to prevserve args
    if String_eq "$arg" "--"; then
      escapeFlag=1
      unifiedArgs+=("$arg")
      continue
    fi
    if ((escapeFlag)); then
      escapeFlag=0
      unifiedArgs+=("$arg")
      continue
    fi

    if __validateInputFlag__ "$arg" 2>/dev/null; then
      if String_match "$arg" "^--[^=]+=.*$"; then
        local flag=""
        String_stripEnd "$arg" "=*" 1 >/dev/null
        flag="$RETVAL"

        local value=""
        String_stripStart "$arg" "*=" >/dev/null
        value="$RETVAL"

        unifiedArgs+=("$flag")
        unifiedArgs+=("$value")
      elif String_match "$arg" "^-[^-].+$"; then
        local value=""
        local num=""

        String_stripStart "$arg" "-" >/dev/null
        arg="$RETVAL"

        if String_includes "$arg" "="; then
          String_stripStart "$arg" "*=" >/dev/null
          value="$RETVAL"

          String_stripEnd "$arg" "=*" 1 >/dev/null
          arg="$RETVAL"
        elif String_match "$arg" "[0-9]$"; then
          String_stripStart "$arg" "*[^.0-9-]" 1 >/dev/null
          num="$RETVAL"

          String_stripEnd "$arg" "[.0-9-]*" 1 >/dev/null
          arg="$RETVAL"
        fi

        local -a flags=()
        String_split "$arg" "" >/dev/null
        flags=("${RETVAL[@]}")

        local singleFlag=""
        for singleFlag in "${flags[@]}"; do
          unifiedArgs+=("-$singleFlag")
        done

        String_notEmpty "$value" && unifiedArgs+=("$value")
        String_notEmpty "$num" && unifiedArgs+=("$num")
      else
        unifiedArgs+=("$arg")
      fi
    else
      unifiedArgs+=("$arg")
    fi
  done

  # must reset it to
  escapeFlag=0

  local -i i
  for ((i = 0; i < "${#unifiedArgs[@]}"; i++)); do
    local arg="${unifiedArgs[$i]}"

    # while filename start with '-', use '--' to solve it
    if String_eq "$arg" "--"; then
      escapeFlag=1
      continue
    fi
    if ((escapeFlag)); then
      LIBSHELL_ARGS_INPUT+=("$arg")
      escapeFlag=0
      continue
    fi

    if __validateDefineFlag__ "$arg" 2>/dev/null; then
      if ((readingFlagValue)); then
        IO_error "Error: flag [$singleFlag] expect a value" >&2
        return 1
      fi

      singleFlag="$arg"
      if ! __argsDefined__ "$singleFlag"; then
        return 1
      fi

      allFlag="${LIBSHELL_ARGS_DEFINED_OPTIONS[$singleFlag]}"
      valueType="${LIBSHELL_ARGS_DEFINED_OPTIONS["$allFlag#valueType"]}"
      if String_isEmpty "$valueType"; then
        LIBSHELL_ARGS_OPTIONS["$allFlag"]=1
      else
        readingFlagValue=1
      fi

      unset 'LIBSHELL_ARGS_REQUIRED_OPTIONS[$allFlag]'
    else
      if ((readingFlagValue)); then

        # check value type
        if ! String_match "$valueType" "^\[( |\[)" && String_match "$valueType" "^(<|\[)"; then
          if (String_match "$valueType" "^\[.+\]$" && (String_isEmpty "$arg" || ! String_match "$valueType" "(\[| )$arg( |\])")) ||
            (String_match "$valueType" "<int" && ! String_match "$arg" "^-?([1-9][0-9]*|0)$") ||
            (String_match "$valueType" "<float" && ! String_match "$arg" "^-?([1-9][0-9]*|0)\.[0-9]+$") ||
            (String_match "$valueType" "<num" && ! String_match "$arg" "^-?([1-9][0-9]*|0)(\.[0-9]+)?$"); then
            IO_error "Error: flag [$singleFlag] expect a value of: $valueType" >&2
            return 1
          fi
        else
          __argsLambdaFunc__ "$valueType"
          valueType="$RETVAL"
          $valueType "$arg" || return 1
        fi

        LIBSHELL_ARGS_OPTIONS["$allFlag"]="$arg"
        readingFlagValue=0
      else
        LIBSHELL_ARGS_INPUT+=("$arg")
      fi
    fi

  done

  if ((readingFlagValue)); then
    IO_error "Error: flag [$singleFlag] expect a value" >&2
    return 1
  fi

  local key=""
  for key in "${!LIBSHELL_ARGS_REQUIRED_OPTIONS[@]}"; do
    IO_error "Error: flag [$key] is required" >&2
    return 1
  done

  LIBSHELL_ARGS_HAS_PARSED=1
}

__argsDefined__() {
  if [[ ${LIBSHELL_ARGS_DEFINED_OPTIONS[$1]+_} ]]; then
    return 0
  else
    IO_error "Error: flag [$1] not defined" >&2
    return 1
  fi
}

__validateDefineFlag__() {
  if String_match "$1" "^-[a-zA-Z_]$" || String_match "$1" "^--[0-9a-zA-Z_-]+$"; then
    :
  else
    IO_error "Error: invalid flag defined: [$1]" >&2
    return 1
  fi
}

__validateInputFlag__() {
  if String_match "$1" "^-[a-zA-Z_]+(=.*)?$" ||
    String_match "$1" "^-[a-zA-Z_]+(-?([1-9][0-9]*|0)(\.[0-9]+)?)?$" ||
    String_match "$1" "^--[0-9a-zA-Z_-]+(=.*)?$"; then
    :
  else
    IO_error "Error: invalid flag input: [$1]" >&2
    return 1
  fi
}

__warnParsingArgs__() {
  if ((LIBSHELL_ARGS_HAS_PARSED == 0)); then
    IO_error "Error: call Args_parse to parse the arguments first" >&2
    return 1
  fi
}

__argsLambdaFunc__() {
  # shellcheck disable=SC2178
  RETVAL="$1"
  if ! type -t "$1" &>/dev/null; then
    eval '___args_lambda_func___() {
      '"$1"'
    }'
    # shellcheck disable=SC2178
    RETVAL="___args_lambda_func___"
  fi
}
