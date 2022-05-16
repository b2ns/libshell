#!/usr/bin/env bash
load test_helper.sh
load ../lib/Args.sh

Args_test() { #@test
  run ./test/Args.script.sh -r -p 123
  assert_output "Readonly"

  run ./test/Args.script.sh -o out.txt -p=123
  assert_output "Output: out.txt"

  run ./test/Args.script.sh -o=out.txt -p=123
  assert_output "Output: out.txt"

  run ./test/Args.script.sh --job 9 -p=123
  assert_output "Too many jobs"

  run ./test/Args.script.sh --job 9.0 -p=123
  assert_failure

  run ./test/Args.script.sh -r -v -j=9 -p=123
  assert_line -n 0 "Readonly"
  assert_line -n 1 "Too many jobs"
  assert_line -n 2 "Version: 1.0.0"

  run ./test/Args.script.sh -rvj9 -p=123
  assert_line -n 0 "Readonly"
  assert_line -n 1 "Too many jobs"
  assert_line -n 2 "Version: 1.0.0"

  run ./test/Args.script.sh -f csv -p123
  assert_success

  run ./test/Args.script.sh --format unkownone -p=123
  assert_failure

  run ./test/Args.script.sh -p=123 -c=custxm
  assert_output "Expected 'custom', got 'custxm'"
  assert_failure

  run ./test/Args.script.sh foo.txt bar.txt --show-input-file -p=123 -- --job
  assert_output "Input files: foo.txt bar.txt --job"

  run ./test/Args.script.sh --not-defined-flag
  assert_failure
}
