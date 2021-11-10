# Week 7 Homework
# What the Error Distribution of the data are 
# Which of the predictor (x) variables have a significant effect on the y variable 

library(vroom)
library(tidyverse)
library(ggplot2)
library(scales)
library(gamlr)

raw_1 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%206/data%201.csv")
raw_2 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%206/data%202.csv")
raw_3 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%206/data%203.csv")
raw_4 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%206/data%204.csv")

###############################################################################
# Data Set: raw_1
# X1
mod_raw_1_x1_gaussian <- glm(y ~ x1, data = raw_1, family = "gaussian")
mod_raw_1_x1_poisson <- glm(y ~ x1, data = raw_1, family = "poisson")
mod_raw_1_x1_gaussian_log <- glm(y ~ x1, data = raw_1, family = gaussian(link = "log"))
mod_raw_1_x1_gaussiahn_inverse <- glm(y ~ x1, data = raw_1, family = gaussian(link = "inverse"))

##compare the models
AIC_mods_1 <- data.frame(model = c("mod_raw_1_x1_gaussian", "mod_raw_1_x1_poisson", "mod_raw_1_x1_gaussian_log", "mod_raw_1_x1_gaussiahn_inverse"),
                       AICc = c(AICc(mod_raw_1_x1_gaussian), AICc(mod_raw_1_x1_poisson), AICc(mod_raw_1_x1_gaussian_log), AICc(mod_raw_1_x1_gaussiahn_inverse)))

## rank them by AIC using the order() function
AIC_mods_1[order(AIC_mods_1$AICc),]


###############################################################################

# X2
mod_raw_1_x2_gaussian <- glm(y ~ x2, data = raw_1, family = "gaussian")
mod_raw_1_x2_poisson  <- glm(y ~ x2, data = raw_1, family = "poisson")
mod_raw_1_x2_gaussian_log <- glm(y ~ x2, data = raw_1, family = gaussian(link = "log"))
mod_raw_1_x2_gaussian_inverse <- glm(y ~ x2, data = raw_1, family = gaussian(link = "inverse"))
##compare the models
AIC_mods_2 <- data.frame(model = c("mod_raw_1_x2_gaussian", "mod_raw_1_x2_poisson", "mod_raw_1_x2_gaussian_log", "mod_raw_1_x2_gaussian_inverse"),
                         AICc = c(AICc(mod_raw_1_x2_gaussian), AICc(mod_raw_1_x2_poisson), AICc(mod_raw_1_x2_gaussian_log), AICc(mod_raw_1_x2_gaussian_inverse)))

## rank them by AIC using the order() function
AIC_mods_2[order(AIC_mods_1$AICc),]

###############################################################################

#X3
mod_raw_1_x3_gaussian <- glm(y ~ x3, data = raw_1, family = "gaussian")
mod_raw_1_x3_poisson  <- glm(y ~ x3, data = raw_1, family = "poisson")
mod_raw_1_x3_gaussian_log <- glm(y ~ x3, data = raw_1, family = gaussian(link = "log"))
mod_raw_1_x3_gaussian_inverse <- glm(y ~ x3, data = raw_1, family = gaussian(link = "inverse"))

AIC_mods_3 <- data.frame(model = c("mod_raw_1_x3_gaussian", "mod_raw_1_x3_poisson", "mod_raw_1_x3_gaussian_log", "mod_raw_1_x3_gaussian_inverse"),
                         AICc = c(AICc(mod_raw_1_x3_gaussian), AICc(mod_raw_1_x3_poisson), AICc(mod_raw_1_x3_gaussian_log), AICc(mod_raw_1_x_gaussian_inverse)))

## rank them by AIC using the order() function
AIC_mods_3[order(AIC_mods_1$AICc),]
###############################################################################

#X4
mod_raw_1_x4_gaussian <- glm(y ~ x4, data = raw_1, family = "gaussian")
mod_raw_1_x4_poisson  <- glm(y ~ x4, data = raw_1, family = "poisson")
mod_raw_1_x4_gaussian_log <- glm(y ~ x4, data = raw_1, family = gaussian(link = "log"))
mod_raw_1_x4_gaussian_inverse <- glm(y ~ x4, data = raw_1, family = gaussian(link = "inverse"))

AIC_mods_4 <- data.frame(model = c("mod_raw_1_x4_gaussian", "mod_raw_1_x4_poisson", "mod_raw_1_x4_gaussian_log", "mod_raw_1_x4_gaussian_inverse"),
                         AICc = c(AICc(mod_raw_1_x4_gaussian), AICc(mod_raw_1_x4_poisson), AICc(mod_raw_1_x4_gaussian_log), AICc(mod_raw_1_x4_gaussian_inverse)))

## rank them by AIC using the order() function
AIC_mods_4[order(AIC_mods_1$AICc),]

library(patchwork)

p1 <- ggplot(data = raw_1, aes(x = x1, y =y)) + 
  geom_line()
p2 <- ggplot(data = raw_1, aes(x = x2, y =y)) + 
  geom_line()
p3 <- ggplot(data = raw_1, aes(x = x3, y =y)) + 
  geom_line()
p4 <- ggplot(data = raw_1, aes(x = x4, y =y)) + 
  geom_line()

p5 <- p1 + p2 + p3 + p4
p5

p3

p_raw3 <- ggplot(data = raw_3, aes(x = x1, y = y)) + geom_line()
p_raw3
