
This book is not an island; there is no single resource that will allow you to master R. As you start to apply the techniques described in this book to your own data you will soon find questions that I do not answer. This section describes a few tips on how to get help, and to help you keep learning.

If you get stuck, start with Google. Typically adding "R" to a query is enough to restrict it to relevant results: if the search isn't useful, it often means that there aren't any R-specific results available. Google is particularly useful for error messages. If you get an error message and you have no idea what it means, try googling it! Chances are that someone else has been confused by it in the past, and there will be help somewhere on the web. (If the error message isn't in English, run `Sys.setenv(LANGUAGE = "en")` and re-run the code; you're more likely to find help for English error messages.)

If Google doesn't help, try [stackoverflow](http://stackoverflow.com). Start by spending a little time searching for an existing answer, including `[R]` to restrict your search to questions and answers that use R. If you don't find anything useful, prepare a minimal reproducible example or __reprex__.  A good reprex makes it easier for other people to help you, and often you'll figure out the problem yourself in the course of making it.

There are three things you need to include to make your example reproducible: required packages, data, and code.

1.  **Packages** should be loaded at the top of the script, so it's easy to
    see which ones the example needs. This is a good time to check that you're
    using the latest version of each package; it's possible you've discovered
    a bug that's been fixed since you installed the package. For packages
    in the tidyverse, the easiest way to check is to run `tidyverse_update()`.

1.  The easiest way to include **data** in a question is to use `dput()` to 
    generate the R code to recreate it. For example, to recreate the `mtcars` 
    dataset in R, I'd perform the following steps:
  
    1. Run `dput(mtcars)` in R
    2. Copy the output
    3. In my reproducible script, type `mtcars <- ` then paste.
    
    Try and find the smallest subset of your data that still reveals
    the problem.

1.  Spend a little bit of time ensuring that your **code** is easy for others to
    read:

    * Make sure you've used spaces and your variable names are concise, yet
      informative.
    
    * Use comments to indicate where your problem lies.
    
    * Do your best to remove everything that is not related to the problem.  
      The shorter your code is, the easier it is to understand, and the 
      easier it is to fix.

Finish by checking that you have actually made a reproducible example by starting a fresh R session and copying and pasting your script in. 

You should also spend some time preparing yourself to solve problems before they occur. Investing a little time in learning R each day will pay off handsomely in the long run. One way is to follow what Hadley, Garrett, and everyone else at RStudio are doing on the [RStudio blog](https://blog.rstudio.org). This is where we post announcements about new packages, new IDE features, and in-person courses. You might also want to follow Hadley ([\@hadleywickham](https://twitter.com/hadleywickham)) or Garrett ([\@statgarrett](https://twitter.com/statgarrett)) on Twitter, or follow [\@rstudiotips](https://twitter.com/rstudiotips) to keep up with new features in the IDE.

To keep up with the R community more broadly, we recommend reading <http://www.r-bloggers.com>: it aggregates over 500 blogs about R from around the world. If you're an active Twitter user, follow the `#rstats` hashtag. Twitter is one of the key tools that Hadley uses to keep up with new developments in the community.
