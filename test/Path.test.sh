#!/usr/bin/env bash
load test_helper.sh
load ../lib/Path.sh

declare -ga files
files=(
  "[dir]:$HOME/__Path_dirpath"
  "$HOME/__Path_dirpath/__Path_dirpath.ext"
  "[dir]:__Path_dirpath"
  "__Path_dirpath/__Path_dirpath.ext"
  "[dir]:../__Path_dirpath"
  "../__Path_dirpath/__Path_dirpath.ext"

  "[dir]:$HOME/__Path_filepath"
  "$HOME/__Path_filepath/__Path_filepath.ext"
  "[dir]:__Path_filepath"
  "__Path_filepath/__Path_filepath.ext"
  "[dir]:../__Path_filepath"
  "../__Path_filepath/__Path_filepath.ext"

  "[dir]:__Path_pathnoext"
  "__Path_pathnoext/__Path_pathnoext.ext"
  "__Path_pathnoext/.__Path_pathnoext"
)

setup_file() {
  setupFiles "${files[@]}"
}

teardown_file() {
  teardownFiles "${files[@]}"
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

Path_dirpath() { #@test
  run Path_dirpath "$HOME/__Path_dirpath"
  assert_output "$HOME"

  # shellcheck disable=SC2088
  run Path_dirpath "~/__Path_dirpath/__Path_dirpath.ext"
  assert_output "$HOME/__Path_dirpath"

  run Path_dirpath "__Path_dirpath"
  assert_output "$(cd "__Path_dirpath/.." && pwd)"

  run Path_dirpath "__Path_dirpath/__Path_dirpath.ext"
  assert_output "$(cd "__Path_dirpath" && pwd)"

  run Path_dirpath "../__Path_dirpath"
  assert_output "$(cd ".." && pwd)"

  run Path_dirpath "../__Path_dirpath/__Path_dirpath.ext"
  assert_output "$(cd "../__Path_dirpath" && pwd)"

  run Path_dirpath "."
  assert_output "$(cd .. && pwd)"

  run Path_dirpath "$HOME/file/not/exist"
  assert_failure
}

Path_expandTilde() { #@test
  run Path_expandTilde "~"
  assert_output "$HOME"
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

Path_filename() { #@test
  run Path_filename "foo.sh"
  assert_output "foo.sh"

  run Path_filename "./foo.sh"
  assert_output "foo.sh"

  run Path_filename "/foo.sh"
  assert_output "foo.sh"

  run Path_filename "../../path/to/foo.sh"
  assert_output "foo.sh"

  # shellcheck disable=SC2088
  run Path_filename "~/path/to/foo.sh"
  assert_output "foo.sh"

  run Path_filename "."
  assert_output "."

  run Path_filename "./"
  assert_output "."

  run Path_filename ".."
  assert_output ".."

  run Path_filename "../"
  assert_output ".."

  run Path_filename "./../"
  assert_output ".."

  run Path_filename "~"
  assert_output "~"

  run Path_filename "/"
  assert_output "/"

  run Path_filename ""
  assert_output "."

  run Path_filename "path/to/"
  assert_output "to"
}

Path_filenoext() { #@test
  run Path_filenoext "foo.sh"
  assert_output "foo"

  run Path_filenoext "./foo.test.sh"
  assert_output "foo.test"

  run Path_filenoext "."
  assert_output "."

  run Path_filenoext "./"
  assert_output "."

  run Path_filenoext ".."
  assert_output ".."

  run Path_filenoext "~"
  assert_output "~"

  run Path_filenoext "/"
  assert_output "/"

  run Path_filenoext "path/to/"
  assert_output "to"

  run Path_filenoext "path/.to"
  assert_output ".to"
}

Path_filepath() { #@test
  run Path_filepath "$HOME/__Path_filepath"
  assert_output "$HOME/__Path_filepath"

  # shellcheck disable=SC2088
  run Path_filepath "~/__Path_filepath/__Path_filepath.ext"
  assert_output "$HOME/__Path_filepath/__Path_filepath.ext"

  run Path_filepath "__Path_filepath"
  assert_output "$(cd "__Path_filepath" && pwd)"

  run Path_filepath "__Path_filepath/__Path_filepath.ext"
  assert_output "$(cd "__Path_filepath" && pwd)/__Path_filepath.ext"

  run Path_filepath "../__Path_filepath"
  assert_output "$(cd ".." && pwd)/__Path_filepath"

  run Path_filepath "../__Path_filepath/__Path_filepath.ext"
  assert_output "$(cd "../__Path_filepath" && pwd)/__Path_filepath.ext"

  run Path_filepath "."
  assert_output "$(pwd)"

  run Path_filepath "$HOME/file/not/exist"
  assert_failure
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

Path_pathnoext() { #@test
  run Path_pathnoext "__Path_pathnoext"
  assert_output "$(cd "__Path_pathnoext" && pwd)"

  run Path_pathnoext "__Path_pathnoext/__Path_pathnoext.ext"
  assert_output "$(cd "__Path_pathnoext" && pwd)/__Path_pathnoext"

  run Path_pathnoext "__Path_pathnoext/.__Path_pathnoext"
  assert_output "$(cd "__Path_pathnoext" && pwd)/.__Path_pathnoext"

  run Path_pathnoext "$HOME/file/not/exist"
  assert_failure
}
