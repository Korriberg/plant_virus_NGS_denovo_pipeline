#!/usr/bin/env bash
# ------------------------------------------------------------
# 02_trim_adapters_bbduk.sh
#
# PURPOSE:
#   Remove sequencing adapters using bbduk.
#
# KEY PARAMETERS:
#   ktrim=r   : trim right end of reads
#   k=21      : k-mer size to detect adapters
#   mink=11   : minimal k-mer during matching
#   hdist=2   : allow up to 2 mismatches
#   tpe/tbo   : trim both ends & trim adapters based on overlap
#
# WHY DO THIS?
#   Adapter contamination causes false k-mers, misassembly,
#   and poor mapping. Removing them improves downstream steps
#   (assembly + variant calling).
# ------------------------------------------------------------

set -euo pipefail

IN_DIR="data/raw"
OUT_DIR="results/qc/trim_adapters"
mkdir -p "$OUT_DIR"

bbduk.sh \
  threads=4 \
  in="$IN_DIR"/infected_plant_R#.fastq.gz \
  out="$OUT_DIR"/infected_noadapters_R#.fastq.gz \
  ref=resources/adapters.fa \
  ktrim=r k=21 mink=11 hdist=2 tpe tbo \
  stats="$OUT_DIR"/adapter_trimming_stats.txt

echo "Adapter trimming completed. Output saved to $OUT_DIR"
