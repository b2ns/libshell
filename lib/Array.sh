#!/usr/bin/env bash
# shellcheck disable=SC2178,SC2128
import Math
import String

# @desc check if all elements in array meets the condition
# @param array <array>
# @param condition <function> | <string>

# @example
# gt5() {
#   (($1 > 5))
# }
#
# arr=(6 7 8)
# Array_every arr gt5
# # assert success
#
# arr=(6 5 8)
# Array_every arr '(( $1 > 5 ))'
# # assert failure
# @end
Array_every() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      if ! $fn "${___array___[i]}" "$i" &>/dev/null; then
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
# @param condition <function> | <string>
# @return array <array>

# @example
# arr=(6 1 8)
# Array_filter arr '(( $1 > 5 ))'
# # output: 6 8
# @end
Array_filter() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"
    local -a res=()
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      if $fn "${___array___[i]}" "$i" &>/dev/null; then
        res+=("${___array___[i]}")
      fi
    done
    RETVAL=("${res[@]}")
    printf '%s\n' "${res[@]}"
  else
    RETVAL=("")
    printf '%s\n' ""
    return 1
  fi
}

# @desc check if array has element satisfy the condition
# @param array <array>
# @param condition <function> | <string>

# @example
# arr=("foo" "bar111" "baz")
# Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# # assert success
#
# arr=("foo" "bar" "baz")
# Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# # assert failure
# @end
Array_find() {
  Array_findIndex "$@" >/dev/null
}

# @desc return the index of the first element match the regexp
# @param array <array>
# @param regexp <regexp>
# @return index <int> or -1 when not found

# @example
# arr=("foo" "bar111" "baz")
# Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# # output: 1
#
# arr=("foo" "bar" "baz")
# Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# output: -1
# @end
Array_findIndex() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      if $fn "${___array___[i]}" "$i" &>/dev/null; then
        RETVAL="$i"
        echo "$i"
        return 0
      fi
    done
    RETVAL=-1
    echo -1
    return 1
  else
    RETVAL=-1
    echo -1
    return 1
  fi
}

# @desc execute the function for each element in array
# @param array <array>
# @param function <function> | <string>

# @example
# arr=(6 7 8)
# Array_forEach arr 'echo "$2: $1"'
# # output: 0: 6
# # output: 1: 7
# # output: 2: 8
# @end
Array_forEach() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      $fn "${___array___[i]}" "$i"
    done
  fi
}

# @desc check if array has a certain element
# @param array <array>
# @param element <string>

# @example
# arr=(1 2 3)
# Array_includes arr 2
# # assert success
# @end
Array_includes() {
  Array_indexOf "$@" >/dev/null
}

# @desc get the first index of the element
# @param array <array>
# @param element <string>
# @return index <int> or -1 when not found

