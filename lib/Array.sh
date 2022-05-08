#!/usr/bin/env bash
import Math

declare -g COMPARATOR="${COMPARATOR:-__defaultComparator__}"

Array_concat() {
  printf '%s\n' "$@"
}

Array_every() {
  if (($# >= 2)); then
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

Array_filter() {
  if (($# >= 2)); then
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

Array_find() {
  Array_findIndex "$@"
}

Array_findIndex() {
  if (($# >= 2)); then
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

Array_forEach() {
  if (($# >= 2)); then
    local fn=$(Array_last "$@")
    local len=$(($# - 1))
    local index=0
    for item in "${@:1:$len}"; do
      ($fn "$item" "$index")
      index=$((index + 1))
    done
  fi
}

Array_includes() {
  Array_indexOf "$@"
}

Array_indexOf() {
  if (($# >= 2)); then
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

Array_join() {
  if (($# >= 3)); then
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
    printf '%s\n' "$res"
  else
    printf '%s\n' "$@"
  fi
}

Array_last() {
  printf '%s\n' "${@: -1:1}"
}

Array_length() {
  echo "$#"
}

Array_map() {
  if (($# >= 2)); then
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
    printf '%s\n' "$1"
  fi
}

Array_push() {
  Array_concat "$@"
}

Array_reverse() {
  local -a res=()
  local len=$(($# - 1))
  for ((i = len; i > 0; i--)); do
    res+=("$i")
  done
  printf '%s\n' "${res[@]}"
}

Array_slice() {
  if (($# >= 3)); then
    local endIndx=$(Array_last "$@")
    local startIndex="${@:-2:1}"
    printf '%s\n' "${@:$startIndex:"$((endIndx - startIndex))"}"
  else
    printf '%s\n' "$@"
  fi
}

Array_some() {
  if (($# >= 2)); then
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

Array_sort() {
  if (($# >= 2)); then
    local -a arr=("$@")
    local arrLen="$#"
    local smallArraySize=7

    process() {
      local L="$1"
      local R="$2"

      # use insertSort for small arrays
      local size=$((R - L + 1))
      if ((size <= smallArraySize)); then
        local i=0
        local j=0
        local tmp=""
        local cmp=""
        for ((i = L; i <= R; i++)); do
          tmp="${arr[i]}"
          for ((j = $((i - 1)); j >= 0; j--)); do
            cmp=$($COMPARATOR "${arr[j]}" "$tmp")
            if ((cmp > 0)); then
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

      while ((i < more)); do
        cmp=$($COMPARATOR "${arr["$i"]}" "${arr["$R"]}")
        if ((cmp > 0)); then
          more=$((more - 1))
          tmp="${arr["$more"]}"
          arr["$more"]="${arr["$i"]}"
          arr["$i"]="$tmp"
        elif ((cmp < 0)); then
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
    printf '%s\n' "$@"
  fi
}

__defaultComparator__() {
  if (($1 > $2)); then
    echo 1
  elif (($1 < $2)); then
    echo -1
  else
    echo 0
  fi
}

Array_sub() {
  if (($# >= 3)); then
    local subLen=$(Array_last "$@")
    local startIndex="${@:-2:1}"
    printf '%s\n' "${@:$startIndex:"$subLen"}"
  else
    printf '%s\n' "$@"
  fi
}
