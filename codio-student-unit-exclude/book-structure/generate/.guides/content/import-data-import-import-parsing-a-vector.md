
Before we get into the details of how readr reads files from disk, we need to take a little detour to talk about the `parse_*()` functions. These functions take a character vector and return a more specialised vector like a logical, integer, or date:


```r
str(parse_logical(c("TRUE", "FALSE", "NA")))
#>  logi [1:3] TRUE FALSE NA
str(parse_integer(c("1", "2", "3")))
#>  int [1:3] 1 2 3
str(parse_date(c("2010-01-01", "1979-10-14")))
#>  Date[1:2], format: "2010-01-01" "1979-10-14"
```

These functions are useful in their own right, but are also an important building block for readr. Once you've learned how the individual parsers work in this section, we'll circle back and see how they fit together to parse a complete file in the next section.

Like all functions in the tidyverse, the `parse_*()` functions are uniform: the first argument is a character vector to parse, and the `na` argument specifies which strings should be treated as missing:


```r
parse_integer(c("1", "231", ".", "456"), na = ".")
#> [1]   1 231  NA 456
```

If parsing fails, you'll get a warning:


```r
x <- parse_integer(c("123", "345", "abc", "123.45"))
#> Warning: 2 parsing failures.
#> row col               expected actual
#>   3  -- an integer                abc
#>   4  -- no trailing characters    .45
```

And the failures will be missing in the output:


```r
x
#> [1] 123 345  NA  NA
#> attr(,"problems")
#> # A tibble: 2 x 4
#>     row   col expected               actual
#>   <int> <int> <chr>                  <chr> 
#> 1     3    NA an integer             abc   
#> 2     4    NA no trailing characters .45
```

If there are many parsing failures, you'll need to use `problems()` to get the complete set. This returns a tibble, which you can then manipulate with dplyr.


```r
problems(x)
#> # A tibble: 2 x 4
#>     row   col expected               actual
#>   <int> <int> <chr>                  <chr> 
#> 1     3    NA an integer             abc   
#> 2     4    NA no trailing characters .45
```

Using parsers is mostly a matter of understanding what's available and how they deal with different types of input. There are eight particularly important parsers:

1.  `parse_logical()` and `parse_integer()` parse logicals and integers
    respectively. There's basically nothing that can go wrong with these
    parsers so I won't describe them here further.
    
1.  `parse_double()` is a strict numeric parser, and `parse_number()` 
    is a flexible numeric parser. These are more complicated than you might
    expect because different parts of the world write numbers in different
    ways.
    
1.  `parse_character()` seems so simple that it shouldn't be necessary. But
    one complication makes it quite important: character encodings.

1.  `parse_factor()` create factors, the data structure that R uses to represent
    categorical variables with fixed and known values.

1.  `parse_datetime()`, `parse_date()`, and `parse_time()` allow you to
    parse various date & time specifications. These are the most complicated
    because there are so many different ways of writing dates.

The following sections describe these parsers in more detail.

### Numbers

It seems like it should be straightforward to parse a number, but three problems make it tricky:

1. People write numbers differently in different parts of the world.
   For example, some countries use `.` in between the integer and fractional 
   parts of a real number, while others use `,`.
   
1. Numbers are often surrounded by other characters that provide some
   context, like "$1000" or "10%".

1. Numbers often contain "grouping" characters to make them easier to read, 
   like "1,000,000", and these grouping characters vary around the world.

To address the first problem, readr has the notion of a "locale", an object that specifies parsing options that differ from place to place. When parsing numbers, the most important option is the character you use for the decimal mark. You can override the default value of `.` by creating a new locale and setting the `decimal_mark` argument:


```r
parse_double("1.23")
#> [1] 1.23
parse_double("1,23", locale = locale(decimal_mark = ","))
#> [1] 1.23
```

readr's default locale is US-centric, because generally R is US-centric (i.e. the documentation of base R is written in American English). An alternative approach would be to try and guess the defaults from your operating system. This is hard to do well, and, more importantly, makes your code fragile: even if it works on your computer, it might fail when you email it to a colleague in another country.

`parse_number()` addresses the second problem: it ignores non-numeric characters before and after the number. This is particularly useful for currencies and percentages, but also works to extract numbers embedded in text.


