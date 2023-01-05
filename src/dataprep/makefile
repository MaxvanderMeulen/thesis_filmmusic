DATA_DIR = ../../data

../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv : unzip_download.R $(DATA_DIR)/Archive.zip
	R --vanilla < unzip_download.R

../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/filtered_playlist.csv: filtering.R ../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv
	R --vanilla < filtering.R




