
For the rest of this chapter, we're going to focus on `forcats::gss_cat`. It's a sample of data from the [General Social Survey](http://gss.norc.org), which is a long-running US survey conducted by the independent research organization NORC at the University of Chicago. The survey has thousands of questions, so in `gss_cat` I've selected a handful that will illustrate some common challenges you'll encounter when working with factors.


```r
gss_cat
#> # A tibble: 21,483 x 9
#>    year marital     age race  rincome   partyid    relig    denom   tvhours
#>   <int> <fct>     <int> <fct> <fct>     <fct>      <fct>    <fct>     <int>
#> 1  2000 Never ma~    26 White $8000 to~ Ind,near ~ Protest~ Southe~      12
#> 2  2000 Divorced     48 White $8000 to~ Not str r~ Protest~ Baptis~      NA
#> 3  2000 Widowed      67 White Not appl~ Independe~ Protest~ No den~       2
#> 4  2000 Never ma~    39 White Not appl~ Ind,near ~ Orthodo~ Not ap~       4
#> 5  2000 Divorced     25 White Not appl~ Not str d~ None     Not ap~       1
#> 6  2000 Married      25 White $20000 -~ Strong de~ Protest~ Southe~      NA
#> # ... with 2.148e+04 more rows
```
{Run code | terminal}(Rscript code/gss.r)              


(Remember, since this dataset is provided by a package, you can get more information about the variables with `?gss_cat`.)

When factors are stored in a tibble, you can't see their levels so easily. One way to see them is with `count()`:


```r
gss_cat %>%
  count(race)
#> # A tibble: 3 x 2
#>   race      n
#>   <fct> <int>
#> 1 Other  1959
#> 2 Black  3129
#> 3 White 16395
```

Or with a bar chart:


```r
ggplot(gss_cat, aes(race)) +
  geom_bar()
```

{Run code | terminal}(Rscript code/gss.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 18.1](factors_files/figure-latex/unnamed-chunk-14-1.jpg)

**Figure 18.1**

By default, ggplot2 will drop levels that don't have any values. You can force them to display with:


```r
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)
```



![Figure 18.2](factors_files/figure-latex/unnamed-chunk-15-1.jpg)

**Figure 18.2**

These levels represent valid values that simply did not occur in this dataset. Unfortunately, dplyr doesn't yet have a `drop` option, but it will in the future.

When working with factors, the two most common operations are changing the order of the levels, and changing the values of the levels. Those operations are described in the sections below.

### Exercise

1.  Explore the distribution of `rincome` (reported income). What makes the
    default bar chart hard to understand? How could you improve the plot?

1.  What is the most common `relig` in this survey? What's the most
    common `partyid`?

1.  Which `relig` does `denom` (denomination) apply to? How can you find
    out with a table? How can you find out with a visualisation?
