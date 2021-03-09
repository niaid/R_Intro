# step1: download from github:
# step2: open html 
# step3: create R script, paste code to a new R script

# 0.1 Create workspace

# 0.2 Set working directory
getwd()

# 0.3 install R packages  
install.packages("readr") #install one package
install.packages(c("dplyr", "Stat2Data","naniar","tidyverse")) # install multiple packages

library(Stat2Data)  # library package before use it
library(dplyr)
library(tidyverse)

# 0.4 Operator 

# 0.5 data type and generate data object
# create a vector
id <- c(seq(1,5,by=1))
name <- c("apple","pear","strawberry","banana","watermelon")

# create data frame
fruit_menu <- data.frame(id,name);fruit_menu

# create matrix
fruit_matrix <- as.matrix(fruit_menu);fruit_matrix
num_mat <- matrix(c(1:9),ncol=3)

# create list
fruit_list <- list(fruit_menu);fruit_list

# create another data frame for merging practice
fruit_price <- data.frame(id = c(1,2,3,5,6),price = c(3,2,4,2,10));fruit_price

# merge two data sets
complete_menu_data <- merge(fruit_menu, fruit_price, all.x = T, by.x = "id", by.y = "id");complete_menu_data # all rows in fruit_menu
complete_price_data <- merge(fruit_menu, fruit_price, all.y = T, by.x = "id", by.y = "id");complete_price_data # all rows in fruit_price

# 0.6 import data   
library(readr)
BirdNest <- read_csv("BirdNest.csv")  # read data from csv file
# If you did not set work directory or would like to read in file from other folder instead of working directory, specify path above

library(Stat2Data)
data(BirdNest)  # get BirdNest data
str(BirdNest)

# 0.7 getting help
help(read_csv)

# 0.8 basic functions to learn about your data  
sapply(BirdNest, class) # check the type of each variable in BirdNest
dim(BirdNest)  # dimension
colnames(BirdNest) 
BirdNest[!complete.cases(BirdNest),] # return all rows with missing value in BirdNest; use "complete.cases()" for non-missings; use "!" for negation (NOT)
class(BirdNest)  # the type of the data set 
head(BirdNest)  # first six rows
table(BirdNest$Location) # return all unique value with frequency in Location variable of BirdNest
unique(BirdNest$Location) # return all unique value in factor
length(unique(BirdNest$Location)) # return the number of unique value in factor
table(is.na(BirdNest$Location))
table(is.na(BirdNest$Totcare))

# 0.9 creating new variable and select variables by critieria
BirdNest$cup_type <- ifelse(BirdNest$Nesttype == "cup", 1, 0); table(BirdNest$cup_type) # create binary variable to indicate "cup" type nest
BirdNest$white_cup <- ifelse(BirdNest$Nesttype == "cup" & BirdNest$Color == 1, 1, 0); table(BirdNest$white_cup) # create binary variable to indicate "cup" and "white" nest
BirdNest$cup_cavity <- ifelse(BirdNest$Nesttype %in% c("cup","cavity") , 1, 0); table(BirdNest$cup_cavity) # create binary variable to indicate "cup" or "cavity" type nest
BirdNest$cu_type <- ifelse(grepl("cu",BirdNest$Nesttype)==TRUE,1,0); table(BirdNest$cu_type) # create binary variable to indicate "cu" type nest
select1 <- BirdNest[,grepl("Co",colnames(BirdNest)) ];colnames(select1)
select2 <- BirdNest[,colnames(BirdNest) %in% c("Common","Color") ];colnames(select2)

# 0.10 missing value 
example <- data.frame(id = seq(1:4),name = c("Apple","NA","Orange","Banana"));example

library(naniar)
na_strings <- c("NA")
example_clean <- example %>%
  replace_with_na_all(condition = ~.x %in% na_strings)

example_clean


# 0.11 Reshape data
long_data <- read.table(header=TRUE, text='
 subject sex condition measurement
       1   M   control         7.9
       1   M     cond1        12.3
       1   M     cond2        10.7
       2   F   control         6.3
       2   F     cond1        10.6
       2   F     cond2        11.1
       3   F   control         9.5
       3   F     cond1        13.1
       3   F     cond2        13.8
       4   M   control        11.5
       4   M     cond1        13.4
       4   M     cond2        12.9
')

# long to wide
library(tidyr)
wide_data <- spread(long_data,condition,measurement)  # tidyr
wide_data

# long to wide
library(reshape2)
wide_data2 <- dcast(long_data, subject + sex ~ condition, value.var="measurement") # reshape2
wide_data2

# wide to long
data_long <- gather(wide_data, condition, measurement, cond1:control, factor_key=TRUE) # tidyr
data_long

# wide to long
data_long2 <- melt(wide_data, id.vars=c("subject", "sex")) # reshape2
data_long2

# end
