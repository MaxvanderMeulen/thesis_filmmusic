DATA = ../../gen/short_cut/data
OUTPUT = ../../gen/short_cut/output

all: $(OUTPUT)/pre_post.pdf $(OUTPUT)/parallel_trends.pdf $(DATA)/data_long_50w.csv $(OUTPUT)/model_simple.txt $(OUTPUT)/model_trends.txt $(OUTPUT)/model_mod.txt

$(DATA)/data_long_50w.csv $(DATA)/data_long_200w.csv: short_cut_unzip.R ../data/data.zip
	R --vanilla < short_cut_unzip.R

$(OUTPUT)/pre_post.pdf $(OUTPUT)/parallel_trends.pdf $(OUTPUT)/model_simple.txt $(OUTPUT)/model_trends.txt $(OUTPUT)/model_mod.txt: short_cut_analysis.R $(DATA)/data_long_50w.csv
	R --vanilla < short_cut_analysis.R
	
 
