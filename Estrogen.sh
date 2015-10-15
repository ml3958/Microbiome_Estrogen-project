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
alpha_rarefaction.py -i otu_table_rdp_nochimera_m0001.biom  -o diversity/a_rarefaction/ -t rep_set.tre  -m Barcode+Metadata.txt

#Add alpha diversity to mapping files.
# output <alpha_mapping_09242015.txt>
add_alpha_to_mapping_file.py -i adiv_pd.txt -m ~/Documents/Research/Rotation/Blaser\ lab/Estrogen/Qiime/Barcode_Metadata.txt -o alpha_mapping_09242015.txt

## 9.28
#compute new alpha diversity with new metadata file
alpha_rarefaction.py -i otu_table_rdp_nochimera_m0001.biom  -o diversity/alpha_div/a_rarefaction2_09282015/ -t rep_set.tre  -m metadata_mapping_files/Mappingfiles_Sample_EStro_Barcode_09252015.txt
#Compute beta diviersity
# 1. non phylogenetic
beta_diversity.py -i otu_table_rdp_nochimera_m0001.biom -m euclidean -o diversity/beta_div
# 2. phylogenetic
beta_diversity.py -i otu_table_rdp_nochimera_m0001.biom -m weighted_unifrac -o diversity/beta_div/weighted_unifrac_betadiv.txt -t rep_set.tre
# 3. Multiple File (batch from multiple rarefraction.py) Beta Diversity (phylogenetic)
multiple_rarefactions.py -i otu_table_rdp_nochimera_m0001.biom -m 10 -x 140 -s 10 -n 2 -o rarefied_otu_tables/
beta_diversity.py -i  rarefied_otu_tables/ -m weighted_unifrac -o -o diversity/beta_div/ -t rep_set.tre
#compute beta diversity through plot
beta_diversity_through_plots.py -i otu_table_rdp_nochimera_m0001.biom -o diversity/beta_div/bdiv_even100/ -t rep_set.tre -m metadata_mapping_files/Mappingfiles_Sample_EStro_Barcode_09252015.txt -e 100


##10.12
##filter 19.1 28.2 20.1 20.2
menghans-mbp:seq_result menghanliu$ filter_samples_from_otu_table.py -i otu_table_rdp_nochimera_m0001.biom -o otu_table_rdp_nochimera_m0001_filter.biom -m ../metadata_mapping_files/10062015.txt -s 'SampleID:*,!19.1 28.2 20.1 20.2'
## compute Adiv shannon index
alpha_diversity.py -i otu_table_rdp_nochimera_m0001_filter.biom -m shannon -o ../diversity/alpha_div/adiv_shannon_pd.txt -t rep_set.tre
## add Shannon index into mapping file
add_alpha_to_mapping_file.py -i ../diversity/alpha_div/adiv_shannon_pd.txt -m ../metadata_mapping_files/10062015.txt -o 10152015_shannon.txt
