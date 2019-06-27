# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
library(nycflights13)
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest