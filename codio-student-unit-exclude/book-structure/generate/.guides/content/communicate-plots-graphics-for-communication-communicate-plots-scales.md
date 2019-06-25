
The third way you can make your plot better for communication is to adjust the scales. Scales control the mapping from data values to things that you can perceive. Normally, ggplot2 automatically adds scales for you. For example, when you type:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))
```

ggplot2 automatically adds default scales behind the scenes:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()
```

Note the naming scheme for scales: `scale_` followed by the name of the aesthetic, then `_`, then the name of the scale. The default scales are named according to the type of variable they align with: continuous, discrete, datetime, or date. There are lots of non-default scales which you'll learn about below.

The default scales have been carefully chosen to do a good job for a wide range of inputs. Nevertheless, you might want to override the defaults for two reasons:

*   You might want to tweak some of the parameters of the default scale.
    This allows you to do things like change the breaks on the axes, or the
    key labels on the legend.

*   You might want to replace the scale altogether, and use a completely
    different algorithm. Often you can do better than the default because
    you know more about the data.

### Axis ticks and legend keys

There are two primary arguments that affect the appearance of the ticks on the axes and the keys on the legend: `breaks` and `labels`. Breaks controls the position of the ticks, or the values associated with the keys. Labels controls the text label associated with each tick/key. The most common use of `breaks` is to override the default choice:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
```



![Figure 35.2](communicate-plots_files/figure-latex/unnamed-chunk-15-1.jpg)

**Figure 35.2**

You can use `labels` in the same way (a character vector the same length as `breaks`), but you can also set it to `NULL` to suppress the labels altogether. This is useful for maps, or for publishing plots where you can't share the absolute numbers.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)
```



![Figure 35.3](communicate-plots_files/figure-latex/unnamed-chunk-16-1.jpg)

**Figure 35.3**

You can also use `breaks` and `labels` to control the appearance of legends. Collectively axes and legends are called __guides__. Axes are used for x and y aesthetics; legends are used for everything else.

Another use of `breaks` is when you have relatively few data points and want to highlight exactly where the observations occur. For example, take this plot that shows when each US president started and ended their term.


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y")
```



![Figure 35.4](communicate-plots_files/figure-latex/unnamed-chunk-17-1.jpg)

**Figure 35.4**

Note that the specification of breaks and labels for date and datetime scales is a little different:

* `date_labels` takes a format specification, in the same form as
  `parse_datetime()`.

* `date_breaks` (not shown here), takes a string like "2 days" or "1 month".

### Legend layout

You will most often use `breaks` and `labels` to tweak the axes. While they both also work for legends, there are a few other techniques you are more likely to use.

To control the overall position of the legend, you need to use a `theme()` setting. We'll come back to themes at the end of the chapter, but in brief, they control the non-data parts of the plot. The theme setting `legend.position` controls where the legend is drawn:


```r
base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "bottom")
base + theme(legend.position = "right") # the default
```


![Figure 35.10](communicate-plots_files/figure-latex/unnamed-chunk-18-1.jpg)

**Figure 35.10**

 ![Figure 35.11](communicate-plots_files/figure-latex/unnamed-chunk-18-2.jpg)

**Figure 35.11**

 ![Figure 35.12](communicate-plots_files/figure-latex/unnamed-chunk-18-3.jpg)

**Figure 35.12**

 ![Figure 35.13](communicate-plots_files/figure-latex/unnamed-chunk-18-4.jpg)

**Figure 35.13**

 

You can also use `legend.position = "none"` to suppress the display of the legend altogether.

To control the display of individual legends, use `guides()` along with `guide_legend()` or `guide_colourbar()`. The following example shows two important settings: controlling the number of rows the legend uses with `nrow`, and overriding one of the aesthetics to make the points bigger. This is particularly useful if you have used a low `alpha` to display many points on a plot.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 4)))
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```



![Figure 35.5](communicate-plots_files/figure-latex/unnamed-chunk-19-1.jpg)

**Figure 35.5**

### Replacing a scale

Instead of just tweaking the details a little, you can instead replace the scale altogether. There are two types of scales you're mostly likely to want to switch out: continuous position scales and colour scales. Fortunately, the same principles apply to all the other aesthetics, so once you've mastered position and colour, you'll be able to quickly pick up other scale replacements.

It's very useful to plot transformations of your variable. For example, as we've seen in [diamond prices](diamond-prices) it's easier to see the precise relationship between `carat` and `price` if we log transform them:


```r
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()
```


