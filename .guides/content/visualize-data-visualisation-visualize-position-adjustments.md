
There's one more piece of magic associated with bar charts. You can colour a bar chart using either the `colour` aesthetic, or, more usefully, `fill`:


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
```


![Figure 5.7](visualize_files/figure-latex/unnamed-chunk-37-1.jpg)

**Figure 5.7**

 ![Figure 5.8](visualize_files/figure-latex/unnamed-chunk-37-2.jpg)

**Figure 5.8**

 

Note what happens if you map the fill aesthetic to another variable, like `clarity`: the bars are automatically stacked. Each colored rectangle represents a combination of `cut` and `clarity`.


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
```



![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-38-1.jpg)

**Figure 5.1**

The stacking is performed automatically by the __position adjustment__ specified by the `position` argument. If you don't want a stacked bar chart, you can use one of three other options: `"identity"`, `"dodge"` or `"fill"`.

*   `position = "identity"` will place each object exactly where it falls in 
    the context of the graph. This is not very useful for bars, because it
    overlaps them. To see that overlapping we either need to make the bars
    slightly transparent by setting `alpha` to a small value, or completely
    transparent by setting `fill = NA`.
    
    
```r
    ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
      geom_bar(alpha = 1/5, position = "identity")
    ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
      geom_bar(fill = NA, position = "identity")
```
    
    
    ![Figure 5.9](visualize_files/figure-latex/unnamed-chunk-39-1.jpg)

**Figure 5.9**

 ![Figure 5.10](visualize_files/figure-latex/unnamed-chunk-39-2.jpg)

**Figure 5.10**

 
    
    The identity position adjustment is more useful for 2d geoms, like points,
    where it is the default.
    
*   `position = "fill"` works like stacking, but makes each set of stacked bars
    the same height. This makes it easier to compare proportions across 
    groups.

    
```r
    ggplot(data = diamonds) + 
      geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
```
    
    
    
![Figure 5.2](visualize_files/figure-latex/unnamed-chunk-40-1.jpg)

**Figure 5.2**

*   `position = "dodge"` places overlapping objects directly _beside_ one 
    another. This makes it easier to compare individual values.

    
```r
    ggplot(data = diamonds) + 
      geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
```
    
    
    
![Figure 5.3](visualize_files/figure-latex/unnamed-chunk-41-1.jpg)

**Figure 5.3**

There's one other type of adjustment that's not useful for bar charts, but it can be very useful for scatterplots. Recall our first scatterplot. Did you notice that the plot displays only 126 points, even though there are 234 observations in the dataset?


![Figure 5.4](visualize_files/figure-latex/unnamed-chunk-42-1.jpg)

**Figure 5.4**

The values of `hwy` and `displ` are rounded so the points appear on a grid and many points overlap each other. This problem is known as __overplotting__. This arrangement makes it hard to see where the mass of the data is. Are the data points spread equally throughout the graph, or is there one special combination of `hwy` and `displ` that contains 109 values? 

You can avoid this gridding by setting the position adjustment to "jitter".  `position = "jitter"` adds a small amount of random noise to each point. This spreads the points out because no two points are likely to receive the same amount of random noise.


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
```



![Figure 5.5](visualize_files/figure-latex/unnamed-chunk-43-1.jpg)

**Figure 5.5**

Adding randomness seems like a strange way to improve your plot, but while it makes your graph less accurate at small scales, it makes your graph _more_ revealing at large scales. Because this is such a useful operation, ggplot2 comes with a shorthand for `geom_point(position = "jitter")`: `geom_jitter()`.

To learn more about a position adjustment, look up the help page associated with each adjustment: `?position_dodge`, `?position_fill`, `?position_identity`, `?position_jitter`, and `?position_stack`.

### Exercises

1.  {Submit Answer!|assessment}(free-text-898232935)

1.  {Submit Answer!|assessment}(free-text-2462061477)

1.  {Submit Answer!|assessment}(free-text-4262217264)

1.  {Submit Answer!|assessment}(free-text-2715920861)

