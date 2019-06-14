library(tidyverse)
ggplot(data = mpg) + geom_point(mapping = aes(x = cty, y = hwy))