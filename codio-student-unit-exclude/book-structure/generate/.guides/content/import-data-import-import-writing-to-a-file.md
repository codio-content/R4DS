
readr also comes with two useful functions for writing data back to disk: `write_csv()` and `write_tsv()`. Both functions increase the chances of the output file being read back in correctly by:

* Always encoding strings in UTF-8.
  
* Saving dates and date-times in ISO8601 format so they are easily
  parsed elsewhere.

If you want to export a csv file to Excel, use `write_excel_csv()` --- this writes a special character (a "byte order mark") at the start of the file which tells Excel that you're using the UTF-8 encoding.

The most important arguments are `x` (the data frame to save), and `path` (the location to save it). You can also specify how missing values are written with `na`, and if you want to `append` to an existing file.


```r
write_csv(challenge, "challenge.csv")
```

Note that the type information is lost when you save to csv:


```r
challenge
#> # A tibble: 2,000 x 2
#>       x y         
#>   <dbl> <date>    
#> 1   404 NA        
#> 2  4172 NA        
#> 3  3004 NA        
#> 4   787 NA        
#> 5    37 NA        
#> 6  2332 NA        
#> # ... with 1,994 more rows
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")
#> Parsed with column specification:
#> cols(
#>   x = col_double(),
#>   y = col_logical()
#> )
#> # A tibble: 2,000 x 2
#>       x y    
#>   <dbl> <lgl>
#> 1   404 NA   
#> 2  4172 NA   
#> 3  3004 NA   
#> 4   787 NA   
#> 5    37 NA   
#> 6  2332 NA   
#> # ... with 1,994 more rows
```

This makes CSVs a little unreliable for caching interim results---you need to recreate the column specification every time you load in. There are two alternatives:

1.  `write_rds()` and `read_rds()` are uniform wrappers around the base 
    functions `readRDS()` and `saveRDS()`. These store data in R's custom 
    binary format called RDS:
    
    
```r
    write_rds(challenge, "challenge.rds")
    read_rds("challenge.rds")
    #> # A tibble: 2,000 x 2
    #>       x y         
    #>   <dbl> <date>    
    #> 1   404 NA        
    #> 2  4172 NA        
    #> 3  3004 NA        
    #> 4   787 NA        
    #> 5    37 NA        
    #> 6  2332 NA        
    #> # ... with 1,994 more rows
```
  
1.  The feather package implements a fast binary file format that can
    be shared across programming languages:
    
    
```r
    library(feather)
    write_feather(challenge, "challenge.feather")
    read_feather("challenge.feather")
    #> # A tibble: 2,000 x 2
    #>       x      y
    #>   <dbl> <date>
    #> 1   404   <NA>
    #> 2  4172   <NA>
    #> 3  3004   <NA>
    #> 4   787   <NA>
    #> 5    37   <NA>
    #> 6  2332   <NA>
    #> # ... with 1,994 more rows
```

Feather tends to be faster than RDS and is usable outside of R. RDS supports list-columns (which you'll learn about in [many models]); feather currently does not.


