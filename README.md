# plant_virus_NGS_denovo_pipeline

A reproducible NGS workflow for identifying plant viruses using de novo assembly and reference-guided mapping. Includes QC, trimming, assembly, BLAST identification, variant calling, and annotation.

This pipeline is adapted from an NGS analysis project completed during my MSc at TUM.  
The original report is not included here, but the full workflow has been rewritten as a standalone, reproducible pipeline.

# Plant virus identification from NGS data (de novo + mapping pipeline)

## Biological question
Given a WGS/RNA-seq library prepared from infected plant tissue:

1. Which virus(es) are present?  
2. What sequence variants do they carry relative to reference genomes?

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

---

## Assembly parameter optimization

To obtain the best possible de novo assembly of the viral genomes, multiple SPAdes assemblies were performed using different k-mer combinations. Assembly quality was evaluated using contig statistics such as total assembly length, longest contig, and N50 (via BBTools’ `stats.sh` tool). :contentReference[oaicite:0]{index=0}

### Evaluated k-mer sets
Several k-mer configurations were tested, including:

- `25,53,73,93,111`  
- `23,53,83,123`  
- additional intermediate sets explored interactively

Each k-mer set produced its own `contigs.fasta`, which was assessed for:

- assembly continuity (fewer, longer contigs)  
- approximate genome size consistency  
- suitability for BLAST-based virus identification  
- robustness for downstream mapping and variant calling  

### Final choice: `23,53,83,123`
This k-mer set produced:

- the longest, most continuous viral contigs  
- minimal fragmentation  
- strongest BLAST support for viral identity  
- optimal mapping performance for variant calling  

### Reproducible SPAdes command
```bash
spades.py \
  -1 results/qc/quality/infected_clean_R1.fastq.gz \
  -2 results/qc/quality/infected_clean_R2.fastq.gz \
  --only-assembler \
  -t 8 \
  -k 23,53,83,123 \
  -o results/assembly/spades_k23_53_83_123
```

## Main result (original dataset)
De novo contigs and BLAST results identified **Cucumber mosaic virus (CMV)** as the causal infection.  
Mapping confirmed CMV with ~44% alignment rate, and variant calling detected **5 variants across the three viral RNA strands**.

## Reproducibility / data
The course dataset cannot be redistributed.  
To reproduce, substitute any paired-end plant virus dataset and place FASTQ files in `data/raw/`.

## Tools
FastQC, BBTools (bbduk), SPAdes, BLAST, Bowtie2, Samtools, Qualimap, Picard, Freebayes, SnpEff.
Tool versions / parameters are documented in `scripts/`.
