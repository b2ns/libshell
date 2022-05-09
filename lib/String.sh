#!/usr/bin/env bash

String_at() {
  local string="${1:-}"
  local -i position="${2:-0}"
  String_substr "$string" "$position" 1
}

String_capitalize() {
  local string="${1:-}"
  printf '%s\n' "${string^}"
}

String_concat() {
  local res=""
  for str in "$@"; do
    res="$res$str"
  done
  printf '%s\n' "$res"
}

String_endsWith() {
  local string="${1:-}"
  local suffix="${2:-}"
  [[ "$string" == *"$suffix" ]]
}

String_eq() {
  local string1="${1:-}"
  local string2="${2:-}"
  [[ "$string1" == "$string2" ]]
}

String_includes() {
  local string="${1:-}"
  local substring="${2:-}"
  [[ "$string" == *"$substring"* ]]
}

String_indexOf() {
  (($# < 2)) && echo -1
  local string="$1"
  local substring="$2"
  if String_includes "$string" "$substring"; then
    local -i index=0
    local str="$string"
    while ! String_startsWith "$str" "$substring"; do
      index=$((index + 1))
      str="$(String_substr "$string" "$index")"
    done
    echo "$index"
  else
    echo -1
  fi
}

String_isEmpty() {
  [[ -z "${1:-}" ]]
}

String_notEmpty() {
  [[ -n "${1:-}" ]]
}

String_join() {
  if (($# <= 1)); then
    printf '%s\n' "$@"
  elif (($# == 2)); then
    printf '%s\n' "$1$2"
  else
    local -a args=("$@")
    local delimiter="${args[-1]}"
    unset "args[-1]"
    local res=""
    for str in "${args[@]}"; do
      if String_isEmpty "$res"; then
        res="$str"
      else
        res="$res$delimiter$str"
      fi
    done
    printf '%s\n' "$res"
  fi
}

String_length() {
  local string="${1:-}"
  echo "${#string}"
}

String_match() {
  local string="${1:-}"
  local pattern="${2:-}"
  [[ "$string" =~ $pattern ]]
}

String_notEq() {
  local string1="${1:-}"
  local string2="${2:-}"
  [[ "$string1" != "$string2" ]]
}

String_padEnd() {
  if (($# >= 2)); then
    local string="$1"
    local -i strLen=""
    strLen="$(String_length "$string")"
    local -i maxLen="$2"
    local -i len=$((maxLen - strLen))
    local padStr="${3:- }"
    printf '%s\n' "$string$(String_repeat "$padStr" "$len")"
  else
    printf '%s\n' "$@"
  fi
}

String_padStart() {
  if (($# >= 2)); then
    local string="$1"
    local -i strLen=""
    strLen="$(String_length "$string")"
    local -i maxLen="$2"
    local -i len=$((maxLen - strLen))
    local padStr="${3:- }"
    printf '%s\n' "$(String_repeat "$padStr" "$len")$string"
  else
    printf '%s\n' "$@"
  fi
}

String_repeat() {
  local string="${1:-}"
  local -i count="${2:-1}"
  local res=""
  local -i i
  for ((i = 0; i < count; i++)); do
    res="$res$string"
  done
  printf '%s\n' "$res"
}

String_replace() {
  if (($# >= 3)); then
    printf '%s\n' "${1/$2/$3}"
  else
    printf '%s\n' "${1:-}"
  fi
}

String_replaceAll() {
  if (($# >= 3)); then
    printf '%s\n' "${1//$2/$3}"
  else
    printf '%s\n' "${1:-}"
  fi
}

String_reverse() {
  local string="${1:-}"
  local -i index=""
  index="$(String_length "$string")"
  local res=""
  while ((index > 0)); do
    index=$((index - 1))
    res="$res$(String_at "$string" "$index")"
  done
  printf '%s\n' "$res"
}

String_search() {
  echo TODO
}

String_slice() {
  if (($# >= 3)); then
    String_substr "$1" "$2" "$(($3 - $2))"
  else
    String_substr "$@"
  fi
}

String_split() {
  local string="${1:-}"
  local delmiter="${2:-}"
  local -a array=()

  if String_isEmpty "$delmiter"; then
    local -i strLen=""
    strLen=$(String_length "$string")
    local -i i
    for ((i = 0; i < strLen; i++)); do
      array+=("$(String_at "$string" "$i")")
    done
  else
    while String_includes "$string" "$delmiter"; do
      array+=("$(String_stripEnd "$string" "$delmiter*" 1)")
      string="$(String_stripStart "$string" "*$delmiter")"
    done
    array+=("$string")
  fi

  printf "%s\n" "${array[@]}"
}

String_startsWith() {
  local string="${1:-}"
  local prefix="${2:-}"
  [[ "$string" == "$prefix"* ]]
}

String_stripEnd() {
  local string="${1:-}"
  local pattern="${2:-}"
  local -i greedy="${3:-0}"
  if ((greedy == 1)); then
    printf '%s\n' "${string%%$pattern}"
  else
    printf '%s\n' "${string%$pattern}"
  fi
}

String_stripStart() {
  local string="${1:-}"
  local pattern="${2:-}"
  local -i greedy="${3:-0}"
  if ((greedy == 1)); then
    printf '%s\n' "${string##$pattern}"
  else
    printf '%s\n' "${string#$pattern}"
  fi
}

String_substr() {
  if (($# >= 3)); then
    printf '%s\n' "${1:($2):$3}"
  elif (($# == 2)); then
    printf '%s\n' "${1:($2)}"
  else
    printf '%s\n' "$@"
  fi
}

String_toLowerCase() {
  local string="${1:-}"
  printf '%s\n' "${string,,}"
}

String_toUpperCase() {
  local string="${1:-}"
  printf '%s\n' "${string^^}"
}

String_trim() {
  local string="${1:-}"
  local pattern="${2:- }"
  String_trimEnd "$(String_trimStart "$@")" "$pattern"
}

String_trimEnd() {
  local string="${1:-}"
  local pattern="${2:- }"
  local pre=""
  while String_notEq "$pre" "$string"; do
    pre="$string"
    string="$(String_stripEnd "$string" "$pattern")"
  done
  printf '%s\n' "$string"
}

String_trimStart() {
  local string="${1:-}"
  local pattern="${2:- }"
  local pre=""
  while String_notEq "$pre" "$string"; do
    pre="$string"
    string="$(String_stripStart "$string" "$pattern")"
  done
  printf '%s\n' "$string"
}

String_uncapitalize() {
  local string="${1:-}"
  printf '%s\n' "${string,}"
}
