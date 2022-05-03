#!/usr/bin/env bash
function setup() {
  load test_helper.sh
  load ../lib/Path.sh
}

function path_dirpath() { #@test
  run Path_dirpath
  assert_output "TODO"
}

function path_filepath() { #@test
  run Path_filepath
  assert_output "TODO"
}
