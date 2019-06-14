
To motivate the power of many simple models, we're going to look into the "gapminder" data. This data was popularised by Hans Rosling, a Swedish doctor and statistician. If you've never heard of him, stop reading this chapter right now and go watch one of his videos! He is a fantastic data presenter and illustrates how you can use data to present a compelling story. A good place to start is this short video filmed in conjunction with the BBC: <https://www.youtube.com/watch?v=jbkSRLYSojo>.

The gapminder data summarises the progression of countries over time, looking at statistics like life expectancy and GDP. The data is easy to access in R, thanks to Jenny Bryan who created the gapminder package:


```r
library(gapminder)
gapminder
#> # A tibble: 1,704 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779.
#> 2 Afghanistan Asia       1957    30.3  9240934      821.
#> 3 Afghanistan Asia       1962    32.0 10267083      853.
#> 4 Afghanistan Asia       1967    34.0 11537966      836.
#> 5 Afghanistan Asia       1972    36.1 13079460      740.
#> 6 Afghanistan Asia       1977    38.4 14880372      786.
#> # ... with 1,698 more rows
```

In this case study, we're going to focus on just three variables to answer the question "How does life expectancy (`lifeExp`) change over time (`year`) for each country (`country`)?". A good place to start is with a plot:


```r
gapminder %>% 
  ggplot(aes(year, lifeExp, group = country)) +
    geom_line(alpha = 1/3)
```



![Figure 30.1](model-many_files/figure-latex/unnamed-chunk-3-1.jpg)

**Figure 30.1**

This is a small dataset: it only has ~1,700 observations and 3 variables. But it's still hard to see what's going on! Overall, it looks like life expectancy has been steadily improving. However, if you look closely, you might notice some countries that don't follow this pattern. How can we make those countries easier to see?

One way is to use the same approach as in the last chapter: there's a strong signal (overall linear growth) that makes it hard to see subtler trends. We'll tease these factors apart by fitting a model with a linear trend. The model captures steady growth over time, and the residuals will show what's left.

You already know how to do that if we had a single country:


```r
nz <- filter(gapminder, country == "New Zealand")
nz %>% 
  ggplot(aes(year, lifeExp)) + 
  geom_line() + 
  ggtitle("Full data = ")

nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>% 
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) + 
  geom_line() + 
  ggtitle("Linear trend + ")

nz %>% 
  add_residuals(nz_mod) %>% 
  ggplot(aes(year, resid)) + 
  geom_hline(yintercept = 0, colour = "white", size = 3) + 
  geom_line() + 
  ggtitle("Remaining pattern")
```




**Figure 30.6** 

**Figure 30.7** 

**Figure 30.8** 

How can we easily fit that model to every country?

### Nested data

You could imagine copy and pasting that code multiple times; but you've already learned a better way! Extract out the common code with a function and repeat using a map function from purrr. This problem is structured a little differently to what you've seen before. Instead of repeating an action for each variable, we want to repeat an action for each country, a subset of rows. To do that, we need a new data structure: the __nested data frame__. To create a nested data frame we start with a grouped data frame, and "nest" it:


```r
by_country <- gapminder %>% 
  group_by(country, continent) %>% 
  nest()

by_country
#> # A tibble: 142 x 3
#>   country     continent data             
#>   <fct>       <fct>     <list>           
#> 1 Afghanistan Asia      <tibble [12 x 4]>
#> 2 Albania     Europe    <tibble [12 x 4]>
#> 3 Algeria     Africa    <tibble [12 x 4]>
#> 4 Angola      Africa    <tibble [12 x 4]>
#> 5 Argentina   Americas  <tibble [12 x 4]>
#> 6 Australia   Oceania   <tibble [12 x 4]>
#> # ... with 136 more rows
```

