
If you've encountered unusual values in your dataset, and simply want to move on to the rest of your analysis, you have two options.

1.  Drop the entire row with the strange values:

    
```r
    diamonds2 <- diamonds %>% 
      filter(between(y, 3, 20))
```
    
    I don't recommend this option because just because one measurement
    is invalid, doesn't mean all the measurements are. Additionally, if you
    have low quality data, by time that you've applied this approach to every
    variable you might find that you don't have any data left!

1.  Instead, I recommend replacing the unusual values with missing values.
    The easiest way to do this is to use `mutate()` to replace the variable
    with a modified copy. You can use the `ifelse()` function to replace
    unusual values with `NA`:

    
```r
    diamonds2 <- diamonds %>% 
      mutate(y = ifelse(y < 3 | y > 20, NA, y))
```
{Run code | terminal}(Rscript code/missing.r)
 


`ifelse()` has three arguments. The first argument `test` should be a logical vector. The result will contain the value of the second argument, `yes`, when `test` is `TRUE`, and the value of the third argument, `no`, when it is false. Alternatively to ifelse, use `dplyr::case_when()`. `case_when()` is particularly useful inside mutate when you want to create a new variable that relies on a complex combination of existing variables.

Like R, ggplot2 subscribes to the philosophy that missing values should never silently go missing. It's not obvious where you should plot missing values, so ggplot2 doesn't include them in the plot, but it does warn that they've been removed:


```r
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
#> Warning: Removed 9 rows containing missing values (geom_point).
```
{Run code | terminal}(Rscript code/missing.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 9.1](EDA_files/figure-latex/unnamed-chunk-17-1.png)

**Figure 9.1**

To suppress that warning, set `na.rm = TRUE`:


```r
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)
```

Other times you want to understand what makes observations with missing values different to observations with recorded values. For example, in `nycflights13::flights`, missing values in the `dep_time` variable indicate that the flight was cancelled. So you might want to compare the scheduled departure times for cancelled and non-cancelled times. You can do this by making a new variable with `is.na()`.


```r
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
```
{Run code | terminal}(Rscript code/missing.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 9.2](EDA_files/figure-latex/unnamed-chunk-19-1.jpg)

**Figure 9.2**

However this plot isn't great because there are many more non-cancelled flights than cancelled flights. In the next section we'll explore some techniques for improving this comparison.

### Exercises

1.  What happens to missing values in a histogram?  What happens to missing
    values in a bar chart? Why is there a difference?

1.  What does `na.rm = TRUE` do in `mean()` and `sum()`?
