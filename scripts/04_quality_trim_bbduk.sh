#!/usr/bin/env bash
# ------------------------------------------------------------
# 04_quality_trim_bbduk.sh
#
# PURPOSE:
#   Perform quality trimming and filtering on reads.
#
# WHY THIS MATTERS:
#   Low-quality bases lead to misassemblies and false variants.
#
# KEY PARAMETERS:
#   qtrim=lr      : trim low-quality bases from both ends
#   trimq=22      : quality threshold (Phred <22 trimmed)
#   maxlength=21  : drop extremely short reads
#   maq=10        : require average quality >=10
#   maxns=5       : allow max 5 ambiguous bases
# ------------------------------------------------------------

set -euo pipefail

IN_DIR="results/qc/no_contaminants"
OUT_DIR="results/qc/quality"
mkdir -p "$OUT_DIR"

bbduk.sh \
  threads=8 \
  in="$IN_DIR"/infected_nocontaminants_R#.fastq.gz \
  out="$OUT_DIR"/infected_clean_R#.fastq.gz \
  qtrim=lr trimq=22 minlength=21 maq=10 maxns=5 \
  stats="$OUT_DIR"/quality_filter_stats.txt

echo "Quality trimming completed. Output saved to $OUT_DIR"
