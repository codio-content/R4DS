
**Variation** is the tendency of the values of a variable to change from measurement to measurement. You can see variation easily in real life; if you measure any continuous variable twice, you will get two different results. This is true even if you measure quantities that are constant, like the speed of light. Each of your measurements will include a small amount of error that varies from measurement to measurement. Categorical variables can also vary if you measure across different subjects (e.g. the eye colors of different people), or different times (e.g. the energy levels of an electron at different moments). 
Every variable has its own pattern of variation, which can reveal interesting information. The best way to understand that pattern is to visualise the distribution of the variable's values.

### Visualising distributions

How you visualise the distribution of a variable will depend on whether the variable is categorical or continuous. A variable is **categorical** if it can only take one of a small set of values. In R, categorical variables are usually saved as factors or character vectors. To examine the distribution of a categorical variable, use a bar chart:


```r
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
```



![Figure 9.1](EDA_files/figure-latex/unnamed-chunk-2-1.jpg)

**Figure 9.1**

The height of the bars displays how many observations occurred with each x value. You can compute these values manually with `dplyr::count()`:


```r
diamonds %>% 
  count(cut)
#> # A tibble: 5 x 2
#>   cut           n
#>   <ord>     <int>
#> 1 Fair       1610
#> 2 Good       4906
#> 3 Very Good 12082
#> 4 Premium   13791
#> 5 Ideal     21551
```

A variable is **continuous** if it can take any of an infinite set of ordered values. Numbers and date-times are two examples of continuous variables. To examine the distribution of a continuous variable, use a histogram:


```r
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
```



![Figure 9.2](EDA_files/figure-latex/unnamed-chunk-4-1.jpg)

**Figure 9.2**

You can compute this by hand by combining `dplyr::count()` and `ggplot2::cut_width()`:


```r
diamonds %>% 
  count(cut_width(carat, 0.5))
#> # A tibble: 11 x 2
#>   `cut_width(carat, 0.5)`     n
#>   <fct>                   <int>
#> 1 [-0.25,0.25]              785
#> 2 (0.25,0.75]             29498
#> 3 (0.75,1.25]             15977
#> 4 (1.25,1.75]              5313
#> 5 (1.75,2.25]              2002
#> 6 (2.25,2.75]               322
#> # ... with 5 more rows
```

A histogram divides the x-axis into equally spaced bins and then uses the height of a bar to display the number of observations that fall in each bin. In the graph above, the tallest bar shows that almost 30,000 observations have a `carat` value between 0.25 and 0.75, which are the left and right edges of the bar. 

You can set the width of the intervals in a histogram with the `binwidth` argument, which is measured in the units of the `x` variable. You should always explore a variety of binwidths when working with histograms, as different binwidths can reveal different patterns. For example, here is how the graph above looks when we zoom into just the diamonds with a size of less than three carats and choose a smaller binwidth.


```r
smaller <- diamonds %>% 
  filter(carat < 3)
  
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
```



![Figure 9.3](EDA_files/figure-latex/unnamed-chunk-6-1.jpg)

**Figure 9.3**

If you wish to overlay multiple histograms in the same plot, I recommend using `geom_freqpoly()` instead of `geom_histogram()`. `geom_freqpoly()` performs the same calculation as `geom_histogram()`, but instead of displaying the counts with bars, uses lines instead. It's much easier to understand overlapping lines than bars.


```r
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)
```



![Figure 9.4](EDA_files/figure-latex/unnamed-chunk-7-1.jpg)

**Figure 9.4**

