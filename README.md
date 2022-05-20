<img src="https://cdn.jsdelivr.net/gh/b2ns/assets/images/libshell/logo.svg" alt="logo" style="width: 100%; height: 250px;">

# libshell🚀

![GitHub top language](https://img.shields.io/badge/bash-4EAA25?logo=GNU%20Bash&logoColor=white&color="brightgreen"&style=flat-square)
![GitHub top language](https://img.shields.io/github/languages/top/b2ns/libshell?color=brightgreen&style=flat-square)
![GitHub repo file count (custom path)](https://img.shields.io/github/directory-file-count/b2ns/libshell/lib?label=libs&logo=libs&style=flat-square)
![GitHub repo size](https://img.shields.io/github/repo-size/b2ns/libshell?style=flat-square)
![GitHub package.json version](https://img.shields.io/github/package-json/v/b2ns/libshell?style=flat-square)
![GitHub](https://img.shields.io/github/license/b2ns/libshell?style=flat-square)

**warning⚠: not stable now, api may change, use at your owen risk.**

basic lib functions for (bash)shell script

<!-- vim-markdown-toc GFM -->

- [features](#features)
- [how to use](#how-to-use)
  - [download and source it](#download-and-source-it)
  - [npm](#npm)
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
- [build with](#build-with)
- [TODO](#todo)
- [contribute](#contribute)
- [acknowledgments](#acknowledgments)
- [links](#links)

<!-- vim-markdown-toc -->

## features

- meant to be basic, small and easy to use
- pure bash(4.2+), no magic, no external dependences
- ECMAScript(Javascript) style like api
- well tested
- well documented
- should be fast

## how to use

### download and source it

1. download libshell

```sh
git clone https://github.com/b2ns/libshell
```

2. source libshell in your script

```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# way 1(recommended): add libshell to PATH and source it directly from everywhere
export PATH="/path/to/libshell/bin:$PATH" # write in .bashrc or .zshrc
source libshell

# way 2: source from absolute path
source "/abs/path/to/libshell.sh"

# way 3: source from relative path
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rel/path/to/libshell.sh"

# after source libshell you get a import function and all libs builtin
# use IMPORT_ALL_LIBS=0 to only get the import function
# IMPORT_ALL_LIBS=0 source libshell

# use import to include your own script
import /path/to/foo.sh
import ./path/to/bar.sh
import path/to/bar.sh

# import at one line
import /path/to/x.sh ./path/to/y.sh path/to/z.sh

# import builtin lib(you only need this when you set IMPORT_ALL_LIBS to 0)
import Array File Path String
```

### npm

```sh
# if install in global
npm -g i @b2ns/libshell
# or
yarn global add @b2ns/libshell

# source libshell
source libshell


# if install in local
npm i @b2ns/libshell
# or
yarn add @b2ns/libshell

# source libshell
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/node_modules/@b2ns/libshell/libshell.sh"
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

# don't forget to parse the arguments passed in
Args_parse "$@"


# let's deal with the arguments you got
if Args_has "-v"; then
  echo "Version: 1.0.0"
fi

if Args_has "-h" || ($# == 0); then
  # get help info based on what you defined above
  Args_help
fi

if Args_has "-f"; then
  format="$(Args_get "--format")"
  echo "hello world" > "foo.$format"
fi

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

```sh
arr=("foo" "bar" "baz")

Array_isEmpty "${arr[@]}"

Array_includes "${arr[@]}" "bar"

Array_indexOf "${arr[@]}" "bar" # 1

Array_join "${arr[@]}" "/" # foo/bar/baz

arr2=(2 5 1 3 4)

Array_forEach "${arr2[@]}" echo # "2 0" "5 1" "1 2" "3 3" "4 4"

double(){ echo "$(($1 * 2))"; }
Array_map "${arr2[@]}" double # 2 10 2 6 8

Array_sort "${arr2[@]}" # 1 2 3 4 5
```

more details in the [doc](doc/Array.md)

### [Color](doc/Color.md)

```sh
coloredMsg="$(Color "hello world" "yellowBright" "bgBlack" "italic" "underline")"
echo -e "$coloredMsg"

# or just use Color_print
Color_print "hello world\n" "yellowBright" "bgBlack" "italic" "underline"

# use rgb or hex color if your terminal supports it
Color_print "hello world\n" "#fa0" "rgb(0,0,0)|bg" "bold"
```

more details in the [doc](doc/Color.md)

### [File](doc/File.md)

```sh
File_isDir "foo/bar/"
File_isFile "foo/bar/baz.sh"
File_isExist "foo/bar/baz.sh"
File_isSymlink "foo/bar/baz.sh"
File_isEmpty "foo/bar/baz.sh"
```

more details in the [doc](doc/File.md)

### [IO](doc/IO.md)

```sh
IO_log "log"
IO_info "info"
IO_warn "warn"
IO_error "error"
# also accept color format arguments
IO_success "success" "#0f0" "bold"
```

more details in the [doc](doc/IO.md)

### [Math](doc/Math.md)

```sh
Math_random 1 100
Math_range 1 10 2
```

more details in the [doc](doc/Math.md)

### [Path](doc/Path.md)

```sh
Path_basename "../foo/bar.sh" # bar.sh
Path_basename "../foo/bar.sh" ".sh" # bar

Path_extname "../foo/bar.sh" # .sh

Path_dirname "../foo/bar.sh" # ../foo

Path_join "path/to/foo/" "../bar.sh" # path/to/bar.sh

Path_resolve "path/to/foo/" "../bar.sh" # /abs/path/to/bar.sh
```

more details in the [doc](doc/Path.md)

### [String](doc/String.md)

```sh
String_isEmpty "foo"

String_includes "foobar" "bar"

String_indexOf "foobar" "bar" # 3

String_match "foobar" "o{2,2}bar$"

String_replace "foobar" "o" "x" #fxobar

String_slice "foobar" 1 4 # oob

String_substr "foobar" 1 4 # ooba

String_split "foo-bar-baz" "-" # ("foo" "bar" "baz")

String_toLowerCase "FOO" # foo

String_toUpperCase "foo" # FOO

String_capitalize "foo" # Foo

String_trim "  foo bar  " # foo bar

String_stripStart "/foo/bar/baz.sh" "*/" 1 # baz.sh

String_stripEnd "/foo/bar/baz.sh" "/*" # baz.sh
```

more details in the [doc](doc/String.md)

## FAQ

- **why this repo?**  
  I came form the javascript world, and I found myself always googling `truncate string in bash shell ?`, `difference between % and # ?`, `if String is empty, use -n or -z ?`:joy:.  
  So here is this repo, to help writing shell script without google and pain.
- **shoud I source libshell in every file?**  
  No. you only need source it in the entry file.  
  And there will be no harm if you source it everywhere.
- **will it import the same module multiple times?**  
  No. `import` only import module once.  
  libshell will register the imported module and make sure it not being imported multiple times.
- **feel slow when running in a loop?**  
  It's a bash problem here.  
  In bash `()`, `$()` or `|` will use subshell to execute. too many subshell will slow down your script.

  ```sh
  SECONDS=0
  for ((i = 0; i < 10000; i++)); do
    # subshell used here
    num="$(Math_random 0 10)"
  done
  echo "cost: ${SECONDS}s"
  # cost: 10s
  ```

  **workaround**: use the special global variable **`RETVAL`** to get the return value from the function

  ```sh
  SECONDS=0
  for ((i = 0; i < 10000; i++)); do
    # invoke function directly and redirect stdout to /dev/null
    Math_random 0 10 >/dev/null
    num="$RETVAL"
  done
  echo "cost: ${SECONDS}s"
  # cost: 0s
  ```

- **why xxx not included?**  
  libshell meant to be basic. Only basic and general use function will be included.

## build with

- editor: [neovim](https://github.com/neovim/neovim)
- linter: [shellcheck](https://github.com/koalaman/shellcheck)
- fixer: [shfmt](https://github.com/mvdan/sh)
- unit test: [bats](https://github.com/bats-core/bats-core)

## TODO
- [ ] add more Math function
- [ ] use nameref in Array ?
- [ ] Args support define command
- [ ] add Assert module ?

## contribute

## acknowledgments

- [bash-oo-framework](https://github.com/niieani/bash-oo-framework)
- [pure-sh-bible](https://github.com/dylanaraps/pure-sh-bible)
- [chalk](https://github.com/chalk/chalk)
- [commander](https://github.com/tj/commander.js)

## links

- [https://devhints.io/bash](https://devhints.io/bash)
- [https://learnxinyminutes.com/docs/bash/](https://learnxinyminutes.com/docs/bash/)
- [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
- [https://mywiki.wooledge.org](https://mywiki.wooledge.org)
- [https://wiki.bash-hackers.org](https://wiki.bash-hackers.org)
- [http://redsymbol.net/articles/unofficial-bash-strict-mode/](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [https://tldp.org/LDP/abs/html/index.html](https://tldp.org/LDP/abs/html/index.html)
