# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))