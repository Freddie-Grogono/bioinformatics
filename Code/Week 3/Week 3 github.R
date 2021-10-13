##Recapping vecotrs - numeric, character, logical 

## Combining two vectors together 

# c(1, 4, 1, 7) )& c(3, 2)

a <- c(1, 4, 1, 7)
b <- c(3, 2)

d <- c(c(a),c(b))
d

# Or
c(c(1, 4, 1, 7), c(3, 2))


## Matrices are 2 two dimensional 
# where the first argument is the data to be included in the matrix
# here we are using the seq() function which generates regular sequences (see ?seq()) for more information)
# and the second and third arguments specify the shape of the matrix (number of columns, and number of rows).
matrix(seq(from = 1, to = 6, by =1), ncol = 3, nrow = 2)

# Creating a blank matrix full of NAs
matrix(NA, ncol = 3, nrow = 4)

## You can also shape a vector into a matrix using the dim() function:
b <- seq(from = 1, to = 6, by = 1) ## b <- 1 2 3 4 5 6 (it becomes a string from 1 to 6, with a gap of 1)
#set the dimensions of the matrix (nrows and then ncolumns)
# Rows = across & Columns = down
dim(b) <- c(2,3)
## look at the matrix you've made:
b

#dim() can also be used to show us the properties of the matrix - i.e it's dimensions 
#(remember that names() can be used to both ascribe names to a vector, 
#and see the names that a vector had been given)

# Here we have used a quick trick to fill the matrix - the : between two numbers means "generate a sequence
#of whole numbers from x to y. 

dim(matrix(1:6, nrow = 2, ncol = 3))

# Making a matrix of 80 random numbers, drawn from a normal distribution (look at rnorm())

Matrix_1 <- matrix(rnorm(80), nrow = 8, ncol = 10)

Matrix_1 

#As with vectors, the values stored in matrices can be accessed using the [ ] operator.
#As they're one dimensional we only have to specify one value:
seq(from = 1, to = 10, by = 1)[5]

# Matrices are 2 dimensional, to specify a single value for the position in the vector
# we need to give two values, the first determines the row that R should look in, the second
# determines the column, thus:
# Return the value of the matrix in the first row and the second column
Matrix_1[1, 2]

# the ORDER for square brackets is always [Row, Column]
# You can also return multiple values by giving either the row or column values as a vector:
# i.e returning the values in the first row from the first and second column:
Matrix_1[1,c(1,2)]

# Or whole rows or columns:
Matrix_1[1,]

# Return the values in the second column
Matrix_1[,2]

# MATRIX OPERATIONS
# you can carry out mathematical operations on Matrices, 
# this can be done using the regular: +. -, *, /,
# a matrix of values:
integer_matrix <- matrix(1:6, ncol = 3, nrow = 2)
integer_matrix

# adding one to all of the values:
integer_matrix + 1

# when the vector is of lenthg > 1, something else happens
# Note: As with vectors R approaches matrix multiplication 
# depending on how you specify the multiplication - if you 
# use the * symbol, R will perform element-wise multiplication, 
# whilst if you need true matrix multiplication you need a special operator %*% (see below).


rep(1:3, each = 5)
# -> this repeates 1-3, 5 times

# so making a matrix using rep:
Matrix_Rep <- matrix(rep(1:3, each = 5), nrow = 3, ncol = 5, byrow = TRUE)
Matrix_Rep

# a vector of the numbers 1 to 5
Vector_Sequence <- 1:5
Vector_Sequence

# multiplying the Repeating Matrix by the Vector Sequence
Matrix_Rep * Vector_Sequence
# this is a funky way of multiplying matrices - not the regular

# Matrix Multiplication
# where the first argument is the data to be included in the matrix
# and the second and third arguents specify in the shape of the matrix.

Matrix_Sequence <- matrix(seq(from = 1, to = 20, lenght.out = 6), ncol = 3, nrow = 2)
Matrix_Sequence

Matrix_Sequence_1 <- matrix(1:20, ncol = 5, nrow = 2)
Matrix_Sequence_1

