### Path

- [Path_basename](#Path_basename)
- [Path_dirname](#Path_dirname)
- [Path_extname](#Path_extname)
- [Path_isAbs](#Path_isAbs)
- [Path_isRel](#Path_isRel)
- [Path_join](#Path_join)
- [Path_resolve](#Path_resolve)

#### Path_basename

> get basename of the given path

- **path** \<*string*\>
- **extname** \<*string*\> | \<number\> provide 1 if you dont know the extension name

+ **@return** basename \<*string*\>

```sh
Path_basename "~/path/to/foo.sh"
# output: foo.sh

Path_basename "~/path/to/foo.sh" ".sh"
# output: foo

# if you dont know the extension name, you can use the following
Path_basename "~/path/to/foo.sh" 1
# output: foo
```

#### Path_dirname

> get dirname of the given path

- **path** \<*string*\>

+ **@return** dirname \<*string*\>

```sh
Path_dirname "~/path/to/foo.sh"
# output: ~/path/to

Path_dirname "../foo.sh"
# output: ..
```

#### Path_extname

> get extension of the given path

- **path** \<*string*\>

+ **@return** extension name \<*string*\>

```sh
Path_extname "~/path/to/foo.sh"
# output: .sh
```

#### Path_isAbs

> check if the given path is absolute

- **path** \<*string*\>

```sh
Path_isAbs "/path/to/foo.sh"
# assert success
```

#### Path_isRel

> check if the given path is relative

- **path** \<*string*\>

```sh
Path_isRel "./path/to/foo.sh"
# assert success
```

#### Path_join

> join the given paths

- **paths** \<*string*\>

+ **@return** joined path \<*string*\>

```sh
Path_join "/path/to/" "./foo.sh"
# output: /path/to/foo.sh

Path_join "path/to/" "../foo.sh"
# output: path/foo.sh
```

#### Path_resolve

> resolve the given paths into an absolute path

- **paths** \<*string*\>

+ **@return** an absolute path \<*string*\>

```sh
Path_resolve "path/to" "../foo.sh"
# output: $PWD/path/foo.sh
```