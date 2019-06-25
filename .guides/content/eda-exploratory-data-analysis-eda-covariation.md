
If variation describes the behavior _within_ a variable, covariation describes the behavior _between_ variables. **Covariation** is the tendency for the values of two or more variables to vary together in a related way. The best way to spot covariation is to visualise the relationship between two or more variables. How you do that should again depend on the type of variables involved.

### A categorical and continuous variable 

It's common to want to explore the distribution of a continuous variable broken down by a categorical variable, as in the previous frequency polygon. The default appearance of `geom_freqpoly()` is not that useful for that sort of comparison because the height is given by the count. That means if one of the groups is much smaller than the others, it's hard to see the differences in shape. For example, let's explore how the price of a diamond varies with its quality:


```r
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
```



![Figure 9.1](EDA_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 9.1**

It's hard to see the difference in distribution because the overall counts differ so much:


```r
ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))
```



![Figure 9.2](EDA_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 9.2**

To make the comparison easier we need to swap what is displayed on the y-axis. Instead of displaying count, we'll display __density__, which is the count standardised so that the area under each frequency polygon is one.


```r
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
```



![Figure 9.3](EDA_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 9.3**

There's something rather surprising about this plot - it appears that fair diamonds (the lowest quality) have the highest average price!  But maybe that's because frequency polygons are a little hard to interpret - there's a lot going on in this plot.

Another alternative to display the distribution of a continuous variable broken down by a categorical variable is the boxplot. A **boxplot** is a type of visual shorthand for a distribution of values that is popular among statisticians. Each boxplot consists of:

* A box that stretches from the 25th percentile of the distribution to the 
  75th percentile, a distance known as the interquartile range (IQR). In the
  middle of the box is a line that displays the median, i.e. 50th percentile,
  of the distribution. These three lines give you a sense of the spread of the
  distribution and whether or not the distribution is symmetric about the
  median or skewed to one side. 

* Visual points that display observations that fall more than 1.5 times the 
  IQR from either edge of the box. These outlying points are unusual
  so are plotted individually.

* A line (or whisker) that extends from each end of the box and goes to the   
  farthest non-outlier point in the distribution.


![Figure 9.4](images/EDA-boxplot.jpg)

**Figure 9.4**

Let's take a look at the distribution of price by cut using `geom_boxplot()`:


```r
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
```



![Figure 9.5](EDA_files/figure-latex/unnamed-chunk-24-1.jpg)

**Figure 9.5**

We see much less information about the distribution, but the boxplots are much more compact so we can more easily compare them (and fit more on one plot). It supports the counterintuitive finding that better quality diamonds are cheaper on average! In the exercises, you'll be challenged to figure out why.

`cut` is an ordered factor: fair is worse than good, which is worse than very good and so on. Many categorical variables don't have such an intrinsic order, so you might want to reorder them to make a more informative display. One way to do that is with the `reorder()` function.

For example, take the `class` variable in the `mpg` dataset. You might be interested to know how highway mileage varies across classes:


```r
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
```



![Figure 9.6](EDA_files/figure-latex/unnamed-chunk-25-1.jpg)

**Figure 9.6**

To make the trend easier to see, we can reorder `class` based on the median value of `hwy`:


```r
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
```



![Figure 9.7](EDA_files/figure-latex/unnamed-chunk-26-1.jpg)

**Figure 9.7**

If you have long variable names, `geom_boxplot()` will work better if you flip it 90°. You can do that with `coord_flip()`.


```r
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
```



![Figure 9.8](EDA_files/figure-latex/unnamed-chunk-27-1.jpg)

**Figure 9.8**

#### Exercises

1.  Use what you've learned to improve the visualisation of the departure times
    of cancelled vs. non-cancelled flights.

1.  What variable in the diamonds dataset is most important for predicting
    the price of a diamond? How is that variable correlated with cut?
    Why does the combination of those two relationships lead to lower quality
    diamonds being more expensive?

1.  Install the ggstance package, and create a horizontal boxplot.
    How does this compare to using `coord_flip()`?

1.  One problem with boxplots is that they were developed in an era of 
    much smaller datasets and tend to display a prohibitively large
    number of "outlying values". One approach to remedy this problem is
    the letter value plot. Install the lvplot package, and try using
    `geom_lv()` to display the distribution of price vs cut. What
    do you learn? How do you interpret the plots?

1.  Compare and contrast `geom_violin()` with a facetted `geom_histogram()`,
    or a coloured `geom_freqpoly()`. What are the pros and cons of each 
    method?

1.  If you have a small dataset, it's sometimes useful to use `geom_jitter()`
    to see the relationship between a continuous and categorical variable.
    The ggbeeswarm package provides a number of methods similar to 
    `geom_jitter()`. List them and briefly describe what each one does.

### Two categorical variables

To visualise the covariation between categorical variables, you'll need to count the number of observations for each combination. One way to do that is to rely on the built-in `geom_count()`:


```r
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
```



![Figure 9.9](EDA_files/figure-latex/unnamed-chunk-28-1.jpg)

**Figure 9.9**

The size of each circle in the plot displays how many observations occurred at each combination of values. Covariation will appear as a strong correlation between specific x values and specific y values. 

Another approach is to compute the count with dplyr:


```r
diamonds %>% 
  count(color, cut)
#> # A tibble: 35 x 3
#>   color cut           n
#>   <ord> <ord>     <int>
#> 1 D     Fair        163
#> 2 D     Good        662
#> 3 D     Very Good  1513
#> 4 D     Premium    1603
#> 5 D     Ideal      2834
#> 6 E     Fair        224
#> # ... with 29 more rows
```

Then visualise with `geom_tile()` and the fill aesthetic:


```r
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
    geom_tile(mapping = aes(fill = n))
```



![Figure 9.10](EDA_files/figure-latex/unnamed-chunk-30-1.jpg)

**Figure 9.10**

If the categorical variables are unordered, you might want to use the seriation package to simultaneously reorder the rows and columns in order to more clearly reveal interesting patterns. For larger plots, you might want to try the d3heatmap or heatmaply packages, which create interactive plots.

#### Exercises

1.  How could you rescale the count dataset above to more clearly show
    the distribution of cut within colour, or colour within cut?

1.  Use `geom_tile()` together with dplyr to explore how average flight
    delays vary by destination and month of year.  What makes the 
    plot difficult to read? How could you improve it?

1.  Why is it slightly better to use `aes(x = color, y = cut)` rather
    than `aes(x = cut, y = color)` in the example above?

### Two continuous variables

You've already seen one great way to visualise the covariation between two continuous variables: draw a scatterplot with `geom_point()`. You can see covariation as a pattern in the points. For example, you can see an exponential relationship between the carat size and price of a diamond.


```r
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))
```



![Figure 9.11](EDA_files/figure-latex/unnamed-chunk-31-1.png)

**Figure 9.11**

Scatterplots become less useful as the size of your dataset grows, because points begin to overplot, and pile up into areas of uniform black (as above).
You've already seen one way to fix the problem: using the `alpha` aesthetic to add transparency.


```r
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)
```



![Figure 9.12](EDA_files/figure-latex/unnamed-chunk-32-1.png)

**Figure 9.12**

But using transparency can be challenging for very large datasets. Another solution is to use bin. Previously you used `geom_histogram()` and `geom_freqpoly()` to bin in one dimension. Now you'll learn how to use `geom_bin2d()` and `geom_hex()` to bin in two dimensions.

`geom_bin2d()` and `geom_hex()` divide the coordinate plane into 2d bins and then use a fill color to display how many points fall into each bin. `geom_bin2d()` creates rectangular bins. `geom_hex()` creates hexagonal bins. You will need to install the hexbin package to use `geom_hex()`.


```r
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

# install.packages("hexbin")
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))
```


![Figure 9.16](EDA_files/figure-latex/unnamed-chunk-33-1.jpg)

**Figure 9.16**

 ![Figure 9.17](EDA_files/figure-latex/unnamed-chunk-33-2.jpg)

**Figure 9.17**

 

Another option is to bin one continuous variable so it acts like a categorical variable. Then you can use one of the techniques for visualising the combination of a categorical and a continuous variable that you learned about. For example, you could bin `carat` and then for each group, display a boxplot:


```r
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
```



![Figure 9.13](EDA_files/figure-latex/unnamed-chunk-34-1.jpg)

**Figure 9.13**

`cut_width(x, width)`, as used above, divides `x` into bins of width `width`. By default, boxplots look roughly the same (apart from number of outliers) regardless of how many observations there are, so it's difficult to tell that each boxplot summarises a different number of points. One way to show that is to make the width of the boxplot proportional to the number of points with `varwidth = TRUE`.

Another approach is to display approximately the same number of points in each bin. That's the job of `cut_number()`:


```r
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))
```



![Figure 9.14](EDA_files/figure-latex/unnamed-chunk-35-1.jpg)

**Figure 9.14**

#### Exercises

1.  Instead of summarising the conditional distribution with a boxplot, you
    could use a frequency polygon. What do you need to consider when using
    `cut_width()` vs `cut_number()`? How does that impact a visualisation of
    the 2d distribution of `carat` and `price`?

1.  Visualise the distribution of carat, partitioned by price.

1.  How does the price distribution of very large diamonds compare to small 
    diamonds? Is it as you expect, or does it surprise you?
    
1.  Combine two of the techniques you've learned to visualise the 
    combined distribution of cut, carat, and price.

1. Two dimensional plots reveal outliers that are not visible in one 
   dimensional plots. For example, some points in the plot below have an 
   unusual combination of `x` and `y` values, which makes the points outliers 
   even though their `x` and `y` values appear normal when examined separately.
  
    
```r
    ggplot(data = diamonds) +
      geom_point(mapping = aes(x = x, y = y)) +
      coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))
```
    
    
    
![Figure 9.15](EDA_files/figure-latex/unnamed-chunk-36-1.png)

**Figure 9.15**
    
    Why is a scatterplot a better display than a binned plot for this case?
