
An online version of this book is available at <http://r4ds.had.co.nz>. It will continue to evolve in between reprints of the physical book. The source of the book is available at <https://github.com/hadley/r4ds>. The book is powered by <https://bookdown.org> which makes it easy to turn R markdown files into HTML, PDF, and EPUB.

This book was built with:


```r
devtools::session_info(c("tidyverse"))
#> - Session info ----------------------------------------------------------
#>  setting  value                       
#>  version  R version 3.5.3 (2019-03-11)
#>  os       macOS Mojave 10.14.2        
#>  system   x86_64, darwin18.2.0        
#>  ui       unknown                     
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       Europe/Moscow               
#>  date     2019-04-10                  
#> 
#> - Packages --------------------------------------------------------------
#>  package      * version    date       lib
#>  askpass        1.1        2019-01-13 [1]
#>  assertthat     0.2.1      2019-03-21 [1]
#>  backports      1.1.3      2018-12-14 [1]
#>  base64enc      0.1-3      2015-07-28 [1]
#>  BH             1.69.0-1   2019-01-07 [1]
#>  broom          0.5.2      2019-04-07 [1]
#>  callr          3.2.0      2019-03-15 [1]
#>  cellranger     1.1.0      2016-07-27 [1]
#>  cli            1.1.0      2019-03-19 [1]
#>  clipr          0.5.0      2019-01-11 [1]
#>  colorspace     1.4-1      2019-03-18 [1]
#>  crayon         1.3.4      2017-09-16 [1]
#>  curl           3.3        2019-01-10 [1]
#>  DBI            1.0.0      2018-05-02 [1]
#>  dbplyr         1.3.0      2019-01-09 [1]
#>  digest         0.6.18     2018-10-10 [1]
#>  dplyr        * 0.8.0.1    2019-02-15 [1]
#>  ellipsis       0.1.0      2019-02-19 [1]
#>  evaluate       0.13       2019-02-12 [1]
#>  fansi          0.4.0      2018-10-05 [1]
#>  forcats      * 0.4.0      2019-02-17 [1]
#>  fs             1.2.7      2019-03-19 [1]
#>  generics       0.0.2      2018-11-29 [1]
#>  ggplot2      * 3.1.0.9000 2019-04-09 [1]
#>  glue           1.3.1      2019-03-12 [1]
#>  gtable         0.3.0      2019-03-25 [1]
#>  haven          2.1.0      2019-02-19 [1]
#>  highr          0.8        2019-03-20 [1]
#>  hms            0.4.2      2018-03-10 [1]
#>  htmltools      0.3.6      2017-04-28 [1]
#>  httr           1.4.0      2018-12-11 [1]
#>  jsonlite       1.6        2018-12-07 [1]
#>  knitr          1.22       2019-03-08 [1]
#>  labeling       0.3        2014-08-23 [1]
#>  lattice        0.20-38    2018-11-04 [2]
#>  lazyeval       0.2.2      2019-03-15 [1]
#>  lubridate      1.7.4      2018-04-11 [1]
#>  magrittr       1.5        2014-11-22 [1]
#>  markdown       0.9        2018-12-07 [1]
#>  MASS           7.3-51.1   2018-11-01 [2]
#>  Matrix         1.2-15     2018-11-01 [2]
#>  mgcv           1.8-27     2019-02-06 [2]
#>  mime           0.6        2018-10-05 [1]
#>  modelr         0.1.4      2019-02-18 [1]
#>  munsell        0.5.0      2018-06-12 [1]
#>  nlme           3.1-137    2018-04-07 [2]
#>  openssl        1.3        2019-03-22 [1]
#>  pillar         1.3.1      2018-12-15 [1]
#>  pkgconfig      2.0.2      2018-08-16 [1]
#>  plogr          0.2.0      2018-03-25 [1]
#>  plyr           1.8.4      2016-06-08 [1]
#>  prettyunits    1.0.2      2015-07-13 [1]
#>  processx       3.3.0      2019-03-10 [1]
#>  progress       1.2.0      2018-06-14 [1]
#>  ps             1.3.0      2018-12-21 [1]
#>  purrr        * 0.3.2      2019-03-15 [1]
#>  R6             2.4.0      2019-02-14 [1]
#>  RColorBrewer   1.1-2      2014-12-07 [1]
#>  Rcpp           1.0.1      2019-03-17 [1]
#>  readr        * 1.3.1      2018-12-21 [1]
#>  readxl         1.3.1      2019-03-13 [1]
#>  rematch        1.0.1      2016-04-21 [1]
#>  reprex         0.2.1      2018-09-16 [1]
#>  reshape2       1.4.3      2017-12-11 [1]
#>  rlang          0.3.4      2019-04-07 [1]
#>  rmarkdown      1.12.4     2019-04-09 [1]
#>  rstudioapi     0.10       2019-03-19 [1]
#>  rvest          0.3.2      2016-06-17 [1]
#>  scales         1.0.0      2018-08-09 [1]
#>  selectr        0.4-1      2018-04-06 [1]
#>  stringi        1.4.3      2019-03-12 [1]
#>  stringr      * 1.4.0      2019-02-10 [1]
#>  sys            3.1        2019-03-10 [1]
#>  tibble       * 2.1.1      2019-03-16 [1]
#>  tidyr        * 0.8.3      2019-03-01 [1]
#>  tidyselect     0.2.5      2018-10-11 [1]
#>  tidyverse    * 1.2.1      2017-11-14 [1]
#>  tinytex        0.11       2019-03-12 [1]
#>  utf8           1.1.4      2018-05-24 [1]
#>  viridisLite    0.3.0      2018-02-01 [1]
#>  whisker        0.3-2      2013-04-28 [1]
#>  withr          2.1.2      2018-03-15 [1]
#>  xfun           0.6        2019-04-02 [1]
#>  xml2           1.2.0      2018-01-24 [1]
#>  yaml           2.2.0      2018-07-25 [1]
#>  source                            
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  Github (hadley/ggplot2@230e8f7)   
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  Github (rstudio/rmarkdown@56bb955)
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#>  CRAN (R 3.5.3)                    
#> 
#> [1] /usr/local/lib/R/3.5/site-library
#> [2] /usr/local/Cellar/r/3.5.3/lib/R/library
```