#!/usr/bin/env bash
load test_helper.sh
load ../lib/Path.sh

Path_basename() { #@test
  run Path_basename "foo.sh"
  assert_output "foo.sh"

  run Path_basename "foo.sh" ".sh"
  assert_output "foo"

  run Path_basename "foo.sh" 1
  assert_output "foo"

  run Path_basename "./foo.sh"
  assert_output "foo.sh"

  run Path_basename "/foo.sh"
  assert_output "foo.sh"

  run Path_basename "../../path/to/foo.sh"
  assert_output "foo.sh"

  # shellcheck disable=SC2088
  run Path_basename "~/path/to/foo.sh"
  assert_output "foo.sh"

  run Path_basename "."
  assert_output "."

  run Path_basename "./"
  assert_output "."

  run Path_basename ".."
  assert_output ".."

  run Path_basename "../"
  assert_output ".."

  run Path_basename "./../"
  assert_output ".."

  run Path_basename "~"
  assert_output "~"

  run Path_basename "/"
  assert_output "/"

  run Path_basename ""
  assert_output "."

  run Path_basename "path/to/"
  assert_output "to"
}

Path_dirname() { #@test
  run Path_dirname "path/to/foo.sh"
  assert_output "path/to"

  run Path_dirname "foo.sh"
  assert_output "."

  run Path_dirname "./foo.sh"
  assert_output "."

  run Path_dirname "../foo.sh"
  assert_output ".."

  run Path_dirname "/foo.sh"
  assert_output "/"

  # shellcheck disable=SC2088
  run Path_dirname "~/foo.sh"
  assert_output "~"

  run Path_dirname "."
  assert_output "."

  run Path_dirname "./"
  assert_output "."

  run Path_dirname ".."
  assert_output "."

  run Path_dirname "../"
  assert_output "."

  run Path_dirname "./.."
  assert_output "."

  run Path_dirname "./../"
  assert_output "."

  run Path_dirname "../../"
  assert_output ".."

  run Path_dirname "~"
  assert_output "."

  run Path_dirname "/"
  assert_output "/"

  run Path_dirname "path/to/foo/"
  assert_output "path/to"
}

Path_extname() { #@test
  run Path_extname "foo.sh"
  assert_output ".sh"

  run Path_extname "./foo.sh"
  assert_output ".sh"

  run Path_extname "/foo.test.sh"
  assert_output ".sh"

  run Path_extname "foo"
  assert_output ""

  run Path_extname "."
  assert_output ""

  run Path_extname "./"
  assert_output ""

  run Path_extname ".."
  assert_output ""

  run Path_extname "~"
  assert_output ""

  run Path_extname "/"
  assert_output ""

  run Path_extname "path/to"
  assert_output ""

  run Path_extname "path/.to/.foo"
  assert_output ""
}

Path_isAbs() { #@test
  run Path_isAbs "/path/to/file.sh"
  assert_success

  run Path_isAbs "$HOME/path/to/file.sh"
  assert_success

  # shellcheck disable=SC2088
  run Path_isAbs "~/path/to/file.sh"
  assert_failure

  run Path_isAbs "./path/to/file.sh"
  assert_failure

  run Path_isAbs "path/to/file.sh"
  assert_failure
}

Path_isRel() { #@test
  run Path_isRel "./path/to/file.sh"
  assert_success

  run Path_isRel "path/to/file.sh"
  assert_success

  # shellcheck disable=SC2088
  run Path_isRel "~/path/to/file.sh"
  assert_success

  run Path_isRel "/path/to/file.sh"
  assert_failure

  run Path_isRel "$HOME/path/to/file.sh"
  assert_failure
}

Path_join() { #@test
  run Path_join "/path/to" "file.sh"
  assert_output "/path/to/file.sh"

  run Path_join "path/to/" "file.sh"
  assert_output "path/to/file.sh"

  run Path_join "./path/to/" "/file.sh"
  assert_output "path/to/file.sh"

  run Path_join ".////path////to/./././/." "./.file.sh"
  assert_output "path/to/.file.sh"

  run Path_join "/path/to/" "../file.sh"
  assert_output "/path/file.sh"

  run Path_join "path/to/" "../../file.sh"
  assert_output "file.sh"

  run Path_join "path/to/" "../foo/.."
  assert_output "path"

  run Path_join "/path/to/./" "../../../file.sh"
  assert_output "/file.sh"

  run Path_join "path/to" "../../../file.sh"
  assert_output "../file.sh"

  run Path_join "/path/to/.." "dir" "../.file.sh"
  assert_output "/path/.file.sh"

  run Path_join "/path/../to/" "dir" "../.file.sh"
  assert_output "/to/.file.sh"

  run Path_join "/path/to" "/../dir/../" "../.file.sh"
  assert_output "/.file.sh"

  run Path_join "/path/to/" ""
  assert_output "/path/to"

  run Path_join "" ".file.sh" ""
  assert_output ".file.sh"

  run Path_join "/" ""
  assert_output "/"

  run Path_join "./"
  assert_output "."

  run Path_join "../"
  assert_output ".."

  run Path_join "/.."
  assert_output "/"

  run Path_join
  assert_output "."
}

Path_resolve() { #@test
  run Path_resolve "./foo.sh"
  assert_output "$PWD/foo.sh"

  run Path_resolve "path/to" "../foo.sh"
  assert_output "$PWD/path/foo.sh"

  run Path_resolve "path/to" "/foo" "bar.sh"
  assert_output "/foo/bar.sh"

  run Path_resolve
  assert_output "$PWD"
}
