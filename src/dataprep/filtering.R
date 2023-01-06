library(lubridate)
library(reshape2)
library(dplyr)
library(tidyr)
library(tidyverse)
library(data.table)

#Read csv
tunefind <- fread('../../gen/dataprep/data/tunefind.csv')
tracks_playlists <- fread('../../gen/dataprep/data/tracks_playlists.csv')

#remove duplicate
unique_tunefind <- unique(tunefind [ , 1:11 ])
unique_tunefind$releasedate_episode <- dmy(unique_tunefind$releasedate_episode)

#apply duration moderation
unique_tunefind <- extract(unique_tunefind, scene_description, "featured_song_duration", "[0]:([0-9.][0-9.])", remove = F)

unique_tunefind <- extract(unique_tunefind, scene_description, "time2.1", "[0-9][0-9]:[0-9][0-9]-([0-9.][0-9.]:[0-9.][0-9.])", remove = F)   
unique_tunefind <- extract(unique_tunefind, scene_description, "time1.1", "([0-9.][0-9.]:[0-9.][0-9.])-[0-9][0-9]:[0-9][0-9]", remove = F)

unique_tunefind <- extract(unique_tunefind, scene_description, "time2.2", "[0-9]:[0-9][0-9][)]; [(]([0-9.]:[0-9.][0-9.])", remove = F)   
unique_tunefind <- extract(unique_tunefind, scene_description, "time1.2", "([0-9.]:[0-9.][0-9.])[)]; [(][0-9]:[0-9][0-9]", remove = F)

unique_tunefind <- extract(unique_tunefind, scene_description, "time2.3", "[0-9][0-9]:[0-9][0-9] - ([0-9.][0-9.]:[0-9.][0-9.])", remove = F)   
unique_tunefind <- extract(unique_tunefind, scene_description, "time1.3", "([0-9.][0-9.]:[0-9.][0-9.]) - [0-9][0-9]:[0-9][0-9]", remove = F)


unique_tunefind$diff_time1 <- difftime(strptime(unique_tunefind$time2.1, format = "%M:%S"), strptime(unique_tunefind$time1.1, format = "%M:%S"), units = "secs")
unique_tunefind$diff_time2 <- difftime(strptime(unique_tunefind$time2.2, format = "%M:%S"), strptime(unique_tunefind$time1.2, format = "%M:%S"), units = "secs")
unique_tunefind$diff_time3 <- difftime(strptime(unique_tunefind$time2.3, format = "%M:%S"), strptime(unique_tunefind$time1.3, format = "%M:%S"), units = "secs")

unique_tunefind$duration_seconds <- paste(unique_tunefind$diff_time1, unique_tunefind$diff_time2, unique_tunefind$diff_time3)
unique_tunefind$duration_seconds <- gsub("NA", "", unique_tunefind$duration_second)
unique_tunefind$duration_seconds <- as.numeric(unique_tunefind$duration_seconds)

unique_tunefind <- unique_tunefind %>% 
  select(-time1.1, -time1.2, -time1.3, -time2.1, -time2.2, -time2.3, -diff_time1, -diff_time2, -diff_time3)

unique_tunefind$duration_seconds_join <- paste(unique_tunefind$duration_seconds, unique_tunefind$featured_song_duration)
unique_tunefind$duration_seconds_join <- gsub("NA", "", unique_tunefind$duration_seconds_join)
unique_tunefind$duration_seconds_join <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", unique_tunefind$duration_seconds_join)
unique_tunefind$duration_seconds_join <- sub(" .*", "", unique_tunefind$duration_seconds_join)
unique_tunefind$duration_seconds_join <- as.numeric(unique_tunefind$duration_seconds_join)

unique_tunefind <- unique_tunefind %>% 
  select(-duration_seconds, -featured_song_duration)

#filtering tunefind
filtered_tunefind <- unique_tunefind %>%
  filter(releasedate_episode > "2016-01-01", releasedate_episode < "2020-01-01") %>%
  filter(length(order) >= 3)

filtered_tunefind %>% 
  filter(!grepl('The Voice Soundtrack', title)) %>% 
  filter(!grepl('So You Think You Can Dance Soundtrack', title)) %>% 
  filter(!grepl("America's Got Talent Soundtrack", title)) %>% 
  filter(!grepl('American Idol', title)) %>% 
  filter(!grepl('World of Dance Soundtrack', title))

#filtering playlists
filtered_playlist <- tracks_playlists %>%
  select(-cm_artist, -key, -mode, -spell)


gc()
filtered_playlist <- sample_n(filtered_playlist, 100000)

#to lower, space gone, only char (for merge)
filtered_playlist$name <- tolower(filtered_playlist$name)
filtered_playlist$artist_names <- tolower(filtered_playlist$artist_names)
filtered_tunefind$song_title <- tolower(filtered_tunefind$song_title)
filtered_tunefind$song_artist <- tolower(filtered_tunefind$song_artist)

filtered_playlist$name <- gsub("[[:punct:]]", "", filtered_playlist$name)
filtered_playlist$artist_names <- gsub("[[:punct:]]", "", filtered_playlist$artist_names)
filtered_tunefind$song_title <- gsub("[[:punct:]]", "", filtered_tunefind$song_title)
filtered_tunefind$song_artist <- gsub("[[:punct:]]", "", filtered_tunefind$song_artist)

filtered_playlist$name <- gsub(" ", "", filtered_playlist$name)
filtered_playlist$artist_names <- gsub(" ", "", filtered_playlist$artist_names)
filtered_tunefind$song_title <- gsub(" ", "", filtered_tunefind$song_title)
filtered_tunefind$song_artist <- gsub(" ", "", filtered_tunefind$song_artist)

file.remove("../../gen/dataprep/data/tunefind.csv")
file.remove("../../gen/dataprep/data/tracks_playlists.csv")
fwrite(filtered_tunefind, "../../gen/dataprep/data/filtered_tunefind.csv")
fwrite(filtered_playlist, "../../gen/dataprep/data/filtered_playlist.csv")

