version 1.0

task map_read {
    input {
        Array[File] read1_files
        Array[File] read2_files
        Array[String] sample_names
        File reference_genome
    }

    command <<<
        mkdir mapped_reads
        for i in $(seq 0 $((${#read1_files[@]} - 1)))
        do
            bwa mem -t 4 ${reference_genome} ${read1_files[i]} ${read2_files[i]} | \
            samtools sort -o mapped_reads/"${sample_names[i]}_sorted.bam"
            samtools index mapped_reads/"${sample_names[i]}_sorted.bam"
        done
    >>>

    output {
        Array[File] sorted_bams = glob("mapped_reads/*_sorted.bam")
    }

    runtime {
        docker: "biocontainers/bwa-samtools"
        memory: "32 GB"
        cpu: "4"
    }
}