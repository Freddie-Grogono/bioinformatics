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

# So now we have sorted the covid data out
# we want to joing the population data from the WB to it 

# Look on the tidyverse website to see which join() function we want 

# REMEMBER that: full_join() keeps all of the columns AND rows for both x and y 
# remember we have countries in the covid_data and countries 
# AND economic areas in the WB data, so we want to drop these economic areas 
# and just stick to the countries.

# We can do this using LEFT_JOIN() < https://www.programmingr.com/tutorial/left-join-in-r/#:~:text=A%20left%20join%20in%20R%20is%20a%20merge,do%20not%20already%20exist%20in%20the%20first%20table. >

# left_join returns all rows from x, and all columns from x and y
# adding this to our cleaned data set covid_country via our new code column 
# and the corresponding column of codes in the WB data 
# need to make sure we selece the correct column of codes as there are a few!

# We don't want ALL the columns of the WBdata, so we can use the select() function to specify
# we only want the iso3c and value columns to be included in our join:

# rename the 5th column of the pop data so it works:
names(pop_2020)[5] <- "value"

# demonstartation of what select does: 

head(pop_2020 %>% select(iso3c, value))


## now join the 2 data sets using left_join

covid_w_pop <- left_join(covid_country, 
                         pop_2020 %>% select(iso3c, value),
                         by = c("code" = "iso3c"))
                          # telling join() that "code" = "iso3c" 
                          # otherwise _join() won't work out where to join the data sets.

# look at new data set:

covid_w_pop

# we could have joined these data by country and by date using:

                        # by = c("code" = "country", "date" = "Date")
# however, we already filtered out the correct year from WB data AND the date in the covid data set is month/day/year
# so we would need to extract the year data AND the most recent data is year 2020 in the covid data
# and only 2019 in the WB data 

# Letw now change the name of the "value" column to one which is more meaningful:

# We do this using the which() function which takes a logical operator 
# in this case names(covid_w_pop) == "value" - and returns a vector of numbers which is the 
# positions in the vecotr where the statement is true: 

# column names
names(covid_w_pop)
# so they are : "Country.Region", "Date", "Deaths", "Code", "Value"

# the ones which are equal to "value":

names(covid_w_pop) == "value"
# is: FALSE, FALSE, FALSE, FALSE, TURE

which(names(covid_w_pop) == "value")

names(covid_w_pop)[5]

# This means you don’t have to specify the location of the “value” manually 
# (i.e. don’t need to do names(covid_w_pop)[5]) 
# so if it ever changes position this code will still work.

# change the name:
names(covid_w_pop)[which(names(covid_w_pop) == "value")] <- "Population"

names(covid_w_pop)[5] # checking this you can now see the name has been changed

# Another quick visual check filtering out a single coutry from each data set 
# and visually check that the population data are the same in each:

## quick visual check
covid_w_pop %>% filter(Country.Region=="Afghanistan" & Date == "1/22/20") 

pop_2020 %>% filter(country=="Afghanistan")

# Now we have joined the data together and done some cleaning we can start to calculate out the 
# statistics we want and then start to think about visualising them.

# 2.5 - Calculating Death Rates

# what the total number of deaths are
# what the number of deaths per day are (globally)
# number of deaths per million people in the country


# Total Global Deaths: 
# the data is cumulative, so the total deaths will be the sum of the data for all countries
# in the most recent date in the data frame 

most_recent <- covid_country%>% # defining what the most recent year is 
  filter(Date == max(covid_country$Date)) # using the fitler function to find this 

sum(most_recent$Deaths) # then summing the final year of data cumulative deaths 

# Number of deaths per day globally:

# need to group the data to calculate this: 
# need to save it as a new data.frame: 

global_deaths_day <- covid_country%>% # so we have assigned the global_deaths from covid data
  group_by(Date) %>% # we are then grouping the Date data 
  summarise("Global.deaths" = sum(Deaths)) 


# Lets make a quick check to ensure we dont have any issues in the data (like NAs):
which(is.na(global_deaths_day$Global.deaths)) 

# Great, it doesnt seem like we have any NAs (otherwise the calculation about would 
# be a series of numbers corresponding to the rows in which those NA values are). 
# We can trivially remove any NA’s in our data using the na.rm=T argument:

# makine a new data frame of the global deaths using group_by() and summarise()

global_deaths_day_1 <- covid_country %>%
  group_by(Date) %>% 
  summarise("Global.deaths" = sum(Deaths, na.rm = T)) # removing the NA values

# 2.7 Deaths Per Million people:
# This normalised death rate allows us to compare the reate of increase in deaths
# between countries which have vastly different population sizes

# lets go back to the covid_w_pop data set 
# calculate deaths per million individuals for all of the countries in the covid_w_pop data.

covid_w_pop$Deaths.p.m <- (covid_w_pop$Deaths / covid_w_pop$Population) * 1000000

# look @ the data:
tail(covid_w_pop)

