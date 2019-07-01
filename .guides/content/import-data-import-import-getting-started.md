
Most of readr's functions are concerned with turning flat files into data frames:

* `read_csv()` reads comma delimited files, `read_csv2()` reads semicolon
  separated files (common in countries where `,` is used as the decimal place),
  `read_tsv()` reads tab delimited files, and `read_delim()` reads in files
  with any delimiter.

* `read_fwf()` reads fixed width files. You can specify fields either by their
  widths with `fwf_widths()` or their position with `fwf_positions()`.
  `read_table()` reads a common variation of fixed width files where columns
  are separated by white space.

* `read_log()` reads Apache style log files. (But also check out
  [webreadr](https://github.com/Ironholds/webreadr) which is built on top
  of `read_log()` and provides many more helpful tools.)

These functions all have similar syntax: once you've mastered one, you can use the others with ease. For the rest of this chapter we'll focus on `read_csv()`. Not only are csv files one of the most common forms of data storage, but once you understand `read_csv()`, you can easily apply your knowledge to all the other functions in readr.

The first argument to `read_csv()` is the most important: it's the path to the file to read.


```r
heights <- read_csv("data/heights.csv")
#> Parsed with column specification:
#> cols(
#>   earn = col_double(),
#>   height = col_double(),
#>   sex = col_character(),
#>   ed = col_double(),
#>   age = col_double(),
#>   race = col_character()
#> )
```
{Run code | terminal}(Rscript code/startImport.r)


When you run `read_csv()` it prints out a column specification that gives the name and type of each column. That's an important part of readr, which we'll come back to in [parsing a file].

You can also supply an inline csv file. This is useful for experimenting with readr and for creating reproducible examples to share with others:


```r
read_csv("a,b,c
1,2,3
4,5,6")
#> # A tibble: 2 x 3
#>       a     b     c
#>   <dbl> <dbl> <dbl>
#> 1     1     2     3
#> 2     4     5     6
```

In both cases `read_csv()` uses the first line of the data for the column names, which is a very common convention. There are two cases where you might want to tweak this behaviour:

1.  Sometimes there are a few lines of metadata at the top of the file. You can
    use `skip = n` to skip the first `n` lines; or use `comment = "#"` to drop
    all lines that start with (e.g.) `#`.
    
    
```r
    read_csv("The first line of metadata
      The second line of metadata
      x,y,z
      1,2,3", skip = 2)
    #> # A tibble: 1 x 3
    #>       x     y     z
    #>   <dbl> <dbl> <dbl>
    #> 1     1     2     3
    
    read_csv("# A comment I want to skip
      x,y,z
      1,2,3", comment = "#")
    #> # A tibble: 1 x 3
    #>       x     y     z
    #>   <dbl> <dbl> <dbl>
    #> 1     1     2     3
```
{Run code | terminal}(Rscript code/startImport.r)

    
1.  The data might not have column names. You can use `col_names = FALSE` to
    tell `read_csv()` not to treat the first row as headings, and instead
    label them sequentially from `X1` to `Xn`:
    
    
```r
    read_csv("1,2,3\n4,5,6", col_names = FALSE)
    #> # A tibble: 2 x 3
    #>      X1    X2    X3
    #>   <dbl> <dbl> <dbl>
    #> 1     1     2     3
    #> 2     4     5     6
```
    
    (`"\n"` is a convenient shortcut for adding a new line. You'll learn more
    about it and other types of string escape in [string basics].)
    
    Alternatively you can pass `col_names` a character vector which will be
    used as the column names:
    
    
```r
    read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))
    #> # A tibble: 2 x 3
    #>       x     y     z
    #>   <dbl> <dbl> <dbl>
    #> 1     1     2     3
    #> 2     4     5     6
```
{Run code | terminal}(Rscript code/startImport.r)


Another option that commonly needs tweaking is `na`: this specifies the value (or values) that are used to represent missing values in your file:


```r
read_csv("a,b,c\n1,2,.", na = ".")
#> # A tibble: 1 x 3
#>       a     b c    
#>   <dbl> <dbl> <lgl>
#> 1     1     2 NA
```
{Run code | terminal}(Rscript code/startImport.r)


This is all you need to know to read ~75% of CSV files that you'll encounter in practice. You can also easily adapt what you've learned to read tab separated files with `read_tsv()` and fixed width files with `read_fwf()`. To read in more challenging files, you'll need to learn more about how readr parses each column, turning them into R vectors.

### Compared to base R

If you've used R before, you might wonder why we're not using `read.csv()`. There are a few good reasons to favour readr functions over the base equivalents:

* They are typically much faster (~10x) than their base equivalents.
  Long running jobs have a progress bar, so you can see what's happening. 
  If you're looking for raw speed, try `data.table::fread()`. It doesn't fit 
  quite so well into the tidyverse, but it can be quite a bit faster.

* They produce tibbles, they don't convert character vectors to factors,
  use row names, or munge the column names. These are common sources of
  frustration with the base R functions.

* They are more reproducible. Base R functions inherit some behaviour from
  your operating system and environment variables, so import code that works 
  on your computer might not work on someone else's.

### Exercises

1.  What function would you use to read a file where fields were separated with  
    "|"?
    
1.  Apart from `file`, `skip`, and `comment`, what other arguments do
    `read_csv()` and `read_tsv()` have in common?
    
1.  What are the most important arguments to `read_fwf()`?
   
1.  Sometimes strings in a CSV file contain commas. To prevent them from
    causing problems they need to be surrounded by a quoting character, like
    `"` or `'`. By convention, `read_csv()` assumes that the quoting
    character will be `"`, and if you want to change it you'll need to
    use `read_delim()` instead. What arguments do you need to specify
    to read the following text into a data frame?
    
    
```r
    "x,y\n1,'a,b'"
```
    
1.  Identify what is wrong with each of the following inline CSV files. 
    What happens when you run the code?
    
    
```r
    read_csv("a,b\n1,2,3\n4,5,6")
    read_csv("a,b,c\n1,2\n1,2,3,4")
    read_csv("a,b\n\"1")
    read_csv("a,b\n1,2\na,b")
    read_csv("a;b\n1;3")
```
