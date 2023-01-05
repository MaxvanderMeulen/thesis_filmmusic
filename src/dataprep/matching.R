library(data.table)
library(MatchIt)
library(dplyr)
library(tidyr)
library(tidyverse)

regular_join <- fread("../../gen/dataprep/data/regular_join.csv")

match_join <- regular_join %>% 
  select(rowid, treatment, danceability, speechiness, valence, loudness, liveness, energy, acousticness, instrumentalness, tempo, nplaylists, spotify_popularity, X2016.01.04, X2016.02.08, X2016.03.07)

match_join_nomiss <- match_join %>%
  drop_na(rowid, treatment, danceability, speechiness, valence, loudness, liveness, energy, acousticness, instrumentalness, tempo, nplaylists, spotify_popularity)


# propensity score model
m_ps <-
  glm(treatment ~ speechiness + liveness + instrumentalness + nplaylists + spotify_popularity, family = binomial(), data = match_join_nomiss)
summary(m_ps)

mod_match <- matchit(treatment ~ speechiness + liveness + instrumentalness + nplaylists + spotify_popularity, method = "nearest", verbose = TRUE, data = match_join_nomiss)
summary(mod_match)
dta_m <- match.data(mod_match)

# psm with class
dta_m_class <- dta_m %>% 
  select(rowid, subclass, distance)

gc()
fwrite(dta_m_class, "../../gen/dataprep/data/dta_m_class.csv")
