
The first tool we'll look at for combining a pair of tables is the __mutating join__. A mutating join allows you to combine variables from two tables. It first matches observations by their keys, then copies across variables from one table to the other.

Like `mutate()`, the join functions add variables to the right, so if you have a lot of variables already, the new variables won't get printed out. For these examples, we'll make it easier to see what's going on in the examples by creating a narrower dataset:


```r
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2
#> # A tibble: 336,776 x 8
#>    year month   day  hour origin dest  tailnum carrier
#>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>  
#> 1  2013     1     1     5 EWR    IAH   N14228  UA     
#> 2  2013     1     1     5 LGA    IAH   N24211  UA     
#> 3  2013     1     1     5 JFK    MIA   N619AA  AA     
#> 4  2013     1     1     5 JFK    BQN   N804JB  B6     
#> 5  2013     1     1     6 LGA    ATL   N668DN  DL     
#> 6  2013     1     1     5 EWR    ORD   N39463  UA     
#> # ... with 3.368e+05 more rows
```

(Remember, when you're in RStudio, you can also use `View()` to avoid this problem.)

Imagine you want to add the full airline name to the `flights2` data. You can combine the `airlines` and `flights2` data frames with `left_join()`:


```r
flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")
#> # A tibble: 336,776 x 7
#>    year month   day  hour tailnum carrier name                  
#>   <int> <int> <int> <dbl> <chr>   <chr>   <chr>                 
#> 1  2013     1     1     5 N14228  UA      United Air Lines Inc. 
#> 2  2013     1     1     5 N24211  UA      United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA  AA      American Airlines Inc.
#> 4  2013     1     1     5 N804JB  B6      JetBlue Airways       
#> 5  2013     1     1     6 N668DN  DL      Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463  UA      United Air Lines Inc. 
#> # ... with 3.368e+05 more rows
```

The result of joining airlines to flights2 is an additional variable: `name`. This is why I call this type of join a mutating join. In this case, you could have got to the same place using `mutate()` and R's base subsetting:


```r
flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])
#> # A tibble: 336,776 x 7
#>    year month   day  hour tailnum carrier name                  
#>   <int> <int> <int> <dbl> <chr>   <chr>   <chr>                 
#> 1  2013     1     1     5 N14228  UA      United Air Lines Inc. 
#> 2  2013     1     1     5 N24211  UA      United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA  AA      American Airlines Inc.
#> 4  2013     1     1     5 N804JB  B6      JetBlue Airways       
#> 5  2013     1     1     6 N668DN  DL      Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463  UA      United Air Lines Inc. 
#> # ... with 3.368e+05 more rows
```

But this is hard to generalise when you need to match multiple variables, and takes close reading to figure out the overall intent.

The following sections explain, in detail, how mutating joins work. You'll start by learning a useful visual representation of joins. We'll then use that to explain the four mutating join functions: the inner join, and the three outer joins. When working with real data, keys don't always uniquely identify observations, so next we'll talk about what happens when there isn't a unique match. Finally, you'll learn how to tell dplyr which variables are the keys for a given join.

### Understanding joins

To help you learn how joins work, I'm going to use a visual representation:


![Figure 16.1](diagrams/join-setup.png)

**Figure 16.1**

```r
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     3, "x3"
)
y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2",
     4, "y3"
)
```

The coloured column represents the "key" variable: these are used to match the rows between the tables. The grey column represents the "value" column that is carried along for the ride. In these examples I'll show a single key variable, but the idea generalises in a straightforward way to multiple keys and multiple values.

A join is a way of connecting each row in `x` to zero, one, or more rows in `y`. The following diagram shows each potential match as an intersection of a pair of lines.


![Figure 16.2](diagrams/join-setup2.png)

**Figure 16.2**

(If you look closely, you might notice that we've switched the order of the key and value columns in `x`. This is to emphasise that joins match based on the key; the value is just carried along for the ride.)

In an actual join, matches will be indicated with dots. The number of dots = the number of matches = the number of rows in the output.


![Figure 16.3](diagrams/join-inner.png)

**Figure 16.3**

### Inner join 

The simplest type of join is the __inner join__. An inner join matches pairs of observations whenever their keys are equal:


![Figure 16.4](diagrams/join-inner.png)

**Figure 16.4**

(To be precise, this is an inner __equijoin__ because the keys are matched using the equality operator. Since most joins are equijoins we usually drop that specification.)

The output of an inner join is a new data frame that contains the key, the x values, and the y values. We use `by` to tell dplyr which variable is the key:


```r
x %>% 
  inner_join(y, by = "key")
#> # A tibble: 2 x 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1 x1    y1   
#> 2     2 x2    y2
```

The most important property of an inner join is that unmatched rows are not included in the result. This means that generally inner joins are usually not appropriate for use in analysis because it's too easy to lose observations.

### Outer joins 

An inner join keeps observations that appear in both tables. An __outer join__ keeps observations that appear in at least one of the tables. There are three types of outer joins:

* A __left join__ keeps all observations in `x`.
* A __right join__ keeps all observations in `y`.
* A __full join__ keeps all observations in `x` and `y`.

These joins work by adding an additional "virtual" observation to each table. This observation has a key that always matches (if no other key matches), and a value filled with `NA`.

Graphically, that looks like:


![Figure 16.5](diagrams/join-outer.png)

**Figure 16.5**

The most commonly used join is the left join: you use this whenever you look up additional data from another table, because it preserves the original observations even when there isn't a match. The left join should be your default join: use it unless you have a strong reason to prefer one of the others.

Another way to depict the different types of joins is with a Venn diagram:


![Figure 16.6](diagrams/join-venn.png)

**Figure 16.6**

However, this is not a great representation. It might jog your memory about which join preserves the observations in which table, but it suffers from a major limitation: a Venn diagram can't show what happens when keys don't uniquely identify an observation.

### Duplicate keys 

So far all the diagrams have assumed that the keys are unique. But that's not always the case. This section explains what happens when the keys are not unique. There are two possibilities:

1.  One table has duplicate keys. This is useful when you want to
    add in additional information as there is typically a one-to-many
    relationship.

    
![Figure 16.7](diagrams/join-one-to-many.png)

**Figure 16.7**

    Note that I've put the key column in a slightly different position
    in the output. This reflects that the key is a primary key in `y`
    and a foreign key in `x`.

    
```r
    x <- tribble(
      ~key, ~val_x,
         1, "x1",
         2, "x2",
         2, "x3",
         1, "x4"
    )
    y <- tribble(
      ~key, ~val_y,
         1, "y1",
         2, "y2"
    )
    left_join(x, y, by = "key")
    #> # A tibble: 4 x 3
    #>     key val_x val_y
    #>   <dbl> <chr> <chr>
    #> 1     1 x1    y1   
    #> 2     2 x2    y2   
    #> 3     2 x3    y2   
    #> 4     1 x4    y1
```

1.  Both tables have duplicate keys. This is usually an error because in
    neither table do the keys uniquely identify an observation. When you join
    duplicated keys, you get all possible combinations, the Cartesian product:

    
![Figure 16.8](diagrams/join-many-to-many.png)

**Figure 16.8**

    
```r
    x <- tribble(
      ~key, ~val_x,
         1, "x1",
         2, "x2",
         2, "x3",
         3, "x4"
    )
    y <- tribble(
      ~key, ~val_y,
         1, "y1",
         2, "y2",
         2, "y3",
         3, "y4"
    )
    left_join(x, y, by = "key")
    #> # A tibble: 6 x 3
    #>     key val_x val_y
    #>   <dbl> <chr> <chr>
    #> 1     1 x1    y1   
    #> 2     2 x2    y2   
    #> 3     2 x2    y3   
    #> 4     2 x3    y2   
    #> 5     2 x3    y3   
    #> 6     3 x4    y4
```

### Defining the key columns 

So far, the pairs of tables have always been joined by a single variable, and that variable has the same name in both tables. That constraint was encoded by `by = "key"`. You can use other values for `by` to connect the tables in other ways:

  * The default, `by = NULL`, uses all variables that appear in both tables,
    the so called __natural__ join. For example, the flights and weather tables
    match on their common variables: `year`, `month`, `day`, `hour` and
    `origin`.

    
```r
    flights2 %>% 
      left_join(weather)
    #> Joining, by = c("year", "month", "day", "hour", "origin")
    #> # A tibble: 336,776 x 18
    #>    year month   day  hour origin dest  tailnum carrier  temp  dewp humid
    #>   <dbl> <dbl> <int> <dbl> <chr>  <chr> <chr>   <chr>   <dbl> <dbl> <dbl>
    #> 1  2013     1     1     5 EWR    IAH   N14228  UA       39.0  28.0  64.4
    #> 2  2013     1     1     5 LGA    IAH   N24211  UA       39.9  25.0  54.8
    #> 3  2013     1     1     5 JFK    MIA   N619AA  AA       39.0  27.0  61.6
    #> 4  2013     1     1     5 JFK    BQN   N804JB  B6       39.0  27.0  61.6
    #> 5  2013     1     1     6 LGA    ATL   N668DN  DL       39.9  25.0  54.8
    #> 6  2013     1     1     5 EWR    ORD   N39463  UA       39.0  28.0  64.4
    #> # ... with 3.368e+05 more rows, and 7 more variables: wind_dir <dbl>,
    #> #   wind_speed <dbl>, wind_gust <dbl>, precip <dbl>, pressure <dbl>,
    #> #   visib <dbl>, time_hour <dttm>
```

  * A character vector, `by = "x"`. This is like a natural join, but uses only
    some of the common variables. For example, `flights` and `planes` have
    `year` variables, but they mean different things so we only want to join by
    `tailnum`.

    
```r
    flights2 %>% 
      left_join(planes, by = "tailnum")
    #> # A tibble: 336,776 x 16
    #>   year.x month   day  hour origin dest  tailnum carrier year.y type 
    #>    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>
    #> 1   2013     1     1     5 EWR    IAH   N14228  UA        1999 Fixe~
    #> 2   2013     1     1     5 LGA    IAH   N24211  UA        1998 Fixe~
    #> 3   2013     1     1     5 JFK    MIA   N619AA  AA        1990 Fixe~
    #> 4   2013     1     1     5 JFK    BQN   N804JB  B6        2012 Fixe~
    #> 5   2013     1     1     6 LGA    ATL   N668DN  DL        1991 Fixe~
    #> 6   2013     1     1     5 EWR    ORD   N39463  UA        2012 Fixe~
    #> # ... with 3.368e+05 more rows, and 6 more variables: manufacturer <chr>,
    #> #   model <chr>, engines <int>, seats <int>, speed <int>, engine <chr>
```

    Note that the `year` variables (which appear in both input data frames,
    but are not constrained to be equal) are disambiguated in the output with
    a suffix.

  * A named character vector: `by = c("a" = "b")`. This will
    match variable `a` in table `x` to variable `b` in table `y`. The
    variables from `x` will be used in the output.

    For example, if we want to draw a map we need to combine the flights data
    with the airports data which contains the location (`lat` and `lon`) of
    each airport. Each flight has an origin and destination `airport`, so we
    need to specify which one we want to join to:

    
```r
    flights2 %>% 
      left_join(airports, c("dest" = "faa"))
    #> # A tibble: 336,776 x 15
    #>    year month   day  hour origin dest  tailnum carrier name    lat   lon
    #>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr> <dbl> <dbl>
    #> 1  2013     1     1     5 EWR    IAH   N14228  UA      Geor~  30.0 -95.3
    #> 2  2013     1     1     5 LGA    IAH   N24211  UA      Geor~  30.0 -95.3
    #> 3  2013     1     1     5 JFK    MIA   N619AA  AA      Miam~  25.8 -80.3
    #> 4  2013     1     1     5 JFK    BQN   N804JB  B6      <NA>   NA    NA  
    #> 5  2013     1     1     6 LGA    ATL   N668DN  DL      Hart~  33.6 -84.4
    #> 6  2013     1     1     5 EWR    ORD   N39463  UA      Chic~  42.0 -87.9
    #> # ... with 3.368e+05 more rows, and 4 more variables: alt <int>, tz <dbl>,
    #> #   dst <chr>, tzone <chr>
    
    flights2 %>% 
      left_join(airports, c("origin" = "faa"))
    #> # A tibble: 336,776 x 15
    #>    year month   day  hour origin dest  tailnum carrier name    lat   lon
    #>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr> <dbl> <dbl>
    #> 1  2013     1     1     5 EWR    IAH   N14228  UA      Newa~  40.7 -74.2
    #> 2  2013     1     1     5 LGA    IAH   N24211  UA      La G~  40.8 -73.9
    #> 3  2013     1     1     5 JFK    MIA   N619AA  AA      John~  40.6 -73.8
    #> 4  2013     1     1     5 JFK    BQN   N804JB  B6      John~  40.6 -73.8
    #> 5  2013     1     1     6 LGA    ATL   N668DN  DL      La G~  40.8 -73.9
    #> 6  2013     1     1     5 EWR    ORD   N39463  UA      Newa~  40.7 -74.2
    #> # ... with 3.368e+05 more rows, and 4 more variables: alt <int>, tz <dbl>,
    #> #   dst <chr>, tzone <chr>
```

### Exercises

1.  Compute the average delay by destination, then join on the `airports`
    data frame so you can show the spatial distribution of delays. Here's an
    easy way to draw a map of the United States:

    
```r
    airports %>%
      semi_join(flights, c("faa" = "dest")) %>%
      ggplot(aes(lon, lat)) +
        borders("state") +
        geom_point() +
        coord_quickmap()
```

    (Don't worry if you don't understand what `semi_join()` does --- you'll
    learn about it next.)

    You might want to use the `size` or `colour` of the points to display
    the average delay for each airport.

1.  Add the location of the origin _and_ destination (i.e. the `lat` and `lon`)
    to `flights`.

1.  Is there a relationship between the age of a plane and its delays?

1.  What weather conditions make it more likely to see a delay?

1.  What happened on June 13 2013? Display the spatial pattern of delays,
    and then use Google to cross-reference with the weather.

    

### Other implementations

`base::merge()` can perform all four types of mutating join:

dplyr              | merge
-------------------|-------------------------------------------
`inner_join(x, y)` | `merge(x, y)`
`left_join(x, y)`  | `merge(x, y, all.x = TRUE)`
`right_join(x, y)` | `merge(x, y, all.y = TRUE)`,
`full_join(x, y)`  | `merge(x, y, all.x = TRUE, all.y = TRUE)`

The advantages of the specific dplyr verbs is that they more clearly convey the intent of your code: the difference between the joins is really important but concealed in the arguments of `merge()`. dplyr's joins are considerably faster and don't mess with the order of the rows.

SQL is the inspiration for dplyr's conventions, so the translation is straightforward:

dplyr                        | SQL
-----------------------------|-------------------------------------------
`inner_join(x, y, by = "z")` | `SELECT * FROM x INNER JOIN y USING (z)`
`left_join(x, y, by = "z")`  | `SELECT * FROM x LEFT OUTER JOIN y USING (z)`
`right_join(x, y, by = "z")` | `SELECT * FROM x RIGHT OUTER JOIN y USING (z)`
`full_join(x, y, by = "z")`  | `SELECT * FROM x FULL OUTER JOIN y USING (z)`

Note that "INNER" and "OUTER" are optional, and often omitted.

Joining different variables between the tables, e.g. `inner_join(x, y, by = c("a" = "b"))` uses a slightly different syntax in SQL: `SELECT * FROM x INNER JOIN y ON x.a = y.b`. As this syntax suggests, SQL supports a wider  range of join types than dplyr because you can connect the tables using constraints other than equality (sometimes called non-equijoins).
