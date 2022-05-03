#!/usr/bin/env bash
function setup() {
  load test_helper.sh
  load ../lib/File.sh
}

function file_mkfile() { #@test
  run File_mkfile
  assert_output "TODO"
}
