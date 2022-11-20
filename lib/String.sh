#!/usr/bin/env bash
# shellcheck disable=SC2178,SC2128

# @desc get the char at the given index
# @param string <string>
# @param index <int>
# @return char <char>

# @example
# String_at "abc" 1
# # output: b
#
# String_at "abc" -1
# # output: c
# @end
String_at() {
  local string="${1:-}"
  local -i position="${2:-0}"
  String_substr "$string" "$position" 1
}

# @desc capitalize the first letter of the given string
# @param string <string>
# @return capitalized string <string>

# @example
# String_capitalize "foo"
# # output: "Foo"
# @end
String_capitalize() {
  local string="${1:-}"
  local res="${string^}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

# @desc check if the given string ends with the specific suffix
# @param string <string>
# @param suffix <string>

# @example
# String_endsWith "foobar" "bar"
# # assert success
#
# String_endsWith "foobar" "ba"
# # assert failure
# @end
String_endsWith() {
  local string="${1:-}"
  local suffix="${2:-}"
  [[ "$string" == *"$suffix" ]]
}

# @desc check if the given strings are equal
# @param string1 <string>
# @param string2 <string>

# @example
# String_eq "foobar" "foobar"
# # assert success
#
# String_eq "foobar" "foo"
# # assert failure
# @end
String_eq() {
  local string1="${1:-}"
  local string2="${2:-}"
  [[ "$string1" == "$string2" ]]
}

# @desc check if the given stirng includes the specific substring
# @param string <string>
# @param substring <string>

# @example
# String_includes "foobar" "oob"
# # assert success
#
# String_includes "foobar" "baz"
# # assert failure
# @end
String_includes() {
  local string="${1:-}"
  local substring="${2:-}"
  [[ "$string" == *"$substring"* ]]
}

# @desc  get the index of the first occurrence of the specific substring
# @param string <string>
# @param substring <string>
# @return index <int>

# @example
# String_indexOf "foo barbar" "bar"
# # output: 4
#
# String_indexOf "foo bar" "baz"
# # output: -1
# @end
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

# @desc check if the given stirng is empty
# @param string <string>

# @example
# String_isEmpty ""
# # assert success
#
# String_isEmpty "foo"
# # assert failure
# @end
String_isEmpty() {
  [[ -z "${1:-}" ]]
}

# @desc check if the given stirng match the specific pattern
# @param string <string>
# @param pattern <regexp>

# @example
# String_match "foo12o bar" "^foo[0-9]+o"
# # assert success
#
# String_match "foo1 bar" "^foo$"
# # assert failure
# @end
String_match() {
  local string="${1:-}"
  local pattern="${2:-}"
  [[ "$string" =~ $pattern ]]
}

# @desc check if the given stirng is not empty
# @param string <string>

# @example
# String_notEmpty "foo"
# # assert success
#
# String_notEmpty ""
# # assert failure
# @end
String_notEmpty() {
  [[ -n "${1:-}" ]]
}

# @desc check if the given stirngs are not equal
# @param string1 <string>
# @param string2 <string>

# @example
# String_notEq "foo" "fox"
# # assert success
#
# String_notEq "foo" "foo"
# # assert failure
# @end
String_notEq() {
  local string1="${1:-}"
  local string2="${2:-}"
  [[ "$string1" != "$string2" ]]
}

# @desc pads the current string with a given string at the end
# @param string <string>
# @param targetLength <int>
# @param padString <string> (default " ")
# @return padded string <string>

# @example
# String_padEnd "foo" 5
# # output: "foo  "
#
# String_padEnd "foo" 6 "-"
# # output: "foo---"
# @end
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

# @desc pads the current string with a given string at the beginning
# @param string <string>
# @param targetLength <int>
# @param padString <string> (default " ")
# @return padded string <string>

# @example
# String_padStart "foo" 5
# # output: "  foo"
#
# String_padStart "foo" 6 "-"
# # output: "---foo"
# @end
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

# @desc repeat the given string n times
# @param string <string>
# @param count <int>
# @return new string <string>

# @example
# String_repeat "a" 3
# # output: aaa
# @end
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

# @desc replace the subStr of the given string with newSubStr
# @param string <string>
# @param subStr <string>
# @param newSubStr <string>
# @return new string <string>

# @example
# String_replace "foo bar" "bar" "baz"
# # output: foo baz
#
# String_replace " foo bar" "bar" ""
# # output: " foo "
#
# String_replace "foo bar foobar" "bar" "baz"
# # output: foo baz foobar
# @end
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

# @desc replace all the subStr of the given string with newSubStr
# @param string <string>
# @param subStr <string>
# @param newSubStr <string>
# @return new string <string>

# @example
# String_replaceAll "foo bar foobar" "bar" "baz"
# # output: foo baz foobaz
# @end
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

# @desc reverse the given string
# @param string <string>
# @return reversed string <string>

# @example
# String_reverse "abcd"
# # output: dcba
# @end
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

# @desc get the index of the first occurrence of the specific pattern
# @param string <string>
# @param pattern <regexp>
# @return index <int>

# @example
# String_search "foo123bar" "[0-9]+"
# # output: 3
#
# String_search "foobar" "[0-9]+"
# # output: -1
# @end
String_search() {
  RETVAL=-1
  (($# < 2)) && echo -1
  local string="$1"
  local pattern="$2"
  if String_match "$string" "$pattern"; then
    String_indexOf "$string" "${BASH_REMATCH[0]}"
  else
    echo -1
  fi
}

# @desc extracts a section of the given string
# @param string <string>
# @param beginIndex <int>
# @param endIndex <int> (optional)
# @return new string <string>

# @example
# String_slice "foobar" 0 3
# # output: foo
#
# String_slice "foobar" 0 -1
# # output: fooba
#
# String_slice "foobar" 3
# # output: bar
#
# String_slice "foobar" -1
# # output: r
# @end
String_slice() {
  if (($# >= 3)); then
    String_substr "$1" "$2" "$(($3 - $2))"
  else
    String_substr "$@"
  fi
}

# @desc divides the given string into an array of substrings
# @param string <string>
# @param delmiter <string> (optional)
# @return array of substrings <array>

# @example
# String_split "foo"
# # output: "f" "o" "o"
#
# String_split "f/ o /o" "/"
# # output: "f" " o " "o"
# @end
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

# @desc check if the given string starts with the specific prefix
# @param string <string>
# @param prefix <string>

# @example
# String_startsWith "foobar" "foo"
# # assert success
#
# String_startsWith "foobar" "oo"
# # assert failure
# @end
String_startsWith() {
  local string="${1:-}"
  local prefix="${2:-}"
  [[ "$string" == "$prefix"* ]]
}

# @desc remove the match pattern from the end
# @param string <string>
# @param pattern <string>
# @param greedy <int> (default 0)

# @example
# String_stripEnd "path/to/foo.sh" "/*"
# # output: path/to
#
# String_stripEnd "path/to/foo.sh" "/*" 1
# # output: path
# @end
String_stripEnd() {
  local string="${1:-}"
  local pattern="${2:-}"
  local -i greedy="${3:-0}"
  if ((greedy)); then
    # shellcheck disable=SC2295
    local res="${string%%$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    # shellcheck disable=SC2295
    local res="${string%$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

# @desc remove the match pattern from the beginning
# @param string <string>
# @param pattern <string>
# @param greedy <int> (default 0)

# @example
# String_stripStart "path/to/foo.sh" "*/"
# # output: to/foo.sh
#
# String_stripStart "path/to/foo.sh" "*/" 1
# # output: foo.sh
# @end
String_stripStart() {
  local string="${1:-}"
  local pattern="${2:-}"
  local -i greedy="${3:-0}"
  if ((greedy)); then
    # shellcheck disable=SC2295
    local res="${string##$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  else
    # shellcheck disable=SC2295
    local res="${string#$pattern}"
    RETVAL="$res"
    printf '%s\n' "$res"
  fi
}

# @desc extracts a given number of characters from the string
# @param string <string>
# @param beginIndex <int>
# @param length <int> (optional)
# @return new string <string>

# @example
# String_substr "foobar" 1 3
# # output: oob
#
# String_substr "foobar" 0 -1
# # output: fooba
#
# String_substr "foobar" -1
# # output: r
# @end
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

# @desc transform to lower case
# @param string <string>
# @return lower case string <string>

# @example
# String_toLowerCase "FOO"
# # output: foo
# @end
String_toLowerCase() {
  local string="${1:-}"
  local res="${string,,}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

# @desc transform to upper case
# @param string <string>
# @return upper case string <string>

# @example
# String_toLowerCase "foo"
# # output: FOO
# @end
String_toUpperCase() {
  local string="${1:-}"
  local res="${string^^}"
  RETVAL="$res"
  printf '%s\n' "$res"
}

# @desc removes the match pattern from both ends of a string
# @param string <string>
# @param pattern <optional>
# @return trimed string <string>

# @example
# String_trim "  foo bar   "
# # output: foo bar
#
# String_trim "__foo__bar___" "_"
# # output: foo__bar
# @end
String_trim() {
  local string="${1:-}"
  local pattern="${2:- }"
  String_trimStart "$@" >/dev/null
  local tmp="$RETVAL"
  String_trimEnd "$tmp" "$pattern"
}

# @desc removes the match pattern from the end of a string
# @param string <string>
# @param pattern <optional>
# @return trimed string <string>

# @example
# String_trimEnd " foo bar   "
# # output: " foo bar"
#
# String_trimEnd " foo--bar---" "-"
# # output: " foo--bar"
# @end
String_trimEnd() {
  local string="${1:-}"
  local pattern="${2:- }"
  local tmp=""
  local res=""
  String_stripStart "$string" "*[^$pattern]" 1 >/dev/null
  tmp="$RETVAL"
  String_stripEnd "$string" "$tmp" >/dev/null
  res="$RETVAL"
  RETVAL="$res"
  printf '%s\n' "$res"
}

# @desc removes the match pattern from the beginning of a string
# @param string <string>
# @param pattern <optional>
# @return trimed string <string>

# @example
# String_trimStart "   foo bar "
# # output: "foo bar "
#
# String_trimStart "---foo--bar" "-"
# # output: "foo--bar "
# @end
String_trimStart() {
  local string="${1:-}"
  local pattern="${2:- }"
  local tmp=""
  local res=""
  String_stripEnd "$string" "[^$pattern]*" 1 >/dev/null
  tmp="$RETVAL"
  String_stripStart "$string" "$tmp" >/dev/null
  res="$RETVAL"
  RETVAL="$res"
  printf '%s\n' "$res"
}

# @desc uncapitalize the first letter of the given string
# @param string <string>
# @return uncapitalized string <string>

# @example
# String_uncapitalize "FOO"
# # output: "fOO"
# @end
String_uncapitalize() {
  local string="${1:-}"
  local res="${string,}"
  RETVAL="$res"
  printf '%s\n' "$res"
}
