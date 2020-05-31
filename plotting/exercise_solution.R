#' ## Exercise Solution

#' We will need the libraries loaded and the variables that were created in *notes.R* to do the exercises.  If you don't already have them in your environment, you can re-run the script with `source` - same as clicking the button in RStudio. *Be careful* using `source` in general for your own work - it will re-run ALL the commands including saving the plots.  Make sure you don't overwrite something you need.
#+ eval=F
source('notes.R')


#' ### Exercises

#' 1. Plot scatterplot gene vs TPM using just the top 10 genes with each sample a different color.
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point()

#' 2. Make your plots look pretty or at least suitable for publication.  Use a theme!  Increase the font size to 14.

#' Use an existing theme (or make your own from scratch :-o with `theme`)  
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point() + theme(text = element_text(size=14))
#' - update mytheme also adding the `vjust` parameter to center the axis labels on the grid:
mytheme <- mytheme + theme(text = element_text(size=14), axis.text.x=element_text(vjust = 0.5))
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point() + mytheme

#' 3. Look up geom_line (or geom_bar) help.  Make the same plot as #1 with lines (or bars) instead of points.

#' - **Line plot**: uses `group` aesthetic to connect coordinates in same line.
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=sample)) + geom_line()
#' - What happens if we group by gene instead?
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=gene)) + geom_line()

#' - Can plot points AND lines.  
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=sample)) + geom_line() + geom_point()

#' - Since we set the color aesthetic in the `ggplot` function, lines AND points were colored the same.  If we move the color to geom_point:
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_line() + geom_point(aes(color=sample))

#' - Order of geoms determines which gets drawn first.  Set the size of the points to be something big so we can see the difference:
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_line() + geom_point(aes(color=sample), size=5)
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_point(aes(color=sample), size=5) + geom_line()

#' - **Bar plot**. `geom_bar` makes a frequency chart.  To make a bar plot like we usually think, use `geom_col`.  Bars have a color - border, and a fill - color of the interior of bar.
ggplot(longtpm, aes(x=gene, y=TPM, fill=sample)) + geom_col()
#' by default values with the same x coordinate are stacked.  We can put them side-by-side:
ggplot(longtpm, aes(x=gene, y=TPM, fill=sample)) + geom_col(position = position_dodge())
#' Sometimes we might like to stack, though:
ggplot(longtpm, aes(x=sample, y=TPM, fill=gene)) + geom_col() + mytheme


#' 4. Color the points in the volcano plot based on the fold change.  Red for greater than 1, blue for less. 

#' - We can use `cut` as we did above with the p-value.
diffexp$fclabel <- cut(diffexp$`Log2 Fold Change`, breaks=c(-Inf,1,Inf), include.lowest = T)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"))

#' - Probably, however, we wanted to color according to the *absolute value*, `abs`, of the fold change:
diffexp$fclabel <- cut(abs(diffexp$`Log2 Fold Change`), breaks=c(-Inf,1,Inf), include.lowest = T)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"))

#' - But now our legend doesn't make sense.  Because, cut made the labels based on the transformed values.  Let's edit the legend.
?scale_color_manual
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"), name="|Log2 fold change|", labels=c("<=1", ">1"))

#' 5. For heatmap using pheatmap, change annotation column colors.
ann_colors = list(
  Type = c(BM = "violetred", Th = "midnightblue")
)
pheatmap(tpm10[,9:12], labels_row = tpm10$gene, scale='row', annotation_col = annotation_col, annotation_colors = ann_colors)

#' 6. Make heatmap of top 10 up-regulated and top 10 down-regulated genes. Which table(s) would you use? (Different ways to do it; one way is to use `rbind`).

#' - We use the separate DEG up and down regulated tables.
downreg <- read_tsv("DEG.Down_Th_vs_BM_clean.txt")
upreg <- read_tsv("DEG.Up_Th_vs_BM_clean.txt")
downreg10 <- downreg[1:10,]
upreg10 <- upreg[1:10,]

#' - separate heatmaps
tpmdown <- filter(tpm, TranscriptID %in% downreg10$TranscriptID)
pheatmap(tpmdown[,9:12], labels_row = tpmdown$gene, scale='row')
tpmup <- filter(tpm, TranscriptID %in% upreg10$TranscriptID)
pheatmap(tpmup[,9:12], labels_row = tpmup$gene, scale='row')
#' - one heatmap with all:
?rbind
tpmupdown <- rbind(tpmup, tpmdown)
pheatmap(tpmupdown[,9:12], labels_row = tpmupdown$gene, scale='row')


