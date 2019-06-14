
So far you've seen R Markdown used to produce HTML documents. This chapter gives a brief overview of some of the many other types of output you can produce with R Markdown. There are two ways to set the output of a document:

1.  Permanently, by modifying the YAML header: 
    
```yaml
    title: "Viridis Demo"
    output: html_document
```
    
1.  Transiently, by calling `rmarkdown::render()` by hand:
    
    
```r
    rmarkdown::render("diamond-sizes.Rmd", output_format = "word_document")
```
    
    This is useful if you want to programmatically produce multiple types of
    output.

RStudio's knit button renders a file to the first format listed in its `output` field. You can render to additional formats by clicking the dropdown menu beside the knit button.


![Figure 36.1](screenshots/rmarkdown-knit)

**Figure 36.1**
