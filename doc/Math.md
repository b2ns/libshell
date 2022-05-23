### Math

- [Math_abs](#Math_abs)
- [Math_max](#Math_max)
- [Math_min](#Math_min)
- [Math_random](#Math_random)
- [Math_range](#Math_range)

#### Math_abs

> get the absolute value of a number

- **number** \<*number*\>

+ **@return** \<*number*\>

#### Math_max

> get the maximum

- **numbers** \<*array*\>

+ **@return** \<*number*\>

#### Math_min

> get the minimum

- **numbers** \<*array*\>

+ **@return** \<*number*\>

#### Math_random

> generate a random number

- **min** \<*number*\> (default 0)
- **max** \<*number*\> (default 100)

+ **@return** \<*number*\> a random integer between \[min, max)

```sh
Math_random 1 10
Math_random -10 10
```

#### Math_range

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