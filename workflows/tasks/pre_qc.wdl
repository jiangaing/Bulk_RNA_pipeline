version 1.0

task pre_qc {
    
    input {
        File read1_raw
        File read2_raw
        String file_label
    }  
    command <<<
        fastqc -o . ~{read1_raw} 
        fastqc -o . ~{read2_raw}
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