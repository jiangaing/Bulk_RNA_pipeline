# Bulk_RNA_pipeline
[![Open](https://img.shields.io/badge/Open-Dockstore-blue)](https://dockstore.org/my-workflows/github.com/jiangaing/Bulk_RNA_pipeline:main?tab=info)

> [!TIP]
> To import the workflow into your Terra workspace, click on the above Dockstore badge, and select 'Terra' from the 'Launch with' widget on the Dockstore workflow page.


## Workflow Steps

- **PRE_QC**: Quality check of the raw sequencing reads. 
  
- **Trim**: Remove the low quality reads or sequecning adapter using `bwa

- **Align**: Mapping the post QC reads to a given reference genome using `trimmomatic`. The output is sorted bam file with index file (.bai)

- **FeatureCount**: Gene expression are called from the sorted bam file using `FeatureCount`. The output is a test file that contains reference included gene with raw count.

- **MergeCount**: Merge the individual count files as one matrix file

## Inputs
  
The main inputs to the workflow are:

- **raw_fastqc**: Input file in fastq format.
- **raw_annotated_reference**: Human reference genome .gff file (General Feature Format). The version being used is GRCh38 release110 ([source](https://ftp.ensembl.org/pub/release-110/gff3/homo_sapiens/Homo_sapiens.GRCh38.110.gff3.gz)).
- **reference_genome**: Human reference genome .fasta file. The version being used is GRCh38 release110 ([source](https://ftp.ensembl.org/pub/release-110/fasta/Homo_sapiens.GRCh38.dna_sm.toplevel.fa.gz))


## Outputs

The main output files are listed below:

- **qc_report**: Quality check report
- **trimmomatic_stats**: Trimming tool report 
- **read_trimmed**: Cleaned reads ready for mapping
- **sorted_bam**: Sorted bam file
- **sorted_bai**: Index of sorted bam
- **merge_count**:
   - `merge_count_file`: Text file containing raw gene expression count from all input samples
 

## Components

- **Tools**
  - trimmomatic
  - bwa
  - samtools
  - featureCounts

- **Containers**
  - pegi3s/samtools_bcftools
  - pegi3s/feature-counts
  - ensemblorg/ensembl-vep
  - staphb/trimmomatic
  - staphb/fastqc
  - quay.io/staphb/ivar:1.3.1-titan
 
 ## Acknowledgement

- Anand Maurya: [https://github.com/anand-imcm](https://github.com/anand-imcm)
