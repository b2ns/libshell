#!/usr/bin/env bash
# shellcheck disable=SC2178,SC2128

String_at() {
  local string="${1:-}"
  local -i position="${2:-0}"
  String_substr "$string" "$position" 1
}

String_capitalize() {
  local string="${1:-}"
  local res="${string^}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

String_concat() {
  local res=""
  local str=""
  for str in "$@"; do
    res="$res$str"
  done
  RETVAL="$res"
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
  RETVAL=-1
  (($# < 2)) && echo -1
  local string="$1"
  local substring="$2"
  if String_includes "$string" "$substring"; then
    local -i index=0
    local str="$string"
    while ! String_startsWith "$str" "$substring"; do
      index=$((index + 1))
      String_substr "$string" "$index" >/dev/null
      str="$RETVAL"
    done
    RETVAL="$index"
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
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  elif (($# == 2)); then
    RETVAL="$1$2"
    printf '%s\n' "$1$2"
  else
    local -a args=("$@")
    local delimiter="${args[-1]}"
    unset "args[-1]"
    local res=""
    local str=""
    for str in "${args[@]}"; do
      if String_isEmpty "$res"; then
        res="$str"
      else
        res="$res$delimiter$str"
      fi
    done
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

String_length() {
  local string="${1:-}"
  local -i len="${#string}"
  RETVAL="$len"
  echo "$len"
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
    strLen="${#string}"
    local -i maxLen="$2"
    local -i len=$((maxLen - strLen))
    local padStr="${3:- }"
    String_repeat "$padStr" "$len" >/dev/null
    local res="$string$RETVAL"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

String_padStart() {
  if (($# >= 2)); then
    local string="$1"
    local -i strLen=""
    strLen="${#string}"
    local -i maxLen="$2"
    local -i len=$((maxLen - strLen))
    local padStr="${3:- }"
    String_repeat "$padStr" "$len" >/dev/null
    local res="$RETVAL$string"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
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
  RETVAL="$res"
  printf '%s\n' "$res"
}

String_replace() {
  if (($# >= 3)); then
    local res="${1/$2/$3}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    local res="${1:-}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

String_replaceAll() {
  if (($# >= 3)); then
    local res="${1//$2/$3}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    local res="${1:-}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

String_reverse() {
  local string="${1:-}"
  local -i index=""
  index="${#string}"
  local res=""
  while ((index > 0)); do
    index=$((index - 1))
    String_at "$string" "$index" >/dev/null
    res="$res$RETVAL"
  done
  RETVAL="$res"
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
    strLen="${#string}"
    local -i i
    for ((i = 0; i < strLen; i++)); do
      String_at "$string" "$i" >/dev/null
      array+=("$RETVAL")
    done
  else
    while String_includes "$string" "$delmiter"; do
      String_stripEnd "$string" "$delmiter*" 1 >/dev/null
      array+=("$RETVAL")
      String_stripStart "$string" "*$delmiter" >/dev/null
      string="$RETVAL"
    done
    array+=("$string")
  fi

  RETVAL=("${array[@]}")
  printf '%s\n' "${array[@]}"
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
    local res="${string%%$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    local res="${string%$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

String_stripStart() {
  local string="${1:-}"
  local pattern="${2:-}"
  local -i greedy="${3:-0}"
  if ((greedy == 1)); then
    local res="${string##$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    local res="${string#$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

String_substr() {
  if (($# >= 3)); then
    local res="${1:($2):$3}"
    RETVAL="$res"
    printf '%s\n' "$res"
  elif (($# == 2)); then
    local res="${1:($2)}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    RETVAL="${1:-}"
    printf '%s\n' "${1:-}"
  fi
}

String_toLowerCase() {
  local string="${1:-}"
  local res="${string,,}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

String_toUpperCase() {
  local string="${1:-}"
  local res="${string^^}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

String_trim() {
  local string="${1:-}"
  local pattern="${2:- }"
  String_trimStart "$@" >/dev/null
  local tmp="$RETVAL"
  String_trimEnd "$tmp" "$pattern"
}

String_trimEnd() {
  local string="${1:-}"
  local pattern="${2:- }"
  local pre=""
  while String_notEq "$pre" "$string"; do
    pre="$string"
    String_stripEnd "$string" "$pattern" >/dev/null
    string="$RETVAL"
  done
  RETVAL="$string"
  printf '%s\n' "$string"
}

String_trimStart() {
  local string="${1:-}"
  local pattern="${2:- }"
  local pre=""
  while String_notEq "$pre" "$string"; do
    pre="$string"
    String_stripStart "$string" "$pattern" >/dev/null
    string="$RETVAL"
  done
  RETVAL="$string"
  printf '%s\n' "$string"
}

String_uncapitalize() {
  local string="${1:-}"
  local res="${string,}"
  RETVAL="$res"
  printf '%s\n' "$res"
}
