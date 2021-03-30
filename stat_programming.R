# 0. Summary statistics
library(Stat2Data)
data(BirdNest) 
mean(BirdNest$Totcare, na.rm=T)
median(BirdNest$Totcare, na.rm=T)
var(BirdNest$Totcare,  na.rm=T)
sd(BirdNest$Totcare,  na.rm=T)
quantile(BirdNest$Totcare, probs = seq(0, 1, 0.25), na.rm = T)
IQR(BirdNest$Totcare, na.rm=T)

# 1. Pearson Correlation
Normal <- c(56,56,65,65,50,25,87,44,35)
Hypervent <- c(87,91,85,91,75,28,122,66,58)
plot(Normal, Hypervent)
cor(Normal, Hypervent, method = "pearson")
cor.test(Normal, Hypervent, method = "pearson")

# 2. Spearman's rank correlation coefficientplot(BirdNest$Length, BirdNest$No.eggs)
cor(BirdNest$Length, BirdNest$No.eggs, method = "spearman")
cor.test(BirdNest$Length, BirdNest$No.eggs, method = "spearman", exact = T)

# 3. Cramer's V
#install.packages("rcompanion")
library(rcompanion)
cramerV(BirdNest$Closed.,BirdNest$Color)
cramerV(BirdNest$Closed.,BirdNest$Location)
cramerV(BirdNest$Closed.,BirdNest$Nesttype)

# 4. Compare the means of two groups / multiple groups
# create data for t-test
library(dplyr)
t_test_data <- 
  BirdNest %>% filter(Location	%in% c("ground", "decid")) 
group_by(t_test_data, Location) %>%
  summarise(
    count = n(),
    mean = mean(Totcare, na.rm = TRUE),
    sd = sd(Totcare, na.rm = TRUE))

# visualize data
#install.packages("ggpubr")
library(ggpubr)
ggboxplot(t_test_data, x = "Location", y = "Totcare", 
          color = "Location", palette = c("#00AFBB", "#E7B800"),
          ylab = "Totcare", xlab = "Location")

# Shapiro-Wilk normality test for decid's Totcare
with(t_test_data, shapiro.test(Totcare[Location == "decid"]))# p = 0.5101
# Shapiro-Wilk normality test for ground's Totcare
with(t_test_data, shapiro.test(Totcare[Location == "ground"])) # p = 0.1502

# check equal variances
#  F-test to test for homogeneity in variances
res.ftest <- var.test(Totcare ~ Location, data = t_test_data) # p = 0.5472
res.ftest

# perform t-test
res <- t.test(Totcare ~ Location, data = t_test_data, var.equal = TRUE)
res # p = 7.138e-07

res$conf.int

# Mann-whitney test
wilcox.test(Totcare ~ Location, data = t_test_data, exact=F)

# ANOVA
aov.data <- BirdNest %>% filter(Location	%in% c("ground", "shrub","decid")) 
res.aov <- aov(Totcare ~ Location, data = aov.data)
summary(res.aov)

# nonparametric Kruskal-Wallis test
kruskal.test(Totcare ~ Location, data = aov.data)

# 5. Chi-square test
library(rcompanion)
table <- data.frame(
  smoker=c("Yes","No","Yes","No"),
  lung_cancer=c("Cases","Cases","Control","Control"),
  count=c(688,21,650,59)
)

ctable <- xtabs(count ~ smoker + lung_cancer, data=table);ctable
chisq.test(ctable, correct = FALSE)

# 6. Fisher exact test
tea <- matrix(c(3,1,1,3),ncol=2,byrow=TRUE)
dimnames(tea) <- list(PouringFirst=c("Milk","Tea"), GuessPouredFirst=c("Milk","Tea"))
tea
fisher.test(tea, alternative = "greater") # set alternative to "greater", "less", "two.sided"

# 7. Linear regression
lm_data <- read.table("http://www.statsci.org/data/general/cofreewy.txt", header = T)
head(lm_data)

plot(lm_data)

lm.fit <- lm(CO~.,lm_data)
summary(lm.fit)
shapiro.test(lm.fit$res)
qqnorm(lm.fit$res);qqline(lm.fit$res)

hist(lm.fit$res) # residual
plot(lm.fit$fitted.values, lm.fit$residuals) # residual vs fitted value 
plot(lm_data$Hour, lm.fit$res) # residuals vs time order

# stepwise model
lm.step <- step(lm.fit, direction = "backward")
summary(lm.step)
shapiro.test(lm.step$res)

hist(lm.step$res)
qqnorm(lm.step$res);qqline(lm.step$res)
plot(lm_data$Hour, lm.step$res)

# play around other posibilities
lm.co <- step(lm(CO ~ Traffic + Wind + Wind^2 + sin((2 * pi)/24 * Hour) +
                   cos((2 * pi)/24 * Hour) + sin((4 * pi)/24 * Hour) + cos((4 * pi)/24 * Hour), lm_data), direction = "backward")
summary(lm.co)

# residual check
hist(lm.co$res) # residual
shapiro.test(lm.co$res)
qqnorm(lm.co$res);qqline(lm.co$res)
plot(lm.co$fitted.values, lm.co$residuals) # residual vs fitted value 
plot(lm_data$Hour, lm.co$res) # residuals vs time order

# 8. Format data
#install.packages("table1")
library(table1)
table <- table1(~  Totcare + factor(Nesttype)  | Location, data=t_test_data);table

#install.packages("finalfit")
library(finalfit)
dependent = "differ.factor"

# Specify explanatory variables of interest
explanatory = c("age", "sex.factor", 
                "extent.factor", "obstruct.factor", 
                "nodes")

colon_s %>% 
  summary_factorlist(dependent, explanatory, 
                     p=TRUE, na_include=TRUE)





