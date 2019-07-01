
Let's work through a similar process for a dataset that seems even simpler at first glance: the number of flights that leave NYC per day. This is a really small dataset --- only 365 rows and 2 columns --- and we're not going to end up with a fully realised model, but as you'll see, the steps along the way will help us better understand the data. Let's get started by counting the number of flights per day and visualising it with ggplot2.


```r
daily <- flights %>% 
  mutate(date = make_date(year, month, day)) %>% 
  group_by(date) %>% 
  summarise(n = n())
daily
#> # A tibble: 365 x 2
#>   date           n
#>   <date>     <int>
#> 1 2013-01-01   842
#> 2 2013-01-02   943
#> 3 2013-01-03   914
#> 4 2013-01-04   915
#> 5 2013-01-05   720
#> 6 2013-01-06   832
#> # ... with 359 more rows

ggplot(daily, aes(date, n)) + 
  geom_line()
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.1](model-building_files/figure-latex/unnamed-chunk-14-1.jpg)

**Figure 29.1**

### Day of week

Understanding the long-term trend is challenging because there's a very strong day-of-week effect that dominates the subtler patterns. Let's start by looking at the distribution of flight numbers by day-of-week:


```r
daily <- daily %>% 
  mutate(wday = wday(date, label = TRUE))
ggplot(daily, aes(wday, n)) + 
  geom_boxplot()
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.2](model-building_files/figure-latex/unnamed-chunk-15-1.jpg)

**Figure 29.2**

There are fewer flights on weekends because most travel is for business. The effect is particularly pronounced on Saturday: you might sometimes leave on Sunday for a Monday morning meeting, but it's very rare that you'd leave on Saturday as you'd much rather be at home with your family.

One way to remove this strong pattern is to use a model. First, we fit the model, and display its predictions overlaid on the original data:


```r
mod <- lm(n ~ wday, data = daily)

grid <- daily %>% 
  data_grid(wday) %>% 
  add_predictions(mod, "n")

ggplot(daily, aes(wday, n)) + 
  geom_boxplot() +
  geom_point(data = grid, colour = "red", size = 4)
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.3](model-building_files/figure-latex/unnamed-chunk-16-1.jpg)

**Figure 29.3**

Next we compute and visualise the residuals:


```r
daily <- daily %>% 
  add_residuals(mod)
daily %>% 
  ggplot(aes(date, resid)) + 
  geom_ref_line(h = 0) + 
  geom_line()
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.4](model-building_files/figure-latex/unnamed-chunk-17-1.jpg)

**Figure 29.4**

Note the change in the y-axis: now we are seeing the deviation from the expected number of flights, given the day of week. This plot is useful because now that we've removed much of the large day-of-week effect, we can see some of the subtler patterns that remain:

1.  Our model seems to fail starting in June: you can still see a strong 
    regular pattern that our model hasn't captured. Drawing a plot with one 
    line for each day of the week makes the cause easier to see:

    
```r
    ggplot(daily, aes(date, resid, colour = wday)) + 
      geom_ref_line(h = 0) + 
      geom_line()
```
    
    
    
![Figure 29.5](model-building_files/figure-latex/unnamed-chunk-18-1.jpg)

**Figure 29.5**

    Our model fails to accurately predict the number of flights on Saturday:
    during summer there are more flights than we expect, and during Fall there 
    are fewer. We'll see how we can do better to capture this pattern in the
    next section.

1.  There are some days with far fewer flights than expected:

    
```r
    daily %>% 
      filter(resid < -100)
    #> # A tibble: 11 x 4
    #>   date           n wday  resid
    #>   <date>     <int> <ord> <dbl>
    #> 1 2013-01-01   842 Tue   -109.
    #> 2 2013-01-20   786 Sun   -105.
    #> 3 2013-05-26   729 Sun   -162.
    #> 4 2013-07-04   737 Thu   -229.
    #> 5 2013-07-05   822 Fri   -145.
    #> 6 2013-09-01   718 Sun   -173.
    #> # ... with 5 more rows
```

    If you're familiar with American public holidays, you might spot New Year's 
    day, July 4th, Thanksgiving and Christmas. There are some others that don't 
    seem to correspond to public holidays. You'll work on those in one 
    of the exercises.
    
