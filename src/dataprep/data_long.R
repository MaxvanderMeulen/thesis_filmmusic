
library(reshape2)
library(dplyr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(data.table)

regular_join <- fread("../../gen/dataprep/data/regular_join.csv")
dta_m_class <- fread("../../gen/dataprep/data/dta_m_class.csv")

# make long format
regular_join$releasedate_episode <- as.character(regular_join$releasedate_episode) 
data_long <- melt(regular_join, id.vars = c("rowid", "track_id", "name", "artist_names", "track_genre", "releasedate_episode", "speechiness","liveness","instrumentalness","nplaylists", "spotify_popularity", "duration_seconds_join", "order"), measure.vars = c("X2016.01.04", "X2016.01.11", "X2016.01.18", "X2016.01.25", "X2016.02.01", "X2016.02.08", "X2016.02.15", "X2016.02.22", "X2016.02.29", "X2016.03.07", "X2016.03.14", "X2016.03.21", "X2016.03.28", "X2016.04.04", "X2016.04.11", "X2016.04.18", "X2016.04.25", "X2016.05.02", "X2016.05.09", "X2016.05.16", "X2016.05.23", "X2016.05.30", "X2016.06.06", "X2016.06.13", "X2016.06.20", "X2016.06.27", "X2016.07.04", "X2016.07.11", "X2016.07.18", "X2016.07.25", "X2016.08.01", "X2016.08.08", "X2016.08.15", "X2016.08.22", "X2016.08.29", "X2016.09.05", "X2016.09.12", "X2016.09.19", "X2016.09.26", "X2016.10.03", "X2016.10.10", "X2016.10.17", "X2016.10.24","X2016.10.31", "X2016.11.07", "X2016.11.14", "X2016.11.21", "X2016.11.28", "X2016.12.05", "X2016.12.12", "X2016.12.19", "X2016.12.26", "X2017.01.02", "X2017.01.09", "X2017.01.16", "X2017.01.23", "X2017.01.30", "X2017.02.06", "X2017.02.13", "X2017.02.20", "X2017.02.27", "X2017.03.06", "X2017.03.13", "X2017.03.20", "X2017.03.27", "X2017.04.03", "X2017.04.10", "X2017.04.17", "X2017.04.24", "X2017.05.01", "X2017.05.08", "X2017.05.15", "X2017.05.22", "X2017.05.29", "X2017.06.05", "X2017.06.12", "X2017.06.19", "X2017.06.26", "X2017.07.03", "X2017.07.10", "X2017.07.17", "X2017.07.24", "X2017.07.31", "X2017.08.07", "X2017.08.14", "X2017.08.21", "X2017.08.28", "X2017.09.04", "X2017.09.11", "X2017.09.18", "X2017.09.25", "X2017.10.02", "X2017.10.09", "X2017.10.16", "X2017.10.23", "X2017.10.30", "X2017.11.06", "X2017.11.13", "X2017.11.20", "X2017.11.27", "X2017.12.04", "X2017.12.11", "X2017.12.18", "X2017.12.25", "X2018.01.01", "X2018.01.08", "X2018.01.15", "X2018.01.22", "X2018.01.29", "X2018.02.05", "X2018.02.12", "X2018.02.19", "X2018.02.26", "X2018.03.05", "X2018.03.12", "X2018.03.19", "X2018.03.26", "X2018.04.02", "X2018.04.09", "X2018.04.16", "X2018.04.23", "X2018.04.30", "X2018.05.07", "X2018.05.14", "X2018.05.21", "X2018.05.28", "X2018.06.04", "X2018.06.11", "X2018.06.18", "X2018.06.25", "X2018.07.02", "X2018.07.09", "X2018.07.16", "X2018.07.23", "X2018.07.30", "X2018.08.06", "X2018.08.13", "X2018.08.20", "X2018.08.27", "X2018.09.03", "X2018.09.10", "X2018.09.17", "X2018.09.24", "X2018.10.01", "X2018.10.08", "X2018.10.15", "X2018.10.22", "X2018.10.29", "X2018.11.05", "X2018.11.12", "X2018.11.19", "X2018.11.26", "X2018.12.03", "X2018.12.10", "X2018.12.17", "X2018.12.24", "X2018.12.31", "X2019.01.07", "X2019.01.14", "X2019.01.21", "X2019.01.28", "X2019.02.04", "X2019.02.11", "X2019.02.18", "X2019.02.25", "X2019.03.04", "X2019.03.11", "X2019.03.18", "X2019.03.25", "X2019.04.01", "X2019.04.08", "X2019.04.15", "X2019.04.22", "X2019.04.29","X2019.05.06", "X2019.05.13", "X2019.05.20", "X2019.05.27","X2019.06.03", "X2019.06.10", "X2019.06.17", "X2019.06.24", "X2019.07.01", "X2019.07.08", "X2019.07.15", "X2019.07.22", "X2019.07.29", "X2019.08.05", "X2019.08.12", "X2019.08.19", "X2019.08.26", "X2019.09.02", "X2019.09.09", "X2019.09.16", "X2019.09.23", "X2019.09.30","X2019.10.07", "X2019.10.14", "X2019.10.21", "X2019.10.28",  "X2019.11.04", "X2019.11.11", "X2019.11.18", "X2019.11.25", "X2019.12.02", "X2019.12.09", "X2019.12.16", "X2019.12.23", "X2019.12.30", "X2020.01.06", "X2020.01.13", "X2020.01.20", "X2020.01.27", "X2020.02.03", "X2020.02.10", "X2020.02.17","X2020.02.24","X2020.03.02", "X2020.03.09", "X2020.03.16", "X2020.03.23", "X2020.03.30", "X2020.04.06", "X2020.04.13"), variable.name = "date", na.rm = FALSE)

gc()

#drop observations that did not make the selection
analysis_join <- left_join(data_long, dta_m_class, by = "rowid") %>% 
  drop_na(subclass)

data_long <- analysis_join

#transform data_long
names(data_long)[names(data_long) == "variable"] <- "date"
data_long <- data_long %>%
  relocate(date, .before = releasedate_episode)

data_long$date <- gsub("X", "", data_long$date)
data_long$date <- as.Date.character(data_long$date, format = "%Y.%m.%d")
data_long$releasedate_episode <- as.Date(data_long$releasedate_episode)

# treatment and post treatment
data_long$treatment <- ifelse(is.na(data_long$releasedate_episode), 0, 1)
data_long$treatment[is.na(data_long$treatment)] <- 0

# mirror subclass
data_long <- data_long %>%
  group_by(subclass) %>%
  fill(releasedate_episode)

#post treatment
data_long$post_treatment <- ifelse(data_long$releasedate_episode<=data_long$date, 1, 0)
data_long$post_treatment[is.na(data_long$post_treatment)] <- 0

# pre treatment
data_long$pre_treatment <- ifelse(data_long$releasedate_episode>=data_long$date, 1, 0)
data_long$pre_treatment[is.na(data_long$pre_treatment)] <- 0

#NA to zero dependent variable
data_long$value[is.na(data_long$value)] <- 0

#weeks since treatment
data_long <- data_long %>% 
  group_by(track_id, post_treatment) %>% 
  mutate(weeks_since_treatment = row_number() - 1)

data_long$weeks_since_treatment <- ifelse(data_long$post_treatment == 0, NA, data_long$weeks_since_treatment)

data_long <- data_long %>%
  group_by(subclass) %>%
  fill(weeks_since_treatment)

data_long$weeks_since_treatment <- as.numeric(data_long$weeks_since_treatment)

#weeks before treatment
data_long <- data_long %>% 
  group_by(track_id, post_treatment) %>% 
  mutate(weeks_before_treatment = rev(row_number() * -1))

data_long$weeks_before_treatment <- ifelse(data_long$post_treatment == 1, NA, data_long$weeks_before_treatment)

data_long$weeks_before_treatment <- as.numeric(data_long$weeks_before_treatment)

#filter
data_long <- data_long %>% 
  group_by(track_id) %>% 
  filter(length(na.exclude(weeks_before_treatment)) > 10) %>% 
  filter(length(na.exclude(weeks_since_treatment)) > 10)

#combine
data_long$relative_treatment <- paste(data_long$weeks_before_treatment, data_long$weeks_since_treatment)
data_long$relative_treatment <- gsub("NA", "", data_long$relative_treatment)
data_long$relative_treatment <- as.numeric(data_long$relative_treatment)

#remove duplicates
data_long <- data_long[!duplicated(data_long[c('name', 'artist_names', 'date')]),]

fwrite(data_long, "../../gen/dataprep/data/data_long.csv")
