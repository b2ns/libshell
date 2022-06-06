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

#### Path_isRel

#### Path_join

#### Path_resolve