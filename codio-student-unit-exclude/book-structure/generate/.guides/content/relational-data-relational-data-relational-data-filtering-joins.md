
Filtering joins match observations in the same way as mutating joins, but affect the observations, not the variables. There are two types:

* `semi_join(x, y)` __keeps__ all observations in `x` that have a match in `y`.
* `anti_join(x, y)` __drops__ all observations in `x` that have a match in `y`.

Semi-joins are useful for matching filtered summary tables back to the original rows. For example, imagine you've found the top ten most popular destinations:


```r
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest
#> # A tibble: 10 x 2
#>   dest      n
#>   <chr> <int>
#> 1 ORD   17283
#> 2 ATL   17215
#> 3 LAX   16174
#> 4 BOS   15508
#> 5 MCO   14082
#> 6 CLT   14064
#> # ... with 4 more rows
```
{Run code | terminal}(Rscript code/filterJoins.r)


Now you want to find each flight that went to one of those destinations. You could construct a filter yourself:


```r
flights %>% 
  filter(dest %in% top_dest$dest)
#> # A tibble: 141,145 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      542            540         2      923
#> 2  2013     1     1      554            600        -6      812
#> 3  2013     1     1      554            558        -4      740
#> 4  2013     1     1      555            600        -5      913
#> 5  2013     1     1      557            600        -3      838
#> 6  2013     1     1      558            600        -2      753
#> # ... with 1.411e+05 more rows, and 12 more variables:
#> #   sched_arr_time <int>, arr_delay <dbl>, carrier <chr>, flight <int>,
#> #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
#> #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

But it's difficult to extend that approach to multiple variables. For example, imagine that you'd found the 10 days with highest average delays. How would you construct the filter statement that used `year`, `month`, and `day` to match it back to `flights`?

Instead you can use a semi-join, which connects the two tables like a mutating join, but instead of adding new columns, only keeps the rows in `x` that have a match in `y`:


```r
flights %>% 
  semi_join(top_dest)
#> Joining, by = "dest"
#> # A tibble: 141,145 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      542            540         2      923
#> 2  2013     1     1      554            600        -6      812
#> 3  2013     1     1      554            558        -4      740
#> 4  2013     1     1      555            600        -5      913
#> 5  2013     1     1      557            600        -3      838
#> 6  2013     1     1      558            600        -2      753
#> # ... with 1.411e+05 more rows, and 12 more variables:
#> #   sched_arr_time <int>, arr_delay <dbl>, carrier <chr>, flight <int>,
#> #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
#> #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```
{Run code | terminal}(Rscript code/filterJoins.r)


Graphically, a semi-join looks like this:


![Figure 16.1](diagrams/join-semi.png)

**Figure 16.1**

Only the existence of a match is important; it doesn't matter which observation is matched. This means that filtering joins never duplicate rows like mutating joins do:


![Figure 16.2](diagrams/join-semi-many.png)

**Figure 16.2**

The inverse of a semi-join is an anti-join. An anti-join keeps the rows that _don't_ have a match:


![Figure 16.3](diagrams/join-anti.png)

**Figure 16.3**

Anti-joins are useful for diagnosing join mismatches. For example, when connecting `flights` and `planes`, you might be interested to know that there are many `flights` that don't have a match in `planes`:


```r
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)
#> # A tibble: 722 x 2
#>   tailnum     n
#>   <chr>   <int>
#> 1 <NA>     2512
#> 2 N725MQ    575
#> 3 N722MQ    513
#> 4 N723MQ    507
#> 5 N713MQ    483
#> 6 N735MQ    396
#> # ... with 716 more rows
```
{Run code | terminal}(Rscript code/filterJoins.r)


### Exercises

1.  What does it mean for a flight to have a missing `tailnum`? What do the
    tail numbers that don't have a matching record in `planes` have in common?
    (Hint: one variable explains ~90% of the problems.)

1.  Filter flights to only show flights with planes that have flown at least 100
    flights.

1.  Combine `fueleconomy::vehicles` and `fueleconomy::common` to find only the
    records for the most common models.

1.  Find the 48 hours (over the course of the whole year) that have the worst
    delays. Cross-reference it with the `weather` data. Can you see any
    patterns?

1.  What does `anti_join(flights, airports, by = c("dest" = "faa"))` tell you?
    What does `anti_join(airports, flights, by = c("faa" = "dest"))` tell you?

1.  You might expect that there's an implicit relationship between plane
    and airline, because each plane is flown by a single airline. Confirm
    or reject this hypothesis using the tools you've learned above.
