#!/usr/bin/env bash
# ------------------------------------------------------------
# 01_fastqc_raw.sh
#
# PURPOSE:
#   Run FastQC on raw paired-end FASTQ files to assess read
#   quality, adapter content, and overall sequencing quality.
#
# WHY `set -euo pipefail`?
#   -e  : exit immediately on any error (prevents silent failures)
#   -u  : treat unset variables as errors (prevents typos)
#   -o pipefail : fail if ANY command in a pipeline fails
#   These settings make the pipeline safe and reproducible.
# ------------------------------------------------------------

set -euo pipefail

# Directory containing raw FASTQ files (not included in repo)
RAW_DIR="data/raw"

# Output directory for FastQC reports
OUT_DIR="results/qc/raw"
mkdir -p "$OUT_DIR"

# Run FastQC on all FASTQ.gz files in RAW_DIR
fastqc \
  -o "$OUT_DIR" \
  --nogroup \
  -t 2 \
  "$RAW_DIR"/*.fastq.gz

echo "Raw FastQC completed. Reports saved to $OUT_DIR"
