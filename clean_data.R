#!/usr/bin/env Rscript

#' Data is Supplementary tables from
#' Choudhury, A., Aron, S., Botigué, L.R. *et al.* High-depth African genomes inform human migration and health. *Nature* **586**, 741–748 (2020). https://doi.org/10.1038/s41586-020-2859-7

#' Read in spreadsheets - skipping first rows
T1 <- as.data.frame(readxl::read_excel("41586_2020_2859_MOESM3_ESM.xlsx", na = c('', '-'), skip=1, sheet= 'Supp Meth T1'))
T4 <- readxl::read_excel("41586_2020_2859_MOESM3_ESM.xlsx", sheet='Supp T4', skip=2)
 
#' **Clean up T4**
#' 
#' Europeans use '.' instead of ',' for grouping thousands, and my American
#' Excel reads those as decimals (and truncates zeroes :().  So, convert numerical
#' columns by multiplying by 1000
T4[,-1] <- 1000*T4[,-1]

#' **Clean up T1**
#' 
#' remove annotations at the bottom 
T1 <- subset(T1, !is.na(Country))


#' Only keep 3 letter Population code - no superscripts
T1$`Population Code` <- substr(T1$`Population Code`, 1,3)

#' Rename columns to also remove superscripts
names(T1)[names(T1) == "Coding variantsd"] <- "Coding variants"
names(T1)[names(T1) == "Count after outlier removal#"] <- "Count after outlier removal"


#' Remove ~ and x from Approximate Seq Depth since column title says it's approx
#' and depth implies x (and so the column can be numeric and easier to plot)
T1$`Approximate Seq Depth` <- as.numeric(gsub('[~x]', '', T1$`Approximate Seq Depth`))


#' Collapse WGR
wgr <- subset(T1, `Population Code` == 'WGR')
newwgr <- list("WGR", 
               "Gur speakers from West Africa (Kassena/Mossi)", 
               paste(wgr$Country, collapse="/"),
               paste(wgr$`Ethnolinguistic groups`, collapse = "/"),
               sum(wgr$`Sequence Count`),
               sum(wgr$`Post-QC Count`),
               mean(wgr$`Approximate Seq Depth`),
               mean(wgr$`Total Variants`),
               mean(wgr$`Coding variants`),
               sum(wgr$`Count after outlier removal`)
)
T1 <- subset(T1,  `Population Code` != 'WGR')
T1 <- rbind(T1, newwgr)

data <- merge(T1, T4, by.x = "Population Code", by.y = "Population", all.x=T)

#' Save as tab-delimited text
write.table(data, "Supp_Meth_T1_Supp_T4_merged.txt", sep = '\t', na='', row.names = F)
