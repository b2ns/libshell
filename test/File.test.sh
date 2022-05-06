#!/usr/bin/env bash
load test_helper.sh
load ../lib/File.sh

function File_isDir() { #@test
  run File_isDir "./test"
  assert_success

  run File_isDir "./test/File.test.sh"
  assert_failure
}

function File_isEmpty() { #@test
  local tmpFilename="__test_file_isempty__.ext"
  makeFile "$tmpFilename"

  run File_isEmpty "$tmpFilename"
  assert_success

  run File_isEmpty "./test/File.test.sh"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_isExecutable() { #@test
  local tmpFilename="__test_file_isexecutable__.ext"
  makeFile "$tmpFilename"

  chmod +x "$tmpFilename"
  run File_isExecutable "$tmpFilename"
  assert_success

  chmod -x "$tmpFilename"
  run File_isExecutable "$tmpFilename"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_isExist() { #@test
  run File_isExist "./test"
  assert_success

  run File_isExist "./test/File.test.sh"
  assert_success

  run File_isExist "./test/File.not.exist"
  assert_failure
}

function File_isFile() { #@test
  run File_isFile "./test/File.test.sh"
  assert_success

  run File_isFile "./test"
  assert_failure

  run File_isFile "./test/File.not.exist"
  assert_failure
}

function File_isNotEmpty() { #@test
  local tmpFilename="__test_file_isnotempty__.ext"
  makeFile "$tmpFilename"

  run File_isNotEmpty "./test/File.test.sh"
  assert_success

  run File_isNotEmpty "$tmpFilename"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_isReadable() { #@test
  local tmpFilename="__test_file_isreadable__.ext"
  makeFile "$tmpFilename"

  run File_isReadable "$tmpFilename"
  assert_success

  chmod -r "$tmpFilename"
  run File_isReadable "$tmpFilename"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_isSame() { #@test
  run File_isSame "./test/File.test.sh" "./test/File.test.sh"
  assert_success

  run File_isSame "./test/File.test.sh" "./test/Path.test.sh"
  assert_failure
}

function File_isSymlink() { #@test
  local tmpFilename="__test_file_issymlink__.ext"
  ln -s "./test/File.test.sh" "$tmpFilename"

  run File_isSymlink "$tmpFilename"
  assert_success

  run File_isSymlink "./test/File.test.sh"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_isWritable() { #@test
  local tmpFilename="__test_file_iswritable__.ext"
  makeFile "$tmpFilename"

  run File_isWritable "$tmpFilename"
  assert_success

  chmod -w "$tmpFilename"
  run File_isWritable "$tmpFilename"
  assert_failure

  cleanFile "$tmpFilename"
}

function File_mkdir() { #@test
  local tmpDirname="__test_file_mkdir_dir__/path/to/dir"

  run File_mkdir "$tmpDirname"
  assert_dir_exists "$tmpDirname"

  rmdir -p "$tmpDirname"
}

function File_mkfile() { #@test
  local tmpFilename="__test_file_mkfile__/path/to/foo.ext"

  run File_mkfile "$tmpFilename"
  assert_exists "$tmpFilename"

  cleanFile "$tmpFilename"
  rmdir -p "${tmpFilename%/*}"
}

