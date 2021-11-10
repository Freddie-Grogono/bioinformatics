# Week 7 

##install the usethis package and then load it
install.packages("usethis")
library("usethis")
library(tidyverse)
library(vroom)
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

## calculate standarised time per pop and per species. 
long_spp <-  long_spp %>% 
  group_by(species, population) %>%
  mutate(standardised_time = as.numeric(difftime(as.Date(date), 
                                                 min(as.Date(date)), 
                                                 units="weeks")))

## just look four of the columns to visualise the data 
## (you can look at all in Rstudio) but printing all the columns in 
## Rmarkdown means we won't see the standardised_time column

print(long_spp[,c("species", "population", "abundance", "standardised_time")], 10)


## make a new column in long_spp which is the number of threats recorded for each population
##this is the length of the non-NA values in each row of the columnns primary_threat, secondary_threat, and tertiary_threat: 
long_spp <- long_spp %>% 
  rowwise %>%
  mutate(n.threats = length(which(!is.na(c(primary_threat, secondary_threat, tertiary_threat)))))

##load in the scales package for the psudo_log transformation
library(scales)

##build the ggplot, setx§ing the date to a date format
ggplot(long_spp, aes(x=as.Date(date), 
                     y=abundance, 
                     col=n.threats))+
  ##set the theme to minimal
  theme_minimal() +
  ##position the legend at the top on the left
  theme(legend.position = "top", 
        legend.justification="left") +
  ## change the automatic label for the legend to the following
  ## note it is done twice (once for fill and once for col) as 
  ## we change the colour of the lines and the fill of the smooth according to the number of threats
  labs(col="Number of threats", fill="Number of threats") +
  ## add in the lines of the population, using the group and interaction functions
  ## to specify how the data are grouped and get 1 line per population 
  geom_line(aes(group = interaction(population, 
                                    species, 
                                    n.threats, 
                                    population)), 
            alpha=0.2, 
            size=1) + 
  ## add in a smoothed line across all of the population time series for each number of threats
  ## this visualises the mean change across the populations
  geom_smooth(aes(group = n.threats, 
                  fill = n.threats), alpha=0.3, size=1) +
  ##change the colours to reflect the number of threats, using a gradient
  scale_color_gradient(low = "#745745", 
                       high = "#d14124") +
  scale_fill_gradient(low = "#745745", 
                      high = "#d14124") +
  ## transform the y axis using a psudo_log transformation 
  ## (as we have some 0 counts and you can't log 0)
  scale_y_continuous(trans="pseudo_log") +
  ##change the x and y axis labels
  ylab("Population abundance") +
  xlab("standardised_time")

# We will set out to see - statistically - if there is any effect of the number of stressors a population is affect 
# on the rate of decline of those populations (as in the plot above), whilst accounting for the fact that this data covers different species.

## we will specify the x and y asethics here but specify the groups for the lines later
## this is because doing so means that the data for the geom_smooth() will then be all of the 
## data for each of the facets, but we can specify grouped data for the lines in geom_line
ggplot(long_spp, aes(x = standardised_time,
                     y = abundance)) + 
  ##add the points. we can use the group function to specify
  ## groups within the data (in this case species and population)
  ## that we want to treat as seperate data for the sake of plotting
  ## the `interaction()` function allows us to specify multiple levels to these data
  geom_line(aes(group = interaction(species, population))) + 
  facet_wrap(~n.threats) +
  theme_minimal() +
  ##fit a linear regression to the data to help visualise
  geom_smooth(method = "lm")

## I havent run this, but here is an example of what happens when we group 
## in the initial ggplot() function rather than in the geom_line()
## try running it and seeing what happens
ggplot(long_spp, aes(x = standardised_time,
                     y = abundance,
                     group = interaction(species, population))) + 
  geom_line() + 
  facet_wrap(~n.threats) +
  theme_minimal() +
  geom_smooth(method = "lm")


# 1. abundance - this will be our response variable
# 2. standardized_time - we want to understand whether the number of threats affects 
# the populations through time, so we still need to include the time element
#3. n.threats - the number of threats
#4. species - looking at the above plots it seems like the species are potentially behaving in slightly different ways
#5. population - for some of the species we have multiple populations, which we might want to consider separately.

# abundance ~ standardised_time + n.threats + standardised_time:n.threats

# abundance ~ standardised_time + n.threats + standardised_time:n.threats

