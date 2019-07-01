
You've seen formulas before when using `facet_wrap()` and `facet_grid()`. In R, formulas provide a general way of getting "special behaviour". Rather than evaluating the values of the variables right away, they capture them so they can be interpreted by the function.

The majority of modelling functions in R use a standard conversion from formulas to functions. You've seen one simple conversion already: `y ~ x` is translated to `y = a_1 + a_2 * x`.  If you want to see what R actually does, you can use the `model_matrix()` function. It takes a data frame and a formula and returns a tibble that defines the model equation: each column in the output is associated with one coefficient in the model, the function is always `y = a_1 * out1 + a_2 * out_2`. For the simplest case of `y ~ x1` this shows us something interesting:


```r
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)
#> # A tibble: 2 x 2
#>   `(Intercept)`    x1
#>           <dbl> <dbl>
#> 1             1     2
#> 2             1     1
```
{Run code | terminal}(Rscript code/formulas.r)              


The way that R adds the intercept to the model is just by having a column that is full of ones.  By default, R will always add this column. If you don't want, you need to explicitly drop it with `-1`:


```r
model_matrix(df, y ~ x1 - 1)
#> # A tibble: 2 x 1
#>      x1
#>   <dbl>
#> 1     2
#> 2     1
```

The model matrix grows in an unsurprising way when you add more variables to the the model:


```r
model_matrix(df, y ~ x1 + x2)
#> # A tibble: 2 x 3
#>   `(Intercept)`    x1    x2
#>           <dbl> <dbl> <dbl>
#> 1             1     2     5
#> 2             1     1     6
```

This formula notation is sometimes called "Wilkinson-Rogers notation", and was initially described in _Symbolic Description of Factorial Models for Analysis of Variance_, by G. N. Wilkinson and C. E. Rogers <https://www.jstor.org/stable/2346786>. It's worth digging up and reading the original paper if you'd like to understand the full details of the modelling algebra.

The following sections expand on how this formula notation works for categorical variables, interactions, and transformation.

### Categorical variables

Generating a function from a formula is straight forward when the predictor is continuous, but things get a bit more complicated when the predictor is categorical. Imagine you have a formula like `y ~ sex`, where sex could either be male or female. It doesn't make sense to convert that to a formula like `y = x_0 + x_1 * sex` because `sex` isn't a number - you can't multiply it! Instead what R does is convert it to `y = x_0 + x_1 * sex_male` where `sex_male` is one if `sex` is male and zero otherwise:


```r
df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)
model_matrix(df, response ~ sex)
#> # A tibble: 3 x 2
#>   `(Intercept)` sexmale
#>           <dbl>   <dbl>
#> 1             1       1
#> 2             1       0
#> 3             1       1
```
{Run code | terminal}(Rscript code/formulas.r)              


You might wonder why R also doesn't create a `sexfemale` column. The problem is that would create a column that is perfectly predictable based on the other columns (i.e. `sexfemale = 1 - sexmale`). Unfortunately the exact details of why this is a problem is beyond the scope of this book, but basically it creates a model family that is too flexible, and will have infinitely many models that are equally close to the data.

Fortunately, however, if you focus on visualising predictions you don't need to worry about the exact parameterisation. Let's look at some data and models to make that concrete. Here's the `sim2` dataset from modelr:


```r
ggplot(sim2) + 
  geom_point(aes(x, y))
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.1](model-basics_files/figure-latex/unnamed-chunk-27-1.jpg)

**Figure 28.1**

We can fit a model to it, and generate predictions:


```r
mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid
#> # A tibble: 4 x 2
#>   x      pred
#>   <chr> <dbl>
#> 1 a      1.15
#> 2 b      8.12
#> 3 c      6.13
#> 4 d      1.91
```

Effectively, a model with a categorical `x` will predict the mean value for each category. (Why? Because the mean minimises the root-mean-squared distance.) That's easy to see if we overlay the predictions on top of the original data:


```r
ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.2](model-basics_files/figure-latex/unnamed-chunk-29-1.jpg)