```r
parse_number("$100")
#> [1] 100
parse_number("20%")
#> [1] 20
parse_number("It cost $123.45")
#> [1] 123
```

The final problem is addressed by the combination of `parse_number()` and the locale as `parse_number()` will ignore the "grouping mark":


```r
# Used in America
parse_number("$123,456,789")
#> [1] 1.23e+08

# Used in many parts of Europe
parse_number("123.456.789", locale = locale(grouping_mark = "."))
#> [1] 1.23e+08

# Used in Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))
#> [1] 1.23e+08
```

### Strings {#readr-strings}

It seems like `parse_character()` should be really simple --- it could just return its input. Unfortunately life isn't so simple, as there are multiple ways to represent the same string. To understand what's going on, we need to dive into the details of how computers represent strings. In R, we can get at the underlying representation of a string using `charToRaw()`:


```r
charToRaw("Hadley")
#> [1] 48 61 64 6c 65 79
```

Each hexadecimal number represents a byte of information: `48` is H, `61` is a, and so on. The mapping from hexadecimal number to character is called the encoding, and in this case the encoding is called ASCII. ASCII does a great job of representing English characters, because it's the __American__ Standard Code for Information Interchange.

Things get more complicated for languages other than English. In the early days of computing there were many competing standards for encoding non-English characters, and to correctly interpret a string you needed to know both the values and the encoding. For example, two common encodings are Latin1 (aka ISO-8859-1, used for Western European languages) and Latin2 (aka ISO-8859-2, used for Eastern European languages). In Latin1, the byte `b1` is "±", but in Latin2, it's "ą"! Fortunately, today there is one standard that is supported almost everywhere: UTF-8. UTF-8 can encode just about every character used by humans today, as well as many extra symbols (like emoji!).

readr uses UTF-8 everywhere: it assumes your data is UTF-8 encoded when you read it, and always uses it when writing. This is a good default, but will fail for data produced by older systems that don't understand UTF-8. If this happens to you, your strings will look weird when you print them. Sometimes just one or two characters might be messed up; other times you'll get complete gibberish. For example:


```r
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

x1
#> [1] "El Ni\xf1o was particularly bad this year"
x2
#> [1] "\x82\xb1\x82\xf1\x82\u0242\xbf\x82\xcd"
```

To fix the problem you need to specify the encoding in `parse_character()`:


```r
parse_character(x1, locale = locale(encoding = "Latin1"))
#> [1] "El Niño was particularly bad this year"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
#> [1] "こんにちは"
```

How do you find the correct encoding? If you're lucky, it'll be included somewhere in the data documentation. Unfortunately, that's rarely the case, so readr provides  `guess_encoding()` to help you figure it out. It's not foolproof, and it works better when you have lots of text (unlike here), but it's a reasonable place to start. Expect to try a few different encodings before you find the right one.


```r
guess_encoding(charToRaw(x1))
#> # A tibble: 2 x 2
#>   encoding   confidence
#>   <chr>           <dbl>
#> 1 ISO-8859-1       0.46
#> 2 ISO-8859-9       0.23
guess_encoding(charToRaw(x2))
#> # A tibble: 1 x 2
#>   encoding confidence
#>   <chr>         <dbl>
#> 1 KOI8-R         0.42
```

The first argument to `guess_encoding()` can either be a path to a file, or, as in this case, a raw vector (useful if the strings are already in R).

Encodings are a rich and complex topic, and I've only scratched the surface here. If you'd like to learn more I'd recommend reading the detailed explanation at <http://kunststube.net/encoding/>.

### Factors {#readr-factors}

R uses factors to represent categorical variables that have a known set of possible values. Give `parse_factor()` a vector of known `levels` to generate a warning whenever an unexpected value is present:


```r
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
#> Warning: 1 parsing failure.
#> row col           expected   actual
#>   3  -- value in level set bananana
#> [1] apple  banana <NA>  
#> attr(,"problems")
#> # A tibble: 1 x 4
#>     row   col expected           actual  
#>   <int> <int> <chr>              <chr>   
#> 1     3    NA value in level set bananana
#> Levels: apple banana
```

But if you have many problematic entries, it's often easier to leave as character vectors and then use the tools you'll learn about in [strings] and [factors] to clean them up.

### Dates, date-times, and times {#readr-datetimes}