# How to specify in the GLMMs 
# you specify random intercept effects using + (1 | group)
# you specify random slope but fixed intercept using + (0 + x | group)
# you specify random slope and intercept effects using + (x | group)
# Fitting a model whilst only changing the X intercept, the slope is remaining the same meaning we are ASSUMING that the 
# number of stressors effect on population is the same, there are just different mean abundancies in the each species. 

install.packages("glmmTMB")
install.packages("nloptr")

library(glmmTMB)
##fit a random effects model
m_mod1 <- glmmTMB(abundance ~ 
                    standardised_time + 
                    n.threats + 
                    standardised_time:n.threats + 
                    (1|species), 
                  data=long_spp, 
                  family="gaussian")

##look at the model summary:
summary(m_mod1)

# calculate how much of the variance the random effect accounts for as the variance of the random effect 
# divided by the sum of the random effect variance and residual variance:

# = 9602 / (9602 + 4447)
9602 / (9602 + 4447)
# = about 70%

# NESTING 
# So back to our example, we want to nest population inside species, and do this as follows:
##fit a random effects model with nested random effects
m_mod2 <- glmmTMB(abundance ~ standardised_time + 
                    n.threats + 
                    standardised_time:n.threats + 
                    (1|species/population), 
                  data=long_spp, 
                  family="gaussian")

##look at the model summary:
summary(m_mod2)
#  we can see that we have a new term (population:species) in our “conditional model”

# Calculate the variance explained by these random effect
(8.988e+03+5.554e-93)/(8.988e+03+5.554e-93+3.755e+03)
# again it equals about 71%

# Crossed Random Effects:
# y ~ x1 + x2 + (1|z1) + (1|z2)
# Where z1 is one random effect, and z2 is another.

# So the model at the moment it:
# abundance ~ standardised_time + n.threats + standardised_time:n.threats + (1|species/population)

# loading DHARMA for plotting residuals and looking at the model fit: 

install.packages("DHARMAa")

library(DHARMa)
## simulate the residuals from the model
##setting the number of sims to 1000 (more better, according to the DHARMa help file)
m_mod2_sim <- simulateResiduals(m_mod2, n = 1000)

##plot out the residuals
plot(m_mod2_sim)

# Conclusion? Our model is doing a poor job of fitting to the data.
# Why?
# We have time series which go extinct, and then we have a series of 0’s recorded until the end of the time series
# Luckily our data finish with 0, 0, 0, 0 etc and don’t have something like 0, 0, 1, 0, 0 (which would make things trickier to code).
# This means we can tell R to return the data up to the first instance of a 0 being present:

##a function to return data up to and including the first 0 count:
single_zero <- function(x, group_info){
  if(nrow(x)>0){
    x <- x[ order(x$standardised_time) ,]
    if( min(x$abundance) == 0){
      return( x[1:min(which(x$abundance == 0)),] )
    }else{return(as_tibble(x))}
  }
}

library(tidyverse)

## make a new data frame
species_single0 <- long_spp %>% 
  ##we want to cut the long_spp data up by the values in species and population
  group_by(species, population) %>% 
  ##the group_map function allows us to apply a function to these groups
  ##and we want to keep the grouping variables, hence keep = T
  group_map(single_zero, .keep = T) %>% 
  ##and then bind it all back together again to a tibble
  ##otherwise it is returned as a list of the group data
  bind_rows()

single_zero(long_spp[which(long_spp$species=="Paraleucobryum longifolium"),])

#  The following are some of the most commonly used count data distributions which can be fit in glmmTMB (see here:

# poisson
# generalised poisson
# negative binomial (there are two different parameterizations of this available)
  # nbinom1
  # nbinom2

install.packages("fitdistrplus")
##load the fitdistrplus package
library(fitdistrplus)    

##fit a poisson distribution to our data:
fit_pois <- fitdist(species_single0$abundance, 
                    distr = "pois")
##plot the data
plot(fit_pois)

# It is clear that the data do not follow a poission distribution:
# ##look at the summary statistics
gofstat(fit_pois)
# Goodness-of-fit test for poisson distribution - a significant P value here denotes a significant difference 
# from the distribution we are testing the data against (poisson).
# Conclusion - the poisson distribution is a bad fit for our data.

# What about the negative binomial distribution? This is a great (and more fleixible) option for fitting to count data:
##fit a nbinom to the data instead
fit_nbinom <- fitdist(species_single0$abundance, 
                      dist = 'nbinom')
