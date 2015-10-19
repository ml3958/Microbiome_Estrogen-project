
########### This stores the qiime work flow of estrogen project
######## 

##filter samples with low seuencing quality
filter_samples_from_otu_table.py -i otu_table_rdp_nochimera_m0001.biom -o otu_table_rdp_nochimera_m0001_filter_lowquality.biom -m ../metadata_mapping_files/10062015.txt -s 'SampleID:*,!19.1,!28.2' 

## calculate beta-diversity and plot with PcoA to identify outliers
beta_diversity_through_plots.py -i otu_table_10162015_23PairedSubjects.biom -o ../diversity/beta_div/new/ -t rep_set.tre -m ../metadata_mapping_files/10152015_shannon.txt -e 100
