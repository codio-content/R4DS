
Paths and directories are a little complicated because there are two basic styles of paths: Mac/Linux and Windows. There are three chief ways in which they differ:

1.  The most important difference is how you separate the components of the
    path. Mac and Linux uses slashes (e.g. `plots/diamonds.pdf`) and Windows
    uses backslashes (e.g. `plots\diamonds.pdf`). R can work with either type
    (no matter what platform you're currently using), but unfortunately, 
    backslashes mean something special to R, and to get a single backslash 
    in the path, you need to type two backslashes! That makes life frustrating, 
    so I recommend always using the Linux/Mac style with forward slashes.

1.  Absolute paths (i.e. paths that point to the same place regardless of 
    your working directory) look different. In Windows they start with a drive
    letter (e.g. `C:`) or two backslashes (e.g. `\\servername`) and in
    Mac/Linux they start with a slash "/" (e.g. `/users/hadley`). You should
    __never__ use absolute paths in your scripts, because they hinder sharing: 
    no one else will have exactly the same directory configuration as you.

1.  The last minor difference is the place that `~` points to. `~` is a
    convenient shortcut to your home directory. Windows doesn't really have 
    the notion of a home directory, so it instead points to your documents
    directory.
