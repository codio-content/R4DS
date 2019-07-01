
Typically, you won't create list-columns with `tibble()`. Instead, you'll create them from regular columns, using one of three methods: 

1.  With `tidyr::nest()` to convert a grouped data frame into a nested data 
    frame where you have list-column of data frames.
    
1.  With `mutate()` and vectorised functions that return a list.

1.  With `summarise()` and summary functions that return multiple results. 

Alternatively, you might create them from a named list, using `tibble::enframe()`.

Generally, when creating list-columns, you should make sure they're homogeneous: each element should contain the same type of thing. There are no checks to make sure this is true, but if you use purrr and remember what you've learned about type-stable functions, you should find it happens naturally.

### With nesting

`nest()` creates a nested data frame, which is a data frame with a list-column of data frames. In a nested data frame each row is a meta-observation: the other columns give variables that define the observation (like country and continent above), and the list-column of data frames gives the individual observations that make up the meta-observation.

There are two ways to use `nest()`. So far you've seen how to use it with a grouped data frame. When applied to a grouped data frame, `nest()` keeps the grouping columns as is, and bundles everything else into the list-column:


```r
gapminder %>% 
  group_by(country, continent) %>% 
  nest()
#> # A tibble: 142 x 3
#>   country     continent data             
#>   <fct>       <fct>     <list>           
#> 1 Afghanistan Asia      <tibble [12 x 4]>
#> 2 Albania     Europe    <tibble [12 x 4]>
#> 3 Algeria     Africa    <tibble [12 x 4]>
#> 4 Angola      Africa    <tibble [12 x 4]>
#> 5 Argentina   Americas  <tibble [12 x 4]>
#> 6 Australia   Oceania   <tibble [12 x 4]>
#> # ... with 136 more rows
```
{Run code | terminal}(Rscript code/listCols.r)              


You can also use it on an ungrouped data frame, specifying which columns you want to nest:


```r
gapminder %>% 
  nest(year:gdpPercap)
#> # A tibble: 142 x 3
#>   country     continent data             
#>   <fct>       <fct>     <list>           
#> 1 Afghanistan Asia      <tibble [12 x 4]>
#> 2 Albania     Europe    <tibble [12 x 4]>
#> 3 Algeria     Africa    <tibble [12 x 4]>
#> 4 Angola      Africa    <tibble [12 x 4]>
#> 5 Argentina   Americas  <tibble [12 x 4]>
#> 6 Australia   Oceania   <tibble [12 x 4]>
#> # ... with 136 more rows
```

### From vectorised functions

Some useful functions take an atomic vector and return a list. For example, in [strings] you learned about `stringr::str_split()` which takes a character vector and returns a list of character vectors. If you use that inside mutate, you'll get a list-column:


```r
df <- tribble(
  ~x1,
  "a,b,c", 
  "d,e,f,g"
) 

df %>% 
  mutate(x2 = stringr::str_split(x1, ","))
#> # A tibble: 2 x 2
#>   x1      x2       
#>   <chr>   <list>   
#> 1 a,b,c   <chr [3]>
#> 2 d,e,f,g <chr [4]>
```
{Run code | terminal}(Rscript code/listCols.r)              


`unnest()` knows how to handle these lists of vectors:


```r
df %>% 
  mutate(x2 = stringr::str_split(x1, ",")) %>% 
  unnest()
#> # A tibble: 7 x 2
#>   x1      x2   
#>   <chr>   <chr>
#> 1 a,b,c   a    
#> 2 a,b,c   b    
#> 3 a,b,c   c    
#> 4 d,e,f,g d    
#> 5 d,e,f,g e    
#> 6 d,e,f,g f    
#> # ... with 1 more row
```

(If you find yourself using this pattern a lot, make sure to check out `tidyr::separate_rows()` which is a wrapper around this common pattern).

Another example of this pattern is using the `map()`, `map2()`, `pmap()` from purrr. For example, we could take the final example from [Invoking different functions] and rewrite it to use `mutate()`:


