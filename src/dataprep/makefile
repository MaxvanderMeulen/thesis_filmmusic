
DATA = ../../gen/dataprep/data


all: $(DATA)/tunefind.csv $(DATA)/filtered_tunefind.csv $(DATA)/regular_join.csv $(DATA)/dta_m_class.csv $(DATA)/data_long.csv

$(DATA)/tunefind.csv $(DATA)/tracks_playlists.csv: unzip_download.R ../../data/Archive.zip
	R --vanilla < unzip_download.R

$(DATA)/filtered_tunefind.csv $(DATA)/filtered_playlist.csv: filtering.R $(DATA)/tunefind.csv $(DATA)/tracks_playlists.csv
	R --vanilla < filtering.R

$(DATA)/regular_join.csv: joining.R $(DATA)/filtered_tunefind.csv $(DATA)/filtered_playlist.csv
	R --vanilla < joining.R
	
$(DATA)/dta_m_class.csv: matching.R $(DATA)/regular_join.csv
	R --vanilla < matching.R

$(DATA)/data_long.csv: data_long.R $(DATA)/dta_m_class.csv $(DATA)/regular_join.csv
	R --vanilla < data_long.R
