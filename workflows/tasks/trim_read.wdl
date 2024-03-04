version 1.0

task trim_read {

    input {
        File read1
        File read2
        String file_label
        Int? trimmomatic_minlen = 75
        Int? trimmomatic_window_size=4
        Int? trimmomatic_quality_trim_score=30
    }
    command <<<
    # date and version control
        date | tee DATE
        trimmomatic -version > VERSION && sed -i -e 's/^/Trimmomatic /' VERSION

    trimmomatic PE \
        ~{read1} ~{read2} \
        -baseout ~{file_label}.fastq.gz \
        SLIDINGWINDOW:~{trimmomatic_window_size}:~{trimmomatic_quality_trim_score} \
        MINLEN:~{trimmomatic_minlen} &> ~{file_label}.trim.stats.txt

    >>>

    output {
        File read1_trimmed = "~{file_label}_1P.fastq.gz"
        File read2_trimmed = "~{file_label}_2P.fastq.gz"
        File trimmomatic_stats = "~{file_label}.trim.stats.txt"
    }

    runtime {
        docker: "staphb/trimmomatic"
        memory: "32G"
        disks: "local-disk 40 HDD"
    }
}