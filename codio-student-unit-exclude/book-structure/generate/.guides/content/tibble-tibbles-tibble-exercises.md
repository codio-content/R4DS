
1.  How can you tell if an object is a tibble? (Hint: try printing `mtcars`,
    which is a regular data frame). 

1.  Compare and contrast the following operations on a `data.frame` and 
    equivalent tibble. What is different? Why might the default data frame
    behaviours cause you frustration?
    
    
```r
    df <- data.frame(abc = 1, xyz = "a")
    df$x
    df[, "xyz"]
    df[, c("abc", "xyz")]
```

1.  If you have the name of a variable stored in an object, e.g. `var <- "mpg"`,
    how can you extract the reference variable from a tibble?

1.  Practice referring to non-syntactic names in the following data frame by:

    1.  Extracting the variable called `1`.

    1.  Plotting a scatterplot of `1` vs `2`.

    1.  Creating a new column called `3` which is `2` divided by `1`.
        
    1.  Renaming the columns to `one`, `two` and `three`. 
    
    
```r
    annoying <- tibble(
      `1` = 1:10,
      `2` = `1` * 2 + rnorm(length(`1`))
    )
```

1.  What does `tibble::enframe()` do? When might you use it?

1.  What option controls how many additional column names are printed
    at the footer of a tibble?