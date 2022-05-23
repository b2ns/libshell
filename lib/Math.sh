#!/usr/bin/env bash

# @desc get the absolute value of a number
# @param number <number>
# @return <number>

# example
# Math_abs -1
# # output: 1
# end
Math_abs() {
  if (($1 < 0)); then
    local -i num=$((0 - $1))
    RETVAL="$num"
    echo "$num"
  else
    RETVAL="$1"
    echo "$1"
  fi
}

# @desc get the maximum
# @param numbers <array>
# @return <number>

# example
# Math_max 1 2 3
# # output: 3
# end
Math_max() {
  local -i max="${1-}"
  local -i num=""
  for num in "$@"; do
    if ((num > max)); then
      max="$num"
    fi
  done
  RETVAL="$max"
  echo "$max"
}

# @desc get the minimum
# @param numbers <array>
# @return <number>

# example
# Math_min 1 2 3
# # output: 1
# end
Math_min() {
  local -i min="${1-}"
  local -i num=""
  for num in "$@"; do
    if ((num < min)); then
      min="$num"
    fi
  done
  RETVAL="$min"
  echo "$min"
}

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