#making a vector to multiply by:
Vector_Sequence_1 <- seq(from = 10, to = 4, length.out =3)

Matrix_Sequence %*% Vector_Sequence_1

mat_seq <- matrix(seq(from = 1, to = 20, length.out = 6), ncol = 3, nrow = 2)

##a vector to multiply by
vec_seq <- seq(from = 10, to = 4, length.out = 3)

##multiple the matrices using element-wise multiplication
mat_seq %*% vec_seq

# this gives us the 1 x 2 matrix we expecte given the rules of matrix 

# As with vectors matrices can include numeric or character strings, 
# or a mix, and we can also perform logial operators on them:

Matrix_Sequence_2 <- matrix(seq(1, 20, length.out = 6), ncol = 3, nrow = 2)
Matrix_Sequence_2

# display the logical operator of this matrix for values greater than 10
Matrix_Sequence_2 > 10

#return the values which are greater than 10
Matrix_Sequence_2[Matrix_Sequence_2 > 10]
# the values returned in via mat_seq[mat_seq>10] come in the form of a vector
# in the order they were found in the matrix (from left to right, top to bottom)

#
#Description	Code	Example
#Transpose	t()	t(matrix(1:2, ncol = 1, nrow = 2))
#Create matrix where diagonal is filled with x	diag()	x<-1:5; diag(x)
#Return the diagonal of a matrix	diag()	diag(matrix(1:9, ncol = 3, nrow = 3))
#Calculate eighenvalues and eigenvectors	eigen()	eigen(matrix(1:9, ncol = 3, nrow = 3))
#Sums of the rows	rowSums()	rowSums(matrix(1:9, ncol = 3, nrow = 3))
#Sums of the columns	cowSums()	rowSums(matrix(1:9, ncol = 3, nrow = 3))
#Means of the rows	rowMeans()	rowMeans(matrix(1:9, ncol = 3, nrow = 3))
#Means of the columns	colMeans()	rowMeans(matrix(1:9, ncol = 3, nrow = 3))

# Arrays
# Starting with a simple array:

Array_1 <- array(1:24, dim = c(3, 4, 2))
Array_1

#We specified there were going to be three rows, four columns, and two matrix levels to the array by writing dim = c(3, 4, 2)

Array_2 <- array(1:24, dim=c(3,2,4))
Array_2

# And have four smaller matrices of three rows and two columns.
#  because arrays are n dimensional, we can also do:

Array_3 <- array(1:24, dim = c(3,2,2,4))
dim(Array_3)

Array_3

#Create an array containing 100 random numbers drawn from a uniform 
#distribution (see runif()) with at least 3 groups. Consider the 
#limitations in terms of the dimensions you can specify given the 
#length of the data you are adding to the matrix.
My_Array <- array(runif(100, 69, 420), dim = c(5, 5, 4))
My_Array

# Data Frames
# most common data structure in R.
# they allow us to store multiple different types of data in the same data structure

# My first data frame
#make a data frame with information on whether a Species was seen (1 = yes, 0 = no), 
# on a particular Day:

My_Data_Frame <- data.frame("Day" = rep(1:3, each = 3), 
                            "Species" = rep(letters[1:3], each = 3),
                            "Seen" = rbinom(n = 9, size = 1, prob = 0.5))

My_Data_Frame
##look at the Day column
My_Data_Frame["Day"]

?rbinom() # binomial distribution

#a data.frame is in effect a series of vectors arranged in columns - within a 
# column the data types can't mix, but across columns they can.


# specify the names for each of the coluns in the data.frame using the 
# form "Name" = 
# We can still access data in the data frame using the "our_data[1,2] 
# our our_data["Day"] approach earlier
# however, the new structure we can also access the data via the $ operator

# accessing the Day Column from My_Data_Frame

My_Data_Frame$Day

# This returns the vector found in the column "Day"
# We can also use the $ operator to add a column to a data.frame 
# We use it to specify then name of the column and give some data to
# fill that column: 

My_Data_Frame$location <- "United Kingdom"
My_Data_Frame

# we just provied a single value ("United Kingdom") R will assume we 
# ant this repeated in ever row of the column automatically.

