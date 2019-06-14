
The easiest place to start when turning an exploratory graphic into an expository graphic is with good labels. You add labels with the `labs()` function. This example adds a plot title:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")
```



![Figure 35.1](communicate-plots_files/figure-latex/unnamed-chunk-3-1.jpg)

**Figure 35.1**

The purpose of a plot title is to summarise the main finding. Avoid titles that just describe what the plot is, e.g. "A scatterplot of engine displacement vs. fuel economy". 

If you need to add more text, there are two other useful labels that you can use in ggplot2 2.2.0 and above (which should be available by the time you're reading this book):

*   `subtitle` adds additional detail in a smaller font beneath the title.

*   `caption` adds text at the bottom right of the plot, often used to describe
    the source of the data.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )
```



![Figure 35.2](communicate-plots_files/figure-latex/unnamed-chunk-4-1.jpg)

**Figure 35.2**

You can also use `labs()` to replace the axis and legend titles. It's usually a good idea to replace short variable names with more detailed descriptions, and to include the units.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
```



![Figure 35.3](communicate-plots_files/figure-latex/unnamed-chunk-5-1.jpg)

**Figure 35.3**

It's possible to use mathematical equations instead of text strings. Just switch `""` out for `quote()` and read about the available options in `?plotmath`:


```r
df <- tibble(
  x = runif(10),
  y = runif(10)
)
ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )
```



![Figure 35.4](communicate-plots_files/figure-latex/unnamed-chunk-6-1.jpg)

**Figure 35.4**

### Exercises

1.  Create one plot on the fuel economy data with customised `title`,
    `subtitle`, `caption`, `x`, `y`, and `colour` labels.

1.  The `geom_smooth()` is somewhat misleading because the `hwy` for
    large engines is skewed upwards due to the inclusion of lightweight
    sports cars with big engines. Use your modelling tools to fit and display
    a better model.

1.  Take an exploratory graphic that you've created in the last month, and add
    informative titles to make it easier for others to understand.
