library(dplyr)
library(tidyr)
library(tidyverse)
library(data.table)

filtered_tunefind <- fread("../../gen/dataprep/data/filtered_tunefind.csv")
filtered_playlist <- fread("../../gen/dataprep/data/filtered_playlist.csv")

#select all the treated songs
inner_join <- 
  inner_join(filtered_tunefind, filtered_playlist, by = c("song_title" = "name", "song_artist" = "artist_names"), keep = TRUE) %>%
  distinct(song_title, song_artist, .keep_all = TRUE)

#all treated songs with moderating variables
inner_join_sample <- inner_join %>%
  filter(!is.na(order)) %>% 
  filter(!is.na(duration_seconds_join))

#lower sample size, otherwise unable to join/match/transform
filtered_playlist_sample <- sample_n(filtered_playlist, 400000) 

#join datasets
regular_join <-
  full_join(inner_join_sample, filtered_playlist_sample) %>%
  unique() %>%
  rowid_to_column()

# activate treatment
regular_join$treatment <- ifelse(is.na(regular_join$releasedate_episode), 0, 1)
#make popularity zero
regular_join$spotify_popularity <- ifelse(is.na(regular_join$spotify_popularity), 0, regular_join$spotify_popularity)

#clean memory
file.remove("../../gen/dataprep/data/filtered_tunefind.csv")
file.remove("../../gen/dataprep/data/filtered_playlist.csv")
gc()

fwrite(regular_join, "../../gen/dataprep/data/regular_join.csv")



