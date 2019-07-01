
To finish off the chapter, let's pull together everything you've learned to tackle a realistic data tidying problem. The `tidyr::who` dataset contains tuberculosis (TB) cases broken down by year, country, age, gender, and diagnosis method. The data comes from the *2014 World Health Organization Global Tuberculosis Report*, available at <http://www.who.int/tb/country/data/download/en/>.

There's a wealth of epidemiological information in this dataset, but it's challenging to work with the data in the form that it's provided:


```r
who
#> # A tibble: 7,240 x 60
#>   country iso2  iso3   year new_sp_m014 new_sp_m1524 new_sp_m2534
#>   <chr>   <chr> <chr> <int>       <int>        <int>        <int>
#> 1 Afghan~ AF    AFG    1980          NA           NA           NA
#> 2 Afghan~ AF    AFG    1981          NA           NA           NA
#> 3 Afghan~ AF    AFG    1982          NA           NA           NA
#> 4 Afghan~ AF    AFG    1983          NA           NA           NA
#> 5 Afghan~ AF    AFG    1984          NA           NA           NA
#> 6 Afghan~ AF    AFG    1985          NA           NA           NA
#> # ... with 7,234 more rows, and 53 more variables: new_sp_m3544 <int>,
#> #   new_sp_m4554 <int>, new_sp_m5564 <int>, new_sp_m65 <int>,
#> #   new_sp_f014 <int>, new_sp_f1524 <int>, new_sp_f2534 <int>,
#> #   new_sp_f3544 <int>, new_sp_f4554 <int>, new_sp_f5564 <int>,
#> #   new_sp_f65 <int>, new_sn_m014 <int>, new_sn_m1524 <int>,
#> #   new_sn_m2534 <int>, new_sn_m3544 <int>, new_sn_m4554 <int>,
#> #   new_sn_m5564 <int>, new_sn_m65 <int>, new_sn_f014 <int>,
#> #   new_sn_f1524 <int>, new_sn_f2534 <int>, new_sn_f3544 <int>,
#> #   new_sn_f4554 <int>, new_sn_f5564 <int>, new_sn_f65 <int>,
#> #   new_ep_m014 <int>, new_ep_m1524 <int>, new_ep_m2534 <int>,
#> #   new_ep_m3544 <int>, new_ep_m4554 <int>, new_ep_m5564 <int>,
#> #   new_ep_m65 <int>, new_ep_f014 <int>, new_ep_f1524 <int>,
#> #   new_ep_f2534 <int>, new_ep_f3544 <int>, new_ep_f4554 <int>,
#> #   new_ep_f5564 <int>, new_ep_f65 <int>, newrel_m014 <int>,
#> #   newrel_m1524 <int>, newrel_m2534 <int>, newrel_m3544 <int>,
#> #   newrel_m4554 <int>, newrel_m5564 <int>, newrel_m65 <int>,
#> #   newrel_f014 <int>, newrel_f1524 <int>, newrel_f2534 <int>,
#> #   newrel_f3544 <int>, newrel_f4554 <int>, newrel_f5564 <int>,
#> #   newrel_f65 <int>
```
{Run code | terminal}(Rscript code/whoCase.r)              


This is a very typical real-life example dataset. It contains redundant columns, odd variable codes, and many missing values. In short, `who` is messy, and we'll need multiple steps to tidy it. Like dplyr, tidyr is designed so that each function does one thing well. That means in real-life situations you'll usually need to string together multiple verbs into a pipeline. 

The best place to start is almost always to gather together the columns that are not variables. Let's have a look at what we've got: 

* It looks like `country`, `iso2`, and `iso3` are three variables that 
  redundantly specify the country.
  
* `year` is clearly also a variable.

* We don't know what all the other columns are yet, but given the structure 
  in the variable names (e.g. `new_sp_m014`, `new_ep_m014`, `new_ep_f014`) 
  these are likely to be values, not variables.

So we need to gather together all the columns from `new_sp_m014` to `newrel_f65`. We don't know what those values represent yet, so we'll give them the generic name `"key"`. We know the cells represent the count of cases, so we'll use the variable `cases`. There are a lot of missing values in the current representation, so for now we'll use `na.rm` just so we can focus on the values that are present.


```r
who1 <- who %>% 
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE)
who1
#> # A tibble: 76,046 x 6
#>   country     iso2  iso3   year key         cases
#>   <chr>       <chr> <chr> <int> <chr>       <int>
#> 1 Afghanistan AF    AFG    1997 new_sp_m014     0
#> 2 Afghanistan AF    AFG    1998 new_sp_m014    30
#> 3 Afghanistan AF    AFG    1999 new_sp_m014     8
#> 4 Afghanistan AF    AFG    2000 new_sp_m014    52
#> 5 Afghanistan AF    AFG    2001 new_sp_m014   129
#> 6 Afghanistan AF    AFG    2002 new_sp_m014    90
#> # ... with 7.604e+04 more rows
```

We can get some hint of the structure of the values in the new `key` column by counting them:


