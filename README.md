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


# Plant virus identification from NGS data (de novo + mapping pipeline)

## Biological question
Given a WGS/RNA-seq library prepared from infected plant tissue:
1) which virus(es) are present?  
2) what sequence variants do they carry relative to reference genomes?

## Pipeline overview
1. Raw read QC (FastQC)  
2. Adapter trimming (bbduk)  
3. Removal of PhiX / sequencing artifacts (bbduk)  
4. Quality trimming / filtering (bbduk)  
5. Clean read QC (FastQC)  
6. De novo assembly (SPAdes; k-mer optimisation)  
7. Virus identification (blastn vs virus DB)  
8. Reference-guided mapping (bowtie2)  
9. BAM processing + duplicate removal (samtools + Picard)  
10. Variant calling (freebayes)  
11. Variant filtering + annotation (vcffilter + SnpEff)

## Main result (original dataset)
De novo contigs and BLAST results identified **Cucumber mosaic virus (CMV)** as the causal infection.  
Mapping confirmed CMV with ~44% alignment rate, and variant calling detected **5 variants across the three viral RNA strands**.

## Reproducibility / data
The course dataset cannot be redistributed.  
To reproduce, substitute any paired-end plant virus dataset and place FASTQ files in `data/raw/`.

## Tools
FastQC, BBTools (bbduk), SPAdes, BLAST, Bowtie2, Samtools, Qualimap, Picard, Freebayes, SnpEff.
Tool versions / parameters are documented in `scripts/`.
