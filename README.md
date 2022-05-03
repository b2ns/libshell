# libshell

basic lib functions for shell script

# toc

- [libshell](#libshell)
- [toc](#toc)
- [how to use](#how-to-use)
- [Path](#path)
  - [Path_dirname](#path_dirname)
  - [Path_dirpath](#path_dirpath)
  - [Path_extname](#path_extname)
  - [Path_filename](#path_filename)
  - [Path_filepath](#path_filepath)
  - [Path_isAbs](#path_isabs)
  - [Path_isRel](#path_isrel)
- [Acknowledgments](#acknowledgments)

# how to use

1. add libshell to PATH

```sh
export PATH="/path/to/libshell:$PATH"
```

2. source libshell in your script
```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# after source libshell you get a import function and all libs buildin libshell
source libshell.sh

# use IMPORT_ALL_LIBS=0 to only get the import function
# IMPORT_ALL_LIBS=0 source libshell.sh

# use import to include your own script
import /path/to/foo.sh
import ./path/to/bar.sh
import path/to/bar.sh

# import within one line
import /path/to/x.sh ./path/to/y.sh path/to/z.sh

# import buildin lib
import File Path Array String
```

# Path
## Path_dirname
## Path_dirpath
## Path_extname
## Path_filename
## Path_filepath
## Path_isAbs
## Path_isRel

# Acknowledgments
- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)
