#!/usr/bin/env bash
load test_helper.sh
load ../lib/Array.sh

setup() {
  gt5() {
    (($1 > 5)) && return 0
    return 1
  }

  double() {
    echo $(($1 * 2))
  }
}

Array_every() { #@test
  local -a arr=(6 7 8)
  run Array_every "${arr[@]}" gt5
  assert_success

  local -a arr=(6 5 8)
  run Array_every "${arr[@]}" gt5
  assert_failure
}

Array_filter() { #@test
  local -a arr=(6 1 8)
  run Array_filter "${arr[@]}" gt5
  assert_line -n 0 6
  assert_line -n 1 8
}

Array_find() { #@test
  local -a arr=("foo" "bar111" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_success

  local -a arr=("foo" "bar" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_failure
}

Array_findIndex() { #@test
  local -a arr=("foo" "bar111" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_output 1

  local -a arr=("foo" "bar" "baz")
  run Array_find "${arr[@]}" "[a-z]+[0-9]+"
  assert_output -1
}

Array_forEach() { #@test
  local -a arr=(1 2 3)
  run Array_forEach "${arr[@]}" echo
  assert_line -n 0 "1 0"
  assert_line -n 1 "2 1"
  assert_line -n 2 "3 2"
}

Array_includes() { #@test
  local -a arr=(1 2 3)
  run Array_includes "${arr[@]}" 2
  assert_success

  run Array_includes "${arr[@]}" 4
  assert_failure
}

Array_indexOf() { #@test
  local -a arr=(1 2 3)
  run Array_indexOf "${arr[@]}" 2
  assert_output 1

  run Array_indexOf "${arr[@]}" 4
  assert_output -1
}

Array_join() { #@test
  local -a arr=(1 2 3)
  run Array_join "${arr[@]}" ","
  assert_output "1,2,3"

  run Array_join "${arr[@]}" ""
  assert_output "123"
}

Array_length() { #@test
  local -a arr=(1 2 3)
  run Array_length "${arr[@]}"
  assert_output 3
}

Array_map() { #@test
  local -a arr=(1 2 3)
  run Array_map "${arr[@]}" double
  assert_line -n 0 2
  assert_line -n 1 4
  assert_line -n 2 6
}

Array_reverse() { #@te
  local -a arr=(1 2 3)
  run Array_reverse "${arr[@]}"
  assert_line -n 0 3
  assert_line -n 1 2
  assert_line -n 2 1
}

Array_some() { #@test
  local -a arr=(1 2 6)
  run Array_some "${arr[@]}" gt5
  assert_success

  local -a arr=(1 2 3)
  run Array_some "${arr[@]}" gt5
  assert_failure
}

Array_sort() { #@test
  local -a arr=(6 1 5 2 5 3 5 8)
  run Array_sort "${arr[@]}"
  # shellcheck disable=SC2154
  readarray -t res <<<"$output"
  assert_equal "${res[*]}" "1 2 3 5 5 5 6 8"

  foo() {
    comparator() {
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
