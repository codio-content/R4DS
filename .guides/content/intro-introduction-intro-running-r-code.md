
The previous section showed you a couple of examples of running R code. Code in the book looks like this:


```r
1 + 2
#> [1] 3
#> [1] 3
```

If you run the same code in your local console, it will look like this:

```
> 1 + 2
[1] 3
```

There are two main differences. In your console, you type after the `>`, called the __prompt__; we don't show the prompt in the book. In the book, output is commented out with `#>`; in your console it appears directly after your code. These two differences mean that if you're working with an electronic version of the book, you can easily copy code out of the book and into the console.

Throughout the book we use a consistent set of conventions to refer to code:

* Functions are in a code font and followed by parentheses, like `sum()`, 
  or `mean()`.

* Other R objects (like data or function arguments) are in a code font,
  without parentheses, like `flights` or `x`.
  
* If we want to make it clear what package an object comes from, we'll use
  the package name followed by two colons, like `dplyr::mutate()`, or   
  `nycflights13::flights`. This is also valid R code.
