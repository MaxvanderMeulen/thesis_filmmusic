all: ../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/regular_join.csv

../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.csv: unzip_download.R ../../data/Archive.zip
	R --vanilla < unzip_download.R

../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/filtered_playlist.csv: filtering.R ../../gen/dataprep/data/tunefind.csv ../../gen/dataprep/data/tracks_playlists.cs
	R --vanilla < filtering.R

../../gen/dataprep/data/regular_join.csv: joining.R ../../gen/dataprep/data/filtered_tunefind.csv ../../gen/dataprep/data/filtered_playlist.csv
	R --vanilla < joining.R
