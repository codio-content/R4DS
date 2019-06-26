# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))