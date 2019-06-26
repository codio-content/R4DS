
There are two main differences in the usage of a tibble vs. a classic `data.frame`: printing and subsetting.

### Printing

Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen. This makes it much easier to work with large data. In addition to its name, each column reports its type, a nice feature borrowed from `str()`:


```r
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
#> # A tibble: 1,000 x 5
#>   a                   b              c     d e    
#>   <dttm>              <date>     <int> <dbl> <chr>
#> 1 2019-04-10 15:58:30 2019-04-17     1 0.368 h    
#> 2 2019-04-11 10:03:39 2019-04-22     2 0.612 n    
#> 3 2019-04-11 04:27:19 2019-05-02     3 0.415 l    
#> 4 2019-04-10 17:48:36 2019-05-01     4 0.212 x    
#> 5 2019-04-10 14:12:52 2019-04-28     5 0.733 a    
#> 6 2019-04-11 01:13:49 2019-04-24     6 0.460 v    
#> # ... with 994 more rows
```
{Run code | terminal}(Rscript code/tib.r)              


Tibbles are designed so that you don't accidentally overwhelm your console when you print large data frames. But sometimes you need more output than the default display. There are a few options that can help.

First, you can explicitly `print()` the data frame and control the number of rows (`n`) and the `width` of the display. `width = Inf` will display all columns:


```r
nycflights13::flights %>% 
  print(n = 10, width = Inf)
```

You can also control the default print behaviour by setting options:

* `options(tibble.print_max = n, tibble.print_min = m)`: if more than `n`
  rows, print only `m` rows. Use `options(tibble.print_min = Inf)` to always
  show all rows.

* Use `options(tibble.width = Inf)` to always print all columns, regardless
  of the width of the screen.

You can see a complete list of options by looking at the package help with `package?tibble`.

A final option is to use RStudio's built-in data viewer to get a scrollable view of the complete dataset. This is also often useful at the end of a long chain of manipulations.


```r
nycflights13::flights %>% 
  View()
```

### Subsetting

So far all the tools you've learned have worked with complete data frames. If you want to pull out a single variable, you need some new tools, `$` and `[[`. `[[` can extract by name or position; `$` only extracts by name but is a little less typing.


```r
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x
#> [1] 0.434 0.395 0.548 0.762 0.254
df[["x"]]
#> [1] 0.434 0.395 0.548 0.762 0.254

# Extract by position
df[[1]]
#> [1] 0.434 0.395 0.548 0.762 0.254
```
{Run code | terminal}(Rscript code/tib.r)              


To use these in a pipe, you'll need to use the special placeholder `.`:


```r
df %>% .$x
#> [1] 0.434 0.395 0.548 0.762 0.254
df %>% .[["x"]]
#> [1] 0.434 0.395 0.548 0.762 0.254
```

Compared to a `data.frame`, tibbles are more strict: they never do partial matching, and they will generate a warning if the column you are trying to access does not exist.
