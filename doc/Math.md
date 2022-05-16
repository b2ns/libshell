### Math

- [Math_random](#Math_random)
- [Math_range](#Math_range)

#### Math_random

___

> generate a random number

- **min** \<*number*\> (default 0)
- **max** \<*number*\> (default 100)

+ **@return** \<*number*\> a random integer between \[min, max)

```sh
Math_random 1 10
Math_random -10 10
```

#### Math_range

___

> generate a sequence of numbers

- **min** \<*number*\> (default 0)
- **max** \<*number*\> (default 100)
- **step** \<*number*\> (default 1)

+ **@return** \<*array*\>

```sh
Math_range 1 10
# output: 1 2 3 4 5 6 7 8 9 10
Math_random -10 10 3
# output: -10 -7 -4 1 4 7 10
```