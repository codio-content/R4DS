
Coordinate systems are probably the most complicated part of ggplot2. The default coordinate system is the Cartesian coordinate system where the x and y positions act independently to determine the location of each point. There are a number of other coordinate systems that are occasionally helpful.

*   `coord_flip()` switches the x and y axes. This is useful (for example),
    if you want horizontal boxplots. It's also useful for long labels: it's
    hard to get them to fit without overlapping on the x-axis.
    
    
```r
    ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
      geom_boxplot()
    ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
      geom_boxplot() +
      coord_flip()
```
    
    
    ![Figure 5.2](visualize_files/figure-latex/unnamed-chunk-45-1.jpg)

**Figure 5.2**

 ![Figure 5.3](visualize_files/figure-latex/unnamed-chunk-45-2.jpg)

**Figure 5.3**

 

*   `coord_quickmap()` sets the aspect ratio correctly for maps. This is very
    important if you're plotting spatial data with ggplot2 (which unfortunately
    we don't have the space to cover in this book).

    
```r
    nz <- map_data("nz")
    
    ggplot(nz, aes(long, lat, group = group)) +
      geom_polygon(fill = "white", colour = "black")
    
    ggplot(nz, aes(long, lat, group = group)) +
      geom_polygon(fill = "white", colour = "black") +
      coord_quickmap()
```
    
    
    ![Figure 5.4](visualize_files/figure-latex/unnamed-chunk-46-1.jpg)

**Figure 5.4**

 ![Figure 5.5](visualize_files/figure-latex/unnamed-chunk-46-2.jpg)

**Figure 5.5**

 

*   `coord_polar()` uses polar coordinates. Polar coordinates reveal an 
    interesting connection between a bar chart and a Coxcomb chart.
    
    
```r
    bar <- ggplot(data = diamonds) + 
      geom_bar(
        mapping = aes(x = cut, fill = cut), 
        show.legend = FALSE,
        width = 1
      ) + 
      theme(aspect.ratio = 1) +
      labs(x = NULL, y = NULL)
    
    bar + coord_flip()
    bar + coord_polar()
```
    
    
    ![Figure 5.6](visualize_files/figure-latex/unnamed-chunk-47-1.jpg)

**Figure 5.6**

 ![Figure 5.7](visualize_files/figure-latex/unnamed-chunk-47-2.jpg)

**Figure 5.7**

 

### Exercises

1.  Turn a stacked bar chart into a pie chart using `coord_polar()`.

1.  What does `labs()` do? Read the documentation.

1.  What's the difference between `coord_quickmap()` and `coord_map()`?

1.  What does the plot below tell you about the relationship between city
    and highway mpg? Why is `coord_fixed()` important? What does 
    `geom_abline()` do?
    
    
```r
    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
      geom_point() + 
      geom_abline() +
      coord_fixed()
```
    
    
    
![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-48-1.jpg)

**Figure 5.1**
