
The variables used to connect each pair of tables are called __keys__. A key is a variable (or set of variables) that uniquely identifies an observation. In simple cases, a single variable is sufficient to identify an observation. For example, each plane is uniquely identified by its `tailnum`. In other cases, multiple variables may be needed. For example, to identify an observation in `weather` you need five variables: `year`, `month`, `day`, `hour`, and `origin`.

There are two types of keys:

* A __primary key__ uniquely identifies an observation in its own table.
  For example, `planes$tailnum` is a primary key because it uniquely identifies
  each plane in the `planes` table.

* A __foreign key__ uniquely identifies an observation in another table.
  For example, the `flights$tailnum` is a foreign key because it appears in the 
  `flights` table where it matches each flight to a unique plane.

A variable can be both a primary key _and_ a foreign key. For example, `origin` is part of the `weather` primary key, and is also a foreign key for the `airport` table.

Once you've identified the primary keys in your tables, it's good practice to verify that they do indeed uniquely identify each observation. One way to do that is to `count()` the primary keys and look for entries where `n` is greater than one:


```r
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)
#> # A tibble: 0 x 2
#> # ... with 2 variables: tailnum <chr>, n <int>

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)
#> # A tibble: 3 x 6
#>    year month   day  hour origin     n
#>   <dbl> <dbl> <int> <int> <chr>  <int>
#> 1  2013    11     3     1 EWR        2
#> 2  2013    11     3     1 JFK        2
#> 3  2013    11     3     1 LGA        2
```

Sometimes a table doesn't have an explicit primary key: each row is an observation, but no combination of variables reliably identifies it. For example, what's the primary key in the `flights` table? You might think it would be the date plus the flight or tail number, but neither of those are unique:


```r
flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
#> # A tibble: 29,768 x 5
#>    year month   day flight     n
#>   <int> <int> <int>  <int> <int>
#> 1  2013     1     1      1     2
#> 2  2013     1     1      3     2
#> 3  2013     1     1      4     2
#> 4  2013     1     1     11     3
#> 5  2013     1     1     15     2
#> 6  2013     1     1     21     2
#> # ... with 2.976e+04 more rows

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)
#> # A tibble: 64,928 x 5
#>    year month   day tailnum     n
#>   <int> <int> <int> <chr>   <int>
#> 1  2013     1     1 N0EGMQ      2
#> 2  2013     1     1 N11189      2
#> 3  2013     1     1 N11536      2
#> 4  2013     1     1 N11544      3
#> 5  2013     1     1 N11551      2
#> 6  2013     1     1 N12540      2
#> # ... with 6.492e+04 more rows
```

When starting to work with this data, I had naively assumed that each flight number would be only used once per day: that would make it much easier to communicate problems with a specific flight. Unfortunately that is not the case! If a table lacks a primary key, it's sometimes useful to add one with `mutate()` and `row_number()`. That makes it easier to match observations if you've done some filtering and want to check back in with the original data. This is called a __surrogate key__.

A primary key and the corresponding foreign key in another table form a __relation__. Relations are typically one-to-many. For example, each flight has one plane, but each plane has many flights. In other data, you'll occasionally see a 1-to-1 relationship. You can think of this as a special case of 1-to-many. You can model many-to-many relations with a many-to-1 relation plus a 1-to-many relation. For example, in this data there's a many-to-many relationship between airlines and airports: each airline flies to many airports; each airport hosts many airlines.

### Exercises

1.  Add a surrogate key to `flights`.

1.  Identify the keys in the following datasets

    1.  `Lahman::Batting`,
    1.  `babynames::babynames`
    1.  `nasaweather::atmos`
    1.  `fueleconomy::vehicles`
    1.  `ggplot2::diamonds`
    
    (You might need to install some packages and read some documentation.)

1.  Draw a diagram illustrating the connections between the `Batting`,
    `Master`, and `Salaries` tables in the Lahman package. Draw another diagram
    that shows the relationship between `Master`, `Managers`, `AwardsManagers`.

    How would you characterise the relationship between the `Batting`,
    `Pitching`, and `Fielding` tables?
