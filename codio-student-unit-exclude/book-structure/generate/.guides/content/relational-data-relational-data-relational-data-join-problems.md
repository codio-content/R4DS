
The data you've been working with in this chapter has been cleaned up so that you'll have as few problems as possible. Your own data is unlikely to be so nice, so there are a few things that you should do with your own data to make your joins go smoothly.

1.  Start by identifying the variables that form the primary key in each table.
    You should usually do this based on your understanding of the data, not
    empirically by looking for a combination of variables that give a
    unique identifier. If you just look for variables without thinking about
    what they mean, you might get (un)lucky and find a combination that's
    unique in your current data but the relationship might not be true in
    general.

    For example, the altitude and longitude uniquely identify each airport,
    but they are not good identifiers!

    
```r
    airports %>% count(alt, lon) %>% filter(n > 1)
    #> # A tibble: 0 x 3
    #> # ... with 3 variables: alt <int>, lon <dbl>, n <int>
```
{Run code | terminal}(Rscript code/joinProbs.r)


1.  Check that none of the variables in the primary key are missing. If
    a value is missing then it can't identify an observation!

1.  Check that your foreign keys match primary keys in another table. The
    best way to do this is with an `anti_join()`. It's common for keys
    not to match because of data entry errors. Fixing these is often a lot of
    work.

    If you do have missing keys, you'll need to be thoughtful about your
    use of inner vs. outer joins, carefully considering whether or not you
    want to drop rows that don't have a match.

Be aware that simply checking the number of rows before and after the join is not sufficient to ensure that your join has gone smoothly. If you have an inner join with duplicate keys in both tables, you might get unlucky as the number of dropped rows might exactly equal the number of duplicated rows!
