# write your code below and then press the RUN CODE button
# for graphical output press the "Refresh Plot" link
 
library(tidyverse)
challenge <- read_csv(readr_example("challenge.csv"))
write_csv(challenge, "challenge.csv")