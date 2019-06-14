
In this chapter you're going to learn three powerful ideas that help you to work with large numbers of models with ease:

1.  Using many simple models to better understand complex datasets.

1.  Using list-columns to store arbitrary data structures in a data frame.
    For example, this will allow you to have a column that contains linear 
    models.
   
1.  Using the __broom__ package, by David Robinson, to turn models into tidy 
    data. This is a powerful technique for working with large numbers of models
    because once you have tidy data, you can apply all of the techniques that 
    you've learned about earlier in the book.

We'll start by diving into a motivating example using data about life expectancy around the world. It's a small dataset but it illustrates how important modelling can be for improving your visualisations. We'll use a large number of simple models to partition out some of the strongest signals so we can see the subtler signals that remain. We'll also see how model summaries can help us pick out outliers and unusual trends.

The following sections will dive into more detail about the individual techniques:

1. In [list-columns], you'll learn more about the list-column data structure,
   and why it's valid to put lists in data frames.
   
1. In [creating list-columns], you'll learn the three main ways in which you'll
   create list-columns.
   
1. In [simplifying list-columns] you'll learn how to convert list-columns back
   to regular atomic vectors (or sets of atomic vectors) so you can work
   with them more easily.
   
1. In [making tidy data with broom], you'll learn about the full set of tools
   provided by broom, and see how they can be applied to other types of 
   data structure.

This chapter is somewhat aspirational: if this book is your first introduction to R, this chapter is likely to be a struggle. It requires you have to deeply internalised ideas about modelling, data structures, and iteration. So don't worry if you don't get it --- just put this chapter aside for a few months, and come back when you want to stretch your brain. 

### Prerequisites

Working with many models requires many of the packages of the tidyverse (for data exploration, wrangling, and programming) and modelr to facilitate modelling.


```r
library(modelr)
library(tidyverse)
```
