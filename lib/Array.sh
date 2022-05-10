#!/usr/bin/env bash
# shellcheck disable=SC2178,SC2128
import Math

declare -g LIBSHELL_COMPARATOR="${LIBSHELL_COMPARATOR:-__defaultComparator__}"

Array_every() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if ! ($fn "$item" "$i"); then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}

Array_filter() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if ($fn "$item" "$i"); then
        res+=("$item")
      fi
    done
    RETVAL=("${res[@]}")
    printf '%s\n' "${res[@]}"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

Array_find() {
  Array_findIndex "$@"
}

Array_findIndex() {
  RETVAL=-1
  if (($# >= 2)); then
    local -a args=("$@")
    local target="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if [[ "$item" =~ $target ]]; then
        RETVAL="$i"
        echo "$i"
        return 0
      fi
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
    local -a args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      ($fn "$item" "$i")
    done
  fi
}

Array_includes() {
  Array_indexOf "$@"
}

Array_indexOf() {
  RETVAL=-1
  if (($# >= 2)); then
    local -a args=("$@")
    local target="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if [[ "$target" == "$item" ]]; then
        RETVAL="$i"
        echo "$i"
        return 0
      fi
    done
    echo -1
    return 1
  else
    echo -1
    return 1
  fi
}

Array_isEmpty() {
  ((${#@} == 0))
}

Array_notEmpty() {
  ! Array_isEmpty "$@"
}

Array_join() {
  if (($# >= 3)); then
    local -a args=("$@")
    local delimiter="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local result=""
    local str=""
    local -i i
    for ((i = 0; i < len; i++)); do
      str="${args[$i]}"
      if ((i == 0)); then
        result="$str"
      else
        result="$result$delimiter$str"
      fi
    done
    RETVAL="$result"
    printf '%s\n' "$result"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

Array_length() {
  local -i len="$#"
  RETVAL="$len"
  echo "$len"
}

Array_map() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local -a res=()
    local val=""
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      RETVAL="__reset_retval__"
      $fn "$item" "$i" >/dev/null
      # check if fn use the RETVAL to return value
      if [[ "$RETVAL" != "__reset_retval__" ]]; then
        val="$RETVAL"
      else
        val="$($fn "$item" "$i")"
      fi
      res+=("$val")
    done
    RETVAL=("${res[@]}")
    printf '%s\n' "${res[@]}"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

Array_random() {
  local -a res=()
  local -i size="${1:-10}"
  local -i min="${2:-0}"
  local -i max="${3:-100}"
  local -i i
  for ((i = 0; i < size; i++)); do
    Math_random "$min" "$max" >/dev/null
    res+=("$RETVAL")
  done
  RETVAL=("${res[@]}")
  printf '%s\n' "${res[@]}"
}

Array_reverse() {
  local -a arr=("$@")
  local -i i=0
  local -i j=$(($# - 1))
  while ((i < j)); do
    local tmp="${arr[$i]}"
    arr[$i]="${arr[$j]}"
    arr[$j]="$tmp"
    ((i++, j--))
  done
  RETVAL=("${arr[@]}")
  printf '%s\n' "${arr[@]}"
}

Array_some() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local -i len="${#args[@]}"
    local item=""
    local -i i
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if ($fn "$item" "$i"); then
        return 0
      fi
    done
    return 1
  else
    return 1
  fi
}

Array_sort() {
  if (($# >= 2)); then
    local -a arr=("$@")
    local -i arrLen="$#"
    local -i smallArraySize=7

    process() {
      local -i L="$1"
      local -i R="$2"

      # use insertSort for small arrays
      local -i size=$((R - L + 1))
      if ((size <= smallArraySize)); then
        local -i i=0
        local -i j=0
        local tmp=""
        local -i i
        for ((i = L; i <= R; i++)); do
          tmp="${arr[i]}"
          local -i j
          for ((j = $((i - 1)); j >= 0; j--)); do
            if $LIBSHELL_COMPARATOR "${arr[j]}" ">" "$tmp"; then
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
      local -i randP=""
      Math_random "$L" "$R" >/dev/null
      randP="$RETVAL"
      local tmp="${arr["$R"]}"
      arr["$R"]="${arr["$randP"]}"
      arr["$randP"]="$tmp"

      # partition
      local -i i="$L"
      local -i less=$((L - 1))
      local -i more="$R"
      local tmp=""

      while ((i < more)); do

        if $LIBSHELL_COMPARATOR "${arr["$i"]}" ">" "${arr["$R"]}"; then
          more=$((more - 1))
          tmp="${arr["$more"]}"
          arr["$more"]="${arr["$i"]}"
          arr["$i"]="$tmp"
        elif $LIBSHELL_COMPARATOR "${arr["$i"]}" "<" "${arr["$R"]}"; then
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

    RETVAL=("${arr[@]}")
    printf '%s\n' "${arr[@]}"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

__defaultComparator__() {
  local a="$1"
  local op="$2"
  local b="$3"
  if [[ "$op" == ">" ]]; then
    ((a > b))
  elif [[ "$op" == "<" ]]; then
    ((a < b))
  else
    ((a == b))
  fi
}
