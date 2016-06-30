### Analyze Tweet Volume as a Count Distribution
### Which it is.
library(lme4)
library(lmerTest)
library(MASS)
library(AER)
library(VGAM)
library(vcd)
require(ggplot2)

stories <- read.table('../DATA/FOR_CORR/all_fields_no_title.csv', header=TRUE, sep = ",", quote = "'")
# remove NaN for some reason the python code breaks the CSV
stories <- stories[complete.cases(stories),]

### DON'T FORGET TO CONVERT TO FACTORS!###
stories$num_tweets = as.numeric((stories$num_tweets))
stories$wc = as.numeric((stories$wc))
stories$emotionality = as.numeric((stories$emotionality))
stories$positivity = as.numeric((stories$positivity)) 

#### Data Checks ####
nrow(stories)
# SHOULD BE 2651
summary(stories)  

###### Diagnostic Plots ######
fit <- goodfit(stories$num_tweets) 
summary(fit) 
rootogram(fit)

Ord_plot(stories$num_tweets)

mod1 <- glm(num_tweets ~ wc, data=stories, family="poisson")
summary(mod1)
anova(mod1, test="Chisq")
 
deviance(mod1)/mod1$df.residual
dispersiontest(mod1)

library(car)
influencePlot(mod1)

library(pscl)
mod2 <- zeroinfl(num_tweets~wc, data=stories, dist="poisson")
AIC(mod1, mod2)

res <- residuals(mod1, type="deviance")
plot(log(predict(mod1)), res)
abline(h=0, lty=2)
qqnorm(res)
qqline(res)

library(faraway)
halfnorm(residuals(mod1))


######## Word Count ###########
model.wc <- vglm(num_tweets ~ wc, family=posnegbinomial(), 
                 control=vglm.control(maxit=1000), data=stories)
summary(model.wc)

output <- data.frame(resid = resid(model.wc)[, 1], fitted = fitted(model.wc))
ggplot(output, aes(fitted, resid)) + geom_jitter(position = position_jitter(width = 0.25), 
                                                 alpha = 0.5) + stat_smooth(method = "loess")



model.emot <- vglm(num_tweets ~ emotionality, family=posnegbinomial(), 
                 data=stories)
summary(model.emot)

output <- data.frame(resid = resid(model.emot)[, 1], fitted = fitted(model.emot))
ggplot(output, aes(fitted, resid)) + geom_jitter(position = position_jitter(width = 0.25), 
                                                 alpha = 0.5) + stat_smooth(method = "loess")

ggplot(output, aes(fitted, resid)) +
  geom_jitter(position=position_jitter(width=.25), alpha=.5) +
  stat_quantile(method="rq")

output <- within(output, {
  broken <- cut(fitted, hist(fitted, plot=FALSE)$breaks)
})

ggplot(output, aes(broken, resid)) +
  geom_boxplot() +
  geom_jitter(alpha=.25)



ggplot(data=stories, aes(emotionality, num_tweets)) +
  geom_boxplot() +
  geom_jitter(alpha=.25)

######## WC ###########
### Model as Linear-- baseline ###
model.lm.wc <- lm(num_tweets ~ wc, stories)
summary(model.lm.wc)

### Model as Poisson ###
model.pois.wc = glm(num_tweets ~ wc, data=stories, family=poisson)
summary(model.pois.wc)

### Model as Negative Binomial ###
model.nb.wc = glm.nb(num_tweets ~ wc, data=stories, control=glm.control(maxit=100))
summary(model.nb.wc)

# with log of data
model.nb.logwc = glm.nb(num_tweets ~ log(wc), data=stories, control=glm.control(maxit=100))
summary(model.nb.logwc)

# goodness of fit
1 - pchisq(summary(model.nb.logwc)$deviance,
           summary(model.nb.logwc)$df.residual
)

### What model fits better? ###
X0 <- 2 * (logLik(model.nb.wc) - logLik(model.lm.wc))
X0 # 'log Lik.' -100852.6 (df=2)
pchisq(X0, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)

X1 <- 2 * (logLik(model.nb.wc) - logLik(model.pois.wc))
X1
# 'log Lik.' 104529.3 (df=3)
pchisq(X1, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.

# What fits better, log of x values or striaght up?
Y <- 2 * (logLik(model.nb.logwc) - logLik(model.nb.wc))
Y
pchisq(Y, df=0, lower.tail=FALSE)
# Log of data does! 13.97 Y p value 0

# What performs better, linear model or nb model with log transform?
test = 2*(logLik(model.nb.logwc) - logLik(lm(num_tweets ~ log(wc), data = stories)))
test
pchisq(test, df=0, lower.tail=FALSE)

######## Emotionality ###########

### Model as Linear-- baseline ###
model.lm.emot <- lm(num_tweets ~ emotionality, stories)
summary(model.lm.emot)

### Model as Poisson ###
model.pois.emot = glm(num_tweets ~ emotionality, data=stories, family=poisson)
summary(model.pois.emot)

### Model as Negative Binomial ###
model.nb.emot = glm.nb(num_tweets ~ emotionality, data=stories)
summary(model.nb.emot)

# goodness of fit
1 - pchisq(summary(model.nb.emot)$deviance,
           summary(model.nb.emot)$df.residual
)

### What model fits better? ###
X2 <- 2 * (logLik(model.nb.emot) - logLik(model.lm.emot))
X2
pchisq(X2, df = 0, lower.tail=FALSE)

X3 <- 2 * (logLik(model.nb.emot) - logLik(model.pois.emot))
X3
# 'log Lik.' 104803.9 (df=3)
pchisq(X3, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.



######## Positivity ###########
### Model as Linear-- baseline ###
model.lm.pos <- lm(num_tweets ~ positivity, stories)
summary(model.lm.pos)

### Model as Poisson ###
model.pois.pos = glm(num_tweets ~ positivity, data=stories, family=poisson)
summary(model.pois.pos)

### Model as Negative Binomial ###
model.nb.pos = glm.nb(num_tweets ~ positivity, data=stories)
summary(model.nb.pos)

# goodness of fit
1 - pchisq(summary(model.nb.pos)$deviance,
           summary(model.nb.pos)$df.residual
)

### What model fits better? ###
X4 <- 2 * (logLik(model.nb.pos) - logLik(model.lm.pos))
pchisq(X4, df = 0, lower.tail=FALSE)

X5 <- 2 * (logLik(model.nb.pos) - logLik(model.pois.pos))
# 'log Lik.' 104946 (df=3)
pchisq(X5, df = 0, lower.tail=FALSE)
# 'log Lik.' 0 (df=3)
# This very large chi-square strongly suggests the negative binomial model,
# which estimates the dispersion parameter, is more appropriate than the Poisson model.


