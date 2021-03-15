####### 0. import data
library(readr)
BirdNest <- read_csv("BirdNest.csv")  # read data from csv file
# If you did not set work directory or would like to read in file from other folder instead of working directory, specify path above

####### 1. select 
# select four columns: Length, Nesttype, Location, No.eggs from original data, return the first six rows.
library(dplyr)
select <- select(BirdNest, Length, Nesttype, Location, No.eggs)
head(select)

# remove two columns: Species and Common from original data  
drop <- select(BirdNest,-(Species:Common))
head(drop)

# select variables contain "nest" (default case insensitive)
head(select(BirdNest, contains("nest")))

##### 2. filter  
# select rows with Length more than 30
filter(BirdNest, Length>30)

# select rows with No.eggs more than 6 and Location in "decid"
filter(BirdNest, No.eggs>6 , Location %in% c("decid")) ## or Location=="decid" if just one level

# **Question:**
# Could you filter the rows with levels contains "Jay" in Common column? (hint: use grepl function)
filter(BirdNest ,grepl("Jay",Common))

##### 3. mutate  
head(mutate(BirdNest, ratio = Incubate/Totcare))
head(mutate(BirdNest, ratio = Incubate/Totcare, inverse = 1/ratio))
head(mutate(BirdNest, cumsum_total = cumsum(Totcare)))
head(mutate(BirdNest, nor_Nest = Nestling/mean(Nestling, na.rm=T))) # na.rm=T removes the missing value when calculating mean 
head(mutate(BirdNest, cup_type = case_when(Nesttype == "cup"~ 1, Nesttype != "cup"~ 0)))
head(mutate(BirdNest, cup_type = ifelse(Nesttype == "cup", 1,0)))
a <- mutate(BirdNest, totcare_gt27 = case_when(Totcare >27 ~ 1, Totcare <=27~ 0))
table(a$totcare_gt27) # missing value is NA
b <- mutate(BirdNest, totcare_gt27 = case_when(Totcare >27 ~ 1, Totcare <=27~ 0, TRUE ~999)) 
table(b$totcare_gt27) # missing value is defined
c <- mutate(BirdNest, totcare_mul = case_when(Totcare <27 ~ 0, Totcare >=30~ 2, Totcare >= 27 & Totcare <30 ~1))
table(c$totcare_mul) # missing value is defined
d <- mutate(BirdNest, totcare_gt27 = ifelse(Totcare >27 ,1, 0)) # become complex if multiple crtieria
table(d$totcare_gt27)

##### 4. arrange  
# Order the data by ascending length
head(arrange(BirdNest, Length))
head(arrange(BirdNest, Length, No.eggs))

# Order Common by descending
head(arrange(BirdNest, desc(Common)))

##### 5. pipes 
head(select(BirdNest, Length, Nesttype, Location, No.eggs))
# equals to
head(BirdNest %>% select(Length, Nesttype, Location, No.eggs))

head(filter(BirdNest, No.eggs>6 , Location %in% c("decid")))
# equals to
head(BirdNest %>% filter( No.eggs>6 , Location %in% c("decid")))

# add layer
BirdNest %>% 
  filter( No.eggs>6 , Location %in% c("decid")) %>% 
  select(Species, Common, No.eggs, Location)

#**Question:**
#  Could you output top 10 observations with largest length? 
BirdNest %>%
  arrange(desc(Length) ) %>% 
  head(n = 10)

##### 6. summarise  
# to create a summery about average, variance of length, and count distinct egg color 
BirdNest %>% summarise(mean_length = mean(Length), var_Length = var(Length), n_distict_color = n_distinct(Color))  

# to create a summery respective to same fields above within each egg color.
BirdNest %>% 
  group_by(Color) %>% 
  summarise(mean_length = mean(Length), var_Length = var(Length), n_distict_color = n_distinct(Color)) 

##### 7. group by  
# create summary about mean and variance of legnth, number of distinct location by color and nesttype
BirdNest %>% 
  group_by(Color,Nesttype) %>% 
  summarise(mean_length = mean(Length), num_obs = n(), n_distict_location = n_distinct(Location))

#**Take home question:  **
# Could you create a summary about the largest ratio (ratio = Nestling / Totcare) by nest type (excluding "cavity" category) and present the result in a descending order?
BirdNest %>% 
filter(!grepl("cavity",Nesttype)) %>% 
  mutate(ratio = Nestling / Totcare) %>% 
  group_by(Nesttype) %>% 
  summarise(max_ratio = max(ratio, na.rm=T)) %>%
  arrange(desc(max_ratio)) 

  