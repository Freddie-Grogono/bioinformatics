



y = c(4.26, 5.68, 7.24, 4.82, 6.95, 8.81, 8.04, 8.33, 10.84, 7.58, 9.96)

x = 4:14
x = seq(4, 14,1)


plot(y ~ x)

model = lm(y ~ x) # lm function is linear model


summary(model)        

?identity


model.glm = glm(y ~ x, family = gaussian (link = "identity"))
summary(model.glm)

install.packages("titanic")

if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("paulhendricks/titanic")

library(titanic)
data.raw = titanic_train


 data.raw[data.raw == ""] <- NA # turning lacking data in NA 

# how many do we have? 
sapply(data.raw, function(x) # function of x (columns )
  sum(is.na(x))) # applies the function to the data

length(data.raw$Pclass) 
levels(data.raw$Sex) # this is not a factor so have to convert into a factor
levels(factor(data.raw$Sex))# this will tell you that you have "female" and "male"

levels(factor(data.raw$Survived))
levels(factor(data.raw$Embarked))



# whos us the number of NAs in the data set ^
# basically says nothing about the cabin 

# dropping the useless columns in the data 
data <- subset(data.raw, select = c(2, 3, 5, 6, 7, 8, 10, 12))

# output is zero or one (binary)

# performing a logistic regression
model <- glm(Survived ~ Sex, family = binomial(link = 'logit'), data = data)
summary(model)


# summarising the model output: 
summary(mod_iris)
# look at the co-efficient 
# For more informtaion on the outcome of the summary and interpreting results, look at:
# https://www.theanalysisfactor.com/r-glm-model-fit/
# https://www.r-bloggers.com/2018/11/interpreting-generalized-linear-models/


# Our values for our other two species are relative to this mean. So to calculate the mean value for versicolor we need to add its Estimate 
# (from the above table) to the Intercept:
3.428 + -0.65800
## [1] 2.77


#'And the same for virginica:
  3.428 + -0.45400
## [1] 2.974
# Remember that these values are taken from the 'coefficients' in the summary output 
  
  # Multiple Comparisons Test: 
  # used to determine if  there are significant differences between our groups
  


## load the multcomp pack
library(multcomp)

## run the multiple comparisons, and look at the summary output:
summary(glht(mod_iris, mcp(Species="Tukey")))



## GLM with Continuous Predictors:



