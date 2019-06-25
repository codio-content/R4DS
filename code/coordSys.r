# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()