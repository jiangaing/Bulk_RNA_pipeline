version 1.0

task SortBam {
    
    input {
        File bam_file
        String file_label
    }  
    command <<<
        samtools sort ~{bam_file} -o ~{file_label}_sorted.bam

    >>>

    output {
        File sorted_bam = file_label + "_sorted.bam"
    }
    
    runtime {
        docker: "pegi3s/samtools_bcftools"
        memory: "32G"
        disks: "local-disk 40 HDD"
    }
}