## 9.17

#Rarefy your data
single_rarefraction.py

#Summarize taxa
summarize_taxa_through_plots.py -i otu_table_rdp_nochimera_m0001.biom  -o ./sum/

#find OUTS which are significantly differently abundant between treatments.

## 9.20
##calculate a diversity
#non phyologenetic
alpha_diversity.py -i otu_table_rdp_nochimera_m0001.biom -m chao1 -o adiv_chao1.txt

#phyologenetic
alpha_diversity.py -i otu_table_rdp_nochimera_m0001.biom -m PD_whole_tree -o adiv_pd.txt -t rep_set.tre

## 9.24
#Generate rarefied OTU tables; compute alpha diversity metrics for each rarefied OTU table; collate alpha diversity results; and generate alpha rarefaction plots.
