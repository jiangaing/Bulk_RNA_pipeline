version 1.0

task trim_read {
    input {
        Array[File] read1_files
        Array[File] read2_files
        Array[String] sample_names
        String adapters_path
        Int minlen = 75
    }

    command <<<
        mkdir trimmed_reads
        for i in $(seq 0 $((${#read1_files[@]} - 1)))
        do
            trimmomatic PE -threads 4 \
            ${read1_files[i]} ${read2_files[i]} \
            trimmed_reads/"${sample_names[i]}_R1_paired.fastq.gz" trimmed_reads/"${sample_names[i]}_R1_unpaired.fastq.gz" \
            trimmed_reads/"${sample_names[i]}_R2_paired.fastq.gz" trimmed_reads/"${sample_names[i]}_R2_unpaired.fastq.gz" \
            ILLUMINACLIP:${adapters_path}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:${minlen} MINLEN:${minlen}
        done
    >>>

    output {
        Array[File] r1_paired = glob("trimmed_reads/*_R1_paired.fastq.gz")
        Array[File] r2_paired = glob("trimmed_reads/*_R2_paired.fastq.gz")
    }

    runtime {
        docker: "staphb/trimmomatic"
        memory: "16 GB"
        cpu: "4"
    }
}
