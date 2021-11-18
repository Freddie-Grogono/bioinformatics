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

# All of the models look identically ranked 
plot(mod_raw_1_x1_gaussian)
plot(mod_raw_1_x1_poisson)
plot(mod_raw_1_x1_gaussian_log)
plot(mod_raw_1_x1_gaussiahn_inverse)

# Looking at all of the summary 
summary(mod_raw_1_x1_gaussian) #x1 -0.0006235  0.0618441   -0.01    0.992  
summary(mod_raw_1_x1_poisson)
summary(mod_raw_1_x1_gaussian_log)
summary(mod_1_gaussiahn_inverse)

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


big_boy_glm <- glm(y ~ x1 + x2 + x3 + x4,
                   data = raw_1,
                   family = "gaussian") 

plot(big_boy_glm)

# Decided to pivot the data and start investigating it that way instead: 
pivot_raw_1 <- pivot_longer(data = raw_1, x1: x4, names_to = "response", values_to = "value") 
raw_1_plot <- ggplot(data = pivot_raw_1, aes(x = value, y = y)) + geom_point(aes(col = response)) + geom_line()

# Plotting a linear regression:
mod_pivot_raw_1 <- glm(y ~ value,
                ##specify the data
                data = pivot_raw_1,
                ##specify the error structure
                family = "gaussian")
mod_pivot_raw_1

# Investigate the class of the model 
class(mod_pivot_raw_1)

# Setup the multi-panel plot 
par(mfrow = c(2, 2))

# have a look at the plots 
plot(mod_pivot_raw_1)

#Normal Q-Q plot does not look good at all 
mod_1_gaussian <- glm(y ~ value, data = pivot_raw_1, family = "gaussian")
mod_1_poisson <- glm(y ~ value, data = pivot_raw_1, family = "poisson")
mod_1_gaussian_log <- glm(y ~ value, data = pivot_raw_1, family = gaussian(link = "log"))
mod_1_gaussian_inverse <- glm(y ~ value, data = pivot_raw_1, family = gaussian(link = "inverse"))

AIC_mods_1 <- data.frame(model = c("mod_1_gaussian", "mod_1_poisson", "mod_1_gaussian_log", "mod_1_gaussian_inverse"),
                         AICc = c(AICc(mod_1_gaussian), AICc(mod_1_poisson), AICc(mod_1_gaussian_log), AICc(mod_1_gaussian_inverse)))
AIC_mods_1[order(AIC_mods_1$AICc),]

# Not sure this is actually doing the right thing! 

raw_2_plot <- ggplot(data = raw_2, aes(x = , y = y)) + geom_point(aes(col = response)) + geom_line()



#############################################################################################

# Data Set 2 

pivot_raw_2 <- pivot_longer(data = raw_2, x1: x3, names_to = "response", values_to = "value") 
raw_2_plot <- ggplot(data = pivot_raw_2, aes(x = value, y = y)) + geom_point(aes(col = response))
raw_2_plot




