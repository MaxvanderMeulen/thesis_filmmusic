all: ../../data/Archive.zip../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv

../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv : ../../data/Archive.zip unzip_download.R
	R --vanilla < unzip_download.R


