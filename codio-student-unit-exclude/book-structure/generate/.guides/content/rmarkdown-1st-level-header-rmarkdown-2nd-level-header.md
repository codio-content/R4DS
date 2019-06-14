
### 3rd Level Header

Lists
------------------------------------------------------------

*   Bulleted list item 1

*   Item 2

    * Item 2a

    * Item 2b

1.  Numbered list item 1

1.  Item 2. The numbers are incremented automatically in the output.

Links and images
------------------------------------------------------------

<http://example.com>

[linked phrase](http://example.com)

![optional caption text](path/to/img.png)

Tables 
------------------------------------------------------------

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell
```

The best way to learn these is simply to try them out. It will take a few days, but soon they will become second nature, and you won't need to think about them. If you forget, you can get to a handy reference sheet with *Help > Markdown Quick Reference*.

### Exercises

1.  Practice what you've learned by creating a brief CV. The title should be
    your name, and you should include headings for (at least) education or
    employment. Each of the sections should include a bulleted list of
    jobs/degrees. Highlight the year in bold.
    
1.  Using the R Markdown quick reference, figure out how to:

    1.  Add a footnote.
    1.  Add a horizontal rule.
    1.  Add a block quote.
    
1.  Copy and paste the contents of `diamond-sizes.Rmd` from
    <https://github.com/hadley/r4ds/tree/master/rmarkdown> in to a local
    R markdown document. Check that you can run it, then add text after the 
    frequency polygon that describes its most striking features.

## Code chunks

To run code inside an R Markdown document, you need to insert a chunk. There are three ways to do so:

1. The keyboard shortcut Cmd/Ctrl + Alt + I

1. The "Insert" button icon in the editor toolbar.

1. By manually typing the chunk delimiters ` ```{r} ` and ` ``` `.

Obviously, I'd recommend you learn the keyboard shortcut. It will save you a lot of time in the long run!

You can continue to run the code using the keyboard shortcut that by now (I hope!) you know and love: Cmd/Ctrl + Enter. However, chunks get a new keyboard shortcut: Cmd/Ctrl + Shift + Enter, which runs all the code in the chunk. Think of a chunk like a function. A chunk should be relatively self-contained, and focussed around a single task. 

The following sections describe the chunk header which consists of ```` ```{r ````, followed by an optional chunk name, followed by comma separated options, followed by `}`. Next comes your R code and the chunk end is indicated by a final ```` ``` ````.

### Chunk name

Chunks can be given an optional name: ```` ```{r by-name} ````. This has three advantages:

1.  You can more easily navigate to specific chunks using the drop-down
    code navigator in the bottom-left of the script editor:

    
![Figure 34.1](screenshots/rmarkdown-chunk-nav)

**Figure 34.1**

1.  Graphics produced by the chunks will have useful names that make
    them easier to use elsewhere. More on that in [other important options].
    
1.  You can set up networks of cached chunks to avoid re-performing expensive
    computations on every run. More on that below.

There is one chunk name that imbues special behaviour: `setup`. When you're in a notebook mode, the chunk named setup will be run automatically once, before any other code is run.

### Chunk options

Chunk output can be customised with __options__, arguments supplied to chunk header. Knitr provides almost 60 options that you can use to customize your code chunks. Here we'll cover the most important chunk options that you'll use frequently. You can see the full list at <http://yihui.name/knitr/options/>. 

The most important set of options controls if your code block is executed and what results are inserted in the finished report:
  
*   `eval = FALSE` prevents code from being evaluated. (And obviously if the
    code is not run, no results will be generated). This is useful for 
    displaying example code, or for disabling a large block of code without 
    commenting each line.

*   `include = FALSE` runs the code, but doesn't show the code or results 
    in the final document. Use this for setup code that you don't want
    cluttering your report.

*   `echo = FALSE` prevents code, but not the results from appearing in the 
    finished file. Use this when writing reports aimed at people who don't
    want to see the underlying R code.
    
*   `message = FALSE` or `warning = FALSE` prevents messages or warnings 
    from appearing in the finished file.

*   `results = 'hide'` hides printed output; `fig.show = 'hide'` hides
    plots.

*   `error = TRUE` causes the render to continue even if code returns an error.
    This is rarely something you'll want to include in the final version
    of your report, but can be very useful if you need to debug exactly
    what is going on inside your `.Rmd`. It's also useful if you're teaching R
    and want to deliberately include an error. The default, `error = FALSE` causes 
    knitting to fail if there is a single error in the document.
    
The following table summarises which types of output each option supressess:

Option             | Run code | Show code | Output | Plots | Messages | Warnings 
-------------------|----------|-----------|--------|-------|----------|---------
`eval = FALSE`     | -        |           | -      | -     | -        | -
`include = FALSE`  |          | -         | -      | -     | -        | -
`echo = FALSE`     |          | -         |        |       |          |
`results = "hide"` |          |           | -      |       |          | 
`fig.show = "hide"`|          |           |        | -     |          |
`message = FALSE`  |          |           |        |       | -        |
`warning = FALSE`  |          |           |        |       |          | -

### Table

By default, R Markdown prints data frames and matrices as you'd see them in the console:


```r
mtcars[1:5, ]
#>                    mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.62 16.5  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.88 17.0  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.32 18.6  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.21 19.4  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.44 17.0  0  0    3    2
```

If you prefer that data be displayed with additional formatting you can use the `knitr::kable` function. The code below generates Table \@ref(tab:kable).


```r
knitr::kable(
  mtcars[1:5, ], 
  caption = "A knitr kable."
)
```

\begin{table}[t]

\caption{(\#tab:kable)A knitr kable.}
\centering
\begin{tabular}{l|r|r|r|r|r|r|r|r|r|r|r}
\hline
  & mpg & cyl & disp & hp & drat & wt & qsec & vs & am & gear & carb\\
\hline
Mazda RX4 & 21.0 & 6 & 160 & 110 & 3.90 & 2.62 & 16.5 & 0 & 1 & 4 & 4\\
\hline
Mazda RX4 Wag & 21.0 & 6 & 160 & 110 & 3.90 & 2.88 & 17.0 & 0 & 1 & 4 & 4\\
\hline
Datsun 710 & 22.8 & 4 & 108 & 93 & 3.85 & 2.32 & 18.6 & 1 & 1 & 4 & 1\\
\hline
Hornet 4 Drive & 21.4 & 6 & 258 & 110 & 3.08 & 3.21 & 19.4 & 1 & 0 & 3 & 1\\
\hline
Hornet Sportabout & 18.7 & 8 & 360 & 175 & 3.15 & 3.44 & 17.0 & 0 & 0 & 3 & 2\\
\hline
\end{tabular}
\end{table}

Read the documentation for `?knitr::kable` to see the other ways in which you can customise the table. For even deeper customisation, consider the __xtable__, __stargazer__, __pander__, __tables__, and __ascii__ packages. Each provides a set of tools for returning formatted tables from R code.

There is also a rich set of options for controlling how figures are embedded. You'll learn about these in [saving your plots].

### Caching

Normally, each knit of a document starts from a completely clean slate. This is great for reproducibility, because it ensures that you've captured every important computation in code. However, it can be painful if you have some computations that take a long time. The solution is `cache = TRUE`. When set, this will save the output of the chunk to a specially named file on disk. On subsequent runs, knitr will check to see if the code has changed, and if it hasn't, it will reuse the cached results.

The caching system must be used with care, because by default it is based on the code only, not its dependencies. For example, here the `processed_data` chunk depends on the `raw_data` chunk:

```{r raw_data}
    rawdata <- readr::read_csv("a_very_large_file.csv")
```
    
```{r processed_data, cache = TRUE}
    processed_data <- rawdata %>% 
      filter(!is.na(import_var)) %>% 
      mutate(new_variable = complicated_transformation(x, y, z))
```

Caching the `processed_data` chunk means that it will get re-run if the dplyr pipeline is changed, but it won't get rerun if the `read_csv()` call changes. You can avoid that problem with the `dependson` chunk option:

```{r processed_data, cache = TRUE, dependson = "raw_data"}
    processed_data <- rawdata %>% 
      filter(!is.na(import_var)) %>% 
      mutate(new_variable = complicated_transformation(x, y, z))
```

`dependson` should contain a character vector of *every* chunk that the cached chunk depends on. Knitr will update the results for the cached chunk whenever it detects that one of its dependencies have changed.

Note that the chunks won't update if `a_very_large_file.csv` changes, because knitr caching only tracks changes within the `.Rmd` file. If you want to also track changes to that file you can use the `cache.extra` option. This is an arbitrary R expression that will invalidate the cache whenever it changes. A good function to use is `file.info()`: it returns a bunch of information about the file including when it was last modified. Then you can write:

```{r raw_data, cache.extra = file.info("a_very_large_file.csv")}
    rawdata <- readr::read_csv("a_very_large_file.csv")
```

As your caching strategies get progressively more complicated, it's a good idea to regularly clear out all your caches with `knitr::clean_cache()`.

I've used the advice of [David Robinson](https://twitter.com/drob/status/738786604731490304) to name these chunks: each chunk is named after the primary object that it creates. This makes it easier to understand the `dependson` specification.

### Global options

As you work more with knitr, you will discover that some of the default chunk options don't fit your needs and you want to change them. You can do this by calling `knitr::opts_chunk$set()` in a code chunk. For example, when writing books and tutorials I set:


```r
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE
)
```

This uses my preferred comment formatting, and ensures that the code and output are kept closely entwined. On the other hand, if you were preparing a report, you might set:


```r
knitr::opts_chunk$set(
  echo = FALSE
)
```

That will hide the code by default, so only showing the chunks you deliberately choose to show (with `echo = TRUE`). You might consider setting `message = FALSE` and `warning = FALSE`, but that would make it harder to debug problems because you wouldn't see any messages in the final document.

### Inline code

There is one other way to embed R code into an R Markdown document: directly into the text, with:  `` `r ` ``. This can be very useful if you mention properties of your data in the text. For example, in the example document I used at the start of the chapter I had:

> We have data about `` `r nrow(diamonds)` `` diamonds. 
> Only `` `r nrow(diamonds) - nrow(smaller)` `` are larger 
> than 2.5 carats. The distribution of the remainder is shown below:

When the report is knit, the results of these computations are inserted into the text:

> We have data about 53940 diamonds. Only 126 are larger than 
> 2.5 carats. The distribution of the remainder is shown below:

When inserting numbers into text, `format()` is your friend. It allows you to set the number of `digits` so you don't print to a ridiculous degree of accuracy, and a `big.mark` to make numbers easier to read. I'll often combine these into a helper function:


```r
comma <- function(x) format(x, digits = 2, big.mark = ",")
comma(3452345)
#> [1] "3,452,345"
comma(.12358124331)
#> [1] "0.12"
```

### Exercises

1.  Add a section that explores how diamond sizes vary by cut, colour,
    and clarity. Assume you're writing a report for someone who doesn't know
    R, and instead of setting `echo = FALSE` on each chunk, set a global 
    option.

1.  Download `diamond-sizes.Rmd` from
    <https://github.com/hadley/r4ds/tree/master/rmarkdown>. Add a section
    that describes the largest 20 diamonds, including a table that displays
    their most important attributes.

1.  Modify `diamonds-sizes.Rmd` to use `comma()` to produce nicely
    formatted output. Also include the percentage of diamonds that are
    larger than 2.5 carats.

1.  Set up a network of chunks where `d` depends on `c` and `b`, and
    both `b` and `c` depend on `a`. Have each chunk print `lubridate::now()`,
    set `cache = TRUE`, then verify your understanding of caching.
