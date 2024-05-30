#### Package ####
install.packages("readxl")
install.packages("matlib")
install.packages("dplyr")
install.packages("mvnormtest")
install.packages("MVTests")
install.packages("profileR")
install.packages("rstatix")
library(readxl)
library(matlib)
library(dplyr)
library(mvnormtest)
library(MVTests)
library(profileR)
library(rstatix)


#### Import Data Set ####
df <- read_excel("C:/Users/TOSHIBA/Desktop/Semester 5/Analisis Mutivariat 1/Project/data.xlsx")
df$sleep <- as.factor(df$sleep)
View(df)


#### EDA ####
str(df)
df1 <- df[1:15,]
df2 <- df[16:30,]
summary(df1)
summary(df2)
par(mfrow = c(2,2))
boxplot(df$gpa~df$sleep,
        main = "GPA",
        xlab = "Sleep",
        ylab = "GPA")
boxplot(df$passed_unit_tests~df$sleep,
        main = "Passed Unit Tests",
        xlab = "Sleep",
        ylab = "Passed Unit Tests")
boxplot(df$passed_asserts~df$sleep,
        main = "Passed Asserts",
        xlab = "Sleep",
        ylab = "Passed Asserts")
boxplot(df$tackled_user_stories~df$sleep,
        main = "Tackled User Stories",
        xlab = "Sleep",
        ylab = "Tackled User Stories")


#### Uji Asumsi ####
#Multivariat Normal
mshapiro.test(t(df[,2:5]))

#Homogenitas
BoxM(data = df[,2:5], df$sleep)

#Outlier
#Deteksi Multivariat Outlier
df %>%
  group_by(sleep)%>%
  mahalanobis_distance()%>%
  filter(is.outlier == TRUE) %>%
  as.data.frame()

#Multikolinearitas
df%>%
  cor_test(gpa, passed_unit_tests, passed_asserts, tackled_user_stories)


#### MANOVA One Way ####
mod <- manova(
  cbind(df$gpa, df$passed_unit_tests, df$passed_asserts, df$tackled_user_stories)~df$sleep
)
summary(mod)

#Matrik H dan E
H <- summary(mod)$SS[1]
E <- summary(mod)$SS[2]
matrix_H <- matrix(unlist(H),ncol = 4,byrow = TRUE); matrix_H
matrix_E <- matrix(unlist(E),ncol = 4,byrow = TRUE); matrix_E

#Wilks Test
summary(mod, test = "Wilks")

#Hotelling-Lawley Test
summary(mod, text = "Hotelling-Lawley")

#Pillai Test
summary(mod, text = "Pillai")

#Roy Test
summary(mod, test = "Roy")


#### Uji Lanjutan (ANOVA One Way) ####
#Untuk mengetahui variabel mana yang berbeda signifikan
summary(aov(mod))


#### Profile Analysis ####
par(mfrow = c(1,1))
profile <-
  pbg(
    data = as.matrix(df[, 2:5]),
    group = as.matrix(df[, 1]),
    original.names = TRUE,
    profile.plot = TRUE
  )
summary(profile)
