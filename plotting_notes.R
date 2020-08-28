#' ## Heatmap

#' uncomment to install, and then re-comment afterward.
# install.packages("pheatmap")
library(pheatmap)
library(readr)

#' read in Transcripts per Million output of `analyzeRepeats.pl` from HOMER.
tpm <- read_tsv("output_rna_clean.txt")
colnames(tpm)
?pheatmap
pheatmap(tpm[,9:12], show_rownames = F, scale = 'row')

#' *tpm* has ~16k rows!  So takes some time.  Uncomment line below to save heatmap as pdf.
nrow(tpm)
#pheatmap(tpm[,9:12], show_rownames = F, scale = 'row', filename="allheatmap.pdf")

#' read in DESeq2 output of `getDiffExpression.pl` from HOMER
diffexp <- read_tsv("diff_rna_BM_vs_Th_clean.txt")
diffexp10 <- diffexp[1:10,]
diffexp10$TranscriptID

#' *dplyr* filter for top 10
library(dplyr)
tpm10 <- filter(tpm, TranscriptID %in% diffexp10$TranscriptID)
dim(tpm10)

#' - why are there only 8?  Missing ID also not in original output_rna.txt
setdiff(diffexp10$TranscriptID, tpm10$TranscriptID)

#' - remake heatmap with gene names
pheatmap(tpm10[,9:12], labels_row = tpm10$gene, scale='row')

#' add some simple annotation to the columns
#'
#' - check column names
colnames(tpm10)
#' - create annotation data frame
annotation_col <- data.frame(
  Type = factor(c("BM", "BM", "Th", "Th"))
)
#' - make sure rows have same names as *columns* of heatmap
rownames(annotation_col) <- colnames(tpm10)[9:12]

pheatmap(tpm10[,9:12], labels_row = tpm10$gene, scale='row', annotation_col = annotation_col)


#' ## ggplot2

#' ggplot2 is based on *The Grammar of Graphics* by [Leland Wilkinson](https://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html).  But, nowadays we associate [GoG with Hadley Wickham](https://vita.had.co.nz/papers/layered-grammar.pdf) the author of ggplot2.  He is very influential in R programming - progenitor of the "tidyverse."  ggplot2 is probably the MOST popular plotting package in R, and heavily influences graphing grammars in other languages, notably python and js.

library(ggplot2)

#' ### Scatter plot

#' 1. start with ggplot function - specify data and "aesthetics"
#' 2. add "geoms" which are the type of plot (points, lines, bars, etc)
#' 3. add "scales" which further specify the aesthetics: axes, colors, sizes

#' *Aesthetics* map from variables in the data to components of the graph.
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`adj. p-value`)) + geom_point()

#' For volcano plot we do -Log10 of p-value
diffexp$newvalue <- -log10(diffexp$`adj. p-value`)

#' How should we deal with these infinite values?  However we do it, we should alert the reader in the caption. Set the "Inf" values equal to 300 for plotting.
head(diffexp$newvalue)
head(diffexp$`adj. p-value`)
diffexp$newvalue[1:4] <- 300

ggplot(diffexp, aes(x=`Log2 Fold Change`, y=newvalue)) + geom_point()

#' Better way is to add 1 to the p-values, so we avoid taking the log of 0.  This is more robust, as we don't have to check the largest value to replace `Inf`.  We can do this in all situations.
diffexp$badlog10 <- -log10(1 + diffexp$`adj. p-value`)

