
When you use a pattern that's a string, it's automatically wrapped into a call to `regex()`:


```r
# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))
```

You can use the other arguments of `regex()` to control details of the match:

*   `ignore_case = TRUE` allows characters to match either their uppercase or 
    lowercase forms. This always uses the current locale.
    
    
```r
    bananas <- c("banana", "Banana", "BANANA")
    str_view(bananas, "banana")
```
    
    
    
\begin{center}

**Figure 17.1**
    
```r
    str_view(bananas, regex("banana", ignore_case = TRUE))
```
    
    

**Figure 17.2** 
    
*   `multiline = TRUE` allows `^` and `$` to match the start and end of each
    line rather than the start and end of the complete string.
    
    
```r
    x <- "Line 1\nLine 2\nLine 3"
    str_extract_all(x, "^Line")[[1]]
    #> [1] "Line"
    str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]
    #> [1] "Line" "Line" "Line"
```
    
*   `comments = TRUE` allows you to use comments and white space to make 
    complex regular expressions more understandable. Spaces are ignored, as is 
    everything after `#`. To match a literal space, you'll need to escape it: 
    `"\\ "`.
    
    
```r
    phone <- regex("
      \\(?     # optional opening parens
      (\\d{3}) # area code
      [) -]?   # optional closing parens, space, or dash
      (\\d{3}) # another three numbers
      [ -]?    # optional space or dash
      (\\d{3}) # three more numbers
      ", comments = TRUE)
    
    str_match("514-791-8141", phone)
    #>      [,1]          [,2]  [,3]  [,4] 
    #> [1,] "514-791-814" "514" "791" "814"
```

*   `dotall = TRUE` allows `.` to match everything, including `\n`.

There are three other functions you can use instead of `regex()`:

*   `fixed()`: matches exactly the specified sequence of bytes. It ignores
    all special regular expressions and operates at a very low level. 
    This allows you to avoid complex escaping and can be much faster than 
    regular expressions. The following microbenchmark shows that it's about
    3x faster for a simple example.
  
    
```r
    microbenchmark::microbenchmark(
      fixed = str_detect(sentences, fixed("the")),
      regex = str_detect(sentences, "the"),
      times = 20
    )
    #> Unit: microseconds
    #>   expr   min    lq mean median  uq max neval
    #>  fixed  72.9  76.7  101   82.7 103 265    20
    #>  regex 256.1 260.8  279  263.9 283 352    20
```
    
    Beware using `fixed()` with non-English data. It is problematic because 
    there are often multiple ways of representing the same character. For 
    example, there are two ways to define "á": either as a single character or 
    as an "a" plus an accent:
    
    
```r
    a1 <- "\u00e1"
    a2 <- "a\u0301"
    c(a1, a2)
    #> [1] "á" "á"
    a1 == a2
    #> [1] FALSE
```

    They render identically, but because they're defined differently, 
    `fixed()` doesn't find a match. Instead, you can use `coll()`, defined
    next, to respect human character comparison rules:

    
```r
    str_detect(a1, fixed(a2))
    #> [1] FALSE
    str_detect(a1, coll(a2))
    #> [1] TRUE
```
    
*   `coll()`: compare strings using standard **coll**ation rules. This is 
    useful for doing case insensitive matching. Note that `coll()` takes a
    `locale` parameter that controls which rules are used for comparing
    characters. Unfortunately different parts of the world use different rules!

    
```r
    # That means you also need to be aware of the difference
    # when doing case insensitive matches:
    i <- c("I", "İ", "i", "ı")
    i
    #> [1] "I" "İ" "i" "ı"
    
    str_subset(i, coll("i", ignore_case = TRUE))
    #> [1] "I" "i"
    str_subset(i, coll("i", ignore_case = TRUE, locale = "tr"))
    #> [1] "İ" "i"
```
    
    Both `fixed()` and `regex()` have `ignore_case` arguments, but they
    do not allow you to pick the locale: they always use the default locale.
    You can see what that is with the following code; more on stringi
    later.
    
    
```r
    stringi::stri_locale_info()
    #> $Language
    #> [1] "en"
    #> 
    #> $Country
    #> [1] "US"
    #> 
    #> $Variant
    #> [1] ""
    #> 
    #> $Name
    #> [1] "en_US"
```
    
    The downside of `coll()` is speed; because the rules for recognising which
    characters are the same are complicated, `coll()` is relatively slow
    compared to `regex()` and `fixed()`.

*   As you saw with `str_split()` you can use `boundary()` to match boundaries.
    You can also use it with the other functions: 
    
    
```r
    x <- "This is a sentence."
    str_view_all(x, boundary("word"))
```
    
    
    
\begin{center}

**Figure 17.3**
    
```r
    str_extract_all(x, boundary("word"))
    #> [[1]]
    #> [1] "This"     "is"       "a"        "sentence"
```

### Exercises

1.  How would you find all strings containing `\` with `regex()` vs.
    with `fixed()`?

1.  What are the five most common words in `sentences`?
