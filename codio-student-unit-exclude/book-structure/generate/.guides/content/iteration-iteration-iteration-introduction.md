
In [functions], we talked about how important it is to reduce duplication in your code by creating functions instead of copying-and-pasting. Reducing code duplication has three main benefits:

1.  It's easier to see the intent of your code, because your eyes are
    drawn to what's different, not what stays the same.
    
1.  It's easier to respond to changes in requirements. As your needs 
    change, you only need to make changes in one place, rather than
    remembering to change every place that you copied-and-pasted the 
    code.
    
1.  You're likely to have fewer bugs because each line of code is 
    used in more places.

One tool for reducing duplication is functions, which reduce duplication by identifying repeated patterns of code and extract them out into independent pieces that can be easily reused and updated. Another tool for reducing duplication is __iteration__, which helps you when you need to do the same thing to multiple inputs: repeating the same operation on different columns, or on different datasets. 
In this chapter you'll learn about two important iteration paradigms: imperative programming and functional programming. On the imperative side you have tools like for loops and while loops, which are a great place to start because they make iteration very explicit, so it's obvious what's happening. However, for loops are quite verbose, and require quite a bit of bookkeeping code that is duplicated for every for loop. Functional programming (FP) offers tools to extract out this duplicated code, so each common for loop pattern gets its own function. Once you master the vocabulary of FP, you can solve many common iteration problems with less code, more ease, and fewer errors.

### Prerequisites

Once you've mastered the for loops provided by base R, you'll learn some of the powerful programming tools provided by purrr, one of the tidyverse core packages.


```r
library(tidyverse)
```
