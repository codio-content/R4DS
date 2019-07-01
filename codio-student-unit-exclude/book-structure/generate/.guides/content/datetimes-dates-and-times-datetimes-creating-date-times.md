
There are three types of date/time data that refer to an instant in time:

* A __date__. Tibbles print this as `<date>`.

* A __time__ within a day. Tibbles print this as `<time>`.

* A __date-time__ is a date plus a time: it uniquely identifies an
  instant in time (typically to the nearest second). Tibbles print this
  as `<dttm>`. Elsewhere in R these are called POSIXct, but I don't think
  that's a very useful name.
  
In this chapter we are only going to focus on dates and date-times as R doesn't have a native class for storing times. If you need one, you can use the __hms__ package.

You should always use the simplest possible data type that works for your needs. That means if you can use a date instead of a date-time, you should. Date-times are substantially more complicated because of the need to handle time zones, which we'll come back to at the end of the chapter.

To get the current date or date-time you can use `today()` or `now()`:


```r
today()
#> [1] "2019-04-10"
now()
#> [1] "2019-04-10 14:03:37 MSK"
```
{Run code | terminal}(Rscript code/dateTime.r)              


Otherwise, there are three ways you're likely to create a date/time:

* From a string.
* From individual date-time components.
* From an existing date/time object.

They work as follows.

### From strings

Date/time data often comes as strings. You've seen one approach to parsing strings into date-times in [date-times](#readr-datetimes). Another approach is to use the helpers provided by lubridate. They automatically work out the format once you specify the order of the component. To use them, identify the order in which year, month, and day appear in your dates, then arrange "y", "m", and "d" in the same order. That gives you the name of the lubridate function that will parse your date. For example:


```r
ymd("2017-01-31")
#> [1] "2017-01-31"
mdy("January 31st, 2017")
#> [1] "2017-01-31"
dmy("31-Jan-2017")
#> [1] "2017-01-31"
```

These functions also take unquoted numbers. This is the most concise way to create a single date/time object, as you might need when filtering date/time data. `ymd()` is short and unambiguous:


```r
ymd(20170131)
#> [1] "2017-01-31"
```
{Run code | terminal}(Rscript code/dateTime.r)              


`ymd()` and friends create dates. To create a date-time, add an underscore and one or more of "h", "m", and "s" to the name of the parsing function:


```r
ymd_hms("2017-01-31 20:11:59")
#> [1] "2017-01-31 20:11:59 UTC"
mdy_hm("01/31/2017 08:01")
#> [1] "2017-01-31 08:01:00 UTC"
```

You can also force the creation of a date-time from a date by supplying a timezone:


```r
ymd(20170131, tz = "UTC")
#> [1] "2017-01-31 UTC"
```

### From individual components

Instead of a single string, sometimes you'll have the individual components of the date-time spread across multiple columns. This is what we have in the flights data:


```r
flights %>% 
  select(year, month, day, hour, minute)
#> # A tibble: 336,776 x 5
#>    year month   day  hour minute
#>   <int> <int> <int> <dbl>  <dbl>
#> 1  2013     1     1     5     15
#> 2  2013     1     1     5     29
#> 3  2013     1     1     5     40
#> 4  2013     1     1     5     45
#> 5  2013     1     1     6      0
#> 6  2013     1     1     5     58
#> # ... with 3.368e+05 more rows
```
{Run code | terminal}(Rscript code/dateTime.r)              


To create a date/time from this sort of input, use `make_date()` for dates, or `make_datetime()` for date-times:


```r
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))
#> # A tibble: 336,776 x 6
#>    year month   day  hour minute departure          
#>   <int> <int> <int> <dbl>  <dbl> <dttm>             
#> 1  2013     1     1     5     15 2013-01-01 05:15:00
#> 2  2013     1     1     5     29 2013-01-01 05:29:00
#> 3  2013     1     1     5     40 2013-01-01 05:40:00
#> 4  2013     1     1     5     45 2013-01-01 05:45:00
#> 5  2013     1     1     6      0 2013-01-01 06:00:00
#> 6  2013     1     1     5     58 2013-01-01 05:58:00
#> # ... with 3.368e+05 more rows
```

Let's do the same thing for each of the four time columns in `flights`. The times are represented in a slightly odd format, so we use modulus arithmetic to pull out the hour and minute components. Once I've created the date-time variables, I focus in on the variables we'll explore in the rest of the chapter.


```r
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt
#> # A tibble: 328,063 x 9
#>   origin dest  dep_delay arr_delay dep_time            sched_dep_time     
#>   <chr>  <chr>     <dbl>     <dbl> <dttm>              <dttm>             
#> 1 EWR    IAH           2        11 2013-01-01 05:17:00 2013-01-01 05:15:00
#> 2 LGA    IAH           4        20 2013-01-01 05:33:00 2013-01-01 05:29:00
#> 3 JFK    MIA           2        33 2013-01-01 05:42:00 2013-01-01 05:40:00
#> 4 JFK    BQN          -1       -18 2013-01-01 05:44:00 2013-01-01 05:45:00
#> 5 LGA    ATL          -6       -25 2013-01-01 05:54:00 2013-01-01 06:00:00
#> 6 EWR    ORD          -4        12 2013-01-01 05:54:00 2013-01-01 05:58:00
#> # ... with 3.281e+05 more rows, and 3 more variables: arr_time <dttm>,
#> #   sched_arr_time <dttm>, air_time <dbl>
```

With this data, I can visualise the distribution of departure times across the year:


```r
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day
```
{Run code | terminal}(Rscript code/dateTime.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 19.1](datetimes_files/figure-latex/unnamed-chunk-10-1.jpg)

**Figure 19.1**

Or within a single day:


```r
flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes
```



![Figure 19.2](datetimes_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 19.2**

Note that when you use date-times in a numeric context (like in a histogram), 1 means 1 second, so a binwidth of 86400 means one day. For dates, 1 means 1 day.

### From other types

You may want to switch between a date-time and a date. That's the job of `as_datetime()` and `as_date()`:


```r
as_datetime(today())
#> [1] "2019-04-10 UTC"
as_date(now())
#> [1] "2019-04-10"
```
{Run code | terminal}(Rscript code/dateTime.r)              


Sometimes you'll get date/times as numeric offsets from the "Unix Epoch", 1970-01-01. If the offset is in seconds, use `as_datetime()`; if it's in days, use `as_date()`.


```r
as_datetime(60 * 60 * 10)
#> [1] "1970-01-01 10:00:00 UTC"
as_date(365 * 10 + 2)
#> [1] "1980-01-01"
```

### Exercises

1.  What happens if you parse a string that contains invalid dates?

    
```r
    ymd(c("2010-10-10", "bananas"))
```

1.  What does the `tzone` argument to `today()` do? Why is it important?

1.  Use the appropriate lubridate function to parse each of the following dates:

    
```r
    d1 <- "January 1, 2010"
    d2 <- "2015-Mar-07"
    d3 <- "06-Jun-2017"
    d4 <- c("August 19 (2015)", "July 1 (2015)")
    d5 <- "12/30/14" # Dec 30, 2014
```
