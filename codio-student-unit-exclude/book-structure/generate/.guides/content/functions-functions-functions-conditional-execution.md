
An `if` statement allows you to conditionally execute code. It looks like this:


```r
if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}
```

To get help on `if` you need to surround it in backticks: `` ?`if` ``. The help isn't particularly helpful if you're not already an experienced programmer, but at least you know how to get to it!

Here's a simple function that uses an `if` statement. The goal of this function is to return a logical vector describing whether or not each element of a vector is named.


```r
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
```

This function takes advantage of the standard return rule: a function returns the last value that it computed. Here that is either one of the two branches of the `if` statement.

### Conditions

The `condition` must evaluate to either `TRUE` or `FALSE`. If it's a vector, you'll get a warning message; if it's an `NA`, you'll get an error. Watch out for these messages in your own code:


```r
if (c(TRUE, FALSE)) {}
#> Warning in if (c(TRUE, FALSE)) {: the condition has length > 1 and only the
#> first element will be used
#> NULL

if (NA) {}
#> Error in if (NA) {: missing value where TRUE/FALSE needed
```

You can use `||` (or) and `&&` (and) to combine multiple logical expressions. These operators are "short-circuiting": as soon as `||` sees the first `TRUE` it returns `TRUE` without computing anything else. As soon as `&&` sees the first `FALSE` it returns `FALSE`. You should never use `|` or `&` in an `if` statement: these are vectorised operations that apply to multiple values (that's why you use them in `filter()`). If you do have a logical vector, you can use `any()` or `all()` to collapse it to a single value.

Be careful when testing for equality. `==` is vectorised, which means that it's easy to get more than one output.  Either check the length is already 1, collapse with `all()` or `any()`, or use the non-vectorised `identical()`. `identical()` is very strict: it always returns either a single `TRUE` or a single `FALSE`, and doesn't coerce types. This means that you need to be careful when comparing integers and doubles:


```r
identical(0L, 0)
#> [1] FALSE
```

You also need to be wary of floating point numbers:


```r
x <- sqrt(2) ^ 2
x
#> [1] 2
x == 2
#> [1] FALSE
x - 2
#> [1] 4.44e-16
```

Instead use `dplyr::near()` for comparisons, as described in [comparisons].

And remember, `x == NA` doesn't do anything useful!

### Multiple conditions

You can chain multiple if statements together:


```r
if (this) {
  # do that
} else if (that) {
  # do something else
} else {
  # 
}
```

But if you end up with a very long series of chained `if` statements, you should consider rewriting. One useful technique is the `switch()` function. It allows you to evaluate selected code based on position or name.


```
#> function(x, y, op) {
#>   switch(op,
#>     plus = x + y,
#>     minus = x - y,
#>     times = x * y,
#>     divide = x / y,
#>     stop("Unknown op!")
#>   )
#> }
```

Another useful function that can often eliminate long chains of `if` statements is `cut()`. It's used to discretise continuous variables.

### Code style

Both `if` and `function` should (almost) always be followed by squiggly brackets (`{}`), and the contents should be indented by two spaces. This makes it easier to see the hierarchy in your code by skimming the left-hand margin.

An opening curly brace should never go on its own line and should always be followed by a new line. A closing curly brace should always go on its own line, unless it's followed by `else`. Always indent the code inside curly braces.


```r
# Good
if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

# Bad
if (y < 0 && debug)
message("Y is negative")

if (y == 0) {
  log(x)
} 
else {
  y ^ x
}
```

It's ok to drop the curly braces if you have a very short `if` statement that can fit on one line:


```r
y <- 10
x <- if (y < 20) "Too low" else "Too high"
```

I recommend this only for very brief `if` statements. Otherwise, the full form is easier to read:


```r
if (y < 20) {
  x <- "Too low" 
} else {
  x <- "Too high"
}
```

### Exercises

1.  What's the difference between `if` and `ifelse()`? Carefully read the help
    and construct three examples that illustrate the key differences.

1.  Write a greeting function that says "good morning", "good afternoon",
    or "good evening", depending on the time of day. (Hint: use a time
    argument that defaults to `lubridate::now()`. That will make it 
    easier to test your function.)

1.  Implement a `fizzbuzz` function. It takes a single number as input. If
    the number is divisible by three, it returns "fizz". If it's divisible by
    five it returns "buzz". If it's divisible by three and five, it returns
    "fizzbuzz". Otherwise, it returns the number. Make sure you first write 
    working code before you create the function.
    
1.  How could you use `cut()` to simplify this set of nested if-else statements?

    
```r
    if (temp <= 0) {
      "freezing"
    } else if (temp <= 10) {
      "cold"
    } else if (temp <= 20) {
      "cool"
    } else if (temp <= 30) {
      "warm"
    } else {
      "hot"
    }
```
    
    How would you change the call to `cut()` if I'd used `<` instead of `<=`?
    What is the other chief advantage of `cut()` for this problem? (Hint:
    what happens if you have many values in `temp`?)

1.  What happens if you use `switch()` with numeric values?

1.  What does this `switch()` call do? What happens if `x` is "e"?

    
```r
    switch(x, 
      a = ,
      b = "ab",
      c = ,
      d = "cd"
    )
```
    
    Experiment, then carefully read the documentation. 
