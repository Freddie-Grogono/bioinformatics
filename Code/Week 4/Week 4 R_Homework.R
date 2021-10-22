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




# filter for the unique species: 
unique_species <- unique(long_spp$species)
unique_species


# plotting the all specie's abundancies across all years:
total_population_abundance_over_all_time <- ggplot(data= long_spp, aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) + 
  theme(legend.position = "none")

total_population_abundance_over_all_time


total_population_abundance_over_all_time_2 <- ggplot(data= long_spp, aes (x = year, y = abundance)) + 
  geom_point(aes(col = species)) + 
  geom_line(aes(col = species)) +
  facet_wrap(. ~ primary_threat ) +
  theme(legend.position = "none")

total_population_abundance_over_all_time_2

# filtering to different threats: 



primary_threat_population <- long_spp%>% 
  filter(primary_threat == "Pollution") 

primary_threat_habitat_destruction <- long_spp%>% 
  filter(primary_threat == "Habitat destruction") 

primary_threat_exploitation<- long_spp%>% 
  filter(primary_threat == "Exploitation") 

primary_threat_climate_change <- long_spp%>% 
  filter(primary_threat == "Climate change") 

primary_threat_habitat_fragmentation <- long_spp%>% 
  filter(primary_threat == "Habitat fragmentation") 

primary_threat_habitat_loss <- long_spp%>% 
  filter(primary_threat == "Habitat loss") 

primary_threat_effects <- c(
  
  

primary_threat_effect_on_abundance_over_time <- ggplot(data = long_spp, aes (x = year, y = abundance)) +
  geom_point(aes(col = ))
  
total_population_abundance_over_all_time <- ggplot(data= long_spp, aes (x = year, y = abundance)) + 
  geom_point(aes(col = s))

total_population_abundance_over_all_time
