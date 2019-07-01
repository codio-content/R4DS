
The point of the pipe is to help you write code in a way that is easier to read and understand. To see why the pipe is so useful, we're going to explore a number of ways of writing the same code. Let's use code to tell a story about a little bunny named Foo Foo:

> Little bunny Foo Foo  
> Went hopping through the forest  
> Scooping up the field mice  
> And bopping them on the head  

This is a popular Children's poem that is accompanied by hand actions.

We'll start by defining an object to represent little bunny Foo Foo:


```r
foo_foo <- little_bunny()
```
{Run code | terminal}(Rscript code/pipes.r)              


And we'll use a function for each key verb: `hop()`, `scoop()`, and `bop()`. Using this object and these verbs, there are (at least) four ways we could retell the story in code:

1. Save each intermediate step as a new object.
1. Overwrite the original object many times.
1. Compose functions.
1. Use the pipe.

We'll work through each approach, showing you the code and talking about the advantages and disadvantages.

### Intermediate steps

The simplest approach is to save each step as a new object:


```r
foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)
```

The main downside of this form is that it forces you to name each intermediate element. If there are natural names, this is a good idea, and you should do it. But many times, like this in this example, there aren't natural names, and you add numeric suffixes to make the names unique. That leads to two problems:

1. The code is cluttered with unimportant names

1. You have to carefully increment the suffix on each line. 

Whenever I write code like this, I invariably use the wrong number on one line and then spend 10 minutes scratching my head and trying to figure out what went wrong with my code.

You may also worry that this form creates many copies of your data and takes up a lot of memory. Surprisingly, that's not the case. First, note that proactively worrying about memory is not a useful way to spend your time: worry about it when it becomes a problem (i.e. you run out of memory), not before. Second, R isn't stupid, and it will share columns across data frames, where possible. Let's take a look at an actual data manipulation pipeline where we add a new column to `ggplot2::diamonds`:


```r
diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>% 
  dplyr::mutate(price_per_carat = price / carat)

pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 3.89 MB
```
{Run code | terminal}(Rscript code/pipes.r)
 
 [Refresh plot](close_preview Rplots.pdf panel=1; open_preview Rplots.pdf panel=1)


`pryr::object_size()` gives the memory occupied by all of its arguments. The results seem counterintuitive at first:

* `diamonds` takes up 3.46 MB,
* `diamonds2` takes up 3.89 MB,
* `diamonds` and `diamonds2` together take up 3.89 MB!

How can that work? Well, `diamonds2` has 10 columns in common with `diamonds`: there's no need to duplicate all that data, so the two data frames have variables in common. These variables will only get copied if you modify one of them. In the following example, we modify a single value in `diamonds$carat`. That means the `carat` variable can no longer be shared between the two data frames, and a copy must be made. The size of each data frame is unchanged, but the collective size increases:


```r
diamonds$carat[1] <- NA
pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 4.32 MB
```

(Note that we use `pryr::object_size()` here, not the built-in `object.size()`. `object.size()` only takes a single object so it can't compute how data is shared across multiple objects.)

### Overwrite the original

Instead of creating intermediate objects at each step, we could overwrite the original object:


```r
foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)
```
{Run code | terminal}(Rscript code/pipes.r)              


This is less typing (and less thinking), so you're less likely to make mistakes. However, there are two problems:

1.  Debugging is painful: if you make a mistake you'll need to re-run the 
    complete pipeline from the beginning.
    
1.  The repetition of the object being transformed (we've written `foo_foo` six 
    times!) obscures what's changing on each line. 

### Function composition

Another approach is to abandon assignment and just string the function calls together:


```r
bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ), 
  on = head
)
```

Here the disadvantage is that you have to read from inside-out, from right-to-left, and that the arguments end up spread far apart (evocatively called the 
[dagwood sandwhich](https://en.wikipedia.org/wiki/Dagwood_sandwich) problem). In short, this code is hard for a human to consume.

### Use the pipe 

Finally, we can use the pipe:


```r
foo_foo %>%
  hop(through = forest) %>%
  scoop(up = field_mice) %>%
  bop(on = head)
```
{Run code | terminal}(Rscript code/pipes.r)              


This is my favourite form, because it focusses on verbs, not nouns. You can read this series of function compositions like it's a set of imperative actions. Foo Foo hops, then scoops, then bops. The downside, of course, is that you need to be familiar with the pipe. If you've never seen `%>%` before, you'll have no idea what this code does. Fortunately, most people pick up the idea very quickly, so when you share your code with others who aren't familiar with the pipe, you can easily teach them.

The pipe works by performing a "lexical transformation": behind the scenes, magrittr reassembles the code in the pipe to a form that works by overwriting an intermediate object. When you run a pipe like the one above, magrittr does something like this:


```r
my_pipe <- function(.) {
  . <- hop(., through = forest)
  . <- scoop(., up = field_mice)
  bop(., on = head)
}
my_pipe(foo_foo)
```

This means that the pipe won't work for two classes of functions:

1.  Functions that use the current environment. For example, `assign()`
    will create a new variable with the given name in the current environment:
     
    
```r
    assign("x", 10)
    x
    #> [1] 10
    
    "x" %>% assign(100)
    x
    #> [1] 10
```
    
    The use of assign with the pipe does not work because it assigns it to 
    a temporary environment used by `%>%`. If you do want to use assign with the
    pipe, you must be explicit about the environment:
    
    
```r
    env <- environment()
    "x" %>% assign(100, envir = env)
    x
    #> [1] 100
```
{Run code | terminal}(Rscript code/pipes.r)              

    
    Other functions with this problem include `get()` and `load()`.

1.  Functions that use lazy evaluation. In R, function arguments
    are only computed when the function uses them, not prior to calling the 
    function. The pipe computes each element in turn, so you can't 
    rely on this behaviour.
    
    One place that this is a problem is `tryCatch()`, which lets you capture
    and handle errors:
    
    
```r
    tryCatch(stop("!"), error = function(e) "An error")
    #> [1] "An error"
    
    stop("!") %>% 
      tryCatch(error = function(e) "An error")
    #> Error in eval(lhs, parent, parent): !
```
    
    There are a relatively wide class of functions with this behaviour,
    including `try()`, `suppressMessages()`, and `suppressWarnings()`
    in base R.
  