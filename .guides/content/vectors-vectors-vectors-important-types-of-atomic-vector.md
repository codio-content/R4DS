
The four most important types of atomic vector are logical, integer, double, and character. Raw and complex are rarely used during a data analysis, so I won't discuss them here.

### Logical

Logical vectors are the simplest type of atomic vector because they can take only three possible values: `FALSE`, `TRUE`, and `NA`. Logical vectors are usually constructed with comparison operators, as described in [comparisons]. You can also create them by hand with `c()`:


```r
1:10 %% 3 == 0
#>  [1] FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE

c(TRUE, TRUE, FALSE, NA)
#> [1]  TRUE  TRUE FALSE    NA
```

### Numeric

Integer and double vectors are known collectively as numeric vectors. In R, numbers are doubles by default. To make an integer, place an `L` after the number:


```r
typeof(1)
#> [1] "double"
typeof(1L)
#> [1] "integer"
1.5L
#> [1] 1.5
```

The distinction between integers and doubles is not usually important, but there are two important differences that you should be aware of:

1.  Doubles are approximations. Doubles represent floating point numbers that 
    can not always be precisely represented with a fixed amount of memory. 
    This means that you should consider all doubles to be approximations. 
    For example, what is square of the square root of two?

    
```r
    x <- sqrt(2) ^ 2
    x
    #> [1] 2
    x - 2
    #> [1] 4.44e-16
```

    This behaviour is common when working with floating point numbers: most
    calculations include some approximation error. Instead of comparing floating
    point numbers using `==`, you should use `dplyr::near()` which allows for 
    some numerical tolerance.

1.  Integers have one special value: `NA`, while doubles have four:
    `NA`, `NaN`, `Inf` and `-Inf`. All three special values `NaN`, `Inf` and `-Inf` can arise during division:
   
    
```r
    c(-1, 0, 1) / 0
    #> [1] -Inf  NaN  Inf
```

    Avoid using `==` to check for these other special values. Instead use the 
    helper functions `is.finite()`, `is.infinite()`, and `is.nan()`:
    
    |                  |  0  | Inf | NA  | NaN |
    |------------------|-----|-----|-----|-----|
    | `is.finite()`    |  x  |     |     |     |
    | `is.infinite()`  |     |  x  |     |     |
    | `is.na()`        |     |     |  x  |  x  |
    | `is.nan()`       |     |     |     |  x  |

### Character

Character vectors are the most complex type of atomic vector, because each element of a character vector is a string, and a string can contain an arbitrary amount of data. 

You've already learned a lot about working with strings in [strings]. Here I wanted to mention one important feature of the underlying string implementation: R uses a global string pool. This means that each unique string is only stored in memory once, and every use of the string points to that representation. This reduces the amount of memory needed by duplicated strings. You can see this behaviour in practice with `pryr::object_size()`:


```r
x <- "This is a reasonably long string."
pryr::object_size(x)
#> 152 B

y <- rep(x, 1000)
pryr::object_size(y)
#> 8.14 kB
```

`y` doesn't take up 1,000x as much memory as `x`, because each element of `y` is just a pointer to that same string. A pointer is 8 bytes, so 1000 pointers to a 136 B string is 8 * 1000 + 136 = 8.13 kB.

### Missing values

Note that each type of atomic vector has its own missing value:


```r
NA            # logical
#> [1] NA
NA_integer_   # integer
#> [1] NA
NA_real_      # double
#> [1] NA
NA_character_ # character
#> [1] NA
```

Normally you don't need to know about these different types because you can always use `NA` and it will be converted to the correct type using the implicit coercion rules described next. However, there are some functions that are strict about their inputs, so it's useful to have this knowledge sitting in your back pocket so you can be specific when needed.

### Exercises

1.  Describe the difference between `is.finite(x)` and  `!is.infinite(x)`.

1.  Read the source code for `dplyr::near()` (Hint: to see the source code,
    drop the `()`). How does it work? 

1.  A logical vector can take 3 possible values. How many possible
    values can an integer vector take? How many possible values can
    a double take? Use google to do some research.

1.  Brainstorm at least four functions that allow you to convert a double to an
    integer. How do they differ? Be precise.
    
1.  What functions from the readr package allow you to turn a string
    into logical, integer, and double vector?
