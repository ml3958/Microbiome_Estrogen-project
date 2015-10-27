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
filter_samples_from_otu_table.py -i otu_table_rdp_nochimera_m0001.biom -o otu_table_rdp_nochimera_m0001_filter_lowquality_outlier.biom -m ../metadata_mapping_files/10062015.txt -s 'SampleID:*,!19.1,!28.2,!20.1,!20.2'
## compute Adiv shannon index
alpha_diversity.py -i otu_table_rdp_nochimera_m0001_filter.biom -m shannon -o ../diversity/alpha_div/adiv_shannon_pd.txt -t rep_set.tre
## add Shannon index into mapping file
add_alpha_to_mapping_file.py -i ../diversity/alpha_div/adiv_shannon_pd.txt -m ../metadata_mapping_files/10062015.txt -o 10152015_shannon.txt

# Convert to JSON before running normalize abunance (for use with qiime 1.9.1)
biom convert -i picrust/closed_otu_table.biom -o picrust/closed_otu_table_json.biom --table-type="OTU table" --to-json

-------------PICRUST

# Make directory to store results
mkdir -p picrust

# Remove new-refrence OTU's
filter_otus_from_otu_table.py -i biologics/otu_table_biologics_noabx_nodup_n0001.biom -o picrust/closed_otu_table.biom --negate_ids_to_exclude -e /macqiime/greengenes/gg_13_8_otus/rep_set/97_otus.fasta

# Convert to JSON before running normalize abunance (for use with qiime 1.9.1)
biom convert -i picrust/closed_otu_table.biom -o picrust/closed_otu_table_json.biom --table-type="OTU table" --to-json

# Run PICRUSt ----------------------
normalize_by_copy_number.py -i picrust/closed_otu_table_json.biom -o picrust/closed_otu_table_json_normalized.biom
predict_metagenomes.py -i picrust/closed_otu_table_json_normalized.biom -o picrust/metagenome_predictions.biom

# Cat by Function
mkdir -p picrust/cat_by_function
categorize_by_function.py -i picrust/metagenome_predictions.biom -c KEGG_Pathways -l 3 -o picrust/cat_by_function/predicted_metagenomes.L3.biom
categorize_by_function.py -i picrust/metagenome_predictions.biom -c KEGG_Pathways -l 2 -o picrust/cat_by_function/predicted_metagenomes.L2.biom
categorize_by_function.py -i picrust/metagenome_predictions.biom -c KEGG_Pathways -l 1 -o picrust/cat_by_function/predicted_metagenomes.L1.biom

# Analayze PICRUSt in QIIME
mkdir -p picrust/qiime
echo 'summarize_taxa:md_identifier    "KEGG_Pathways"' >> picrust/picrust_parameters.txt
echo 'summarize_taxa:absolute_abundance   True' >> picrust/picrust_parameters.txt
echo 'summarize_taxa:level    2' >> picrust/picrust_parameters.txt

normalize_table.py -i picrust/metagenome_predictions.biom -a DESeq2 -o picrust/cat_by_function/DESeq2_normalized_otu_table.biom
group_significance.py -i picrust/cat_by_function/DESeq2_normalized_otu_table.biom -m biologics/ibd_biologics_nodup_n0001_noabx_abc.txt -c s_study -s kruskal_wallis -o picrust/qiime/kw_ocs.txt


