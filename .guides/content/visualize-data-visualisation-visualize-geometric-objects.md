
How are these two plots similar? 


![Figure 5.6](visualize_files/figure-latex/unnamed-chunk-18-1.jpg)

**Figure 5.6**

 ![Figure 5.7](visualize_files/figure-latex/unnamed-chunk-18-2.jpg)

**Figure 5.7**

 

Both plots contain the same x variable, the same y variable, and both describe the same data. But the plots are not identical. Each plot uses a different visual object to represent the data. In ggplot2 syntax, we say that they use different __geoms__.

A __geom__ is the geometrical object that a plot uses to represent data. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms, line charts use line geoms, boxplots use boxplot geoms, and so on. Scatterplots break the trend; they use the point geom. As we see above, you can use different geoms to plot the same data. The plot on the left uses the point geom, and the plot on the right uses the smooth geom, a smooth line fitted to the data. 

To change the geom in your plot, change the geom function that you add to `ggplot()`. For instance, to make the plots above, you can use this code:


```r
# left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# right
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

Every geom function in ggplot2 takes a `mapping` argument. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn't set the "shape" of a line. On the other hand, you _could_ set the linetype of a line. `geom_smooth()` will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.


```r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
```



![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 5.1**

Here `geom_smooth()` separates the cars into three lines based on their `drv` value, which describes a car's drivetrain. One line describes all of the points with a `4` value, one line describes all of the points with an `f` value, and one line describes all of the points with an `r` value. Here, `4` stands for four-wheel drive, `f` for front-wheel drive, and `r` for rear-wheel drive.

If this sounds strange, we can make it more clear by overlaying the lines on top of the raw data and then coloring everything according to `drv`. 


![Figure 5.2](visualize_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 5.2**

Notice that this plot contains two geoms in the same graph! If this makes you excited, buckle up. We will learn how to place multiple geoms in the same plot very soon.

ggplot2 provides over 30 geoms, and extension packages provide even more (see <https://www.ggplot2-exts.org> for a sampling). The best way to get a comprehensive overview is the ggplot2 cheatsheet, which you can find at <http://rstudio.com/cheatsheets>. To learn more about any single geom, use help: `?geom_smooth`.

Many geoms, like `geom_smooth()`, use a single geometric object to display multiple rows of data. For these geoms, you can set the `group` aesthetic to a categorical variable to draw multiple objects. ggplot2 will draw a separate object for each unique value of the grouping variable. In practice, ggplot2 will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable (as in the `linetype` example). It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms.


```r
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
              
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
    
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )
```


![Figure 5.8](visualize_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 5.8**

 ![Figure 5.9](visualize_files/figure-latex/unnamed-chunk-22-2.jpg)

**Figure 5.9**

 ![Figure 5.10](visualize_files/figure-latex/unnamed-chunk-22-3.jpg)

**Figure 5.10**

 

To display multiple geoms in the same plot, add multiple geom functions to `ggplot()`:


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
```



![Figure 5.3](visualize_files/figure-latex/unnamed-chunk-23-1.jpg)

**Figure 5.3**

This, however, introduces some duplication in our code. Imagine if you wanted to change the y-axis to display `cty` instead of `hwy`. You'd need to change the variable in two places, and you might forget to update one. You can avoid this type of repetition by passing a set of mappings to `ggplot()`. ggplot2 will treat these mappings as global mappings that apply to each geom in the graph.  In other words, this code will produce the same plot as the previous code:


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
```

If you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer. It will use these mappings to extend or overwrite the global mappings _for that layer only_. This makes it possible to display different aesthetics in different layers.


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
```



![Figure 5.4](visualize_files/figure-latex/unnamed-chunk-25-1.jpg)

**Figure 5.4**

You can use the same idea to specify different `data` for each layer. Here, our smooth line displays just a subset of the `mpg` dataset, the subcompact cars. The local data argument in `geom_smooth()` overrides the global data argument in `ggplot()` for that layer only.


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
```



![Figure 5.5](visualize_files/figure-latex/unnamed-chunk-26-1.jpg)

**Figure 5.5**

(You'll learn how `filter()` works in the chapter on data transformations: for now, just know that this command selects only the subcompact cars.)

### Exercises

1.  What geom would you use to draw a line chart? A boxplot? 
    A histogram? An area chart?

1.  Run this code in your head and predict what the output will look like.
    Then, run the code in R and check your predictions.
    
    
```r
    ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
      geom_point() + 
      geom_smooth(se = FALSE)
```

1.  What does `show.legend = FALSE` do?  What happens if you remove it?  
    Why do you think I used it earlier in the chapter?

1.  What does the `se` argument to `geom_smooth()` do?


1.  Will these two graphs look different? Why/why not?

    
```r
    ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
      geom_point() + 
      geom_smooth()
    
    ggplot() + 
      geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
      geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
```

1.  Recreate the R code necessary to generate the following graphs.
    
    
    ![Figure 5.11](visualize_files/figure-latex/unnamed-chunk-29-1.jpg)

**Figure 5.11**

 ![Figure 5.12](visualize_files/figure-latex/unnamed-chunk-29-2.jpg)

**Figure 5.12**

 ![Figure 5.13](visualize_files/figure-latex/unnamed-chunk-29-3.jpg)

**Figure 5.13**

 ![Figure 5.14](visualize_files/figure-latex/unnamed-chunk-29-4.jpg)

**Figure 5.14**

 ![Figure 5.15](visualize_files/figure-latex/unnamed-chunk-29-5.jpg)

**Figure 5.15**

 ![Figure 5.16](visualize_files/figure-latex/unnamed-chunk-29-6.jpg)

**Figure 5.16**

 
