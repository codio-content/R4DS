
This chapter introduces you to string manipulation in R. You'll learn the basics of how strings work and how to create them by hand, but the focus of this chapter will be on regular expressions, or regexps for short. Regular expressions are useful because strings usually contain unstructured or semi-structured data, and regexps are a concise language for describing patterns in strings. When you first look at a regexp, you'll think a cat walked across your keyboard, but as your understanding improves they will soon start to make sense.

### Prerequisites

This chapter will focus on the __stringr__ package for string manipulation. stringr is not part of the core tidyverse because you don't always have textual data, so we need to load it explicitly.


```r
library(tidyverse)
library(stringr)
```
