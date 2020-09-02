#' load library
library(dplyr) 

#' read in data.  [BirdNest](https://rdrr.io/rforge/Stat2Data/man/BirdNest.html)
data <- readr::read_csv("BirdNest.csv") %>%
  na.omit %>%
  mutate(Genus = stringr::str_split(Species, " ", simplify = T)[,1])


#' ## ggplot2

#' ggplot2 is based on *The Grammar of Graphics* by [Leland Wilkinson](https://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html).  But, nowadays we associate [GoG with Hadley Wickham](https://vita.had.co.nz/papers/layered-grammar.pdf) the author of ggplot2.  He is very influential in R programming - progenitor of the "tidyverse."  ggplot2 is probably the MOST popular plotting package in R, and heavily influences graphing grammars in other languages, notably python and js.

library(ggplot2)

#' ### Scatter plot

#' 1. start with ggplot function - specify data and "aesthetics"
#' 2. add "geoms" which are the type of plot (points, lines, bars, etc)
#' 3. add "scales" which further specify the aesthetics: axes, colors, sizes

#' *Aesthetics* map from variables in the data to components of the graph.
ggplot(data, aes(x=Nestling, y=Totcare)) + geom_point()


#' **Scales and colors**
#'
#' Plot log of Nestling 
data$logNestling <- log10(data$Nestling)
ggplot(data, aes(x=logNestling, y=Totcare)) + geom_point()

#' Could also change the scale.  *Scales* change the scale (quantitative or qualitative) of an aesthetic mapping. 
ggplot(data, aes(x=Nestling, y=Totcare)) + geom_point() + scale_x_log10()

#' Change the breaks
ggplot(data, aes(x=Nestling, y=Totcare)) + geom_point() + scale_x_log10(breaks=c(8,10,15,20))

#' We can color the points based on Location
ggplot(data, aes(x=Nestling, y=Totcare, color=Location)) + geom_point()

#' We can color the points based on number of eggs
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point()

#' **Q:** Why the difference in the color scales?
#'
#' **A:** Because we have different classes of variables.  No.eggs is a continuous numeric. And the Location is a discrete character/factor.
#'
#' For discrete scales, we use `scale_color_manual` to change the color.  We give one color for every distinct value of Location in our data. And use color scale to manually set the colors
unique(data$Location)
ggplot(data, aes(x=Nestling, y=Totcare, color=Location)) + geom_point() + scale_color_manual(values=c("red", "green", "yellow", "blue", "purple", "brown", "orange", "forestgreen", "turquoise"))

#' Other continuous palettes we can use for gradients [hcl.colors](https://developer.r-project.org/Blog/public/2019/04/01/hcl-based-color-palettes-in-grdevices/)
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"))

#' Change limits
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), limits=c(5,12.5))

#' The legend represents the scale, so use scale function to change some elements.
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), name="Number of eggs")

#' **Saving plots**
#'
#' Save most recent plot to file
ggsave("birdsnestplot.pdf")

#' Can also assign variable name to plot and then save that.


#' ### Long vs wide data

#' ggplot expects **long data**.  Long data is where each column corresponds to a single variable, so you can match up variables to aesthetics.

#' Use `pivot_longer` from tidyr 
library(tidyr)

long <- pivot_longer(data, cols = c("Nestling", "Incubate"), names_to="Caretype", values_to="Time")

#' Stacked bar graph
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col()

#' Can make cosmetic changes with `theme`. text angle, justification, size, background colors, etc
?theme
?element_text
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col() + theme(axis.text.x = element_text(angle=90))

#' Save your theme to a variable, so you can re-use it over and over.
mytheme <- theme_minimal() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5))
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col() + mytheme

#' Unstacked barplot using position dodge or fill
longsub <- long[1:10,]
ggplot(longsub, aes(x=Species, y=Time, fill=Caretype)) + geom_col(position = "dodge") + mytheme

#' Pie
ggplot(longsub, aes(x=Species, y=Time, fill=Caretype)) + geom_col() + coord_polar(theta="y")

#' use geom_bar which uses stat count and change theta or use geom_col position fill
ggplot(longsub[1:2,], aes(x=0, y=Time, fill=Caretype)) + geom_col(position = "fill") + coord_polar(theta="y")

#' use facets
ggplot(longsub, aes(x=0, y=Time, fill=Caretype)) + geom_col(position = "fill") + coord_polar(theta="y") + facet_wrap(facets = vars(Species))

#' Boxplot or Violin plot with points (remove outliers)
ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_boxplot() + mytheme


#' ### More ways to plot

#' Can convert continuous scale to discrete scale by converting numerics to *factors*.
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_hue()

#' ^ is silly example.  But makes more sense with fewer values or by *binning*.  Can use `cut`. Careful of breaks and labels and right left interval.
data$egglabel <- cut(data$No.eggs, breaks=c(1,5,12.5))
ggplot(data, aes(x=Nestling, y=Totcare, color=egglabel)) + geom_point() + scale_color_hue()


#' Label points with **ggrepel** (better than geom_text)
library(ggrepel)
ggplot(data[1:40,], aes(x=Nestling, y=Totcare, color=egglabel)) + geom_point() + geom_text_repel(aes(label=Genus))

#' Heatmap with pheatmap.  Can make heatmap with geom_raster/geom_tile But pheatmap is nicer.
library(pheatmap)
datamap <- data[,c("Incubate", "Nestling")]
row.names(datamap) <- data$Species
pheatmap(datamap, scale = 'column', cluster_cols = F)



