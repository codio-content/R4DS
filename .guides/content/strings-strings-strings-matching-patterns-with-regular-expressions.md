
Regexps are a very terse language that allow you to describe patterns in strings. They take a little while to get your head around, but once you understand them, you'll find them extremely useful. 

To learn regular expressions, we'll use `str_view()` and `str_view_all()`. These functions take a character vector and a regular expression, and show you how they match. We'll start with very simple regular expressions and then gradually get more and more complicated. Once you've mastered pattern matching, you'll learn how to apply those ideas with various stringr functions.

### Basic matches

The simplest patterns match exact strings:


```r
x <- c("apple", "banana", "pear")
str_view(x, "an")
```



\begin{center}

**Figure 17.1**

The next step up in complexity is `.`, which matches any character (except a newline):


```r
str_view(x, ".a.")
```



\begin{center}

**Figure 17.2**

But if "`.`" matches any character, how do you match the character "`.`"? You need to use an "escape" to tell the regular expression you want to match it exactly, not use its special behaviour. Like strings, regexps use the backslash, `\`, to escape special behaviour. So to match an `.`, you need the regexp `\.`. Unfortunately this creates a problem. We use strings to represent regular expressions, and `\` is also used as an escape symbol in strings. So to create the regular expression `\.` we need the string `"\\."`. 


```r
# To create the regular expression, we need \\
dot <- "\\."

# But the expression itself only contains one:
writeLines(dot)
#> \.

# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")
```



\begin{center}

**Figure 17.3**

If `\` is used as an escape character in regular expressions, how do you match a literal `\`? Well you need to escape it, creating the regular expression `\\`. To create that regular expression, you need to use a string, which also needs to escape `\`. That means to match a literal `\` you need to write `"\\\\"` --- you need four backslashes to match one!


```r
x <- "a\\b"
writeLines(x)
#> a\b

str_view(x, "\\\\")
```



\begin{center}

**Figure 17.4**

In this book, I'll write regular expression as `\.` and strings that represent the regular expression as `"\\."`.

#### Exercises

1.  Explain why each of these strings don't match a `\`: `"\"`, `"\\"`, `"\\\"`.

