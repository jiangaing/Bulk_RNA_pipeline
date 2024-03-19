version 1.0

task pre_qc {
    input {
        File read1_files
        File read2_files
        String sample_names
    }

    command <<<
        set -e
        mkdir qc_reports
        for i in $(seq 0 $((${#read1_files[@]} - 1)))
        do
            fastqc -o qc_reports "${read1_files[i]}" "${read2_files[i]}" -f fastq
            mv qc_reports/* "${sample_names[i]}_R1_fastqc.html"
            mv qc_reports/* "${sample_names[i]}_R2_fastqc.zip"
        done
    >>>

    output {
        File qc_report_htmls = glob("qc_reports/*_fastqc.html")
        File qc_report_zips = glob("qc_reports/*_fastqc.zip")
    }

    runtime {
        docker: "staphb/fastqc"
        memory: "8 GB"
        cpu: "4"
    }
}