# Calculations using data.frame values
# We can use the data in data.frames exactly as if they were vectors
# accessing them usinghte $ operator

# some simple data
Simple_Data <- data.frame( "a" = runif(10, 0, 1),
                           "b" = rnorm(10, 3, 5))
Simple_Data

# example calculations

Simple_Data$calc <- (Simple_Data$a * Simple_Data$b) - Simple_Data$b
Simple_Data

# Task : Create a data frame which includes the following four vectors:

name = c('Anastasia', 'Dima', 'Katherine', 'James', 'Emily', 'Michael', 'Matthew', 'Laura', 'Kevin', 'Jonas')
score = c(12.5, 9, 16.5, 12, 9, 20, 14.5, 13.5, 8, 19)
questions = c(1, 3, 2, 3, 2, 3, 1, 1, 2, 1)
qualify = c('yes', 'no', 'yes', 'no', 'no', 'yes', 'yes', 'no', 'no', 'yes')

Data_Frame = data.frame(name, score, questions, qualify)
Data_Frame

# display the structure of the data frame you just created: 
str(Data_Frame)

# add a column to this data frame which is the mean score per question
Data_Frame$mean_score <-  Data_Frame$score/Data_Frame$questions

Data_Frame$mean_score <- (Data_Frame[,2])/(Data_Frame[,3])
Data_Frame

# using the $ to highlight columns and then using the [] brackets to make criteria for what you want

Data_Frame[which(Data_Frame$questions=="2" & Data_Frame$qualify=="yes"),]

# Lists - 

#$ - referring to a column within a data frame 

# Lists
# The final data structure we are going to consider
# Lists are data structures that can contain other data structures

# making a numeric matrix 

Numeric_Matrix <- matrix(rep(1:3, each = 5),
                         nrow = 3,
                         ncol = 5,
                         byrow = TRUE)

Numeric_Matrix

# now make a vector of letters 
Letter_Vector <- LETTERS[4:16]
Letter_Vector

# now make a data.frame of species information:
Species_Data <- data.frame("Species" = c("a", "b"),
                           "Observed" = c(TRUE, FALSE))
Species_Data

# now save them into a list using the list() function

My_First_List <- list(Numeric_Matrix,
                      Letter_Vector,
                      Species_Data,
                      5)
My_First_List

# So we now have an object called "My_First_List"
# this has 4 objects inside it
# 1 = numeric matrix, 2 = letters vector, 3 = species data frame, 4 = the number 5

# the square brackets show the position in the list of each of these objects
# we can use double square brackets to extract these objects from the list:

My_First_List[[1]]

# and we can access items in that object again using the square brackets

My_First_List[[3]][1,]

# ~ within the 3rd thing of our list (the species data frame), 
# I want the ALL of the columns from row 1

# We can also save the objects into the list with names, to access
# them through the $ operator as we did with the data.frame

# save them into a list using the list() function with names:

My_Second_List <- list("numbers_vec" = Numeric_Matrix,
                       "letters" = Letter_Vector,
                       "spp_pres" = Species_Data,
                       "number" = 5
)

My_Second_List
# display the names of the objects:
names(My_Second_List)

#view the list 
My_Second_List[[3]][1,]

#or

My_Second_List$numbers_vec

# the list() function two lists as the objects 
# instead of the matrix, data.frame, etc we use above:

##make a new list with "data" split into two different sites - site 1 and site 2:
our_second_list <- list("site_1" = My_Second_List,
                        "site_2" = My_Second_List)

##display the list
our_second_list

# R also tells you how to access each of these data objects. e.g. 
# to access the letters from site 1 you can do:
# letters in site 1

our_second_list$site_1$letters

# You don't need to name the different objects when you're making a list()
# You don't have to do: list("site_1" = our_list, site_2 = our_list) 
# you can just do list(our_list, our_list)
# but it often helps to have them well labelled so you don't get lost
# especially when they're complex! 

# Functions outside of the base R 

# base R included a lot of very useful functions, 
# it isn't exhaustive and we will want to use functions which are not included
# in the basic installation 
# These are contained in "packages" which can be downloaded and installed onto your version of R.
# There are two main ways to install packages 

