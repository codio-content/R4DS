# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))