```r
sim <- tribble(
  ~f,      ~params,
  "runif", list(min = -1, max = 1),
  "rnorm", list(sd = 5),
  "rpois", list(lambda = 10)
)

sim %>%
  mutate(sims = invoke_map(f, params, n = 10))
#> # A tibble: 3 x 3
#>   f     params     sims      
#>   <chr> <list>     <list>    
#> 1 runif <list [2]> <dbl [10]>
#> 2 rnorm <list [1]> <dbl [10]>
#> 3 rpois <list [1]> <int [10]>
```
{Run code | terminal}(Rscript code/listCols.r)              


Note that technically `sim` isn't homogeneous because it contains both double and integer vectors. However, this is unlikely to cause many problems since integers and doubles are both numeric vectors.

### From multivalued summaries

One restriction of `summarise()` is that it only works with summary functions that return a single value. That means that you can't use it with functions like `quantile()` that return a vector of arbitrary length:


```r
mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = quantile(mpg))
#> Error: Column `q` must be length 1 (a summary value), not 5
```

You can however, wrap the result in a list! This obeys the contract of `summarise()`, because each summary is now a list (a vector) of length 1.


```r
mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg)))
#> # A tibble: 3 x 2
#>     cyl q        
#>   <dbl> <list>   
#> 1     4 <dbl [5]>
#> 2     6 <dbl [5]>
#> 3     8 <dbl [5]>
```

To make useful results with unnest, you'll also need to capture the probabilities:


```r
probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)
mtcars %>% 
  group_by(cyl) %>% 
  summarise(p = list(probs), q = list(quantile(mpg, probs))) %>% 
  unnest()
#> # A tibble: 15 x 3
#>     cyl     p     q
#>   <dbl> <dbl> <dbl>
#> 1     4  0.01  21.4
#> 2     4  0.25  22.8
#> 3     4  0.5   26  
#> 4     4  0.75  30.4
#> 5     4  0.99  33.8
#> 6     6  0.01  17.8
#> # ... with 9 more rows
```
{Run code | terminal}(Rscript code/listCols.r)              


### From a named list

Data frames with list-columns provide a solution to a common problem: what do you do if you want to iterate over both the contents of a list and its elements? Instead of trying to jam everything into one object, it's often easier to make a data frame: one column can contain the elements, and one column can contain the list.  An easy way to create such a data frame from a list is `tibble::enframe()`.  


```r
x <- list(
  a = 1:5,
  b = 3:4, 
  c = 5:6
) 

df <- enframe(x)
df
#> # A tibble: 3 x 2
#>   name  value    
#>   <chr> <list>   
#> 1 a     <int [5]>
#> 2 b     <int [2]>
#> 3 c     <int [2]>
```

The advantage of this structure is that it generalises in a straightforward way - names are useful if you have character vector of metadata, but don't help if you have other types of data, or multiple vectors.

Now if you want to iterate over names and values in parallel, you can use `map2()`:


```r
df %>% 
  mutate(
    smry = map2_chr(name, value, ~ stringr::str_c(.x, ": ", .y[1]))
  )
#> # A tibble: 3 x 3
#>   name  value     smry 
#>   <chr> <list>    <chr>
#> 1 a     <int [5]> a: 1 
#> 2 b     <int [2]> b: 3 
#> 3 c     <int [2]> c: 5
```
{Run code | terminal}(Rscript code/listCols.r)              


### Exercises

1.  List all the functions that you can think of that take a atomic vector and 
    return a list.
    
1.  Brainstorm useful summary functions that, like `quantile()`, return
    multiple values.
    
1.  What's missing in the following data frame? How does `quantile()` return
    that missing piece? Why isn't that helpful here?

    
```r
    mtcars %>% 
      group_by(cyl) %>% 
      summarise(q = list(quantile(mpg))) %>% 
      unnest()
    #> # A tibble: 15 x 2
    #>     cyl     q
    #>   <dbl> <dbl>
    #> 1     4  21.4
    #> 2     4  22.8
    #> 3     4  26  
    #> 4     4  30.4
    #> 5     4  33.9
    #> 6     6  17.8
    #> # ... with 9 more rows
```

1.  What does this code do? Why might might it be useful?

    
```r
    mtcars %>% 
      group_by(cyl) %>% 
      summarise_each(funs(list))
```
