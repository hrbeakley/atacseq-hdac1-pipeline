# Final Project

This project uses publicly available ATAC-seq and RNA-seq data from Fernandes et al. (2024), who examined the effects of HDAC1 loss on chromatin accessibility and transcriptional programs in different types of mouse dendritic cells.


### Description of how to run the pipeline:

1. Navigate to the project directory and activate a Nextflow environment.

2. Run the initial Nextflow pipeline to perform read processing, alignment, peak calling, and QC: nextflow run main.nf -profile cluster,singularity,conda

3. After the pipeline completes, run all cells in diffbind.Rmd to perform differential accessibility analysis.

4. Uncomment the downstream workflow steps in main.nf (for annotation, motif analysis, and visualization), then resume the pipeline: nextflow run main.nf -profile cluster,singularity,conda -resume

5. Run all cells in deseq.Rmd to perform differential expression analysis on RNA-seq data and generate RNA–ATAC concordance plots.


### Citation:

De Sá Fernandes, C., Novoszel, P., Gastaldi, T., Krauß, D., Lang, M., Rica, R., … Sibilia, M. (2024). The histone deacetylase HDAC1 controls dendritic cell development and anti-tumor immunity. Cell Reports, 43, 114308. https://doi.org/10.1016/j.celrep.2024.114308

