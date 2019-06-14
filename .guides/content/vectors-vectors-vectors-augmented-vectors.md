
Atomic vectors and lists are the building blocks for other important vector types like factors and dates. I call these __augmented vectors__, because they are vectors with additional __attributes__, including class. Because augmented vectors have a class, they behave differently to the atomic vector on which they are built. In this book, we make use of four important augmented vectors:

* Factors
* Dates 
* Date-times
* Tibbles

These are described below.

### Factors

Factors are designed to represent categorical data that can take a fixed set of possible values. Factors are built on top of integers, and have a levels attribute:


```r
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
#> [1] "integer"
attributes(x)
#> $levels
#> [1] "ab" "cd" "ef"
#> 
#> $class
#> [1] "factor"
```

### Dates and date-times

Dates in R are numeric vectors that represent the number of days since 1 January 1970.


```r
x <- as.Date("1971-01-01")
unclass(x)
#> [1] 365

typeof(x)
#> [1] "double"
attributes(x)
#> $class
#> [1] "Date"
```

Date-times are numeric vectors with class `POSIXct` that represent the number of seconds since 1 January 1970. (In case you were wondering, "POSIXct" stands for "Portable Operating System Interface", calendar time.)


```r
x <- lubridate::ymd_hm("1970-01-01 01:00")
unclass(x)
#> [1] 3600
#> attr(,"tzone")
#> [1] "UTC"

typeof(x)
#> [1] "double"
attributes(x)
#> $class
#> [1] "POSIXct" "POSIXt" 
#> 
#> $tzone
#> [1] "UTC"
```

The `tzone` attribute is optional. It controls how the time is printed, not what absolute time it refers to.


```r
attr(x, "tzone") <- "US/Pacific"
x
#> [1] "1969-12-31 17:00:00 PST"

attr(x, "tzone") <- "US/Eastern"
x
#> [1] "1969-12-31 20:00:00 EST"
```

There is another type of date-times called POSIXlt. These are built on top of named lists:


```r
y <- as.POSIXlt(x)
typeof(y)
#> [1] "list"
attributes(y)
#> $names
#>  [1] "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"  
#>  [8] "yday"   "isdst"  "zone"   "gmtoff"
#> 
#> $class
#> [1] "POSIXlt" "POSIXt" 
#> 
#> $tzone
#> [1] "US/Eastern" "EST"        "EDT"
```

POSIXlts are rare inside the tidyverse. They do crop up in base R, because they are needed to extract specific components of a date, like the year or month. Since lubridate provides helpers for you to do this instead, you don't need them. POSIXct's are always easier to work with, so if you find you have a POSIXlt, you should always convert it to a regular data time `lubridate::as_date_time()`.

### Tibbles

Tibbles are augmented lists: they have class "tbl_df" + "tbl" + "data.frame", and `names` (column) and `row.names` attributes:


```r
tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb)
#> [1] "list"
attributes(tb)
#> $names
#> [1] "x" "y"
#> 
#> $row.names
#> [1] 1 2 3 4 5
#> 
#> $class
#> [1] "tbl_df"     "tbl"        "data.frame"
```

The difference between a tibble and a list is that all the elements of a data frame must be vectors with the same length. All functions that work with tibbles enforce this constraint.

Traditional data.frames have a very similar structure:


```r
df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
#> [1] "list"
attributes(df)
#> $names
#> [1] "x" "y"
#> 
#> $class
#> [1] "data.frame"
#> 
#> $row.names
#> [1] 1 2 3 4 5
```

The main difference is the class. The class of tibble includes "data.frame" which means tibbles inherit the regular data frame behaviour by default.

### Exercises

1.  What does `hms::hms(3600)` return? How does it print? What primitive
    type is the augmented vector built on top of? What attributes does it 
    use?
    
1.  Try and make a tibble that has columns with different lengths. What
    happens?

1.  Based on the definition above, is it ok to have a list as a
    column of a tibble?