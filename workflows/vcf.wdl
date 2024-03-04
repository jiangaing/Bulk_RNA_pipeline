version 1.0

task SubsetVCF {
    input {
        File vcf
        String region = "chr1"  # Default region set to chromosome 1
    }
}

task QualityControl {
    input {
        File vcf
        Float minQual = 20.0  # Default minimum quality score
        Int minDepth = 10     # Default minimum depth of coverage
        Int minGQ = 30        # Default minimum genotype quality
        Float maxAF = 0.05    # Default maximum allele frequency
    }
}

task AnnotateVCF {
    input {
        File vcf
    }
}

workflow VCFProcessing {
    input {
        File vcf
        String region = "chr1"  # Default region, can be overridden
        Float minQual = 20.0    # Default minimum quality score
        Int minDepth = 10       # Default minimum depth of coverage
        Int minGQ = 30          # Default minimum genotype quality
        Float maxAF = 0.05      # Default maximum allele frequency
    }

    call SubsetVCF {
        input: vcf = vcf, region = region
    }

    call QualityControl {
        input: vcf = SubsetVCF.subsetVcf, minQual = minQual, minDepth = minDepth, minGQ = minGQ, maxAF = maxAF
    }

    call AnnotateVCF {
        input: vcf = QualityControl.qcVcf
    }

    output {
        File finalVcf = AnnotateVCF.annotatedVcf
    }
}