##again we get warnings from those missing values and can ignore

##plot it out:
plot(fit_nbinom)
# It looks much better! 

##the goodness of fit
gofstat(fit_nbinom)
# we still have a signifiacant difference from the nbimon distribution (p<0.05)
# we are looking at the distribution of the WHOLE data, and we need to ensure that the residuals fit the model assumptions.
#So the above is SUGGESTING that the poisson is unlikely to be a good fit
# the the negative binomial might be better. Better still, we might consider a zero inflated negative binomial 
# - which can account for a larger number of 0s than expected given the negative binomial distribution. 
# So we might like to consider the following distributions for our model:

# 1. poisson (unlikely to fit well)
# 2. negative binomial
# 3. zero inflated negative binomial

# NOTE - SCALING DATA:
# 2.0.7 Scaling data
# Just as a quick aside - we often scale() data (so the data have a mean of zero (“centering”) and standard deviation of one 
# (“scaling”)) when the continuous predictor variables we are using are on very different scales. 
# In our case we have one (number of threats) which is between 0 and 3 and one (standardised time) which is between 0 and 991. 
# This can cause issues with the model fitting, as the coefficents for one of your predictors might be vanishingly small 
# (and therefore hard to estimate) when compared to your other predictors.

# Time to fit the model:
# So here we fit our model, with scaled parameters, and population nested within species as our random effects:

## fit a poisson model
ps_mod <- glmmTMB(abundance ~ scale(standardised_time) * scale(n.threats) + 
                    (1 | species/population), 
                  data = species_single0,
                  family="poisson")
##summarise the model output
summary(ps_mod)

##function to calculate a psudo R2 value for our GLMM
r2.corr.mer <- function(m) {
  lmfit <-  lm(model.response(model.frame(m)) ~ fitted(m))
  summary(lmfit)$r.squared
}

## apply it to our poisson model
r2.corr.mer(ps_mod)
# the closer to one that this is, the better the model is 

# 0.867 is agood r2. There are also more complex methods e.g. that available in the MuMin package:

install.packages("MuMIn")
library(MuMIn)

##r squared calcualted by MuMIn:
MuMIn::r.squaredGLMM(ps_mod)

# We can also use a simple function to look at our overdispersion in the model:
##function to calculate overdispersion 
overdisp_fun <- function(model) {
  rdf <- df.residual(model)
  rp <- residuals(model,type="pearson")
  Pearson.chisq <- sum(rp^2)
  prat <- Pearson.chisq/rdf
  pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE)
  c(chisq=Pearson.chisq,ratio=prat,rdf=rdf,p=pval)
}

##apply to our data
overdisp_fun(ps_mod)
# data are considered overdispersed when the chisq value is > the rdf value - 
# i.e. when the ratio is > 1. Clearly these data are overdispersed!

# Using update to change the model type: 
###try with nbinom: 
nb1_mod <- update(ps_mod, family="nbinom1")
##and the second parameterisation of nb
nb2_mod <- update(ps_mod, family="nbinom2")

# Setting 0 inflated data models because we know we have 0s in our data set: 
##zero inflated version of these with zeros being attributed to number of threats:
Zi_nb1_mod <- update(nb1_mod, ziformula = ~n.threats)
Zi_nb2_mod <- update(nb2_mod, ziformula = ~n.threats)

##and we can also look at the zero inflated version of the poisson model:
Zi_ps_mod <- update(ps_mod, ziformula = ~n.threats)

# Running an ANOVA on the model types:
anova(ps_mod, 
      Zi_ps_mod,
      nb1_mod, 
      nb2_mod,
      Zi_nb1_mod,
      Zi_nb2_mod)


# We can see the zero inflated version NB1 model (Zi_nb1_mod) seems to fit the best of the models 
# tested (with Zi_nb1_mod having the (lowest AIC) 
# and if we look at the psudo-r2 values we can see that it is still fitting well:

# We can see that the Zi_nb1_mod is the most appropriate with the lowest AIC score: 

# Use the r2.corr.mer() function to calculate the psudo r2 value for the Zi_nb1_mod.

r2.corr.mer(Zi_nb1_mod) # This is basically looking at how well the model fits the data
# 86% shows that it is a great model! 

# Sadly the MuMIn::r.squaredGLMM approach we tried earlier doesn’t (yet) handle zero inflated version of the NB in glmmTMB, 
# however this model is looking like a pretty good fit for our data.


