### Array

- [Array_every](#Array_every)
- [Array_filter](#Array_filter)
- [Array_find](#Array_find)
- [Array_findIndex](#Array_findIndex)
- [Array_forEach](#Array_forEach)
- [Array_includes](#Array_includes)
- [Array_indexOf](#Array_indexOf)
- [Array_isEmpty](#Array_isEmpty)
- [Array_join](#Array_join)
- [Array_length](#Array_length)
- [Array_map](#Array_map)
- [Array_notEmpty](#Array_notEmpty)
- [Array_random](#Array_random)
- [Array_reverse](#Array_reverse)
- [Array_some](#Array_some)
- [Array_sort](#Array_sort)

#### Array_every

___

> check if all elements in array meets the condition

- **array** \<*array*\>
- **condition** \<*function*\>

```sh
gt5() {
  (($1 > 5)) && return 0
  return 1
}

arr=(6 7 8)
Array_every "${arr[@]}" gt5
# assert success

arr=(6 5 8)
Array_every "${arr[@]}" gt5
# assert failure
```

#### Array_filter

___

> filter the array by condition

- **array** \<*array*\>
- **condition** \<*function*\>

```sh
gt5() {
  (($1 > 5)) && return 0
  return 1
}

arr=(6 1 8)
Array_filter "${arr[@]}" gt5
# output: 6 8
```

#### Array_find

___

> check if array has element match the regexp

- **array** \<*array*\>
- **regexp** \<*regexp*\>

```sh
arr=("foo" "bar111" "baz")
Array_find "${arr[@]}" "[a-z]+[0-9]+"
# assert success

arr=("foo" "bar" "baz")
Array_find "${arr[@]}" "[a-z]+[0-9]+"
# assert failure
```

#### Array_findIndex

___

> return the index of the first element match the regexp

- **array** \<*array*\>
- **regexp** \<*regexp*\>

+ **@return** index \<*int*\> or \-1 when not found

```sh
arr=("foo" "bar111" "baz")
Array_find "${arr[@]}" "[a-z]+[0-9]+"
# output: 1

arr=("foo" "bar" "baz")
Array_find "${arr[@]}" "[a-z]+[0-9]+"
output: -1
```

#### Array_forEach

___

#### Array_includes

___

#### Array_indexOf

___

#### Array_isEmpty

___

#### Array_join

___

#### Array_length (deprecated)

___

#### Array_map

___

#### Array_notEmpty

___

#### Array_random

___

#### Array_reverse

___

#### Array_some

___

> check if array has element meets the condition

- **array** \<*array*\>
- **condition** \<*function*\>

```sh
gt5() {
  (($1 > 5)) && return 0
  return 1
}

arr=(1 2 6)
Array_some "${arr[@]}" gt5
# assert success

arr=(1 2 3)
Array_some "${arr[@]}" gt5
# assert failure
```

#### Array_sort

___