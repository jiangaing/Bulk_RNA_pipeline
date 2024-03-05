version 1.0

import "./tasks/pre_qc.wdl" as Qc
import "./tasks/trim_read.wdl" as Trim
import "./tasks/map_read.wdl" as Align
import "./tasks/feature_count.wdl" as Count

workflow main {
    input {
        Array[File] fastq_end1_files
        Array[File] fastq_end2_files
        Array[String] sample_names
        File reference_genome
        File annotated_reference
        String adapters_path
    }

    # Quality Control (QC) with fastqc
    call Qc.pre_qc {
        input:
            read1_files = fastq_end1_files,
            read2_files = fastq_end2_files,
            sample_names = sample_names
    }

    # Read Trimming with trimmomatic
    call Trim.trim_read {
        input:
            read1_files = fastq_end1_files,
            read2_files = fastq_end2_files,
            sample_names = sample_names,
            adapters_path = adapters_path
    }

    # Read Mapping with bwa
    call Align.map_read {
        input:
            read1_files = trim_read.r1_paired,
            read2_files = trim_read.r2_paired,
            sample_names = sample_names,
            reference_genome = reference_genome
    }

    # Feature Counting with featureCounts
    call Count.feature_count {
        input:
            sorted_bams = map_read.sorted_bams,
            sample_names = sample_names,
            annotated_reference = annotated_reference
    }

    # Outputs
    output {
        Array[File] qc_report_htmls = pre_qc.qc_report_htmls
        Array[File] qc_report_zips = pre_qc.qc_report_zips
        Array[File] trimmed_reads_r1 = trim_read.r1_paired
        Array[File] trimmed_reads_r2 = trim_read.r2_paired
        Array[File] mapped_bams = map_read.sorted_bams
        Array[File] count_files = feature_count.count_files
    }
}