
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

