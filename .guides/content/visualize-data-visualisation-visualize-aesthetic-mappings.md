
> "The greatest value of a picture is when it forces us to notice what we
> never expected to see." --- John Tukey

In the plot below, one group of points (highlighted in red) seems to fall outside of the linear trend. These cars have a higher mileage than you might expect. How can you explain these cars? 


![Figure 5.3](visualize_files/figure-latex/unnamed-chunk-6-1.jpg)

**Figure 5.3**

Let's hypothesize that the cars are hybrids. One way to test this hypothesis is to look at the `class` value for each car. The `class` variable of the `mpg` dataset classifies cars into groups such as compact, midsize, and SUV. If the outlying points are hybrids, they should be classified as compact cars or, perhaps, subcompact cars (keep in mind that this data was collected before hybrid trucks and SUVs became popular).

You can add a third variable, like `class`, to a two dimensional scatterplot by mapping it to an __aesthetic__. An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, the shape, or the color of your points. You can display a point (like the one below) in different ways by changing the values of its aesthetic properties. Since we already use the word "value" to describe data, let's use the word "level" to describe aesthetic properties. Here we change the levels of a point's size, shape, and color to make the point small, triangular, or blue:


![Figure 5.4](visualize_files/figure-latex/unnamed-chunk-7-1.jpg)

**Figure 5.4**

You can convey information about your data by mapping the aesthetics in your plot to the variables in your dataset. For example, you can map the colors of your points to the `class` variable to reveal the class of each car.


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```



![Figure 5.5](visualize_files/figure-latex/unnamed-chunk-8-1.jpg)

**Figure 5.5**

(If you prefer British English, like Hadley, you can use `colour` instead of `color`.)

To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside `aes()`. ggplot2 will automatically assign a unique level of the aesthetic (here a unique color) to each unique value of the variable, a process known as __scaling__. ggplot2 will also add a legend that explains which levels correspond to which values.

The colors reveal that many of the unusual points are two-seater cars. These cars don't seem like hybrids, and are, in fact, sports cars! Sports cars have large engines like SUVs and pickup trucks, but small bodies like midsize and compact cars, which improves their gas mileage. In hindsight, these cars were unlikely to be hybrids since they have large engines.

In the above example, we mapped `class` to the color aesthetic, but we could have mapped `class` to the size aesthetic in the same way. In this case, the exact size of each point would reveal its class affiliation. We get a _warning_ here, because mapping an unordered variable (`class`) to an ordered aesthetic (`size`) is not a good idea.


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#> Warning: Using size for a discrete variable is not advised.
```



![Figure 5.6](visualize_files/figure-latex/unnamed-chunk-9-1.jpg)

**Figure 5.6**

Or we could have mapped `class` to the _alpha_ aesthetic, which controls the transparency of the points, or to the shape aesthetic, which controls the shape of the points.


```r
# Left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-10-1.jpg)
![Figure 5.1](visualize_files/figure-latex/unnamed-chunk-10-2.jpg)

**Figure 5.1**

What happened to the SUVs? ggplot2 will only use six shapes at a time. By default, additional groups will go unplotted when you use the shape aesthetic.

For each aesthetic, you use `aes()` to associate the name of the aesthetic with a variable to display. The `aes()` function gathers together each of the aesthetic mappings used by a layer and passes them to the layer's mapping argument. The syntax highlights a useful insight about `x` and `y`: the x and y locations of a point are themselves aesthetics, visual properties that you can map to variables to display information about the data. 

Once you map an aesthetic, ggplot2 takes care of the rest. It selects a reasonable scale to use with the aesthetic, and it constructs a legend that explains the mapping between levels and values. For x and y aesthetics, ggplot2 does not create a legend, but it creates an axis line with tick marks and a label. The axis line acts as a legend; it explains the mapping between locations and values.

You can also _set_ the aesthetic properties of your geom manually. For example, we can make all of the points in our plot blue:


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
```



![Figure 5.7](visualize_files/figure-latex/unnamed-chunk-11-1.jpg)

**Figure 5.7**

Here, the color doesn't convey information about a variable, but only changes the appearance of the plot. To set an aesthetic manually, set the aesthetic by name as an argument of your geom function; i.e. it goes _outside_ of `aes()`. You'll need to pick a level that makes sense for that aesthetic:

* The name of a color as a character string.

* The size of a point in mm.

* The shape of a point as a number, as shown in Figure \@ref(fig:shapes).

![Figure 5.2R has 25 built in shapes that are identified by numbers. There are some seeming duplicates: for example, 0, 15, and 22 are all squares. The difference comes from the interaction of the `colour` and `fill` aesthetics. The hollow shapes (0--14) have a border determined by `colour`; the solid shapes (15--18) are filled with `colour`; the filled shapes (21--24) have a border of `colour` and are filled with `fill`.](visualize_files/figure-latex/shapes-1.jpg)

**Figure 5.2R has 25 built in shapes that are identified by numbers. There are some seeming duplicates: for example, 0, 15, and 22 are all squares. The difference comes from the interaction of the `colour` and `fill` aesthetics. The hollow shapes (0--14) have a border determined by `colour`; the solid shapes (15--18) are filled with `colour`; the filled shapes (21--24) have a border of `colour` and are filled with `fill`.**

### Exercises

1.  {Submit Answer!|assessment}(free-text-2644417677)
What's gone wrong with this code? Why are the points not blue?

    
```r
    ggplot(data = mpg) + 
      geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```
    
    
    
![Figure 5.8](visualize_files/figure-latex/unnamed-chunk-12-1.jpg)

**Figure 5.8**
    
1.  {Check It!|assessment}(multiple-choice-3151543202)
Which variables in `mpg` are categorical? Which variables are continuous? 
    (Hint: type `?mpg` to read the documentation for the dataset). How
    can you see this information when you run `mpg`?

1.  {Submit Answer!|assessment}(free-text-2494697878)
Map a continuous variable to `color`, `size`, and `shape`. How do
    these aesthetics behave differently for categorical vs. continuous
    variables? 
    
1.  {Submit Answer!|assessment}(free-text-514781532)
What happens if you map the same variable to multiple aesthetics? 

1.  {Check It!|assessment}(multiple-choice-1947897726)
What does the `stroke` aesthetic do? What shapes does it work with?
    (Hint: use `?geom_point`)
    
1.  What happens if you map an aesthetic to something other than a variable 
    name, like `aes(colour = displ < 5)`?  Note, you'll also need to specify x and y.{Submit Answer!|assessment}(free-text-1352662087)

