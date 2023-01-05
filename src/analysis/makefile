OUTPUT = ../../gen/analysis/output
DATA = ../../gen/dataprep/data

all: $(OUTPUT)/pre_post.pdf $(OUTPUT)/parallel_trends.pdf $(DATA)/data_long_small.csv $(OUTPUT)/model_simple.txt $(OUTPUT)/model_trends.txt $(OUTPUT)/model_mod.txt

$(OUTPUT)/pre_post.pdf $(OUTPUT)/parallel_trends.pdf $(DATA)/data_long_small.csv: analysis.R $(DATA)/data_long.csv
	R --vanilla < analysis.R
	
$(OUTPUT)/model_simple.txt $(OUTPUT)/model_trends.txt $(OUTPUT)/model_mod.txt: regression.R $(DATA)/data_long_small.csv
	R --vanilla < regression.R
