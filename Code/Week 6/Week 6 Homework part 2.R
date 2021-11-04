# Week 6 Homework Part 2:

# Positive effect of Petal.Length on Petal.Width 

data("iris")
library(ggplot2)

## Plot the sepal widths so we can visualize if there are differences between the different species
ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) + 
  geom_jitter(aes(col=Species)) +
  theme_bw()

# Petal length and petal width histograms:

#1. Petal Length Histogram
ggplot(iris, aes(x=Petal.Length,
                  fill=Species)) +
  geom_histogram(binwidth=.1, alpha=.5, position = "identity")

#2.Petal Width Histogram
ggplot(iris, aes(x=Petal.Width,
                 fill=Species)) +
  geom_histogram(binwidth=.1, alpha=.5, position = "identity")


# generate and plot the model: 
mod1 <- glm(Petal.Width ~ Petal.Length * Species,
                data = iris,
                family = "gaussian")

class(mod_iris)
plot(mod_iris)
summary(mod_iris)

mod2 <- glm(Petal.Width ~ Petal.Length * Species,
                  data = iris,
                  family = gaussian(link = "log"))

mod3 <- glm(Petal.Width ~ Petal.Length * Species, 
                  data = iris,
                  family = "poisson")

mod4 <- glm(Petal.Width ~ Petal.Length * Species,
                  data = iris,
                  family = gaussian(link = "inverse"))
                  
library(gamlr)

##compare the models
AIC_mods <- data.frame(model = c("mod1", "mod2", "mod3", "mod4"),
                       AICc = c(AICc(mod1), AICc(mod2), AICc(mod3), AICc(mod4)))

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AICc),]


# returning the predicted gaussian 
iris$pred_gaussian <- predict(mod1,
                                    type="response")

# returning the residual gaussian 
iris$resid_gaussian <- resid(mod1)

# making a plot
p1 <- ggplot(data = iris, aes(x = Petal.Length,
                              y = Petal.Width,
                              col = Species)) +
  geom_point() +
  geom_smooth(data = iris,
              method = glm)
p1









