# install packages
install.packages("fixest", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("reshape2", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("dplyr", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("stargazer", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("lubridate", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("tidyr", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("tidyverse", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("ggplot2", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("data.table", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("MatchIt", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("zoo", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("stargazer", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("etable", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("gridExtra", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("readr", repos= 'https://mirror.lyrahosting.com/CRAN/')


# activate packages
library(dplyr)
library(tidyr)
library(tidyverse)
library(data.table)
library(readr)

# unzip data
tunefind <- fread(cmd = 'unzip -p ../../data/Archive.zip df_tunefind.csv')
tracks_playlists <- fread(cmd = 'unzip -p ../../data/Archive.zip df_hannes.csv')


#Export to csv
dir.create('../../gen')
dir.create('../../gen/dataprep')
dir.create('../../gen/dataprep/data')
fwrite(tunefind, "../../gen/dataprep/data/tunefind.csv")
fwrite(tracks_playlists, "../../gen/dataprep/data/tracks_playlists.csv")
