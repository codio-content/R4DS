
Now that you understand the different types of atomic vector, it's useful to review some of the important tools for working with them. These include:

1.  How to convert from one type to another, and when that happens
    automatically.

1.  How to tell if an object is a specific type of vector.

1.  What happens when you work with vectors of different lengths.

1.  How to name the elements of a vector.

1.  How to pull out elements of interest.

### Coercion

There are two ways to convert, or coerce, one type of vector to another:

1.  Explicit coercion happens when you call a function like `as.logical()`,
    `as.integer()`, `as.double()`, or `as.character()`. Whenever you find
    yourself using explicit coercion, you should always check whether you can
    make the fix upstream, so that the vector never had the wrong type in 
    the first place. For example, you may need to tweak your readr 
    `col_types` specification.

1.  Implicit coercion happens when you use a vector in a specific context
    that expects a certain type of vector. For example, when you use a logical
    vector with a numeric summary function, or when you use a double vector
    where an integer vector is expected.
    
Because explicit coercion is used relatively rarely, and is largely easy to understand, I'll focus on implicit coercion here. 

You've already seen the most important type of implicit coercion: using a logical vector in a numeric context. In this case `TRUE` is converted to `1` and `FALSE` converted to `0`. That means the sum of a logical vector is the number of trues, and the mean of a logical vector is the proportion of trues:


```r
x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)  # how many are greater than 10?
#> [1] 44
mean(y) # what proportion are greater than 10?
#> [1] 0.44
```

You may see some code (typically older) that relies on implicit coercion in the opposite direction, from integer to logical:


```r
if (length(x)) {
  # do something
}
```

In this case, 0 is converted to `FALSE` and everything else is converted to `TRUE`. I think this makes it harder to understand your code, and I don't recommend it. Instead be explicit: `length(x) > 0`.

It's also important to understand what happens when you try and create a vector containing multiple types with `c()`: the most complex type always wins.


```r
typeof(c(TRUE, 1L))
#> [1] "integer"
typeof(c(1L, 1.5))
#> [1] "double"
typeof(c(1.5, "a"))
#> [1] "character"
```

An atomic vector can not have a mix of different types because the type is a property of the complete vector, not the individual elements. If you need to mix multiple types in the same vector, you should use a list, which you'll learn about shortly.

### Test functions

Sometimes you want to do different things based on the type of vector. One option is to use `typeof()`. Another is to use a test function which returns a `TRUE` or `FALSE`. Base R provides many functions like `is.vector()` and `is.atomic()`, but they often return surprising results. Instead, it's safer to use the `is_*` functions provided by purrr, which are summarised in the table below.

|                  | lgl | int | dbl | chr | list |
|------------------|-----|-----|-----|-----|------|
| `is_logical()`   |  x  |     |     |     |      |
| `is_integer()`   |     |  x  |     |     |      |
| `is_double()`    |     |     |  x  |     |      |
| `is_numeric()`   |     |  x  |  x  |     |      |
| `is_character()` |     |     |     |  x  |      |
| `is_atomic()`    |  x  |  x  |  x  |  x  |      |
| `is_list()`      |     |     |     |     |  x   |
| `is_vector()`    |  x  |  x  |  x  |  x  |  x   |

Each predicate also comes with a "scalar" version, like `is_scalar_atomic()`, which checks that the length is 1. This is useful, for example, if you want to check that an argument to your function is a single logical value.

### Scalars and recycling rules

As well as implicitly coercing the types of vectors to be compatible, R will also implicitly coerce the length of vectors. This is called vector __recycling__, because the shorter vector is repeated, or recycled, to the same length as the longer vector. 

This is generally most useful when you are mixing vectors and "scalars". I put scalars in quotes because R doesn't actually have scalars: instead, a single number is a vector of length 1. Because there are no scalars, most built-in functions are __vectorised__, meaning that they will operate on a vector of numbers. That's why, for example, this code works:


```r
sample(10) + 100
#>  [1] 109 108 104 102 103 110 106 107 105 101
runif(10) > 0.5
#>  [1]  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE
```

In R, basic mathematical operations work with vectors. That means that you should never need to perform explicit iteration when performing simple mathematical computations.

It's intuitive what should happen if you add two vectors of the same length, or a vector and a "scalar", but what happens if you add two vectors of different lengths?


```r
1:10 + 1:2
#>  [1]  2  4  4  6  6  8  8 10 10 12
```

Here, R will expand the shortest vector to the same length as the longest, so called recycling. This is silent except when the length of the longer is not an integer multiple of the length of the shorter:


```r
1:10 + 1:3
#> Warning in 1:10 + 1:3: longer object length is not a multiple of shorter
#> object length
#>  [1]  2  4  6  5  7  9  8 10 12 11
```

While vector recycling can be used to create very succinct, clever code, it can also silently conceal problems. For this reason, the vectorised functions in tidyverse will throw errors when you recycle anything other than a scalar. If you do want to recycle, you'll need to do it yourself with `rep()`:


```r
tibble(x = 1:4, y = 1:2)
#> Tibble columns must have consistent lengths, only values of length one are recycled:
#> * Length 2: Column `y`
#> * Length 4: Column `x`

tibble(x = 1:4, y = rep(1:2, 2))
#> # A tibble: 4 x 2
#>       x     y
#>   <int> <int>
#> 1     1     1
#> 2     2     2
#> 3     3     1
#> 4     4     2

tibble(x = 1:4, y = rep(1:2, each = 2))
#> # A tibble: 4 x 2
#>       x     y
#>   <int> <int>
#> 1     1     1
#> 2     2     1
#> 3     3     2
#> 4     4     2
```

### Naming vectors

All types of vectors can be named. You can name them during creation with `c()`:


```r
c(x = 1, y = 2, z = 4)
#> x y z 
#> 1 2 4
```

Or after the fact with `purrr::set_names()`:


```r
set_names(1:3, c("a", "b", "c"))
#> a b c 
#> 1 2 3
```

Named vectors are most useful for subsetting, described next.

### Subsetting 

So far we've used `dplyr::filter()` to filter the rows in a tibble. `filter()` only works with tibble, so we'll need new tool for vectors: `[`. `[` is the subsetting function, and is called like `x[a]`. There are four types of things that you can subset a vector with:

1.  A numeric vector containing only integers. The integers must either be all 
    positive, all negative, or zero.
    
    Subsetting with positive integers keeps the elements at those positions:
    
    
```r
    x <- c("one", "two", "three", "four", "five")
    x[c(3, 2, 5)]
    #> [1] "three" "two"   "five"
```
    
    By repeating a position, you can actually make a longer output than 
    input:
    
    
```r
    x[c(1, 1, 5, 5, 5, 2)]
    #> [1] "one"  "one"  "five" "five" "five" "two"
```
    
    Negative values drop the elements at the specified positions:
    
    
```r
    x[c(-1, -3, -5)]
    #> [1] "two"  "four"
```
    
    It's an error to mix positive and negative values:
    
    
```r
    x[c(1, -1)]
    #> Error in x[c(1, -1)]: only 0's may be mixed with negative subscripts
```

    The error message mentions subsetting with zero, which returns no values:
    
    
```r
    x[0]
    #> character(0)
```
    
    This is not useful very often, but it can be helpful if you want to create 
    unusual data structures to test your functions with.
  
1.  Subsetting with a logical vector keeps all values corresponding to a
    `TRUE` value. This is most often useful in conjunction with the 
    comparison functions.
    
    
```r
    x <- c(10, 3, NA, 5, 8, 1, NA)
    
    # All non-missing values of x
    x[!is.na(x)]
    #> [1] 10  3  5  8  1
    
    # All even (or missing!) values of x
    x[x %% 2 == 0]
    #> [1] 10 NA  8 NA
```

1.  If you have a named vector, you can subset it with a character vector:
    
    
```r
    x <- c(abc = 1, def = 2, xyz = 5)
    x[c("xyz", "def")]
    #> xyz def 
    #>   5   2
```
    
    Like with positive integers, you can also use a character vector to 
    duplicate individual entries.

1.  The simplest type of subsetting is nothing, `x[]`, which returns the 
    complete `x`. This is not useful for subsetting vectors, but it is useful
    when subsetting matrices (and other high dimensional structures) because
    it lets you select all the rows or all the columns, by leaving that
    index blank. For example, if `x` is 2d, `x[1, ]` selects the first row and 
    all the columns, and `x[, -1]` selects all rows and all columns except
    the first.
    
To learn more about the applications of subsetting, reading the "Subsetting" chapter of _Advanced R_: <http://adv-r.had.co.nz/Subsetting.html#applications>.

There is an important variation of `[` called `[[`. `[[` only ever extracts a single element, and always drops names. It's a good idea to use it whenever you want to make it clear that you're extracting a single item, as in a for loop. The distinction between `[` and `[[` is most important for lists, as we'll see shortly.

### Exercises

1.  What does `mean(is.na(x))` tell you about a vector `x`? What about
    `sum(!is.finite(x))`?

1.  Carefully read the documentation of `is.vector()`. What does it actually
    test for? Why does `is.atomic()` not agree with the definition of 
    atomic vectors above?
    
1.  Compare and contrast `setNames()` with `purrr::set_names()`.

1.  Create functions that take a vector as input and returns:
    
    1. The last value.  Should you use `[` or `[[`?

    1. The elements at even numbered positions.
    
    1. Every element except the last value.
    
    1. Only even numbers (and no missing values).

1.  Why is `x[-which(x > 0)]` not the same as `x[x <= 0]`? 

1.  What happens when you subset with a positive integer that's bigger
    than the length of the vector? What happens when you subset with a 
    name that doesn't exist?