# Now looking at temporal correlations in the data: 

##fit a zero inflated negative binomial model with autocorrelation structure defined by the time variable
Zi_nb1_ar1_mod <- glmmTMB(abundance ~ scale(standardised_time) * scale(n.threats) + (1|species/population) + ar1(factor(scale(standardised_time)) - 1|species/population), 
                          data = species_single0,
                          ziformula=~n.threats,
                          family="nbinom1")

# Note - we have to include the predictor for ar1() as a factor (thats just the way that glmmTMB needs it to be, don’t ask!), 
# hence the factor(scale(standardised_time)).

##fit a zero inflated negative binomial model with autocorrelation structure defined by the time variable
Zi_nb1_ar1_mod <- glmmTMB(abundance ~ scale(standardised_time) * scale(n.threats) + (1|species/population) + ar1(factor(scale(standardised_time))-1|species/population), 
                          data = species_single0,
                          ziformula=~n.threats,
                          family="nbinom1",
                          ##the control parameter specifying the optimizer to use:
                          control=glmmTMBControl(optimizer=optim, optArgs=list(method="BFGS")))
# The troubleshooting vignette gives the following as probable reasons for this warning:
# 1. when a model is overparameterized (i.e. the data does not contain enough information to estimate the parameters reliably)
# 2. when a random-effect variance is estimated to be zero, or random-effect terms are estimated to be perfectly correlated (“singular fit”: often caused by having too many levels of the random-effect grouping variable)
# 3. when zero-inflation is estimated to be near zero (a strongly negative zero-inflation parameter)
# 4. when dispersion is estimated to be near zero
# 5. when complete separation occurs in a binomial model: some categories in the model contain proportions that are either all 0 or all 1

# If we look at the fixed effects of the model:
  ##show the fixed effects
fixef(Zi_nb1_ar1_mod)

##look at the model
Zi_nb1_mod

##zero inflated negative binomial model with autocorrelation and population as random effects
Zi_nb1_ar1_mod <- glmmTMB(abundance ~ scale(standardised_time) * scale(n.threats) + (1|population) + ar1(factor(scale(standardised_time))-1|population), 
                          data = species_single0,
                          ziformula=~n.threats,
                          family="nbinom1",
                          ##the control parameter specifying the optimizer to use:
                          control=glmmTMBControl(optimizer=optim, optArgs=list(method="BFGS")))

# (1). So let’s fall back to our previous best model -Zi_nb1_mod. If we thought there was likely to be significant 
# autocorelation structure then we would need to think about going back and simplifying our original model.

##load DHARMa
library(DHARMa)

## simualte the residuals from the model
##setting the number of sims to 1000 (more better, according to the DHARMa help file)
Zi_nb1_mod_sim <- simulateResiduals(Zi_nb1_mod, n = 1000)

##plot out the residuals
plot(Zi_nb1_mod_sim)

# Additional DHARMa tests:
# DHARMa also provides a suite of other test functions which allow us to run diagnostics on the simulated outputs from simulateResiduals():

## test to see where there are outliers, in our case not significant so we dont need to worry
testOutliers(Zi_nb1_mod_sim, 
             plot = TRUE)
## tests if the simulated dispersion is equal to the observed dispersion,
## again not significant so no need to worry
testDispersion(Zi_nb1_mod_sim, 
               plot = TRUE)
## compares the distribution of expected zeros in the data against the observed zeros
## this is right on the borderline of being significant, suggesting there might be a better structure for
## our zero inflation parameter (remember we used ~n.threats). That might be worth looking into further
testZeroInflation(Zi_nb1_mod_sim, 
                  plot = TRUE)
## see if there is temporal autocorrelation in the residuals
## not significant, so it turns out we didnt need to try and fit the autocorrelation model earlier on!
testTemporalAutocorrelation(Zi_nb1_mod_sim,
                            time = species_single0$standarised_time,
                            plot = TRUE) 


# Final Visual Checks: 
# compare the model predictions to the observed values. We will go back to our old friend the predict()function for this:
## add in the predicted values from the model:
species_single0$predicted <- predict(Zi_nb1_mod, 
                                     data = species_single0, 
                                     type = "response")

##plot the predicted against the observed
ggplot(species_single0, aes(x = abundance, 
                            y = predicted)) + 
  geom_point(col="grey") + 
  geom_abline(slope = 1) +
  theme_minimal() +
  xlab("Observed") +
  ylab("Predicted")


