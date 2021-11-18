# Week 6 R Workshop Session 


# Normal Distribution forms the basis of all statistics 
hist(rnorm(1000, 161.6, sd = 8.8)) # histogram plot of average height of females in the US 


##load the iris data set
data("iris")

#install the ggplot2 package
install.packages("ggplot2")

#use the ggplot 2 library 
library(ggplot2)

## Plot the sepal widths so we can visualise if there are differences between the different species
ggplot(iris, aes(x=Species, y=Sepal.Width)) + 
  geom_jitter(aes(col=Species)) +
  theme_bw()

ggplot(iris, aes(x=Sepal.Width, fill = Species)) +
  ## bin width determines how course the histogram is
  ## the alpha determines the transparency of the bars
  ## position allows you to determine what kind of histogram you plot (e.g. stacked vs overlapping). try changing to position="stack"
  geom_histogram(binwidth = .1, alpha = .5, position="identity")



##fit a glm()
mod_iris <- glm(Sepal.Width ~ Species, #  ~ in R as “as a function of”. So in this case, we are testing whether the Sepal.Width changes as a function of species
                ##specify the data
                data = iris,
                ##specify the error structure
                family = "gaussian")

mod_iris
# Sepal width is the dependent variable and Species is our independent variable. 
# Family here means the error structure, so we are assuming (initially) that our residuals are normally distributed, this means that - given our current settings - we are actually just fitting a ANOVA to the data.

##display the class of the model object
class(mod_iris)

##display the class of the model object
plot(mod_iris) # this will return a load of different graphs that give an insight as to what our data looks like

# Breifly, for the above plots:
# 1. the residuals vs fitted doesn't show a clear trend, so that's OK
# 2. the normal Q-Q closely follows the dotted line, so that's OK
# 3. the residuals appear randomly distributed so there isn't any heteroskedasticity - so this is ok too
# 4. None of the points appear to have an undue effect on the residuals, so we don’t need to consider removing any of them.

##summarise the model outputs
summary(mod_iris)

# Note - for a full discussion of the output see the excellent posts:
# < https://www.theanalysisfactor.com/r-glm-model-fit/ >
# < https://www.r-bloggers.com/2018/11/interpreting-generalized-linear-models/ >

# Our values for our other two species are relative to this mean. So to calculate the mean value for versicolor we need to add its Estimate (from the above table) to the Intercept:
3.428 + -0.65800
## [1] 2.77

# And the same for virginica:
  3.428 + -0.45400
## [1] 2.974

  
  
  
# Multiple Comparisons Test 
  ## load the multcomp pack
library(multcomp)

  
## run the multiple comparisons, and look at the summary output:
summary(glht(mod_iris, mcp(Species="Tukey")))
____________________________________________________________
____________________________||______________________________
# GLM with Continuous predictors 
# Working on a single population time series from the species data you plotted for homework last week
# Looking at whether thaere has been a significant increase, decrease or no change in that population over time 
# Then we will try to fit a GLM to the data, checkign the fit and other potential models, then think about plotting the outputs of the model 

install.packages("tidyverse")
library(tidyverse)
library(vroom)

# Loading in the data 
wide_spp.1 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_1.csv")
wide_spp.2 <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/to_sort_pop_2.csv")

# Joining the data 
long_spp <- full_join(wide_spp.1, wide_spp.2) %>% 
pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = T, 
               values_to = "abundance")

print(long_spp)

# Set the date column to date format.
long_spp$date <- as.Date(long_spp$date, format = "%Y-%m-%d")

# filtering the time series to get a data frame called single_spp containig only data on Trichocolea Tomentella 
single_spp <- long_spp %>% 
  filter(species == "Trichocolea tomentella")

