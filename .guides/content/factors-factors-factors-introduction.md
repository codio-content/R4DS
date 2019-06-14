
In R, factors are used to work with categorical variables, variables that have a fixed and known set of possible values. They are also useful when you want to display character vectors in a non-alphabetical order.

Historically, factors were much easier to work with than characters. As a result, many of the functions in base R automatically convert characters to factors. This means that factors often crop up in places where they're not actually helpful. Fortunately, you don't need to worry about that in the tidyverse, and can focus on situations where factors are genuinely useful.

### Prerequisites

To work with factors, we'll use the __forcats__ package, which provides tools for dealing with **cat**egorical variables (and it's an anagram of factors!). It provides a wide range of helpers for working with factors. forcats is not part of the core tidyverse, so we need to load it explicitly.


```r
library(tidyverse)
library(forcats)
```

### Learning more

If you want to learn more about factors, I recommend reading Amelia McNamara and Nicholas Horton’s paper, [_Wrangling categorical data in R_](https://peerj.com/preprints/3163/). This paper lays out some of the history discussed in [_stringsAsFactors: An unauthorized biography_](http://simplystatistics.org/2015/07/24/stringsasfactors-an-unauthorized-biography/) and [_stringsAsFactors = \<sigh\>_](http://notstatschat.tumblr.com/post/124987394001/stringsasfactors-sigh), and compares the tidy approaches to categorical data outlined in this book with base R methods. A early version of the paper help motivate and scope the forcats package; thanks Amelia & Nick!
