#!/usr/bin/env bash
load test_helper.sh
load ../lib/IO.sh

IO_error() { #@test
  local output=""
  run IO_error "foo"
  output="$(echo -e "\e[31;1mfoo\e[39;22m")"
  assert_output "$output"
}