# We have now successfully filtered the data, lets visualize! 
p1 <- ggplot(single_spp, aes(x=date, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("Year")
##add the loess smoothing:
p1 + geom_smooth(method="loess")

# We can clearly see that the population is declining
# Always consider the X-axis on the plot 
# R will accept Date as a predictor 
# Often better to replace with a numeric vector as it's easier to interpret
# So....

## calculate a new column (`standardised_time`) which is the difference between the
## starting date of the time series and each other date in weeks (see ?difftime)
## we will set this to a numeric vector
single_spp <- single_spp %>%
  mutate(standardised_time = as.numeric(difftime(as.Date(date),
                                                 min(as.Date(date)),
                                                 units = "weeks")))

print(single_spp[,c("abundance", "date", "standardised_time")], 30)

# Now fitting the GLM: 
mod1 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "gaussian")

# Assessing the fit to the model: 
# never going to find a perfect fit but rather a 'good' fit

# We need:
# predicted y values for each x value from the model
# the residuals 

# do this using the predict() and resid()
# returning the predicted (response) values from the model 
# and adding them to the single species tibble:

single_spp$pred_gaussian <- predict(mod1,
                                    type="response")
# Adding the residuals of the model to the spp data.frame 
##return the model residuals and add to the single species tibble:
single_spp$resid_gaussian <- resid(mod1)


# Now we have added these data to our original data frame we can start to plot 
# Using the style 'Error Distributions'
# First start with the original plot with added in the predicted values from the model as a line:


p2 <- ggplot(single_spp, aes(x = standardised_time,
                             y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") + # this just mean y-label and x-label 
  xlab("standaradised_time")

# now we add in a line of the predicted values from the model:
p2 <- p2 + geom_line(aes(x = standardised_time,
                         y = pred_gaussian),
                     col = "dodgerblue",
                     size = 1)

p2 

# Note at this point the plot isn't very pretty so lets add some more bits:
# Vertical blue lines which show the residual error of the model
# how far the observed points are from the predicted value

# In geom_segment we specify where we want the start and end of the segments (lines)
# to be. Without any prompting, ggplot will assume that we want the start of the lines 
# to be taken from the x and y values we are plotting using the ggplot() function
# i.e. standardised_time and abundance, so we just need to specify the end points of
# the lines:

p2 <- p2 +
  geom_segment(aes(xend = standardised_time,
                   yend = pred_gaussian),
               col="lightblue")
## add a title
p2 <- p2 + ggtitle("Fitted model (gaussian with identity link)")

##print the plot
p2

# Eye-balling this it looks like a pretty good fit, which is nice.
# Next, let’s check the residuals around the fitted values:

# plotting a histogram of the residuals from the model using geom_histogram()

p3 <- ggplot(single_spp, aes(x = resid_gaussian)) +
  geom_histogram(fill = "goldenrod") +
  theme_minimal() +
  ggtitle("Histogram of residuals (gaussian with identity link)")
p3

# this shows us that our residual are not normally distributed:
# lets look at how the residules change with the predicted vs residuals in the single_spp data.frame

p4 <- ggplot(single_spp,
             aes(x = pred_gaussian,
                 y = resid_gaussian)) +
  geom_point() +
  theme_minimal() +
  xlab("Predicted values") +
  ylab("residuals") +
  ggtitle("Predicted vs residual (gaussian with identity link)") +
  geom_smooth(fill="lightblue", col="dodgerblue")
p4

# There is a clear banana shape for the residuals errors
# This is due to a problem with using the standard_time 

# Lets use a QQ plot for the residuals from the model, assuming a normal distribution,
# and add the straight line, the points should fall along: 

qqnorm(single_spp$resid_gaussian); qqline(single_spp$resid_gaussian)
# the points also deviate from the expected straight line
# our data is likely to be negatively skewed


# Exploring different models to see if they will do a better job:
# The data are counts (abundance of species at each standardised_time) so one very sensible option is a glm with poisson error distribution.

## SO fit a glm with a poisson distribution
mod2 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "poisson")

## OR fit a glm with a gaussian distribution with a log link
mod3 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "log"))

# We could also try a guassian model with an inverse link:
## we could also try a guassian model with an inverse link
mod4 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "inverse"))



