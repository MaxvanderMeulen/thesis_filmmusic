library(fixest)
library(dplyr)
library(data.table)

data_long_small <- fread("../../gen/dataprep/data/data_long_small.csv")

#simple regression
sink("../../gen/analysis/output/model_simple.txt")
model_simple <- feols(log(value) ~ post_treatment + treatment:post_treatment | date + track_id,
                      data = data_long_small, cluster = ~track_id)
summary(model_simple)
sink()

#regression with terms
sink("../../gen/analysis/output/model_trends.txt")
model_simple_terms <- feols(log(value) ~ post_treatment + treatment:post_treatment:short_term + treatment:post_treatment:middle_term + treatment:post_treatment:long_term| date + track_id, data = data_long_small, cluster = ~track_id)
summary(model_simple_terms)
sink()

#moderation
sink("../../gen/analysis/output/model_mod.txt")
model_moderation <- feols(value ~ treatment:post_treatment + treatment:post_treatment:order_standard + treatment:post_treatment:duration_seconds_join_standard | date + track_id, data = data_long_small, cluster = ~track_id)
summary(model_moderation)
sink()


