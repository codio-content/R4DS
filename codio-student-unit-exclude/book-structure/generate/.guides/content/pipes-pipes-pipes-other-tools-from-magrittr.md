
All packages in the tidyverse automatically make `%>%` available for you, so you don't normally load magrittr explicitly. However, there are some other useful tools inside magrittr that you might want to try out:

*   When working with more complex pipes, it's sometimes useful to call a 
    function for its side-effects. Maybe you want to print out the current 
    object, or plot it, or save it to disk. Many times, such functions don't 
    return anything, effectively terminating the pipe.
    
    To work around this problem, you can use the "tee" pipe. `%T>%` works like 
    `%>%` except that it returns the left-hand side instead of the right-hand 
    side. It's called "tee" because it's like a literal T-shaped pipe.

    
```r
    rnorm(100) %>%
      matrix(ncol = 2) %>%
      plot() %>%
      str()
    #>  NULL
    
    rnorm(100) %>%
      matrix(ncol = 2) %T>%
      plot() %>%
      str()
    #>  num [1:50, 1:2] -0.387 -0.785 -1.057 -0.796 -1.756 ...
```
{Run code | terminal}(Rscript code/magrittr.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)

    
    
    
![Figure 22.1](pipes_files/figure-latex/unnamed-chunk-13-1.jpg)
![Figure 22.1](pipes_files/figure-latex/unnamed-chunk-13-2.jpg)

**Figure 22.1**

*   If you're working with functions that don't have a data frame based API  
    (i.e. you pass them individual vectors, not a data frame and expressions 
    to be evaluated in the context of that data frame), you might find `%$%` 
    useful. It "explodes" out the variables in a data frame so that you can 
    refer to them explicitly. This is useful when working with many functions 
    in base R:
    
    
```r
    mtcars %$%
      cor(disp, mpg)
    #> [1] -0.848
```

*   For assignment magrittr provides the `%<>%` operator which allows you to
    replace code like:
  
    
```r
    mtcars <- mtcars %>% 
      transform(cyl = cyl * 2)
```
    
    with
     
    
```r
    mtcars %<>% transform(cyl = cyl * 2)
```
    
    I'm not a fan of this operator because I think assignment is such a 
    special operation that it should always be clear when it's occurring.
    In my opinion, a little bit of duplication (i.e. repeating the 
    name of the object twice) is fine in return for making assignment
    more explicit.