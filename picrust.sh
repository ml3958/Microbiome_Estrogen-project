
PICRUSt Analysis -----------------

###############
 ---Thomas 
###############
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
 
 ###############
 ---Menghan 
###############

normalize_table.py -i Galaxy21-\[Predict_Metagenome_on_data_20\].picrustp -a DESeq2 -o qiime/DESeq2_normalized_otu_table.biom

