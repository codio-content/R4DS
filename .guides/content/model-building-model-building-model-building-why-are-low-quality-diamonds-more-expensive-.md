
In previous chapters we've seen a surprising relationship between the quality of diamonds and their price: low quality diamonds (poor cuts, bad colours, and inferior clarity) have higher prices.


```r
ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()
```



![Figure 29.1](model-building_files/figure-latex/unnamed-chunk-2-1.png)
![Figure 29.1](model-building_files/figure-latex/unnamed-chunk-2-2.png)
![Figure 29.1](model-building_files/figure-latex/unnamed-chunk-2-3.png)

**Figure 29.1**

Note that the worst diamond color is J (slightly yellow), and the worst clarity is I1 (inclusions visible to the naked eye).

### Price and carat

It looks like lower quality diamonds have higher prices because there is an important confounding variable: the weight (`carat`) of the diamond. The weight of the diamond is the single most important factor for determining the price of the diamond, and lower quality diamonds tend to be larger.


```r
ggplot(diamonds, aes(carat, price)) + 
  geom_hex(bins = 50)
```



![Figure 29.2](model-building_files/figure-latex/unnamed-chunk-3-1.jpg)

**Figure 29.2**

We can make it easier to see how the other attributes of a diamond affect its relative `price` by fitting a model to separate out the effect of `carat`. But first, lets make a couple of tweaks to the diamonds dataset to make it easier to work with:

1. Focus on diamonds smaller than 2.5 carats (99.7% of the data)
1. Log-transform the carat and price variables.


```r
diamonds2 <- diamonds %>% 
  filter(carat <= 2.5) %>% 
  mutate(lprice = log2(price), lcarat = log2(carat))
```

Together, these changes make it easier to see the relationship between `carat` and `price`:


```r
ggplot(diamonds2, aes(lcarat, lprice)) + 
  geom_hex(bins = 50)
```



![Figure 29.3](model-building_files/figure-latex/unnamed-chunk-5-1.jpg)

**Figure 29.3**

The log-transformation is particularly useful here because it makes the pattern linear, and linear patterns are the easiest to work with. Let's take the next step and remove that strong linear pattern. We first make the pattern explicit by fitting a model:


```r
mod_diamond <- lm(lprice ~ lcarat, data = diamonds2)
```

Then we look at what the model tells us about the data. Note that I back transform the predictions, undoing the log transformation, so I can overlay the predictions on the raw data:


```r
grid <- diamonds2 %>% 
  data_grid(carat = seq_range(carat, 20)) %>% 
  mutate(lcarat = log2(carat)) %>% 
  add_predictions(mod_diamond, "lprice") %>% 
  mutate(price = 2 ^ lprice)

ggplot(diamonds2, aes(carat, price)) + 
  geom_hex(bins = 50) + 
  geom_line(data = grid, colour = "red", size = 1)
```



![Figure 29.4](model-building_files/figure-latex/unnamed-chunk-7-1.jpg)

**Figure 29.4**

That tells us something interesting about our data. If we believe our model, then the large diamonds are much cheaper than expected. This is probably because no diamond in this dataset costs more than $19,000.

Now we can look at the residuals, which verifies that we've successfully removed the strong linear pattern:


```r
diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond, "lresid")

ggplot(diamonds2, aes(lcarat, lresid)) + 
  geom_hex(bins = 50)
```



![Figure 29.5](model-building_files/figure-latex/unnamed-chunk-8-1.jpg)

**Figure 29.5**

Importantly, we can now re-do our motivating plots using those residuals instead of `price`. 


```r
ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()
```



![Figure 29.6](model-building_files/figure-latex/unnamed-chunk-9-1.png)
![Figure 29.6](model-building_files/figure-latex/unnamed-chunk-9-2.png)
![Figure 29.6](model-building_files/figure-latex/unnamed-chunk-9-3.png)

**Figure 29.6**