**Figure 28.2**

You can't make predictions about levels that you didn't observe. Sometimes you'll do this by accident so it's good to recognise this error message:


```r
tibble(x = "e") %>% 
  add_predictions(mod2)
#> Error in model.frame.default(Terms, newdata, na.action = na.action, xlev = object$xlevels): factor x has new level e
```

### Interactions (continuous and categorical)

What happens when you combine a continuous and a categorical variable?  `sim3` contains a categorical predictor and a continuous predictor. We can visualise it with a simple plot:


```r
ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.3](model-basics_files/figure-latex/unnamed-chunk-31-1.jpg)

**Figure 28.3**

There are two possible models you could fit to this data:


```r
mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)
```

When you add variables with `+`, the model will estimate each effect independent of all the others. It's possible to fit the so-called interaction by using `*`. For example, `y ~ x1 * x2` is translated to `y = a_0 + a_1 * x1 + a_2 * x2 + a_12 * x1 * x2`. Note that whenever you use `*`, both the interaction and the individual components are included in the model.

To visualise these models we need two new tricks:

1.  We have two predictors, so we need to give `data_grid()` both variables. 
    It finds all the unique values of `x1` and `x2` and then generates all
    combinations. 
   
1.  To generate predictions from both models simultaneously, we can use 
    `gather_predictions()` which adds each prediction as a row. The
    complement of `gather_predictions()` is `spread_predictions()` which adds 
    each prediction to a new column.
    
Together this gives us:


```r
grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid
#> # A tibble: 80 x 4
#>   model    x1 x2     pred
#>   <chr> <int> <fct> <dbl>
#> 1 mod1      1 a      1.67
#> 2 mod1      1 b      4.56
#> 3 mod1      1 c      6.48
#> 4 mod1      1 d      4.03
#> 5 mod1      2 a      1.48
#> 6 mod1      2 b      4.37
#> # ... with 74 more rows
```

We can visualise the results for both models on one plot using facetting:


```r
ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.4](model-basics_files/figure-latex/unnamed-chunk-34-1.jpg)

**Figure 28.4**

Note that the model that uses `+` has the same slope for each line, but different intercepts. The model that uses `*` has a different slope and intercept for each line.

Which model is better for this data? We can take look at the residuals. Here I've facetted by both model and `x2` because it makes it easier to see the pattern within each group.


```r
sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.5](model-basics_files/figure-latex/unnamed-chunk-35-1.jpg)

**Figure 28.5**

There is little obvious pattern in the residuals for `mod2`. The residuals for `mod1` show that the model has clearly missed some pattern in `b`, and less so, but still present is pattern in `c`, and `d`. You might wonder if there's a precise way to tell which of `mod1` or `mod2` is better. There is, but it requires a lot of mathematical background, and we don't really care. Here, we're interested in a qualitative assessment of whether or not the model has captured the pattern that we're interested in. 

### Interactions (two continuous)

Let's take a look at the equivalent model for two continuous variables. Initially things proceed almost identically to the previous example:


```r
mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), 
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)
grid
#> # A tibble: 50 x 4
#>   model    x1    x2   pred
#>   <chr> <dbl> <dbl>  <dbl>
#> 1 mod1   -1    -1    0.996
#> 2 mod1   -1    -0.5 -0.395
#> 3 mod1   -1     0   -1.79 
#> 4 mod1   -1     0.5 -3.18 
#> 5 mod1   -1     1   -4.57 
#> 6 mod1   -0.5  -1    1.91 
#> # ... with 44 more rows
```
{Run code | terminal}(Rscript code/formulas.r)              


Note my use of `seq_range()` inside `data_grid()`. Instead of using every unique value of `x`, I'm going to use a regularly spaced grid of five values between the minimum and maximum numbers. It's probably not super important here, but it's a useful technique in general. There are two other useful arguments to `seq_range()`:

*  `pretty = TRUE` will generate a "pretty" sequence, i.e. something that looks
    nice to the human eye. This is useful if you want to produce tables of 
    output:
    
    
```r
    seq_range(c(0.0123, 0.923423), n = 5)
    #> [1] 0.0123 0.2401 0.4679 0.6956 0.9234
    seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)
    #> [1] 0.0 0.2 0.4 0.6 0.8 1.0
