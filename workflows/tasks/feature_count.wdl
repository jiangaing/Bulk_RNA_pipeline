version 1.0

task feature_count {
    
    input {
        File sorted_bam
        File annotated_reference
        String file_label
    }  
    command <<<
        featureCounts -g Name -a ~{annotated_reference} -o ~{file_label}_count.txt ~{sorted_bam}
    >>>
    output {
        File count_file =  file_label + "_count.txt"
        
    }
    runtime {
        docker: "pegi3s/feature-counts"
        memory: "32G"
        disks: "local-disk 40 HDD"
    }
}