Now we see the relationship we expect: as the quality of the diamond increases, so too does its relative price. To interpret the `y` axis, we need to think about what the residuals are telling us, and what scale they are on. A residual of -1 indicates that `lprice` was 1 unit lower than a prediction based solely on its weight. $2^{-1}$ is 1/2, points with a value of -1 are half the expected price, and residuals with value 1 are twice the predicted price.

### A more complicated model

If we wanted to, we could continue to build up our model, moving the effects we've observed into the model to make them explicit. For example, we could include `color`, `cut`, and `clarity` into the model so that we also make explicit the effect of these three categorical variables:


```r
mod_diamond2 <- lm(lprice ~ lcarat + color + cut + clarity, data = diamonds2)
```

This model now includes four predictors, so it's getting harder to visualise. Fortunately, they're currently all independent which means that we can plot them individually in four plots. To make the process a little easier, we're going to use the `.model` argument to `data_grid`:


```r
grid <- diamonds2 %>% 
  data_grid(cut, .model = mod_diamond2) %>% 
  add_predictions(mod_diamond2)
grid
#> # A tibble: 5 x 5
#>   cut       lcarat color clarity  pred
#>   <ord>      <dbl> <chr> <chr>   <dbl>
#> 1 Fair      -0.515 G     VS2      11.2
#> 2 Good      -0.515 G     VS2      11.3
#> 3 Very Good -0.515 G     VS2      11.4
#> 4 Premium   -0.515 G     VS2      11.4
#> 5 Ideal     -0.515 G     VS2      11.4

ggplot(grid, aes(cut, pred)) + 
  geom_point()
```



![Figure 29.7](model-building_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 29.7**

If the model needs variables that you haven't explicitly supplied, `data_grid()` will automatically fill them in with "typical" value. For continuous variables, it uses the median, and categorical variables it uses the most common value (or values, if there's a tie).


```r
diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond2, "lresid2")

ggplot(diamonds2, aes(lcarat, lresid2)) + 
  geom_hex(bins = 50)
```



![Figure 29.8](model-building_files/figure-latex/unnamed-chunk-12-1.jpg)

**Figure 29.8**

This plot indicates that there are some diamonds with quite large residuals - remember a residual of 2 indicates that the diamond is 4x the price that we expected. It's often useful to look at unusual values individually:


```r
diamonds2 %>% 
  filter(abs(lresid2) > 1) %>% 
  add_predictions(mod_diamond2) %>% 
  mutate(pred = round(2 ^ pred)) %>% 
  select(price, pred, carat:table, x:z) %>% 
  arrange(price)
#> # A tibble: 16 x 11
#>   price  pred carat cut     color clarity depth table     x     y     z
#>   <int> <dbl> <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  1013   264  0.25 Fair    F     SI2      54.4    64  4.3   4.23  2.32
#> 2  1186   284  0.25 Premium G     SI2      59      60  5.33  5.28  3.12
#> 3  1186   284  0.25 Premium G     SI2      58.8    60  5.33  5.28  3.12
#> 4  1262  2644  1.03 Fair    E     I1       78.2    54  5.72  5.59  4.42
#> 5  1415   639  0.35 Fair    G     VS2      65.9    54  5.57  5.53  3.66
#> 6  1415   639  0.35 Fair    G     VS2      65.9    54  5.57  5.53  3.66
#> # ... with 10 more rows
```

Nothing really jumps out at me here, but it's probably worth spending time considering if this indicates a problem with our model, or if there are errors in the data. If there are mistakes in the data, this could be an opportunity to buy diamonds that have been priced low incorrectly.

### Exercises

1.  In the plot of `lcarat` vs. `lprice`, there are some bright vertical
    strips. What do they represent?

1.  If `log(price) = a_0 + a_1 * log(carat)`, what does that say about 
    the relationship between `price` and `carat`?
    
1.  Extract the diamonds that have very high and very low residuals. 
    Is there anything unusual about these diamonds? Are they particularly bad
    or good, or do you think these are pricing errors?

1.  Does the final model, `mod_diamond2`, do a good job of predicting
    diamond prices? Would you trust it to tell you how much to spend
    if you were buying a diamond?