```
    
*   `trim = 0.1` will trim off 10% of the tail values. This is useful if the 
    variables have a long tailed distribution and you want to focus on generating
    values near the center:
    
    
```r
    x1 <- rcauchy(100)
    seq_range(x1, n = 5)
    #> [1] -115.9  -83.5  -51.2  -18.8   13.5
    seq_range(x1, n = 5, trim = 0.10)
    #> [1] -13.84  -8.71  -3.58   1.55   6.68
    seq_range(x1, n = 5, trim = 0.25)
    #> [1] -2.1735 -1.0594  0.0547  1.1687  2.2828
    seq_range(x1, n = 5, trim = 0.50)
    #> [1] -0.725 -0.268  0.189  0.647  1.104
```
    
*   `expand = 0.1` is in some sense the opposite of `trim()` it expands the 
    range by 10%.
    
    
```r
    x2 <- c(0, 1)
    seq_range(x2, n = 5)
    #> [1] 0.00 0.25 0.50 0.75 1.00
    seq_range(x2, n = 5, expand = 0.10)
    #> [1] -0.050  0.225  0.500  0.775  1.050
    seq_range(x2, n = 5, expand = 0.25)
    #> [1] -0.125  0.188  0.500  0.812  1.125
    seq_range(x2, n = 5, expand = 0.50)
    #> [1] -0.250  0.125  0.500  0.875  1.250
```

Next let's try and visualise that model. We have two continuous predictors, so you can imagine the model like a 3d surface. We could display that using `geom_tile()`:


```r
ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.6](model-basics_files/figure-latex/unnamed-chunk-40-1.jpg)

**Figure 28.6**

That doesn't suggest that the models are very different! But that's partly an illusion: our eyes and brains are not very good at accurately comparing shades of colour. Instead of looking at the surface from the top, we could look at it from either side, showing multiple slices:


