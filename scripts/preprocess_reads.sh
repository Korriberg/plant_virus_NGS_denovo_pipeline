#!/usr/bin/env bash
# ------------------------------------------------------------
# 00_preprocess_reads.sh
#
# PURPOSE:
#   Convenience wrapper to run all preprocessing steps:
#   adapter trimming → contaminant removal → quality trimming.
# ------------------------------------------------------------

set -euo pipefail

bash scripts/02_trim_adapters_bbduk.sh
bash scripts/03_remove_contaminants_bbduk.sh
bash scripts/04_quality_trim_bbduk.sh

echo "All preprocessing steps completed."
