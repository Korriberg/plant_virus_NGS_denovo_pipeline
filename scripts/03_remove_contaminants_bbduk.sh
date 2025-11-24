#!/usr/bin/env bash
# ------------------------------------------------------------
# 03_remove_contaminants_bbduk.sh
#
# PURPOSE:
#   Remove PhiX and sequencing artifacts using bbduk.
#
# WHY DO THIS?
#   PhiX is spiked into many sequencing libraries and can create
#   misleading contigs during de novo assembly.
#
# KEY PARAMETERS:
#   k=31      : match exact long k-mers
#   hdist=1   : allow 1 mismatch
# ------------------------------------------------------------

set -euo pipefail

IN_DIR="results/qc/trim_adapters"
OUT_DIR="results/qc/no_contaminants"
mkdir -p "$OUT_DIR"

bbduk.sh \
  threads=8 \
  in="$IN_DIR"/infected_noadapters_R#.fastq.gz \
  out="$OUT_DIR"/infected_nocontaminants_R#.fastq.gz \
  ref=resources/sequencing_artifacts.fa.gz,resources/phix174_ill.ref.fa.gz \
  k=31 hdist=1 \
  stats="$OUT_DIR"/contaminant_removal_stats.txt

echo "Contaminant removal completed. Output saved to $OUT_DIR"
