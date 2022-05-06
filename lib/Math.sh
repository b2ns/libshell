#!/usr/bin/env bash

function Math_random() {
  local min="${1:-0}"
  local max="${2:-100}"
  if ((min > max)); then
    local tmp="$min"
    min="$max"
    max="$tmp"
  fi
  local range=$((max - min))
  if ((range == 0)); then
    echo "$min"
  else
    local random=$((RANDOM % range))
    echo $((min + random))
  fi
}

function Math_range() {
  local min="${1:-0}"
  local max="${2:-100}"
  local step="${3:-1}"
  if ((min > max)); then
    local tmp="$min"
    min="$max"
    max="$tmp"
  fi
  local -a res=()
  for ((i = min; i <= max; i += step)); do
    res+=("$i")
  done
  echo "${res[@]}"
}
