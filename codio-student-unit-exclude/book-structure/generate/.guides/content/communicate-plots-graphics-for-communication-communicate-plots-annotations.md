
In addition to labelling major components of your plot, it's often useful to label individual observations or groups of observations. The first tool you have at your disposal is `geom_text()`. `geom_text()` is similar to `geom_point()`, but it has an additional aesthetic: `label`. This makes it possible to add textual labels to your plots.

There are two possible sources of labels. First, you might have a tibble that provides labels. The plot below isn't terribly useful, but it illustrates a useful approach: pull out the most efficient car in each class with dplyr, and then label it on the plot:


```r
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)
```



![Figure 35.2](communicate-plots_files/figure-latex/unnamed-chunk-7-1.jpg)

**Figure 35.2**

This is hard to read because the labels overlap with each other, and with the points. We can make things a little better by switching to `geom_label()` which draws a rectangle behind the text. We also use the `nudge_y` parameter to move the labels slightly above the corresponding points:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5)
```



![Figure 35.3](communicate-plots_files/figure-latex/unnamed-chunk-8-1.jpg)

**Figure 35.3**

That helps a bit, but if you look closely in the top-left hand corner, you'll notice that there are two labels practically on top of each other. This happens because the highway mileage and displacement for the best cars in the compact and subcompact categories are exactly the same. There's no way that we can fix these by applying the same transformation for every label. Instead, we can use the __ggrepel__ package by Kamil Slowikowski. This useful package will automatically adjust labels so that they don't overlap:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)
```



![Figure 35.4](communicate-plots_files/figure-latex/unnamed-chunk-9-1.jpg)

**Figure 35.4**

Note another handy technique used here: I added a second layer of large, hollow points to highlight the points that I've labelled.

You can sometimes use the same idea to replace the legend with labels placed directly on the plot. It's not wonderful for this plot, but it isn't too bad. (`theme(legend.position = "none"`) turns the legend off --- we'll talk about it more shortly.)


```r
class_avg <- mpg %>%
  group_by(class) %>%
  summarise(
    displ = median(displ),
    hwy = median(hwy)
  )

ggplot(mpg, aes(displ, hwy, colour = class)) +
  ggrepel::geom_label_repel(aes(label = class),
    data = class_avg,
    size = 6,
    label.size = 0,
    segment.color = NA
  ) +
  geom_point() +
  theme(legend.position = "none")
```



![Figure 35.5](communicate-plots_files/figure-latex/unnamed-chunk-10-1.jpg)

**Figure 35.5**

Alternatively, you might just want to add a single label to the plot, but you'll still need to create a data frame. Often, you want the label in the corner of the plot, so it's convenient to create a new data frame using `summarise()` to compute the maximum values of x and y.


```r
label <- mpg %>%
  summarise(
    displ = max(displ),
    hwy = max(hwy),
    label = "Increasing engine size is \nrelated to decreasing fuel economy."
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")
```



![Figure 35.6](communicate-plots_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 35.6**

If you want to place the text exactly on the borders of the plot, you can use `+Inf` and `-Inf`. Since we're no longer computing the positions from `mpg`, we can use `tibble()` to create the data frame:


```r
label <- tibble(
  displ = Inf,
  hwy = Inf,
  label = "Increasing engine size is \nrelated to decreasing fuel economy."
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")
```



![Figure 35.7](communicate-plots_files/figure-latex/unnamed-chunk-12-1.jpg)

**Figure 35.7**

In these examples, I manually broke the label up into lines using `"\n"`. Another approach is to use `stringr::str_wrap()` to automatically add line breaks, given the number of characters you want per line:


```r
"Increasing engine size is related to decreasing fuel economy." %>%
  stringr::str_wrap(width = 40) %>%
  writeLines()
#> Increasing engine size is related to
#> decreasing fuel economy.
```

Note the use of `hjust` and `vjust` to control the alignment of the label. Figure \@ref(fig:just) shows all nine possible combinations.

![Figure 35.1All nine combinations of `hjust` and `vjust`.](communicate-plots_files/figure-latex/just-1.jpg)

**Figure 35.1All nine combinations of `hjust` and `vjust`.**

Remember, in addition to `geom_text()`, you have many other geoms in ggplot2 available to help annotate your plot. A few ideas:

*   Use `geom_hline()` and `geom_vline()` to add reference lines. I often make
    them thick (`size = 2`) and white (`colour = white`), and draw them
    underneath the primary data layer. That makes them easy to see, without
    drawing attention away from the data.

*   Use `geom_rect()` to draw a rectangle around points of interest. The
    boundaries of the rectangle are defined by aesthetics `xmin`, `xmax`,
    `ymin`, `ymax`.

*   Use `geom_segment()` with the `arrow` argument to draw attention
    to a point with an arrow. Use aesthetics `x` and `y` to define the
    starting location, and `xend` and `yend` to define the end location.

The only limit is your imagination (and your patience with positioning annotations to be aesthetically pleasing)!

### Exercises

1.  Use `geom_text()` with infinite positions to place text at the
    four corners of the plot.

1.  Read the documentation for `annotate()`. How can you use it to add a text
    label to a plot without having to create a tibble?

1.  How do labels with `geom_text()` interact with faceting? How can you
    add a label to a single facet? How can you put a different label in
    each facet? (Hint: think about the underlying data.)

1.  What arguments to `geom_label()` control the appearance of the background
    box?

1.  What are the four arguments to `arrow()`? How do they work? Create a series
    of plots that demonstrate the most important options.
