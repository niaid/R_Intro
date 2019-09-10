#!/usr/bin/env Rscript
library(readxl)

#' Read in dataset
data <- read_excel("41589_2019_346_MOESM3_ESM.xlsx", skip = 6)
# View(data)

#' What kind of structure is `data`?
class(data)

#' We will only use the columns relating to frequency.
data <- data[,c(1:3, 15:25)]

#' Remove rows without any data
data <- data[-c(258,261, 262),]

#' Examine the column names
colnames(data)
class(colnames(data))

#' We would like to rename the columns to get rid of the `...`.  We can't completely get rid of the letter R
?paste
colnames(data)[4:14] <- paste0("R", c(3,5,7:15))

#' Change the format of the dataset to long
library(tidyr)
data <- gather(data, key="selection cycle", value="frequency", -c(1:3))

#' Now we can get rid of the letter R
data$`selection cycle` <- gsub("R", "", data$`selection cycle`)

## Come back and fix format
class(data$`selection cycle`)
data$`selection cycle` <- as.numeric(data$`selection cycle`)

#' The plots only use a subset of the data.

#' Graph (n)
ndata <- subset(data, Aptamer %in% c(51, 53, 54, 55))

#' Graph (m)
mdata <- subset(data, Aptamer %in% c(56, 57))


#' Graph (l)
data$Aptamer <- gsub('*', '', data$Aptamer) ## does this work?
data$Aptamer <- gsub('\\*', '', data$Aptamer)
data$Aptamer <- gsub('*', '', data$Aptamer, fixed = T)

ldata <- subset(data, Aptamer %in% c("46", "04")) # why do we need quotes?

#' Now we can plot!
library(ggplot2)
ggplot(mdata, aes(x=`selection cycle`, y=frequency, group=Aptamer, shape=Aptamer, color=Aptamer)) + geom_line() + geom_point() + scale_color_manual(values=c("black", "grey")) + theme_bw() + ylab("frequency [%]")

#' Fix selection cycle
## Go back up and fix it in data

#' Facets
fdata <- subset(data, !is.na(Aptamer))
fdata$graph <- NA

fdata$graph[which(fdata$Aptamer %in% c(51, 53, 54, 55))] <- "n"
fdata$graph[which(fdata$Aptamer %in% c(56, 57))] <- "m"
fdata$graph[which(fdata$Aptamer %in% c("46", "04"))] <- "l"


ggplot(fdata, aes(x=`selection cycle`, y=frequency, group=Aptamer, shape=Aptamer, color=Aptamer)) + geom_line() + geom_point() + theme_bw() + ylab("frequency [%]") + facet_wrap(~graph, scales="free_y") + scale_shape_manual(values=1:8)
ggsave("facetplot.pdf")

#' Save data.frame
write.csv(fdata, "fdata.csv")
