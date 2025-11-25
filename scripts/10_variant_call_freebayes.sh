#!/usr/bin/env bash
# ------------------------------------------------------------
# 10_variant_call_freebayes.sh
#
# PURPOSE:
#   Call variants on the CMV-aligned reads using FreeBayes and
#   filter them with vcffilter to retain high-confidence sites.
#
# ORIGINAL ANALYSIS (COURSE PROJECT, ADAPTED):
#   freebayes -f mapping/CMV_ref.fasta mapping/dedup_IP_CMV_ref_bbmap_global.bam > IP_CMV_ref.vcf
#   vcffilter -f 'QUAL / AO > 10' IP_CMV_ref.vcf
#
# HERE:
#   - We use the final deduplicated BAM with read groups:
#       results/mapping/dedup_IP_CMV_ref_RG.bam
#   - We use the CMV reference FASTA:
#       resources/CMV_ref.fasta
#
# NOTES:
#   - For viral genomes, ploidy is effectively 1, so you may
#     optionally add:  --ploidy 1
# ------------------------------------------------------------

set -euo pipefail

# Reference genome (same as used for Bowtie2 index)
REF_FA="resources/CMV_ref.fasta"

# Final BAM from step 09 (deduplicated + RG)
BAM_IN="results/mapping/dedup_IP_CMV_ref_RG.bam"

# Output directory for variant calls
OUT_DIR="results/variants"
mkdir -p "$OUT_DIR"

# Raw and filtered VCF paths
RAW_VCF="$OUT_DIR/IP_CMV_ref_raw.vcf"
FILT_VCF="$OUT_DIR/IP_CMV_ref_filtered.vcf"

echo "Running FreeBayes variant calling..."
echo "  Reference : $REF_FA"
echo "  BAM input : $BAM_IN"
echo "  Raw VCF   : $RAW_VCF"

# ---------------- FreeBayes call ----------------
freebayes \
  -f "$REF_FA" \
  "$BAM_IN" \
  > "$RAW_VCF"

echo "FreeBayes finished. Raw variants written to: $RAW_VCF"

# ---------------- Filtering with vcffilter ----------------
# Filter used in the original project:
#   'QUAL / AO > 10'
# This keeps variants with good QUAL per alt observation.
echo "Filtering variants with vcffilter (QUAL / AO > 10)..."

vcffilter \
  -f 'QUAL / AO > 10' \
  "$RAW_VCF" \
  > "$FILT_VCF"

echo "Filtering complete."
echo "Filtered VCF: $FILT_VCF"

# Optional: show a quick summary
if command -v grep >/dev/null 2>&1; then
    VAR_COUNT=$(grep -vc '^#' "$FILT_VCF" || true)
    echo "Number of filtered variants: $VAR_COUNT"
fi
