# Easy Code =====================================================

## Create a vector of 100 random numbers between 0 and 50
a <- runif(100,0,50); a

## Sort these by order of their value (from largest to smallest)
sort(a,T)

## Write a function which calculates the logarithm (base 10) of
## a vector it is given, subtracts this from the original vector,
## and returns the new vector of values
funct_1 <- function(x){
  a <- x - log10(x)
  return(a)
}

## Use this function with your vector of random numbers and save
## the output as a new object
b <- funct_1(a); b

## Calculate the mean, standard deviation, and standard error of
## this new object, save these into a single vector where each of
## the objects are named
d <- c("mean" = mean(b),
       "sd" = sd(b),
       "sterr" = sd(b)/sqrt(length(b)))
d

# Advanced code ================================================

## Write code to create a sequence of numbers from 15 to 100
e <- seq(15, 100); e

## Find the mean of the numbers in this vector which are greater
## than 20 and less than 60
mean(e[e > 20 & e < 60])

## and the sum of the numbers in this vector which are greater
## than 48.
sum(e[e > 48])

## Write a function which returns the maximum and minimum values
## of a vector, without using the max(), min(), or range() functions

funct_maxmin <- function(x){
  a <- sort(x,T)
  b <- a[1]
  d <- a[length(a)]
  return(c("max" = b, "min" = d))
}

funct_maxmin(seq(25, 100))
