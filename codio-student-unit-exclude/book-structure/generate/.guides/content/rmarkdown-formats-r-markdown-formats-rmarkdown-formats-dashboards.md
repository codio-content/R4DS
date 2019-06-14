
Dashboards are a useful way to communicate large amounts of information visually and quickly. Flexdashboard makes it particularly easy to create dashboards using R Markdown and a convention for how the headers affect the layout:

* Each level 1 header (`#`) begins a new page in the dashboard.
* Each level 2 header (`##`) begins a new column.
* Each level 3 header (`###`) begins a new row.

For example, you can produce this dashboard:


![Figure 36.1](screenshots/rmarkdown-flexdashboard)

**Figure 36.1**

Using this code:


````
---
title: "Diamonds distribution dashboard"
output: flexdashboard::flex_dashboard
---

```{r setup, include = FALSE}
library(ggplot2)
library(dplyr)
knitr::opts_chunk$set(fig.width = 5, fig.asp = 1/3)
```

## Column 1

### Carat

```{r}
ggplot(diamonds, aes(carat)) + geom_histogram(binwidth = 0.1)
```

### Cut

```{r}
ggplot(diamonds, aes(cut)) + geom_bar()
```

### Colour

```{r}
ggplot(diamonds, aes(color)) + geom_bar()
```

## Column 2

### The largest diamonds

```{r}
diamonds %>% 
  arrange(desc(carat)) %>% 
  head(100) %>% 
  select(carat, cut, color, price) %>% 
  DT::datatable()
```
````

Flexdashboard also provides simple tools for creating sidebars, tabsets, value boxes, and gauges. To learn more about flexdashboard visit <http://rmarkdown.rstudio.com/flexdashboard/>.
