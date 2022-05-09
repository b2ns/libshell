#!/usr/bin/env bash

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
    echo "$min"
  else
    local -i random=$((RANDOM % range))
    echo $((min + random))
  fi
}

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
  echo "${res[@]}"
}
