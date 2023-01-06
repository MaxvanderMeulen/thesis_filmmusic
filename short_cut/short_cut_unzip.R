# install packages
install.packages("fixest", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("dplyr", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("tidyr", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("tidyverse", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("ggplot2", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("data.table", repos= 'https://mirror.lyrahosting.com/CRAN/')
install.packages("readr", repos= 'https://mirror.lyrahosting.com/CRAN/')
library(data.table)

# unzip data
data_long_small <- fread(cmd = 'unzip -p ../data/data.zip data_long_50w.csv')
data_long <- fread(cmd = 'unzip -p ../data/data.zip data_long_200w.csv')

dir.create('../../gen')
dir.create('../../gen/short_cut')
dir.create('../../gen/short_cut/data')
fwrite(data_long_small, "../../gen/short_cut/data/data_long_50w.csv")
fwrite(data_long, "/gen/short_cut/data/data_long_200w.csv")