# Packages on CRAN 

install.packages("devtools", dependencies = TRUE)

library("devtools")

# you have now downloaded and installed the 'devtools' package - it has alos been added to the 
# global environment 

# install the 'vroom' package
# the argument for install_github takes the username and repository name where the package resides
# if we look at the vroom url: https://github.com/r-lib/vroom
# we can see that we just use the bit after github.com/

install_github("r-lib/vroom")

# Remember that you don't need to load all of the packages you have when running a script
# Only run load the packages you NEED!

# Telling R to use the 'vroom' function from the 'vroom' package 

vroom::vroom()

# Loading data into R 
# Two most common data sorts: .csv files and .RData files.

# .CSV files:
# restricted to MATRIX style data (data in two dimensions, matrices and data.frames)

# vroom is a powerful tool for dealing with really really big data sets 
# is does not read all of your data, but indexes where records are ket
# thus they can be read when needed 
# We will use it as our go-to for reading in data 

# loading from your computer

library("devtools")

install_github("r-lib/vroom")

vroom::vroom()

library(vroom)



setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


wad_dat <- vroom('../Data/Workshop 3/wader_data.csv')

# be careful where to put in the fullstops and what not 

# using vroom to install diredtly from github 

covid_dat <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/time_series_covid19_deaths_global.csv")

# note that this does require an internet connection though 

# vroom can also load multiple files simultaenously, combining them into a single object
# as long as the column names are the same across the different files
# vroom provides a nice example of this in their vignette:

##you can ignore this code for the moment if you want
##but to briefly summarise it is reading in some data included in base R
##and then splitting it into 3 differnt data.frame style objects based on the values in one of the columns ("cyl")
mt <- tibble::rownames_to_column(mtcars, "model")
purrr::iwalk(
  split(mt, mt$cyl),
  ##save this split files in to the default directory
  ~ vroom_write(.x, glue::glue("mtcars_{.y}.csv"), "\t")
)

##find files in the default directory which start with "mtcars" and end in "csv"
##save these file names as an object called "files"
files <- fs::dir_ls(glob = "mtcars*csv")

##these are then the names of the files matching the above arguments:
files
##then load these file names using vroom 
vroom(files)
#You can see that vroom() now returns a single file which is the combination of the 
# three files we read in. Don’t worry about trying to understand all the detail provided 
# thats what we will be doing in the next section.

# R Data
# One other very useful file type to know about in R is .RData, which is (unsurprisingly) 
# specific to the R progrmaming language. This has its advantages (its very space efficient, 
# and you arent restricted to dealing with 2 dimensional tables as you are with the .csv file 
# type - i.e. you can share complex data types like lists, matrices, etc) but the draw back is 
# that you can’t open it in other programmes (e.g. like a .csv file where you can open it in Excel 
# and visualise it).

# .RData are loaded into R using the load() function in much the same way as .csv files are:

##load in some RData
load("my_data/pathway/my_data.RData")

# ^ example 

# Writing Data out of R
# .csv data 

# write out a .csv file:

## --  vroom_write(my_data, "a pathway/a data folder/ the_name_of_my_data.csv") -- 

# R Data:
# can be written out using the save() function in base:
# write out my data as an RData file: 

# save(my_data, file - "a pathway/ a data folder/ the_name_of_my_RData.RData)

# However we can here specify as many items as we want to save out, and these data types can be anything R can handle (vector, list, array, etc):
  
  ##write out my data as an RData file:
#  save(my_data, 
 #      my_vector, 
  #     my_list, 
   #    my_array,
    #   file = "a pathway/a data folder/the_name_of_my_RData.RData")

# the above would this save all of those data objects as a single .RData file, and when 
# you load that .RData file in all of those objects would be 
# available straight away in the global environment under their original names. Nifty!




# Installing and using Tidyverse:

##install the tidyverse
install.packages("tidyverse")

#and then loading as normal:
# load the tidyverse
library("tidyverse")

# you have just installed all of TidyVerse and are now ready to use all of the packages that it comes with


