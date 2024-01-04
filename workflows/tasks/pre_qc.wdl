version 1.0

task QC {
    
    input {
         raw_fastq
        String file_label
    }  
    command <<<
        fastqc -o . ~{raw_fastq} 
    >>>

    output {
        File qc_report = file_label + "_fastqc.html"
        File qc_report_zip = file_label + "_fastqc.zip"
    }
    
    runtime {
        docker: "staphb/fastqc"
        memory: "64G"
        disks: "local-disk 40 HDD"
    }
}