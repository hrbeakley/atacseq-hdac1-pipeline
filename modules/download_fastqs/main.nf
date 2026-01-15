#!/usr/bin/env nextflow

process DOWNLOAD_FASTQS {
    container 'ghcr.io/bf528/sratools:latest'
    publishDir params.refdir, mode:'copy'

    input:
    tuple val(name), val(sra)

    output:
    tuple val(name), path('*.fastq.gz')

    script:
    """
    prefetch $sra
    fasterq-dump $sra
    gzip ${sra}*.fastq
    """
}
