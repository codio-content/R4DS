
Any HTML format (document, notebook, presentation, or dashboard) can contain interactive components.

### htmlwidgets

HTML is an interactive format, and you can take advantage of that interactivity with __htmlwidgets__, R functions that produce interactive HTML visualisations. For example, take the __leaflet__ map below. If you're viewing this page on the web, you can drag the map around, zoom in and out, etc. You obviously can't do that in a book, so rmarkdown automatically inserts a static screenshot for you.


```r
library(leaflet)
leaflet() %>%
  setView(174.764, -36.877, zoom = 16) %>% 
  addTiles() %>%
  addMarkers(174.764, -36.877, popup = "Maungawhau") 
```



![Figure 36.1](rmarkdown-formats_files/figure-latex/unnamed-chunk-7-1.jpg)
![Figure 36.1](screenshots/rmarkdown-shiny.png)

**Figure 36.1**
You can then refer to the values with `input$name` and `input$age`, and the code that uses them will be automatically re-run whenever they change. 

I can't show you a live shiny app here because shiny interactions occur on the __server-side__. This means that you can write interactive apps without knowing JavaScript, but you need a server to run them on. This introduces a logistical issue: Shiny apps need a Shiny server to be run online. When you run shiny apps on your own computer, shiny automatically sets up a shiny server for you, but you need a public facing shiny server if you want to publish this sort of interactivity online. That's the fundamental trade-off of shiny: you can do anything in a shiny document that you can do in R, but it requires someone to be running R.

Learn more about Shiny at <http://shiny.rstudio.com/>.
