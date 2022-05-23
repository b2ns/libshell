### Args

- [Args_define](#Args_define)
- [Args_get](#Args_get)
- [Args_getInput](#Args_getInput)
- [Args_has](#Args_has)
- [Args_help](#Args_help)
- [Args_parse](#Args_parse)

#### Args_define

> define command arguments options

- **argName** \<*string*\> \- e\.g\.; "\-h \-\-help"
- **desc** \<*string*\> \- description of the argument
- **argType** \<*string*\> \- type of the argument\. must be one of \<any\> | \<int\> | \<float\> | \<number\> | \[choice1 choice2 \.\.\.\]\. use a suffix ! (i\.e\.; \<any\>!) to indicate the argument is required\. can also define a custom type check function here\.
- **defaultValue** \<*any*\> \- default value of the argument

```sh
Args_define "-r --readonly" "Readonly"
Args_define "-o --output" "Output" "<any>"
Args_define "-j --job" "Running jobs" "<int>" 2
Args_define "--te" "Truncation error" "<float>" 0.00001
Args_define "-f --format" "Output format" "[json yaml toml xml csv]" "json"
Args_define "-p --pwd" "Password is required" "<any>!"

checkEqualCustom() {
if [[ "$1" != "custom" ]]; then
echo "Expected 'custom', got '$1'"
return 1
fi
}
Args_define "-c --custom" "Custom" checkEqualCustom
# or use a string as lambda function
# Args_define "-c --custom" "Custom" '[[ "$1" != "custom" ]] && echo "Expected custom, got $1";return 1'

Args_define "-v -V --version" "Show version"
Args_define "-h --help" "Show help"
```

#### Args_get

> get command arguments value passed in

- **argName** \<*string*\> e\.g\.; "\-j" or "\-\-job"

+ **@return** \<*any*\> value passed in

```sh
Args_get "-j"
# equivalent
Args_get "--job"
```

#### Args_getInput

> get all input text other than command arguments value

+ **@return** \<*array*\>

```sh
# pass arguments to the ./script.sh
./script.sh -f toml ./file1 ../file2 path/to/file3
######################
# then get the files to process
Args_getInput
# output: "./file1 ../file2 path/to/file3"
```

#### Args_has

> check if command argument is passed

- **argName** \<*string*\> e\.g\.; "\-j" or "\-\-job"

```sh
Args_has "-j"
# equivalent
Args_has "--job"
```

#### Args_help

> show help info based on what you have defined

- **insertBefore** \<*string*\> insert text before this help info
- **insertAfter** \<*string*\> insert text after this help info

```sh
Args_help
Args_help "Usage: foo [options]" "more info here..."
```

#### Args_parse

> parse command arguments

- **argv** \<*array*\> command arguments

```sh
#must be called after Args_define()
Args_parse "$@"
```