#!/usr/bin/env bash
load test_helper.sh
load ../lib/Path.sh

Path_dirName() { #@test
  run Path_dirName "path/to/foo.sh"
  assert_output "path/to"

  run Path_dirName "foo.sh"
  assert_output "."

  run Path_dirName "./foo.sh"
  assert_output "."

  run Path_dirName "../foo.sh"
  assert_output ".."

  run Path_dirName "/foo.sh"
  assert_output "/"

  # shellcheck disable=SC2088
  run Path_dirName "~/foo.sh"
  assert_output "~"

  run Path_dirName "."
  assert_output "."

  run Path_dirName "./"
  assert_output "."

  run Path_dirName ".."
  assert_output "."

  run Path_dirName "../"
  assert_output "."

  run Path_dirName "./.."
  assert_output "."

  run Path_dirName "./../"
  assert_output "."

  run Path_dirName "../../"
  assert_output ".."

  run Path_dirName "~"
  assert_output "."

  run Path_dirName "/"
  assert_output "/"

  run Path_dirName "path/to/foo/"
  assert_output "path/to"
}

Path_dirname() { #@test
  run Path_dirname "path/to/foo.sh"
  assert_output "to"

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
  assert_output "to"
}

Path_dirpath() { #@test
  local tmpFilename="__test_path_dirpath__.ext"
  local tmpDirname="__test_path_dirpath_dir__"

  makeDir "$HOME/$tmpDirname"
  makeFile "$HOME/$tmpDirname/$tmpFilename"
  makeDir "$tmpDirname"
  makeFile "$tmpDirname/$tmpFilename"
  makeDir "../$tmpDirname"
  makeFile "../$tmpDirname/$tmpFilename"
  
  local parentDir=$(cd .. && pwd)

  local file="$HOME/$tmpDirname"
  run Path_dirpath "$file"
  assert_output "$HOME"

  # shellcheck disable=SC2088
  run Path_dirpath "~/$tmpDirname/$tmpFilename"
  assert_output "$HOME/$tmpDirname"

  file="$tmpDirname"
  run Path_dirpath "$file"
  assert_output "$(cd "$file/.." && pwd)"

  file="./$tmpDirname/$tmpFilename"
  run Path_dirpath "$file"
  assert_output "$(cd "$(dirname "$file")" && pwd)"

  file="../$tmpDirname"
  run Path_dirpath "$file"
  assert_output "$(cd "$file/.." && pwd)"

  file="../$tmpDirname/$tmpFilename"
  run Path_dirpath "$file"
  assert_output "$(cd "$(dirname "$file")" && pwd)"

  run Path_dirpath "."
  assert_output "$parentDir"
  # assert_output "pwd"

  run Path_dirpath "$HOME/file/not/exist"
  assert_failure


  cleanFile "$HOME/$tmpDirname/$tmpFilename"
  cleanFile "$HOME/$tmpDirname"
  cleanFile "$tmpDirname/$tmpFilename"
  cleanFile "$tmpDirname"
  cleanFile "../$tmpDirname/$tmpFilename"
  cleanFile "../$tmpDirname"
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

Path_filepath() { #@test
  local tmpFilename="__test_path_filepath__.ext"
  local tmpDirname="__test_path_filepath_dir__"

  makeDir "$HOME/$tmpDirname"
  makeFile "$HOME/$tmpDirname/$tmpFilename"
  makeDir "$tmpDirname"
  makeFile "$tmpDirname/$tmpFilename"
  makeDir "../$tmpDirname"
  makeFile "../$tmpDirname/$tmpFilename"
  
  local curpwd=$(pwd)

  local file="$HOME/$tmpDirname"
  run Path_filepath "$file"
  assert_output "$file"

  # shellcheck disable=SC2088
  run Path_filepath "~/$tmpDirname/$tmpFilename"
  assert_output "$HOME/$tmpDirname/$tmpFilename"

  file="$tmpDirname"
  run Path_filepath "$file"
  assert_output "$(cd "$file" && pwd)"

  file="./$tmpDirname/$tmpFilename"
  run Path_filepath "$file"
  assert_output "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"

  file="../$tmpDirname"
  run Path_filepath "$file"
  assert_output "$(cd "$file" && pwd)"

  file="../$tmpDirname/$tmpFilename"
  run Path_filepath "$file"
  assert_output "$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"

  run Path_filepath "."
  assert_output "$curpwd"

  run Path_filepath "$HOME/file/not/exist"
  assert_failure

  cleanFile "$HOME/$tmpDirname/$tmpFilename"
  cleanFile "$HOME/$tmpDirname"
  cleanFile "$tmpDirname/$tmpFilename"
  cleanFile "$tmpDirname"
  cleanFile "../$tmpDirname/$tmpFilename"
  cleanFile "../$tmpDirname"
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

Path_pathnoext() { #@test
  local tmpFilename="__test_path_pathnoext__.ext"
  local tmpFilenoext="__test_path_pathnoext__"
  local tmpDirname="__test_path_pathnoext_dir__"

  makeDir "$HOME/$tmpDirname"
  makeFile "$HOME/$tmpDirname/$tmpFilename"
  makeDir "$tmpDirname"
  makeFile "$tmpDirname/$tmpFilename"

  local file="$HOME/$tmpDirname"
  run Path_pathnoext "$file"
  assert_output "$file"

  file="./$tmpDirname/$tmpFilename"
  run Path_pathnoext "$file"
  assert_output "$(cd "$(dirname "$file")" && pwd)/$tmpFilenoext"

  run Path_pathnoext "$HOME/file/not/exist"
  assert_failure

  cleanFile "$HOME/$tmpDirname/$tmpFilename"
  cleanFile "$HOME/$tmpDirname"
  cleanFile "$tmpDirname/$tmpFilename"
  cleanFile "$tmpDirname"
}
