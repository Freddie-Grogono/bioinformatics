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
GDP_Raw <- wb_data(my_indicators, 
                    start_date = 2020, 
                    end_date = 2020)
GDP_Raw

# Get rid of useless columns from the data set: 
GDP_Data <- subset(GDP_Raw, select = c(1, 2, 3, 4, 5, 9))
GDP_Data # Have a look, Yay it worked! 

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

# Found a new method of ordering them based on what the olympic medals table actually means: i.e. ranked on the no. Gold then no. Silver then no.Bronze 
GDP_And_Medals_Final <-GDP_And_Medals_Final[order(-GDP_And_Medals_Final$Gold, -GDP_And_Medals_Final$Silver, -GDP_And_Medals_Final$Bronze),]

# Using the index to give the countries a Rank:
GDP_And_Medals_Final <- tibble::rowid_to_column(GDP_And_Medals, "Rank")

#install the ggplot2 package
install.packages("ggplot2")

#use the ggplot 2 library 
library(ggplot2)

# Investigating an initial plot of medal ranking and GDP:
p1 <- ggplot(GDP_And_Medals_Final, aes(x = GDP,
                                 y = Rank)) +
  geom_point() +
  theme_bw() +
  ylab("Medal Ranking") +
  xlab("GDP") 
p1

# Pseudo logging the GDP and adding a geom_smooth line
p1 + 
  scale_x_continuous(trans="pseudo_log") + 

    geom_smooth(method="loess")
# It looks very messy 

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

# Comparing the models:
AIC_mods <- AIC(mod1,
                mod2,
                mod3,
                mod4)

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AIC),]

# Now looking at (4)
# create column of log predicted Gaussian
GDP_And_Medals_Final$pred_gaussian_log <- predict(mod4,
                                        type = "response")

#plotting the diagnostics plot for model 4
plot(mod4)

# creating a column forth residual Gaussian log
GDP_And_Medals_Final$resid_gaussian_log <- resid(mod4)

# plotting p1 with the geom line for the predicted Gaussian log

p1
p2 <- p1 + geom_line(aes(x = GDP,
                   y = pred_gaussian_log),
               col = "dodgerblue",
               size = 1)
p2


p1_1 + geom_segment(aes(xend = GDP,
                        yend = pred_gaussian_log),
                    col = "lightblue") 
  
p_hist <- ggplot(GDP_And_Medals, aes(x = resid_gaussian_log)) + geom_histogram(fill = "goldenrod") + theme_minimal() 
p_hist  
  
p_pred_resid <- ggplot(GDP_And_Medals, aes(x = pred_gaussian_log,
                                           y = resid_gaussian_log)) +
  geom_point() +
  theme_minimal() +
  geom_smooth()

p_pred_resid

qqnorm(GDP_And_Medals$resid_gaussian_log); qqline(GDP_And_Medals$resid_gaussian_log)




