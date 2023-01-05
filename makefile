all: data-preparation analysis

data-preparation:
	make -C src/dataprep
        
analysis:
	make -C src/analysis
