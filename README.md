# libshell🚀

basic lib functions for shell script

**warning⚠: libshell is not stable now, api may change, use at your owen risk.**

<!-- vim-markdown-toc GFM -->

- [how to use](#how-to-use)
- [api](#api)
  - [Args](#args)
  - [Array](#array)
  - [Color](#color)
  - [File](#file)
  - [Math](#math)
  - [Path](#path)
  - [String](#string)
- [acknowledgments](#acknowledgments)
- [links](#links)

<!-- vim-markdown-toc -->

## how to use

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

# import at one line
import /path/to/x.sh ./path/to/y.sh path/to/z.sh

# import builtin lib
import Array File Path String
```

## api

### [Args](doc/Args.md)

define and parse command arguments passed to your script.

```sh
# hello-world.sh

# define command arguments
Args_define "-j --job" "Running jobs" "<int>" 2
Args_define "-f --format" "Output format" "[json yaml toml xml]" "json"
Args_define "-v -V --version" "Show version"
Args_define "-h --help" "Show help"

# parse the arguments passed in
Args_parse "$@"

# deal with the arguments you got
if Args_has "-v"; then
  echo "Version: 1.0.0"
fi

if Args_has "-h"; then
  # auto help info based on what you defined earlier
  Args_help
fi

declare format="$(Args_get "--format")"

echo "hello world" > "foo.$format"

########################################
# let's pass some arguments
./hello-world.sh -h
./hello-world.sh -v
./hello-world.sh -f yaml
./hello-world.sh -f=yaml
./hello-world.sh -vhf yaml
./hello-world.sh -vhf=yaml
./hello-world.sh --job 8
./hello-world.sh -j=8
./hello-world.sh -j8
```
more details in the [doc](doc/Args.md)

### [Array](doc/Array.md)

### [Color](doc/Color.md)

### [File](doc/File.md)

### [Math](doc/Math.md)

### [Path](doc/Path.md)

### [String](doc/String.md)

## acknowledgments

- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)
- [pure-sh-bible](https://github.com/dylanaraps/pure-sh-bible)

## links

- [https://devhints.io/bash](https://devhints.io/bash)
- [https://learnxinyminutes.com/docs/bash/](https://learnxinyminutes.com/docs/bash/)
- [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
- [https://mywiki.wooledge.org](https://mywiki.wooledge.org)
- [https://wiki.bash-hackers.org](https://wiki.bash-hackers.org)
- [http://redsymbol.net/articles/unofficial-bash-strict-mode/](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [https://tldp.org/LDP/abs/html/index.html](https://tldp.org/LDP/abs/html/index.html)
