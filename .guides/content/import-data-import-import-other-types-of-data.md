
To get other types of data into R, we recommend starting with the tidyverse packages listed below. They're certainly not perfect, but they are a good place to start. For rectangular data:

* __haven__ reads SPSS, Stata, and SAS files.

* __readxl__ reads excel files (both `.xls` and `.xlsx`).

* __DBI__, along with a database specific backend (e.g. __RMySQL__, 
  __RSQLite__, __RPostgreSQL__ etc) allows you to run SQL queries against a 
  database and return a data frame.

For hierarchical data: use __jsonlite__ (by Jeroen Ooms) for json, and __xml2__ for XML. Jenny Bryan has some excellent worked examples at <https://jennybc.github.io/purrr-tutorial/>.

For other file types, try the [R data import/export manual](https://cran.r-project.org/doc/manuals/r-release/R-data.html) and the [__rio__](https://github.com/leeper/rio) package.