#!/usr/bin/env bash

import Path

# @desc check if the given path is a directory
# @param path <string>

# @example
# File_isDir "~/Desktop"
# @end
File_isDir() {
  [[ -d "$1" ]]
}

# @desc check if the given path is a empty file
# @param path <string>

# @example
# File_isEmpty "foo.sh"
# @end
File_isEmpty() {
  ! File_notEmpty "$@"
}

# @desc check if the given path is executable
# @param path <string>

# @example
# File_isExecutable "foo.sh"
# @end
File_isExecutable() {
  [[ -x "$1" ]]
}

# @desc check if the given path exists
# @param path <string>

# @example
# File_isExist "foo.sh"
# @end
File_isExist() {
  [[ -e "$1" ]]
}

# @desc check if the given path is a file
# @param path <string>

# @example
# File_isFile "foo.sh"
# @end
File_isFile() {
  [[ -f "$1" ]]
}

# @desc check if the given path is readable
# @param path <string>

# @example
# File_isReadable "foo.sh"
# @end
File_isReadable() {
  [[ -r "$1" ]]
}

# @desc check if the given paths are the same file
# @param path1 <string>
# @param path2 <string>

# @example
# File_isSame "foo.sh" "~/Desktop/foo.sh"
# @end
File_isSame() {
  [[ "$1" -ef "$2" ]]
}

# @desc check if the given path is a symbolic link
# @param path <string>

# @example
# File_isSymlink "foo.sh"
# @end
File_isSymlink() {
  [[ -L "$1" ]]
}

# @desc check if the given path is writable
# @param path <string>

# @example
# File_isWritable "foo.sh"
# @end
File_isWritable() {
  [[ -w "$1" ]]
}

# @desc check if the given path is not a empty file
# @param path <string>

# @example
# File_notEmpty "foo.sh"
# @end
File_notEmpty() {
  [[ -s "$1" ]]
}
