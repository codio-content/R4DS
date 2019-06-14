
For simple models, like the one above, you can figure out what pattern the model captures by carefully studying the model family and the fitted coefficients. And if you ever take a statistics course on modelling, you're likely to spend a lot of time doing just that. Here, however, we're going to take a different tack. We're going to focus on understanding a model by looking at its predictions. This has a big advantage: every type of predictive model makes predictions (otherwise what use would it be?) so we can use the same set of techniques to understand any type of predictive model.

It's also useful to see what the model doesn't capture, the so-called residuals which are left after subtracting the predictions from the data. Residuals are powerful because they allow us to use models to remove striking patterns so we can study the subtler trends that remain.

### Predictions

To visualise the predictions from a model, we start by generating an evenly spaced grid of values that covers the region where our data lies. The easiest way to do that is to use `modelr::data_grid()`. Its first argument is a data frame, and for each subsequent argument it finds the unique variables and then generates all combinations:


```r
grid <- sim1 %>% 
  data_grid(x) 
grid
#> # A tibble: 10 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 3     3
#> 4     4
#> 5     5
#> 6     6
#> # ... with 4 more rows
```

(This will get more interesting when we start to add more variables to our model.)

Next we add predictions. We'll use `modelr::add_predictions()` which takes a data frame and a model. It adds the predictions from the model to a new column in the data frame:


```r
grid <- grid %>% 
  add_predictions(sim1_mod) 
grid
#> # A tibble: 10 x 2
#>       x  pred
#>   <int> <dbl>
#> 1     1  6.27
#> 2     2  8.32
#> 3     3 10.4 
#> 4     4 12.4 
#> 5     5 14.5 
#> 6     6 16.5 
#> # ... with 4 more rows
```

(You can also use this function to add predictions to your original dataset.)

Next, we plot the predictions. You might wonder about all this extra work compared to just using `geom_abline()`. But the advantage of this approach is that it will work with _any_ model in R, from the simplest to the most complex. You're only limited by your visualisation skills. For more ideas about how to visualise more complex model types, you might try <http://vita.had.co.nz/papers/model-vis.html>.


```r
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)
```



![Figure 28.1](model-basics_files/figure-latex/unnamed-chunk-19-1.jpg)

**Figure 28.1**

### Residuals

The flip-side of predictions are __residuals__. The predictions tells you the pattern that the model has captured, and the residuals tell you what the model has missed. The residuals are just the distances between the observed and predicted values that we computed above. 

We add residuals to the data with `add_residuals()`, which works much like `add_predictions()`. Note, however, that we use the original dataset, not a manufactured grid. This is because to compute residuals we need actual y values.


```r
sim1 <- sim1 %>% 
  add_residuals(sim1_mod)
sim1
#> # A tibble: 30 x 3
#>       x     y  resid
#>   <int> <dbl>  <dbl>
#> 1     1  4.20 -2.07 
#> 2     1  7.51  1.24 
#> 3     1  2.13 -4.15 
#> 4     2  8.99  0.665
#> 5     2 10.2   1.92 
#> 6     2 11.3   2.97 
#> # ... with 24 more rows
```

There are a few different ways to understand what the residuals tell us about the model. One way is to simply draw a frequency polygon to help us understand the spread of the residuals:


```r
ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)
```



![Figure 28.2](model-basics_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 28.2**

This helps you calibrate the quality of the model: how far away are the predictions from the observed values?  Note that the average of the residual will always be 0.

You'll often want to recreate plots using the residuals instead of the original predictor. You'll see a lot of that in the next chapter.


```r
ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 
```



![Figure 28.3](model-basics_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 28.3**

This looks like random noise, suggesting that our model has done a good job of capturing the patterns in the dataset.

### Exercises

1.  Instead of using `lm()` to fit a straight line, you can use `loess()`
    to fit a smooth curve. Repeat the process of model fitting, 
    grid generation, predictions, and visualisation on `sim1` using 
    `loess()` instead of `lm()`. How does the result compare to 
    `geom_smooth()`?
    
1.  `add_predictions()` is paired with `gather_predictions()` and 
    `spread_predictions()`. How do these three functions differ?
    
1.  What does `geom_ref_line()` do? What package does it come from?
    Why is displaying a reference line in plots showing residuals
    useful and important?
    
1.  Why might you want to look at a frequency polygon of absolute residuals?
    What are the pros and cons compared to looking at the raw residuals?
