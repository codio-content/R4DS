# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)