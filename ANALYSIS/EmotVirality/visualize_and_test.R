library(ggplot2) 
library(lme4)
library(lmerTest)

stories <- read.table('../DATA/FOR_CORR/all_fields_no_title.csv', header=TRUE, sep = ",", quote = "'")
nrow(stories)
head(stories)

stories <- stories[complete.cases(stories),]
write.csv(stories, file = "stories_all_emots.csv")
summary(stories$num_tweets)

ggplot(stories, aes(x=stories$log_emotionality, y=log(stories$num_tweets))) +
  geom_point(shape=1)      # Use hollow circles

ggplot(stories, aes(x=stories$log_emotionality, y=log(stories$num_tweets))) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm,   # Add linear regression line
              se=FALSE)    # Don't add shaded confidence region
 