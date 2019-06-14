
You can also use R Markdown to produce presentations. You get less visual control than with a tool like Keynote or PowerPoint, but automatically inserting the results of your R code into a presentation can save a huge amount of time. Presentations work by dividing your content into slides, with a new slide beginning at each first (`#`) or second (`##`) level header. You can also insert a horizontal rule (`***`) to create a new slide without a header. 

R Markdown comes with three presentation formats built-in:

1.  `ioslides_presentation` - HTML presentation with ioslides

1.  `slidy_presentation` - HTML presentation with W3C Slidy

1.  `beamer_presentation` - PDF presentation with LaTeX Beamer.

Two other popular formats are provided by packages:

1.  `revealjs::revealjs_presentation` - HTML presentation with reveal.js. 
    Requires the __revealjs__ package.

1.  __rmdshower__, <https://github.com/MangoTheCat/rmdshower>, provides a 
    wrapper around the __shower__, <https://github.com/shower/shower>, 
    presentation engine
