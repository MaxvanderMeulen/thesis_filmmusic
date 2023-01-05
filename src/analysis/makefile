OUTPUT = ../../gen/analysis/output
DATA = ../../gen/dataprep/data

../../gen/dataprep/data/data_long.csv
$(DATA)/tunefind.csv $(DATA)/tracks_playlists.csv: unzip_download.R ../../data/Archive.zip
	R --vanilla < analysis.R
