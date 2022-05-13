### Math

- [Math_random](#Math_random)
- [Math_range](#Math_range)

#### Math_random

___

> get a random number

- **min** <*number*> (default 0)
- **max** <*number*> (default 100)

+ **@return** <*number*> a random integer between \[min, max)

```sh
Math_random 1 10
Math_random -10 10
```

#### Math_range

___

> generate a sequence of numbers, like {0\.\.100\.\.1} in bash

- **min** <*number*> (default 0)
- **max** <*number*> (default 100)
- **step** <*number*> (default 1)

+ **@return** <*array*>

```sh
Math_range 1 10
Math_random -10 10 3
```