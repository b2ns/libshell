#!/usr/bin/env bash
load test_helper.sh
load ../lib/Args.sh

function Args_test() { #@test
  # define args accpected
  Args_define "-r --readonly" "Readonly"
  Args_define "-o --output" "Output" "<any>"
  Args_define "-j -job" "Running jobs" "<int>" 2
  Args_define "--te" "Truncation error" "<float>" 0.00001
  Args_define "-l --level" "Level of parse" "<num>" 3
  Args_define "-f --format" "Output format" "[json yaml toml xml csv]" "json"
  Args_define "-v -V --version" "Show version"
  Args_define "-h --help" "Show help"

  run Args_defined "-r"
  assert_success

  run Args_defined "--help"
  assert_success

  run Args_defined "--not-defined-flag"
  assert_failure

  run Args_has "-j"
  assert_success

  run Args_has "--readonly"
  assert_failure

  run Args_get "--te"
  assert_output "0.00001"
}

function Args_script_test() { #@test
  run ./test/Args.script.sh -r
  assert_output "Readonly"

  run ./test/Args.script.sh -o out.txt
  assert_output "Output: out.txt"

  run ./test/Args.script.sh -o=out.txt
  assert_output "Output: out.txt"

  run ./test/Args.script.sh --job 9
  assert_output "Too many jobs"

  run ./test/Args.script.sh --job 9.0
  assert_failure

  run ./test/Args.script.sh --readonly -V
  assert_line -n 0 "Readonly"
  assert_line -n 1 "Version: 1.0.0"

  run ./test/Args.script.sh -f yaml
  assert_success

  run ./test/Args.script.sh --format unkownone
  assert_failure

  run ./test/Args.script.sh foo.txt bar.txt --show-input-file
  assert_output "Input files: foo.txt bar.txt"

  run ./test/Args.script.sh --show-input-file a.txt b.txt
  assert_output "Input files: a.txt b.txt"

  run ./test/Args.script.sh --not-defined-flag
  assert_failure
}
