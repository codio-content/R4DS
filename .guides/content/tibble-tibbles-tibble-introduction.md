
Throughout this book we work with "tibbles" instead of R's traditional `data.frame`. Tibbles _are_ data frames, but they tweak some older behaviours to make life a little easier. R is an old language, and some things that were useful 10 or 20 years ago now get in your way. It's difficult to change base R without breaking existing code, so most innovation occurs in packages. Here we will describe the __tibble__ package, which provides opinionated data frames that make working in the tidyverse a little easier. In most places, I'll use the term tibble and data frame interchangeably; when I want to draw particular attention to R's built-in data frame, I'll call them `data.frame`s. 

If this chapter leaves you wanting to learn more about tibbles, you might enjoy `vignette("tibble")`.

### Prerequisites

In this chapter we'll explore the __tibble__ package, part of the core tidyverse.


```r
library(tidyverse)
```