```r
ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)
ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.7](model-basics_files/figure-latex/unnamed-chunk-41-1.jpg)
![Figure 28.7](model-basics_files/figure-latex/unnamed-chunk-41-2.jpg)

**Figure 28.7**

This shows you that interaction between two continuous variables works basically the same way as for a categorical and continuous variable. An interaction says that there's not a fixed offset: you need to consider both values of `x1` and `x2` simultaneously in order to predict `y`.

You can see that even with just two continuous variables, coming up with good visualisations are hard. But that's reasonable: you shouldn't expect it will be easy to understand how three or more variables simultaneously interact! But again, we're saved a little because we're using models for exploration, and you can gradually build up your model over time. The model doesn't have to be perfect, it just has to help you reveal a little more about your data.

I spent some time looking at the residuals to see if I could figure if `mod2` did better than `mod1`. I think it does, but it's pretty subtle. You'll have a chance to work on it in the exercises.

### Transformations

You can also perform transformations inside the model formula. For example, `log(y) ~ sqrt(x1) + x2` is transformed to `log(y) = a_1 + a_2 * sqrt(x1) + a_3 * x2`. If your transformation involves `+`, `*`, `^`, or `-`, you'll need to wrap it in `I()` so R doesn't treat it like part of the model specification. For example, `y ~ x + I(x ^ 2)` is translated to `y = a_1 + a_2 * x + a_3 * x^2`. If you forget the `I()` and specify `y ~ x ^ 2 + x`, R will compute `y ~ x * x + x`. `x * x` means the interaction of `x` with itself, which is the same as `x`. R automatically drops redundant variables so `x + x` become `x`, meaning that `y ~ x ^ 2 + x` specifies the function `y = a_1 + a_2 * x`. That's probably not what you intended!

Again, if you get confused about what your model is doing, you can always use `model_matrix()` to see exactly what equation `lm()` is fitting:


```r
df <- tribble(
  ~y, ~x,
   1,  1,
   2,  2, 
   3,  3
)
model_matrix(df, y ~ x^2 + x)
#> # A tibble: 3 x 2
#>   `(Intercept)`     x
#>           <dbl> <dbl>
#> 1             1     1
#> 2             1     2
#> 3             1     3
model_matrix(df, y ~ I(x^2) + x)
#> # A tibble: 3 x 3
#>   `(Intercept)` `I(x^2)`     x
#>           <dbl>    <dbl> <dbl>
#> 1             1        1     1
#> 2             1        4     2
#> 3             1        9     3
```
{Run code | terminal}(Rscript code/formulas.r)              


Transformations are useful because you can use them to approximate non-linear functions. If you've taken a calculus class, you may have heard of Taylor's theorem which says you can approximate any smooth function with an infinite sum of polynomials. That means you can use a polynomial function to get arbitrarily close to a smooth function by fitting an equation like `y = a_1 + a_2 * x + a_3 * x^2 + a_4 * x ^ 3`. Typing that sequence by hand is tedious, so R provides a helper function: `poly()`:


```r
model_matrix(df, y ~ poly(x, 2))
#> # A tibble: 3 x 3
#>   `(Intercept)` `poly(x, 2)1` `poly(x, 2)2`
#>           <dbl>         <dbl>         <dbl>
#> 1             1     -7.07e- 1         0.408
#> 2             1     -7.85e-17        -0.816
#> 3             1      7.07e- 1         0.408
```

However there's one major problem with using `poly()`: outside the range of the data, polynomials rapidly shoot off to positive or negative infinity. One safer alternative is to use the natural spline, `splines::ns()`.


```r
library(splines)
model_matrix(df, y ~ ns(x, 2))
#> # A tibble: 3 x 3
#>   `(Intercept)` `ns(x, 2)1` `ns(x, 2)2`
#>           <dbl>       <dbl>       <dbl>
#> 1             1       0           0    
#> 2             1       0.566      -0.211
#> 3             1       0.344       0.771
```

Let's see what that looks like when we try and approximate a non-linear function:


```r
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.8](model-basics_files/figure-latex/unnamed-chunk-45-1.jpg)

**Figure 28.8**

I'm going to fit five models to this data.


```r
mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~ model)
```
{Run code | terminal}(Rscript code/formulas.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.9](model-basics_files/figure-latex/unnamed-chunk-46-1.jpg)

**Figure 28.9**

Notice that the extrapolation outside the range of the data is clearly bad. This is the downside to approximating a function with a polynomial. But this is a very real problem with every model: the model can never tell you if the behaviour is true when you start extrapolating outside the range of the data that you have seen. You must rely on theory and science.

### Exercises

1.  What happens if you repeat the analysis of `sim2` using a model without
    an intercept. What happens to the model equation? What happens to the
    predictions?
    
1.  Use `model_matrix()` to explore the equations generated for the models
    I fit to `sim3` and `sim4`. Why is `*` a good shorthand for interaction?

1.  Using the basic principles, convert the formulas in the following two
    models into functions. (Hint: start by converting the categorical variable
    into 0-1 variables.)
    
    
```r
    mod1 <- lm(y ~ x1 + x2, data = sim3)
    mod2 <- lm(y ~ x1 * x2, data = sim3)
```

1.   For `sim4`,  which of `mod1` and `mod2` is better? I think `mod2` does a 
     slightly better job at removing patterns, but it's pretty subtle. Can you 
     come up with a plot to support my claim? 
