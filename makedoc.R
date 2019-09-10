library(rmarkdown)
library(knitr)

opts_chunk$set(eval=FALSE)
render("Intro_R_outline.Rmd", output_format = github_document(toc=T), output_file = "Intro_R_outline.md")
