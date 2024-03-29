
Next, let's take a look at a bar chart. Bar charts seem simple, but they are interesting because they reveal something subtle about plots. Consider a basic bar chart, as drawn with `geom_bar()`. The following chart displays the total number of diamonds in the `diamonds` dataset, grouped by `cut`. The `diamonds` dataset comes in ggplot2 and contains information about ~54,000 diamonds, including the `price`, `carat`, `color`, `clarity`, and `cut` of each diamond. The chart shows that more diamonds are available with high quality cuts than with low quality cuts. 


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
```

{Run code | terminal}(Rscript code/statTrans.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-30-1.jpg)

**Figure 5.1**

On the x-axis, the chart displays `cut`, a variable from `diamonds`. On the y-axis, it displays count, but count is not a variable in `diamonds`! Where does count come from? Many graphs, like scatterplots, plot the raw values of your dataset. Other graphs, like bar charts, calculate new values to plot:

* bar charts, histograms, and frequency polygons bin your data 
  and then plot bin counts, the number of points that fall in each bin.

* smoothers fit a model to your data and then plot predictions from the
  model.

* boxplots compute a robust summary of the distribution and then display a 
  specially formatted box.

The algorithm used to calculate new values for a graph is called a __stat__, short for statistical transformation. The figure below describes how this process works with `geom_bar()`.


![Figure 5.2](images/visualization-stat-bar.png)

**Figure 5.2**

You can learn which stat a geom uses by inspecting the default value for the `stat` argument. For example, `?geom_bar` shows that the default value for `stat` is "count", which means that `geom_bar()` uses `stat_count()`. `stat_count()` is documented on the same page as `geom_bar()`, and if you scroll down you can find a section called "Computed variables". That describes how it computes two new variables: `count` and `prop`.

You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using `stat_count()` instead of `geom_bar()`:


```r
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
```

{Run code | terminal}(Rscript code/statTrans.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)



![Figure 5.3](visualize_files/figure-latex/unnamed-chunk-32-1.jpg)

**Figure 5.3**

This works because every geom has a default stat; and every stat has a default geom. This means that you can typically use geoms without worrying about the underlying statistical transformation. There are three reasons you might need to use a stat explicitly:

1.  You might want to override the default stat. In the code below, I change 
    the stat of `geom_bar()` from count (the default) to identity. This lets 
    me map the height of the bars to the raw values of a $y$ variable. 
    Unfortunately when people talk about bar charts casually, they might be
    referring to this type of bar chart, where the height of the bar is already
    present in the data, or the previous bar chart where the height of the bar
    is generated by counting rows.
    
    
```r
    demo <- tribble(
      ~cut,         ~freq,
      "Fair",       1610,
      "Good",       4906,
      "Very Good",  12082,
      "Premium",    13791,
      "Ideal",      21551
    )
    
    ggplot(data = demo) +
      geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")
```
{Run code | terminal}(Rscript code/statTrans.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)

    
    
    
![Figure 5.4](visualize_files/figure-latex/unnamed-chunk-33-1.jpg)

**Figure 5.4**
    
    (Don't worry that you haven't seen `<-` or `tribble()` before. You might be
    able to guess at their meaning from the context, and you'll learn exactly
    what they do soon!)

1.  You might want to override the default mapping from transformed variables
    to aesthetics. For example, you might want to display a bar chart of
    proportion, rather than count:
    
    
```r
    ggplot(data = diamonds) + 
      geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```
    
{Run code | terminal}(Rscript code/statTrans.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)

    
    
![Figure 5.5](visualize_files/figure-latex/unnamed-chunk-34-1.jpg)

**Figure 5.5**

    To find the variables computed by the stat, look for the help section
    titled "computed variables".
    
1.  You might want to draw greater attention to the statistical transformation
    in your code. For example, you might use `stat_summary()`, which
    summarises the y values for each unique x value, to draw 
    attention to the summary that you're computing:
    
    
```r
    ggplot(data = diamonds) + 
      stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.ymin = min,
        fun.ymax = max,
        fun.y = median
      )
```
    
{Run code | terminal}(Rscript code/statTrans.r)
 
[Refresh Plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)

    
    
![Figure 5.6](visualize_files/figure-latex/unnamed-chunk-35-1.jpg)

**Figure 5.6**
    
ggplot2 provides over 20 stats for you to use. Each stat is a function, so you can get help in the usual way, e.g. `?stat_bin`. To see a complete list of stats, try the ggplot2 cheatsheet.

### Exercises

1.  What is the default geom associated with `stat_summary()`? How could
    you rewrite the previous plot to use that geom function instead of the 
    stat function?

1.  What does `geom_col()` do? How is it different to `geom_bar()`?

1.  Most geoms and stats come in pairs that are almost always used in 
    concert. Read through the documentation and make a list of all the 
    pairs. What do they have in common?

1.  What variables does `stat_smooth()` compute? What parameters control
    its behaviour?

1.  In our proportion bar chart, we need to set `group = 1`. Why? In other
    words what is the problem with these two graphs?
    
    
```r
    ggplot(data = diamonds) + 
      geom_bar(mapping = aes(x = cut, y = ..prop..))
    ggplot(data = diamonds) + 
      geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
```
  