![Figure 35.14](communicate-plots_files/figure-latex/unnamed-chunk-20-1.jpg)

**Figure 35.14**

 ![Figure 35.15](communicate-plots_files/figure-latex/unnamed-chunk-20-2.jpg)

**Figure 35.15**

 

However, the disadvantage of this transformation is that the axes are now labelled with the transformed values, making it hard to interpret the plot. Instead of doing the transformation in the aesthetic mapping, we can instead do it with the scale. This is visually identical, except the axes are labelled on the original data scale.


```r
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()
```



![Figure 35.6](communicate-plots_files/figure-latex/unnamed-chunk-21-1.jpg)

**Figure 35.6**

Another scale that is frequently customised is colour. The default categorical scale picks colours that are evenly spaced around the colour wheel. Useful alternatives are the ColorBrewer scales which have been hand tuned to work better for people with common types of colour blindness. The two plots below look similar, but there is enough difference in the shades of red and green that the dots on the right can be distinguished even by people with red-green colour blindness.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")
```


![Figure 35.16](communicate-plots_files/figure-latex/unnamed-chunk-22-1.jpg)

**Figure 35.16**

 ![Figure 35.17](communicate-plots_files/figure-latex/unnamed-chunk-22-2.jpg)

**Figure 35.17**

 

Don't forget simpler techniques. If there are just a few colours, you can add a redundant shape mapping. This will also help ensure your plot is interpretable in black and white.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_colour_brewer(palette = "Set1")
```



![Figure 35.7](communicate-plots_files/figure-latex/unnamed-chunk-23-1.jpg)

**Figure 35.7**

The ColorBrewer scales are documented online at <http://colorbrewer2.org/> and made available in R via the __RColorBrewer__ package, by Erich Neuwirth. Figure \@ref(fig:brewer) shows the complete list of all palettes. The sequential (top) and diverging (bottom) palettes are particularly useful if your categorical values are ordered, or have a "middle". This often arises if you've used `cut()` to make a continuous variable into a categorical variable.

![Figure 35.1All ColourBrewer scales.](communicate-plots_files/figure-latex/brewer-1.jpg)

**Figure 35.1All ColourBrewer scales.**

When you have a predefined mapping between values and colours, use `scale_colour_manual()`. For example, if we map presidential party to colour, we want to use the standard mapping of red for Republicans and blue for Democrats:


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue"))
```



![Figure 35.8](communicate-plots_files/figure-latex/unnamed-chunk-24-1.jpg)

**Figure 35.8**

For continuous colour, you can use the built-in `scale_colour_gradient()` or `scale_fill_gradient()`. If you have a diverging scale, you can use `scale_colour_gradient2()`. That allows you to give, for example, positive and negative values different colours. That's sometimes also useful if you want to distinguish points above or below the mean.

Another option is `scale_colour_viridis()` provided by the __viridis__ package. It's a continuous analog of the categorical ColorBrewer scales. The designers, Nathaniel Smith and Stéfan van der Walt, carefully tailored a continuous colour scheme that has good perceptual properties. Here's an example from the viridis vignette.


```r
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()
```


![Figure 35.18](communicate-plots_files/figure-latex/unnamed-chunk-25-1.jpg)

**Figure 35.18**

 ![Figure 35.19](communicate-plots_files/figure-latex/unnamed-chunk-25-2.jpg)

**Figure 35.19**

 

Note that all colour scales come in two variety: `scale_colour_x()` and `scale_fill_x()` for the `colour` and `fill` aesthetics respectively (the colour scales are available in both UK and US spellings).

### Exercises

1.  Why doesn't the following code override the default scale?

    
```r
    ggplot(df, aes(x, y)) +
      geom_hex() +
      scale_colour_gradient(low = "white", high = "red") +
      coord_fixed()
```

1.  What is the first argument to every scale? How does it compare to `labs()`?

1.  Change the display of the presidential terms by:

    1. Combining the two variants shown above.
    1. Improving the display of the y axis.
    1. Labelling each term with the name of the president.
    1. Adding informative plot labels.
    1. Placing breaks every 4 years (this is trickier than it seems!).

1.  Use `override.aes` to make the legend on the following plot easier to see.

    
```r
    ggplot(diamonds, aes(carat, price)) +
      geom_point(aes(colour = cut), alpha = 1/20)
```
    
    
    
![Figure 35.9](communicate-plots_files/figure-latex/unnamed-chunk-27-1.png)

**Figure 35.9**
