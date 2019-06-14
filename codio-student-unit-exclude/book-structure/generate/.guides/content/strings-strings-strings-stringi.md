
stringr is built on top of the __stringi__ package. stringr is useful when you're learning because it exposes a minimal set of functions, which have been carefully picked to handle the most common string manipulation functions. stringi, on the other hand, is designed to be comprehensive. It contains almost every function you might ever need: stringi has 244 functions to stringr's 49.

If you find yourself struggling to do something in stringr, it's worth taking a look at stringi. The packages work very similarly, so you should be able to translate your stringr knowledge in a natural way. The main difference is the prefix: `str_` vs. `stri_`.

### Exercises

1.  Find the stringi functions that:

    1. Count the number of words.
    1. Find duplicated strings.
    1. Generate random text.

1.  How do you control the language that `stri_sort()` uses for 
    sorting?