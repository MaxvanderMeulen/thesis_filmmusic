../../gen/dataprep/data/tunefind.csv: unzip_download.R ../../data/Archive.zip
	R --vanilla < unzip_download.R

../../gen/dataprep/data/filtered_tunefind.csv: 	filtering.R ../../gen/dataprep/data/tunefind.csv
	R --vanilla < filtering.R

