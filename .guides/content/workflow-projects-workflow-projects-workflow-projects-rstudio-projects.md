
R experts keep all the files associated with a project together --- input data, R scripts, analytical results, figures. This is such a wise and common practice that RStudio has built-in support for this via __projects__.

Let's make a project for you to use while you're working through the rest of this book. Click File > New Project, then:


![Figure 10.1](screenshots/rstudio-project-1.png)

**Figure 10.1**

![Figure 10.2](screenshots/rstudio-project-2.png)

**Figure 10.2**

 ![Figure 10.3](screenshots/rstudio-project-3.png)

**Figure 10.3**

 

Call your project `r4ds` and think carefully about which _subdirectory_ you put the project in. If you don't store it somewhere sensible, it will be hard to find it in the future!

Once this process is complete, you'll get a new RStudio project just for this book. Check that the "home" directory of your project is the current working directory:


```r
getwd()
#> [1] /Users/hadley/Documents/r4ds/r4ds
```

Whenever you refer to a file with a relative path it will look for it here. 

Now enter the following commands in the script editor, and save the file, calling it "diamonds.R". Next, run the complete script which will save a PDF and CSV file into your project directory. Don't worry about the details, you'll learn them later in the book.


```r
library(tidyverse)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")
```

Quit RStudio. Inspect the folder associated with your project --- notice the `.Rproj` file. Double-click that file to re-open the project. Notice you get back to where you left off: it's the same working directory and command history, and all the files you were working on are still open. Because you followed my instructions above, you will, however, have a completely fresh environment, guaranteeing that you're starting with a clean slate.

In your favorite OS-specific way, search your computer for `diamonds.pdf` and you will find the PDF (no surprise) but _also the script that created it_ (`diamonds.R`). This is huge win! One day you will want to remake a figure or just understand where it came from. If you rigorously save figures to files __with R code__ and never with the mouse or the clipboard, you will be able to reproduce old work with ease!
