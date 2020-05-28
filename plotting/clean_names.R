#!/usr/bin/env Rscript

library(readr)
library(dplyr)

#' Use dplyr to clean up column names, extract gene name, and remove rows with all zeroes.  We could write the following for each file individually:

# data <- read_tsv("output_rna.txt") %>%
#   rename(TranscriptID = starts_with("Transcript")) %>%
#   rename_at(vars(starts_with("./processed_data")),
#             ~gsub("^./processed_data/|\\s+.+$", "", .)) %>%
#   mutate(gene = gsub("^(.*?)\\|.+$", "\\1", `Annotation/Divergence`)) %>%
#   filter_at(vars(starts_with("RNAseq")), any_vars(. > 0))
#
# write.table(data, "output_rna_clean.txt", quote=FALSE, sep='\t', row.names = F)

#' Can write a function instead which is re-usable.
#' - Saves typing and can fix mistakes in one place.
#' - Added extra rename for diff exp tables and `arrange` sorts by p-value (ascending, so smallest are at top).  Can remove this line if you will have more than one comparison in your table.
cleandata <- function(inputfilename, outputfilename) {
  data <- read_tsv(inputfilename) %>%
    rename(TranscriptID = starts_with("Transcript")) %>%
    rename_at(vars(starts_with("./processed_data")),
              ~gsub("^./processed_data/|\\s+.+$", "", .)) %>%
    mutate(gene = gsub("^(.*?)\\|.+$", "\\1", `Annotation/Divergence`)) %>%
    mutate(genetype = gsub(".+\\|([^\\|]+)$", "\\1", `Annotation/Divergence`)) %>%
    filter_at(vars(starts_with("RNAseq")), any_vars(. > 0))

  ## extra column name cleaning and sorting of p-value
    if (any(grepl("p-value", colnames(data), fixed=T))) {
      data <- rename(data, `Log2 Fold Change` = ends_with("Log2 Fold Change"),
                     `adj. p-value` = ends_with("adj. p-value")) %>%
        arrange(`adj. p-value`)
    }


  write.table(data, outputfilename, quote=FALSE, sep='\t', row.names = F)
}

#' Now we can use our function for each of our tables.
cleandata("output_rna.txt", "output_rna_clean.txt")
cleandata("diff_rna_BM_vs_Th.txt", "diff_rna_BM_vs_Th_clean.txt")
cleandata("DEG.Down_Th_vs_BM.txt", "DEG.Down_Th_vs_BM_clean.txt")
cleandata("DEG.Up_Th_vs_BM.txt", "DEG.Up_Th_vs_BM_clean.txt")
