version 2.0

task merge_count {
    # This concatenates the featureCounts count files into a 
    # raw count matrix.
    input {
        Array[File] count_files
        String file_label
    }

    command <<<
        concatenate_featurecounts.py -o ${output_filename} ${sep=" " count_files}
    >>>

    output {
        File count_matrix = "${file_label}"
    }

    runtime {
        docker: "docker.io/blawney/star_rnaseq:v0.0.1"
        memory: "32G"
        disks: "local-disk 40 HDD"
    }

}