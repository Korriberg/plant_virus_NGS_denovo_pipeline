#!/usr/bin/env bash
# ------------------------------------------------------------
# 11_snpeff_annotation.sh
#
# PURPOSE:
#   Annotate variants called on the Cucumber mosaic virus (CMV)
#   reference using SnpEff and generate an HTML summary report.
#
# ORIGINAL ANALYSIS (ADAPTED):
#   snpEff ann Cucumber_Mosaic_Virus IP_CMV_ref.vcf > IP_CMV_ann.vcf
#
# HERE:
#   - We annotate the *filtered* VCF from step 10:
#       results/variants/IP_CMV_ref_filtered.vcf
#   - We use a pre-built SnpEff database named:
#       Cucumber_Mosaic_Virus
#   - We also generate an HTML stats file similar to the
#     snpEff_summary.html from the course project.
#
# REQUIREMENTS:
#   - SnpEff installed and on PATH as `snpEff`
#   - A SnpEff database called "Cucumber_Mosaic_Virus" already built
#     (e.g. using CMV_ref.fasta and its GFF annotation).
#
# USAGE:
#   bash scripts/11_snpeff_annotation.sh
# ------------------------------------------------------------

set -euo pipefail

# Name of the SnpEff database (edit if you used a different name)
SNPEFF_DB="Cucumber_Mosaic_Virus"

# Input VCF (from step 10: FreeBayes + vcffilter)
IN_VCF="results/variants/IP_CMV_ref_filtered.vcf"

# Output directory for annotated VCF + SnpEff reports
OUT_DIR="results/variants/snpeff"
mkdir -p "$OUT_DIR"

# Annotated VCF and HTML summary paths
OUT_VCF="$OUT_DIR/IP_CMV_ref_annotated.vcf"
HTML_STATS="$OUT_DIR/snpEff_summary.html"

echo "Running SnpEff annotation..."
echo "  DB     : $SNPEFF_DB"
echo "  Input  : $IN_VCF"
echo "  Output : $OUT_VCF"
echo "  HTML   : $HTML_STATS"

# If you need a custom config, set SNPEFF_CONFIG and uncomment:
# SNPEFF_CONFIG="/path/to/snpEff.config"
# snpEff -c "$SNPEFF_CONFIG" ...

# Run SnpEff with HTML summary output
snpEff \
  -v \
  -htmlStats "$HTML_STATS" \
  "$SNPEFF_DB" \
  "$IN_VCF" \
  > "$OUT_VCF"

echo "SnpEff annotation completed."
echo "Annotated VCF : $OUT_VCF"
echo "HTML summary  : $HTML_STATS"
echo "You can open the HTML file in a browser to inspect impacts, functional classes, and variant distribution."
