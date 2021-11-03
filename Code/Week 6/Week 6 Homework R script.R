# Week 6 Homework 

# Part 1 - Tokyo Olympics

# significant effect of a country's GDP on their position in the olympics


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
GDP_Per_Cap_Data_Raw <- wb_data(my_indicators, 
                    start_date = 2020, 
                    end_date = 2020)

# Get rid of useless columns from the data set: 
GDP_Per_Cap_Data <- subset(GDP_Per_Cap_Data_Raw, select = c(1, 2, 3, 4, 5, 9))
GDP_Per_Cap_Data # Have a look, Yay it worked! 

#Making it a tibble
GDP_Per_Cap_Data <- as_tibble(GDP_Per_Cap_Data)

# Adding a column to Tokyo Data containing country code:
library(countrycode)

# Adding the iso3c column to the Tokyo Data enabling joining later on:
Tokyo_Data$code <- countrycode(Tokyo_Data$Country, 
                                  origin = "country.name", 
                                  destination = "iso3c")
GDP_Per_Cap_Data


# Joining the data:
GDP_And_Medals_Raw <- left_join(Tokyo_Data, 
                         GDP_Per_Cap_Data %>% select(country, GDP),
                         by = c("Country" = "country"))

# Remove all of the NA values 
GDP_And_Medals <- na.omit(GDP_And_Medals_Raw)
GDP_And_Medals

# Also summarize the medals so that they are total points 
# gold = 3, silver = 2, bronze = 1
GDP_And_Medals$Total_Points <- ((GDP_And_Medals$Gold*5) + (GDP_And_Medals$Silver*3) + (GDP_And_Medals$Bronze*1))

# Check Summary: 
GDP_And_Medals
# Seems to look okay, shame that we have had to omit so many countries. 

# Now rank the countries based on their total points, in descending order 
GDP_And_Medals$Rank<-rank(desc(GDP_And_Medals$Total_Points))

# Found a new method of ordering them based on what the olympic medals table actually means: i.e. ranked on the no. Gold then no. Silver then no.Bronze 
GDP_And_Medals <-GDP_And_Medals[order(-GDP_And_Medals$Gold, -GDP_And_Medals$Silver, -GDP_And_Medals$Bronze),]

# Using the index to give the countries and ID 
GDP_And_Medals <- tibble::rowid_to_column(GDP_And_Medals, "ID")

# Visualize the relationship between GDP and position in the table: 
#install the ggplot2 package
install.packages("ggplot2")

#use the ggplot 2 library 
library(ggplot2)

# Investigating an initial plot of medal ranking and GDP:
p1 <- ggplot(GDP_And_Medals, aes(x = GDP,
                                 y = ID)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Medal Ranking") +
  xlab("GDP") 

p1 + geom_smooth(method="loess")

# It looks very messy 

# Assessing the fit of a model:
# Mod 1 is going to be the "gaussian" or normally distributed:
mod1 <- glm(ID ~ GDP,
                data = GDP_And_Medals,
                family = "gaussian")

# Mod 2 is going to be the "poisson" type:
mod2 <- glm(ID ~ GDP,
            data = GDP_And_Medals,
            family = "poisson")

# Mod 3 is the gaussian with the link being log:
mod3 <- glm(ID ~ GDP,
            data = GDP_And_Medals,
            family = gaussian(link="log"))

# Mod 4 is the gaussian link with inverse link:
mod4 <- glm(ID ~ GDP,
            data = GDP_And_Medals,
            family = gaussian(link = "inverse"))

AIC_mods <- AIC(mod1,
                mod2,
                mod3,
                mod4)

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AIC),]

# create column of log residual and log predicted 

# go with inverse (4)

GDP_And_Medals$pred_gaussian_log <- predict(mod3,
                                        type = "response")

GDP_And_Medals$resid_gaussian_log <- resid(mod3)


p2 <- ggplot(GDP_And_Medals, aes ( x = GDP,
                               y = ID)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Rank") +
  xlab("GDP")

# Now add in a line of predicted values from the model: 

p2 <-  p2 + geom_line(aes(x = GDP,
                          y = ID),
                      col = "dodgerblue",
                      size = 1)

p2 <- p2 + ggtitle("Fitted model (gaussian with log link)")
p2 # That looks like a good fit! 
