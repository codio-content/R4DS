
Next you'll learn about how arithmetic with dates works, including subtraction, addition, and division. Along the way, you'll learn about three important classes that represent time spans:

* __durations__, which represent an exact number of seconds.
* __periods__, which represent human units like weeks and months.
* __intervals__, which represent a starting and ending point.

### Durations

In R, when you subtract two dates, you get a difftime object:


```r
# How old is Hadley?
h_age <- today() - ymd(19791014)
h_age
#> Time difference of 14423 days
```
{Run code | terminal}(Rscript code/timeSpans.r)              


A difftime class object records a time span of seconds, minutes, hours, days, or weeks. This ambiguity can make difftimes a little painful to work with, so lubridate provides an alternative which always uses seconds: the __duration__.


```r
as.duration(h_age)
#> [1] "1246147200s (~39.49 years)"
```

Durations come with a bunch of convenient constructors:


```r
dseconds(15)
#> [1] "15s"
dminutes(10)
#> [1] "600s (~10 minutes)"
dhours(c(12, 24))
#> [1] "43200s (~12 hours)" "86400s (~1 days)"
ddays(0:5)
#> [1] "0s"                "86400s (~1 days)"  "172800s (~2 days)"
#> [4] "259200s (~3 days)" "345600s (~4 days)" "432000s (~5 days)"
dweeks(3)
#> [1] "1814400s (~3 weeks)"
dyears(1)
#> [1] "31536000s (~52.14 weeks)"
```

Durations always record the time span in seconds. Larger units are created by converting minutes, hours, days, weeks, and years to seconds at the standard rate (60 seconds in a minute, 60 minutes in an hour, 24 hours in day, 7 days in a week, 365 days in a year).

You can add and multiply durations:


```r
2 * dyears(1)
#> [1] "63072000s (~2 years)"
dyears(1) + dweeks(12) + dhours(15)
#> [1] "38847600s (~1.23 years)"
```
{Run code | terminal}(Rscript code/timeSpans.r)              


You can add and subtract durations to and from days:


```r
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)
```

However, because durations represent an exact number of seconds, sometimes you might get an unexpected result:


```r
one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")

one_pm
#> [1] "2016-03-12 13:00:00 EST"
one_pm + ddays(1)
#> [1] "2016-03-13 14:00:00 EDT"
```

Why is one day after 1pm on March 12, 2pm on March 13?! If you look carefully at the date you might also notice that the time zones have changed. Because of DST, March 12 only has 23 hours, so if we add a full days worth of seconds we end up with a different time.

### Periods

To solve this problem, lubridate provides __periods__. Periods are time spans but don't have a fixed length in seconds, instead they work with "human" times, like days and months. That allows them work in a more intuitive way:


```r
one_pm
#> [1] "2016-03-12 13:00:00 EST"
one_pm + days(1)
#> [1] "2016-03-13 13:00:00 EDT"
```
{Run code | terminal}(Rscript code/timeSpans.r)              


Like durations, periods can be created with a number of friendly constructor functions. 


```r
seconds(15)
#> [1] "15S"
minutes(10)
#> [1] "10M 0S"
hours(c(12, 24))
#> [1] "12H 0M 0S" "24H 0M 0S"
days(7)
#> [1] "7d 0H 0M 0S"
months(1:6)
#> [1] "1m 0d 0H 0M 0S" "2m 0d 0H 0M 0S" "3m 0d 0H 0M 0S" "4m 0d 0H 0M 0S"
#> [5] "5m 0d 0H 0M 0S" "6m 0d 0H 0M 0S"
weeks(3)
#> [1] "21d 0H 0M 0S"
years(1)
#> [1] "1y 0m 0d 0H 0M 0S"
```

You can add and multiply periods:


```r
10 * (months(6) + days(1))
#> [1] "60m 10d 0H 0M 0S"
days(50) + hours(25) + minutes(2)
#> [1] "50d 25H 2M 0S"
```

And of course, add them to dates. Compared to durations, periods are more likely to do what you expect:


```r
# A leap year
ymd("2016-01-01") + dyears(1)
#> [1] "2016-12-31"
ymd("2016-01-01") + years(1)
#> [1] "2017-01-01"

# Daylight Savings Time
one_pm + ddays(1)
#> [1] "2016-03-13 14:00:00 EDT"
one_pm + days(1)
#> [1] "2016-03-13 13:00:00 EDT"
```
{Run code | terminal}(Rscript code/timeSpans.r)              


