# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))