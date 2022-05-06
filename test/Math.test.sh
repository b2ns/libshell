#!/usr/bin/env bash
load test_helper.sh
load ../lib/Math.sh

function Math_random() { #@test
  run Math_random 10 15
  # shellcheck disable=SC2154
  assert [ "$output" -ge 10 ] && [ "$output" -lt 15 ]

  run Math_random 15 10
  assert [ "$output" -ge 10 ] && [ "$output" -lt 15 ]

  run Math_random -15 -10
  assert [ "$output" -ge -15 ] && [ "$output" -lt -10 ]
}

function Math_range() { #@test
  run Math_range -10 -5
  assert_output '-10 -9 -8 -7 -6 -5'

  run Math_range 5 10 2
  assert_output '5 7 9'

  run Math_range 10 5
  assert_output '5 6 7 8 9 10'
}
