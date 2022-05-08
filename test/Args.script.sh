#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/../libshell"

checkEqualCustom() {
  if [ "$1" != "custom" ]; then
    echo "Expected 'custom', got '$1'"
    return 1
  fi
}

# define args accpected
Args_define "-r --readonly" "Readonly"
Args_define "-o --output" "Output" "<any>"
Args_define "-j --job" "Running jobs" "<int>" 2
Args_define "--te" "Truncation error" "<float>" 0.00001
Args_define "-l --level" "Level of parse" "<num>" 3
Args_define "-f --format" "Output format" "[json yaml toml xml csv]" "json"
Args_define "-p --pwd" "Password is required" "<any>!"
Args_define "-c --custom" "Custom" checkEqualCustom
Args_define "-v -V --version" "Show version"
Args_define "-h --help" "Show help"
Args_define "--show-input-file"

# parse args
Args_parse "$@"

# deal with args
if Args_has "-r"; then
  echo "Readonly"
fi

if Args_has "--output"; then
  declare output="$(Args_get "-o")"
  echo "Output: ${output}"
fi

if (($(Args_get "-j") >= 8)); then
  echo "Too many jobs"
fi

if Args_has "-v"; then
  echo "Version: 1.0.0"
fi

if Args_has "-h"; then
  Args_help
fi

if Args_has "--show-input-file"; then
  readarray -t inputFiles <<<"$(Args_getInput)"
  echo Input files: "${inputFiles[@]}"
fi