summary(Zi_nb1_mod)
# what is the actual final model

# Well, it says:
# 1. on average as time increases abudances decline
# 2. as the number of threats increases the average population size decreases
# 3. the interaction states that as those species with more threats decline faster through time than those with fewer threats


# PLOTTING THE MDOEL OUTPUTS 

## make a blank data set which includes the variables in the model
## we will then use this to generate predicted values from the model for 
## various combinations of number of threats, standardised time, species,
## and population
## we can use the unique() function across the columns in our data.frame
## to retrieve every unique combination of:
##n.threats, standardised_time, species, and population
new_data <-  unique(species_single0[,c("n.threats",
                                       "standardised_time", 
                                       "species", 
                                       "population")])

##scale the relevant columns (remember our model is expecting scaled data)
new_data$n.threats<-scale(new_data$n.threats)
new_data$standardised_time<-scale(new_data$standardised_time)

##set the random effects of the model to zero
X_cond <- model.matrix(lme4::nobars(formula(Zi_nb1_mod)[-2]), new_data)
beta_cond <- fixef(Zi_nb1_mod)$cond
pred_cond <- X_cond %*% beta_cond
ziformula <- Zi_nb1_mod$modelInfo$allForm$ziformula
X_zi <- model.matrix(lme4::nobars(ziformula), new_data)
beta_zi <- fixef(Zi_nb1_mod)$zi
pred_zi <- X_zi %*% beta_zi

##transform point estimates of the unconditional counts to the response scale and multiply
##(because they are logged and on logit link)
pred_ucount = exp(pred_cond)*(1-plogis(pred_zi))

##load the MASS library
library(MASS)

##set the random number generator seed
set.seed(101)

##use posterior predictive simulations to generated upper and lower confidence intervals
## and median predicted counts
##ignoring variabtion in the random effects

##conditional
pred_condpar_psim = mvrnorm(1000,mu=beta_cond,Sigma=vcov(Zi_nb1_mod)$cond)
pred_cond_psim = X_cond %*% t(pred_condpar_psim)

##zero inflation parameter
pred_zipar_psim = mvrnorm(1000,mu=beta_zi,Sigma=vcov(Zi_nb1_mod)$zi)
pred_zi_psim = X_zi %*% t(pred_zipar_psim)

##transform them
pred_ucount_psim = exp(pred_cond_psim)*(1-plogis(pred_zi_psim))

##calculate 95% CIs
ci_ucount = t(apply(pred_ucount_psim,1,quantile,c(0.025,0.975)))
ci_ucount = data.frame(ci_ucount)

##rename
names(ci_ucount) = c("ucount_low","ucount_high")

##put into a data frame
pred_ucount = data.frame(new_data, 
                         pred_ucount, 
                         ci_ucount)

##we need to reverse the scaling of our predictor variables for our plots to make sense
##the scale() function stores attributes of the scaling in the vectors of scaled data 
## try running new_data$n.threats and looking at the bottom values
##write a function to do this:
unscale <- function(x){
  x * attr(x, 'scaled:scale') + attr(x, 'scaled:center')
}

##unscale the variables
pred_ucount$n.threats_unscaled <- unscale(pred_ucount$n.threats)
pred_ucount$standardised_time_unscaled <- unscale(pred_ucount$standardised_time)

install.packages("viridis", dependencies = TRUE)

##load the viridis package (colourblind friendly palletes)
library(viridis)

##plot out the predicted median values for abundance
## in response to time (x-axis)
##and grouped by the number of threats
ggplot(pred_ucount, aes(x = standardised_time_unscaled, 
                        y = pred_ucount, 
                        group = n.threats_unscaled, 
                        col = n.threats_unscaled))+ 
  ##median lines for each number of threats
  geom_line() +
  ##add in a geom_ribbon to show the 95% CI
  geom_ribbon(aes(ymin = ucount_low,
                  ymax = ucount_high), 
              alpha = 0.1, 
              col = "grey", 
              linetype=0) +
  ##minimal theme
  theme_minimal() +
  ##set x and y axes labels
  ylab("Predicted\nabundance") + xlab("Time\n(weeks)") +
  ##viridis colour pallette for continuous data
  scale_colour_viridis_c() +
  ##move legend to the top
  theme(legend.position = "top") +
  ##rename the legend
  labs(colour="Number of threats")

