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

# Visualize the relationship between GDP and position in the table: 
#install the ggplot2 package
install.packages("ggplot2")

#use the ggplot 2 library 
library(ggplot2)


p1


