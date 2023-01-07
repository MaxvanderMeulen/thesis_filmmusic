# Video Did Not Kill The Radiostar
## The effect of a song featuring in a TV series and its music popularity

The changing way in which consumers discover music, especially with the use of technology, has an impact on music popularity. In this thesis, we study the influence of a song being featured in a TV series on its music popularity. Using a unique long-format dataset in which weekly song data serves as the unit of analysis, we estimate the treatment effect with a difference in differences analysis. 

## Running instructions
### Dependencies

Make. [Installation Guide.](http://tilburgsciencehub.com/setup/make)\
R. [Installation Guide.](http://tilburgsciencehub.com/setup/r/)\
For R packages, see source code files (lines starting with `library`).

### Running the code

#### option 1: The full analysis

Copy the repository code
Open the terminal
Run: `git clone` paste repository code
Run: `cd thesis_filmmusic`
Run: `make`

##### Generated files:

Merged filtered Chartmetric & filtered Tunefind: `gen/dataprep/data/regular_join.csv`
Propensity Score Matching: `gen/dataprep/data/dta_m_class.csv`
Data long analysis: `gen/dataprep/data/data_long.csv`
Data long analysis *without noise*: `gen/dataprep/data/data_long_small.csv`

DiD model simple: `gen/analysis/output/model_simple.txt`
DiD model trends: `gen/analysis/output/model_trends.txt`
DiD model moderation: `gen/analysis/output/model_mod.txt`
Pre & Post visual: `gen/analysis/output/pre_post.pdf`
Parallel Trends visual: `gen/analysis/output/parallel_trends.pdf`









##### Generated files:

Association rules: gen/dataprep/output/rules.csv
Playlist classification: gen/data-preparation/output/playlist_clusters.csv
Silhouette score line charts: gen/data-preparation/output/figures
Label pairs (absolute): gen/data-preparation/output/label_pairs_abs.csv
Label pairs (normalized): gen/data-preparation/output/label_pairs_norm.csv








![Video-Didnt-Kill-Radio-V5-1](https://user-images.githubusercontent.com/98962990/210887465-22a32a09-0819-4d19-ab44-ccf97618ef06.png)
Photo credits: Eoin Dowdall, 2022
