#!/usr/bin/env bash
load test_helper.sh
load ../lib/File.sh

declare -ga files
files=(
  "__File_isEmpty.ext"
  "__File_isExecutable.ext"
  "__File_notEmpty.ext"
  "__File_isReadable.ext"
  "[nocreate]:__File_isSymlink.ext"
  "__File_isWritable.ext"
  "[nocreate]:__File_mkdir"
  "[nocreate]:__File_mkdir/path"
  "[nocreate]:__File_mkdir/path/to"
  "[nocreate]:__File_mkfile"
  "[nocreate]:__File_mkfile/path"
  "[nocreate]:__File_mkfile/path/to"
  "[nocreate]:__File_mkfile/path/to/file.ext"
)

setup_file() {
  setupFiles "${files[@]}"
}

teardown_file() {
  teardownFiles "${files[@]}"
}

File_isDir() { #@test
  run File_isDir "./test"
  assert_success

  run File_isDir "./test/File.test.sh"
  assert_failure
}

File_isEmpty() { #@test
  local file="__File_isEmpty.ext"

  run File_isEmpty "$file"
  assert_success

  run File_isEmpty "./test/File.test.sh"
  assert_failure
}

File_isExecutable() { #@test
  local file="__File_isExecutable.ext"

  chmod +x "$file"
  run File_isExecutable "$file"
  assert_success

  chmod -x "$file"
  run File_isExecutable "$file"
  assert_failure
}

File_isExist() { #@test
  run File_isExist "./test"
  assert_success

  run File_isExist "./test/File.test.sh"
  assert_success

  run File_isExist "./test/File.not.exist"
  assert_failure
}

File_isFile() { #@test
  run File_isFile "./test/File.test.sh"
  assert_success

  run File_isFile "./test"
  assert_failure

  run File_isFile "./test/File.not.exist"
  assert_failure
}

File_isReadable() { #@test
  local file="__File_isReadable.ext"

  run File_isReadable "$file"
  assert_success

  chmod a-r "$file"
  run File_isReadable "$file"
  assert_failure
}

File_isSame() { #@test
  run File_isSame "./test/File.test.sh" "./test/File.test.sh"
  assert_success

  run File_isSame "./test/File.test.sh" "./test/Path.test.sh"
  assert_failure
}

File_isSymlink() { #@test
  local file="__File_isSymlink.ext"
  ln -s "./test/File.test.sh" "$file"

  run File_isSymlink "$file"
  assert_success

  run File_isSymlink "./test/File.test.sh"
  assert_failure
}

File_isWritable() { #@test
  local file="__File_isWritable.ext"

  chmod +w "$file"
  run File_isWritable "$file"
  assert_success

  chmod -w "$file"
  run File_isWritable "$file"
  assert_failure
}

File_mkdir() { #@test
  local dir="__File_mkdir/path/to"

  run File_mkdir "$dir"
  assert_dir_exists "$dir"
}

File_mkfile() { #@test
  local file="__File_mkfile/path/to/file.ext"

  run File_mkfile "$file"
  assert_exists "$file"
}

File_notEmpty() { #@test
  local file="__File_notEmpty.ext"

  run File_notEmpty "./test/File.test.sh"
  assert_success

  run File_notEmpty "$file"
  assert_failure
}
