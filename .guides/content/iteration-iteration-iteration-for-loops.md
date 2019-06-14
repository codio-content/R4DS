
Imagine we have this simple tibble:


```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
```

We want to compute the median of each column. You _could_ do with copy-and-paste:


```r
median(df$a)
#> [1] -0.246
median(df$b)
#> [1] -0.287
median(df$c)
#> [1] -0.0567
median(df$d)
#> [1] 0.144
```

But that breaks our rule of thumb: never copy and paste more than twice. Instead, we could use a for loop:


```r
output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
#> [1] -0.2458 -0.2873 -0.0567  0.1443
```

Every for loop has three components:

1.  The __output__: `output <- vector("double", length(x))`. 
    Before you start the loop, you must always allocate sufficient space 
    for the output. This is very important for efficiency: if you grow
    the for loop at each iteration using `c()` (for example), your for loop 
    will be very slow. 
    
    A general way of creating an empty vector of given length is the `vector()`
    function. It has two arguments: the type of the vector ("logical", 
    "integer", "double", "character", etc) and the length of the vector. 

1.  The __sequence__: `i in seq_along(df)`. This determines what to loop over:
    each run of the for loop will assign `i` to a different value from 
    `seq_along(df)`. It's useful to think of `i` as a pronoun, like "it".
    
    You might not have seen `seq_along()` before. It's a safe version of the 
    familiar `1:length(l)`, with an important difference: if you have a
    zero-length vector, `seq_along()` does the right thing:

    
```r
    y <- vector("double", 0)
    seq_along(y)
    #> integer(0)
    1:length(y)
    #> [1] 1 0
```
    
    You probably won't create a zero-length vector deliberately, but
    it's easy to create them accidentally. If you use `1:length(x)` instead
    of `seq_along(x)`, you're likely to get a confusing error message.
    
1.  The __body__: `output[[i]] <- median(df[[i]])`. This is the code that does
    the work. It's run repeatedly, each time with a different value for `i`.
    The first iteration will run `output[[1]] <- median(df[[1]])`, 
    the second will run `output[[2]] <- median(df[[2]])`, and so on.

That's all there is to the for loop! Now is a good time to practice creating some basic (and not so basic) for loops using the exercises below. Then we'll move on some variations of the for loop that help you solve other problems that will crop up in practice. 

### Exercises

1.  Write for loops to:

    1. Compute the mean of every column in `mtcars`.
    1. Determine the type of each column in `nycflights13::flights`.
    1. Compute the number of unique values in each column of `iris`.
    1. Generate 10 random normals for each of $\mu = -10$, $0$, $10$, and $100$.
    
    Think about the output, sequence, and body __before__ you start writing
    the loop.

1.  Eliminate the for loop in each of the following examples by taking 
    advantage of an existing function that works with vectors:
    
    
```r
    out <- ""
    for (x in letters) {
      out <- stringr::str_c(out, x)
    }
    
    x <- sample(100)
    sd <- 0
    for (i in seq_along(x)) {
      sd <- sd + (x[i] - mean(x)) ^ 2
    }
    sd <- sqrt(sd / (length(x) - 1))
    
    x <- runif(100)
    out <- vector("numeric", length(x))
    out[1] <- x[1]
    for (i in 2:length(x)) {
      out[i] <- out[i - 1] + x[i]
    }
```

1.  Combine your function writing and for loop skills:

    1. Write a for loop that `prints()` the lyrics to the children's song 
       "Alice the camel".

    1. Convert the nursery rhyme "ten in the bed" to a function. Generalise 
       it to any number of people in any sleeping structure.

    1. Convert the song "99 bottles of beer on the wall" to a function.
       Generalise to any number of any vessel containing any liquid on 
       any surface.

1.  It's common to see for loops that don't preallocate the output and instead
    increase the length of a vector at each step:
    
    
```r
    output <- vector("integer", 0)
    for (i in seq_along(x)) {
      output <- c(output, lengths(x[[i]]))
    }
    output
```
    
    How does this affect performance? Design and execute an experiment.
