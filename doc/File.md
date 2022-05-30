### File

- [File_isDir](#File_isDir)
- [File_isEmpty](#File_isEmpty)
- [File_isExecutable](#File_isExecutable)
- [File_isExist](#File_isExist)
- [File_isFile](#File_isFile)
- [File_isReadable](#File_isReadable)
- [File_isSame](#File_isSame)
- [File_isSymlink](#File_isSymlink)
- [File_isWritable](#File_isWritable)
- [File_notEmpty](#File_notEmpty)

#### File_isDir

> check if the given path is a directory

- **path** \<*string*\>

```sh
File_isDir "~/Desktop"
```

#### File_isEmpty

> check if the given path is a empty file

- **path** \<*string*\>

```sh
File_isEmpty "foo.sh"
```

#### File_isExecutable

> check if the given path is executable

- **path** \<*string*\>

```sh
File_isExecutable "foo.sh"
```

#### File_isExist

> check if the given path exists

- **path** \<*string*\>

```sh
File_isExist "foo.sh"
```

#### File_isFile

> check if the given path is a file

- **path** \<*string*\>

```sh
File_isFile "foo.sh"
```

#### File_isReadable

> check if the given path is readable

- **path** \<*string*\>

```sh
File_isReadable "foo.sh"
```

#### File_isSame

> check if the given paths are the same file

- **path1** \<*string*\>
- **path2** \<*string*\>

```sh
File_isSame "foo.sh" "~/Desktop/foo.sh"
```

#### File_isSymlink

> check if the given path is a symbolic link

- **path** \<*string*\>

```sh
File_isSymlink "foo.sh"
```

#### File_isWritable

> check if the given path is writable

- **path** \<*string*\>

```sh
File_isWritable "foo.sh"
```

#### File_notEmpty

> check if the given path is not a empty file

- **path** \<*string*\>

```sh
File_notEmpty "foo.sh"
```