# We now have got four models to test: 
# We can compare the fits of these models to the data using the Akaike information criterion (AIC):
##compare the models <https://en.wikipedia.org/wiki/Akaike_information_criterion>
AIC_mods <- AIC(mod1,
                mod2,
                mod3,
                mod4)

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AIC),]
#  (AIC) compares the quality of a set of statistical models to each other
# order in this case is putting them in ascending order from lowest AIC result to highest
# the lower the AIC the better the model so in this case model 3 is best

# Whilst AIC tells us about the comparitive fits of the different models, it doesn’t tell us 
# how well the models actually fit the data. They could all just fit it really badly, and 
# mod3 just fits it least badly! So we need to go back and check the fits of the model again.

# Now do a plot similar to the fitted model earlier (P2) with the fits and residuals for a guassian distribution
# with an identity link 


##return the predicted (response) values from the model and add them to the single species tibble:
single_spp$pred_gaussian_log <- predict(mod3,
                                        type = "response")

##return the model residuals and add to the single species tibble:
single_spp$resid_gaussian_log <- resid(mod3)

# Now do the plot again, adding in the predicted values from the model as a line. 
# We can modify the plot we started earlier: 

p5 <- ggplot(single_spp, aes ( x = standardised_time,
                               y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("Standardised_time")

# Now add in a line of predicted values from the model: 

p5 <-  p5 + geom_line(aes(x = standardised_time,
                      y = pred_gaussian_log),
                      col = "dodgerblue",
                      size = 1)

p5 <- p5 + ggtitle("Fitted model (gaussian with log link)")
p5 # That looks like a good fit! 

plot(mod3)

# 1. the residuals vs fitted doesnt show a clear trend, so thats ok
# 2. the normal Q-Q closely follows the dotted line, so thats ok
# 3. the residuals appear randomly distributed so there isnt any heteroskedasticity - so this is ok too
# 4. none of the points are outside the 0.5 or 1 lines, so none of the data are exerting an overly strong effect on the predicted trends (if they were we might consider removing them).
# https://data.library.virginia.edu/diagnostic-plots/ 

# Model summaries and outputs
# So we have fit our model, and ensured that our model fits the data well. Now we want to look at what our model says about the data.
# First off let’s look at the model output, using the summary() function:


# summarise the model output: 
summary(mod3)
# In depth explanation of this on: < https://data.library.virginia.edu/diagnostic-plots/ >
# The guassian distribution is not specifically formulated for count data 
# It assumes that error values are going to be continuous, whereas 
# we know thta isn't the case with out data 

# Model Summaires and Ouptut
summary(mod3)
# there is a significant negative effect of standardised_time on the dependent variable (abundance)
# there is a decrease of ~0.003 individuals per week over the time series 
# lets plot the ouput of this model, a great way to visualize
# how well it fits the data and is ideal for things like publications and to communicate the results of your analyses

p6 <- ggplot(single_spp, aes( x = standardised_time,
                              y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

# then use the geom smooth() to add the regression to the plot.
# unlike earlier here we specify the model type (Glm), the formula and the error structure and link:
p6 <- p6 + geom_smooth(data = single_spp,
                       method = "glm",
                       method.args = list(family = gaussian(link = "log")),
                       formula = y ~ x,
                       col = "dodgerblue",
                       fill = "lightblue")

p6     

# You can see that ggplot() conveniently calculates the confidence intervals around the line, giving us a nice visualization of the fitted model.

install.packages("usethis")
library("usethis")

## set your user name and email:
usethis::use_git_config(user.name = "Freddie-Grogono", user.email = "fg17761@bristol.ac.uk")

## create a personal access token for authentication:
usethis::create_github_token() 
##hit generate token (PAT) at the bottom of the page and copy it!

## set personal access token:
credentials::set_github_pat("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")

## or store it manually in '.Renviron':
usethis::edit_r_environ("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")
## store your personal access token with: GITHUB_PAT=xxxyyyzzz
## and make sure '.Renviron' ends with a newline

# ----------------------------------------------------------------------------

#### 4. Restart R! ###########################################################

# ----------------------------------------------------------------------------

#### 5. Verify settings ######################################################

usethis::git_sitrep()





