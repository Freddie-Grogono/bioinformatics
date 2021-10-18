# Week 4

# Data tidying and basic visualization

# Matrices - 2 dimensional containging a single type of data 
# Array are n dimensional matrices containing a single type of data
# Data.Frames (including tibble) can contain multiple data types 
# Lists - structures containing nested information of multiple types 
# Installig packages from CRAN via 'install.packages('package.name")
# Installing packages from GitHub via 'install_github("r-lib/vroom")
# We can specify a function to be used from a certain package using the :: operator: vroom:vroom()
# Load data into R using vroom() via direct pathways, or using a relative pathways
# Load data from GitHub using vroom() and the data URL 
# Creating piplines via the magrittr operator %>%
# Reshaping data from wide to long and long to wide using the pivot_ function

# Today:
# Tidyverse to further delve into some data manipulation and then learn how to visualise these data too:


# Data Manipulation 

# Task: load in the Covid_19 Data from last week:
# Installing 'devtools' package
install.packages("devtools", dependencies = TRUE)

# Installing the 'devtools' package
library("devtools")

# Installing vroom from GitHub
install_github("r-lib/vroom")

library(vroom)

library(tidyverse)
# Importing the Data
covid_data <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/time_series_covid19_deaths_global.csv")

covid_data

# Task: rename the first two columns in the covid data frame to “Province.State” and “Country.Region”.

# Changing the first two names of our data frame:
names(covid_data)[1:2] <- c("Province.State", "Country.Region")

# Now reshape the data into long format:

covid_data_long <- covid_data %>% # magrittr operator < https://magrittr.tidyverse.org/ >
  pivot_longer(col = -c(Province.State:Long),
               names_to = "Date",
               values_to = "Deaths"
                        )

covid_data_long

# 5 Common Themes of Tidyverse data manipulations: 

mutate() # adds new variables that are functions of existing variables 
select() # picks variables based on their names 
filter () # picks cases based on their values 
summarise() # reduces multiple values down to a single summary 
arrange() # changes the ordering of the rows 

group_by() # specify the groups within the data we want to apply these to 


# With our data lets find out:

# 1. what the total number of deaths are (globally)
# 2. what the number of deaths per day are (globally)
# 3. number of deaths per million people in the country 

# Calculate things like the number of deaths per million people we need to know the number of
# people which live in each country - the covid doesn't include this so we need to go fishing 

# Accessing the WORLD BANK data using 'wbstats'
# installing web stats:
install.packages("wbstats") 

# Task
# Install wbstats (best to install it from its github repository, try googling in) and load it into R, 
# and find and have a look at its vignette online (google) 

# Remember to use the top right button: 'Tools', 'Install Packages', 'CRAN'... to install pacakges 
devtools::install_github("nset-ornl/wbstats")

# then make sure we have got access to the wbstats data library 
library(wbstats)

# Task
# Extract the population data for all countries
covid_data_long <- wb_data(indicator = "SP.POP.TOTL", 
                    start_date = 2002, 
                    end_date = 2020)


# Convert it to a tibble
covid_data_long <- as_tibble(covid_data_long)

# The maximum value of the years in the date column
max(covid_data_long$date)

# Filtering Data

# Filter words with the logical operators we discussed in the first workshop:
# < https://dplyr.tidyverse.org/reference/filter.html >

# the Filter() uses the logical operators, also other functions like between() 

# Task: we want the data from 2020 so we can use this as our filtering argument:

# 1. filter the data to include data from the year 2020 only:
pop_2020 <- covid_data_long %>%
  # 2. only return data where the data is equal to the maximum value in the column "date"
  filter(date == 2020)

# look at the data:
pop_2020

# 2.3 Cleaning Data:

# Once we join these two data frames we can use the information from the WB to calculate 
# some statistics in the covid data (like deaths per million people). However, before we 
# think about making this join we need to do some careful consideration of whether we can 
# actually join the two data sets in their current form.

# Have a look at the structure of the two data sets: 
#1:
covid_long
#2:
pop_2020

# Take the total population data for each country from the WB data and add 
# it as a new column to the covid data
# Easier to visualise when we look at the unique values in the 'country' column:

##the first 10 and last 10 unique values in the country column
## the ; operature acts as a new line - meaning you can run two bits of code which don't interact on the same line
head(unique(pop_2020$country), 10); tail(unique(pop_2020$country), 10)

# Not a big problem: 
# we can drop the values for 'countries' in the pop_2020 data set which don't match 
# the countries we have in the covid data. 

# Two bigger issues which will become more apparent later on
head(covid_dat, 10)

# The 1st problem is the names of the countries - names of the countries 
# The 2nd major problem is the 'province.state. column in the covid data. 
# Lets look at Australia


## just look at the data from Australia:
covid_data %>% filter(Country.Region == "Australia")

# It is easier to use the wide (not long) here because we can see waht is going on
# in the 'Province.State' and 'Country.Region' column when they aren't repeated over and over 



# Task
# Now filter the WB data to only show the data from Australia, and compare this to 
# the covid data. 
# What are the differences?
## the data for Australia from the WB

pop_2020 %>% filter(country == "Australia")

# This data is not split by state or province 
# We need to convert the covid data so that we have total covid deaths for a country, not region 

# We can do this using the 'tidyverse' and the 'summarise()' function:

# summarise() allows us to specify what function we want to be applied: e.g mean(), sd() or in our case sum(), 
# **It will then create a new column of a specified,name containing that data**  

# We can pair this up with group_by() function, where we can specify the groups in which
# we want the summarize function to be applied to. 

# e.g. mean(), sd(), or in our case sum()
# and will create a new column of a specified name containing that data.

# We can pair this up with the group_by() function, where we can specify the groups in which we 
# want the summarize function to be applied to. 

# we now have a very powerful tool for rapidly and easily summarizing data which is complex
# It is also very easily read by humans lel

# TASK:

## have a look at the data.frame that is produced:
covid_country
# Make a new data.frame from the old covid_long data.frame
covid_country <- covid_long %>% 
  
  # we want to calculate the number of deaths in each country and at each date: 
  group_by(Country.Region, Date) %>% 
  
  ## and we want the sum of the "Death" column in these groups:
  summarise(Deaths = sum(Deaths))


# we have removed the regions so the death toll is per country

#look at the first row of the WB data:
tail(pop_2020)

# Download the countrycode package on CRAN (remember the tools --> install packages)

library(countrycode)

?countrycode

covid_country$code <- countrycode()

## add a column to covid data containing the 
covid_country$code <- countrycode(covid_country$Country.Region, 
                                  origin = "country.name", 
                                  destination = "iso3c")

##look at the new column we have added to the data set:
head(covid_country, 1)

##compare that to the values in the WB data
pop_2020 %>% filter(iso3c == "AFG")


# 2.4 Joining Data