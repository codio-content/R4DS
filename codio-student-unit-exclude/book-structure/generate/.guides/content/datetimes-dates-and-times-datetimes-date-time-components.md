
Now that you know how to get date-time data into R's date-time data structures, let's explore what you can do with them. This section will focus on the accessor functions that let you get and set individual components. The next section will look at how arithmetic works with date-times.

### Getting components

You can pull out individual parts of the date with the accessor functions `year()`, `month()`, `mday()` (day of the month), `yday()` (day of the year), `wday()` (day of the week), `hour()`, `minute()`, and `second()`. 


```r
datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
#> [1] 2016
month(datetime)
#> [1] 7
mday(datetime)
#> [1] 8

yday(datetime)
#> [1] 190
wday(datetime)
#> [1] 6
```
{Run code | terminal}(Rscript code/dateTime.r)              


For `month()` and `wday()` you can set `label = TRUE` to return the abbreviated name of the month or day of the week. Set `abbr = FALSE` to return the full name.


```r
month(datetime, label = TRUE)
#> [1] Jul
#> 12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < ... < Dec
wday(datetime, label = TRUE, abbr = FALSE)
#> [1] Friday
#> 7 Levels: Sunday < Monday < Tuesday < Wednesday < Thursday < ... < Saturday
```

We can use `wday()` to see that more flights depart during the week than on the weekend:


```r
flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
    geom_bar()
```

{Run code | terminal}(Rscript code/dateTime.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 19.1](datetimes_files/figure-latex/unnamed-chunk-18-1.jpg)

**Figure 19.1**

There's an interesting pattern if we look at the average departure delay by minute within the hour. It looks like flights leaving in minutes 20-30 and 50-60 have much lower delays than the rest of the hour!


```r
flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, avg_delay)) +
    geom_line()
```



![Figure 19.2](datetimes_files/figure-latex/unnamed-chunk-19-1.jpg)

**Figure 19.2**

Interestingly, if we look at the _scheduled_ departure time we don't see such a strong pattern:


```r
sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())

ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()
```

{Run code | terminal}(Rscript code/dateTime.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 19.3](datetimes_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 19.3**

So why do we see that pattern with the actual departure times? Well, like much data collected by humans, there's a strong bias towards flights leaving at "nice" departure times. Always be alert for this sort of pattern whenever you work with data that involves human judgement!


```r
ggplot(sched_dep, aes(minute, n)) +
  geom_line()
```



![Figure 19.4](datetimes_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 19.4**

### Rounding

An alternative approach to plotting individual components is to round the date to a nearby unit of time, with `floor_date()`, `round_date()`, and `ceiling_date()`. Each function takes a vector of dates to adjust and then the name of the unit round down (floor), round up (ceiling), or round to. This, for example, allows us to plot the number of flights per week:


```r
flights_dt %>% 
  count(week = floor_date(dep_time, "week")) %>% 
  ggplot(aes(week, n)) +
    geom_line()
```

{Run code | terminal}(Rscript code/dateTime.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 19.5](datetimes_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 19.5**

Computing the difference between a rounded and unrounded date can be particularly useful.

### Setting components

You can also use each accessor function to set the components of a date/time: 


```r
(datetime <- ymd_hms("2016-07-08 12:34:56"))
#> [1] "2016-07-08 12:34:56 UTC"

year(datetime) <- 2020
datetime
#> [1] "2020-07-08 12:34:56 UTC"
month(datetime) <- 01
datetime
#> [1] "2020-01-08 12:34:56 UTC"
hour(datetime) <- hour(datetime) + 1
datetime
#> [1] "2020-01-08 13:34:56 UTC"
```

Alternatively, rather than modifying in place, you can create a new date-time with `update()`. This also allows you to set multiple values at once.


```r
update(datetime, year = 2020, month = 2, mday = 2, hour = 2)
#> [1] "2020-02-02 02:34:56 UTC"
```

If values are too big, they will roll-over:


```r
ymd("2015-02-01") %>% 
  update(mday = 30)
#> [1] "2015-03-02"
ymd("2015-02-01") %>% 
  update(hour = 400)
#> [1] "2015-02-17 16:00:00 UTC"
```
{Run code | terminal}(Rscript code/dateTime.r)              


You can use `update()` to show the distribution of flights across the course of the day for every day of the year: 


```r
flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) +
    geom_freqpoly(binwidth = 300)
```

{Run code | terminal}(Rscript code/dateTime.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 19.6](datetimes_files/figure-latex/unnamed-chunk-26-1.jpg)

**Figure 19.6**

Setting larger components of a date to a constant is a powerful technique that allows you to explore patterns in the smaller components.

### Exercises

1.  How does the distribution of flight times within a day change over the 
    course of the year?
    
1.  Compare `dep_time`, `sched_dep_time` and `dep_delay`. Are they consistent?
    Explain your findings.

1.  Compare `air_time` with the duration between the departure and arrival.
    Explain your findings. (Hint: consider the location of the airport.)
    
1.  How does the average delay time change over the course of a day?
    Should you use `dep_time` or `sched_dep_time`? Why?

1.  On what day of the week should you leave if you want to minimise the
    chance of a delay?

1.  What makes the distribution of `diamonds$carat` and 
    `flights$sched_dep_time` similar?

1.  Confirm my hypothesis that the early departures of flights in minutes
    20-30 and 50-60 are caused by scheduled flights that leave early. 
    Hint: create a binary variable that tells you whether or not a flight 
    was delayed.