There are a few challenges with this type of plot, which we will come back to in [visualising a categorical and a continuous variable](#cat-cont).

Now that you can visualise variation, what should you look for in your plots? And what type of follow-up questions should you ask? I've put together a list below of the most useful types of information that you will find in your graphs, along with some follow-up questions for each type of information. The key to asking good follow-up questions will be to rely on your curiosity (What do you want to learn more about?) as well as your skepticism (How could this be misleading?).

### Typical values

In both bar charts and histograms, tall bars show the common values of a variable, and shorter bars show less-common values. Places that do not have bars reveal values that were not seen in your data. To turn this information into useful questions, look for anything unexpected:

* Which values are the most common? Why?

* Which values are rare? Why? Does that match your expectations?

* Can you see any unusual patterns? What might explain them?

As an example, the histogram below suggests several interesting questions: 

* Why are there more diamonds at whole carats and common fractions of carats?

* Why are there more diamonds slightly to the right of each peak than there 
  are slightly to the left of each peak?
  
* Why are there no diamonds bigger than 3 carats?


```r
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
```



![Figure 9.5](EDA_files/figure-latex/unnamed-chunk-8-1.jpg)

**Figure 9.5**

Clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:

* How are the observations within each cluster similar to each other?

* How are the observations in separate clusters different from each other?

* How can you explain or describe the clusters?

* Why might the appearance of clusters be misleading?

The histogram below shows the length (in minutes) of 272 eruptions of the Old Faithful Geyser in Yellowstone National Park. Eruption times appear to be clustered into two groups: there are short eruptions (of around 2 minutes) and long eruptions (4-5 minutes), but little in between.


```r
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
```



![Figure 9.6](EDA_files/figure-latex/unnamed-chunk-9-1.jpg)

**Figure 9.6**

Many of the questions above will prompt you to explore a relationship *between* variables, for example, to see if the values of one variable can explain the behavior of another variable. We'll get to that shortly.

### Unusual values

Outliers are observations that are unusual; data points that don't seem to fit the pattern. Sometimes outliers are data entry errors; other times outliers suggest important new science. When you have a lot of data, outliers are sometimes difficult to see in a histogram.  For example, take the distribution of the `y` variable from the diamonds dataset. The only evidence of outliers is the unusually wide limits on the x-axis.


```r
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
```



![Figure 9.7](EDA_files/figure-latex/unnamed-chunk-10-1.jpg)

**Figure 9.7**

There are so many observations in the common bins that the rare bins are so short that you can't see them (although maybe if you stare intently at 0 you'll spot something). To make it easy to see the unusual values, we need to zoom to small values of the y-axis with `coord_cartesian()`:


```r
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
```



![Figure 9.8](EDA_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 9.8**

(`coord_cartesian()` also has an `xlim()` argument for when you need to zoom into the x-axis. ggplot2 also has `xlim()` and `ylim()` functions that work slightly differently: they throw away the data outside the limits.)

This allows us to see that there are three unusual values: 0, ~30, and ~60. We pluck them out with dplyr: 




```r
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual
#> # A tibble: 9 x 4
#>   price     x     y     z
#>   <int> <dbl> <dbl> <dbl>
#> 1  5139  0      0    0   
#> 2  6381  0      0    0   
#> 3 12800  0      0    0   
#> 4 15686  0      0    0   
#> 5 18034  0      0    0   
#> 6  2130  0      0    0   
#> 7  2130  0      0    0   
#> 8  2075  5.15  31.8  5.12
#> 9 12210  8.09  58.9  8.06
```



The `y` variable measures one of the three dimensions of these diamonds, in mm. We know that diamonds can't have a width of 0mm, so these values must be incorrect. We might also suspect that measurements of 32mm and 59mm are implausible: those diamonds are over an inch long, but don't cost hundreds of thousands of dollars!

It's good practice to repeat your analysis with and without the outliers. If they have minimal effect on the results, and you can't figure out why they're there, it's reasonable to replace them with missing values, and move on. However, if they have a substantial effect on your results, you shouldn't drop them without justification. You'll need to figure out what caused them (e.g. a data entry error) and disclose that you removed them in your write-up.


### Exercises

1.  Explore the distribution of each of the `x`, `y`, and `z` variables 
    in `diamonds`. What do you learn? Think about a diamond and how you
    might decide which dimension is the length, width, and depth.

1.  Explore the distribution of `price`. Do you discover anything unusual
    or surprising? (Hint: Carefully think about the `binwidth` and make sure
    you try a wide range of values.)

1.  How many diamonds are 0.99 carat? How many are 1 carat? What
    do you think is the cause of the difference?
    
1.  Compare and contrast `coord_cartesian()` vs `xlim()` or `ylim()` when
    zooming in on a histogram. What happens if you leave `binwidth` unset?
    What happens if you try and zoom so only half a bar shows?
    