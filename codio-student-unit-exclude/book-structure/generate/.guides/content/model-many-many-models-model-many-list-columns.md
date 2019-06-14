
Now that you've seen a basic workflow for managing many models, let's dive back into some of the details. In this section, we'll explore the list-column data structure in a little more detail. It's only recently that I've really appreciated the idea of the list-column. List-columns are implicit in the definition of the data frame: a data frame is a named list of equal length vectors. A list is a vector, so it's always been legitimate to use a list as a column of a data frame. However, base R doesn't make it easy to create list-columns, and `data.frame()` treats a list as a list of columns:.


```r
data.frame(x = list(1:3, 3:5))
#>   x.1.3 x.3.5
#> 1     1     3
#> 2     2     4
#> 3     3     5
```

You can prevent `data.frame()` from doing this with `I()`, but the result doesn't print particularly well:


```r
data.frame(
  x = I(list(1:3, 3:5)), 
  y = c("1, 2", "3, 4, 5")
)
#>         x       y
#> 1 1, 2, 3    1, 2
#> 2 3, 4, 5 3, 4, 5
```

Tibble alleviates this problem by being lazier (`tibble()` doesn't modify its inputs) and by providing a better print method:


```r
tibble(
  x = list(1:3, 3:5), 
  y = c("1, 2", "3, 4, 5")
)
#> # A tibble: 2 x 2
#>   x         y      
#>   <list>    <chr>  
#> 1 <int [3]> 1, 2   
#> 2 <int [3]> 3, 4, 5
```

It's even easier with `tribble()` as it can automatically work out that you need a list:


```r
tribble(
   ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)
#> # A tibble: 2 x 2
#>   x         y      
#>   <list>    <chr>  
#> 1 <int [3]> 1, 2   
#> 2 <int [3]> 3, 4, 5
```

List-columns are often most useful as intermediate data structure. They're hard to work with directly, because most R functions work with atomic vectors or data frames, but the advantage of keeping related items together in a data frame is worth a little hassle.

Generally there are three parts of an effective list-column pipeline:

1.  You create the list-column using one of `nest()`, `summarise()` + `list()`,
    or `mutate()` + a map function, as described in [Creating list-columns].

1.  You create other intermediate list-columns by transforming existing
    list columns with `map()`, `map2()` or `pmap()`. For example, 
    in the case study above, we created a list-column of models by transforming
    a list-column of data frames.
    
1.  You simplify the list-column back down to a data frame or atomic vector,
    as described in [Simplifying list-columns].
