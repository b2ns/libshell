#!/usr/bin/env bash
load test_helper.sh
load ../lib/Array.sh

function setup() {
  function gt5() {
    (($1 > 5)) && return 0
    return 1
  }

  function double() {
    echo $(($1 * 2))
  }
}

function Array_concat() { #@test
  local -a arr1=(1 2)
  local -a arr2=("foo" " bar")
  run Array_concat "${arr1[@]}" "${arr2[@]}"
  assert_line -n 0 1
  assert_line -n 1 2
  assert_line -n 2 "foo"
  assert_line -n 3 " bar"
}

function Array_every() { #@test
  local -a arr=(6 7 8)
  run Array_every "${arr[@]}" gt5
  assert_success

  local -a arr=(6 5 8)
  run Array_every "${arr[@]}" gt5
  assert_failure
}

function Array_filter() { #@test
  local -a arr=(6 1 8)
  run Array_filter "${arr[@]}" gt5
  assert_line -n 0 6
  assert_line -n 1 8
}

function Array_find() { #@test
  local -a arr=("foo" "bar111" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_success

  local -a arr=("foo" "bar" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_failure
}

function Array_findIndex() { #@test
  local -a arr=("foo" "bar111" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_output 1

  local -a arr=("foo" "bar" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_output -1
}

function Array_forEach() { #@test
  local -a arr=(1 2 3)
  run Array_forEach "${arr[@]}" echo
  assert_line -n 0 "1 0"
  assert_line -n 1 "2 1"
  assert_line -n 2 "3 2"
}

function Array_includes() { #@test
  local -a arr=(1 2 3)
  run Array_includes "${arr[@]}" 2
  assert_success

  run Array_includes "${arr[@]}" 4
  assert_failure
}

function Array_indexOf() { #@test
  local -a arr=(1 2 3)
  run Array_indexOf "${arr[@]}" 2
  assert_output 1

  run Array_indexOf "${arr[@]}" 4
  assert_output -1
}

function Array_join() { #@test
  local -a arr=(1 2 3)
  run Array_join "${arr[@]}" ","
  assert_output "1,2,3"

  run Array_join "${arr[@]}" ""
  assert_output "123"
}

function Array_last() { #@test
  local -a arr=(1 2 3)
  run Array_last "${arr[@]}"
  assert_output 3
}

function Array_length() { #@test
  local -a arr=(1 2 3)
  run Array_length "${arr[@]}"
  assert_output 3
}

function Array_map() { #@test
  local -a arr=(1 2 3)
  run Array_map "${arr[@]}" double
  assert_line -n 0 2
  assert_line -n 1 4
  assert_line -n 2 6
}

function Array_push() { #@test
  local -a arr=(1 2)
  run Array_push "${arr[@]}" 3
  assert_line -n 0 1
  assert_line -n 1 2
  assert_line -n 2 3
}

function Array_reverse() { #@te
  local -a arr=(1 2 3)
  run Array_reverse "${arr[@]}"
  assert_line -n 0 3
  assert_line -n 1 2
  assert_line -n 2 1
}

function Array_slice() { #@te
  local -a arr=(1 2 3 4 5)
  run Array_slice "${arr[@]}" 0 1
  assert_line -n 0 1

  run Array_slice "${arr[@]}" 1 3
  assert_line -n 0 2
  assert_line -n 1 3
  assert_line -n 2 ""

  run Array_slice "${arr[@]}" 3 -1
  assert_line -n 0 4
  assert_line -n 1 5
}

function Array_some() { #@test
  local -a arr=(1 2 6)
  run Array_some "${arr[@]}" gt5
  assert_success

  local -a arr=(1 2 3)
  run Array_some "${arr[@]}" gt5
  assert_failure
}

function Array_sort() { #@test
  local -a arr=(6 1 5 2 5 3 5 8)
  run Array_sort "${arr[@]}"
  # shellcheck disable=SC2154
  readarray -t res <<<"$output"
  assert_equal "${res[*]}" "1 2 3 5 5 5 6 8"

  function foo() {
    function comparator() {
      if (($1 > $2)); then
        echo -1
      elif (($1 < $2)); then
        echo 1
      else
        echo 0
      fi
    }
    COMPARATOR=comparator Array_sort "${arr[@]}"
  }
  run foo
  # shellcheck disable=SC2154
  readarray -t res <<<"$output"
  assert_equal "${res[*]}" "8 6 5 5 5 3 2 1"
}

function Array_sub() { #@te
  local -a arr=(1 2 3 4 5)
  run Array_sub "${arr[@]}" 0 1
  assert_line -n 0 1

  run Array_sub "${arr[@]}" 1 3
  assert_line -n 0 2
  assert_line -n 1 3
  assert_line -n 2 4

  run Array_sub "${arr[@]}" 3 -1
  assert_line -n 0 4
  assert_line -n 1 5
}
