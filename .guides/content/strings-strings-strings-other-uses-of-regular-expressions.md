
There are two useful function in base R that also use regular expressions:

*   `apropos()` searches all objects available from the global environment. This
    is useful if you can't quite remember the name of the function.
    
    
```r
    apropos("replace")
    #> [1] "%+replace%"       "replace"          "replace_na"      
    #> [4] "setReplaceMethod" "str_replace"      "str_replace_all" 
    #> [7] "str_replace_na"   "theme_replace"
```
{Run code | terminal}(Rscript code/otherPatterns.r)

    
*   `dir()` lists all the files in a directory. The `pattern` argument takes
    a regular expression and only returns file names that match the pattern.
    For example, you can find all the R Markdown files in the current
    directory with:
    
    
```r
    head(dir(pattern = "\\.Rmd$"))
    #> [1] "communicate-plots.Rmd" "communicate.Rmd"       "datetimes.Rmd"        
    #> [4] "EDA.Rmd"               "explore.Rmd"           "factors.Rmd"
```
    
    (If you're more comfortable with "globs" like `*.Rmd`, you can convert
    them to regular expressions with `glob2rx()`):
