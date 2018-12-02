# Regression

# install.packages("readr", dependencies = TRUE)
# install.packages("Hmisc", dependencies = TRUE)
# install.packages("pastecs", dependencies = TRUE)
# install.packages("psych", dependencies = TRUE)
# install.packages("skimr", dependencies = TRUE)
# install.packages("AER", dependencies = TRUE)
# install.packages("MASS", dependencies = TRUE)

library(AER)
library(readr)
library(pastecs)
library(psych)
library(skimr)
library(MASS)

# Load the data
data(CollegeDistance)
names(CollegeDistance)

# Descriptive statistics

#Hmisc::describe(CollegeDistance)
#pastecs::stat.desc(CollegeDistance)
psych::describe(CollegeDistance)
skimr::skim(CollegeDistance)

# Basic linear model
#########################
# Model selection
#########################

start.model <- lm(education ~ score + urban + distance + tuition, data = CollegeDistance)
simple.model <- lm(education ~ 1, data = CollegeDistance)
MASS::stepAIC(start.model, scope = list(upper = start.model, lower = simple.model), direction = "backward")

## Full model (almost)

fmodel <- lm(education ~ gender + ethnicity + score + fcollege + home + urban + wage + 
               distance + income, data = CollegeDistance)
summary(fmodel)

#########################
## Breakdown
#########################
# The breakDown package is a model agnostic tool for decomposition of predictions 
# from black boxes. Break Down Table shows contributions of every variable to a 
# final prediction. Break Down Plot presents variable contributions in a concise 
# graphical way. This package works for binary classifiers and general regression models.

install.packages("devtools", dependencies = TRUE)
devtools::install_github("pbiecek/breakDown")
library(breakDown)
new_observation <- CollegeDistance[1,]
br <- broken(fmodel, new_observation)
br
plot(br)

#########################
# jtools
#########################

#devtools::install_github("jacob-long/jtools")
library(jtools)

jtools::summ(fmodel)
jtools::summ(fmodel, scale = TRUE, vifs = TRUE, part.corr = TRUE, 
             confint = TRUE, pvals = FALSE)


model1 <- lm(education ~ gender + ethnicity + score, data = CollegeDistance)
model2 <- lm(education ~ gender + ethnicity + score + fcollege + home, data = CollegeDistance)
model3 <- lm(education ~ gender + ethnicity + score + fcollege + home + urban + wage + 
               distance + income, data = CollegeDistance)

# coef.names <- c("Gender" = "gender", "Ethnicity" = "ethnicity", )

## Bug: Error: Install the huxtable package to use the export_summs function.
install.packages("huxtable", dependencies = TRUE)
library(huxtable)
jtools::export_summs(model1, model2, model3, scale = TRUE, transform.response=TRUE)

## Bug: Error: Install the ggstance package to use the plot_coefs function.
# install.packages("ggstance", dependencies = TRUE)
library(ggstance)
plot_summs(model1, model2, model3, scale = TRUE, robust = "HC3")

plot_summs(model3, scale = TRUE, robust = "HC3", plot.distributions = TRUE)

#########################
# caret
#########################
# install.packages("caret", dependencies = TRUE)
library(caret)
importance <- varImp(fmodel, scale=FALSE)
plot(importance)
