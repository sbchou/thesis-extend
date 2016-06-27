### Analyze Tweet Volume as a Count Distribution
### Which it is.

library(lme4)
library(lmerTest)
library(MASS)
library(AER)

stories <- read.table('../DATA/FOR_CORR/all_fields_no_title.csv', header=TRUE, sep = ",", quote = "'")
nrow(stories)
head(stories)

# remove NaN for some reason the python code breaks the CSV
stories <- stories[complete.cases(stories),]
nrow(stories)
# SHOULD BE 2651

######## WC ###########
### Model as Poisson ###
model.pois.wc = glm(num_tweets ~ wc, data=stories, family=poisson)
summary(model.pois.wc)

### Model as Negative Binomial ###
model.nb.wc = glm.nb(num_tweets ~ wc, data=stories, control=glm.control(maxit=100))
summary(model.nb.wc)

### What model fits better? ###
X1 <- 2 * (logLik(model.nb.wc) - logLik(model.pois.wc))
# 'log Lik.' 104529.3 (df=3)
pchisq(X1, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.


######## Emotionality ###########
### Model as Poisson ###
model.pois.emot = glm(num_tweets ~ emotionality, data=stories, family=poisson)
summary(model.pois.emot)

### Model as Negative Binomial ###
model.nb.emot = glm.nb(num_tweets ~ emotionality, data=stories)
summary(model.nb.emot)

### What model fits better? ###
X2 <- 2 * (logLik(model.nb.emot) - logLik(model.pois.emot))
# 'log Lik.' 104803.9 (df=3)
pchisq(X2, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.


######## Positivity ###########
### Model as Poisson ###
model.pois.pos = glm(num_tweets ~ positivity, data=stories, family=poisson)
summary(model.pois.pos)

### Model as Negative Binomial ###
model.nb.pos = glm.nb(num_tweets ~ positivity, data=stories)
summary(model.nb.pos)

### What model fits better? ###
X3 <- 2 * (logLik(model.nb.pos) - logLik(model.pois.pos))
# 'log Lik.' 104946 (df=3)
pchisq(X3, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.

 

 