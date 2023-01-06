library(data.table)
library(dplyr)
library(ggplot2)
library(fixest)

dir.create('../../gen/short_cut')
dir.create('../../gen/short_cut/output')
data_long_small <- fread("../../gen/short_cut/data/data_long_50w.csv")

#parallel trends
data_long_small = mutate(data_long_small, treatment_group = ifelse(treatment == 1, "treated", "control"))

parallel_trends <- data_long_small %>%
  group_by(treatment_group, relative_treatment) %>%
  summarise(y = mean(value))

pdf("../../gen/short_cut/output/parallel_trends.pdf") 
ggplot(parallel_trends, aes(y=y,x=relative_treatment, color= treatment_group)) +
  geom_line() + xlim(-50, 50) + ylim(0, 50) + geom_vline(xintercept = 0, linetype=3) +
  xlab("Relative treatment time in weeks") + ylab("Mean number of playlists") + theme_bw() + ggtitle("Parallel trends assumption")
dev.off()

#evidence pre post
data_long = mutate(data_long_small, post_group = ifelse(post_treatment == 1, "post_treatment", "pre_treatment"))

pre_post <- data_long_small %>%
  filter(treatment == 1) %>%
  group_by(post_group, relative_treatment) %>%
  summarise(y = mean(value))

pdf("../../gen/short_cut/output/pre_post.pdf") 
ggplot(pre_post, aes(y=y,x=relative_treatment, color= post_group)) +
  geom_line() + xlim(-50, 50) + ylim(0,50) + geom_vline(xintercept = 0, linetype=3) +
  xlab("Relative treatment time") + ylab("Mean number of playlists") + theme_bw() + ggtitle("Evidence for pre and post treatment")
dev.off()

#simple regression
sink("../../gen/short_cut/output/model_simple.txt")
model_simple <- feols(log(value) ~ post_treatment + treatment:post_treatment | date + track_id,
                      data = data_long_small, cluster = ~track_id)
summary(model_simple)
sink()

#regression with terms
sink("../../gen/short_cut/output/model_trends.txt")
model_simple_terms <- feols(log(value) ~ post_treatment + treatment:post_treatment:short_term + treatment:post_treatment:middle_term + treatment:post_treatment:long_term| date + track_id, data = data_long_small, cluster = ~track_id)
summary(model_simple_terms)
sink()

#moderation
sink("../../gen/short_cut/output/model_mod.txt")
model_moderation <- feols(value ~ treatment:post_treatment + treatment:post_treatment:order_standard + treatment:post_treatment:duration_seconds_join_standard | date + track_id, data = data_long_small, cluster = ~track_id)
summary(model_moderation)
sink()
