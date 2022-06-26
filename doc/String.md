### String

- [String_at](#String_at)
- [String_capitalize](#String_capitalize)
- [String_endsWith](#String_endsWith)
- [String_eq](#String_eq)
- [String_includes](#String_includes)
- [String_indexOf](#String_indexOf)
- [String_isEmpty](#String_isEmpty)
- [String_match](#String_match)
- [String_notEmpty](#String_notEmpty)
- [String_notEq](#String_notEq)
- [String_padEnd](#String_padEnd)
- [String_padStart](#String_padStart)
- [String_repeat](#String_repeat)
- [String_replace](#String_replace)
- [String_replaceAll](#String_replaceAll)
- [String_reverse](#String_reverse)
- [String_search](#String_search)
- [String_slice](#String_slice)
- [String_split](#String_split)
- [String_startsWith](#String_startsWith)
- [String_stripEnd](#String_stripEnd)
- [String_stripStart](#String_stripStart)
- [String_substr](#String_substr)
- [String_toLowerCase](#String_toLowerCase)
- [String_toUpperCase](#String_toUpperCase)
- [String_trim](#String_trim)
- [String_trimEnd](#String_trimEnd)
- [String_trimStart](#String_trimStart)
- [String_uncapitalize](#String_uncapitalize)

#### String_at

> get the char at the given index

- **string** \<*string*\>
- **index** \<*int*\>

+ **@return** char \<*char*\>

```sh
String_at "abc" 1
# output: b

String_at "abc" -1
# output: c
```

#### String_capitalize

> capitalize the first letter of the given string

- **string** \<*string*\>

+ **@return** capitalized string \<*string*\>

```sh
String_capitalize "foo"
# output: "Foo"
```

#### String_endsWith

> check if the given string ends with the specific suffix

- **string** \<*string*\>
- **suffix** \<*string*\>

```sh
String_endsWith "foobar" "bar"
# assert success

String_endsWith "foobar" "ba"
# assert failure
```

#### String_eq

> check if the given strings are equal

- **string1** \<*string*\>
- **string2** \<*string*\>

```sh
String_eq "foobar" "foobar"
# assert success

String_eq "foobar" "foo"
# assert failure
```

#### String_includes

> check if the given stirng includes the specific substring

- **string** \<*string*\>
- **substring** \<*string*\>

```sh
String_includes "foobar" "oob"
# assert success

String_includes "foobar" "baz"
# assert failure
```

#### String_indexOf

>  get the index of the first occurrence of the specific substring

- **string** \<*string*\>
- **substring** \<*string*\>

+ **@return** index \<*int*\>

```sh
String_indexOf "foo barbar" "bar"
# output: 4

String_indexOf "foo bar" "baz"
# output: -1
```

#### String_isEmpty

> check if the given stirng is empty

- **string** \<*string*\>

```sh
String_isEmpty ""
# assert success

String_isEmpty "foo"
# assert failure
```

#### String_match

> check if the given stirng match the specific pattern

- **string** \<*string*\>
- **pattern** \<*regexp*\>

```sh
String_match "foo12o bar" "^foo[0-9]+o"
# assert success

String_match "foo1 bar" "^foo$"
# assert failure
```

#### String_notEmpty

> check if the given stirng is not empty

- **string** \<*string*\>

```sh
String_notEmpty "foo"
# assert success

String_notEmpty ""
# assert failure
```

#### String_notEq

> check if the given stirngs are not equal

- **string1** \<*string*\>
- **string2** \<*string*\>

```sh
String_notEq "foo" "fox"
# assert success

String_notEq "foo" "foo"
# assert failure
```

#### String_padEnd

> pads the current string with a given string at the end

- **string** \<*string*\>
- **targetLength** \<*int*\>
- **padString** \<*string*\> (default " ")

+ **@return** padded string \<*string*\>

```sh
String_padEnd "foo" 5
# output: "foo  "

String_padEnd "foo" 6 "-"
# output: "foo---"
```

#### String_padStart

> pads the current string with a given string at the beginning

- **string** \<*string*\>
- **targetLength** \<*int*\>
- **padString** \<*string*\> (default " ")

+ **@return** padded string \<*string*\>

```sh
String_padStart "foo" 5
# output: "  foo"

String_padStart "foo" 6 "-"
# output: "---foo"
```

#### String_repeat

> repeat the given string n times

- **string** \<*string*\>
- **count** \<*int*\>

+ **@return** new string \<*string*\>

```sh
String_repeat "a" 3
# output: aaa
```

#### String_replace

> replace the subStr of the given string with newSubStr

- **string** \<*string*\>
- **subStr** \<*string*\>
- **newSubStr** \<*string*\>

+ **@return** new string \<*string*\>

```sh
String_replace "foo bar" "bar" "baz"
# output: foo baz
String_replace " foo bar" "bar" ""
# output: " foo "
String_replace "foo bar foobar" "bar" "baz"
# output: foo baz foobar
```

#### String_replaceAll

> replace all the subStr of the given string with newSubStr

- **string** \<*string*\>
- **subStr** \<*string*\>
- **newSubStr** \<*string*\>

+ **@return** new string \<*string*\>

```sh
String_replaceAll "foo bar foobar" "bar" "baz"
# output: foo baz foobaz
```

#### String_reverse

#### String_search

#### String_slice

#### String_split

#### String_startsWith

#### String_stripEnd

#### String_stripStart

#### String_substr

#### String_toLowerCase

#### String_toUpperCase

#### String_trim

#### String_trimEnd

#### String_trimStart

#### String_uncapitalize