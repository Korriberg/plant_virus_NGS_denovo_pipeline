#!/usr/bin/env bash
# ------------------------------------------------------------
# 06_denovo_spades.sh
#
# PURPOSE:
#   Perform de novo assembly of the cleaned reads using SPAdes.
#   Multiple k-mer combinations can be tested; here we apply
#   the optimal set determined during analysis (23,53,83,123).
#
# FROM REPORT (summary):
#   - SPAdes used with --only-assembler
#   - Tested multiple k-mer sets (e.g. 25_53_73_93_111)
#   - Final k-mer choice: 23,53,83,123
#   - Assembly quality assessed using stats.sh (BBTools)
# ------------------------------------------------------------

set -euo pipefail

# Input cleaned reads
READ_DIR="results/qc/quality"
READ1="$READ_DIR/infected_clean_R1.fastq.gz"
READ2="$READ_DIR/infected_clean_R2.fastq.gz"

# Output directory
OUT_DIR="results/assembly/spades_k23_53_83_123"
mkdir -p "$OUT_DIR"

# Run SPAdes assembly
spades.py \
  -1 "$READ1" \
  -2 "$READ2" \
  --only-assembler \
  -t 8 \
  -k 23,53,83,123 \
  -o "$OUT_DIR"

echo "SPAdes assembly completed. Results in $OUT_DIR"

# Optional: calculate assembly stats (if BBTools is available)
if command -v stats.sh >/dev/null 2>&1; then
    stats.sh in="$OUT_DIR/contigs.fasta" \
             out="$OUT_DIR/assembly_stats.txt"
    echo "Assembly stats generated in $OUT_DIR/assembly_stats.txt"
else
    echo "stats.sh not found; skipping assembly stats."
fi
