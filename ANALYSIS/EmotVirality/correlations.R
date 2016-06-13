library(lme4)
library(lmerTest)

stories <- read.table('../DATA/EMOT/all_fields_no_title.csv', header=TRUE, sep = ",", quote = "'")
nrow(stories)
head(stories)

# remove NaN for some reason the python code breaks the CSV
stories <- stories[complete.cases(stories),]
nrow(stories)
# SHOULD BE 2651

 
# COLUMNS:
# "X"               "url"             "sentiment_mean"  "num_tweets"      "wc"             
# "negativ_ct"      "positiv_ct"      "negativ_percent" "positiv_percent" "emotionality"   
# "positivity"

## First: WC and Num Tweets
stories$num_tweets = as.numeric((stories$num_tweets))
stories$wc = as.numeric((stories$wc))
wc_corr <- lm(num_tweets ~ wc, stories)
summary(wc_corr)

#             Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 50.425959   1.818541  27.729  < 2e-16 ***
#  wc          -0.004180   0.001438  -2.907  0.00368 ** 


## Emotionality and Num Tweets 
stories$emotionality = as.numeric((stories$emotionality))
emot_corr <- lm(num_tweets ~ emotionality, stories)
summary(emot_corr)
#               Estimate Std. Error t value Pr(>|t|)    
#(Intercept)    40.349      2.685  15.027   <2e-16 ***
#  emotionality  305.229    122.427   2.493   0.0127 *  

## Positivity and Num Tweets 
stories$positivity = as.numeric((stories$positivity))
pos_corr <- lm(num_tweets ~ positivity, stories)
summary(pos_corr)

#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)   47.078      1.221  38.572   <2e-16 ***
#  positivity  -281.010    139.546  -2.014   0.0441 *  

