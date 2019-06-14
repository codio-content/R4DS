
There are two types of vectors:

1. __Atomic__ vectors, of which there are six types:
  __logical__, __integer__, __double__,  __character__, __complex__, and 
  __raw__. Integer and double vectors are collectively known as
  __numeric__ vectors. 

1. __Lists__,  which are sometimes called recursive vectors because lists can 
  contain other lists. 

The chief difference between atomic vectors and lists is that atomic vectors are __homogeneous__, while lists can be __heterogeneous__. There's one other related object: `NULL`. `NULL` is often used to represent the absence of a vector (as opposed to `NA` which is used to represent the absence of a value in a vector). `NULL` typically behaves like a vector of length 0. Figure \@ref(fig:datatypes) summarises the interrelationships. 

![Figure 24.1The hierarchy of R's vector types](diagrams/data-structures-overview)

**Figure 24.1The hierarchy of R's vector types**

Every vector has two key properties: 

1.  Its __type__, which you can determine with `typeof()`.

    
```r
    typeof(letters)
    #> [1] "character"
    typeof(1:10)
    #> [1] "integer"
```

1. Its __length__, which you can determine with `length()`.

    
```r
    x <- list("a", "b", 1:10)
    length(x)
    #> [1] 3
```

Vectors can also contain arbitrary additional metadata in the form of attributes. These attributes are used to create __augmented vectors__ which build on additional behaviour. There are three important types of augmented vector:

* Factors are built on top of integer vectors.
* Dates and date-times are built on top of numeric vectors.
* Data frames and tibbles are built on top of lists.

This chapter will introduce you to these important vectors from simplest to most complicated. You'll start with atomic vectors, then build up to lists, and finish off with augmented vectors.
