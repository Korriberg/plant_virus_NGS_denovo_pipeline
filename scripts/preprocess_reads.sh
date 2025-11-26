#!/usr/bin/env bash
# ------------------------------------------------------------
# preprocess_reads.sh
#
# PURPOSE:
#   Convenience wrapper to run all preprocessing steps:
#   adapter trimming → contaminant removal → quality trimming.
# ------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/02_trim_adapters_bbduk.sh"
bash "$SCRIPT_DIR/03_remove_contaminants_bbduk.sh"
bash "$SCRIPT_DIR/04_quality_trim_bbduk.sh"

echo "All preprocessing steps completed."
