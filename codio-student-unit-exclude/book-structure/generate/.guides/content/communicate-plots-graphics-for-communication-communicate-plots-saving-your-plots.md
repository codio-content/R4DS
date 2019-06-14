
There are two main ways to get your plots out of R and into your final write-up: `ggsave()` and knitr. `ggsave()` will save the most recent plot to disk:


```r
ggplot(mpg, aes(displ, hwy)) + geom_point()
```



![Figure 35.1](communicate-plots_files/figure-latex/unnamed-chunk-32-1.jpg)

**Figure 35.1**

```r
ggsave("my-plot.pdf")
#> Saving 6 x 3.71 in image
```


If you don't specify the `width` and `height` they will be taken from the dimensions of the current plotting device. For reproducible code, you'll want to specify them.

Generally, however, I think you should be assembling your final reports using R Markdown, so I want to focus on the important code chunk options that you should know about for graphics. You can learn more about `ggsave()` in the documentation.

### Figure sizing

The biggest challenge of graphics in R Markdown is getting your figures the right size and shape. There are five main options that control figure sizing: `fig.width`, `fig.height`, `fig.asp`, `out.width` and `out.height`. Image sizing is challenging because there are two sizes (the size of the figure created by R and the size at which it is inserted in the output document), and multiple ways of specifying the size (i.e., height, width, and aspect ratio: pick two of three).

I only ever use three of the five options:

* I find it most aesthetically pleasing for plots to have a consistent
  width. To enforce this, I set `fig.width = 6` (6") and `fig.asp = 0.618`
  (the golden ratio) in the defaults. Then in individual chunks, I only
  adjust `fig.asp`.

* I control the output size with `out.width` and set it to a percentage
  of the line width. I default to `out.width = "70%"`
  and `fig.align = "center"`. That give plots room to breathe, without taking
  up too much space.

* To put multiple plots in a single row I set the `out.width` to
  `50%` for two plots, `33%` for 3 plots, or `25%` to 4 plots, and set
  `fig.align = "default"`. Depending on what I'm trying to illustrate (e.g.
  show data or show plot variations), I'll also tweak `fig.width`, as
  discussed below.

If you find that you're having to squint to read the text in your plot, you need to tweak `fig.width`. If `fig.width` is larger than the size the figure is rendered in the final doc, the text will be too small; if `fig.width` is smaller, the text will be too big. You'll often need to do a little experimentation to figure out the right ratio between the `fig.width` and the eventual width in your document. To illustrate the principle, the following three plots have `fig.width` of 4, 6, and 8 respectively:



![Figure 35.2](communicate-plots_files/figure-latex/unnamed-chunk-35-1.jpg)

**Figure 35.2**

![Figure 35.3](communicate-plots_files/figure-latex/unnamed-chunk-36-1.jpg)

**Figure 35.3**

![Figure 35.4](communicate-plots_files/figure-latex/unnamed-chunk-37-1.jpg)

**Figure 35.4**

If you want to make sure the font size is consistent across all your figures, whenever you set `out.width`, you'll also need to adjust `fig.width` to maintain the same ratio with your default `out.width`. For example, if your default `fig.width` is 6 and `out.width` is 0.7, when you set `out.width = "50%"` you'll need to set `fig.width` to 4.3 (6 * 0.5 / 0.7).

### Other important options

When mingling code and text, like I do in this book, I recommend setting `fig.show = "hold"` so that plots are shown after the code. This has the pleasant side effect of forcing you to break up large blocks of code with their explanations.

To add a caption to the plot, use `fig.cap`. In R Markdown this will change the figure from inline to "floating".

If you're producing PDF output, the default graphics type is PDF. This is a good default because PDFs are high quality vector graphics. However, they can produce very large and slow plots if you are displaying thousands of points. In that case, set `dev = "png"` to force the use of PNGs. They are slightly lower quality, but will be much more compact.

It's a good idea to name code chunks that produce figures, even if you don't routinely label other chunks. The chunk label is used to generate the file name of the graphic on disk, so naming your chunks makes it much easier to pick out plots and reuse in other circumstances (i.e. if you want to quickly drop a single plot into an email or a tweet).
