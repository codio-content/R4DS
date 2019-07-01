
Once you have the basic for loop under your belt, there are some variations that you should be aware of. These variations are important regardless of how you do iteration, so don't forget about them once you've mastered the FP techniques you'll learn about in the next section.

There are four variations on the basic theme of the for loop:

1.  Modifying an existing object, instead of creating a new object.
1.  Looping over names or values, instead of indices.
1.  Handling outputs of unknown length.
1.  Handling sequences of unknown length.

### Modifying an existing object

Sometimes you want to use a for loop to modify an existing object. For example, remember our challenge from [functions]. We wanted to rescale every column in a data frame:


```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
```
{Run code | terminal}(Rscript code/for.r)              


To solve this with a for loop we again think about the three components:

1.  __Output__: we already have the output --- it's the same as the input!

1.  __Sequence__: we can think about a data frame as a list of columns, so 
    we can iterate over each column with `seq_along(df)`.

1.  __Body__: apply `rescale01()`.

This gives us:


```r
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
```

Typically you'll be modifying a list or data frame with this sort of loop, so remember to use `[[`, not `[`. You might have spotted that I used `[[` in all my for loops: I think it's better to use `[[` even for atomic vectors because it makes it clear that I want to work with a single element.

### Looping patterns

There are three basic ways to loop over a vector. So far I've shown you the most general: looping over the numeric indices with `for (i in seq_along(xs))`, and extracting the value with `x[[i]]`. There are two other forms:

1.  Loop over the elements: `for (x in xs)`. This is most useful if you only
    care about side-effects, like plotting or saving a file, because it's
    difficult to save the output efficiently.

1.  Loop over the names: `for (nm in names(xs))`. This gives you name, which
    you can use to access the value with `x[[nm]]`. This is useful if you want 
    to use the name in a plot title or a file name. If you're creating
    named output, make sure to name the results vector like so:
    
    
```r
    results <- vector("list", length(x))
    names(results) <- names(x)
```

Iteration over the numeric indices is the most general form, because given the position you can extract both the name and the value:


```r
for (i in seq_along(x)) {
  name <- names(x)[[i]]
  value <- x[[i]]
}
```
{Run code | terminal}(Rscript code/for.r)              


### Unknown output length

Sometimes you might not know how long the output will be. For example, imagine you want to simulate some random vectors of random lengths. You might be tempted to solve this problem by progressively growing the vector:


```r
means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)
#>  num [1:202] 0.912 0.205 2.584 -0.789 0.588 ...
```

But this is not very efficient because in each iteration, R has to copy all the data from the previous iterations. In technical terms you get "quadratic" ($O(n^2)$) behaviour which means that a loop with three times as many elements would take nine ($3^2$) times as long to run.

A better solution to save the results in a list, and then combine into a single vector after the loop is done:


```r
out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
#> List of 3
#>  $ : num [1:83] 0.367 1.13 -0.941 0.218 1.415 ...
#>  $ : num [1:21] -0.485 -0.425 2.937 1.688 1.324 ...
#>  $ : num [1:40] 2.34 1.59 2.93 3.84 1.3 ...
str(unlist(out))
#>  num [1:144] 0.367 1.13 -0.941 0.218 1.415 ...
```
{Run code | terminal}(Rscript code/for.r)              


Here I've used `unlist()` to flatten a list of vectors into a single vector. A stricter option is to use `purrr::flatten_dbl()` --- it will throw an error if the input isn't a list of doubles.

This pattern occurs in other places too:

1.  You might be generating a long string. Instead of `paste()`ing together 
    each iteration with the previous, save the output in a character vector and
    then combine that vector into a single string with 
    `paste(output, collapse = "")`.
   
1.  You might be generating a big data frame. Instead of sequentially
    `rbind()`ing in each iteration, save the output in a list, then use 
    `dplyr::bind_rows(output)` to combine the output into a single
    data frame.

Watch out for this pattern. Whenever you see it, switch to a more complex result object, and then combine in one step at the end.

### Unknown sequence length

Sometimes you don't even know how long the input sequence should run for. This is common when doing simulations. For example, you might want to loop until you get three heads in a row. You can't do that sort of iteration with the for loop. Instead, you can use a while loop. A while loop is simpler than for loop because it only has two components, a condition and a body:


```r
while (condition) {
  # body
}
```

A while loop is also more general than a for loop, because you can rewrite any for loop as a while loop, but you can't rewrite every while loop as a for loop:


```r
for (i in seq_along(x)) {
  # body
}

# Equivalent to
i <- 1
while (i <= length(x)) {
  # body
  i <- i + 1 
}
```

Here's how we could use a while loop to find how many tries it takes to get three heads in a row:


```r
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips
#> [1] 3
```
{Run code | terminal}(Rscript code/for.r)              


I mention while loops only briefly, because I hardly ever use them. They're most often used for simulation, which is outside the scope of this book. However, it is good to know they exist so that you're prepared for problems where the number of iterations is not known in advance.

### Exercises

1.  Imagine you have a directory full of CSV files that you want to read in.
    You have their paths in a vector, 
    `files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)`, and now
    want to read each one with `read_csv()`. Write the for loop that will 
    load them into a single data frame. 

1.  What happens if you use `for (nm in names(x))` and `x` has no names?
    What if only some of the elements are named? What if the names are
    not unique?

1.  Write a function that prints the mean of each numeric column in a data 
    frame, along with its name. For example, `show_mean(iris)` would print:
    
    
```r
    show_mean(iris)
    #> Sepal.Length: 5.84
    #> Sepal.Width:  3.06
    #> Petal.Length: 3.76
    #> Petal.Width:  1.20
```
    
    (Extra challenge: what function did I use to make sure that the numbers
    lined up nicely, even though the variable names had different lengths?)

1.  What does this code do? How does it work?

    
```r
    trans <- list( 
      disp = function(x) x * 0.0163871,
      am = function(x) {
        factor(x, labels = c("auto", "manual"))
      }
    )
    for (var in names(trans)) {
      mtcars[[var]] <- trans[[var]](mtcars[[var]])
    }
```
