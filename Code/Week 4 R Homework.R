# install.packages("devtools", dependencies = TRUE)

library("devtools")

# install_github("r-lib/vroom")

library(vroom)

library(tidyverse)


##read in the data
wide_spp.1 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_1.csv")
wide_spp.2 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_2.csv") 

## code to reshape data
## first join the data using full join - this will keep all of the columns
full_data <- full_join(wide_spp.1, wide_spp.2) %>%
  ## pivot the joined data frame, using species, primary_threat, secondary_threat, tertiary_threat as ID columns
  ## and using names-pattern to pull out the population number 
  ## and make a new column (called population) to store them in. 
  ##Drop the NAs. 
  pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = F, 
               values_to = "abundance")

full_data 

# Visualizing the data in the most useful way 

full_data$Date.corrected

ful

full_data$Date.corrected <- as.Date(
  full_data$Date, format = "%m/%d/%y")

full_data <- select(full_data, -Date.corrected)

names(full_data)[1] <- "Species"
names(full_data)[2] <- "Primary_Threat"
names(full_data)[3] <- "Secondary_Threat"
names(full_data)[4] <- "Tertiary_Threat"
names(full_data)[5] <- "Population"
names(full_data)[6] <- "Date"
names(full_data)[7] <- "Abundance"

full_data 

full_data %>%
  seperate(dates, c("month", "year", ))


Sort By Primary Threat: 

by_date_plot <- ggplot(data = full_data, aes(x = Date, y = Abundance)) + geom_point(aes(col = Species))
by_date_plot

# First year and last year 

year_one <- full_data %>%
  filter(date == "1995-01-01")

year_one

# 1. filter the data to include data from the year 2020 only:
pop_2020 <- covid_data_long %>%
  # 2. only return data where the data is equal to the maximum value in the column "date"
  filter(date == 2020)