1.  There seems to be some smoother long term trend over the course of a year.
    We can highlight that trend with `geom_smooth()`:

    
```r
    daily %>% 
      ggplot(aes(date, resid)) + 
      geom_ref_line(h = 0) + 
      geom_line(colour = "grey50") + 
      geom_smooth(se = FALSE, span = 0.20)
    #> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)
 
     \begin{center}\includegraphics[width=0.7\linewidth]{model-building_files/figure-latex/unnamed-chunk-20-1} \end{center}

    
    
    
![Figure 29.6](model-building_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 29.6**

    There are fewer flights in January (and December), and more in summer 
    (May-Sep). We can't do much with this pattern quantitatively, because we 
    only have a single year of data. But we can use our domain knowledge to 
    brainstorm potential explanations.

### Seasonal Saturday effect

Let's first tackle our failure to accurately predict the number of flights on Saturday. A good place to start is to go back to the raw numbers, focussing on Saturdays:


```r
daily %>% 
  filter(wday == "Sat") %>% 
  ggplot(aes(date, n)) + 
    geom_point() + 
    geom_line() +
    scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.7](model-building_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 29.7**

(I've used both points and lines to make it more clear what is data and what is interpolation.)

I suspect this pattern is caused by summer holidays: many people go on holiday in the summer, and people don't mind travelling on Saturdays for vacation. Looking at this plot, we might guess that summer holidays are from early June to late August. That seems to line up fairly well with the [state's school terms](http://schools.nyc.gov/Calendar/2013-2014+School+Year+Calendars.htm): summer break in 2013 was Jun 26--Sep 9. 

Why are there more Saturday flights in the Spring than the Fall? I asked some American friends and they suggested that it's less common to plan family vacations during the Fall because of the big Thanksgiving and Christmas holidays. We don't have the data to know for sure, but it seems like a plausible working hypothesis.

Lets create a "term" variable that roughly captures the three school terms, and check our work with a plot:


```r
term <- function(date) {
  cut(date, 
    breaks = ymd(20130101, 20130605, 20130825, 20140101),
    labels = c("spring", "summer", "fall") 
  )
}

daily <- daily %>% 
  mutate(term = term(date)) 

daily %>% 
  filter(wday == "Sat") %>% 
  ggplot(aes(date, n, colour = term)) +
  geom_point(alpha = 1/3) + 
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.8](model-building_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 29.8**

(I manually tweaked the dates to get nice breaks in the plot. Using a visualisation to help you understand what your function is doing is a really powerful and general technique.)

It's useful to see how this new variable affects the other days of the week:


```r
daily %>% 
  ggplot(aes(wday, n, colour = term)) +
    geom_boxplot()
```



![Figure 29.9](model-building_files/figure-latex/unnamed-chunk-23-1.jpg)

**Figure 29.9**

It looks like there is significant variation across the terms, so fitting a separate day of week effect for each term is reasonable. This improves our model, but not as much as we might hope:


```r
mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)

daily %>% 
  gather_residuals(without_term = mod1, with_term = mod2) %>% 
  ggplot(aes(date, resid, colour = model)) +
    geom_line(alpha = 0.75)
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.10](model-building_files/figure-latex/unnamed-chunk-24-1.jpg)

**Figure 29.10**

We can see the problem by overlaying the predictions from the model on to the raw data:


```r
grid <- daily %>% 
  data_grid(wday, term) %>% 
  add_predictions(mod2, "n")

ggplot(daily, aes(wday, n)) +
  geom_boxplot() + 
  geom_point(data = grid, colour = "red") + 
  facet_wrap(~ term)
```



![Figure 29.11](model-building_files/figure-latex/unnamed-chunk-25-1.jpg)

**Figure 29.11**

Our model is finding the _mean_ effect, but we have a lot of big outliers, so mean tends to be far away from the typical value. We can alleviate this problem by using a model that is robust to the effect of outliers: `MASS::rlm()`. This greatly reduces the impact of the outliers on our estimates, and gives a model that does a good job of removing the day of week pattern:


```r
mod3 <- MASS::rlm(n ~ wday * term, data = daily)

daily %>% 
  add_residuals(mod3, "resid") %>% 
  ggplot(aes(date, resid)) + 
  geom_hline(yintercept = 0, size = 2, colour = "white") + 
  geom_line()
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.12](model-building_files/figure-latex/unnamed-chunk-26-1.jpg)

**Figure 29.12**

It's now much easier to see the long-term trend, and the positive and negative outliers.


### Computed variables

If you're experimenting with many models and many visualisations, it's a good idea to bundle the creation of variables up into a function so there's no chance of accidentally applying a different transformation in different places. For example, we could write:


```r
compute_vars <- function(data) {
  data %>% 
    mutate(
      term = term(date), 
      wday = wday(date, label = TRUE)
    )
}
```
{Run code | terminal}(Rscript code/dailyFlights.r)              


Another option is to put the transformations directly in the model formula:


```r
wday2 <- function(x) wday(x, label = TRUE)
mod3 <- lm(n ~ wday2(date) * term(date), data = daily)
```

Either approach is reasonable. Making the transformed variable explicit is useful if you want to check your work, or use them in a visualisation. But you can't easily use transformations (like splines) that return multiple columns. Including the transformations in the model function makes life a little easier when you're working with many different datasets because the model is self contained.

### Time of year: an alternative approach

In the previous section we used our domain knowledge (how the US school term affects travel) to improve the model. An alternative to using our knowledge explicitly in the model is to give the data more room to speak. We could use a more flexible model and allow that to capture the pattern we're interested in. A simple linear trend isn't adequate, so we could try using a natural spline to fit a smooth curve across the year:


```r
library(splines)
mod <- MASS::rlm(n ~ wday * ns(date, 5), data = daily)

daily %>% 
  data_grid(wday, date = seq_range(date, n = 13)) %>% 
  add_predictions(mod) %>% 
  ggplot(aes(date, pred, colour = wday)) + 
    geom_line() +
    geom_point()
```
{Run code | terminal}(Rscript code/dailyFlights.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 29.13](model-building_files/figure-latex/unnamed-chunk-29-1.jpg)

**Figure 29.13**

We see a strong pattern in the numbers of Saturday flights. This is reassuring, because we also saw that pattern in the raw data. It's a good sign when you get the same signal from different approaches.


### Exercises

1.  Use your Google sleuthing skills to brainstorm why there were fewer than
    expected flights on Jan 20, May 26, and Sep 1. (Hint: they all have the
    same explanation.) How would these days generalise to another year?

1.  What do the three days with high positive residuals represent?
    How would these days generalise to another year?

    
```r
    daily %>% 
      top_n(3, resid)
    #> # A tibble: 3 x 5
    #>   date           n wday  resid term 
    #>   <date>     <int> <ord> <dbl> <fct>
    #> 1 2013-11-30   857 Sat   112.  fall 
    #> 2 2013-12-01   987 Sun    95.5 fall 
    #> 3 2013-12-28   814 Sat    69.4 fall
```

1.  Create a new variable that splits the `wday` variable into terms, but only
    for Saturdays, i.e. it should have `Thurs`, `Fri`, but `Sat-summer`, 
    `Sat-spring`, `Sat-fall`. How does this model compare with the model with 
    every combination of `wday` and `term`?
    
1.  Create a new `wday` variable that combines the day of week, term 
    (for Saturdays), and public holidays. What do the residuals of 
    that model look like?

1.  What happens if you fit a day of week effect that varies by month 
    (i.e. `n ~ wday * month`)? Why is this not very helpful? 

1.  What would you expect the model `n ~ wday + ns(date, 5)` to look like?
    Knowing what you know about the data, why would you expect it to be
    not particularly effective?

1.  We hypothesised that people leaving on Sundays are more likely to be 
    business travellers who need to be somewhere on Monday. Explore that 
    hypothesis by seeing how it breaks down based on distance and time: if 
    it's true, you'd expect to see more Sunday evening flights to places that 
    are far away.

1.  It's a little frustrating that Sunday and Saturday are on separate ends
    of the plot. Write a small function to set the levels of the 
    factor so that the week starts on Monday.
