install.packages("devtools", dependencies = TRUE)

library("devtools")

install_github("r-lib/vroom")

library(vroom)

library(tidyverse)


##read in the data
wide_spp.1 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_1.csv")
wide_spp.2 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_2.csv") 

## code to reshape data
## first join the data using full join - this will keep all of the columns
long_spp <- full_join(wide_spp.1, wide_spp.2) %>%
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
               values_drop_na = T, 
               values_to = "abundance")

# Access library lubridate:
library(lubridate) 

# telling R how your date column is organised
long_spp$date <- ymd(long_spp$date)

# changing the date into a numberic value and making a new column for just date
long_spp$year <- as.numeric(as.character(long_spp$date, "%Y"))


# plotting the all specie's abundance across all years:
total_population_abundance_over_all_time <- ggplot(data= long_spp, aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) 

total_population_abundance_over_all_time


# effect of primary threat on abundance over time: 
total_population_abundance_over_all_time_primary <- ggplot(data= long_spp, aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) +
  facet_wrap(. ~ primary_threat ) +
  theme(legend.position = "none")

total_population_abundance_over_all_time_primary

# effect of primary threat on abundance over time for population 1: 
total_population_abundance_over_all_time_primary_1 <- ggplot(
  data= long_spp %>% filter(population == "pop_1"), 
  aes (x = year, y = abundance)) +
  geom_point(aes(col = species)) +
  geom_line(aes(col = species)) +
  facet_wrap(. ~ primary_threat ) +
  theme(legend.position = "none") +
  ggtitle("Effect of Primary Threat on Abundance of Population 1 over Time") +

  


total_population_abundance_over_all_time_primary_1

# effect of primary threat on abundance over time for population 2:
total_population_abundance_over_all_time_primary_2 <- ggplot(data= long_spp %>% filter(population == "pop_2"), aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) +
  facet_wrap(. ~ primary_threat ) +
  theme(legend.position = "none") +
  
  theme(plot.title = element_text(hjust = 0.5))
        

total_population_abundance_over_all_time_primary_2



# effect of tertiary threat on abundance of population 1, over time:
total_population_abundance_over_all_time_secondary_1 <- ggplot(data= long_spp %>% filter(population == "pop_1"), aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) +
  facet_wrap(. ~ secondary_threat ) +
  theme(legend.position = "none")

total_population_abundance_over_all_time_secondary_1

# effect of tertiary threat on abundance in population 2, over time:
total_population_abundance_over_all_time_tertiary_2 <- ggplot(data= long_spp %>% filter(population == "pop_2"), aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) +
  facet_wrap(. ~ tertiary_threat ) +
  theme(legend.position = "none")

total_population_abundance_over_all_time_tertiary_2


