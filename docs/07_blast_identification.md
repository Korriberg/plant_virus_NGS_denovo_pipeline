# BLAST-based virus identification

After assembling the cleaned reads with SPAdes (k-mers 23,53,83,123), the resulting `contigs.fasta` file was compared against public databases using BLAST. The goal was to determine which viral genomes were present in the infected plant sample.

## Initial BLAST results
A BLAST search of the SPAdes contigs revealed strong matches to *Cucumis × hytivus* when searching against broad databases. These plant-like hits suggested the presence of host material in some contigs. :contentReference[oaicite:1]{index=1}

To properly identify the viral components, the contigs were then aligned against **virus-only reference databases**.

## Viral BLAST hits
The following viral candidates were reported in BLAST results:

| Virus | Reference accession | Notes |
|-------|----------------------|-------|
| **Cucumber mosaic virus (CMV)** | GCF_000864745.1 | Strong hits; used as final reference |
| Hop mosaic virus (HMV) | GCF_000875045.1 | Detected, but later rejected (0% mapping rate) |
| Sweet potato virus C (SPVC) | GCF_000888795.1 | Detected in BLAST but rejected (0% mapping rate) |

These results suggested CMV as the primary candidate virus.

## Filtering candidates with mapping statistics
To confirm the BLAST hits, cleaned reads were mapped to each viral genome:

- **HMV:** 0.00% alignment rate  
- **SPVC:** 0.00% alignment rate  
- **CMV:** ~44% alignment rate (strong support)

Thus, HMV and SPVC were ruled out as false positives or spurious hits, while CMV was validated as the actual viral infection.

## Final identification
**Cucumber mosaic virus (CMV)** was identified as the infectious agent based on:

1. BLAST similarity of assembled contigs  
2. High-confidence mapping statistics (~44% mapped reads)  
3. Clean variant calling results supporting known CMV genome structure  

This reference was used for the downstream steps: mapping, duplicate removal, variant calling, and annotation.

