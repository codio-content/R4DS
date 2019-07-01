
The pattern of looping over a vector, doing something to each element and saving the results is so common that the purrr package provides a family of functions to do it for you. There is one function for each type of output:

* `map()`     makes a list.
* `map_lgl()` makes a logical vector.
* `map_int()` makes an integer vector.
* `map_dbl()` makes a double vector.
* `map_chr()` makes a character vector.

Each function takes a vector as input, applies a function to each piece, and then returns a new vector that's the same length (and has the same names) as the input. The type of the vector is determined by the suffix to the map function. 

Once you master these functions, you'll find it takes much less time to solve iteration problems. But you should never feel bad about using a for loop instead of a map function. The map functions are a step up a tower of abstraction, and it can take a long time to get your head around how they work. The important thing is that you solve the problem that you're working on, not write the most concise and elegant code (although that's definitely something you want to strive towards!).

Some people will tell you to avoid for loops because they are slow. They're wrong! (Well at least they're rather out of date, as for loops haven't been slow for many years). The chief benefits of using functions like `map()` is not speed, but clarity: they make your code easier to write and to read.

We can use these functions to perform the same computations as the last for loop. Those summary functions returned doubles, so we need to use `map_dbl()`:


```r
map_dbl(df, mean)
#>       a       b       c       d 
#>  0.2026 -0.2068  0.1275 -0.0917
map_dbl(df, median)
#>      a      b      c      d 
#>  0.237 -0.218  0.254 -0.133
map_dbl(df, sd)
#>     a     b     c     d 
#> 0.796 0.759 1.164 1.062
```
{Run code | terminal}(Rscript code/map.r)              


Compared to using a for loop, focus is on the operation being performed (i.e. `mean()`, `median()`, `sd()`), not the bookkeeping required to loop over every element and store the output. This is even more apparent if we use the pipe:


```r
df %>% map_dbl(mean)
#>       a       b       c       d 
#>  0.2026 -0.2068  0.1275 -0.0917
df %>% map_dbl(median)
#>      a      b      c      d 
#>  0.237 -0.218  0.254 -0.133
df %>% map_dbl(sd)
#>     a     b     c     d 
#> 0.796 0.759 1.164 1.062
```

There are a few differences between `map_*()` and `col_summary()`:

*   All purrr functions are implemented in C. This makes them a little faster
    at the expense of readability.
    
*   The second argument, `.f`, the function to apply, can be a formula, a 
    character vector, or an integer vector. You'll learn about those handy 
    shortcuts in the next section.
    
*   `map_*()` uses ... ([dot dot dot]) to pass along additional arguments 
    to `.f` each time it's called:

    
```r
    map_dbl(df, mean, trim = 0.5)
    #>      a      b      c      d 
    #>  0.237 -0.218  0.254 -0.133
```

*   The map functions also preserve names:

    
```r
    z <- list(x = 1:3, y = 4:5)
    map_int(z, length)
    #> x y 
    #> 3 2
```

### Shortcuts

There are a few shortcuts that you can use with `.f` in order to save a little typing. Imagine you want to fit a linear model to each group in a dataset. The following toy example splits the up the `mtcars` dataset in to three pieces (one for each value of cylinder) and fits the same linear model to each piece:  


```r
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))
```
{Run code | terminal}(Rscript code/map.r)              


The syntax for creating an anonymous function in R is quite verbose so purrr provides a convenient shortcut: a one-sided formula.


```r
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))
```

Here I've used `.` as a pronoun: it refers to the current list element (in the same way that `i` referred to the current index in the for loop). 

When you're looking at many models, you might want to extract a summary statistic like the $R^2$. To do that we need to first run `summary()` and then extract the component called `r.squared`. We could do that using the shorthand for anonymous functions:


```r
models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)
#>     4     6     8 
#> 0.509 0.465 0.423
```

But extracting named components is a common operation, so purrr provides an even shorter shortcut: you can use a string.


```r
models %>% 
  map(summary) %>% 
  map_dbl("r.squared")
#>     4     6     8 
#> 0.509 0.465 0.423
```

You can also use an integer to select elements by position: 


```r
x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>% map_dbl(2)
#> [1] 2 5 8
```

### Base R
  
If you're familiar with the apply family of functions in base R, you might have noticed some similarities with the purrr functions:

*   `lapply()` is basically identical to `map()`, except that `map()` is 
    consistent with all the other functions in purrr, and you can use the 
    shortcuts for `.f`.

*   Base `sapply()` is a wrapper around `lapply()` that automatically
    simplifies the output. This is useful for interactive work but is 
    problematic in a function because you never know what sort of output
    you'll get:
    
    
```r
    x1 <- list(
      c(0.27, 0.37, 0.57, 0.91, 0.20),
      c(0.90, 0.94, 0.66, 0.63, 0.06), 
      c(0.21, 0.18, 0.69, 0.38, 0.77)
    )
    x2 <- list(
      c(0.50, 0.72, 0.99, 0.38, 0.78), 
      c(0.93, 0.21, 0.65, 0.13, 0.27), 
      c(0.39, 0.01, 0.38, 0.87, 0.34)
    )
    
    threshold <- function(x, cutoff = 0.8) x[x > cutoff]
    x1 %>% sapply(threshold) %>% str()
    #> List of 3
    #>  $ : num 0.91
    #>  $ : num [1:2] 0.9 0.94
    #>  $ : num(0)
    x2 %>% sapply(threshold) %>% str()
    #>  num [1:3] 0.99 0.93 0.87
```
{Run code | terminal}(Rscript code/map.r)              


*   `vapply()` is a safe alternative to `sapply()` because you supply an
    additional argument that defines the type. The only problem with 
    `vapply()` is that it's a lot of typing: 
    `vapply(df, is.numeric, logical(1))` is equivalent to
    `map_lgl(df, is.numeric)`. One advantage of `vapply()` over purrr's map
    functions is that it can also produce matrices --- the map functions only 
    ever produce vectors.

I focus on purrr functions here because they have more consistent names and arguments, helpful shortcuts, and in the future will provide easy parallelism and progress bars.

### Exercises

1.  Write code that uses one of the map functions to:

    1. Compute the mean of every column in `mtcars`.
    1. Determine the type of each column in `nycflights13::flights`.
    1. Compute the number of unique values in each column of `iris`.
    1. Generate 10 random normals for each of $\mu = -10$, $0$, $10$, and $100$.

1.  How can you create a single vector that for each column in a data frame
    indicates whether or not it's a factor?

1.  What happens when you use the map functions on vectors that aren't lists?
    What does `map(1:5, runif)` do? Why?
    
1.  What does `map(-2:2, rnorm, n = 5)` do? Why?
    What does `map_dbl(-2:2, rnorm, n = 5)` do? Why?

1.  Rewrite `map(x, function(df) lm(mpg ~ wt, data = df))` to eliminate the 
    anonymous function. 
