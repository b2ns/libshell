# libshell

basic lib functions for shell script

# toc

- [libshell](#libshell)
- [toc](#toc)
- [how to use](#how-to-use)
- [api](#api)
- [acknowledgment](#acknowledgment)
- [links](#links)

# how to use

1. download libshell
```sh
git clone https://github.com/b2ns/libshell
```
2. add libshell to PATH
```sh
export PATH="/path/to/libshell/bin:$PATH"
```
3. source libshell in your script
```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# after source libshell you get a import function and all libs builtin libshell
source libshell

# use IMPORT_ALL_LIBS=0 to only get the import function
# IMPORT_ALL_LIBS=0 source libshell

# use import to include your own script
import /path/to/foo.sh
import ./path/to/bar.sh
import path/to/bar.sh

# import within one line
import /path/to/x.sh ./path/to/y.sh path/to/z.sh

# import builtin lib
import Array File Path String
```

# api

- Args
- Array
- Color
- File
- Math
- Path
- String

# acknowledgment

- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)

# links

- [https://devhints.io/bash](https://devhints.io/bash)
- [https://learnxinyminutes.com/docs/bash/](https://learnxinyminutes.com/docs/bash/)
- [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
- [https://mywiki.wooledge.org](https://mywiki.wooledge.org)
- [https://wiki.bash-hackers.org](https://wiki.bash-hackers.org)
- [http://redsymbol.net/articles/unofficial-bash-strict-mode/](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [https://tldp.org/LDP/abs/html/index.html](https://tldp.org/LDP/abs/html/index.html)