1.  How would you match the sequence `"'\`?

1.  What patterns will the regular expression `\..\..\..` match? 
    How would you represent it as a string?

### Anchors

By default, regular expressions will match any part of a string. It's often useful to _anchor_ the regular expression so that it matches from the start or end of the string. You can use:

* `^` to match the start of the string.
* `$` to match the end of the string.


```r
x <- c("apple", "banana", "pear")
str_view(x, "^a")
```



\begin{center}

**Figure 17.5**

```r
str_view(x, "a$")
```



**Figure 17.6** 

To remember which is which, try this mnemonic which I learned from [Evan Misshula](https://twitter.com/emisshula/status/323863393167613953): if you begin with power (`^`), you end up with money (`$`).

To force a regular expression to only match a complete string, anchor it with both `^` and `$`:


```r
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
```



\begin{center}

**Figure 17.7**

```r
str_view(x, "^apple$")
```



**Figure 17.8** 

You can also match the boundary between words with `\b`. I don't often use this in R, but I will sometimes use it when I'm doing a search in RStudio when I want to find the name of a function that's a component of other functions. For example, I'll search for `\bsum\b` to avoid matching `summarise`, `summary`, `rowsum` and so on.

#### Exercises

1.  How would you match the literal string `"$^$"`?

1.  Given the corpus of common words in `stringr::words`, create regular
    expressions that find all words that:
    
    1. Start with "y".
    1. End with "x"
    1. Are exactly three letters long. (Don't cheat by using `str_length()`!)
    1. Have seven letters or more.

    Since this list is long, you might want to use the `match` argument to
    `str_view()` to show only the matching or non-matching words.

### Character classes and alternatives

There are a number of special patterns that match more than one character. You've already seen `.`, which matches any character apart from a newline. There are four other useful tools:

* `\d`: matches any digit.
* `\s`: matches any whitespace (e.g. space, tab, newline).
* `[abc]`: matches a, b, or c.
* `[^abc]`: matches anything except a, b, or c.

Remember, to create a regular expression containing `\d` or `\s`, you'll need to escape the `\` for the string, so you'll type `"\\d"` or `"\\s"`.

A character class containing a single character is a nice alternative to backslash escapes when you want to include a single metacharacter in a regex. Many people find this more readable.


```r
# Look for a literal character that normally has special meaning in a regex
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
```



\begin{center}

**Figure 17.9**

```r
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
```



**Figure 17.10** 

```r
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")
```



**Figure 17.11** 

This works for most (but not all) regex metacharacters: `$` `.` `|` `?` `*` `+` `(` `)` `[` `{`. Unfortunately, a few characters have special meaning even inside a character class and must be handled with backslash escapes: `]` `\` `^` and `-`.

You can use _alternation_ to pick between one or more alternative patterns. For example, `abc|d..f` will match either '"abc"', or `"deaf"`. Note that the precedence for `|` is low, so that `abc|xyz` matches `abc` or `xyz` not `abcyz` or `abxyz`. Like with mathematical expressions, if precedence ever gets confusing, use parentheses to make it clear what you want:


```r
str_view(c("grey", "gray"), "gr(e|a)y")
```



\begin{center}

**Figure 17.12**

#### Exercises

1.  Create regular expressions to find all words that:

    1. Start with a vowel.

    1. That only contain consonants. (Hint: thinking about matching 
       "not"-vowels.)

    1. End with `ed`, but not with `eed`.
    
    1. End with `ing` or `ise`.
    
1.  Empirically verify the rule "i before e except after c".

1.  Is "q" always followed by a "u"?

1.  Write a regular expression that matches a word if it's probably written
    in British English, not American English.

1.  Create a regular expression that will match telephone numbers as commonly
    written in your country.

### Repetition

The next step up in power involves controlling how many times a pattern matches:

* `?`: 0 or 1
* `+`: 1 or more
* `*`: 0 or more


```r
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
```



\begin{center}

**Figure 17.13**

```r
str_view(x, "CC+")
```



**Figure 17.14** 

```r
str_view(x, 'C[LX]+')
```



**Figure 17.15** 

Note that the precedence of these operators is high, so you can write: `colou?r` to match either American or British spellings. That means most uses will need parentheses, like `bana(na)+`.

You can also specify the number of matches precisely:

* `{n}`: exactly n
* `{n,}`: n or more
* `{,m}`: at most m
* `{n,m}`: between n and m


```r
str_view(x, "C{2}")
```



\begin{center}

**Figure 17.16**

```r
str_view(x, "C{2,}")
```



**Figure 17.17** 

```r
str_view(x, "C{2,3}")
```



**Figure 17.18** 

By default these matches are "greedy": they will match the longest string possible. You can make them "lazy", matching the shortest string possible by putting a `?` after them. This is an advanced feature of regular expressions, but it's useful to know that it exists:


```r
str_view(x, 'C{2,3}?')
```



\begin{center}

**Figure 17.19**

```r
str_view(x, 'C[LX]+?')
```



**Figure 17.20** 

#### Exercises

1.  Describe the equivalents of `?`, `+`, `*` in `{m,n}` form.

1.  Describe in words what these regular expressions match:
    (read carefully to see if I'm using a regular expression or a string
    that defines a regular expression.)

    1. `^.*$`
    1. `"\\{.+\\}"`
    1. `\d{4}-\d{2}-\d{2}`
    1. `"\\\\{4}"`

1.  Create regular expressions to find all words that:

    1. Start with three consonants.
    1. Have three or more vowels in a row.
    1. Have two or more vowel-consonant pairs in a row.

1.  Solve the beginner regexp crosswords at
    <https://regexcrossword.com/challenges/beginner>.

### Grouping and backreferences

Earlier, you learned about parentheses as a way to disambiguate complex expressions. Parentheses also create a _numbered_ capturing group (number 1, 2 etc.). A capturing group stores _the part of the string_ matched by the part of the regular expression inside the parentheses. You can refer to the same text as previously matched by a capturing group with _backreferences_, like `\1`, `\2` etc. For example, the following regular expression finds all fruits that have a repeated pair of letters.


```r
str_view(fruit, "(..)\\1", match = TRUE)
```



\begin{center}

**Figure 17.21**

(Shortly, you'll also see how they're useful in conjunction with `str_match()`.)

#### Exercises

1.  Describe, in words, what these expressions will match:

    1. `(.)\1\1`
    1. `"(.)(.)\\2\\1"`
    1. `(..)\1`
    1. `"(.).\\1.\\1"`
    1. `"(.)(.)(.).*\\3\\2\\1"`

1.  Construct regular expressions to match words that:

    1. Start and end with the same character.
    
    1. Contain a repeated pair of letters
       (e.g. "church" contains "ch" repeated twice.)
    
    1. Contain one letter repeated in at least three places
       (e.g. "eleven" contains three "e"s.)
