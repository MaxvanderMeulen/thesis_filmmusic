all: ../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv ../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/filtered_playlists.csv

../../data/Archive.zip : unzip_download.R
	R --vanilla < download_data.R

../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/filtered_playlists.csv: ../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv filtering.R
	R --vanilla < filtering.R
