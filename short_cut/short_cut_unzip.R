install.packages("data.table", repos= 'https://mirror.lyrahosting.com/CRAN/')
library(data.table)

# unzip data
data_long_small <- fread(cmd = 'unzip -p ../../short_cut/data.zip data_long_50w.csv')
data_long <- fread(cmd = 'unzip -p ../../short_cut/data.zip data_long_200w.csv')

dir.create('../../gen')
dir.create('../../gen/short_cut')
dir.create('../../gen/short_cut/data')
fwrite(tunefind, "../../gen/short_cut/data/data_long_50w.csv")
fwrite(tracks_playlists, "/gen/short_cut/data/data_long_200w.csv")