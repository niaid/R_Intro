
#' Use my library for some packages
.libPaths("/home/psubramanian/R/x86_64-conda_cos6-linux-gnu-library/3.5")


#' If you know ggplot2, can add some interactivity to plots.

#' Here is some code from last time where we made Fig. 3:
library(ggplot2)
data <- read.delim("Supp_Meth_T1_Supp_T4_merged.txt", stringsAsFactors = F)
names(data)[names(data) == "X.2x.within.population"] <- "gt.2x.within.population"
sub <- subset(data, !is.na(Count.after.outlier.removal))
neworder <- order(sub$Novel.variants, decreasing = T)
sub <- sub[neworder,]
sub$Add.variants <- cumsum(sub$Novel.variants)
colors <- c("red", "green", "yellow", "blue", "purple", "brown", "orange")

p0 <- ggplot(sub, aes(x=Population.Code, y=Add.variants, color=Country)) + scale_x_discrete(limits=sub$Population.Code) + scale_color_manual(values=colors)  + geom_point(size=3)
print(p0)

#' ggiraph library
library(ggiraph)
?geom_point_interactive

p1 <- ggplot(sub, aes(x=Population.Code, y=Add.variants, color=Country)) + scale_x_discrete(limits=sub$Population.Code) + scale_color_manual(values=colors) + geom_point_interactive(size=2, aes(tooltip=Novel.variants, data_id = Population.Code))
ip1 <- girafe(ggobj = p1)
print(ip1)
ip1


#' ggplotly
library(plotly)
ggplotly(p0)


#' Other kinds of plots common in Bioinformatics

#' Heatmap
A <- read.delim("example_metadata.txt")
B <- read.delim("example_microbiome.txt")
mat <- B[,3:12]
row.names(mat) <- B$Family

#' PCA


#' Plot with ggplot2


#' Non-ggplot library for "3d"
library(scatterplot3d)



#' More ggplot2 from last time!

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


