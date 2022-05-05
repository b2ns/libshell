#!/usr/bin/env bash
import Math

declare -g COMPARATOR="${COMPARATOR:-defaultComparator}"

function Array_concat() {
  printf '%s\n' "$@"
}

function Array_every() {
  if [[ $# -ge 2 ]]; then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      if ! ($fn "$item" "$index"); then
        return 1
      fi
      index=$((index + 1))
    done
    return 0
  else
    return 1
  fi
}

function Array_filter() {
  if [[ $# -ge 2 ]]; then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    local res=()
    for item in "${@:1:$len}"; do
      if ($fn "$item" "$index"); then
        res+=("$item")
      fi
      index=$((index + 1))
    done
    printf '%s\n' "${res[@]}"
  else
    echo "$1"
  fi
}

function Array_find() {
  Array_findIndex "$@"
}

function Array_findIndex() {
  if [[ $# -ge 2 ]]; then
    local target=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      if [[ "$item" =~ $target ]]; then
        echo "$index"
        return 0
      fi
      index=$((index + 1))
    done
    echo -1
    return 1
  else
    echo -1
    return 1
  fi
}

function Array_forEach() {
  if [[ $# -ge 2 ]]; then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      ($fn "$item" "$index")
      index=$((index + 1))
    done
  fi
}

function Array_includes() {
  Array_indexOf "$@"
}

function Array_indexOf() {
  if [[ $# -ge 2 ]]; then
    local target=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      if [[ "$target" == "$item" ]]; then
        echo "$index"
        return 0
      fi
      index=$((index + 1))
    done
    echo -1
    return 1
  else
    echo -1
    return 1
  fi
}

function Array_join() {
  if [[ $# -ge 3 ]]; then
    local delimiter=$(Array_last "$@")
    local len=$(($# - 1))
    local res
    for str in "${@:1:$len}"; do
      if [[ -z "$res" ]]; then
        res="$str"
      else
        res="$res$delimiter$str"
      fi
    done
    echo "$res"
  else
    echo "$@"
  fi
}

function Array_last() {
  echo "${@: -1:1}"
}

function Array_length() {
  echo "$#"
}

function Array_map() {
  if [[ $# -ge 2 ]]; then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    local res=()
    local val=""
    for item in "${@:1:$len}"; do
      val=$($fn "$item" "$index")
      res+=("$val")
      index=$((index + 1))
    done
    printf '%s\n' "${res[@]}"
  else
    echo "$1"
  fi
}

function Array_push() {
  Array_concat "$@"
}

function Array_reverse() {
  local -a res=()
  local len=$(($# - 1))
  for ((i = len; i > 0; i--)); do
    res+=("$i")
  done
  printf '%s\n' "${res[@]}"
}

function Array_slice() {
  if [[ $# -ge 3 ]]; then
    local endIndx=$(Array_last "$@")
    local startIndex="${@:-2:1}"
    printf '%s\n' "${@:$startIndex:"$((endIndx - startIndex))"}"
  else
    printf '%s\n' "$@"
  fi
}

function Array_some() {
  if [[ $# -ge 2 ]]; then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      if ($fn "$item" "$index"); then
        return 0
      fi
      index=$((index + 1))
    done
    return 1
  else
    return 1
  fi
}

function Array_sort() {
  if [[ $# -ge 2 ]]; then
    local -a arr=("$@")
    local arrLen="$#"
    local smallArraySize=7

    function process() {
      local L="$1"
      local R="$2"

      # use insertSort for small arrays
      local size=$((R - L + 1))
      if [[ "$size" -le "$smallArraySize" ]]; then
        local i=0
        local j=0
        local tmp=""
        local cmp=""
        for ((i = L; i <= R; i++)); do
          tmp="${arr[i]}"
          for ((j = $((i - 1)); j >= 0; j--)); do
            cmp=$($COMPARATOR "${arr[j]}" "$tmp")
            if [[ $cmp -gt 0 ]]; then
              arr[$((j + 1))]="${arr[j]}"
            else
              break
            fi
          done
          arr[$((j + 1))]="$tmp"
        done
        return 0
      fi

      # random pivot
      local randP="$(Math_random "$L" "$R")"
      local tmp="${arr["$R"]}"
      arr["$R"]="${arr["$randP"]}"
      arr["$randP"]="$tmp"

      # partition
      local i="$L"
      local less=$((L - 1))
      local more="$R"
      local tmp=""
      local cmp=""

      while [[ "$i" -lt "$more" ]]; do
        cmp=$($COMPARATOR "${arr["$i"]}" "${arr["$R"]}")
        if [[ $cmp -gt 0 ]]; then
          more=$((more - 1))
          tmp="${arr["$more"]}"
          arr["$more"]="${arr["$i"]}"
          arr["$i"]="$tmp"
        elif [[ $cmp -lt 0 ]]; then
          less=$((less + 1))
          tmp="${arr["$less"]}"
          arr["$less"]="${arr["$i"]}"
          arr["$i"]="$tmp"
          i=$((i + 1))
        else
          i=$((i + 1))
        fi
      done

      tmp="${arr["$more"]}"
      arr["$more"]="${arr["$R"]}"
      arr["$R"]="$tmp"

      # recurse
      process "$L" "$less"
      process $((more + 1)) "$R"
    }

    process 0 $((arrLen - 1))

    printf '%s\n' "${arr[@]}"
  else
    echo "$@"
  fi
}

function defaultComparator() {
  if [[ "$1" -gt "$2" ]]; then
    echo 1
  elif [[ "$1" -lt "$2" ]]; then
    echo -1
  else
    echo 0
  fi
}

function Array_sub() {
  if [[ $# -ge 3 ]]; then
    local subLen=$(Array_last "$@")
    local startIndex="${@:-2:1}"
    printf '%s\n' "${@:$startIndex:"$subLen"}"
  else
    printf '%s\n' "$@"
  fi
}
