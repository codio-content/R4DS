
With a little additional infrastructure you can use R Markdown to generate a complete website:

*   Put your `.Rmd` files in a single directory. `index.Rmd` will become 
    the home page.

*   Add a YAML file named `_site.yml` provides the navigation for the site.
    For example:

    
```
    name: "my-website"
    navbar:
      title: "My Website"
      left:
        - text: "Home"
          href: index.html
        - text: "Viridis Colors"
          href: 1-example.html
        - text: "Terrain Colors"
          href: 3-inline.html
```

Execute `rmarkdown::render_site()` to build `_site`, a directory of files ready to deploy as a standalone static website, or if you use an RStudio Project for your website directory. RStudio will add a Build tab to the IDE that you can use to build and preview your site. 

Read more at <http://rmarkdown.rstudio.com/rmarkdown_websites.html>.
