#!/usr/bin/env bash
load test_helper.sh
load ../lib/Math.sh

Math_abs() { #@test
  run Math_abs -1
  assert_output 1

  run Math_abs 1
  assert_output 1

  run Math_abs 0
  assert_output 0
}

Math_max() { #@test
  run Math_max 3 2 9 8 1 2 5
  assert_output 9
}

Math_min() { #@test
  run Math_min 3 2 9 8 1 2 5
  assert_output 1
}

Math_random() { #@test
  run Math_random 10 15
  # shellcheck disable=SC2154
  assert [ "$output" -ge 10 ] && [ "$output" -lt 15 ]

  run Math_random 15 10
  assert [ "$output" -ge 10 ] && [ "$output" -lt 15 ]

  run Math_random -15 -10
  assert [ "$output" -ge -15 ] && [ "$output" -lt -10 ]
}

Math_range() { #@test
  run Math_range -10 -5
  assert_output '-10 -9 -8 -7 -6 -5'

  run Math_range 5 10 2
  assert_output '5 7 9'

  run Math_range 10 5
  assert_output '5 6 7 8 9 10'
}
