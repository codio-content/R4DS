
Any vector can contain arbitrary additional metadata through its __attributes__. You can think of attributes as named list of vectors that can be attached to any object. 
You can get and set individual attribute values with `attr()` or see them all at once with `attributes()`.


```r
x <- 1:10
attr(x, "greeting")
#> NULL
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)
#> $greeting
#> [1] "Hi!"
#> 
#> $farewell
#> [1] "Bye!"
```
{Run code | terminal}(Rscript code/attr.r)              


There are three very important attributes that are used to implement fundamental parts of R:

1. __Names__ are used to name the elements of a vector.
1. __Dimensions__ (dims, for short) make a vector behave like a matrix or array.
1. __Class__ is used to implement the S3 object oriented system.

You've seen names above, and we won't cover dimensions because we don't use matrices in this book. It remains to describe the class, which controls how __generic functions__ work. Generic functions are key to object oriented programming in R, because they make functions behave differently for different classes of input. A detailed discussion of object oriented programming is beyond the scope of this book, but you can read more about it in _Advanced R_ at <http://adv-r.had.co.nz/OO-essentials.html#s3>.

Here's what a typical generic function looks like:


```r
as.Date
#> function (x, ...) 
#> UseMethod("as.Date")
#> <bytecode: 0x7faa8e4b1568>
#> <environment: namespace:base>
```

The call to "UseMethod" means that this is a generic function, and it will call a specific __method__, a function, based on the class of the first argument. (All methods are functions; not all functions are methods). You can list all the methods for a generic with `methods()`:


```r
methods("as.Date")
#> [1] as.Date.character as.Date.default   as.Date.factor    as.Date.numeric  
#> [5] as.Date.POSIXct   as.Date.POSIXlt  
#> see '?methods' for accessing help and source code
```

For example, if `x` is a character vector, `as.Date()` will call `as.Date.character()`; if it's a factor, it'll call `as.Date.factor()`.

You can see the specific implementation of a method with `getS3method()`:


```r
getS3method("as.Date", "default")
#> function (x, ...) 
#> {
#>     if (inherits(x, "Date")) 
#>         x
#>     else if (is.logical(x) && all(is.na(x))) 
#>         .Date(as.numeric(x))
#>     else stop(gettextf("do not know how to convert '%s' to class %s", 
#>         deparse(substitute(x)), dQuote("Date")), domain = NA)
#> }
#> <bytecode: 0x7faa8fd9b8a8>
#> <environment: namespace:base>
getS3method("as.Date", "numeric")
#> function (x, origin, ...) 
#> {
#>     if (missing(origin)) 
#>         stop("'origin' must be supplied")
#>     as.Date(origin, ...) + x
#> }
#> <bytecode: 0x7faa8fda1f70>
#> <environment: namespace:base>
```
{Run code | terminal}(Rscript code/attr.r)              


The most important S3 generic is `print()`: it controls how the object is printed when you type its name at the console. Other important generics are the subsetting functions `[`, `[[`, and `$`. 
