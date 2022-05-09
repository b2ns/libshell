#!/usr/bin/env bash
load test_helper.sh
load ../lib/String.sh

String_at() { #@test
  run String_at "bar" 0
  assert_output "b"

  run String_at "bar" -1
  assert_output "r"

  run String_at "bar" 2
  assert_output "r"

  run String_at "bar" 3
  assert_output ""

  run String_at "bar" -4
  assert_output ""
}

String_capitalize() { #@test
  run String_capitalize "foo"
  assert_output "Foo"
}

String_concat() { #@test
  run String_concat "foo" "bar " "x" "/y" "/z"
  assert_output "foobar x/y/z"
}

String_endsWith() { #@test
  run String_endsWith "foobar" "bar"
  assert_success

  run String_endsWith "foobar" "ba"
  assert_failure
}

String_eq() { #@test
  run String_eq "foo" "foo"
  assert_success

  run String_eq "foo" "fox"
  assert_failure
}

String_includes() { #@test
  run String_includes "foo bar" "bar"
  assert_success

  run String_includes "foo bar" "baz"
  assert_failure

  run String_includes "foo" "foobar"
  assert_failure
}

String_indexOf() { #@test
  run String_indexOf "foo barbar" "bar"
  assert_output 4

  run String_indexOf "foo bar" "baz"
  assert_output -1

  run String_indexOf "foo" "foobar"
  assert_output -1
}

String_isEmpty() { #@test
  run String_isEmpty "foo"
  assert_failure

  run String_isEmpty ""
  assert_success

  run String_isEmpty
  assert_success
}

String_isNotEmpty() { #@test
  run String_isNotEmpty "foo"
  assert_success

  run String_isNotEmpty ""
  assert_failure

  run String_isNotEmpty
  assert_failure
}

String_join() { #@test
  run String_join " a" " b" " c " "_"
  assert_output " a_ b_ c "

  run String_join "a" "b" "c" ""
  assert_output "abc"
}

String_length() { #@test
  run String_length "foo"
  assert_output 3

  run String_length " foo "
  assert_output 5

  run String_length
  assert_output 0
}

String_match() { #@test
  run String_match "foo12o bar" "^foo[0-9]+o"
  assert_success

  run String_match "foo bar   " "bar +$"
  assert_success

  run String_match "foo1 bar" "^foo$"
  assert_failure
}

String_padEnd() { #@test
  run String_padEnd "foo" 5
  assert_output "foo  "

  run String_padEnd "foo" 6 "-"
  assert_output "foo---"
}

String_padStart() { #@test
  run String_padStart "foo" 5
  assert_output "  foo"

  run String_padStart "foo" 6 "-"
  assert_output "---foo"
}

String_repeat() { #@test
  run String_repeat "a" 3
  assert_output "aaa"

  run String_repeat " " 4
  assert_output "    "
}

String_replace() { #@test
  run String_replace "foo bar" "bar" "baz"
  assert_output "foo baz"

  run String_replace " foo bar" "bar" ""
  assert_output " foo "

  run String_replace "foo bar foobar" "bar" "baz"
  assert_output "foo baz foobar"
}

String_replaceAll() { #@test
  run String_replaceAll "foo bar foobar" "bar" "baz"
  assert_output "foo baz foobaz"
}

String_reverse() { #@test
  run String_reverse "abcd"
  assert_output "dcba"
}

String_slice() { #@test
  run String_slice "foobar" 0 3
  assert_output "foo"

  run String_slice "foobar" 0 100
  assert_output "foobar"

  run String_slice "foobar" 0 -1
  assert_output "fooba"

  run String_slice "foobar" 1 3
  assert_output "oo"

  run String_slice "foobar" 3
  assert_output "foo"

  run String_slice "foobar" -1
  assert_output "fooba"

  run String_slice "foobar" -3 -1
  assert_output "ba"

  run String_slice "foobar"
  assert_output "foobar"
}

String_substr() { #@test
  run String_substr "foobar" 0 3
  assert_output "foo"

  run String_substr "foobar" 0 100
  assert_output "foobar"

  run String_substr "foobar" 0 -1
  assert_output "fooba"

  run String_substr "foobar" 1 3
  assert_output "oob"

  run String_substr "foobar" 3
  assert_output "foo"

  run String_substr "foobar" -1
  assert_output "fooba"

  run String_substr "foobar" -3 -1
  assert_output "ba"

  run String_substr "foobar"
  assert_output "foobar"
}

String_split() { #@test
  run String_split "foo" ""
  assert_line -n 0 "f"
  assert_line -n 1 "o"
  assert_line -n 2 "o"

  run String_split "f o o" " "
  assert_line -n 0 "f"
  assert_line -n 1 "o"
  assert_line -n 2 "o"

  run String_split "f/o/o" "/"
  assert_line -n 0 "f"
  assert_line -n 1 "o"
  assert_line -n 2 "o"

  run String_split " f - o - o " "-"
  assert_line -n 0 " f "
  assert_line -n 1 " o "
  assert_line -n 2 " o "
}

String_startsWith() { #@test
  run String_startsWith "foobar" "foo"
  assert_success

  run String_startsWith "foobar" "oo"
  assert_failure
}

String_toLowerCase() { #@test
  run String_toLowerCase "FOO"
  assert_output "foo"
}

String_toUpperCase() { #@test
  run String_toUpperCase "foo"
  assert_output "FOO"
}

String_trim() { #@test
  run String_trim "foo bar   "
  assert_output "foo bar"

  run String_trim "   foo bar"
  assert_output "foo bar"

  run String_trim "  foo bar   "
  assert_output "foo bar"
}

String_trimEnd() { #@test
  run String_trimEnd "foo bar   "
  assert_output "foo bar"

  run String_trimEnd " foo bar   "
  assert_output " foo bar"

  run String_trimEnd "path/to/foo.sh" "/*"
  assert_output "path/to"

  run String_trimEnd "path/to/foo.sh" "/*" 1
  assert_output "path"
}

String_trimStart() { #@test
  run String_trimStart "   foo bar"
  assert_output "foo bar"

  run String_trimStart "   foo bar "
  assert_output "foo bar "

  run String_trimStart "path/to/foo.sh" "*/"
  assert_output "to/foo.sh"

  run String_trimStart "path/to/foo.sh" "*/" 1
  assert_output "foo.sh"
}

String_uncapitalize() { #@test
  run String_uncapitalize "FOO"
  assert_output "fOO"
}
