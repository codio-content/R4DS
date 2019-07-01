
We will use the nycflights13 package to learn about relational data. nycflights13 contains four tibbles that are related to the `flights` table that you used in [data transformation]:

*   `airlines` lets you look up the full carrier name from its abbreviated
    code:

    
```r
    airlines
    #> # A tibble: 16 x 2
    #>   carrier name                    
    #>   <chr>   <chr>                   
    #> 1 9E      Endeavor Air Inc.       
    #> 2 AA      American Airlines Inc.  
    #> 3 AS      Alaska Airlines Inc.    
    #> 4 B6      JetBlue Airways         
    #> 5 DL      Delta Air Lines Inc.    
    #> 6 EV      ExpressJet Airlines Inc.
    #> # ... with 10 more rows
```
{Run code | terminal}(Rscript code/nycFlights.r)


*   `airports` gives information about each airport, identified by the `faa`
    airport code:

    
```r
    airports
    #> # A tibble: 1,458 x 8
    #>   faa   name                       lat   lon   alt    tz dst   tzone       
    #>   <chr> <chr>                    <dbl> <dbl> <int> <dbl> <chr> <chr>       
    #> 1 04G   Lansdowne Airport         41.1 -80.6  1044    -5 A     America/New~
    #> 2 06A   Moton Field Municipal A~  32.5 -85.7   264    -6 A     America/Chi~
    #> 3 06C   Schaumburg Regional       42.0 -88.1   801    -6 A     America/Chi~
    #> 4 06N   Randall Airport           41.4 -74.4   523    -5 A     America/New~
    #> 5 09J   Jekyll Island Airport     31.1 -81.4    11    -5 A     America/New~
    #> 6 0A9   Elizabethton Municipal ~  36.4 -82.2  1593    -5 A     America/New~
    #> # ... with 1,452 more rows
```

*   `planes` gives information about each plane, identified by its `tailnum`:

    
```r
    planes
    #> # A tibble: 3,322 x 9
    #>   tailnum  year type       manufacturer   model  engines seats speed engine
    #>   <chr>   <int> <chr>      <chr>          <chr>    <int> <int> <int> <chr> 
    #> 1 N10156   2004 Fixed win~ EMBRAER        EMB-1~       2    55    NA Turbo~
    #> 2 N102UW   1998 Fixed win~ AIRBUS INDUST~ A320-~       2   182    NA Turbo~
    #> 3 N103US   1999 Fixed win~ AIRBUS INDUST~ A320-~       2   182    NA Turbo~
    #> 4 N104UW   1999 Fixed win~ AIRBUS INDUST~ A320-~       2   182    NA Turbo~
    #> 5 N10575   2002 Fixed win~ EMBRAER        EMB-1~       2    55    NA Turbo~
    #> 6 N105UW   1999 Fixed win~ AIRBUS INDUST~ A320-~       2   182    NA Turbo~
    #> # ... with 3,316 more rows
```

*   `weather` gives the weather at each NYC airport for each hour:

    
```r
    weather
    #> # A tibble: 26,115 x 15
    #>   origin  year month   day  hour  temp  dewp humid wind_dir wind_speed
    #>   <chr>  <dbl> <dbl> <int> <int> <dbl> <dbl> <dbl>    <dbl>      <dbl>
    #> 1 EWR     2013     1     1     1  39.0  26.1  59.4      270      10.4 
    #> 2 EWR     2013     1     1     2  39.0  27.0  61.6      250       8.06
    #> 3 EWR     2013     1     1     3  39.0  28.0  64.4      240      11.5 
    #> 4 EWR     2013     1     1     4  39.9  28.0  62.2      250      12.7 
    #> 5 EWR     2013     1     1     5  39.0  28.0  64.4      260      12.7 
    #> 6 EWR     2013     1     1     6  37.9  28.0  67.2      240      11.5 
    #> # ... with 2.611e+04 more rows, and 5 more variables: wind_gust <dbl>,
    #> #   precip <dbl>, pressure <dbl>, visib <dbl>, time_hour <dttm>
```
{Run code | terminal}(Rscript code/nycFlights.r)


One way to show the relationships between the different tables is with a drawing:


![Figure 16.1](diagrams/relational-nycflights.png)

**Figure 16.1**

This diagram is a little overwhelming, but it's simple compared to some you'll see in the wild! The key to understanding diagrams like this is to remember each relation always concerns a pair of tables. You don't need to understand the whole thing; you just need to understand the chain of relations between the tables that you are interested in.

For nycflights13:

* `flights` connects to `planes` via a single variable, `tailnum`. 

* `flights` connects to `airlines` through the `carrier` variable.

* `flights` connects to `airports` in two ways: via the `origin` and
  `dest` variables.

* `flights` connects to `weather` via `origin` (the location), and
  `year`, `month`, `day` and `hour` (the time).

### Exercises

1.  Imagine you wanted to draw (approximately) the route each plane flies from
    its origin to its destination. What variables would you need? What tables
    would you need to combine?

1.  I forgot to draw the relationship between `weather` and `airports`.
    What is the relationship and how should it appear in the diagram?

1.  `weather` only contains information for the origin (NYC) airports. If
    it contained weather records for all airports in the USA, what additional
    relation would it define with `flights`?

1.  We know that some days of the year are "special", and fewer people than
    usual fly on them. How might you represent that data as a data frame?
    What would be the primary keys of that table? How would it connect to the
    existing tables?