You pick between three parsers depending on whether you want a date (the number of days since 1970-01-01), a date-time (the number of seconds since midnight 1970-01-01), or a time (the number of seconds since midnight). When called without any additional arguments:

*   `parse_datetime()` expects an ISO8601 date-time. ISO8601 is an
    international standard in which the components of a date are
    organised from biggest to smallest: year, month, day, hour, minute, 
    second.
    
    
```r
    parse_datetime("2010-10-01T2010")
    #> [1] "2010-10-01 20:10:00 UTC"
    # If time is omitted, it will be set to midnight
    parse_datetime("20101010")
    #> [1] "2010-10-10 UTC"
```
    
    This is the most important date/time standard, and if you work with
    dates and times frequently, I recommend reading
    <https://en.wikipedia.org/wiki/ISO_8601>
    
*   `parse_date()` expects a four digit year, a `-` or `/`, the month, a `-` 
    or `/`, then the day:
    
    
```r
    parse_date("2010-10-01")
    #> [1] "2010-10-01"
```

*   `parse_time()` expects the hour, `:`, minutes, optionally `:` and seconds, 
    and an optional am/pm specifier:
  
    
```r
    library(hms)
    parse_time("01:10 am")
    #> 01:10:00
    parse_time("20:10:01")
    #> 20:10:01
```
    
    Base R doesn't have a great built in class for time data, so we use 
    the one provided in the hms package.

If these defaults don't work for your data you can supply your own date-time `format`, built up of the following pieces:

Year
: `%Y` (4 digits). 
: `%y` (2 digits); 00-69 -> 2000-2069, 70-99 -> 1970-1999.

Month
: `%m` (2 digits).
: `%b` (abbreviated name, like "Jan").
: `%B` (full name, "January").

Day
: `%d` (2 digits).
: `%e` (optional leading space).

Time
: `%H` 0-23 hour.
: `%I` 0-12, must be used with `%p`.
: `%p` AM/PM indicator.
: `%M` minutes.
: `%S` integer seconds.
: `%OS` real seconds. 
: `%Z` Time zone (as name, e.g. `America/Chicago`). Beware of abbreviations:
  if you're American, note that "EST" is a Canadian time zone that does not
  have daylight savings time. It is _not_ Eastern Standard Time! We'll
  come back to this [time zones].
: `%z` (as offset from UTC, e.g. `+0800`). 

Non-digits
: `%.` skips one non-digit character.
: `%*` skips any number of non-digits.

The best way to figure out the correct format is to create a few examples in a character vector, and test with one of the parsing functions. For example:


```r
parse_date("01/02/15", "%m/%d/%y")
#> [1] "2015-01-02"
parse_date("01/02/15", "%d/%m/%y")
#> [1] "2015-02-01"
parse_date("01/02/15", "%y/%m/%d")
#> [1] "2001-02-15"
```

If you're using `%b` or `%B` with non-English month names, you'll need to set the  `lang` argument to `locale()`. See the list of built-in languages in `date_names_langs()`, or if your language is not already included, create your own with `date_names()`.


```r
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
#> [1] "2015-01-01"
```

### Exercises

1.  What are the most important arguments to `locale()`? 

1.  What happens if you try and set `decimal_mark` and `grouping_mark` 
    to the same character? What happens to the default value of 
    `grouping_mark` when you set `decimal_mark` to ","? What happens
    to the default value of `decimal_mark` when you set the `grouping_mark`
    to "."?

1.  I didn't discuss the `date_format` and `time_format` options to
    `locale()`. What do they do? Construct an example that shows when 
    they might be useful.

1.  If you live outside the US, create a new locale object that encapsulates 
    the settings for the types of file you read most commonly.
    
1.  What's the difference between `read_csv()` and `read_csv2()`?
    
1.  What are the most common encodings used in Europe? What are the
    most common encodings used in Asia? Do some googling to find out.

1.  Generate the correct format string to parse each of the following 
    dates and times:
    
    
```r
    d1 <- "January 1, 2010"
    d2 <- "2015-Mar-07"
    d3 <- "06-Jun-2017"
    d4 <- c("August 19 (2015)", "July 1 (2015)")
    d5 <- "12/30/14" # Dec 30, 2014
    t1 <- "1705"
    t2 <- "11:15:10.12 PM"
```