Let's use periods to fix an oddity related to our flight dates. Some planes appear to have arrived at their destination _before_ they departed from New York City.


```r
flights_dt %>% 
  filter(arr_time < dep_time) 
#> # A tibble: 10,633 x 9
#>   origin dest  dep_delay arr_delay dep_time            sched_dep_time     
#>   <chr>  <chr>     <dbl>     <dbl> <dttm>              <dttm>             
#> 1 EWR    BQN           9        -4 2013-01-01 19:29:00 2013-01-01 19:20:00
#> 2 JFK    DFW          59        NA 2013-01-01 19:39:00 2013-01-01 18:40:00
#> 3 EWR    TPA          -2         9 2013-01-01 20:58:00 2013-01-01 21:00:00
#> 4 EWR    SJU          -6       -12 2013-01-01 21:02:00 2013-01-01 21:08:00
#> 5 EWR    SFO          11       -14 2013-01-01 21:08:00 2013-01-01 20:57:00
#> 6 LGA    FLL         -10        -2 2013-01-01 21:20:00 2013-01-01 21:30:00
#> # ... with 1.063e+04 more rows, and 3 more variables: arr_time <dttm>,
#> #   sched_arr_time <dttm>, air_time <dbl>
```

These are overnight flights. We used the same date information for both the departure and the arrival times, but these flights arrived on the following day. We can fix this by adding `days(1)` to the arrival time of each overnight flight.


```r
flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )
```

Now all of our flights obey the laws of physics.


```r
flights_dt %>% 
  filter(overnight, arr_time < dep_time) 
#> # A tibble: 0 x 10
#> # ... with 10 variables: origin <chr>, dest <chr>, dep_delay <dbl>,
#> #   arr_delay <dbl>, dep_time <dttm>, sched_dep_time <dttm>,
#> #   arr_time <dttm>, sched_arr_time <dttm>, air_time <dbl>,
#> #   overnight <lgl>
```
{Run code | terminal}(Rscript code/timeSpans.r)              


### Intervals

It's obvious what `dyears(1) / ddays(365)` should return: one, because durations are always represented by a number of seconds, and a duration of a year is defined as 365 days worth of seconds.

What should `years(1) / days(1)` return? Well, if the year was 2015 it should return 365, but if it was 2016, it should return 366! There's not quite enough information for lubridate to give a single clear answer. What it does instead is give an estimate, with a warning:


```r
years(1) / days(1)
#> estimate only: convert to intervals for accuracy
#> [1] 365
```

If you want a more accurate measurement, you'll have to use an __interval__. An interval is a duration with a starting point: that makes it precise so you can determine exactly how long it is:


```r
next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)
#> [1] 366
```
{Run code | terminal}(Rscript code/timeSpans.r)              


To find out how many periods fall into an interval, you need to use integer division:


```r
(today() %--% next_year) %/% days(1)
#> Note: method with signature 'Timespan#Timespan' chosen for function '%/%',
#>  target signature 'Interval#Period'.
#>  "Interval#ANY", "ANY#Period" would also be valid
#> [1] 366
```

### Summary

How do you pick between duration, periods, and intervals? As always, pick the simplest data structure that solves your problem. If you only care about physical time, use a duration; if you need to add human times, use a period; if you need to figure out how long a span is in human units, use an interval.

Figure \@ref(fig:dt-algebra) summarises permitted arithmetic operations between the different data types.

![Figure 19.1The allowed arithmetic operations between pairs of date/time classes.](diagrams/datetimes-arithmetic.png)

**Figure 19.1The allowed arithmetic operations between pairs of date/time classes.**

### Exercises

1.  Why is there `months()` but no `dmonths()`?

1.  Explain `days(overnight * 1)` to someone who has just started 
    learning R. How does it work?

1.  Create a vector of dates giving the first day of every month in 2015.
    Create a vector of dates giving the first day of every month
    in the _current_ year.

1.  Write a function that given your birthday (as a date), returns 
    how old you are in years.

1.  Why can't `(today() %--% (today() + years(1)) / months(1)` work?