# @example
# arr=(1 2 3)
# Array_indexOf arr 2
# # output: 1
# @end
Array_indexOf() {
  if (($# >= 1)); then
    local target="${2:-}"
    Array_findIndex "$1" '[[ "$1" == "'"$target"'" ]]'
  else
    RETVAL=-1
    echo -1
    return 1
  fi
}

# @desc check if array is empty
# @param array <array>

# @example
# arr=()
# Array_isEmpty arr
# # assert success
# @end
Array_isEmpty() {
  if (($# >= 1)); then
    local -n ___array___="$1"
    ((${#___array___[@]} == 0))
  else
    return 1
  fi
}

# @desc join array elements with a delimiter
# @param array <array>
# @param delimiter <string>
# @return joined string <string>

# @example
# arr=(1 2 3)
# Array_join arr ","
# # output: 1,2,3
#
# arr=(1 2 3)
# Array_join arr
# # output: 123
# @end
Array_join() {
  if (($# >= 1)); then
    local -n ___array___="$1"
    local delimiter="${2:-}"
    local result=""
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      result="$result$delimiter${___array___[i]}"
    done

    String_stripStart "$result" "$delimiter" >/dev/null
    result="$RETVAL"

    RETVAL="$result"
    printf '%s\n' "$result"
  else
    RETVAL=""
    printf '%s\n' ""
  fi
}

# @desc create a new array with the results of calling a provided function on every element in this array
# @param array <array>
# @param function <function> | <string>
# @return array <array>

# @example
# double() {
# echo $(($1 * 2))
# }
#
# arr=(1 2 3)
# Array_map arr double
# # output: 2 4 6
#
# arr=(1 2 3)
# Array_map arr 'echo $(( $1 * 3 ))'
# # output: 3 6 9
# @end
Array_map() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"

    local -a res=()
    local val=""
    local item=""
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      item="${___array___[i]}"
      RETVAL="___reset_retval___"
      $fn "$item" "$i" >/dev/null
      # check if fn use the RETVAL to return value
      if [[ "$RETVAL" != "___reset_retval___" ]]; then
        val="$RETVAL"
      else
        val="$($fn "$item" "$i")"
      fi
      res+=("$val")
    done
    RETVAL=("${res[@]}")
    printf '%s\n' "${res[@]}"
  else
    RETVAL=("")
    printf '%s\n' ""
  fi
}

# @desc check if array is not empty
# @param array <array>

# @example
# arr=(1 2 3)
# Array_notEmpty arr
# # assert success
# @end
Array_notEmpty() {
  ! Array_isEmpty "$@"
}

Array_pop() {
  if (($# >= 1)); then
    local -n ___array___="$1"
    local -i len=${#___array___[@]}
    if ((len)); then
      local last="${___array___[len - 1]}"
      unset '___array___[len - 1]'
      RETVAL="$last"
      printf '%s\n' "$last"
    else
      RETVAL=""
      echo ""
    fi
  else
    RETVAL=""
    echo ""
  fi
}

Array_push() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    ___array___+=("$2")
    RETVAL="$2"
    printf '%s\n' "$2"
  else
    RETVAL=""
    echo ""
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
  if (($# >= 1)); then
    local -n ___array___="$1"
    local -i len=${#___array___[@]}
    local -i i=0
    local -i j=$((len - 1))
    while ((i < j)); do
      local tmp="${___array___[i]}"
      ___array___[$i]="${___array___[j]}"
      ___array___[$j]="$tmp"
      i=$((i + 1))
      j=$((j - 1))
    done
  fi
}

Array_shift() {
  if (($# >= 1)); then
    local -n ___array___="$1"
    local -i len=${#___array___[@]}
    if ((len)); then
      local first="${___array___[0]}"
      unset '___array___[0]'
      ___array___=("${___array___[@]}")
      RETVAL="$first"
      printf '%s\n' "$first"
    else
      RETVAL=""
      echo ""
    fi
  else
    RETVAL=""
    echo ""
  fi
}

# @desc check if array has element meets the condition
# @param array <array>
# @param condition <function> | <string>

# @example
# gt5() {
#   (($1 > 5))
# }
#
# arr=(1 2 6)
# Array_some arr gt5
# # assert success
#
# arr=(1 2 3)
# Array_some arr '(($1 > 5))'
# # assert failure
# @end
Array_some() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "$2"
    local fn="$RETVAL"
    local -i i
    for ((i = 0; i < ${#___array___[@]}; i++)); do
      if $fn "${___array___[i]}" "$i" &>/dev/null; then
        return 0
      fi
    done
    return 1
  else
    return 1
  fi
}

Array_sort() {
  if (($# >= 1)); then
    local -n ___array___="$1"
    __arrayLambdaFunc__ "${2:-__defaultComparator__}"
    local comparator="$RETVAL"

    local -i len="${#___array___[@]}"
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
          if $comparator "${___array___[i]}" ">" "${___array___[j]}"; then
            tmpArr+=("${___array___[j]}")
            j=$((j + 1))
          else
            tmpArr+=("${___array___[i]}")
            i=$((i + 1))
          fi
        done

        while ((i <= lEnd)); do
          tmpArr+=("${___array___[i]}")
          i=$((i + 1))
        done

        while ((j <= rEnd)); do
          tmpArr+=("${___array___[j]}")
          j=$((j + 1))
        done

        local k=0
        for ((k = 0; k < ${#tmpArr[@]}; k++)); do
          ___array___[k + lStart]="${tmpArr[k]}"
        done

        lStart=$((lStart + 2 * step))
      done
      step=$((step * 2))
    done
  fi
}

Array_splice() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    local -i len=${#___array___[@]}
    local -i start="$2"
    ((start >= len)) && start=$((len - 1))
    ((start < -len)) && start=0
    ((start < 0)) && start=$((len + start))
    local -i restCount="$((len - start))"
    local -i deleteCount="${3:-$restCount}"
    ((deleteCount > restCount)) && deleteCount="$restCount"
    local -a insertItems=("${@:4}")
    local -a headItems=("${___array___[@]:0:start}")
    local -a deleteItems=("${___array___[@]:start:deleteCount}")
    local -a tailItems=("${___array___[@]:start+deleteCount}")
    ___array___=("${headItems[@]}" "${insertItems[@]}" "${tailItems[@]}")
    RETVAL=("${deleteItems[@]}")
    printf '%s\n' "${deleteItems[@]}"
  else
    RETVAL=("")
    printf '%s\n' ""
  fi
}

Array_unshift() {
  if (($# >= 2)); then
    local -n ___array___="$1"
    ___array___=("$2" "${___array___[@]}")
    RETVAL="$2"
    printf '%s\n' "$2"
  else
    RETVAL=""
    echo ""
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

__arrayLambdaFunc__() {
  RETVAL="$1"
  if ! type -t "$1" &>/dev/null; then
    eval '___array_lambda_func___() {
      '"$1"'
    }'
    RETVAL="___array_lambda_func___"
  fi
}
