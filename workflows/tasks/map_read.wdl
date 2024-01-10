version 1.0

task map_read {
    input {
        File read1
        File read2
        String file_label
        File reference_genome_map
    }
    command <<<
    # date and version control
        date | tee DATE
        echo "BWA $(bwa 2>&1 | grep Version )" | tee BWA_VERSION
        samtools --version | head -n1 | tee SAMTOOLS_VERSION

        bwa index "~{reference_genome_map}"

        # Map with BWA MEM
        echo "Running bwa mem ${reference_genome_map} ~{read1} ~{read2} | samtools sort | samtools view -F 4 -o ~{file_label}.sorted.bam "
        bwa mem \
        "${reference_genome_map}" \
        ~{read1} ~{read2} |\
        samtools sort | samtools view -F 4 -o ~{file_label}.sorted.bam

        # index BAMs
        samtools index ~{file_label}.sorted.bam
        >>>
        output {
            File sorted_bam = "${file_label}.sorted.bam"
            File sorted_bai = "${file_label}.sorted.bam.bai"
        }
        runtime {
            docker: "quay.io/staphb/ivar:1.3.1-titan"
            memory: "32G"
            disks: "local-disk 40 HDD"
        }
}