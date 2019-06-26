
One way to add additional variables is with aesthetics. Another way, particularly useful for categorical variables, is to split your plot into __facets__, subplots that each display one subset of the data. 

To facet your plot by a single variable, use `facet_wrap()`. The first argument of `facet_wrap()` should be a formula, which you create with `~` followed by a variable name (here "formula" is the name of a data structure in R, not a synonym for "equation"). The variable that you pass to `facet_wrap()` should be discrete. 


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

{Run code | terminal}(Rscript code/facets.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-13-1.jpg)

**Figure 5.1**

To facet your plot on the combination of two variables, add `facet_grid()` to your plot call. The first argument of `facet_grid()` is also a formula. This time the formula should contain two variable names separated by a `~`. 


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
```

{Run code | terminal}(Rscript code/facets.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 5.2](visualize_files/figure-latex/unnamed-chunk-14-1.jpg)

**Figure 5.2**

If you prefer to not facet in the rows or columns dimension, use a `.` instead of a variable name, e.g. `+ facet_grid(. ~ cyl)`.

### Exercises

1.  What happens if you facet on a continuous variable?

1.  What do the empty cells in plot with `facet_grid(drv ~ cyl)` mean?
    How do they relate to this plot?
    
    
```r
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = drv, y = cyl))
```

1.  What plots does the following code make? What does `.` do?

    
```r
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_grid(drv ~ .)
    
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_grid(. ~ cyl)
```

1.  Take the first faceted plot in this section:

    
```r
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = displ, y = hwy)) + 
      facet_wrap(~ class, nrow = 2)
```
    
    What are the advantages to using faceting instead of the colour aesthetic?
    What are the disadvantages? How might the balance change if you had a 
    larger dataset?
    
1.  Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other
    options control the layout of the individual panels? Why doesn't
    `facet_grid()` have `nrow` and `ncol` arguments?

1.  When using `facet_grid()` you should usually put the variable with more
    unique levels in the columns. Why?
