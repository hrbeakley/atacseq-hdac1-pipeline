#!/usr/bin/env nextflow

process REMOVE_MITO {

    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(bam), path(bai)

    output:
    tuple val(name), path("${name}.noMT.bam"), path("${name}.noMT.bam.bai")

    script:
    """
    # Remove mitochondrial chromosomes (handles UCSC chrM, MT, and RefSeq NC_*)
    samtools view -h ${bam} \
      | awk 'BEGIN{OFS="\\t"} /^@/ {print; next} 
             \$3 !~ /^(chrM|MT|NC_012920\\.1|NC_005089\\.1)\$/ {print}' \
      | samtools view -b -o ${name}.noMT.bam -
    
    samtools index ${name}.noMT.bam
    """
}
