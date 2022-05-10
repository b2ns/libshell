#!/usr/bin/env bash
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
    printf '%s\n' "${res[@]}"
  else
    echo "$@"
  fi
}

Array_find() {
  Array_findIndex "$@"
}

Array_findIndex() {
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
    printf '%s\n' "$result"
  else
    printf '%s\n' "${1:-}"
  fi
}

Array_length() {
  echo "$#"
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
      val=$($fn "$item" "$i")
      res+=("$val")
    done
    printf '%s\n' "${res[@]}"
  else
    printf '%s\n' "$@"
  fi
}

Array_random() {
  local -a res=()
  local -i size="${1:-10}"
  local -i min="${2:-0}"
  local -i max="${3:-100}"
  local -i i
  for ((i = 0; i < size; i++)); do
    res+=("$(Math_random "$min" "$max")")
  done
  printf "%s\n" "${res[@]}"
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
        local -i cmp=""
        local -i i
        for ((i = L; i <= R; i++)); do
          tmp="${arr[i]}"
          local -i j
          for ((j = $((i - 1)); j >= 0; j--)); do
            cmp=$($LIBSHELL_COMPARATOR "${arr[j]}" "$tmp")
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
      local -i randP=""
      randP="$(Math_random "$L" "$R")"
      local tmp="${arr["$R"]}"
      arr["$R"]="${arr["$randP"]}"
      arr["$randP"]="$tmp"

      # partition
      local -i i="$L"
      local -i less=$((L - 1))
      local -i more="$R"
      local tmp=""
      local -i cmp=""

      while ((i < more)); do
        cmp=$($LIBSHELL_COMPARATOR "${arr["$i"]}" "${arr["$R"]}")
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
