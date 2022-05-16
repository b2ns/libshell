#!/usr/bin/env bash

# @desc generate a random number
# @param min <number> (default 0)
# @param max <number> (default 100)
# @return <number> a random integer between [min, max)

# @example
# Math_random 1 10
# Math_random -10 10
# @end
Math_random() {
  local -i min="${1:-0}"
  local -i max="${2:-100}"
  if ((min > max)); then
    local -i tmp="$min"
    min="$max"
    max="$tmp"
  fi
  local -i range=$((max - min))
  if ((range == 0)); then
    RETVAL="$min"
    echo "$min"
  else
    local -i random=$((RANDOM % range))
    local -i res=$((min + random))
    RETVAL="$res"
    echo "$res"
  fi
}

# @desc generate a sequence of numbers
# @param min <number> (default 0)
# @param max <number> (default 100)
# @param step <number> (default 1)
# @return <array>

# @example
# Math_range 1 10
# # output: 1 2 3 4 5 6 7 8 9 10
# Math_random -10 10 3
# # output: -10 -7 -4 1 4 7 10
# @end
Math_range() {
  local -i min="${1:-0}"
  local -i max="${2:-100}"
  local -i step="${3:-1}"
  if ((min > max)); then
    local -i tmp="$min"
    min="$max"
    max="$tmp"
  fi
  local -a res=()
  local -i i
  for ((i = min; i <= max; i += step)); do
    res+=("$i")
  done
  # shellcheck disable=SC2034
  RETVAL=("${res[@]}")
  echo "${res[@]}"
}