#' Why do we get so many zeroes?
head(diffexp$badlog10, 20)
#' Computing $log(1+x)$ suffers when $|x| << 1$.  `log1p` was written to increase precision of this computation.  We use it with the change of base formula to calculate $-log_{10}(1 + \textit{p-value})$:
diffexp$`-Log10 adj. p` <- -log1p(diffexp$`adj. p-value`)/log(10)
head(diffexp$`-Log10 adj. p`)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`)) + geom_point()


#' **Scales and colors**
#'
#' Could also change the scale.  *Scales* change the scale (quantitative or qualitative) of an aesthetic mapping.
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`adj. p-value`)) + geom_point() + scale_y_log10()


#' We can color the points based on p-value
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=`-Log10 adj. p`)) + geom_point()
#' change the gradient scale
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=`-Log10 adj. p`)) + geom_point() + scale_color_gradient(low = "royalblue",high="goldenrod")
#' We can color the points based on gene type
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=genetype)) + geom_point()

#' **Q:** Why the difference in the color scales?
#'
#' **A:** Because we have different classes of variables.  p-value is a continuous numeric. And the genetype is a discrete character.
#'
#' For discrete scales, we use `scale_color_manual` to change the color.  We give one color for every distinct value of genetype in our data.
unique(diffexp$genetype)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=genetype)) + geom_point() + scale_color_manual(values = c("red", "blue", "green", "yellow", "purple", "brown"))



#' **Saving plots**
#'
#' Save most recent plot to file
ggsave("volcanoplot.pdf")

#' Can also assign variable name to plot and then save that.
myplot <- ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=`-Log10 adj. p`)) + geom_point() + scale_color_gradient(low = "royalblue",high="goldenrod")
ggsave("myplot.pdf", myplot)

#' ### Long vs wide data

#' ggplot expects **long data**.  Long data is where each column corresponds to a single variable, so you can match up variables to aesthetics.

print(tpm10[,-c(1:7)])

#' Use `gather` from tidyr to "gather together" the sample names and tpm measurements.
library(tidyr)

longtpm <- gather(tpm10, key = "sample", value = "TPM", starts_with("RNAseq"))
head(longtpm[,-c(1:7)])

#' we can make a heatmap in ggplot as well, but it is not as easy to annotate or draw the dendrogram/clustering.
ggplot(longtpm, aes(x=sample, y=gene, fill=TPM)) + geom_tile()

#' Can make cosmetic changes with `theme`.
?theme
?element_text
ggplot(longtpm, aes(x=sample, y=gene, fill=TPM)) + geom_tile() + theme(axis.text.x = element_text(angle=90))
#' Save your theme to a variable, so you can re-use it over and over.
mytheme <- theme_minimal() + theme(axis.text.x = element_text(angle=90))
ggplot(longtpm, aes(x=sample, y=gene, fill=TPM)) + geom_tile() + mytheme

#' ### More ways to plot


#' Histogram of p-values
ggplot(diffexp, aes(x=`adj. p-value`)) + geom_histogram(binwidth = 0.01, fill="powderblue", color="grey30") + mytheme

#' Can convert continuous scale to discrete scale by converting numerics to *factors*.
ggplot(diffexp[1:10,], aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=as.factor(`-Log10 adj. p`))) + geom_point() + mytheme

#' ^ is silly example.  But makes more sense with fewer values or by *binning*.  Can use `cut`.
diffexp$plabel <- cut(diffexp$`-Log10 adj. p`, breaks=c(-0.31,-0.1,0), include.lowest = T)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=plabel)) + geom_point() + mytheme


#' Label points with **ggrepel**
library(ggrepel)
ggplot(diffexp[1:10,], aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=plabel)) + geom_point() + geom_text_repel(aes(label=gene))

#' label only the top 10 points by giving `geom_text_repel` its own data argument.  This will override the *data* argument of the main `ggplot` function.  So it will only use the first 10 rows of diffexp instead
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=plabel)) + geom_point() + geom_text_repel(data=diffexp[1:10,], aes(label=gene))
#' change the color of the labels to override the `color` aesthetic in the main `ggplot` function.
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=plabel)) + geom_point() + geom_text_repel(data=diffexp[1:10,], aes(label=gene), color="mediumorchid", fontface="bold")


#' ### Exercises

#' 1. Plot scatterplot gene vs TPM using just the top 10 genes with each sample a different color.

#' 3. Make your plots look pretty or at least suitable for publication.  Use a theme!  Increase the font size to 14.
#' Use an existing theme (or make your own from scratch :-o with `theme`)
?theme_bw


#' 2. Look up geom_line (or geom_bar) help.  Make the same plot as #1 with lines (or bars) instead of points.

#' 4. Color the points based on the fold change.  Red for greater than 1, blue for less.

#' 5. For heatmap using pheatmap, change annotation column colors.

#' 6. Make heatmap of top 10 up-regulated and top 10 down-regulated genes. Which table(s) would you use? (Different ways to do it; one way is to use `rbind`).

