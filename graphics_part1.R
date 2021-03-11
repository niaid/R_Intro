#!/usr/bin/env Rscript

#' # Generating graphics in R - part I
#' MSB7102: R programming and Bioconductor


#' read in data.
#' Choudhury, A., Aron, S., Botigué, L.R. *et al.* High-depth African genomes inform human migration and health. *Nature* **586**, 741–748 (2020). https://doi.org/10.1038/s41586-020-2859-7
#' Data cleaned in [clean_data.R]
data <- read.delim("Supp_Meth_T1_Supp_T4_merged.txt", stringsAsFactors = F)
names(data)[names(data) == "X.2x.within.population"] <- "gt.2x.within.population"


#' ## ggplot2

#' ggplot2 is based on *The Grammar of Graphics* by [Leland Wilkinson](https://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html).  In R, we associate [GoG with Hadley Wickham](https://vita.had.co.nz/papers/layered-grammar.pdf) the author of ggplot2.  He is very influential in R programming - started the "tidyverse."  ggplot2 is probably the MOST popular plotting package in R.

library(ggplot2)

#' ### Basics

#' 1. start with ggplot function - specify data and "aesthetics"
#' 2. add "geoms" which are the type of plot (points, lines, bars, etc)
#' 3. add "scales" which further specify the aesthetics: axes, colors, sizes
#'

#' *Aesthetics* map from variables in the data to components of the graph. A **scatterplot**
ggplot(data, aes(x=Population.Code, y=Coding.variants)) + geom_point()


#' ## Scales (inc. Colors)
#'
#' Plot log of Sequence Count first making separate column logSC holding
#' log10 of data
data$logSC <- log10(data$Sequence.Count)



#' Could also change the scale.  *Scales* change the scale (quantitative or qualitative) of an aesthetic mapping.
ggplot(data, aes(x=Population.Code, y=Sequence.Count)) + geom_point() + scale_y_log10()

#' Change the breaks, labels (plotmath), limits 
ggplot(data, aes(x=Population.Code, y=Sequence.Count)) + geom_point() + scale_y_log10()

#' We can color the points based on Country
ggplot(data, aes(x=Population.Code, y=Sequence.Count, color=Country)) + geom_point()

#' We can color the points based on total number of variants
ggplot(data, aes(x=Population.Code, y=Sequence.Count, color=Total.Variants)) + geom_point()

#' **Q:** Why the difference in the color scales?
#'
#' **A:** Because we have different classes of variables.  Total.Variants is a continuous numeric. And Country is a discrete character/factor.

#' Other continuous palettes we can use for gradients with `scale_color_gradientn` [hcl.colors](https://developer.r-project.org/Blog/public/2019/04/01/hcl-based-color-palettes-in-grdevices/)
ggplot(data, aes(x=Population.Code, y=Sequence.Count, color=Total.Variants)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"))

#' What factors affect Total Variants? Post.QC.Count? Approximate.Seq.Depth?


#' The legend represents the scale, so use scale function to change some elements.
#' Change limits to 14000000 up to 22000000


#' Make scientific notation labels using format explicitly or as function
labels <- 10^6*c(12,14,16,18,20)
newlabels <- format(labels, scientific=T)


#' Change name of legend






#' **Let's make a plot like Fig. 3 in paper**
sub <- subset(data, !is.na(Count.after.outlier.removal))
neworder <- order(sub$Novel.variants, decreasing = T)
sub <- sub[neworder,]
sub$Add.variants <- cumsum(sub$Novel.variants)

#' For discrete scales, we use `scale_color_manual` to change the color.  We give one color for every distinct value of Country in our data. And use color scale to manually set the colors(see help(colors)), and order of legend.  Can also change size of points in geom_point. 
colors <- c("red", "green", "yellow", "blue", "purple", "brown", "orange")


#' ### Saving plots
#'
#' Save most recent plot to file
ggsave("plot1.pdf")

#' Can also assign variable name to plot and then save that.
myplot <- ggplot(data, aes(x=Population.Code, y=Post.QC.Count, color=Total.Variants)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), labels = function(x) format(x, scientific=T), name="number of total variants")
ggsave("myplot.pdf", plot=myplot)

#' ## Geoms
#' 
#' Change **geom** to change type of plot
ggplot(sub, aes(x=Population.Code, y=Novel.variants)) + geom_col()

#' ### Long vs wide data

#' Suppose we want to plot a **Stacked bar graph** of the novel variants, showing 
#' the proportion of singletons and proportion found >=2 times in the population 
sub$singleton <- sub$Novel.variants - sub$gt.2x.within.population


#' ggplot expects **long data**.  Long data is where each column corresponds to a single variable, so you can match up variables to aesthetics.

#' Use `pivot_longer` from tidyr or `melt` from reshape2
long <- reshape2::melt(sub, measure.vars = c("singleton", "gt.2x.within.population"), variable.name="Frequency", value.name = "Num.variants")

long <- tidyr::pivot_longer(sub, cols = c("singleton", "gt.2x.within.population"), names_to="Frequency", values_to="Num.variants")

#' Now we can color our bars based on the Frequency
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col()


#' ## Theme
#' 
#' Can make cosmetic changes with `theme`. text angle, justification, size, background colors, etc
?theme
?element_text
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col() + theme(axis.text.x = element_text(size=5))

#' Move legend inside plot with legend.position and legend.justification.  change background of legend
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col()


#' Save your theme to a variable, so you can re-use it over and over.
mytheme <- theme_light() + theme(axis.text.x = element_text(size=5))
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col() + mytheme

#' Unstacked barplot using position dodge or fill
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col() + mytheme


#' ## Facets
#'
#' For **pie graph** add polar coordinates mapping y to angle 
#' - try different geom_col position
ggplot(long, aes(x=Population.Code, y=Num.variants, fill=Frequency)) + geom_col()

#' plot single pie with x=0
longsub <- long[1:2,]


#' use facets
ggplot(long, aes(x=0, y=Num.variants, fill=Type)) + geom_col(position = "fill") + coord_polar(theta="y") 

#' ## More geoms
#' 
#' **Boxplot or Violin plot**
#'
#' `geom_boxplot` or `geom_violin`
ggplot(data, aes(x = Approximate.Seq.Depth, y=Coding.variants/Post.QC.Count)) + geom_boxplot()

#' Can convert continuous scale to discrete scale by converting numerics to *characters*.

#' with points - if you specify color or other parameter outside of `aes`, it will apply to all data in the plot.  Use more than one **geom**.
ggplot(data, aes(x = as.character(Approximate.Seq.Depth), y=Coding.variants/Post.QC.Count)) + geom_boxplot()

#' Order matters!  


#'Use `geom_jitter` so you can see more points - not all on top of each other.  And remove the black outliers
?geom_jitter
ggplot(data, aes(x = as.character(Approximate.Seq.Depth), y=Coding.variants/Post.QC.Count))  + geom_boxplot() + geom_jitter(color="red", width = 0.25, height = 0)



