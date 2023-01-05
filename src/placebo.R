#placebo effect
data_long_lagged <- data_long_small %>% 
  mutate(releasedate_episode_lag = ymd(releasedate_episode) - weeks(25)) #change number of weeks

#REMOVE COLUMNS
data_long_lagged <- data_long_lagged %>% 
  ungroup() %>% 
  select(-treatment, -post_treatment, -weeks_since_treatment, -weeks_before_treatment, -relative_treatment)

# treatment and post treatment
data_long_lagged$treatment <- ifelse(is.na(data_long_lagged$releasedate_episode_lag), 0, 1)
data_long_lagged$treatment[is.na(data_long_lagged$treatment)] <- 0

#data_long_lagged <- data_long_lagged %>%
#group_by(subclass) %>%
#fill(releasedate_episode_lag)

data_long_lagged$post_treatment <- ifelse(data_long_lagged$releasedate_episode_lag<=data_long_lagged$date, 1, 0)
data_long_lagged$post_treatment[is.na(data_long_lagged$post_treatment)] <- 0

data_long_lagged$pre_treatment <- ifelse(data_long_lagged$releasedate_episode_lag>=data_long_lagged$date, 1, 0)
data_long_lagged$pre_treatment[is.na(data_long_lagged$pre_treatment)] <- 0

#data_long_lagged$value[is.na(data_long_lagged$value)] <- 0

#weeks since treatment
data_long_lagged <- data_long_lagged %>% 
  group_by(track_id, post_treatment) %>% 
  mutate(weeks_since_treatment = row_number() - 1)

data_long_lagged$weeks_since_treatment <- ifelse(data_long_lagged$post_treatment == 0, NA, data_long_lagged$weeks_since_treatment)

data_long_lagged <- data_long_lagged %>%
  group_by(subclass) %>%
  fill(weeks_since_treatment)

data_long_lagged$weeks_since_treatment <- as.numeric(data_long_lagged$weeks_since_treatment)

#weeks before treatment
data_long_lagged <- data_long_lagged %>% 
  group_by(track_id, post_treatment) %>% 
  mutate(weeks_before_treatment = rev(row_number() * -1))

data_long_lagged$weeks_before_treatment <- ifelse(data_long_lagged$post_treatment == 1, NA, data_long_lagged$weeks_before_treatment)

data_long_lagged$weeks_before_treatment <- as.numeric(data_long_lagged$weeks_before_treatment)

#combine
data_long_lagged$relative_treatment <- paste(data_long_lagged$weeks_before_treatment, data_long_lagged$weeks_since_treatment)
data_long_lagged$relative_treatment <- gsub("NA", "", data_long_lagged$relative_treatment)
data_long_lagged$relative_treatment <- as.numeric(data_long_lagged$relative_treatment)


#remove duplicates
data_long_lagged <- data_long_lagged[!duplicated(data_long_lagged[c('name', 'artist_names', 'date')]),]

#create dummy for terms
data_long_lagged$short_term <- ifelse(data_long_lagged$relative_treatment > -1 & data_long_lagged$relative_treatment < 5, 1, 0)
data_long_lagged$middle_term <- ifelse(data_long_lagged$relative_treatment > 4 & data_long_lagged$relative_treatment < 26, 1, 0)
data_long_lagged$long_term <- ifelse(data_long_lagged$relative_treatment > 25, 1, 0)

#data_long_lagged = mutate(data_long_lagged, treatment_group = ifelse(treatment == 1, "treated", "control"))
data_long_lagged$treatment <- ifelse(data_long_lagged$treatment_group == "control", 0, 1)

model_simple_placebo <- feols(log(value) ~ post_treatment + post_treatment:treatment |
                                date + track_id, data = data_long_lagged, cluster = ~track_id)
summary(model_simple_placebo)

