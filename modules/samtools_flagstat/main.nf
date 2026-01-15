#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(bam)

    output:
    path("${name}_flagstat.txt")

    shell:
    """ 
    samtools flagstat $bam > ${name}_flagstat.txt
    """

    stub:
    """
    touch ${name}_flagstat.txt
    """
}