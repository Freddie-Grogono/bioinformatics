
# Task 1

help <- function(){
  print("Help")
}

help


# Task 1.2
# Create a function that given a vector random_vector and an integer will return how many times that integer appears inside the vector.

random_vector <- c(8,9,9,8,5,1,8,5,6,2,3,5,9,9,8)



func <- function(x, y){
  a <- table(x)
  a[names(a)==y]
  return(a[names(a) == y])}

print(func(random_vector, 9))


# Task 1.4

odds_even <- c(0,2,3,5,6,8,9)

# Task 2
library(vroom)
library(tidyverse)

task2_df <- vroom("https://raw.githubusercontent.com/PolCap/Teaching/master/Bristol/R%20Course/data/LivingPlanetIndex.csv")
task2_df
    

task2_df_long <- task2_df %>%
  pivot_longer(cols = -c(ID:System),
               names_to = c("date")
)



# What is the most recent year that the UK started monitoring a new population (according to the living planet index)?


uk_filtered <- task2_df_long %>%
  filter(Country == "United Kingdom")


uk_filtered_nl <- task2_df %>%
  filter(Country == "United Kingdom")



# drop everything that has NULL in it 


task2_df_long_no_null <- task2_df_long [task2_df_long == "NULL"] <- NA

task2_df_long_no_null


    