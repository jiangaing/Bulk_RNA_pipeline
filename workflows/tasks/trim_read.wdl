version 1.0

task QC {
    
    input {
        File raw_fastq
        String file_label
    }  
    command <<<
        trimmomatic PE  SRR_1056_1.fastq SRR_1056_2.fastq
              SRR_1056_1.trimmed.fastq SRR_1056_1un.trimmed.fastq \
              SRR_1056_2.trimmed.fastq SRR_1056_2un.trimmed.fastq \
              ILLUMINACLIP:SRR_adapters.fa SLIDINGWINDOW:4:20
    >>>

    output {
        File qc_report = file_label + "_fastqc.html"
        File qc_report_zip = file_label + "_fastqc.zip"
    }
    
    runtime {
        docker: "staphb/trimmomatic"
        memory: "64G"
        disks: "local-disk 40 HDD"
    }
}