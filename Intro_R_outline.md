# Introduction to R

A lot of this is  borrowed from [Sean Davis](https://seandavi.github.io/ITR/)

#### A.  Let's Jump In

- RStudio - the console, the editor, the environment, the files, help

- Basic syntax in the console
- expressions, variable assignment, naming conventions
- Useful commands - `ls()`, `rm`, `View`, `head`, `sessionInfo`
- Saving and loading a session - .RData, .Rhistory, individual objects

#### B.  Data Structures

- **Vectors**
  - data types - character, numeric, factor, logical, `Inf`, `NA`, `NULL`
  - simple manipulation
  - vectorized operations (could put this under functions
- **Matrices & Data frames**
  - index elements
  - column and row names
  - data types of individual elements
- **Lists**
  - very general "data holding" structures - items of different types and lengths can be put in a list
  - useful along with `lapply` to iterate over many items

#### C.  Base and Add-on Packages

- base package
  - basic statistics - mean, median, sd, factorial
  - matrix operations

- how to use functions from different packages


#### D.  File IO and data formatting/cleanup
- Reading in files
- global options - stringsAsFactors, scipen
- tidyr, reshape2, string manipulation - gsub/paste
- Writing tabular output

#### E.  Control Flow
- If statements - logical vectors, etc
- Functions
- Loops/Apply - simple for loops and also how to use lapply and apply
- debugging - `print`, `message`, `warn`, `stop`

#### F. Plotting

- histograms
- ggplot2
- lattice/base plotting



  