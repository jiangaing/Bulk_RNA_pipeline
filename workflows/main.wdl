version 2.0

import "./tasks/pre_qc.wdl" as Qc
import "./tasks/trim_read.wdl" as Trim
import "./tasks/map_read.wdl" as Align
import "./tasks/feature_count.wdl" as Count
import "./tasks/merge_count.wdl" as Merge

workflow main {
    String pipeline_version = "2.0"
    String container_src = "ghcr.io/jiangaing/Bulk_RNA_pipeline/container~{pipeline_version}"
    
    input {
        File raw_annotated_reference
        String prefix
        File read1_raw 
        File read2_raw
        Int? trimmomatic_minlen = 75
        Int? trimmomatic_window_size=4
        Int? trimmomatic_quality_trim_score=30
        File reference_genome
        
        Array[File] read1_raw
        Array[File] read2_raw
        Array[Pair[File, File]] fastq_pairs = zip(read1_raw, read2_raw)
    }

    parameter_meta {
        bam_file : "bam file"
        annotated_reference : "mapping reference as bed file"
        prefix : "Sample name"
    }

    scatter(item in fastq_pairs){
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
    }

    call Merge.merge_count {
        input: 
            count_files = feature_count.count_file,
            file_label = prefix
    }

    output {
        Array[File] qc_report = pre_qc.qc_report
        Array[File] qc_report_zip = pre_qc.qc_report_zip
        Array[File] read1_trimmed = trim_read.read1_trimmed
        Array[File] read2_trimmed = trim_read.read2_trimmed
        Array[File] trimmomatic_stats = trim_read.trimmomatic_stats
        Array[File] sorted_bam = map_read.sorted_bam
        Array[File] sorted_bai = map_read.sorted_bai
        Array[File] count_file_raw = feature_count.count_file
        File count_matrix = merge_count.count_matrix
    }

    meta {
        description: "A WDL-based workflow for analyzing bulk RNA-seq data"
        author: "Chang"
        email: "jiang.chang@well.ox.ac.uk"
    }

}