
Pipes are a powerful tool for clearly expressing a sequence of multiple operations. So far, you've been using them without knowing how they work, or what the alternatives are. Now, in this chapter, it's time to explore the pipe in more detail. You'll learn the alternatives to the pipe, when you shouldn't use the pipe, and some useful related tools.

### Prerequisites

The pipe, `%>%`, comes from the __magrittr__ package by Stefan Milton Bache. Packages in the tidyverse load `%>%` for you automatically, so you don't usually load magrittr explicitly.  Here, however, we're focussing on piping, and we aren't loading any other packages, so we will load it explicitly.


```r
library(magrittr)
```
