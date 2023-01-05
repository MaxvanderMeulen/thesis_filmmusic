


#simple regression
model_simple <- feols(log(value) ~ post_treatment + treatment:post_treatment | date + track_id,
                      data = data_long_small, cluster = ~track_id)
summary(model_simple)

#regression with terms
model_simple_terms <- feols(log(value) ~ post_treatment + treatment:post_treatment:short_term + treatment:post_treatment:middle_term + treatment:post_treatment:long_term + spotify_popularity | date, data = data_long_small, cluster = ~track_id)
summary(model_simple_terms)

#moderation
model_moderation <- feols(value ~ treatment:post_treatment + treatment:post_treatment:order_standard + treatment:post_treatment:duration_seconds_join_standard | date + track_id, data = data_long_small, cluster = ~track_id)
summary(model_moderation)


