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
- [Array_map](#Array_map)
- [Array_notEmpty](#Array_notEmpty)
- [Array_pop](#Array_pop)
- [Array_push](#Array_push)
- [Array_random](#Array_random)
- [Array_reverse](#Array_reverse)
- [Array_shift](#Array_shift)
- [Array_some](#Array_some)
- [Array_sort](#Array_sort)
- [Array_splice](#Array_splice)
- [Array_unshift](#Array_unshift)

#### Array_every

> check if all elements in array meets the condition

- **array** \<*array*\>
- **condition** \<*function*\> | \<string\>

```sh
gt5() {
  (($1 > 5))
}

arr=(6 7 8)
Array_every arr gt5
# assert success

arr=(6 5 8)
Array_every arr '(( $1 > 5 ))'
# assert failure
```

#### Array_filter

> filter the array by condition

- **array** \<*array*\>
- **condition** \<*function*\> | \<string\>

```sh
arr=(6 1 8)
Array_filter arr '(( $1 > 5 ))'
# output: 6 8
```

#### Array_find

> check if array has element satisfy the condition

- **array** \<*array*\>
- **condition** \<*function*\> | \<string\>

```sh
arr=("foo" "bar111" "baz")
Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# assert success

arr=("foo" "bar" "baz")
Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# assert failure
```

#### Array_findIndex

> return the index of the first element match the regexp

- **array** \<*array*\>
- **regexp** \<*regexp*\>

+ **@return** index \<*int*\> or \-1 when not found

```sh
arr=("foo" "bar111" "baz")
Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
# output: 1

arr=("foo" "bar" "baz")
Array_find arr '[[ $1 =~ [a-z]+[0-9]+ ]]'
output: -1
```

#### Array_forEach

#### Array_includes

#### Array_indexOf

#### Array_isEmpty

#### Array_join

#### Array_map

#### Array_notEmpty

#### Array_pop

#### Array_push

#### Array_random

#### Array_reverse

#### Array_shift

#### Array_some

> check if array has element meets the condition

- **array** \<*array*\>
- **condition** \<*function*\> | \<string\>

```sh
gt5() {
  (($1 > 5))
}

arr=(1 2 6)
Array_some arr gt5
# assert success

arr=(1 2 3)
Array_some arr '(($1 > 5))'
# assert failure
```

#### Array_sort

#### Array_splice

#### Array_unshift