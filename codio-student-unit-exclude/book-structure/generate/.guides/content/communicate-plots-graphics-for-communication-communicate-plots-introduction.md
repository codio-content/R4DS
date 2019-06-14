
In [exploratory data analysis], you learned how to use plots as tools for _exploration_. When you make exploratory plots, you know---even before looking---which variables the plot will display. You made each plot for a purpose, could quickly look at it, and then move on to the next plot. In the course of most analyses, you'll produce tens or hundreds of plots, most of which are immediately thrown away.

Now that you understand your data, you need to _communicate_ your understanding to others. Your audience will likely not share your background knowledge and will not be deeply invested in the data. To help others quickly build up a good mental model of the data, you will need to invest considerable effort in making your plots as self-explanatory as possible. In this chapter, you'll learn some of the tools that ggplot2 provides to do so.

This chapter focuses on the tools you need to create good graphics. I assume that you know what you want, and just need to know how to do it. For that reason, I highly recommend pairing this chapter with a good general visualisation book. I particularly like [_The Truthful Art_](https://amzn.com/0321934075), by Albert Cairo. It doesn't teach the mechanics of creating visualisations, but instead focuses on what you need to think about in order to create effective graphics.

### Prerequisites

In this chapter, we'll focus once again on ggplot2. We'll also use a little dplyr for data manipulation, and a few ggplot2 extension packages, including __ggrepel__ and __viridis__. Rather than loading those extensions here, we'll refer to their functions explicitly, using the `::` notation. This will help make it clear which functions are built into ggplot2, and which come from other packages. Don't forget you'll need to install those packages with `install.packages()` if you don't already have them.


```r
library(tidyverse)
```
