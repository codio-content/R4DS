
Lists are a step up in complexity from atomic vectors, because lists can contain other lists. This makes them suitable for representing hierarchical or tree-like structures. You create a list with `list()`:


```r
x <- list(1, 2, 3)
x
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
```
{Run code | terminal}(Rscript code/lists.r)              


A very useful tool for working with lists is `str()` because it focusses on the **str**ucture, not the contents.


```r
str(x)
#> List of 3
#>  $ : num 1
#>  $ : num 2
#>  $ : num 3

x_named <- list(a = 1, b = 2, c = 3)
str(x_named)
#> List of 3
#>  $ a: num 1
#>  $ b: num 2
#>  $ c: num 3
```

Unlike atomic vectors, `list()` can contain a mix of objects:


```r
y <- list("a", 1L, 1.5, TRUE)
str(y)
#> List of 4
#>  $ : chr "a"
#>  $ : int 1
#>  $ : num 1.5
#>  $ : logi TRUE
```

Lists can even contain other lists!


```r
z <- list(list(1, 2), list(3, 4))
str(z)
#> List of 2
#>  $ :List of 2
#>   ..$ : num 1
#>   ..$ : num 2
#>  $ :List of 2
#>   ..$ : num 3
#>   ..$ : num 4
```
{Run code | terminal}(Rscript code/lists.r)              


### Visualising lists

To explain more complicated list manipulation functions, it's helpful to have a visual representation of lists. For example, take these three lists:


```r
x1 <- list(c(1, 2), c(3, 4))
x2 <- list(list(1, 2), list(3, 4))
x3 <- list(1, list(2, list(3)))
```

I'll draw them as follows:


![Figure 24.2](diagrams/lists-structure.png)

**Figure 24.2**

There are three principles:

1.  Lists have rounded corners. Atomic vectors have square corners.
  
1.  Children are drawn inside their parent, and have a slightly darker
    background to make it easier to see  the hierarchy.
  
1.  The orientation of the children (i.e. rows or columns) isn't important, 
    so I'll pick a row or column orientation to either save space or illustrate 
    an important property in the example.

### Subsetting

There are three ways to subset a list, which I'll illustrate with a list named `a`:


```r
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
```
{Run code | terminal}(Rscript code/lists.r)              


*   `[` extracts a sub-list. The result will always be a list.

    
```r
    str(a[1:2])
    #> List of 2
    #>  $ a: int [1:3] 1 2 3
    #>  $ b: chr "a string"
    str(a[4])
    #> List of 1
    #>  $ d:List of 2
    #>   ..$ : num -1
    #>   ..$ : num -5
```
    
    Like with vectors, you can subset with a logical, integer, or character
    vector.
    
*   `[[` extracts a single component from a list. It removes a level of 
    hierarchy from the list.

    
```r
    str(a[[1]])
    #>  int [1:3] 1 2 3
    str(a[[4]])
    #> List of 2
    #>  $ : num -1
    #>  $ : num -5
```

*   `$` is a shorthand for extracting named elements of a list. It works
    similarly to `[[` except that you don't need to use quotes.
    
    
```r
    a$a
    #> [1] 1 2 3
    a[["a"]]
    #> [1] 1 2 3
```

The distinction between `[` and `[[` is really important for lists, because `[[` drills down into the list while `[` returns a new, smaller list. Compare the code and output above with the visual representation in Figure \@ref(fig:lists-subsetting).

![Figure 24.1Subsetting a list, visually.](diagrams/lists-subsetting.png)

**Figure 24.1Subsetting a list, visually.**

### Lists of condiments

The difference between `[` and `[[` is very important, but it's easy to get confused. To help you remember, let me show you an unusual pepper shaker.


![Figure 24.3](images/pepper.jpg)

**Figure 24.3**

If this pepper shaker is your list `x`, then, `x[1]` is a pepper shaker containing a single pepper packet:


![Figure 24.4](images/pepper-1.jpg)

**Figure 24.4**

`x[2]` would look the same, but would contain the second packet. `x[1:2]` would be a pepper shaker containing two pepper packets. 

`x[[1]]` is:


![Figure 24.5](images/pepper-2.jpg)

**Figure 24.5**

If you wanted to get the content of the pepper package, you'd need `x[[1]][[1]]`:


![Figure 24.6](images/pepper-3.jpg)

**Figure 24.6**

### Exercises

1.  Draw the following lists as nested sets:

    1.  `list(a, b, list(c, d), list(e, f))`
    1.  `list(list(list(list(list(list(a))))))`

1.  What happens if you subset a tibble as if you're subsetting a list?
    What are the key differences between a list and a tibble?
