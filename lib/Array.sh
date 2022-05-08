#!/usr/bin/env bash
import Math

declare -g COMPARATOR="${COMPARATOR:-__defaultComparator__}"

Array_every() {
  if (($# >= 2)); then
    local args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
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
    local args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      if ($fn "$item" "$i"); then
        res+=("$item")
      fi
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
    local args=("$@")
    local target="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
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
    local args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
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
    local args=("$@")
    local target="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
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

Array_join() {
  if (($# >= 3)); then
    local args=("$@")
    local delimiter="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local result=""
    local str=""
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
    printf '%s\n' "$1"
  fi
}

Array_length() {
  echo "$#"
}

Array_map() {
  if (($# >= 2)); then
    local args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local res=()
    local val=""
    local item=""
    for ((i = 0; i < len; i++)); do
      item="${args[$i]}"
      val=$($fn "$item" "$i")
      res+=("$val")
    done
    printf '%s\n' "${res[@]}"
  else
    printf '%s\n' "$1"
  fi
}

Array_reverse() {
  local -a res=()
  local len=$(($# - 1))
  for ((i = len; i > 0; i--)); do
    res+=("$i")
  done
  printf '%s\n' "${res[@]}"
}

Array_some() {
  if (($# >= 2)); then
    local args=("$@")
    local fn="${args[-1]}"
    unset "args[-1]"
    local len="${#args[@]}"
    local item=""
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
      local randP=""
      randP="$(Math_random "$L" "$R")"
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
