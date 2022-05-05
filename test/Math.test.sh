#!/usr/bin/env bash
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
