## Exercise solution

[exercise_solution.R script](exercise_solution.R)

We will need the libraries loaded and the variables that were created in
*notes.R* to do the exercises. If you don’t already have them in your
environment, you can re-run the script with `source` - same as clicking
the button in RStudio. *Be careful* using `source` in general for your
own work - it will re-run ALL the commands including saving the plots.
Make sure you don’t overwrite something you need.

``` r
source('notes.R')
```

### Exercises

1.  Plot scatterplot gene vs TPM using just the top 10 genes with each
    sample a different color.

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-3-1.pdf)<!-- -->

2.  Make your plots look pretty or at least suitable for publication.
    Use a theme\! Increase the font size to 14. Use an existing theme
    (or make your own from scratch :-o with `theme`)

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point() + theme(text = element_text(size=14))
```

![](notes_files/figure-gfm/soln-unnamed-chunk-4-1.pdf)<!-- -->

  - update mytheme also adding the `vjust` parameter to center the axis
    labels on the grid:

<!-- end list -->

``` r
mytheme <- mytheme + theme(text = element_text(size=14), axis.text.x=element_text(vjust = 0.5))
ggplot(longtpm, aes(x=gene, y=TPM, color=sample)) + geom_point() + mytheme
```

![](notes_files/figure-gfm/soln-unnamed-chunk-5-1.pdf)<!-- -->

3.  Look up geom\_line (or geom\_bar) help. Make the same plot as \#1
    with lines (or bars) instead of points.

<!-- end list -->

  - **Line plot**: uses `group` aesthetic to connect coordinates in same
    line.

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=sample)) + geom_line()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-6-1.pdf)<!-- -->

  - What happens if we group by gene instead?

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=gene)) + geom_line()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-7-1.pdf)<!-- -->

  - Can plot points AND lines.

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, color=sample, group=sample)) + geom_line() + geom_point()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-8-1.pdf)<!-- -->

  - Since we set the color aesthetic in the `ggplot` function, lines AND
    points were colored the same. If we move the color to geom\_point:

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_line() + geom_point(aes(color=sample))
```

![](notes_files/figure-gfm/soln-unnamed-chunk-9-1.pdf)<!-- -->

  - Order of geoms determines which gets drawn first. Set the size of
    the points to be something big so we can see the difference:

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_line() + geom_point(aes(color=sample), size=5)
```

![](notes_files/figure-gfm/soln-unnamed-chunk-10-1.pdf)<!-- -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, group=sample)) + geom_point(aes(color=sample), size=5) + geom_line()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-10-2.pdf)<!-- -->

  - **Bar plot**. `geom_bar` makes a frequency chart. To make a bar plot
    like we usually think, use `geom_col`. Bars have a color - border,
    and a fill - color of the interior of bar.

<!-- end list -->

``` r
ggplot(longtpm, aes(x=gene, y=TPM, fill=sample)) + geom_col()
```

![](notes_files/figure-gfm/soln-unnamed-chunk-11-1.pdf)<!-- -->

by default values with the same x coordinate are stacked. We can put
them side-by-side:

``` r
ggplot(longtpm, aes(x=gene, y=TPM, fill=sample)) + geom_col(position = position_dodge())
```

![](notes_files/figure-gfm/soln-unnamed-chunk-12-1.pdf)<!-- -->

Sometimes we might like to stack, though:

``` r
ggplot(longtpm, aes(x=sample, y=TPM, fill=gene)) + geom_col() + mytheme
```

![](notes_files/figure-gfm/soln-unnamed-chunk-13-1.pdf)<!-- -->

4.  Color the points in the volcano plot based on the fold change. Red
    for greater than 1, blue for less.

<!-- end list -->

  - We can use `cut` as we did above with the p-value.

<!-- end list -->

``` r
diffexp$fclabel <- cut(diffexp$`Log2 Fold Change`, breaks=c(-Inf,1,Inf), include.lowest = T)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"))
```

![](notes_files/figure-gfm/soln-unnamed-chunk-14-1.png)<!-- -->

  - Probably, however, we wanted to color according to the *absolute
    value*, `abs`, of the fold change:

<!-- end list -->

``` r
diffexp$fclabel <- cut(abs(diffexp$`Log2 Fold Change`), breaks=c(-Inf,1,Inf), include.lowest = T)
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"))
```

  - But now our legend doesn’t make sense. Because, cut made the labels
    based on the transformed values. Let’s edit the legend.

<!-- end list -->

``` r
?scale_color_manual
ggplot(diffexp, aes(x=`Log2 Fold Change`, y=`-Log10 adj. p`, color=fclabel)) + geom_point() + scale_color_manual(values=c("blue", "red"), name="|Log2 fold change|", labels=c("<=1", ">1"))
```

![](notes_files/figure-gfm/soln-unnamed-chunk-16-1.png)<!-- -->

5.  For heatmap using pheatmap, change annotation column colors.

<!-- end list -->

``` r
ann_colors = list(
  Type = c(BM = "violetred", Th = "midnightblue")
)
pheatmap(tpm10[,9:12], labels_row = tpm10$gene, scale='row', annotation_col = annotation_col, annotation_colors = ann_colors)
```

![](notes_files/figure-gfm/soln-unnamed-chunk-17-1.pdf)<!-- -->

6.  Make heatmap of top 10 up-regulated and top 10 down-regulated genes.
    Which table(s) would you use? (Different ways to do it; one way is
    to use `rbind`).

<!-- end list -->

  - We use the separate DEG up and down regulated tables.

<!-- end list -->

``` r
downreg <- read_tsv("DEG.Down_Th_vs_BM_clean.txt")
upreg <- read_tsv("DEG.Up_Th_vs_BM_clean.txt")
downreg10 <- downreg[1:10,]
upreg10 <- upreg[1:10,]
```

  - separate heatmaps

<!-- end list -->

``` r
tpmdown <- filter(tpm, TranscriptID %in% downreg10$TranscriptID)
pheatmap(tpmdown[,9:12], labels_row = tpmdown$gene, scale='row')
```

![](notes_files/figure-gfm/soln-unnamed-chunk-19-1.pdf)<!-- -->

``` r
tpmup <- filter(tpm, TranscriptID %in% upreg10$TranscriptID)
pheatmap(tpmup[,9:12], labels_row = tpmup$gene, scale='row')
```

![](notes_files/figure-gfm/soln-unnamed-chunk-19-2.pdf)<!-- -->

  - one heatmap with all:

<!-- end list -->

``` r
tpmupdown <- rbind(tpmup, tpmdown)
pheatmap(tpmupdown[,9:12], labels_row = tpmupdown$gene, scale='row')
```

![](notes_files/figure-gfm/soln-unnamed-chunk-20-1.pdf)<!-- -->
