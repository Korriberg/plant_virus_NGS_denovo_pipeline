#!/usr/bin/env bash
# ------------------------------------------------------------
# 09_bam_processing_picard.sh
#
# PURPOSE:
#   Process the mapped reads BAM file by:
#     1) marking PCR/optical duplicates (Picard MarkDuplicates)
#     2) adding / replacing read groups (Picard AddOrReplaceReadGroups)
#   The final output is a deduplicated, RG-tagged BAM ready for
#   QC (Qualimap) and variant calling (FreeBayes).
#
# ASSUMPTIONS:
#   - Input sorted BAM from mapping step (08) is:
#       results/mapping/IP_CMV_ref_bowtie2_local.sorted.bam
#   - Picard is available as `picard` on the PATH
#     (or adapt commands to `java -jar /path/to/picard.jar`).
# ------------------------------------------------------------

set -euo pipefail

MAP_DIR="results/mapping"

# Input from step 08
SORTED_BAM="$MAP_DIR/IP_CMV_ref_bowtie2_local.sorted.bam"

# Intermediate + final outputs
DEDUP_BAM="$MAP_DIR/dedup_IP_CMV_ref_bowtie2_local.bam"
METRICS_TXT="$MAP_DIR/IP_CMV_ref_bowtie2_metrics.txt"
FINAL_BAM="$MAP_DIR/dedup_IP_CMV_ref_RG.bam"

echo "Input sorted BAM: $SORTED_BAM"

# ------------------------------------------------------------
# 1) Mark duplicates
# ------------------------------------------------------------
echo "Running Picard MarkDuplicates..."

picard MarkDuplicates \
    INPUT="$SORTED_BAM" \
    OUTPUT="$DEDUP_BAM" \
    METRICS_FILE="$METRICS_TXT" \
    TAGGING_POLICY=All \
    CREATE_INDEX=true \
    VALIDATION_STRINGENCY=SILENT

echo "Duplicate marking done."
echo "  Dedup BAM:        $DEDUP_BAM"
echo "  Metrics file:     $METRICS_TXT"

# ------------------------------------------------------------
# 2) Add / replace read groups
# ------------------------------------------------------------
echo "Running Picard AddOrReplaceReadGroups..."

picard AddOrReplaceReadGroups \
    I="$DEDUP_BAM" \
    O="$FINAL_BAM" \
    CREATE_INDEX=true \
    RGID=IP_CMV_ref \
    RGLB=lib1 \
    RGPL=illumina \
    RGPU=lane1 \
    RGSM=IP_CMV_ref \
    VALIDATION_STRINGENCY=SILENT

echo "Read groups added."
echo "Final BAM for QC + variant calling: $FINAL_BAM"

# Optional: quick samtools flagstat for sanity check
if command -v samtools >/dev/null 2>&1; then
    echo "Running samtools flagstat on final BAM..."
    samtools flagstat "$FINAL_BAM" > "$FINAL_BAM.flagstat.txt"
    echo "Flagstat written to: $FINAL_BAM.flagstat.txt"
fi
