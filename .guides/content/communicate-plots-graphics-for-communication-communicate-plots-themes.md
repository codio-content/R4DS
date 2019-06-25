
Finally, you can customise the non-data elements of your plot with a theme:


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()
```



![Figure 35.2](communicate-plots_files/figure-latex/unnamed-chunk-31-1.jpg)

**Figure 35.2**

ggplot2 includes eight themes by default, as shown in Figure \@ref(fig:themes). Many more are included in add-on packages like __ggthemes__ (<https://github.com/jrnold/ggthemes>), by Jeffrey Arnold.

![Figure 35.1The eight themes built-in to ggplot2.](images/visualization-themes.png)

**Figure 35.1The eight themes built-in to ggplot2.**

Many people wonder why the default theme has a grey background. This was a deliberate choice because it puts the data forward while still making the grid lines visible. The white grid lines are visible (which is important because they significantly aid position judgements), but they have little visual impact and we can easily tune them out. The grey background gives the plot a similar typographic colour to the text, ensuring that the graphics fit in with the flow of a document without jumping out with a bright white background. Finally, the grey background creates a continuous field of colour which ensures that the plot is perceived as a single visual entity.

It's also possible to control individual components of each theme, like the size and colour of the font used for the y axis. Unfortunately, this level of detail is outside the scope of this book, so you'll need to read the [ggplot2 book](https://amzn.com/331924275X) for the full details. You can also create your own themes, if you are trying to match a particular corporate or journal style.
