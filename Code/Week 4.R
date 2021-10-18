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

