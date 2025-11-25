#!/usr/bin/env bash
# ------------------------------------------------------------
# 08_mapping_bowtie2.sh
#
# PURPOSE:
#   Map cleaned reads to the Cucumber mosaic virus (CMV)
#   reference genome using Bowtie2 and produce a sorted,
#   indexed BAM file for downstream QC and variant calling.
#
# ASSUMPTIONS IN THIS REPO:
#   - Cleaned reads are in:  results/qc/quality/
#   - Reference genome is in: resources/CMV_ref.fasta
#   - Output BAMs go to:     results/mapping/
# ------------------------------------------------------------

set -euo pipefail

# Paths
READ_DIR="results/qc/quality"
REF_FA="resources/CMV_ref.fasta"
OUT_DIR="results/mapping"
mkdir -p "$OUT_DIR"

# Input reads
READ1="$READ_DIR/infected_clean_R1.fastq.gz"
READ2="$READ_DIR/infected_clean_R2.fastq.gz"

# Bowtie2 index prefix (will create several index files with this prefix)
BT2_INDEX="$OUT_DIR/CMV_ref"

# Output files
SAM_OUT="$OUT_DIR/IP_CMV_ref_bowtie2_local.sam"
BAM_OUT="$OUT_DIR/IP_CMV_ref_bowtie2_local.bam"
SORTED_BAM="$OUT_DIR/IP_CMV_ref_bowtie2_local.sorted.bam"

# ------------------------------------------------------------
# 1) Build Bowtie2 index
# ------------------------------------------------------------
echo "Building Bowtie2 index for reference: $REF_FA"
bowtie2-build "$REF_FA" "$BT2_INDEX"

# ------------------------------------------------------------
# 2) Map cleaned reads to reference (local alignment)
# ------------------------------------------------------------
echo "Mapping cleaned reads to CMV reference with Bowtie2 (local mode)..."
bowtie2 \
  -p 4 \
  --local \
  -x "$BT2_INDEX" \
  -1 "$READ1" \
  -2 "$READ2" \
  -S "$SAM_OUT"

# ------------------------------------------------------------
# 3) Convert SAM → BAM, sort, and index
# ------------------------------------------------------------
echo "Converting SAM to BAM and sorting..."
samtools view -@ 4 -bS "$SAM_OUT" > "$BAM_OUT"
samtools sort -@ 4 "$BAM_OUT" -o "$SORTED_BAM"
samtools index "$SORTED_BAM"

# Cleanup intermediate files
rm "$SAM_OUT" "$BAM_OUT"

echo "Mapping finished."
echo "Sorted, indexed BAM: $SORTED_BAM"
echo "You can now run Qualimap bamqc and Picard MarkDuplicates on this file."
