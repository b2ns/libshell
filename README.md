# libshell

basic lib functions for shell script

# toc

- [libshell](#libshell)
- [toc](#toc)
- [how to use](#how-to-use)
- [api](#api)
- [acknowledgment](#acknowledgment)

# how to use

1. download libshell
```sh
git clone https://github.com/b2ns/libshell
```
2. add libshell to PATH

```sh
export PATH="/path/to/libshell:$PATH"
```

3. source libshell in your script
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
import Array File Path String
```

# api
- Array
- File
- Path
- String

# acknowledgment
- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)
