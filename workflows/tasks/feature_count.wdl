version 1.0

task feature_count {
    input {
        Array[File] sorted_bams
        Array[String] sample_names
        File annotated_reference
    }

    command <<<
        mkdir feature_counts
        for bam in ${sorted_bams[@]}
        do
            name=$(basename $bam _sorted.bam)
            featureCounts -a ${annotated_reference} -o feature_counts/"${name}_counts.txt" $bam
        done
    >>>

    output {
        File count_files = glob("feature_counts/*_counts.txt")
    }

    runtime {
        docker: "pegi3s/feature-counts"
        memory: "16 GB"
        cpu: "4"
    }
}