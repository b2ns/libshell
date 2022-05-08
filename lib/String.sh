#!/usr/bin/env bash

String_at() {
  if (($# >= 2)); then
    String_substr "$1" "$2" 1
  else
    echo "$1"
  fi
}

String_capitalize() {
  printf '%s\n' "${1^}"
}

String_concat() {
  local res=""
  for str in "$@"; do
    res="$res$str"
  done
  printf '%s\n' "$res"
}

String_includes() {
  if [[ "$1" == *"$2"* ]]; then
    return 0
  else
    return 1
  fi
}

String_indexOf() {
  if (($# >= 2)); then
    if String_includes "$1" "$2"; then
      local index=-1
      local str=""
      local subStrLen=$(String_length "$2")
      while ! String_includes "$str" "$2"; do
        index=$((index + 1))
        str="$(String_slice "$1" "$index")"
      done
      echo $((index - subStrLen))
    else
      echo -1
    fi
  else
    echo -1
  fi
}

String_isEmpty() {
  [[ -z "$1" ]]
}

String_isNotEmpty() {
  [[ -n "$1" ]]
}

String_join() {
  if (($# >= 3)); then
    local delimiter=${@:$#:1}
    delimiter=${delimiter[0]}
    local len=$(($# - 1))
    local res=""
    for str in "${@:1:$len}"; do
      if String_isEmpty "$res"; then
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

String_length() {
  echo "${#1}"
}

String_match() {
  if [[ "$1" =~ $2 ]]; then
    return 0
  else
    return 1
  fi
}

String_padEnd() {
  if (($# >= 2)); then
    local strLen="$(String_length "$1")"
    local maxLen="$2"
    local len=$((maxLen - strLen))
    local padStr="${3:- }"
    printf '%s\n' "$1$(String_repeat "$padStr" "$len")"
  else
    printf '%s\n' "$1"
  fi
}

String_padStart() {
  if (($# >= 2)); then
    local strLen="$(String_length "$1")"
    local maxLen="$2"
    local len=$((maxLen - strLen))
    local padStr="${3:- }"
    printf '%s\n' "$(String_repeat "$padStr" "$len")$1"
  else
    printf '%s\n' "$1"
  fi
}

String_repeat() {
  if (($# >= 2)); then
    local res=""
    for ((i = 0; i < $2; i++)); do
      res="$res$1"
    done
    printf '%s\n' "$res"
  else
    printf '%s\n' "$1"
  fi
}

String_replace() {
  if (($# >= 3)); then
    printf '%s\n' "${1/$2/$3}"
  else
    printf '%s\n' "$1"
  fi
}

String_replaceAll() {
  if (($# >= 3)); then
    printf '%s\n' "${1//$2/$3}"
  else
    printf '%s\n' "$1"
  fi
}

String_reverse() {
  local str="$1"
  local len="$(String_length "$str")"
  local res=""
  while ((len > 0)); do
    len=$((len - 1))
    res="$res$(String_at "$str" "$len")"
  done
  printf '%s\n' "$res"
}

String_search() {
  echo TODO
}

String_slice() {
  if (($# >= 3)); then
    String_substr "$1" "$2" "$(($3 - $2))"
  elif (($# == 2)); then
    printf '%s\n' "${1::$2}"
  else
    printf '%s\n' "$1"
  fi
}

String_substr() {
  if (($# >= 3)); then
    printf '%s\n' "${1:$2:$3}"
  elif (($# == 2)); then
    printf '%s\n' "${1::$2}"
  else
    printf '%s\n' "$1"
  fi
}

String_split() {
  declare -a array=()
  if (($# >= 1)); then
    local str="$1"
    local delmiter="$2"
    if String_isEmpty "$delmiter"; then
      local strLen=$(String_length "$str")
      for ((i = 0; i < strLen; i++)); do
        array+=("$(String_substr "$str" "$i" 1)")
      done
    else
      while [[ "$str" == *"$delmiter"* ]]; do
        array+=("$(String_trimEnd "$str" "$delmiter*" 1)")
        str="$(String_trimStart "$str" "*$delmiter")"
      done
      array+=("$str")
    fi
  fi

  printf "%s\n" "${array[@]}"
}

String_toLowerCase() {
  printf '%s\n' "${1,,}"
}

String_toUpperCase() {
  printf '%s\n' "${1^^}"
}

String_trim() {
  local res=$(String_trimStart "$1")
  String_trimEnd "$res"
}

String_trimEnd() {
  if (($# >= 3)); then
    if (($3 == 1)); then
      printf '%s\n' "${1%%$2}"
    else
      printf '%s\n' "${1%$2}"
    fi
  elif (($# == 2)); then
    printf '%s\n' "${1%$2}"
  else
    local res="${1% }"
    local pre=""
    while [[ "$pre" != "$res" ]]; do
      pre="$res"
      res="${res% }"
    done
    printf '%s\n' "$res"
  fi
}

String_trimStart() {
  if (($# >= 3)); then
    if (($3 == 1)); then
      printf '%s\n' "${1##$2}"
    else
      printf '%s\n' "${1#$2}"
    fi
  elif (($# == 2)); then
    printf '%s\n' "${1#$2}"
  else
    local res="${1# }"
    local pre=""
    while [[ "$pre" != "$res" ]]; do
      pre="$res"
      res="${res# }"
    done
    printf '%s\n' "$res"
  fi
}

String_uncapitalize() {
  printf '%s\n' "${1,}"
}
