library(data.table)
library(dplyr)
library(ggplot2)

data_long <- fread("../../gen/dataprep/data/data_long.csv")

#create dummy for terms
data_long$short_term <- ifelse(data_long$relative_treatment > -1 & data_long$relative_treatment < 5, 1, 0)
data_long$middle_term <- ifelse(data_long$relative_treatment > 4 & data_long$relative_treatment < 26, 1, 0)
data_long$long_term <- ifelse(data_long$relative_treatment > 25, 1, 0)

#mean standardize
data_long$duration_seconds_join_standard <- (data_long$duration_seconds_join - mean(data_long$duration_seconds_join, na.rm=TRUE)) / sd(data_long$duration_seconds_join, na.rm=TRUE)
data_long$order_standard <- (data_long$order - mean(data_long$order, na.rm=TRUE)) / sd(data_long$order, na.rm=TRUE)
#make control group zero
data_long$duration_seconds_join_standard[is.na(data_long$duration_seconds_join_standard)] <- 0
data_long$order_standard[is.na(data_long$order_standard)] <- 0

#add constant value for log
data_long$value <- data_long$value + 1
data_long$value_log <- log(data_long$value)

#remove noise
data_long_small <- data_long %>% 
  filter(relative_treatment < 51, relative_treatment > -51) 

#parallel trends
data_long_small = mutate(data_long_small, treatment_group = ifelse(treatment == 1, "treated", "control"))

parallel_trends <- data_long_small %>%
  group_by(treatment_group, relative_treatment) %>%
  summarise(y = mean(value))

pdf("../../gen/analysis/output/parallel_trends.pdf") 
ggplot(parallel_trends, aes(y=y,x=relative_treatment, color= treatment_group)) +
  geom_line() + xlim(-50, 50) + ylim(0, 50) + geom_vline(xintercept = 0, linetype=3) +
  xlab("Relative treatment time in weeks") + ylab("Mean number of playlists") + theme_bw() + ggtitle("Parallel trends assumption")
dev.off()

#evidence pre post
data_long = mutate(data_long, post_group = ifelse(post_treatment == 1, "post_treatment", "pre_treatment"))

pre_post <- data_long %>%
  filter(treatment == 1) %>%
  group_by(post_group, relative_treatment) %>%
  summarise(y = mean(value))

pdf("../../gen/analysis/output/pre_post.pdf") 
ggplot(pre_post, aes(y=y,x=relative_treatment, color= post_group)) +
  geom_line() + xlim(-50, 50) + ylim(0,50) + geom_vline(xintercept = 0, linetype=3) +
  xlab("Relative treatment time") + ylab("Mean number of playlists") + theme_bw() + ggtitle("Evidence for pre and post treatment")
dev.off()

fwrite(data_long_small, "../../gen/dataprep/data/data_long_small.csv")
