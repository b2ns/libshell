#!/usr/bin/env bash

function Math_random() {
  local min="${1:-0}"
  local max="${2:-100}"
  if [[ "$min" -gt "$max" ]]; then
    local tmp="$min"
    min="$max"
    max="$tmp"
  fi
  local range=$((max - min))
  if [[ "$range" -eq 0 ]]; then
    echo "$min"
  else
    local random=$((RANDOM % range))
    echo $((min + random))
  fi
}