```r
who1 %>% 
  count(key)
#> # A tibble: 56 x 2
#>   key              n
#>   <chr>        <int>
#> 1 new_ep_f014   1032
#> 2 new_ep_f1524  1021
#> 3 new_ep_f2534  1021
#> 4 new_ep_f3544  1021
#> 5 new_ep_f4554  1017
#> 6 new_ep_f5564  1017
#> # ... with 50 more rows
```
{Run code | terminal}(Rscript code/whoCase.r)              


You might be able to parse this out by yourself with a little thought and some experimentation, but luckily we have the data dictionary handy. It tells us:

1.  The first three letters of each column denote whether the column 
    contains new or old cases of TB. In this dataset, each column contains 
    new cases.

1.  The next two letters describe the type of TB:
    
    *   `rel` stands for cases of relapse
    *   `ep` stands for cases of extrapulmonary TB
    *   `sn` stands for cases of pulmonary TB that could not be diagnosed by 
        a pulmonary smear (smear negative)
    *   `sp` stands for cases of pulmonary TB that could be diagnosed be 
        a pulmonary smear (smear positive)

3.  The sixth letter gives the sex of TB patients. The dataset groups 
    cases by males (`m`) and females (`f`).

4.  The remaining numbers gives the age group. The dataset groups cases into 
    seven age groups:
    
    * `014` = 0 -- 14 years old
    * `1524` = 15 -- 24 years old
    * `2534` = 25 -- 34 years old
    * `3544` = 35 -- 44 years old
    * `4554` = 45 -- 54 years old
    * `5564` = 55 -- 64 years old
    * `65` = 65 or older

We need to make a minor fix to the format of the column names: unfortunately the names are slightly inconsistent because instead of `new_rel` we have `newrel` (it's hard to spot this here but if you don't fix it we'll get errors in subsequent steps). You'll learn about `str_replace()` in [strings], but the basic idea is pretty simple: replace the characters "newrel" with "new_rel". This makes all variable names consistent.


```r
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2
#> # A tibble: 76,046 x 6
#>   country     iso2  iso3   year key         cases
#>   <chr>       <chr> <chr> <int> <chr>       <int>
#> 1 Afghanistan AF    AFG    1997 new_sp_m014     0
#> 2 Afghanistan AF    AFG    1998 new_sp_m014    30
#> 3 Afghanistan AF    AFG    1999 new_sp_m014     8
#> 4 Afghanistan AF    AFG    2000 new_sp_m014    52
#> 5 Afghanistan AF    AFG    2001 new_sp_m014   129
#> 6 Afghanistan AF    AFG    2002 new_sp_m014    90
#> # ... with 7.604e+04 more rows
```

We can separate the values in each code with two passes of `separate()`. The first pass will split the codes at each underscore.


```r
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3
#> # A tibble: 76,046 x 8
#>   country     iso2  iso3   year new   type  sexage cases
#>   <chr>       <chr> <chr> <int> <chr> <chr> <chr>  <int>
#> 1 Afghanistan AF    AFG    1997 new   sp    m014       0
#> 2 Afghanistan AF    AFG    1998 new   sp    m014      30
#> 3 Afghanistan AF    AFG    1999 new   sp    m014       8
#> 4 Afghanistan AF    AFG    2000 new   sp    m014      52
#> 5 Afghanistan AF    AFG    2001 new   sp    m014     129
#> 6 Afghanistan AF    AFG    2002 new   sp    m014      90
#> # ... with 7.604e+04 more rows
```
{Run code | terminal}(Rscript code/whoCase.r)              


Then we might as well drop the `new` column because it's constant in this dataset. While we're dropping columns, let's also drop `iso2` and `iso3` since they're redundant.


```r
who3 %>% 
  count(new)
#> # A tibble: 1 x 2
#>   new       n
#>   <chr> <int>
#> 1 new   76046
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
```

Next we'll separate `sexage` into `sex` and `age` by splitting after the first character:


```r
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5
#> # A tibble: 76,046 x 6
#>   country      year type  sex   age   cases
#>   <chr>       <int> <chr> <chr> <chr> <int>
#> 1 Afghanistan  1997 sp    m     014       0
#> 2 Afghanistan  1998 sp    m     014      30
#> 3 Afghanistan  1999 sp    m     014       8
#> 4 Afghanistan  2000 sp    m     014      52
#> 5 Afghanistan  2001 sp    m     014     129
#> 6 Afghanistan  2002 sp    m     014      90
#> # ... with 7.604e+04 more rows
```
{Run code | terminal}(Rscript code/whoCase.r)              


The `who` dataset is now tidy!

I've shown you the code a piece at a time, assigning each interim result to a new variable. This typically isn't how you'd work interactively. Instead, you'd gradually build up a complex pipe:


```r
who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
```

### Exercises

1.  In this case study I set `na.rm = TRUE` just to make it easier to
    check that we had the correct values. Is this reasonable? Think about
    how missing values are represented in this dataset. Are there implicit
    missing values? What's the difference between an `NA` and zero? 

1.  What happens if you neglect the `mutate()` step?
    (`mutate(key = stringr::str_replace(key, "newrel", "new_rel"))`)

1.  I claimed that `iso2` and `iso3` were redundant with `country`. 
    Confirm this claim.

1.  For each country, year, and sex compute the total number of cases of 
    TB. Make an informative visualisation of the data.
