
The previous chapter focused on the default `html_document` output. There are a number of basic variations on that theme, generating different types of documents:

*   `pdf_document` makes a PDF with LaTeX (an open source document layout 
    system), which you'll need to install. RStudio will prompt you if you 
    don't already have it.
  
*   `word_document` for Microsoft Word documents (`.docx`).
  
*   `odt_document` for OpenDocument Text documents (`.odt`).
  
*   `rtf_document` for Rich Text Format (`.rtf`) documents.
  
*   `md_document` for a Markdown document. This isn't typically useful by 
    itself, but you might use it if, for example, your corporate CMS or
    lab wiki uses markdown.
    
*   `github_document`: this is a tailored version of `md_document` 
    designed for sharing on GitHub. 

Remember, when generating a document to share with decision makers, you can turn off the default display of code by setting global options in the setup chunk:


```r
knitr::opts_chunk$set(echo = FALSE)
```

For `html_document`s another option is to make the code chunks hidden by default, but visible with a click:

```yaml
output:
  html_document:
    code_folding: hide
```
