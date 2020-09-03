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
#' 

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
unique(data$Location); dput(unique(data$Location))
ggplot(data, aes(x=Nestling, y=Totcare, color=Location)) + geom_point() + scale_color_manual(values=c("red", "green", "yellow", "blue", "purple", "brown", "orange", "forestgreen", "turquoise"))

colors <- c("red", "green", "yellow", "blue", "purple", "brown", "orange", "forestgreen", "turquoise")
names(colors) <- c("shrub", "decid", "bridge",  "ground", "bank", "building", "conif", 
                   "snag", "cliff")
ggplot(data, aes(x=Nestling, y=Totcare, color=Location)) + geom_point() + scale_color_manual(values=colors)


#' Other continuous palettes we can use for gradients [hcl.colors](https://developer.r-project.org/Blog/public/2019/04/01/hcl-based-color-palettes-in-grdevices/)
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"))

#' Change limits
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), limits=c(5,12.5))

ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), breaks=c(0, 5, 12.5), limits=c(0,12.5))

#' The legend represents the scale, so use scale function to change some elements.
ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), name="Number of eggs")

#' **Saving plots**
#'
#' Save most recent plot to file
ggsave("birdsnestplot.pdf")

#' Can also assign variable name to plot and then save that.
myplot <- ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), name="Number of eggs")
ggsave("myplot.pdf", plot=myplot)

#' ### Long vs wide data

#' ggplot expects **long data**.  Long data is where each column corresponds to a single variable, so you can match up variables to aesthetics.

#' Use `pivot_longer` from tidyr 

long <- tidyr::pivot_longer(data, cols = c("Nestling", "Incubate"), names_to="Caretype", values_to="Time")

#' ### Stacked bar graph
#' Change **geom** to change type of plot
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col()

#' Can make cosmetic changes with `theme`. text angle, justification, size, background colors, etc
?theme
?element_text
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col() + theme(axis.text.x = element_text(angle=90, hjust = 1, vjust = 0.5))

#' Save your theme to a variable, so you can re-use it over and over.
mytheme <- theme_minimal() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5))
ggplot(long, aes(x=Species, y=Time, fill=Caretype)) + geom_col() + mytheme

#' Unstacked barplot using position dodge or fill
longsub <- long[1:10,]
ggplot(longsub, aes(x=Species, y=Time, fill=Caretype)) + geom_col(position = "dodge") + mytheme

#' **Facets (and pie)**
ggplot(longsub, aes(x=Species, y=Time, fill=Caretype)) + geom_col(position = "fill") + coord_polar(theta="y")

#' use geom_col position fill with x=0
ggplot(longsub[1:2,], aes(x=0, y=Time, fill=Caretype)) + geom_col(position = "fill") + coord_polar(theta="y")

#' use facets
ggplot(longsub, aes(x=0, y=Time, fill=Caretype)) + geom_col(position = "fill") + coord_polar(theta="y") + facet_wrap(facets = vars(Species)) + mytheme + theme(strip.background = element_rect(fill="green"))

#' **Boxplot or Violin plot**
#' 
#' `geom_boxplot` or `geom_violin`
ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_boxplot() + mytheme 

#' with points - if you specify color or other parameter outside of `aes`, it will apply to all data in the plot.  Use more than one **geom**.
ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_point(color="red") + geom_boxplot() + mytheme 

#' Order matters!  Use `geom_jitter` so you can see more points - not all on top of each other.  And remove the black outliers that are plot by default for _cavity_
ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_boxplot() + geom_point(color="red") + mytheme

?geom_jitter
ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_boxplot() + geom_jitter(color="red", width = 0.25) + mytheme 

ggplot(long, aes(x=Nesttype, y=Totcare)) + geom_boxplot(outlier.shape = NA) + geom_jitter(color="red", width = 0.25) + mytheme 

#' ## More ways to plot

#' Can convert continuous scale to discrete scale by converting numerics to *factors*.
## try(ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point() + scale_color_hue())
ggplot(data, aes(x=Nestling, y=Totcare, color=as.factor(No.eggs))) + geom_point() + scale_color_hue()

#' ^ is silly example.  But makes more sense with fewer values or by *binning*.  Can use `cut`. Careful of breaks and labels and right left interval.
data$egglabel <- cut(data$No.eggs, breaks=c(1,5,12.5))
ggplot(data, aes(x=Nestling, y=Totcare, color=egglabel)) + geom_point() + scale_color_hue()


#' Label points with **[ggrepel](https://ggrepel.slowkow.com/index.html)** (better than geom_text)
ggplot(data[1:40,], aes(x=Nestling, y=Totcare, color=egglabel)) + geom_point() + geom_text(aes(label=Genus))
library(ggrepel)
ggplot(data[1:40,], aes(x=Nestling, y=Totcare, color=egglabel)) + geom_point() + geom_text_repel(aes(label=Genus))


#' Interactive plotting with **[ggiraph](https://davidgohel.github.io/ggiraph)** or **[plotly](https://plotly.com/r)** which build off of ggplot2

plotly::ggplotly(p=myplot)

library(ggiraph)
myplot2 <- ggplot(data, aes(x=Nestling, y=Totcare, color=No.eggs)) + geom_point_interactive(aes(tooltip=Genus, data_id=Species)) + scale_color_gradientn(colors=hcl.colors(5, palette = "plasma"), name="Number of eggs")
x <- girafe(ggobj = myplot2)
x <- girafe_options(x = x, opts_hover(css = "fill:red;stroke:black;r:5pt;") )
x


#' Heatmap with pheatmap.  Can make heatmap with `geom_raster`/`geom_tile` in ggplot2, but pheatmap is nicer.
library(pheatmap)

datamap <- data[,c("Incubate", "Nestling")]
row.names(datamap) <- data$Species

pheatmap(datamap, scale = 'column', cluster_cols = F)