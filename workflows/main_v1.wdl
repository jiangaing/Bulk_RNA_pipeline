version 1.0

import "./tasks/pre_qc.wdl" as Qc
import "./tasks/trim_read.wdl" as Trim
import "./tasks/map_read.wdl" as Align
import "./tasks/feature_count.wdl" as Count

workflow RNASeqAnalysis {  
    input {
        String prefix
        Array[File] fastq_end1_files
        Array[File] fastq_end2_files
        Int? trimmomatic_minlen = 75
        Int? trimmomatic_window_size=4
        Int? trimmomatic_quality_trim_score=30
        File reference_genome
        File raw_annotated_reference
    }

    parameter_meta {
        bam_file : "bam file"
        annotated_reference : "mapping reference as bed file"
        prefix : "Sample name"
    }

    call Qc.pre_qc {
        input: 
            read1 = read1_raw,
            read2 = read2_raw,
            file_label = prefix
    }

    call Trim.trim_read {
        input: 
            read1 = read1_raw,
            read2 = read2_raw,
            file_label = prefix,
            trimmomatic_minlen = trimmomatic_minlen,
            trimmomatic_window_size = trimmomatic_window_size,
            trimmomatic_quality_trim_score = trimmomatic_quality_trim_score,
    }

    call Align.map_read {
        input: 
            read1 = trim_read.read1_trimmed,
            read2 = trim_read.read2_trimmed,
            file_label = prefix,
            reference_genome_map = reference_genome
    }

    call Count.feature_count {
        input:  
            sorted_bam = map_read.sorted_bam,
            annotated_reference = raw_annotated_reference, 
            file_label = prefix
    }
    output {
        File qc_report = pre_qc.qc_report
        File qc_report_zip = pre_qc.qc_report_zip
        File read1_trimmed = trim_read.read1_trimmed
        File read2_trimmed = trim_read.read2_trimmed
        File trimmomatic_stats = trim_read.trimmomatic_stats
        File sorted_bam = map_read.sorted_bam
        File sorted_bai = map_read.sorted_bai
        File count_file_raw = feature_count.count_file
    }

    meta {
        description: "A WDL-based workflow for analyzing bulk RNA-seq data"
        author: "Chang"
        email: "jiang.chang@well.ox.ac.uk"
    }

}