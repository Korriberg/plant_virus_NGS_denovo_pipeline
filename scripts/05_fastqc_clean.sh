#!/usr/bin/env bash
# ------------------------------------------------------------
# 05_fastqc_clean.sh
#
# PURPOSE:
#   Run FastQC on the cleaned (preprocessed) reads to verify
#   that adapter trimming, contaminant removal and quality
#   filtering improved the data.
# ------------------------------------------------------------

set -euo pipefail

# Directory containing cleaned FASTQ files from bbduk
CLEAN_DIR="results/qc/quality"

# Output directory for FastQC reports on cleaned reads
OUT_DIR="results/qc/clean"
mkdir -p "$OUT_DIR"

# Run FastQC on all cleaned read files
fastqc \
  -o "$OUT_DIR" \
  --nogroup \
  -t 2 \
  "$CLEAN_DIR"/*clean_R?.fastq.gz

echo "FastQC on cleaned reads completed. Reports saved to $OUT_DIR"
