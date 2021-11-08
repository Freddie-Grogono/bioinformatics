# Week 6 Homework 

# Part 1 - Tokyo Olympics

## Is there a significant effect of a country's GDP on their position in the Olympics?


library(tidyverse)
library(vroom)

#Install the Tokyo Medals Data 
Tokyo_Data <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%205/Tokyo%202021%20medals.csv")

# Install wbstats for access to the GDP data 
install.packages("wbstats")
library(wbstats)

#Renaming the column so it is nicer to look at and easier to understand 
my_indicators = c("GDP" = "NY.GDP.MKTP.CD")

##extract the GDP data for all countries
GDP_Raw <- wb_data(my_indicators, 
                    start_date = 2020,
                    end_date = 2020)

# Having a look at the data
GDP_Raw
# seems as though there are some columns we won't need, so let us get rid of those: 

# Getting rid of useless columns from the data set: 
GDP_Data <- subset(GDP_Raw, select = c(1, 2, 3, 4, 5, 9))
GDP_Data 
# Have a look, Yay it worked! 


## Joining the two data sets: 

# Now we need to join the 
#Renaming row for join:
GDP_Data_Final<- rename(GDP_Data, code = iso3c)

# Adding a column to Tokyo Data containing country code:
library(countrycode)

# Adding the iso3c column to the Tokyo Data enabling joining later on:
Tokyo_Data$code <- countrycode(Tokyo_Data$Country, 
                                  origin = "country.name", 
                                  destination = "iso3c")

# Giving china the CHN
Tokyo_Data$code <- sub("TWN", "CHN", Tokyo_Data$code)
Tokyo_Data$code[42] <- "TWN"

# Joining the data:
GDP_And_Medals_Raw <- inner_join(Tokyo_Data, GDP_Data_Final, by = "code")
GDP_And_Medals_Raw

# Remove all of the NA values 
GDP_And_Medals_Final <- na.omit(GDP_And_Medals_Raw)
GDP_And_Medals_Final

# Ordering the data set based on how the olympic medal table ranking works: 
GDP_And_Medals_Final <-GDP_And_Medals_Final[order(-GDP_And_Medals_Final$Gold, -GDP_And_Medals_Final$Silver, -GDP_And_Medals_Final$Bronze),]

# Using the index to give the countries a Rank:
GDP_And_Medals_Final <- tibble::rowid_to_column(GDP_And_Medals_Final, "Rank")

#install the ggplot2 package
install.packages("ggplot2")

# Use the ggplot 2 library 
library(ggplot2)

# Investigating an initial plot of medal ranking and GDP:
p1 <- ggplot(GDP_And_Medals_Final, aes(x = GDP,
                                 y = Rank)) +
  geom_point() +
  theme_bw() +
  ylab("Medal Ranking") +
  xlab("GDP") 
p1
# looks okay but could do with some logging perhaps of the GDP to make things more clear. 

# Pseudo logging the GDP and adding a geom_smooth line
p2 <- p1 + 
  scale_x_continuous(trans="pseudo_log") + 

    geom_smooth(method="glm")

p2
# looks okay!

# Assessing the fit of a model:
# Mod 1 is going to be the "Gaussian" or normally distributed:
mod1 <- glm(Rank ~ GDP,
                data = GDP_And_Medals_Final,
                family = "gaussian")

# Mod 2 is going to be the "poisson" type:
mod2 <- glm(Rank ~ GDP,
            data = GDP_And_Medals_Final,
            family = "poisson")

# Mod 3 is the Gaussian with the link being log:
mod3 <- glm(Rank ~ GDP,
            data = GDP_And_Medals_Final,
            family = gaussian(link="log"))

# Mod 4 is the Gaussian link with inverse link:
mod4 <- glm(Rank ~ GDP,
            data = GDP_And_Medals_Final,
            family = gaussian(link = "inverse"))


# gettting library gamlr
library(gamlr)

# Comparing the models:
AIC_mods <- AIC(mod1,
                mod2,
                mod3,
                mod4)

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AIC),]

# It looks as though model 4, the gaussian, link = inverse, is slightly better so lets check that out: 

# Now looking at mod4
# create column of log predicted Gaussian
GDP_And_Medals_Final$pred_gaussian_log <- predict(mod4,
                                        type = "response")

#plotting the diagnostics plot for model 4
plot(mod4)

# creating a column for residual Gaussian log
GDP_And_Medals_Final$resid_gaussian_log <- resid(mod4)

# plotting with the geom line for the predicted Gaussian log
p3 <- ggplot(GDP_And_Medals_Final, aes(x = GDP,
                                       y = Rank)) +
  geom_point() +
  theme_bw() +
  ylab("Medal Ranking") +
  xlab("GDP") 

p3
#applying the model to the plot (method = glm)
p3 <-  p3 + 
  scale_x_continuous(trans="log") + 
  geom_smooth(method="glm") +
  xlab("Medal Ranking") +
  ylab("log_GDP") +
  ggtitle( " Logged GDP Data")

p3
# I thought this was a good model. There is no residuals plotted but the data points are clear. 
# Now having a look at the model summary:
summary(mod3)

# This was the solution that you gave which I have adapted to my data:

p4 <- ggplot(GDP_And_Medals_Final, aes(x=GDP, y=Rank)) + 
  geom_point() + 
  scale_y_continuous(trans='log10') + 
  scale_x_continuous(trans='log10') + 
  theme_bw() +
  ggtitle("Logged data")
  
p4

## fit a model where neither the x or y are logged:
mod6 <- glm(Rank ~ GDP, data=GDP_And_Medals_Final)
plot(mod6)
## DOESNT LOOK GOOD!

## fit a model where both the x and y are logged:
mod7 <- glm(log10(Rank) ~ log10(GDP), data=GDP_And_Medals_Final)
plot(mod7)

## So, is there an effect?
summary(mod7)


 