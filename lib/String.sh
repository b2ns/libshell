#!/usr/bin/env bash

function String_at() {
  if [[ $# -ge 2 ]]; then
    String_substr "${1}" "${2}" 1
  else
    echo "${1}"
  fi
}

function String_capitalize() {
  echo "${1^}"
}

function String_concat() {
  local res=""
  for str in "${@}"; do
    res="${res}${str}"
  done
  echo "${res}"
}

function String_includes() {
  if [[ "${1}" == *"${2}"* ]]; then
    return 0
  else
    return 1
  fi
}

function String_indexOf() {
  if [[ $# -ge 2 ]]; then
    if String_includes "${1}" "${2}"; then
      local index=-1
      local str=""
      local subStrLen=$(String_length "${2}")
      while ! String_includes "${str}" "${2}"; do
        index=$((index + 1))
        str="$(String_slice "${1}" "${index}")"
      done
      echo $((index - subStrLen))
    else
      echo -1
    fi
  else
    echo -1
  fi
}

function String_isEmpty() {
  if [[ -z "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function String_isNotEmpty() {
  if [[ -n "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function String_join() {
  if [[ $# -ge 1 ]]; then
    # shellcheck disable=SC2124
    local delimiter=${@:$#:1}
    delimiter=${delimiter[0]}
    local len=$(($# - 1))
    local res=""
    for str in "${@:1:$len}"; do
      if String_isEmpty "${res}"; then
        res="${str}"
      else
        res="${res}${delimiter}${str}"
      fi
    done
    echo "${res}"
  else
    echo "${1}"
  fi
}

function String_length() {
  echo "${#1}"
}

function String_match() {
  if [[ "${1}" =~ ${2} ]]; then
    return 0
  else
    return 1
  fi
}

function String_padEnd() {
  if [[ $# -ge 2 ]]; then
    local strLen="$(String_length "${1}")"
    local maxLen="${2}"
    local len=$((maxLen - strLen))
    local padStr="${3:- }"
    echo "${1}$(String_repeat "${padStr}" "${len}")"
  else
    echo "${1}"
  fi
}

function String_padStart() {
  if [[ $# -ge 2 ]]; then
    local strLen="$(String_length "${1}")"
    local maxLen="${2}"
    local len=$((maxLen - strLen))
    local padStr="${3:- }"
    echo "$(String_repeat "${padStr}" "${len}")${1}"
  else
    echo "${1}"
  fi
}

function String_repeat() {
  if [[ $# -ge 2 ]]; then
    local res=""
    for ((i = 0; i < ${2}; i++)); do
      res="${res}${1}"
    done
    echo "${res}"
  else
    echo "${1}"
  fi
}

function String_replace() {
  if [[ $# -ge 3 ]]; then
    echo "${1/${2}/${3}}"
  else
    echo "${1}"
  fi
}

function String_replaceAll() {
  if [[ $# -ge 3 ]]; then
    echo "${1//${2}/${3}}"
  else
    echo "${1}"
  fi
}

function String_reverse() {
  local str="${1}"
  local len="$(String_length "${str}")"
  local res=""
  while [[ "${len}" -gt 0 ]]; do
    len=$((len - 1))
    res="${res}$(String_at "${str}" "${len}")"
  done
  echo "${res}"
}

function String_search() {
  echo TODO
}

function String_slice() {
  if [[ $# -ge 3 ]]; then
    String_substr "${1}" "${2}" "$((${3} - ${2}))"
  elif [[ $# -eq 2 ]]; then
    echo "${1::${2}}"
  else
    echo "${1}"
  fi
}

function String_substr() {
  if [[ $# -ge 3 ]]; then
    echo "${1:${2}:${3}}"
  elif [[ $# -eq 2 ]]; then
    echo "${1::${2}}"
  else
    echo "${1}"
  fi
}

function String_split() {
  declare -a array=()
  if [[ $# -ge 1 ]]; then
    local str="${1}"
    local delmiter="${2}"
    if String_isEmpty "${delmiter}"; then
      local strLen=$(String_length "${str}")
      for ((i = 0; i < strLen; i++)); do
        array+=("$(String_substr "${str}" "${i}" 1)")
      done
    else
      while [[ "${str}" == *"${delmiter}"* ]]; do
        array+=("$(String_trimEnd "${str}" "${delmiter}*" 1)")
        str="$(String_trimStart "${str}" "*${delmiter}")"
      done
      array+=("${str}")
    fi
  fi

  printf "%s\n" "${array[@]}"
}

function String_toLowerCase() {
  echo "${1,,}"
}

function String_toUpperCase() {
  echo "${1^^}"
}

function String_trim() {
  local res=$(String_trimStart "${1}")
  String_trimEnd "${res}"
}

function String_trimEnd() {
  if [[ $# -ge 3 ]]; then
    if [[ "$3" -eq 1 ]]; then
      echo "${1%%${2}}"
    else
      echo "${1%${2}}"
    fi
  elif [[ $# -eq 2 ]]; then
    echo "${1%${2}}"
  else
    local res="${1% }"
    local pre=""
    while [[ "$pre" != "$res" ]]; do
      pre="$res"
      res="${res% }"
    done
    echo "$res"
  fi
}

function String_trimStart() {
  if [[ $# -ge 3 ]]; then
    if [[ "$3" -eq 1 ]]; then
      echo "${1##${2}}"
    else
      echo "${1#${2}}"
    fi
  elif [[ $# -eq 2 ]]; then
    echo "${1#${2}}"
  else
    local res="${1# }"
    local pre=""
    while [[ "$pre" != "$res" ]]; do
      pre="$res"
      res="${res# }"
    done
    echo "$res"
  fi
}

function String_uncapitalize() {
  echo "${1,}"
}
