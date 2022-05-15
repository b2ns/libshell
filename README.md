<img src="assets/logo.svg" alt="logo" style="width: 100%; max-height: 250px">

# libshell🚀

![GitHub top language](https://img.shields.io/github/languages/top/b2ns/libshell?color=brightgreen&style=flat-square)
![GitHub repo file count (custom path)](https://img.shields.io/github/directory-file-count/b2ns/libshell/lib?label=libs&logo=libs&style=flat-square)
![GitHub repo size](https://img.shields.io/github/repo-size/b2ns/libshell?style=flat-square)
![GitHub package.json version](https://img.shields.io/github/package-json/v/b2ns/libshell?style=flat-square)
![GitHub](https://img.shields.io/github/license/b2ns/libshell?style=flat-square)

**warning⚠: libshell is not stable now, api may change, use at your owen risk.**

basic lib functions for shell script

> write readable shell code with understandable api

<!-- vim-markdown-toc GFM -->

- [features](#features)
- [how to use](#how-to-use)
- [api](#api)
  - [Args](#args)
  - [Array](#array)
  - [Color](#color)
  - [File](#file)
  - [IO](#io)
  - [Math](#math)
  - [Path](#path)
  - [String](#string)
- [FAQ](#faq)
- [acknowledgments](#acknowledgments)
- [build with](#build-with)
- [links](#links)

<!-- vim-markdown-toc -->

## features

- mean to be basic, small and easy to use
- pure bash(4.2+), no magic, no external dependences
- ECMAScript(Javascript) style like api
- well tested
- ~~well documented~~

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
  # get help info based on what you defined above
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

### [IO](doc/IO.md)

### [Math](doc/Math.md)

### [Path](doc/Path.md)

### [String](doc/String.md)

## FAQ

- why this repo?
- why it is slow when running in a loop?
- why xxx not included?

## acknowledgments

- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)
- [pure-sh-bible](https://github.com/dylanaraps/pure-sh-bible)
- [chalk](https://github.com/chalk/chalk)
- [commander](https://github.com/tj/commander.js)

## build with

- editor: [neovim](https://github.com/neovim/neovim)
- linter: [shellcheck](https://github.com/koalaman/shellcheck)
- fixer: [shfmt](https://github.com/mvdan/sh)
- unit test: [bats](https://github.com/bats-core/bats-core)

## links

- [https://devhints.io/bash](https://devhints.io/bash)
- [https://learnxinyminutes.com/docs/bash/](https://learnxinyminutes.com/docs/bash/)
- [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
- [https://mywiki.wooledge.org](https://mywiki.wooledge.org)
- [https://wiki.bash-hackers.org](https://wiki.bash-hackers.org)
- [http://redsymbol.net/articles/unofficial-bash-strict-mode/](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [https://tldp.org/LDP/abs/html/index.html](https://tldp.org/LDP/abs/html/index.html)
