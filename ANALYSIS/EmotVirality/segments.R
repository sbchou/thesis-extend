### Examine Segments
library(lme4)
library(lmerTest)
library(MASS)
library(AER)
library(VGAM)
require(ggplot2)
library(GGally)

stories <- read.table('../DATA/FOR_CORR/all_segments_no_title.csv', header=TRUE, sep = ",")
# remove NaN for some reason the python code breaks the CSV
stories <- stories[complete.cases(stories),]

### DON'T FORGET TO CONVERT TO FACTORS!###
stories$num_tweets = as.numeric((stories$num_tweets))
stories$wc = as.numeric((stories$wc))
stories$emotionality = as.numeric((stories$emotionality))
stories$positivity = as.numeric((stories$positivity)) 

### DON'T FORGET TO CONVERT TO FACTORS!###
stories$num_tweets = as.numeric((stories$num_tweets))
stories$wc = as.numeric((stories$wc))
stories$emotionality = as.numeric((stories$emotionality))
stories$positivity = as.numeric((stories$positivity)) 
stories$candid_camp = factor((stories$candid_camp))


### num_tweets vs. Candid Camp? ###
m = lm(num_tweets ~ candid_camp, data=stories)
summary(m)


### Visualizing Data by Segment ###

# Box plot: Positivity by Segment -- makes no sense. we are base on story... 
ggplot(data=stories, aes(candid_camp,num_tweets)) +  
  geom_boxplot() 
# nothing difference

ggplot(data=stories, aes(candid_camp, positivity)) +  
  geom_boxplot() 

# boxplot with real data points overlaid and horizontally jittered
p <- ggplot(stories, aes(candid_camp, positivity))
p1 <- p + geom_boxplot(outlier.shape = 3)
p1
p1 + geom_point(alpha=0.25, position = position_jitter(width = 0.5))


# Violin plot: Positivity by Segment
# positivity doesn't seem to vary much
ggplot(stories, aes(candid_name, positivity)) +
  geom_violin() +
  #geom_jitter(size=1.5) +
  scale_y_log10() +
  stat_smooth(aes(x = candid_name, y = positivity, group=1), method="loess")

ggplot(data=stories, aes(candid_name, positivity)) +  
  geom_boxplot() +
  geom_jitter(alpha=.25)


 
ggscatmat(stories, columns = 2:4, color="candid_name", alpha=0.8)
ggcorr(stories)


p2 <- p + geom_boxplot(outlier.colour = NA)
p2 + geom_point(position = position_jitter(width = 0.2))

ggplot(stories, aes(candid_name, num_tweets)) + geom_boxplot()

ggplot(data=stories, aes(candid_name, emotionality)) + geom_boxplot()

ggplot(data=stories, aes(candid_name, positivity)) +  
  geom_boxplot() +
  geom_jitter(alpha=.25)


## some plots
ggplot(data=stories, aes(candid_name, num_tweets)) +
  geom_boxplot()  
#+
#  geom_jitter(alpha=.25)



