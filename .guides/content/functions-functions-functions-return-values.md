
Figuring out what your function should return is usually straightforward: it's why you created the function in the first place! There are two things you should consider when returning a value: 

1. Does returning early make your function easier to read? 

2. Can you make your function pipeable?

### Explicit return statements

The value returned by the function is usually the last statement it evaluates, but you can choose to return early by using `return()`. I think it's best to save the use of `return()` to signal that you can return early with a simpler solution. A common reason to do this is because the inputs are empty:


```r
complicated_function <- function(x, y, z) {
  if (length(x) == 0 || length(y) == 0) {
    return(0)
  }
    
  # Complicated code here
}
```

Another reason is because you have a `if` statement with one complex block and one simple block. For example, you might write an if statement like this:


```r
f <- function() {
  if (x) {
    # Do 
    # something
    # that
    # takes
    # many
    # lines
    # to
    # express
  } else {
    # return something short
  }
}
```

But if the first block is very long, by the time you get to the `else`, you've forgotten the `condition`. One way to rewrite it is to use an early return for the simple case:


```r

f <- function() {
  if (!x) {
    return(something_short)
  }

  # Do 
  # something
  # that
  # takes
  # many
  # lines
  # to
  # express
}
```

This tends to make the code easier to understand, because you don't need quite so much context to understand it.

### Writing pipeable functions

If you want to write your own pipeable functions, it's important to think about the return value. Knowing the return value's object type will mean that your pipeline will "just work". For example, with dplyr and tidyr the object type is the data frame. 

There are two basic types of pipeable functions: transformations and side-effects. With __transformations__, an object is passed to the function's first argument and a modified object is returned. With __side-effects__, the passed object is not transformed. Instead, the function performs an action on the object, like drawing a plot or saving a file. Side-effects functions should "invisibly" return the first argument, so that while they're not printed they can still be used in a pipeline. For example, this simple function prints the number of missing values in a data frame:


```r
show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}
```

If we call it interactively, the `invisible()` means that the input `df` doesn't get printed out:


```r
show_missings(mtcars)
#> Missing values: 0
```

But it's still there, it's just not printed by default:


```r
x <- show_missings(mtcars) 
#> Missing values: 0
class(x)
#> [1] "data.frame"
dim(x)
#> [1] 32 11
```

And we can still use it in a pipe:



```r
mtcars %>% 
  show_missings() %>% 
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings() 
#> Missing values: 0
#> Missing values: 18
```
