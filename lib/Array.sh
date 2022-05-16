#!/usr/bin/env bash
# shellcheck disable=SC2178,SC2128
import Math
import String

declare -g LIBSHELL_COMPARATOR="${LIBSHELL_COMPARATOR:-__defaultComparator__}"

# @desc check if all elements in array meets the condition
# @param array <array>
# @param condition <function>

# @example
# gt5() {
#   (($1 > 5)) && return 0
#   return 1
# }
#
# arr=(6 7 8)
# Array_every "${arr[@]}" gt5
# # assert success
#
# arr=(6 5 8)
# Array_every "${arr[@]}" gt5
# # assert failure
# @end
Array_every() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[$# - 1]}"
    unset "args[$# - 1]"
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

# @desc filter the array by condition
# @param array <array>
# @param condition <function>

# @example
# gt5() {
#   (($1 > 5)) && return 0
#   return 1
# }
#
# arr=(6 1 8)
# Array_filter "${arr[@]}" gt5
# # output: 6 8
# @end
Array_filter() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[$# - 1]}"
    unset "args[$# - 1]"
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
    RETVAL=("${1:-}")
    printf '%s\n' "${1:-}"
  fi
}

# @desc check if array has element match the regexp
# @param array <array>
# @param regexp <regexp>

# @example
# arr=("foo" "bar111" "baz")
# Array_find "${arr[@]}" "[a-z]+[0-9]+"
# # assert success
#
# arr=("foo" "bar" "baz")
# Array_find "${arr[@]}" "[a-z]+[0-9]+"
# # assert failure
# @end
Array_find() {
  Array_findIndex "$@"
}

# @desc return the index of the first element match the regexp
# @param array <array>
# @param regexp <regexp>
# @return index <int> or -1 when not found

# @example
# arr=("foo" "bar111" "baz")
# Array_find "${arr[@]}" "[a-z]+[0-9]+"
# # output: 1
#
# arr=("foo" "bar" "baz")
# Array_find "${arr[@]}" "[a-z]+[0-9]+"
# output: -1
# @end
Array_findIndex() {
  RETVAL=-1
  if (($# >= 2)); then
    local -a args=("$@")
    local target="${args[$# - 1]}"
    unset "args[$# - 1]"
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
    local fn="${args[$# - 1]}"
    unset "args[$# - 1]"
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
    local target="${args[$# - 1]}"
    unset "args[$# - 1]"
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

Array_join() {
  if (($# >= 3)); then
    local -a args=("$@")
    local delimiter="${args[$# - 1]}"
    unset "args[$# - 1]"
    local -i len="${#args[@]}"
    local result=""
    local str=""
    local -i i
    for ((i = 0; i < len; i++)); do
      str="${args[$i]}"
      result="$result$delimiter$str"
    done

    String_stripStart "$result" "$delimiter" >/dev/null
    result="$RETVAL"

    RETVAL="$result"
    printf '%s\n' "$result"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

# @deprecated
Array_length() {
  local -i len="$#"
  RETVAL="$len"
  echo "$len"
}

Array_map() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[$# - 1]}"
    unset "args[$# - 1]"
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
    RETVAL=("${1:-}")
    printf '%s\n' "${1:-}"
  fi
}

Array_notEmpty() {
  ! Array_isEmpty "$@"
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

# @desc check if array has element meets the condition
# @param array <array>
# @param condition <function>

# @example
# gt5() {
#   (($1 > 5)) && return 0
#   return 1
# }
#
# arr=(1 2 6)
# Array_some "${arr[@]}" gt5
# # assert success
#
# arr=(1 2 3)
# Array_some "${arr[@]}" gt5
# # assert failure
# @end
Array_some() {
  if (($# >= 2)); then
    local -a args=("$@")
    local fn="${args[$# - 1]}"
    unset "args[$# - 1]"
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
    local -i len="$#"
    local -i step=1

    while ((step < len)); do
      local -i lStart=0
      while ((lStart < len)); do
        local -i rStart=$((lStart + step))
        local -i lEnd=$((rStart - 1))
        ((lEnd >= len)) && break
        local -i rEnd=$((lEnd + step))
        ((rEnd >= len)) && rEnd=$((len - 1))

        local -a tmpArr=()
        local -i i="$lStart"
        local -i j="$rStart"

        while ((i <= lEnd)) && ((j <= rEnd)); do
          if $LIBSHELL_COMPARATOR "${arr[i]}" ">" "${arr[j]}"; then
            tmpArr+=("${arr[j]}")
            j=$((j + 1))
          else
            tmpArr+=("${arr[i]}")
            i=$((i + 1))
          fi
        done

        while ((i <= lEnd)); do
          tmpArr+=("${arr[i]}")
          i=$((i + 1))
        done

        while ((j <= rEnd)); do
          tmpArr+=("${arr[j]}")
          j=$((j + 1))
        done

        local k=0
        for ((k = 0; k < ${#tmpArr[@]}; k++)); do
          arr[k + lStart]="${tmpArr[k]}"
        done

        lStart=$((lStart + 2 * step))
      done
      step=$((step * 2))
    done

    RETVAL=("${arr[@]}")
    printf '%s\n' "${arr[@]}"
  else
    RETVAL=("${1:-}")
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
