
1.  Why does this code not work?

    
```r
    my_variable <- 10
    my_varıable
    #> Error in eval(expr, envir, enclos): object 'my_varıable' not found
```
    
    Look carefully! (This may seem like an exercise in pointlessness, but
    training your brain to notice even the tiniest difference will pay off
    when programming.)
    
1.  Tweak each of the following R commands so that they run correctly:

    
```r
    library(tidyverse)
    
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = displ, y = hwy))
    
    fliter(mpg, cyl = 8)
    filter(diamond, carat > 3)
```
    
