### THE HOMEWORK FOR WEEK 2, USING THE HOMEWORK FROM WEEK 1

## create a vector of random numners
ran_50 <- runif(100, 0, 50)

##order them from smallest to largest
sort_ran_50 <- sort(ran_50)

##write the function

my_fun <- function(x){
  
  ##subtract log10(x) from x
  y <- x - log10(x)
  
  ##return the new vector
  return(y)
}

##run the function on your random numbers
new_data <- my_fun(sort_ran_50)

##calculate mean, sd, and se:

##calcualte mean
mean_dat <- mean(new_data)

##calcualte SD
sd_dat <- sd(new_data)

##the function for se
se <- function(x)sd(x)/sqrt(length(x))

se_dat <- se(new_data)

##results

results <- c("mean" = mean_dat, 
             "sd" = sd_dat,
             "se" = se_dat)

#############################################
#############################################
##create a sequence of numbers from 15 to 100
my_seq <- 15:100

##mean of numbers >20 and <60
mean(my_seq[my_seq > 20 & my_seq < 60])

##mean of numbers >20 and <60
mean(my_seq[my_seq > 20 & my_seq < 60])

sum(my_seq[my_seq > 48])

#############################################
#############################################
## a function to return the minimum and maximum values of a vector
my_range <- function(x){
  return(c("minimum" = sort(x)[1],
           "maximum" = rev(sort(x))[1]))
}

##show it works
my_range(rnorm(10))