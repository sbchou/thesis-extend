library(lme4)
library(lmerTest)

stories <- read.table('../DATA/FOR_CORR/all_fields_no_title.csv', header=TRUE, sep = ",", quote = "'")
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
# Multiple R-squared:  0.003182,	Adjusted R-squared:  0.002805 

######### Word Count ###############
## log(WC) and Num Tweets 
stories$log_wc = as.numeric((log(stories$wc)))
log_wc_corr <- lm(num_tweets ~ log_wc, stories)
summary(log_wc_corr)

## sqrt(WC) and Num Tweets 
stories$sqrt_wc = as.numeric((sqrt(stories$wc)))
sqrt_wc_corr <- lm(num_tweets ~ sqrt_wc, stories)
summary(sqrt_wc_corr)

## log(WC) and log(Num Tweets)
stories$log_num_tweets = as.numeric((log(stories$num_tweets)))
loglog_wc_corr <- lm(log_num_tweets ~ log_wc, stories)
summary(loglog_wc_corr)

plot(x = stories$log_wc, y=stories$log_num_tweets)

######### Emotionality ###############
## Plain
emot_corr <- lm(num_tweets ~ emotionality, stories)
summary(emot_corr)

## log(emot) and Num Tweets 
stories$log_emot = as.numeric((log(stories$emotionality + 1)))
log_emot_corr <- lm(num_tweets ~ log_emot, stories)
summary(log_emot_corr)

## sqrt(emot) and Num Tweets 
stories$sqrt_emot = as.numeric((sqrt(stories$emotionality)))
sqrt_emot_corr <- lm(num_tweets ~ sqrt_emot, stories)
summary(sqrt_emot_corr)

## log(emot) and log(Num Tweets) 
loglog_emot_corr <- lm(log_emot ~ log_wc, stories)
summary(loglog_emot_corr)

plot(x = stories$log_wc, y=stories$num_tweets)


######### Positivity ###############
## Plain
pos_corr <- lm(num_tweets ~ positivity, stories)
summary(pos_corr)

## log(pos) and Num Tweets 
stories$log_pos = as.numeric((log(stories$positivity+1)))
log_pos_corr <- lm(num_tweets ~ log_pos, stories)
summary(log_pos_corr)

## sqrt(emot) and Num Tweets 
stories$sqrt_emot = as.numeric((sqrt(stories$emotionality)))
sqrt_emot_corr <- lm(num_tweets ~ sqrt_emot, stories)
summary(sqrt_emot_corr)

## log(emot) and log(Num Tweets) 
loglog_emot_corr <- lm(log_emot ~ log_wc, stories)
summary(loglog_emot_corr)

plot(x = stories$log_wc, y=stories$num_tweets)


 