# Introduction to R

### A.  Let's Jump In
**RStudio - the console, the editor, the environment, the files, help**

- How do we get help?

1. Help pane with our mouse.
2. From the console:
```R
?help
```
3. Search the internet!
   - stackoverflow.com - [Questions tagged with R](https://stackoverflow.com/questions/tagged/r)
   - [Cross Validated](https://stats.stackexchange.com/) - https://stats.stackexchange.com/
   - [Bioconductor Support Site](https://support.bioconductor.org/)
   - Package author's GitHub/GitLab/website may have an "Issues" section

- Working directory

  - Allows you to access/read/write files in a directory without having to give the whole directory path.  You can just give filenames relative to that directory.  Maybe right now this doesn't seem like a big deal.  But, as you do more work in R, you will see that it can get confusing to access files in lots of different places

  - Best practices keep all of your work for a single project in a single folder and make that your *working directory*  EVEN BETTER is to use an [RStudio project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects)

  - Ordinarily you would make a new project.  Today, we will check out this class project from git: 

    Upper right corner Project menu -> Version Control -> Git -> Repo URL: https://github.com/niaid/R_Intro -> Create Project

**Basic syntax in the console**

- expressions, variable assignment, naming conventions
- Useful commands - `ls()`, `rm`, `View`, `head`, `sessionInfo`
- Saving and loading a session - .RData, .Rhistory

**Writing a script**

- File -> New File -> R Script
- Paste commands from history
- Run from the command line.  The first line of your script (shebang):

```R
#!/usr/bin/env Rscript
```

- Comments start with a `#` character.  These lines are not run.  Even better is to use `#'` - pound sign followed by apostrophe.

### B.  File IO
**Reading in files**

Weber, Anna M., et al. “A Blue Light Receptor That Mediates RNA Binding and Translational Regulation.” *Nature Chemical Biology*, Aug. 2019, pp. 1–8. *www.nature.com*, doi:[10.1038/s41589-019-0346-y](https://doi.org/10.1038/s41589-019-0346-y).

[Supplementary Dataset 1](https://static-content.springer.com/esm/art%3A10.1038%2Fs41589-019-0346-y/MediaObjects/41589_2019_346_MOESM3_ESM.xlsx) - 41589_2019_346_MOESM3_ESM.xlsx

[Supplementary Figure 6 - page 13](https://static-content.springer.com/esm/art%3A10.1038%2Fs41589-019-0346-y/MediaObjects/41589_2019_346_MOESM1_ESM.pdf#page=13)

- GUI: File -> Import Dataset -> 
- Paste command in script

**Writing tabular output**

- printing options

  - scipen
  
  > integer. A penalty to be applied when deciding to print numeric values in fixed or exponential notation. Positive values bias towards fixed and negative towards scientific notation: fixed notation will be preferred unless it is more than `scipen`digits wider.
  - in practice, if you don't want scientific notation, set:
  ```r
  options(scipen=999)
  ```
  - width - number of digits or characters before truncation/rounding
  ```r
  getOption("width")
  ```
  - Save data.frame to file

```r
?write.csv
write.csv(df, "mydata.csv", quote=FALSE)
?write_excel_csv ## readr package
```

### B.  Data Structures
- **Data frames & Matrices**
  - index elements
  - column and row names
  - data types of individual elements
- **Vectors**
  - data types - character, numeric, factor, logical, `Inf`, `NA`, `NULL`
  - simple manipulation
  - vectorized operations (could put this under functions)
- **Lists**
  - very general "data holding" structures - items of different types and lengths can be put in a list
    - a data.frame is just a special kind of list where all the items are the same length
  - useful along with `lapply` to iterate over many items

### C.  Base and Add-on Packages
- base package
  - basic statistics - mean, median, sd, factorial
  - matrix operations
- how to install packages
- how to use functions from different packages

### F. Plotting and Visualization
**ggplot2**

- knitr



### E.  Control Flow
- If statements - logical vectors, etc
- Functions
- Loops/Apply - simple for loops and also how to use lapply and apply
- debugging - `print`, `message`, `warn`, `stop`


