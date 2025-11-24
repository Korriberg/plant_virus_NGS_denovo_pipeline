# plant_virus_NGS_denovo_pipeline
A reproducible NGS workflow for identifying plant viruses using de novo assembly and reference-guided mapping. Includes QC, trimming, assembly, BLAST identification, variant calling, and annotation.

This pipeline is adapted from an NGS analysis project completed during my MSc at TUM. 
The original report is not included here, but the full workflow has been rewritten as a standalone, reproducible pipeline.

# Data
The original FASTQ files used for this analysis come from a university course and cannot be redistributed here.

To reproduce the pipeline, you can substitute any paired-end plant virus NGS dataset from SRA.
Example datasets (paired-end):

- Arabidopsis + CMV infection (RNA-seq): SRR*******  
- General plant virus WGS/RNA-seq datasets: search terms "plant virus RNA-seq paired end".

Place downloaded FASTQ files in:
`data/raw/`
and update file names in the scripts accordingly.