(I'm cheating a little by grouping on both `continent` and `country`. Given `country`, `continent` is fixed, so this doesn't add any more groups, but it's an easy way to carry an extra variable along for the ride.)

This creates a data frame that has one row per group (per country), and a rather unusual column: `data`. `data` is a list of data frames (or tibbles, to be precise).  This seems like a crazy idea: we have a data frame with a column that is a list of other data frames! I'll explain shortly why I think this is a good idea.

The `data` column is a little tricky to look at because it's a moderately complicated list, and we're still working on good tools to explore these objects. Unfortunately using `str()` is not recommended as it will often produce very long output. But if you pluck out a single element from the `data` column you'll see that it contains all the data for that country (in this case, Afghanistan).


```r
by_country$data[[1]]
#> # A tibble: 12 x 4
#>    year lifeExp      pop gdpPercap
#>   <int>   <dbl>    <int>     <dbl>
#> 1  1952    28.8  8425333      779.
#> 2  1957    30.3  9240934      821.
#> 3  1962    32.0 10267083      853.
#> 4  1967    34.0 11537966      836.
#> 5  1972    36.1 13079460      740.
#> 6  1977    38.4 14880372      786.
#> # ... with 6 more rows
```

Note the difference between a standard grouped data frame and a nested data frame: in a grouped data frame, each row is an observation; in a nested data frame, each row is a group. Another way to think about a nested dataset is we now have a meta-observation: a row that represents the complete time course for a country, rather than a single point in time.

### List-columns

Now that we have our nested data frame, we're in a good position to fit some models. We have a model-fitting function:


```r
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}
```

And we want to apply it to every data frame. The data frames are in a list, so we can use `purrr::map()` to apply `country_model` to each element:


```r
models <- map(by_country$data, country_model)
```

However, rather than leaving the list of models as a free-floating object, I think it's better to store it as a column in the `by_country` data frame. Storing related objects in columns is a key part of the value of data frames, and why I think list-columns are such a good idea. In the course of working with these countries, we are going to have lots of lists where we have one element per country. So why not store them all together in one data frame?

In other words, instead of creating a new object in the global environment, we're going to create a new variable in the `by_country` data frame. That's a job for `dplyr::mutate()`:


```r
by_country <- by_country %>% 
  mutate(model = map(data, country_model))
by_country
#> # A tibble: 142 x 4
#>   country     continent data              model   
#>   <fct>       <fct>     <list>            <list>  
#> 1 Afghanistan Asia      <tibble [12 x 4]> <S3: lm>
#> 2 Albania     Europe    <tibble [12 x 4]> <S3: lm>
#> 3 Algeria     Africa    <tibble [12 x 4]> <S3: lm>
#> 4 Angola      Africa    <tibble [12 x 4]> <S3: lm>
#> 5 Argentina   Americas  <tibble [12 x 4]> <S3: lm>
#> 6 Australia   Oceania   <tibble [12 x 4]> <S3: lm>
#> # ... with 136 more rows
```

This has a big advantage: because all the related objects are stored together, you don't need to manually keep them in sync when you filter or arrange. The semantics of the data frame takes care of that for you:


```r
by_country %>% 
  filter(continent == "Europe")
#> # A tibble: 30 x 4
#>   country                continent data              model   
#>   <fct>                  <fct>     <list>            <list>  
#> 1 Albania                Europe    <tibble [12 x 4]> <S3: lm>
#> 2 Austria                Europe    <tibble [12 x 4]> <S3: lm>
#> 3 Belgium                Europe    <tibble [12 x 4]> <S3: lm>
#> 4 Bosnia and Herzegovina Europe    <tibble [12 x 4]> <S3: lm>
#> 5 Bulgaria               Europe    <tibble [12 x 4]> <S3: lm>
#> 6 Croatia                Europe    <tibble [12 x 4]> <S3: lm>
#> # ... with 24 more rows
by_country %>% 
  arrange(continent, country)
#> # A tibble: 142 x 4
#>   country      continent data              model   
#>   <fct>        <fct>     <list>            <list>  
#> 1 Algeria      Africa    <tibble [12 x 4]> <S3: lm>
#> 2 Angola       Africa    <tibble [12 x 4]> <S3: lm>
#> 3 Benin        Africa    <tibble [12 x 4]> <S3: lm>
#> 4 Botswana     Africa    <tibble [12 x 4]> <S3: lm>
#> 5 Burkina Faso Africa    <tibble [12 x 4]> <S3: lm>
#> 6 Burundi      Africa    <tibble [12 x 4]> <S3: lm>
#> # ... with 136 more rows
```

If your list of data frames and list of models were separate objects, you have to remember that whenever you re-order or subset one vector, you need to re-order or subset all the others in order to keep them in sync. If you forget, your code will continue to work, but it will give the wrong answer!

### Unnesting

Previously we computed the residuals of a single model with a single dataset. Now we have 142 data frames and 142 models. To compute the residuals, we need to call `add_residuals()` with each model-data pair:


```r
by_country <- by_country %>% 
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country
#> # A tibble: 142 x 5
#>   country     continent data              model    resids           
#>   <fct>       <fct>     <list>            <list>   <list>           
#> 1 Afghanistan Asia      <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> 2 Albania     Europe    <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> 3 Algeria     Africa    <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> 4 Angola      Africa    <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> 5 Argentina   Americas  <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> 6 Australia   Oceania   <tibble [12 x 4]> <S3: lm> <tibble [12 x 5]>
#> # ... with 136 more rows
```

But how you can plot a list of data frames? Instead of struggling to answer that question, let's turn the list of data frames back into a regular data frame. Previously we used `nest()` to turn a regular data frame into an nested data frame, and now we do the opposite with `unnest()`:


```r
resids <- unnest(by_country, resids)
resids
#> # A tibble: 1,704 x 7
#>   country     continent  year lifeExp      pop gdpPercap   resid
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>   <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779. -1.11  
#> 2 Afghanistan Asia       1957    30.3  9240934      821. -0.952 
#> 3 Afghanistan Asia       1962    32.0 10267083      853. -0.664 
#> 4 Afghanistan Asia       1967    34.0 11537966      836. -0.0172
#> 5 Afghanistan Asia       1972    36.1 13079460      740.  0.674 
#> 6 Afghanistan Asia       1977    38.4 14880372      786.  1.65  
#> # ... with 1,698 more rows
```

Note that each regular column is repeated one for each row in the nested column.

Now we have regular data frame, we can plot the residuals:


```r
resids %>% 
  ggplot(aes(year, resid)) +
    geom_line(aes(group = country), alpha = 1 / 3) + 
    geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```



![Figure 30.2](model-many_files/figure-latex/unnamed-chunk-13-1.jpg)

**Figure 30.2**

Facetting by continent is particularly revealing:
 

```r
resids %>% 
  ggplot(aes(year, resid, group = country)) +
    geom_line(alpha = 1 / 3) + 
    facet_wrap(~continent)
```



![Figure 30.3](model-many_files/figure-latex/unnamed-chunk-14-1.jpg)

**Figure 30.3**

It looks like we've missed some mild patterns. There's also something interesting going on in Africa: we see some very large residuals which suggests our model isn't fitting so well there. We'll explore that more in the next section, attacking it from a slightly different angle.

### Model quality

Instead of looking at the residuals from the model, we could look at some general measurements of model quality. You learned how to compute some specific measures in the previous chapter. Here we'll show a different approach using the broom package. The broom package provides a general set of functions to turn models into tidy data. Here we'll use `broom::glance()` to extract some model quality metrics. If we apply it to a model, we get a data frame with a single row:


```r
broom::glance(nz_mod)
#> # A tibble: 1 x 11
#>   r.squared adj.r.squared sigma statistic p.value    df logLik   AIC   BIC
#>       <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>  <dbl> <dbl> <dbl>
#> 1     0.954         0.949 0.804      205. 5.41e-8     2  -13.3  32.6  34.1
#> # ... with 2 more variables: deviance <dbl>, df.residual <int>
```

We can use `mutate()` and `unnest()` to create a data frame with a row for each country:


```r
by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance)
#> # A tibble: 142 x 16
#>   country continent data  model resids r.squared adj.r.squared sigma
#>   <fct>   <fct>     <lis> <lis> <list>     <dbl>         <dbl> <dbl>
#> 1 Afghan~ Asia      <tib~ <S3:~ <tibb~     0.948         0.942 1.22 
#> 2 Albania Europe    <tib~ <S3:~ <tibb~     0.911         0.902 1.98 
#> 3 Algeria Africa    <tib~ <S3:~ <tibb~     0.985         0.984 1.32 
#> 4 Angola  Africa    <tib~ <S3:~ <tibb~     0.888         0.877 1.41 
#> 5 Argent~ Americas  <tib~ <S3:~ <tibb~     0.996         0.995 0.292
#> 6 Austra~ Oceania   <tib~ <S3:~ <tibb~     0.980         0.978 0.621
#> # ... with 136 more rows, and 8 more variables: statistic <dbl>,
#> #   p.value <dbl>, df <int>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>
```

This isn't quite the output we want, because it still includes all the list columns. This is default behaviour when `unnest()` works on single row data frames. To suppress these columns we use `.drop = TRUE`:


```r
glance <- by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE)
glance
#> # A tibble: 142 x 13
#>   country continent r.squared adj.r.squared sigma statistic  p.value    df
#>   <fct>   <fct>         <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>
#> 1 Afghan~ Asia          0.948         0.942 1.22      181.  9.84e- 8     2
#> 2 Albania Europe        0.911         0.902 1.98      102.  1.46e- 6     2
#> 3 Algeria Africa        0.985         0.984 1.32      662.  1.81e-10     2
#> 4 Angola  Africa        0.888         0.877 1.41       79.1 4.59e- 6     2
#> 5 Argent~ Americas      0.996         0.995 0.292    2246.  4.22e-13     2
#> 6 Austra~ Oceania       0.980         0.978 0.621     481.  8.67e-10     2
#> # ... with 136 more rows, and 5 more variables: logLik <dbl>, AIC <dbl>,
#> #   BIC <dbl>, deviance <dbl>, df.residual <int>
```

(Pay attention to the variables that aren't printed: there's a lot of useful stuff there.)

With this data frame in hand, we can start to look for models that don't fit well:


```r
glance %>% 
  arrange(r.squared)
#> # A tibble: 142 x 13
#>   country continent r.squared adj.r.squared sigma statistic p.value    df
#>   <fct>   <fct>         <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>
#> 1 Rwanda  Africa       0.0172      -0.0811   6.56     0.175   0.685     2
#> 2 Botswa~ Africa       0.0340      -0.0626   6.11     0.352   0.566     2
#> 3 Zimbab~ Africa       0.0562      -0.0381   7.21     0.596   0.458     2
#> 4 Zambia  Africa       0.0598      -0.0342   4.53     0.636   0.444     2
#> 5 Swazil~ Africa       0.0682      -0.0250   6.64     0.732   0.412     2
#> 6 Lesotho Africa       0.0849      -0.00666  5.93     0.927   0.358     2
#> # ... with 136 more rows, and 5 more variables: logLik <dbl>, AIC <dbl>,
#> #   BIC <dbl>, deviance <dbl>, df.residual <int>
```

The worst models all appear to be in Africa. Let's double check that with a plot. Here we have a relatively small number of observations and a discrete variable, so `geom_jitter()` is effective:


```r
glance %>% 
  ggplot(aes(continent, r.squared)) + 
    geom_jitter(width = 0.5)
```



![Figure 30.4](model-many_files/figure-latex/unnamed-chunk-19-1.jpg)

**Figure 30.4**

We could pull out the countries with particularly bad $R^2$ and plot the data:


```r
bad_fit <- filter(glance, r.squared < 0.25)

gapminder %>% 
  semi_join(bad_fit, by = "country") %>% 
  ggplot(aes(year, lifeExp, colour = country)) +
    geom_line()
```



![Figure 30.5](model-many_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 30.5**

We see two main effects here: the tragedies of the HIV/AIDS epidemic and the Rwandan genocide.

### Exercises

1.  A linear trend seems to be slightly too simple for the overall trend.
    Can you do better with a quadratic polynomial? How can you interpret
    the coefficients of the quadratic? (Hint you might want to transform
    `year` so that it has mean zero.)

1.  Explore other methods for visualising the distribution of $R^2$ per
    continent. You might want to try the ggbeeswarm package, which provides 
    similar methods for avoiding overlaps as jitter, but uses deterministic
    methods.

1.  To create the last plot (showing the data for the countries with the
    worst model fits), we needed two steps: we created a data frame with
    one row per country and then semi-joined it to the original dataset.
    It's possible to avoid this join if we use `unnest()` instead of 
    `unnest(.drop = TRUE)`. How?
