
You can create strings with either single quotes or double quotes. Unlike other languages, there is no difference in behaviour. I recommend always using `"`, unless you want to create a string that contains multiple `"`.


```r
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
```

If you forget to close a quote, you'll see `+`, the continuation character:

```
> "This is a string without a closing quote
+ 
+ 
+ HELP I'M STUCK
```

If this happen to you, press Escape and try again!

To include a literal single or double quote in a string you can use `\` to "escape" it:


```r
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"
```

That means if you want to include a literal backslash, you'll need to double it up: `"\\"`.

Beware that the printed representation of a string is not the same as string itself, because the printed representation shows the escapes. To see the raw contents of the string, use `writeLines()`:


```r
x <- c("\"", "\\")
x
#> [1] "\"" "\\"
writeLines(x)
#> "
#> \
```

There are a handful of other special characters. The most common are `"\n"`, newline, and `"\t"`, tab, but you can see the complete list by requesting help on `"`: `?'"'`, or `?"'"`. You'll also sometimes see strings like `"\u00b5"`, this is a way of writing non-English characters that works on all platforms:


```r
x <- "\u00b5"
x
#> [1] "µ"
```

Multiple strings are often stored in a character vector, which you can create with `c()`:


```r
c("one", "two", "three")
#> [1] "one"   "two"   "three"
```

### String length

Base R contains many functions to work with strings but we'll avoid them because they can be inconsistent, which makes them hard to remember. Instead we'll use functions from stringr. These have more intuitive names, and all start with `str_`. For example, `str_length()` tells you the number of characters in a string:


```r
str_length(c("a", "R for data science", NA))
#> [1]  1 18 NA
```

The common `str_` prefix is particularly useful if you use RStudio, because typing `str_` will trigger autocomplete, allowing you to see all stringr functions:


![Figure 17.1](screenshots/stringr-autocomplete.png)

**Figure 17.1**

### Combining strings

To combine two or more strings, use `str_c()`:


```r
str_c("x", "y")
#> [1] "xy"
str_c("x", "y", "z")
#> [1] "xyz"
```

Use the `sep` argument to control how they're separated:


```r
str_c("x", "y", sep = ", ")
#> [1] "x, y"
```

Like most other functions in R, missing values are contagious. If you want them to print as `"NA"`, use `str_replace_na()`:


```r
x <- c("abc", NA)
str_c("|-", x, "-|")
#> [1] "|-abc-|" NA
str_c("|-", str_replace_na(x), "-|")
#> [1] "|-abc-|" "|-NA-|"
```

As shown above, `str_c()` is vectorised, and it automatically recycles shorter vectors to the same length as the longest:


```r
str_c("prefix-", c("a", "b", "c"), "-suffix")
#> [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"
```

Objects of length 0 are silently dropped. This is particularly useful in conjunction with `if`:


```r
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)
#> [1] "Good morning Hadley."
```

To collapse a vector of strings into a single string, use `collapse`:


```r
str_c(c("x", "y", "z"), collapse = ", ")
#> [1] "x, y, z"
```

### Subsetting strings

You can extract parts of a string using `str_sub()`. As well as the string, `str_sub()` takes `start` and `end` arguments which give the (inclusive) position of the substring:


```r
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
#> [1] "App" "Ban" "Pea"
# negative numbers count backwards from end
str_sub(x, -3, -1)
#> [1] "ple" "ana" "ear"
```

Note that `str_sub()` won't fail if the string is too short: it will just return as much as possible:


```r
str_sub("a", 1, 5)
#> [1] "a"
```

You can also use the assignment form of `str_sub()` to modify strings:


```r
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
#> [1] "apple"  "banana" "pear"
```

### Locales

Above I used `str_to_lower()` to change the text to lower case. You can also use `str_to_upper()` or `str_to_title()`. However, changing case is more complicated than it might at first appear because different languages have different rules for changing case. You can pick which set of rules to use by specifying a locale:


```r
# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalising them:
str_to_upper(c("i", "ı"))
#> [1] "I" "I"
str_to_upper(c("i", "ı"), locale = "tr")
#> [1] "İ" "I"
```

The locale is specified as a ISO 639 language code, which is a two or three letter abbreviation. If you don't already know the code for your language, [Wikipedia](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) has a good list. If you leave the locale blank, it will use the current locale, as provided by your operating system.

Another important operation that's affected by the locale is sorting. The base R `order()` and `sort()` functions sort strings using the current locale. If you want robust behaviour across different computers, you may want to use `str_sort()` and `str_order()` which take an additional `locale` argument:


```r
x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "en")  # English
#> [1] "apple"    "banana"   "eggplant"

str_sort(x, locale = "haw") # Hawaiian
#> [1] "apple"    "eggplant" "banana"
```

### Exercises

1.  In code that doesn't use stringr, you'll often see `paste()` and `paste0()`.
    What's the difference between the two functions? What stringr function are
    they equivalent to? How do the functions differ in their handling of 
    `NA`?
    
1.  In your own words, describe the difference between the `sep` and `collapse`
    arguments to `str_c()`.

1.  Use `str_length()` and `str_sub()` to extract the middle character from 
    a string. What will you do if the string has an even number of characters?

1.  What does `str_wrap()` do? When might you want to use it?

1.  What does `str_trim()` do? What's the opposite of `str_trim()`?

1.  Write a function that turns (e.g.) a vector `c("a", "b", "c")` into 
    the string `a, b, and c`. Think carefully about what it should do if
    given a vector of length 0, 1, or 2.
