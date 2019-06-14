
The last component of a function is its environment. This is not something you need to understand deeply when you first start writing functions. However, it's important to know a little bit about environments because they are crucial to how functions work. The environment of a function controls how R finds the value associated with a name. For example, take this function:


```r
f <- function(x) {
  x + y
} 
```

In many programming languages, this would be an error, because `y` is not defined inside the function. In R, this is valid code because R uses rules called __lexical scoping__ to find the value associated with a name. Since `y` is not defined inside the function, R will look in the __environment__ where the function was defined:


```r
y <- 100
f(10)
#> [1] 110

y <- 1000
f(10)
#> [1] 1010
```

This behaviour seems like a recipe for bugs, and indeed you should avoid creating functions like this deliberately, but by and large it doesn't cause too many problems (especially if you regularly restart R to get to a clean slate). 

The advantage of this behaviour is that from a language standpoint it allows R to be very consistent. Every name is looked up using the same set of rules. For `f()` that includes the behaviour of two things that you might not expect: `{` and `+`. This allows you to do devious things like:


```r
`+` <- function(x, y) {
  if (runif(1) < 0.1) {
    sum(x, y)
  } else {
    sum(x, y) * 1.1
  }
}
table(replicate(1000, 1 + 2))
#> 
#>   3 3.3 
#> 100 900
rm(`+`)
```

This is a common phenomenon in R. R places few limits on your power. You can do many things that you can't do in other programming languages. You can do many things that 99% of the time are extremely ill-advised (like overriding how addition works!). But this power and flexibility is what makes tools like ggplot2 and dplyr possible. Learning how to make best use of this flexibility is beyond the scope of this book, but you can read about in [_Advanced R_](http://adv-r.had.co.nz).