
Lets take a look at the simulated dataset `sim1`, included with the modelr package. It contains two continuous variables, `x` and `y`. Let's plot them to see how they're related:


```r
ggplot(sim1, aes(x, y)) + 
  geom_point()
```

{Run code | terminal}(Rscript code/model.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 28.1](model-basics_files/figure-latex/unnamed-chunk-2-1.jpg)

**Figure 28.1**

You can see a strong pattern in the data. Let's use a model to capture that pattern and make it explicit. It's our job to supply the basic form of the model. In this case, the relationship looks linear, i.e. `y = a_0 + a_1 * x`.  Let's start by getting a feel for what models from that family look like by randomly generating a few and overlaying them on the data. For this simple case, we can use `geom_abline()` which takes a slope and intercept as parameters. Later on we'll learn more general techniques that work with any model.


```r
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) +
  geom_point() 
```
{Run code | terminal}(Rscript code/model.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.2](model-basics_files/figure-latex/unnamed-chunk-3-1.jpg)

**Figure 28.2**

There are 250 models on this plot, but a lot are really bad! We need to find the good models by making precise our intuition that a good model is "close" to the data. We need a way to quantify the distance between the data and a model. Then we can fit the model by finding the value of `a_0` and `a_1` that generate the model with the smallest distance from this data.

One easy place to start is to find the vertical distance between each point and the model, as in the following diagram. (Note that I've shifted the x values slightly so you can see the individual distances.)


![Figure 28.3](model-basics_files/figure-latex/unnamed-chunk-4-1.jpg)

**Figure 28.3**

This distance is just the difference between the y value given by the model (the __prediction__), and the actual y value in the data (the __response__).

To compute this distance, we first turn our model family into an R function. This takes the model parameters and the data as inputs, and gives values predicted by the model as output:


```r
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)
#>  [1]  8.5  8.5  8.5 10.0 10.0 10.0 11.5 11.5 11.5 13.0 13.0 13.0 14.5 14.5
#> [15] 14.5 16.0 16.0 16.0 17.5 17.5 17.5 19.0 19.0 19.0 20.5 20.5 20.5 22.0
#> [29] 22.0 22.0
```
{Run code | terminal}(Rscript code/model.r)                           

Next, we need some way to compute an overall distance between the predicted and actual values. In other words, the plot above shows 30 distances: how do we collapse that into a single number?

One common way to do this in statistics to use the "root-mean-squared deviation". We compute the difference between actual and predicted, square them, average them, and the take the square root. This distance has lots of appealing mathematical properties, which we're not going to talk about here. You'll just have to take my word for it!


```r
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)
#> [1] 2.67
```

Now we can use purrr to compute the distance for all the models defined above. We need a helper function because our distance function expects the model as a numeric vector of length 2.


```r
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models
#> # A tibble: 250 x 3
#>       a1      a2  dist
#>    <dbl>   <dbl> <dbl>
#> 1 -15.2   0.0889  30.8
#> 2  30.1  -0.827   13.2
#> 3  16.0   2.27    13.2
#> 4 -10.6   1.38    18.7
#> 5 -19.6  -1.04    41.8
#> 6   7.98  4.59    19.3
#> # ... with 244 more rows
```

Next, let's overlay the 10 best models on to the data. I've coloured the models by `-dist`: this is an easy way to make sure that the best models (i.e. the ones with the smallest distance) get the brighest colours.


```r
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )
```
{Run code | terminal}(Rscript code/model.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.4](model-basics_files/figure-latex/unnamed-chunk-8-1.jpg)

**Figure 28.4**

We can also think about these models as observations, and visualising with a scatterplot of `a1` vs  `a2`, again coloured by `-dist`. We can no longer directly see how the model compares to the data, but we can see many models at once. Again, I've highlighted the 10 best models, this time by drawing red circles underneath them.


```r
ggplot(models, aes(a1, a2)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
```



![Figure 28.5](model-basics_files/figure-latex/unnamed-chunk-9-1.jpg)

**Figure 28.5**

Instead of trying lots of random models, we could be more systematic and generate an evenly spaced grid of points (this is called a grid search). I picked the parameters of the grid roughly by looking at where the best models were in the plot above.


```r
grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
  ) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 
```
{Run code | terminal}(Rscript code/model.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.6](model-basics_files/figure-latex/unnamed-chunk-10-1.jpg)

**Figure 28.6**

When you overlay the best 10 models back on the original data, they all look pretty good:


```r
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(grid, rank(dist) <= 10)
  )
```



![Figure 28.7](model-basics_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 28.7**

You could imagine iteratively making the grid finer and finer until you narrowed in on the best model. But there's a better way to tackle that problem: a numerical minimisation tool called Newton-Raphson search. The intuition of Newton-Raphson is pretty simple: you pick a starting point and look around for the steepest slope. You then ski down that slope a little way, and then repeat again and again, until you can't go any lower. In R, we can do that with `optim()`:


```r
best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
#> [1] 4.22 2.05

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])
```
{Run code | terminal}(Rscript code/model.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)




![Figure 28.8](model-basics_files/figure-latex/unnamed-chunk-12-1.jpg)

**Figure 28.8**

Don't worry too much about the details of how `optim()` works. It's the intuition that's important here. If you have a function that defines the distance between a model and a dataset, an algorithm that can minimise that distance by modifying the parameters of the model, you can find the best model. The neat thing about this approach is that it will work for any family of models that you can write an equation for. 

There's one more approach that we can use for this model, because it's a special case of a broader family: linear models. A linear model has the general form `y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_(n - 1)`. So this simple model is equivalent to a general linear model where n is 2 and `x_1` is `x`. R has a tool specifically designed for fitting linear models called `lm()`. `lm()` has a special way to specify the model family: formulas. Formulas look like `y ~ x`, which `lm()` will translate to a function like `y = a_1 + a_2 * x`. We can fit the model and look at the output:


```r
sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
#> (Intercept)           x 
#>        4.22        2.05
```

These are exactly the same values we got with `optim()`! Behind the scenes `lm()` doesn't use `optim()` but instead takes advantage of the mathematical structure of linear models. Using some connections between geometry, calculus, and linear algebra, `lm()` actually finds the closest model in a single step, using a sophisticated algorithm. This approach is both faster, and guarantees that there is a global minimum.

### Exercises

1.  One downside of the linear model is that it is sensitive to unusual values
    because the distance incorporates a squared term. Fit a linear model to 
    the simulated data below, and visualise the results. Rerun a few times to
    generate different simulated datasets. What do you notice about the model? 
    
    
```r
    sim1a <- tibble(
      x = rep(1:10, each = 3),
      y = x * 1.5 + 6 + rt(length(x), df = 2)
    )
```

1.  One way to make linear models more robust is to use a different distance
    measure. For example, instead of root-mean-squared distance, you could use
    mean-absolute distance:
    
    
```r
    measure_distance <- function(mod, data) {
      diff <- data$y - model1(mod, data)
      mean(abs(diff))
    }
```
    
    Use `optim()` to fit this model to the simulated data above and compare it 
    to the linear model.

1.  One challenge with performing numerical optimisation is that it's only
    guaranteed to find one local optimum. What's the problem with optimising
    a three parameter model like this?
    
    
```r
    model1 <- function(a, data) {
      a[1] + data$x * a[2] + a[3]
    }
```
