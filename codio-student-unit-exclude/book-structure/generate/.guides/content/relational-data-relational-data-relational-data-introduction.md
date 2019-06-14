
It's rare that a data analysis involves only a single table of data. Typically you have many tables of data, and you must combine them to answer the questions that you're interested in. Collectively, multiple tables of data are called __relational data__ because it is the relations, not just the individual datasets, that are important.

Relations are always defined between a pair of tables. All other relations are built up from this simple idea: the relations of three or more tables are always a property of the relations between each pair. Sometimes both elements of a pair can be the same table! This is needed if, for example, you have a table of people, and each person has a reference to their parents.

To work with relational data you need verbs that work with pairs of tables. There are three families of verbs designed to work with relational data:

* __Mutating joins__, which add new variables to one data frame from matching
  observations in another.

* __Filtering joins__, which filter observations from one data frame based on
  whether or not they match an observation in the other table.

* __Set operations__, which treat observations as if they were set elements.

The most common place to find relational data is in a _relational_ database management system (or RDBMS), a term that encompasses almost all modern databases. If you've used a database before, you've almost certainly used SQL. If so, you should find the concepts in this chapter familiar, although their expression in dplyr is a little different. Generally, dplyr is a little easier to use than SQL because dplyr is specialised to do data analysis: it makes common data analysis operations easier, at the expense of making it more difficult to do other things that aren't commonly needed for data analysis.

### Prerequisites

We will explore relational data from `nycflights13` using the two-table verbs from dplyr.


```r
library(tidyverse)
library(nycflights13)
```
